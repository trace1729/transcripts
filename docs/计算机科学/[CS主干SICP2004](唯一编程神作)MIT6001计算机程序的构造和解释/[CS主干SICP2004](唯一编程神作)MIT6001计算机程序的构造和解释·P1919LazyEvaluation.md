# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=19)

## Summary (摘要)

- The semantics of a programming language are defined by the implementation of eval and apply, small changes to which can yield fundamentally different behaviors.
- Normal-order (lazy) evaluation substitutes unevaluated arguments into procedure bodies and only evaluates them when needed, contrasting with Scheme's applicative-order evaluation which computes arguments eagerly.
- Lazy evaluation is implemented by modifying eval and apply to delay argument evaluation using thunks, which are promises containing the expression and its evaluation environment, and forcing them when actual values are required.
- To avoid re-evaluating delayed expressions multiple times, memoization is introduced: when a thunk is forced, it is mutated into an evaluated thunk that stores the result for future use.
- Programmers can gain control over evaluation strategy by declaring each parameter as normal, lazy, or lazy-memoized, allowing per-parameter choice of initial evaluation, thunk creation, or memoized thunk creation.
- Combining lazy evaluation with streams enables the creation of infinite data structures and decouples the order of computation from the description of processes, simplifying coding patterns like the sieve of Eratosthenes and signal processing integrators.

- 编程语言的语义由 eval 和 apply 的实现定义，对它们的微小改动可能导致根本不同的行为。

正常序（惰性）求值将未求值的参数替换到过程体中，仅在需要时才对其求值，这与 Scheme 的应用序求值（急切地计算参数）形成对比。

惰性求值通过修改 eval 和 apply 来实现，使用 thunk（一种包含表达式及其求值环境的承诺）延迟参数求值，并在需要实际值时强制求值。

为避免多次重新求值延迟表达式，引入了记忆化：当 thunk 被强制时，它会被修改为已求值的 thunk，存储结果以备将来使用。

程序员可以通过将每个参数声明为 normal、lazy 或 lazy-memoized 来控制求值策略，从而允许对每个参数选择初始求值、创建 thunk 或创建记忆化 thunk。

将惰性求值与流结合，可以创建无限数据结构，并将计算顺序与过程描述解耦，简化了诸如埃拉托斯特尼筛法和信号处理积分器等编码模式。

## Outline (大纲)

1. Review of eval and apply and the difference between applicative and normal order
2. Implementing lazy evaluation in the evaluator
3. Thunks and forcing
4. Memoization to avoid re-evaluation
5. Trade-offs and programmer control of evaluation
6. Parameter declarations and handling different flavors of laziness
7. From lazy evaluation to streams and infinite data structures
8. Streams and lazy evaluation for efficient prime computation
9. Building infinite streams and the sieve of Eratosthenes
10. Streams as signal processing and the integrator example

1. 回顾 eval 和 apply，以及应用序与正常序的区别

在求值器中实现惰性求值

Thunk 与强制求值

记忆化以避免重复求值

权衡与程序员对求值的控制

参数声明与处理不同风格的惰性

从惰性求值到流和无限数据结构

流与惰性求值用于高效素数计算

构建无限流与埃拉托斯特尼筛法

流作为信号处理与积分器示例

## Transcript (转录)

### 1. Review of eval and apply and the difference between applicative and normal order (回顾 eval 和 apply，以及应用序与正常序的区别)

Over the past few lectures, we've been looking at evaluation and, in particular, how to implement eval and apply in a language such as scheme, in order to define a language scheme or some variation thereof. What we've seen is that by creating or specifying eval and its associated procedures, we actually define the semantics of a language—what it means to determine an expression's value, or to associate meanings with actual expressions in the language. We've also separated out the semantics of eval and apply from the syntax of the language.

在过去的几讲中，我们一直在考察求值，特别是如何在诸如 Scheme 这样的语言中实现 eval 和 apply，以定义 Scheme 语言或其变体。我们已经看到，通过创建或指定 eval 及其相关过程，我们实际上定义了语言的语义——即确定表达式值或为语言中的实际表达式关联意义意味着什么。我们还把 eval 和 apply 的语义与语言的语法分离开来。

Val and apply from the syntax of the language meaning how we choose to write the expressions can be interfaced through a data abstraction into the actual evaluation of meaning associated with those expressions.

Val 和 apply 与语言的语法分离，意味着我们选择如何书写表达式可以通过数据抽象与这些表达式关联的实际意义求值相接口。

In this lecture we're going to look at variations on scheme. We're going to explore the idea of how by making changes, in many cases very small changes, but in making changes to eval and apply, we can cause the language to behave in a very very different fashion.

在本讲中，我们将考察 Scheme 的变体。我们将探索这样的想法：通过对 eval 和 apply 进行修改（在许多情况下是非常小的修改），我们可以使语言以非常非常不同的方式运行。

And we're going to look at how we gain some benefits sometimes at little cost by making these changes.

我们将看到如何通过进行这些修改，有时以很小的代价获得一些好处。

sometimes it the little cost by making those changes trading off design issues in the language for performance issues in actually using the language to set the stage for what we're about to do. let's remind ourselves of what normal scheme does remember we said much earlier in the term that scheme is basically an applicative order language. that means when evaluating a combination, we first evaluate all the arguments reduce those down to actual values, including the first argument which in our language or our syntax actually is the operator, and then we apply that.

有时以很小的代价进行这些修改，在语言的设计问题与使用语言时的性能问题之间进行权衡，为我们将要做的事情奠定基础。让我们提醒自己正常 Scheme 做什么。记得我们在学期初说过，Scheme 基本上是一种应用序语言。这意味着在求值一个组合式时，我们首先求值所有参数，将它们化简为实际值，包括第一个参数（在我们的语言或语法中实际上是运算符），然后我们应用它。

The operator and then we apply that operator the procedure associated with that first argument to the values of all the other arguments we apply the procedure to the values.

运算符，然后我们将该运算符（与第一个参数关联的过程）应用于所有其他参数的值。我们将过程应用于这些值。

Now while we've been accepting that as our method of operation and scheme in fact it's a design choice it was a choice that was made by the people who created the language.

虽然我们一直接受这作为我们在 Scheme 中的操作方法，事实上这是一个设计选择，是语言创建者做出的选择。

There's another way at least one other way of looking at that and that's called normal order evaluation in normal order evaluation we do the following when given a compound expression we'd say go ahead and apply.

还有另一种方式，至少另一种看待它的方式，称为正常序求值。在正常序求值中，我们做以下事情：给定一个复合表达式，我们说继续应用。

following when given a compound expression we'd say go ahead and apply

给定一个复合表达式，我们说继续应用

expression we'd say go ahead and apply the operator that is the value of the first sub expression but with unevaluated argument sub expressions or said differently when given a compound expression we could evaluate the first one but then simply take the other pieces and substitute them into the body of the procedure and do that until we actually need the value and in fact we would have value a sub-expression only when the value was needed to print something out or because a primitive procedure is going to be applied that is the primitive procedures

表达式，我们说继续应用运算符，即第一个子表达式的值，但使用未求值的参数子表达式；或者换句话说，给定一个复合表达式，我们可以求值第一个，但然后简单地将其他部分代入过程体，并一直这样做直到我们实际需要该值。事实上，我们只有在需要打印某些东西或因为要应用一个基本过程时才会求值子表达式，即基本过程

applied that is the primitive procedures are going to be strict and requiring that their arguments actually have values set differently normal order would have a very different substitution model in which in essence we would take the sub expressions substitute them into the body of the procedure and keep doing that substitution until we have an expression that involves only primitive procedures and their application

应用，即基本过程是严格的，要求它们的参数实际有值。换句话说，正常序会有一个非常不同的替换模型，其中本质上我们将子表达式代入过程体，并不断进行替换，直到我们得到一个只涉及基本过程及其应用的表达式。

our goal here is to say how is that different in terms of how the language evolves and how can we create such a language to visualize the difference

我们的目标是说明这在语言如何演化方面有何不同，以及我们如何创建这样的语言来可视化这种差异。

language to visualize the difference between these two kinds of evaluations let's look at an example here's an example using applicative order meaning the normal kind of scheme thing let's define food to be a procedure of one argument X and inside the body we'll write out a particular expression to tell us where inside of foo and then we'll add X to X

语言来可视化这两种求值之间的差异，让我们看一个例子。这是一个使用应用序的例子，即正常的 Scheme 方式。让我们定义 foo 为一个单参数 X 的过程，在体内我们将写出一个特定的表达式来告诉我们 foo 内部的位置，然后我们将 X 加到 X 上。

and let's see what happens if we call foo with an argument that has a sequence of things and the argument says write out the fact that I'm evaluating the argument and then return the value 222 now what happens if

让我们看看，如果我们用带有序列的参数调用 foo，并且该参数说写出我正在求值该参数的事实，然后返回值 222，会发生什么。

return the value 222 now what happens if we do applicative order here well in normal scheme or applicative order scheme the first thing we do is evaluate each of the arguments we'll get the value of foo that's going to be a procedure of some sort but then we have to evaluate this argument we have to evaluate this begin statement and that is going to lead to the following kind of behavior evaluating this argument says evaluate this begin statement and therefore we evaluate the first sub expression which writes out on the screen eval argh

返回值 222。如果我们在这里采用应用序会怎样？在标准的 Scheme 或应用序 Scheme 中，我们首先做的是求值每个参数。我们会得到 foo 的值，那将是某种过程，但接着我们必须求值这个参数，我们必须求值这个 begin 语句，这将导致以下行为：求值该参数说求值这个 begin 语句，因此我们求值第一个子表达式，它在屏幕上写出 eval argh。

screen eval argh we then evaluate the second argument or the second expression rather 2:22, and since this is the last sub expression in this begin, that's the value returned, which is the value of the overall argument. That's the value we're going to use in the application of foo.

屏幕上写出 eval argh。然后我们求值第二个参数，或者更确切地说是第二个表达式 2:22，由于这是该 begin 中的最后一个子表达式，这就是返回的值，也就是整个参数的值。这就是我们将在 foo 的应用中使用的值。

Great, so now we apply the procedure named foo to that argument 222, and by the substitution model, that says we substitute 222 in for X everywhere in the body, then evaluate the body. And that says we'll evaluate this begin statement, a sequence of write out the line saying...

好，现在我们应用名为 foo 的过程到那个参数 222，根据替换模型，这意味着我们在函数体中将 222 替换为 X 的每个出现，然后求值函数体。这表示我们将求值这个 begin 语句，一个写出行的序列，说……

a sequence of write out the line saying I'm inside foo followed by evaluating I'm inside foo followed by evaluating I'm inside foo followed by evaluating plus 222 222 yes I know we should really plus 222 222 yes I know we should really plus 222 222 yes I know we should really use the environment model here but use the environment model here but use the environment model here but substitution is sufficient to see what substitution is sufficient to see what substitution is sufficient to see what we're doing and of course evaluating

一个写出行的序列，说我在 foo 内部，接着求值我在 foo 内部，接着求值我在 foo 内部，接着求值加 222 222 是的，我知道我们真的应该使用环境模型，但替换足以看到我们在做什么，当然求值……

this in order says we first write out this in order says we first write out this in order says we first write out the fact that we're inside foo and then the fact that we're inside foo and then the fact that we're inside foo and then we go ahead and do the actual addition

按顺序求值这个，说我们首先写出我们在 foo 内部的事实，然后我们在 foo 内部的事实，然后我们在 foo 内部的事实，然后我们继续做实际的加法。

of adding 222 to 222 of adding 222 to 222 of adding 222 to 222 giving us out the answer we expect so giving us out the answer we expect so giving us out the answer we expect so let's summarize what we did we first

将 222 加到 222，给出我们期望的答案。所以让我们总结一下我们做了什么：我们首先……

evaluated the argument then substituted evaluated the argument then substituted evaluated the argument then substituted that value into the body of the that value into the body of the that value into the body of the procedure and this led to the behavior

求值了参数，然后替换，求值了参数，然后替换，求值了参数，然后将该值替换到过程体中，这导致了行为……

procedure and this led to the behavior in which we've said we've evaluated the argument once that was our marker on the screen then we were inside foo then we return the value keep that in mind as we now go to the alternative model.

过程体，这导致了行为，其中我们说我们已经求值了参数一次，那是我们屏幕上的标记，然后我们在 foo 内部，然后我们返回值。记住这一点，现在我们转向替代模型。

Now let's think of the alternative model this is a normal order model in which we're going to first evaluate the procedure to get out the thing we're dealing with but then the arguments we're simply going to substitute into the body of that procedure and keep unwinding the evaluations until we get down to things that either involve.

现在让我们考虑替代模型。这是一个正则序模型，其中我们将首先求值过程以得到我们处理的东西，但然后参数我们将简单地替换到该过程体中，并继续展开求值，直到我们得到涉及……

down to things that either involve printouts or just primitive operations. Same definition of foo, same call, but what's the difference now? Well, in this case, we take that entire argument, we get the value foo, but we substitute that entire argument in every place in the body foo where we see X.

得到涉及打印或仅原始操作的东西。相同的 foo 定义，相同的调用，但现在有什么区别？嗯，在这种情况下，我们取整个参数，我们得到 foo 的值，但我们将整个参数替换到 foo 体中每个看到 X 的位置。

This says that now we're going to turn this evaluation into an evaluation of a begin that does the right line inside foo—that's the first part of the body of foo—and then everywhere we saw an X, we're substituting that expression. Notice we've done no

这表示现在我们将把这个求值转化为对一个 begin 的求值，该 begin 在 foo 内部做正确的行——那是 foo 体的第一部分——然后在我们看到 X 的每个地方，我们替换那个表达式。注意我们还没有做任何……

In that expression, notice we've done no evaluation yet. We've simply substituted it directly into the body. Therefore, nothing is printed out. We're simply reducing to this evaluation.

在那个表达式中，注意我们还没有做任何求值。我们只是直接将其替换到体中。因此，没有打印任何东西。我们只是简化为这个求值。

In this case, we evaluate these expressions in order. So, we first evaluate the line that says we're inside foo, and that gets printed out. Then, we turn to the next sub-expression in the begin, the plus. And the plus, we know, is of course a primitive thing.

在这种情况下，我们按顺序求值这些表达式。所以，我们首先求值说我们在 foo 内部的行，那被打印出来。然后，我们转向 begin 中的下一个子表达式，即加号。而加号，我们知道，当然是原始的东西。

So, we're going to, in this case, have to actually evaluate the arguments. We can't simply substitute them in because there's no compound procedure.

所以，在这种情况下，我们将不得不实际求值参数。我们不能简单地将它们替换进去，因为没有复合过程。

because there's no compound procedure here, so we in this case now evaluate the first of those to begin expressions, which says write out the line I'm inside the argument, then get the value 222 and return it. Do the same thing for the second argument 2 plus, since it's a primitive procedure, then actually apply that for a similar primitive procedure to the two arguments 22222, returning out the value we expect.

因为没有复合过程，所以在这种情况下，我们现在求值那些 begin 表达式中的第一个，它说写出我在参数内部的行，然后得到值 222 并返回它。对第二个参数做同样的事情，加号，由于它是原始过程，然后实际应用那个类似的原始过程到两个参数 22222，返回我们期望的值。

Ah, and now we see there's a difference. Remember in the previous case, the applicable order case, what happened? We first evaluated the

啊，现在我们看到了区别。记住在之前的情况下，应用序的情况，发生了什么？我们首先求值了……

what happened we first evaluated the argument so we printed out in fact eval Arg we did it once because we then substituted that value into the body and applied the procedure in which case we said we're now inside full and we return the result here it's as we said it's a

发生了什么？我们首先求值了参数，所以我们打印了 eval Arg，我们做了一次，因为我们将该值替换到体中并应用了过程，在这种情况下我们说我们现在在 foo 内部，我们返回结果。这里正如我们所说，它是……

if we substituted the unev alyou ated expression into the body of the procedure so now we only first set inside of food writing out we're inside foo and then we go ahead when required by a primitive procedure to do the actual evaluation of the argument and of course here we have to do it twice

如果我们把未求值的表达式替换到过程体中，所以现在我们首先设置 foo 内部，写出我们在 foo 内部，然后当原始过程要求时，我们继续做参数的实际求值，当然这里我们必须做两次。

Course here we have to do it twice because we have to evaluate each argument that was substituted in before returning the result. Our goal then is to say AHA normal order is a different behavior. It's substitute until required to evaluate, as opposed to applicative order, which says get the value and then apply.

当然这里我们必须做两次，因为我们必须求值每个被替换进来的参数，然后返回结果。我们的目标则是说：啊哈，正则序是一种不同的行为。它是替换直到需要求值，而应用序则是先取值然后应用。

Our goal now is to see two things: one, why is that a useful change to make; and two, how do we change the evaluator to actually accomplish that.

我们现在的目标是看到两件事：一是为什么这是一个有用的改变；二是我们如何改变求值器来实际实现这一点。

Well, let's deal with the second one first. What changes should we make to a Val and apply the eval and apply we've...

好吧，让我们先处理第二个问题。我们应该对 eval 和 apply 做哪些改变？我们一直在讨论的 eval 和 apply……

Val and apply the eval and apply we've grown to know and love in order to implement this new idea, this idea of normal order evaluation or sometimes called lazy evaluation. And of course it's called lazy evaluation because we're only evaluating the arguments when required, either because we need to print them out or because we're down to a primitive procedure application.

为了实施这个新想法，即正则序求值，有时也称为惰性求值，我们需要回顾并运用我们已经熟知并喜爱的 eval 和 apply。当然，它被称为惰性求值，是因为我们只在需要时才求值参数，要么是因为需要打印它们，要么是因为我们遇到了基本过程的调用。

### 2. Implementing lazy evaluation in the evaluator (在求值器中实现惰性求值)

So let's look at the changes we need to make. Well, let's start here, and here means when we're applying a compound procedure, that is, we're applying one of these things.

让我们看看需要做的修改。嗯，我们从这里开始，这里指的是当我们应用一个复合过程时，也就是说，我们正在应用这些由 lambda 构造的对象之一。

当我们将一个用 lambda 构建的对象应用时，我们想要做的关键步骤是：在一个新的环境中对该过程的主体进行求值。

当我们将一个用 lambda 构建的对象应用时，我们想要做的关键步骤是：在一个新的环境中对该过程的主体进行求值。

这个环境应该包含过程的一组参数，并将它们与某些内容绑定在一起——不是我们想要获取的实际参数值，而是一系列延迟的参数。那么，我们所谓的“延迟参数”具体是什么意思呢？

这个环境应该包含过程的一组参数，并将它们与某些内容绑定在一起——不是我们想要获取的实际参数值，而是一系列延迟的参数。那么，我们所谓的“延迟参数”具体是什么意思呢？

让我们创建一个结构，使得我们能够推迟实际获取参数值的过程。这个概念在思考我们的示例时是合理的，因为当应用一个过程时，我们并不希望立即对参数求值。

让我们创建一个结构，使得我们能够推迟实际获取参数值的过程。这个概念在思考我们的示例时是合理的，因为当应用一个过程时，我们并不希望立即对参数求值。

Example we want to apply a procedure to a set of arguments. What that says is, in fact, say, "Gee, just take those arguments and substitute them into the body when necessary, but don't actually get their values." So our change in a compound procedure says we'll still evaluate the body of a procedure in a new environment, but rather than binding the parameters of the procedure to their actual arguments, we'll bind them to this special structure that keeps track of the expression to be evaluated when required, plus, of course, we're going to

例如，我们想要将一个过程应用于一组参数。这实际上是在说：“嘿，就把这些参数代入主体中，当需要时再使用，但不要真正获取它们的值。”因此，我们对复合过程的修改是：我们仍然会在新环境中求值过程的主体，但不再将过程的参数绑定到它们的实际参数值，而是将它们绑定到这个特殊结构上，该结构记录了在需要时要求值的表达式，当然，我们还要

required plus of course we're going to

需要，当然我们还要

Required plus of course we're going to need to have the environment in which we want to do that evaluation. Actually that last point is worth stressing because it's a change. Remember prior to this, apply didn't need to know about its environment; we simply applied a procedure to a set of arguments because in those cases we had values available. Here we're saying we're going to delay, we're going to be lazy, we're going to hold off getting the value of the arguments to a procedure. But of course ultimately we want those values relative to the environment we started with, so we're

需要，当然我们还要有我们想要进行求值的环境。实际上，最后一点值得强调，因为这是一个变化。记住，在此之前，apply 不需要知道它的环境；我们只是简单地将一个过程应用于一组参数，因为在那些情况下我们有可用的值。这里我们说的是要延迟，要懒惰，要推迟获取过程参数的值。但当然，最终我们想要相对于我们开始时的环境来获取这些值，所以我们

environment we started with so we're going to need to pass that down and that says we need to change in fact what happens inside of our apply to pass the environment in as an argument okay so

我们开始时的环境，所以我们需要传递那个环境，这表示我们需要改变 apply 内部发生的事情，将环境作为参数传递进去。好的，所以

with this change when we deal with compound procedures we'll do the thing we want that is will delay actually getting the value of the arguments going to have to build the structure for list of delayed arguments we'll do that in a second but we can conceptualize that it simply takes the arguments as expressions and glues them together with something that marks them as a thing to

有了这个修改，当我们处理复合过程时，我们会做我们想做的事情，即延迟实际获取参数值。我们将不得不构建延迟参数列表的结构，我们稍后会做这件事，但我们可以概念化地认为，它只是将参数作为表达式，并将它们与某种标记粘合在一起，标记它们为待办事项。

something that marks them as a thing to be done later ultimately though we're going to get down to a primitive application and in that case we said we wanted to do the actual work when we got down to applying a primitive procedure

标记它们为以后要做的事情。但最终，我们会遇到基本过程的调用，而在那种情况下，我们说过当我们应用基本过程时，我们想要做实际的工作。

we wanted to get the actual values out so our other change will be to say when we get down to that stage we'll take the set of arguments in and actually get their values that is we'll force them to be evaluated at that stage and here again we'll need to pass the environment into this procedure because we're going

我们想要获取实际的值，所以我们的另一个修改将是，当我们到达那个阶段时，我们将接收一组参数并实际获取它们的值，也就是说，我们将强制它们在那个阶段被求值。这里我们再次需要将环境传递到这个过程中，因为我们将

into this procedure because we're going to have to walk our way down this set of arguments asking for the actual value of that argument expression with respect to an environment so notice then small number of changes applies now taking in an environment as an argument and when we apply a compound procedure we're simply building this thing that constructs a list of delayed arguments

进入这个过程，因为我们将不得不遍历这组参数，询问该参数表达式相对于某个环境的值。所以注意，修改很少：apply 现在将环境作为参数，当我们应用复合过程时，我们只是构建这个构造延迟参数列表的东西。

we may have buried some work underneath there although we'll see shortly that's not true and then when we apply a primitive procedure we're going to have to construct out the list of the actual

我们可能在其中埋藏了一些工作，尽管我们很快就会看到并非如此。然后当我们应用基本过程时，我们将不得不构造出实际参数值的列表。

To construct out the list of the actual argument values, forcing the evaluation of those arguments at this stage. Otherwise, very small set of changes—what else do we have to change? Well, of course, we've changed apply. We're calling it L-apply here for lazy apply, as you might have already figured out. We've changed apply, so we have to change how it's used. But in fact, most of the work is now in apply.

构造出实际参数值的列表，在这个阶段强制对这些参数进行求值。除此之外，修改非常少——还有什么需要修改呢？嗯，当然，我们修改了 apply。我们在这里称之为 L-apply，表示惰性 apply，你可能已经猜到了。我们修改了 apply，所以我们必须修改它的使用方式。但实际上，大部分工作现在都在 apply 中。

We need to call it with the actual value of the operator, but just the expressions for the operands and the environment, so our change to a vowel is...

我们需要用运算符的实际值来调用它，但只需要操作数的表达式和环境，所以我们对 eval 的修改是……

environment so our change to a vowel is

环境，所以我们对 eval 的修改是

environment so our change to a vowel is very simple when we get to an application we pass in the environment is the third argument we need to get the actual values of the operator so we're gonna have to do some work there to say get the value do the work to get the value out but notice we simply take the operands as a tree structure and ask them in to apply we're just passing the expressions down notice that this is the only change to eval all of the other expressions the special forms and the primitives are going to be exactly the same it's only in the application that

环境，所以我们对 eval 的修改非常简单：当我们遇到一个应用时，我们将环境作为第三个参数传递进去。我们需要获取运算符的实际值，所以我们必须做一些工作来获取值。但注意，我们只是将操作数作为树结构，并将它们传递给 apply，我们只是传递表达式。注意，这是对 eval 的唯一修改；所有其他表达式、特殊形式和基本过程都将完全相同，只有在应用时

Same, it's only in the application that we change it, and to say it one more time, we're going to get the actual value of the operator, going to do the evaluation. We will define actual value in a second. We're going to simply pass the operands as expressions down to apply, and we pass the environment along as well.

相同，只有在应用时我们才修改它，再说一次，我们将获取运算符的实际值，进行求值。我们稍后会定义实际值。我们将简单地将操作数作为表达式传递给 apply，并且我们也传递环境。

Apply, as we just saw, will take those operands and either force their evaluation if we need them for primitive application, or otherwise just make up a list of delayed arguments if we're doing a compound expression. Now, what else do we need? Well.

正如我们刚才看到的，apply 将接收这些操作数，如果我们需要它们用于基本过程，则强制对它们求值，否则，如果是复合表达式，则只是构造一个延迟参数列表。现在，我们还需要什么？嗯。

expression. Now what else do we need? Well, notice we've now made a distinction between getting the actual value of an expression versus simply delaying it out. As we said, when we get the primitive applications, we'll need the value. We'll need the value as well for the operator. Everything else we want to delay.

表达式。现在还需要什么？嗯，注意我们现在区分了获取表达式的实际值与简单地延迟它。正如我们所说，当我们遇到基本过程调用时，我们需要值。对于运算符，我们也需要值。其他一切我们都想延迟。

But we've introduced two different kinds of expressions now, or if you'd like, two different kinds of values: something that is the actual value of the expression, and some things more that is more like a promise to get the value when asked for.

但我们现在引入了两种不同的表达式，或者如果你愿意，两种不同的值：一种是表达式的实际值，另一种更像是承诺在需要时获取值的承诺。

promise to get the value when asked for

承诺在被要求时获取值

promise to get the value when asked for it we need to implement those and we'll do that as follows first to get the actual value of an expression with respect to an environment well we might expect that that simply says go off and evaluate it and that's certainly built into this we'll do the evaluation of the expression with its respect to the environment but notice evaluating that thing might itself give us back something that's a delay thing if it's a nested combination of pieces for instance evaluating the first level may give us back something that is still a

承诺在被要求时获取值，我们需要实现这些，我们将按如下方式进行。首先，要获取一个表达式在某个环境中的实际值，我们可能会期望直接去求值它，这当然已经内置于此：我们将对该表达式在其环境中进行求值。但请注意，求值该表达式本身可能返回一个延迟的东西，如果它是嵌套的组合片段，例如，求值第一层可能返回给我们一个仍然是延迟承诺的东西，以获取另一个值。

give us back something that is still a delayed promise to get another value so we'll add one more piece here we'll add a procedure we're going to write shortly called Forsett which says if this expression comes back make sure I force it to be evaluated all the way out so that if it returns for me something that is already a basic value not a delayed promise I'll return it but otherwise I'll go ahead and force whatever is returned as a delayed promise to do the actual evaluation keep on winding it all the way through all of the stages until

返回给我们一个仍然是延迟承诺的东西，以获取另一个值。因此，我们将在这里添加一个部分：我们将添加一个过程，稍后我们将编写，称为 Forsett，它说：如果这个表达式返回，确保我强制它被完全求值，这样如果它返回给我的东西已经是一个基本值而不是延迟承诺，我将返回它；否则，我将继续强制返回的延迟承诺进行实际求值，一直展开所有阶段，直到……

The way through all of the stages until we get back an actual value, key thing to see though, is asking for the actual value of an expression evaluates that expression and then keeps evaluating using forces until we get down to a base value. As we saw, we will certainly use actual value inside our evaluator to get the value of the procedure.

一直展开所有阶段，直到我们得到一个实际值。关键要看到的是，获取一个表达式的实际值会求值该表达式，然后使用 force 继续求值，直到我们得到一个基础值。正如我们所见，我们肯定会在求值器内部使用 actual value 来获取过程的值。

And we do that because we need to know whether the procedure is in a primitive thing or a compound thing, in order to be able to keep unwrapping the substitution of unevaluated arguments into the bodies of those things. We also need to use that.

我们这样做是因为我们需要知道该过程是原语还是复合的，以便能够继续展开未求值参数替换到这些过程体中的过程。我们也需要使用它。

those things we also need to use that though ultimately when we go off and get the set of values remember in our little lazy apply if we're applying a primitive procedure to a set of arguments we need to take that arguments and make sure we get out the actual values of them list.

那些东西，我们也需要使用它，尽管最终当我们去获取值列表时，记住在我们的惰性 apply 中，如果我们将一个原语过程应用于一组参数，我们需要获取这些参数并确保我们得到它们的实际值列表。

of our values should take a set of expressions in an environment and evaluate all of those expressions in that environment and here's how we do it it's pretty easy it's a list of expressions we simply walk our way down the list getting the actual value of.

我们的值列表应该接受一组表达式和一个环境，并求值该环境中的所有表达式。这里是我们如何做的：这很容易，它是一个表达式列表，我们只需沿着列表向下走，获取每个表达式的实际值。

the list getting the actual value of each of the expressions in turn and gluing them together and remember applying actual Val to one of these expressions will evaluate that expression in the environment if it returns another delayed thing it will force it and continue the evaluation until we get out a base expression so list of our values takes a set of delayed promises and reduces it to their actual values on the other hand if we're applying a compound procedure to a set of arguments here we want to just take the arguments and substitute them in directly into the

沿着列表向下走，依次获取每个表达式的实际值，并将它们粘合在一起。记住，将 actual Val 应用于这些表达式之一将求值该环境中的表达式；如果它返回另一个延迟的东西，它将强制它并继续求值，直到我们得到一个基础表达式。因此，list of our values 接受一组延迟承诺并将其简化为它们的实际值。另一方面，如果我们将一个复合过程应用于一组参数，这里我们只想获取参数并直接将它们替换到……

Substitute them in directly into the body, but we need to label them as something that is a delayed thing, a promise that says here is an expression I haven't done any work on it, but when you actually ask me to do it, all evaluate it, list the delayed args, then does exactly the opposite of list of Arc values, that is, it walks down this sequence of expressions in order and glues a label on front of it that actually delays it, creates a promise that says here is the expression represented just as tree structure and here's the environment in which.

直接将它们替换到过程体中，但我们需要将它们标记为延迟的东西，一个承诺，说：这里是一个表达式，我还没有对它做任何工作，但当你实际要求我这样做时，我会求值它。list the delayed args 则与 list of Arc values 完全相反，也就是说，它按顺序沿着这个表达式序列向下走，并在前面粘上一个标签，实际上延迟它，创建一个承诺，说：这里是表达式，仅表示为树结构，这里是环境，在其中……

here's the environment in which eventually I want to evaluate this expression and here's a data structure that glues them together that says I'll do it when you ask me to notice these are the only changes we need to make to eval and apply to implement lazy evaluation.

这里是环境，最终我想在其中求值这个表达式，这里是一个数据结构，将它们粘合在一起，说：当你要求我时我会做。注意，这些是我们需要对 eval 和 apply 进行的唯一更改，以实现惰性求值。

so let's recap what we've done we buried a few details we'll fix but let's recap what we've done we've changed apply so that if it is a primitive application we're going to get the actual values of expressions with respect to an environment if it's a compound application we're going to

所以让我们回顾一下我们做了什么。我们埋了一些细节，我们会修复，但让我们回顾一下我们做了什么。我们更改了 apply，因此如果它是原语应用，我们将获取表达式相对于环境的值；如果它是复合应用，我们将……

Compound application we're going to delay the evaluation of the expressions of our arguments until actually required to do them. And eval simply evaluates when given a compound expression the first expression to get the procedure, also we know what to do.

复合应用，我们将延迟对参数表达式的求值，直到实际需要它们。而 eval 只是简单地求值：当给定一个复合表达式时，首先求值第一个表达式以获取过程，我们也知道该怎么做。

What passes the rest of the arguments down as delayed things. Ultimately when we have to do it in the primitive application, will force the evaluation of these delayed things, but otherwise that's it.

将剩余的参数作为延迟的东西传递下去。最终当我们在原语应用中必须这样做时，将强制这些延迟的东西的求值，但除此之外，就是这样。

Now the only things left are this idea of what does it mean to force it and.

现在唯一剩下的就是强制意味着什么，以及延迟意味着什么。

### 3. Thunks and forcing (Thunks 与强制求值)

Of what does it mean to force it and what does it mean to delay something? So we need to have some abstraction for representing delayed versions of expressions. Well, for historical reasons, we call one of these delayed things one of these promises, a thunk. And abstractly, a thunk is simply a promise. They promised a return of value when it's needed later, or when it's forced, if you like.

强制意味着什么，延迟意味着什么？因此，我们需要某种抽象来表示表达式的延迟版本。出于历史原因，我们将这些延迟的东西之一，这些承诺之一，称为 thunk。抽象地说，thunk 只是一个承诺。它们承诺在以后需要时，或者如果你愿意，在被强制时，返回一个值。

So it says, inside a thunk, we need to represent the expression itself, the environment that's going to be the context in which we get the value of that expression, and a label that says...

所以它说，在 thunk 内部，我们需要表示表达式本身、将作为获取该表达式值的上下文的环境，以及一个标签，说……

that expression and a label that says it's a thunk and it represents this promise to do the work when asked to. Actually implement this well, we can just build this as a tag structure right? We could make a list which has a label func at the front, plus the actual expression represented as list structure, since that's how it's passed into the evaluator.

该表达式和一个标签，说它是一个 thunk，它代表在被要求时做这项工作的承诺。实际上实现这个，我们可以将其构建为一个标签结构，对吧？我们可以制作一个列表，前面有一个标签 func，加上实际表达式，表示为列表结构，因为这是它被传入求值器的方式。

plus a pointer to the environment, and that can be our concrete representation of a thunk, a delayed promise to do evaluation. Well, with that in mind, we can see how we can easily build this delay if something simply...

加上一个指向环境的指针，这可以是我们的 thunk 的具体表示，一个延迟求值的承诺。考虑到这一点，我们可以看到如何轻松构建这个 delay，如果某物只是……

Build this delay if something simply constructs a list with the tag thunk, the expression, and the environment. Remember again, since expression is just being passed in as list structure, no evaluation is taking place here—it's simply glued together into one of these structures.

构建这个 delay，如果某物只是构造一个带有标签 thunk、表达式和环境的列表。再次记住，由于表达式只是作为列表结构传入，这里没有发生求值——它只是被粘合到这些结构之一中。

And then, of course, we have ways of telling whether something is a thunk by checking whether it's a tag list with the appropriate label, and for pulling out, of course, the expression and the environment that we want to use ultimately to actually force the evaluation and the corresponding pieces.

然后，当然，我们有办法通过检查它是否是一个带有适当标签的标签列表来判断某物是否为 thunk，并且为了取出我们最终要用来强制求值以及相应部分的表达式和环境。

evaluation and the corresponding pieces when given one of these delayed promises we need to ultimately force it to be evaluated here we can be careful well first check to see if this is a delayed thing a thunk if it isn't then we know that this is already down to a basic value we just return it this is exactly why we put that label on there to be able to distinguish between tree structure for example that's just part of the data structure being manipulated from something that actually is being waited to be evaluated if on the other

求值以及相应的部分，当给定这些延迟承诺之一时，我们最终需要强制它被求值。在这里我们可以小心地先检查这是否是一个延迟的东西，一个 thunk。如果不是，那么我们知道这已经是一个基本值，我们直接返回它。这正是我们放置那个标签的原因，以便能够区分例如只是被操作的数据结构一部分的树结构，与实际上等待被求值的东西。另一方面，如果

waited to be evaluated if on the other

等待被求值。另一方面，如果

Waited to be evaluated. If on the other hand this is a tagged thing that says it's a thunk, we'll get out the expression, we'll get out the corresponding environment, and then we'll do the actual evaluation. We'll use actual value, which we know will force the evaluation of this. Rushon and notice if the expression on first evaluation reduces to another delayed thing, actual value will force it again and continue to do so until it just returns an object.

等待被求值。另一方面，如果这是一个标记为 thunk 的东西，我们将取出表达式，取出相应的环境，然后进行实际的求值。我们将使用实际值，我们知道这会强制对此进行求值。注意，如果表达式在第一次求值时归约为另一个延迟的东西，actual-value 将再次强制它，并继续这样做，直到它返回一个对象。

Well, there are the changes. Very simple changes to our evaluator have allowed us now to build something that does lazy evaluation.

好了，这就是变化。对我们的求值器进行的非常简单修改，使我们能够构建出执行惰性求值的东西。

something that does lazy evaluation does delayed evaluation we made a small change to apply we made a small change to eval we introduced one new kind of thing a delayed object or a thunk and other than that we've done everything we need to do in order to change the way our evaluator works

执行惰性求值的东西，即延迟求值。我们对 apply 做了一个小改动，对 eval 做了一个小改动，引入了一种新的事物：延迟对象或 thunk。除此之外，我们已经完成了改变求值器工作方式所需的一切。

notice we now have a dramatic change in behavior based on a small change in the evaluator as we've said the evaluator defines the semantics for us and now we can see this relationship can have very strong effects even with small changes so what have we accomplished at this point

注意，我们现在基于求值器的小改动而有了行为上的巨大变化。正如我们所说，求值器为我们定义了语义，现在我们可以看到这种关系即使在小改动下也能产生非常强烈的影响。那么，我们在这个阶段取得了什么成就呢？

Have we accomplished at this point? Basically, we've converted our standard evaluator, our applicative order evaluator, into a normal order evaluator. And to do that, we had to make only a small number of changes in the evaluator itself.

我们在这个阶段取得了什么成就？基本上，我们已经将我们的标准求值器，即应用序求值器，转换成了正则序求值器。要做到这一点，我们只需要对求值器本身做少量修改。

In terms of things to change in the code, however, we have had to introduce a couple of major new things. The primary one has been this idea of a delayed object—the idea of taking an expression plus the environment in which it is to be evaluated, and sticking them together into a promise, a thunk, that says I'm not going to evaluate.

然而，就代码中需要改变的东西而言，我们必须引入几个主要的新事物。最主要的是延迟对象的概念——将表达式及其求值环境组合在一起，并将它们粘合成一个承诺，一个 thunk，它说“我不打算求值”。

That says I'm not going to evaluate myself now, but when you ask me for the value, I'll give it to you. And in particular, we use that to delay evaluation of any of the arguments in procedure applications until we get down to either things that need to be printed, things that are required in order to control the evaluation, or applications of primitive procedures to their actual arguments.

它说“我现在不求值自己，但当你向我请求值时，我会给你。”特别是，我们用它来延迟过程应用中的任何参数的求值，直到我们到达需要打印的东西、控制求值所需的东西，或者将基本过程应用于其实际参数的情况。

One consequence of using these delayed objects as part of our lazy evaluation is that we end up doing at least at present some extra work. If you go back to our earlier example when we...

在我们的惰性求值中使用这些延迟对象的一个后果是，我们最终至少目前会做一些额外的工作。如果你回到我们之前的例子，当我们……

Go back to our earlier example when we compared normal order and applicative order using the food procedure. You will see that in lazy evaluation, if we use the same argument multiple places inside a procedure body, we had to re-evaluate it each time. If this is an expensive computation, we could be wasting a lot of effort. On the other hand, in applicative order evaluation, we evaluated the argument once and then simply used it or referenced it as part of the environment inside the body of the procedure.

回到我们之前的例子，当我们使用 food 过程比较正则序和应用序时，你会看到在惰性求值中，如果我们在过程体内多处使用同一个参数，我们每次都必须重新求值它。如果这是一个昂贵的计算，我们可能会浪费大量精力。另一方面，在应用序求值中，我们只求值一次参数，然后在过程体内简单地使用它或作为环境的一部分引用它。

trade off this thing is there some way

权衡一下，有没有某种方法

Trade off this thing is there some way of keeping track of values once we have forced a delayed object in order to avoid the cost of re-evaluation and the answer is of course we can. The basic idea is that we'll memorize a thunk and by memoization we mean that we'll keep track using a memo if you like we'll keep track of when we've actually done the work. So the basic idea is that we start off with a thunk, a delayed expression, an expression that's simply a promise to be evaluated when asked to. When we actually force the evaluation of that thumb, when we do the

权衡一下，有没有某种方法在强制求值一个延迟对象后跟踪其值，以避免重新求值的成本？答案当然是我们能做到。基本思想是，我们将记忆一个 thunk，通过记忆化，我们指的是我们将使用一个备忘录（如果你愿意）来跟踪我们何时实际完成了工作。所以基本思想是，我们从一个 thunk 开始，一个延迟表达式，一个仅仅是在被要求时求值的承诺。当我们实际强制对该 thunk 求值时，当我们做……

evaluation of that thumb when we do the work to get the funks value out we'll simply remember it we'll keep track of that by putting a tag on it that says here's the value associated with this thunk and then if the values ever needed again we'll just return that value rather than recomputing it

对该 thunk 求值时，当我们做工作以获取 thunk 的值时，我们将简单地记住它。我们将通过在其上放置一个标签来跟踪它，该标签说“这是与该 thunk 关联的值”，然后如果再次需要该值，我们将直接返回该值，而不是重新计算它。

so remember we've been representing thunks as a tagged structure it's got a label that says it's a thunk it's got a pointer to the actual expression just as tree structure and a pointer to the environment which we'll use to help us evaluate the expression when needed

所以记住，我们一直将 thunk 表示为带标签的结构：它有一个标签说它是一个 thunk，有一个指向实际表达式的指针（就像树结构），以及一个指向环境的指针，我们将在需要时用它来帮助求值表达式。

Evaluate the expression when needed now. Given that this is our thunk after we've done the evaluation, what do we want to have happen? Well, we simply want to take the result, the value that comes from that evaluation, and keep track of it together with a label that says I've already done the work.

现在，在需要时求值表达式。鉴于这是我们的 thunk，在我们完成求值之后，我们希望发生什么？好吧，我们只是简单地取结果，即来自该求值的值，并将其与一个标签一起跟踪，该标签说“我已经完成了这项工作”。

So concretely, we can simply mutate the current thunk into an evaluated thunk by putting that tag on the front together with the result. Notice that we used an important word there in describing that: we said we would mutate the thunk. That, of course,That, of course,

所以具体来说，我们可以简单地将当前的 thunk 变异为一个已求值的 thunk，方法是将该标签连同结果放在前面。注意，我们在描述中使用了重要的词：我们说我们将变异 thunk。那当然，那当然，

would mutate the thunk that of course

将变异 thunk，那当然

would mutate the thunk that of course means we're going to take this list structure and actually change its contents and we can ask the question why would we want to just mutate the thunk why not simply create a new object that says I'm an evaluated thing and here's my result

将变异 thunk，那当然意味着我们将取这个列表结构并实际改变其内容。我们可以问一个问题：为什么我们只想变异 thunk，而不是简单地创建一个新对象，说“我是一个已求值的东西，这是我的结果”？

and the answer of course is if some other part of the procedure or some other part of the evaluation is pointing to this structure it's pointing to this object that is a thunk by mutating the thunk those things still point to the same piece therefore I don't have to worry about trying to keep track of who

答案当然是，如果过程的其他部分或求值的其他部分指向这个结构，即指向这个作为 thunk 的对象，那么通过修改 thunk，那些部分仍然指向同一块数据，因此我不必担心跟踪谁

worry about trying to keep track of who needs this value. I have simply changed the value directly, without having to cause any changes to the rest of the procedures around it.

担心跟踪谁需要这个值。我只是直接改变了值，而无需对其余过程做任何改动。

How about implementing that idea? Well, it's pretty straightforward. Notice we're taking a particular data structure, a thunk, and we're adding some components to it. In particular, we now have a thunk that can be evaluated, so we'll need to have a way of checking that with a predicate that will just be a tag list check to see if the first part of it, the tag, is evaluated thunk as a symbol.

如何实现这个想法呢？嗯，这相当直接。注意我们采用了一个特定的数据结构，即 thunk，并向其添加了一些组件。特别是，我们现在有了一个可以被求值的 thunk，所以我们需要一种方法来检查它，使用一个谓词，只需检查标签列表，看第一部分（标签）是否是符号 evaluated-thunk。

tag is evaluated thunk as a symbol and we'll have to have a way of getting the funk value out of an evaluated thunk which we'll use by grab the right piece of the list structure.

标签是符号 evaluated-thunk，我们还需要一种方法从已求值的 thunk 中获取值，我们将通过抓取列表结构的正确部分来使用它。

This simply goes hand in hand with the parts we had earlier for funks themselves.

这正好与之前为 thunk 本身定义的部分相辅相成。

Now you might expect that we should also have a constructor for an evaluated thunk. It seems like we're building a data abstraction here. We've got a predicate, we got a selector; where is the constructor? But remember what we said: we said we're going to mutate an existing structure, not create a new one.

现在你可能会期望我们也应该有一个已求值 thunk 的构造函数。看起来我们正在构建一个数据抽象。我们有了谓词，有了选择器；构造函数在哪里？但记住我们说过的话：我们说我们将修改现有结构，而不是创建新结构。

Existing structure not create a new one, and that means we're really just adding or modifying the components of a thunk itself. And therefore, we will not have a specific constructor for an evaluated thunk, but we'll rely on changing what happens with a thunk when we force things.

现有结构而不是创建新结构，这意味着我们实际上只是添加或修改 thunk 本身的组件。因此，我们不会为已求值的 thunk 提供特定的构造函数，而是依赖于在强制求值时改变 thunk 的行为。

Now remember what force it did: it said, given an object, it would first check to see if it's a thunk, and if it was, it would go ahead and get the actual value of the expression part of the thunk with respect to the environment part of the thunk, it would do all the...

现在记住 force 做了什么：它说，给定一个对象，它首先检查它是否是 thunk，如果是，就继续获取 thunk 中表达式部分相对于环境部分的实际值，它会做所有……

part of the thunk it would do all the work to reduce it to a value if it wasn't a thunk it would just return the object saying that must be the value I want here we need to change things slightly if the object is a func that is it has that tag on the front saying I'm a thunk I therefore have an expression in an environmental but I have not yet done the evaluation in that case we will again do the work to get out the actual value we will force the evaluation of the expression with respect to the environment and I'll remind you that actual valve a value rather would have

thunk 的部分，它会做所有工作将其归约为一个值；如果它不是 thunk，它就直接返回该对象，说那一定是我想要的值。这里我们需要稍微改变一下：如果对象是一个 thunk（即它前面有标签表明“我是 thunk，因此我有表达式和环境，但我还没有进行求值”），在这种情况下，我们将再次做工作以获取实际值；我们将强制表达式相对于环境的求值，并且我要提醒你，实际值（一个值）本身会包含额外的 force 操作，以防返回的值本身是 thunk。因此，我们现在都有了结果。

actual valve a value rather would have within itself additional forces to force all the evaluations in case a value that's returned is itself a thunk as a consequence we have both the result now

实际值（一个值）本身会包含额外的 force 操作，以防返回的值本身是 thunk。因此，我们现在都有了结果。

what we'll do is we'll mutate the existing object will change the first part of the object from the label func to the label evaluated thunk we'll change the next component of the object notes notice the use of coder of object to get the second part of the list to actually put in there the result itself replacing what used to be the expression

我们要做的是修改现有对象：将对象的第一部分从标签 thunk 改为标签 evaluated-thunk；改变对象的下一部分（注意使用 cdr 获取列表的第二部分）以实际放入结果本身，替换原来的表达式。

### 4. Memoization to avoid re-evaluation (记忆化以避免重复求值)

replacing what used to be the expression

替换原来的表达式

Replacing what used to be the expression with result, and then finally we'll mutate the last part of the object to be the empty list. That is, we will drop the pointer to the environment because we no longer need it, and we've mutated a list of length 3 into a list of length 2 that now has the structure of an evaluated thunk.

用结果替换原来的表达式，然后最后我们将对象的最后一部分修改为空列表。也就是说，我们将丢弃指向环境的指针，因为我们不再需要它，并且我们已经将长度为 3 的列表修改为长度为 2 的列表，现在具有已求值 thunk 的结构。

What else do we need? Well, if the object is itself an evaluated thunk, we'll just return the value. That's what we want from Forsett is the value if we have one. And of course, if it's neither a thunk nor an evaluated thunk, it's some...

我们还需要什么？嗯，如果对象本身是已求值的 thunk，我们只需返回值。这就是我们从 force 中想要的：如果我们有值，就返回它。当然，如果它既不是 thunk 也不是已求值的 thunk，而是某种……

thunk nor an evaluated thunk it's some primitive thing or some other structure will just turn return that object itself as the value and there's our change we've now gotten the ability to have a memorization version of thunks which says I'll only do the work once to evaluate a delayed object so what else do we need

thunk 也不是已求值的 thunk，而是某种原始事物或其他结构，我们将直接返回该对象本身作为值。这就是我们的改变：我们现在已经获得了 thunk 的记忆化版本，它说我只做一次工作来求值延迟对象。那么我们还缺什么？

to convert our evaluator over to a lazy or normal order evaluator not a lot turns out and in fact to see this let's think about what we've had to change so far our primary change was in apply apply now said if I'm applying a primitive procedure I'm going to go

将我们的求值器转换为惰性或正常序求值器？事实证明，并不多。事实上，让我们看看到目前为止我们不得不改变什么。我们的主要改变是在 apply 中：apply 现在说，如果我正在应用一个原始过程，我将继续获取与参数关联的实际值，因为我显然需要它们，因为我即将进行最终归约；为此，我当然需要传入环境来帮助我实现这一点。

primitive procedure I'm going to go ahead and get the actual values associated with the arguments because I clearly need them as I'm about to do a final reduction and to do that of course I needed to pass the environment in to help me have that happen.

原始过程，我将继续获取与参数关联的实际值，因为我显然需要它们，因为我即将进行最终归约；为此，我当然需要传入环境来帮助我实现这一点。

If I was dealing with a compound procedure I simply took the arguments as expressions and created a list of delayed arguments and put that into the environment the thunks that basically said I've got a promise to give you the value when I need it.

如果我处理的是复合过程，我只需将参数作为表达式，并创建延迟参数列表，将其放入环境中，这些 thunk 基本上说：我承诺在需要时给你值。

In terms of eval we went ahead and said when doing an application we'll

在 eval 方面，我们继续并说，当进行应用时，我们将

And said when doing an application we'll get the actual value of the operator we need that to know whether we're doing a primitive or a compound thing but we'll simply pass down the arguments themselves and then the other changes were ways of actually getting the actual values out for a list of arguments when needed and we put in this last little piece of memoization which is basically an efficiency issue.

并说，当进行应用时，我们将获取运算符的实际值，我们需要它来知道我们是在处理原始过程还是复合过程，但我们只需传递参数本身。然后其他改变是在需要时获取参数列表的实际值的方法，并且我们加入了最后的记忆化部分，这基本上是一个效率问题。

Now what else do we need? Well, the other change that we need is in one of our special forms and that's an if—think about what happens in an if.

现在还需要什么？嗯，另一个需要的改变是在我们的一个特殊形式中，即 if——想想在 if 中会发生什么。

That's an if. Think about what happens in an if here. In order to decide which direction I'm going to go, I need to get the actual value of the predicate. I can't make a decision if I don't know if it's just a promise to say I'll get you the value when you need it. I have to make a choice, and so within if I will go ahead and get the value of the predicate part of the expression.

即 if。想想在 if 中会发生什么。为了决定走哪条路，我需要获取谓词的实际值。如果它只是一个承诺，说“我会在需要时给你值”，我就无法做出决定。我必须做出选择，所以在 if 中，我将继续获取表达式谓词部分的值。

But the other components I can simply pass along as thunks, relying on the reduction to basic forms or the primitive things to eventually get out the value I need there. So one small change inside of.

但其他组件我可以直接作为 thunk 传递，依靠归约到基本形式或原始事物来最终得到我需要的值。所以内部的一个小改动。

there so one small change inside of there and of course you can see what I'm doing I'm working my way through now the special forms to decide are there any changes I need to make there I've changed application only the special forms remain if is one that I do need to change but the others I don't for example think about an assignment if I'm going to do an assignment a set bang of something do I need to make a change here the answer is no I can still go ahead and get out the variable that's the part of the expression anyway but in

那里，所以内部的一个小改动，当然你可以看到我在做什么，我正在逐步检查特殊形式，以决定是否需要在那里做任何改动。我已经改变了应用，只剩下特殊形式。如果是我确实需要改变的一个，但其他的我不需要。例如，考虑一个赋值，如果我要做一个赋值，对一个东西进行 set bang，我需要在这里做改动吗？答案是否定的，我仍然可以继续取出变量，那毕竟是表达式的一部分，但在

the part of the expression anyway, but in terms of what I put in is the value associated with that variable. I can go ahead and do lazy evaluation. If I don't actually need the value yet, I'll simply start away as a thunk. If it's already been evaluated, I'll start away as an evaluated thunk.

表达式的一部分，但在我要放入的内容方面，是与该变量关联的值。我可以继续进行惰性求值。如果我实际上还不需要这个值，我将简单地将其存储为 thunk。如果它已经被求值，我将存储为一个已求值的 thunk。

And otherwise, if there is a value there that was other than one of the thunks, I'll put it in, but I don't need to actually change what I'm doing inside of assignment. And that basically completes our conversion of our evaluator from applicative order to normal or lazy order evaluation one.

否则，如果那里有一个值，不是 thunk 之一，我会把它放进去，但我不需要实际改变我在赋值内部所做的事情。这基本上完成了我们将求值器从应用序转换为正则序或惰性序求值的转换。

normal or lazy order evaluation one of the goals of this particular lecture was to show, as we've done in some earlier lectures, how we can change the behavior of a language, the behavior of a programming environment, by changing the evaluator. And in particular, how small changes in the evaluator can have very large consequences, and how something happens within terms of the evaluation of expressions within that language.

正则序或惰性序求值。本讲的目标之一，正如我们在前几讲中所做的那样，是展示我们如何通过改变求值器来改变语言的行为，改变编程环境的行为。特别是，求值器中微小的改动如何能产生非常大的后果，以及在该语言中表达式求值方面如何发生某些事情。

### 5. Trade-offs and programmer control of evaluation (权衡与程序员对求值的控制)

Here we've converted from an applicative order to a normal order or lazy evaluator. One of the questions we can ask though is: what are the trade-offs in

在这里，我们已经从应用序转换到了正则序或惰性求值器。不过，我们可以问的一个问题是：在

ask though is what are the trade-offs in terms of impact on the language and with lazy evaluation we actually have an interesting dilemma on the one hand we have a real plus we only do work when we need an actual value which means in principle we could come up with very efficient ways of programming things on the other hand we're not always certain when an expression will be evaluated and if we've got a language with side-effects in which mutation takes place this can be a serious issue it can both lead to conceptual errors as well as programming errors and can cause

要问的是，在对语言的影响方面有哪些权衡？对于惰性求值，我们实际上面临一个有趣的困境。一方面，我们有一个真正的优点：我们只在需要实际值时才做工作，这意味着原则上我们可以想出非常高效的编程方式。另一方面，我们并不总是确定表达式何时会被求值，如果我们有一种带有副作用、发生变更的语言，这可能是一个严重的问题。它既可能导致概念错误，也可能导致编程错误，并可能给我们带来一些真正的困难或劣势。也可能发生我们多次求值同一个表达式的情况，因为我们在延迟求值，我们不知道它何时会被求值，我们可能最终重复做工作。

well as programming errors and can cause us some real difficulties or disadvantages it may also be the case that we evaluate the same expression more than once since we're delaying the evaluation we don't know when it's going to be evaluated we may end up redoing work

以及编程错误，并可能给我们带来一些真正的困难或劣势。也可能发生我们多次求值同一个表达式的情况，因为我们在延迟求值，我们不知道它何时会被求值，我们可能最终重复做工作。

well some of this we can fix with memoization it allows us to evaluate an expression at most once and resolve this issue of doing extra work but it has the disadvantage that we don't have control over what if we want evaluation on each use what if the evaluation of an

其中一些我们可以通过记忆化来修复；它允许我们最多求值一个表达式一次，并解决这个做额外工作的问题。但它有一个缺点，即我们无法控制如果我们想要每次使用时都求值怎么办？如果表达式的求值

Use what if the evaluation of an expression in fact involves say mutation, in which the side-effect is important and is not the value that's returned but the effect that takes place that matters. In that case we want to be able to do this, and as if we structured it so far, we don't have that ability.

使用，如果表达式的求值实际上涉及例如变更，其中副作用很重要，重要的不是返回的值，而是发生的影响。在这种情况下，我们希望能够做到这一点，而如果我们按照目前的结构，我们没有这种能力。

So this makes it sound like lazy evaluation isn't a good idea, and of course that's not true. It's really a trade-off. One way of approaching this would be to say gee, if I'm going to have no side-effects in my language, I'm not going to allow any mutations to take.

所以这听起来像是惰性求值不是一个好主意，当然事实并非如此。这实际上是一种权衡。一种处理方式是说，如果我的语言中没有副作用，我不允许任何变更发生，

mutations to take place, then lazy evaluation may actually be a very powerful thing to use with memoization in place. I can have efficient implementations, only get values when I need them, and have my code run as I would expect.

不允许任何变更发生，那么惰性求值加上记忆化可能实际上是一个非常强大的工具。我可以有高效的实现，只在需要时获取值，并让我的代码按预期运行。

But of course, if I want to have side-effects or mutations, then I have a disadvantage: I don't know how to control when I get the evaluation out. Well, we've got another alternative; we could give the programmer direct control. We could let the programmer specify: do I want something to be a func, a delayed promise, or do I want something?

但当然，如果我想要有副作用或变更，那么我就有一个劣势：我不知道如何控制何时得到求值结果。不过，我们还有另一种选择；我们可以给程序员直接控制权。我们可以让程序员指定：我想要某个东西成为一个函数，一个延迟承诺，还是我想要某个东西？

A delayed promise, or do I want something to be a value directly and let the programmer make the decisions about how to make that happen? The question then is: how do we build that into an evaluator?

一个延迟承诺，还是我想要某个东西直接成为一个值，并让程序员决定如何实现这一点？那么问题就是：我们如何将其构建到求值器中？

Well, let's change our evaluator to let the programmer directly tell us what he or she wants. In particular, we'll let the programmer specify, when they create a procedure, whether a variable should be treated as a normal variable, as a lazy variable, or as a lazy memo variable.

好吧，让我们改变我们的求值器，让程序员直接告诉我们他或她想要什么。特别是，我们将让程序员在创建过程时指定一个变量应该被视为普通变量、惰性变量还是惰性记忆变量。

Here's the formal use. We will now let lambdas have as the parameter list this...

这是形式上的用法。我们现在将让 lambda 的参数列表成为这样……

lambdas have as the parameter list this of just variables or expressions that say here's a variable name and here's what kind of thing it is in this particular example we'll treat a and C or we'd like the evaluator to treat a and C as normal variables when we apply a procedure the arguments associated with this should be evaluated before we actually do the procedure application.

lambda 的参数列表成为这样，即只是变量或表达式，说明这里是一个变量名，这里是什么类型的东西。在这个特定的例子中，我们将把 a 和 C 视为普通变量，当我们应用一个过程时，与这些参数关联的参数应该在我们实际进行过程应用之前被求值。

we'll specify that B is a lazy variable that says when an argument is or a value is passed in for this argument it should get I've got reevaluated each time its values actually needed it's a delayed.

我们将指定 B 是一个惰性变量，这意味着当一个参数或值被传入这个参数时，它应该在每次实际需要其值时才被重新求值；它是一个延迟的

values actually needed it's a delayed thing but every time we need it we'll go ahead and do the value on the other hand we're going to specify with this example that the argument D should be a lazy memo value that is when something is passed in as part of an application of this procedure the argument will be evaluated the first time its value is needed it will be delayed up until then but then that value is just returned again any other time that it's needed this will allow us to distinguish between things that we want to get evaluated right out procedure

值实际需要时才求值；它是一个延迟的东西，但每次我们需要它时，我们都会去求值。另一方面，我们将用这个例子指定参数 D 应该是一个惰性记忆值，也就是说，当某个东西作为该过程应用的一部分被传入时，该参数将在第一次需要其值时才被求值，在此之前它将被延迟，但之后该值将在任何其他需要时再次返回。这将使我们能够区分那些我们希望立即求值的东西，过程

evaluated right out procedure application time things that we want to delay until we actually need them but reuse or reevaluate rather every time because it may have a potential side effect in it, and things that we wanted to delay the evaluation of until we actually need it but having gotten it we can just keep track of it so notice what we're doing we're now giving the program with you.

在过程应用时立即求值，而我们希望延迟到真正需要时才求值，但又不想每次重新求值，因为它可能带有副作用；还有些东西我们希望延迟求值直到真正需要，但一旦得到结果就可以保存下来。注意我们现在所做的，是在赋予程序以……

You need to put declarations on the variables or parameters that are part of a procedure saying something about what kind of behavior we want there this.

你需要对作为过程一部分的变量或参数进行声明，说明我们希望在那里有哪种行为。

kind of behavior we want there this suggests that one of the changes we'll need to make to our evaluator is to change the syntax we now have to change the syntax associated with a lambda expression and a lot of this is pretty straightforward.

我们希望在那里有哪种行为，这表明我们需要对求值器做出的改变之一是改变语法，我们现在必须改变与 lambda 表达式相关的语法，而其中很多都是相当直接的。

so remember what happens in our little lazy evaluator when we go to apply a compound procedure the thing we're now changing we evaluate the body of that procedure in an extended environment and what did the extended environment do it took the list of parameters from the procedure definition itself plus a list of delayed arguments

所以记住在我们的惰性求值器中，当我们应用一个复合过程时会发生什么——我们现在正在改变的是——我们在一个扩展环境中求值该过程体，而扩展环境做了什么？它从过程定义本身取出参数列表，再加上一个延迟参数列表，

itself plus a list of delayed arguments and glued them together now we have to think a little more carefully about what does it mean to actually look at the list of parameters. Well, remember in the full-blown version of a lazy evaluator list of delayed arguments, the thing that created the arguments would simply delay everything in the list of things passed in here.

再加上一个延迟参数列表，然后将它们粘合在一起。现在我们必须更仔细地思考，查看参数列表到底意味着什么。记住，在完整版的惰性求值器中，延迟参数列表，创建参数的东西会简单地将传入列表中的所有内容都延迟。

### 6. Parameter declarations and handling different flavors of laziness (参数声明与处理不同种类的惰性)

We want to walk down the parameter list at the same time we're walking down the arguments to decide do I want to evaluate it or not, so we can build some structure to do that.

我们希望在遍历参数列表的同时遍历参数，以决定是否要求值它，所以我们可以构建一些结构来实现这一点。

build some structure to do that we'll

构建一些结构来实现这一点，我们将

Build some structure to do that. We'll need a way of getting the next variable out of the list of variables in the parameter list, as well as the rest of the variables. And we'll need a way of checking for each one of those whether it's just a symbol—which means I want to get the value directly—or whether it's something that has been declared to be of a particular type.

构建一些结构来实现这一点。我们需要一种方法从参数列表中的变量列表中取出下一个变量，以及剩余的变量。我们还需要一种方法来检查每一个变量是仅仅是一个符号——这意味着我想直接获取值——还是它已经被声明为特定类型。

So declaration question mark will simply check to see whether the next element in the parameter list is itself a list or not. To get the actual name out of one of these variable declarations, we'll check.

所以声明问号将简单地检查参数列表中的下一个元素本身是否是一个列表。为了从这些变量声明中取出实际名称，我们将检查。

These variable declarations we'll check if the thing is a pair then we know in fact that the first part of it will be in fact the name as we saw in our previous example.

这些变量声明，我们将检查如果该事物是一个序对，那么我们知道事实上它的第一部分将是名称，正如我们在之前的例子中看到的。

If the object is not a pair, then it's not being declared to be anything; we just returned the name itself.

如果对象不是序对，那么它没有被声明为任何东西；我们只返回名称本身。

And of course, we can check to see whether something is lazy or whether something is a memo by making sure that it is a pair, that it's a declaration, and then checking for the tag.

当然，我们可以通过确保它是一个序对，即它是一个声明，然后检查标签，来检查某物是惰性的还是记忆化的。

So this will allow us to walk down the parameter list associated with a procedure.

这将允许我们遍历与过程相关联的参数列表。

Associated with a procedure, we've built something with the lambda checking. We've built with the lambda checking each element in turn to decide what's the name of this variable and does it have a particular declaration on it, saying it's either something that's a lazy evaluation or a lazy memorized evaluation in terms of the values to be associated with variables.

与过程相关联，我们用 lambda 检查构建了某些东西。我们用 lambda 检查依次检查每个元素，以决定这个变量的名称是什么，以及它是否有特定的声明，说明它是惰性求值还是惰性记忆化求值，就与变量关联的值而言。

We now have several different flavors. We have standard values, numbers, symbols, and other such things that have been reduced down to their basic primitive form. We also have funks and thunks, as we said, will be something that does not ever get memorized.

我们现在有几种不同的类型。我们有标准值，如数字、符号和其他已归约为基本原始形式的事物。我们还有 funks 和 thunks，正如我们所说，将是永远不会被记忆化的东西。

That does not ever get memorized. It will be labeled as a thunk, and it will be simply treated as a thunk. This means an object in this particular version labeled as a thunk will always be reevaluated whenever we ask for its value. We never keep track of it; we simply represent it as a delayed promise.

永远不会被记忆化。它将被标记为 thunk，并且将被简单地当作 thunk 处理。这意味着在这个特定版本中标记为 thunk 的对象，每当我们要求其值时总是被重新求值。我们从不跟踪它；我们只是将其表示为延迟承诺。

We will also, however, have a memoized thunk. This is a different declaration, and here the idea is that when we first evaluate this thunk, we're going to remember it, and we will remember it in a particular structure. As we did earlier, we will mutate a thunk memo.

然而，我们还将有一个记忆化 thunk。这是一个不同的声明，这里的想法是当我们第一次求值这个 thunk 时，我们将记住它，并且我们将在一个特定的结构中记住它。正如我们之前所做的那样，我们将改变一个 thunk 记忆。

Will mutate a thunk memo structure into an evaluated thunk, keeping track of the results so when we actually force the evaluation of one of these thunk mammals, it will convert it, mutate it into this new structure. Notice what we're doing now: we're making a distinction between the thunk and a memoized thunk.

将改变一个 thunk 记忆结构为已求值的 thunk，跟踪结果，所以当我们实际强制求值这些 thunk 记忆之一时，它将转换、改变它到这个新结构。注意我们现在所做的：我们在区分 thunk 和记忆化 thunk。

In our earlier version, we always memoized thunks. Here, we're allowing the programmer to specify: if he says something is going to be a thunk, it simply remains as a delayed promise, and every time I want to get the value, I redo the work. If the programmer chooses to use a memoized thunk, the results are stored and reused upon subsequent evaluations.

在我们之前的版本中，我们总是记忆化 thunk。在这里，我们允许程序员指定：如果他说某物将是一个 thunk，它只是保持为延迟承诺，每次我想要获取值时，我都重新做工作。如果程序员选择使用记忆化 thunk，结果被存储并在后续求值中重用。

redo the work if the programmer specifies it as something to be memorized when first evaluated we will do the work to get the value out prior to that is simply a delayed promise but having done the work once will mutate this structure into an evaluated thunk keeping track of the results so we can simply use it whenever we need it.

重新做工作，如果程序员指定某物为要记忆化的，当首次求值时我们将做工作以获取值，在此之前它只是一个延迟承诺，但一旦做过一次工作，我们将改变这个结构为已求值的 thunk，跟踪结果，以便我们可以在需要时直接使用它。

now remember in our full-blown version of a lazy evaluator the key issue came when we actually went to apply a compound procedure because we glued together the parameters of the procedure with a list of delayed

现在记住，在我们完整版的惰性求值器中，关键问题出现在我们实际应用复合过程时，因为我们将过程的参数与一个延迟列表粘合在一起

glued together the parameters of the procedure with a list of delayed

将过程的参数与一个延迟列表粘合在一起

procedure with a list of delayed arguments we delayed each argument putting in a promise to get the value unnecessary and then putting that into a new environment and letting the evaluation of the body take place because we're now giving the programmer some control we have to re-examine delay it and in particular we need to make a small change previously delay it would have simply taken in an expression in an environment and delayed it that is converted it into a thunk now however we need to pass in to delay it not only the expression that potentially is to be

过程与一个延迟参数列表，我们延迟每个参数，放入一个承诺以在必要时获取值，然后将其放入新环境中，让过程体的求值发生。因为我们现在给程序员一些控制，我们必须重新检查 delay-it，特别是我们需要做一个小的改变。以前 delay-it 会简单地将一个表达式和环境延迟，即将其转换为 thunk。然而现在，我们需要传递给 delay-it 的不仅是一个可能要求值的表达式，

expression that potentially is to be delayed but also the declaration part of the parameter list that corresponds to this expression and we'll do the following if that parameter is not a declaration if it says it's just a variable then we go ahead and get the value right now that's exactly what we want get the value and return it on the other hand if this variable has been specified by the programmer as being lazy we will then convert it into one of these delayed objects we will create a structure with the name or symbol func

表达式可能被延迟，但参数列表中与该表达式对应的声明部分也需要处理。我们将这样做：如果该参数不是声明，即它只是一个变量，那么我们就立即获取其值，这正是我们想要的，获取值并返回它。另一方面，如果程序员已将该变量指定为惰性的，那么我们将把它转换为这些延迟对象之一，我们将创建一个带有名称或符号 func 的结构。

structure with the name or symbol func and expression in the environment exactly as we would have done in the normal case. On the other hand, if it's specified as something we want to memorize, we will similarly label that with the distinctive memo that it's a thunk memo and glue that together with the expression in the environment.

结构带有名称或符号 func 以及环境中的表达式，正如我们在正常情况下所做的那样。另一方面，如果它被指定为我们想要记忆的东西，我们将类似地将其标记为独特的记忆 thunk，并将其与环境中的表达式粘合在一起。

I now have different kinds of expressions floating around in my system. I need to also change force it to remember. Force it was something that would take in an object and, in the previous version, actually force the evaluation of the object if it was delayed, and if it wasn't, simply returned that value.

现在我的系统中有不同类型的表达式在浮动。我还需要修改 force it 以记住。Force it 是一个接受对象并，在之前的版本中，如果对象被延迟则强制求值，如果不是则直接返回该值的函数。

Here, I've now got a set of things I want to deal with first. If the object passed in has been labeled as a thunk, a delayed promise, I get out the expression part of the object, the environment part of the object, and do the work to get the actual value, forcing it.

这里，我有一组需要首先处理的东西。如果传入的对象被标记为 thunk，即延迟承诺，我取出对象的表达式部分、环境部分，并进行工作以获取实际值，强制求值。

The work to get the actual value, forcing the evaluation of this expression, and I'll return that value as the value of this object. But notice, I don't remember it. I'm going to have to redo the work again if I have another place that wants to use this thunk. That's the behavior I said I want it.

获取实际值的工作，即强制求值该表达式，我将返回该值作为该对象的值。但请注意，我不记住它。如果另一个地方想要使用这个 thunk，我将不得不重新做这项工作。这就是我所说的行为。

On the other hand, if this is a memoized thunk, it's got that label on it. I will again get out the expression and environment, do the work to get the actual value, and then having gotten that value, I will mutate this structure to label it as an evaluated thunk with the value.

另一方面，如果这是一个记忆化的 thunk，它带有那个标签。我将再次取出表达式和环境，进行工作以获取实际值，然后获得该值后，我将修改此结构，将其标记为已求值的 thunk 并带有该值。

label it as an evaluated thunk with the right result and remember I'm mutating in place so that anything that points to this object that has a pointer to this actual structure will still have a pointer to this structure we've simply replaced a promise to do something with the actual value and a label that specifies that if something has already been evaluated I just get the value out and return it that's all I want and everything else I just returned straightforwardly and with that infrastructure in place I can now go off and make the key change in apply or in

将其标记为已求值的 thunk 并带有正确的结果，记住我是在原地修改，因此任何指向此对象的指针（指向此实际结构的指针）仍将指向此结构，我们只是用实际值和一个标签替换了做某事的承诺，该标签指定如果某些东西已经被求值，我只需取出值并返回它。这就是我想要的，其他一切我都直接返回。有了这些基础设施，我现在可以继续在 apply 中进行关键更改。

And make the key change in apply or in lazy apply under this version. Now I want to simply keep track of what I wanted to delay. I'm only going to delay parameters that are specified being lazy or lazy memo. In case of a lazy parameter, I'll make a fun out of it. In the case of a lazy memo parameter, I'll make a memoized thunk out of it, and that we see will happen by simply our new implementation of delay.

并在 apply 或惰性 apply 的这个版本中进行关键更改。现在我想简单地跟踪我想要延迟的内容。我只延迟那些被指定为惰性或惰性记忆的参数。对于惰性参数，我将从中创建一个 fun。对于惰性记忆参数，我将从中创建一个记忆化 thunk，这我们将看到通过我们新的 delay 实现即可实现。

What else do I need to do? Well, basically, when I go to apply a compound procedure, I need to do the following. When I apply a compound procedure, I once more want to evaluate...

我还需要做什么？基本上，当我应用复合过程时，我需要做以下事情。当我应用复合过程时，我再次想要求值……

Procedure I once more want to evaluate. Procedure I once more want to evaluate the body of that procedure with respect to a new environment in that environment. I'm going to get by a course extending the procedures environment with a new frame but in that frame notice what I'll do first.

过程，我再次想要求值该过程的主体，相对于一个新环境。在该环境中，我将通过扩展过程的环境并添加一个新框架来获得，但注意在该框架中我将首先做什么。

I'll get out the parameters that correspond to the procedure just pulling out the list structure but now I know that that list isn't just a list of names it may be a list of names and declarations. So to extend the environment I need to get just the names themselves which I do by mapping.

我将取出对应于该过程的参数，只是拉出列表结构，但现在我知道该列表不仅仅是名称列表，它可能是名称和声明的列表。因此，为了扩展环境，我需要仅获取名称本身，我通过映射来实现。

themselves which I do by mapping parameter name down that list pulling out the names and then from the parameters I go ahead and create the set of list of delayed arguments by taking those declarations together with the arguments passed in and using delay it to walk down the list and decide do I evaluate now do I create a thunk or do I create a memorize them there's the change we need and now I can use all the infrastructure I've put together to create that actual list of delayed arguments I simply take the declarations the list of variables in their

通过将参数名映射到该列表上，拉出名称，然后从参数中，我通过将这些声明与传入的参数一起使用 delay it 来创建延迟参数列表，以决定我是立即求值、创建 thunk 还是创建记忆化 thunk。这就是我们需要的更改，现在我可以使用我构建的所有基础设施来创建实际的延迟参数列表，我只需取声明、变量列表及其……

arguments I simply take the declarations the list of variables in their

参数，我只需取声明、变量列表及其……

the list of variables in their declarations plus the list of expressions the arguments passed in and walk down those two lists in unison delaying each one and remember what delay it will do it will look at the declaration to decide is this something I want to get a value of right now in which case I'll do it is it something I want to turn into a thunk or a memo eyes thunk in which case I'll do the appropriate delay and doing this now allows us to control when we evaluate do we evaluate on application to evaluate when required or do we evaluate and

变量列表及其声明，加上表达式列表（传入的参数），并同步遍历这两个列表，逐个延迟每个参数。记住 delay it 将查看声明以决定这是否是我想要立即获取值的东西，如果是，我将执行；是否是我想要变成 thunk 或记忆化 thunk 的东西，如果是，我将执行适当的延迟。这样做现在允许我们控制何时求值：我们是在应用时求值，还是在需要时求值，还是求值并……

when required or do we evaluate and remember and simply look up when asked for it? So what does this do for us? Well, now we've built in some programmer control by changing how we deal with the arguments when we get to an application. By deciding at that time, do I evaluate, do I delay, do I delay but keep track of... we've now enabled the programmer to specify what he or she wants when they create a lambda. They have the opportunity to say, I want the values of this parameter at application time, or I want the value of this parameter delayed.

在需要时求值，还是求值并记住，然后在被要求时简单查找？那么这为我们带来了什么？现在，我们通过改变在应用时处理参数的方式，内置了一些程序员控制。通过在那时决定：我是求值、延迟，还是延迟但跟踪……我们现在使程序员能够在创建 lambda 时指定他或她想要什么。他们有机会说，我想要此参数在应用时的值，或者我想要此参数的值被延迟。

this parameters on application time or I want the value of this parameter delayed

此参数在应用时的值，或者我想要此参数的值被延迟。

want the value of this parameter delayed until I need it but keep doing it every time I need as I may be relying on side-effects or other things inside of that evaluation or I wanted the latest until I absolutely need it but once I've got it just keep track of it so I don't redo that work we've built in now programmer control the key thing to see is how given this idea of lazy evaluation we're able to easily change the performance or the behavior of our system a little syntactical change in terms of how we specify parameters and a little change

希望这个参数的值被延迟到我需要它的时候，但每次需要时都重新计算，因为我可能依赖该求值中的副作用或其他内容；或者我希望它尽可能晚地获取最新值，但一旦获取就记住它，以免重复工作。我们现在已经内置了程序员控制。关键是要看到，基于这种惰性求值的理念，我们能够轻松改变系统的性能或行为：只需在参数指定方式上做一点语法改动，以及在求值操作本身做一点改动。

### 7. From lazy evaluation to streams and infinite data structures (从惰性求值到流与无限数据结构)

specify parameters and a little change in the manipulation of the evaluation itself gave us a very different performance. So as we've seen, then we now have the ability to really change the way an evaluator behaves. We can control the order in which things are evaluated, going from an applicative order to a normal order or to things in between.

指定参数的方式和求值操作本身的微小改动，带来了截然不同的性能。因此，正如我们所看到的，我们现在有能力真正改变求值器的行为方式。我们可以控制求值的顺序，从应用序到正则序，或介于两者之间的各种方式。

We've also seen that those changes involve only details of the evaluator, and in many cases very small details, and they allow us to have models of one kind, models of another kind, or models of evaluation in between that let us

我们还看到，这些改变只涉及求值器的细节，而且在许多情况下是非常小的细节，它们使我们能够拥有一种模型、另一种模型，或介于两者之间的求值模型，从而让我们

evaluation in between that let us control as a programmer how we want the evaluation to actually take place now let's look at one example in which changing the evaluation model allows us to explore a very different kind of computational problem our goal is to show how a small change in the evaluator basically our lazy evaluator can let us have a very different way of thinking about programs in programming imagine that I want to simulate the motion of an object in a complex environment simple case might be a tennis ball that I throw against a set

介于两者之间的求值模型，让我们作为程序员能够控制实际求值如何进行。现在让我们看一个例子，其中改变求值模型使我们能够探索一种非常不同的计算问题。我们的目标是展示，对求值器的一个小改动——基本上是我们的惰性求值器——如何让我们以非常不同的方式思考程序和编程。想象一下，我想模拟一个物体在复杂环境中的运动。一个简单的例子可能是我将一个网球扔向一组墙壁。

Tennis ball that I throw against a set of walls. I would like to simulate how the ball would bounce against those obstacles and where it might end up.

我将网球扔向一组墙壁。我想模拟球如何在这些障碍物上反弹以及它可能最终落在哪里。

In our earlier approach, we might have chosen to model this using an object-oriented system, which seems like a natural way of breaking this problem up into pieces. Under that view, we would have a different object to represent each different structure in our world.

在我们早期的方法中，我们可能选择使用面向对象系统来建模，这似乎是自然地将这个问题分解成多个部分的方式。在这种观点下，我们会为世界中的每个不同结构设置一个不同的对象。

We might have an object that represented the ball with some internal state that captured the properties of the ball. Similarly, each wall would be an object.

我们可能有一个对象代表球，具有一些内部状态来捕获球的属性。类似地，每面墙都是一个对象。

similarly each wall would be an object perhaps with different characteristics representing how objects bounce off them and we might have a clock to synchronize interactions between the objects leading to an object centered system very similar to what we saw earlier in this way each synchronization step would cause the objects to update their state including detecting when for example two objects have collided so that the physics captured in each object would then govern changes in the state the thing to notice is that while this is a

类似地，每面墙都是一个对象，可能具有不同的特性来表示物体如何从它们反弹，并且我们可能有一个时钟来同步对象之间的交互，形成一个以对象为中心的系统，与我们之前看到的非常相似。这样，每个同步步骤都会导致对象更新其状态，包括检测例如两个对象何时碰撞，以便每个对象中捕获的物理规律支配状态的变化。需要注意的是，虽然这是一种

thing to notice is that while this is a

需要注意的是，虽然这是一种

thing to notice is that while this is a natural way of breaking up the system into two units, the state of the simulation is basically captured in an instantaneous wait. At any point in time, we can determine the state of the overall system by the values of the state variables of each object.

需要注意的是，虽然这是一种将系统分解为两个单元的自然方式，但模拟的状态基本上是在一个瞬时时刻捕获的。在任何时间点，我们都可以通过每个对象的状态变量的值来确定整个系统的状态。

But we don't have a lot of information about how the system has been evolving. Set a different way, by breaking up the system into units of this form, we are naturally focusing on the discrete objects within the system, not on the behavior of there is a very different way of thinking about.

但我们没有太多关于系统如何演变的信息。换一种方式说，通过将系统分解为这种形式的单元，我们自然关注的是系统内的离散对象，而不是它们的行为。有一种非常不同的思考方式。

非常不同的思考方式来看待这类系统，然而并非拥有显式捕获状态的架构，我可以考虑这样的系统，其中状态实际上仅以非常隐含的方式存在。

有一种非常不同的思考方式来看待这类系统，然而并非拥有显式捕获状态的架构，我可以考虑这样的系统，其中状态实际上仅以非常隐含的方式存在。

在我抛网球撞向一组墙壁的例子中，想象一下，当我进行这个操作时，我实际上在房间周围放置了一组摄像机，记录球的运动，因此捕获了关于球位置状态的信息，特别是想象这种情况发生在某个环境中。

在我抛网球撞向一组墙壁的例子中，想象一下，当我进行这个操作时，我实际上在房间周围放置了一组摄像机，记录球的运动，因此捕获了关于球位置状态的信息，特别是想象这种情况发生在某个环境中。

Imagine that this is happening in a continuous fashion. There is a constant stream of information being spewed out that represents the X&Y position for example of the ball as it moves around the room. Under this view, my basic units now become the time series of values of the different variables that represent my system.

想象这是以连续方式发生的。有一串持续的信息流被输出，代表球在房间内移动时的X和Y位置。在这种观点下，我的基本单元变成了代表我的系统的不同变量的时间序列值。

In the earlier version, my basic units were the objects themselves—the ball, the wall, the clock, anything else. Now I've changed my viewpoint. I pulled out the state variables and said my basic units are the stream or history of values associated with them.

在早期版本中，我的基本单元是对象本身——球、墙、时钟，或其他任何东西。现在我改变了我的观点。我提取出状态变量，并说我的基本单元是与它们关联的值的流或历史。

of values associated with them to capture the state of the system at any point, I simply take the values of all of those variables across the same point in time. But my units now that I want to think about are the actual history of values, the stream of values associated with each thing that represents my system.

为了在任何点捕获系统的状态，我只需取所有这些变量在同一时间点的值。但我现在想要思考的单元是实际的值历史，即与代表我的系统的每个事物相关联的值的流。

A key question then becomes how can I efficiently capture this information, and an obvious thing to do is say well this represented as a list, just keep gluing new values that represent the state of these variables onto the beginning of a list as I go.

那么一个关键问题是如何高效地捕获这些信息。一个明显的做法是说这可以表示为一个列表，只需在模拟过程中不断将代表这些变量状态的新值粘到列表的开头。

onto the beginning of a list as I go through my simulation and while that's an appropriate way of thinking about it we'll see that once we start getting into complex systems it becomes very difficult to do this efficiently we'd like to have a way of capturing that information without having to do excess computation.

在模拟过程中将它们粘到列表的开头，虽然这是一种合适的思考方式，但我们会发现，一旦开始处理复杂系统，要高效地做到这一点就变得非常困难。我们希望有一种方法来捕获这些信息，而不必进行过多的计算。

and for that we're going to turn back to what we did in the last lecture now we just saw how to convert our standard or applicative order evaluator into a normal order or lazy evaluator I want to take that idea and

为此，我们将回到上一讲所做的内容。现在我们刚刚看到了如何将标准或应用序求值器转换为正则序或惰性求值器。我想利用这个想法，

you to change the way we think about programming by showing how changing our viewpoint on evaluation coupled with this idea of capturing objects by their streams of values gives us a different way of programming.

通过展示改变我们对求值的观点，结合用值的流来捕获对象的想法，如何给我们一种不同的编程方式，从而改变我们对编程的思考方式。

the key ideas we're going to use are the notion of deferring evaluation of sub expressions until only when needed and the idea of avoiding re-evaluation of the same sub expression by memorizing.

我们将使用的关键思想是：将子表达式的求值推迟到真正需要时才进行的观念，以及通过记忆化避免对同一子表达式重复求值的观念。

so we created an evaluator in which the programmer could declare when building a procedure how to treat the different parameters in this little

因此，我们创建了一个求值器，程序员可以在构建过程时声明如何处理不同的参数。

The different parameters in this little example, A and C, are normal variables, meaning they will be evaluated, or their arguments will be evaluated, before we actually apply this procedure. B, we treat as lazy, which says we don't evaluate the argument expression passed in when the application is done until it's actually required somewhere inside of the body.

在这个小例子中，不同的参数 A 和 C 是普通变量，意味着它们会在实际应用该过程之前被求值，或者说它们的参数会被求值。而 B 我们将其视为惰性的，这意味着在应用完成时，我们不会对传入的参数表达式进行求值，直到在过程体内部确实需要它时才求值。

When a primitive procedure is applied in that case, it is evaluated and the value is used, but it's thrown away once we're done. Any other time that this parameter is used, we'll reevaluate it.

当在这种情况下应用一个基本过程时，它会被求值并使用其值，但一旦完成就被丢弃。任何其他时候使用这个参数，我们都会重新求值。

parameter is used we'll reevaluate the sub expression to get its value out and finally D we could mark as being lazy but memorized that means we don't evaluate until required in the body of this procedure when a primitive procedure is applied to it when we do actually do the evaluation however we keep that value around remembering it for subsequent uses of this actual variable somewhere else within this procedure.

当使用该参数时，我们会重新求值子表达式以获取其值。最后，D 我们可以标记为惰性但带记忆的，这意味着我们不会立即求值，直到在过程体中需要它时才求值；当我们确实进行求值时，我们会保留该值，记住它以便在此过程的其他地方后续使用这个实际变量。

so how could we use this idea in our context well we could create a new data abstraction called a stream here's of one particular version of it

那么我们如何在我们自己的语境中使用这个想法呢？我们可以创建一个新的数据抽象，称为流。这里是它的一个特定版本。

Here's one particular version of it. It has a constructor will call con stream and it has two selectors dream car and stream coder. You can see by the names that they're going to behave a lot like what a list would accept for the following. And the following is that the second part of a con stream is lazy, a rather lazy memoed meaning I am not going to get the value of the second part of this structure until I'm asked to. But having been asked to I'm going to store the value away. Here we've chosen to represent it as a message passing.

这里是它的一个特定版本。它有一个构造函数，我们称之为 cons-stream，它有两个选择器 stream-car 和 stream-cdr。从名字可以看出，它们的行为很像列表所接受的那样。其规则如下：cons-stream 的第二部分是惰性的，更确切地说是惰性且带记忆的，这意味着我不会去获取这个结构的第二部分的值，直到我被要求这样做。但一旦被要求，我就会存储这个值。在这里我们选择用消息传递来表示它。

To represent it as a message passing system, you could imagine we could also just do this using cons directly. The key change though is that now I have a way of constructing together, or gluing together, a sequence of values in which only the first value is explicitly evaluated when I do the construction. The second part of this structure is lazy, it's a promise. I get the value when asked for it, but I don't do the work of actually computing it now.

为了用消息传递系统来表示它，你可以想象我们也可以直接用 cons 来做。但关键的变化是，现在我有了一个方法，可以将一系列值构造或粘合在一起，其中只有第一个值在构造时被显式求值。这个结构的第二部分是惰性的，它是一个承诺。当我被要求时我会得到值，但我现在不会实际计算它。

What does this do in terms of thinking about building long sequences of structures? A stream object thus looks

这在思考构建长序列结构方面意味着什么？一个流对象因此看起来

of structures a stream object thus looks

结构，一个流对象因此看起来

of structures a stream object thus looks a lot like a pair except that the cutter part is lazy it's not evaluated until actually needed and when it is we'll keep track of that value so we don't have to redo the work think about what happens now for example if I ask X to have the value of a constraint of 99 and divided by 1 0 what will happen well if I did this just using a normal constant I know what will happen I'll get an error because cons would say evaluate is two arguments getting the value 99 but then trying to divide by 0 and ending up with an error in the case of con stream

结构，一个流对象因此看起来很像一个序对，只不过 cdr 部分是惰性的，它直到真正需要时才被求值，并且当我们求值时，我们会跟踪该值，这样我们就不必重新做这项工作。想想现在会发生什么，例如，如果我让 X 具有 cons-stream 99 和除以 1 0 的值，会发生什么？好吧，如果我仅仅使用普通的 cons 来做，我知道会发生什么：我会得到一个错误，因为 cons 会对其两个参数求值，得到值 99，但随后尝试除以 0，最终导致错误。而在 cons-stream 的情况下，

with an error in the case of con stream. I can do this safely because con stream will evaluate its first argument the 99, but will simply create a promise to evaluate the second argument and glue the two things together. As a consequence, X is safely defined and I can get out the car of it as a stream, returning the value 99.

在 cons-stream 的情况下，我可以安全地这样做，因为 cons-stream 会求值它的第一个参数 99，但只会创建一个承诺来求值第二个参数，并将两者粘合在一起。因此，X 被安全地定义，我可以取出它的 car 作为一个流，返回值 99。

It's only when I go to actually get the cooter that I will do the evaluation and end up with the error. So what we see is there's now a nice difference between a stream object as a pair and the standard pair, in that the

只有当我真正去获取 cdr 时，我才会进行求值并最终得到错误。所以我们看到，流对象作为序对与标准序对之间现在有一个很好的区别，即流的第二部分直到需要时才被求值。我们现在要做的是在这个想法的基础上，看看我们如何能创建非常不同的结构以及不同的计算思维方式。

pair and the standard pair in that the second part of the stream is not evaluated until required. What we're going to do now is build on that idea to see how we can create very different structures and different ways of thinking about how we do computation.

序对与标准序对之间的区别在于，流的第二部分直到需要时才被求值。我们现在要做的是在这个想法的基础上，看看我们如何能创建非常不同的结构以及不同的计算思维方式。

This may seem like a very straightforward change. What I've done in essence is say, given my standard way of gluing things together, conscious, let's make an alternative in which I glue together the value of the first thing, put the promise to get the value of the second. It doesn't sound like a lot, but...

这看起来可能是一个非常直接的改变。本质上我所做的是说，鉴于我标准的粘合方式 cons，让我们做一个替代方案，在其中我粘合第一个事物的值，并放入获取第二个值的承诺。听起来没什么大不了的，但是……

secondly it doesn't sound like a lot but in fact it has a very fundamental impact on how I can think about computation in particular I can now decouple the actual computation of values from the description of those values or set a different way I can separate out the order of events that occur inside of the computer from the apparent order of events that are held in the procedure description and let's look at an example of that suppose I want to find the hundredth prime value well here's a standard way in which I could do that using list processing the ways I've

听起来没什么大不了的，但实际上它对我如何思考计算有着非常根本的影响。特别是，我现在可以将值的实际计算与这些值的描述解耦，或者换一种说法，我可以将计算机内部发生的事件顺序与过程描述中呈现的表观事件顺序分离开来。让我们看一个例子：假设我想找到第一百个素数。好吧，这是我可以使用列表处理的标准方式，就像我们之前做的那样。

使用列表处理的方式，像我们之前做的那样，我可以使用 numerate interval（我们之前看到过几次）来生成一个从一到一亿（或任意范围）的所有整数列表。然后，我可以使用一个检查素数的函数来过滤那个列表——课本里有一个版本，我并不真正关心它具体做什么，我只是想思考过滤掉非素数的这个想法。之后，我可以进入列表，找到第几百个元素。

使用列表处理的方式，像我们之前做的那样，我可以使用 enumerate-interval（我们之前看到过几次）来生成一个从一到一亿（或任意范围）的所有整数列表。然后，我可以使用一个检查素数的函数来过滤那个列表——课本里有一个版本，我并不真正关心它具体做什么，我只是想思考过滤掉非素数的这个想法。之后，我可以进入列表，找到第几百个元素。

done here I first had to generate a very

在这里，我首先必须生成一个非常

done here I first had to generate a very large list from 1 to 100 million because I'm not certain exactly what values I'm going to need. The key point is I've done a lot of computation and I've created a very large data structure.

在这里，我首先必须生成一个非常大的列表，从 1 到 1 亿，因为我不确定我到底需要哪些值。关键是我做了大量的计算，并且创建了一个非常大的数据结构。

### 8. Streams and lazy evaluation for efficient prime computation (流与惰性求值在高效素数计算中的应用)

Filter will then run down that list and generate a new list, not quite as long but still very long, in which it checks each element in turn, throwing away the ones that what doesn't want and keeping only what's valuable.

然后 Filter 将沿着该列表运行，生成一个新列表，虽然不那么长但仍然很长，它依次检查每个元素，丢弃不需要的，只保留有价值的。

And finally, list.rev will simply walk down that list, find the hundred element, keep it, and throw everything else away. In this way of doing things...

最后，list-ref 将简单地沿着列表走下去，找到第一百个元素，保留它，然后丢弃其他所有东西。在这种做事方式中……

everything else away in this way of viewing things I have to do all of the computation to get the value of an expression before I can move on to the next stage and it literally says I have to do an entire generation of a data structure then pass it to another procedure which does an entire generation of another data structure and then passes that on clearly in this case it's wasteful because I don't need those entire lists suppose instead I change my viewpoint and I say rather than creating an entire list of all of the integers

丢弃其他所有东西。在这种看待事物的方式中，我必须完成所有计算才能得到表达式的值，然后才能进入下一阶段；它字面上要求我必须完整生成一个数据结构，然后将其传递给另一个过程，该过程又完整生成另一个数据结构，然后再传递下去。显然在这种情况下这是浪费的，因为我并不需要那些完整的列表。相反，假设我改变我的观点，我说，与其创建所有整数的完整列表，不如……

An entire list of all of the integers, before I can do any filtering I'm going to create a structure that has the first integer I want and a promise to generate the rest of the integers when you ask for it. That says rather than creating enumerate interval as a big long list, I'm going to use streams.

在能够进行任何筛选之前，我需要创建一个结构，它包含我想要的第一个整数，以及一个在需要时生成其余整数的承诺，而不是先构造一个包含所有整数的完整列表。也就是说，我不会把 enumerate interval 创建成一个很长的列表，而是使用流。

Streams will say because of that lazy memoization that when I asked for the intervals of the stream from A to B, I will generate a structure that gives me the value a is the first part, a constraint, and they promise to generate the rest of the integral when required.

流会说明，由于这种惰性记忆化，当我请求从 A 到 B 的区间流时，我会生成一个结构，其中值 a 作为第一部分，一个约束，以及一个在需要时生成其余整数的承诺。

The rest of the integral when required I can certainly imagine creating a stream filter that behaves just like filter did on lists but uses cost stream and stream car and stream could a rather than cons car encoder and now notice what would happen in this case when I evaluate the bottom expression stream interval will generate a structure with the value 1 and a promise to generate the stream interval to to 100 million that can instantly be passed to stream filter which will now check the first element since ones not prime it will throw it away and ask for

在需要时生成其余整数，我完全可以想象创建一个流过滤器，它的行为就像列表上的过滤器一样，但使用 cost stream、stream car 和 stream could a，而不是 cons car encoder。现在注意，在这种情况下，当我计算底部的表达式时，stream interval 将生成一个结构，其中包含值 1 和一个生成 stream interval 2 到 1 亿的承诺，这个结构可以立即传递给 stream filter，后者将检查第一个元素，因为 1 不是素数，它会将其丢弃，并请求下一个元素。

prime it will throw it away and ask for the next element in the stream stream the next element in the stream stream the next element in the stream stream filtering member is going to walk down the stream this will now go back to stream interval and say please generate the rest of your stream which will cause a con stream to generate the value too

素数，它会将其丢弃，并请求流中的下一个元素。流中的下一个元素，流中的下一个元素，流过滤成员将沿着流向下走，这将回到 stream interval 并说：请生成你流的其余部分，这将导致 con stream 生成值 2。

and they promise to generate the rest of the stream and as a consequence these two procedures will work in synchrony stream interval generating the next element of the stream passing the entire structure to stream filter which we'll keep looking at them and we'll pass out

以及一个生成流其余部分的承诺，因此这两个过程将同步工作：stream interval 生成流的下一个元素，将整个结构传递给 stream filter，后者将继续检查它们，并将值传递出去。

keep looking at them and we'll pass out values as they come along to stream wrap. As a consequence, we will only generate as much of this stream of values as we need until we return out the hundredth prime.

继续检查它们，并在值出现时将其传递给 stream wrap。因此，我们只会生成所需数量的流值，直到我们返回第一百个素数。

Notice what this has allowed us to do. We can now think about the processing as if the entire set of values was available. We're thinking about how to deal with streams as if all of those values were actually there, but in fact, when we go to do the computation, the laziness allows us to in fact separate out the order of events inside of the computer from this apparent order of

注意这让我们能够做什么。我们现在可以像整个值集可用那样来思考处理过程。我们考虑如何处理流，就好像所有这些值确实存在一样，但实际上，当我们进行计算时，惰性使我们能够将计算机内部的事件顺序与这种表面上的顺序分离开来。

computer from this apparent order of events in the description so that we get the efficiency of only computing what we need while allowing us to think about things as if the entire structure the entire sequence of values was available.

计算机内部的事件顺序与描述中的表面事件顺序分离开来，这样我们就能获得只计算所需内容的效率，同时允许我们像整个结构、整个值序列可用那样来思考问题。

if we go back to our little motivating example at the beginning it says we can think about building simulations in which we think about the entire stream of position values as if they were available but we don't have to do all of that computation in order to actually run the simulation to see how this lazy

如果我们回到开头那个小小的激励性例子，它说我们可以考虑构建模拟，在模拟中我们思考整个位置值流，就好像它们可用一样，但为了实际运行模拟，我们不必进行所有计算，以了解这种惰性求值如何给我们带来这种行为。

run the simulation to see how this lazy evaluation gives us this kind of behavior. Let's look at this in a little more detail. So first, here's one of our procedures, a standard stream procedure that we write. This looks just like our filter that we wrote for lists. The only difference is we're using the stream data abstraction, so we're using stream-car and stream-cdr to get out the pieces, and we're using cons-stream to generate up the structure that we want to get.

运行模拟以了解这种惰性求值如何给我们带来这种行为。让我们更详细地看一下。首先，这是我们编写的一个标准流过程。这看起来就像我们为列表编写的过滤器。唯一的区别是我们使用了流数据抽象，所以我们使用 stream-car 和 stream-cdr 来获取各个部分，并使用 cons-stream 来生成我们想要的结构。

Let's see though how the lazy evaluation in cons-stream allows us to separate out the order of evaluation.

然而，让我们看看 cons-stream 中的惰性求值如何让我们分离求值顺序。

separate out the order of evaluation within the machine from the apparent order of evaluation as described by the actual procedure.

将机器内部的求值顺序与实际过程所描述的表面求值顺序分离开来。

indeed the standard question might be why doesn't stream filter end up generating all of the elements of the stream at once the answer is here when we apply this procedure to a stream it will recursively test each element in the stream until it finds one that satisfies the predicate at that stage note what happens we generate a stream with that element as the first element and with a lazy or delayed promise to

确实，标准问题可能是为什么 stream filter 最终不会一次生成流的所有元素。答案在这里：当我们把这个过程应用于一个流时，它会递归地测试流中的每个元素，直到找到一个满足谓词的元素。在那个阶段，注意会发生什么：我们生成一个流，以该元素作为第一个元素，并带有一个惰性或延迟的承诺，即

and with a lazy or delayed promise to filter the rest of the stream when needed, thus we generate the first element of the new stream and just a promise, not the intent. So let's look at what happens with our little example.

在需要时过滤流的其余部分，因此我们生成了新流的第一个元素，并且只是一个承诺，而不是意图。所以让我们看看我们的这个小例子会发生什么。

We're going to filter the stream of integers from 1 to 100 million using prime, and let's see what would happen if we actually do this, looking carefully at how lazy evaluation controls the order of evaluation. Well, stream filter is just a standard procedure, so we need to get the values of its arguments; prime will discrete is some procedure, but stream...

我们将使用 prime 过滤从 1 到 1 亿的整数流，让我们看看如果我们实际这样做会发生什么，仔细观察惰性求值如何控制求值顺序。好吧，stream filter 只是一个标准过程，所以我们需要获取其参数的值；prime 将是某个过程，但 stream...

Discrete is some procedure but stream interval we need to evaluate notice. However, stream interval, as you recall, was defined in terms of con stream, so it literally returns one of these stream objects. This object has the value of the first element one already available, plus a promise shown in that squiggly line—a promise to get the value of the next argument, which is stream interval from 2 to 100 million.

Discrete 是某个过程，但 stream interval 我们需要评估注意。然而，stream interval，正如你回忆的那样，是用 con stream 定义的，所以它字面上返回这些流对象之一。这个对象已经有第一个元素 1 的值可用，加上一个承诺（用波浪线表示）——一个获取下一个参数值的承诺，即 stream interval 从 2 到 1 亿。

Now notice, at this stage, all that has been explicitly computed is the first value; everything else is sitting around as a promise.

现在注意，在这个阶段，所有被显式计算的只是第一个值；其他一切都作为承诺存在。

sitting around as a promise having evaluated the two arguments evaluated the two arguments evaluated the two arguments appropriately we can now execute stream filter and notice what it does it replies its predicate to the first element of the stream stream car one is not prime so in this case stream filter says the value to be returned is they call a recursively de stream filter with the same predicate but on the coder of the thing that was passed in so now we're going to force that promise that stream interval from 2 to 100 million is going to be asked to do its thing now here's where a potential confusion can

作为承诺存在。在适当地评估了两个参数之后，我们现在可以执行 stream filter，注意它做了什么：它将谓词应用于流的第一个元素。stream car 1 不是素数，所以在这种情况下，stream filter 说要返回的值是它递归调用 stream filter，使用相同的谓词，但应用于传入对象的 coder。所以现在我们将强制那个承诺，即 stream interval 从 2 到 1 亿将被要求做它的事情。现在这里可能产生一个困惑。

going to be asked to do its thing now here's where a potential confusion can

将被要求做它的事情。现在这里可能产生一个困惑。

这里可能产生一个困惑。你可能会觉得，当调用 stream interval 获取该片段的 stream coder 时，它应该立刻运行并生成整个流中的所有内容，即从 2 到 1 亿的列表元素。

这里可能产生一个困惑。你可能会觉得，当调用 stream interval 获取该片段的 stream coder 时，它应该立刻运行并生成整个流中的所有内容，即从 2 到 1 亿的列表元素。

但事实上，我们知道 stream interval 的作用是：它说将第一个元素 cons 到一个 promise 上，以完成其余部分。因此，它实际上返回另一个流对象，其中下一个元素现在可用，并附带一个 promise 来处理后续内容。

但事实上，我们知道 stream interval 的作用是：它说将第一个元素 cons 到一个 promise 上，以完成其余部分。因此，它实际上返回另一个流对象，其中下一个元素现在可用，并附带一个 promise 来处理后续内容。

to do the further things and that is

去做进一步的事情，那就是

To do the further things and that is what will be then used as part of stream filter. So now stream filter can evaluate its body or apply its procedure if you like to its body testing with the predicate to see is the first element of this stream of prime it is so it returns a con stream of aha the first element which is the two plus a promise and the promise is to do a stream cutter on the remaining or rather a stream filter on the remaining things.

去做进一步的事情，而这将随后被用作 stream filter 的一部分。所以现在 stream filter 可以求值其函数体，或者如果你愿意，将其过程应用于其函数体，用谓词测试以查看该素数流的第一个元素是否为素数；如果是，它返回一个 cons 流，包含第一个元素（即 2）加上一个 promise，该 promise 是对剩余部分进行 stream cutter，或者更确切地说，是对剩余部分进行 stream filter。

So notice what this stream filter is it's a promise that says when you ask me I will try and filter using prime on a

所以注意这个 stream filter 是什么：它是一个 promise，说当你问我时，我将尝试使用 prime 过滤

I will try and filter using prime on a stream cutter of the object I started with so we now have to delay promises we have a promise to do the filter and inside of it is a promise to go off and get the rest of the stream this now lets us see that we will in essence only pull out values as needed from this stream filter

我将尝试使用 prime 过滤我最初对象的 stream cutter，所以我们现在有两个延迟的 promise：一个 promise 去做过滤，其中内部还有一个 promise 去获取流的其余部分。这让我们看到，我们实际上只会按需从这个 stream filter 中拉取值。

if we were to ask what's the next element in this sequence we'd go past the two and it forced the evaluation of stream filter which would force the evaluation of the stream quitter and pull out the next prime nonetheless we'll only in essence tug on

如果我们问这个序列的下一个元素是什么，我们会经过 2，并强制求值 stream filter，这将强制求值 stream quitter 并拉出下一个素数。尽管如此，我们实际上只会

nonetheless we'll only in essence tug on this stream to get the next element when requested but by building our procedures both our filters and our Constructors using Kahn stream we actually separate out the order of evaluation from the apparent order of evaluation. Now we see that if we create procedures that manipulate this stream object this new data structure we have we never have to worry about how long the data structure is we only get the next element in order as we asked for it and this raises an interesting question if we don't really

尽管如此，我们实际上只会按需拉取这个流的下一个元素。但是通过使用 Kahn stream 构建我们的过程（无论是过滤器还是构造器），我们实际上将求值顺序与表面上的求值顺序分离开来。现在我们看到，如果我们创建操作这个流对象（这个新数据结构）的过程，我们永远不必担心数据结构有多长；我们只在需要时按顺序获取下一个元素。这引发了一个有趣的问题：如果我们并不真正

Interesting question: if we don't really care about how long the rest of the structure is, how long can we actually make it? The answer is well, infinitely long—or that's a slight misspeaking—let's just say indefinitely long. But we can now, in fact, create data structures that have arbitrary length and act as if they had infinite length.

有趣的问题：如果我们并不真正关心结构的其余部分有多长，我们实际上能把它做成多长？答案是，嗯，无限长——或者说这有点口误——让我们说无限长。但现在我们实际上可以创建具有任意长度的数据结构，并表现得好像它们具有无限长度。

This leads to some really interesting behavior in terms of how we think about processing. So let's look at an example: let's give the name 'ones' to the structure we get by Kahn streaming the integer one on two.

这在我们思考处理过程的方式上导致了一些非常有趣的行为。让我们看一个例子：让我们将名称 'ones' 赋予通过 Kahn streaming 整数 1 到

Kahn streaming the integer one on two ones itself okay that's going to make a weird-looking little structure in particular if we ask for say the second element in this stream we get out of one huh why is this happening well defining it this way says the name ones refers to or points to a structure created by Kahn streaming the integer 1 onto a promise to get the value of the name ones when asked for it and that says when we ask for the stream critter this object we will at that point evaluate once and it will go back around and point to this same structure and as

Kahn streaming 整数 1 到 ones 本身，好吧，这将产生一个看起来奇怪的小结构。特别是，如果我们要求这个流的第二个元素，我们会得到 1。嗯，为什么会这样？这样定义它意味着名称 ones 引用或指向一个由 Kahn streaming 整数 1 到一个 promise 所创建的结构，该 promise 在需要时获取名称 ones 的值。这表示当我们要求这个对象的 stream critter 时，我们将在那时求值 ones，它将循环回去并指向这个相同的结构，并且

and point to this same structure and as a consequence this structure basically represents a very funny thing it represents an infinite stream of ones no matter how many times I ask for the next element of this list I will always get out of one so I now have a structure that I can think of as representing an infinite set of things whenever I ask for a particular element of that thing the hundredth element for example of this structure I will get out the thing I want namely a 1

并指向这个相同的结构，因此这个结构基本上代表了一个非常有趣的东西：它代表了一个无限的 1 流。无论我要求这个列表的下一个元素多少次，我总是会得到 1。所以我现在有了一个结构，我可以将其视为代表一个无限集合的事物；每当我要求该事物的特定元素时，例如这个结构的第 100 个元素，我将得到我想要的东西，即 1。

### 9. Building infinite streams and the sieve of Eratosthenes (构建无限流与埃拉托斯特尼筛法)

this may still seem odd so let's think about the comparison

这可能仍然看起来奇怪，所以让我们考虑一下比较。

odd so let's think about the comparison. Suppose I did define once to be a concept 1 and once of course in this case I get an error because remember cons requires the value of both its arguments before it can actually create the structure and I don't have a value for 1 yet so I can't in fact do it.

奇怪，所以让我们考虑一下比较。假设我确实定义了 ones 为 cons 1 和 ones，当然在这种情况下我会得到一个错误，因为记住 cons 要求其两个参数都有值才能实际创建结构，而我还没有 1 的值，所以我实际上无法做到。

Streams though with the lazy evaluation enables me to hold off getting the value of the second element until I've completed the structure which means that the name ones will be available to me when I need it. So now we see lazy evaluation gives me the ability to create one of these.

然而，流通过惰性求值使我能够推迟获取第二个元素的值，直到我完成结构，这意味着当我需要名称 ones 时，它将对我可用。所以现在我们看到惰性求值赋予我创建这种无限数据结构的能力。

the ability to create one of these infinite data structures so what does this bias well this way of thinking about infinite data structures in fact lets us think about creating procedures that operate as if the entire data structure were available to us on demand

创建这种无限数据结构的能力。那么这种思考无限数据结构的方式让我们能够考虑创建过程，这些过程表现得好像整个数据结构在我们需要时都可用。

so for example things that would typically apply to lists procedures that might handle finite lists we can now turn into procedures that handle infinite streams to add together two streams for instance we could have something that checks to see video streams empty in which case we just

例如，通常适用于列表的过程，可能处理有限列表的过程，我们现在可以将其转变为处理无限流的过程。例如，要将两个流相加，我们可以有某种检查流是否为空的过程，在这种情况下我们只需

streams empty in which case we just return the empty stream otherwise we'll use our data obstruction to constrain the sum of the first two elements onto whatever we get by adding the remaining streams together pair Watts the idea.

流为空，在这种情况下我们只需返回空流；否则，我们将使用我们的数据抽象来将前两个元素的和 cons 到我们将剩余流相加得到的结果上，成对地，就是这个想法。

would be take two infinite streams add each of their elements up together and create out a new infinite stream using this for example we can create the infinite data structure of all the integers we simply constrain the first integer which is 1 onto whatever we get by adding together the stream of ones to

将是取两个无限流，将它们的每个元素相加，并创建一个新的无限流。使用这个，例如，我们可以创建所有整数的无限数据结构：我们只需将第一个整数（即 1）cons 到我们将 1 的流与

by adding together the stream of ones to the stream of integers now let's check it out and make sure this does the right thing.

将 1 的流与整数的流相加得到的结果上。现在让我们检查一下，确保这做了正确的事情。

so what does intz or integers look like well we know the first element will be a 1 because we constrain that onto a promise to get the rest of the integers when we want them ok suppose we now ask for the second element of this stream well the second element was a promise a promise because of the construction of using lazy evaluation they promised to add together the streams of ones and the streams of integers so to get the second

那么 intz 或 integers 看起来像什么？我们知道第一个元素将是 1，因为我们将其 cons 到一个 promise 上，以在我们需要时获取整数的其余部分。好的，假设我们现在要求这个流的第二个元素。嗯，第二个元素是一个 promise，一个 promise，因为使用惰性求值的构造，它承诺将 1 的流和整数的流相加。所以为了得到第二个

streams of integers so to get the second element we now need to evaluate this element we now need to evaluate this element we now need to evaluate this notice though that at this point both ones is available we know that's just an infinite stream of ones but also the stream intz is available as the first element plus a promise and since that first element is available that allows us to go ahead and ask for it and add streams will therefore con stream the first element of ones and the first element of ents together and add those up generating that is the first element plus a promise to do add streams of the remainder of these two streams if we

整数流，因此要得到第二个元素，我们现在需要求值这个元素，我们现在需要求值这个元素，我们现在需要求值这个元素。但请注意，此时两个流都已可用：我们知道 ones 只是一个无限的 1 流，但 ints 流也可用，它由第一个元素加上一个承诺组成，既然第一个元素可用，我们就可以继续请求它，并将两个流相加。因此，add-streams 将把 ones 的第一个元素和 ints 的第一个元素连接起来并相加，生成第一个元素加上一个对这两个流的剩余部分进行 add-streams 的承诺。如果我们

plus a promise to do add streams of the remainder of these two streams if we

加上一个对这两个流的剩余部分进行 add-streams 的承诺。如果我们

Remainder of these two streams if we were to ask for the third element events, we would then force this promise. We would, of course, the promise that says add together the streams of O, a promise to go off and get stream cutter of ones and stream could or events that says if they have not already been evaluated, will do them but if they have will keep them around and generate out one more element.

这两个流的剩余部分。如果我们请求第三个元素 events，我们就会强制这个承诺。当然，这个承诺说要把 ones 的流和 events 的流相加，它会去获取 ones 的 stream-cdr 和 events 的 stream-cdr，如果它们尚未被求值，就进行求值；但如果已经求值，就保留它们，并再生成一个元素。

So this says we can basically walk our way down integers whenever we ask for the next element, it will tug if you like on the stream of ones and use.

所以这表示，基本上我们可以沿着整数流逐步向下，每当我们请求下一个元素时，它就会（如果你愿意这么说）拉动 ones 流并使用。

You like on the stream of ones and use the previous values of integers that it is created to create the next element. Press a promise to create the remainder of the stream, and we can continue this all the way along, having the ability to create these infinite data structures.

拉动 ones 流，并使用它之前创建的 integers 的先前值来生成下一个元素。按下承诺以创建流的剩余部分，我们可以一直这样继续下去，从而有能力创建这些无限的数据结构。

The infinite stream of ones, the infinite stream of integers, lets us actually change our way of thinking about things. In particular, remember the sieve that we saw several lectures ago. This was the sieve Emeritus thinnies that said to find all of the primes, start with the integers beginning at 2 and do the...

无限的 1 流、无限的整数流，让我们实际上改变了我们思考事物的方式。特别是，还记得我们几讲之前看到的筛法吗？那就是埃拉托斯特尼筛法，它说为了找到所有的素数，从 2 开始的整数开始，然后做以下操作……

integers beginning at 2 and do the following take the first integer or the first element of that list keep it because it's a prime and then remove from all the other structures or all the remaining elements everything that's divisible by that number then move on take the next remaining element keep it because it's a prime and remove everything divisible by that and we walked our way along generating the list of primes.

从 2 开始的整数，然后做以下操作：取第一个整数或该列表的第一个元素，保留它，因为它是一个素数；然后从所有其他结构或所有剩余元素中移除所有能被该数整除的元素；然后继续，取下一个剩余元素，保留它，因为它是一个素数，并移除所有能被它整除的元素；我们就这样一路走下去，生成素数列表。

but remember to do this when we had just lists we had to create a list of integers from 1 to some point and then process each of them in turn.

但请记住，当我们只有列表时，我们必须创建一个从 1 到某个点的整数列表，然后依次处理每一个。

and then process each of them in turn to make this thing happen and in particular, that said, had to first generate the first element, then filter everything else in the remaining list. I just literally create a huge long list of all the things that were not divisible by to keep the next element, and then filter or remove all of the elements of that list. This again had this property that we were generating lists, filtering them, generating lists, filtering them, and doing a lot of extra work.

然后依次处理每一个，以使这件事发生。特别是，那意味着必须首先生成第一个元素，然后过滤剩余列表中的所有其他元素。我实际上只是字面意义上创建了一个巨大的列表，包含所有不能被 2 整除的东西，保留下一个元素，然后过滤或移除该列表的所有元素。这再次具有这样的性质：我们生成列表、过滤它们、生成列表、过滤它们，并且做了大量额外的工作。

We can now turn this around using the idea of having infinite data.

我们现在可以利用拥有无限数据这一想法来扭转这种情况。

The idea of having infinite data structures available lets me create a sieve that in fact is much cleaner than the list version.

拥有无限数据结构这一想法让我能够创建一个筛法，它实际上比列表版本要简洁得多。

Remember in the list version, I'd have to generate the entire list of integers, then filter that to generate another list of everything that's not divisible by two, then filter that to give another list of everything that's not divisible by three. I'd have to do a lot of work to create the elements of the primes.

记住在列表版本中，我必须生成整个整数列表，然后过滤它以生成另一个所有不能被 2 整除的元素的列表，然后过滤它以得到另一个所有不能被 3 整除的元素的列表。我必须做大量工作来生成素数的元素。

On the other hand, with infinite structures, I can generate the primes only as needed. Notice what I would do:

另一方面，有了无限结构，我可以只在需要时生成素数。注意我会怎么做：

only as needed notice what i would do i can create a sieve that says given an input stream i'm going to generate an output stream the first element will be the first element of the input stream the rest will be a promise a promise to do what well to take the rest of the stream screen coder filter it removing everything that's divisible by the first element and then taking the sieve of that oh that's nice because that sieve will then when asked to be evaluated forcing the promise will generate the first element of that filtered stream.

只在需要时生成素数。注意我会怎么做：我可以创建一个筛法，它说给定一个输入流，我将生成一个输出流，第一个元素将是输入流的第一个元素，其余部分将是一个承诺，一个承诺做什么呢？好吧，取流的剩余部分，用 stream-cdr 过滤它，移除所有能被第一个元素整除的元素，然后取那个的筛法。哦，这很好，因为那个筛法在被要求求值时，强制承诺将生成那个过滤流的第一个元素。

first element of that filtered stream

那个过滤流的第一个元素

First element of that filtered stream, plus a promise to sieve again. This says, as a consequence, I will only pull out those elements from this sieve that I need on demand. I could think as though the entire stream was available, but actually do the work intimately, or increment of an increment at a time: one element as needed, then the next element as needed.

那个过滤流的第一个元素，加上一个再次筛法的承诺。这表示，结果就是，我只从筛法中取出那些我按需需要的元素。我可以想象整个流都是可用的，但实际上只是逐步地、一点一点地做工作：按需一个元素，然后按需下一个元素。

And as a consequence, I can define primes to be the sieve of all of these integers starting at to notice by the way. In this sieve, there's no base case; there's no test for am I at the end of the stream. Oh, that's okay.

因此，我可以定义素数为从 2 开始的所有整数的筛法。顺便注意，在这个筛法中，没有基本情况；没有测试我是否到达流的末尾。哦，那没关系。

the end of the stream oh that's okay because our streams are in fact infinite and we don't need to worry about that. We'll simply keep generating more and more promises to get future elements as needed, but here we have no base case and no test for base case; we simply have the construction of the stream element by element.

流的末尾。哦，那没关系，因为我们的流实际上是无限的，我们不需要担心那个。我们只需不断生成越来越多的承诺，以按需获取未来的元素，但这里我们没有基本情况，也没有对基本情况的测试；我们只是逐元素地构造流。

### 10. Streams as signal processing and the integrator example (流作为信号处理与积分器示例)

In fact, this idea of thinking about these stream structures as infinite sequences of things that are just in existence, or generate it if you like as needed over time, relates very nicely to a way of thinking about programming that's.

事实上，这种将流结构视为无限序列的想法，它们只是存在，或者如果你愿意，随时间按需生成，与一种编程思维方式非常契合，这种思维方式是。

Way of thinking about programming that's somewhat different indeed. Stream programming looks a lot like traditional signal processing, the kinds of things you'll see in six double O three for example. And what does that say well if we were to think about processing an audio signal for example, a standard way of doing it would be to say that we have some signal coming in, an initial value X, and what we're going to do to generate an output signal Y is take X, delay the signal slightly, amplify it, run it through something that increases its

一种有些不同的编程思维方式。事实上，流编程看起来很像传统的信号处理，比如你在 6.003 中会看到的那类东西。那是什么意思呢？如果我们考虑处理音频信号，例如，一种标准的方法是：我们有一些输入信号，初始值为 X，我们要生成输出信号 Y，方法是取 X，稍微延迟信号，放大它，通过一个增加其……的装置运行它。

through something that increases its value by some factor G and then adds that value back in. This is a standard little feedback loop in which we get an output signal by processing an input signal, modifying or amplifying it to scale up the values.

通过某个因子 G 放大其值，然后再将该值加回去。这是一个标准的反馈回路，我们通过处理输入信号、修改或放大它来放大数值，从而得到输出信号。

Now we can do the same thing using streams. We can capture this idea of signal processing very cleanly. So we can capture this idea of a feedback loop very nicely in streams. If X is our input stream, we'll generate an output stream Y as follows: X, the first element of X, will simply pass through. But to get the next element of Y, we'll

现在我们可以用流来做同样的事情。我们可以非常简洁地捕捉信号处理的思想。因此，我们可以很好地在流中实现反馈回路的概念。如果 X 是我们的输入流，我们将按如下方式生成输出流 Y：X 的第一个元素直接通过。但要得到 Y 的下一个元素，我们将

but to get the next element of Y we'll take the second element of X using stream Quarter which is equivalent to doing a delay map that through something that scales the element of the stream meaning just multiplies it by some constant and adds it to the value of x that's coming out so we're going to take a delayed version of X scale it and add it to the initial version of X generating as a consequence and in consequence an infinite stream as output now why would we like to have that well that leads to a very common example of a feedback loop in fact exactly that idea

但要得到 Y 的下一个元素，我们将使用流操作 stream Quarter 取 X 的第二个元素，这相当于执行一个延迟映射，通过某个缩放流的元素（即乘以一个常数）并将其加到输出的 x 值上。因此，我们将取 X 的延迟版本，缩放它，并将其加到 X 的初始版本上，从而生成一个无限流作为输出。现在，为什么我们需要这样做呢？这引出了一个非常常见的反馈回路例子，事实上正是这个思想

feedback loop in fact exactly that idea of a feedback loop can be used to build an integrator what would we like to have if we had an integrand represented as a stream of values you can think of that stream as tracing out a curve and we want to get the value of the area under that curve well we could generate a stream that outputs the values corresponding to the integrand and what would that look like well whatever the first value would be would be some initial value for example zero and then to get the next value the value under

反馈回路，事实上正是这个反馈回路的思想可以用来构建一个积分器。如果我们有一个被积函数表示为值的流，你可以把该流想象成描绘一条曲线，而我们想要得到曲线下的面积值。那么，我们可以生成一个输出对应于被积函数值的流。那会是什么样子呢？无论第一个值是什么，都会是某个初始值，例如零，然后要得到下一个值，即曲线下的值

To get the next value, the value under the curve so far, what should we do? We take the stream of input values, scale them, multiply them by some constant DT, which is the spacing between the values, and then add that value to the value we have so far. And why does that make sense? Well, we're adding the area under the curve as we move along.

要得到下一个值，即到目前为止曲线下的面积，我们应该怎么做？我们取输入值的流，缩放它们，将它们乘以某个常数 DT（即值之间的间距），然后将该值加到我们到目前为止的值上。为什么这样做合理呢？因为我们在随着移动累加曲线下的面积。

And so we can simply generate a stream as needed in which we take the value of the previous point in the stream, which is the value of the integral so far, and add to it the area under the next step. For example, we could use this to generate the integral.

因此，我们可以简单地按需生成一个流，其中我们取流中前一个点的值（即到目前为止的积分值），并加上下一步的面积。例如，我们可以用这个来生成积分。

could use this to generate the integral of the stream of ones if we take the integral of the constant value one with a spacing of two so our DT is two notice what will happen in terms of this Kahn stream effect int is returned as the actual stream and if we look at the first element of it it's just the initial value in this case is zero.

我们可以用这个来生成常数 1 的流的积分，如果我们取常数 1 的积分且间距为 2，那么我们的 DT 就是 2。注意在 Kahn 流效应中会发生什么，int 被返回为实际的流，如果我们查看它的第一个元素，它只是初始值，在这种情况下是 0。

The next value in this integral stream is given by adding together the scale stream of the integral with whatever we've done so far. And what does that say to do? We say take the value, the first value of once, scale up by two, and add it.

这个积分流中的下一个值是通过将积分的缩放流与我们到目前为止所做的相加得到的。那是什么意思呢？我们说取 once 的第一个值，乘以 2，然后加上它。

value of once scale up by two and add it to the first value of the integral so far those to simply get added up to create a to plus a promise to get the next element as we need it and of course if we ask ad streams to evaluate its next chunk it will take scale stream of ones multiplying it by two plus the element we've added so far add those together and generate four plus a promise to carry on and so on so the key points to note are that by having this idea of lazy evaluation we can create structures that will provide promises to

once 的值乘以 2，然后加到到目前为止积分的第一个值上，这两者相加得到 2 加上一个承诺，以便在需要时获取下一个元素。当然，如果我们要求 ad streams 评估它的下一块，它将取 ones 的缩放流乘以 2，加上我们到目前为止添加的元素，将它们相加得到 4 加上一个承诺继续下去，依此类推。因此，关键点在于，通过拥有惰性求值的概念，我们可以创建结构，这些结构将提供承诺，在需要时生成剩余元素；其次，我们可以利用这些思想，在创建操作它们的程序时，将这些结构视为完全可用的，而实际求值则恰好及时发生。

structures that will provide promises to create the remaining elements when needed and then secondly we can use those ideas to think about those structures as if they were entirely available when creating procedures to manipulate them yet have the actual evaluation occurred just in time to

结构将提供承诺，在需要时生成剩余元素；其次，我们可以利用这些思想，在创建操作它们的程序时，将这些结构视为完全可用的，而实际求值则恰好及时发生。