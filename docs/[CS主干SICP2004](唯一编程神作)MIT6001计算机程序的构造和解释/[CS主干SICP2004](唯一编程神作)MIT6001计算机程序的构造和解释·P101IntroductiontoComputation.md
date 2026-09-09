# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=1)

## Summary (摘要)

- The course is not about computer science as a science, but about the engineering and art of controlling complexity in computational processes.
- Declarative knowledge states what is true while imperative knowledge describes how to do something; the course focuses on imperative knowledge expressed as procedures.
- To describe procedures, a language needs primitives, means of combination, and means of abstraction.
- Scheme expressions are evaluated with rules: self-evaluating values return themselves, names are looked up in the environment, special forms like define have custom semantics, and combinations apply procedures to arguments.
- Black-box abstraction, conventional interfaces, and metalinguistic abstraction are key tools for managing system complexity.

- 本课程并非将计算机科学视为一门科学，而是关于在计算过程中控制复杂性的工程与艺术。
- 陈述性知识说明什么是真的，而命令性知识描述如何做某事；本课程侧重于以过程形式表达的命令性知识。
- 要描述过程，语言需要原语、组合手段和抽象手段。
- Scheme 表达式通过规则求值：自求值值返回自身，名字在环境中查找，特殊形式如 define 具有自定义语义，组合将过程应用于参数。
- 黑盒抽象、约定接口和元语言抽象是管理系统复杂性的关键工具。

## Outline (大纲)

1. Course Focus and the Nature of Computer Science
2. Declarative vs. Imperative Knowledge: Square Roots as Example
3. Procedures, Processes, and the Need for a Language
4. Language Requirements: Primitives, Combination, and Abstraction
5. Black-Box Abstraction and Conventional Interfaces
6. Course Goals: Computation to Control Complexity
7. Low-Level Information Representation and the Need for Abstraction
8. Introduction to Scheme and Its Syntax
9. Primitives and Built-In Procedures
10. Combination and Abstraction via Define

1. 课程焦点与计算机科学的本质
2. 陈述性知识与命令性知识：以平方根为例
3. 过程、进程与语言的需求
4. 语言要求：原语、组合与抽象
5. 黑盒抽象与约定接口
6. 课程目标：从计算到控制复杂性
7. 低级信息表征与抽象的需求
8. Scheme 及其语法简介
9. 原语与内置过程
10. 通过 Define 进行组合与抽象

## Transcript (转录)

### 1. Course Focus and the Nature of Computer Science (课程焦点与计算机科学的本质)

The first thing we have to do is discuss the focus is six double of one. What's this course really all about that? Seems kinda obvious this clearly is a course about computer science. But in fact, we're going to claim in a rather strange way that that's not really true. First of all, it's not really about science; it's much more about engineering or maybe even art than it is really science. Secondly, it's not really about computers. Now that definitely sounds strange, but let me tell you why I say it's not about computers.

我们首先要讨论的是本课程的焦点。这门课到底讲什么？看起来很明显，这是一门关于计算机科学的课程。但事实上，我们将以一种相当奇怪的方式声称，这并不完全正确。首先，它并非真正关于科学；它更像是工程，甚至可能是艺术，而非科学。其次，它并非真正关于计算机。这听起来确实奇怪，但让我告诉你为什么我说它不是关于计算机的。

It's not about computers in the same way that physics is not really about particle accelerators, or biology is not really about microscopes, or geometry is not really about surveying instruments.

它不是关于计算机的，就像物理学并非真正关于粒子加速器，生物学并非真正关于显微镜，几何学并非真正关于测量仪器一样。

In fact, geometry is a good analogy to use here. Geometry's ancient term comes from two words, 'geo' and 'metra', which means earth and measure. And to the ancient Egyptians, that's exactly what geometry was about. It dealt with measuring the earth or doing surveying, and the reason was very simple: after the annual flood of the Nile, they needed

事实上，几何学是一个很好的类比。几何学的古老术语来自两个词，“geo”和“metra”，意为“土地”和“测量”。对古埃及人来说，几何学正是关于这些的。它涉及测量土地或进行勘测，原因很简单：尼罗河每年泛滥之后，他们需要

the annual flood of the Nile they need the annual flood of the Nile they need to re-establish the boundaries of the land that belong to different people and they had to go back and do the measuring to make sure they knew where those boundaries were in retrospect of course we know geometry is much more than just dealing with surveying instruments but the Egyptians were really doing was formalizing a particular kind of knowledge that dealt with things that were true they were creating axioms for how to deal with reasoning about geometric entities this analogy is true for a lot of steeled when a field is in

尼罗河每年泛滥之后，他们需要重新确定属于不同人的土地边界，他们必须回去进行测量，以确保知道这些边界在哪里。回顾过去，我们当然知道几何学远不止处理测量仪器，但埃及人实际上在做的是形式化一种特定类型的知识，这种知识处理的是真实的事物；他们正在创建关于如何推理几何实体的公理。这个类比对于许多领域都适用，当一个领域处于初期阶段时，

For a lot of fields when a field is in its infancy, it's often easy to confuse the field with its tools or, if you like, what the core of the field is about with the tools that are used to measure it.

对于许多领域，当一个领域处于初期阶段时，人们常常容易将该领域与其工具混淆，或者，如果你愿意，将该领域的核心内容与用于测量它的工具混淆。

In retrospect, we saw Egyptians were really dealing with axiomatic knowledge even though at the time they thought they were just dealing with surveying instruments. So in fact, geometry is really dealing with a particular kind of knowledge known as declarative or what is knowledge.

回顾过去，我们看到埃及人实际上在处理公理性知识，尽管当时他们认为自己只是在处理测量仪器。所以事实上，几何学真正处理的是特定类型的知识，称为陈述性知识或“是什么”的知识。

By analogy to geometry, computer science isn't really about.

与几何学类比，计算机科学并非真正关于

computer science isn't really about computers, it isn't really about the tool. it's about the kind of knowledge the computer science makes available to us. and what we're going to see in this course is the computer science is dealing with a different kind of knowledge, is dealing with imperative or how to knowledge. it's trying to capture the notion of a process that causes information to evolve from one form to another. and we want to see how we can use methods to capture that knowledge. let's stress this a little bit better: what's declarative knowledge? it's

计算机科学并非真正关于计算机，它并非真正关于工具。它关乎计算机科学使我们能够获得的那种知识。我们将在本课程中看到，计算机科学处理的是不同种类的知识，即命令性知识或“如何做”的知识。它试图捕捉导致信息从一种形式演化为另一种形式的过程概念。我们想看看如何用方法捕捉这种知识。让我们更好地强调这一点：什么是陈述性知识？它是

### 2. Declarative vs. Imperative Knowledge: Square Roots as Example (陈述性知识与命令性知识：以平方根为例)

让我们更好地强调这一点。什么是声明性知识？

让我们更好地强调这一点。什么是陈述性知识？

what's declarative knowledge it's knowledge that talks about what is true it makes statements of fact that one can use to try and reason about things for example here's a statement of truth about square roots the square root of x is that thing Y such that Y squared equals x and for safety y is also greater than or equal to zero notice that this is a statement of truth

什么是陈述性知识？它是谈论什么是真的知识，它做出事实陈述，人们可以用这些陈述来推理事物。例如，这里有一个关于平方根的真理陈述：x 的平方根是那个 Y，使得 Y 的平方等于 x，并且为了安全起见，Y 也大于或等于零。注意，这是一个真理陈述。

it says if somebody hands you a possible value for the square root of x you can check it to see if it's correct but it doesn't tell you anything about how to find the square root on the other hand

它说，如果有人给你一个可能的 x 的平方根值，你可以检查它是否正确，但它没有告诉你任何关于如何找到平方根的信息。另一方面，

find the square root on the other hand, imperative knowledge deals with how two kinds of information it tends to describe specific sequences of steps that characterize the evolution of a process by which one can deduce information from one set of it facts to another. So here for example is a very old algorithm for computing the square root of x.

另一方面，命令性知识处理的是“如何做”的知识。它倾向于描述特定的步骤序列，这些步骤表征了一个过程的演化，通过这个过程，人们可以从一组事实推导出另一组事实的信息。例如，这里有一个非常古老的算法，用于计算 x 的平方根。

And it says very simply, let's start with an initial guess call it G. Let's improve that guess by taking G and X divided by G and averaging them, and let's keep doing that until the guess gets good enough. Okay, let's test it out.

它非常简单地说，让我们从一个初始猜测开始，称之为 G。让我们通过取 G 和 x 除以 G 的平均值来改进这个猜测，然后继续这样做，直到猜测足够好。好的，让我们测试一下。

这个已经足够好了，我们来测试一下。例如，如果我们想计算x的平方根，而x等于2，我们可以看到这一组步骤描述了一种如何获取该信息的方法。

这个已经足够好了，我们来测试一下。例如，如果我们想计算 x 的平方根，而 x 等于 2，我们可以看到这一组步骤描述了一种如何获取该信息的方法。

所以我们开始，这里有一个小图表。我们设X等于2，G等于1。我们的算法说：通过取G和x除以G的平均值来改进猜测，所以这给出X除以G等于2。

所以我们开始，这里有一个小图表。我们设 X 等于 2，G 等于 1。我们的算法说：通过取 G 和 x 除以 G 的平均值来改进猜测，所以这给出 X 除以 G 等于 2。

现在我们可以通过取G和x除以G的平均值来进一步改进猜测，这给出了一个稍好一些的G猜测值。我们可以检查一下，发现我们还没有达到足够接近，所以我们会继续做下去。

现在我们可以通过取 G 和 x 除以 G 的平均值来进一步改进猜测，这给出了一个稍好一些的 G 猜测值。我们可以检查一下，发现我们还没有达到足够接近，所以我们会继续做下去。

not really close enough so we keep doing the same process we take x over the current value of G we take the current value of G we average those and we get a slightly better guess and we keep doing that until we get a guess that's good enough.

还不够接近，所以我们继续同样的过程：我们取 x 除以当前 G 的值，取当前 G 的值，求平均值，得到一个稍好的猜测，然后继续这样做，直到得到一个足够好的猜测。

so notice how this little algorithm this little method describes a sequence of steps it tells us how to do something how to find a square root whereas the previous case the imperative case is rather the declarative case simply told us how to recognize the square root so what we've seen is that

所以请注意，这个小小的算法，这个小小的程序，描述了一系列步骤；它告诉我们如何去做某件事，如何求平方根。而之前的情况，即命令式的情况，实际上是陈述式的情况，只是告诉了我们如何识别平方根。所以我们看到的是，

square root so what we've seen is that

平方根，所以我们看到的是，

square root so what we've seen is that imperative and declarative knowledge are very different. one captures statements of fact, the other captures methods for deducing information. it is easy to see why the latter is more interesting for example, one could in principle imagine trying to collect a giant listing of all possible square roots and then simply looking up a square root when you need it.

平方根，所以我们看到的是，命令式知识和陈述式知识是非常不同的。一个捕捉事实陈述，另一个捕捉推导信息的方法。很容易看出为什么后者更有趣；例如，原则上可以想象试图收集所有可能的平方根的巨型列表，然后在需要时简单地查找平方根。

### 3. Procedures, Processes, and the Need for a Language (程序、过程和对语言的需求)

much more convenient is to capture the process of deducing a specific square root as needed. thus we are primarily interested in how-to knowledge. we want to be able to give the computer.

更方便的是捕捉按需推导特定平方根的过程。因此，我们主要感兴趣的是“如何做”的知识。我们希望能够给计算机。

to be able to give the computer instructions to compute a value and this means we need a way of capturing the how-to knowledge in particular we want to describe a series of specific mechanical steps to be followed in order to do a specific or particular value associated with some problem using a predefined set of operations.

能够给计算机指令来计算一个值，这意味着我们需要一种方式来捕捉“如何做”的知识。特别是，我们想要描述一系列具体的机械步骤，以便使用预定义的操作集来执行与某个问题相关的特定值。

this recipe for describing how to knowledge we call a procedure when we want to get the computer to actually compute a value that is use the how-to knowledge to find the value associated with a particular instantiation of the problem we will

这种描述“如何做”知识的配方，我们称之为过程（procedure）。当我们想让计算机实际计算一个值，即使用“如何做”的知识来找到与问题的特定实例相关的值时，我们将

instantiation of the problem we will evaluate an expression that applies that procedure to some values the actual sequence of steps within the computer that caused the how-to knowledge to evolve is called a process much of our focus during the term will be in understanding how to control different kinds of processes by describing them with procedures now we want to create tools that make it easy for us to capture procedures and describe processes and for that we're going to need a language whatever language we choose to use to describe computational

问题的特定实例时，我们将求值一个表达式，该表达式将该过程应用于某些值。计算机内部导致“如何做”知识演化的实际步骤序列称为过程（process）。本学期我们的主要关注点将是理解如何通过用过程描述它们来控制不同类型的过程。现在，我们想要创建工具，使我们能够轻松地捕捉过程并描述过程，为此我们需要一种语言。无论我们选择使用哪种语言来描述计算

choose to use to describe computational processes it must have several components first it will have a vocabulary a set of words on which we build our description these will be the basic elements of computation the fundamental representations information and the fundamental procedures that we will use to describe all other procedures

选择用来描述计算过程的语言，它必须有几个组成部分。首先，它将有一个词汇表，一组我们用来构建描述的词。这些将是计算的基本元素，信息的基本表征，以及我们将用来描述所有其他过程的基本过程。

second it will have a set of rules for Legally connecting elements together that is how to build more complex parts of a procedure at a more basic one this will be very similar to the syntax of a natural language

其次，它将有一组规则，用于合法地将元素连接在一起，即如何从更基本的过程构建更复杂的过程部分。这将非常类似于自然语言的句法。

the syntax of a natural language like English. Third, it will have a set of rules for deducing the meaning associated with elements of the description. This will be very similar to the semantics of a natural language like English. And finally, we'll need standard ways of combining expressions in our language together into a sequence of steps that actually describes the process of computation.

自然语言（如英语）的句法。第三，它将有一组规则，用于推导与描述元素相关联的意义。这将非常类似于自然语言（如英语）的语义。最后，我们需要标准的方法将语言中的表达式组合成一系列步骤，这些步骤实际描述了计算过程。

### 4. Language Requirements: Primitives, Combination, and Abstraction (语言要求：原语、组合和抽象)

We're going to see that our language for describing procedures will have many of the same features of natural languages, and that we will build methods for constructing

我们将看到，我们用来描述过程的语言将具有许多与自然语言相同的特征，并且我们将构建方法，以自然的方式从更简单的过程构造更复杂的过程。

we will build methods for constructing more complex procedures out of simpler prostheses procedures in natural ways one of the things we'll see is that it doesn't take long to actually come up with the rules for connecting together in our language

我们将构建方法，以自然的方式从更简单的过程构造更复杂的过程。我们将看到的一件事是，实际上不需要很长时间就能想出在我们的语言中连接在一起的规则。

nor fur is coming up with rules to deduce meanings associated with those things our real goal of course is to use this language of procedures to solve problems of interest to us

也不需要用很长时间来想出推导这些事物相关意义的规则。我们真正的目标当然是使用这种过程语言来解决我们感兴趣的问题。

and indeed much of the term will be spent on taking that language of procedures and seeing how one can use it to actually

事实上，本学期的大部分时间将花在采用这种过程语言，并看看如何实际使用它来

seeing how one can use it to actually control complexity in very large systems in order to capture imperative knowledge we are going to create languages that describe such processes

看看如何实际使用它来控制非常大的系统中的复杂性。为了捕捉命令式知识，我们将创建描述此类过程的语言。

this means we will need to specify set of primitive elements simple data and simple procedures out of which we will capture more complex things

这意味着我们将需要指定一组原语元素——简单的数据和简单的过程——从中我们将捕捉更复杂的事物。

we will also need a set of rules for combining primitive things into more complex structures

我们还需要一组规则，将原语组合成更复杂的结构。

and once we have those complex structures we will want to be able to abstract them to give them names so that we can simply

一旦我们有了这些复杂的结构，我们将希望能够抽象它们，给它们命名，以便我们可以简单地

give them names so that we can simply treat them as if we will see as we go through the term that this cycle of creating complex processes then suppressing the details by distracting them into black box unit is a powerful tool for designing maintaining and extending computational system indeed that is precisely the goal of understanding computation how can we create methodologies that make it easy to describe complex processes without getting lost in the details clearly a well-designed methodology for thinking about computation should enable us to

给它们命名，以便我们可以简单地将它们视为黑盒。随着学期的进行，我们将看到，创建复杂过程然后通过将它们抽象为黑盒单元来抑制细节的循环，是设计、维护和扩展计算系统的强大工具。事实上，这正是理解计算的目标：我们如何创建方法论，使我们能够轻松描述复杂过程而不会迷失在细节中？显然，一个设计良好的计算思维方法论应该使我们能够

About computation should enable us to build systems that robustly and efficiently compute results without error, but also should enable us to easily add new capabilities to the system. Thus, our goal is to gain experience in thinking about computation independent of language details and specifics, in order to control complexity in large intricate systems.

关于计算的思维应该使我们能够构建稳健且高效地计算结果且无错误的系统，但也应该使我们能够轻松地向系统添加新功能。因此，我们的目标是获得独立于语言细节和具体情况的思考计算的经验，以便控制大型复杂系统中的复杂性。

Our real goal in six double of one then is to use the idea of a process and our way of describing that process with procedures, in order to deal with complex systems. We don't want to just build small programs.

我们在6.001中的真正目标是使用过程的思想以及我们用过程描述过程的方式，来处理复杂系统。我们不想只是构建小程序。

We don't want to just build small programs; we want to build programs that do something interesting. And almost by definition, doing something interesting is going to require us to deal with the complexity of some problem, and we need tools for handling that complexity.

我们不想只是构建小程序；我们想要构建做有趣事情的程序。而且几乎根据定义，做有趣的事情将要求我们处理某个问题的复杂性，我们需要处理这种复杂性的工具。

### 5. Black-Box Abstraction and Conventional Interfaces (黑盒抽象和常规接口)

We're going to see several key concepts in terms of dealing with the abstract engineering or controlling complexity. The first is what we may call blackbox abstraction. Suppose I have that concept of the square root, and in fact I've shown you details of one way to find them, but in general I just want to.

我们将看到几个关键概念，它们涉及抽象的工程或控制复杂性。第一个是我们可称之为黑箱抽象的概念。假设我有平方根这个概念，事实上我已经向你们展示了一种求平方根的方法，但通常我只是想……

find them but in general I just want to use square roots to do something in this case I should be able to take the notion of the square root which is why we give it a name in fact and take it without having to worry about the details and just use it.

……求平方根，但通常我只是想用平方根来做某事。在这种情况下，我应该能够把平方根这个概念（这正是我们给它命名的原因）拿来使用，而不必担心其细节，直接使用它。

we can think of building a black box in which this abstraction so that we isolate the details from the actual use we're going to use that tool of abstraction that black box sort of notion both for procedures and data as a key way to try and control complexity.

我们可以想象构建一个黑箱，在其中进行这种抽象，从而将细节与实际使用隔离开来。我们将把这种抽象工具、这种黑箱式的概念用于过程和数据的处理，作为控制复杂性的关键方式。

not only are building blackbox abstraction is a

构建黑箱抽象不仅是……

Building blackbox abstraction is a valuable tool for isolating out the components of the system, but they also provide us a mechanism for reasoning about how they connect together and indeed in most systems the key issue will be how do we take those pieces, how do we take those modules and stick them together in ways that allow us to do something more complicated.

构建黑箱抽象是隔离系统组件的宝贵工具，但它也为我们提供了一种推理这些组件如何连接在一起的机制。事实上，在大多数系统中，关键问题将是如何把这些部件、这些模块组合在一起，以使我们能够完成更复杂的任务。

This means that we're going to need conventional interfaces for putting modules together. This is much like by analogy dealing with a stereo system in which we can buy components from different manufacturers.

这意味着我们将需要用于组合模块的常规接口。这类似于音响系统，我们可以从不同制造商购买组件。

components from different manufacturers and have standard ways of interfacing them together to get out the systems that we want

……来自不同制造商的组件，并通过标准方式将它们连接起来，以得到我们想要的系统。

in programming we're going to have the same idea and we'll spend a fair amount of time talking about conventional interfaces for gluing together abstractions

在编程中，我们将有同样的想法，我们将花相当多的时间讨论用于粘合抽象的常规接口。

and in fact here are three of the kinds of things we're going to deal with throughout the term as examples of conventional interfaces

事实上，以下是我们将在整个学期中处理的三种常规接口的例子。

we'll see as we go through the term the building black box abstractions and finding ways to conventionally interface

随着课程的进行，我们将看到构建黑箱抽象并找到常规接口的方法。

finding ways to conventionally interface them or glue them together is going to be very valuable but even with these kinds of tools there are still some problems that are too complex to handle in a convenient way when we reach that stage we're going to generalize one more level and build our own language we're going to use the notion of metalinguistic abstraction to create separate languages specifically designed for problem areas we'll find that this is a powerful tool and will require us to look at the notion of what it means to evaluate expressions in a language

找到常规接口的方法或将它们粘合在一起将非常有价值，但即使有了这些工具，仍然有一些问题过于复杂，无法以方便的方式处理。当我们达到那个阶段时，我们将再概括一个层次，构建我们自己的语言。我们将使用元语言抽象的概念来创建专门针对问题领域的独立语言。我们将发现这是一个强大的工具，并且将要求我们审视在语言中求值表达式意味着什么。

to evaluate expressions in a language, and as a consequence we'll see several examples of different ways of building languages, languages for new problems, languages that deal specifically with interfaces to hardware, evaluators of various forms, and finally dealing with compilation as a specific way of manipulating those programs.

……在语言中求值表达式，因此我们将看到几种构建语言的不同方式的例子：针对新问题的语言、专门处理硬件接口的语言、各种形式的求值器，以及最终将编译作为操作这些程序的一种特定方式。

### 6. Course Goals: Computation to Control Complexity (课程目标：从计算到控制复杂性)

our goal in this course is to explore computation, especially how thinking about computation can serve as a tool for understanding and controlling complexity in large systems, a particularly interesting area being systems in which information is

本课程的目标是探索计算，特别是思考计算如何作为理解和控制大型系统复杂性的工具，一个特别有趣的领域是信息从某些初始数据中推断出来的系统。

our systems in which information is inferred from some set of initial data whether that is finding other information on the web or computing an answer to a scientific problem or deciding more control signals to use to guide a mechanical system for such systems to work they need some process by which such inference takes place and our goal is to be able to reason about that process.

我们的系统，其中信息从一组初始数据中推断出来，无论是查找网络上的其他信息、计算科学问题的答案，还是决定用于引导机械系统的更多控制信号。为了使这些系统工作，它们需要某种过程来进行这种推断，我们的目标是能够推理这个过程。

in using computation as a metaphor to understand complex problem-solving we really want to do two things we want to capture descriptions of computational

在使用计算作为理解复杂问题求解的隐喻时，我们确实想做两件事：我们想要捕获计算过程的描述。

capture descriptions of computational processes and we want to use the notion of a computational process as an abstraction on which we can build solutions to other problems.

捕获计算过程的描述，并且我们想要使用计算过程的概念作为抽象，在此基础上构建其他问题的解决方案。

we will see that to describe processes we need a language appropriate for capturing the essential elements of those things.

我们将看到，要描述过程，我们需要一种适合捕获这些过程基本要素的语言。

this means we will need fundamental primitives or atomic elements of the language, means of combination or ways of constructing more complex things from simpler ones, and means of abstraction, ways of treating complex things as primitives so that we can continue this.

这意味着我们将需要语言的基本原语或原子元素、组合的方式（即从简单的东西构造更复杂的东西的方法），以及抽象的方式（即将复杂的事物视为原语的方法），以便我们能够继续这一过程。

primitives so that we can continue this product so let's begin our discussion of a language for describing computational processes to do this we really need to provide a definition of or at least some intuition behind the idea of a process in simple terms a computational process is a precise sequence of steps by which information in the form of numbers symbols or other simple data elements is used to infer new information this could be a numerical computation such as a set of steps to compute the square root as we saw earlier or it could be a symbolic

原语，以便我们能够继续这一过程。那么让我们开始讨论一种用于描述计算过程的语言。为此，我们确实需要提供一个定义，或者至少提供一些关于过程概念的直觉。简单来说，计算过程是一系列精确的步骤，通过这些步骤，以数字、符号或其他简单数据元素形式的信息被用来推断新信息。这可以是数值计算，例如我们之前看到的一组计算平方根的步骤，也可以是符号计算。

We saw earlier, or it could be a symbolic computation, finding a piece of information on the web, or some other inference based on information. Well, the computational process refers to the actual evolution of information in the computation.

我们之前看到的，或者可以是符号计算，例如在网络上查找一条信息，或基于信息的其他推断。计算过程指的是计算中信息的实际演化。

We also want to be able to capture a description of the steps in that computation. We refer to this recipe as a computational procedure, a description of the steps of the computation.

我们还希望能够捕获计算中步骤的描述。我们将这种配方称为计算过程（computational procedure），即计算步骤的描述。

Thus, our language will allow us to describe recipes and to use these descriptions on particular instances of problems. That is, it will allow us to

因此，我们的语言将允许我们描述配方，并将这些描述应用于特定问题实例。也就是说，它将允许我们……

Problems that is it will allow us to bake solutions using those recipes first. We need to understand how we're going to represent information which we will use as a basis for our computational processes. To do this, we need to decide on representations for numeric values and symbolic ones. Let's start with numbers.

……问题，也就是说，它将允许我们使用这些配方来烘焙解决方案。首先，我们需要理解我们将如何表示信息，这将作为我们计算过程的基础。为此，我们需要决定数值和符号值的表示。让我们从数字开始。

### 7. Low-Level Information Representation and the Need for Abstraction (低级信息表示与抽象的必要性)

To represent a number, we begin with the most atomic element because ultimately we will represent information inside the computer. We will use electronic signals to do this. These are most conveniently represented by using a high voltage or current or a low voltage.

为了表示一个数字，我们从最原子的元素开始，因为最终我们要在计算机内部表示信息。我们将使用电子信号来实现这一点。这些信号最方便地用高电压或高电流，或低电压来表示。

High voltage or current or a low voltage recurrent to represent fundamental values and thus the most primitive element in representing a value is a binary variable which takes on either a value of 0 or a value of 1. This variable represents one bit or binary digit of them.

高电压或高电流或低电压反复出现，用来表示基本值，因此表示一个值的最原始元素是一个二元变量，它取值为0或1。这个变量表示一位（bit）或一个二进制数字。

Of course, we need to group these bits together to represent other numbers, which we do typically in groupings of eight bits, called a byte, or in groupings of 16, 32, or 48 bits, often called a word. Once we have sequences of this, we can use them not only to represent other numbers but we can.

当然，我们需要将这些位组合在一起以表示其他数字，通常我们按八位一组进行组合，称为一个字节（byte），或者按16位、32位或48位一组，通常称为一个字（word）。一旦我们有了这样的序列，我们不仅可以用它们来表示其他数字，还可以……

represent other numbers but we can envision encodings in which numbers or bit sequences are used to represent characters and characters can further be grouped together to represent symbolic words so we won't worry about it much in this course there are standard encoding schemes for using bit sequences to represent characters as well as numbers typically the first few bits in the sequence are used as a tag to distinguish a number from an encoding for character now let's spend just a second thinking about binary representations for numbers and

……表示其他数字，但我们还可以设想这样的编码：用数字或位序列来表示字符，而字符可以进一步组合起来表示符号化的词语。在本课程中我们不会过多担心这个问题，因为有标准的编码方案用位序列来表示字符和数字。通常，序列中的前几位用作标签，以区分数字和字符编码。现在让我们花一点时间思考数字的二进制表示以及……

Representations for numbers and operations to manipulate them, we said we could use a sequence of bits to represent a number. For example, a positive integer we can identify each place in the sequence. By convention, the lowest-order bit is at the right, and we can weight each bit by a different power of two, so that we're able to represent all possible integers up to some limit based on the number of bits we're using.

……数字的表示以及操作它们的运算。我们说可以用一个位序列来表示一个数字。例如，对于一个正整数，我们可以标识序列中的每个位置。按照惯例，最低有效位在右边，我们可以用不同的2的幂来加权每一位，这样我们就能表示所有可能的整数，其上限取决于我们使用的位数。

Mathematically, we can capture this in the equation shown on the slide, and this gives us a way of representing unsigned integers. Now what about simple

在数学上，我们可以用幻灯片上的方程来捕捉这一点，这给了我们一种表示无符号整数的方法。那么简单的……

integers now what about simple arithmetic operations on binary integers well the rules for addition are just what you'd expect and we can do standard addition by simply carrying this just as you would in decimal arithmetic you can see this by checking the binary addition at the bottom left and converting that conversion of this result to digital form gives you what is shown on the right

……整数呢？那么二进制整数的简单算术运算呢？加法的规则正如你所预期的那样，我们可以通过简单的进位来进行标准加法，就像十进制算术中那样。你可以通过检查左下角的二进制加法来看到这一点，并将该结果转换为十进制形式，就得到了右边所示的内容。

there are similar rules of course for things like multiplication and other arithmetic operations one can build on this to create signed integers using one

当然，对于乘法和其他算术运算也有类似的规则。我们可以在此基础上构建有符号整数，使用一个……

This to create signed integers using one bit, typically the highest order bit to represent the sign, positive or negative. Now one can extend this to represent real or scientific numbers and to represent encodings for characters, using some high order bits to denote a character and then using some standard encoding to relate bit sequences to actual characters.

……使用一个位（通常是最高位）来表示符号，正或负。现在我们可以扩展这一点来表示实数或科学计数法数字，以及表示字符的编码，使用一些高位来表示字符，然后使用某种标准编码将位序列与实际的字符关联起来。

The problem is that this is clearly too low-level. Imagine trying to write a procedure to compute square roots where all you can think about are operations on individual bits. This quickly gets bogged down in details.

问题是这显然太底层了。想象一下，试图编写一个计算平方根的过程，而你能想到的只是对单个位的操作。这很快就会陷入细节之中。

this quickly gets bogged down in details and it's generally mind-numbingly boring so we need to incorporate a level of abstraction we're going to assume that we are given a set of primitive objects and a set of basic operation

……这很快就会陷入细节之中，而且通常令人麻木地无聊。因此，我们需要引入一个抽象层次。我们将假设给定一组原始对象和一组基本操作……

and we're going to build on top of that level of abstraction to deal with higher-level languages for computation so we will assume that our language provides a built-in set of data structures numbers characters and boolean values things are a true or false and we will assume that our language provides a built-in set of

……我们将在这个抽象层次之上构建，以处理更高级的计算语言。因此，我们将假设我们的语言提供了一组内置的数据结构：数字、字符和布尔值（真或假），并且我们将假设我们的语言提供了一组内置的……

language provides a built-in set of primitive operations for manipulating numbers characters and boolean our goal is to build on top of this level of abstraction to capture the essence of a computational process

……语言提供了一组内置的原始操作，用于操作数字、字符和布尔值。我们的目标是在这个抽象层次之上构建，以捕捉计算过程的本质。

### 8. Introduction to Scheme and Its Syntax (Scheme 及其语法简介)

thus we are going to first describe our language for capturing computational processes and then look at using it to solve problems

因此，我们将首先描述我们用于捕捉计算过程的语言，然后看看如何使用它来解决问题。

in this course the language you are going to use is called scheme a variant of a language called Lisp both of which were invented here at MIT some time ago

在本课程中，你将使用的语言叫做 Scheme，它是 Lisp 语言的一种变体，两者都是很久以前在麻省理工学院发明的。

everything we write in scheme will be

我们在 Scheme 中写的所有内容都将……

Everything we write in Scheme will be composed of a set of expressions, and there is a simple set of rules that tell us how to create legal expressions in this language. These rules are similar to the syntax of a natural language like English; they tell us the simplest legal expression and give us rules for constructing more complex legal expressions from simpler pieces.

我们在 Scheme 中写的所有内容都将由一组表达式组成，并且有一组简单的规则告诉我们如何在该语言中创建合法的表达式。这些规则类似于英语等自然语言的语法；它们告诉我们最简单的合法表达式，并给我们从更简单的部分构造更复杂的合法表达式的规则。

Similarly, almost every expression in Scheme has a meaning or value associated with it. The semantics of the language will tell us how to deduce the meaning associated with each expression.

类似地，Scheme 中几乎每个表达式都有一个含义或值与之关联。语言的语义将告诉我们如何推导出与每个表达式相关联的含义。

meaning associated with each expression, or if you like, how to determine the value associated with a particular computation in scheme. With only a few exceptions, we will see that evaluating every expression results in a value being returned as the associated meaning.

……与每个表达式相关联的含义，或者如果你愿意，如何确定 Scheme 中特定计算所关联的值。除了少数例外，我们将看到，对每个表达式的求值都会导致返回一个值作为关联的含义。

Now, as we build up our vocabulary in scheme, we're going to find rules for syntax and semantics associated with each new type of expression. Finally, we will also see that every value in scheme has a type associated with it. Some of these types are simple; oh, there's more complex types that basically define a...

现在，随着我们在 Scheme 中建立词汇表，我们将为每种新类型的表达式找到相关的语法和语义规则。最后，我们还将看到 Scheme 中的每个值都有一个与之关联的类型。其中一些类型是简单的；哦，还有一些更复杂的类型，它们基本上定义了一个……

complex types basically define a taxonomy of expressions and relate legal ways in which those expressions can be combined and manipulated. We will see that reasoning about types of expressions will be very valuable when we reason about capturing common patterns of computation inside of procedures. As we build up our language, looking at the syntax and semantics of expressions in that language, we will also see that these expressions very nicely break up into three different components: we have primitives, our most basic atomic units on top of which.

……复杂的类型基本上定义了一个表达式的分类法，并关联了这些表达式可以合法组合和操作的方式。我们将看到，当我们推理在过程中捕捉常见计算模式时，对表达式类型的推理将非常有价值。随着我们构建语言，查看该语言中表达式的语法和语义，我们还将看到这些表达式很好地分为三个不同的组成部分：我们有原始表达式，我们最基本的原子单元，在其之上……

### 9. Primitives and Built-In Procedures (原始表达式和内置过程)

basic atomic units on top of which everything else is constructed we have ways of gluing things together our means of combination which tells us how to combine smaller pieces to get bigger constructs and finally we have means of abstraction our way of taking bigger pieces then treating them as primitives so that they can be combined into bigger constructs while boring or suppressing the internal details of the pieces let's start with the primitives the basic elements these are the simplest elements on top of which we will build all our other

基本的原子单元，其他一切都在其上构建；我们有将事物粘合在一起的方式，即我们的组合手段，它告诉我们如何将较小的部分组合成更大的结构；最后，我们有抽象的手段，即我们将较大的部分视为原语的方式，这样它们就可以被组合成更大的结构，同时忽略或隐藏这些部分的内部细节。让我们从原语开始，即基本元素。这些是最简单的元素，我们将在其上构建所有其他的计算结构。

which we will build all our other computational constructs. The simplest of these are the self-evaluating expressions, that is, things whose values are the objects themselves. These include numbers, strings, and booleans.

我们将在其上构建所有其他的计算结构。其中最简单的是自求值表达式，即其值就是对象本身的表达式。这些包括数字、字符串和布尔值。

Numbers are obvious and include things like integers, real numbers, and scientific notation. Strings are sequences of characters, including numbers and special characters, all delimited by double quotes. These represent symbolic, as opposed to numeric, data.

数字是显而易见的，包括整数、实数和科学计数法等。字符串是字符序列，包括数字和特殊字符，全部用双引号分隔。它们表示符号数据，而非数值数据。

Booleans represent the logical values of true and false. These represent logical, as opposed to numeric or symbolic, data.

布尔值表示逻辑真和假。它们表示逻辑数据，而非数值或符号数据。

These represent logical as opposed to symbolic or numeric data of course. We want more than just primitive objects; we need ways of manipulating those objects.

这些表示逻辑数据，而非符号或数值数据。当然，我们不仅仅需要原语对象；我们还需要操作这些对象的方法。

For example, for numbers we have a set of built-in or predefined procedures. Thus the symbol plus is a name for the primitive procedure or operation of addition, and similarly for other arithmetic operations including comparison operations.

例如，对于数字，我们有一组内置或预定义的过程。因此，符号加号是加法原语过程或操作的名称，其他算术运算（包括比较运算）也是如此。

Strings have an associated set of operations for comparing strings or extracting parts of strings, and Booleans have an associated set of logical operations.

字符串有一组相关的操作，用于比较字符串或提取字符串的一部分，布尔值有一组相关的逻辑操作。

set of logical operations think of these as abstractions they're machinery that performed the operations described by set of known rules before we actually show the use of this primitive our built-in procedures we pause to stress that these names are themselves expressions by our earlier discussion this suggests that the expression plus should have a value this sounds like a strange thing for many computer languages but in scheme we can ask for the value associated with a symbol or name in this case the meaning or value associated with this built-in symbol

一组逻辑操作。将它们视为抽象，它们是执行由一组已知规则描述的操作的机制。在我们实际展示这些原语或内置过程的使用之前，我们暂停一下，强调这些名称本身就是表达式。根据我们之前的讨论，这表明表达式加号应该有一个值。对于许多计算机语言来说，这听起来很奇怪，但在Scheme中，我们可以询问与符号或名称相关联的值，在这种情况下，与这个内置符号相关联的含义或值。

associated with this built-in symbol plus is the actual procedure the internal mechanism if you like for performing addition. In fact our rule for evaluating the expression plus is to treat it as a symbol and look up the value associated with it in a big table somewhere. Shortly we'll see how that table is actually created.

与这个内置符号加号相关联的值是实际的过程，如果你愿意，可以说是执行加法的内部机制。事实上，我们评估表达式加号的规则是将其视为一个符号，并在某个大表中查找与其关联的值。稍后我们将看到这个表是如何实际创建的。

### 10. Combination and Abstraction via Define (组合与通过Define进行抽象)

Given numbers and simple procedures, we want to use them together ideally we should be able to apply operations like or plus two numbers to get new values. This leads to means a combination our way of constructing large expressions.

有了数字和简单过程，我们希望将它们一起使用。理想情况下，我们应该能够应用操作，如加法或乘法，对两个数字进行操作以获得新值。这引出了组合的手段，即我们构造大型表达式的方式。

way of constructing large expressions are the simpler ones in scheme our standard means of combination consists of an expression that will apply a procedure to a set of arguments in order to create a new value and it has a very particular form consisting of an open parenthesis followed by an expression whose value using the rules we are describing turns out to be a procedure followed by some number of other expressions whose values are obtained using these same rules followed by a matching closed parenthesis this form always holds for a combination so there

构造大型表达式的方式在Scheme中是比较简单的。我们标准的组合手段包括一个表达式，它将一个过程应用于一组参数以创建一个新值，并且它具有非常特定的形式：一个左括号，后跟一个表达式（其值根据我们正在描述的规则是一个过程），再后跟一些其他表达式（其值使用相同的规则获得），最后是一个匹配的右括号。这种形式总是适用于组合，因此组合有语法：左括号、一个其值为过程的表达式、一组其他值，以及右括号。

always holds for a combination so there is a syntax for combination an open paren an expression whose value as a procedure some other set of values and a close print. What about the semantics of a combination? To evaluate a combination, we evaluate all the sub expressions in any order using the rules we're developing. We then apply the value of the first expression for the values of the other expressions.

总是适用于组合，因此组合有语法：左括号、一个其值为过程的表达式、一组其他值，以及右括号。那么组合的语义是什么？为了评估组合，我们使用我们正在开发的规则以任意顺序评估所有子表达式。然后我们将第一个表达式的值应用于其他表达式的值。

Now what does apply mean for simple built-in procedures? It just means take the underlying hardware implementation and do the appropriate thing to the values.

那么对于简单的内置过程，应用意味着什么？它只是意味着采用底层硬件实现并对这些值执行适当的操作。

do the appropriate thing to the values, for example add them multiply them and so on. This idea of combinations can be nested arbitrarily. We can use a combination whose parts are themselves combinations, so long as the resulting value can legally be used in that spot.

对这些值执行适当的操作，例如相加、相乘等等。这种组合的思想可以任意嵌套。我们可以使用其部分本身是组合的组合，只要结果值在该位置合法使用即可。

To evaluate combinations of arbitrary depth, we just recursively apply these rules: first getting the values of the sub expressions, then applying the procedure to the arguments and further reducing the expression. So for example, to get the value of the first expression here, we get the values of plus or lookup.

为了评估任意深度的组合，我们只需递归地应用这些规则：首先获取子表达式的值，然后将过程应用于参数，并进一步简化表达式。例如，要获取这里第一个表达式的值，我们获取加号的值或查找它。

here we get the values of plus or lookup, and for because it's self evaluated. Because the middle sub expression is itself a combination, we apply the same rules to this to get the value 6 before completing the computation.

这里我们获取加号的值或查找它，并且因为它是自求值的。因为中间的子表达式本身是一个组合，我们应用相同的规则来获取值6，然后完成计算。

So far, we have basic primitives, numbers, and simple built-in procedures, and we have means of combination—ways of combining all those pieces together to get more complicated expressions. But at this stage, all we can do is write out long, complicated arithmetic expressions. We have no way of abstracting expressions; we would like to...

到目前为止，我们有基本的原语、数字和简单的内置过程，我们有组合的手段——将这些部分组合在一起以获得更复杂表达式的方法。但在这个阶段，我们所能做的只是写出冗长、复杂的算术表达式。我们没有办法抽象表达式；我们希望...

abstracting expressions we would like to be able to give some pression a name so that we could just refer to that name as abstraction and not have to write out the complete expression each time we want to use it in scheme our standard way for doing that is to use a particular expression called a define it has a specific form and open parenthesis as before followed by the keyword defined followed by an expression that will serve as a name typically some sequence of letters and other characters followed by an expression whose value will be associated with that name.

抽象表达式，我们希望能够给某个表达式一个名字，这样我们就可以引用那个名字作为抽象，而不必每次想使用它时都写出完整的表达式。在Scheme中，我们标准的做法是使用一个特定的表达式，称为define。它具有特定的形式：和之前一样，一个左括号，后跟关键字define，再后跟一个将作为名称的表达式（通常是字母和其他字符的序列），再后跟一个其值将与那个名称关联的表达式。

will be associated with that name, followed by close parentheses we say that this expression is a special form. This means it does not follow the normal rules of evaluation for a combination. We can see why we want that here.

将与那个名称关联，后跟右括号。我们说这个表达式是一种特殊形式。这意味着它不遵循组合的正常评估规则。我们在这里可以看到为什么我们需要这样。

If we applied the normal rules for combination, we would get the value of the expression score and the value of 23 and then apply the define procedure. But the whole point of this expression is to associate a value with score.

如果我们应用通常的组合规则，我们会得到表达式 score 的值和 23 的值，然后应用 define 过程。但这个表达式的全部意义在于将一个值与 score 关联起来。

So we can't possibly use the normal rules to evaluate score. Instead, we will use a different rule to handle this special form properly.

因此，我们不可能使用通常的规则来求值 score。相反，我们将使用不同的规则来正确处理这种特殊形式。

Instead we will use a different rule to evaluate this special form in particular. We just evaluate the last sub expression, then take the name without evaluating it, score in this case, and pair that name together with the deduced value in a special structure we call an environment.

相反，我们将使用不同的规则来专门求值这种特殊形式。我们只求值最后一个子表达式，然后取名称而不对其求值，在此例中是 score，并将该名称与推导出的值配对，放入一个我们称之为环境（environment）的特殊结构中。

For now think of this as a big table into which pairings of names and values can be made using this special defined expression, because our goal is to associate a name with the value. We don't actually care what value is returned by the defined expression, and in most scheme implementations we leave that as

现在，你可以把它看作一张大表，通过这种特殊的 define 表达式可以在其中建立名称与值的配对，因为我们的目标是将名称与值关联起来。我们实际上并不关心 define 表达式返回什么值，在大多数 Scheme 实现中，我们将其留作

Scheme implementations we leave that as unspecified. Thus, our means of abstraction gives us a way of associating a name with an expression, allowing us to use that name in place of the actual expression.

Scheme 实现中，我们将其留作未指定。因此，我们的抽象手段为我们提供了一种将名称与表达式关联起来的方法，使我们能够用该名称代替实际的表达式。

Once we have the ability to create names and give names to values, we also need the ability to get the value back out. That's easy: to get the value of the name in Scheme, we simply look up the pairing of the name in that table that we created.

一旦我们能够创建名称并给值赋予名称，我们还需要能够将值取回。这很容易：要在 Scheme 中获取名称的值，我们只需在我们创建的表中查找该名称的配对。

If we evaluate the expression 'score', we simply look up the association we made when we defined 'score' in that table.

如果我们求值表达式 'score'，我们只需查找我们在表中定义 'score' 时建立的关联。

when we define score in that table in this case 23 and return that value note that this is exactly what we did when we dealt with built-in primitives if we give the name plus to scheme it looks up the Association of that symbol which in this case is the built in addition primitive and that procedure is then returned as the value

当我们在表中定义 score 时，在此例中是 23，并返回该值。请注意，这正是我们在处理内置原语时所做的事情：如果我们给 Scheme 名称 plus，它会查找该符号的关联，在此例中是内置的加法原语，然后该过程作为值返回。

and thus we can now use names in any place we would have used its associated expression an example shown here we can define total to have the value of the sub expression shown and by our previous rules we know that this reduces to 25

因此，我们现在可以在任何使用其关联表达式的地方使用名称。这里展示了一个例子：我们可以定义 total 为所示子表达式的值，根据我们之前的规则，我们知道这可以化简为 25。

Rules we know that this reduces to 25 if we evaluate the last expression our rules say that we first evaluate the sub expressions. The symbol star is easy as if the as is the number 100 to get the value of the last sub expression we recursively apply our rules in this case looking up the value of score and the value of total then applying the value of slash to the result and finally applying the multiplication operator to the whole thing.

根据规则，我们知道这可以化简为 25。如果我们求值最后一个表达式，我们的规则说我们首先求值各个子表达式。符号 star 很容易，就像数字 100 一样。为了得到最后一个子表达式的值，我们递归地应用我们的规则：在这种情况下，查找 score 和 total 的值，然后将 slash 的值应用于结果，最后将乘法运算符应用于整个结果。

Notice that this creates a very nice loop in our system we can now create complex expressions give them a name and

注意，这在我们的系统中创造了一个非常好的循环：我们现在可以创建复杂的表达式，给它们一个名称，然后

Complex expressions give them a name and then by using that name treat the whole expression as if it were primitive. We can refer to that expression by name, and that can write new complex expressions, evolving those names, giving the resulting expression another name and treating it as a new primitive, and so on.

复杂的表达式给它们一个名称，然后通过使用该名称，将整个表达式视为原语。我们可以通过名称引用该表达式，从而可以编写新的复杂表达式，演化这些名称，将得到的表达式赋予另一个名称，并将其视为新的原语，依此类推。

In this way we can vary complexity behind the name and create new primitive elements in our language. So here is a summary of the rules of evaluation we've seen so far: for self-evaluating expressions, return the value; for names, return the value for names.

通过这种方式，我们可以在名称背后隐藏复杂性，并在我们的语言中创建新的原语元素。以下是我们目前所见的求值规则总结：对于自求值表达式，返回值；对于名称，返回名称的值。

expressions return the value for names return the value associated with the name in the environment, for special forms do particularly different things. And for combinations, evaluate all the sub-expressions in any order, and then apply the operator or first sub-expression's value to the values of the off-ramps.

对于表达式，返回值；对于名称，返回环境中与该名称关联的值；对于特殊形式，做特别不同的事情；对于组合式，以任意顺序求值所有子表达式，然后将运算符（即第一个子表达式的值）应用于其余子表达式的值。

Because these ideas of evaluation are important, let's take another look at what happens when an expression is evaluated. Remember that our goal is to capture computation in expressions, and then use those expressions to compute values.

因为这些求值的思想很重要，让我们再看一看表达式被求值时会发生什么。记住，我们的目标是在表达式中捕获计算，然后使用这些表达式来计算值。

expressions to compute values we have been describing both the forms of the expressions and how one deduce his values of expressions when we consider the second stage we can actually separate out two different worlds or two different ways of looking at what happens during evaluation one world is the visible world this is what we see when we type an expression at the computer and ask it to perform an evaluation leading to some printed result below that world is the execution world this is what happens within the computer see a lot more details about

用表达式来计算值。我们一直在描述表达式的形式以及如何推导出表达式的值。当我们考虑第二阶段时，我们实际上可以分离出两个不同的世界，或者两种不同的方式来看待求值过程中发生的事情。一个世界是可见世界，这是当我们向计算机输入表达式并要求其执行求值，导致在下面打印出某个结果时我们所看到的。在那个世界之下是执行世界，这是计算机内部发生的事情，关于这方面的更多细节，

计算机能看到更多关于这方面的细节，本课程后面会讲到，这既包括对象如何表示，也包括实际求值机制如何发生。

计算机能看到更多关于这方面的细节，本课程后面会讲到，这既包括对象如何表示，也包括实际求值机制如何发生。

我们想要看到这两个世界如何交互，以纳入语义规则，用于确定表达式的值。当表达式从我们的可见世界输入计算机时，它首先由一个称为读取器的机制处理，该机制将表达式转换为适合计算机的内部形式。

我们想要看到这两个世界如何交互，以纳入语义规则，用于确定表达式的值。当表达式从我们的可见世界输入计算机时，它首先由一个称为读取器的机制处理，该机制将表达式转换为适合计算机的内部形式。

那种形式随后被传递给一个称为求值器的过程，这个求值器封装了……

那种形式随后被传递给一个称为求值器的过程，这个求值器封装了……

evaluator this evaluator encapsulates our rules for evaluation and reduces the expression to its value using exactly the rules we've been talking about note that this may involve a recursive application of the evaluation rules if the expression is a compound one as we saw with our earlier nested arithmetic expression and the result is then passed to a print process which converts it into a human readable form and outputs it onto the screen suppose for example we type the expression 23 into the computer and ask for its value the

求值器封装了我们的求值规则，并使用我们一直在讨论的规则将表达式化简为其值。注意，如果表达式是复合的，这可能涉及求值规则的递归应用，正如我们之前看到的嵌套算术表达式那样。然后结果被传递给打印过程，该过程将其转换为人类可读的形式并输出到屏幕上。例如，假设我们在计算机中输入表达式 23 并请求其值，

computer and ask for its value, the computer basically recognizes what type of expression this is — self evaluating in this case — and therefore applies the rule for self evaluating expressions. This causes the expression to be converted into an internal representation of itself; in this case, some binary representation of the same number. For self evaluating expressions, the value is just the expression itself, so this computer simply returns that value to the print procedure, which prints the results on the screen for us to see.

计算机并请求其值，计算机基本上识别出这是什么类型的表达式——在此例中是自求值的——因此应用自求值表达式的规则。这导致表达式被转换为其自身的内部表示；在此例中，是同一个数字的某种二进制表示。对于自求值表达式，值就是表达式本身，所以计算机只是将该值返回给打印过程，打印过程将结果打印在屏幕上供我们查看。

A second kind of primitive object

第二种原语对象

To see a second kind of primitive object, it is a name for something typically created by evaluating a defined expression. Remember that a define created a pairing of a name and a value in a structure we call an environment.

为了看到第二种原语对象，它是一种事物的名称，通常通过求值 define 表达式来创建。记住，define 在我们称为环境的结构中创建了名称和值的配对。

When we ask the computer to evaluate an expression such as pi, it recognizes the type of expression, a name, and applies the name rule. This causes the computer internally to find the pairing or association of that name in the environment and to return the value that is part of that pairing as the value of the expression.

当我们要求计算机求值一个诸如 pi 的表达式时，它会识别出表达式的类型（一个名字），并应用名字规则。这会使计算机在环境中内部地找到该名字的配对或关联，并返回该配对中的值作为表达式的值。

This gets handed to the print procedure, which outputs the result.

这个值被传递给打印过程，由它输出结果。

handed to the print procedure which prints the result on the screen. Note that the internal representation of the value may be very different from what is printed out for us to see.

传递给打印过程，由它在屏幕上打印结果。注意，值的内部表示可能与打印出来供我们观看的内容大不相同。

What about special forms? Well, the first one we saw was a define. Here are the rules. They are different: we first apply our evaluation rules to the second sub expression of the define. Once we've determined that value, we then take the first sub expression without evaluation and create a pairing of that name and the computed value in a structure called an environment.

那么特殊形式呢？嗯，我们看到的第一个是 define。规则如下，它们有所不同：我们首先将求值规则应用于 define 的第二个子表达式。一旦我们确定了那个值，我们就取第一个子表达式（不求值），并在一个称为环境的结构中创建该名字与计算出的值的配对。

structure called an environment since the goal of the define expression is to create this pairing we don't really care about the value of the define expression itself it's just used for the side-effect of creating despairing and thus typically we leave the value returned by define expression as unspecified

一个称为环境的结构。由于 define 表达式的目标是创建这个配对，我们并不真正关心 define 表达式本身的值；它仅用于产生配对的副作用，因此通常我们将 define 表达式返回的值留作未指定。

so let's see what happens in our to world view suppose we type in a defined expression and evaluate it what happens here's an example the evaluator first identifies the type of expression in this case by recognizing the keyword

所以让我们看看在我们的世界观中会发生什么。假设我们输入一个 define 表达式并求值它。这里会发生什么？这是一个例子：求值器首先识别表达式的类型，在这种情况下通过识别关键字。

In this case, by recognizing the keyword 'define' at the beginning of the compound expression, it applies the rule we just described. As we saw, the evaluator now takes the second sub-expression and evaluates it using the same rule. In this case, we have a number, so the self-evaluation rule is applied.

在这种情况下，通过识别复合表达式开头的关键字 'define'，它应用我们刚刚描述的规则。正如我们所看到的，求值器现在取第二个子表达式并使用相同的规则对其进行求值。在这种情况下，我们有一个数字，因此应用自求值规则。

That value is then paired with the name or first sub-expression, gluing these two things together in a table somewhere. We don't worry about the details of the table or environment for now; we'll discuss it in detail later in the term. As noted, the actual value of the defined expression.

然后，该值与名字或第一个子表达式配对，将这两者粘合在某个表中。我们暂时不担心表或环境的细节；我们将在本学期稍后详细讨论。如前所述，define 表达式的实际值。

actual value of the defined expression is not specified, and in many Scheme implementations we use a particular undefined value. As a consequence, the value that gets returned back up to the visible world may vary in different implementations of Scheme. Most versions of Scheme will show with some information about what binding was just created, but in general we will not rely on this since it does vary with implementation.

define 表达式的实际值未指定，在许多 Scheme 实现中，我们使用一个特定的未定义值。因此，返回给可见世界的值可能因 Scheme 实现的不同而不同。大多数 Scheme 版本会显示一些关于刚刚创建的绑定的信息，但通常我们不会依赖于此，因为它随实现而变化。

These rules hold for any expression. If we just have a simple computation or combination involving a built-in arithmetic procedure, we know

这些规则适用于任何表达式。如果我们只是进行涉及内置算术过程的简单计算或组合，我们知道

built in arithmetic procedure we know that we get the values of the other sub expressions using the self evaluation rule then apply the value associated with the symbol plus two those values thus executing an addition operation but suppose we do something strange like this a rule for defined says that we get the value associated with plus and bind it together with the name Fred in our environment remember that plus is just a name so we use our name rule to find its value which in this case is actually the internal procedure for addition now

内置算术过程，我们知道我们使用自求值规则获得其他子表达式的值，然后将与符号 + 关联的值应用于这些值，从而执行加法运算。但假设我们做一些奇怪的事情，比如这样：define 的规则说我们得到与 + 关联的值，并将其与名字 Fred 绑定在我们的环境中。记住 + 只是一个名字，所以我们使用名字规则找到它的值，在这种情况下实际上是加法的内部过程。现在

internal procedure for addition now. Let's apply Fred to some argument. Notice that this just appears to be doing addition. Is that really right? Yes, it is. And let's think about why.

加法的内部过程。现在让我们将 Fred 应用于某个参数。注意，这看起来只是在做加法。真的是这样吗？是的。让我们想想为什么。

Well, our rules really do explain this. The defined expression says to pair the name thread with the value of Plus. Note that Plus is just a name; it happens to be the one that was created when Scheme was started. Its value, we saw, is a procedure: the internal procedure for addition.

嗯，我们的规则确实解释了这一点。define 表达式说将名字 Fred 与 + 的值配对。注意，+ 只是一个名字；它恰好是 Scheme 启动时创建的那个。我们看到，它的值是一个过程：加法的内部过程。

Hence, the defined expression creates a binding for Fred to addition. Thus, when we evaluate the combination, our rule...

因此，define 表达式为 Fred 创建了一个到加法的绑定。因此，当我们求值组合时，我们的规则...

we evaluate the combination our rule says to get the values of the sub expressions and hence the name Fred is evaluated using the name rule to get the addition procedure this is then applied to the values of the numbers to generate the displayed result as an example if I ask for the value associated with one of these built-in names my rules explain what happens since this is a name its value is looked up in the environment in this case that value is some internal representation of the procedure for multiplication for example a pointer to

我们求值组合时，规则说获取子表达式的值，因此名字 Fred 使用名字规则求值，得到加法过程。然后将其应用于数字的值，以生成显示的结果。例如，如果我询问这些内置名字之一的值，我的规则解释了会发生什么。由于这是一个名字，它的值在环境中查找。在这种情况下，该值是乘法的某种内部表示，例如指向

multiplication, for example, a pointer to the part of the eternal or arithmetic unit that does multiplication, that value is returned as the value of this expression. And the print procedure then displays the result, showing some representation of where the procedure lives within the machine. The main issue is to see that this symbol has a value associated with it, in this case a primitive procedure.

乘法的指针，例如指向机器内部或算术单元中执行乘法的部分的指针。该值作为此表达式的值返回。然后打印过程显示结果，展示过程在机器中位置的某种表示。主要问题是看到这个符号有一个与之关联的值，在这种情况下是一个原始过程。

Thus, what we have seen so far is ways to utilize primitive data and procedures, ways to create combinations, and ways to give names to things. In the next section, we'll turn to

因此，到目前为止我们看到的是一种利用原始数据和过程的方法，创建组合的方法，以及给事物命名的方法。在下一节中，我们将转向

things in the next section we'll turn to the idea of capturing common patterns in

事物。在下一节中，我们将转向捕获常见模式的思想。