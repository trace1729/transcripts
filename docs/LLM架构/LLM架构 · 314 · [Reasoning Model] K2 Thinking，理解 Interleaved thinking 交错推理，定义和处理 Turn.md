# LLM架构 · 314 · [Reasoning Model] K2 Thinking，理解 Interleaved thinking 交错推理，定义和处理 Turn
[视频链接](https://www.bilibili.com/video/BV1AMCdBqEe1)

## 总结

- 本期介绍K2 Thinking模型提出的交错推理（interleaved thinking），是LLM推理范式的重要变化，面向Agent场景的强化学习训练方式。
- 与传统O1/R1先长思考后回答不同，交错推理把思考与工具调用反复交替（think→act→observe），可跨200-300步工具调用，不需要人类参与。
- 定义关键概念：turn是user-assistant完整交互，step是turn内部的reasoning→tool call→tool result循环，推理状态仅在turn内部保持。
- 通过Chat Template定义turn：以“不含tool call的最后一条assistant消息”为分水岭，之前为history（去掉推理过程），之后为新turn（保留推理上下文）。
- 交错推理使执行过程可监督（逐步reward）、可保持规划状态（plan-verify-reflect），是端到端训练的thinking agent，区别于外部编排（如ReAct）。

## 大纲

1. 交错推理概念与背景
2. 工具调用与推理过程演示
3. turn与step的定义
4. 与其他交错推理方式的对比
5. Thinking Agent训练与规划能力
6. 从Chat Template定义turn
7. turn定义规则总结

## 正文

### 1. 交错推理概念与背景

亲爱的朋友们，好久不见哈。我们今天我们继续回到语言模型价格这个系列啊，这一期我们介绍最近比较新鲜的一篇k two哈，key to thinking这样一篇工作哈。我觉得哈他是致去年9月份啊O1zing model，今年1月份R1thinking i r e这个model以来，可能在lining model这块，我觉得比较大的一个范式的一个变化哈。他是所谓的这个interleaved raining，或者interleaved这个thinking，交错推理或者交错思考，它是面向于AGENCIC的一个use的一种全新的一种RL训练的一种方式哈，非常非常值得给大家去分享和介绍一下哈。

呃我们这一期就是着重来介绍这个inner lives raining啊。呃这个概念呢是最早呢应该是应该是05年那个是苹果出了这一篇哈，交错推理for语言模型通过强化学习。我们其实看这个图的话，其实看的比较清楚哈，经典的或传统的OE或者是R1哈，它都是在回答问题之前，在行动，最终最终的answer之前有一个漫长的一个long coo t的一个过程。然后所谓的交错思考呢，就是把这个思考回答分分解成多步啊，当然这个具体多少步是是最终训出来的。

就比如这样一个问题，呃柏林墙倒塌之后的第5年的奥斯卡最佳影片的导演是谁，他显然是需要有一个多不得思考。他左边那个这个这个就思考错了哈，他觉得是黑黑客帝国，他得到了一个黑客帝国，但其实际结果是错的哈。右边一步一步的，首先他召回了这个柏林墙导弹的年份1989，然后第5年1994，然后要指出这一这一年赢啊，这个字这个字写错了哈，就word哈，1994年的最佳影片，他说的是阿甘正传，然后然后最后去识别出来这个导演是谁，他是这个导演。

大家可以看到哈，就是有几个事情哈。第一这个他的实验会比较高，因为它long city，它首次实验会非常非常高，用户体验比较差。那这里边显然就是就第一个think answer，它是时间是比较短的，因为他只需要回答这大概第一步的思考的话，可能七八个单词哈，所以他首次时间很短。另外呢它可以比较方便的去定义犀利丢的一个reward，可以做一些过程的一个监督，这是概念上哈。那这一期呢概念上其实没那么复杂哈。

### 2. 工具调用与推理过程演示

这是这个他官方的VLOG，它可以执行哦对串行的200到300步的一个工具调用，不需要人类的参与哈。也就是说他消息list，从message list的角度我们可以看到哈，它不需要用户的参与，就是user assistant，再一次的user assistant里边assistant内部完成的，它是串行的。然后他的推理过程是一致的，可以跨越上百上百步的一个去攻击调用，去执行一个复杂的问题。也就是user假如说给给给到了一个复杂的query，它可以在一个assistant内部完成串行的，完成200到300步的一个工具调用，不需要人类的一个参与。

咳咳我们可以实验一下哈。我们把这个我们把这个问题摘出来，我们问一下这个我们问一下这个k two哈，我们选择这个thinking哈，我们就是问这个问题。大家可以感受一下他这个他这个他这个完整的一个过程，因为后边我们要介绍一个重要的概念就是这个turn的一个概念。因为大家可以看到啊，它首先执行了一次search，然后然后thinking，然后又产生了下一次的一个工具调用，然后呢他在这个thinking和在这个search和thinking之间，肯定是有一个search的一个结果，然后thinking继续接着去做进一步的思考。

他其实这个官方的这个里边，他其实我们看这个例子的时候其实也比较清楚哈，这是一个HLE的一个题目。他这里边展示的大家可以看到哈，首先ZERING，然后产生一次search search得到一个结果，继续reining，然后继续search，继续reining，继续search。

继续reining，他这样一个大概这里边做了多少步呢？我记不清了，应该20多步，最终形成一个回答。好，我们看我们这边的思考完了没？哦，他还在思考。就是这里边我其实之前执行过哈，大家可以看到哈，Search thinking，Search，search出来的结果就接着thinking，接着search，接着think，直到thinking complete。他这里边最后得到的结果是辛德勒的名单，然后导演是斯皮尔伯格。就这就这就搞不懂了哈，大家可以自己去验证一下，到底这个答案到底是什么样，跟罗老师，我觉得也太不严谨了啊，如果是新动力名单的话，这也太不严谨了。

### 3. turn与step的定义

呃我们接着来看这个概念哈。好，我们下来就来简介绍这个这样一个事情哈，就是turn her step，就是我们这里边有三个概念哈，一个是对话，一个是turn，一个是steps。就是ten的话就是user assistant，这称之为一次turn，就是用户有一个query assistance的形成，就这么个回答，再称之为一个turn。然后ASSTEPS呢就是说在一个ten内部哈，一个assistant通过不断的调工具，产生对产生工具的调用，然后得到工具的一个结果，这当然是外部给他提供的哈，然后继续reining，基于这个结果之后继续认认拧，那这样的一个就是reining to call to result，自称之为一个step，也就是在一个assistant回答用户的一个复杂query里边，它可以有非常非常多的一个steps。

然后很重要的一个事情，这期我们重点介绍一个事情，就是说他在这个assistant这这个ten里边，他的raining过程是是保持的是有状态的，是是记得之前的raining process，所以它可以实现一致性的一个最认领，这跟之前是很大的一个不同。包括他在这个这个这个哈利菲斯，他就发布这个这个model card的时候，他也一直在调整这个措辞，他最开始是把这个steps称之为turn，他后来觉得不准确哈，他还是后来是把这个steps变变成了turn，我觉得把这个turn变成了steps，我觉得是非常非常准确的。OK那这里边呃我想想啊，我觉得这个概念是比较比较清楚的。

### 4. 与其他交错推理方式的对比

我们后边我们可以看这个mini max，它他也有自己的inner live thinking，他这里边有一个表格哈，我觉得大家可以我们我们可以一块看一下哈，它是对比了三种的，就是inner live thinking，交错思考。第一种的话它只占第一次，只在assistant的第一次回答这个用户的query的时候，有一次reining process，然后to cause to result，他后面就没有这个没有这个SC过程了哈。然后第第二种呢，就是我们之前看到的O1或者R1的那种，就每次每次assistant回答用户的问题的时候，之前的jing process都是干掉的，然后一种完全体就说每次的assistant的回答都过往的那个reading process都是保持的。

就是这样去画这个图呢，我觉得不是特别特别清晰哈，反而是我我现在还比较推崇这个KIKI，kid to thinking的这种这种方式哈，就是只要assistance没有产生新的工具调用，也就是完成了对这一轮的一个回答，在一个turn内，在一个assistant的回答，这个问用户的query内部是维持这个reining的，跨ten的话是没是really really ining process，是不跨ten的，我待会还会具体讲怎么去定义一个turn。好呃，我们再接着看那个他这些blog里面，这些这些这介这些介绍哈，就是building a thinking agent，不再是一个thinking model了，是一个thinking agent。

### 5. Thinking Agent训练与规划能力

它这个inner lives thinking是面向agent tec的一个use，它可以training step by step，通过工具实现了一个一个SOTA的一个性能。它是训练出来的，端到端的交错的。它也就是说它构造了这样的coo t的数据哈，它是端到端的训练出来的，然后交错推理哈。然后娜娜BANA之前此称之为教授生成，也就之前是一个coo t，一个answer结束，然后大多模型会在一次长推力里，长推力里想完所有的步骤，然后给出答案。前面一步错了，后面就会错，就内部的过程是不可监督，不不可不可管理的哈。

然后他现在是thinking answer，是不断的CCO这样一个过程，先想一段，然后调用工具看结果，再接着讲组织循环。而且这里边我们就可以可能可能可能比较容易的去定义和计算一次reward哈。那这里面很重要的一个事情哈，大家可以看到啊，它它自然可以涌现出来一种什么样的一个思考模式呢？plan先定计划，然后是然后是执行每一步，然后呢基于结果去做verify，然后再基于这个结果去反思，再refine剩余的这个plan。

你既然有这个plan了哈，你在一个assistant turn里面有这个plan的话，那必须是有状态的，因为你有plan和refly refine，那这个过程必须是reining process，必须必须是有状态的，is capable of planning哈。这里面也在抢planning，Raining executing and adapting，跨越hundreds of steps，And tackle some of the most challenging academia按照分析的问题。在一次实例中，它可以解决一个pt t level一个数学问题，通过23次in the live reining and two course，也就是刚看到的那个HLE那个那个题目，就这道题目他应该是做了23次的in the leaves raining process啊。

他这个他这个in interleaf，你显然我们基于R1也可以过到这样一个过程，但他这是是内生的，是端端端续续去基于这个你构造的合成这样数据去训练出来的，不是经过外部编排出来的，不是react这种风格哈，他是一个thinking的一个断断端训练出来一个thinking agents好。

### 6. 从Chat Template定义turn

那下面我们就从这个chat template的角度，我们去详细的去看一下他怎么去定义一个turn，我们去我们去看这个chat template，就是看他是怎么去定义一个turn的，呃我就不其他的我就不不不不再展开讲了哈。这个是k two呃，Kimi k two，这应该是切入发的instruct版本，它是没有thinking process的。假如说我们构造这样一个zing的一个一个这样一个消息历史，大家可以看到assistant里面是有zing的一个context，也就是然后有to cos，但是我们如果用这个kimi k two insert的版本的话，他这个thinking是没有的，他这里边是没有thinking的一个一个内容的，他把这个thinking所有都干掉了。

然后我们再看这个key to thinking，那这里边大家可以看到哈，因为他那这里面就有这个大家可以看到哈，他这个thinking的一个process，他是有这其实大家可以看到这里边step，这是我构造了一个数学哈，Step 1step2，Step3，Step4，这其实就是个plan哈。然后当然我们一次攻击作用只能调用一个哈啊，当然你可以并行并行调用多个哈，然后回收出来结果，然后继续呃，基于这个结构之后，继续执行剩余的步骤，或者是调整剩余的这个plan哈，也就是说它它这个thinking process在一个turn里面。

它必须是有状态的，必须维护着之前的reasoning process，所以才能实现一致性。下面我们就来具体的china template，我就不看了，我们就来看怎么去定义一个turn。

他把最后一条没有tool call的assistant消息，也就是assistant彻底完成了上一次用户的一个query，他形成了最后的一个回答，就是这种。就是用户有一个复杂的query，然后他在reasoning产生工具调用，得到工具的结果，继续reasoning循环的一个过程，完了之后他形成最后一个回答，也就是最后一次回答，他是没有新的工具调用的。我们把这种记录视为一次turn，把它处理成一个turn。

我们看具体来，就是说我把黑色的里边assistant都变成我们基于这个最后一条没有tool call的assistant消息，之前的我们称之为history，然后之后的称之为suffix history。里面所有的这个reasoning process都干掉，然后suffix里边assistant会把reading context放在这个think里边，这个处理和这个定义是非常非常清晰的。

我们来看这样一个事情，system user assistant，他有reasoning process，有tool call，然后我们去得到工具的返回，然后工具调用，然后assistant是继续调工具，然后工具的返回，那这里边其实就有两个reasoning，那这里边有一次reasoning，那这里边有一次reasoning。大家可以看到，我我们处理完了之后，他其实是有两次reasoning的。think先调用工具A拿到基础信息，然后A的结果，然后基于A的结果，就要用调用B做补充，基本上我讲完这个我基本上就讲清楚了。

### 7. turn定义规则总结

呃大家还要注意一点哈，这个tool call的请求，他一定是挂在这个assistant上面的。最后我们这期可能最核心的一个事情，就是我们怎么去定义一个turn。在一个turn内部，我们可以去循环这样一个reasoning、tool call、tool results、reasoning、tool call、tool results这样一个过程，然后在这样一个turn内部，reasoning过程是有状态的，是维持的，因为这样的话我们可以把它给训出来一个planning adapting这样一种方式。

核心我们定义turn的一个标准，具体处理上就是说我们把这个tool call里，把这个assistant消息里面不含有tool call，这称之为一个turn的一个分水岭。之前的称之为history，最后的称之为一个新的user assistant的turn，然后之前的reasoning process都是干掉的，之后的我们是保留的，因为意味着一个新的turn的开始。好，以上就是本期的全部内容。