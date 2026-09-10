# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=2)

## Summary (摘要)

- The lecture introduces procedural abstraction in Scheme, explaining how lambda expressions create procedure objects that can be named and reused.
- Key syntax is covered: (lambda (params) body) creates a procedure; (define (name params) body) is shorthand for naming a lambda procedure.
- The evaluation rule for applying a procedure is substitution: replace formal parameters with argument values in the body, then evaluate.
- Procedural abstraction allows modularization: breaking complex processes into smaller, reusable procedures (modules) that can be controlled by a main procedure.
- The square root problem is used as an example, modularized into good-enough?, improve, and squirt-loop procedures, with recursion for iteration.
- The lecture introduces if as a special form with predicate, consequence, and alternative, and demonstrates tracing a procedure by substitution.

- 本讲座介绍了Scheme中的过程抽象，解释了lambda表达式如何创建可命名和重复使用的过程对象。
涵盖了关键语法：(lambda (参数) 主体) 创建一个过程；(define (名称 参数) 主体) 是命名lambda过程的简写。
- 应用过程的求值规则是替换：在主体中用实参值替换形参，然后求值。
- 过程抽象允许模块化：将复杂过程分解为更小的、可重用的过程（模块），这些模块可以由主过程控制。
- 以平方根问题为例，将其模块化为good-enough?、improve和squirt-loop过程，并使用递归进行迭代。
- 讲座介绍了if作为一种特殊形式，包含谓词、结果和替代，并演示了通过替换来跟踪过程。

## Outline (大纲)

1. Introduction to Procedural Abstraction and Lambda
2. Applying and Naming Procedures
3. Shorthand Define and Lambda Semantics
4. Procedural Abstraction and Modularization
5. Applying Modularization to Square Root
6. If as Special Form and Recursive Implementation
7. Tracing and Controlling Computational Processes

1. 过程抽象与Lambda简介
2. 应用和命名过程
3. Define简写与Lambda语义
4. 过程抽象与模块化
5. 将模块化应用于平方根
6. If作为特殊形式与递归实现
7. 跟踪和控制计算过程

## Transcript (文稿)

### 1. Introduction to Procedural Abstraction and Lambda (过程抽象与Lambda简介)

In the last lecture, we began looking at the programming language Scheme, with the intent of learning how that language would provide a basis for describing procedures and processes. That's for understanding computational metaphors for controlling complex things. In this lecture, we look at how to create procedural abstractions in our language, and how to use those abstractions to describe and capture computational processes. So far, we've seen primitives, numbers, and built-in procedures; we've seen means of combination, ways of combining things.

在上一讲中，我们开始研究编程语言Scheme，目的是了解该语言如何为描述过程和进程提供基础。这是为了理解控制复杂事物的计算隐喻。在本讲中，我们探讨如何在我们语言中创建过程抽象，以及如何使用这些抽象来描述和捕获计算过程。到目前为止，我们已经看到了原语、数字和内置过程；我们已经看到了组合的手段，即组合事物的方式。

We've seen means of combination ways of creating complex expressions, and we've gotten our first needs of abstraction, namely a way of giving a name to something. But we're still stuck just writing out arithmetic expressions as the only procedures we have are the built-in ones. We need a way to capture our own processes and our own procedures.

我们已经看到了组合的手段，即创建复杂表达式的方式，并且我们获得了第一次抽象的需要，即给某物命名的方式。但我们仍然局限于写出算术表达式，因为我们拥有的唯一过程是内置的。我们需要一种方法来捕获我们自己的过程和程序。

So we need another kind of abstraction. We need a way of capturing particular processes in our own procedures, and that's what we turn to now. In Scheme, we have a particular expression for capturing a procedure; it's called a

因此我们需要另一种抽象。我们需要一种方法在我们自己的过程中捕获特定的过程，这就是我们现在要转向的。在Scheme中，我们有一个特定的表达式来捕获过程；它被称为

捕捉一个过程，这被称为lambda表达式，它具有如下所示的形式：左括号开始，接着是关键字lambda，关键字lambda之后是若干符号，这些符号用括号括起来，随后是一个或多个合法表达式，最后以右括号结束。关键字lambda标识这个表达式是一种特殊的特殊形式。

捕捉一个过程，这被称为lambda表达式，它具有如下所示的形式：左括号开始，接着是关键字lambda，关键字lambda之后是若干符号，这些符号用括号括起来，随后是一个或多个合法表达式，最后以右括号结束。关键字lambda标识这个表达式是一种特殊的特殊形式。

紧跟lambda后面的符号集合被称为该lambda的形式参数。在这种情况中，只有一个形式参数，即参数X。后续的表达式我们称之为过程体。

紧跟lambda后面的符号集合被称为该lambda的形式参数。在这种情况中，只有一个形式参数，即参数X。后续的表达式我们称之为过程体。

Refer to as the body of the procedure. This is the particular pattern we're going to use to capture a process. The way to think about this lambda expression is that it is going to capture a common pattern of computation in a procedure; we'll actually build the procedure for us. The way to read the expression is as follows: to process something, multiply it by itself and return that value.

我们称之为过程体。这是我们将用来捕获过程的特定模式。理解这个lambda表达式的方式是，它将捕获计算中的一个常见模式；实际上，它将为我们构建过程。阅读该表达式的方式如下：要处理某物，将其自身相乘并返回该值。

So in fact, this particular lambda expression captures the process of squaring. It says if you give me a value for X, I will return the value of multiplying that thing by itself.

因此，实际上，这个特定的lambda表达式捕获了平方的过程。它说，如果你给我一个X的值，我将返回将该物与其自身相乘的值。

value of multiplying that thing by itself in a second we'll see how this happens notice that lambda expressions must be special forms the normal rules for evaluating a combination do not apply here instead the value returned by evaluating a lambda expression is the actual procedure it captures.

将该物与其自身相乘的值。稍后我们将看到这是如何发生的。注意，lambda表达式必须是特殊形式；组合的正常求值规则在这里不适用；相反，求值lambda表达式返回的值是它捕获的实际过程。

contained within that procedure will be a set of formal parameters and a body that captures the common pattern of the process as a function of those formal parameters now where can we use such a procedure well basically anywhere in our earlier expressions that we could use a built in

包含在该过程中的是一组形式参数和一个主体，该主体捕获了作为这些形式参数的函数的过程的常见模式。那么，我们可以在哪里使用这样的过程呢？基本上，在我们之前的表达式中，任何可以使用内置过程的地方，目前意味着作为组合的第一个元素。例如，这里有一个复合表达式，包含两个子表达式。与之相关的值或含义是什么？

### 2. Applying and Naming Procedures (应用和命名过程)

expressions that we could use a built-in procedure, which for now means as the first element of a combination. For example, here's a compound expression with two sub-expressions. What is the value or meaning associated with it?

表达式，我们可以使用内置过程，目前意味着作为组合的第一个元素。例如，这里有一个复合表达式，包含两个子表达式。与之相关的值或含义是什么？

The value of the first sub-expression we just saw was a procedure. The value of the second sub-expression is just the number 5. Now we have something similar to our earlier cases: a procedure applied to a value. The only difference is that here we have a procedure we built rather than a pre-existing one. We need now to

第一个子表达式的值，我们刚才看到，是一个过程。第二个子表达式的值就是数字5。现在我们有了类似于早期情况的东西：一个过程应用于一个值。唯一的区别是，这里我们有一个自己构建的过程，而不是预先存在的。我们现在需要

than a pre-existing one we need now to specify how such a procedure is applied to a set of argument so here is a summary of our earlier rules for evaluating expressions the only change is to amplify what it means to apply a procedure to a set of arguments when the procedure was a built in arithmetic operator we just did the obvious thing.

而不是预先存在的。我们现在需要指定这样的过程如何应用于一组参数。所以这里是我们早期求值规则的总结，唯一的改变是扩展了将过程应用于一组参数的含义。当过程是内置算术运算符时，我们只是做了显而易见的事情。

now if the procedure is something built by evaluating a lambda expression we have a new rule we take the body of the procedure substitute the value of the argument in place of the corresponding formal parameter and then use the same

现在，如果过程是通过求值lambda表达式构建的，我们有一个新规则：我们取过程的主体，用参数的值替换相应的形式参数，然后使用相同的

formal parameter and then use the same rules to evaluate the resulting expression. So let's go back to our example. Our rule says to replace the value of the second expression 5 everywhere in the body that we see the formal parameter X. This then reduces the application of the lammed expression to a simpler expression shown here.

形式参数，然后使用相同的规则来求值结果表达式。所以让我们回到我们的例子。我们的规则说，在主体中看到形式参数X的每个地方，都用第二个表达式的值5替换。这将lambda表达式的应用简化为这里显示的更简单的表达式。

Thus, this application of a procedure to a simple expression allows us to apply our rules again. The symbol star is just the name for the built-in multiplication operation, and v is just self-evaluating, so this all reduces to simply 25.

因此，这个过程应用于简单表达式允许我们再次应用我们的规则。符号星号只是内置乘法操作的名称，v只是自求值的，所以这一切都简化为25。

so this all reduces to simply 25 thus we see that our rules now cover the evaluation of compound expressions that include the application of procedures created by lambdas in particular the rules tell us to substitute into the body of a procedure for the formal parameters reducing to a new expression and then apply the same set of rules all over again until we reach a final answer

所以这一切都简化为25。因此，我们看到我们的规则现在涵盖了复合表达式的求值，包括由lambda创建的过程的应用。特别是，规则告诉我们将形式参数替换到过程的主体中，简化为一个新表达式，然后再次应用相同的规则，直到我们达到最终答案。

thus lambda gives us the ability to capture procedure abstraction patterns of computation in a single procedure but we don't want to have to write lambda expressions everywhere we need

因此，lambda 赋予我们将计算中的过程抽象模式捕获到单个过程中的能力，但我们不希望在每个需要的地方都编写 lambda 表达式。

lambda expressions everywhere we need this particular procedure instead we can combine this procedural abstraction with our naming abstraction, that is we can use a define expression to give a name to a procedure. In this case, the name Square will be paired with the value of the lambda expression, or quite literally, with the actual procedure created by evaluating that lambda.

我们不需要在每个需要这个特定过程的地方都写 lambda 表达式，而是可以将这种过程抽象与我们的命名抽象结合起来，也就是说，我们可以使用 define 表达式来给过程命名。在这种情况下，名称 Square 将与 lambda 表达式的值配对，或者更确切地说，与通过求值该 lambda 而创建的实际过程配对。

Then we can use the name Square whenever we want the procedure, since its value is the actual procedure. If you follow through the rules of evaluation for the last

然后，每当我们想要这个过程时，就可以使用名称 Square，因为它的值就是实际的过程。如果你按照最后一个表达式的求值规则进行推导，

rules of evaluation for the last expression you will see that we get a procedure applied to a number and the substitution of the argument into the body of the procedure reduces to a simpler expression just as we saw earlier.

你会发现我们得到一个过程应用于一个数字，并且将参数替换到过程体中，会简化为一个更简单的表达式，正如我们之前看到的那样。

the second kind of special form we saw was a lambda expression and lambda we said is our way of capturing processes in procedure lambda well-known to be Greek for procedure maker is our way of saying take this pattern and capture it together in a way that we're going to be able to reuse it in our to world view if we type this expression in

我们看到的第二种特殊形式是 lambda 表达式，我们说 lambda 是我们将过程捕获到过程中的方式。lambda 众所周知在希腊语中意为“过程制造者”，是我们表达“将这个模式捕获并组合在一起，以便我们能够在我们的世界观中重用它”的方式。如果我们输入这个表达式，

world view if we type this expression in at the visible world the computer or evaluator determines the kind of expression it is a lambda expression and uses the rule for lambdas to create the associated value.

在可见世界中，计算机或求值器确定表达式的类型，它是一个 lambda 表达式，并使用 lambda 的规则创建相应的值。

it's important to stress that the actual value created by the machine is some representation of the procedure itself it contains those init information about what kinds of formal parameters it expects and what it should do when it gets those formal parameters in other words what its body is that actual procedure object represented somehow internally is the

需要强调的是，机器创建的实际值是过程本身的某种表征。它包含关于它期望哪些形式参数以及当它获得这些形式参数时应该做什么的信息，换句话说，就是它的过程体。那个实际的过程对象以某种方式在内部表征，就是

represented somehow internally is the value associated with the lambda expression and what gets returned well some representation that says here's what I've made in fact it'll be a funny-looking thing like this that says it's a compound procedure something made by you and where it actually resides in the machine so that we can get back to it it's key to stress

与 lambda 表达式相关联的值，而返回的则是某种表征，表明“这是我创建的东西”。事实上，它会是一个看起来很奇怪的东西，比如这个，它说这是一个复合过程，是由你创建的东西，以及它在机器中的实际位置，以便我们可以回到它。需要强调的是，

evaluating the lambda creates a procedure object within the execution world whose value is then printed back out as some representation of that object now let's look at the

对 lambda 求值会在执行世界中创建一个过程对象，其值随后被打印出来，作为该对象的某种表征。现在让我们来看看

Of that object, now let's look at the interaction between creating lambdas and giving them names. First of all, as we've seen, I can create a lambda expression, and the value returned by that expression is the actual procedure object. It's not executed, it's not run; it's simply created.

创建 lambda 和给它们命名之间的交互。首先，正如我们所见，我可以创建一个 lambda 表达式，该表达式返回的值就是实际的过程对象。它不会被执行，不会被运行；它只是被创建。

If I actually want to use that procedure, I need to be able to refer to it, and the easiest way to do that is to simply give it a name. So I can define square to be the value returned by that lambda, which is the procedure. Remember, this creates a binding of the names.

如果我真的想使用这个过程，我需要能够引用它，而最简单的方法就是给它一个名字。所以我可以将 square 定义为该 lambda 返回的值，也就是这个过程。记住，这创建了名称的绑定，

binding of the names, we're with the actual procedure in that environment. Having done that, I can now write an expression using square anyplace I would have used the lambda. The rules say square's value will be used in place of square, namely the actual procedure, and therefore I'll be able to do the right thing.

将名称与实际过程绑定在那个环境中。完成之后，我现在可以在任何使用 lambda 的地方使用 square 来编写表达式。规则说 square 的值将代替 square 被使用，即实际的过程，因此我将能够做正确的事情。

And in fact, I can therefore create expressions either using square or using the full lambda expression written out. These will result in exactly the same behavior. Now, because this operation of both creating a procedure and giving it a name is such...

事实上，我因此可以创建使用 square 的表达式，或者使用完整写出的 lambda 表达式。这些将产生完全相同的行为。现在，因为这种既创建过程又给它命名的操作是如此……

### 3. Shorthand Define and Lambda Semantics (定义和 Lambda 语义的简写形式)

procedure and giving it a name it's such a common thing we have a shorthand form of that that we will use throughout the term and in the text and it's shown in this last expression here there are really two things going on this expression is the same as the second expression and there's a hidden lambda that's being evaluated to create the procedure and then the define is being used to associate the name square with that procedure let's look a little more carefully at that lambda special form then the syntax is shown at the top the

过程并给它命名，这是如此常见的事情，我们有一种简写形式，我们将在整个学期和文本中使用它，它显示在最后一个表达式中。这里实际上有两件事在发生：这个表达式与第二个表达式相同，有一个隐藏的 lambda 被求值以创建过程，然后 define 被用来将名称 square 与该过程关联。让我们更仔细地看一下 lambda 特殊形式，语法显示在顶部，

then the syntax is shown at the top the

语法显示在顶部，

then the syntax is shown at the top the has three pieces it has the keyword lambda that says this is a procedure maker the first operand here is a list of parameters in this case x and y it might be empty it might have one it might have two it might have many such expressions and what it does is it determines the number of operands that are going to be required when we use the procedure

语法显示在顶部，它有三个部分：有关键字 lambda，表示这是一个过程制造者；第一个操作数是一个参数列表，在这个例子中是 x 和 y，它可能为空，可能有一个，可能有两个，可能有很多这样的表达式，它决定了当我们使用这个过程时需要多少个操作数。

the second operand is what's called the body in this case it's that division of a plus of a couple of things in the two it can be any expression and it is important to stress it's not

第二个操作数被称为过程体，在这个例子中是那个除法表达式，它可以是任何表达式，重要的是要强调它

It is important to stress it's not evaluated when the lambda is created. It is simply kept there as a string of symbols that are going to be used later. It is only evaluated when the procedure is applied. Okay, that's the syntax of lambda.

重要的是要强调，当 lambda 被创建时，它不会被求值。它只是作为一串符号被保留在那里，供以后使用。它只在过程被应用时才被求值。好的，这就是 lambda 的语法。

What about the semantics of lambda? Well, the semantics of lambda are really important, so we're going to put it on a whole separate slide. And I feel like I should be shouting this out, but it says that the semantics of lambda are that a value of a lambda expression is a procedure. It's an object that sits in

那么 lambda 的语义呢？lambda 的语义非常重要，所以我们要把它放在单独的一页幻灯片上。我觉得我应该大声喊出来，但它的意思是，lambda 表达式的值是一个过程。它是一个对象，位于

Procedure is an object that sits in the execution world, and within it, it contains the information about what parameters it expects to be passed in and what it's going to do when you give them to them. That object is the actual value of a lambda expression.

过程是执行世界中的一个对象，它包含关于它期望接收什么参数以及当你给它们时它将做什么的信息。那个对象就是 lambda 表达式的实际值。

### 4. Procedural Abstraction and Modularization (过程抽象与模块化)

We've now seen most of the basic elements of Scheme. We're going to continue to add a few more special forms and introduce some additional built-in procedures as we go along, but for now, we have enough elements of the language to start reasoning about processes.

我们现在已经看到了 Scheme 的大部分基本元素。我们将在后续继续添加一些特殊形式并引入一些额外的内置过程，但就目前而言，我们已经有了足够的语言元素来开始推理过程。

And it's actually useful to use procedures to describe processes.

实际上，使用过程来描述过程是有用的。

actually to use procedures to describe computational things so let's look at some examples of describing processes in procedures first what does the procedure describe one useful way of thinking about this is as a means of generalizing a common pattern of operations for example consider the three expressions shown here the first two are straightforward the third is a bit more general since fubar is presumably a name for some numerical value however each of these is basically just a specific instantiation of a process the process

实际上，要用过程来描述计算性的事物，那么让我们来看一些用过程描述过程的例子。首先，过程描述的是什么？一种有用的思考方式是将其视为对常见操作模式的概括。例如，考虑这里展示的三个表达式：前两个很直接，第三个则更一般化，因为 fubar 大概是某个数值的名称。然而，每一个基本上都只是一个过程的特定实例化，这个过程是……

Instantiation of a process, the process of multiplying a value by itself, or the process of squaring, so we can capture this by giving a name to the part of the pattern that changes with each instantiation, identifying that name as a formal parameter, and then capturing that pattern as the body of a lambda expression together with the set of formal parameters all within that actual lambda.

一个过程的实例化，即一个值乘以自身的过程，或平方的过程。因此，我们可以通过给模式中随每次实例化而变化的部分命名来捕捉这一点，将该名称标识为形式参数，然后将该模式连同形式参数集合一起作为 lambda 表达式的主体，所有这些都在那个实际的 lambda 中。

Now let's consider a more complex pattern as shown here. In this case, there are two things that vary, so we will need two parameters to capture this, each with a different name, otherwise we could just...

现在让我们考虑一个更复杂的模式，如下所示。在这种情况下，有两个变化的部分，因此我们需要两个参数来捕捉它，每个参数有不同的名称，否则我们只能……

a different name otherwise we could just do the same thing we did last time and replicate the pattern with the parameters in place of the things that change as shown, but a better way to capture this pattern is to realize that there are really two things going on.

……使用不同的名称，否则我们只能像上次那样做，用参数替换变化的部分来复制模式，如下所示。但捕捉这一模式的更好方式是认识到实际上有两件事在发生。

one is the sub pattern of squaring things, the second is the use of the results of two different squaring operations within a larger pattern, so we could capture each of these things within its own procedural abstraction with its own set of parameters and its own body or pattern note that in doing

一是平方的子模式，二是两个不同平方操作的结果在更大模式中的使用。因此，我们可以将每一部分捕捉到各自的过程抽象中，每个抽象有自己的参数集和主体或模式。注意，在这样做时……

own body or pattern note that in doing this we are relying on a property of a combination namely that a combination involving a name procedure is equivalent to the pattern captured by the procedure with values substituted for the formal parameters and we see that where we use the ID of square inside a spectacular so why is this a better way of capturing a pattern.

……我们依赖于组合的一个性质，即涉及命名过程的组合等价于该过程所捕捉的模式，其中值替换了形式参数。我们看到，在某个更大的过程中使用 square 的标识符时，情况就是这样。那么，为什么这是捕捉模式的更好方式呢？

The primary reason is that by breaking the pattern up into smaller modules we isolate pieces of the computation into separate abstractions and these modules can then be reused by

主要原因是，通过将模式分解为更小的模块，我们将计算的各个部分隔离到独立的抽象中，这些模块可以被其他计算重用。特别是，平方的概念很可能在其他地方有用，因此将其捕捉到自己的过程中，然后在这个更大的过程中使用它是有意义的。通过这样做，我们创建了更易读的代码，因为我们使用简单的名称来捕捉平方的概念，并隐藏了不必要的细节。

and these modules can then be reused by other computations in particular the idea of square is likely to be a value elsewhere so it makes sense to capture that in its own procedure and then use it within this larger one as well by doing this we create code that is easier to read as we use a simple name to capture the ideal square and press the unnecessary details by so doing we isolate out the use of a procedure from the details of its active implicate implementation a trick to which we will return later in the term of course there may be many different当然，可能会有很多不同的情况。

通过这样做，我们将过程的使用与其实现细节隔离开来，这是一个我们稍后在本课程中会再讨论的技巧。当然，可能会有很多不同的模块化方式。

Of course, there may be many different ways of modularizing a computational pattern, and part of the goal is to decide how best to do this. Here, for example, is a finer-scale modularization of the pattern into procedures. Now, how each procedure uses the previous one within its body, using that idea of abstraction, to separate out the use of the procedure from the details.

当然，可能有许多不同的方式对计算模式进行模块化，部分目标就是决定如何最好地做到这一点。例如，这里是将模式分解为过程的更细粒度的模块化。现在，每个过程如何在主体中使用前一个过程，利用抽象的思想，将过程的使用与细节分离开来。

Now, let's step away from the specifics of this example and talk about the process we just used. In essence, we did several things: we identified modules as part of the computational process, which we could...

现在，让我们从这个例子的具体细节中抽身出来，谈谈我们刚刚使用的过程。本质上，我们做了几件事：我们确定了计算过程中的模块，这些模块我们可以……

The computational process which we could usefully isolate, we then captured each of those within their own procedural abstraction. And finally, we created a procedure to control the interactions between the individual modules. Of course, we could apply this process within each of the modules in a recursive fashion.

……有效地隔离，然后我们将每个模块捕捉到各自的过程抽象中。最后，我们创建了一个过程来控制各个模块之间的交互。当然，我们可以以递归的方式在每个模块内部应用这个过程。

### 5. Applying Modularization to Square Root (将模块化应用于平方根)

Our goal now is to see how we can use this general approach to capture computational processes inside of procedures. Let's take another look at this idea of capturing a procedural description with our language for describing processes, namely lambeth.

我们的目标现在是看看如何使用这种通用方法将计算过程捕捉到过程中。让我们再次审视用我们的过程描述语言（即 lambda）来捕捉过程描述的想法。

describing processes namely lambeth。我们还记得第一讲中描述的那个求平方根的过程。现在，我们构建计算平方根代码的第一步，就是要在这个过程中确定一些好的模块或阶段。

用 lambda 来描述过程。我们还记得第一讲中描述的求平方根的过程。现在，我们构建计算平方根代码的第一步，就是要在这个过程中确定一些好的模块或阶段。

在这里我们可以看到几个模块。有这样一个想法：测量我们的猜测是否足够好，以便我们能够停下来并返回答案。还有另一个想法：如果我们不够接近，就创建一个新的猜测。

在这里我们可以看到几个模块。有这样一个想法：测量我们的猜测是否足够好，以便我们能够停下来并返回答案。还有另一个想法：如果我们不够接近，就创建一个新的猜测。

接下来，我们需要一种方式来控制整个过程，在这个过程里，我们将新的猜测当作它原本就是那样地使用。

接下来，我们需要一种方式来控制整个过程，在这个过程里，我们将新的猜测当作它原本就是那样地使用。

Use our new guest as if it were the original one. I continue the process, so let's build each of these abstractions using our idea of capturing common patterns within lambda expressions here. This is a rather naive way of deciding if a guest is close enough: we take the guest and square it. If the guest is good, then this should give us a value close to the number whose square root we are seeking. Here, abs is a built-in procedure that returns the absolute value of its argument, and we simply test to see if the absolute difference is small. Note how we are already using procedural...

将我们的新猜测当作原始猜测来使用，继续这个过程。因此，让我们使用在 lambda 表达式中捕捉常见模式的想法来构建这些抽象。这是一种相当天真的判断猜测是否足够接近的方法：我们取猜测并平方它。如果猜测是好的，那么这应该给我们一个接近我们正在寻找其平方根的数字的值。这里，abs 是一个内置过程，返回其参数的绝对值，我们简单地测试绝对差是否小。注意我们已经在使用过程抽象……

how we are already using procedural abstraction we have assumed that square is an abstraction for the process of squaring numbers for improving the gift we can just use the same approach we did with Pythagoras we capture the idea of average and we use it to improve a guess as described by the process as before we can see that average is likely to be a process that we will want to use in other places so creating an abstraction allows us to avoid replicating the code in those places moreover we stress that by building this abstraction we seal off the details of

……我们已经在使用过程抽象。我们假设 square 是平方数字过程的抽象。对于改进猜测，我们可以使用与毕达哥拉斯相同的方法：我们捕捉平均值的概念，并用它来改进猜测，如过程所描述。如前所述，我们可以看到 average 很可能是一个我们会在其他地方使用的过程，因此创建抽象使我们能够避免在这些地方复制代码。此外，我们强调，通过构建这个抽象，我们将实现的细节与抽象的实际使用隔离开来。

Abstraction we seal off the details of the implementation from the actual use of the abstraction. For example, we could decide to change the implementation of average such as that shown here. Doing so does not require us to make any changes to procedures that use average, however, since those simply refer to the procedure not to the internal specifics.

抽象将实现的细节与抽象的实际使用隔离开来。例如，我们可以决定更改 average 的实现，如下所示。这样做不需要我们对使用 average 的过程进行任何更改，因为这些过程只是引用该过程，而不涉及内部细节。

Also note that the names of the parameters are internal to the lambda expression. We cannot refer to them outside the scope of the lambda here. We've changed the names of the parameters but this does not affect.

还要注意，参数的名称是 lambda 表达式内部的。我们不能在 lambda 的作用域之外引用它们。这里我们更改了参数的名称，但这并不影响……

parameters but this does not affect those procedures that use average the last step is to decide how to integrate these pieces together into a process that controls the steps of the computation.

参数，但这并不影响那些使用平均值的程序。最后一步是决定如何将这些部分整合成一个控制计算步骤的过程。

### 6. If as Special Form and Recursive Implementation (如果作为特殊形式和递归实现)

The basic idea is already captured in the process description: given a number and a guess, we want to use improve to derive a new guess, but now we have to make a decision if the guess is good enough, in which case we can stop, or should we continue the process in order to make such a decision we need a new special form called an if expression, which has three sub expressions a

基本思想已经包含在过程描述中：给定一个数字和一个猜测，我们想用 improve 来推导出一个新的猜测，但现在我们必须做出决定：如果猜测足够好，就可以停止；否则，我们应该继续这个过程。为了做出这样的决定，我们需要一种新的特殊形式，称为 if 表达式，它有三个子表达式：

which has three sub expressions a predicate a consequence and an alternative. Here is how an if expression is evaluated. First, the evaluator uses its rules, such as those we've described, to determine the value of the predicate expression.

它有三个子表达式：谓词、结果和替代。以下是 if 表达式的求值方式。首先，求值器使用其规则（如我们描述的那些）来确定谓词表达式的值。

If that value is true, then the evaluator uses its rules to evaluate the consequence expression and return that value as the value of the entire if expression. On the other hand, if that value is not true, then the evaluator uses its rules to evaluate the alternative expression and returns that value as the value of the entire if.

如果该值为真，则求值器使用其规则求值结果表达式，并将该值作为整个 if 表达式的值返回。另一方面，如果该值不为真，则求值器使用其规则求值替代表达式，并将该值作为整个 if 表达式的值返回。

value as the value of the entire if expression. So why do we say that this is a special form and not just a procedure? We'll let you think about this, but after the next lecture you should be able to answer this question. For now, we will simply accept that if expressions are evaluated in this particular manner.

值作为整个 if 表达式的值。那么为什么我们说这是一种特殊形式，而不仅仅是一个过程呢？我们让你思考这个问题，但在下一讲之后你应该能够回答这个问题。目前，我们只需接受 if 表达式以这种特定方式求值。

So back to our process. We know from our description that the heart of the process should look something like this: we check to see if we're close, and if so, then we just return the value of the guest. Or if expression will handle that for us if we are not close.

回到我们的过程。从描述中我们知道，过程的核心应该看起来像这样：我们检查是否接近，如果是，则直接返回猜测的值。如果我们不接近，if 表达式将为我们处理。

handle that for us if we are not close enough we want to improve our gifts using the improve procedural abstraction we built but somehow we want that to then use that value as a new gift and repeat the process how do we do that

如果我们不够接近，我们想使用我们构建的 improve 过程抽象来改进我们的猜测，但不知何故，我们希望将该值用作新的猜测并重复该过程。我们该怎么做呢？

well let's call this overall process of repeated improving a guess until we're close enough squirt loop then if we're not close enough we get an improved gift and simply do this again

好吧，让我们将这种重复改进猜测直到足够接近的整体过程称为 squirt loop。那么如果我们不够接近，我们得到一个改进的猜测，然后简单地再次执行此操作。

finally we can assemble our squirt procedures we just use this repeated process of improving against all we need to do is get it

最后，我们可以组装我们的 squirt 过程：我们只需使用这种重复改进的过程，我们需要做的就是启动它。

against all we need to do is get it started with some initial gift ash this may look a bit unusual we have a procedure that refers to itself within its body in a recursive fashion can we be sure that this procedure will correctly evolve as we saw in the first lecture.

我们需要做的就是以某个初始猜测启动它。这可能看起来有点不寻常：我们有一个在其自身内部以递归方式引用自身的过程。我们能确定这个过程会像我们在第一讲中看到的那样正确演化吗？

### 7. Tracing and Controlling Computational Processes (追踪和控制计算过程)

in the next lecture we're going to introduce a formal model for tracing the evaluation of expressions special expressions involving the application of procedures for now however we can be a bit informal and walk through the steps of the computation as an example let's suppose we will try to find the squirt

在下一讲中，我们将引入一个正式模型来追踪表达式的求值，特别是涉及过程应用的特殊表达式。现在，我们可以非正式地逐步检查计算的步骤。作为一个例子，假设我们试图找到 squirt。

Suppose we will try to find the squirt of two. Basically, we can replace this expression with the body of the procedure associated with squirt, where the formal parameters are replaced with a specific value. In other words, we reverse the process of capturing a pattern. So we are going to loop through the process using an initial guess of one.

假设我们试图找到 2 的平方根。基本上，我们可以用与 squirt 关联的过程体替换这个表达式，其中形式参数被替换为特定值。换句话说，我们逆转了捕获模式的过程。因此，我们将使用初始猜测 1 循环该过程。

Now, what does this squirt loop do? Well, the pattern it captured was to see if we are close enough. Here we have the body of the squirt loop procedure, with the specific values in place. For now, we don't care about the other sub.

现在，这个 squirt loop 做什么？它捕获的模式是检查我们是否足够接近。这里我们有 squirt loop 过程体，其中特定值已就位。目前，我们不关心其他子表达式。

don't care about the other sub expressions of the ethics in this case. We are not close enough so we move to the alternative stage of this expression as shown now. This is just like a normal combination.

在这种情况下，我们不关心 if 表达式的其他子表达式。我们不够接近，所以转到此表达式的替代部分，如图所示。这就像一个普通的组合。

We reduced the values of the sub expressions so we get the value of the improved guest and then just repeat the Prophet. We keep doing this until we get a value that's close enough that we can stop. So to summarize, we've seen that we can use the idea of a procedure to capture a computational process by finding good components or modules of

我们减少了子表达式的值，因此我们得到改进猜测的值，然后重复该过程。我们一直这样做，直到得到一个足够接近的值，可以停止。总而言之，我们已经看到，我们可以使用过程的思想来捕获计算过程，方法是找到过程的好组件或模块，

finding good components or modules of the process, capturing each within its own procedure, and then deciding how to control the overall process of the computation.

找到过程的好组件或模块，将每个组件封装在自己的过程中，然后决定如何控制整个计算过程。

in the next lecture we will return to this idea, looking at different ways to.

在下一讲中，我们将回到这个想法，探讨不同的方式。