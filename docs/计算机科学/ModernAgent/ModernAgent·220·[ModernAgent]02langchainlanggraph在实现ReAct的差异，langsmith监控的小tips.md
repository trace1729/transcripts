# ModernAgent·220·[ModernAgent]02langchainlanggraph在实现ReAct的差异，langsmith监控的小tips
[视频链接](https://www.bilibili.com/video/BV1n4n7znEDN)

## 总结

- 强调基础概念和原理的重要性，指出现代开发理念脱胎于经典工作。
- 说明本期核心动机是比较 LangChain 和 LangGraph 中实现 ReAct 的接口差异。
- 介绍本期将重点讲解使用 LangSmith 平台监控模型输入输出以理解工作流程。
- 回顾 ReAct 工作，引用姚舜瑜的播客，并指出 ReAct 是对大模型早期潜力的探索。
- 通过类比 COT（如“Let's think step by step”）说明 ReAct 强调工具调用和环境交互。

## 大纲

1. 开场与基础概念强调
2. LangChain 与 LangGraph 实现 ReAct 的差异对比动机
3. LangSmith 监控与调试的核心方法
4. ReAct 工作回顾与意义

## 正文

### 1. 开场与基础概念强调

亲爱的朋友们，大家周末好。今天我们继续回到Modern Agents这个系列里边，感谢在这个系列里边我们再次相遇。这一期我们回到一个非常经典、非常基础、非常朴素的一个react篇工作上。就是在开始之前，我先再讲一句题外话：一定要重视基础概念和基础基本的原理，一定要把概念搞清楚，越基础的东西越本质。随着我们后续这个系列里面越来越去介绍一些modern的、现代的、powerful的、fancy的这些新型的开发的理念，我们会发现它其实都是脱胎于原始的经典的那些工作之上的。

### 2. LangChain 与 LangGraph 实现 ReAct 的差异对比动机

在开始之前，我的一个很重要的一个动机，就是因为我最近包括这个系列，也是我们都是基于这个Longchain Longgraph这样一个生态去做的，去做对一些原理或者对一些工作做一些介绍或者一些探索和实践。就是我最近在想，因为我当时我自己在用这个Longgraph的时候，其实看到这个接口，基于Lang Graph去实现React这样一个接口的时候，是用Create React Agent这样一个封装好的一个Agent的模板。我当然是在想，在Lang Graph之前，其实Langchain里面也实现了一个Create React Agent，我其实就想对比看一下这两个实现上的一个差异，这是本期的一个很大的出发点。

### 3. LangSmith 监控与调试的核心方法

另外这期我们可能要重点介绍我们基于Langsmith这样一个在线的一个monitor平台，我们去怎么去监控模型的输入输出，怎么通过模型的输入输出核心的tips，就是说我们通过check模型的输入输出来理解它的一个工作流程。好，这是这期我们主要围绕的两个点来展开：就是对比看一下浪线lang graph去再实现create react agents这两个接口上的一个内部是工作流程上的一个区别。然后其次我们介绍一下Langsmith这个平台，我们怎么去debug看一下整个工作流程。

### 4. ReAct 工作回顾与意义

我们再简单回顾一下这个react。包括我最近在从听这个姚舜瑜在小夜桌上的一个播客的时候，他也重点callback了这个react，大家有兴趣的话可以听一听。就react，包括后续再然后这个姚舜瑜他们团队提出了reflection，这两个非常经典的工作。react现在的引用量已经应该达到了已经4000多了，当然它未来会越来越多。它都是对我自己的理解，它都是对rm的一个早期的适配或者说探索模型的一个大元模型的潜力，它的一个早期实践的版本。站在现在的角度，它工作的最大的一个意义就是面向agent的，就是所谓的调用工具跟环境不断的交互，就如同这个COT，所谓的Chain of thought，一个经典的一个promise就是Let's think step by step。