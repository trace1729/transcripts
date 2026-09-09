# Modern Agent · 1720 · [Modern Agent] 15 Codex 通用工具设计，subagents，apply_patch，exec_command，agentic vision
[视频链接](https://www.bilibili.com/video/BV1QUXGBXER9)

## 总结

- 本期以 codex 为例，拆解其 12 个通用工具的设计，强调 agent 开发中需要 review 和引导模型，而非将其视为黑盒。
- 核心工具 apply_patch 通过受限的领域特定语言（DSL）进行结构化文件编辑，避免模型自由改写，以提高编辑效率和上下文利用。
- execute_command 允许模型通过命令行执行脚本，兼容了类似执行代码的功能，实现了模型生成代码并运行的自驱动循环。
- subagent 系统通过隔离上下文和并发执行实现任务委派，提供 spawn、send_input、wait、close、resume 五个操作，弥补单一上下文窗口的局限。
- 工具定义在 codex 中分内部规格（internal spec）、线上传输层（wire layer）和运行时处理层（handler），其中输出 schema 不会暴露给模型，而由运行时维护。
- view_image 工具作为视觉能力的桥接，模型通过调用它请求图片，运行时将其编码为 base64 并注入上下文，使多模态输入成为可能。

## 大纲

1. 开场介绍与工具设计概览
2. 核心工具对比：apply_patch、execute_command 与 stdin
3. 通信层与 function calling 的入参无输出设计
4. 请求体实例分析：logs 文件与 API 调用细节
5. 工具定义的三层规格：内部、线上与处理层
6. apply_patch 详解：DSL 限制与语法约束
7. subagent 系统设计与触发条件
8. wait 与 subagent 的阻塞、恢复及后台通知机制
9. view_image 与多模态视觉能力的运行时实现
10. 结尾总结与配套资源说明

## 正文

### 1. 开场介绍与工具设计概览

好亲爱的朋友们，大家中午好。今天我们继续回到MODERA进的这个系列，这期我们继续探索codex。我们在过去的第12期、第13期、第15期，我们是从context engineering的角度，或者是wrong time，或者是哈利斯角度去探索codex。那这一期呢我们介绍codex里面非常非常丰富的general的一个to的一个设计。就是我最近我也经常讲的一个口头禅，就是没有魔法，千万不要把A进的当黑盒要去review，或者是guide它的这个agent delier process。当模型，尤其是当模型陷入到死胡同里边时，模型表现的不符合预期的时候，要去尝试去引导引导他。然后同时呢当我们发现这个是如果是模型能力不足的时候，可能就涉及到training，training一个agent tic的一个model。

好那这一期呢我们我们之前也介绍过，我们这个codex里面一共有12个预定义的图，这期我们就来逐个的去拆解分析它不同的to的一个设计。大概我先整体串讲一下。第一个apply patch就是编辑编辑代码文件，它是def的形式，def的形式去编辑文件，它不是重写一份文件。很很容易理解，因为毕竟节省上下文嘛，它是遵循了一定的grammar或者叫d s l domain specific language，这个我们后边展开讲。

另外一个很重要的general一个to，就是execute command。就是最近大家也经常流传这样一句话，就是bh is all you need。你要把你的应用程序变成一个命令行，可以交互的一种方式。然后当然当然那个windows或者LINUX，它提或者是Mac os提供了丰富的BH的一个命令，这些都是被模型所掌握的。就另外之前我我对这个我没有分详细的分析codex这个这个to design之前，我觉得这个excute code也是一个非常非常尖头人的图。那这样的话就模型可以自发的去生成代码脚本，然后去执行这个代码脚本。我以为哈我后来没，我后来再在这个codex这个图底下里面没有看到这个excute execute code这样一个命呃，这样一个工具，这样一个方式后来发现哈他是完全可以被这个execute command所消化的，它是兼容到execute方法里面的。也就是说它会它可以起，它可以生成一个命令去执行你生成的脚本，它本身就是一个模型的一个输出。

另然后很大的一块就是撒贝金斯这个系统。我对萨博伊金斯的一个理解就是他首先是隔离上下文，因为毕竟你如果把所有的上下文都放在一个master in的一个single的一个modern的一个context window里边的话，他有可能很容易超出它的context window。它隔离上下文之后，然后而且可以实现撒贝已经死了一个并发执行。然后最终哈因为你master a镜子里那个connect window就非常非常有限了，就会很多东西委派分派到不同的撒贝金子里边去执行之后，然后你在master aa型里边执行一次reduce啊，或者是汇总，那你就可以产生更长的一个交付交付物。

然后codex里面关于SB金色的设计大概有五个。Function，Spoiginsend input，等待阻塞，等待撒贝因某个撒b int的执行，然后关闭，然后恢复继续恢复到上下文，继续和他去send input，大概这五个哈。我我整理个图，后边我们看notebook的时候会详细展开。其他的就是说web search gt非常擅长搜索，可能目前我看到的所有的coding a键词里边，GBT是最擅长搜索。还有这个view image视觉的输入，去process视觉的输入，放到context里面，它对应着模型的一个aztec vision的能力。

就是我最近在动态里边经常讲我那个YouTube render PDF的话，它是非常非常依赖它的视觉的能力，以及asic vision的能力，还有其他的一些，比如持续的向一个命令行里面去写命令，update plan，请求用户的输入，这就不展开讲了。

### 2. 核心工具对比：apply_patch、execute_command 与 stdin

好，我相信我们介绍完了它里边非常非常general的最小必要的这12个tool之后，加上之前我们对context engineering的一个分析，我觉得大家去理解各种各样的code agent会有一个比较深入直观的认知。这样的话，我们去把这个agent拆开黑盒的时候，我们就可以去review、去get它的一个内部的处理过程。好，回到我们这个notebook，就是我们这一期呢就是来分析它的general的tool design，以codex为例。我们去理解agent runtime，理解harness，以及所谓的底层的模型。哪些是底层模型能力所具有的，哪些是在runtime去维护的，或者是harness，然后它的subagent的design，简介一下。

apply page就是把该改的代码，编辑代码文件变成一个受限的grammar的DSL，domain specific language。它是一个def，它不是重写和覆盖runrise。在这个标准输入里边去持续的写，就和一个正在运行的程序继续对话，即发送输入，获取增量的一个输出。比如驱动REPL，比如Python的环境或者是交互式的CLI，Python的node mexico GDP等等。execute command呢更像是一次性的调用。就这个地方是对比writestdin和这个execute command。execute command是一次性的调用，启动跑一段获得输出。当然，就像我刚说的，它去执行一个model generated code片段的时候，它也是在这个execute command里面去消化的。举例，它就可以产生这样一个代码片段，然后去执行。对我们经常会看到codex里面会写这样的代码，它就是在去调用execute command。

### 3. 通信层与 function calling 的入参无输出设计

那这边我可能要补充，在介绍后边的这个general的tool design之前，KPI分析他们之前，我可能要再补充介绍一下这个function calling。就是关于function calling呢，如果大家去看这个标准的文档的话，就这里边我想讲一个事情。就是我们再去定义这个tools的在这个通信层的schema的时候，它是只有入参的介绍，只有这个函数的描述，它是没有出参的介绍的。那这里边我留一个问题，但是我来讲。就是他spin agent的时候，agents sport agent这个函数的入参是没有agent的id或者是agent name的，但是那个模型GPT这样用模型怎么去感知，我创建了一个什么样的模型呢？我创建了一个什么样的state呢？我怎么去和他去通信和交互呢？

是因为在于这个spent的返回是带有agent的id和agent的name的，这个是codex的runtime去维护的。我执行完了这样一个sport agent的function之后，我这个runtime、我这个codex给它返回一个agent的id和agent的name，这样作为一个function call output。这样的话模型去放到这个模型的这个上下文里边，它就可以建立起来的一个agent的id、agent的name和具体的一个sport agent的一个关联。对，在call里边的tool design里边是没有关于返回值的一个介绍。然后另外，就是我们之前我们在第13期

### 4. 请求体实例分析：logs 文件与 API 调用细节

我们具体去分析它。因为那个GBT，目前大部分情况下走的是response.create这样一个API，这个请求体默认情况下是没有落盘的。GBT用这个落盘这个词，就是我们启动codex的时候，如果只加上这样一个环境变量，他是可以去落盘到这个你home目录下的这个dot n点codex这个logs-1这个skill alize这个文件里面。

我扒了一个具体的请求体，这个文件我已经放到GitHub上，大家可以去展开看一看。完整的一个请求体，有instructions，然后有input 8个消息，然后user——我实际发出的就是一个text的这样一个命令，然后对它带了12个tool，也就是这期我们要讲的execute grands，然后rise标准输入，update plan，request user input，apply patch，对这里面是有这个grammar的一个语法，一个luck的约束，然后web search，还有查看输入，准备这个输入，把这个图像变成一个base64的编码，放到这个模型文里边。

剩下的应该就是那个马里镜子里一个撒贝金子的设计，我就不展开讲。我就看一下吧，spin金子对它写的很长，然后是send input，像这个具体的agent的id里面去持续地发新的指令，恢复一个被关闭的agent，那这样的话我们可以追加上下文，去让它去进一步地探索，去或者执行等待和阻塞，等待close agent。好，这12个箭头的图，大家可以去把这个JSON文件下载下来，去看一下这个response.create的一个请求体。

### 5. 工具定义的三层规格：内部、线上与处理层

那么下面我们来分析，codex里边是怎么在GBT层面，codex层面，然后去怎么去定义，去设计这个tool的一个规格。好，这个是为什么呢？因为codex是release它的源码的，大家可以去读源码，主要是在这个spec.rs这个文件里边，它有三层，有几层定义。首先内部规格，codex自己维护的一个tool spec——SPC这样一个抽象。注意，它不是直接发给response.create一个JSON，就是刚看到的那个JSON list，那个input tool list。

我们以举例，以这个create spin agent tool为例，它是构造了这样一个内部有name、有描述、有参数入参、有output exec schema，然后这个spin agent的output schema，就是返回到这个output schema里边，就是描述这个工具理论上的一个输出结构。对，它是没有暴露在这个tool definition里边的，是发给那个请求，发给那个远端的API里边。

另外一个层就是wire definition，就是真正的发给这个response.create的tool。因为这个wire呢，是电线网线那个意思，它这个wire这个layer，它指的就是工具，你这个tool在这个网络传输中的传输的一个定义。这一层是wire layer cortex，会把内部的tool space spec通过这个create tool JSON for response API序列化成一个JSON，然后塞给这个请求体里边。

我们举例，以formation为例，它就是这五个参数。这里面有一个很重要的细节，就是内部虽然定义了output case schema，但是它不会出现在这个请求体里面。然后就是执行层，就是这一层就是runtime，当模型真正的产生了一个function calling，关于这个spring agent的一个调用之后，codex会进入到handlers里边。

解析参数、做校验合并，然后调用这个参数构造 result 执行，最后把结果组成。因为 function 的执行不可能是在远端的服务器上执行的，而是在我们本地。我们本地这个 HOTEX 执行完了之后，把这个输出打包，以这个 function call output 的方式放到这个 context 里边，放到这个消息里边，作为它的返回值。以这个 spin 为例，它的返回值就是 agent 的 id 和 nickname，就是我们在前台界面上可以看到的那个他 spin 了一个什么 agency 的那个 name，是我们这个 codex runtime 来维护的。这是关于这个口袋子里面关于这个 two spark 的一个几层的规定和约定。

### 6. apply_patch 详解：DSL 限制与语法约束

下面我们来逐个地分析。第一，apply patch，把代码改成一个受限的 DSL（Domain Specific Language）。apply patch 本身就是一个带 grammar 的自定义的 tool，就是 patch DSL。它是补丁，不是让模型直接随便地 freestyle 的方式写文件，而是让模型输出结构化的定义：添加了什么行、删除了什么行、添加了什么文件、删除什么文件，不是任意改文本，而是一个结构化的定义。强制他用这个 begin patch update file 这样的结构化的表达驱动。大家可以去读它具体的 grammar，显然大模型是可以理解这些 grammar 的，它是一个 lark 的 grammar。

说到 patch 之后，然后就是 handler。刚讲到的这个 codex handler 会去执行，它不是去立即改文件，而是先解析和验证。首先验证这个 grammar 是否正确，然后推导到底改了哪些文件、需要哪些写权限、然后额外的审批权限。为什么语言模型能理解这 grammar 呢？我们在请求里边其实也定义了，这个 lark 的 grammar 的文本，就是它要符合这个 lark grammar 的约束。然后我们这第一条消息里，整体的 instruction 里边其实也有关于 apply patch 的说明。大家可以看到，apply patch 我这里边大概拆解了几步：一定要对单个文件的编辑使用 apply patch 工具，不要用 Python 去读写文件；当一个简单的相关命令或者 apply patch 可以满足的时候，不要读或写，要通过 apply patch 的方式或 shell command 的方式去执行。

### 7. subagent 系统设计与触发条件

下面就来到这期的一个重头戏，就是 sub agent 的一个设计。我们刚看到了，大家也可以读这个 handlers 文件夹里边的 sub agents 的文件夹，它有五个具体的 function：to start society input with closest resume。那这个里边 spin 就不用说了，send input 是向已有 sub agent 的持续交互，就是给他发一个新的指令；然后 wait 是阻塞式地等待它的执行；close 是显式关闭或 down 一个 sub agent；resume 就是 sub agent 可能已经退出、结束或脱离当前活跃的内存态，但我们的 master agent 或 parents 仍希望沿着那个 thread 的上下文工作，就把它给恢复出来。然后关于这个 in name，就是里边又维护了一个 inner nicknames 的 pool，主要是历史科学家和学者，是从里边选一些没有被用过、没有被占用的名字。

这是 spin agent output schema，主要就是 agent 的 id 和那个 name，就是 spin agent 成功之后的结果。

rn time会把这个agent id和name nick name作为方式，CORE output回填到后续的上下文里边，in the name的一个决策逻辑。就是看你这个昨天看的配置文件里面有没有配配专属的nickname，如果有的话就从这个选，如果没有的话就是从这个内呃内内置的内名名额名名字池里面去选，要尽量避免当前活跃的a agent已经占用的名字哈。

首先也就是说原模型决策触发这个工具调用sport agents，然后long time执行完了之后，后续上下文出现的就是function CORE output，然后具体的int id和nickname统一进到这个模型的哈。我们master agent的上下文之后，他就知道我刚创建的这个agent，它是名id是什么，名字是什么，当然名字是给前端展示的，他整个所有的交互里边应该都是带的，传的都是id。

对我们再简单看一下啊，组agent词呃，我我看啊，组A进词先去SPNA一个子agent词，然后组A进词向这个具体的A键则区分派新的任务Send input，组A近似去等待一个或多个A阻塞式的等待一个子A键词或者多多个子A键词达到一个最终态。因为有些时候是依赖某一个SAB键词的一个具体执行的，左右键呢去close一个职业键词，然后直接进呢就下down或者close，组一进的去resume恢复或者关闭的直接禁止。对创建大概就这这几个这五个吧。

大家注意哈，这里边大家可以看到哈，子agents子又在结束的时候才会有一个输出，子agent是没有目前接口设计设计层面是没有和主A键的交互的一种模式的，都是组A进侧向子A近侧发送。好codex里边关于这个mari agents或者SUBAGENT这个system的话，它有一个很很明显的一个短板，就是它不会显示的触发，很我们很难触发他去执行这个sport agents，是为什么呢？是因为他在这个工具的定义里面，他写了一个非常非常强的一个指令，就是这个工具的description里边，只有当用户显示的要求三倍键词分派或者并发agent的执行的时候，才可才需要创建这个spring agents，它不会基于这个任务本身去sports subway键词。

但是呢我们很多时候我们第一次我们打开一个复杂的一个HOTOBASE的话，我们让这个口袋词去读这个代码的话，它基本上会spawn出来subway agines是因为什么呢？他这个同时他这个描述里边，description里边它也有另外一条指指令，就是requests for dives对，如果是是对这个HOTBS作为一个深度的全面的research或者调调查，或者一个相细致的分析，不需要用户的许可去创建substance子对，有两有两有两点非常非常强的一个指令。所以就是说如果我们想去试一试codex的一个撒B音色的一个一个流程的话，我们可能要在这个user quest query里边想呃，具体来说你要帮我创建显示的要求，codex帮我去用撒贝心思去并发的或者分派的去完成这个复杂的任务。

### 8. wait 与 subagent 的阻塞、恢复及后台通知机制

好那下面就是这个with就weight是mari agent协议中的weight，不是一个sleep哈，他是专门等待一个或多个agent到一个final states，对他传的是一个id list，他有一个time out的一个实现，我只只能等你这么久，不能等更久了，就是如果超出这这之后我们可能要close或者干嘛的，它最长应该是一个小时哈。

就什么时候会触发这个wait agent词呢？就是你B你下一步的执行master a进行下一步的执行，必须依赖子A进的结果，目前子A进的还没有完成，我们要等待它，也就是说你现在就要看他的状态。就什么时候是不不着急去with a进程呢？就直接进程还在后台跑，而你自己还有别的事情要做。

就是他是一个主设是死的，你依赖你必须依赖这个某一个撒倍镜子的执行，所以我们要触发这个wait。Wait，Wait agent a with subagents。对它这里边这个description里面其实也秒呃，也也讲了个事情哈，就是这个DESTRUDESCRIPTION是SPN agents的一个description。你要非常非常少的去使用这个with it agents，当你需要这个，你需要立即执行这个呃，需要立即得到这个结果的时候，你才去掉这个wait agen。因为你被他这个撒贝宁的这个这个结果阻塞了，对我就不展开介介绍了，大家可以去去看一下这个具体去读一下，去通过这个JSON文件里面具体去读一下他的个一个description哈。

注意它不是sleep，而而是对这个A的状态的状态流做一个订阅，从A镜子的行为上看，他会阻塞当前的master a键词的后续推理，它更像是一个joint和await的一个操作。对如果master agent不调用with with with agent，然后这个subway完成之后也不会失联哈，他会在后台自动的把，就当它当一个sab int执行完了之后，呃，且这个sab int没有被组为进的是wait，它如果执行完了之后，它会发送一个sub agent的一个一个一个消息哈，他是以user身份哈，放到这个master agent的context里面，对他有这样一个XML的一个定义哈。

### 9. view_image 与多模态视觉能力的运行时实现

讲完了这个复杂的杂配验测之后，我们就来讲这个view image。我当时呃比较拿衣服的就是怀疑哈，因为我们这个GPT模型是一个多模态模型，它是可理论上是可以把这个图片哈编码成这个base64哈，去放到这个请求体里边的，为什么还要设计一个专门的tool呢，这是我当时很大的一个好奇哈。view image是多模态agent的能力的一个来源，当然首先你的base model必须是一个VLM model，既能接受这个agent的input，image的一个input。

为什么需要一个单独的一个tool或者function，是因为这个agent需要自主维护，看什么图片放到context里边，也就是prepare image input，必须这步必须用agent的runtime来做啊。对就是模型说我这时候要看某一个具体图片，他去调用这个view image tool，然后runtime呢就把这个图片处理成base64，放到这个这个function的output里边。好对大家可以看哈，这样这样比如这样一个请求体，他问哈这张图片里面有什么啊，对之前我们的一个做法是这样的，就是我们当时是这个东西，是人作为这个agent自己去把这个图片给解析一下，变成base64哈，然后放到这个请求体里边。

但是我们在一个coding agent system里面，大家可以看哈，就是我比如请读取这张照片，他是一个绝对路径，那这个时候呢模型产生一个function call哈，view image哈，然后codex runtime去去执行这个tool，然后把这个图像编码成base64，放到以一个这个，以这个function call output的形式放到这个一个消息，放到这个context里面啊。对这里边我还讲了这个，我还把这个tool的一个description给打印出来了哈，view哈，查看一个本地的一个图片，从这个文件系统里边，当且仅当用户给了一个完整的一个文件路径，而且这个image历史上是没有看过这个image的哈，这样的话我们可以复用吗，如果如果出现过了，我们可以复用了哈，就不需要再读了。

就是view image是codex的一个本地图像的一个桥接工具，它在tool的定义里边向模型暴露，你具有查看本地图片的能力，在runtime层负责完成路径的解析文件的读取。

最终不是返回普通文本或JSON，而是把图片作为function call output的image，image的内容注入到后续的response的create input里面。好。

### 10. 结尾总结与配套资源说明

以上就是本期的全部内容，非常非常感谢大家看到这里哈。希望这期的介绍能让大家对这个coding agent有一个深入直观的一个认知。

那个我们这个最新的这个付费系列里边是关联了匹配了一个私有的一个代码仓库，就大家有代码需求的同学一定要在后台私信我，你们具体的github的一个账户信息，我把大家邀请到这个项目里面来。我把大家邀请到这个项目里面来