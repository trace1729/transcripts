# ModernAgent·420·[AIAgent]llamaindexRAG原理及源码分析
[视频链接](https://www.bilibili.com/video/BV1Vm42157PL)

## 总结

- LlamaIndex 是基于 RAG 的框架，核心流程包括：外部数据集分块（chunk）、每块创建 embedding、用户查询也做 embedding，并计算相似度后取 Top-K 相关块与查询拼接，作为上下文提供给语言模型回答。
- RAG 涉及两个关键模型：embedding model（如 text-embedding-ada-002）和 language model（如 GPT-3.5-turbo），默认均由 OpenAI 提供，但 LlamaIndex 内部封装了这些模型接口。
- 环境配置包括安装 llama-index 和 python-dotenv，并设置 OpenAI API key；使用格雷厄姆的短文作为外部数据集，目标是让模型基于指定数据回答，减少幻觉。
- 源码分析显示，文档分块时默认 chunk size 为 1024，窗口重叠（overlap）为 200，示例中单一文档最终被划分为 22 个 chunk，每个 chunk 对应一个 node 和 1536 维的 embedding 向量。
- 检索时对查询计算 embedding，并通过向量相似度（如欧氏距离或余弦相似度）找到最相关的 top-2 个节点，随后将相关内容与查询按预设的 QA 模板组合成 prompts 发送给语言模型。
- 语言模型的输出模式默认是 compact（紧凑型），并且系统提示会明确要求模型仅依据提供的上下文信息回答，不使用内部已有知识，以提升回答的准确性。

## 大纲

1. 开场与 RAG 基本概念
2. 环境配置与整体流程
3. Prompt 模板与关键参数
4. 代码实现与索引构建
5. 源码级分析：分块与 embedding
6. 检索过程与相似性计算
7. 语言模型调用与总结

## 正文

### 1. 开场与 RAG 基本概念

亲爱的朋友们，大家周末好。今天我们回到LLM and ITC 74个系列，这个系列专注于现代人工智能、现代语言模型的一些现代化的应用。之前那一期我们介绍了RAG这样一个非常非常实用的技术，我觉得其实无所谓工程还是科研，都是非常非常必要的、非常非常基础的、非常非常现代的一个框架。我们介绍的这一节，我们介绍的一个RAG的框架叫Llama Index。其实我在之前第三期介绍OpenAI Embedding Model的时候，当时就我们自己相当于自己手动的去搞了一套RAG的一些事情，那这一期呢我们就用Llama Index去做这件事情。然后其次呢就是补充一点，我在5月底的时候其实推荐过一本书叫《AI镜像》，那这本书里面也是比较全面、比较系统的介绍了AI镜像、现代的一些基于语言模型的一些应用的开发。如果有需要的话，大家一定点我这个链接去购买这本书。好，言归正传，首先我们来看这个RAG的一些基本的概念，这当然是从他官网里面去拿了一个图啊，这个图其实搞清楚之后，RAG就很简单。

首先我们看用户会有一个Query，就是问一个问题，然后这个Query呢要和这个Index去做结合。这个Index是针对我们外部的一些数据集，就非语言模型之外的一些外部的、我们存在硬盘上的一些数据集，比如结构化的一些数据库，或者一些非结构化的文档。那这一期我们最后Demo或代码展示的就是一个非结构化的文档。然后API这个事情我不是特别熟哈，总之对外部的数据集进行做Index，分Chunk，也不是说一个文件就对应着一个Chunk，是一个呃，我们会基于一定的原则去划分Chunk，对一个文档它分Chunk。然后Index的过程呢就是对这些Chunk，把这个所有的数据集做分Chunk之后，每个Chunk去创建一个Embedding Vector，同时呢对这个Query也要创建一个Index，就是创建它的Embedding Vector。然后呢就基于问题和你已有的数据，就是自己本地的一些数据集，去计算一个基于它们的Embedding Vector，去计算一个点乘的一个相似性的计算，然后取Top K的这个相关的外部的一些数据和这个Query拼起来之后，去作为Language Model的一个输入，然后产生回答。

那最终呢我们其实要求这个Language Model回答的时候，仅基于这个上下文，就是我们检索出来的最相关的数据集去自我回答，而不是说用这个Language Model已有的知识。那个我们知道现在的Language Model其实Context Learning非常非常强，它很容易去基于你的相关的数据集去回答最相关的问题，回答你这个Query里边相关的问题。所以我们其实可以看到，这个里边这个RAG里边，它两个非常重要的Model，一个是Embedding Model，就是你外部的一些个性化的数据集分了Chunk之后，然后创建了这个Embedding Vector，是用了一个Embedding Model，然后另外就是Language Model。默认情况下这两个Model呢是用的OpenAI的，Embedding Model用的是Text Embedding Ada 002，然后Language Model用的是ChatGPT，就是GPT Turbo 3.5。这个框架搞清楚之后，基本上就没有什么特别困难的。然后这一节我们主要是重点是介绍，因为它封装的特别特别好，然后我其实如果代码层面写这个实现这个功能的话，就可能五行代码就可以完成这样一个事情，但是它因为它底下有个High Level。

### 2. 环境配置与整体流程

他的框架写得非常非常高级，导致我们其实这集重点是放在源码的分析上，看它内部到底是怎么处理的。然后我们再总体概括一下，这节课代码就用到了他官网里面提供的一个代码，非常非常简单、非常非常基础。好，看一下这个整个工程的配置。首先 dot env，左边我们看 dot env，首先需要装两个包哈，llama index 和 python dot env。dot env 里边配置 OpenAI API key。其次就是数据集，这个 data 目录里边，我们用格雷厄姆的一篇短文，他写的一篇文章，作为外部的数据集。我们希望它基于我们给它提供的数据集去回答问题，而不是基于模型本身的知识，去降低模型本身的幻觉，尤其是对真实性要求比较高的一些场景。

好，那这是整个工程的环境配置。然后我们看 data 到 index 的过程，他用的是 embedding model，是 text-embedding-ada-002，走的是 API 的方式。当然他那个 llama index 内部也封装了 OpenAI 的 embedding 类。然后 query 也是要做 index 化的，也是要把 query 变成 embedding vector。外部数据变 index 的过程其实就是分 chunk，首先外部数据划分 chunks，然后每个 chunk 去创建 embedding vector。检索的过程就是把我们的 query embedding vector 和这些 chunks 拿到的 embedding vectors 求一个相似性，默认情况下是取 top 2 的相似性文档，然后把它们作为 relevant data，和 query 一起，以一种 prompt template 的方式组合起来，然后送给 LLM model。一共两个 model：embedding model 和 language model。

### 3. Prompt 模板与关键参数

那这里边是我从源码里面扒出来的 templates，就是我们组合这个 query 和 relevant data 的时候是怎么组合起来的。有一个 QA 的 templates，这是从源码里面捞出来的，大家可以学习这些 prompt engineering 的技术。这 QA 的大家可以看到，就是你回答问题时要紧跟根据 context information，不要使用你已有的知识回答这个 query。这个地方是 query，这个地方就属于 relevant data。然后还有 refine templates，就是 query 和之前的答案，然后你要基于这个 context window，基于这个 context message，去 refine、去优化之前的答案。然后最简单的 templates 就是 query 哈，就是基于他本身的能力去回答这个问题。还有一些 summarise 的 templates 就不再说了。还有一个就是 LLM 在 response 的时候，他 response 的一个 mode，这是从源码里面扒的，默认情况下是 compact 紧凑型的。

### 4. 代码实现与索引构建

好，下面我们就来看代码。代码的话我是写在这里吧，当然我这个 notebook 里面也提供了一个代码，然后还加了一些必要的注释。好，我们先从这个 notebook 里面看一下代码吧。这是环境的一个配置，加载文档，我们去这个 data 目录底下去，把所有的 document 都 load 进来。然后因为这里边只有一个文档哈，所以它当然是一个 list，list 的长度为 1。我们看一下它这些就不用管好。那比较重点、比较核心的就是 index and query。

就划分trunk，trunk size是1024很默认的，然后窗口之间是有OVERLEFT，然后OVERLA大小是200。然后就具体一个split和一个watch的过程哈，这里边非常非常细节吧，待会那个代码看代码的时候，其实能看到是怎么把一个文档去做split，然后做merge，然后把一个trunk，然后默认完了之后会有很多trunk嘛，然后每个trunk去创建一个note，然后把这个notes里面对应的trunk的文本去创建他们的embedding vector。然后对于text imagine i的002的话，它其实就是1536位的一个向量啊，就512×3好。

然后这这这就这就是这句话，就我们这个文档呢它最终只有一个文档，然后它一共划分了22个trunk，然后每个22个，每个trunk呢他创建了分别创建了notes，然后然后再计算他们的embedding factor。好嗯，这里边我们可以从这个dock store里面去，基于这个node node id去索引它们对应的文档，去索引它们对应的这里面可以看一下，去索引它们对应的，这是这这是这是某个窗口的文档，就是文本，然后这是某某个trunk的embedding vector，就是1500啊，三六位好。

然后就可以基于这个index去去去构造一个query的一个engine，然后这个query engine就可以查询这个这句话，就是这个作者是在哪呃，What did you go growing up，他做了什么，在成长成长阶段就是格雷厄姆特，然后是非常非常硅谷嘛，然后产生了一个回答，然后这个回答呢它是基于这个基于这个啊，这个我们看这个数据集里边，基于这个，它是基于完全的，是基于这个就是我们提供的这个数据集本身回答的这个问题，而不是基于他已有的知识。如果基于一遇的支持呢，你应该这样问哈，就是what what did，这什么炮，保罗格雷厄姆做了什么，在强化阶段，那其他的就没什么了，我们就来，那剩下的就是我们来去看一下源码，我们第八个跟一下啊。

### 5. 源码级分析：分块与 embedding

好稍等哈，这个OK嗯，这个里边它有一个settings啊，这个先不管啊，我们就往前走，好我们进到这个，我们首先这个文档呢长度是一，就是他会给文文档搞一个id哈，就是这这里边的内容呢，就是啊就是就是这个文档本身的内容，就是这个时候还没有划分trunk呢，哈好我们接着看哈，这里是进到这个嗯，就是这个vector store index里面，然后变化哈，我我我看一下吧，我跟一下，好这个地方就是对这个文本进行划分，Trunk，trunk size是这个地方，我看川普赛斯997，他应该是1024减去了，减去了这个文档的目录，文档的路径，这个大家可以看源码哈，就是1024减去这个文档目录，然后划分split看啊，然后一共划分了，就split的话划分了，哎划分了759个space，大家可以看到啊，有的时候一句话他不一定说固定长度，他有自己的原则哈，如果有兴趣的话，可以看这个split的源码，然后另外就是对他们进行merge，merge成trunk，我看最终trunk，trunk的话是是22个trunk，其实就是这里边我们取22个这个，然后22个trunk，22个note，22个imagine vectors。

这个就很长了，这一句话就比较长了，就是我们可以看到这是第一段，就是第一个啊，文本就是最终的力度哈，最终检索的一个力度，就是把这样长的文文档放在这个prompt template里边，好，我们继续嗯，我看好，然后这个地方是把这些trunk呃，把这些trunk呃给他们都创建了个notes，然后把创建note，是是把这些这这个这个notes也是22个，应该是没问题的，每个都有自己的node id，然后它对应的文本，这个时候还没有对它做embedding，我们继续吧，好啊，这个是好看，我们看一下这个imaging model哈。

它默他这这个地方也就走的默认的哈，它默认的embedding model呢是诶，不好意思，我们可以看啊，imagine one是text，imagine text i的呃002好，那个bad size的话是2048，OK好嗯，这个也没什么说的哈，我们就在这接着走好。这个地方就是给每个notes创建他们的imagine，就基于text的达芬奇呃，Text imagine add00 to，这个地方就是把这个文本变成embedding啊，应该打的都是断联哈，我就直接走。这个就是啊他是一个by词进来的哈，是22个啊，这个batch size是目前的by size是22，给他们分别创建这个EMINE，我们看这是它们分别对应的22个embedding，每一个EBEDING的维度是1536，就512×3。好这个results呢就是把这个就是每一个notes，他都把它们对应的这个对应的这个vector，也可以放进去哈，啊无所谓了，就是这个maging vector给拼拼起来好，我们继续。

### 6. 检索过程与相似性计算

好那这句话就完成了这个index的一个构建的过程，对文文本，我对这个数据集里边每个文档划分trunk，每个trunk去再创建一个note，每个node在在计算他这个创客对应的创客里边文本对应的一个embedding factor，1536位。然后我们看这个，其实嗯我们就不嗯，这个这个应该没什么特别要讲的啊，这就是说他的他这里边拿到了一些templates，这个地方就我们可以看到，就是这是一个QA的一个templates，其实就是这里边我总结的，我把他们拉出漏出来整整理的，Keep it template，就是我提供这样的环呃，Context information，然后这个里边就是基于这个retrieval哈相似性，去从数据集里面low出来的相关的一些文本，然后这是我用户的一个query，这是这样的一个QA的templates啊，这个就我们也不再讲了。

然后这里边的language model呢，它用到的就我用到的是啊G p t 3.5turbo，OK好，那下面就进入到query哈，就进入到query的环节好，我们看啊，query嗯，然后这个是query哈，就是我们的我们输入的那句话，query就是我就是这个作者成长阶段做了什么，我们去快去retrieval，去所有的目前这个index里面所有的notes里面去retrieval最相关的notes，然后retrieve notes，我们看一下他是怎么retrievable的啊，还是RETRIABLE啊。

这个呢，首先对这个query也要基于我们的imagine model去算他的imaging vector，啊这是query的embedding，OK好，然后我看他的embedding，也是1536维的好，那这个时候query等于白ding嗯，就没关系好，那这个地方就是从这个embedding是应该就是就是22个notes它们对应的分别对应的embedding，1536的维度，然后取top k的top kid相关的啊，Note note note，那这里边我们我们看一下吧，他就是他们去怎么去计算top k的embedding，他用到的function是啊，这个function我先不管，我们看这个function是哪个function，这欧式距离，然后去算他们的额，imagine相差相减，再算L2的范数，然后再取负号，我们用到的是点击再除以再除以NM，就是一个标准的个距离，一个计算，而且或者然后加上这个呃cos，OK这比较简单哈，比较基础哈。

然后好，那这里面我们可以看到哈，它找到了两个0.82和0.81的，它们对应的就是node id呢是是这样的啊，我们这个数据，我们这个文档呢我们只有一个文档，然后一个文档分了22个trunk，20个trunk的分别创建对应的notes。

### 7. 语言模型调用与总结

然后每个node的创建他们这个创口对应的EBOR，然后他有这样的一个id，我们找到了，我们去拿到他最相关的两个id，就跟当前问题最相关的两个id，那这个时候啊notes带他们的，就把这个scores再放到这个node里面去。好那这个时候去创建它，就去基于这个time prompt template，去创建这个送给这个language model的一个输入啊，这个也也不管了吧，就是好。那这个时候就是标准的一个对话哈，我们看这个messages是什么，就这里面大家也可以学习哈，就第一个是system的一个麦啊，就角色哈，这个角色是system他的我们看它默认的情况下，他给的这个我可以放进去哈，就是这个我放到这儿哈。System，这个啊这个是角色哈，你是一个专家QA的专家，然后是是是值得被信赖的一个QV庄家，永远要回答这个用户的query，使用我们提供的context information，不要使用你的EU的信息。一些规则哈，不要直接参考啊，这given的文档要避免避免这个陈述，就基于这个文档啊，基于这个contest，the contest information啊，或者是说一些其他的一些信息。

然后我我看我们这个我们再看一下这个messages里面，除了这个system的，我就是我们这个这个地方，我们也呃，我们不妨，因为他一共low出来了，首先这就是我刚说的哈，他会有这样的一个路径信息，Context information is as is below，就是他走的是这个KA的模板，Context information is below，然后这是这是top1相关的，然后这个地方呢是top2相关的啊，这都是，然后最后given the context information and the，不使用这个EU的信息回答这个query，这个query就是用户提供的query，就问问问问问问的问题，就是这个作者他是在哪，他成长阶段是做了什么，然后让拉格尼毛的去回答。

OK那这个地方就是调open i的API，就是CHAGBT3.5，好额。那这样的话基本上就把这个lab index，然后这个他整个框架的一个流程，然后他源码的一些细节，应该是介绍的比较清楚了。好以上就是本期的全部内容呃，最后就是如果对呃这个RG对这个agents，对一些现代基于语言模型的，一些现代的一些开发的一个框架工具，有兴趣的话，大家要可以读这本书，哈达模型进行开发AI进程这本书，然后支持一下up，点一下这个链接。