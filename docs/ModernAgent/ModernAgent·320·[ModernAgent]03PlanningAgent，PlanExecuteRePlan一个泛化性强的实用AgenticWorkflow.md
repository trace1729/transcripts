# ModernAgent·320·[ModernAgent]03PlanningAgent，PlanExecuteRePlan一个泛化性强的实用AgenticWorkflow
[视频链接](https://www.bilibili.com/video/BV1qa43z5EBJ)

## 总结

- 介绍了一种名为 Plan-Execute-Replan 的通用 agentic workflow，该流程通过先制定计划（Plan）、执行步骤（Execute）并根据反馈重新规划（Replan）来分解复杂任务。
- 阐述了该 workflow 的核心逻辑：自上而下进行子目标分解以形成 to-do list，通过与环境的真实交互获取反馈，再自下而上地动态更新计划，从而在可控性和可靠性方面优于完全自主的 agent。
- 强调了在实际应用中，应根据任务复杂度进行资源配置：规划环节使用强大的推理模型（如 O 系列）决定 workflow 的上限，执行环节则使用成本更低的弱模型来提升效率。
- 通过具体的代码示例演示了如何在 LangGraph 中实现这一 workflow，详细展示了 planner、execute（基于 React agent）和 replan 三个节点的定义、状态管理以及条件循环机制。
- 作者指出该 workflow 不是 demo，而是已被应用于科研项目中，能有效提升整体 performance，并提到这属于预定义的 agentic workflow，具有可控、可靠和可预测的优点。

## 大纲

1. 开场与核心概念介绍
2. 解析Plan-Execute-Replan三步流程
3. 理解循环机制与模型分工差异
4. 规划与执行环节的模型选型策略
5. 转向代码实现前的案例铺垫
6. 定义全局状态与规划器Prompt
7. 设计重规划器与核心循环逻辑
8. 实现工作流图并演示实例
9. 总结实践要点与核心价值回顾

## 正文

### 1. 开场与核心概念介绍

亲爱的朋友们，大家中午好！今天我们继续回到Modern Agent这个系列里面，这一期我们介绍一个Planning Agents。具体来说，它就是一个Plan-Execute-Replan这样非常非常典型的、非常非常general的Agentic Workflow。它不是一个demo，我已经把它用到我的一个科研项目里面，包括我很多具体的工作场景里面，它是能够真正提升整体performance的，而且是一个非常非常general的workflow。具体来说，我把它称之为Dynamic的Plan-Soft这样一个workflow。

### 2. 解析Plan-Execute-Replan三步流程

它有三个步骤：Plan。我们这个workflow拿到用户的一个复杂的query，或者是一个复杂的task，我们先制定一个plan，先做自顶向下的一个sub-goal的分解，它的输出是一个list of steps，大家可以把它理解成一个to-do list。包括我们看到的各种各样的coding，比如EIN或者叫Cursor，它们现在都支持了Plan Mode，都是先列出来一个to-do list，然后不断边执行边更新这个to-do list。因为这种方式是非常非常有助于结构化整个workflow，结构化模型的思考，我们降低对复杂问题的具体分解，是有助于降低整个求解的复杂度的。

然后另外，我们制定好自顶向下的计划之后，然后我们就Execute，逐步去消化这里边Plan里边的每一个step，通过执行工具去执行具体的step，然后会拿到outcome，会拿到输出以及具体的feedback。我们这个step能不能执行成功，以及执行成功之后拿到了那个effects、拿到了那个事实、那个效果是什么、outcome是什么。然后基于这个outcome呢，我们再去Replan剩余的steps。

然后Replan这个过程是一个bottom-up的过程，执行了一个具体动作，拿到了反馈，然后再交给这个Plan重新去做Replan。我们可以看到哈，这样一个Plan-Execute-Replan的workflow呢，就是说如果它真正的瓶颈在于Planning的地方。具体来说，如果你这个问题比较复杂的话，非常非常考验你规划的能力的话，你第一呢，你可以在这个Planning这一块用一个比较强的reasoning model；当然了，你也可以引入Generate-Generator-Critic这样一个非常非常典型的workflow，去形成一个比较稳固的、可靠的一个Plan。

### 3. 理解循环机制与模型分工差异

那我对这个结构的一个理解呢，就是自顶向下的、我们不跟环境任何交互的子任务的一个分解，sub-goal的一个分解，形成一个具体的Plan list，可以理解成是一个planning的脑中，因为它不涉及到环境，它是想象出来的一个sub-goal的序列。然后有了这个执行之后，它就意味着和环境真实地发生了交互，和外部环境、和一些工具发生了真实的交互。基于这个真实交互，我们再Replan，得到一个新的计划，这样一个循环的过程。

我们看右上角这个过程其实很清楚：用户有一个query，我们先制定一个plan，然后去执行每一个具体的step，执行了一个具体动作之后，拿到了具体的反馈之后，我们做Replan。如果需要Replan，这里是一个条件分支；也可能随着这个循环的执行，它可以直接产生response，也可能要形成一个新的plan，然后再去cycle这个执行。

然后在long graph里面就是这样的，先有一个planner哈，我们我们这期讲到的代码示例，也就是这样一个示例哈。我们先形成一个planner哈，我们用一个planner，然后去输出一系列的子任务哈。然后这个我们用上一期我们介绍的这个reaction，这样一种方式呢去消化每一个step，因为一个step呢，肯定可能对应着多个工具的调用哈。然后走到这个reply那个节点，REPPLAN的话可能直接可以输出最终的答案，也可能要进行继续cycle这样一个执行的这样一个过程。还有我们看到这这是一个相对而言比较复杂的，一个多节点的这样一个workflow哈。

### 4. 规划与执行环节的模型选型策略

那这里边我们也也其实也可以看到哈，我们可以用小的弱的模型去做执行，我们在这个react这个模型里面，也可以定义具体的model哈。比如我们用一个弱的哈GBT4.1 NANO或者四或者mini这样的模型，然后用大的墙的模型去做planning，因为planning决定了整个workflow的一个上限。

然后具体来说最近我也看到了，包括这个地方大，我们可以一块看一下哈，就是呃open i它它这个API的这个blog，官方的这个blog里面有这样一个，就是uniing model的一个最佳实践。那这里边我们可以可以看到哈，什么时候用推理模型，什么时候用普通的非推理模型呢，他有这样的一些评论哈。就是和这个传统的GPT的模型而相比，O系列的这个推理推理模型，它只是他擅长不同的任务，需要不同的提示，就不不意味着说O系列模型就比非推理模型要更好，他们只是不同哈。就他们把这个O系列模型当成一个planner哈，这跟我们这一期讲的topic也是非常非常吻合的，他对于复杂任务可以执行更长时间，更深入的思考，从而有效地制定策略，规划，复杂问题的解决方案，并根据大量模糊信息做出决策。然后另一方面追求为了追求一个低时间，成本效益更高的一个，我们可以把我们可以用GPT的非推理模型，直接去执行，去执行具体的任务而设计。

那这部分讲完之后，我们就回到我们的代码这个地方，我们再有一些具体的一个补充吧。嗯这边有一个一个comment，就是说从这个安索贝克年初那篇非常著名的block，对A进的定义来说，我们目前显示的一个plan execute replan这样一个workflow哈，它不算是一个autonomous agents，它只能是一个agent tic的workflow。不是说这个agent的workflow就一定比这个autonomous agentes workflow一定要差，只是说完全自动化的一个A键，则是我们追求的一个终极的目标。然后agent词agent这个本身也只是一个光谱哈，然后AUTOMAGENTS词是一个终极形态。就是我们这一期的plan execute REPLAN呢是一种预定义的一个agencic workflow，它胜在他的可控可靠以及可预测。就假如说一个完全自主的一我我我，我们也可以把它变成变成一个完全的一个react的一个过程哈，就是一个纯自AUTOMOS里一个A镜的一个范式，但是他受限于这个模型的能力，他有可能表现没有那么的好。就是我们目前看到的大量的coding agents，不管是cloud code，codex还是cursor哈，它都是有一颗预定义的workflow的，只有一个具体的comments好。

### 5. 转向代码实现前的案例铺垫

下面我们就来看一个一个具体实际的代码哈，这个代码呢只是提供一个demo哈，大家可以完全可以把它放到自己的一个科研的场景里面。就如果你这个你这个整体的任务呢，是比较复杂的，大家完全可以用这样一个plan execute REPL这样一个workflow哈。好我们定义的我们的工具哈，就是execute的时候我们要执行的工具，我们看这样一个示例哈，就是我们定义一个，这里面就是展示一个一个普通的一个调用过程。

用ZX还是那个例子哈，就是谁是就美国公开赛的一个冠军，他去查哈啊，这个就是简简单的一个演示哈。好，下面就正式进入到我们这期的基于long graph搭建的这样一个plan execute的这样一个workflow哈。

### 6. 定义全局状态与规划器Prompt

好，我们定义状态，这个状态是全局共享的，在各个节点都可以拿到这个状态。我们有用户的输入哈，用户的问题有形成的一个planet，一个list，sub go的一个list，有过去执行的这个steps，还有形成的最终的给用户的这个response。

我们来看这个planner哈，planner的输出就是一系列的steps，就是一个to do list。我们看这个planner的一个system problems，对于一个给定的一个objective，提出一个step by step的一个plan，这个plan呢应该是涉及的是独立的子任务，就如果正确执行的话，将会导致将会达到最终的一个结果。不会do not不要产，不要增加多余的步骤，是一个精简的步骤。然后最终那个最终的一步的一个结果应该是最终的答案，要确保每一步的信息是必要的，不要跳步。大家可以看到这个system promise是非常非常general的，他是跟具体的任务无关的，一个general的一个problem，一个设计。

你看大家看到我们就用这样一个问题哈，这然后这个里边他这个这个语言模型，调用的过程是基于这个消息去维护的哈。我们看哈我们当前的澳网公开赛冠军的hometown，我们看它形成了一个steps，就是识别最近的澳网公开赛的冠军，然后确定他的家乡是非常非常合理的，一个两步骤的一个to do list或者一个plan。

### 7. 设计重规划器与核心循环逻辑

好，我们看我们这个reply的一个一个定义哈，大家待会儿要注意哈，这个replant一个输入哈，我们看这个reply一个system prompt，那这个地方和和之前的是一样的，然后只是这个地方多了几个站位哈，就是你的目标，然后你原始的plan，然后你已经执行的steps，然后说你要update your plan，你要对应的更新你的plan。如果没有更多的步骤的话，你应该re，那这个时候的话就是你要return to the user，否则的话你要fill out填充这个plan，Only add steps to the plan，That is still need to be done，不要不要返回之前的已经做过的steps，作为你的plan。这个这个reply prompter也是非常非常general的，就你有原始的问题，你有原始的plan，你有已经执行的这个steps。

下面我们来正式定义这样一个graph，这个excuse step，就是说我们去调这个工具哈，我们用reacts这个agent executor，就是我们定之前定义的critical creates，React agents，他这个地方做完之后，他是把这个词形是放在这个pass steps里面的，他是个追加的一个动作哈。然后是plan哈，就拿到这个to do list，然后reply an呢，或者是response to user哈，或者是形成一个新的plan，就什么时候停止呢，就是如果他决定要this response的话，那就停止，然后否则的话就要返回这个就是这个zx agent好。

### 8. 实现工作流图并演示实例

我们搭建这样一个workflow哈，planner节点，我看这个节点部分好，planner agent agent的话就是execute，然后reply3个节点，然后我们入口是planner，然后planner会跳到这个react react agents，然后这个agents呢会进入到REFLY，然后REFLY那个地方呢是一个条件边，一个续边是就是是否要结束，还是要继续这个execute好。我们看这个就是就是个非常非常特别。

非常非常典型的这个怎样一个graph，先进进入这个planner，形成一个to do list，然后用一个react agents去消化每里边的每一个step，然后完了之后就交给REPPLINE，Repplan，如果reply决定要结束，那就那就结束整个过程流，然后REPPLAN如果要形成了一个新的plan，我们再交给这个reaction去去进进，进行进一步的执行。

好我们还是看一个具体的事例哈，看具体的一个一个执行的过程哈，就是男子2024澳网公开赛的冠军的家乡是哪里，我们看形成的第一个第一个plan，形成的第一个to do list就识别这个冠军，然后找到他的家乡，然后然后就是返回给用户这个最终的答案。好我们看这个steps，因为我们是一个reacts，他执行了两步就识别这个冠军好，这个冠军是jennie sinner哈，然后REPPLAN的话就是叫search search，这个jennier sinner的家乡啊，这我就不不再讲了哈。

### 9. 总结实践要点与核心价值回顾

就以上就是本期的全部内容，就是我们再来回顾一下哈，就是我再再回顾一下哈，我们这期介绍的一个plan execute reply，这样一个模式呢是一个非常非常典型的，非常非常general的，而且是广泛运用的这样一个agent ticket workflow哈，我已经把它用到我的，我自己的一个科研项目里面，包括我很多的工作的一个场景里边，他是能够很大的提升这个整体的表现的。

我们再来简单回顾一下plan哈，只是做一个自上而下的一个子目标的分解，它是形成了一个to do list，然后如果你这个因为plan决定了整整体规划的，或者求解的一个上限哈，如果这个地方比较重要的话，我们不要预期它一次性可以提出一个很好的plan，你这个地方可以，要么是用一个很更强的一个模型，要么就是你你也引入这个generator critic，这样一个这样一种模式。

然后execute的话，我们就用一个reacts去消化里边，plan里边的每一个step，excuse的话，我们可以用一个弱的模型，因为我已经告诉你该怎么做了哈，你只是一步一步去做就行了，然后execute完了之后，你会形成你会拿到一个新的facts或者feedback，然后你要做新的reply replan，输入的话就是原始的用户的query哈，这个我们要求解的问题，原始的plan以及过去执行的哪些步骤。

然后他这个dynamic的这种plant cute，它有一种刚中之脑，从缸中之脑走走向了一个真实的交互，从经济的角度而言，我们可以用在planner用一个强的模型，然后在这个reacts agent里边，用一个弱的模型去做执行，这和这个呃呃open i对这个reading model和非催ing mo，非zing model的定位也是一致的。

好，以上就是本期的全部内容哈，就是感非常非常感谢大家充电哈，呃我们这两个付费的系列呢，有一个专门的一个GITHUB的一个私有的一个仓库，就是大家如果有代码需要的话，可以在后台私信我，你们的具体的一个get up id，我把大家加到这个项目里边来，好。