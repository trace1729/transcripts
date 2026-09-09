# ModernAgent·620·[AgentWorks]Gemini25Pro+Agent=IMO金牌，actorcritic，生成验证修正迭代循环
[视频链接](https://www.bilibili.com/video/BV1Aq8bz1Emj)

## 总结

- 介绍Agent Works中Gemini 2.5 Pro求解IMO 2025的workflow：generate -> verify -> correct的迭代循环，核心在于初始解的质量和验证反馈。
- 分析两个关键prompts：step1初始解生成prompt，要求严格遵守格式并诚实输出verdict和solution；step3验证prompt，定义角色为严谨阅卷人，输出final verdict和bug report。
- 解释循环细节：连续5次验证通过则接受解，连续10次未通过则放弃；验证结论（final verdict）用于分支判断，bug report用于修正。
- 提到API实现注意事项，如thinking budget未严格限制、用流式SDK解决超时问题。
- 通过实际运行日志展示迭代过程，验证循环确实有效，最终找到正确解。

## 大纲

1. Introducing Agent Workflow for IMO Problem Solving
2. Workflow Overview: Generate, Improve, and Verify
3. API Implementation and Initial Setup Considerations
4. Analysis of Initial Solution Generation Prompt (Step 1)
5. Step 2: Self-Improvement to Extend Thinking Budget
6. Detailed Breakdown of Verification Prompt (Step 3)
7. The Correction Loop: Step 5 and the Iterative Process
8. Walking Through the Finale Solution and Execution Log
9. Conclusion and Wrap-Up

## 正文

### 1. Introducing Agent Workflow for IMO Problem Solving

亲爱的朋友们，大家中午好。今天是比较激动，给大家介绍一篇本周对我而言启发和影响非常非常大的一篇工作啊，就是健美达2pro，是有能与其赢得RMO2025的一个金牌。因为他这套workflow哈是基于原生的界面，2.5pro哈，不是dem man的官方的那个TW过的一个模模型哈，它仅仅是2.5pro，就是就求解了今年六道题中的五道前五道哈，也是人类的一个静脉水平。那这一期呢我们主要关注两个点，第一它这个workflow是怎么设计的，另外就是我们要详细的分析他两个比较重要的PROMI，就是一个是产生初始解的一个promise，另外就是他very fation的一个promise。

### 2. Workflow Overview: Generate, Improve, and Verify

好，首先我们看他的这个流程哈，非常非常清晰。就是第一步呢我们基于这个一个promise，基于界面点2.50肉哈，产生一个初始器。然后第二步的话会有一个自我提升，就这里面的提升呢，就是说他是其实待会后边我们会分析的话，可step two是的存必要性是存疑的。因为他当时有个claim说，就是step1的时候，因为我们界面加入pro，它是一个thinking model，我们可以设设设置它最大的一个thinking的一个Budget，32k32768。

他他他当时他去验，他去去去完成这样一个工这样一个工作的时候，就发现step1生成step1的时候，就是你有一个arm t的原题，然后他去thinking去求解的时候，他已经把这个thinking88结的值打满了，也就是他不得不结束思考，然后生成一个仓促的生成一个解。他觉得这个地这个地方对模型不公平，所以他继续这个上下文，让他continue去生成，去完成了第二步，也就是期望我们，我们希望把他的thinking巴结的给充分的去利用，他的thinking thinking的一个能力哈，这是step two要做的事情，它是它是step two，two是共享step1的上下文的好。

那这个时候就产生了一个初始解，step1和step2负责产生一个初始的solution，然后这个solution呢就交给后边所有的这样一个过程和缓解好。step3呢对step two哈产生的这个初始解呢进行验证，验证的时候会有输会会输出啊，有没有解决问题，这个解这个解释不是好的，或者是他不够好不够好的时候，还要提供他不好好不不够好的一个依据，它的它有哪些bug，八个report review哈，看哪些过程的一个漏洞好。

有了这个step3的一个bug report review之后，然后你有step two的一个初始的一个solution，然后你再用模型去基于这个review的意见，相当于rev的意见，你去纠正这个初始的解correction，那这样的话你就拿到了一个新的一个solution，然后再交给VERFACTION去验证，然后不断的循环这个过程什么时候结束，什么时候接受，什么时候拒绝，什么时候结束呢？

就说你假如你有一个solution，你连续的五次，连续的五次VERFACTION都认为very fire或者REVER，都认为他是一个好的，没有瑕疵的一个解，那我们就接受。如果你你这个这个循环呢，你持续了十次，还是没有通过这个Wi-Fi faction的一个验证，我们就认为这个解是是是没办法求求解这个问题的。

对什么情况下，它它这里边其实有一个我觉得有一个结论，大概大概这个结论就是说你step to是，如果你step two生成的解，离真正的离能求解的，能求解问题的那个解overlap比较大的话，那你大概率经过后边的循环之后，是可以解决这个问题的。因为模型的生存能力和验证能力都非常强，他是很容易很快的就发现这个漏洞，然后补上之后最终sop这个问题的。但是如果你初始的slap two，给出来那个初始的这个解呢，离标准答案偏差比较远，或者他的求解的方向就是错的，那你后边大概率是纠正不回来的。

有这样一个大概有这样一个gm哈，OK好这是它完整的一个流程哈，好那我们就直接看代码哈。呃我这边有一些有些high的一些简单的重点哈，就是他这里边重要的事情就是生成验证修正的一个迭代循环。那这个呢这种workflow呢，我们之前介绍这个building effective a镜子的时候，其实也聊过这个事情哈，它里面有这样一个比较经典的一个workflow哈，Evaluator optimizer，就是有一个生成器，有一个验证器，验证器的话会对这个生成进行评估，接受的话就就输出，如果拒绝的话，会提供对应的feedback，这和这个流程是一样的啊。好就是连续五次验证通过求解成功，连续十次重新生成都是失败的哈，则退出成功的关键在于初始解是否跟正确解有较大的一个OLL好。

### 3. API Implementation and Initial Setup Considerations

那这一期呢我们用到的，我们可能第一次哈去聊这个前面大洲pro的API哈，这里边我可能要重点讲一个事情哈，第一thinking部分呃，其实说我们让他输出的时候，去输出他的thinking的过程，其实我们看到的thinking，它是一个summarize之后的一个结果，它不是原生的thinking的一个过程哈，这里面有一个重点哈，然后另外呢他这个角色呢就是system user model，user model哈，不是user assistant，其次呢我们呃我们最后再看吧哈，就是这里面我其实想跟大家探讨一个问题哈，就是我自己发现啊，这个singing8ket budgets，似乎控制的似乎控制的不是很严格哈，就是那个我是设置32768，但有的时候会达到3万4000多的一个token的一个长度好行。

那下面我们直接看代码，就首先坦白讲他这个代码其实呃不够好哈，但是它胜在这个他promise的比较好，然后流程也整体也比较清晰。好我们这里边很大的一个，其实我坦白讲，我没有去复现他这个AH的PY这个文件哈，因为我这个通过这种request请求和post请求去，因为他那个thinking的过程很长哈，这个也就是说你要请求的时候时间很长，我这个请求始终是失败的，后来我自己自己是改造成这样一个SDK的方式去做请求。就是个用谷歌的这个JER，这个啊这样一套SDK去做的请求，是成是能能够成功的，而且他这里边他也没有用流式的话，就是大家要注意哈，你几万的一个token的一个呃思考，或者是一个输出的话，他是非常非常耗时的，你即使说一呃一秒生成100个token，他始终还能达到一个将近10分钟的量级，这里边也就是说你这个执行的时候，大部分时间都是空的，就是你什么都看不到的，所以我最后还是用SK的方式，而且用到的他这个流式的一个输出，这样的话我们可以动态的去监控它这个过程哈，就这个GENER呃，Generates contain the stream好。

### 4. Analysis of Initial Solution Generation Prompt (Step 1)

我们还是看他这个代码里面这个流程吧，就是我们看这个main里边，它核心的就是这个agent，大家注意哈，这个外部的这个max runs，就是你要就假如说你呃，假如说这个你这个过程里边，你这一步是验证失败了，我们要重新重启这样一个流程，然后重启的流程的数量哈，就是最大的最大的一个rounds，在AH的内部是完成这样一个step1到step6哈的，一个一个一个完整的一个过客flow哈。好这边我们我们简单可以看一下哈，这个是初始in its exploration，就是初始的时候我们产生初始一个解有问题额，我们要做第一步，我们看这个P1好问题的step1的promise好，下面我们就来正式的去介绍这个step1的prompts哈，就是产生解的这个promise，我把这个他这个promise放到一个，我们去一个online拉个down去看一下，就是我们放到这里边可以看得比较清楚，它是一个标准的，非常非常标准的一个结构化清晰的一个markdown的一个文本。

我们用这个翻译工具把它给翻译一下。这里边我讲了一个几个重点哈。第一，它首先它是个标准的一个markdown的格式，包括VERIFIRE的prompts、System prompts也是。其次呢，他分了几部分哈，我们这里边也看的比较清楚。第一它有指令部分核心的指令，第二部分是输出的格式，第三部分是自我验证的一个insurrection。好，我们先来看一下。这个核心的指令就说严谨性是至关重要的，因为我们是要求解IMO的，IMO大部分都是证明题，就是最后判卷的一个依据，还是你这个逻辑的一个严谨性。

另外呢，就是要诚实对待你的结果。就这里边其实就是我们包括我们自己平常也会，让原模型去回答一些问题的时候，有些时候也是它中间其实它硬凹了一个结果。也就是说他有时候会存在一个所谓的reorder hack的一种情况，就是他其实不知道哈，但是他最终硬凹了一个结果，他就证明了，得证了哈。我们就是通过这个指令去约束他的一个幻觉，就是知之为不知，不知为不知，就是你不会的话你不要瞎编啊，就大概这个意思哈。

然后第三个这个核心指令里面，就是说要全文都要用text输出的格式的话。第一部分是总结，总结里面包含两部分。verdict就是你最终的结论，你有没有找到一个完整的解决方案，然后你方法的一个概述。然后第二部分就是用来是详细的一个解决方案。那这里边我其实想讲一个事情哈，就是用一些现代的一些AI进的开发的工具哈，比如launch long graft和。其实我们一般让它结构化输出的，但是本文的它这个代码写的是非常非常简洁的，就是基于API1些正则的一个提取，是因为这个界面25pro的一个指令，个人的能力非常非常强的。我们待会还会看他具体的一个输出，我们去看它符不符合这样的格式哈。

因为我们去搭建workflow的时候，一个环节到了一个环节，一个环节的输出作为另外一个环节的输入哈，你这个环节中间是要有一些格式化，需要一些所谓的一些标准化的一个约束哈。就是我们这里边要基于step1的或者是前两个step的一个输出去做一些分支的一个判断哈。就是如果你没有求解的话，那你没有拿到，也就是这个verdict这个地方，你如果没有拿到个solution的话，我是后边循环是没有意义的。你并没有拿到一个solution吧，后边我们怎么去改正都是没有意义的哈。这个verdict也是用来做分支判断的，如果你这个verdict是为false的话，就是你没有达到一个解的话，我们要重新重新进行step1。

### 5. Step 2: Self-Improvement to Extend Thinking Budget

然后这个详细的解决方案呢，是用来做后边的一个verification的。我们是通过正则的方式去提取这里面的相关的内容，去后续环节的一个条件判断，以及数据的一个流向。就大概意思就是这个summary里面，这个verdict是用来做后续的一个分支判断，然后详细的solution呢后续做verification。那我们接着看，我们看这个他的workflow init好。我们第一步哈，我们原始的问题基于这个step1的prompts就是生成一个解。我们拿我们去掉这个API去拿，去提取它的文本，这个文本的话就是从就是取这个candidates零的content，pass零的text好。然后OK然后我们我们要进入第二步哈。

大家可以看到哈，step2和step1是共享context的，是接着做的哈。我们看P1，我们继续追加了一个模型的一个输出，我们同时追加了一个就是step two的一个prompt。就这个prompt比较简单的，你有一个机会去改进你的结果，因为要review你的，请仔细的去review你的solution，纠正一些错误以及填充一些justification的gap，如果存在的话。你的第二轮的output should strictly。

好的，我们按照系统提示的流程来操作。首先再调一次API，提取它的response，这样我们就拿到了一个solution，这是后续所有判断的依据。接下来，我们要判断这个solution是否声称已经找到了一个完整的解答，这需要基于顶点信息来分析。这里同样使用了原始模型来做这个分支判断，检查文本中是否声明其解决方案是完整的。如果不完整，就退出这轮循环，需要重新按三步写好。

### 6. Detailed Breakdown of Verification Prompt (Step 3)

如果它声称解释是完整的，我们就进入一次验证的流程。我们会从详细的解决方案中提取具体的解题步骤，然后进行验证。现在看第二部分的介绍，我们开始正式讲解验证模块的系统提示词。大家可以看到，它同样是一个标准的格式。根据我自己的总结，它首先包含角色扮演的部分，比如你是谁，你是一位卓越的数学家，也是奥数级别的严谨阅卷人。然后还有核心的指令，以及对问题的一种分类，最后是输出格式。

我们简单看一下核心说明：你仅仅用来扮演验证者，不是服务器，不要尝试去纠正错误或填充空白，只需识别你发现的问题，并且要逐步验证整个解决方案。第二部分是关于问题的分类，比如严重错误，如果你从A大于B和C大于D就推导出A减C大于B减D，这是错误的，属于非常严重的问题。另外还有一类是gap，也就是在步骤中出现了跳跃。

最终的输出格式，首先有一个摘要，里面同样有一个结论，这也是后续分支判断的依据。在验证时，你需要给出这个解决方案是有效的，还是有瑕疵，还是没有瑕疵的结论。这对应论文中的计数机制，如果连续五次通过，就在这里判断。当结论是没有瑕疵时，我们就认为这个解决方案是完全正确的。另外，你的发现就是所谓的bug报告，需要列出发现的所有bug。最后要给出详细的验证日志。我们来看一个例子，首先是最终的结论，比如解决方案无效，因为它包含了一个关键性错误，然后具体指明错误的位置以及原因。

这就是验证提示词的完整内容。接下来我们来看，拿到前面的结果后，我们需要再构建一次请求，然后提取出验证结果。首先看正确性，这里又进行了一次校验，基于验证者的结论来判断这个解是否有效，答案用是或否来表示。我们提取出来，如果内容中包含“是”，就表示验证者认为这个解释是可以接受的。如果不行，我们就需要提取详细的错误报告，也就是从最终输出中找到详细的验证部分。这就是验证的一个过程。我们看哈这个WIFI啊

### 7. The Correction Loop: Step 5 and the Iterative Process

他这个代码写得不太好，就是bug reports，然后good verify解决，是否这个解释好的一个solution是OK了。我们去看这个流程，但这个流程其实也有点怪。首先要做第一步的initial的探索，生成一个初始解，这个solution是step2的输出。然后我们在这个INAL这个函数里边还完成了一次验证，这个verify是一个bug reports，这个good verify就是说它是一个布尔。

我们看，首先他这里边create count就加一了，这个代码逻辑有点古怪，但也是合理的。就是说如果你这个verify里面不包含叶子，也就是没有，其实是有bug的，那这个时候我们要把正确的答案清空，错误加一，然后再生成一版解。啊对，这个时候我们要基于这个solution加上一个correction的prompt，我们要完成哪一步呢？就是要完成这个correction，即Step5。拿到step5的solution，拿到step5的bug report，然后去做纠正。

我们看这个prompt，这个prompt不是很重要，就是一个纠正的，below is the bug reports，如果你同意，就是这个很简单。这里边因为我这是第一次接触这个界面，带API，你看这里边它有parts，它不叫content，叫parts。这个parts呢，我自己找钱的理解，它是用来兼容多模态的，多个模态。你有文本的模态，有图片的模态，你有PDF文件的一个模态。但这里面是两个text，我觉得我自己的理解是为了刻画顺序。

大家可以看到，这个correction prompt就是说below is a bug report，也就是这个地方，这个verify是bug report，一个具体的内容就是list of findings，你在哪个位置犯了什么错误，错误的原因是什么。好，这一步是用来做纠正的。那这样的话我们又拿到了一个新的solution，就是step5拿到一个新的solution，然后继续做，交给verify action。

好，交给verify action，这个时候我们要判断，要再做一次验证，cycle这个循环，验证bug report的内容，以及它这里面是不是一个好的，是不是这次solution是足够好的了。同样的，如果这里面包含了yes的话，我们就正确加一；如果是错误的话，如果是yes的话，正确加一。

这个时候我们要计数了，我们对这个error counts和这个create count进行计数，如果大于等于十的话，那也就是说这个解释没希望了。如果是大于等于五的话，那么就退出，就找到一个解了，也就是某个解，他连续五次都通过这个verify的验证。

我们看这个yes的循环，就是yes的话，也就说假如我举个例子，假如说这个地方这个good verify已经是yes的话，我们会走这个地方，我们再验证一次，大家可以看，然后继续验证，所以这个地方create count为一。这个逻辑有点怪，但是代码逻辑有点怪，但其实内部的逻辑是对的。我们再验证一次，如果yes的话，我们再加一，然后其他的没了，然后又再做一次验证。

### 8. Walking Through the Finale Solution and Execution Log

OK，我觉得没啥要讲的了。我们去看一下他最终求解的一个过程，他把所有的日志都打印出来了。我们看这个run，run就是他甚至说第一道题他run了一次，也就是说他在外部的一个循环只run了一次，就找到了解。我们看他这个迭代走了多少个迭代，做了八次迭代，也就是他这个编号。也就是他这个编号啊

就零八，他八次找到这个解，我们看这个过程哈。首先啊，这个所以他这个代码有点怪哈，他第一次的时候，这个number of cracks是一哈，OK好，因为他因为这次哈他是觉得有bug的哈，然后number one else就等于一等于二等于三，好第四步的时候，他找到了一个好的，是，他这个纠正之后通过了WIFI的一个验证。

number of cracks等于一开始了，然后等于二等于三，第三次通过，第四次通过，第五次通过，最后一次通过。OK我们看一下这个过程哈，就是首先初始的1proms产生第一step，一产生一个解，然后做了一次save correction，就是a seal improvement，就是save two，然后得到一个经要呃，得到一个最终的一个solution啊，不是得到一个solution，是用来交给后边的WIFOK。

我们要现证验证这个解是不是完整的，就是他有没有克里姆说他找到了一个解啊，yes好，那就开始验证哈，开始验证这验证的一个PROMI，好这是验证的一个结果啊，这个结果我就不打不出来看了哈，这是验证的一个结果。OK这个这个我们这个WIFI输出的时候，他这个final verdict，Yes or no，这边NO，也就是我们要提取它的bug reports去用来交给模型去做correction。

好呃，Bug reports，这就是第一第一次哈，然后玩，然后就开始纠错哈，在这个地方是纠错，大家可以看到哈，这是问题呃，这是这是VERIFICTION的哦，这是用来做重新生成啊，这是问题，这是模型的输出啊，这是模型的输出，Below is the bug report，这是bug report。Ok，然后又产生了一个新的解，他纠正之后产生一个新的解，然后这个新的解要进行这个这个求解的过程是完整的，他肯定没说是完整的，那我们交给WIFI去去做验证，然后OKWIF的一个结果好。

我们看哈啊，他还是说这个这个这个是没有通过这个WIFI验证的，好继续迭代哈，继续correction，然后然后Correct一个solution。OK那我们交给WIFI验证，交给WIF2去一做验证，好final的，大家可以看到这个WIFI的一个结果，The solutions approach is valuable，but那它还是有get的，OKOK好。

我们看哈，最后通过验证的，通过WIFI验证的，OK这是CRU就错了一次，Cortion，好，where法去继续去对一个新的solution去做验证啊，the solution contains还是有error，OK我们继续哈，可以纠正一个新的一个solution，然后要再做一次WIFI的一个验证，Ok the solution is correct list of foundings，No issues were found，OK好。

### 9. Conclusion and Wrap-Up

那这里边就是说，那我们就开始正式的进入加一的这个循环，开始找到一个能够打动VER法，打动VREVUE的一个解了，好额，以上就是本期的全部内容哈。