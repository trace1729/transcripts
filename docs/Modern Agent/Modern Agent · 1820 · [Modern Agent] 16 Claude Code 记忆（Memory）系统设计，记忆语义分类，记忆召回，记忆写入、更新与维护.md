# Modern Agent · 1820 · [Modern Agent] 16 Claude Code 记忆（Memory）系统设计，记忆语义分类，记忆召回，记忆写入、更新与维护
[视频链接](https://www.bilibili.com/video/BV1ZA93BtEKW)

## 总结

- Claude Code 的 Memory 系统按语义分为四类：user（用户画像）、feedback（行为约束）、project（项目上下文）和 reference（外部信息来源），每类都有明确的定义和适用场景。
- Memory 的持久化采用文件系统方式，包含索引文件 memory.md 和按主题命名的 MD 文件，每个文件包含 front matter（name、description、type）用于召回时判断相关性。
- 写入流程由 extract memories 子 agent 在每次对话 turn 结束后执行，它会扫描已有记忆清单，决定更新旧文件还是创建新文件，并遵循类型约束和内容结构（rule、facts、why、how）。
- 召回流程通过独立的 selecting memory agent 完成，它只读取文件元数据（name、description）进行筛选，最多返回 5 个文件，且强调记忆不是当前事实，使用时必须回代码仓库验证。
- 记忆注入发生在 agent loop 的 system prompt（规则）、user message（CLAUDE.md、相关记忆、附件）等多个层级，且 memory 在 prompt 中被明确要求作为线索而非真相来源，以防止记忆幻觉。

## 大纲

1. 开场与本期主题引入 / Memory 系统的核心问题与分类框架
2. 分析线索与适用场景
3. 核心概念：manifest 声明式元数据文件
4. Auto memory 文件命名与索引结构
5. Memory 的全局分类体系
6. 四类 taxonomy 详细解析：user、feedback、project、reference
7. 按运行期用途与注入方式的分类
8. 写入与召回：auto memory 落盘与提取流程
9. 召回 prompt 设计：selecting memory agent
10. 注入与维护：policy、上下文组装及 extract subagent

## 正文

### 1. 开场与本期主题引入 / Memory 系统的核心问题与分类框架

好亲爱的朋友们，大家中午好。今天我们继续回到MODERA型坦克系列哈，这期我们继续探索coding与电子。然后本来我其实不是很想讲这个clady code或者codex了哈，但是最近这个clady code的发布啊，源码的一个泄露哈，再加上那个我对这个memory哈，一直很好奇关于memory的设计和实现啊。但有这一次clad code源码的一个泄漏哈，我们来可以去详细的分析collect code如何去设计和实现它的memory的一个system。就我比较关心的几个话题哈，第一memory的分类，它按它比如按这期我们重点讲的就是text and non Taxonomy，就是所谓的这个autumn memory哈，它的一个按语义的一个分类哈，User feedback，project reference这四类哈。好这第一类哈，就memory的一个语义的一个分类。

第二部分就是它是怎么去落盘，就所谓的本地持久化以及更新和维护啊，就对应的也是写入，它是按这些语义的分类去写入这个所谓的autumn memory自动的一个memory。然后第三，他在A键的路loop里面怎么加载和注入，那这里面就体现了一个召回，他是怎么去从这个memory这些MD文件里边去召回最相关的memory，以及它对应的这个while layer哈，就是我们之前分析codex的时候也在讲这个概念哈。就where layer的意思就是我要把这些memory哈，以这种请API请求的方式发送给远端的cloud的模型，就where r呢是是个网线的意思哈，就where la就是发送给远端的API请求哈，放在codex或者ChatGPT的API层面的话，它就是所谓的response点crazy那个请求体，对这里面对应着召回和加载，我们要加载到这个agent的loop里边。

然后我们要去学它对应的system的一个设计，因为很多地方哈，因为大家可以看到哈，不管是写入加载，包括进到这个aina loop的这个请求体里边，他都很多时候都是语言模型驱动的。然后这里边要涉及对应的入哈，所谓的入哈就是他应该怎么去写，怎么去加载，以什么样的角色去加载，怎么去组织管理这个具有这个memory的一个context。他很多时候因为是语言模型驱动的，他要给他去指明对应的R去避免这个memory的幻觉。in memory呢其实也类似于人的memory哈，merry的幻觉什么意思呢，就是人在记一些东西的时候，也会有记忆不清的情况，因为memory毕竟不是实时的好。

### 2. 分析线索与适用场景

我们就按照这些线索去分析哈，去看一下这个cut code是怎么去设计和实现它的memory系统的。然后大家可以看到哈，按语义分类的话，它是按这个user feedback projects reference，它其实更多的这个memory的含义呢，是一个coding project的一个memory一个设计。就如果大家去针对自己的coding呃，针针对自己的agent的系统的话，要设计一个memory哈，让这个这个agent词他有记忆哈，他对你越来越熟，对项目越来越熟，大家可以参考他这个我们这个clady code，他关于这个coding projects的一个memory的设计和实现。

### 3. 核心概念：manifest 声明式元数据文件

大家去按这个尖端的意义上就是第一是分类，针对你的系统，你的A型的这个系统去去设计，它的一个分类的一个类型系统。第二呢就是它的落盘更新和维护，以及它的召回比较核心的几大类的问题好。首先我们来看一下具体的一个事例哈，就这里边要引入一个概念啊，就是所谓的这个manifest，就声明式的一个原数据的一个文件，它是一个生命清单，它是对memory目录中已有记忆文件的一个轻量级的一个目录摘要。它不是全文内容，也不是索引文件，这个memory点MD呢它是一个索引文件。

有点像我们之前介绍cortex的时候，我们在发送第一条user query的时候，它会在之前注入相当多的一个system prompts，developed的消息。当时我们介绍这个skills的时候，他其实是在user在我们真实的user query之前，他会注入一条user消息哈，里面就会索引相关的skills名称以及它的一个description。这个memory这个MD呢也是一种索引的一个形式哈，某个文件它的主题是什么，它的简短的一个description。

对读源码的话，它是这个这个文件生成的，它会去扫描哈，我们这个根目录下这个或者这个home目录下这个点cloud文件，它关于这个projects啊，然后仓库的一个标识，然后memory这个文件，这个文件夹除memory点MD之外的其他的MD文件。除memory点MD呢它是个索引的一个文件，其他的文件呢，每个文件承载一条或一组相同主题的持久化的一个记忆。

因为他本地落盘了嘛，我们只读取前面的front matter和文件时间，抽出这些字段啊，它有点像我们去写一个skills的时候，大概是风格是类似的。它也是一个渐进式加载，另方便我们去召回相关的一个具体的一个topic的一个memory的一个MD文件。对，这就是MANUFACTS，就是声明式的一个原数据文件好。

### 4. Auto memory 文件命名与索引结构

然后就是auto memory，这相关的维护的这些files它是按主题去分类的哈，每个文件承载一条或一组相同主题的这句话记忆，它按语义主题命名，不按不是按时间命名。它是先更新已有文件，不重复创建哈，这这当然都是prompt based，它会有一个extract memories的一个agent，它是一个独立的一个agents词哈。

比如一个典型的命名，因为我们之前讲过哈，它的分类哈，他的按语义的分类，User feedback projects really reference，它后边有一个具体的一个后缀哈，比如用户的一个身份feedback，关于testing部分的project，关于呃就发布时的冻结reference，关于呃一些相关的一个参考。然后front matter呢，跟那个skills的文件差不多啊，name description type type的话就这四类哈，User feedback projects reference，四个memory type的一个语义的一个分类哈，也对应着我们对对于这个memory的一个抽象和设计。

这种这种分类呢，大家可以去套用到自己的一个A型的system里面。memory点MD呢，它就是个索引文件哈，就比如user role哈，它的user ro对MD哈，然后一个简单的描述，他是一个索引和摘要好。他的一个目录结构就是这样的，它是projects下边的一个具体的一个project的一个名字哈，然后memory好，memory点MD好，然后就是各个类别的一个命名。

### 5. Memory 的全局分类体系

它的分类呢我我下面介绍这个分类哈，它当然我们重点讲的是按语义分类哈，它这里边那个它出现的地方，我大概大概简简单概括一下哈，就是按来源和作用域分类，按内容语义分类哈，这这是我们这期的重点，然后按运行期的用途分类以及注入方式进行分类。好我们先看第一第一部分哈。

就我们在讲memory的时候，关于一个project memory的时候，其实cloud cloudy点MD啊，包括codex里边的这个A进则点MD哈，它是它也是一种项目的一个记忆哈，它更像一个指令和规则哈。在CD code里面，这CLALOUD点MD它更像是一个指令和规则，然后auto memory哈更像是长期的一个知识库，那这个team memory呢我就不不展开讲了哈，是是说人类协作的时候，在关于某个项目去协作的时候，大概一个集体的一个memory哈。

就所有的答案，每个人他的一个在这个卡迪code开头的项目里边，都会care这些team的一个memory哈。我们这期重点讲的这个auto memory哈。然后按来源和作用域呢，他所谓的这几个哈，呃manager user哈啊就大概都是这个考点点MD哈，只是它的路径不一样哈，projects local哈，还有auto memory和team memory哈。按内容语义哈，这只是我们这期的重点，就是auto memory或者tm memory哈。

### 6. 四类 taxonomy 详细解析：user、feedback、project、reference

真正的记忆文件它不是随便写的，它有强约束的四类的taxonomy，它定义在这个memory types点TS里面。好我们我们详细展开这四类哈。user user被定义为关于用户是谁的记忆，而不是项目的一个事实。写入时，模型在extraction promise里边，会被要求按这个语义类型去写。召回时它也不会出现在memory的，就是我们刚讲的生命值清单里边，就帮助相关的selector去判断user的本质，是一个个体式背层。它改变的是回答的风格，解释的力度，默认的一个协作方式。

feedback是对行为约束型的一个memory，它存的不是用户时，而是以后，而是这个A型的，以后应该怎么做。feedback不只记录正负反馈，也记录正反馈。比如哈不要mock dB是feedback，这个打包这个pr的方式对是对的，也是feedback呃。相关的就是说就memory content for feedback or project types，结构是rule和facts，以及why and how to apply lines。就这个这这条哈，写这个feedback memory的时候，也包括写这个project memory的时候，他要写rule和facts，以及为什么要写以及如何用。因为这类记忆不是静态的一个事实，而是可迁移的一个规则。如果没有Y的话，模型以后只能机械机械的套用。有了W他才知道边界条件，就为什么会有这条rule和facts。对，这就是from front matter，事例里面专门强调feedback project正文结构的一个原因。

project的话就是纯在是项目项目里，难那些不能从代码直接推出的上下文。就是你从这个项目的代码里边，是得不到这样一个rule或者facts的，就这类memory的核心是非代码可推导。就从代码文件里面是读不出来这样的约束的。比如截止日期，merge的一个冻结时期，某次重构背后的合规的原因，这个事故的业务背景。这些东西即使读完整个rapper也未必能推出。所以project并不是项目支持的大杂烩，而是代码之外的项目的现实。project往往在record阶段最有价值，因为用户问为什么要改这个，最近这个方向的约束是什么，时代码本身不足以回答。但运行时运行时代码对它的统一仍呃，对它的处理仍然是统一的扫描。front matter读description，让select判断是否相关，注入相关的内容。因为召回完了之后，就注入到这个A型的loop里面。

reference不是存事实本身，而是去存去哪找事实。它典型的内容，某个linear project是什么，然后这个看板看什么，哪个看板看什么，以及哪个select的channel存什么信息好。好我们概括起来就是说这四类哈，TAXANASTRONOMY哈，就是my class code，关于memory的一个分类，关于auto memory哈，自动更新维护的一个memory的一个分类，就是这四类哈。user他回答了问题，这个用户是谁。Fit back，我以后该怎么做这个coding。Clady code，这个cocoding agent词应该怎么做。Project，这个项目当前处在什么样的一个外部的一个语境里。reference如果要查外部信息。

应该去哪去找？然后就大家去读吧哈，就这里边就是关于这个类型的一个定义哈。Description，然后when to apply，什么时候用，How to use，纯用户的画像，不纯项目的状态，不存代码的事实，feedback呃，我就不展开讲了哈，然后projects reference。

### 7. 按运行期用途与注入方式的分类

然后按运行时的用途分有session memory memory，它是当前绘画的一个摘要的笔记，有点像codex里面的compact，有压缩服务于常规划过了，compact不是项目长期的知识库，agent memory哈，对是给ZA进的，或者是专用A型的一个持球记忆哈，也是按这个user project local scope去分目录哈，这不是不太敢讲了哈。

然后注入方式哈，呃因为这个卡拉提code，关于这个memory的分类比较多哈，就刚刚也讲过了哈，所以他有的是rule哈，有的是facts对，额如果注释方式的话，因为我们要注入到这个context里边，就是where layer哈，发送给远端的API里边，就是它会有第一哈，有这个system prom，它是规则，它不是事实哈。

就比如什么时候去获取记忆，然后在你召回相关的记忆之前，你要注意哪些事情哈，就所谓的约束哈，以及作为前置的，在我们发这个所谓的这个提示词注入哈，在我们发这个真实的query之前，他会注入的相关的文本cloud点MD哈，他为什么不直接这个cloudy点MD，为什么不直接塞进这个system problems呢，因为它更是更像是一个会谁绘画变化特效文，它不是一个稳定的规则。

还有就是作为附件生转成的这个matter user message，也是user这个message在我们uuuser query之前，只给音加载进进来的，逐入进就注入进来的呃。nested嵌套的记忆哈，相关的记忆，nested memory呢它就依然是相关的呃，这考点点MD哈，或者是一些rule哈，rules我因为我对这卡地图扣的不是不是很熟哈，我这个相关的一些呃格式化的文件，我不是很特别特别清楚哈。

然后这一部分relevant memory哈，就是我们从这个按四个，就是那个auto memory里面四大类哈，去我们基于一个召回的agents去召回出来的相关的记忆，围绕用户当前用户的问题的予以召回，这是刚刚刚介绍这个卡拉code，整体关于这个在大的这个memory概念上的一个分类哈。

### 8. 写入与召回：auto memory 落盘与提取流程

好下面就很重要的一部分就是写入和召回，写入的话就是落盘更新和维护，就我刚讲的第一类哈，就是那些clock点MD哈，他是读取和发现的一个规则，它不是主要的是自动写中目标，更多是人维护的系统读取啊，读取这个卡拉给点MD哈，这这这就不展开讲了哈，就是关于项目的一个长期的记忆哈。

auto memory哈，这是真正的我们这期的重点就是文件型知识库，他是cloud code真正的长期记忆库哈，他的目录哈，他是在这里哈，然后入口文件是memory memory点MD哈，它是索引，它不是正文，正文在对应的一个个的topic topic点MD文件里面，就是真正去召回的时候是召回的具体的我们跳过这个memory md去扫描这个某一个topic对应的front matter哈，就是那个description哈。

自动写入哈，主要有额也就是写入哈或者更新维护，它主要是extract memories这个这个这个代码文件，大家去去去去读哈，因为我对这个TTS文件这个不是很熟哈，大家可以去读，它不是组模型直接写，而是这个会话一轮这一轮会话结束之后去fork一个agent的去做总结和提取呃，因为我们之前介绍这个A镜的时候几乎记过很多次哈，这个所谓的ten的概念，就是用户有一个query哈，coding agent进入到自己的一个多轮的一个工具调用，形成最终的一个回答工具调用哈，一个单词的工具调用称之为一个stuck。

然后整个user到最终形成一个response，中间所有的工具调用加在一起，称之为一个turn。就是用户有一个query，然后assistant有个回答，这称之为一个turn。turn结束之后会fork一个agent去做总结和提取，就是所谓的extract memory agents。它先扫描已有记忆，给extract agent一个manifest，就是清单、元数据的一个清单。然后fork agent自己决定对language model base的一个extract agent，更新旧文件还是写新文件，限制权限。然后它的其他一些东西，这个我就不展开讲了。

### 9. 召回 prompt 设计：selecting memory agent

其他的我就不展开讲了，对我们介绍一些具体的prompt，就发送给远端API时，memory如何加载和注入。我们先把这个相关的文件里边的system prompt给大家介绍一下，看这里就是一个select memory system prompt。You are a selecting memory，就是召回部分，你正在选择记忆，那些will be useful to处理这个用户的请求。我就不展开讲了，我们看一下它的限制：你最多发五个文件，仅包含记忆，让你很确定它是有用的。基于它的名字、memory topic文件的名称和描述，你确定它对用户的query是重要的、有用的。如果你不确定是否有用，那就不要包含在清单里边，一定要非常非常有判别力。如果没有相关的代码文件或memory文件是有用的，你可以返回一个空的list。

对，最后一句，我们来解读一下最后一句话。就是如果当前对话里边已经在使用某个工具，我们就不要召回相关的代码memory了，因为它是重复的。怎么理解呢？如果在当前对话里边已经在使用某个工具模型，通常已经处于该工具的工作上下文了，比如工具的schema、tools、call to results也在上下文里边，当前任务本身就是驱动它使用该工具。所以你不要去召回关于这个工具的相关的文档。

然后就是memory的type，对，这就是之前说的，这只rule放在最开始的system prompt里面的，就什么时候去获取记忆，关于获取记忆的一个。然后在你召回记忆之前，对它这里边我大概简单整理一下：memory中如果提到某个具体符号，它只能被当做历史的线索，而不能被当做当前的事实。也就是说，如果memory说有一个代码文件、有一个函数、有一个flag，它并不等于他们现在还存在。这就是我对这段话的一些整理和总结。

因为memory记录的是写下这条记忆时的认知，而代码库是持久变化的，就所谓的幻觉。就像人的记忆一样，有可能是模糊不清的，这个函数或者文件、flag可能在后来被重命名了、被删除了、从来没被真正合并到当前分支，只存在于某个分支或者某次讨论里边。所以这段prompt不是在要求，是在明确要求模型：memory不是source of truth，不是真相，memory只是一个后显的线索，真正要给用户建议之前，必须回到当前代码、当前仓库中去验证。

### 10. 注入与维护：policy、上下文组装及 extract subagent

好，然后这就是真正的memory的一个extraction的一个相关的一个prompt的设计，我就不大讲了。然后就召回这类请求，应该是纯检索和排序的一个请求，不开工具捕捉执行，只做选择，比如就是我刚讲的，you are a selecting memory，对它的一个定义。它最终的结果比如选择了这样一个文件。下面就是注入这个agent的loop，整个agent的loop里边会有system prompt，就关于memory policy。就关于memory policy哈。

什么时候或或在加载你召回记忆之前，你要做哪些事情，如何去用memory。User context就是cludy点MD哈，然后就是我们之前讲的这个relevant的一个memory哈。就是我们从记忆文件里边啊，那四大类文件里边，auto memory里边去召回一个独立的一个召回类，因词召回出来的相关memory。让INA在行动时知道什么时候该信memory，知道什么时候该先验证，把merry当作行动约束和上下文，而不是当成绝对的事实库好。

那就是些具体的吧，就是我们看哈，我就不展开讲了，对。然后这是对所谓的这个在用user message之前，再插入一些关于记忆的一些内容，也是同样的，以user的一个身份。

然后更新和维护，就是也是刚刚讲的这个extraction subagents，写入更新维护是一体的。他调用时机就是每次ten的结束哈，就是user，然后多了工具调用形成最终assistant，形成最终的一个回答，把这些东西打包送给这个extraction撒倍电子。然后这个instruction suffagent呢，它会继承副会副会话的system pro，就那一大堆内容。

好这个我就不读了哈，就大家可以把相关内容从代码里边去检测出来吧。好以上就是本期的全部内容，希望就是我们这一系列关于这个口袋子的分析哈，就是我们中13期，14期，十五十六期，17期，大家可以带着这些线索这些主题哈去读，比公认的更好的一个coding1键词，clad code的源码。