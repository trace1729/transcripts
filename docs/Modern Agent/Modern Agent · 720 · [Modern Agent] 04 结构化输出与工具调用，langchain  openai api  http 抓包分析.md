# Modern Agent · 720 · [Modern Agent] 04 结构化输出与工具调用，langchain  openai api  http 抓包分析
[视频链接](https://www.bilibili.com/video/BV1uiUnBFED4)

## 总结

- 结构化输出（structured output）和工具调用（function/tool calling）本质上是对OpenAI API的HTTP请求，通过请求体中的response_format和tools字段实现，无需在Prompt中显式约定输出格式或函数定义。
- 使用Pydantic模型定义输出结构，通过model.json_schema()注入请求，可简化输出解析和适配，是实现弱版接口约定（SSD）和高效agentic workflow的关键。
- 在OpenAI API层面，结构化输出返回JSON，需要手动实例化；LangChain进一步封装，可直接返回Pydantic对象（如item实例），简化开发流程。
- 工具调用通过tools字段传递，LangChain的tool注解可方便地将Python函数转换为OpenAI工具格式。
- 结构化输出可用于实现类似CoT（Chain of Thought）的效果，通过将思考过程封装为结构化对象（含steps和output字段），提升模型表现。

## 大纲

1. 结构化输出与工具调用的意义
2. OpenAI API 结构化输出的实现与抓包分析
3. LangChain 中的便捷封装与对比
4. 结构化输出实现 CoT 技巧与总结

## 正文

### 1. 结构化输出与工具调用的意义

亲爱的朋友们，大家中午好。今天我们继续回到modern AI agents这个系列里面。在讲更复杂的AI agents的开发和应用之前，我们这期介绍一个非常非常基础、非常非常实用的功能，就是所谓的结构化输出，structured output和这个function tool。其实很多人我觉得对这个就这两个接口还是有很多误解哈，就是本质上它本质上调的是OpenAI的API，然后OpenAI的API呢是一个HTTP请求。这期我们就是看一下这两个请求，它本质上是长什么样子，在HTTP请求层面，我们对它做一次抓包分析，简单的抓包分析。

然后它更多的意义在于就是说，第一呢，如果我们传了这样一个model，就是一个实例化的、格式化的一个model，Pydantic model，我们不需要在Prompt层面再去约定这个output formats，就可以省略很多TTS内容的一个解析，也不需要我们再去解析这个复杂的JSON去把它给实例化出来。同时包括function call的信息，我们也不需要显式地再把它给放到prompt里面，因为这个API层面已经做了这个事情，我们也不需要再去做复杂的output的一个解析。

因为这期我们基于的元木器开发的框架还是LangChain哈，因为LangChain我们再去调API，调GPT模型的时候，他走的是OpenAI API，OpenAI API本质上底层是走的HTTP请求。我们这一期呢，是在HTTP请求层面，我们看他到底在做什么样的事情哈。通过这种结构化输出，或者是tool的一个注入，我们某种意义上实现了一个接口的一个约定，就某种意义上是一个非常非常弱版的SDD，就是specification driven的development。

我们在构建复杂的agentic workflow的时候，我们通过这种结构化的输出的方式，我们去定义了module之间的接口的一个输入、输出的一个约定，自当的一个约定，这样极大的可以简化我们输入输出的解析和适配。他的一个底层的一个原因，就在于现在的大语言模型，它在结构化输出这块已经训的非常非常好了，可以省略掉非常多的人工的输入输出的一个解析。

### 2. OpenAI API 结构化输出的实现与抓包分析

好，首先我们还是回到这个OpenAI API，然后在这个结构化输出这里面，它核心是声明了这样一个response format的一个字段。好，假如说这个就我们定义了这个Pydantic model，他最终输出的时候就会把你再做一次解适配的话，是可以把它给实例化出来的，这是OpenAI的API。我们简单看一下，我们测试一下哈。

我就是我们先测试一下这个open下，等一下，然后好，我们看一下哈，我们声明了这样一个Pydantic model，我们希望它response的时候是按这个model的一个字段来输出，它最终是个JSON哈。他这个里呢我们可以看一下哈，假如说我们定义这样一个Pydantic model，它我们可以通过这种方式，就是这一个排列model，这个model点JSON点schema就把它给识别出来，他最终送到HTTP请求里边，就是这样一种方式哈。

我们是我们去跑一下这个代码，好我们看，因为我做我看第一次请求他这个response format，他最终他虽然传的是这样一个model，但是它实例化出来是这样一种形式，就是我们刚看到的就是我们刚看到这个就通过这种方式哈，model点JSON schema的方式把它给注入到这个请求里边。

我们不需要在大家注意哈，我们有了这样一个这个JSON format一个注入之后，我们就不需要在Prompt层面里边去告诉他你要怎么去，你要你需要哪些字段。

你要提取什么样的信息，不需要那个output prompt，好，这是一点好。然后他的这个tool呢是通过这个tool这个字段给放放到这个请求里边。当然他这个tool呢是比较复杂哈。其实我们我们用这个LangChain他这个tool的这个工具，这个注解工具，我们注册注册一个一个Python的一个function，我们也可以通过这种方便的接口哈，convert to OpenAI tool，把它变成请求体里边。他这种呃相对格式化的复杂的一个JSON的一个算算，是某种意义上的一个呃一个约定吧。

然后因为我们刚跑的哈，我们除了跑了这个结构化输出之外，我们还跑了function call tool，我们这两个tool哈，这是add和这个乘哈，是我们通过这个LangChain的这个tool这个注解工具，注解注册的两个两个tool哈，同样的我们放到这个tool这个字段里边，然后这就其他就不说了，就不用说了哈。因为这个地方看，我们这个tools是比较按照约定的，把它给放进去的。那最终呢这个呃他去调的，他是他是有这个呃function call的这个这个实例化的内容的，这是OpenAI的API层面。

### 3. LangChain 中的便捷封装与对比

然后进一步呢有了这LangChain之后，我们就可以把更，我们就可以用我们去实验一下哈，好好我们就实例化这个哦。对我刚漏了一点哈，就是我们在实例化这个语言模型client的时候，我们要把我们这个这个HTTP请求的这个工具哈，抓包的工具呃，给放到这个实例化这个模型的时候，放到这个a HTTP client这个字段里边啊，这是一点哈。然后我们看我们这个long chain的这个，它就更简单了，呃，我们这里边定了一个panic model是item，有这个title和year，然后我们通过几种方式哈，我们通过几种方式都可以去完成这个structure的output，他我们我们去我们去调一下它，本质上好稍等哈。

看大家可以看到了，他他请求的时候还是这个response format，它是实例化这个a response format这个字段，但如果哈这个jason schema哈，是是是是是是对齐到这个item这个语义层面，就是字段层面。然后function calling呢我们可以看到他走的是tooth，他是把他给放到tools里边看，大家可以看到哈，呃这个这个该怎么理解呢？其实某种意义上，这个item呢我们实例化一个类的时候，其实是某种意义上是一个function，就是就是item这个去掉这个什么叉叉叉叉叉叉，它是某种意义上也是一个function。

这里边long chain走的更远的一步哈，就是说这个structure的它直接这个out out，它直接就是一个PDC的一个实例化对象。对于open i的API呢，我们还要把它给实例化出来，我们要基于他的输出，再把它给实例化出来。然后long chain又又走了一步，就更加自动化了，就是我们拿到这个out就是一个item，一个对象。好呃，对JSONCHEMA是走的是response for mates，Function calling走的是tooth，那那剩下的就是bon tooth，他就自然而然他就是一个他走的就是tooth，那个API的一个字段。我们再跑一下这个这个代码，大家可以看到哈，他走的是tooth这个字段。

### 4. 结构化输出实现 CoT 技巧与总结

好额以上就基本上就是本期的全部内容哈，这里边我就不再展开讲了哈。然后这里边我其实想讲几个事情哈，就是就这里边我当时看这个open i API的时候，其实我觉得我们通过这种结构化的输出呢，我们可以实现一个COT的一个功能，就是我们把这个思考过程呢，封装成一个pandemic的一个结构化输出一个对象，就比如这里边有一个steps，steps的话，就是解释和这个output，就是我们通过结构化输出，可以约定实现一个coo t的一个效果。

那这样，自然可以比较大的去提升这个模型的一个表现啊，这是一个非常非常实用的一个原模型使用的一个技巧哈。

就是当然我们可以叠加这样一个实例呃，结构化输出去实现这样一个ZOT哈。

以上就是本期的全部内容哈，那最后就是感谢大家看到这里哈。

就是我们这个这这几个付费系列呢，有有对应的一个私有的一个GITHUB工程哈，就大家如果有代码需求的话，因为我是会不断的update这个这个这个私有的代码仓库的，大家如果有代码需求的话，一定在后台私信我，你的GITHUB的id，我把大家压到邀请到这个项目里边来。