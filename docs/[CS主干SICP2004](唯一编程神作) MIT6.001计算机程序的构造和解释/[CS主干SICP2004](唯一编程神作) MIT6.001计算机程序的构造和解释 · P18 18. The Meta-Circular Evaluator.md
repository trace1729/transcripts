# Video Transcript (视频文字稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=18)

## Summary (摘要)

- The lecture recaps the construction of the metacircular evaluator, where eval and apply form the core cycle: evaluating an expression in an environment reduces to applying a procedure to arguments, which in turn evaluates the procedure body in a new environment with parameters bound to arguments.
- The evaluator uses data abstractions to separate syntax from semantics, allowing changes to the syntax of expressions (e.g., changing the order or form of procedure application) without altering eval and apply, and enabling syntactic sugar like converting let expressions into lambda applications via syntactic manipulation.
- The lecture details the implementation of environment operations, including extend-env for creating new frames and lookup procedures that scan frames and traverse the environment chain, culminating in the construction of the global environment with primitives and the driver loop for user interaction.
- Lexical scoping is demonstrated through the environment model, where procedure applications create frames scoped to the environment in which the procedure was defined, ensuring free variables are bound in that lexical context.
- Dynamic scoping is introduced as an alternative, requiring only minimal changes to eval and apply: procedures no longer store their creation environment, and applications extend the caller's environment instead, fundamentally changing variable lookup rules while leaving the syntax unchanged.

- 本讲座回顾了元循环求值器的构建，其中 eval 和 apply 构成了核心循环：在环境中求值一个表达式，归结为将过程应用于参数，而后者又在新环境中求值过程体，该环境将形参绑定到实参。
求值器使用数据抽象将语法与语义分离，允许在不改变 eval 和 apply 的情况下修改表达式的语法（例如，改变过程应用的顺序或形式），并通过语法操作将 let 表达式转换为 lambda 应用等语法糖。
- 讲座详细介绍了环境操作的实现，包括用于创建新框架的 extend-env 以及扫描框架并遍历环境链的查找过程，最终构建了包含原语和用户交互驱动循环的全局环境。
- 通过环境模型演示了词法作用域，其中过程应用创建框架，其作用域限定在定义该过程的环境中，确保自由变量在该词法上下文中绑定。
- 动态作用域作为另一种选择被引入，只需对 eval 和 apply 做最小改动：过程不再存储其创建环境，应用改为扩展调用者的环境，从根本上改变了变量查找规则，而语法保持不变。

## Outline (大纲)

1. Recap and Introduction to the Actual Scheme Evaluator
2. The Heart of the Interpreter: Eval and Apply
3. Implementation of Eval: Dispatch on Expression Type
4. Handling Previous Expressions and New Sequences
5. Details of Eval and Apply for Compound Procedures and Sequences
6. Separating Syntax from Semantics with Data Abstractions
7. Example of Syntax Changes and Syntactic Sugar for Let
8. Handling Shorthand Define and Modifying the Evaluator
9. Concrete Environment Representation and Operations
10. Lexical vs. Dynamic Scoping and Tight Coupling of Eval/Apply

1. 回顾与介绍实际的 Scheme 求值器
解释器的核心：Eval 和 Apply
3. Eval 的实现：按表达式类型分派
4. 处理先前的表达式和新的序列
5. 复合过程与序列的 Eval 和 Apply 细节
6. 用数据抽象分离语法与语义
7. 语法变更示例与 Let 的语法糖
8. 处理简写 Define 并修改求值器
9. 具体环境表示与操作
10. 词法作用域与动态作用域，以及 Eval/Apply 的紧密耦合

## Transcript (文字稿)

### 1. Recap and Introduction to the Actual Scheme Evaluator (回顾与介绍实际的 Scheme 求值器)

last time we completed building our evaluator and as you saw we slightly misled you we started off saying we were going to use schemes lexical analyzer and parser but then build our own evaluator which we did initially for our arithmetic expressions then for defines and for applications and eventually we ended up with something that basically looked like schemes evaluator written in scheme

上次我们完成了求值器的构建，如你所见，我们稍微误导了你：我们一开始说将使用 Scheme 的词法分析器和解析器，但随后构建了我们自己的求值器，最初针对算术表达式，然后是 define 和应用，最终我们得到了一个基本上看起来像用 Scheme 编写的 Scheme 求值器的东西。

today we're going to build on that idea by examining the actual scheme evaluator well run through a quick but Graham tour the full evaluator looking at several

今天我们将在此基础上，通过考察实际的 Scheme 求值器来继续。我们将快速浏览完整的求值器，审视几个关键思想。

the full evaluator looking at several key ideas first remember that we are basically describing the process of evaluation which in our case means making the environment model a concrete set of procedures

首先，记住我们基本上是在描述求值过程，在我们的案例中，这意味着将环境模型具体化为一组过程。

second the essential message is that by defining the process of evaluation we are also defining our language this means that the evaluator design then provides the basis on which we can create abstractions especially procedural abstractions as it provides the mechanism for unwinding abstraction back down to primitive pieces when we

其次，核心信息是，通过定义求值过程，我们也在定义我们的语言。这意味着求值器的设计为我们创建抽象（尤其是过程抽象）提供了基础，因为它提供了将抽象层层展开回原始部件的机制，当我们想要获得实际值时。

Back down to primitive pieces when we want to get an actual value and finally, given that designing an evaluator is essentially equivalent to designing a language, we're going to look at how variations in a scheme evaluator can lead to very different language behavior.

最后，鉴于设计求值器本质上等同于设计语言，我们将研究 Scheme 求值器的变体如何导致非常不同的语言行为。

To do this, we're going to have to look at several different parts of the language design. We'll start with the core of a vowel and apply, then look at how we support the syntax of the language, how we create and manipulate the environments that let us look up values that are associated with that syntax.

为此，我们将不得不审视语言设计的几个不同部分。我们将从 eval 和 apply 的核心开始，然后研究我们如何支持语言的语法，如何创建和操作环境，这些环境让我们查找与该语法关联的值。

These are associated with that syntax, and then how primitives are installed into the initial or global environment. Finally, we'll put together the overall infrastructure for letting a user interact with the evaluator, and we'll see all of these pieces as we walk quickly through our full evaluator.

这些值与该语法相关联，然后研究原语如何安装到初始或全局环境中。最后，我们将整合整体基础设施，让用户与求值器交互，我们将在快速浏览完整求值器的过程中看到所有这些部分。

### 2. The Heart of the Interpreter: Eval and Apply (解释器的核心：Eval 和 Apply)

As with previous lectures, there's a code handout that goes with this lecture, and we suggest you print out a copy or have one available as we walk through all of this in order to follow along. Let's start with the heart of the interpreter.

与之前的讲座一样，本次讲座附带代码讲义，我们建议你打印一份或手边有一份，以便我们按顺序浏览所有这些内容。让我们从解释器的核心开始。

with the heart of the interpreter we've already seen this with our simple interpreter from last time the essence of the evaluator is a tight loop in which the evaluation of an expression with respect to an environment reduces in the general case to the application of a procedure object to a set of arguments and this in turn generally reduces to the evaluation of a simpler expression namely the body of the procedure with respect to a new environment one in which the formal parameters have been bound to a new set of arguments this loop continues

对于解释器的核心，我们上次在简单解释器中已经看到过：求值器的本质是一个紧密的循环，其中对表达式相对于环境的求值，在一般情况下归结为将过程对象应用于一组参数，而这通常又归结为对更简单表达式的求值，即过程体相对于新环境的求值，在该环境中形参已绑定到一组新的实参。这个循环继续

of arguments this loop continues unwinding expressions until it reaches the application of a primitive procedure or the evaluation of a primitive data object.

这个循环继续展开表达式，直到达到原语过程的应用或原语数据对象的求值。

our convention in setting this up is we'll use an eval that does dispatch on that is it checks the expression type and based on that sends the expression off to a particular procedure to handle that kind of expression.

我们在此设置中的约定是，使用一个 eval 进行分派，即检查表达式类型，并根据类型将表达式发送给特定的过程来处理该类表达式。

our Convention on apply is that it will first evaluate the arguments then apply the procedure it is the value of the first argument to the values of the others.so here's our

我们对 apply 的约定是，它首先对参数求值，然后将过程（即第一个参数的值）应用于其他参数的值。所以这是我们的

### 3. Implementation of Eval: Dispatch on Expression Type (Eval 的实现：按表达式类型分派)

the values of the others so here's our implementation of eval as we said this is also on a printout that you can do separately so you can have it around as we walk through all of this we're just going to capture pieces here as part of the lecture. check out the form of eval first of all it's a dispatch on type so it checks the expression to figure out what kind of beast it is then sends it to the procedure that handles evaluation for such beasts also notice that we're assuming a data abstraction for checking out types we're not making any particular assumptions but we're using a

其他表达式的值，所以这是我们 eval 的实现。正如我们所说，这也在一份打印稿上，你可以单独拿在手里，以便在我们逐步讲解时参考。我们在这里只是截取其中的一部分作为讲座内容。首先看看 eval 的形式，它是一个基于类型的分发器：它检查表达式，判断它属于哪种类型，然后将其发送给处理该类表达式求值的过程。同时注意，我们假设了一种数据抽象来检查类型；我们没有做任何特定的假设，而是使用一组过程来检查每种类型。这意味着我们以后总能干净地添加或修改类型，而不必在求值本身中做任何更改。

particular assumptions but we're using a set of procedures to check each type this will it mean that we can always cleanly add or alter our types later on and not have to change anything in terms of the evaluation itself

特定的假设，而是使用一组过程来检查每种类型。这意味着我们以后总能干净地添加或修改类型，而不必在求值本身中做任何更改。

also notice the order in which we check things in eval we first start out by checking for primitives things like self evaluating expression or a variable these are easy things to deal with

还要注意我们在 eval 中检查的顺序：我们首先检查基本类型，比如自求值表达式或变量，这些是容易处理的东西。

next we check out the special forms and remember a special form means something that does not obey the normal rules of evaluation these are

接下来我们检查特殊形式，记住特殊形式是指不遵循常规求值规则的东西。这些是

The normal rules of evaluation, these are clearly things like assignment or definition, in which we only want to evaluate one of the sub-expressions but not both, or things like `if` where we know we want to evaluate in a different order.

常规求值规则，这些显然是诸如赋值或定义之类的东西，我们只想求值其中一个子表达式而不是全部，或者像 `if` 这样的东西，我们知道要以不同的顺序求值。

Each one of these will be treated separately with a specific procedure to deal with the kind of expression shown here. We've added a couple of new ones, and we'll come back to those in a second.

每一个都将用一个特定的过程单独处理，以处理这里所示的表达式类型。我们添加了一些新的，稍后我们会回到这些。

The flavor to see, though, is that we've now dealt with all of the special forms, and then finally we get to an application.

要看到的要点是，我们现在已经处理了所有的特殊形式，最后我们到达了应用。

then finally we get to an application, that is we get to the case where we're treating an expression which has a set of sub expressions each of which we're going to evaluate and then apply the operator that's the value of the first sub expression to all the rest of them.

然后最后我们到达了应用，也就是说，我们处理一个表达式，它有一组子表达式，我们将对每个子表达式求值，然后将运算符（即第一个子表达式的值）应用于其余所有子表达式。

we've left application question mark as an abstraction here to check to see whether something is an application, but as you saw with our earlier examples of avails most likely we'll just try and make sure this is a combination, meaning we will assume that if it's not something that's a primitive and it's

我们把 application? 留作一个抽象来检查某物是否是一个应用，但正如你在我们之前的 eval 例子中看到的，很可能我们只会尝试确保它是一个组合，这意味着我们将假设如果它不是基本类型，也不是特殊形式，那么按定义我们通常期望它是一个应用。

something that's a primitive and it's not something that's a special form by definition we'll expect it to actually be an application in general. However, we see that our evaluator has exactly the kind of form that we slowly grew up to in our previous lectures. Given an expression and an environment, eval will check the type of expression using some abstractions we'll get for seeing if it's a primitive, then seeing if it's a special form, then ultimately checking to see if it's an application. In each case, it's going to dispatch that expression off to a.

不是基本类型，也不是特殊形式，那么按定义我们通常期望它是一个应用。然而，我们看到我们的求值器具有我们在前几讲中逐渐成长起来的精确形式。给定一个表达式和一个环境，eval 将使用一些抽象来检查表达式的类型，首先看它是否是基本类型，然后看它是否是特殊形式，最后检查它是否是一个应用。在每种情况下，它都会将该表达式分派给一个

dispatch that expression off to a procedure to handle it. And we've seen many of these things: we know what variable should do, it should just look up the value of the variable in the environment. We know what quoted should do, it should simply grab the quotation and return it. We know what each of the special forms in general should do: definition should create a binding for a name and a value in the new environment; similarly, if should change the order in which we evaluate the expressions, and so on. And of course, the last thing we do is get to an

将该表达式分派给一个过程来处理它。我们已经见过许多这样的东西：我们知道 variable 应该做什么，它应该只是在环境中查找变量的值。我们知道 quoted 应该做什么，它应该只是获取引号内的内容并返回它。我们知道每个特殊形式大体上应该做什么：definition 应该在新环境中为名字和值创建绑定；类似地，if 应该改变我们求值表达式的顺序，等等。当然，我们最后要做的是到达一个

the last thing we do is get to an application in which we evaluate the first sub expression the operator and then get the values of all the other sub expressions as a list and apply that operator to that list in fact notice I misled you slightly because we don't have to say that the operator is the first sub expression here operator is simply some data abstraction that will get out the right piece of the expression but it could in fact be some other part as we'll see shortly

最后我们到达一个应用，其中我们求值第一个子表达式（运算符），然后获取所有其他子表达式的值作为一个列表，并将该运算符应用于该列表。事实上，注意我稍微误导了你，因为我们不必说运算符是这里的第一个子表达式；运算符只是某种数据抽象，它将取出表达式的正确部分，但它实际上可能是其他部分，正如我们稍后将看到的。

### 4. Handling Previous Expressions and New Sequences (处理先前的表达式和新序列)

so here's a quick synopsis of what we see on that evaluator the evaluator

这是我们在那个求值器上看到的快速概要：求值器

在那个求值器上，求值器首先根据类型进行分发。首先检查的是基本类型，也就是那些可以自我求值或者仅仅被引用的东西。这些东西需要实现引用功能，我们稍后会回来讨论，因为之前我们还没见过它。

在那个求值器上，求值器首先根据类型进行分发。首先检查的是基本类型，也就是那些可以自我求值或者仅仅被引用的东西。这些东西需要实现引用功能，我们稍后会回来讨论，因为之前我们还没见过它。

第二组处理的是我们的变量以及它们在环境中被操作的方式。这包括能够定义变量、能够查找变量的值，以及能够改变变量的值。我们见过的第三组东西是

第二组处理的是我们的变量以及它们在环境中被操作的方式。这包括能够定义变量、能够查找变量的值，以及能够改变变量的值。我们见过的第三组东西是

The third set of things we've seen are conditionals, ways of branching depending on what the value of an expression is. If we saw in our earlier evaluators here, we've also added in cond.

我们见过的第三组东西是条件表达式，即根据表达式的值进行分支的方式。在我们早期的求值器中，我们看到了 if，这里我们还添加了 cond。

And we'll come back to how we can actually implement that in a second. Then ultimately, we get around to procedure application—how do we apply an operator or procedure to a set of arguments? We've added one other new thing to our system, by the way, and that's dealing with sequences of expressions, begins, and let's look at that briefly before we come back to looking at procedure.

我们稍后会回到如何实际实现它。然后，最终我们到达过程应用——我们如何将运算符或过程应用于一组参数？顺便说一句，我们还为系统添加了一个新东西，那就是处理表达式序列，即 begin，让我们在回到过程应用之前简要看一下它。

come back to looking at procedure application in the evaluators we built over the last couple of lectures when we got around to applying a procedure to a set of arguments we saw that reduce to simply evaluating the body of the procedure with respect to a new environment one in which the parameters had been bound to the values passed in but evaluation of the body just reduced to recursively using eval on that expression and that was because we assumed that the body was just one single expression in fact before we introduced mutation into our language

在我们过去几讲构建的求值器中，当我们处理将过程应用于一组参数时，我们看到它简化为在新环境中求值过程体，其中参数已绑定到传入的值。但过程体的求值只是递归地对那个表达式使用 eval，那是因为我们假设过程体只是一个单一表达式。事实上，在我们向语言引入变异之前

introduced mutation into our language that would make sense because the value the body would be the value of the last expression and basically said it should only be one expression there if we had more than one expression evaluating them in order would simply cause us to throw away things once we have mutation though expressions can do things other than return values they can create side-effects and so a generalization for an evaluator is to let the body of a procedure be a sequence of one or more expressions that's shown here for example in which

在我们向语言引入变异之前，这是有道理的，因为过程体的值就是最后一个表达式的值，并且基本上说它应该只有一个表达式。如果有多个表达式，按顺序求值它们只会导致我们丢弃前面的值。一旦我们有了变异，表达式除了返回值之外还能做其他事情，它们可以产生副作用，因此求值器的一个推广是让过程体成为一个或多个表达式的序列，例如这里所示的

That's shown here, for example, in which we define food to be a procedure that has two expressions in its body: one that does something, probably a side-effect, since the value returned will simply be lost, and then one that actually computes and returns a value. Now we still have to figure out how to do evaluation of a sequence; we'll get to that in a second. But given the idea that evaluating a sequence could take a series of expressions, evaluate them in order, and then return the value of the last one, we could see that in our...

例如，这里展示了这一点，我们定义 `food` 为一个过程，其过程体包含两个表达式：一个执行某些操作，可能是副作用，因为返回的值将被丢弃；另一个实际计算并返回一个值。现在，我们仍需弄清楚如何对序列进行求值；我们稍后会讨论。但考虑到对序列求值可以接受一系列表达式，按顺序求值，然后返回最后一个表达式的值，我们可以看到在我们的……

最后一点，我们可以在我们的推广中看到这一点。现在我们的过程体可以包含多个表达式，并且在我们的apply中，我们将评估整个过程体的序列，而不仅仅是将过程体作为一个单一表达式。

最后一点，我们可以在我们的推广中看到这一点。现在我们的过程体可以包含多个表达式，并且在我们的 `apply` 中，我们将评估整个过程体的序列，而不仅仅是将过程体作为一个单一表达式。

这接着说明，我们的apply，我们处理过程应用于参数的方式，将会略有不同。它将获得一种处理原语的方式，并且它将获得一种处理复合过程的方式，但后者将会略有改变。然而，请注意apply的形式，即将过程应用于参数。

这接着说明，我们的 `apply`，即我们处理过程应用于参数的方式，将会略有不同。它将获得一种处理原语的方式，并且它将获得一种处理复合过程的方式，但后者将会略有改变。然而，请注意 `apply` 的形式，即将过程应用于参数。

notice the form apply of a procedure to a set of arguments first checks to see if it's a primitive procedure something that's built-in in which case we'll send it off to the thing that deals with that application

注意 `apply` 的形式：将过程应用于一组参数时，首先检查它是否是一个原语过程，即内建的过程，如果是，则将其发送给处理该应用的程序。

### 5. Details of Eval and Apply for Compound Procedures and Sequences (复合过程与序列的 Eval 和 Apply 细节)

if it's a compound procedure on a combination that's using something we built with our own lambda for example we will get out a new environment by taking the parameters of the procedure using the appropriate data abstraction taking the arguments passed in and doing a binding of those parameters to those arguments in a frame which extends the

如果它是一个复合过程，即一个使用我们自己的 lambda 构建的组合，我们将通过提取过程的参数（使用适当的数据抽象）、提取传入的参数，并在一个框架中将参数绑定到这些参数来获得一个新环境，该框架扩展了……

arguments in a frame which extends the environment that was the environment the procedure held given this new environment we will then evaluate the body of the procedure but notice here we'll evaluate it as a sequence not as a single evelle meaning we'll treat it as a set of expressions evaluate each one in order and return the value of the last one as the value of the overall application.

……该过程所持有的环境。给定这个新环境，我们将评估过程体，但注意这里我们将它作为一个序列来评估，而不是作为一个单一的 `eval`，这意味着我们将它视为一组表达式，按顺序评估每一个，并返回最后一个的值作为整个应用的值。

with that we now see the intertwining of a Val and apply let's take a look now at some of the specific pieces so let's quickly look through the

至此，我们看到了 `eval` 和 `apply` 的相互交织。现在让我们看看一些具体的部分，快速浏览一下……

pieces so let's quickly look through the pieces of eval checking out some of the things to make sure they do what we expect. First of all, self-evaluating expressions. Well, remember exp is just a tree structure. Self-evaluating says just return the value of that expression, just return that tree structure, so things like numbers will simply return as numbers. If an expression is just a variable, a symbol will simply look up that variable in the environment. We'll get to that shortly.

……快速浏览一下 `eval` 的各个部分，检查一些事情以确保它们符合我们的预期。首先，自求值表达式。记住，`exp` 只是一个树结构。自求值意味着直接返回该表达式的值，即返回那个树结构，因此像数字这样的东西将直接作为数字返回。如果一个表达式只是一个变量，即一个符号，则只需在环境中查找该变量。我们稍后会讨论。

Next, let's skip down to procedure application. With our change, we can see that the evaluator gets the...

接下来，让我们跳到过程应用。随着我们的改变，我们可以看到求值器获得……

we can see that the evaluator gets the value of the operator by recursively evaluating the sub expression then gets a list of values of the other expressions note that we explicitly require a list here by evaluating this case each species in turn and constructing up a list of values note however that our data is protraction isolates the issues of the order the arguments from our evaluator we don't know if the operators the first expression or not in this case operator simply will select out whatever we decide to have in terms of our semantics

……我们可以看到求值器通过递归求值子表达式获得运算符的值，然后获得其他表达式的值的列表。注意，我们在这里明确要求一个列表，通过依次求值每个表达式并构造一个值列表。然而，请注意，我们的数据抽象将参数的顺序问题与求值器隔离开来；我们不知道运算符是否是第一个表达式，在这种情况下，运算符将简单地选择我们根据语义决定的任何内容。

decide to have in terms of our semantics

……根据我们的语义决定……

decide to have in terms of our semantics and syntax for our language and as we saw, apply will now evaluate the sequence of expressions that it assumes the body contains.

……根据我们的语义和语法决定，并且正如我们所见，`apply` 现在将评估它假定过程体包含的表达式序列。

What about ifs? Well, we know what an if should do. It should take a sequence of expressions, evaluate the first sub expression — or rather, we're going to assume it's the first sub expression — and depending on that's value, either evaluate the consequent or the alternative.

那么 `if` 呢？我们知道 `if` 应该做什么。它应该接受一个表达式序列，评估第一个子表达式——或者更确切地说，我们假设它是第一个子表达式——然后根据该值，评估结果部分或替代部分。

And if you look in the code that we've handed out, you'll see that this does exactly the right thing. What about begins? Remember, a sequence is.

如果你查看我们分发的代码，你会看到这确实做了正确的事情。那么 `begin` 呢？记住，一个序列是……

What about begins remember a sequence is something that's either identified by an explicit begins statement or in the body of our procedures we just saw so what we want to do in this case is get out the set of expressions and evaluate them and we'll do the following trick which we show in the next slide.

那么 `begin` 呢？记住，一个序列要么由显式的 `begin` 语句标识，要么就在我们刚才看到的过程体中。所以在这种情况下，我们要做的是取出表达式集合并评估它们，我们将采用下一个幻灯片中展示的技巧。

Well to evaluate a sequence we know what we should do we should evaluate eating each of the expressions in order when we get to the last one we should return its value as the value of the overall expression again we're going to burry some things.

要评估一个序列，我们知道应该做什么：我们应该依次评估每个表达式，当到达最后一个时，返回它的值作为整个表达式的值。同样，我们将把一些东西隐藏在数据抽象后面。

again we're going to bury some things behind some data abstractions but we can see here the form we'd expect for evaluating a sequence if it's the last expression we'll get it out and simply evaluate it by recursively calling eval.

……再次，我们将把一些东西隐藏在数据抽象后面，但我们可以在这里看到评估序列的预期形式：如果是最后一个表达式，我们将取出它并通过递归调用 `eval` 来评估它。

and all of this on the other hand if it's not we'll evaluate the next sequence or next expression in the sequence and having done that we'll move on and evaluate the remaining expressions in the sequence expressions like definition and assignment simply either create or change bindings of variables and values in the environment.

另一方面，如果不是最后一个，我们将评估序列中的下一个表达式，然后继续评估序列中剩余的表达式。像 `definition` 和 `assignment` 这样的表达式只是创建或改变环境中变量和值的绑定。

variables and values in the environment, but notice the form in both these cases. We get out the part of the expression that corresponds to the new value and actually evaluate it by recursively apply Val to that. We similarly, though, get out just the part of the expression that corresponds to the variable, has a tree structure kind of manipulation, grabbing out that piece without evaluation, and then doing something in the environment.

……环境中变量和值的绑定，但注意这两种情况的形式。我们取出表达式中对应于新值的部分，并通过递归调用 `eval` 来实际评估它。类似地，我们也取出表达式中对应于变量的部分，这是一种树结构操作，提取该部分而不评估，然后在环境中进行某些操作。

Again, notice by using data abstractions here, we have not specified what order the expressions will be in. We need to do.

再次注意，通过在这里使用数据抽象，我们没有指定表达式将按什么顺序排列。我们需要这样做。

The expressions will be in, we need to do that ultimately, but here a change in the order will not change how these evaluations take place. So there's the whirlwind tour of eval and apply. We've certainly buried some details behind some data structures; we're going to come back to that shortly, but the heart that you see here really is the heart of a Val.

……表达式将按什么顺序排列，我们最终需要这样做，但在这里，顺序的改变不会影响这些评估如何进行。所以这就是对 `eval` 和 `apply` 的快速浏览。我们确实将一些细节隐藏在数据结构后面；我们稍后会回到这一点，但你在这里看到的精髓确实是 `eval` 的核心。

What does a Valved, in general, do? Given an expression and environment, in general it reduces the evaluation of that expression with respect to that environment to the application of a procedure to a set of arguments.

`eval` 通常做什么？给定一个表达式和一个环境，它通常将该表达式相对于该环境的评估简化为将一个过程应用于一组参数。

Procedure to a set of arguments and apply takes that application and in general reduces it to the evaluation of a new expression the body of the procedure with respect to a new environment one in which the parameters have been bound to the arguments passed in while inheriting things from the earlier environment.

过程应用于一组参数，而 apply 接受该应用并将其一般性地归约为对新表达式的求值，即过程体相对于新环境的求值，在该环境中参数已绑定到传入的参数，同时继承先前环境中的内容。

### 6. Separating Syntax from Semantics with Data Abstractions (用数据抽象将语法与语义分离)

We have some special forms in between to deal with other kinds of things but that's the general form of a valid apply. You ought to be able to look at the code we've just handed out and see how all of this is taking place. Now let's think of what.

我们还有一些特殊形式来处理其他种类的事物，但这是有效 apply 的一般形式。你应该能够查看我们刚刚分发的代码，并看到这一切是如何发生的。现在让我们思考一下。

taking place now let's think of what we've done basically we've defined the semantics of our language by defining a Val and apply we've specified what the language means and the model of computation we're going to use

现在让我们思考一下我们基本上做了什么：我们通过定义 Val 和 apply 来定义我们语言的语义，我们指定了语言的含义以及我们将使用的计算模型。

notice as well though we've done this in terms of data abstractions everything we've used to pull out this structure from the expressions has used an abstraction we're no cars encoders anywhere in there

还要注意，尽管我们通过数据抽象来做到这一点，我们用来从表达式中提取这种结构的一切都使用了抽象，其中没有任何 car 或 cdr 操作。

this is actually valuable for us because we've separated out the syntax from the semantics we said given that these particular sub

这对我们来说实际上是有价值的，因为我们将语法与语义分离开来；我们说，鉴于这些特定的子部分具有意义，我们将对它们进行处理。

said given that these particular sub pieces have meaning we'll do something with them ultimately though we also have to specify the syntax for the language the particulars of how we write expressions and that's going to enable us for example to determine when we have different kinds of expressions which ones are special forms and how to deal with them at the same time this separation of syntax and semantics is extremely useful it allows us to very easily change the syntax without having to do anything to eval and apply we're simply changing the interface to

鉴于这些特定的子部分具有意义，我们将对它们进行处理；但最终我们还必须指定语言的语法，即我们如何编写表达式的具体细节，这将使我们能够确定何时有不同类型的表达式，哪些是特殊形式以及如何处理它们。同时，这种语法与语义的分离极其有用，它使我们能够非常容易地改变语法，而无需对 eval 和 apply 做任何改动；我们只是改变接口。

we're simply changing the interface to the abstractions so we're going to look at that both by showing a little bit about how we built the syntax for our language and then how we can easily change it.

我们只是改变抽象的接口，因此我们将通过展示一点我们如何构建语言语法以及如何轻松改变它来考察这一点。

the second page of the code handout contains all of this in much more detail we're just going to highlight here some of the key things to look at in terms of how we define our basic syntax.

代码讲义的第二页包含了所有这些更详细的内容，我们这里只强调一些关键点，关于我们如何定义基本语法。

let's start with the first part we need a set of routines to detect different kinds of expressions and an easy way to do that is to have each one of them check to see

让我们从第一部分开始：我们需要一组例程来检测不同类型的表达式，一个简单的方法是让每一个例程检查它是否是一个标签列表。

is to have each one of them check to see if it's a tag list so for example if question mark will check to see if the expression is a list that is it something that's constructed out of pairs and will then check to see if the first element of that list is the symbol if ditto for lambda application

让每一个例程检查它是否是一个标签列表；例如，if? 将检查表达式是否是一个列表，即由序对构造的东西，然后检查该列表的第一个元素是否是符号 if；lambda 和应用也是如此。

we're going to use as we did before we're going to assume that anything that has not been caught by special flag a special keyword but is in fact a combination of expressions or a list if you like we're going to treat as an application this means that we may get

我们将像之前一样使用：我们将假设任何没有被特殊标志（特殊关键字）捕获但实际上是表达式组合或列表（如果你愿意）的东西，我们都将其视为应用。这意味着我们可能会遇到一些麻烦。

Application this means that we may get into some trouble, but it's the easiest way of allowing us to generalize to having any kind of procedure applied to any kind of set of expressions, as long as that procedure was created using our lambda.

应用意味着我们可能会遇到一些麻烦，但这是允许我们推广到任何类型的过程应用于任何类型的表达式集合的最简单方式，只要该过程是使用我们的 lambda 创建的。

Given that we can detect different kinds of expressions and ship them off to the procedure that handles them, those procedures will also need to have ways of getting information out of the expressions. They'll have to have ways of pulling out the pieces by walking down the list structure.

鉴于我们可以检测不同类型的表达式并将它们发送到处理它们的程序，这些程序还需要有从表达式中获取信息的方法。它们必须有通过遍历列表结构来提取部分的方法。

walking down the list structure so for example if it's an application we need to have a way of getting out the operator and the other expressions here we're going to assume that the first sub expression is in fact the operator sokar we'll grab it and we'll assume that operands is a list of all the remaining things so it could or would grab that of course you might have made a different choice as we'll see the key point is that we now have an abstraction that pulls out pieces to pass on to the evaluator and we'll need to have routines that manipulate the expressions

遍历列表结构；例如，如果是一个应用，我们需要一种方法来取出运算符和其他表达式；这里我们假设第一个子表达式实际上是运算符，所以 car 将获取它，我们假设操作数是一个包含所有剩余项的列表，所以 cdr 将获取它。当然，你可能做出了不同的选择；正如我们将看到的，关键是我们现在有一个抽象来提取部分以传递给求值器，并且我们需要有操作表达式的例程。

routines that manipulate the expressions, that is walk along and getting out the pieces. For example, if we're applying a procedure to a set of arguments, we need to be able to get out the different parts of the operands. So we'll have to have something that both checks to see are there any here, as well as one that gets either the first or the remaining operands.

操作表达式的例程，即遍历并取出部分。例如，如果我们将一个过程应用于一组参数，我们需要能够取出操作数的不同部分。因此，我们将需要有某种东西既检查是否有任何参数，又获取第一个或剩余的操作数。

Again, this is now list structure, and again we're making a choice about order. We're assuming that the operands are, for example, in this case in a left-to-right order. Nonetheless, the overall point is if you

同样，这现在是列表结构，我们再次对顺序做出选择。我们假设操作数，例如在这种情况下，是从左到右的顺序。尽管如此，总体要点是如果你

nonetheless the overall point is if you look at the code from page two what we have in terms of syntax is a set of expressions to deal with the list structure that is passed in both walking down at the find out what kind of expression it is walking down at the pull up particular pieces or walking down it to do other manipulations of that list structure

尽管如此，总体要点是如果你查看第二页的代码，我们在语法方面所拥有的是一组处理传入列表结构的表达式，既遍历以找出它是什么类型的表达式，遍历以提取特定部分，或遍历以对该列表结构进行其他操作。

the rest of the code on page two of the handout just fills out the rest of that sort of syntactical definition how to represent expressions you ought to look at it to make sure you're comfortable with it

讲义第二页的其余代码只是填补了那种语法定义的其余部分，即如何表示表达式。你应该查看它以确保你熟悉它。

### 7. Example of Syntax Changes and Syntactic Sugar for Let (语法变更示例与 Let 的语法糖)

make sure you're comfortable with it but you should see that it has much the same form using tag list checking to determine what kind of expression it is and then using car and quarter operations to get out the pieces that correspond to the different parts of the expression

确保你熟悉它，但你应该看到它具有相同的形式，使用标签列表检查来确定它是什么类型的表达式，然后使用 car 和 cdr 操作来取出对应于表达式不同部分的部分。

as we said earlier one of the reasons for using data abstractions everywhere within eval is to let us separate out the syntax from the semantics eval and apply define the semantics how expressions get their values in this language the syntax tells us how to write legal expressions by

正如我们之前所说，在 eval 中到处使用数据抽象的原因之一是让我们将语法与语义分开。eval 和 apply 定义了语义，即表达式在此语言中如何获得其值；语法告诉我们如何编写合法表达式。

us how to write legal expressions by doing that separation we can make changes to the syntax without affecting the semantics and here's one example suppose I decide rather than having the convention that the operator is the first sub expression and the operands are all the remaining expressions that I'd like to be much more verbose much more careful I might want to have expressions that say call this procedure on arguments of this form like call plus args 2 3 5 whatever how would I make this change how would I allow this kind of more verbose syntax in my language

我们如何通过这种分离来写出合法的表达式，从而在不影响语义的情况下修改语法。这里有一个例子：假设我决定不再采用运算符是第一个子表达式、操作数是其余表达式的约定，而是希望表达得更冗长、更仔细。我可能希望表达式写成这样：调用这个函数，参数是这种形式，比如 call plus args 2 3 5 等等。我该如何做出这种改变？我该如何在我的语言中允许这种更冗长的语法？

of more verbose syntax in my language. Well, we've already hinted at the answer. All we need to do is change the syntax. So, for example, now when we want to look at an application checking to see if as an application would be something that checks to Tacey if a tag list has the symbol call at the beginning. Notice that's now different. Before, we just assumed anything that wasn't a special form but was a combination was an application.

在我的语言中允许更冗长的语法。嗯，我们已经暗示了答案。我们只需要改变语法。例如，现在当我们想要查看一个应用时，检查它是否是应用，就要检查标签列表是否以符号 call 开头。注意，这现在不同了。以前，我们只是假设任何不是特殊形式但却是组合的东西都是应用。

Here, we're being very explicit about identifying things that are actually applications. Now, how do I get out the pieces? Well, remember before...

在这里，我们非常明确地识别出哪些是真正的应用。现在，我如何取出各个部分呢？嗯，记住之前……

get out the pieces well remember before we would have gotten the operator as the first sub expression here it's the second sub expression we know the first sub expression is the symbol call so we have to go down one more to get the counter to pull out the thing that's going to be the operator and for the operands well we have to skip down pass call the procedure and the symbol args to get the remainder those things so the change here is and how we pull out the pieces otherwise everything is as before again the key point all I've changed is

取出各个部分，嗯，记住之前我们会把运算符作为第一个子表达式，而这里它是第二个子表达式。我们知道第一个子表达式是符号 call，所以我们必须再往下走一层才能取出运算符。对于操作数，我们必须跳过 call 过程和符号 args，才能得到剩余的部分。所以这里的变化在于我们如何取出各个部分，其他一切都和之前一样。再次强调关键点：我所改变的只是语法。

again the key point all I've changed is the syntax the routines that walk down the list structure and pull out the pieces nothing has changed in a valor' applied itself the second reason for separating syntax from semantics is that it allows us to easily accommodate alternative forms expressions we often call this syntactic sugar meaning that it looks nicer but it actually just coats the same underlying idea with a sweeter way of expressing it let me show you an example remember left we could treat this as a special form and write a handler for it we could have

再次强调关键点：我所改变的只是语法，即那些遍历列表结构并取出各个部分的例程。在求值器本身中没有任何改变。将语法与语义分离的第二个原因是，它使我们能够轻松地容纳替代形式的表达式。我们通常称之为语法糖，意思是它看起来更美观，但实际上只是用更甜的方式表达了相同的基本思想。让我给你看一个例子。记住，我们可以把 let 当作一种特殊形式，并为它编写一个处理程序。我们可以有……

and write a handler for it we could have something that dispatches off based on having detected that this first expression is the keyword left but we can also realize that lead is just a cleaner way of creating a procedure than applying it to capture some local state variables or set another way a lat expression is really just the same as the expression shown below that is we have a lambda where the argument list for the lambda is the arguments that we're going to have as bindings in the let the body of the lambda is the body of the let expression itself and that

并为它编写一个处理程序。我们可以有某种东西，根据检测到第一个表达式是关键字 let 来进行分派。但我们也可以认识到，let 只是创建过程并将其应用于捕获一些局部状态变量的更简洁方式。换句话说，let 表达式实际上等同于下面所示的表达式：也就是说，我们有一个 lambda，其中 lambda 的参数列表是我们要在 let 中作为绑定的参数，lambda 的主体是 let 表达式本身的主体，然后……

Of the let expression itself, and that whole lambda would then be applied to the values that we want to bind to those names. These are, as we saw earlier, equivalent forms, and we've seen in the environment model they create exactly the same kind of structure.

let 表达式本身的主体，然后整个 lambda 将应用于我们想要绑定到这些名称的值。正如我们之前看到的，这些是等价的形式，并且在环境模型中，它们创建了完全相同的结构。

So rather than building a special form and inserting that into the eval to deal with it, let's see how we can simply use syntax and syntactical manipulation to convert this particular form of a let into the application of a procedure to a set of arguments.

因此，与其构建一个特殊形式并将其插入到求值器中来处理它，不如让我们看看如何简单地使用语法和语法操作来将这种 let 形式转换为过程对一组参数的应用。

First, here's the change we will make inside of an M eval will have...

首先，这是我们将要在求值器内部进行的更改：我们将有……

will make inside of an M eval will have something that detects lats we have to deal with them because we know we have to do something particular to them but what we're going to do is write something that manipulates the syntax turns a let into a combination and then simply evaluates that so recursively calls a vowel treating this now as a normal expression. Therefore we're going to dispatch, but the dispatch is in our thing; it doesn't dispatch to a procedure that does evaluation; it has syntax being manipulated and then doing a value on.

在求值器内部进行的更改：我们将有某种检测 let 的东西。我们必须处理它们，因为我们知道我们必须对它们做特定的事情。但我们要做的是编写一些操作语法的东西，将 let 转换为组合，然后简单地对其进行求值，因此递归调用求值器，将其视为普通表达式。因此，我们将进行分派，但分派是在我们的东西中；它不是分派给执行求值的过程；而是操作语法，然后对整体进行求值。

Manipulated and then doing a value on the overall thing, so now all we need to do is figure out how to rewrite the tree structure that represents a let expression into something that looks like a procedure application. Well, here we go.

操作语法，然后对整体进行求值。所以现在我们需要做的就是弄清楚如何重写表示 let 表达式的树结构，使其看起来像过程应用。好了，我们开始吧。

First of all, we'll have to have a way of checking do we have a let, and that's just a tag list check as before. What else do we need to do? Well, remember we need to pull out the variables of the let, we need to pull out the values that those variables will be bound to, and we need to pull out the body. So we do exactly that. Notice, let bound variables...

首先，我们需要一种方法来检查我们是否有 let，这就像之前一样，只是一个标签列表检查。我们还需要做什么？嗯，记住我们需要取出 let 的变量，取出这些变量将要绑定的值，以及取出主体。所以我们正是这样做的。注意，let 的绑定变量……

exactly that notice let bound variables taking in one of these tree structures is going to get the Katter of the expression that is everything that corresponds to all the is but what we want and it's on a map car down all of that we'll check it in a second but we'll see that that is actually going to pull out the bound variables getting the values map scatter down the same structure and then the body well we simply take the creditor of the body to get out the right piece and we convert that into a single expression that is wrap a sequence around it in

正是这样。注意，let 的绑定变量，取其中一个树结构，将得到表达式的 cdr，即对应于所有绑定的部分，但我们想要的是对所有这些进行 map car。我们稍后会检查，但我们会看到这实际上会取出绑定变量。获取值，对相同的结构进行 map cdr，然后对于主体，我们只需取主体的 cdr 来取出正确的部分，并将其转换为单个表达式，即在其周围包裹一个序列……

That is, wrap a sequence around it in order to convert it into something that has a begin at the beginning, ignoring for the moment the specific details what these three expressions are doing. Are walking through the tree structure corresponding to a LED expression and pulling out the appropriate pieces: the list of variables, the list of values, and the body, and converting that body into something that actually looks like a sequence now.

即在其周围包裹一个序列，以便将其转换为以 begin 开头的东西。暂时忽略这三个表达式正在做什么的具体细节。我们正在遍历对应于 let 表达式的树结构，并取出适当的片段：变量列表、值列表和主体，并将该主体转换为实际上看起来像序列的东西。

We can put all of this together. That combination, remember, is going to take one of these tree structures.

我们可以将所有这些放在一起。那个组合，记住，将接受这些树结构之一。

take him one of these tree structures representing a left and it's going to convert it into a form that we can just evaluate we're going to pass this off to a Val what does it do

接受这些表示 let 的树结构之一，并将其转换为我们可以直接求值的形式。我们将把它传递给求值器。它做什么呢？

it gets ahold of the tree structure corresponding to the variables it gets ahold of the tree structure corresponding to the values it gets ahold of the body and then it creates now a new structure and notice this structure the first part of this list because we're doing a cons is a list that represents the way we're dealing with procedures it is open paren lambda followed by a list of names followed by

它获取了与变量对应的树结构，获取了与值对应的树结构，获取了函数体，然后它创建了一个新的结构。注意这个结构，这个列表的第一部分，因为我们正在做 cons，是一个表示我们处理过程方式的列表：它是左括号 lambda，后跟一个名称列表，后跟

followed by a list of names followed by a body AHA so that's going to look exactly like a lambda expression and then what is that done we've put that on front of or at the beginning of the list of values so this will convert a let combination into a new tree structure a tree structure that looks exactly like an application of a lambda to a set of values that will then be passed to eval which will cause the evaluation of the whole expanded expression creating the thing we want okay.

后跟一个名称列表，后跟一个函数体。啊哈，所以那看起来完全像一个 lambda 表达式。然后我们做了什么？我们把它放在了值列表的前面或开头。所以这将把 let 组合转换为一个新的树结构，一个看起来完全像 lambda 应用于一组值的树结构，然后将其传递给 eval，这将导致对整个展开表达式的求值，从而创建我们想要的东西。好的。

let's trace this through to make sure we understand what's going on so remember

让我们追踪这个过程，以确保我们理解发生了什么。记住，

understand what's going on so remember, if we have a let expression such as the one shown at the top of this slide, the parser converts that into a tree structure that looks exactly like this. The first part of the tree structure is the symbol, and the second part is itself a tree structure, notice it just mimics the structure we'd expect to see.

理解发生了什么。记住，如果我们有一个 let 表达式，例如本幻灯片顶部所示的那个，解析器会将其转换为一个树结构，看起来完全像这样。树结构的第一部分是符号，第二部分本身是一个树结构，注意它只是模仿了我们期望看到的结构。

and then the last part is another piece of tree structure that is the expression that's the body of this left this tree structures what's passed into a Val and let's see what happens when we get to it.

然后最后一部分是另一块树结构，即作为这个 let 的函数体的表达式。这个树结构被传入 eval，让我们看看当我们到达它时会发生什么。

let's see what happens when we get to it now what does this in tactic and manipulation that converts a lead expression into a combination do well remember it's going to first take the thing that grabs the bound variables and in particular what did that say to do is head grab the catter of this expression so it's going to grab this piece and then it says walk down this piece this list structure that we're using a map and in particular map car down this list structure and what does that do for each element of this list it takes the car of that structure which

让我们看看当我们到达它时会发生什么。现在，这个将 let 表达式转换为组合的句法操作做了什么？记住，它首先要获取绑定变量的东西，特别是它说要获取这个表达式的 car，所以它将获取这一部分，然后它说沿着这个列表结构走下去，我们使用 map，特别是 map car 沿着这个列表结构走下去。那对列表中的每个元素做什么？它取该结构的 car，这

that do for each element of this list it takes the car of that structure which

对列表中的每个元素做什么？它取该结构的 car，这

takes the car of that structure which means it's going to grab off and create a new list structure. This one, the next thing it does is takes that same cat or that same list structure but now map's a different thing down it.

取该结构的 car，这意味着它将抓取并创建一个新的列表结构。这个，接下来它做的是取同一个 car 或同一个列表结构，但现在 map 一个不同的东西沿着它走。

In particular, it map scatter down this list. Done each means for each element of this list, it applies quatre and pulls out those pieces, which is going to build this structure.

特别是，它 map cdr 沿着这个列表走。对每个元素，它应用 cdr 并取出那些部分，这将构建这个结构。

Then this syntactic manipulation procedure walks down that left tree structure and grabs out the body, giving us this structure.

然后这个句法操作过程沿着那个 let 树结构走下去，抓取函数体，给我们这个结构。

body giving us this structure know what

函数体给我们这个结构。现在什么

body giving us this structure. Know what we've done: we've constructed three new pieces of list structure. We've done no evaluation here; we've simply manipulated pieces of the tree structure. And given those pieces of tree structure, we now glue them together. What does the let to combination syntactic manipulation say to do? It says create a list with the symbol lambda, followed by the set of names, followed by the body. Take that whole piece and then put it on the front of what we have in terms of the values.

函数体给我们这个结构。现在我们知道我们做了什么：我们构建了三块新的列表结构。这里我们没有进行任何求值；我们只是操作了树结构的各个部分。有了这些树结构的部分，我们现在将它们粘合在一起。let 到组合的句法操作说要做什么？它说创建一个列表，包含符号 lambda，后跟名称列表，后跟函数体。取整个部分，然后将其放在我们已有的值的前面。

So what have we done? We've constructed a

所以我们做了什么？我们构建了一个

所以，我们做了什么呢？我们构建了一个新的树结构列表结构，这个新的树结构列表结构代表了一个表达式的检查。它的形式是一个列表，其第一个子表达式是适当形式的lambda，后面跟着一系列表达式。

所以，我们做了什么呢？我们构建了一个新的树结构列表结构，这个新的树结构列表结构代表了一个表达式的检查。它的形式是一个列表，其第一个子表达式是适当形式的 lambda，后面跟着一系列表达式。

事实上，我们返回的是一个指向这整个树结构的指针。这个结构被拼合在一起，得到了我们想要的结果。我们要将这个lambda应用到一个参数集上，或者更确切地说，我们要评估这个整体表达式，它将会转化为某种结果。

事实上，我们返回的是一个指向这整个树结构的指针。这个结构被拼合在一起，得到了我们想要的结果。我们要将这个 lambda 应用到一个参数集上，或者更确切地说，我们要评估这个整体表达式，它将会转化为某种结果。

expression which is going to turn into an application exactly as we'd expect so. The key point is we can now do syntactic manipulation of expressions to convert one form into another form, in this case converting a let into its underlying lambda application, and then let a valve do the right thing to implement, in fact, the behavior that we want for left.

表达式，它将变成一个应用，正如我们所期望的那样。所以关键点是，我们现在可以对表达式进行句法操作，将一种形式转换为另一种形式，在这种情况下，将 let 转换为其底层的 lambda 应用，然后让 eval 做正确的事情，以实现我们想要的 let 行为。

What other syntactic variations can we have? Well remember that we can have named procedures, that is we can have forms such as the one shown here. The earlier way of doing it was to say

我们还能有哪些句法变体？嗯，记住我们可以有命名过程，也就是说，我们可以有像这里所示的形式。早期的方式是说

### 8. Handling Shorthand Define and Modifying the Evaluator (处理简写定义和修改求值器)

更早的做法是，通过定义 open paren lambda of params 以及一堆东西，来把创建过程的 lambda 和实际给过程命名的 define 分离开。我们发现，这样做很方便，尤其是在考虑替换模型的时候。我们有了这种替代形式，在 define 内部用 open paren foo 和一组参数，清晰地标识出过程对其参数的应用。

更早的做法是，通过定义 open paren lambda of params 以及一堆东西，来把创建过程的 lambda 和实际给过程命名的 define 分离开。我们发现，这样做很方便，尤其是在考虑替换模型的时候。我们有了这种替代形式，在 define 内部用 open paren foo 和一组参数，清晰地标识出过程对其参数的应用。

那么，我们应该怎么做，才能把这种形式加入到我们的系统中呢？注意，到目前为止，求值器还不能处理这种情况。

那么，我们应该怎么做，才能把这种形式加入到我们的系统中呢？注意，到目前为止，求值器还不能处理这种情况。

system note so far evaluator won't deal with this well there are two pieces in terms of semantics this is just another define everything looks just as before we're defining a variable to be a particular value now what else would we need to make it happen well as noted we don't want to change the semantics the defines are still the same in fact that a valid definition is exactly what we had before all we're going to do now is change the syntax that is the thing that manipulates the tree structure to decide how to deal with these two different

系统注意，到目前为止求值器不会处理这个。在语义上有两部分，这只是另一个 define，一切看起来都和以前一样，我们正在定义一个变量为一个特定的值。现在还需要什么来实现它？正如所指出的，我们不想改变语义，define 仍然是一样的，事实上，一个有效的定义正是我们之前所拥有的。我们现在要做的只是改变语法，即操作树结构来决定如何处理这两种不同的

如何应对这两种不同的表达式呢？关键在于记住这个改变：以前，从定义中取值时，我们只需简单地抓取第三个子表达式即可。但现在，我们需要更加小心。

如何应对这两种不同的表达式呢？关键在于记住这个改变：以前，从定义中取值时，我们只需简单地抓取第三个子表达式即可。但现在，我们需要更加小心。

我们首先要检查第二个子表达式是否是一个符号。如果是符号，说明我们面对的是“define some symbol some expression”的形式，这时我们会像之前一样，取出另一个表达式作为实际的值返回。

我们首先要检查第二个子表达式是否是一个符号。如果是符号，说明我们面对的是“define some symbol some expression”的形式，这时我们会像之前一样，取出另一个表达式作为实际的值返回。

另一方面，如果第二个子表达式不是符号，那么我们可以假设我们遇到的是这些新形式之一，并相应地处理它们。

另一方面，如果第二个子表达式不是符号，那么我们可以假设我们遇到的是这些新形式之一，并相应地处理它们。

have one of these new forms and he'll what now what do we do well in this case we have to unsure ger unwrap that lambda. So we'll do the following we will construct a new lambda using a make lambda procedure that obviously just glues a lambda on to the front of this. And what do we have to pull out we need to get the formal parameters and we can walk down the tree structure to grab those. And we need to get the body and we can walk down the tree structure to grab that. So in this case getting out the value of the definition will in fact convert this form into a lambda.

有这些新形式之一，那么现在该怎么办？在这种情况下，我们必须解开那个 lambda。所以我们将做以下事情：我们将使用 make-lambda 过程构造一个新的 lambda，显然这只是将 lambda 粘合到它的前面。我们需要取出什么？我们需要获取形式参数，我们可以沿着树结构走下去抓取它们。我们还需要获取函数体，我们可以沿着树结构走下去抓取它。所以在这种情况下，取出定义的值将实际上将这个形式转换为一个 lambda。

convert this form into a lambda and that's great because that then gets passed back into a valid definition that will be evaluated and that means that we will actually get out the lambda create the procedure and that is the value to be bound to the variable itself so once again notice that definition value as in our case of left is simply manipulating the tree structure to convert one kind of expression into another using our definitions and our conventions for that structure and then we're evaluating it to do the right thing in summary then we

将这个形式转换为一个 lambda，这很好，因为这样它就会被传回一个有效的定义中，并被求值，这意味着我们实际上会得到 lambda，创建过程，而这就是要绑定到变量本身的值。所以再次注意，定义值，就像我们例子中的 left 一样，仅仅是操纵树结构，利用我们的定义和约定将该结构从一种表达式转换为另一种，然后我们对其进行求值以做正确的事情。总结一下，我们

To do the right thing in summary then we looked at how to build the eval and apply, building on top of the things we did in the previous lectures. We've created that structure which defines the semantics for our language.

为了做正确的事情，总结一下，我们研究了如何构建 eval 和 apply，建立在之前讲座中所做内容的基础上。我们创建了定义我们语言语义的结构。

And now we've separately done the syntax, worked out how to actually manipulate the legal ways of creating expressions. And by building this data abstraction between eval and apply on the one hand and the manipulation of the expressions on the other, we've left ourselves a nice clean way in which we can change syntax, we can

现在我们又单独处理了语法，弄清楚了如何实际操纵创建表达式的合法方式。通过构建这种数据抽象，一方面在 eval 和 apply 之间，另一方面在表达式的操纵之间，我们为自己留下了一条清晰简洁的途径，可以改变语法，我们可以

way in which we can change syntax we can

改变语法的方式，我们可以

way in which we can change syntax we can add to syntax we can create procedures that manipulate syntax to convert some kinds of expressions into others without ever having to change a Val and apply so with those two pieces in place we now have an understanding of the semantics of the language and an understanding of the syntax of the language so you can see we're making pretty good progress on building an actual complete evaluator for scheme we started out building a Val and apply doing it on top of some data abstraction so we can see the flow of

改变语法的方式，我们可以添加语法，可以创建操纵语法以将某些类型的表达式转换为其他表达式的过程，而无需更改 eval 和 apply。因此，有了这两部分，我们现在理解了语言的语义和语法，所以你可以看到我们在构建一个完整的 Scheme 求值器方面取得了相当大的进展。我们开始构建 eval 和 apply，将其建立在一些数据抽象之上，这样我们就能看到流程

abstraction，这样我们就能看到求值流程，看看我们如何在环境的上下文中求值一个表达式和将它转换为一个过程应用于一组参数之间来回往返。

抽象，这样我们就能看到求值流程，看看我们如何在环境的上下文中求值一个表达式和将它转换为一个过程应用于一组参数之间来回往返。

我们做的第二件事是，我们现在深入并填补了细节。我们将语义部分——即Val和apply——从语法部分分离出来，即我们实际上如何编写表达式，而那些数据抽象使得这成为可能。

我们做的第二件事是，我们现在深入并填补了细节。我们将语义部分——即 eval 和 apply——从语法部分分离出来，即我们实际上如何编写表达式，而那些数据抽象使得这成为可能。

现在我们不得不考虑，为了真正完成这个系统，我们还需要填补哪些其他细节。

现在我们不得不考虑，为了真正完成这个系统，我们还需要填补哪些其他细节。

### 9. Concrete Environment Representation and Operations (具体环境表示与操作)

Do we need to fill in, in order to really make sure that everything we do is done in terms of basic concrete terms? And the third thing we have to get to is the environment itself. So far, we've just relied on there being some kind of abstract table for dealing with storing away bindings of variables and values and getting them back out. But now we can actually make that also very explicit.

我们需要填补哪些细节，以确保我们所做的一切都基于基本的、具体的术语？我们必须处理的第三件事是环境本身。到目前为止，我们只是依赖于某种抽象的表来存储变量和值的绑定并取回它们。但现在我们也可以将其变得非常明确。

So what do we need in an environment? Well, abstractly, we want to just build the environment diagrams that we had in our environment model—that is, we need a way of taking bindings, carryings of names.

那么环境中需要什么呢？抽象地说，我们只想构建环境模型中的环境图——也就是说，我们需要一种方式来获取绑定，即名称的携带。

Of taking bindings, carrying of names and values and gluing them together into tables, where those tables can themselves have pointers to other tables. Remember a frame is going to inherit from some other environment, so we need to glue things together as sequences of tables.

获取绑定，即名称和值的携带，并将它们粘合在一起形成表，这些表本身可以指向其他表。记住，一个框架将从某个其他环境继承，所以我们需要将事物作为表的序列粘合在一起。

And the tables have to have comparisons or bindings of values and variables together. Well, you could probably already guess that we can just do this using list structure, and indeed, if you look at page three of the code handout, you'll see how we go about representing it.

并且这些表必须有值的比较或绑定，将变量和值绑定在一起。你可能已经猜到我们可以使用列表结构来实现这一点，事实上，如果你查看代码讲义的第3页，你会看到我们如何表示它。

See how we go about representing environments. An environment, we'll just create as a list of frames. So when our little example here, E2 would point to a pair whose first pointer or car pointer points to a frame, and whose car pointer points off to the enclosing environment. And we can obviously discontinue to have this list ending up with the global environment as the last element of this list.

看看我们如何表示环境。一个环境，我们将简单地创建为一个框架的列表。所以在我们这个小例子中，E2 将指向一个序对，其第一个指针或 car 指针指向一个框架，而其 cdr 指针指向外部环境。显然我们可以继续，使这个列表以全局环境作为最后一个元素结束。

To represent a frame, we've got lots of choices. Remember that abstractly what has to go into here is a collection of variables and values paired up, and we could just

为了表示一个框架，我们有很多选择。记住，抽象地说，这里必须包含的是变量和值的配对集合，我们可以直接

and values paired up and we could just glue them together in that order. variable valuable variable value. another way to do it though is simply to create as a frame two lists. so in fact that's how we'll do it.

将值和变量配对，并按顺序粘合在一起。变量、值、变量、值。另一种方法是简单地将框架创建为两个列表。事实上，这就是我们将要做的。

if you look at the code a frame here will be a concept two things. the first thing will be a list of the variables and the second thing will be a list of the values.

如果你查看代码，一个框架在这里将是一个包含两个东西的概念。第一个东西将是一个变量列表，第二个东西将是一个值列表。

the correspondence is simply done by walking down the lists in order. the first variable in the list corresponds to the first value in its list and so on as we've seen one of the.

对应关系只需按顺序遍历列表即可。列表中的第一个变量对应于其列表中的第一个值，依此类推，正如我们所见，这是

list and so on as we've seen one of the standard in fact the most integral loop of a Val and apply is to reduce a valuation of one expression with respect to some environment ultimately to evaluation of another expression typically the body of a procedure with respect to a new environment that extends the original environment.

列表，依此类推，正如我们所见，这是 eval 和 apply 中最标准、实际上也是最核心的循环之一：将对一个表达式相对于某个环境的求值，最终归结为对另一个表达式（通常是过程体）相对于一个新环境的求值，该新环境扩展了原始环境。

so one of the things we need to be able to do is to in fact extend an environment to allow for this new evaluation how do we do that well abstractly we know the behavior we want extending an environment to take in as input a list

所以我们需要的其中一件事是能够扩展环境以允许这种新的求值。我们如何做到这一点？抽象地说，我们知道我们想要的行为：扩展环境，接受一个变量列表

Environment to take in as input a list of variables, a list of corresponding values, and a current environment, and it should create a new frame that is enclosed or scoped by that original environment in which the list of parameters are bound to the corresponding list of variables. This is just our environment model of creating a new frame and inheriting an environment that creates, as a consequence, a sequence of frames.

环境，接受一个变量列表、一个对应的值列表和一个当前环境作为输入，它应该创建一个新框架，该框架由该原始环境封闭或限定作用域，其中参数列表绑定到对应的变量列表。这只是我们环境模型中创建新框架并继承环境的过程，从而产生一个框架序列。

In terms of our concrete implementation, we can also make this code remember: our environment was simply a list of frames, so to extend an environment means adding a new frame to that list, where the new frame holds the bindings of parameters to values, and it inherits the existing environment as its enclosing scope.

就我们的具体实现而言，我们也可以编写这个代码。记住：我们的环境只是一个框架列表，所以扩展环境意味着向该列表添加一个新框架，其中新框架保存参数到值的绑定，并且它继承现有环境作为其封闭作用域。

a list of frames so to extend an environment we simply want to put on the front of that list a new frame so if you look at the code again on page 3 the handout you'll see that extending an environment put a new frame on the beginning of the current environment literally kant's a new frame onto there and what's that frame do well that frame basically constructs together one of these pairings of a list of values in a list of variables being careful in this case to make sure that we have the right numbers to match up so you can see in

一个帧的列表，因此要扩展环境，我们只需在该列表的前面添加一个新帧。所以如果你再看一下讲义第3页的代码，你会看到扩展环境会将一个新帧放到当前环境的前面，字面上就是把一个新帧加到那里。那么这个帧是做什么的呢？基本上，这个帧将值列表和变量列表配对在一起，并在此过程中小心确保数量匹配，所以你可以看到在

numbers to match up so you can see in our concrete implementation extending an environment simply says create one of these frame structures as a pairing of two lists and put it on the front of the current list of frames. Now starting with that point as the environment in which we're going to do evaluation, so once we have an implementation, a concrete way of building environments, we need to use them. In particular, environments are there to help us look up values of variables, so we need to figure out how to write a procedure or set of procedures that will let us do that.

数量匹配，所以你可以看到在我们的具体实现中，扩展环境只是说创建这样一个帧结构，作为两个列表的配对，并将其放到当前帧列表的前面。现在，以这一点作为我们进行求值的环境，一旦我们有了实现，一种构建环境的具体方式，我们就需要使用它们。特别是，环境用于帮助我们查找变量的值，所以我们需要弄清楚如何编写一个或多个过程来实现这一点。

procedures that will let us do that in particular what do we do when we want to look up a variable in an environment well the first thing we know we want to do hierarchically is look for it in a frame so we'll take a frame the current frame and loop through the list of variables and the list of values in parallel

实现这一点的过程，特别是当我们要在环境中查找变量时该怎么做。首先，我们知道要按层次结构来做，先在帧中查找，所以我们将取一个帧，即当前帧，并同时遍历变量列表和值列表。

remember we store those as two separate lists so we simply walk down them in synchrony if we find the variable we're looking for it then we return that value associated with it if we get all the way through that pair of lists and do not

记住我们将它们存储为两个独立的列表，所以我们只需同步地向下遍历。如果我们找到了要找的变量，就返回与之关联的值。如果我们遍历完这对列表却没有找到，

Through that pair of lists and do not find the variable, then we know that there's not a binding for this variable in this frame. And what do we do? We move on to the next enclosing environment. And we know that this is just going to be manipulation of list structure because that's the way we represented it. So on the next slide, let's look at the piece of code that will do this for us.

遍历完这对列表却没有找到该变量，那么我们就知道这个帧中没有该变量的绑定。那我们该怎么办？我们转向下一个外层环境。我们知道这将是列表结构的操作，因为这就是我们表示它的方式。所以在下一张幻灯片上，让我们看看为我们完成这项工作的代码。

So to implement this idea in our particular structure, we just need two different looping mechanisms. The first one, and we're going to look up a variable value, is to have something that

因此，要在我们的特定结构中实现这个想法，我们只需要两种不同的循环机制。第一种，我们将查找变量值，是有一个东西

Variable value is to have something that loops over environment. So notice what environment does: it takes in an environment. If it's the empty environment, it complains, saying I can't find it, so it's an unbound variable. Otherwise, it's going to look in the first frame in that environment, and first frame, of course, is just going to grab the first element of that list.

变量值，是有一个东西在环境上循环。注意环境循环做什么：它接收一个环境。如果它是空环境，它会抱怨，说找不到，所以这是一个未绑定变量。否则，它将在该环境的第一个帧中查找，而第一个帧当然只是获取该列表的第一个元素。

If that doesn't work, we're going to expect it to work its way down to the next frame, and we'll see that. But environment loop basically walks its way down the environment looking for binding.

如果那不起作用，我们期望它向下一个帧移动，我们将会看到。但环境循环基本上是在环境中向下移动，寻找绑定。

down the environment looking for binding in each frame and notice what environment loop does having gotten the first frame out of this environment just grabbing that first element of the list it then runs another loop called scan.

在环境中向下移动，在每个帧中寻找绑定，注意环境循环在从环境中取出第一个帧后（只是获取列表的第一个元素），然后运行另一个称为扫描的循环。

that takes the frame variables which remember is a list and the frame values which remember is also a list gain just walking down and grabbing those two pieces of the list structure.

该循环接收帧变量（记住是一个列表）和帧值（记住也是一个列表），再次只是向下遍历并获取列表结构的这两个部分。

and what does scan do it basically walks down the two lists in unison if I run out of variables I must not have found a binding I'll go on to the next frame.

扫描做什么呢？它基本上同步地向下遍历两个列表。如果我耗尽了变量，那我一定没有找到绑定，我将继续到下一个帧。

binding I'll go on to the next frame. Notice that it calls environment loop again, going back up to the top-level loop with the enclosing environment, which we know means jump past the first frame and grab the remaining environments as a list.

绑定，我将继续到下一个帧。注意它再次调用环境循环，回到顶层循环，使用外层环境，我们知道这意味着跳过第一个帧，并将剩余的环境作为列表获取。

If in fact though we still have variables to check, then we look and see: is the next variable on my list the one I'm looking for? If it is, I return the next element on the values list. If it isn't, then I scan again, moving in synchrony down both the variables list and the values list to the next one down, and there's our two.

如果实际上我们仍有变量要检查，那么我们看看：我列表上的下一个变量是否是我要找的那个？如果是，我返回值列表的下一个元素。如果不是，那么我再次扫描，同步地沿着变量列表和值列表向下移动到下一个，这就是我们的两个循环。

the next one down and there's our two loops that let us look up the value of a variable both within a frame and if it's not bound there then in the next frame in the list. Of course, other aspects of manipulating variables in environments, for example setting a variable value, will have a very similar structure just like we can look up a variable. You can see if you look at the code that's setting a variable, we'll do the same kind of thing looking to find the binding and then changing and doing some mutation, and if of course it doesn't...

下一个，这就是我们的两个循环，让我们能够在帧内查找变量的值，如果在那里没有绑定，则在列表的下一个帧中查找。当然，操作环境中变量的其他方面，例如设置变量值，将具有非常相似的结构，就像我们可以查找变量一样。如果你查看设置变量的代码，你会看到我们会做同样的事情，找到绑定，然后进行更改并进行一些修改，如果当然它没有……

mutation and if of course it doesn't find when it complains and returns an error message other than that we now see how we can build environments just out of list structure using that to represent the pairings of names or symbols and values in that particular structure organization to get things going we need an initial environment also called the global environment this will be our default environment this is where we will normally evaluate expressions at least initially and therefore within this environment we need bindings for the built in names for

修改，如果当然它没有找到，它会抱怨并返回错误消息。除此之外，我们现在看到如何仅用列表结构构建环境，使用它来表示名称或符号与值的配对，在这种特定的结构组织中。为了开始，我们需要一个初始环境，也称为全局环境。这将是我们的默认环境，通常我们将在其中求值表达式，至少最初是这样，因此在这个环境中，我们需要为内置名称提供绑定，

需要为内置名称提供绑定，这也会是我们的兜底方案。这意味着，如果我们遍历所有环境寻找绑定，直到到达全局环境却仍未找到与变量关联的值，我们就会报错，称其为未绑定。

需要为内置名称提供绑定，这也会是我们的兜底方案。这意味着，如果我们遍历所有环境寻找绑定，直到到达全局环境却仍未找到与变量关联的值，我们就会报错，称其为未绑定。

现在记住，我们正在将环境表示为帧的列表。因此，为了得到初始环境，我们将取一个空环境（即空列表），并扩展它，构建一个单一帧。在此帧中，我们执行以下操作：取一组可能的内置原语名称和一个集合……

现在记住，我们正在将环境表示为帧的列表。因此，为了得到初始环境，我们将取一个空环境（即空列表），并扩展它，构建一个单一帧。在此帧中，我们执行以下操作：取一组可能的内置原语名称和一个集合……

built-in primitives and a set of procedures that are going to go with those and install them into the environment. If you look at the code on page 4 for our particular implementation, you'll see that we're going to rely on giving names to the built-in scheme primitives, things like car, cdr, or cons, plus, greater than, x, and all those sorts of pieces.

内置原语和一组与之对应的过程，并将它们安装到环境中。如果你查看第4页我们特定实现的代码，你会看到我们将依赖于为内置的Scheme原语命名，例如car、cdr或cons、加、大于、x等等这些。

Of course, we could have established a name of our choice to those built-in primitives, and we could have selected whichever things we want to have as to us as primitive elements. But the idea is to build a new frame in which we

当然，我们可以为这些内置原语选择我们自己的名称，也可以选择我们想要作为原语元素的东西。但想法是构建一个新帧，在其中我们……

idea is to build a new frame in which we have bindings of names to our primitive procedures. Notice will also create bindings for true and false to the boolean value Star teen star F in this environment as well, using the defined variable form. And then we'll simply return that environment as our initial environment.

其思路是构建一个新的框架，其中将名字绑定到我们的基本过程。注意，我们还会使用定义变量形式，在此环境中为 true 和 false 创建到布尔值 Star teen star F 的绑定。然后，我们只需将该环境作为初始环境返回。

If this is not certain to you, check out the code to see how we do it. It's pretty straightforward. To interact with our evaluator, we need some mechanism for getting expressions into it. And for this, we build a simple little driver loop, so as often known as an REP.

如果你对此不太确定，可以查看代码了解我们如何实现。这相当直接。为了与我们的求值器交互，我们需要某种机制将表达式输入其中。为此，我们构建一个简单的驱动循环，通常称为 REP。

driver loop so as often known as an r EP or read eval print loop in which it runs through this constant cycle of reading in an expression evaluating it using the interpreter then printing out the result and going back around and reading in the next expression and indeed if you look at this little piece of code you can see that it runs through exactly that loop it prints out some prompt on the screen to say I'm ready reason an expression using schemes read a procedure then interprets that using our evaluator starting in the global environment

驱动循环，通常称为 REP 或读-求值-打印循环，它不断循环：读取一个表达式，使用解释器对其进行求值，然后打印结果，再回到起点读取下一个表达式。事实上，如果你查看这段小代码，可以看到它正是按照这个循环运行的：它在屏幕上打印一些提示符，表示我已准备好读取一个表达式，使用 Scheme 的 read 过程读取，然后使用我们的求值器从全局环境开始对其进行解释。

starting in the global environment exactly where we expect it to be. It then tells us we're going to give us an answer and prints out that answer and goes back around. Simple little loop that lets us read expressions, evaluate them with respect to the global environment, and print out the result.

从全局环境开始，这正是我们期望的位置。然后它告诉我们它将给出一个答案，并打印出该答案，然后回到循环。这个简单的循环让我们能够读取表达式，相对于全局环境对其进行求值，并打印结果。

And with that, we've now built an evaluator. It has all of the pieces. It has the capability of dealing with eval and apply to unwrap the abstractions in order to get down to basic expressions. It has some syntax for telling us how to write

至此，我们已经构建了一个求值器。它拥有所有组成部分。它具备处理 eval 和 apply 的能力，以解开抽象，直达基本表达式。它有一些语法规则，告诉我们如何书写

关于如何书写，这里有一些语法规则需要遵循。

关于如何书写，这里有一些语法规则需要遵循。

some syntax for telling us how to write legal expressions in that language which is cleanly separated out from the semantics of eval and apply and then it has very particular ways of implementing environments to store our bindings of values and variables and a way to actually get input into and out of that evaluator

一些语法规则，告诉我们如何书写该语言中的合法表达式，这些规则与 eval 和 apply 的语义清晰分离。然后，它有非常特定的方式来实现环境，以存储值和变量的绑定，以及一种实际将输入和输出送入和送出该求值器的方法。

so there you have it we've built an evaluator we've actually built a full-blown and scheme evaluator Val and apply in all its grandeur E and while we throw in a lot of code at you you should be able to look at the pieces and see the higher-level issues we've

所以，就是这样，我们构建了一个求值器。我们实际上构建了一个完整的 Scheme 求值器，eval 和 apply 以其全部辉煌呈现。虽然我们向你抛出了大量代码，但你应该能够审视各个部分，看到我们讨论过的高层问题。

### 10. Lexical vs. Dynamic Scoping and Tight Coupling of Eval/Apply (词法作用域与动态作用域，以及 Eval/Apply 的紧密耦合)

And see the higher-level issues we've talked about here having done that, we can now step back and ask some questions about choices that were made in designing this evaluator. In particular, we've said much earlier in the term that Scheme, and therefore the evaluator we've just built, uses lexical scoping. Now, what does that mean?

并看到我们在此讨论过的高层问题。完成这些之后，我们现在可以退后一步，询问在设计这个求值器时所做的选择。特别是，我们在学期初就说过，Scheme（因此我们刚刚构建的求值器）使用词法作用域。那么，这意味着什么？

Well, think about what happens when we apply a procedure to a set of arguments. Again, if we look at it a little bit more carefully, the evaluator says we're gonna get the values of the arguments and the value of the procedure itself, and then we're going to

嗯，想想当我们把一个过程应用于一组参数时会发生什么。如果我们更仔细地看一下，求值器会说我们将获取参数的值和过程本身的值，然后我们将

procedure itself and then we're going to create a new environment in which the variables of the procedure, the parameters of the procedure are bound to the arguments passed in and relative to that environment we're going to evaluate the body of the procedure. Okay, now what happens inside that body? In particular, that body will be an expression that contains lots of names, and the issue is how do we find the values associated with those names? Well, first of all, we know any value that was a formal parameter of that procedure gets its value from the frame we just created.

过程本身的值，然后我们将创建一个新环境，其中过程的变量（即参数）绑定到传入的参数，并相对于该环境求值过程体。好的，现在过程体内部会发生什么？特别是，该过程体将是一个包含许多名字的表达式，问题是如何找到与这些名字关联的值。首先，我们知道任何作为该过程形式参数的值，其值来自我们刚刚创建的框架。

value from the frame we just created. Those are called bound parameters. But any variable in that body that is not one of the formal parameters is known as a free variable.

值来自我们刚刚创建的框架。这些被称为绑定参数。但该过程体中任何不是形式参数的变量被称为自由变量。

How do we find the bindings for those? What we said is that when we have a procedure that has free variables, the values that they get are taken to refer to the bindings made by enclosing procedure definitions.

我们如何找到这些变量的绑定？我们说过，当一个过程有自由变量时，它们所获得的值被认为是指向外围过程定义所做的绑定。

In other words, they're looked up in the environment in which the procedure was defined. Or said another way, it says we walk up that chain of environments.

换句话说，它们是在定义该过程的环境中查找的。或者换一种说法，它说我们沿着环境链向上走。

walk up that chain of environments, looking for a binding of the variable, and we know that chain of environments comes from sets of procedures. So if our procedures defined inside of a procedure, we know that if we can't find a scoping a formal parameter binding for the particular thing we're looking for in the initial in lambda, we go outside of that lambda to the next enclosing lambda looking for that.

沿着环境链向上走，寻找变量的绑定，我们知道这条环境链来自一系列过程。因此，如果我们的过程定义在另一个过程内部，我们知道如果在初始 lambda 中找不到我们正在寻找的特定东西的形式参数绑定，我们就到该 lambda 之外，到下一个外层 lambda 中寻找。

Therefore, if you like the boundaries of the lambda expressions define the chain of frames are going to see in our environment and that's how we're actually going to capture our.

因此，如果你愿意，lambda 表达式的边界定义了我们在环境中会看到的框架链，这就是我们实际捕获词法环境以确定变量绑定的方式。

we're actually going to capture our lexical environment to determine bindings of variables. How does this happen in practice? Well, look at the code in a particularly cat make procedure, which you'll find on page 3 of the handout.

我们实际上将捕获我们的词法环境以确定变量的绑定。这在实践中是如何发生的？看看代码，特别是 make-procedure，你可以在讲义的第 3 页找到。

it glues together a tag or label, the actual parameters, the body, and the environment in which it's evaluated. As a consequence, the evaluation environment is stored away and is always going to be the enclosing lexical scope.

它将一个标签或标记、实际参数、过程体以及求值它的环境粘合在一起。因此，求值环境被存储起来，并且始终是外围的词法作用域。

it's going to tell us where to look to find a binding for a variable if we don't find it as a formal parameter of.

它将告诉我们，如果我们没有找到作为形式参数的绑定，去哪里寻找变量的绑定。

Don't find it as a formal parameter of the actual procedure. Why? Well, that was just the choice you made for our semantic rules for procedure application. What did we say to do? Hang a new frame, bind the parameters to the actual arguments in that new frame, and evaluate the body in this new environment.

没有找到作为实际过程的形式参数的绑定。为什么？嗯，那只是我们为过程应用语义规则所做的选择。我们说了什么？挂一个新框架，将参数绑定到该新框架中的实际参数，并在该新环境中求值过程体。

That was our environment model, and we've made a choice that says we will scope together frames based on where the procedures were actually valuated. So let's remind ourselves of how that works in our evaluator; this is going back over the environment model.

那是我们的环境模型，我们做了一个选择，即根据过程实际求值的位置来将框架组合在一起。所以让我们提醒自己这在我们的求值器中是如何工作的；这要回到环境模型。

Going back over the environment model, but we've now built a very particular implementation of that in our eval and apply. So let's define foo to be a procedure that has a body and other procedure, and of course in the environment model we know what happens. Evaluation of this expression will create a binding for foo in the global environment, that's where we're interacting with the read eval print loop, and that is bound to the procedure that we get with one argument x and y, coming from that hidden lambda. Remember that it's de-sugaring of the syntax.

回到环境模型，但我们现在已经在 eval 和 apply 中构建了一个非常具体的实现。因此，让我们将 foo 定义为一个具有函数体和另一个过程的过程，当然，在环境模型中我们知道会发生什么。对这个表达式的求值将在全局环境中为 foo 创建一个绑定，那正是我们与读取-求值-打印循环交互的地方，并且它被绑定到我们通过一个参数 x 和 y 得到的过程，该过程来自那个隐藏的 lambda。记住，这是语法的去糖化。

that it's d sugaring of the syntax we'll convert this into a defined foo of lambda of X Y and then a body evaluation of the lambda creates that double bubble with an environment pointer back to the global environment since that's where we evaluated the lambda whose parameters are x and y and whose body is itself another lambda remember again we have not evaluated this lambda yet now let's apply foo to a couple of arguments and give the result the name Bar foo of course drops a new frame or hangs it if you like scoped by the same place the procedure says

这是语法的去糖化，我们会将其转换为一个定义的 foo，即 lambda (X Y)，然后对函数体求值。对 lambda 的求值会创建那个双气泡，其环境指针指回全局环境，因为那正是我们求值 lambda 的地方，其参数是 x 和 y，其函数体本身是另一个 lambda。再次记住，我们还没有对这个 lambda 求值。现在让我们将 foo 应用于几个参数，并将结果命名为 Bar。foo 当然会放下一个新框架，或者如果你愿意，可以挂起它，其作用域由过程所指示的同一位置决定。

The same place the procedure says, namely up to the global environment. Inside of there we bind the parameters x and y to the values 1 and 2. Notice in our implementation that's done has two lists: lists of X Y in the list 1 2.

过程所指示的同一位置，即直到全局环境。在其中，我们将参数 x 和 y 绑定到值 1 和 2。注意，在我们的实现中，这是通过两个列表完成的：列表 X Y 和列表 1 2。

Then relative to this frame we evaluate the body, and the body of this procedure is another lambda, so we created scoped by this frame, since that's where we did the evaluation. And bar is bound to the result of that whole thing, which is that particular procedure.

然后相对于这个框架，我们求值函数体，而这个过程的函数体是另一个 lambda，因此我们创建了由这个框架作用域限定的过程，因为那正是我们进行求值的地方。Bar 被绑定到整个过程的结果，即那个特定的过程。

So now let's go ahead and apply bar, our environment.

所以现在让我们继续应用 bar，我们的环境。

ahead and apply bar our environment

继续应用 bar，我们的环境。

Ahead and apply our environment model now as a consequence our eval apply that we've built basically says get the value bar which is a procedure and apply it by dropping a frame whose enclosing environment is the same thing that procedures in closing environment was relative to which we bind the parameter Z to the input argument 3 and relative to which we evaluate plus XYZ or the body of that procedure. Notice we are now evaluating XYZ with respect to e 2 which says we'll get the binding for Z from this frame it was scoped lexically by the procedure, the sub or the lambda.

继续应用我们的环境模型。现在，作为结果，我们构建的 eval apply 基本上是说：获取值 bar，它是一个过程，并通过放下一个框架来应用它，该框架的封闭环境与过程的封闭环境相同，相对于该环境我们将参数 Z 绑定到输入参数 3，并相对于该环境我们求值 + X Y Z 或该过程的函数体。注意，我们现在相对于 e2 求值 X Y Z，这意味着我们将从该框架获取 Z 的绑定，该框架由过程（即子过程或 lambda 本身）在词法上限定。

by the procedure the sub or the lambda rather itself but to get the bindings for x and y we will move up the chain to the next enclosing environment which comes from the enclosing lambda buried inside of the foo notice as well to get the value of + we move up from E to through u in V 1 up to the global environment to get its binding that is the ultimate enclosing scope into which we can find a parameter binding

由过程（即子过程或 lambda 本身）在词法上限定，但要获取 x 和 y 的绑定，我们将沿着链向上移动到下一个封闭环境，该环境来自隐藏在 foo 内部的封闭 lambda。还要注意，为了获取 + 的值，我们从 E 向上通过 u 和 V 1 直到全局环境，以获取其绑定，那是我们可以找到参数绑定的最终封闭作用域。

as a consequence we can see that we will always evaluate the expression + x/y/z that body of that procedure in a new environment inside the surrounding

因此，我们可以看到，我们总是在一个新的环境中求值表达式 + X/Y/Z，即该过程的函数体，该环境位于周围环境内部。

environment inside the surrounding lexical environment every time we apply this procedure we're going to hang a new frame that will always scope back to e1 e1 is therefore our surrounding lexical environment we will always get the same bindings for x and y

环境位于周围的词法环境内部。每次我们应用这个过程时，我们都会挂起一个新的框架，该框架将始终作用域回 e1。因此，e1 是我们的周围词法环境，我们将始终获得相同的 x 和 y 绑定。

now that was a particularly made but it's not the only way to do evaluation an alternative way to get bindings for free variables would be to look them up in the caller's environment meaning in the environment that is corresponding to the procedure actually asking for them rather than in实际上是在向他们索取，而不是给予。

现在，那是一种特殊的做法，但并不是求值的唯一方式。另一种获取自由变量绑定的方式是在调用者的环境中查找它们，即在对应于实际请求它们的过程的环境中查找，而不是在周围的词法环境中查找。

actually asking for them rather than in the surrounding lexical environment the surrounding lexical environment the one we just saw which is inherited from when the procedure was created this will lead to different behavior this is known as dynamic scoping because it is based on the actual values in place when the caller asks for them this model then leads to a different behavior for

实际上是在向他们索取，而不是在周围的词法环境中，即我们刚刚看到的那个从过程创建时继承的环境。这将导致不同的行为，这被称为动态作用域，因为它基于调用者请求它们时的实际值。这种模型随后会导致不同的行为。

example we could define pou to be a procedure one argument X whose body calls bear on xx notice no explicit reference to X here we could define bear to be a procedure of one argument Y which adds X to Y notice there's no

例如，我们可以将 pou 定义为一个过程，带一个参数 X，其函数体调用 bear 于 xx，注意这里没有显式引用 X。我们可以将 bear 定义为一个过程，带一个参数 Y，它将 X 加到 Y，注意这里没有显式的 X 参数。

This adds X to Y. Notice there's no explicit parameter for X here, so bear needs to get it from somewhere else. But if we call Phu on the value 9, it will then take bear applied to xx and give it as well the value of X now passed in as 9 in order to get 29 out. This may look strange. Think about whether this would work under normal lexical scoping under the evaluation we're used to, and the answer, of course, would be no.

这将 X 加到 Y。注意这里没有显式的 X 参数，因此 bear 需要从其他地方获取它。但是，如果我们对值 9 调用 Phu，它将把 bear 应用于 xx，并同样给出 X 的值，现在作为 9 传入，以便得到 29。这可能看起来很奇怪。想想这在正常的词法作用域下，在我们习惯的求值方式下是否可行，答案当然是否定的。

But we're now changing the behavior. We're asking Pou, when it is used, to get the value of X passed in, which is 9. And when it is used, we are altering the standard evaluation context to ensure this works as described.

但我们现在正在改变行为。我们要求 Pou 在被使用时获取传入的 X 的值，即 9。并且当它被使用时，我们正在改变标准求值上下文以确保这按描述工作。

value of x passed in which is 9 and when we pass it on to bear bear is then saying use the value of x that is in place when I asked for it not the one that is inherited by the lexical scoping.

传入的 x 的值是 9，当我们将其传递给 bear 时，bear 然后说：使用当我请求它时在位的 x 的值，而不是由词法作用域继承的那个。

suppose we want to change our evaluator to use dynamic scoping rather than lexical school what would it do first of all conceptually to the environment model well here's our sequence of things we want to evaluate.

假设我们想要改变我们的求值器以使用动态作用域而不是词法作用域。首先，从概念上讲，它对环境模型会做什么？嗯，这是我们想要求值的一系列事情。

the first thing to notice is when we define pou to be a procedure of one argument X notice we don't need the double bubble anymore that second part

首先要注意的是，当我们定义 pou 为一个带一个参数 X 的过程时，注意我们不再需要双气泡了，那第二部分。

double bubble anymore that second part of the bubble was around to tell us what was the enclosing environment in which the lambda was evaluated but now we don't need that because we're not going to pass that down so defining pou will simply create a procedure that a single argument X and a body and that's all we need to use to represent it.

双气泡不再需要了，气泡的第二部分是为了告诉我们求值 lambda 时的封闭环境，但现在我们不需要了，因为我们不会传递它。因此，定义 pou 将简单地创建一个过程，带一个参数 X 和一个函数体，这就是我们表示它所需的全部。

similarly defining Bayer will give us a procedure one argument Y whose body is the list X Y but no enclosing environment pointer it's no longer necessary under this way of thinking about things now let's apply proof to

类似地，定义 Bayer 将给我们一个过程，带一个参数 Y，其函数体是列表 X Y，但没有封闭环境指针。在这种思考方式下，它不再必要。现在让我们将 proof 应用于……

About things now let's apply proof to some argument. Applying pow under this new model says: drop a frame in which we bind a formal parameter X to the value 9, passed in, and that frame gets scoped by the caller's environment, which in this case happens to be the global environment. That's where we're asking for things; it looks much like before.

现在让我们将证明应用于某个论证。在这个新模型下应用幂运算意味着：丢弃一个框架，在其中我们将形式参数 X 绑定到传入的值 9，并且该框架由调用者的环境（在此恰好是全局环境）限定作用域。这就是我们请求事物的方式；看起来与之前非常相似。

Now, relative to that frame, we're going to evaluate the body of proof, and the body of proof says: apply bar to Y. So in this case, we're going to apply a procedure; we're going to build a frame whereby Y...

现在，相对于那个框架，我们将评估证明的主体，而证明的主体是：将 bar 应用于 Y。因此，在这种情况下，我们将应用一个过程；我们将构建一个框架，其中 Y...

we're going to build a frame whereby Y

我们将构建一个框架，其中 Y

we're going to build a frame whereby Y is bound to 20 as before but now the scoping environment is given to point towards the environment that was in place when the caller was asked or in other words it points to e1 it does not inherit the environment that was there when Bear was actually created but rather it points to who asked for it and in this case we can then evaluate the body plus XY therefore looking up the value of Y passed in that's an argument to bear and inheriting the value of x that was passed in when we evaluated Pooh the key thing to note is that we

我们将构建一个框架，其中 Y 像之前一样绑定到 20，但现在作用域环境被设置为指向调用者被请求时所在的环境，换句话说，它指向 e1；它不继承 Bear 实际创建时的环境，而是指向谁请求了它。在这种情况下，我们可以评估主体 plus XY，因此查找传入的 Y 的值作为 bear 的参数，并继承我们在评估 Pooh 时传入的 x 的值。关键要注意的是，我们

Pooh the key thing to note is that we will evaluate the expression plus XY in an environment that extends the callers environment.

Pooh 关键要注意的是，我们将在扩展调用者环境的环境中评估表达式 plus XY。

This means if we call this a different time we will have a different environment and that's very different than the lexical case in which this would always point back to the environment that was created when the procedure itself was created.

这意味着如果我们再次调用它，我们将有一个不同的环境，这与词法情况非常不同，在词法情况下，这总是会指向过程创建时创建的环境。

So we can see we can get a very different behavior which will have some advantages and some disadvantages compared to normal lexical scoping we'll come back later to the

因此，我们可以看到，与正常的词法作用域相比，我们可以获得非常不同的行为，这将有一些优点和一些缺点。我们稍后会回到

Scoping，我们稍后会回来讨论为什么人们希望采用动态绑定而非词法绑定的问题。这只是在语言性能方面产生了不同。我们这里想要展示的关键点是，做出这种改变是多么简单，尤其是我们对求值器进行了非常少量的修改。

作用域，我们稍后会回来讨论为什么人们希望采用动态绑定而非词法绑定的问题。这只是在语言性能方面产生了不同。我们这里想要展示的关键点是，做出这种改变是多么简单，尤其是我们对求值器进行了非常少量的修改。

首先，当我们评估一个lambda表达式时，我们会像之前一样创建一个过程，但现在我们不需要包含封闭环境。正如你所见，我们不制作双重气泡，而是制作单一气泡。

首先，当我们评估一个 lambda 表达式时，我们会像之前一样创建一个过程，但现在我们不需要包含封闭环境。正如你所见，我们不制作双重气泡，而是制作单一气泡。

double bubble we make a single bubble so when we make a procedure we simply pass in a symbol that says there is no environment here. The second change occurs when we go about actually applying a procedure something we've built with a lambda to a set of arguments. Remember in the previous case what we did was get the value of the operator, get the value of the operands as a list, and then apply them. An application there meant that we would evaluate the body of the procedure in a new environment, extending the environment part of the procedure with a frame that

双重气泡，我们制作单一气泡，所以当我们创建一个过程时，我们只需传入一个符号，表示这里没有环境。第二个变化发生在我们实际应用一个过程时，即我们用 lambda 构建的东西应用于一组参数。记住，在之前的情况下，我们所做的是获取运算符的值，获取操作数的值作为列表，然后应用它们。那里的应用意味着我们将在新环境中评估过程的主体，该环境通过一个框架扩展过程的环境部分，该框架

part of the procedure with a frame that had bindings for parameters two arguments here we don't do that here our application says get the value of the operator get the list of values of the operands and then apply that operator to those values in the current environment

过程的环境部分，该框架具有参数到参数的绑定；在这里我们不这样做，我们的应用说获取运算符的值，获取操作数值的列表，然后在当前环境中将该运算符应用于这些值。

we've added one more argument to our apply and the only other change we need to do is to build a dynamic apply rather than our standard meta-circular apply here apply takes in a procedure a list of arguments and an environment the environment that the caller is coming

我们向 apply 添加了一个参数，我们唯一需要的其他更改是构建一个动态 apply，而不是我们标准的元循环 apply；这里 apply 接受一个过程、一个参数列表和一个环境，即调用者来自的环境。

environment that the caller is coming from, what does it do if it's a primitive? From what does it do if it's a primitive? It does it just like before, if it's a compound procedure that is an application of something we built with a lambda, we will as before evaluate the body to expect to be a sequence in an environment, but here the environment comes from extending the in calling environment rather than the procedures environment itself.

调用者来自的环境，如果它是原语，它做什么？如果它是原语，它做什么？它像之前一样做；如果它是一个复合过程，即我们用 lambda 构建的东西的应用，我们将像之前一样评估主体，期望在环境中是一个序列，但这里的环境来自扩展调用环境，而不是过程本身的环境。

Remember under dynamic scoping, the procedure doesn't keep track of the environment in which it was created, but rather when we want to extend something, we extend the environment that

记住，在动态作用域下，过程不跟踪它创建时的环境，而是当我们想要扩展某物时，我们扩展环境，即

something we extend the environment that was in place when we asked for this value the key thing we want you to see here is an incredibly small number of changes to eval and apply dramatically change the way in which variables are looked up this goes from lexical scoping to dynamic scoping with two or three very simple changes.

某物，我们扩展当我们请求这个值时所在的环境。这里的关键点是，对 eval 和 apply 的极少量更改戏剧性地改变了变量查找的方式；这通过两三个非常简单的更改从词法作用域变为动态作用域。

in some sense this was the whole point of this little example of dynamic scoping it leads to a different kind of behaviors we're thinking about what advantages one gets by having that way of looking things up.

在某种意义上，这正是这个动态作用域小例子的全部意义；它导致了不同类型的行为，我们正在思考通过那种查找方式能获得什么优势。

by having that way of looking things up, but notice what we've really done by making a few small changes to eval and apply, we've changed the semantics of the language. That's exactly the point of having an eval on the fly. By creating those, we're defining what it means to evaluate expressions in a language.

通过那种查找方式，但注意我们真正所做的，通过对 eval 和 apply 做几个小更改，我们改变了语言的语义。这正是拥有即时 eval 的意义。通过创建这些，我们定义了在语言中评估表达式的含义。

Notice the second point: by cleanly separating out the syntax from the semantics, we've enabled that kind of change very easily. By putting in the data abstractions, the syntax—the legal way of writing expressions in our language—is left separate from the semantics.

注意第二点：通过将语法与语义干净地分离，我们使得这种更改非常容易。通过引入数据抽象，语法——我们语言中表达式的合法书写方式——与语义保持分离。

language is left separate from the actual way in which they're interpreted. And here we can actually change the rules for interpretation without having to change the syntax. We're going to come back to this idea of having different ways of evaluating things and looking at the implications of those changes in terms of the behavior of the language in the...

语言与它们被解释的实际方式保持分离。在这里，我们实际上可以更改解释规则而不必更改语法。我们将在后续课程中回到这种具有不同评估方式的想法，并从语言行为的角度审视这些更改的含义。