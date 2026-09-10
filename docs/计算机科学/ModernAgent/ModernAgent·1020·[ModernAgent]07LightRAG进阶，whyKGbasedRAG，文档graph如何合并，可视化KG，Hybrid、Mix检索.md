# ModernAgent·1020·[ModernAgent]07LightRAG进阶，whyKGbasedRAG，文档graph如何合并，可视化KG，Hybrid、Mix检索
[视频链接](https://www.bilibili.com/video/BV1Fuq2BWELU)

## 总结

- LightRAG 的核心优势在于基于知识图谱（KG）的 RAG，能够实现多跳推理和全局性查询，克服了传统 Naive RAG 因 top-k 限制导致的碎片化推理和失败问题。
- 新增文档时，LightRAG 通过实体对齐（大小写不敏感、一致性命名）、基于语言模型的语义压缩，将新文档的子图合并到全局大图中，实现动态更新。
- 实体和关系的合并策略采用 map-reduce 方式：先收集并去重不同 chunk 对同一实体/关系的描述，若较短则用分隔符拼接，若过长则用语言模型进行语义摘要压缩。
- 项目提供专门的代码，可将索引过程中生成的 graphml 文件通过 Gephi 等工具进行知识图谱可视化，方便查看实体和关系。
- LightRAG 支持三种检索模式：Naive（纯向量检索）、Hybrid（纯知识图谱，结合 local 和 global 信息）、Mix（知识图谱推理 + 向量检索获取原始文本）。
- Local query 以实体为中心，使用 low-level 关键词检索实体节点后进行一跳领域遍历；Global query 以关系为中心，使用 high-level 关键词检索关系边，关注宏观主题。

## 大纲

1. 开场与内容概览
2. 为什么需要 Knowledge Graph based RAG
3. 对比 Naive RAG 与 KG based RAG 的数据形态和推理能力
4. 分析 RAG 系统的方法：日志与 LangFuse 监控
5. 新文档如何合并进入知识图谱：实体对齐与命名一致性
6. 关系合并与描述语义压缩策略 (map-reduce)
7. merge 过程代码示例演示 (insert & merge nodes/edges)
8. 知识图谱可视化方法
9. 三种检索模式详解：Naive, Hybrid, Mix
10. Local query 与 Global query 的区别与实现及结尾

## 正文

### 1. 开场与内容概览

亲爱的朋友们，大家中午好。今天我们继续回到MODERAIN的这个系列。这一期我们补充介绍上一期介绍的LightRAG更丰富的源码细节。也就是说这期的内容非常简单，大概几块内容：第一，为什么要引入Knowledge Graph based的RAG，传统的Naive RAG的局限和不足是什么；第二，LightRAG很重要的一个特点，就是它可以动态地新增新的文档，然后这里的mod过程是什么样的；然后还有它这个项目里面也提供了Knowledge Graph可视化的一个代码；然后第四块，就是我们在详细地介绍一下它这个所谓的Hybrid Mode或者叫Mix Mode，Local Search、Global Search。然后这一期的内容是紧接着上上上一期的，大家一定要完整地把之前的内容看一下，做到无缝衔接。上期我们介绍了LightRAG的一个完整的工作过程，以及我们怎么基于LangFuse去对它所有的API调用的过程做trace监控。

### 2. 为什么需要 Knowledge Graph based RAG

也就是说那第一部分就是说为什么要引入Knowledge Graph based的RAG。就是它的应用场景，就是对于海量的文档，我们要实现一种全局性。我举例，就是你要做一个多跳的推理。假如说文档chunk之间、实体之间是有多跳的关系，就是A和B是有关系的，B和C是有关系的，C和D是有关系的，D和E是有关系的，它们分别在不同的chunk里面。Graph based的Knowledge Graph based RAG可以实现多跳的推理。然后比如还有一种是全局的计数，我先简单介绍这两种场景。总之Knowledge Graph based RAG可以实现某种意义上的全局性搜索、全局性的query、全局性的匹配。

### 3. 对比 Naive RAG 与 KG based RAG 的数据形态和推理能力

我们再简单对比一下，Chunk based或者在LightRAG里边它所谓的Naive方式的query方式。它数据的形态是点，因为每个chunk我给它建一个embedding；而Knowledge Graph based RAG它是一个网，它是一个graph，里面是实体和关系。实体有细粒度的描述，关系有细粒度的描述，而且有对应的embedding。这些上期我们也介绍了，这个实体关系是基于语言模型抽取的，基于一个prompt去做提取；实体的描述是基于语言模型去做的profiling，关系也是如此，基于语言模型去做profiling。等于建这个全局的Knowledge Graph完全依赖的是语言模型的能力。

从数据形态上，Knowledge Graph based它某种意义上有一个完整性，有一种全局性。然后推理的话，你把对于Naive的一种风格的话，你把所有的chunk检索出来之后放进大语言模型里面有限的context里面，实现一种碎片化推理。而LightRAG是利用图结构多跳的路径游走和关联发现，把它给放到context里面，它具有一种可解释性和深度性。然后全局性呢，Chunk based的Naive RAG它受限于top k，就是你只能放有限的top k个chunk，如果你检索不到最可能、最核心的、最必要的chunk的话，它就会导致你推理的失败。而LightRAG实现一种global query之后，它可以做一个结构化的聚合，它能回答一个总体的信息。其他的就是一些更细粒度的一些优势吧。

### 4. 分析 RAG 系统的方法：日志与 LangFuse 监控

然后我们去跑这种RAG系统的话，我从分析的角度，我们第一是分析它的log，第二是我们基于上一期介绍的一个第二是我们基于上一期介绍的一个

我们本地部署的一个long fuse，去监控API调用的一个输入输出，我们就把这个完整的检索建图的过程给看得比较清楚。那下面我们来介绍它这个merge这个过程，就是他一个很大的一个优势。有一个新的文档进来之后，对着新的文档，先基于原模型去提取它的实体和关系，然后对这个实体和关系做profiling，同时呢对实体和关系做embedding。

### 5. 新文档如何合并进入知识图谱：实体对齐与命名一致性

然后这里边就是怎么把这个新的文档的子图合并到原来这个大图里边，是非常非常简单的。首先有一个事情就是实体对齐，entity element或者同义词匹配，但是这块呢主要是依赖于语言模型生成的时候的一致性。然后这个prompt里面其实专门提了，这个事情就是这个entity expression system prompt里边有提到，大家去看他所有的prompt都是放在这个prompt.py里边，整体组织得也比较清晰。

大家可以看到这一块，他在这个提实体名的这个system prompt里面提到这个事情，就是这个实体的名字呢，第一它是大小写不敏感的，要把每个单词有意义的单词大写，要确保一致性的命名。然后重要的就是实体的合并，不同的实体在不同chunk里边，同一个实体呢，它其实是刻画着不同的侧面，然后这个合并的逻辑呢就是侧面的叠加。大家注意，如果因为实体还有描述，如果描述过长的话，要基于语言模型做语义的压缩，我们待会会详细的介绍。

### 6. 关系合并与描述语义压缩策略 (map-reduce)

然后就是关系的合并，关系的合并可能更存在这种所谓的语义压缩。我们简单看一下，就是边的description的一个合并策略，不是简单的字符串拼接，它是一种map reduce的一种策略。首先搜集不同chunk提取到关于这对关系的描述收集起来，然后去重，然后判断如果短的话，就用分隔符去做拼接；如果长的话，要基于语言模型去对这个描述做一个语义的摘要。然后它同时同样的，它是基于语言模型去做的，大家也可以读这个prompt，它里边有这样一个key，就是summarize entity descriptions。

### 7. merge 过程代码示例演示 (insert & merge nodes/edges)

这里边我构造了一个示例，就是复现这个merge的一个过程，就是merge nodes and edges，这个就是update和insert一个一个的合并。这个代码比较啰嗦，但大家不用特别详细地去看，我们还是看它的大体的一个流程。我们看我们有两个chunk，基于语言模型提取出来两个chunk，chunk里面有节点，有边。节点的话有名字、有节点类型、有描述，还有它对应的source id；然后边的话同样的有关键字，同时有description。

然后第一个chunk的话，显然就直接把它给insert进去；然后第二个chunk的话，就涉及到一个merge的过程。那个merge的话其实对于节点的话，我们去索引相同的节点，然后把这个description给concatenate起来，然后同时呢对边也是如此，也是对这个description做concatenate，如果它长度过长，要基于这个语言模型去做语义的压缩。

我们简单看一下，其实合并的过程，我的第一个chunk那就是插入进去，然后第二个chunk就是个merge。我们可以看merge出来这个结果，你看这个ALEX这样一个节点，他的描述呢就变成了，因为他不同chunk里面对这个实体有不同的侧面，因为它比较短，我们就基于这个分隔符去做concatenate，同时呢source id也做concatenate。然后对边也是如此，因为第一个chunk里边ALEX和bob的那个描述呢是两个人是同事，第二个chunk里面两个人的关系是朋友，然后这里边也是说把他们concatenate起来。也就是说这里边假如说这个同一个entity

### 8. 知识图谱可视化方法

它有它在不同的创客里面大量的出现，而且有非常非常详尽的description。那这个时候如果他超出一定的透光的长度，我们要基于语言模型对它做语义的一个压缩。同样的对于边也是如此。好，这是这一大块的东西。然后第三个就是可视化。就我们呃，他他他那个工程里边提供了这样一个组代码，也非常非常简单。因为我们当时建图的时候，我们在index过程里面会生成这样一个graph m l的一种风格的格式化的文件，一个graph的文件。我们就是对它基于这个排位这个库哈，对他做可视化。我在这个脚本里边，我们这个脚本里边我也写了这个可视化的代码啊，脚本里面也写了这个可视化的代码哈，就比较简单。然后最终大家可以看到这个可视化的一个过程哈，大家去去点这个节点啊，点这个节点点这个边就会看到相关的内容。这块比较简单。

### 9. 三种检索模式详解：Naive, Hybrid, Mix

然后最后呢就是retrieve的过程哈。就LightRAG做的比较好的一点，它支持多种的retrieve mode，大家可以来对比去评估。我们这里边简单再再来回顾一下naive、hybrids和mix的三者的一个过程。naive的话它仅仅是基于vector，他基于vector做retrieve。我们对会会对用户的query哈，作为embedding哈，然后每个trunk呢，每个text的trunk会建立一个embedding，就基于它的一个cos similar的一个相似度去做检索，就非常非常trivial哈。hybrid的话它就涉及到知识图谱，knowledge graph里面，它涉及到local和global。hybrid的话就纯粹是基于知识图谱，它结合了local和global的图谱信息。它不大家注意哈，他不直接去向量库里边去找原始的文本框。然后mix的话就是基于知识图谱base以及vector Retrieval，也就是hybrid加naive。有kg的一个全局的一个推理，又额外做了一次传统的向量检索，去获取原始的文本框。

### 10. Local query 与 Global query 的区别与实现及结尾

好，我们最后我们再来去整理一下，所谓的local query和global query。local query的话基于实体的一个领域搜索，它是实体以实体为中心的。因为我们当时大家知道哈，这个所谓的HYBRID呃，LightRAG呢它是一个一个low level加high level都有的核心。就是基于query里边去定义它的low level的关键词和高level的关键词呃，上一期我们介绍的非常非常清楚了。我不妨我们再去这个这个呃long fuse里面，这个trace里面大家可以看到哈，呃我我我展开的这个trace呢，就是就是所谓的这个提取关键词的一个trace。他是基于这个query哈，你去定义它的low level的关键词和COLLAB的关键词，非常非常简单哈。low level的关键词哈，原模型从query中提取出具体的实例名称。然后基于vector search，基于这关键词，在ANTICITY的一个向量里面去检索对应的实体节点。然后在graph里面去做traveler，去做便利，找到一跳的一个实体。找到这些实体，去图数据库里边去获取他们直接的领域，叫一跳的一个retrial。

然后global query的话基于这个实体哈，他是从实体的一个角度去出发的，关注的是宏观主题。同样的因为我们有hello的关键词vector search去匹配relation，因为我们对relation也做了embedding哈，去检索对应的relation，然后从relation去检索对应的边。好，以上就是这期的全部内容吧，希望对大家对这个light rg，对这个knowledge graph base的一个RG，有更深入的一个了解和认识哈。那最后呢非常非常感谢大家看到这里哈，就是我们这些付费的这两个系列里边，还包括其他的一些呃系列里边。

我们那个对应的代码呢，都是我们这边的一个私有的一个代码仓库。就是我每天呢也会记，对我个人的笔记都做大量的更新。大家有代码需求的话，一定要在后台私信我，你具体的一个get up一个账户信息，我把大家邀请到这个项目里边来。