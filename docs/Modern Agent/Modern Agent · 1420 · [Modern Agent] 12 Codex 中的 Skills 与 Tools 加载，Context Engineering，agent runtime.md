# Modern Agent · 1420 · [Modern Agent] 12 Codex 中的 Skills 与 Tools 加载，Context Engineering，agent runtime
[视频链接](https://www.bilibili.com/video/BV1bSwpzNEWE)

## 总结

- Modern AI agent（如 Codex、OpenCloud）的核心是 context engineering，通过注入 system、developer、user 消息来管理上下文。
- Agent runtime 负责维护消息列表和执行循环（agent loop），包括提示词注入、模型推理、工具调用和结果持久化。
- Skills 以摘要形式出现在 user 消息的 content 中，而 MCP 或内置 tools 则定义在 API 的 tools 字段里，二者在技术上正交独立、解耦。
- Codex 默认提供 13 个内置 function（如 execute_command、update_plan、spawn_agent 等），MCP server 可动态扩展 tools。
- 通过设置环境变量，可将 Codex 的完整请求体（包括 instructions、input 消息列表和 tools schema）落盘保存到本地 SQLite 数据库，便于分析。

## 大纲

1. 开篇与主题引入
2. Modern AI Agent 的特点与 Agent Runtime
3. 内置 Tools 与调度编排系统
4. Context Engineering 的核心：暴露在上下文中
5. Skills 与 MCP 在技术上是正交解耦的
6. Agent Runtime 与 Agent Loop 的运作机制
7. Codex 中的 Tools Schema 类型与落盘方法
8. Codex 请求体结构与默认的 13 个 Function
9. 结语与后续资源说明

## 正文

### 1. 开篇与主题引入

亲爱的朋友们，大家中午好。今天我们继续回到MODERAJ这个系列哈，这期我们继续探索context engineering哈。这些codex包括cloud code，前面的CLI open cloud这些现代的AI检测的context，按年龄的设计。上一期我们介绍了codex里边的skills，如何做渐进式的加载的。那这一期呢我们第一是来到这个更大的context，3年轻那个picture，同时呢我们来还补充介绍一下tooth相关的相关的一些知识哈。我我目前的一个理解tooth或者叫MCP哈，和skills在技术上是赠交独立结构的好。

### 2. Modern AI Agent 的特点与 Agent Runtime

就首先哈第一点哈，包括最近那个李宏毅老师，他介绍这个open cloud的时候，他也在讲这个事情哈。Codex cd code，键盘带CLI open cloud都是modern AI agent词，它们都是一种更现代的一种agent词。它的特点或者不同，就在于比这之前他有更强的基础模型，GBT5.4哈，Obs4.6，他有更长城的AINSIC的多轮的一个能力，就是我们发了一个用户的一个query之后，整个这个agents层进行漫长的一个多轮的，一个长城的一个交互，最终写出完整的代码，或者是达到实现用户的要求。

然后另外一所谓的agent的run time，他会准备了大量的提示词注入哈，A型词点MD哈，so点md memory，点MD哈，就我们上一期介绍skills的时候，当时也介绍了codex的一个提示词注入哈，就是用户在口袋XCLI里面，发第一个请求的时候，他整整个codex已经提前帮你植入了，至少三条的一个一个一个消息哈。第一条是system的一个instruction，第二条是developer消息，第三条是user的一个消息，user的消息里面就包含了A进四点MD以及skills的一个摘要，就有哪些可用的skills，每个skills的一个简单的一个说明是什么。

### 3. 内置 Tools 与调度编排系统

还有tooth这些A键词都内置了很多to，还包括一些现代的，比如spawn agent，mari agent的相关的设计哈，还有update plan task，当然还包括经典的shell commands，就执行一些shell的命令哈，还有这个web search，web flash对他就支持了，他又更更丰富的skills，当然这个skills呢是整个社区不断的在维护的。还有TOOS呢，有MCP servers，还有这个系统内置的这些to哈，它就可以执行，比如浏览器的自动化，还有这个open cloud，它比较有趣的就是它的app的一个交互哈，就是你可以通过即时通讯的软件哈，和这个A级的进行交互。

第三呢就是他们有更合适的一个调度编排系统，要设计完善他们的agent的loop。第二点呢就是整个这些AIA键词，它提供了一个A进的run time，就是他有对提示词的一个设计啊，他有skills的一些文档，他有类似的一些to哈，然后当然你也可以集成，你也可以自定义一些skills啊，自定义一些to哈，他是agent的run time，他这些A禁词的一个A型的run time，在管理维护这样一个A进的loop，执行的一个运行时的环境哈，然后去support这个agin the loop，因为它毕竟还是要调AAPI或者本地的，或者是远端的，它核心呢就是维护在维护这个消息列表，就我们我们做过AAPI调用的话，都应该熟熟悉这个事情。

### 4. Context Engineering 的核心：暴露在上下文中

然后这些东西共同构成了这个远端的，或者本地的大模型推理的一个上下文，也就是整体的这所有的agent的modern AI agent，都是在做context engineering好。第三点，不管是skills还是MCP或者任何预设的tools，如果他们不暴露在context里边，不暴也就是不暴露在这个API的这个message的list里面。

这个远端的模型或者本地的模型，是不可能感知这些skills这些tools的存在，也就无从去调用啊。当然这里面还包括这个memory，大家一定要记得这一点哈。就是我们过去一期，包括这一期我们去探索这个CONNE3in yin，其实就是探索modern AI镜子，它是怎么去管理和维护这些context，skills放在什么地方，有哪些预知的system指令，tools是如何暴露给远端的API的，有哪些tools好。

### 5. Skills 与 MCP 在技术上是正交解耦的

最后一点就是，skills跟MCP在技术上是正交独立解耦的。我先说明一个点，就是skills是以cortex为例哈，它是出现在这个user的message里里边的，它是一个message的一个content。但是MCP或者是其他的任何的tools，它的定义是放在tools这个字段里面的API里面，那个tools这个字段里边的，所以它本身就处在不同的位置哈。所以说不存在说出现了skills之后，简化了MCP或者TOs所占的context，除非你显示的设计对。技术上他俩是正交独立解耦的。

就skills加摘要是出现在message的content里面，具体来说就是他植入的哈，cortex而言，他植入的第三条的一个消息，user这个消息他是跟As近S点MD是一起的。然后用户发完第一个query之后，这个远端的模型，它基于这个query去匹配最合适的一个skill，如果发现它要加载某一个具体的skill，它会去通过一个function，就是具体来说就是一个执行一个SL的一个命令啊，这个命令就是cat，我们把这个skill点这个skill对应的skills点MD完整的加载出来，就作为一个function output的一个消息吧，加载到这个context里面。

MCP或者任何这些agent词，它内置的一些to哈，web search哈，spagents update plan哈，它都是通过tools的方式，tools schema的方式加载到这个API里面的，出现在context里面，暴露给远端的或者本地的大模型做推理。当然skills里边可以提及具体的to，即可以说明什么时候用什么样的to，但是哈你仍然需要toos schema的一个定义哈，放在这个API里面。

### 6. Agent Runtime 与 Agent Loop 的运作机制

对我刚刚已经也也介绍过了哈，AINARUTIME和agent的loop in the wrong，time是agent的执行的运行时环境，就是AN的执行的一个舞台。比如你对于open cloud而言，你有一个workspace，你需要注入一些启动的一个文件哈，内置的工具skills，还有其他的一些部分吧，啊还有一些markdown文件哈，ISEN点md so点md tooth。in in the loop呢是当一条消息真的进来之后，系统如何把它变成动作或者回复，最终的一个response。也就是intake输入一个消息哈，可能也也可能会处在一个排队哈，然后给他准备给他做大量的一个prompter，一个injection哈，提示词注入，然后模型推理，如果要做一个function call号，然后执行这个工具，然后流失的一个回答，然后持久化到本地，这是open cloud官方的一个agent的loop好。

### 7. Codex 中的 Tools Schema 类型与落盘方法

那下面我们就正式介绍这个，我们以codex为例哈，介绍它这里边的toos schema哈。我们在cortex CLI里面看到的update plan哈，Spn agents exexecute command，它都是内置的一些function，然后这个codex里面他把这个function的或者TOs schema schema呢分为了五种类型哈，至少目前看到的五种类型的function local cell呃，然后图像生成web search啊。

还有自定义哈，好，对，就大概先简简简介一下哈。然后这个当当然，这个MCP就是一个DYNAMIC的tools啊，因为它它是取决于你的配置哈，你配置了哪些MCP的server，这些MCP server会暴露到哪些tools或者functions codex。默认的情况下，你启动codex的话，你这些放tool schema哈，就是API层面的，tool schema是不不持久化到本地的。如果我们想要持久化到本地或者叫落盘哈，GPT5I用的一个词哈，落盘就把内存的数据持久化到本地哈。如果我们想要落盘的话，我们需要加这样一个环境变量吧，那这样的话他就会把这个完整的一个请求体放在这个logs杠一的SQLITE这样一个数据库里面，本地的数据库里面。

### 8. Codex 请求体结构与默认的 13 个 Function

就假如说我们我当时试呃，试了一下哈，我们将启动之后，我发了一个hello哈，呃他最终记录在第2200、2673条这个记录里面好，那这样我们就拿到了完整的这个消息请求体。我们可以在里边去看到，因为他是个response API哈，我们的可以读他的instructions指令哈，就第一条system的一个instruction，然后input里面就包括developer user哈，然后user query哈相关的，然后同时呢它里面还有一个tool这个字段我们都可以打印出来哈，就是它是一个response点creates的一个请求体。

instruction是独立的顶层的一个指令，相当于system problems，input里边是一个完整的一个message的一个list，它里边可以是developer，可以是user，可以是assistant，可以是function CORE output，当然它还有这个response API所独有的一种，它可以挂着挂载之前的response id哈，上号链接，就它的结构大概是这样的。重点的就是这个tool，我我当时没有，我们没有配任何MCP server的情况下哈，我们大概看一下它默认的有13个function。

执行command，就这个命令执行命令，命令向已用命令会话写入啊，标准输入哈，呃并读取标准输出。update plan哈，更新计划，因为我们知道哈，现在的coding agent都内置了一个plan的一个mode，当然还有request user input，或者叫ask ask user question，当然还有执行代码，Apply patch，编辑和执行代码，Web search，还有督图view imagine哈，还有sporing agent，就是所谓的multi agent system。

Subagents，send input，给已有子代理继续发送消息或补充上下文，Resume agents，恢复上一个已关闭或暂停的一个子代理，然后wait，因为子代的子代理的执行是需要一定时间的，wait，等待一个或多个子代理完成，Close agents，关闭子代理，并返回其最后的状态，spawn agents on as on csv哈，这应该是最近加的一个future哈，按CSV每行批量启动子代理，并汇总结果好。

### 9. 结语与后续资源说明

以上就是本期的全部内容，就是非常感谢大家看大家看到这里哈，就是我们这个目前的几个付费系列，都对应着一个私有的代码仓库，就是我每天也会进行大量的代码更新，大家有代码需求的，一定要在后台私信我，你们具体的GITHUB账户信息，我把大家邀请到这个项目里边来。