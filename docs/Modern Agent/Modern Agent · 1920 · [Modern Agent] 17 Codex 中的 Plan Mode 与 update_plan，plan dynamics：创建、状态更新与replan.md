# Modern Agent · 1920 · [Modern Agent] 17 Codex 中的 Plan Mode 与 update_plan，plan dynamics：创建、状态更新与replan
[视频链接](https://www.bilibili.com/video/BV1NdDtBjEg7)

## 总结

- Codex 中实现 Plan 有两种方式：Plan Mode（通过斜杠 /plan 切换，以对话询问方式形成 Markdown 计划）和 Update Plan（通过函数调用方式，模型自主涌现出计划行为，形成 To Do List）。
- Plan Mode 是一种协作模式，通过注入 Developer 消息约束行为，要求先探索、再澄清、最终形成完备计划，最终产物是存放在上下文窗口中的 XML 封装 Markdown 文本，不落盘到本地。
- Update Plan 是一个执行期工具，用于展示任务进度，通过参数（解释和计划列表）实现创建计划、更新步骤状态和执行 replan，所有状态变更都通过这一单一函数完成。
- 计划内部每个 Step 有 pending、in progress 和 complete 三种状态，且同一时间最多只能有一个 Step 处于 in progress 状态，实现了 step-by-step 的执行机制。
- Update Plan 通过提交完整最新计划快照、提供解释来触发 replan，体现了 Codex 工具设计的通用性和简洁性，模型只需反复调用该函数即可完成整个计划生命周期管理。

## 大纲

1. 开场回顾与本期主题引入：Codex 中 Plan 的重要性与两种实现方式
2. Plan 的两种形态辨析：协作模式与函数调用，以及计划的存放位置
3. 理解 Plan Dynamics：Update Plan 如何通过参数实现创建、更新与 replan
4. 深入 Plan Mode：触发机制、核心要求与最终产物，以及退出方式
5. 剖析 Update Plan 工具：结构、状态定义与使用场景
6. Update Plan 的设计初衷与实操演示，以及 replan 的具体实现机制
7. 总结与系列展望收尾

## 正文

### 1. 开场回顾与本期主题引入：Codex 中 Plan 的重要性与两种实现方式

好亲爱的朋友们，大家晚上晚上好。今天我们继续回到Modern Agent的这个系列里面，这一期我们继续探索Codex。我们在第17期介绍Codex的一个General的To Design哈的时候，它的最小工具及设计的时候，我们当时可能漏掉了Update Plan。包括我们这个系列里边，我们第呃第二期介绍React，第三期介绍非常非常有名的一篇工作哈，就Plan Agent，就是在执行之前先进行Plan，然后在执行过程中也可以动态的去调整这个Plan。包括很多时候大家对这个Coding Agent，很重要的一个设计哈，就是要有Plan哈，Plan Mode也包括就是Codex。大家对比Codex或者呃Clad Code的时候，其实很多时候他们都能涌现出来Plan，但就是说对于Codex而言，它可能还有前置的，有一步哈，就是密集的一个Exploration。

所以就是Codex一个非常非常完整的一个流程，是什么的呢？就我们针对一个Code Base做一个需求的一个开发，他先第一步先做代码级别的一个Code Base级别的一个Exploration，然后形成一个Plan，然后所以Execution。那这一期呢我们就来看哈，就是Codex里面是怎么去完成这个Plan。Codex里面具有做Plan的话有两种方式哈。第一种是Plan Mode，就是我们通过斜杠Plan哈，在Codex命令行里面斜杠Plan去切到这个Plan Mode里边，然后他是通过对话，通过询问的方式形成一份Markdown的一个文件哈。

### 2. Plan 的两种形态辨析：协作模式与函数调用，以及计划的存放位置

但是我我我先声明一点哈，这个Markdown文件它没有落盘到本地，它是放在对上下文里边的，它是一个文本型文本的形式，放在Context Window里边的。包括后边我们介绍Update Plan的时候，它其实也是一个Check List或者To Do To Do List，他是放在对上回里边的，他没有持久持久化或者落盘到本地。好两种哈，一种是Plan Mode，它是对应的一种协作的一种模式哈。我们之前介绍Codex的一个Context Engineering的时候，其实我们之前讲了哈，他首先会有一个Instruction，很长很长的一个Instruction，然后就是Input里面会有一个额，会有先是Develop的消息。

然后这个，我看第一条是关于这个Permission哈，一个许可，第二个就是Collaboration Mode，就如果我们不开这个Plan Mode，它默认的是一个Default Mode，开了这个Plan Mode，它会有一个完整的关于Plan Plan Mode的一个介绍，大家可以去读一读哈。对，就Plan Mode它是一种协助的模式，就是我们用户发第一个Query之前，他会植入哈一堆的Instruction和Development的消息呃，它与这个Plan Mode相搭配的一个工具叫Request User Input，它通过和用户对话的方式，去形成一个完整的一个Plan。

### 3. 理解 Plan Dynamics：Update Plan 如何通过参数实现创建、更新与 replan

Request User Input for one two，Three short questions，And wait for the response。The Tool is only available in Plan Mode。然后另外一种就是我们通过调用工具的方式，去实现这个Plan哈。但是具体来说这个Update Plan，它其实形成的是一个To Do List，然后这种Update Plan呢，它通过调用工具的方式，是一种模型自己去涌现出来的一个行为哈，不是强制的让他去进入到一个Plan Mode子。对Update Plan呢，就我们之前介绍的时候其实也讲过哈，我们看一下我们之前介绍这个Tool Scheme的时候，我们看一下这个Update Plan。

对更新当前任务计划和步骤的状态，我们待会会展开介绍这个update plan。就两种哈，就codex完成plan的话，有两种方式。第一种是plan modes，它会在plan mode结束的时候形成一个完整的markdown文件哈，但这个markdown文件它不是罗盘到本地的，它是放在context window里面的。然后另外一种就是我们如果不显示的进入到plan mode里面的话，我们可以就是也是我们日常更多大部分时间我们发出一个query，没有进到plan mode里边，模型是通过调用工具的方式去完成这个plan的创建、plan的一个update以及REPLAN。

然后这一期我们可能重点还是要理解这个plan的dynamics，尤其是在agent的loop里边的，就是这个plan的一个dynamics，所谓的创建update和replan。我们这期重点讲的这个update plan这样一个tool的话，它其实在一个tool内哈，而且是通过参数的方式，通过我们去实例化这样一个，我们去调用这个update plan的时候，我们要传参数，通过传参的方式实现plan的一个创建。然后因为plan它内部是一堆steps或者叫todo子，然后每个step或者每个todo都对应着一个状态，然后可以在这个update plan这个参里面实现对这个plan的一个状态的、每个steps状态的一个update，是pending、是executing还是完成，一共三个状态。

以及replan，就是因为这个plan是一个事先定义的，很有可能我们走到一半的时候发现这个plan不可行，那这个时候同样要触发一次replan。注意哈，那这三个dynamics，这个plan的三个dynamics，它都是通过一个update plan这样一个function call来实现的，就是传不同的update plan的参数去实现这个plan的dynamics。然后同时呢我们也可以比较深刻的去理解，codex里边这个所谓的我把它叫做一个general的tool system的一个design，他是非常非常general、非常非常unified，就一个function就可以实现对一个plan的创建、对plan每个steps状态的update以及重新的replan。

### 4. 深入 Plan Mode：触发机制、核心要求与最终产物，以及退出方式

他是一个非常非常minimal的、而且非常非常clean的一个设计，这也是我去对比理解这个cari code的时候，我发现codex在这个本身的设计层面的一个简洁性和优雅性。好，那我们分别展开来介绍这个plan mode和这个update plan。plan mode就是通过斜杠plan去切换到这个plan mode里边，他会在这个developer消息里边去植入，对，去植入这样一种，在这个developer消息的第二个part里边会植入这样非常非常长的一个文本，就关于这个plan的一个介绍哈，我就不展开讲了哈，就大家有兴趣的话可以去读一读这个完整的plan mode的一个介绍。

它核心的一点就是通过ask user question来形成最终的一个plan。对，因为我本地保存了这样一个完整的请求体啊，大家可以去读这份文件里边我保存下来的这一份请求体的文件哈，就这期我们可能会用到的这个文件。plan mode呢是一种collaboration的一种mode，他目标是聊出一个可直接实施的一个规格，它的最终产物是一个通过这个XML格式封装起来的一个markdown的文本。

大家注意哈，这里边是字符串，不是持久化到本地的一个文件。他明确的要求非变更，非变更是探索。就我们在plan mode里面是不改任何的代码的，尽量用request user input的方式去提问，直到这个plan mode的一个结束。

就我自己实实际测试下来，就是我们在通过对话的方式形成最终一个plan之后，如果形成了这样一个盘之后，他会询问这样一个问题，是否要实现这个plan。就如果你选择了一，那就会退出这个plan mode，也就是重新会替换这个这个这个，这个消息的内容啊，变成一个default的一个模式哈。

也就是说他通过一种collaboration的一种precise，就是我们刚看到了那个DEVELOPP消息，去注入了一整套的一个行，一注入一整套的行为约束，要求先探索再澄清，再形成决策完备的一个计划，并尽量通过request user input的结构化方式去提问好。我们大概大概简单介绍一下这个plan mode，那那那如果我们退出这个plan mode的话，我们拿到这样一个plan的话，我们就可以沿着这个plan去执行了好。那这是一种非常非常硬的一种模式哈。

### 5. 剖析 Update Plan 工具：结构、状态定义与使用场景

另外一种就是通过function calling的方式去实现plan的一个DYNAMIX。update plan呢是执行期的一个to do或者checklist的工具，它我们把它叫做live progress model哈，一个对当前进度状态的一个内部表示，用来给用户显示当前任务的进度哈。注意哈，这个update plan不是进入或退出plan mode的一个开关，而且你如果在plan目录里面去调用这个update plan的话，会会直接报错哈。

它这个它是一个function哈，它是一个to哈，他的scheme非常非常简单，explanation解释你为什么要有这样一个plan，然后plan是个list，然后用step和他的状态，他的状态的话三种可选的一种pending和等待哈，一种in progress执行中，一种是完成好。

我们看这个，我们看这个方式，这个two里边好，我们看到这个update plan哈，update updates the task plan哈，提供一个可选的一个解释，以及a list of planatoms，Each with a step and a steady status。最多哈，一个STEVE是IMPROGRESS状态里边我们看这个参数哈，explanation哈，然后以及plan plan呢它它是一个list，然后他step和这个就step，是这步骤要做出什么样的内容，以及这个step它对应的一个状态，他的输出没有任何的语义，业务的语义哈，然后这个function执行完了之后，返回给模型的是就是这样一个一个消息哈，Plan upse。所以去实现update plan，去实现这个plan的一个DNICS，完全是通过这个update plan的一个参数来实现的好。

### 6. Update Plan 的设计初衷与实操演示，以及 replan 的具体实现机制

然后关于这个plan哈，然后以及这个update plan这个to的一个指引哈，其实我是在呃这个文件里，这个文件里面看到的，在这个base instructions default md里面，大家可以去读哈，他关于这个plan的一个设计，以及关于这个关于这个工具的一个指引，尤其是这个update plan的一个指引对额。

但是我可能要讲一点哈，就是这里边的内容呢，其实我没有在这个真正发给远端的API请求体里面发，发现这些内容，但从语义上哈，codex设计这个update plan这样一个to的一个初衷，就是这个MD文件里边介绍的，那也要好，也就是说，其实目前这个和SGPT这个系列的模型，其实已经对这个update plan这个工具用的是非常非常成熟了，呃那那自然呢我当时看这个update plan的时候。

其实就有个问题，关于这个dynamic就是plan的一个DNICS，就是个同同一个turn name，如何更新plan。他是他不是有一个modify的这样一个function，而依然是update plan，就是再次发一个新的update plan这样一个function call哈，并附上完整的新的plan的一个快照，实现一个REPLAN。他完全是通过这个唯一的一个update plan这样一个function去实现整个plan的一个DMIX，就是所谓的创建更新以及REPL好。

我们大概简单看一下哈，就比如哈哦这个是前置的一些请求体，好我们发出了第一个query哈，假如说这个时候在一个A型的路途里边，他掉了这个function呃，掉了update plan这个function，然后它里面传这个explanation哈，传这个具体的一个planner，一个steps，然后大家状态哈就第一个会进入到，因为他最多只允许一个进到这个in progress的状态里面，所以他是啊step by step去执行的哈。他创建这个plan的时候，就第一个step就自然的就进入到这样一个执行的一个状态里边。

好那那最终哈这个A型的loop里边，他消化完了所有的step，然后所有的step大概都进入到这个完成的状态里边，然后这个A键的loop这个turn哈，这个turn内部的一个A键的loop也完成了。好，我们最后再再简单整理一下，这个所谓的DNICS，也就是有时哈你需要去在这个任务执行过程中去改变这个plan哈，因为plan毕竟是一个事先设计好的，他是一个缸中之脑，他没有想到执行中的一个可能存在的一些问题，但执行在按step去执行这个plan的时候，他可能遇到这条路不通，你要去update整个plan。

那这个时候呢你就去调这个update plan，使用你更新之后的一个plan，以及你要尽可能多的去提供这个解释，为什么要这样去update plan。也就是在整个to哈run这个运行时，这一层update plan并没有create和update这两个不同的API，他语义上依然是提交当前计划的一个快照，或者是update这个状态，或者是reply那个状态。第一次执行，第一次调这个update plan的时候，会将第一个step置为IMPROGRESS，而且他完全可以更新整个plan，不只是改某一个step的一个状态。

### 7. 总结与系列展望收尾

好，以上就是本期的全部内容吧，就是带着大家去简单的去认识一下这个plan mode，以及update plan。也就是随着这个模型能力足够强之后，我们就是设计实现对应的一个instructions，或者是有这样一个监督的一个update plan哈，它的参数是解释和这个具体的steps，然后我们反复的通过update plan去更新这个steps的状态，甚至是可以追他，都是在一个GPT5.4这样一个模型内部，可以非常非常丝滑的去完成好。

这应该是我们最后一期哈，去介绍这个cortex或者cloud code，除非有特别大的意外哈，比如有一个重大的一个底层的一个架构的设计，或者是某一种概念的一个原理的一个引入哈，我们就暂时的把这个codex和clad code告一段落哈。