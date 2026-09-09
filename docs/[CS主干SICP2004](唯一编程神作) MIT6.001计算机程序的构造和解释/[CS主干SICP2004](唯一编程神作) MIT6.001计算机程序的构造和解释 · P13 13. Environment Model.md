# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=13)

## Summary (摘要)

- The substitution model of evaluation fails to explain the behavior of procedures that mutate state, such as counters that return different values each time they are called.
- The environment model introduces frames, bindings, and environments—sequences of frames—to provide a mechanistic account of variable lookup, definition, assignment, and procedure application.
- Lambda expressions create procedure objects with pointers to their code and to the environment in which they were evaluated, capturing lexical scope.
- Applying a compound procedure creates a new frame linked to the procedure's environment, binds formal parameters to arguments, and evaluates the body in that new environment.
- Define creates or replaces a binding in the current frame, while set! searches up the environment chain to mutate an existing binding.
- The environment model explains how a procedure like a counter can maintain local mutable state across calls, and why different procedures created from the same expression have independent state.

- 替换模型无法解释修改状态的过程的行为，例如每次调用时返回不同值的计数器。
环境模型引入了框架、绑定和环境——框架的序列——以提供变量查找、定义、赋值和过程应用的机械论解释。
Lambda 表达式创建过程对象，这些对象带有指向其代码和其求值环境的指针，从而捕获词法作用域。
应用复合过程会创建一个新框架，该框架链接到过程的环境，将形式参数绑定到实参，并在该新环境中求值过程体。
Define 在当前框架中创建或替换绑定，而 set! 则沿环境链向上搜索以修改现有绑定。
环境模型解释了像计数器这样的过程如何在多次调用中保持局部可变状态，以及为什么由同一表达式创建的不同过程具有独立的状态。

## Outline (大纲)

1. Introduction: Why the Substitution Model Fails with Mutation
2. Goals and Overview of the Environment Model
3. Core Concepts: Frames, Bindings, Environments, and Global Environment
4. Evaluation Rules: Names, Define, and Set!
5. More on Define, Set!, and Error Cases
6. Procedures as Double Bubbles: Lambda and the Environment Pointer
7. Applying a Compound Procedure: The Four-Step Mechanistic Rule
8. Worked Example: Evaluating (square 4)
9. Worked Example: Evaluating (inc-square 4) with Nested Application
10. Counter Example: Capturing Local State with make-counter and Independent Procedures CA and CB

1. 引言：为什么替换模型在修改中失效
环境模型的目标与概述
核心概念：框架、绑定、环境和全局环境
求值规则：名称、Define 和 Set!
关于 Define、Set! 和错误情况的更多内容
过程作为双气泡：Lambda 和环境指针
应用复合过程：四步机械规则
示例：求值 (square 4)
示例：求值 (inc-square 4) 及嵌套应用
计数器示例：使用 make-counter 捕获局部状态以及独立过程 CA 和 CB

## Transcript (转录)

### 1. Introduction: Why the Substitution Model Fails with Mutation (引言：为什么替换模型在修改中失效)

In the last lecture, we introduced mutation as a component of our data structures. We saw, for example, that set! was a way of changing the value associated with a variable, and set-cdr! and set-car! were ways of changing the elements of a list structure.

在上一讲中，我们引入了修改作为数据结构的一个组成部分。例如，我们看到 set! 是一种改变与变量关联的值的方式，而 set-cdr! 和 set-car! 是改变列表结构元素的方式。

Now, several important things happened when we introduced mutation. First, we introduced the notion of time and context into our interpretation of Scheme. The order in which things were evaluated now mattered in terms of the kinds of values we saw coming back out.

现在，当我们引入修改时，发生了几个重要的事情。首先，我们在 Scheme 的解释中引入了时间和上下文的概念。求值的顺序现在在结果值的种类方面变得重要。

kinds of values we saw coming back out as a consequence. Secondly, we shifted from a functional programming perspective to a more state-based programming perspective, a point we're going to come back to.

结果值的种类。其次，我们从函数式编程视角转向了基于状态的编程视角，这一点我们稍后会再讨论。

Third, we unfortunately introduced the opportunity for bugs and errors, since shared objects allow mutation of one to affect the value of another, and we're going to come back to that point as well.

第三，不幸的是，我们引入了错误和缺陷的机会，因为共享对象允许对一个对象的修改影响另一个对象的值，这一点我们也会再讨论。

And finally, fourth, we broke the substitution model. Now, this last point needs to be addressed, and indeed, in addressing it, we're going to address many of the other.

最后，第四，我们打破了替换模型。现在，这最后一点需要解决，事实上，在解决它的过程中，我们将解决许多其他问题。

We're going to address many of the other points I've just raised, and so today that's what we're going to do. We're going to replace the substitution model with a stronger model that incorporates the substitution model as a piece of it, but also accounts for state, time, context, and mutation.

我们将解决我刚才提出的许多其他问题，所以今天这就是我们要做的。我们将用更强的模型替换替换模型，该模型包含替换模型作为其一部分，但也解释了状态、时间、上下文和修改。

Now, to stress this point—to stress the idea that the substitution model no longer works—take a look at this code. Why does it behave this way? We can see that make counter is a higher-order procedure; it's a procedure that returns a procedure as a value.

现在，为了强调这一点——为了强调替换模型不再起作用的想法——看看这段代码。为什么它表现得这样？我们可以看到 make-counter 是一个高阶过程；它是一个返回过程作为值的过程。

But notice that if we create a counter...

但请注意，如果我们创建一个计数器...

notice that if we create a counter called CA and we call it several times, it simply increases its value by 1 each time it's called. Thus, the standard substitution model, the functional programming model, doesn't hold because evaluating exactly the same expression open paren CA close print is leading to different values depending on when we actually evaluate it.

请注意，如果我们创建一个名为 CA 的计数器并多次调用它，它每次调用时只是将其值增加 1。因此，标准的替换模型，即函数式编程模型，不成立，因为对完全相同的表达式 (CA) 的求值会根据我们实际求值的时间产生不同的值。

secondly, if we create a second counter defining CB to be the value associated with evaluating make counter, which itself is the same expression that we got when we define CA, we end up with different structures.

其次，如果我们创建第二个计数器，将 CB 定义为对 make-counter 求值所关联的值，这本身与我们定义 CA 时得到的表达式相同，我们最终会得到不同的结构。

we end up with different structures. Calling CB and then CA shows that the two are independent, they don't behave as if they were shared in any way. So our substitution model is broken, mutation has caused that to happen. We need to come up with a better model to explain how code like this works the way it does.

我们最终会得到不同的结构。调用 CB 然后调用 CA 表明两者是独立的，它们的行为不像以任何方式共享。所以我们的替换模型被打破了，修改导致了这种情况。我们需要提出一个更好的模型来解释像这样的代码如何以这种方式工作。

### 2. Goals and Overview of the Environment Model (环境模型的目标与概述)

To do this, we will introduce a better model of evaluation, and this is known as the environment model. This model will both explain mutation, as well as standard things that were explained by the substitution model, and it's going to

为此，我们将引入一个更好的求值模型，这被称为环境模型。该模型将解释修改，以及替换模型所解释的标准事物，并且它将

The substitution model and it's going to lead us to war, lead us to war, lead us to war — a much better understanding of the notion of evaluation in general. So what is the environment model? Well, for now, you should think of it as a very precise, very mechanical description of a set of rules.

替换模型，它将引导我们走向战争，走向战争，走向战争——对求值概念的整体有更好的理解。那么什么是环境模型？嗯，目前，你应该把它看作一组非常精确、非常机械的规则。

A set of rules for determining the values associated with expressions, similar to what we saw earlier. We'll see a rule for dealing with getting the value of a variable, a rule for creating definitions of variables, a rule for changing the values of variables, a rule for creating procedures, and a rule for

一组用于确定与表达式关联的值的规则，类似于我们之前看到的。我们将看到一个用于获取变量值的规则，一个用于创建变量定义的规则，一个用于改变变量值的规则，一个用于创建过程的规则，以及一个用于

for creating procedures and a rule for applying procedures but the key issue is it's a very mechanical precise description of exactly how values are associated with expressions so our goal

创建过程和应用过程的规则，但关键问题是它是对值如何与表达式关联的非常机械、精确的描述，所以我们的目标

will be first to determine the specific rules for the environment model for these kinds of expressions once we've set out those details we'll be able to explain the evaluation and evolution of arbitrarily complex code including things like the example we just saw more importantly by using the model to analyze code we'll learn how to associate particular coding choices with

将首先是确定环境模型对这些类型表达式的具体规则，一旦我们制定了这些细节，我们将能够解释任意复杂代码的求值和演化，包括我们刚才看到的例子，更重要的是，通过使用该模型分析代码，我们将学习如何将特定的编码选择与

associate particular coding choices with their effects and thus we'll be able to work the other way around having decided what behavior we need for some problem we'll be able to create appropriate code including code that involves mutation as well as normal functional kinds of programming and we really have two reasons for doing this

将特定的编码选择与其效果联系起来，这样我们就能反过来工作：在决定了某个问题需要什么行为之后，我们就能创建合适的代码，包括涉及变更以及常规函数式编程的代码。我们这样做确实有两个原因。

the first is in fact just to deal with understanding what happens when we make choices in our code to deal with the abilities to have side effects a mutation in our language and understand how to control it

第一个原因实际上只是为了理解当我们对代码做出选择时会发生什么，以处理语言中的副作用和变更的能力，并理解如何控制它。

how to control it, but ultimately we're going to see that in fact the model will build this environment model. It is the blueprint for building an interpreter for scheme that is the guts of the code that actually allows us to evaluate any expression, the thing that makes scheme run.

如何控制它，但最终我们将看到，事实上这个模型将构建出这个环境模型。它是为Scheme构建解释器的蓝图，也就是真正允许我们求值任何表达式的代码核心，是让Scheme运行起来的东西。

As a consequence, for now certainly starting today, we're going to draw an environment model somewhat abstractly, using very sort of notations and graphical manipulations to deal with what's going on inside of it. But we'll see that in fact it leads to a very mechanical idea.

因此，至少从今天开始，我们将以某种抽象的方式绘制环境模型，使用各种符号和图形操作来处理其内部发生的事情。但我们将看到，这实际上引向一个非常机械化的观念。

### 3. Core Concepts: Frames, Bindings, Environments, and Global Environment (核心概念：框架、绑定、环境与全局环境)

fact it leads to a very mechanical idea that can be effect implemented in code and we'll do that in a few lectures time as we build up the pieces of our environment model a key thing to keep in mind is that we're about to shift our viewpoint on what constitutes the basic units of computation until we introduce mutation we could think of a variable as just being a name for a value that was exactly how it behaved in that sort of functional viewpoint of computation now we're going to change that viewpoint we're going to think of a variable as a

事实上，它引向一个非常机械化的观念，可以在代码中有效实现，我们将在几节课内做到这一点，随着我们构建环境模型的各个部分。要记住的一个关键点是，我们即将转变关于什么构成计算基本单元的观点。在引入变更之前，我们可以把变量看作值的名称，这正是它在那种函数式计算观点中的行为方式。现在我们将改变这种观点，我们将把变量看作一个

we're going to think of a variable as a place into which one can store things a name for a placeholder or a box or a cubicle into which things can be placed the second change we're going to make deals with procedures up until now we could really think about procedures as if they were functional descriptions of some computation we stressed this idea that evaluating the same expression gave rise to the same value it behaved as a mapping from input values to output values like any ordinary function would now we're going to change that view we're going to change our view of

我们将把变量看作一个可以存放东西的地方，一个占位符的名称，或者一个盒子，或者一个隔间，可以把东西放进去。我们要做的第二个改变涉及过程。到目前为止，我们确实可以把过程看作某种计算的功能描述。我们强调过，对同一表达式求值会产生相同的值，它表现为从输入值到输出值的映射，就像任何普通函数一样。现在我们将改变这种观点，我们将改变对过程的看法，

we're going to change our view of procedure to instead think of a procedure as an object with an inherited context a context that tells us how to interpret symbols in that computation

我们将改变对过程的看法，转而把过程看作一个具有继承上下文的对象，这个上下文告诉我们如何解释该计算中的符号。

and that's going to change the way we think about computation overall and finally we're going to change the way we think about expressions we're going to now say that an expression only has meaning with respect to a structure called an environment something we're both to build but this means that expressions now inherit their interpretation or their value by

这将改变我们整体上对计算的思考方式。最后，我们将改变对表达式的思考方式。我们现在要说，一个表达式只有相对于一个称为环境的结构才有意义，这个结构我们即将构建。但这意味着表达式现在通过继承关于它们创建时情况的信息来获得它们的解释或值。

Interpretation or their value by inheriting information about what was going on when they were created and we'll see why that changes our viewpoint of computation as we go through the rest of this lecture. So we ask you to keep those three things in mind as we now build up this new model of computation.

解释或值是通过继承关于它们创建时情况的信息而获得的，我们将在本讲剩余部分看到为什么这会改变我们对计算的看法。因此，在我们构建这个新的计算模型时，我们请求你记住这三件事。

Variables are now places into which one can store things, procedures are now objects within inherited context, and expressions have meaning with respect to an environment. So now let's start building up our environment model. First of all, if variables should now be

变量现在是存放东西的地方，过程是带有继承上下文的对象，表达式相对于环境才有意义。那么现在让我们开始构建我们的环境模型。首先，如果变量现在应该被

All of if variables should now be thought of as places. We need a way of organizing them, so the first piece of an environment is something we call a frame. This just consists of a table of bindings, and a binding here refers to a pairing of a name and a slot into which a value can be stored that will be associated with that name.

如果变量现在应该被看作场所，我们需要一种组织它们的方式，所以环境的第一个部分是我们称之为框架的东西。它仅由一个绑定表组成，这里的绑定指的是名称与槽位的配对，槽位中可以存储与该名称关联的值。

In terms of an abstract schematic for keeping track of that, here is a table of bindings, table A, which we also refer to as a frame. It has two bindings in it: it has a binding for the variable X and a binding for the

就用于跟踪的抽象示意图而言，这里是一个绑定表，表A，我们也称之为框架。它包含两个绑定：一个用于变量X的绑定和一个用于

the variable X and a binding for the variable Y and in particular we say that X is bound to the value of 15 within frame a and Y is bound to the value of the list 1/2 within frame a notice that the value of the variable within this frame is therefore given by the value 15 or better way of saying it is the expression X has a value associated with this frame and it's the value obtained by looking up the binding of X is destructor this table in a second we'll talk about how we actually establish bindings in these frames but for now we've got the fer

变量X的绑定和一个用于变量Y的绑定。特别地，我们说在框架A中，X被绑定到值15，Y被绑定到列表1/2。注意，变量在该框架中的值因此由值15给出，或者更好的说法是，表达式X具有与该框架关联的值，它是通过在该表中查找X的绑定而获得的值。稍后我们将讨论如何在这些框架中实际建立绑定，但就目前而言，我们已经有了环境模型的第一个部分。

we've got the first piece of our environment model: a frame is a table of bindings, a binding is simply a pairing of a name and a value. Now, an environment consists of a sequence of frames for reasons that we'll see shortly. So here's our frame from before, with the bindings we had, and here's a second frame with its own set of bindings.

我们已经有了环境模型的第一个部分：框架是绑定的表，绑定只是名称和值的配对。现在，一个环境由一系列框架组成，原因我们很快就会看到。所以这是我们之前的框架，带有我们已有的绑定，这是第二个框架，带有它自己的一组绑定。

Now an environment is a nested sequence of frames, so environment E1 will consist in this case of frame A followed by frame B. A second environment E2 might just consist of frame B, so note that a frame can be shared by multiple environments.

现在，一个环境是一个嵌套的框架序列，所以环境E1在这种情况下将由框架A后跟框架B组成。第二个环境E2可能只由框架B组成，所以请注意，一个框架可以被多个环境共享。

Note that a frame can be shared by several environments, and in fact we'll see why that's going to be a very powerful thing in a few slides. The connection between frames is important and is called an enclosing environment pointer.

注意，一个框架可以被多个环境共享，事实上，我们将在几张幻灯片后看到为什么这将是一个非常强大的特性。框架之间的联系很重要，被称为外围环境指针。

So for example, E1 starts with frame A and inherits frame B as the enclosing environment, which in fact is similar to E2 or that environment. We'll see shortly why all of these pieces put together make us understand exactly how evaluation is going to proceed.

例如，E1从框架A开始，并继承框架B作为外围环境，这实际上与E2或那个环境相似。我们很快就会看到，所有这些部分组合在一起如何使我们理解求值究竟如何进行。

Now, so far we've just been talking about details.

现在，到目前为止我们只是在讨论细节。

been talking about details

只是在讨论细节

been talking about details, we've got frames which are tables of bindings, we've got connections between frames, we've got environments as sequences of frames. With all of these pieces in mind, we can now start relating them to the actual evaluation of expressions.

只是在讨论细节，我们有框架，即绑定表，我们有框架之间的联系，我们有作为框架序列的环境。有了所有这些部分，我们现在可以开始将它们与实际表达式的求值联系起来。

Now we're ready to see how to connect environments to evaluation first. As we've already suggested, all evaluation is going to take place with respect to some environment that's going to be the place that provides the context for how to interpret symbols and names.

现在我们准备看看如何首先将环境与求值联系起来。正如我们已经暗示的，所有的求值都将相对于某个环境进行，这个环境将提供解释符号和名称的上下文。

### 4. Evaluation Rules: Names, Define, and Set! (求值规则：名称、定义和 set!)

Notice that this won't always be the same environment, and in fact, a key issue is that whenever we apply a procedure, we will create a new environment which captures the context for interpreting the variables of that procedure.

注意，这并不总是同一个环境，实际上，一个关键问题是，每当我们应用一个过程时，我们都会创建一个新环境，该环境捕获了解释该过程变量的上下文。

Now, we've said all evaluation of expressions is going to take place with respect to an environment, and we've also seen that environments can inherit other environments as part of the chaining process.

现在，我们已经说过，所有表达式的求值都将相对于某个环境进行，并且我们也看到环境可以继承其他环境作为链接过程的一部分。

Nonetheless, this means that eventually we have to have some way of stopping that chaining of environments and to terminate that.

尽管如此，这意味着最终我们必须有某种方式来停止环境的链接并终止它。

Of environments and to terminate that chain, we have a special environment called the global environment. It has no enclosing frame and is the only such environment with that property. This is the environment in which we will normally evaluate expressions; it's our starting point, and it's going to hold the base set of expressions for our language.

为了终止这个链，我们有一个特殊的环境，称为全局环境。它没有外围框架，并且是唯一具有此属性的环境。这是我们通常求值表达式的环境；它是我们的起点，并且它将保存我们语言的基础表达式集。

So we're ready to start putting together rules for evaluating expressions with respect to environments. Before we do, let's remind you that our central rule for evaluation dealt with combinations, and in this new model, things are nearly unchanged.

所以我们准备开始制定相对于环境求值表达式的规则。在此之前，让我们提醒您，我们的核心求值规则处理组合，在这个新模型中，事情几乎不变。

and in this new model things are nearly the same as they were in the substitution model as before we will evaluate the sub expressions now with respect to in the current environment and then we're going to apply the value of the first sub expression to the values of the others we'll see shortly how to do that in a very mechanistic way but it says that basically our combination rule is going to be very similar to what we did before

在这个新模型中，事情与替换模型中的几乎相同，和以前一样，我们现在将在当前环境中求值子表达式，然后将第一个子表达式的值应用于其他子表达式的值。我们很快就会看到如何以非常机械的方式做到这一点，但这说明我们的组合规则将与我们之前所做的非常相似。

with all of this in place let's actually start building the environment model then okay we're ready to start looking at our

有了这些，让我们真正开始构建环境模型吧。好的，我们准备开始审视我们的……

我们准备开始审视这个新模型中的求值规则，特别是将它们与环境模型以及环境如何被创建和操纵联系起来。首先，我们语言中最简单的表达式是数字，这些是自求值的，这意味着它们的值就是它们本身，无论环境是什么，所以对于数字确实没什么好说的。

我们准备开始审视这个新模型中的求值规则，特别是将它们与环境模型以及环境如何被创建和操纵联系起来。首先，我们语言中最简单的表达式是数字，这些是自求值的，这意味着它们的值就是它们本身，无论环境是什么，所以对于数字确实没什么好说的。

第一个有趣的规则出现在处理名字时。我们有办法处理名字的求值，这是我们最简单的原始类型之一，而这条规则应该告诉我们如何获取相应的值。

第一个有趣的规则出现在处理名字时。我们有办法处理名字的求值，这是我们最简单的原始类型之一，而这条规则应该告诉我们如何获取相应的值。

That rule should tell us how to get the value associated with a variable. The rule is straightforward but quite mechanistic. So let's say clearly: a name X evaluated in environment E gives back the value of X in the first frame of E where X is bound.

该规则应该告诉我们如何获取与变量关联的值。该规则简单但非常机械。所以让我们明确地说：名字 X 在环境 E 中求值，返回 X 在 E 的第一个框架中绑定 X 的值。

Remember, an environment is a sequence of frames. So we will start in the first frame and look for a binding of that name, and continue up the frames until we find the first such binding, in which case we return the value associated with that name.

记住，环境是一个框架序列。所以我们将从第一个框架开始，查找该名字的绑定，并继续向上查找框架，直到找到第一个这样的绑定，在这种情况下，我们返回与该名字关联的值。

So here are our example environments from before.

所以这是我们之前的示例环境。

are our example environments from before we're called the top-level environment we're called the top-level environment we're called the top-level environment the global environment it's our stop-gap the global environment it's our stop-gap the global environment it's our stop-gap environment and E one has its own frame environment and E one has its own frame environment and E one has its own frame and inherits as an enclosing environment and inherits as an enclosing environment and inherits as an enclosing environment pointer at the global environment we can pointer at the global environment we can pointer at the global environment we can now talk about the value of a variable now talk about the value of a variable now talk about the value of a variable with respect to an environment and in with respect to an environment and in with respect to an environment and in fact we should always talk about values fact we should always talk about values fact we should always talk about values of anything with respect to some of anything with respect to some of anything with respect to some environment so for example we can ask environment so for example we can ask environment so for example we can ask what is the value of the variable Z with what is the value of the variable Z with what is the value of the variable Z with respect to the global environment and respect to the global environment and respect to the global environment and notice the little notation I'm going to notice the little notation I'm going to

这是我们之前的示例环境，我们称之为顶层环境，我们称之为全局环境，它是我们的止损环境，而 E1 有自己的框架，并继承作为外围环境指针指向全局环境。我们现在可以谈论变量相对于环境的值，事实上，我们应该总是谈论任何东西相对于某个环境的值。例如，我们可以问变量 Z 相对于全局环境的值是什么，注意我将使用的小符号……

Notice the little notation I'm going to use here. I'm going to give the expression and then a vertical bar to indicate that I'm doing the evaluation with respect to some environment, and then a subscript notation to indicate that in this case I'm asking for the value of Z with respect to the global environment.

注意我将在这里使用的小符号。我将给出表达式，然后一个竖线表示我正在相对于某个环境进行求值，然后一个下标符号表示在这种情况下，我正在询问 Z 相对于全局环境的值。

Note as well that would be the normal place in which I would type to the computer. If I type in Z at top level, it's talking to the global environment, and I want to do the lookup there. Our rule we can now use the value of this variable Z with respect to the global.

还要注意，这将是我通常输入计算机的正常位置。如果我在顶层输入 Z，它是在与全局环境对话，我想在那里进行查找。我们的规则现在可以使用变量 Z 相对于全局环境的值。

variable Z with respect to the global environment is clearly 10 that's the pairing associated with it. If I ask for the value of Z with respect to the environment II won I start in frame a, the first frame of that environment, there is no binding for Z available there, so I move up the enclosing environment pointer to the next frame in this case frame B and ask for the binding of Z there in this case there is one and I return again the value 10.

变量 Z 相对于全局环境的值显然是 10，这是与之关联的配对。如果我询问 Z 相对于环境 E1 的值，我从框架 a 开始，该环境的第一个框架，那里没有 Z 的绑定，所以我沿着外围环境指针向上移动到下一个框架，在这种情况下是框架 B，并询问 Z 的绑定，在这种情况下有一个，我再次返回值 10。

Finally, if I ask for the value of X with respect to global environment II won it points to the first frame a.

最后，如果我询问 X 相对于全局环境的值，它指向第一个框架 a。

I won it points to the first frame a I look for a binding of X there and having found one return the value 15 on the other hand if I ask for the value of X with respect to the global environment the global environment points to frame B so I start there I have a binding for X in that frame and I returned therefore the value associated with it which is the value 3 in this case we can see that X has a different value in different environments and e1 its value is 15 in e3 sorry in global environment its value is 3 and we say in fact that the binding

它指向第一个框架 a，我在那里查找 X 的绑定，找到后返回值 15。另一方面，如果我询问 X 相对于全局环境的值，全局环境指向框架 B，所以我从那里开始，我在该框架中有 X 的绑定，因此返回与之关联的值，在这种情况下是值 3。我们可以看到 X 在不同的环境中具有不同的值，在 e1 中它的值是 15，在全局环境中它的值是 3，我们实际上说绑定……

is 3 and we say in fact that the binding of X in frame a shadows the binding of X in frame B it hides it so that when we start in frame a or environment a 1 we only see the binding of X to 15

是 3，我们说实际上，X 在框架 a 中的绑定遮蔽了 X 在框架 B 中的绑定，它隐藏了它，所以当我们从框架 a 或环境 a1 开始时，我们只能看到 X 绑定到 15。

nonetheless we now see how the name rule tells us the mechanism by which we look up the value associated with the variable in some environment okay we have a rule for looking up values associated with variables

然而，我们现在看到了名字规则如何告诉我们查找变量关联值的机制，好的，我们有了一个用于查找变量关联值的规则。

now what about the rule for creating bindings of variables and values of course that's a defined expression and we have this rule for dealing with that a defined special

那么关于创建变量和值绑定的规则呢？当然，那是一个定义表达式，我们有一个规则来处理它，即 define 特殊形式。

for dealing with that a defined special form when evaluated with respect to some environment e creates or replaces a binding in the first frame of e and it always does it in the first frame of E.

用于处理该 define 特殊形式，当相对于某个环境 E 求值时，它会在 E 的第一个框架中创建或替换一个绑定，并且它总是在 E 的第一个框架中进行。

so here's our environment structure from before let's look at what defines do when they're evaluated with respect to this environment structure. first let's suppose we evaluate define of Z to xx in the global environment. as I said before this would be the kind of thing you would type into the computer you're dealing with the global environment. this

所以这是我们之前的环境结构，让我们看看 define 相对于这个环境结构求值时做了什么。首先，假设我们在全局环境中求值 define Z 为 20。正如我之前所说，这将是你在计算机上输入的那种表达式，你处理的是全局环境。

Dealing with the global environment, this is an expression you might normally evaluate. What happens? Well, note what the rule says. It says create a binding or replace a binding for the variable in this case Z in the first frame of the environment, in this case the global environment, so that old binding for Z as 10 gets replaced by new binding of Z equal to 20.

处理全局环境时，这是一个你可能通常求值的表达式。会发生什么？嗯，注意规则所说的。它说在环境的第一框架中为变量（此处为 Z）创建或替换绑定，在这种情况下是全局环境，所以 Z 的旧绑定 10 被 Z 等于 20 的新绑定替换。

On the other hand, suppose we evaluate a defined statement of Z to 25 in the environment II won. What happens in this case? We'll remember our rule. It says create a replace a binding for the variable in the first frame of the

另一方面，假设我们在环境 a1 中求值 define 语句 Z 为 25。在这种情况下会发生什么？我们记住我们的规则。它说在环境的第一框架中为变量创建或替换绑定，所以在这种情况下，我们在框架 a（环境 a 的第一框架）中进行。

variable in the first frame of the environment, so in this case we do it in frame a, the first frame of environment a. And since there is no current binding for Z in that frame, we create a new one. And we've now set up a shadowing of Z. The Z bound of 25 in frame a will shadow the binding of Z to 20 in frame B, similar to what we saw in the previous slide.

由于该框架中没有 Z 的当前绑定，我们创建一个新的。我们现在已经设置了 Z 的遮蔽。框架 a 中 Z 绑定为 25 将遮蔽框架 B 中 Z 绑定为 20，类似于我们在上一张幻灯片中看到的。

Now we have a rule for looking up values of variables, we have a rule for creating bindings of values and variables, we also should have a rule for dealing with mutation of variables.

现在我们有了查找变量值的规则，有了创建值和变量绑定的规则，我们还应该有一个处理变量变更的规则。

### 5. More on Define, Set!, and Error Cases (关于 Define、Set! 和错误情况的更多内容)

Dealing with mutation of variables, that'll be our set bang rule, our mutator rule. And here the rule is as follows: mutating a variable X doing set bang on it, if we evaluate such an expression with respect to an environment E, it changes the binding of X in the first frame of E where such a binding occurs. Look at this carefully, it's different from define, and we want to show exactly why.

处理变量的变更，那将是我们的 set bang 规则，即我们的变更器规则。这里的规则如下：变更变量 X，对其执行 set bang，如果我们相对于环境 E 求值这样的表达式，它会改变 X 在 E 的第一个框架中的绑定，该绑定出现在那里。仔细看，这与 define 不同，我们想确切地展示为什么。

So here's that environment structure we had before. Let's look at what happens when we evaluate set banging expressions with respect to this structure. So let's

所以这是我们之前的环境结构。让我们看看当我们相对于这个结构求值 set bang 表达式时会发生什么。让我们

Respect to this structure, so let's evaluate set bang of Z - 20 with respect to the global environment, and let's see what happens. Well, the rule says find the first frame in this environment in which there's a binding for this variable. We're doing it with respect to the global environment, and there is such a binding for Z. So we change it in place: of Z, we take the value of 20 and substitute that in, causing a mutation. Notice, if we look back at the previous slide, the effect here is exactly the same as a define.

相对于这个结构，让我们相对于全局环境求值 set bang Z - 20，看看会发生什么。嗯，规则说在这个环境中找到第一个包含该变量绑定的框架。我们相对于全局环境进行，那里有 Z 的绑定。所以我们就地改变它：对于 Z，我们取 20 的值并替换进去，导致变更。注意，如果我们看上一张幻灯片，这里的效果与 define 完全相同。

So why do we have two different forms? Well, let's evaluate set.

那么我们为什么有两种不同的形式呢？嗯，让我们求值 set

different forms well let's evaluate set bang of Z - 25 with respect to environment a 1 and let's see what happens now remember what the rule says it says starting in frame a 1 find a binding for Z there isn't one in frame a so we go up the enclosing environment pointer to frame B fortunately there is a binding for Z there so we change that binding that is we actually change the value in the slot associated with Z removing the old value of 20 and replacing with the new value of 25

不同的形式，让我们相对于环境 a1 求值 set bang Z - 25，看看现在会发生什么。记住规则所说的，它说从框架 a1 开始，找到 Z 的绑定，框架 a 中没有，所以我们沿着环境指针向上到框架 B，幸运的是那里有 Z 的绑定，所以我们改变那个绑定，即我们实际上改变了与 Z 关联的槽中的值，移除旧值 20 并用新值 25 替换。

compare this to what happened when we did a define on the previous slide

将此与我们在上一张幻灯片中执行 define 时发生的情况进行比较

did a define on the previous slide. Notice that now that change has taken place in a different spot, set bang always looks for an existing binding of a variable, walking up the chain of frames until it finds one, and then changing or mutating that value.

在上一张幻灯片中执行 define 时发生的情况。注意，现在这个改变发生在不同的位置，set bang 总是寻找变量的现有绑定，沿着框架链向上走直到找到一个，然后改变或变更那个值。

Define always creates a binding in the current frame, even if there was a previous binding there. Okay, let's see if you're getting these ideas. Here are a set of expressions that we'd like you to evaluate in order.

Define 总是在当前框架中创建绑定，即使那里之前有绑定。好的，让我们看看你是否理解了这些概念。这里有一组表达式，我们希望您按顺序求值。

Take a second to see what each one of them does, then click on the mouse button.

花点时间看看每一个做什么，然后点击鼠标按钮。

Then click on the mouse button to see what the actual expression should be or what the effect should be in each case. Well, the first one's straightforward, but let's do it very carefully. Evaluating this expression with respect to e1 says get the value of Z, which we start in e1 and move up the frame until we find a binding which happens to be 10. Get the value of 1, which of course is 1, and then add them together to return the value 11. Doing the mutation of Z with respect to e1 says first get the value of plus zi1 with respect to e1; just did that, we know.

然后点击鼠标按钮，看看实际表达式应该是什么，或者每种情况下的效果应该是什么。嗯，第一个很简单，但让我们非常仔细地做。相对于 e1 求值这个表达式说获取 Z 的值，我们从 e1 开始向上移动框架直到找到绑定，恰好是 10。获取 1 的值，当然是 1，然后将它们相加返回 11。相对于 e1 执行 Z 的变更说首先获取 plus Z 1 相对于 e1 的值；刚刚做了，我们知道

With respect to e1, we just did that. We know it's going to be 11. Then it says, starting at e1, we may find a binding for Z. There isn't one in A, so go up the enclosing environment pointer to frame B. Ah, there's the binding for Z. Change it to the value we just evaluated, namely change that 10 to 11.

相对于 e1，我们刚刚做了。我们知道它将是 11。然后它说，从 e1 开始，我们可能找到 Z 的绑定。A 中没有，所以沿着环境指针向上到框架 B。啊，那里有 Z 的绑定。将其改变为我们刚刚求值的值，即将 10 改为 11。

Now let's do a define with respect to e1. Remember we get the value of the subexpression plus Z 1 with respect to e1. And just as we did before, we start at e1. There is no binding for Z there. We go up the enclosing environment pointer to find the binding.

现在让我们相对于 e1 执行 define。记住我们获取子表达式 plus Z 1 相对于 e1 的值。正如我们之前所做，我们从 e1 开始。那里没有 Z 的绑定。我们沿着环境指针向上找到绑定。

enclosing environment pointer find the binding for Z which is now 11 add that to the value of 1 which is 1 giving us 12 and then create a binding for Z in e1 notice where that happens we create a pairing of the variable Z and the gist computed value 12 in e1 or in particular in the first frame of e1 frame a and the last one we try to sneak by u we can still get the value of plus zi1 with respect to the global environment that's just going to be 12 but trying to do a set bang of y with respect to the global environment will fail.

外层环境指针找到 Z 的绑定，现在是 11，将其加到 1 的值（即 1）上，得到 12，然后在 e1 中为 Z 创建绑定。注意这发生在哪里：我们在 e1 中，特别是在 e1 的第一个帧（帧 a）中，创建了变量 Z 与计算出的值 12 的配对。最后，我们试图偷偷绕过 u，我们仍然可以在全局环境中获取 plus zi1 的值，那只是 12，但试图在全局环境中对 y 执行 set! 将会失败。

environment will fail note we start in the global environment looking for a binding of Y there isn't one there but there's no other enclosing environment to go up to and so we have an error we cannot create that binding remember we never see the binding for y with respect to the global environment that's down in e1 and that's not accessible to us arno enclosing environment pointers getting to that point.

环境将会失败。注意，我们从全局环境开始寻找 Y 的绑定，那里没有，但也没有其他外层环境可以继续向上查找，因此我们得到一个错误：我们不能创建那个绑定。记住，我们从未在全局环境中看到 y 的绑定，它位于 e1 中，我们无法访问它，因为外层环境指针无法到达那个点。

### 6. Procedures as Double Bubbles: Lambda and the Environment Pointer (过程作为双气泡：Lambda 与环境指针)

next we need to deal with lambda expressions and here we see a big change in our view of evaluation and computation first we're going to introduce a more explicit

接下来我们需要处理 lambda 表达式，这里我们看待求值和计算的方式将发生重大变化。首先，我们将引入一个更显式的

evaluation and computation first we're going to introduce a more explicit

求值和计算的方式将发生重大变化。首先，我们将引入一个更显式的

going to introduce a more explicit notion or notation for the procedure created by the evaluation of a lambda expression. If we go back to our two-view world, which we used when talking about the substitution model, remember that we said evaluation of a lambda using its rule created a compound procedure in the evaluation world, and that that gave a printed form that identified it is such back in the visible world.

我们将引入一个更显式的概念或记号，用于表示由 lambda 表达式求值所创建的过程。如果我们回到讨论替换模型时使用的双视角世界，记得我们说过，在求值世界中，lambda 的求值规则创建了一个复合过程，并且在可见世界中，它给出了一种打印形式，将其标识为这样的过程。

In the environment model, we're going to be much more explicit and mechanistic about what it means to create a compound procedure.

在环境模型中，我们将更加显式和机械地说明创建复合过程意味着什么。

it means to create a compound procedure and in particular we're going to create a notation for it called a double bubble. this object contains two parts the first part or the first bubble points to the actual code associated with the procedure and it will indeed have two parts the formal parameters of the procedure and the body of the procedure just as we saw inside a lambda expression.

创建复合过程意味着什么，特别是我们将为它创建一种称为“双气泡”的记号。这个对象包含两部分：第一部分（或第一个气泡）指向与该过程关联的实际代码，它确实有两个部分：过程的形参和过程体，正如我们在 lambda 表达式内部看到的那样。

note by the way that the body of this procedure x XX in this case is just list structure it has not yet been evaluated we have no value associated with it it is simply copied across as.

注意，顺便说一下，这个过程的体（在此例中为 x XX）只是列表结构，尚未被求值；我们没有与之关联的值，它只是被复制过来作为

with it it is simply copied across as the code associated with this part of the double bubble or the new procedure the new part is the second bubble and it points to an environment and in particular to the environment in which the lambda expression was actually evaluated this environment pointer captures a context the context that was in place when the avout lamda procedure was evaluated rather the lambda expression was evaluated or if you like it captures the context in which the symbols of the code of the lambda will be evaluated now we can actually define

它只是被复制过来作为双气泡这一部分（或新过程）的代码。新的部分是第二个气泡，它指向一个环境，特别是指向 lambda 表达式实际被求值时的环境。这个环境指针捕获了一个上下文，即求值 lambda 过程（或更确切地说，lambda 表达式）时存在的上下文；或者如果你愿意，它捕获了 lambda 代码中的符号将被求值的上下文。现在我们可以实际定义

be evaluated now we can actually define the lambda rule for evaluation in our environment model we know that this should create a procedure object the key is that the environment pointer now points to the current environment and let's look at what this says it says a lambda special form when evaluated with respect to some environment e creates a procedure whose environment pointer is that environment E and obviously whose coin ters should point to the body of the lambda itself so let's look at this in more detail here again is our

现在我们可以实际定义环境模型中 lambda 的求值规则。我们知道这应该创建一个过程对象，关键在于环境指针现在指向当前环境。让我们看看这意味着什么：它说，一个 lambda 特殊形式在某个环境 e 下求值时，会创建一个过程，其环境指针指向该环境 e，并且显然其代码指针应指向 lambda 本身的主体。所以让我们更详细地看看这个。这里又是我们的

in more detail here again is our environment structure that we've used in the previous examples and let's look at what happens if we actually evaluate an Atlanta expression with respect to this. In particular, let's evaluate this define of square to be lab of X times X X all with respect to environment II won and let's start with the lambda itself the inner part well.

更详细地看，这里又是我们之前示例中使用的环境结构，让我们看看如果我们在这种情况下实际求值一个 lambda 表达式会发生什么。特别是，让我们在环境 e1 中求值这个定义：square 为 lambda x 乘以 x 乘以 x，所有都在环境 e1 中，让我们从 lambda 本身（内部部分）开始。

the rule says evaluate this lambda with respect to e 1 so that will create one of these procedure objects this little double bubble the code part of it points to the formal parameter X and the body.

规则说在 e1 中求值这个 lambda，因此这将创建一个这样的过程对象，这个小双气泡的代码部分指向形参 X 和主体

to the formal parameter X and the body times xx and the environment pointer we also know should point to a very particular place specifically it should point to frame a because the lambda was evaluated with respect to e1 and e1 s first frame is frame a so notice this rule very mechanistically always tells us where the environment pointer should go to that's the context in which lambda was evaluated that's the context that will define how to interpret other symbols within the body of the expression the next important point to note is that evaluating a lambda

指向形参 X 和主体 times xx，并且环境指针我们也知道应该指向一个非常特定的地方，具体来说应该指向帧 a，因为 lambda 是在 e1 中求值的，而 e1 的第一个帧是帧 a。所以注意，这个规则非常机械地告诉我们环境指针应该指向哪里：那是 lambda 被求值的上下文，也是解释表达式主体中其他符号的上下文。下一个重要的点是，求值一个 lambda

Note is that evaluating a lambda actually returns a pointer to the procedure object that is evaluating that red lambda expression. Returns as its value a pointer to that double bubble. It actually has a handle on the procedure object that was created.

注意，求值一个 lambda 实际上返回一个指向过程对象的指针，即求值该 lambda 表达式返回的值是指向那个双气泡的指针。它实际上持有对创建的过程对象的引用。

Why is this relevant? Well, because we can now complete the evaluation of the define expression. Remember what a define should do: it should create a binding for the symbol square in frame II one, or the first frame of e1. And what should the value be associated with square? The value returned by evaluating the lambda.

为什么这很重要？因为我们现在可以完成 define 表达式的求值。记住 define 应该做什么：它应该在帧 e1（或 e1 的第一个帧）中为符号 square 创建一个绑定。而与 square 关联的值应该是什么？是求值 lambda 返回的值。

value returned by evaluating the lambda expression, so we will literally create a pairing of the name square in a1 or the first frame of you want with the actual procedure object. Now comes the big change. Remember the central part of our evaluation model is how to apply a compound procedure to a set of arguments, that is, how to apply procedure we've created using a lambda to a set of arguments to execute some computation. We saw that in the substitution model now we need to define it for our new model the environment model and it has

求值 lambda 表达式返回的值，因此我们将字面上在 a1（或 e1 的第一个帧）中创建名称 square 与实际过程对象的配对。现在来了重大变化。记住我们求值模型的核心部分是如何将复合过程应用于一组参数，即如何应用我们使用 lambda 创建的过程来执行一些计算。我们在替换模型中看到了这一点，现在我们需要为我们的新模型（环境模型）定义它，它有

### 7. Applying a Compound Procedure: The Four-Step Mechanistic Rule (应用复合过程：四步机械规则)

the environment model and it has basically four steps to apply a compound procedure to set of arguments you do the following step one you create a new frame a step two you convert that frame into an environment by taking a and having its enclosing environment pointer go to the same frame as the environment pointer of the procedure P that's very important it says frame a will inherit the same environment as the procedure inherited step three says within frame a you take the formal parameters of the procedure and you bind them to the argument values that

环境模型，应用复合过程于一组参数基本上有四个步骤：第一步，创建一个新框架；第二步，将该框架转换为环境，方法是取该框架，并使其外围环境指针指向与过程 P 的环境指针相同的框架，这一点非常重要，它表示框架 A 将继承该过程所继承的相同环境；第三步，在框架 A 内，取过程的形参，并将它们绑定到传入的参数值；

bind them to the argument values that were passed in and then finally step four you evaluate the body of the procedure with respect to this environment II this is the central step of the environment model and these four very mechanistic steps are absolutely essential and as it says here you really need to know them you need to be almost Pavlovian in your response that whenever you apply a procedure to a set of arguments you create a frame scope it with the environment specified by the environment pointer of the procedure within the frame bind the parameters to

将它们绑定到传入的参数值；最后，第四步，相对于该环境 II 求过程体。这是环境模型的核心步骤，这四个非常机械的步骤绝对必不可少，正如这里所说，你确实需要知道它们，你的反应几乎要像巴甫洛夫条件反射一样：每当你将过程应用于一组参数时，你创建一个框架，用过程的环境指针所指定的环境来限定其作用域，在框架内将参数绑定到

within the frame bind the parameters to the argument values passed in and then reduce that entire compound expression evaluation to the evaluation of the body with respect to a new environment because this is the central part of the environment model let's look in very painful detail at an example of an evaluation in particular let's look at the evaluation of square of four with respect to the global environment and here's the structure I have let's assume that X has already been bound to the value four by some defined statement

在框架内将参数绑定到传入的参数值，然后将整个复合表达式的求值归结为相对于新环境的过程体求值。因为这是环境模型的核心部分，让我们非常细致地看一个求值示例，特别是看相对于全局环境求值 (square 4)。这是我的结构：假设 X 已经通过某个 define 语句绑定到了值 4

value four by some defined statement

值 4 通过某个 define 语句

value four by some defined statement within that environment and we've created the definition for square as we just saw it's pointing to that procedure object. Now what we want to do is see how the rules for the environment model tell us how to get the value associated with squaring for in this environment.

在该环境中通过某个 define 语句绑定到了值 4，并且我们已经创建了 square 的定义，正如我们刚才看到的，它指向那个过程对象。现在我们要做的是看看环境模型的规则如何告诉我们如何在该环境中获得与 squaring for 相关联的值。

well this is a compound expression so the first thing says we have to get the value of the sub expressions with respect to the global environment. For is easy, it's just self evaluating. We also need to get the value of square with respect to the global environment.

嗯，这是一个复合表达式，所以第一件事是，我们必须相对于全局环境获取子表达式的值。For 很容易，它只是自求值。我们还需要相对于全局环境获取 square 的值。

respect to the global environment and that we also know how to do that's just the name rule we look up the value or the binding of a square in that environment and it simply points to that procedure object so it's going to print that back out but what it really says is that we have a now a binding per square we've gotten back to value which is that double bubble shown in the diagram

相对于全局环境，我们也知道如何做，那只是名字规则：我们在该环境中查找 square 的值或绑定，它只是指向那个过程对象，所以它会将其打印出来，但它真正说的是，我们现在有了一个 square 的绑定，我们已经得到了值，即图中显示的那个双气泡。

ah-ha we're applying a procedure one of those double bubble things to a set of arguments so our four step rule now comes into play step one create a new

啊哈，我们正在将一个过程（那些双气泡之一）应用于一组参数，所以我们的四步规则现在发挥作用了。第一步：创建一个新的

comes into play. Step one: create a new frame, let's call it A. Step two: convert that frame into an environment by having its enclosing environment pointer point to the same environment as the procedure's environment pointer pointed to. In fact, notice this nice little notation—I can use it to link these two pointers together to remind myself that the enclosing environment pointer of frame A, or environment A-one if you like, comes from the same enclosing environment pointer as the procedure whose application caused frame A to be created. Step three: take the formal parameters of the procedure.

发挥作用。第一步：创建一个新框架，我们称之为 A。第二步：通过使其外围环境指针指向与过程的环境指针相同的环境，将该框架转换为环境。事实上，注意这个漂亮的记号——我可以用它来将这两个指针链接在一起，以提醒自己框架 A（或如果你愿意，环境 A-one）的外围环境指针来自与导致框架 A 创建的过程相同的外围环境指针。第三步：取过程的形参。

### 8. Worked Example: Evaluating (square 4) (工作示例：求值 (square 4))

The formal parameters of the procedure being applied in this case X and bind them within that new frame to the value of the argument passed in in this case for now with respect to that new environment II won evaluate the body of the procedure.

正在应用的过程的形参，在这种情况下是 X，并将它们在该新框架内绑定到传入的参数值，在这种情况下是 4。现在，相对于那个新环境 II，我们将求过程体。

So notice evaluating Square four with respect to one environment has reduced to evaluating a simpler expression in this case x XX with respect to a new environment environment II won now the same rules apply as before this is a compound expression so we need to get the values of the sub expressions with

所以注意，相对于一个环境求值 Square 4 已经归结为相对于一个新环境（环境 II won）求值一个更简单的表达式，在这种情况下是 x XX。现在同样的规则适用，如前所述，这是一个复合表达式，所以我们需要获取子表达式的值，相对于

The values of the sub expressions with respect to e1, and we start with getting the value of x or star with respect to e1. Star certainly isn't defined within frame a, that frame came from the application of the procedure, and only formal parameters are bound there. So our rule says go up the enclosing environment to the global environment, and look for a binding of star there.

相对于 e1 获取子表达式的值，我们从获取 x 或星号相对于 e1 的值开始。星号肯定没有在框架 A 中定义，该框架来自过程的应用，只有形参在那里绑定。所以我们的规则说沿着外围环境向上到全局环境，并在那里查找星号的绑定。

Well, we didn't tell you this, but in fact the global environment creates bindings for all the basic built-in procedures, so in fact star is bound to the primitive procedure up in that.

嗯，我们没有告诉你，但事实上全局环境为所有基本内置过程创建绑定，所以事实上星号在那个环境中绑定到了原始过程。

primitive procedure up in that environment and therefore our name rule looks up the value associated with star and returns it so in this case we do get a value associated with star now remember where we were we were getting the value of x XX with respect to e1 we got the value of the first sub expression star or x now we need to get the value of the next sub expression X with respect to e1 notice this is just the name rule and it says starting an e1 look for a binding for X there is one there so we get back the value associated with that frame in particular

原始过程在那个环境中，因此我们的名字规则查找与星号关联的值并返回它，所以在这种情况下我们确实得到了与星号关联的值。现在记住我们在哪里，我们正在相对于 e1 获取 x XX 的值，我们得到了第一个子表达式星号或 x 的值，现在我们需要相对于 e1 获取下一个子表达式 X 的值。注意这只是名字规则，它说从 e1 开始，查找 X 的绑定，那里有一个，所以我们得到与该框架关联的值，特别是

associated with that frame in particular, we get back the value for not the value 10 that is up there in the global environment. We start in this frame II, looking for the binding, and since there is a binding there, it shadows the further binding down the stream, and now we complete this similarly. We get the value of the second x with respect to e1, that again gives us back four, and now we're left with the application of a primitive procedure to two simple values, four and four, and that will of course return the value of 16, which is the result.

与该框架关联的值，特别是，我们得到值 4，而不是全局环境中上面的值 10。我们从该框架 II 开始，查找绑定，因为那里有绑定，它遮蔽了流下游的进一步绑定，现在我们类似地完成这个。我们相对于 e1 获取第二个 x 的值，那再次给我们 4，现在我们剩下一个原始过程应用于两个简单值 4 和 4，那当然会返回 16 的值，这就是结果。

Return the value of 16, which is the value that we return for the entire expression since we reduced square of four with respect to the global environment two times xx with factory 1. I know this was a long example, but notice how the mechanistic rules of the environment model simply tell us how to follow through the evaluation of an expression with respect to an environment, reducing it to simpler things and getting out the values we expect.

返回16的值，这就是我们为整个表达式返回的值，因为我们相对于全局环境将square of four归约了两次，并使用了工厂1。我知道这是一个很长的例子，但请注意环境模型的机械规则如何告诉我们如何相对于一个环境来跟踪表达式的求值，将其归约为更简单的事物，并得到我们期望的值。

### 9. Worked Example: Evaluating (inc-square 4) with Nested Application (工作示例：求值 (inc-square 4) 与嵌套应用)

Now let's be slightly more daring. Having seen the application of a simple procedure like Square, let's look at

现在让我们稍微大胆一点。在看过像Square这样的简单过程的应用程序之后，让我们看看

Procedure like Square let's look at something that involves a little more work. In particular, let's assume that we have defined both Square to be the procedure we expect, and we define increment Square to be a procedure of one argument that adds one to the square of that argument. Here's the structure we would expect for the environment.

像Square这样的过程，让我们看看涉及更多工作的事情。特别是，让我们假设我们已经定义了Square为我们期望的过程，并且我们定义了increment Square为一个单参数的过程，它将参数的平方加一。这是我们对环境所期望的结构。

So let's check it out. Let's evaluate increment square of four with respect to the global environment. And here's that global environment we just created—we have bindings for Square and increment Square to the two procedures, as shown.

所以让我们来检查一下。让我们相对于全局环境求值increment square of four。这就是我们刚刚创建的全局环境——我们有Square和increment Square的绑定，分别指向这两个过程，如图所示。

Square to the two procedures as shown in the previous case this is a compound expression so we need to first evaluate the sub expressions with respect to the same environment value of increment square with respect to the global environment that's just the name rule we look it up and get back that double bubble that procedure that is pointed to by the actual binding.

Square到这两个过程，如图所示。在之前的情况下，这是一个复合表达式，所以我们需要首先相对于相同的环境求值子表达式。相对于全局环境，increment square的值就是名称规则，我们查找它并得到那个双气泡，即由实际绑定指向的过程。

And as we saw before our four-step rule kicks in step 1 create a frame step 2 turn it into an environment by having the enclosing environment pointer of the frame point

正如我们之前看到的，我们的四步规则开始：第1步创建一个框架，第2步通过让框架的环境指针指向

environment pointer of the frame points to the environment specified by the procedure that's being applied, and that we know is specified by the second part of the double bubble of the procedure we're using here. Step 3: take the formal parameter of this procedure and create a binding for it in this frame to the value of the argument passed in.

环境指针指向所应用过程指定的环境，我们知道这由我们正在使用的过程的双气泡的第二部分指定。第3步：取该过程的形式参数，并在该框架中为其创建一个绑定，绑定到传入的参数值。

Step 4: take the body of that procedure and evaluate it with respect to this new environment, plus 1 and square of Y, all done with respect to environment II. Won again, notice how we reduce the evaluation of one compound

第4步：取该过程的主体，并相对于这个新环境求值它，即加1和Y的平方，全部相对于环境II完成。再次获胜，注意我们如何将一个复合表达式的求值

reduce the evaluation of one compound expression with respect to one environment to a simpler compound expression with respect to another environment as before is a compound expression we've got to get out the values of the sub expressions the first one is to get the value of plus with respect to e1 as before that's the name rule there is no binding for plus anyone we go up the enclosing environment of the global environment and find the predefined binding of plus to the primitive addition operation given there during the value of 1 is just a number e.

将一个复合表达式相对于一个环境的求值归约为相对于另一个环境的更简单的复合表达式。和之前一样，这是一个复合表达式，我们必须得到子表达式的值。第一个是相对于e1获取加号的值，和之前一样，这是名称规则，加号没有绑定，我们沿着全局环境的封闭环境向上，找到加号到原始加法运算的预定义绑定。在数值为1的时候，它仅仅是一个数字而已。

在数值为1的时候，它仅仅是一个数字而已。

在数值为1的时候，它仅仅是一个数字而已。

During the value of 1 is just a number e gives us back 1, so all we have left to do is get the value of square of Y with respect to e1, and that is itself a compound expression being evaluated with respect to this new environment. So we'll complete that on the next slide.

在数值为1的时候，它仅仅是一个数字而已，所以返回1，因此我们剩下要做的就是获取相对于e1的Y的平方的值，而这本身就是一个相对于这个新环境求值的复合表达式。所以我们将在下一张幻灯片中完成它。

To complete this evaluation, then we need to get the value of square of Y with respect to e1, and here is just a repeat of the environment structure we've developed so far. Well, let's do it in steps again: we got to get the value of each of the sub expressions now with respect to e1, so we get the value of

为了完成这个求值，我们需要获取相对于e1的Y的平方的值，这里只是我们到目前为止开发的环境结构的重复。好吧，让我们再次分步进行：我们现在必须相对于e1获取每个子表达式的值，所以我们获取

respect to e1 so we get the value of square with respect to e1 this is a little different than last time we start an e1 since there's no binding for square there we go up the inclined closing environment frame and get the binding for square from the global environment therefore returning the appropriate procedure.

相对于e1，所以我们获取相对于e1的square的值。这与上次有点不同，我们从e1开始，因为那里没有square的绑定，我们沿着封闭环境框架向上，从全局环境获取square的绑定，因此返回适当的过程。

the second sub expression is y so we need the value of y with respect to e1 and our name rule says simply looked at up with respect to this frame it's bound there therefore return the value 4 so we're set for our big rule again we have the application

第二个子表达式是y，所以我们需要相对于e1的y的值，我们的名称规则说只需在这个框架中查找它，它在那里有绑定，因此返回值4。所以我们再次准备好我们的主要规则：我们有一个过程的应用

Big rule again: we have the application of a procedure, one of those double bubbles, to a set of arguments. So step one says: drop a frame, extend that frame into an environment by having its enclosing environment pointer be the same one as that specified by the procedure, which says we want this one.

主要规则再次出现：我们有一个过程的应用，即那些双气泡之一，应用于一组参数。所以第1步说：放下一个框架，通过使其环境指针指向过程指定的环境来将该框架扩展为一个环境，这表示我们想要这个。

Notice an interesting point here: this new environment E2 is scoped by the global environment, not by E1. You might have thought it should be E1, because that was where we were doing the work. But remember the rule: the enclosing environment is specified by the procedure.

注意一个有趣的点：这个新环境E2由全局环境限定，而不是由E1限定。你可能认为它应该是E1，因为那是我们工作的地方。但记住规则：封闭环境由过程指定。

环境是由所应用的过程指定的，而不是由我们执行工作的步骤所在的框架指定的。步骤3创建了一个绑定，将过程的形式参数（在此情况下为X）绑定到传入的值（在此情况下为4），并绑定到该框架中。

环境是由所应用的过程指定的，而不是由我们执行工作的步骤所在的框架指定的。步骤3创建了一个绑定，将过程的形式参数（在此情况下为X）绑定到传入的值（在此情况下为4），并绑定到该框架中。

步骤4相对于这个新环境，评估这个过程的主体，即times X X。因此，我们现在已经将其简化，并乘以X与X在环境e中的乘积。现在我们几乎完成了，我们需要获取每个子表达式相对于e2的值。

步骤4相对于这个新环境，评估这个过程的主体，即times X X。因此，我们现在已经将其简化，并乘以X与X在环境e中的乘积。现在我们几乎完成了，我们需要获取每个子表达式相对于e2的值。

these sub expressions with respect to e2

这些子表达式相对于 e2 而言

这些子表达式相对于 e2 而言，但那样很简单，我们查找 x 一路向上到全局环境以获得乘数，我们在该框架中查找 X，两次都是 4。

这些子表达式相对于 e2 而言，但那样很简单，我们查找 x 一路向上到全局环境以获得乘数，我们在该框架中查找 X，两次都是 4。

因此我们准备完成过程，将这个原始过程应用到那些值上，那当然返回 16。

因此我们准备完成过程，将这个原始过程应用到那些值上，那当然返回 16。

记住所有这一切的起点，那个值然后被传回我们来到这个幻灯片时的起点，那是将 1 加到 square 返回的值上，即 4 的平方或这个例子中的 Y 的平方，这给我们一个整体的值 17。

记住所有这一切的起点，那个值然后被传回我们来到这个幻灯片时的起点，那是将 1 加到 square 返回的值上，即 4 的平方或这个例子中的 Y 的平方，这给我们一个整体的值 17。

gives us back an overall value of 17 I'm there are a lot of details here but again if you step through this carefully you'll see how the rules for the environment model vary mechanistically specify exactly the order in which to evaluate the expressions and how to look up the bindings of variables in the appropriate environment in order to make sure each expression has in fact a legal value.

给我们一个整体的值 17。这里有很多细节，但如果你仔细逐步进行，你会看到环境模型的规则如何机械地指定了求值表达式的确切顺序，以及如何在适当的环境中查找变量的绑定，以确保每个表达式实际上都有一个合法的值。

### 10. Counter Example: Capturing Local State with make-counter and Independent Procedures CA and CB (反例：使用 make-counter 和独立过程 CA 和 CB 捕获局部状态)

so what should you take away from this well the key point is to see how as we've said these rules for the environment models specify almost everything we need to know in order to

那么你应该从中得到什么？关键点是要看到，正如我们所说，环境模型的这些规则指定了我们几乎需要知道的一切，以便

everything we need to know in order to understand how expressions get evaluated. It doesn't quite do all of it. In particular, it doesn't show the complete state of the interpreter. In particular, it doesn't tell us what are the pending operations. And we saw that in the last example, where once we got that value 16, we had to go back and remember who was asking for it in order to complete the computation. Other than that, though, it really does specify the rules.

我们需要知道的一切，以便理解表达式如何被求值。但它并没有完全做到这一点。特别是，它没有显示解释器的完整状态。尤其是，它没有告诉我们挂起的操作是什么。我们在最后一个例子中看到了这一点，当我们得到值16时，我们必须回去记住是谁在请求它，以便完成计算。除此之外，它确实指定了规则。

Second thing is to notice how the global environment will contain, as we said, all.

第二件事是注意全局环境将包含，如我们所说，所有的。

环境将包含我们所说的所有标准绑定，这些是Scheme内置的部分，我们在迄今为止使用的环境模型图中确实省略了这些。第三件我们希望你们看到的事情是，将每个框架的环境指针链接到创建它的过程是多么有用。

环境将包含我们所说的所有标准绑定，这些是Scheme内置的部分，我们在迄今为止使用的环境模型图中确实省略了这些。第三件我们希望你们看到的事情是，将每个框架的环境指针链接到创建它的过程是多么有用。

这样就不会混淆谁将使用那个框架，特别要注意的是，框架的封闭环境指针指向的是过程所规定的环境，而不是我们当前所在的框架。

这样就不会混淆谁将使用那个框架，特别要注意的是，框架的封闭环境指针指向的是过程所规定的环境，而不是我们当前所在的框架。

Have not the frame in which we're currently doing the work. Nonetheless, if this is unclear, go back and look at those examples of game to see how in fact these rules very clearly specify the evolution of evaluation in this new model.

而不是我们当前正在做工作的框架。尽管如此，如果这不清楚，请回去看看那些游戏的例子，看看这些规则实际上如何清晰地指定了在这个新模型中求值的演化。

Now that we're reasonably comfortable with the environment model, let's go back and tackle what started us off on all of this. Remember this example from the beginning of the lecture: counter, or something created by make counter, was a little thing that should count up from a number every time we applied that procedure to no arguments.

既然我们对环境模型已经相当熟悉了，让我们回到最初引发这一切的问题。还记得讲座开始时的这个例子：计数器，或者由make-counter创建的东西，是一个小东西，每次我们将该过程应用于无参数时，它应该从一个数字开始向上计数。

applied that procedure to no arguments, we'd get the next number up in the sequence. And we wanted to understand how evaluating the same expression could give rise to different values, and how in fact creating the same expression could give us different objects out that had different behavior.

将该过程应用于无参数时，我们会得到序列中的下一个数字。我们想要理解为什么对同一个表达式的求值会产生不同的值，以及为什么创建同一个表达式会给我们带来具有不同行为的不同的对象。

Let's use our model to see how to understand this computation. So here we go, stick with me, because I know there's going to be a lot of details, but you should be able to follow all of this.

让我们用我们的模型来理解这个计算。所以，我们开始吧，请跟上我，因为我知道会有很多细节，但你们应该能够跟上所有这些。

Let's evaluate the definition of CA to be the value returned by evaluating make counter with

让我们求值CA的定义，使其为用参数0求值make-counter所返回的值。

returned by evaluating make counter with argument zero all of this done within the global environment and here is in fact our structure for the global environment.

用参数0求值make-counter所返回的值，所有这些都在全局环境中完成，这里实际上就是全局环境的结构。

We've already got a definition for make counter in it it just points to that procedure object we got when we would have evaluated the define on the previous slide well to do this we know we need to get the value of applying make counter to zero.

我们已经有了make-counter的定义，它指向那个过程对象，当我们会在上一张幻灯片上求值define时得到它。为了做到这一点，我们知道我们需要得到将make-counter应用于0的值。

Make counter we know as a procedure so the next set of stages we actually know we're going to drop a frame create it into an environment by scoping it by the

我们知道make-counter是一个过程，所以接下来的步骤，我们实际上知道我们将要创建一个框架，通过将其作用域限定为过程应用所指定的封闭环境指针，将其放入一个环境中。

Into an environment by scoping it by the enclosing environment pointers specified by the procedure application, and within that frame bind the formal parameter to the argument passed in. So here's the structure we would get, this is just like what we did before.

通过过程应用所指定的封闭环境指针将其作用域限定为一个环境，并在该框架内将形式参数绑定到传入的参数。所以这是我们得到的结构，这就像我们之前做的一样。

Now watch very carefully, because notice what we have: we now have an evaluation of the body of that procedure with respect to an environment, and what's that body? It is itself a lambda, lambda of no parameters, set bang a bunch of stuff, then return the value N. And we know what that says.

现在非常仔细地看，因为注意我们有什么：我们现在有了对那个过程体相对于一个环境的求值，那个体是什么？它本身是一个lambda，无参数的lambda，set-bang一堆东西，然后返回N的值。我们知道那意味着什么。

the value N and we know what that says to do it says evaluate the lambda in other words create one of those double bubble structures the code part is just the formal parameter in this case nothing and the body is just the set bang of a bunch of stuff and then the value of n that's specified by the details of the lambda the key thing is where does the second part of the double bubble go to what's the environment pointer we want to use right it points to e1 and it does that because that's the environment in which we were evaluating to lambda notice this is a

返回N的值，我们知道那意味着什么：它说求值这个lambda，换句话说，创建那些双气泡结构之一，代码部分只是形式参数，在这种情况下没有，体只是set-bang一堆东西，然后是n的值，这由lambda的细节指定。关键的是双气泡的第二部分指向哪里，我们想要使用的环境指针是什么？它指向e1，它这样做是因为那是在其中求值lambda的环境。注意这是一个

evaluating to lambda notice this is a different structure than we've seen before. For the first time we have a procedure whose environment pointer points to a frame or an environment other than the global environment, and in a second we're going to see why that's crucial.

求值lambda的环境。注意这是我们以前从未见过的不同结构。第一次我们有一个过程，其环境指针指向一个框架或环境，而不是全局环境，一会儿我们将看到为什么这至关重要。

Now remember that bread object there, that double bubble, is the value actually returned by evaluating the procedure or the body of the procedure we applied. So that's the value returned by make counter of 0. Therefore we can complete our definition, the binding for CA up in the global environment since

现在记住那个面包对象，那个双气泡，是实际由求值过程体或我们应用的过程体返回的值。所以那是make-counter应用于0返回的值。因此我们可以完成我们的定义，因为我们在全局环境中求值define，所以CA的绑定在全局环境中被创建，那个变量指向make-counter返回的对象，即那个过程对象。

CA up in the global environment since that's where we were evaluating the define is now created and that variable points to the object returned to by make counter which is that procedure object. This is a useful structure: the variable CA, which is available to us in the global environment, points to the procedure much as earlier things did.

CA在全局环境中，因为那是在其中求值define的地方，现在被创建，那个变量指向make-counter返回的对象，即那个过程对象。这是一个有用的结构：变量CA，在全局环境中对我们可用，指向过程，就像之前的事情一样。

But notice that procedure has nested within it an internal environment: its environment pointer points to an environment that is scoped relative to the global environment. Ok, having created this seizure object associated with CA, let's

但注意那个过程内部嵌套了一个内部环境：它的环境指针指向一个相对于全局环境作用域的环境。好，既然我们已经创建了这个与CA关联的捕获对象，让我们

Seizure object associated with CA. Let's look at what happens when we apply it, when we evaluate it with no arguments. Here's just a recap of the environment structure: we have the global environment with a binding for CA, it points to a procedure object whose environment pointer points to a new frame or new environment II won, which is scoped by the global environment but contains within it its own primitive variable M.

与CA关联的捕获对象。让我们看看当我们应用它时，当我们用无参数求值它时会发生什么。这里只是环境结构的回顾：我们有全局环境，带有CA的绑定，它指向一个过程对象，其环境指针指向一个新的框架或新环境e1，它由全局环境作用域，但包含它自己的原始变量M。

Now, the value of CA is just that procedure, so we're going to apply a procedure. We know what the rule says: drop a frame, within that frame bind the...

现在，CA的值就是那个过程，所以我们将应用一个过程。我们知道规则怎么说：创建一个框架，在该框架内绑定...

drop a frame within that frame bind the formal parameters of this procedure there aren't any so there's nothing to put in the frame and relative to this new environment evaluate the body of the procedure which says we're going to be evaluating that set bang event and then the actual expression and with respect to e2 and notice the structure here we now have a frame e - that points to a frame a1 that points to the global environment ok well we know what a set bang does but let's be careful first we're going to get the value of + + 1

创建一个框架，在该框架内绑定这个过程的形式参数，这里没有，所以框架中没有什么可放的，相对于这个新环境求值过程体，它说我们将求值那个set-bang表达式，然后是实际的表达式，相对于e2，注意这里的结构，我们现在有一个框架e2，它指向框架e1，e1指向全局环境。好，我们知道set-bang做什么，但让我们小心，首先我们将得到+ + 1的值。

We're going to get the value of + + 1 with respect to e2, which means if we look up the value of n with respect to e2, it's not bound there, but we go up a level and find it with respect to e1. Aha, its value is 0, so we add 0 to 1, getting 1. Notice how that local frame has captured and for us given that we now evaluate the set bang with respect to e2, which says starting in e2, trace up the environment chain until we find a binding for n, which we find in e1, and change it there, change it to the new value, which is 1. Having evaluated that part of the body.

我们将相对于 e2 求值 + + 1 的值，这意味着如果我们相对于 e2 查找 n 的值，它在那里没有绑定，但我们会向上查找并在 e1 中找到它。啊哈，它的值是 0，所以我们将 0 加到 1，得到 1。注意这个局部帧如何捕获了状态，并且对我们来说，既然我们现在相对于 e2 求值 set bang，它表示从 e2 开始，沿着环境链向上追踪，直到找到 n 的绑定，我们在 e1 中找到它，并在那里更改它，将其更改为新值，即 1。在求值了过程体的那一部分之后。

having evaluated that part of the body

在求值了过程体的那一部分之后

Having evaluated that part of the body of the procedure, we then evaluate the next part, and with respect to E - same rules chase up the chain till we find a binding frame. There it is, as one returns that as the value, and that of course was the value we wanted to return by the overall application of CA. That's the value of the last expression which returns a 1 at top level.

在求值了过程体的那一部分之后，我们接着求值下一部分，并且相对于 E——同样的规则，沿着链向上追踪，直到找到一个绑定帧。它就在那里，作为值返回 1，而这当然是我们通过整体应用 CA 想要返回的值。这就是最后一个表达式的值，它在顶层返回 1。

The key thing to note here is how that local frame II 1 captures some state information that's accessible only by this procedure. Calling CA gives us the ability to get this value of N, change it, or mutate it.

这里要注意的关键点是，局部帧 II 1 如何捕获了一些仅此过程可访问的状态信息。调用 CA 使我们能够获取 N 的这个值、更改它或修改它。

this value of n change it or mutate it and then return that value okay let's see now what happens if we call it again we should expect to see this behavior of it incrementing up so let's evaluate CA one more time with respect to this environment and here we just repeated the structure we got when we did the previous eval

这个 n 的值，更改它或修改它，然后返回该值。好的，现在让我们看看如果我们再次调用它会发生什么，我们应该预期看到它递增的行为，所以让我们相对于这个环境再求值一次 CA，这里我们只是重复了之前求值时的结构。

and has been mutated from zero to one as part of that process well the value CA is just that procedure we're applying it so we know what the rule says drop a frame scope it with the same environment pointer as the procedure object which

并且在这个过程中，n 已经从 0 修改为 1。CA 的值就是那个过程，我们正在应用它，所以我们知道规则说：创建一个帧，用与过程对象相同的环境指针来限定它，该指针指向

pointer as the procedure object which again says we're going to e1 as we did before there are no parameters to bind in the frame so evaluating CA with respect to the global environment reduces to evaluating the body set bang of n plus n1 with respect to this new frame III well we know what happens that's what we just did it's going to go in and mutate the value of n to be one more than what it was changing it from 1 to 2 in exactly this frame and having evaluated that part of the body we now take the second part of the body the

指针指向过程对象，这再次说明我们将像之前一样指向 e1。帧中没有要绑定的参数，所以相对于全局环境求值 CA 就简化为相对于这个新帧 III 求值过程体 set bang of n plus n1。我们知道会发生什么，这正是我们刚才所做的：它将进入并修改 n 的值，使其比原来多 1，在这个帧中将其从 1 改为 2。在求值了过程体的那一部分之后，我们现在取过程体的第二部分，即

take the second part of the body the expression and evaluate that with respect to e3 chase up the frame find the binding and return that value 2 and that of course is the value of the last expression in the body of CA so that's the value returned by the whole thing

取过程体的第二部分，即表达式，并相对于 e3 求值它，沿着帧向上追踪，找到绑定，并返回该值 2。这当然是 CA 过程体中最后一个表达式的值，所以这就是整个过程返回的值。

and thus we see how this local piece of state now allows us to have a procedure which when evaluated in successive turns returns a different value so in our environment model helps us understand how one counter CA can have some local state that it can keep mutating so that it can return a different value each

因此我们看到了这个局部状态如何允许我们有一个过程，当它在连续调用中被求值时返回不同的值。所以我们的环境模型帮助我们理解一个计数器 CA 如何拥有一些局部状态，它可以不断修改，以便每次求值或应用时返回不同的值。

It can return a different value each time it's evaluated or applied. Now let's see what happens when we call make counter again, starting also with zero but giving it a different name. And just to recap, here's the environment structure we have to this point, with that procedure CA pointing to the procedure shown here and with local state now having n equal to 2 because we've evaluated it twice.

它可以在每次求值或应用时返回不同的值。现在让我们看看当我们再次调用 make counter 时会发生什么，同样从零开始，但给它一个不同的名字。简要回顾一下，这是我们到目前为止的环境结构，过程 CA 指向这里所示的过程，并且局部状态现在 n 等于 2，因为我们已经求值了两次。

Well, we want to apply make counter to zero. We look up the value of make counter with respect to the global environment. It's a procedure, zero is zero. We're applying a procedure.

好的，我们想要将 make counter 应用于零。我们相对于全局环境查找 make counter 的值。它是一个过程，零是零。我们正在应用一个过程。

procedure zero is zero we're applying a procedure. We know what to do. Step one: drop a frame. Step 2: convert it into an environment, scoping that frame with the same environment pointer as the procedure, so this one note will point up to the global environment. Step 3: bind the formal parameter of this procedure, n, to the value passed in, zero. Notice this is a different n than what we had before. This n lives in environment E, before the N we had for CA lives in environment A1, so we have different bindings for the same variable in different environments now.

过程，零是零，我们正在应用一个过程。我们知道该怎么做。第一步：创建一个帧。第二步：将其转换为环境，用与过程相同的环境指针来限定该帧，所以这个注意点将指向全局环境。第三步：将此过程的形参 n 绑定到传入的值零。注意这是一个不同于我们之前拥有的 n。这个 n 存在于环境 E 中，而我们为 CA 拥有的 n 存在于环境 A1 中，所以现在我们在不同的环境中对同一个变量有不同的绑定。

in different environments now relative to this environment evaluate the body of the procedure remember the procedure we're applying its mate counter so we're going to evaluate that lambda X with respect to e4 and we know what evaluating a lambda should do it creates a procedure object a double bubble the parameter or code part of the thing points to the parameters which are none in the body which is that set bang in fact a good point to the same one we had before the key point is where does the procedural objects environment pointer

在不同的环境中，相对于这个环境求值过程体，记住我们正在应用的过程是 make counter，所以我们将相对于 e4 求值那个 lambda X，我们知道求值 lambda 应该做什么：它创建一个过程对象，一个双气泡，参数或代码部分指向参数（这里没有），过程体是那个 set bang，事实上，一个很好的点是指向与之前相同的过程体。关键点是过程对象的环境指针

procedural objects environment pointer point to the environment in which it's being evaluated to e4 so this procedure has a different scoping it's going to capture e4 with that version event which is different than the one we had before and finally that's the value returned by applying make counter to zero that's the body of the thing so that procedure is returned as value and therefore the definition creates a binding for CB up in the global environment to that new procedure object look carefully at the structure we have here we have CB pointing to a procedure.

过程对象的环境指针指向它被求值的环境，即 e4，所以这个过程有一个不同的作用域，它将捕获 e4 以及那个版本的事件，这与我们之前拥有的不同。最后，这就是将 make counter 应用于零所返回的值，这就是过程体的值，所以该过程作为值返回，因此定义在全局环境中为 CB 创建了一个绑定，指向那个新的过程对象。仔细看看我们这里的结构：CB 指向一个过程。

here we have CA pointing to a procedure object that inherits a frame A one we have CB pointing to a similar procedure object that inherits a frame F or they have different scoping Zoar bindings for the parameter N and that's going to allow these things to behave differently.

这里 CA 指向一个继承帧 A1 的过程对象，CB 指向一个类似的过程对象，它继承帧 F 或 E4，它们有不同的作用域，对参数 N 有不同的绑定，这将使它们表现得不同。

now let's finish our understanding of this process by looking at what happens when we apply CB within the global environment and remember here's the environment structure we have we have a global environment we have a binding for CA - one procedure object with its own

现在让我们通过查看在全局环境中应用 CB 时会发生什么来完成我们对这个过程的理解，记住这是我们拥有的环境结构：我们有一个全局环境，有一个 CA 的绑定——一个过程对象，它有自己的

CA - one procedure object with its own

CA——一个过程对象，它有自己的

CA - one procedure object with its own frame we have a binding for CB - another procedure object with its own frame what happens when we apply CB well the rules make it very clear we take the procedure object associated with the binding for CB we apply it which says drop a frame scope it by using the same environment pointer as the procedure object which says 'if I've will be scoped by e for not e1 not global environment efore this says using exactly the same reasoning as before that the value of n that will get mutated is the one that is seen from

CA——一个过程对象，带有自己的框架，我们有一个绑定；CB——另一个过程对象，带有自己的框架。当我们应用CB时会发生什么？规则非常清楚：我们取与CB绑定相关联的过程对象，应用它，这意味着丢弃一个框架，通过使用与过程对象相同的环境指针来限定其作用域，也就是说，'如果我被限定在e中，而不是e1，也不是全局环境efore'。这里使用与之前完全相同的推理，被修改的n的值是从

mutated is the one that is seen from ePHI namely the one sitting at efore so it gets changed by one and then we return that value which says the value of the overall expression is just 1 so

被修改的是从ePHI中看到的值，即位于efore的那个，所以它被改变了一，然后我们返回那个值，这意味着整个表达式的值就是1。所以

what was the point of this long drawn-out exercise part of it was to let you see how the rules for the environment model evolve they specify what happens with the computation now they specify how expressions get meanings assigned to them through a very mechanistic set of rules but the second point was to let us understand things that involve mutation and in particular

这个冗长练习的意义何在？部分是为了让你看到环境模型的规则如何演化，它们规定了计算过程中发生什么，它们通过一套非常机械的规则为表达式赋予意义。但第二点是让我们理解涉及变异的事物，特别是

that involve mutation and in particular mutation associated with procedures. So think about what happened with our little counter example. Here's the environment model that we had, and notice that there's a structure associated with it.

涉及变异，特别是与过程相关的变异。所以想想我们的小计数器例子发生了什么。这是我们有的环境模型，注意它关联着一个结构。

What does CA look like? It's a name bound in the global environment that points to a procedure, and more importantly, that procedure has as its environment pointer a pointer into a frame in this case, E1, that has some local state in it. Now the only way we can get at that value of N is through a procedure whose environment pointer

CA看起来像什么？它是全局环境中绑定到一个过程的名字，更重要的是，该过程的环境指针指向一个框架，在这种情况下是E1，其中包含一些局部状态。现在，我们能够获取N值的唯一方式是通过一个环境指针

procedure whose environment pointer through some chain of events points into that frame, or in this case only through that frame. So this structure, this pattern, is a common pattern.

通过一系列事件指向那个框架的过程，或者在这种情况下仅通过那个框架。所以这种结构，这种模式，是一种常见模式。

In fact, when we evaluated make counter, gained and gave it the result returned by it, rather the name CB, we created a similar pattern, but now with its own local state. So each of these names specifies a procedure that has associated with it some information that belongs only to that procedure. This kind of framework, that is, procedures that capture local state and can

事实上，当我们求值make-counter，得到它返回的结果，并将其命名为CB时，我们创建了一个类似的模式，但现在有了自己的局部状态。因此，这些名字中的每一个都指定了一个过程，该过程关联着一些仅属于该过程的信息。这种框架，即捕获局部状态并能

That capture local state and can manipulate that local state is going to be a very useful programming tool as we're going to see in the next few lectures. So as you step away from all of this, here are the two rules or the two thoughts that we'd like you to leave with.

捕获局部状态并操作该局部状态的过程，将是一个非常有用的编程工具，我们将在接下来的几讲中看到。所以当你从这一切中抽身时，这里有两个规则或两个想法我们希望你能记住。

Note that environment diagrams or environment models are very valuable but they get complicated quickly. They're really meant for the computer to follow, not for us, and we're going to see that when we use those to build an evaluator.

注意，环境图或环境模型非常有价值，但它们很快就会变得复杂。它们实际上是供计算机遵循的，而不是供我们使用的，我们将会看到当我们用它们来构建求值器时。

The second and most important thing was the example we just saw a lambda inside.

第二个也是最重要的事情是我们刚刚看到的例子：一个lambda在

the example we just saw a lambda inside a procedure body captures the frame that was active when that lambda was evaluated that means we can use this to store local state and that's going to allow us to build a whole new set of programming tools as we're going to see

我们刚刚看到的例子：过程体内的lambda捕获了该lambda被求值时活跃的框架，这意味着我们可以用它来存储局部状态，这将使我们能够构建一套全新的编程工具，正如我们将会看到的。