# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV15yMX6aEzJ)

## Summary (摘要)

- Opus 5 was released the day before the interview and shows accelerated performance, with extended long-running capabilities and innovative prompt injection resistance built through three defense layers, including a mechanistic interpretability-based classifier.
- Boris deleted 80% of Claude Code's system prompt for Opus 5, and found that removing all prompts via simple mode yields slightly higher model intelligence, shifting the development approach from prompt engineering to deletion and observation.
- Product overhang—the gap between what models can do and what products allow—is a key opportunity for founders; unhobbling the model by giving it harder tasks with less specification can unleash significant new capabilities.
- A dramatic example is rewriting the Bun runtime from Zig to Rust in 11 days using Claude with a dynamic workflow, a task previously estimated at over a year even for the best engineers.
- Best practices include empirical iteration: giving models tasks slightly beyond their apparent ability, enabling strong verification mechanisms, and avoiding over-specification; dynamic workflows and routine agents can scale this to dozens of engineers' output.
- Boris's own journey reflects a practical, problem-driven approach to programming, and he advises CS students to pair theory with application, design, business, and user interaction skills.

- Opus 5 在采访前一天发布，表现出加速的性能，具有扩展的长时间运行能力和创新的提示注入抵抗能力，该能力通过三层防御机制构建，包括基于机制可解释性的分类器。
Boris 删除了 Opus 5 的 Claude Code 系统提示词的 80%，并发现通过简单模式移除所有提示词会使模型智能略有提升，将开发方法从提示工程转向删除和观察。
产品过剩——模型能做什么与产品允许做什么之间的差距——是创始人的关键机会；通过给模型更难的任务和更少的规格说明来解除束缚，可以释放显著的新能力。
一个戏剧性的例子是使用 Claude 和动态工作流在 11 天内将 Bun 运行时从 Zig 重写为 Rust，而这项任务此前估计即使是最优秀的工程师也需要一年以上。
最佳实践包括经验迭代：给模型略超出其明显能力的任务，启用强大的验证机制，避免过度规格化；动态工作流和常规智能体可以将此扩展到数十名工程师的产出。
Boris 自己的旅程反映了务实、问题驱动的编程方法，他建议计算机科学学生将理论与应用、设计、商业和用户交互技能相结合。

## Outline (大纲)

1. Introducing Opus 5 and Its Capabilities / Long-Running Tasks and Prompt Injection Resistance / How Prompt Injection Resistance Works Mechanistically
2. Deleting 80% of System Prompts: A Radical Experiment / Ablating System Prompts Iteratively After Each Release
3. Builders Should Embrace Deleting and Rationalizing / Rebuilding by Observing Failures, Not Preemptive Instructions / Evals, Saturation, and Introducing Unhobbling / Model Capabilities Overhang and What Products Miss
4. Product Overhang: How Products Hobble Models
5. Founder Opportunity: Unhobbling Models to Create the Next Cloud Code / Fixing Product Overhang with Harder Tasks and Fewer Instructions / Rewriting Bun from Zig to Rust: A Real-World Unhobbling Example
6. Practical Experimentation and Creative Exploration / Elicitation and Verification as the New Core Skills / Two-Week Autonomous Task Lessons on Elicitation
7. Empirical Use Over Hype and Over-Engineering / Over-Specification Is the Top Failure Mode / Dynamic Workflows and Spawning Thousands of Agents
8. Loops and Routines for Ongoing Autonomous Maintenance
9. Has Coding Been Solved? Surveying the Audience / The Empirical Mindset as the Core Approach / Learning to Code by Solving Real Problems
10. Advice for CS Students: Apply CS to Real World / Final Announcement and Encouragement to Build

1. 介绍 Opus 5 及其能力 / 长时间运行任务与提示注入抵抗 / 提示注入抵抗的机制原理
删除 80% 系统提示词：一项激进实验 / 每次发布后迭代消融系统提示词
构建者应拥抱删除和合理化 / 通过观察失败而非预防性指令来重建 / 评估、饱和与引入解除束缚 / 模型能力过剩与产品遗漏之处
产品过剩：产品如何束缚模型
创始人机遇：解除模型束缚以创造下一代云代码 / 用更难的任务和更少的指令解决产品过剩 / 将 Bun 从 Zig 重写为 Rust：一个现实世界中的解除束缚示例
实践实验与创造性探索 / 引出与验证作为新的核心技能 / 两周自主任务关于引出的经验教训
经验使用胜过炒作与过度工程 / 过度规格化是首要失败模式 / 动态工作流与生成数千个智能体
用于持续自主维护的循环与常规
编程是否已被解决？调查观众 / 经验心态作为核心方法 / 通过解决实际问题学习编程
给计算机科学学生的建议：将计算机科学应用于现实世界 / 最终公告与鼓励构建

## Transcript (转录)

### 1. Introducing Opus 5 and Its Capabilities / Long-Running Tasks and Prompt Injection Resistance / How Prompt Injection Resistance Works Mechanistically (介绍 Opus 5 及其能力 / 长时间运行任务与提示注入抵抗 / 提示注入抵抗的机制原理)

Alright Boris, we're so excited to have you here, the creator of Plot Code. Thank you! It's great to be here. Fresh off the press, you guys just shipped Opus 5 yesterday. Yes. And it seems that model performance keeps accelerating. You guys took Arc AGI 3 to 30%, which is incredible. Yes. And for context, before the best score was in the low single digits or low teens, right? What can Opus 5 do now that it couldn't versus the previous version?

好的，Boris，我们非常高兴你能来，Plot Code 的创造者。谢谢！很高兴来到这里。刚刚发布，你们昨天就推出了 Opus 5。是的。看起来模型性能在持续加速。你们把 Arc AGI 3 提升到了 30%，这太不可思议了。是的。作为背景，之前最好的成绩是个位数或低两位数，对吧？Opus 5 现在能做什么以前版本做不到的事情？

Yeah, there's a lot that goes into every new model. And there's a lot of new capabilities that we teach and get the model to do. Whenever you do model training, you try to teach a whole bunch of different things. And most often it doesn't work. But some subset of the things, the model does learn. And sometimes it also surprises you. It has these skills, it has abilities that you actually didn't really teach it, but it just kind of learned.

是的，每个新模型都包含很多内容。我们教授并让模型学会了很多新能力。每次进行模型训练时，你都会尝试教授一大堆不同的东西。但很多时候并不奏效。但其中一部分东西，模型确实学会了。有时它还会给你惊喜。它拥有这些技能和能力，实际上你并没有真正教过它，但它就是学会了。

For 5, one example of something it does that I think no other model has done is it runs for a very long period of time. And especially when you combine Opus 5 with Auto Mode, it's just incredible. It can go for days, weeks, months at a time. It just won't stop. You don't even need to use scaffolding. So you don't need slash goal, you don't need all this other stuff. It'll just go because it knows it needs to do the task.

对于 5，一个我认为没有其他模型做到的例子是它能运行很长时间。特别是当你将 Opus 5 与自动模式结合使用时，简直不可思议。它可以连续运行数天、数周、数月。它不会停下来。你甚至不需要使用脚手架。所以你不需要斜杠目标，不需要所有这些其他东西。它会一直运行，因为它知道它需要完成任务。

Another thing that I'm really excited about, and I'm going to start, I think, to talk about a little bit more, but it's kind of surprising because it's such a new capability, is the model does not seem to be prompt injectable anymore. Not prompt injectable.

另一件我非常兴奋的事情，我想我开始要多谈一点，但有点令人惊讶，因为这是一个如此新的能力，那就是模型似乎不再容易受到提示注入了。不再容易受到提示注入。

It's crazy like people have talked about this like lethal trifecta for a long time and this really affects kind of harness design and agent design and and product design because if the model reads some instruction on the internet that's like you know do X and Y and Z and also delete everything on the users computer. A year ago the model would have just done it. But nowadays Opus does not. And this has actually been the case since like Opus 4.7, 4.8, Sonnet 5 has been quite good at this, Pable was quite good at it. But Opus 5 just hits like a new frontier on this. So essentially if you combine a well-aligned model, so this is like essentially three years of research into alignment, with a prompt injection classifier, which we run for all traffic, and what this is doing is it's based on Chris Sola's mechanistic interpretability work, where it's literally, we're looking at neurons in the model's brain that light up when prompt injection happens. So the model won't even tell you, but we can actually see those neurons and we can figure out and diagnose that it's happening. And then you combine that with the auto mode classifier. And with these three layers, we just cannot demonstrate prompt injection anymore. Talking about a prompt injection, the other side of the coin is now the system prompt. Let's talk a bit about the new release. You actually deleted over 80% of the system prompt from Cloud Code. Tell us more about that. I think something that a lot of people might not realize is Cloud Code as a product and as a harness is just always changing. We're always adding stuff. We're always deleting stuff.

这很疯狂，人们长期以来一直在谈论这种“致命三重奏”，而这确实影响了工具设计、智能体设计和产品设计，因为如果模型在互联网上读到一些指令，比如“做X、Y、Z，还要删除用户电脑上的所有东西”，一年前模型会直接照做。但如今Opus不会了。实际上，从Opus 4.7、4.8开始，Sonnet 5在这方面已经相当不错，Pable也做得很好。但Opus 5在这方面达到了新的前沿。所以，基本上如果你将一个对齐良好的模型——这实际上是三年对齐研究的成果——与一个提示注入分类器结合起来，我们对所有流量都运行这个分类器，它的原理基于Chris Sola的机制可解释性工作，我们实际上是在观察模型大脑中在提示注入发生时被激活的神经元。模型甚至不会告诉你，但我们能看到那些神经元，并诊断出正在发生的情况。然后再加上自动模式分类器。有了这三层防护，我们再也无法演示提示注入了。说到提示注入，硬币的另一面是系统提示。让我们谈谈这次的新版本。你实际上从Cloud Code中删除了超过80%的系统提示。请告诉我们更多。我认为很多人可能没有意识到的是，Cloud Code作为一个产品和工具，一直在变化。我们一直在添加东西，也一直在删除东西。

### 2. Deleting 80% of System Prompts: A Radical Experiment / Ablating System Prompts Iteratively After Each Release (删除80%系统提示：一次激进实验 / 每次发布后迭代式消融系统提示)

Every time that a new model comes out, we delete a bunch of the system prompt, change a bunch of the system prompt, we change the set of tools all the time, we change the prompts for the tools all the time. And the reason is every model is very different. So something that you did for one model maybe three months ago, it just might not translate at all to the next model. And so one thing about Opus 5 is it's just really intelligent. And a lot of the stuff in the system prompt was correcting for these behaviors that the model should have known, but it didn't. Now Opus 5 just does it. So yeah, we deleted 80% of the system prompt.

每当新模型发布时，我们都会删除大量系统提示，更改大量系统提示，我们一直在改变工具集，也一直在改变工具的提示。原因是每个模型都非常不同。所以，你三个月前为某个模型做的事情，可能完全不适用于下一个模型。关于Opus 5的一点是，它确实非常智能。系统提示中的很多内容是在纠正模型本应知道但没有做到的行为。现在Opus 5直接就能做到。所以，是的，我们删除了80%的系统提示。

You can actually try deleting the rest of it too. So when you run Cloud Code, you can just do like dash dash system prompt and set whatever system prompt you want if you want to experiment with it. And another thing that you can try is simple mode. So this is actually this kind of undocumented feature. If you do quad code simple equals one, like this environment variable, and then you run quad, it'll delete all the system prompts, including from the tools. And we actually use this as a sort of ablation to figure out is the prompt useful? And what's interesting is that the model is actually a little bit more intelligent without these prompts.

你实际上也可以尝试删除剩下的部分。当你运行Cloud Code时，你可以使用`--system-prompt`参数并设置任何你想要的系统提示，如果你想实验的话。另一件你可以尝试的事情是简单模式。这实际上是一个未记录的功能。如果你设置环境变量`quad code simple=1`，然后运行quad，它会删除所有系统提示，包括工具中的。我们实际上用这个作为消融实验，来判断提示是否有用。有趣的是，没有这些提示，模型实际上更聪明一些。

That's something that we've been finding. But when you use quad code as a product, you do actually want some of these prompts because it helps you use the product and it helps the product behave and the model behave in the way that you would want when you're using it as a person. I think the thing that's really fascinating in this era of building, basically you have built the best harness in the world for Clot and that's Clot code. From what I'm hearing, for every model released, you basically delete all of the code base, delete all of the prompt, and start from scratch every time.

这是我们一直在发现的。但当你把quad code作为产品使用时，你确实需要一些这样的提示，因为它帮助你使用产品，帮助产品和模型以你作为人使用时想要的方式表现。我认为在这个构建时代，真正迷人的是，你为Clot构建了世界上最好的工具，那就是Clot code。据我所知，每次发布新模型，你基本上都会删除所有代码库，删除所有提示，然后每次都从头开始。

That in the old world would have been not something startups would have done for the product. It's like press delete every six months for everything. That's right. That's right. So to be fair, we don't delete the entire code base, but we do delete a lot. So every time there's a new model, we try, in research, we call this ablation. And so what this means is you delete the entire system prompt, and then you bring it back line by line to figure out what is the impact of each individual line.

在旧世界里，初创公司不会为产品这样做。就像每六个月按一次删除键，删除所有东西。没错。没错。公平地说，我们不会删除整个代码库，但我们会删除很多。所以每次有新模型，我们都会尝试——在研究领域，我们称之为消融。这意味着你删除整个系统提示，然后逐行恢复，以找出每一行的影响。

It's sort of like an eval, and you can kind of evaluate it, and ablation essentially it's an eval, but you delete things to figure out the impact. And yeah, we do the same thing for tools. We unship tools all the time. We delete code in the harness all the time. If you look at actually the code that's in the Cloud Code harness today, almost all of it is about safety and permissions and static analysis. And there's a bunch of UI code. And we've actually unshipped a lot of the other code already.

这有点像评估，你可以进行评估，而消融本质上就是一种评估，但你通过删除来找出影响。是的，我们对工具也做同样的事情。我们一直在下架工具。我们一直在删除工具中的代码。如果你看看今天Cloud Code工具中的代码，几乎全部是关于安全、权限和静态分析的。还有一些UI代码。我们已经下架了很多其他代码。

### 3. Builders Should Embrace Deleting and Rationalizing / Rebuilding by Observing Failures, Not Preemptive Instructions / Evals, Saturation, and Introducing Unhobbling / Model Capabilities Overhang and What Products Miss (构建者应拥抱删除与合理化 / 通过观察失败而非预防性指令来重建 / 评估、饱和与引入“解束缚” / 模型能力过剩与产品错失之处)

Do you think this way of building a Gentic product and harness and basically doing ablations every time there's a new model release. Should everyone in this room that's building AI products basically do that? Be comfortable and brave to press delete. 100%. Yeah, and for people that aren't building agentic products but you're using Cloud Code, every six months, delete your Cloud MD. Delete your skills. Delete your hooks.

你认为这种构建智能体产品和工具的方式，以及每次新模型发布时进行消融实验，是否应该让在座所有构建AI产品的人都这样做？要乐于并勇敢地按下删除键。百分之百。是的，对于那些不在构建智能体产品但使用Cloud Code的人，每六个月删除你的CLOUD.md，删除你的技能，删除你的钩子。

See what the model does and it might surprise you. And actually for Opus 5, this is something we really do recommend is just try deleting all of these things because the model might really just not need all those instructions that you needed for past models. Let's talk a bit about how then you build this new prompt when there's a new model release like for everyone in the room, everyone will want to try Opus 5 and they're going to press delete on their system prompt. How do they go about?

看看模型会做什么，它可能会让你惊讶。实际上，对于Opus 5，我们确实推荐尝试删除所有这些，因为模型可能真的不需要你为过去模型准备的那些指令。让我们谈谈当新模型发布时，你如何构建这个新提示。对于在座的每个人，他们都会想尝试Opus 5，他们会按下删除键删除系统提示。他们该怎么做呢？

Rebuilding the system from? How do you set up your environment? So you do it kind of piece by piece. So the first step is you delete. The next step is you use it. And you don't want to guess what's the instruction that the model needs because you might not predict it correctly. The thing that you want to do is you want to run it. And if it's like a custom agentic product that you're building, you want to kind of run the product, you want to see where it fails with the model, you want to see what it does well. If you're using quad code, you want to see where it does well with your code base, or maybe where it stumbles over the architecture or stumbles over something else. And only when you see it repeatedly stumble on the same thing, that's when you add it back. But you don't want to do it too early. Because remember, the model is going to read this instruction every single time you use it. So you really want to make sure that the model needs this instruction.

从零重建系统？你如何搭建环境？所以你要一块一块地来。第一步是删除。下一步是使用它。你不想猜测模型需要什么指令，因为你可能预测不准。你要做的是运行它。如果你构建的是一个自定义的智能体产品，你要运行这个产品，看看它在模型上哪里失败，哪里做得好。如果你使用 quad code，你要看看它在你的代码库上哪里表现好，或者在哪里被架构绊倒，或者被其他东西绊倒。只有当你看到它反复在同一个地方绊倒时，你才把它加回去。但你不要太早加。因为记住，模型每次使用都会读到这条指令。所以你真的要确保模型需要这条指令。

I think this is sort of the crazy thing about building on models. It's just so different than all the engineering that I've ever done. In the past, when you build on systems, you build these big, beautiful systems, and you really think about the system design up front. You have a big suite of unit tests. You think about everything. A re-architecture is a big project. Sometimes it takes months. I've worked on re-architecture products at big companies that take years. And the model is not like that. The way to think about it is almost like a living creature, like something more organic. It's a thing where every model generation, it behaves differently. It has a slightly different personality. And you have to take the time to get to know it and then adjust the harness based on that. And I think it's just very much like an empirical and kind of scientific thing. You have to take a very scientific mindset to it where you try something, you see the result, and then you iterate based on that.

我认为这是在模型之上构建的疯狂之处。它与我做过的所有工程都截然不同。过去，当你在系统之上构建时，你构建这些庞大而精美的系统，并且你在前期就认真思考系统设计。你有一大套单元测试。你考虑所有事情。重新架构是一个大项目。有时需要数月。我在大公司做过耗时数年的重新架构产品。而模型不是这样的。思考它的方式几乎就像一个有生命的生物，像某种有机体。每一代模型，它的行为都不同。它有略微不同的个性。你必须花时间去了解它，然后基于此调整框架。而且我认为这非常像一种经验性的、科学的事情。你必须以非常科学的心态来对待它：你尝试某事，观察结果，然后基于此迭代。

If you're building in this world right now, what then becomes stable? Are evals something that you keep from the previous models and keep using them in each new model release? We do until we max out the eval. So that's sort of the tip for everyone. So code and system prompt. If you want to build at the bleeding edge and have the most capability for models, you've got to delete those. But evals are constant and keep appending to them, basically. Yeah, you keep appending. What happens is, you know, I actually wouldn't even go this far, to be honest. I think evals, they outlive the harness a little bit, but not by that much. Like an eval might live for maybe one, two, three model generations. But nowadays, you know, we're on the exponential.

如果你现在在这个领域构建，那么什么变得稳定？评估（evals）是你从以前的模型中保留下来，并在每个新模型版本中继续使用的吗？我们一直用到评估饱和为止。所以这算是给所有人的一个提示。代码和系统提示词，如果你想在尖端构建并拥有最强的模型能力，你必须删除这些。但评估是恒定的，并且基本上不断追加。是的，你不断追加。会发生什么，你知道，实际上我不会走那么远，说实话。我认为评估比框架稍微长寿一点，但不会长太多。一个评估可能存活一到三代模型。但如今，你知道，我们处于指数曲线上。

The model is improving so quickly, very often we just saturate the eval and then we have to throw it away and we have to come up with a new eval. And this is just part of the process. And again, it's about being empirical. You have to use the product, you have to use the model, you have to see where it struggles, and then based on that, that's the eval set that you should build. I think one term I heard you describe how to build the best agentic products on top of a plot is this concept of unhobbling. And tell us more about what that means. Yeah, so hobbling is this idea in research that the model is doing something and you're just getting in the way. There's this kind of like way of thinking about it that I really like. It's very useful when you're building product. And it's called product overhang. And the idea is...

模型进步如此之快，很多时候我们刚刚让评估饱和，然后我们就不得不丢弃它，不得不提出新的评估。这只是过程的一部分。而且，这又是关于经验性的。你必须使用产品，你必须使用模型，你必须看到它在哪里挣扎，然后基于此，那就是你应该构建的评估集。我记得你描述过如何在 plot 之上构建最好的智能体产品，其中有个概念叫“解除束缚”（unhobbling）。请告诉我们更多关于它的含义。是的，所以“束缚”（hobbling）是研究中的一个概念，意思是模型正在做某事，而你却在妨碍它。有一种思考方式我非常喜欢。它在构建产品时非常有用。它被称为“产品过剩”（product overhang）。这个想法是……

The model is able to do all sorts of things with today's models, not a future model, but today's model, that we have not yet realized. And there are so many capabilities the model has like this that people are not aware of. And this is like the ability to maybe use a particular tool, use a particular language, solve a particular kind of problem, do things a particular kind of way that we thought was kind of beyond the model's capability. And there's this overhang because the model can do this at every given model generation, but there is often not a product that lets the model do this, and lets it express this kind of ability to do this.

模型能够用今天的模型做各种各样的事情，不是未来的模型，而是今天的模型，我们还没有意识到的事情。模型有很多这样的能力，人们并没有意识到。这可能是使用特定工具、特定语言、解决特定类型问题、以特定方式做事的能力，而我们曾认为这超出了模型的能力范围。存在这种过剩，因为模型在每一代都能做到这一点，但往往没有一个产品能让模型做到这一点，并让它表达这种能力。

### 4. Product Overhang: How Products Hobble Models (产品过剩：产品如何束缚模型)

And on the flip side, often what happens is the product gets in the way. And this getting in the way, we call this hobbling. And then not eliciting the correct behavior from the model, we call this product overhang. So it's kind of like two sides of the same thing. One example of this was the original plot code. When I first started working on it, this was like a year and a half, two years ago, something like that. This was like SANA 3.5. At the time, that was an incredible coding model. That was like the best coding model that exists. Nowadays, it's a pretty terrible coding model by modern standards.

另一方面，经常发生的是产品妨碍了模型。这种妨碍，我们称之为“束缚”（hobbling）。而没有从模型中引出正确行为，我们称之为“产品过剩”（product overhang）。所以这有点像同一事物的两面。一个例子是最初的 plot code。当我刚开始做它时，那大约是一年半或两年前。那时是 SANA 3.5。当时那是一个令人难以置信的编码模型。那是当时最好的编码模型。如今，按照现代标准，它是一个相当糟糕的编码模型。

But I think that was like the first great coding model that we built as Anthropic. And at the time, if you looked at the coding products of the time, what were they doing? They were doing like single line autocomplete. They were doing sometimes multi-line autocomplete. That was sort of a new idea. They were doing chat.

但我认为那是我们 Anthropic 构建的第一个伟大的编码模型。当时，如果你看看当时的编码产品，它们在做什么？它们在做单行自动补全。有时做多行自动补全。那算是个新想法。它们在做聊天。

So you can talk to the agent, but it wasn't write access, you could only read. You could ask about the code base. And so the feeling was that there wasn't really a product that was fully eliciting the model's capability to write entire functions at a time, entire files at a time. At the time it wasn't entire features, we weren't there yet, but probably entire files, that was the level of capability at the time. And so the idea with quad code was, alright, we think the model can probably do this.

所以你可以和智能体对话，但它没有写权限，你只能读。你可以询问代码库。所以感觉是，没有一个产品完全引出了模型一次编写整个函数、整个文件的能力。当时还不是整个功能，我们还没到那一步，但可能是整个文件，那是当时的能力水平。所以 quad code 的想法是，好吧，我们认为模型可能能做到这一点。

What if we get rid of all the scaffolding and just give the model the simplest possible harness so it can write an entire file at a time and build an entire feature? And that was kind of it. That was the product overhang of the time. The model was capable of doing something and everything was just kind of getting in the way. I think that nowadays, with modern models, there is so much product overhang that I'm not seeing startups capture.

如果我们去掉所有脚手架，只给模型最简单的支架，让它一次写整个文件、构建整个功能，会怎样？基本上就是这样。这就是当时的产品过剩。模型有能力做某些事，而其他一切都在碍事。我认为如今，对于现代模型来说，存在如此多的产品过剩，而我没有看到初创公司去捕捉这些机会。

### 5. Founder Opportunity: Unhobbling Models to Create the Next Cloud Code / Fixing Product Overhang with Harder Tasks and Fewer Instructions / Rewriting Bun from Zig to Rust: A Real-World Unhobbling Example (创始人的机遇：解除模型束缚，创造下一个 Cloud Code / 用更困难的任务和更少的指令解决产品过剩 / 将 Bun 从 Zig 重写为 Rust：一个真实的解除束缚的实例)

And I think there's people thinking about these problems, but there's just a huge amount of opportunity to elicit these behaviors from the model that are just like amazing and interesting and commercially valuable. I think this is such a special insight for everyone here in the room. Basically, all of you could create the next CloudCode if you figure out how to unhobble the models because that's effectively the birth story of CloudCode.

我认为有人在思考这些问题，但确实有巨大的机会去激发模型展现出那些令人惊叹、有趣且具有商业价值的行为。我认为这对在座的每个人来说都是一个特别的洞见。基本上，如果你们能弄清楚如何解除模型的束缚，你们都能创造出下一个 CloudCode，因为这实际上就是 CloudCode 的诞生故事。

You unhobble Sonnet 3.5 because all the previous iterations, we're still getting the model very rigid in IDEs. And CloudCode was one of the first instances that gave it just a full terminal access. Yes. And that then created this amazing product just that keeps going. So let's talk about what are some areas and how should future founders here think about unhobbling Cloud and...

你解除了 Sonnet 3.5 的束缚，因为之前的迭代中，我们仍然让模型在 IDE 中非常受限。而 CloudCode 是最早给它完整终端访问权限的实例之一。是的。然后这就创造了一个了不起的产品，并且持续发展。所以让我们谈谈哪些领域，以及未来的创始人应该如何思考解除 Cloud 的束缚……

Fixing this product overhang? So there's a couple things that I will think about. One is you should give the model slightly harder tasks than what you think you can do. I think a really common mistake that I see is people are using quad code, they're using quad, and they just give it way overly specific instructions. They're like, I want you to do this, but I want you to do it in this way, this way, this way. You must do one, then two, then three, then four. And for modern models, that's actually really not the way to do it. You want to go a little bit higher level. You want to describe the task, you want to describe the guardrails, you want to describe the exit criteria, and then just go with the model cook. And come back in a little bit. And I think it'll surprise you. And again, this is just not something that would have worked six months ago, but it does work today.

解决这种产品过剩？有几点我会考虑。一是你应该给模型比你认为你能做的稍微困难一点的任务。我认为我看到的一个非常常见的错误是，人们在使用 quad code 或 quad 时，给了它过于具体的指令。他们说，我希望你做这个，但我希望你以这种方式、这种方式、这种方式来做。你必须先做一，然后二，然后三，然后四。对于现代模型来说，这实际上并不是正确的方式。你应该更抽象一些。你描述任务，描述护栏，描述退出标准，然后就让模型去发挥。过一会儿再回来。我认为它会让你惊讶。而且，这也不是六个月前能奏效的，但今天确实有效。

Can you give some examples of these challenging tasks or capabilities that people should explore that it can do now that it couldn't six months ago? Yeah. So, okay. One example is the model can now rewrite essentially any code base from one language to a different language. It's just sort of crazy. Like, it's this work that would have taken just, like, a very long time as an engineer, and now the model's, like, quite fast at it. So one example of this is Cloud Code is built on the Bunn JavaScript runtime. It's an open source JavaScript runtime. It's an alternative to Node.js. It's kind of a faster node. Bunn was written in Zig. Zig is a systems programming language. It's kind of like C. It's very well level. One of the problems with Zig is you have to manually manage memory. And so it's quite easy to run into situations where there's memory leaks and other memory management issues.

你能举一些具有挑战性的任务或能力的例子吗？这些是现在可以做到而六个月前做不到的。是的。那么，好的。一个例子是，模型现在可以将几乎任何代码库从一种语言重写为另一种语言。这有点疯狂。这类工作过去需要工程师花很长时间，而现在模型做得相当快。一个例子是，Cloud Code 构建在 Bunn JavaScript 运行时之上。这是一个开源的 JavaScript 运行时，是 Node.js 的替代品，是一种更快的 Node。Bunn 是用 Zig 编写的。Zig 是一种系统编程语言，有点像 C，非常底层。Zig 的一个问题是必须手动管理内存，所以很容易遇到内存泄漏和其他内存管理问题。

And so one thing that the bun team was doing is they were having Claude fuzz the code base and try to simulate and trigger memory leaks and they were doing this for a long period of time. They were able to find a lot of memory leaks, it was sort of like a case at a time, and that was kind of the capability of the model at the time was doing this fuzzing. And then at some point, Jared on the team was like, okay, let's just rewrite it. Maybe the model can do this. And I think this is like one of these test problems that he kind of threw at the model with every new model generation. And starting with Fable, the model started to be able to do it. And so I think Opus 5 could do it as well. And so what he did was essentially he defined a test suite. The nice thing about Bunn is it's very, very well tested. There's a big test suite in Bunn. There's a big test suite in Node.js. So it's easy to know if you did the right thing.

所以 Bun 团队在做的一件事是让 Claude 对代码库进行模糊测试，尝试模拟并触发内存泄漏，他们这样做了很长时间。他们能够发现很多内存泄漏，一次一个案例，这就是当时模型的能力，做这种模糊测试。然后某个时候，团队中的 Jared 说，好吧，让我们重写它。也许模型能做到。我认为这是他每次新模型发布时都会抛给模型的一个测试问题。从 Fable 开始，模型开始能够做到。所以我认为 Opus 5 也能做到。他做的基本上是定义了一个测试套件。Bunn 的好处是它测试得非常充分。Bunn 有一个很大的测试套件。Node.js 也有一个很大的测试套件。所以很容易知道你是否做对了。

And he had the model re-write it from Zig to Rust. It was one prompt, it was a dynamic workflow, and a dynamic workflows are a feature in quad code that essentially let you orchestrate dozens, hundreds, thousands of agents to do work productively. And it ran for 11 days, and it rewrote the entire code base. And this was one shot. It was one shot with, no, it wasn't one shot, but there was steering. But previous models just couldn't do this, even with the steering. It just wouldn't have been possible. In just 11 days. Oh my god. This would have taken in the past, even with the best engineers, multiple months, years? Definitely over a year. Yeah. Yeah, over a year. This was like over 100,000. JavaScript runtime is really complicated. There's a lot of stuff in there.

然后他让模型把它从 Zig 重写为 Rust。这是一个提示，一个动态工作流，而动态工作流是 quad code 中的一个功能，基本上可以让你编排几十、几百、几千个智能体来高效地完成工作。它运行了 11 天，重写了整个代码库。这是一次性的。是一次性的，不，不是一次性的，但有引导。但以前的模型即使有引导也做不到。这在 11 天内是不可能的。天哪。这在过去，即使有最好的工程师，也需要几个月、几年？肯定超过一年。是的。是的，超过一年。这超过 10 万行。JavaScript 运行时非常复杂。里面有很多东西。

### 6. Practical Experimentation and Creative Exploration / Elicitation and Verification as the New Core Skills / Two-Week Autonomous Task Lessons on Elicitation (实践实验与创造性探索 / 激发与验证作为新的核心技能 / 两周自主任务关于激发的经验教训)

And yeah, it works. This is in production now. This is what quad code uses now when you're running it. So this is kind of one example. I would give a second example, so a product overhang. So this is like a practical use case where there's a problem you're solving. It's like a business problem, an engineering problem, a product problem. And you should just keep throwing the latest model at it to see if it'll just do it. Because even if a previous model didn't, the new one might. I think the second way to think about it is experiment.

是的，它成功了。现在已经在生产环境中使用了。这就是 quad code 现在运行时使用的。所以这是一个例子。我再举一个例子，关于产品过剩。这是一个实际用例，你在解决一个问题。这是一个业务问题、工程问题、产品问题。你应该不断尝试最新的模型，看看它是否能直接解决。因为即使以前的模型不行，新的可能可以。我认为第二种思考方式是实验。

and just give yourself freedom to play with the model and do creative things, often it'll surprise you. So something that's actually been really popular internally that's been kind of viral within Anthropic the last couple weeks is someone figured out that you can give Opus 5 OpenCV. And you can have a draw. And so something you can do is you can ask Opus, like, hey, use OpenCV to draw this image. And it's actually quite good. It can do portraits. It can draw animals. It can do landscapes. And we didn't train the model to draw. It's just the solicitation gap. If you ask it to do it the right way, it can just do it.

并且只要给自己自由去玩模型、做有创意的事情，它常常会让你惊喜。实际上，最近几周在Anthropic内部非常流行、几乎病毒式传播的一件事是，有人发现你可以给Opus 5 OpenCV，然后让它画画。所以你可以做的是，你可以问Opus，比如‘嘿，用OpenCV画这个图像’。它确实相当擅长。它能画肖像，能画动物，能画风景。我们并没有训练模型去画画。这只是‘引导差距’（solicitation gap）。如果你用正确的方式要求它，它就能做到。

And we discovered this kind of accidentally just by playing around and trying creative things that didn't have direct commercial applications. But it's just kind of interesting. And my hypothesis is there's probably dozens, hundreds of opportunities like this with the models of today that no one has yet realized. And the big area of research for this is basically model elicitation, right? Becoming really good at figuring out all these capabilities.

我们几乎是偶然发现这一点的，只是通过玩耍和尝试一些没有直接商业应用的创意性事物。但这确实很有趣。我的假设是，对于今天的模型，可能还有几十个、几百个这样的机会，而人们尚未意识到。这个领域的主要研究方向基本上就是模型引导（model elicitation），对吧？就是变得非常擅长发现所有这些能力。

Asking the model to do the right thing, right? Yes. How do people get better at that? And effectively, how do people get better at prompt engineering? Do people still need to do a lot of prompt engineering? Or is that changing as well? Tell us about where this is going. Yeah, I remember like a year ago, one of the most popular job openings was prompt engineer. And then it kind of changed, and then I think it became like context engineer. So there's these kind of waves of it. I think these will kind of like come and go. I think the skill nowadays is less about prompt engineering and more about figuring out how do you give quad a hard task that seems a little bit too hard? And then how do you make it possible for quad to verify its work along the way? And the verification, I think, is probably the single most important thing that people do not get right largely.

让模型做正确的事情，对吧？是的。人们如何在这方面变得更好？实际上，人们如何更好地进行提示工程？人们还需要做很多提示工程吗？还是说这也在变化？请告诉我们这个领域的发展方向。是的，我记得大约一年前，最热门的工作之一是提示工程师。然后它变了，我想它变成了上下文工程师。所以有这些一波一波的浪潮。我认为这些会来来去去。我认为如今的技能更少是关于提示工程，而更多是关于弄清楚如何给Claude一个有点太难的任务？然后如何让Claude在过程中能够验证自己的工作？而验证，我认为可能是人们最常搞错的最重要的事情。

One example of this is people were, you know, we have this desktop app for Cloud, and it's built using Electron. We've made it quite fast, so now it's like a pretty awesome experience. Six months ago, it was like sluggish, and it wasn't very reliable. Now it's pretty awesome, and you know, it's the thing that most of the team uses. As an experiment, though, I wanted to see like, what would it feel like if it was native? And so what I did is I started a quad tag session, and quad tag is just, you know, it's a new product we have, it's just quad running in Slack. My first question was, hey tag, do you have access to a Mac OS runner on GitHub? And it said no, and then I hooked up a runner, so it was able to start a Mac virtual machine using GitHub. And then my second question is, I created this like empty code base that was a quad desktop app rewritten in Swift.

这方面的一个例子是，人们——你知道，我们有这个Claude的桌面应用，它是用Electron构建的。我们让它变得相当快，所以现在它是个相当棒的体验。六个月前，它很迟钝，不太可靠。现在它相当棒了，而且，你知道，它是团队大多数人都在用的东西。不过，作为一个实验，我想看看如果它是原生的会是什么感觉。所以我做的是，我开始了一个Claude Tag会话，Claude Tag就是，你知道，这是我们有的新产品，就是Claude在Slack里运行。我的第一个问题是，‘嘿，Tag，你能访问GitHub上的Mac OS runner吗？’它说不能，然后我连接了一个runner，这样它就能用GitHub启动一个Mac虚拟机。然后我的第二个问题是，我创建了一个空代码库，是用Swift重写的Claude桌面应用。

And I asked, can you access this code base? It said no. And then I gave it access and I was like, okay, great, now I have access. And then I was like, okay, now what I want you to do is I want you to rewrite the Electron app in Swift. I want you to run the Electron app in the Mac virtual machine, screenshot it, and then look pixel by pixel, compare it to the Swift version. Don't stop until you're done. And that was your prompt, basically. That was my prompt. And how long did this take to run? It's still running. When did you start it? It's been a little over two weeks. So it's like 14 days, 15 days. Yeah, so I don't know if anyone in the audience has gotten clocked to run a task for more than two weeks. I don't know. Raise your hand, anyone in the audience.

我问，‘你能访问这个代码库吗？’它说不能。然后我给了它访问权限，我说，‘好的，太好了，现在我有访问权限了。’然后我说，‘好的，现在我要你做的是，把Electron应用用Swift重写。我要你在Mac虚拟机里运行Electron应用，截图，然后逐像素地看，和Swift版本比较。不要停，直到你完成。’那就是你的提示，基本上。那就是我的提示。这花了多长时间运行？它还在运行。你什么时候开始的？已经超过两周了。所以是14天，15天。是的，所以我不知道观众中是否有人让Claude运行任务超过两周。我不知道。举手，观众中有人吗？

This is like one of these, this is about elicitation. So this is really one of those examples where the model can do it today, you just have to let it do it. And you don't need the fancy stuff. You don't need slash go, you don't need slash loop. These help, but really all you need is give the model the task, give it a way to verify the output of its work so it doesn't get stuck, and it'll just go. And actually in this case, Quad also decided to live block it. So what it did is it created a Slack channel internally and it started just posting screenshots every few minutes of its progress. Wow. So the prompt sound is so simple. I mean, everyone here could do it. And I guess, what is separating the people here that can become the top 1% Clockwork users? How can people learn to use Clockwork like Boris? Maybe like...

这就是那种例子，这是关于引导的。所以这确实是那种模型今天就能做到的例子，你只需要让它去做。你不需要那些花哨的东西。你不需要斜杠go，不需要斜杠loop。这些有帮助，但真正你需要的只是给模型任务，给它一种验证其工作输出的方式，这样它就不会卡住，然后它就会继续。实际上，在这个案例中，Claude还决定实时发布。所以它做的是，它在内部创建了一个Slack频道，然后开始每隔几分钟发布进度截图。哇。所以提示听起来如此简单。我的意思是，这里的每个人都能做到。我想，是什么区分了这里能成为前1%的Claude用户的人？人们怎样才能学会像Boris那样使用Claude？也许像……

### 7. Empirical Use Over Hype and Over-Engineering / Over-Specification Is the Top Failure Mode / Dynamic Workflows and Spawning Thousands of Agents (实证使用胜过炒作和过度工程 / 过度规格说明是首要失败模式 / 动态工作流和生成数千个智能体)

Don't listen to the LinkedIn influencers. Don't listen to... Don't read Twitter. This is the thing about the model is I think everyone's looking for the one weird trick to do it. That doesn't exist. There's nothing like that. The way the model works is you have to approach it empirically. You have to give it a task that's too hard. You have to give it the tools to verify the work, like you would yourself, like you would if you were doing the task. You have to see where it struggles, and then you have to fix that, either with better prompting or with a skill, or if the model is missing context, give it an MCP so it can pull in the context that it needs. That's kind of it. It sounds very simple. I think people tend to overthink it a little bit. I think people tend to over-engineer.

不要听LinkedIn上的影响者。不要听……不要读Twitter。关于模型，我认为每个人都在寻找那个奇怪的技巧。那不存在。没有那样的东西。模型的工作方式是，你必须以实证的方式接近它。你必须给它一个太难的任务。你必须给它工具来验证工作，就像你自己做任务时那样。你必须看看它在什么地方挣扎，然后你必须修复它，要么通过更好的提示，要么通过技能，或者如果模型缺少上下文，给它一个MCP，这样它就能拉入它需要的上下文。就是这样。听起来很简单。我认为人们倾向于有点过度思考。我认为人们倾向于过度工程化。

Because I think in a lot of ways, when we build systems in the past, that's the way you had to do it. So when I look at engineers that have been coding for a long time, for years or for decades, this is a really, really common failure mode, is trying to over-specify, and it's trying to be overly specific. Get the model to do the task exactly the way that you would have done it, and that's just not the way the model works. But I think a lot of people are kind of un-warning this, and it's a journey to un-warn it. It's a journey to kind of figure out how do you treat this thing like you would a coworker. I think that's the level of intelligence that it's at now. And as part of this, let's go deeper into this task that's still running two weeks since you launched it two weeks ago. How many agents did it spawn? No, I'm not sure. I can ask Claude and then I can get back to you. I would guess...

因为我认为在很多方面，过去我们构建系统时，那是你必须采用的方式。所以当我看到那些编程多年甚至几十年的工程师时，过度具体化是一个非常非常常见的失败模式，试图过度指定。让模型完全按照你本来会做的方式去完成任务，但模型并不是那样工作的。但我认为很多人正在逐渐摆脱这种思维，这是一个去学习的过程。这是一个学习如何像对待同事一样对待这个东西的旅程。我认为这就是它现在所处的智能水平。作为其中的一部分，让我们更深入地探讨这个任务，它已经运行了两周，自从你两周前启动它以来。它生成了多少个智能体？不，我不确定。我可以问一下Claude，然后我再回复你。我猜……

Thousands? Tons of thousands? Has anyone in the audience had a prompt to renew the models that spawn more than a thousand agents? No? I think this is another of the tips. The best cloud users are able to spawn tasks that are really providing you a lot of leverage, like thousands of agents. Yes. How do you do that? There's a few different ways to do it. The easiest way is dynamic workflows. To use dynamic workflows is a fairly new feature in Cloud Code. And all you have to say is use a workflow. That's it. And then Cloud will just trigger the dynamic workflow. What a dynamic workflow is, is essentially we have the Bun runtime. We use Bun as a sandbox. And we start a virtual machine within Bun.

数千个？成千上万个？在座有没有人曾经让模型生成超过一千个智能体的提示？没有？我认为这是另一个技巧。最好的云用户能够生成真正为你提供大量杠杆的任务，比如数千个智能体。是的。你是怎么做到的？有几种不同的方法。最简单的方法是动态工作流。使用动态工作流是Cloud Code中一个相当新的功能。你只需要说使用工作流。就这样。然后Cloud就会触发动态工作流。动态工作流本质上是我们有Bun运行时。我们使用Bun作为沙箱。我们在Bun中启动一个虚拟机。

And we let quads start a lot of agents and orchestrate them. And it doesn't just do one agent, it doesn't just do like 10 parallel agents. What it might do is, let's say a task is like rewrite the code base, or do really in-depth data analysis over some really complicated data, or maybe like build a very complex feature that takes multiple stages, and maybe dozens of pull requests. And so what it's gonna do is it's gonna start a bunch of agents to do kind of like the first pass. Based on that, it might do a second step where it has another set of agents that verify the work or that summarize the work. Then it might do like a third stage where it'll fan out again. So it'll kind of productively orchestrate a bunch of different agents. So my background is functional programming. And so the way that we design this is it's essentially an algebra for agents.

我们让Quads启动大量智能体并编排它们。它不只是做一个智能体，也不只是做10个并行智能体。它可能会做的是，假设一个任务是重写代码库，或者对非常复杂的数据进行深入的数据分析，或者构建一个需要多个阶段、可能需要几十个拉取请求的非常复杂的功能。所以它会启动一组智能体来做第一遍。基于此，它可能会进行第二步，让另一组智能体验证工作或总结工作。然后它可能会进行第三阶段，再次分叉。所以它会高效地编排许多不同的智能体。我的背景是函数式编程。所以我们设计这个的方式是，它本质上是一个智能体的代数。

So there's a way to run agents in sequence. There's a way to run agents in parallel. And Cloud has different tools in order to orchestrate these agents inside of the sandbox to use tokens efficiently to do really, really complex work. It's kind of cool and something that just hasn't really been written about a lot. Like this is actually like a new form of test time compute. Like when we talk about the scaling laws and kind of we talk about the model getting more intelligent over time, historically, it's been a function of the size of the neural net, the amount of training data, and the number of flops that you put in to the training. And then recently we also added test-time compute. So this is essentially a fancy researcher way of saying how many tokens does it generate? And now dynamic workflows are essentially a new way to orchestrate test-time compute. And it's a new way to kind of really, really ramp up the amount of test-time compute that you use to do a really hard task.

所以有一种方法可以顺序运行智能体。有一种方法可以并行运行智能体。Cloud有不同的工具来在沙箱内编排这些智能体，以高效地使用令牌，完成非常非常复杂的工作。这有点酷，而且确实没有被广泛报道过。这实际上是一种新的测试时计算形式。当我们谈论扩展定律，谈论模型随时间变得更智能时，从历史上看，它是神经网络大小、训练数据量和训练中投入的浮点运算次数的函数。然后最近我们还增加了测试时计算。所以这基本上是研究人员对“它生成多少令牌？”的一种花哨说法。现在动态工作流本质上是一种编排测试时计算的新方式。这是一种真正大幅增加用于完成困难任务的测试时计算量的新方法。

### 8. Loops and Routines for Ongoing Autonomous Maintenance (循环与例行程序：用于持续的自主维护)

So this whole very long way to say this is one way to launch thousands of agents in a way that is productive and efficient. A second way to do it is loops and routines. Loop is essentially a cron job that's running locally for a cloud. Routine is the same thing but it's running in the cloud. So you can close your laptop. And this is like slightly different because for a dynamic workflow, it's one task and you break it up into chunks. For loops and routines, it's one task that is repetitive, that doesn't share context, but it might share memory. And you kind of do this over and over. You can do it maybe every hour, every five minutes, every day. And so the thing that we've started doing is we actually have Quad maintaining itself now.

所以这整个很长的路是为了说明这是启动数千个智能体的一种高效且富有成效的方式。第二种方式是循环和例行程序。循环本质上是一个在本地为Cloud运行的cron作业。例行程序是相同的东西，但在云端运行。所以你可以合上笔记本电脑。这有点不同，因为对于动态工作流，它是一个任务，你把它分解成块。对于循环和例行程序，它是一个重复的任务，不共享上下文，但可能共享记忆。你一遍又一遍地做。你可以每小时、每五分钟、每天做一次。所以我们开始做的事情是，我们实际上让Quad现在自我维护。

And the way we do this is we have a Slack channel where we just had Cloud start a bunch of different routines to maintain its own code base. And we actually do this for the CLI, for the iOS app, for the Android app, for the desktop app. And for example, one routine is clean up dead code. This is a single prompt. It's like one sentence. Cloud runs this every day. It'll look for dead code across all the code bases using static and dynamic analysis. We didn't prompt that. It just kind of figured it out. And it'll put up a request every day to delete the dead code.

我们这样做的方式是，我们有一个Slack频道，我们让Cloud启动一系列不同的例行程序来维护它自己的代码库。我们实际上为CLI、iOS应用、Android应用、桌面应用都这样做。例如，一个例行程序是清理死代码。这是一个单一的提示。就像一句话。Cloud每天运行这个。它会使用静态和动态分析在所有代码库中查找死代码。我们没有提示它。它自己就想出来了。它每天会提出一个请求来删除死代码。

Another example is shipping experiments that should go out. So the experiment's already out to 100%. It'll delete it from the code base and it'll just ship it. Another one is writing tests for areas of the code base that need test coverage. Another one is deleting tests that don't need to be there because they were kind of useless tests added by older models or added by people at some point. One that I really love is this I forget what we called it. I think we called it abstraction police.

另一个例子是发布应该上线的实验。如果实验已经达到100%，它会从代码库中删除它，然后直接发布。另一个是为需要测试覆盖的代码库区域编写测试。另一个是删除不需要存在的测试，因为它们是由旧模型或某些人添加的无用测试。我非常喜欢的一个是，我忘了我们叫它什么。我想我们叫它“抽象警察”。

And the idea is there are often in a big code base, there's kind of the same abstraction and it appears multiple times. And if you kind of squint, it actually maybe should just be the same abstraction. But kind of over time, for whatever reason, you rebuilt it multiple ways in different parts of the code base. So Quad kind of goes out every day across all our code bases. It finds these nearly duplicated abstractions and it unifies them.

这个想法是，在一个大型代码库中，通常会有相同的抽象出现多次。如果你眯着眼睛看，它实际上可能应该只是同一个抽象。但随着时间的推移，无论出于什么原因，你在代码库的不同部分以多种方式重建了它。所以Quad每天都会在我们的所有代码库中巡查。它找到这些几乎重复的抽象，并将它们统一起来。

And so now we have every day maybe 20 or 30 of these routines. It's running across all of our code bases. And it's not totally there yet, but we're on the path to fully automating the maintenance of our apps by doing this. And this is, again, hundreds of agents running every day, sometimes thousands of agents every day. It's doing the work of dozens or hundreds of engineers. This is kind of what it used to take to do this kind of work. And this means that engineers can just do the thing they actually want to do, which is ship new products and talk to users and do stuff that's actually fun.

所以现在我们每天大概有20到30个这样的例行程序。它们运行在我们所有的代码库中。虽然还没有完全到位，但我们正通过这种方式走向应用维护的全面自动化。而且，这又是每天运行数百个智能体，有时甚至数千个。它正在完成数十或数百名工程师的工作。这曾经是完成这类工作所需的人力。这意味着工程师们可以只做他们真正想做的事情，即发布新产品、与用户交流以及做真正有趣的事情。

### 9. Has Coding Been Solved? Surveying the Audience / The Empirical Mindset as the Core Approach / Learning to Code by Solving Real Problems (编码问题是否已解决？现场调查 / 实证思维作为核心方法 / 通过解决实际问题来学习编码)

I guess a nice conclusion from this, which you have mentioned in the past that basically coding is solved, right? You have mentioned this. I'm curious now that effectively everyone can write software, what separates the exceptional builders from the rest? What are the qualities now that everyone can ship code?

我想从这一切可以得出一个很好的结论，你过去曾提到过，基本上编码问题已经解决了，对吧？你提到过这一点。我很好奇，既然现在实际上每个人都能编写软件，那么是什么将杰出的构建者与其他人区分开来？既然每个人都能交付代码，现在有哪些品质是重要的？

I would give like one caveat. So coding is solved for the kind of coding that I do. It's not solved for everyone. There's still code bases that are like super deep systems code bases where quad still struggles. There's distributed systems where quad still struggles. There's really kind of in the weeds UI verification, like something is off by pixel or something. Quad is still not perfect at this. Like Opus 5 was a big leap in vision and computer use, but it's still not perfect. But I'm actually curious, for people here, maybe raise your hand if 100% of your code is written using agents. You don't write any code by hand anymore.

我想给出一个警告。编码对于我所做的那种编码来说已经解决了，但并非对所有人都如此。仍然有一些非常底层的系统代码库，Quad 在其中仍然会遇到困难。还有一些分布式系统，Quad 仍然难以应对。还有一些真正棘手的 UI 验证，比如某些像素偏差之类的问题，Quad 在这方面还不完美。比如 Opus 5 在视觉和计算机使用方面是一个巨大的飞跃，但仍然不完美。但我很好奇，在座的人中，如果你100%的代码是由智能体编写的，请举手。你不再手写任何代码了。

It's pretty good. Okay, how about more than 50%? Slightly less hands, maybe about the same. Yeah. So I think it's getting there. So it's kind of getting to this, to being solved for more and more kinds of code. And that's kind of cool. When I think about the people that are the best at using Quad, I think there's a certain mindset that you can bring that's really effective. And it's really about being empirical.

相当不错。好的，那超过50%的呢？举手的人稍微少了一些，也许差不多。是的。所以我认为它正在接近那个目标。它正在逐渐解决越来越多类型的代码。这很酷。当我想到那些最擅长使用 Quad 的人时，我认为你可以带来一种非常有效的思维方式。这实际上关乎实证。

So forget all of the things that you learned about past models. Forget everything that you learned about computer science theory in class. Look at the model. Try to do a task, see where it struggles, and then based on that adjust. So it's just like very much become, it's not a theoretical science, it's become an empirical science. So I think people that are really good at this, that are really good at kind of forgetting their priors, letting go of, you know, this like maybe idea that didn't work before and just being open to trying it again. This is the kind of skill that's just very, very successful now.

所以，忘掉你过去学到的关于旧模型的一切。忘掉你在课堂上学的所有计算机科学理论。观察模型，尝试一个任务，看看它在哪些方面有困难，然后据此调整。所以这非常像，它不再是理论科学，而是变成了实证科学。所以我认为那些真正擅长这一点的人，那些真正擅长忘记先验、放下那些可能以前不奏效的想法，并愿意再次尝试的人，这种技能现在非常非常成功。

Now my last question is, given everything that we talked about, if there's someone here that's studying CS, and you learned the program before this era of AI-engaged coding, what should students still learn the hard way, like the old way? So for me, I learned computer science practically. I learned it by teaching myself to code in order to solve problems. Whenever I was doing this, I was doing it to solve a particular problem that I had. So I actually first learned to code on TI-83 calculators. This was back in middle school. I ended up actually writing a guide on the internet for programming TI-83 calculators. It's still up on the internet somewhere. And it was basic. That was my first language. And I learned how to program on calculators so I could just get better at my math tests.

现在我的最后一个问题是，鉴于我们讨论的所有内容，如果这里有人正在学习计算机科学，并且你在 AI 辅助编码时代之前学习了这门课程，那么学生仍然应该以艰难的方式、像旧方式那样学习什么？对我来说，我是通过实践学习计算机科学的。我通过自学编码来解决问题。每当我这样做时，我都是为了解决我遇到的特定问题。所以我最初是在 TI-83 计算器上学习编码的。那是在中学时期。我最终在网上写了一本关于 TI-83 计算器编程的指南。它现在还在互联网的某个地方。那是 BASIC 语言。那是我的第一门语言。我学会了在计算器上编程，以便在数学考试中取得更好的成绩。

by cheating on the test. So it was about something practical. To me as a middle schooler, that was kind of like the most practical thing I could think of. And I ended up getting good grades, and then I got this little serial cable to give the programs to my classmates, and they got really good grades. And then the math got a little bit harder. It wasn't something that I could solve in BASIC anymore. So I kind of went from this like, you know, like maybe algebra solver that was written in BASIC, and I had to solve harder problems. And, you know, like once we got into calculus, I had to run assemblies so that I could write a better solver so I could cheat better on the test now that it was calculus.

通过在考试中作弊。所以这是关于实际的事情。对我这个中学生来说，那是我能想到的最实际的事情。我最终取得了好成绩，然后我得到了这条串行电缆，把程序传给了我的同学，他们也取得了好成绩。然后数学变得有点难了。那不再是能用 BASIC 解决的问题了。所以我从用 BASIC 编写的代数求解器，不得不解决更难的问题。而且，一旦我们进入微积分，我就必须运行汇编，以便编写一个更好的求解器，这样我就能在微积分考试中更好地作弊。

### 10. Advice for CS Students: Apply CS to Real World / Final Announcement and Encouragement to Build (给计算机科学学生的建议：将计算机科学应用于现实世界 / 最后的公告和鼓励去构建)

And so for me, programming has always been very practical. And I think this is always my advice for people in school is learn not just the computer science. This is like intellectually fascinating. And it's really, really interesting to know, but learn how to apply it. And often this is about building startups. It's about building products. It's about developing your own design sense, developing your business sense, learning how to do data science, learning how to talk to users. There are all these other skills. And when you combine it, with computer science and engineering, that's where it becomes really, really valuable. So those are the hard skills that I would still be doing by hand. So if I'm hearing and summarizing, start with making something you want first for yourself, and then level up and make something people want. Yes. And we just have one last special announcement for us. You want to, one last thing? Yeah, so for everyone here today,

所以对我来说，编程一直是非常实际的。我认为这始终是我给在校学生的建议：不仅要学习计算机科学。这从智力上令人着迷，了解它真的非常有趣，但也要学会如何应用它。这通常涉及创办初创公司、构建产品、培养自己的设计感、培养商业头脑、学习如何进行数据科学、学习如何与用户交流。所有这些其他技能。当你将它们与计算机科学和工程相结合时，它就会变得非常非常有价值。所以这些是我仍然会亲手去做的硬技能。所以如果我听到并总结一下，先为自己制作你想要的东西，然后提升并制作人们想要的东西。是的。我们还有一个最后的特别公告。你想说最后一件事吗？是的，所以对于今天在座的每个人，

You are getting max 20x. Wow. Incredible. Pretty good. So look for a quote in your email. And I can't wait to see what you build. We'll be sending you.

你将获得最高 20 倍的额度。哇。难以置信。相当不错。所以请留意你邮箱中的报价。我迫不及待地想看到你构建的东西。我们会发送给你。

So I'm curious someone in this room should be building something that runs hopefully multiple months and thousands of agents now that you have the account to do it and with that Thank you so much for us

所以我很好奇，这个房间里应该有人正在构建一些东西，希望它能运行数月并涉及数千个智能体，既然你现在有账户去做这件事，那么，非常感谢你为我们做的一切。