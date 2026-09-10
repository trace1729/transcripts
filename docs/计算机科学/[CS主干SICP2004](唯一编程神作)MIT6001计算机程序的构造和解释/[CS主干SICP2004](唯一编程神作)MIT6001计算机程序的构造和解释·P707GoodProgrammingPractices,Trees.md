# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=7)

## Summary (摘要)

- The lecture outlines a systematic approach to designing code, emphasizing the separation of data structures, computational modules, and interfaces, with each module having clear inputs and outputs.
- Proper documentation is stressed as crucial for maintainability, helping to clarify the goal, argument types, constraints, and stages of procedures, and serving as a contract for verification.
- Debugging is presented as a skill that involves identifying common error types such as unbound variables, syntax errors, and structural errors, and using tools like display expressions, tracers, and the Stepper to isolate and fix issues.
- Types are introduced as a powerful tool for designing and debugging procedures, demonstrated through the repeated procedure, where type signatures guide the construction of base and recursive cases.
- The lecture extends to tree data structures, defining them as lists of lists with recursive structure, and shows how to implement and trace procedures like count-leaves and tree-map by mirroring the data structure's recursion.
- Inductive reasoning is used to verify procedures like map on lists and count-leaves on trees, ensuring correctness by base cases and recursive steps.

- 本讲座概述了一种系统化的代码设计方法，强调数据结构、计算模块和接口的分离，每个模块都有明确的输入和输出。

适当的文档对于可维护性至关重要，有助于明确过程的目标、参数类型、约束和阶段，并作为验证的契约。

调试被视为一种技能，涉及识别常见错误类型，如未绑定变量、语法错误和结构错误，并使用显示表达式、跟踪器和步进器等工具来隔离和修复问题。

类型被引入作为设计和调试过程的强大工具，通过重复过程进行演示，其中类型签名指导基础案例和递归案例的构建。

讲座进一步扩展到树数据结构，将其定义为具有递归结构的列表的列表，并展示了如何通过镜像数据结构的递归来实现和跟踪诸如count-leaves和tree-map等过程。

归纳推理用于验证诸如列表上的map和树上的count-leaves等过程，通过基础案例和递归步骤确保正确性。

## Outline (大纲)

1. Introduction to Good Programming Practices
2. Designing Data Structures, Modules, and Interfaces
3. Documentation Practices and Code Refinement
4. Debugging: Common Errors and Basic Tools
5. Structural Errors and Debugging Tools
6. Stepper and Sine Approximation Case Study
7. Using Types for Design and Debugging
8. Type Checks and Inductive Reasoning on Lists
9. Defining Trees and Their Type
10. Implementing and Tracing count-leaves and tree-map

1. 良好编程实践简介
设计数据结构、模块和接口
文档实践与代码改进
调试：常见错误和基本工具
结构错误和调试工具
步进器和正弦逼近案例研究
使用类型进行设计和调试
类型检查和列表上的归纳推理
定义树及其类型
实现和跟踪count-leaves和tree-map

## Transcript (文稿)

### 1. Introduction to Good Programming Practices (良好编程实践简介)

In the past few lectures we've seen a series of tools for helping us create procedures to compute a variety of computational processes. Before we move on to more complex issues in computation, it's useful to step back and look at the more general issues involved in the process of actually creating procedures.

在过去的几讲中，我们介绍了一系列工具，帮助我们创建过程来计算各种计算过程。在我们继续讨论更复杂的计算问题之前，退一步看看在实际创建过程中涉及的更一般的问题是很有用的。

In particular, we want to spend a little bit of time talking about good programming practices. This sounds a little bit like lecturing about motherhood and apple pie—that is, a bit like talking about things that seem

特别是，我们想花一点时间讨论良好的编程实践。这听起来有点像在说教母性和苹果派——也就是说，有点像在谈论那些看似

like talking about things that seem obvious apparent and boring in that everybody understands and accepts them however it's surprising how many quote experienced end quote programmers don't execute good programming practices and we want to get you started on the right track thus in this lecture we're going to look briefly at several methodological aspects of creating procedures designing the components of our code debugging our code when it doesn't run correctly writing documentation for our code and testing our code we'll highlight some standard

就像在谈论那些看似显而易见、无聊且人人都理解并接受的事情，然而令人惊讶的是，有多少所谓的“有经验的”程序员并没有执行良好的编程实践，我们想让你走上正确的轨道。因此，在本讲中，我们将简要探讨创建过程的几个方法论方面：设计代码的组件、在代码运行不正确时调试代码、为代码编写文档以及测试代码。我们将强调每个阶段的一些标准做法，并指出这些做法为何能导致高效且有效的代码生成。

Our code will highlight some standard practices for each stage and indicate why these practices lead to efficient and effective generation of code.

我们的代码将强调每个阶段的一些标准做法，并指出这些做法为何能导致高效且有效的代码生成。

### 2. Designing Data Structures, Modules, and Interfaces (设计数据结构、模块和接口)

Let's start with the issue of how to design code given a problem statement. There are many ways to do this, but most of them involve some combination of the following steps: design of data structures, design of computational modules, and design of interfaces between the modules.

让我们从如何根据问题陈述来设计代码的问题开始。有很多方法可以做到这一点，但大多数方法都涉及以下步骤的某种组合：数据结构的设计、计算模块的设计以及模块之间接口的设计。

Once we've laid out the general design of those stages, we follow by creating specific instantiation of the actual components. Now we've not yet

一旦我们制定了这些阶段的一般设计，我们就接着创建实际组件的具体实例化。现在我们还没有

the actual components now we've not yet talked about data structures in scheme and we'll return to that issue in a few lectures for our purposes here the key thing to note is that when designing a computational system it is extremely valuable to decide what kinds of information naturally should be grouped together and to then create structures that perform that grouping while maintaining interfaces to the structures that hide the details for example one things naturally of a vector is a pairing of an X and y coordinate one wants to be able to get out the

实际组件，现在我们还没有讨论Scheme中的数据结构，我们将在几讲后回到这个问题。就我们这里的目的而言，关键要注意的是，在设计计算系统时，决定哪些类型的信息自然应该分组在一起，然后创建执行这种分组的结构，同时保持隐藏细节的接口，这是极其有价值的。例如，一个向量自然地被看作是x和y坐标的配对，人们希望能够

Wants to be able to get out the coordinates when needed, but in many cases one thinks naturally of manipulating a vector as a unit. Similarly, one can imagine aggregating together a set of vectors to form a polygon, and again one can think of manipulating the polygon as a unit. Thus, a key stage in designing a computational system is determining the natural data structures of the system.

在需要时能够取出坐标，但在许多情况下，人们自然地认为将向量作为一个整体来操作。类似地，可以想象将一组向量聚合在一起形成一个多边形，并且同样可以将多边形作为一个整体来操作。因此，设计计算系统的关键阶段是确定系统的自然数据结构。

A second stage in designing a computational system is deciding how best to break the computation into modules or pieces. This is often as much art as science, but there are some

设计计算系统的第二个阶段是决定如何最好地将计算分解为模块或部分。这往往既是艺术也是科学，但有一些

much art as science but there are some general guidelines that help us separate out modules in our design for example is there part of the problem that defines a computation that is likely to be used many times are there parts of the problem that can be conceptualized in terms of their behavior for example how they convert certain inputs into certain types of outputs without worrying about the details of how it is done does this help us focus on other parts of the computation or set a bit differently can one identify parts of the computation in

既是艺术也是科学，但有一些一般性指导方针可以帮助我们在设计中分离模块。例如，问题中是否有定义计算的部分可能被多次使用？是否有部分可以根据其行为来概念化，例如它们如何将某些输入转换为某些类型的输出，而不必担心如何完成的细节？这是否帮助我们专注于计算的其他部分，或者换一种说法，能否识别计算中

computation or set a bit differently can one identify parts of the computation in

计算或换一种说法，能否识别计算中

One identify parts of the computation in terms of their role and think about that role in the overall computation without having to know details of the actual computation. If one can these components are then good candidates for separate modular components of the design since we can focus on their use while ignoring the details of how they actually achieve that computation. Finally, given that one can identify data structures whose information is to be manipulated and stages of computation in which that information is transformed, one wants to.

能否根据其角色来识别计算的部分，并在整体计算中考虑该角色，而不必知道实际计算的细节。如果可以，这些组件就是设计中独立模块组件的好候选，因为我们可以专注于它们的使用，而忽略它们实际实现该计算的细节。最后，鉴于可以识别其信息要被操作的数据结构以及该信息被转换的计算阶段，人们希望

Information is transformed. One wants to decide the overall flow of information between the modules. What types of inputs does each module need? What types of data does each model return? How does one ensure that the correct types are provided in the correct order?

信息被转换。人们需要决定模块之间信息的整体流动。每个模块需要什么类型的输入？每个模型返回什么类型的数据？如何确保以正确的顺序提供正确的类型？

These kinds of questions need to be addressed in designing the overall flow between the modules. This is perhaps more easily seen by thinking about an example. And in fact, you've already seen one such example: our implementation of squirt.

在设计模块之间的整体流动时，需要解决这类问题。这或许通过思考一个例子更容易理解。事实上，你已经见过这样一个例子：我们实现的 squirt。

When we implemented our method for square roots, we actually engaged in many.

当我们实现平方根的方法时，我们实际上参与了多个阶段。

square roots, we actually engaged in many of these stages. We didn't worry about data structures, since we're simply interested in numbers. We did, however, spend some effort in separating out modules. Remember, our basic computation was: we start with a guess; if it's good enough, we stop; otherwise, we make a new guess by averaging the current guess and the ratio of the target number and the guess, and continue.

平方根，我们实际上参与了这些阶段中的许多。我们不必担心数据结构，因为我们只对数字感兴趣。然而，我们确实花了一些精力来分离模块。记住，我们的基本计算是：我们从一个猜测开始；如果它足够好，我们就停止；否则，我们通过平均当前猜测和目标数与猜测的比值来生成新猜测，并继续。

To design this system, we separated out several modules: the notion of averaging, the notion of measuring good enough. For example, we saw...

为了设计这个系统，我们分离出几个模块：平均的概念、衡量足够好的概念。例如，我们看到……

measuring good enough for example we saw that some of these modules might themselves rely on other procedural abstractions for example our particular version of good enough needed to use the absolute value procedure though other versions might not

衡量足够好，例如我们看到其中一些模块可能自身依赖于其他过程抽象，例如我们特定版本的 good enough 需要使用绝对值过程，尽管其他版本可能不需要。

once we had separated out these notions of different computations average and good enough we considered the overall flow of information through those modules note by the way that we can consider each of these processes as a blackbox abstraction meaning that we can focus on using these procedures without having to

一旦我们分离出这些不同计算（average 和 good enough）的概念，我们就考虑了信息在这些模块中的整体流动。顺便注意，我们可以将每个过程视为一个黑箱抽象，这意味着我们可以专注于使用这些过程，而不必……

using these procedures without having to have already designed the specific implementation of each now what about the flow between these modules in our case we began with a guess and tested to see if it was good enough if it was we could then stop and just return the value of the guess

使用这些过程而不必已经设计好每个过程的具体实现。现在，关于这些模块之间的流动，在我们的例子中，我们从一个猜测开始，并测试它是否足够好；如果是，我们就可以停止并返回猜测的值。

if it was not then we needed to average the current guess and the ratio of our target number to the gas and then we needed to repeat the entire process with this new value as our new guess

如果不是，那么我们需要平均当前猜测和目标数与猜测的比值，然后需要用这个新值作为新猜测重复整个过程。

the point of laying out these modules or black boxes is that we can then use them to decide how to

布置这些模块或黑箱的意义在于，我们可以利用它们来决定如何……

can then use them to decide how to divide up the code and how to isolate details of a procedure from its use as we saw when we implemented our scored procedure. We can change details of a procedure such as average without having to change any of the procedures that use that particular component as well.

可以利用它们来决定如何划分代码，以及如何将过程的细节与其使用隔离开来，正如我们在实现 scored 过程时所看到的。我们可以更改过程的细节，例如 average，而不必更改使用该特定组件的任何过程。

The flow of information between the modules helps guide us in the creation of the overall set of procedures. Thus, when faced with any new computational problem, we want to try to engage in the same exercise: block out chunks of the

模块之间的信息流动有助于指导我们创建整体过程集。因此，面对任何新的计算问题时，我们应尝试进行同样的练习：划分出计算的块……

exercise block out chunks of the computation that can be easily isolated identify the inputs and outputs it from each chunk and lay out the overall flow of information through the system then we can turn to implementing each of the units separately and testing the entire system while isolating the effects of each unit

练习：划分出易于隔离的计算块，识别每个块的输入和输出，并布置信息在整个系统中的整体流动。然后我们可以分别实现每个单元，并在隔离每个单元影响的同时测试整个系统。

### 3. Documentation Practices and Code Refinement (文档实践与代码改进)

a second key element to good programming practice is code documentation unfortunately this is one of the least well practiced elements far too often programmers are in such a hurry to get things written that they skip by the documentation stage

良好编程实践的第二个关键要素是代码文档。不幸的是，这是实践最少的要素之一。程序员常常急于完成代码，以至于跳过了文档阶段。

skip by the documentation stage well this may seem reasonable at the time of code creation when the design choices are fresh in the program creators mind. Six months later one is trying to read the code even one's own it may be very difficult to reconstruct why certain choices were made. Indeed in many commercial programming settings more time is spent on code maintenance and modification than on code generation. Yet without good documentation it can be very difficult or inefficient to understand existing code and change it as well. Good documentation can serve as

跳过文档阶段。在代码创建时，设计选择在程序员脑海中还很清晰，这似乎合理。但六个月后，当人们试图阅读代码时，即使是自己的代码，也可能很难重构出当初为什么做出某些选择。事实上，在许多商业编程环境中，花在代码维护和修改上的时间比代码生成更多。然而，没有良好的文档，理解现有代码并修改它可能非常困难或低效。良好的文档可以作为……

as well good documentation can serve as a valuable source of information about the behavior of each model enabling a programmer to maintain the isolation of the details of the procedural abstraction from the use of that abstraction this information can be helpful when actually debugging procedures

同样，良好的文档可以作为关于每个模型行为的有价值信息来源，使程序员能够保持过程抽象的细节与该抽象的使用相隔离。这些信息在调试过程时可能很有帮助。

as with designing procedural modules the creation of good documentation is unfortunately as much art as science nonetheless here are some standard elements of well documented code we're going to illustrate each of these with a specific example first describe the goal

与设计过程模块一样，创建良好的文档不幸地既是科学也是艺术。尽管如此，以下是编写良好代码的一些标准要素。我们将用具体例子说明每个要素。首先，描述目标。

Specific example first: describe the goal of the procedure. Is it intended to be part of some other computation, as this helper function is? If so, what is the rough description of the process?

具体例子首先：描述过程的目标。它是否打算作为其他计算的一部分，就像这个辅助函数一样？如果是，那么过程的粗略描述是什么？

Note that here we've been a bit cryptic in order to fit things on the slide, and we might well want to say more about successive refinement, though we could defer that to the documentation under the improved procedure.

注意，这里我们为了适应幻灯片而有点简略，我们可能想多说一些关于逐步改进的内容，尽管我们可以将其推迟到改进过程下的文档中。

We also identify the role of each argument to the procedure. Write up second: describe the types of values used in the computation. In this case, the inputs or parameters.

我们还确定每个参数在过程中的作用。第二点：描述计算中使用的值类型。在这种情况下，输入或参数。

In this case, the inputs or parameters are both numbers, and the return value is also a number. Notice the format we've used here to specify that. Actually, if we want to be more careful, we could require that X be a positive number, and we'd place a check somewhere to ensure that this is actually true.

在这种情况下，输入或参数都是数字，返回值也是数字。注意我们用来指定这一点的格式。实际上，如果我们想更仔细，我们可以要求 X 是正数，并在某处放置检查以确保这确实为真。

Third, describe constraints, either desired or required, on the computation. Here, we know that squaring the guess should get us something close to the target value. Now, though, we really don't guarantee this until we reach the termination stage.

第三，描述对计算的约束，无论是期望的还是必需的。这里，我们知道对猜测进行平方应该得到接近目标值的结果。不过，实际上我们直到达到终止阶段才保证这一点。

until we reach the termination stage and fourth describe the expected state of the computation and the goal of each stage in the process. For example here we indicate what Goodenough should do, namely test if our approximation is sufficiently accurate.

直到达到终止阶段。第四，描述计算的预期状态和过程中每个阶段的目标。例如，这里我们指出 Goodenough 应该做什么，即测试我们的近似值是否足够精确。

Then we indicate that if this is the case we can stop and what value to return to satisfy the contract of the entire procedure. And we indicate how to continue the process though we could probably say a bit more about what improve should do. Notice how we can use the documentation to check some aspects of our procedure's contract.

然后我们指出，如果情况如此，我们可以停止，并返回什么值以满足整个过程的契约。我们还指出如何继续这个过程，尽管我们可能应该对 improve 应该做什么再多说一点。注意我们如何利用文档来检查过程契约的某些方面。

some aspects of our procedures contract here we have indicated that the procedure should return a number by examining the if expression we can see that in the consequent clause if the input parameter guess is a number then we're guaranteed to return a number for the alternative clause we can use induction to reason that given numbers as input we also return a number and hence the entire procedure returns a value of the correct type in general taking care to meet each of the stages when you create code will often ensure an easier time when you have to refine a

我们过程的契约的某些方面，这里我们已经指出该过程应返回一个数字。通过检查 if 表达式，我们可以看到在结果子句中，如果输入参数 guess 是一个数字，那么我们保证返回一个数字；对于替代子句，我们可以使用归纳推理，假设给定数字作为输入，我们也返回一个数字，因此整个过程返回一个正确类型的值。一般来说，在编写代码时注意满足每个阶段，往往会在需要改进代码时更容易。

an easier time when you have to refine a replace code getting into the habit of doing this every time you write something even if you're only minutes away from some problems that deadline will greatly improve your productivity

当你需要改进或替换代码时，更容易。养成每次写东西时都这样做的习惯，即使你离某个问题的截止日期只有几分钟，也会大大提高你的生产力。

### 4. Debugging: Common Errors and Basic Tools (调试：常见错误和基本工具)

well we would like to believe that the code we will write will always run correctly first time we try it experience shows that this is a fortunate happenstance typically especially with complex code things will not work right and we need to debug our code debugging is in part an acquired skill with lots of practice

好吧，我们愿意相信我们编写的代码总是第一次尝试就能正确运行。经验表明，这是一种幸运的偶然。特别是对于复杂的代码，事情往往不会顺利，我们需要调试代码。调试在某种程度上是一种通过大量练习获得的技能。

An acquired skill with lots of practice, you will develop your own preferred approach here we're going to describe some of the common sources of errors in code and standard tools for finding the causes of errors and fixing them.

通过大量练习获得的技能，你会形成自己偏好的方法。这里我们将描述代码中一些常见的错误来源，以及用于查找错误原因并修复它们的标准工具。

A common and simple bug in code arises when we use an unbound variable. From the perspective of Scheme, this means that somewhere in our code we try to reference or look up the value of a variable that did not have one. This can occur for several reasons, the simplest is that we miss type a spelling error, the solution in this case is pretty straightforward.

代码中一个常见且简单的错误是使用了未绑定变量。从 Scheme 的角度来看，这意味着在我们的代码中某处，我们试图引用或查找一个没有值的变量。这可能有几个原因，最简单的是我们打错了字。在这种情况下，解决方案相当直接。

In this case is pretty straightforward: simply search through the code file using editor tools to find the offending instance and correct it. Sometimes, however, we are using a legal variable, that is, one that we intended to hold some value, but the evaluator still complains that this variable is unbound. How can that be?

在这种情况下相当直接：只需使用编辑器工具搜索代码文件，找到出错的实例并纠正它。然而，有时我们使用的是一个合法的变量，即我们打算让它持有某个值，但求值器仍然抱怨该变量未绑定。这怎么可能呢？

Remember that in Scheme, a variable gets bound to a value in one of several ways. We may define it at top level, that is, we may directly tell the interpreter to give a variable some value. We may define it internally within a function, or we may bind it as a parameter in a procedure call. If the evaluator complains about an unbound variable, it means that the variable has not been properly introduced in any of these contexts, or its scope does not cover the point where it is being used.

记住，在 Scheme 中，变量通过几种方式之一绑定到值。我们可以在顶层定义它，也就是说，我们可以直接告诉解释器给一个变量某个值。我们可以在函数内部定义它，或者我们可以在过程调用中将其绑定为参数。如果求值器抱怨未绑定变量，这意味着该变量没有在这些上下文中被正确引入，或者其作用域不覆盖其使用的位置。

value we may define it internally within

值，我们可以在某个过程内部定义它，或者我们可以将其用作过程的形式参数，在这种情况下，当过程被应用时，它会被局部绑定到一个值。

Value we may define it internally within some procedure or we may use it as a formal parameter of a procedure in which case it gets locally bound to a value when the procedure is applied.

值，我们可以在某个过程内部定义它，或者我们可以将其用作过程的形式参数，在这种情况下，当过程被应用时，它会被局部绑定到一个值。

In the last two cases, if we attempt to reference the variable outside the scope of the binding, that is somewhere outside the bounds of the lambda expression being used, we will get an unbound variable error.

在后两种情况下，如果我们试图在绑定的作用域之外引用该变量，即在所使用的 lambda 表达式的边界之外的某个地方，我们将会得到未绑定变量错误。

This means that we have tried to use a variable outside its legal domain and we need to correct this. This probably means we have a coding error, but we can isolate the issue.

这意味着我们试图在其合法域之外使用一个变量，我们需要纠正这一点。这可能意味着我们有一个编码错误，但我们可以隔离问题。

Coding error but we can isolate the problem either by searching for instances of the variable in the code file or by using the debugger.

编码错误，但我们可以通过搜索代码文件中该变量的实例或使用调试器来隔离问题。

So what does the debugger do to help us find errors? Each programming language will have its own flavor of debugger. For an interpreted language like Scheme, the debugger actually places us inside the state of the computation.

那么调试器如何帮助我们找到错误呢？每种编程语言都有自己的调试器风格。对于像 Scheme 这样的解释型语言，调试器实际上将我们置于计算状态之中。

That is, when an error occurs, the debugger provides us access to the state of the computation at the time of the error, including access to the values of the variables within the computation.

也就是说，当错误发生时，调试器让我们访问错误发生时计算的状态，包括访问计算中变量的值。

of the variables within the computation. Moreover, we can step around inside the environment of the computation. We can work back up the chain of computational steps, examining what values were produced during reductions where computation is reduced to a simpler expression, and examining what values were produced during subproblems where the computation was converted to a simpler version of itself.

计算中变量的值。此外，我们可以在计算环境中四处移动。我们可以沿着计算步骤链向上回溯，检查在归约过程中产生了什么值（其中计算被简化为更简单的表达式），并检查在子问题中产生了什么值（其中计算被转换为自身的更简单版本）。

For example, here is a simple procedure which we have called with argument. To notice what happens when we hit the unbound variable error and enter the debugger, we are

例如，这里有一个简单的过程，我们用参数调用它。要观察当我们遇到未绑定变量错误并进入调试器时会发生什么，我们……

error and enter the debugger we are placed at the spot in the computation at which the error occurred. If we choose to step back through the chain of evaluations, we can see what expressions were reduced to get to this point, and what recursive versions of the same problem were invoked in reaching this point.

错误并进入调试器时，我们被放置在计算中错误发生的位置。如果我们选择沿着求值链回溯，我们可以看到哪些表达式被归约到这一点，以及在达到这一点时调用了哪些相同问题的递归版本。

In this case, we note that foo was initially called with argument two, and after a reduction through an if expression, we arrived at an expression that contained within it a simpler version of that same problem. This reduction stage repeated again until we

在这种情况下，我们注意到 foo 最初以参数 2 调用，经过 if 表达式的归约后，我们到达了一个包含同一问题更简单版本的表达式。这个归约阶段重复进行，直到我们……

Reduction stage repeated again until we apparently reach the base case of the if expression where we hit the unbound variable. We can see in this example that our unbound variable is coming from within the body of foo and is in the base case of the decision process.

归约阶段重复进行，直到我们显然到达 if 表达式的基本情况，在那里我们遇到了未绑定变量。在这个例子中，我们可以看到我们的未绑定变量来自 foo 的主体内部，并且位于决策过程的基本情况中。

A second class of errors deals with mistakes in syntax creating expressions that do not satisfy the programming language's rules for creating legal expressions. A simple one of these is an expression in which the wrong number of arguments is provided to the procedure if this occurs while attempting to

第二类错误涉及语法错误，创建了不满足编程语言规则以生成合法表达式的表达式。其中一个简单的错误是向过程提供了错误数量的参数。如果这在尝试……时发生

If this occurs while attempting to evaluate the offending expression, we will usually be thrown into the debugger, a system again intended to help us determine the source of the error.

如果这在尝试求值违规表达式时发生，我们通常会被抛入调试器，这是一个旨在帮助我们确定错误来源的系统。

In Scheme, as we've seen, the debugger provides us with information about the environment in which the offending expression occurred, and it has those tools we saw for examining values associated with variable names and for examining the sequence of expressions that have been evaluated leading up to this error by stepping through the frames of the debugger, just as we did.

在 Scheme 中，正如我们所见，调试器为我们提供了出错表达式所在环境的信息，并且它拥有我们之前见过的那些工具，用于检查与变量名关联的值，以及通过逐步遍历调试器的帧来检查导致此错误的表达式求值序列，就像我们之前所做的那样。

Frames of the debugger just as we did before, we can again isolate where in our code the incorrect expression resides. A more insidious syntax error occurs when we use an expression of the wrong type somewhere in our code.

像之前一样遍历调试器的帧，我们可以再次定位到代码中错误表达式所在的位置。一种更隐蔽的语法错误是当我们在代码中的某处使用了错误类型的表达式时发生的。

If we use an expression whose value is not a procedure as the first sub expression of a combination, we will get an error that indicates we have tried to apply a non procedure.

如果我们在组合式的第一个子表达式位置使用了一个值不是过程的表达式，我们会得到一个错误，提示我们试图应用一个非过程。

As before, the debugger can often help us isolate the location of this error, though it may not provide much insight into why an incorrect object was used.

和之前一样，调试器通常可以帮助我们定位这个错误的位置，尽管它可能无法提供太多关于为什么使用了不正确的对象的洞察。

into why an incorrect object was used as a procedure for that we may have to trace back through our code to determine how this value is supplied to the offending expression.

关于为什么一个不正确的对象被用作过程，我们可能需要回溯我们的代码，以确定这个值是如何提供给出错表达式的。

### 5. Structural Errors and Debugging Tools (结构错误与调试工具)

The harder error to isolate is one in which one of the argument expressions to a combination is of the wrong type.

更难隔离的错误是组合式的某个参数表达式类型不正确的情况。

The reason this is harder to track down is that the cause of the creation of an incorrect object type may have occurred far upstream, that is, some other part of our code may have created an incorrect object which has been passed through several levels of.

之所以更难追踪，是因为错误对象类型的产生可能发生在很上游的地方，也就是说，我们代码的其他部分可能创建了一个不正确的对象，该对象已经传递了好几层。

been passed through several levels of procedure calls before causing an error. procedure calls before causing an error. procedure calls before causing an error. tracking down the original source of this error can be difficult as we need to chase our way back through the sequence of expression evaluations to find where we accidentally created the wrong type of argument.

在引起错误之前，该对象已经传递了好几层过程调用。追踪这个错误的原始来源可能很困难，因为我们需要沿着表达式求值的序列回溯，找到我们意外创建错误类型参数的地方。

The most common sorts of errors though are structural ones. This means that our code is syntactically valid composed of correctly phrased expressions but the code does not compute what we intended because we've made an error somewhere in the code design. This could be for a

然而，最常见的错误类型是结构性的。这意味着我们的代码在语法上是有效的，由措辞正确的表达式组成，但代码并没有计算我们想要的结果，因为我们在代码设计的某个地方犯了错误。这可能是由于多种原因：我们以错误的初始值启动了递归过程，或者我们在错误的地方终止，或者我们错误地更新了参数，或者我们在某处使用了错误的过程，等等。

the code design this could be for a variety of reasons we started a recursive process with the wrong initial values or we're ending at the wrong place or we're updating parameters incorrectly or we're using the wrong procedure somewhere and so on

代码设计中的错误可能由多种原因造成：我们以错误的初始值启动了递归过程，或者我们在错误的地方终止，或者我们错误地更新了参数，或者我们在某处使用了错误的过程，等等。

finding these errors is tougher since the code may run without causing a language error but those results we get are erroneous this is where having good test cases is important

发现这些错误更加困难，因为代码可能运行而不会引发语言错误，但我们得到的结果是错误的。这时，拥有良好的测试用例就显得很重要。

for example when testing a recursive procedure it's valuable to try it using the base case values of the parameters to ensure the procedure is

例如，在测试递归过程时，尝试使用参数的基准情况值来确保过程在正确的位置终止并返回正确的值，这是很有价值的。

Parameters to ensure the procedure is terminating at the right place and returning the right value. It is also important to select input parameter values that sample or span the range of legal values. Does it work with small values, with large values, or that changing the input value by a small increment cause the expected change in the output?

参数以确保过程在正确的位置终止并返回正确的值。同样重要的是选择能够采样或覆盖合法值范围的输入参数值。它是否适用于小值、大值，或者输入值的小幅增量是否会导致输出的预期变化？

And what do we do if we find we have one of these structural errors? Well, our goal is to isolate the location of our misconception within the code, and to do this there are some standard tools.

如果我们发现存在这些结构错误之一，我们该怎么办？我们的目标是隔离代码中误解的位置，为此有一些标准工具。

There are some standard tools. The most common one is to use a print or display expression, that is to insert into our code expressions that will print out for us useful information at different stages of the computation. For example, we might insert a display expression within the recursive loop of a procedure, which will print out information about the values of the parameters.

有一些标准工具。最常见的是使用打印或显示表达式，即在代码中插入表达式，在计算的不同阶段为我们打印出有用的信息。例如，我们可以在过程的递归循环中插入一个显示表达式，打印出参数值的信息。

This will allow us to check the parameters are being updated correctly and that end cases are correctly seeking the right termination point. We might similarly print out the values of

这将使我们能够检查参数是否正确更新，以及结束情况是否正确寻求正确的终止点。我们也可以类似地打印出递归循环中中间计算的值。

Similarly, print out the values of intermediate computations within recursive loops again to ascertain that the computation is operating with the values we expect and is computing the values we expect. A related tool, supply for example with Scheme, is a tracer. This allows us to ask the evaluator to inform us about the calling conventions of procedures, that is, to print out the values of the parameters supplied before each application of the procedure we designate, and the value returned by each procedure call. This is similar to our

类似地，打印出递归循环中中间计算的值，再次确认计算使用的是我们期望的值，并且计算出的值也是我们期望的。一个相关的工具，例如 Scheme 中提供的，是跟踪器。这允许我们要求求值器告知我们过程的调用约定，即打印出在我们指定的过程每次应用之前提供的参数值，以及每次过程调用返回的值。这类似于我们使用显示表达式，但它是自动处理的。然而，它只适用于过程调用的参数，因此如果我们想检查计算的某些详细状态，我们需要退回到显示策略。

Procedure call is similar to our use of display expressions, but it is handled automatically for us. It applies only to parameters a procedure calls, however, so that if we want to examine some detailed states of the computation, we need to fall back on the display tactic.

过程调用类似于我们使用显示表达式，但它是自动处理的。然而，它只适用于过程调用的参数，因此如果我们想检查计算的某些详细状态，我们需要退回到显示策略。

### 6. Stepper and Sine Approximation Case Study (步进器与正弦近似案例研究)

In some cases, it may help to actually walk through the substitution model, that is, to see each step of the evaluation. Many languages, including Scheme, provide a means for doing this. In our case, it's called the Stepford. This is a mechanism that lets us control each step of the substitution model.

在某些情况下，实际走一遍替换模型可能会有帮助，即查看求值的每一步。许多语言，包括 Scheme，都提供了这样做的工具。在我们的例子中，它被称为步进器。这是一种机制，让我们控制替换模型中每一步的求值。

each step of the substitution model in the evaluation of an expression there's obviously tedious but works best when we need to isolate a very specific spot at an error at which an error is occurring and we don't want to insert a ton of display expressions perhaps the best way to see the role of these tools is to look at an example which we do let's use an example of a debugging session to highlight these ideas this would be primarily to fix a structural error but we'll see how the other tools come into play as we do this suppose you

在表达式求值中控制替换模型的每一步显然很繁琐，但在我们需要隔离错误发生的非常具体的位置，并且不想插入大量显示表达式时，它效果最好。也许最好的方式是看一个例子来理解这些工具的作用，我们就这么做。让我们用一个调试会话的例子来突出这些想法。这主要是为了修复结构错误，但我们会看到其他工具在这个过程中如何发挥作用。假设你想计算正弦函数的近似值，这里有一个数学近似，可以给我们一个相当好的结果。

come into play as we do this suppose you want to compute an approximation to the sine function here's a mathematical approximation that will give us a pretty good solution

让我们尝试编写这个代码。这是第一次尝试的代码。我们假设 fact 和 small enough 已经存在。这个过程的基本思想与我们为平方根所做的非常相似：我们从一个猜测开始。

let's try coding this up so here is a first attempt at some code to do this we will assume that fact and small enough already exist the basic idea behind this procedure is quite similar to what we did for square roots we start with a guess

让我们尝试编写这个代码。这是第一次尝试的代码。我们假设 fact 和 small enough 已经存在。这个过程的基本思想与我们为平方根所做的非常相似：我们从一个猜测开始。

we then see how to improve the guess in this case by computing the next term and the approximation which we would like to add in if this improvement is small

然后我们看看在这种情况下如何通过计算下一项来改进猜测，以及如果这个改进很小，我们希望加入的近似值。

add in if this improvement is small enough we're done and we can return to the desired value if not we repeat the process with a better guess by adding in the improvement to the current guess now let's try it out on test cases one nice test case is the base case of X equal to zero that clearly works.

如果这个改进足够小，我们就完成了，可以返回所需的值；如果不是，我们就用更好的猜测重复这个过程，将改进加到当前猜测上。现在让我们在测试用例上试试。一个不错的测试用例是 X 等于零的基本情况，这显然有效。

another nice test case is when X is equal to PI where we know the result should also be close to zero oops that didn't work nor does the code work for PI half as a value for X both of these latter cases give results that are much too large okay we need to

另一个不错的测试用例是 X 等于 PI，我们知道结果也应该接近零。哎呀，这没起作用，代码对 X 等于 PI 一半也不起作用。后两种情况给出的结果都太大了。好的，我们需要……

are much too large okay we need to figure out where our conceptual error lies let's try to isolate this by tracing through the computation in particular we will add some display expressions that will show us the state of the computation each time through the recursion and let's try this again here we've used the test case of X equal to PI and we can see the trace of the computation

……都太大了。好的，我们需要找出我们的概念错误在哪里。让我们尝试通过跟踪计算来隔离问题。特别是，我们将添加一些显示表达式，这些表达式将显示每次递归时计算的状态，然后我们再试一次。这里我们使用了 X 等于 PI 的测试用例，我们可以看到计算的跟踪。

if we compare this to the mathematical equation we can see one problem we really only want terms where n is odd but clearly we're getting all terms for n so we need to fix this most

如果我们将此与数学方程进行比较，我们可以看到一个问题：我们实际上只想要 n 为奇数的项，但显然我们得到了所有 n 的项，所以我们需要修复这个问题。

Terms for n, so we need to fix this. Most likely this is because we're not changing our parameters properly. So here's the correction: we will need to increment our parameter by two each time, not by one — an easy mistake to make.

所有 n 的项，所以我们需要修复这个问题。最可能的原因是我们没有正确改变参数。所以这是修正：我们需要每次将参数增加二，而不是一——这是一个容易犯的错误。

And to myth, so let's try this again. Ha, we've gotten better, as we're only computing the odd terms for n, but we're still not right. If we look again at the mathematical equation, we can see that we should be alternating signs on each term.

让我们再试一次。哈，我们变得更好了，因为我们只计算 n 的奇数项，但我们仍然不对。如果我们再看数学方程，我们可以看到每一项的符号应该交替。

Or said another way, the successive approximation should go up, then down, then up, then down, and so on. Note that we

或者换句话说，逐次逼近应该先上升，然后下降，然后上升，然后下降，依此类推。注意我们……

then up then down and so on note that we could have also spotted this if we had chosen to display the value of next at each step so we need to keep track of some additional information in this case whether the term should be added or subtracted from the current gasps well

……然后上升然后下降，依此类推。注意，如果我们选择在每一步显示 next 的值，我们也可以发现这一点。所以我们需要跟踪一些额外的信息，在这种情况下，该项应该从当前猜测中加上还是减去。

we can handle that we add another parameter to our helper procedure which keeps track of whether to add the term if the value is 1 or whether to subtract the term if the value is minus 1 and of course we will need to change how we update the guess and how we update the

我们可以处理这个。我们给辅助过程添加另一个参数，该参数跟踪是加上该项（如果值为 1）还是减去该项（如果值为 -1）。当然，我们需要改变更新猜测的方式以及更新……

update the guess and how we update the value this parameter as shown. Oops, we blew it somewhere. We could enter the debugger to locate the problem, but we can already guess that since we change the aux procedure, that must be the cause of getting this particular error.

……更新猜测的方式以及更新这个参数的值，如图所示。哎呀，我们搞砸了。我们可以进入调试器来定位问题，但我们已经可以猜到，既然我们更改了 aux 过程，那一定是导致这个特定错误的原因。

And clearly the solution is to make sure we call this procedure with the right number of arguments. Notice that in this case it is easy to spot this error, but in general we should get into the habit of checking all calls to procedure when we alter its set of parameters. Now if we try this on the test case of X equal pi.

显然，解决方案是确保我们用正确数量的参数调用这个过程。注意，在这种情况下很容易发现这个错误，但一般来说，当我们改变过程的参数集时，我们应该养成检查所有过程调用的习惯。现在，如果我们在 X 等于 PI 的测试用例上试试。

we alter its set of parameters now if we try this on the test case of X equal pi

我们改变它的参数集。现在，如果我们在 X 等于 PI 的测试用例上试试。

Try this on the test case of X equal pi. It works, but if we try it on the test case 2pi half, it doesn't. The answer should be close to one, but we're getting something close to minus one.

在 X 等于 PI 的测试用例上试试。它有效，但如果我们在 2pi 一半的测试用例上试试，它就不起作用。答案应该接近一，但我们得到的是接近负一。

Note that this reinforces why we want to try a range of test cases. If we'd stopped with just X equal PI, we would not have spotted this problem. So how do we fix it? Here's the bug: we started with the wrong initial value, a common error. By fixing this to the right initial value, we can try again and finally we get the right performance. Note how we've used printing of values to isolate.

注意，这强化了为什么我们要尝试一系列测试用例。如果我们只停在 X 等于 PI，我们就不会发现这个问题。那么我们如何修复它？这是错误：我们以错误的初始值开始，这是一个常见错误。通过将其修正为正确的初始值，我们可以再试一次，最终我们得到正确的性能。注意我们如何使用打印值来隔离……

used printing of values to isolate changes as well as using the debugger to find syntax errors in general we want you to get into the habit of doing the same things developing good programming methodology habits now will greatly help you when you have to deal with large complex bodies of code.

……使用打印值来隔离变化，以及使用调试器来查找语法错误。一般来说，我们希望你们养成做同样事情的习惯。现在培养良好的编程方法论习惯将在你们处理大型复杂代码体时大有帮助。

### 7. Using Types for Design and Debugging (使用类型进行设计与调试)

good programming discipline means being careful and thorough in the creation and the refinement of code of all sizes and forms so start exercising your programming muscles now one other tool that we have in our armamentarium of debugging is the use of types.

良好的编程纪律意味着在创建和完善各种规模和形式的代码时要小心谨慎、彻底全面。所以现在就开始锻炼你的编程肌肉吧。在我们的调试武器库中，另一个工具是使用类型。

debugging is the use of types in particular type specifications that is constraints on what types of objects are passed as arguments to procedures and what types of objects are returned as values by procedures can help us both in planning and designing code and in debugging existing code here we're going to briefly explore both of these ideas to demonstrate why careful programming practice can lead to efficient generation of robust code and to illustrate why thinking about types of procedures and objects is a valuable practice to motivate the idea of types

调试中使用类型，特别是类型规范，即对传递给过程的参数类型和过程返回值类型的约束，可以帮助我们规划、设计代码以及调试现有代码。在这里，我们将简要探讨这两个想法，以演示为什么仔细的编程实践可以导致高效生成健壮的代码，并说明为什么思考过程和对象的类型是一种有价值的实践。为了激发类型作为设计代码工具的想法……

practice to motivate the idea of types as a tool in designing code let's consider an example suppose you want to create a procedure called repeated that will apply any other procedure some specified number of times since this is a vague description let's look at a specific motivating example we saw earlier the idea that we could implement multiplication as a successive set of additions and that we could implement exponential as a successive set of multiplications if we look at these two procedures we can see that there's a general pattern

……实践。为了激发类型作为设计代码工具的想法，让我们考虑一个例子。假设你想创建一个名为 repeated 的过程，它将任何其他过程应用指定的次数。由于这是一个模糊的描述，让我们看一个具体的激励例子。我们之前看到，我们可以将乘法实现为连续的加法，将指数实现为连续的乘法。如果我们看这两个过程，我们可以看到有一个通用模式……

can see that there's a general pattern here there is a base case value to return zero in one case one and the other and there is the idea of applying an operation to an input value and the result of repeating that process one fewer times repeated is intended to capture that common pattern of operation.

……可以看到这里有一个通用模式：有一个基本情况要返回的值（一个是零，另一个是一），以及将一个操作应用于输入值并将该过程重复少一次的结果的想法。repeated 旨在捕获这种操作模式。

so here is what we envision we want our repeated procedure to take a procedure to repeat and the number of times to repeat it it should return a procedure that will actually do that when applied to some value here we can see that the procedure being applied would change in

所以这是我们设想的：我们希望 repeated 过程接受一个要重复的过程和重复的次数，它应该返回一个过程，当应用于某个值时，该过程将实际执行重复。在这里我们可以看到，被应用的过程会改变……

procedure being applied would change in each case and the initial value to which it would apply would change but otherwise the overall operation is the same. The question is how do we create repeated and why does the call to repeat it have that funny structure with two open parens instead of one? First, what is the type of repeated?

每次应用的过程会改变，初始值也会改变，但除此之外整体操作是相同的。问题是我们如何创建 repeated，以及为什么对它的调用具有那种奇怪的结构，有两个左括号而不是一个？首先，repeated 的类型是什么？

Well, from the previous slide, we know that as given, it should take two arguments. The first should be a procedure of one argument. We don't necessarily know what type of argument this procedure should take in.

从上一张幻灯片中，我们知道，按照给定的定义，它应该接受两个参数。第一个应该是一个单参数的过程。我们不一定知道这个过程应该接受什么类型的参数。

这一过程应当接受两个示例中所示的输入，输入是一个数字，但我们可能希望比这更通用。我们所知道的是，无论这个过程接受什么类型的参数，它都需要返回一个相同类型的值，因为它将再次将该过程应用于该值。因此，repeat的第一个参数必须是类型为a映射到a的过程。

这一过程应当接受两个示例中所示的输入，输入是一个数字，但我们可能希望比这更通用。我们所知道的是，无论这个过程接受什么类型的参数，它都需要返回一个相同类型的值，因为它将再次将该过程应用于该值。因此，repeated 的第一个参数必须是类型为 a 映射到 a 的过程。

第二个参数repeated必须是一个整数，因为我们只能对一个整数次执行操作，实际上可能是一个非负整数，正如我们之前论证的那样，返回的...

第二个参数 repeated 必须是一个整数，因为我们只能对一个整数次执行操作，实际上可能是一个非负整数，正如我们之前论证的那样，返回的...

integer and as we argued the returned object needs to be a procedure of the same type a maps to a because the idea is to use repeated recursively on it's

整数，并且正如我们论证的那样，返回的对象需要是一个相同类型 a 映射到 a 的过程，因为其想法是递归地在其上使用 repeated。

okay now how does this help us in designing the actual procedure we know the rough form that repeated should take you should have a test for the base case which is when there are no more repetitions to make in the base case it needs to do something which we have to figure out and in the recursive case we expect to use repeated to solve the smaller problem of repetition plus some

好的，现在这如何帮助我们在设计实际过程时？我们知道 repeated 应该采取的大致形式：你应该有一个针对基本情况的测试，即当没有更多重复要做时；在基本情况下，它需要做一些我们必须弄清楚的事情；在递归情况下，我们期望使用 repeated 来解决较小问题的重复，再加上一些...

Smaller problem of repetition plus some additional operations which we also need to figure out for the base case what do we know. Well, we know that by the type information this must return a procedure of a single argument that returns a value of the same type. We also know that if we're in the base case there's really nothing to do; we don't want to apply our procedure any more times. Hence, we can deduce that we need to return a procedure that serves as the identity; it simply returns whatever value was passed in.

较小问题的重复，再加上一些额外的操作，我们也需要弄清楚。对于基本情况，我们知道什么？嗯，通过类型信息，我们知道这必须返回一个单参数的过程，该过程返回相同类型的值。我们还知道，如果我们处于基本情况，实际上没有什么可做的；我们不想再应用我们的过程。因此，我们可以推断出我们需要返回一个作为恒等函数的过程；它只是返回传入的任何值。

Now what about the recursive case? Well, the idea is to apply

那么递归情况呢？嗯，其想法是应用...

value was passed in now what about the recursive case well the idea is to apply

传入的值。现在递归情况呢？嗯，其想法是应用...

recursive case well the idea is to apply the input procedure to the result of repeating the operation n minus one times. how do we use this idea to figure out the correct code.

递归情况呢？嗯，其想法是将输入过程应用于将操作重复 n 减一次的结果。我们如何使用这个想法来找出正确的代码？

first we know that whatever we write must have type A maps to a by the specification of repeated.

首先，我们知道无论我们写什么，根据 repeated 的规范，都必须具有类型 A 映射到 A。

next we know that we want to apply the input procedure proc to the result of solving the same problem n minus one times so we ought to have something that has these pieces in it.

接下来，我们知道我们想要将输入过程 proc 应用于解决相同问题 n 减一次的结果，所以我们应该有包含这些部分的东西。

but let's check the types we know that repeated has type a maps to a and the proc expects only an

但让我们检查类型。我们知道 repeated 具有类型 a 映射到 a，而 proc 只期望一个...

a maps to a and the proc expects only an argument of type eight so clearly we need to apply repeated to an argument before passing the result on to proc hence we have the form shown note how this fairly complex piece of code can be easily deduced by using types of procedures to determine interactions of course to be sure that we did it right we should now test this on some test cases for example by running mul or X on known cases a second way that types can help us is in debugging code in particular we can use the information about types of arguments and types of

a 映射到 a，而 proc 只期望一个类型为 a 的参数，所以显然我们需要在将结果传递给 proc 之前将 repeated 应用于一个参数，因此我们有了所示的形式。注意，通过使用过程的类型来确定交互，可以轻松推导出这段相当复杂的代码。当然，为了确保我们做对了，我们现在应该在一些测试用例上测试它，例如在已知情况下运行 mul 或 X。类型可以帮助我们的第二种方式是在调试代码时；特别是，我们可以使用关于参数类型和返回值类型的信息...

关于参数类型和返回值类型，我们需要明确地检查过程是否正确地交互。在某些情况下，如果对实际返回的值有约束，我们也可以强制执行检查。

关于参数类型和返回值类型，我们需要明确地检查过程是否正确地交互。在某些情况下，如果对实际返回的值有约束，我们也可以强制执行检查。

### 8. Type Checks and Inductive Reasoning on Lists (类型检查与列表上的归纳推理)

举个例子，这是我们之前的squirt代码。我们有一个条件是输入参数必须是数字，我们可以通过插入显式检查来确保数字被正确传递。在这种情况下，这种检查可能是多余的，因为唯一调用scored helper的代码本身...

举个例子，这是我们之前的 squirt 代码。我们有一个条件是输入参数必须是数字，我们可以通过插入显式检查来确保数字被正确传递。在这种情况下，这种检查可能是多余的，因为唯一调用 scored helper 的代码本身...

code that calls scored helper is itself

调用 scored helper 的代码本身...

but in general when multiple procedures might be involved you can see how this check is valuable note that one can insert this check only when debugging as a tool for deducing what procedure is incorrectly supplying arguments but one can also use it regularly if you want to ensure robust operations of the code clearly one could also add a check on the return value in a similar fashion there are other things one could use to ensure correct operation as well for example the number whose square root we are seeking should be a positive

但一般来说，当可能涉及多个过程时，你可以看到这种检查的价值。注意，只有在调试时才能插入这种检查，作为推断哪个过程错误地提供了参数的工具；但如果你希望确保代码的稳健运行，也可以定期使用它。显然，你也可以类似地添加对返回值的检查。还有其他可以用来确保正确操作的东西，例如，我们正在求平方根的数应该是正数，我们可以在继续之前检查这一点，如前所示。因此，我们看到类型也是良好编程方法论中的有用工具。总结一下。

we are seeking should be a positive number and we could check this as shown before we proceed thus we see that types also serve as a useful tool in good programming methodologies to summarize.

我们正在求平方根的数应该是正数，我们可以在继续之前检查这一点，如前所示。因此，我们看到类型也是良好编程方法论中的有用工具。总结一下。

we've seen in this lecture a set of tools for good programming practices ways of designing code debugging code evaluating and testing code and using knowledge of code structure to guide the design.

我们在本讲座中看到了一套用于良好编程实践的工具：设计代码、调试代码、评估和测试代码，以及利用代码结构知识来指导设计的方法。

let's start by revisiting lists remember that we said a list was simply a sequence of consoles connected by cutters ending in an empty list also.

让我们从重新审视列表开始。记住，我们说列表只是由 cons 单元组成的序列，以空列表结尾。

cutters ending in an empty list also

以空列表结尾的 cons 单元，也称为 nil。记住，我们说列表还具有封闭性：如果我们把任何东西 cons 到列表的开头，我们会得到一个新的 cons 单元序列，以空列表结尾，因此是一个列表。

Cutters ending in an empty list, also known as nil. Remember that we said lists also have the property of closure: if we were to cons anything onto the beginning of the list, we would get a new sequence of consoles ending in the empty list, hence a list.

以空列表结尾的 cons 单元，也称为 nil。记住，我们说列表还具有封闭性：如果我们把任何东西 cons 到列表的开头，我们会得到一个新的 cons 单元序列，以空列表结尾，因此是一个列表。

And with the exception of the empty list, taking the quarter of a list results in a sequence of consoles ending in the empty list, hence a list. Note that this is really something that has an inductive flavor to it: the base case is an empty list.

除了空列表之外，取列表的 cdr 会得到一个以空列表结尾的 cons 单元序列，因此是一个列表。注意，这确实具有归纳的味道：基本情况是空列表。

Given that every collection of consoles of size less than an ending in an empty list...

鉴于每个大小小于 n 且以空列表结尾的 cons 单元集合...

A list of size less than an ending in an empty list is a list, then clearly putting or consing a new element onto such a list yields a list. Thus, by induction, every collection of conses ending in the empty list is a list. We should be able to use this idea to reason about procedures that manipulate lists.

一个大小小于 n 且以空列表结尾的列表是一个列表，那么显然将一个新元素 cons 到这样的列表上会产生一个列表。因此，通过归纳，每个以空列表结尾的 cons 单元集合都是一个列表。我们应该能够使用这个想法来推理操作列表的过程。

Here is one of our standard procedures for manipulating lists: our old friend map. Intuitively, we know how this code should work, but can we establish formally that it does what we expect? Sure, we just use our notion of induction here, both on the

这是我们用于操作列表的标准过程之一：我们的老朋友 map。直观上，我们知道这段代码应该如何工作，但我们能否正式确定它做了我们期望的事情？当然，我们只需在这里使用我们的归纳概念，既在数据结构上，也在代码本身上。对于基本情况，我们有列表的基本情况数据结构，即空列表，因此代码显然返回了正确的结构。

our notion of induction here both on the data structure and on the code itself for the base case we have the base case data structure for a list namely an empty list thus the code clearly returns the right structure

我们的归纳概念既在数据结构上，也在代码本身上。对于基本情况，我们有列表的基本情况数据结构，即空列表，因此代码显然返回了正确的结构。

now assume that map correctly returns a list in which each element of the input list has had proc apply to it and that the order the elements is preserved for any list of size smaller than the current one

现在假设 map 正确返回一个列表，其中输入列表的每个元素都应用了 proc，并且元素的顺序得以保留，对于任何大小小于当前列表的列表都是如此。

then we know given list that by induction on the data structure quarter of list is a list further by induction on the procedure map we know this will return a

那么我们知道，给定一个列表，通过对数据结构进行归纳，列表的四分之一部分仍然是一个列表；进一步，通过对过程 map 进行归纳，我们知道这将返回一个

procedure map we know this will return a list of the same size with each element replaced by the application of proc to that element. We can then see the first element of the new list and, by induction on the data structure, implement a new list of the appropriate size that also satisfies the conditions of map.

过程 map 将返回一个大小相同的列表，其中每个元素都被替换为将 proc 应用于该元素的结果。然后我们可以查看新列表的第一个元素，并通过数据结构的归纳，实现一个大小合适且同样满足 map 条件的新列表。

Thus by induction we know that map will correctly perform as expected. Now is there anything explicit in the code that says this applies only to lists of numbers? Of course not; it could be lists of symbols or lists of strings or lists.

因此，通过归纳我们知道 map 将正确执行。现在，代码中是否有任何明确说明这仅适用于数字列表？当然没有；它可以是符号列表、字符串列表或任何类型的列表。

### 9. Defining Trees and Their Type (定义树及其类型)

of symbols or lists of strings or lists of anything that can be seen by looking at the type definition for a list as with pairs we will represent a list by the symbol list followed by angle brackets containing a type definition for the elements of the list.

符号列表或字符串列表，或任何可以通过查看列表的类型定义来确定的列表，就像对序对一样，我们将用符号 list 后跟尖括号括起来的元素类型定义来表示一个列表。

Since lists are created of pairs we can be more explicit about this definition by noting that a list of some type is either a pair whose first element is of that type and whose second element is a list of the same type or which is indicated by that vertical bar the list is the

由于列表是由序对构成的，我们可以更明确地定义：某种类型的列表要么是一个序对，其第一个元素是该类型，第二个元素是相同类型的列表；要么由竖线表示，列表是

that vertical bar the list is the special empty list note the nice recursive definition of a list with the closure property that the quarter of a list itself is a list

竖线表示列表是特殊的空列表。注意列表的递归定义很优美，具有封闭性：列表的四分之一部分本身就是一个列表。

also notice that nothing in this type definition says the elements hanging off of the cars of the list have to be numbers in fact our definition uses the arbitrary type C

还要注意，这个类型定义中没有任何内容说明列表的 car 中挂着的元素必须是数字；事实上，我们的定义使用了任意类型 C。

this means that those structures could be anything including other lists this leads nicely to a more general data structure called a tree which lets us capture much more complex kinds of relationships and structures so what

这意味着这些结构可以是任何东西，包括其他列表。这自然引出了一个更通用的数据结构，称为树，它让我们能够捕捉更复杂的关系和结构。那么

relationships and structures so what does a tree look like and are there common procedures associated with the manipulation of trees first here's the conceptual idea behind a tree a tree is a structure that consists of a root or a starting point at the root and indeed at every other point in the tree our set of branches that connect different parts of the tree together you can see this shown here each branch is said to contain a child or a sub tree and that sub tree could itself be another tree or could terminate in a leaf in the example shown

关系和结构是什么样的？树是什么样子？是否存在与树操作相关的常见过程？首先，这里是树背后的概念：树是一种由根或起点组成的结构，在根处以及树中的每个其他点，都有一组分支连接树的不同部分。你可以看到这里展示的：每个分支被称为包含一个子节点或子树，该子树本身可以是另一棵树，也可以终止于一个叶子。在所示的例子中

terminate in a leaf in the example shown here the leaves are all numbers but it could be of course other things like symbols or other structures note that there's a nice recursive property to a tree that is taking a subtree gives us in fact again a tree that is taking any of these branches leads to a structure that looks exactly like a tree this suggests that procedures to manipulate trees are going to have this nice recursive property as well.

在所示的例子中，叶子都是数字，但当然也可以是其他东西，如符号或其他结构。注意树有一个很好的递归性质：取一个子树，实际上又得到一棵树；取这些分支中的任何一个，都会得到一个看起来完全像树的结构。这表明操作树的程序也将具有这种良好的递归性质。

to implement a tree we can just build it out of lists in fact each level of the tree will be a list the elements of each

要实现一棵树，我们可以直接用列表来构建；事实上，树的每一层都是一个列表，每个

Tree will be a list. The elements of each of the branches will be shown as the cars of that top-level list, and those levels themselves may contain sub trees. So in the example shown here, the first branch is just the leaf 2, the second branch is itself a sub tree, so there's another list with things hanging off of it, and the third branch is again just the leaf for. So we have lists of lists as our implementation of a tree.

树的每一层都是一个列表。每个分支的元素将显示为顶层列表的 car，而这些层本身可能包含子树。因此，在所示的例子中，第一个分支只是叶子 2，第二个分支本身是一个子树，所以有另一个列表挂着东西，第三个分支又只是叶子 4。所以我们用列表的列表来实现树。

So what can we say about a tree? First, we can define its type very similar to a list. We have that a tree of type C meaning a tree...

那么关于树我们能说什么呢？首先，我们可以定义它的类型，与列表非常相似。我们有一个 C 类型的树，意思是

that a tree of type C meaning a tree whose elements are of some type C has the property that is constructed as a list whose elements themselves are trees of type C or as a leaf of type C and a leaf of type C is just this type itself C.

C 类型的树，即元素为某种类型 C 的树，具有这样的性质：它被构造为一个列表，其元素本身是 C 类型的树，或者是一个 C 类型的叶子，而 C 类型的叶子就是类型 C 本身。

in fact as we defined it here it suggests that C the type of the elements would always be the same a tree of numbers or a tree of symbols clearly we could generalize this but for now this will serve as a good type definition so to repeat a tree whose elements are of type C is implemented as a list of

事实上，正如我们在这里定义的，它表明 C（元素的类型）总是相同的，比如数字树或符号树。显然我们可以将其泛化，但目前这可以作为一个好的类型定义。所以重复一遍：元素类型为 C 的树被实现为一个列表，其

type C is implemented as a list of

元素类型为 C 的树被实现为一个列表，其

type C is implemented as a list of elements each of which is itself a tree, or as a leaf now associated with a tree. We expect to see some standard operations, one of them is a predicate which we'll call leaf, which will tell us whether we're at a sub tree that is in self a leaf or whether there's more things to test.

元素类型为 C 的树被实现为一个列表，其中每个元素本身是一棵树，或者是一个叶子。与树相关，我们期望看到一些标准操作，其中之一是一个谓词，我们称之为 leaf，它将告诉我们当前是在一个本身就是叶子的子树，还是有更多的东西需要测试。

The second thing we want to see though is how different operations can be used to apply to elements of a tree. We expect to see a similar form to what we saw with lists, but more general to deal with the fact that the elements hanging off of the

我们想看到的第二件事是，不同的操作如何应用于树的元素。我们期望看到与列表类似的形式，但更通用，以处理结构中挂着的元素可能不是简单的原始数据（如数字），而可能是复杂的东西（如树）这一事实。

that the elements hanging off of the structure may not be simple primitives like numbers but may themselves be complex things like trees. So given that we have a tree as a data structure built out of lists of lists, what kinds of things can we do with it? What kinds of procedures should we expect to see to manipulate trees?

结构中挂着的元素可能不是简单的原始数据（如数字），而可能是复杂的东西（如树）。那么，既然我们有了一个由列表的列表构建的树作为数据结构，我们可以用它做什么？我们应该期望看到哪些类型的程序来操作树？

First of all, since the tree is implemented as a list in principle, we could just use list procedures on them, although that starts to border on infringing on the data abstraction of the tree itself. Let's see what happens if we do it here.

首先，由于树在原则上被实现为列表，我们原则上可以直接使用列表程序，尽管这开始侵犯树本身的数据抽象。让我们看看在这里这样做会发生什么。

### 10. Implementing and Tracing count-leaves and tree-map (实现并追踪 count-leaves 和 tree-map)

what happens if we do it here I've defined a simple little tree call it my tree it's a list of Lists and there's the structure shown in box and pointer diagram

如果我们在这里这样做会发生什么？我定义了一个简单的小树，称之为 my tree，它是一个列表的列表，结构如盒子和指针图所示。

now let's suppose we asked for the length of this structure remember length is a procedure that applies to lists we can certainly apply it to my tree and it returns three now that may not be what you would have expected when we asked for the length somehow length sort of should count the number of elements are the leaves of the tree but it only returned three why well clearly length applies to a list

现在假设我们询问这个结构的长度。记住 length 是一个适用于列表的程序，我们当然可以将其应用于 my tree，它返回 3。这可能不是你期望的；当我们询问长度时，length 似乎应该计算树中叶子的数量，但它只返回了 3。为什么？显然 length 适用于列表，

clearly length applies to a list and since a tree happens to be implemented as a list of Lists it just counts the number of elements at the top level list of that data structure that is it counts the first car for the second car happens to be a list and the third car too to get three things this may actually be okay if I simply want to know the number of elements at the top level of the tree but suppose I actually want to count elements in the tree itself how do I do it in particular suppose I want a procedure let's call it count leaves

显然，length 适用于列表，而由于树恰好被实现为列表的列表，它只是计算该数据结构顶层列表中的元素个数，也就是说，它计算第一个 car、第二个 car（恰好是一个列表）以及第三个 car，从而得到三个元素。如果我只是想知道树顶层有多少个元素，这或许没问题；但假设我实际上想计算树本身的元素个数，该怎么做呢？特别是，假设我想要一个过程，我们称之为 count-leaves。

Procedure let's call it count leaves that will count all the elements that are leaves in this tree, that is all the numbers ideally here this should return the value four. I need to build a procedure that takes advantage of the data structure of the tree directly to do that.

这个过程，我们称之为 count-leaves，它将计算这棵树中所有作为叶子的元素，也就是所有的数字。理想情况下，这里应该返回数值 4。我需要构建一个过程，直接利用树的数据结构来实现这一点。

So let's think about how to do that, and remember the goal here isn't just to come up with something that deals with trees, is to use the general idea of writing procedures to go hand-in-hand with data structures that we're trying to see nonetheless for counting the number of leaves in the tree.

所以让我们思考如何做到这一点，并记住这里的目标不仅仅是提出一个处理树的方法，而是运用编写过程的一般思想，使其与我们所处理的数据结构相辅相成，尽管如此，我们还是要计算树中叶子的数量。

We're trying to see nonetheless for counting the number of leaves in the tree.

尽管如此，我们还是要计算树中叶子的数量。

we're trying to see nonetheless for counting the number of leaves in the

尽管如此，我们还是要计算树中叶子的数量。

Counting the number of leaves in the tree we can come up with a pretty good strategy. What do we have? Well certainly we have a base case that says if we've got an empty tree the answer is 0 there are no leaves. We also have a second base case which is a little different than what we've seen before.

计算树中叶子的数量，我们可以想出一个相当不错的策略。我们有什么呢？当然，我们有一个基本情况：如果遇到一棵空树，答案是 0，因为没有叶子。我们还有第二个基本情况，这和我们之前见过的略有不同。

Second base case says if we're counting a tree that just consists of a leaf obviously there's one leaf there. And then the recursive strategy, and here we need to be careful: when we were dealing with lists recursive strategies said do something.

第二个基本情况是：如果我们要计算的树只包含一个叶子，显然那里有一个叶子。然后是递归策略，这里我们需要小心：当我们处理列表时，递归策略说的是对某部分做某种操作。

recursive strategies said do something

递归策略说的是对某部分做某种操作。

递归策略说的是，对列表的car部分做某种操作，然后把结果加到你对其余部分（即列表的cdr部分）所做的操作中。

递归策略说的是，对列表的 car 部分做某种操作，然后把结果加到你对其余部分（即列表的 cdr 部分）所做的操作中。

现在要记住，树有许多子节点挂在它上面。因此，计算树中元素的数量，就是统计树中每个子节点下有多少叶子，并将这些计数相加。

现在要记住，树有许多子节点挂在它上面。因此，计算树中元素的数量，就是统计树中每个子节点下有多少叶子，并将这些计数相加。

这会涉及处理所有挂在其下的不同可能的子节点。所以让我们来构建它。这是我定义的count-leaves函数，它接收一个数据结构——一棵树——并且有几个情况，包括两个基本情况。

这会涉及处理所有挂在其下的不同可能的子节点。所以让我们来构建它。这是我定义的 count-leaves 函数，它接收一个数据结构——一棵树——并且有几个情况，包括两个基本情况。

several cases it has the two base cases. The tree is empty using null to check, for then the answer is zero if the tree is a leaf using my predicate for a leaf, then the answer is 1.

几个情况，它有两个基本情况。如果树为空，用 null 来检查，那么答案是 0；如果树是一个叶子，用我的叶子谓词来判断，那么答案是 1。

Otherwise I get what I have in terms of counting the number of leaves in the first part of the tree and adding that to getting what I get by counting the number of leaves in the rest of the tree.

否则，我通过计算树的第一部分中叶子的数量，并将其与计算树的其余部分中叶子的数量相加，来得到结果。

Ah, different form here than what we seen before. Right, in the past we would have just done something with the car of the tree and recursively use count leaves on the

啊，这里的形式和我们之前见过的不同。没错，在过去，我们可能只是对树的 car 做某种操作，然后递归地对树的 cdr 使用 count-leaves。

and recursively use count leaves on the

然后递归地对树的 cdr 使用 count-leaves。

and recursively use count leaves on the quarter of the tree if we were treating this like a list but since the car of the tree could itself be a tree and not just an element I have to go ahead and count the leaves in that part of the tree as well.

然后递归地对树的 cdr 使用 count-leaves，如果我们把它当作列表来处理的话；但由于树的 car 本身可能是一棵树，而不仅仅是一个元素，我必须继续计算树的那一部分中的叶子数量。

you should stop and think about what kind of orders of growth we're going to see for this kind of procedure notice it has two calls to count leaves in its recursive per case and that should remind you of a kind of structure we've seen before.

你应该停下来思考一下，对于这种过程，我们会看到什么样的增长阶数。注意，在递归的每个情况下，它都有两次对 count-leaves 的调用，这应该让你想起我们之前见过的一种结构。

and then to make this work I just need to define leaf that's a predicate that says is

然后为了使它工作，我只需要定义 leaf，这是一个谓词，用来判断……

leaf that's a predicate that says is this an element or not and that's easy. I'll first check to see if it's a pair; if it is then it can't be a leaf because it's part of the tree and so I'll use not a pair to implement my notion of a leaf predicate.

leaf 是一个谓词，用来判断这是否是一个元素，这很容易。我首先检查它是否是一个序对；如果是，那么它不可能是叶子，因为它是树的一部分，所以我会用 not (pair? ...) 来实现我的叶子谓词的概念。

step back for a second notice how again the definition of this procedure reflects the structure of the tree here at each level I have a choice. I have two branches down one half or down the other half of the tree and that means I need two recursive calls to deal with the structures hanging below it.

退后一步，注意这个过程的定义再次反映了树的结构。在每一层，我都有一个选择。我有两个分支，要么向下走树的一半，要么向下走树的另一半，这意味着我需要两个递归调用来处理挂在下面的结构。

with the structures hanging below it, compare that as we've already suggested to the kinds of procedures we had that worked with lists where in fact we had one recursive call plus something to deal with the first element. This message is one we're going to repeat many times: the recursive structure of the procedure will tend to reflect the recursive structure of the data structure itself. They should go hand-in-hand in terms of walking the data structure while computing new values or manipulating new data structures, because this is a new

处理挂在下面的结构，将其与我们之前提到的处理列表的过程进行比较，实际上我们有一个递归调用加上处理第一个元素的东西。这个信息我们将重复多次：过程的递归结构往往反映数据结构本身的递归结构。在遍历数据结构的同时计算新值或操作新数据结构时，它们应该相辅相成，因为这是一种新的数据结构，而且我们正在创建新的过程来操作它们。让我们更仔细地看一下。这里又是我们的 count-leaves 代码，那两个基本情况，然后是递归调用，其中涉及两个递归，一个沿着树的 car 向下，一个沿着树的 cdr 向下。让我们用替换模型看看它如何做正确的事情，或者至少我们希望它做正确的事情，我们将分阶段进行。这是第一个简单的例子，让我们做 count……

data structures because this is a new kind of data structure and because we're creating new kinds of procedures to manipulate them. Let's look at this a little more carefully. Here again is our code for count leaves, those two base cases, and then read the recursive call which involves two recursions, one down the car of the tree, one down the quarter of the tree. Let's use our substitution model to see how this does the right thing, or at least we hope it does the right thing, and we'll do this in stages. Here's the first simple example, let's do count.

数据结构，因为这是一种新的数据结构，而且我们正在创建新的过程来操作它们。让我们更仔细地看一下。这里又是我们的 count-leaves 代码，那两个基本情况，然后是递归调用，其中涉及两个递归，一个沿着树的 car 向下，一个沿着树的 cdr 向下。让我们用替换模型看看它如何做正确的事情，或者至少我们希望它做正确的事情，我们将分阶段进行。这是第一个简单的例子，让我们做 count……

first simple example let's do count leaves on the list of two and of course I'm using lists to construct the tree so this is just a leet tree of one leaf to be very careful I'm going to replace the list of two with the box and pointer notation so we can see how it's grabbing the pieces so we're doing count leaves on this structure what does that caused us to do well equivalently that's kau leaves on the list of one element - and I'm cheating a little bit here that's not the procedure application of - that's representing a list of just one element - I check my bases the cases

第一个简单的例子，让我们对包含两个元素的列表做 count-leaves，当然我用列表来构造树，所以这只是一个包含一个叶子的树。为了非常小心，我将把包含两个元素的列表替换为盒子和指针表示法，这样我们就能看到它是如何抓取各个部分的。所以我们对这个结构做 count-leaves，这会导致我们做什么呢？等价地，那就是对包含一个元素的列表做 count-leaves——我这里有点作弊，那不是过程应用，而是表示只包含一个元素的列表——我检查我的基本情况。

element - I check my bases the cases. Then the base cases do not hold it's not empty and notice I can see that because it's not new I also know it's not a leaf because the structure that's passed in is a pair and therefore leaf does not hold true.

元素——我检查我的基本情况。然后基本情况不成立，它不是空的，注意我可以看到这一点，因为它不是 null；我也知道它不是叶子，因为传入的结构是一个序对，因此 leaf 不成立。

As a consequence I go to the recursive case in which I do count leaves on the car of the tree. Notice the car structure there grabs the element - I also do count leaves on the quarter of the tree that takes the element in the quarter box which is just meal and I add them together.

因此，我进入递归情况，对树的 car 做 count-leaves。注意，那里的 car 结构抓取元素——我也对树的 cdr 做 count-leaves，它取 cdr 框中的元素，那只是 nil，然后将它们相加。

将他们放在一起，现在每一个递归案例都做了正确的事情。第一个count-leaves有一个单一元素——它是现在吗？不，它是一个叶子吗？是的，因为它不是一对，所以我因此返回一。

将他们放在一起，现在每一个递归案例都做了正确的事情。第一个count-leaves有一个单一元素——它是现在吗？不，它是一个叶子吗？是的，因为它不是一对，所以我因此返回一。

第二个调用count-leaves实际上有一个空树，它返回零，和的和当然是给我一。如果我回头看我的方框和指针图，那正好在这里，有一个叶子，所以这个简单案例已经工作了。

第二个调用count-leaves实际上有一个空树，它返回零，和的和当然是给我一。如果我回头看我的方框和指针图，那正好在这里，有一个叶子，所以这个简单案例已经工作了。

好吧，让我们尝试一个稍微难一点的例子，再次有我的代码，就像之前一样，这样你可以看到它。

好吧，让我们尝试一个稍微难一点的例子，再次有我的代码，就像之前一样，这样你可以看到它。

code just like before so you can see it

代码就像之前一样，这样你可以看到它。

code just like before so you can see it let's do count leaves on the list of five and seven notice what this is this is a tree whose first branch is just the number five and whose second branch is itself another subtree and it has one leaf seven.

代码就像之前一样，这样你可以看到它。让我们对列表（五 七）执行count-leaves。注意这是什么：这是一棵树，其第一个分支就是数字五，第二个分支本身是另一个子树，它有一个叶子七。

if I use my box and pointer diagram to represent this I'm doing count leaves on the structure shown a list of two elements this is equivalent of doing count leaves on the list structure shown as the open paren five seven close print.

如果我使用方框和指针图来表示这个，我是在对所示的结构执行count-leaves，即一个包含两个元素的列表。这等同于对列表结构（五 七）执行count-leaves。

I run my cases neither the base cases hold here so I do the recursive call doing count leaves on the

我运行我的案例，这里两个基础案例都不成立，所以我进行递归调用，对树的car执行count-leaves。

recursive call doing count leaves on the car of the tree notice that's going to just be the number five it's a leaf and count leaves on the core of the tree notice the cooter that first box points itself to a list so it's a sub tree and now we see is shown by the fact that we have

递归调用对树的car执行count-leaves，注意那将只是数字五，它是一个叶子；以及对树的cdr执行count-leaves，注意cdr，第一个框指向一个列表，所以它是一个子树，现在我们看到，正如所示，传入的元素是（七）。

/ n7 clothes print as the element passed in I'm going to take the sum of those two things doing count leaves on five well that's pretty easy the base case says it isn't now but it is a leaf I returned one the second called account leaves notice is going to be more

我将取这两者的和。对五执行count-leaves，那很简单，基础案例说它不是空，但它是叶子，我返回一。第二个调用count-leaves，注意将更加仔细：它是空吗？不。它是叶子吗？不，它是一棵树，因此我对car（数字七）和cdr（这个子树的空）执行count-leaves的和，然后递归地我做同样的事情，最终得到二，这正是我想要的。

leaves notice is going to be more careful is it empty no is it a leaf no it's a tree and therefore I do the sum of doing count leaves on the car it's the number seven and the cutter which is empty of this subtree and then recursively I do the same things and I end up with two which is what I wanted okay now let's try a full-fledged example here's a new tree that has that full structure of three sub trees at the top level two of which are just leaves and another sub tree in the middle that in fact itself has several sub trees underneath it

好吧，现在让我们尝试一个完整的例子。这里有一棵新树，具有完整的结构：顶层有三个子树，其中两个只是叶子，中间还有一个子树，它本身又有几个子树在它下面。

Several sub trees underneath it. Let's run count leaves on this example. This is going to give me countless run on that list structure and we can notice that it will do the standard decomposition at the first level, which is going to reduce to doing a count leaves on the first element which is four and count leaves on the remainder of that structure. In fact, it's going to count up and give us the right answer.

其下有几个子树。让我们在这个例子上运行 count-leaves。这将对那个列表结构进行 count-leaves 调用，我们可以注意到，它会在第一层进行标准的分解，即对第一个元素（即 4）进行 count-leaves，并对该结构的其余部分进行 count-leaves。事实上，它会累加起来并给出正确的答案。

But let's see if we can quickly trace how it does this. So here's the first call to count leaves. I've just abbreviated it CL to make life a little easier.

但让我们看看能否快速追踪它是如何做到的。这是对 count-leaves 的第一次调用。为了简化，我将其缩写为 CL。

abbreviated it CL to make life a little easier for me being called on this list structure and I'm putting it in blue just to distinguish that in fact it is list structure and not a procedure call as it might appear recursively we know what this does it reduces to applying count leaves to the first element and count leaves to the remainder of the tree so here's that recursive decomposition I'm going to add up what I get by counting down the first branch which is count Lisa four so whatever I get by counting down the second branch which is that subtree as shown well

为了简化，我将其缩写为 CL，它被调用在这个列表结构上，我用蓝色标记它，以区分它实际上是列表结构，而不是像递归中可能看起来的过程调用。我们知道它的作用：它归结为对第一个元素应用 count-leaves，并对树的其余部分应用 count-leaves。所以这是递归分解。我将把对第一个分支进行计数得到的结果（即 count-leaves 4）与对第二个分支进行计数得到的结果（即所示的那个子树）相加。

which is that subtree as shown well doing cat leaves down the first branch is easy that we know by one of the base cases just returns one and of course the recursive call over here is going to do the same thing is going to reduce to counting down the first element and counting down the remainder of the tree.

即所示的那个子树。对第一个分支进行 count-leaves 很容易，根据一个基本情况我们知道它只返回 1，当然，这里的递归调用也会做同样的事情：它将归结为对第一个元素进行计数，并对树的其余部分进行计数。

and now you get the idea at each level of the tree we're calling count leaves on the first element of the tree and adding that to whatever you get by counting counting the leaves in the remainder of the tree that keeps reducing until we get down to a leaf.

现在你明白了：在树的每一层，我们都对树的第一个元素调用 count-leaves，并将其与对树的其余部分进行计数得到的结果相加。这个过程不断简化，直到我们到达一个叶子。

Reducing until we get down to a leaf in which case we have a 1, or we get down to an empty tree in which case we have a zero. And eventually those all accumulate together to add up to the things that we want of course.

不断简化，直到我们到达一个叶子，此时我们得到 1，或者到达一个空树，此时我们得到 0。最终，所有这些结果累积起来，加起来得到我们想要的结果。

Not only can we write procedures that directly manipulate trees, we can capture general patterns just as we had the notion of map for lists. We have a similar idea for trees shown here. Here we need to separate out two different base cases: the empty tree and a leaf or isolated element of the tree. For the empty tree, we just return an empty tree.

我们不仅可以编写直接操作树的程序，还可以捕获一般模式，就像我们对列表有 map 的概念一样。这里展示了树的类似思想。这里我们需要区分两个不同的基本情况：空树和叶子（即树的孤立元素）。对于空树，我们只返回空树。

empty tree we just return an empty tree for a leaf we simply apply the procedure in the general case we have to be a bit more careful about our data structure a tree is a list each of whose elements might itself be a tree so we can split a tree into its car in its coder each of which is a tree we must then map our procedure down each of these sub pieces and then glue them back together this is different than mapping down a list where we could just directly cost the processed first element onto the remainder of the list note that

对于空树，我们只返回空树；对于叶子，我们只需应用该过程。在一般情况下，我们必须对数据结构更加小心：树是一个列表，其每个元素本身可能是一棵树，所以我们可以将树拆分为其 car 和 cdr，它们各自是一棵树。然后我们必须将我们的过程映射到这些子部分中的每一个，然后将它们重新组合在一起。这与映射列表不同，在列表中我们可以直接将处理后的第一个元素 cons 到列表的其余部分。注意

remainder of the list note that induction holds in this case as well. For each of the two base cases, we get back an appropriate tree, either an empty tree or a single leaf, which is a tree in the inductive case. We know that both the car and the core of the tree are trees of smaller size, so we can assume that tree map correctly returns a process tree.

列表的其余部分。注意在这种情况下归纳也成立。对于两个基本情况中的每一个，我们得到一个合适的树，要么是空树，要么是单个叶子，它是一棵树。在归纳情况下，我们知道树的 car 和 cdr 都是更小的树，所以我们可以假设 tree-map 正确地返回一棵处理过的树。

Then we know that cons will glue each of these pieces back into the larger tree, and hence by induction, this code will correctly process trees of all sizes. We can capture higher order operations on

然后我们知道 cons 会将每个部分重新组合成更大的树，因此通过归纳，这段代码将正确地对所有大小的树进行处理。我们可以捕获树上的高阶操作，

can capture higher order operations on trees beyond just mapping for example this code allows us to specify what operation we want to apply to each leaf of the tree and how we want to glue the pieces together. Using this we can map procedures onto each element of the tree, or we can count up the number of leaves in a tree, or we can reverse the elements of the tree both at the top level and at.

可以捕获树上的高阶操作，而不仅仅是映射。例如，这段代码允许我们指定要对树的每个叶子应用什么操作，以及如何将各部分组合在一起。使用这个，我们可以将过程映射到树的每个元素上，或者我们可以计算树中叶子的数量，或者我们可以反转树的元素，既在顶层也在……