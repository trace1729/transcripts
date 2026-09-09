# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=20)

In this lecture, we're going to return to the theme of evaluation and look at it from two different perspectives to set the stage for what we're going to do. Let's recall the primary goal of evaluation. We have argued that the eval apply cycle is the central element of a language; it is the component that enables us to program in a high-level language. That eval apply cycle lets us write programs in an abstract way, since it will unwind those abstractions at evaluation time, reducing them to a set of primitive operations on primitive.

在本讲中，我们将回到评估这一主题，并从两个不同的视角来审视它，以便为接下来的内容奠定基础。让我们回顾一下评估的主要目标。我们曾论证过，求值-应用循环是语言的核心要素；它是使我们能够用高级语言编程的组件。这个求值-应用循环让我们能够以抽象的方式编写程序，因为它在求值时会展开这些抽象，将它们还原为一组对原始数据对象的原始操作。

of primitive operations on primitive data objects this then connects the descriptions we write at an abstract level to the actual machine operations for determining meanings of expression this key idea means that the evaluator is the component that defines our language for us it encapsulates the rules for determining the meaning of an abstract expression in terms of more primitive operations and thus it spells out the semantics of our length of particular importance here is the fact that describing the process of evaluation is exactly that a description

对原始数据对象的一组原始操作，这便将我们以抽象层次编写的描述与确定表达式含义的实际机器操作联系了起来。这一关键思想意味着，求值器是定义我们语言的组件；它封装了根据更原始的操作来确定抽象表达式含义的规则，从而阐明了我们语言的语义。特别重要的是，描述求值过程恰恰就是对过程的描述。

evaluation is exactly that a description of a process, this means that we can capture that description in a procedure, and thus the evaluator is just another program. The relevance of this observation is that we can explore variations on languages by simply modifying the evaluator. Thus in this lecture we're going to build on this idea under two different perspectives: first from the perspective of a language designer, that is, how can we take advantage of the fact the evaluator is just a program to change the manner in which the language evolves? And then

求值过程恰恰就是对过程的描述，这意味着我们可以将该描述捕获在一个过程中，因此求值器也只是另一个程序。这一观察的相关性在于，我们可以通过简单地修改求值器来探索语言的变体。因此，在本讲中，我们将从两个不同的视角来构建这一思想：首先，从语言设计者的视角，即我们如何利用求值器只是一个程序这一事实来改变语言演进的方式；其次，

which the language evolves and then secondly from the perspective of a theorist, that is, how can we use the fact that the evaluator is a program to answer fundamental questions about what is complete. Let's start by thinking like a designer. If we think about what we have seen with the Vallon apply, we know that the basic cycle is given an expression and an environment in which to interpret the symbols of the expression.

语言演进的方式，其次，从理论家的视角，即我们如何利用求值器是一个程序这一事实来回答关于完备性的基本问题。让我们从设计者的角度开始思考。如果我们思考一下我们所看到的求值-应用，我们知道基本循环是：给定一个表达式和一个环境，在该环境中解释表达式的符号。

Let's unwind the expression into an evaluation of a simpler expression with respect to an extended environment, and keep doing that until we

让我们将表达式展开为对更简单表达式相对于扩展环境的求值，并持续这样做，直到我们

environment and keep doing that until we can return a value the problem is that this may involve a lot of wasted computation an alternative is to try and analyze the expression as much as possible before interpret this means that we could try to extract as much information as possible about the expression without actually looking up values of elements within the expression this static analysis stage would attempt to convert the expression to a more form so that when evaluated with respect to some environment it would lead to better computational performance so why

环境，并持续这样做，直到我们能返回一个值。问题在于，这可能涉及大量浪费的计算。另一种方法是尝试在解释之前尽可能多地分析表达式。这意味着我们可以尝试在不实际查找表达式内元素值的情况下，尽可能多地提取关于表达式的信息。这个静态分析阶段将尝试将表达式转换为更形式化的形式，以便在相对于某个环境求值时，能带来更好的计算性能。那么为什么

better computational performance so why would we want to do this well a key reason is that this can enable us to avoid repeated unnecessary work we'll see an example of this shortly

更好的计算性能，那么为什么我们要这样做呢？一个关键原因是，这能使我们避免重复的不必要工作。我们稍后将看到一个例子。

the second reason is that by statically analyzing an expression we may be able to catch a lot of errors

第二个原因是，通过静态分析表达式，我们或许能够捕捉到许多错误。

if you think about it you'll realize that under the standard scheme we don't catch bugs until evaluation or execution time and this can be a pain often it would be better if we could catch typos or wrong number or wrong type of arguments and other such errors

如果你仔细想想，就会意识到在标准方案下，我们直到求值或执行时才能发现错误，这可能很麻烦。通常，如果我们能在实际使用过程之前捕捉到拼写错误、参数数量或类型错误以及其他此类错误，那会更好。

type of arguments and other such errors before we actually try to use our procedures and we'll see how static analysis can help us do that. What does it mean to avoid wasted work? Well, suppose we evaluate our standard definition of factorial as shown here. Now suppose we are applying factorial to some argument, which means we are evaluating the application of the procedure to an argument. Think about what happens inside of eval: first, eval must run through its case analysis to determine that this expression is an application. It must then run through its

参数类型错误以及其他此类错误，在我们实际尝试使用过程之前。我们将看到静态分析如何帮助我们做到这一点。避免浪费工作意味着什么呢？假设我们求值标准的阶乘定义，如图所示。现在假设我们将阶乘应用于某个参数，这意味着我们正在求值过程对参数的应用。想想在求值器内部发生了什么：首先，求值器必须运行其案例分析以确定该表达式是一个应用。然后，它必须运行其

In an application, it must then run through its case analysis again to decide that the fact is a symbol and to look up its binding. Similarly, with looking up the value of the argument, then it must run through its case analysis yet another time to determine that the body is an if expression, and then it must evaluate the predicate.

在一个应用中，它必须再次运行其案例分析以确定事实是一个符号并查找其绑定。类似地，在查找参数的值时，它必须再次运行其案例分析以确定函数体是一个 if 表达式，然后它必须求值谓词。

This means that we have to run through the case analysis of a valve, that big cond clause, four times in order to get to this stage. But now the evaluation of the predicate is false, so this reduces to a multiplication of an by a recursive call to fact.

这意味着我们必须运行求值器的案例分析（那个大的 cond 子句）四次才能到达这个阶段。但现在谓词的求值为假，因此这简化为将 n 与对 fact 的递归调用相乘。

by a recursive call to fact the problem is that now the evaluator runs through exactly the same set of case analysis four times even though we know that the body is an if so we repeat all of that work just to get back to the same point.

对 fact 的递归调用相乘。问题在于，现在求值器运行完全相同的四次案例分析，即使我们知道函数体是一个 if。因此，我们重复了所有那些工作，只是为了回到同一点。

wouldn't it be nice if we could avoid this that is if we could take advantage of the fact that in passing through the code once we've already deduced a lot of information about the procedure and its structure we're going to do that by building a variant of the evaluator that statically analyzes expressions before

如果我们能避免这种情况，那不是很好吗？也就是说，如果我们能利用这样一个事实：在遍历代码一次时，我们已经推导出关于过程及其结构的大量信息。我们将通过构建一个求值器的变体来做到这一点，该变体在求值之前静态分析表达式。

building a variant of the evaluator that statically analyzes expressions before

构建一个求值器的变体，该变体在求值之前静态分析表达式。

statically analyzes expressions before evaluation so here's a summary of the key points of this part of the lecture here is the strategy that we're going to follow as we sketch the design for a new evaluator our goal is to separate static analysis from evaluation so we wanted to score I've an analyzed stage in which an expression is converted into a new form that form at execution stage will be coupled with an environment to complete the rules of evaluation to do this we're going to need to specify what the analyze stage should produce

在求值之前静态分析表达式。以下是本部分讲座要点的总结。以下是我们勾勒新求值器设计时将遵循的策略。我们的目标是将静态分析与求值分离。因此，我们希望有一个分析阶段，在该阶段中，表达式被转换为一种新形式，该形式在执行阶段将与环境结合以完成求值规则。为此，我们需要指定分析阶段应产生什么。

analyze stage should produce we are going to have it produce an execution procedure that is the analysis is going to convert the expression into a procedure that takes a single argument an environment when this procedure is applied to an environment it will use the bindings of symbols in that environment to complete the evaluation of the expression as a consequence our new evaluator will first use analyze to convert an expression just based on its structure into this execution procedure which can then be applied to the environment this will make more sense if

分析阶段应当产生——我们将让它产生一个执行过程，即分析将把表达式转换为一个接受单个参数（环境）的过程。当这个过程应用于环境时，它将利用该环境中符号的绑定来完成表达式的求值。因此，我们的新求值器将首先使用 analyze 仅基于表达式的结构将其转换为这个执行过程，然后该过程可以应用于环境。如果我们看一些分析不同类型表达式的例子，这会更有意义。

environment this will make more sense if we look at some examples of analyzing different kinds of expressions so let's do that a simple place to start would be with an expression that is just a variable we had like our analysis stage to recognize this as a variable and create a procedure that will actually look up the value of the variable in an environment when asked to thus the output of the analysis stage should be a procedure of one argument an environment whose body will be the actual lookup process note that we want this to hold

如果我们看一些分析不同类型表达式的例子，这会更有意义。让我们这样做。一个简单的起点是仅包含变量的表达式。我们希望分析阶段将其识别为变量，并创建一个过程，该过程在被要求时会在环境中查找变量的值。因此，分析阶段的输出应该是一个接受一个参数（环境）的过程，其主体将是实际的查找过程。注意，我们希望这对任何变量都成立。

process note that we want this to hold for any variable so our procedures body should simply look up a name where the environment part of the procedure contains the specific binding of the name in this case pi if we were then to apply this procedure to some environment the actual evaluation would first look up the binding for name which is pi and then it would look up the binding for that specific variable name in the environment note as a consequence that we have two separate structures being used here the analyze stage will create a procedure whose environment contains

注意，我们希望这对任何变量都成立。因此，我们的过程主体应该简单地查找一个名称，而过程的环境部分包含该名称（此处为 pi）的特定绑定。如果我们随后将这个过程应用于某个环境，实际求值将首先查找名称（即 pi）的绑定，然后在该环境中查找该特定变量名的绑定。注意，因此这里使用了两个独立的结构：分析阶段将创建一个过程，其环境包含

A procedure whose environment contains bindings for the parts of the expression. At evaluation time we will provide a data structure for the specific values of symbols that will be used to complete the evaluation. So how do we capture this? Well, our analyze procedure will dispatch on type just as our evaluator did in the case of an expression that is a variable. We will return a procedure whose body captures the idea of looking up the value of a variable. Notice that the black part of this expression gets evaluated at the analysis stage.

一个过程，其环境包含表达式各部分的绑定。在求值时间，我们将提供一个数据结构，用于符号的具体值，以完成求值。那么我们如何捕捉这一点呢？嗯，我们的 analyze 过程将像我们的求值器一样按类型分派。对于变量表达式，我们将返回一个过程，其主体捕捉了查找变量值的概念。注意，这个表达式的黑色部分在分析阶段被求值。

evaluated at the analysis stage that is the procedure will be built with a pointer to an environment that contains the binding for exp

在分析阶段被求值，即该过程将构建一个指向包含 exp 绑定的环境的指针。

the blue part will be evaluated at evaluation time when this procedures apply to an environment in which case the binding for X will be looked up in the provided environment so let's see if you're getting this idea

蓝色部分将在求值时间被求值，当这个过程应用于环境时，在这种情况下，X 的绑定将在提供的环境中被查找。所以让我们看看你是否理解了这个想法。

how would you implement the analysis of an expression that is just a number when you're ready go to the next slide

你将如何实现仅包含数字的表达式的分析？当你准备好时，转到下一张幻灯片。

write a numbers value is just itself so we simply return a procedure of one argument whose body just returns the

嗯，数字的值就是它本身，所以我们简单地返回一个接受一个参数的过程，其主体只是返回

argument whose body just returns the argument whose body just returns the value of the expression so here's a summary of this part of the lecture now let's look at a more complex expression

接受一个参数的过程，其主体只是返回表达式的值。所以这是本部分讲座的总结。现在让我们看一个更复杂的表达式。

suppose we want to analyze an if expression such as the one that comes from the body of fact at the analysis stage we want to take each of the parts of the if and recursively do our analysis

假设我们想要分析一个 if 表达式，例如来自 fact 主体的那个。在分析阶段，我们希望获取 if 的每个部分并递归地进行分析。

each of these stages should then produce an execution procedure for example the second one will just give us the procedure we saw in the last example for dealing with numbers

这些阶段中的每一个都应该产生一个执行过程，例如第二个将给我们上一个例子中处理数字的过程。

note that this analysis will help us

注意，这种分析将帮助我们

note that this analysis will help us save the extra work that motivated all of this as we can analyze each piece statically once and produce a procedure that will do the actual evaluation given an environment.

注意，这种分析将帮助我们节省激发这一切的额外工作，因为我们可以静态地分析每个部分一次，并产生一个过程，在给定环境的情况下进行实际求值。

in the case of factorial this environment will simply contain different bindings for the variable n at the execution stage we will simply complete the evaluation of the predicate expression and based on its value either to complete the evaluation of the consequence or the alternative.

在阶乘的情况下，这个环境将简单地包含变量 n 的不同绑定。在执行阶段，我们将简单地完成谓词表达式的求值，并根据其值完成对结果或替代的求值。

so here's the code to do this the analysis stage will do the

所以这是执行此操作的代码。分析阶段将进行

This the analysis stage will do the actual analysis of the sub expressions and glue these together into a procedure for use at execution time. Only at that time will the execution procedures be applied to determine which of the consequent and alternative is to be used.

分析阶段将进行子表达式的实际分析，并将它们组合成一个过程以供执行时使用。只有在执行时，执行过程才会被应用以确定使用结果还是替代。

A visualization of this is shown here. When analyzed gets an if expression, it produces an execution procedure whose environment contains pointers to the procedures associated with execution of each of the sub expressions. Those procedures come from the recursive application of analyze, such as the one.

这里显示了可视化。当 analyze 得到一个 if 表达式时，它产生一个执行过程，其环境包含指向与每个子表达式执行相关的过程的指针。这些过程来自 analyze 的递归应用，例如

application of analyze such as the one shown for the sub expression that's just a number so what about things like definitions how would you complete the analysis of an expression like this when you think they have the answer go to the next slide

analyze 的递归应用，例如针对仅包含数字的子表达式所示的过程。那么像定义这样的东西呢？你将如何完成像这样的表达式的分析？当你认为你有答案时，转到下一张幻灯片。

well the variable part we don't want to analyze since it is just a symbol to be bound at execution time we do analyze the value to be associated with the variable then glue this together into an execution procedures so that at evaluation time that value is actually computed and then bound to the symbol

嗯，变量部分我们不想分析，因为它只是一个在执行时要绑定的符号。我们确实分析要与变量关联的值，然后将其组合成一个执行过程，以便在求值时间实际计算该值，然后绑定到符号。

computed and then bound to the symbol so. Here's a summary of this part of the lecture. There are a few other changes we need to make to our evaluator to allow for static analysis. One deals with how we implement lambda. Notice that in our new approach, the body stored within a double bubble is now an execution procedure — that is, something that needs to be applied to an environment at execution time.

计算然后绑定到符号。所以这是本部分讲座的总结。我们需要对我们的求值器进行一些其他更改以允许静态分析。一个涉及我们如何实现 lambda。注意，在我们的新方法中，存储在双气泡中的主体现在是一个执行过程——也就是说，需要在执行时应用于环境的东西。

Thus, in the original eval or make procedure method, we would glue together a list of variables, an expression to be evaluated when we applied the procedure, and an environment.

因此，在原始的 eval 或 make procedure 方法中，我们会将变量列表、一个在应用过程时要求值的表达式以及一个环境组合在一起。

applied the procedure and an environment that captured the meanings of the symbols in the expression. Here we need our make procedure to use an execution procedure in place of the expression, since that is what will be applied when we go to evaluate the body of a procedure.

应用过程时，以及一个捕捉表达式中符号含义的环境。在这里，我们需要我们的 make procedure 使用执行过程代替表达式，因为那将是我们在求值过程主体时要应用的东西。

Thus, when we analyze a lambda expression, we will analyze the body to get the appropriate execution procedure, whose application will complete the body's evaluation. We glue it together with the variable names and the environment of course. If our lambda objects are different, then application...

因此，当我们分析一个 lambda 表达式时，我们会分析其函数体以获得相应的执行过程，该执行过程的应用将完成函数体的求值。我们将其与变量名和环境粘合在一起，当然。如果我们的 lambda 对象不同，那么应用……

objects are different then application of a lambda will also have to be a bit different previously an application would simply resulted in the evaluation of the body with respect to an extended environment now it results in applying the execution procedure that corresponds to the body to the execution environment

对象不同，那么 lambda 的应用也必须略有不同。以前，应用只是相对于扩展环境对函数体进行求值；现在，它变成了将对应于函数体的执行过程应用于执行环境。

and hence the analysis of an application that is something like fact 3 will require that we analyze each of the sub expressions just as we would have evaluated each of the sub expressions in the normal evaluator then we create an

因此，对诸如 fact 3 这样的应用的分析将要求我们分析每个子表达式，就像在普通求值器中我们会求值每个子表达式一样；然后我们创建一个……

The normal evaluator then we create an execution procedure that at evaluation time applies the body to the values of the arguments while there are additional details in the textbook about the analyze evaluator this completes the sketch of the key changes.

在普通求值器中，然后我们创建一个执行过程，在求值时间将函数体应用于参数的值。虽然教科书中有关于分析求值器的更多细节，但这完成了关键变化的概述。

The main issue to notice is how we can separate the static analysis of the code from the actual determining of its meaning this allows us to avoid repeating that analysis each iteration through a loop leading to much more efficient code.

需要注意的主要问题是，我们如何将代码的静态分析与实际确定其含义分开。这使我们能够避免在每次循环迭代中重复该分析，从而产生更高效的代码。

Now let's go back to thinking about evaluation in very abstract terms we can ask the question.

现在让我们回到以非常抽象的方式思考求值。我们可以问这样一个问题。

abstract terms we can ask the question what is a vowel really and here's one way of thinking about it imagine that you're a circuit designer and you want to automate the process of designing circuits one can envision taking a circuit diagram and somehow encoding it electronically with signals to represent the components and their connections now you want to build a circuit that takes as input a signal representing the electronic version of one of those circuit diagrams and have this general circuit reconfigure itself so that it behaves

以抽象的方式，我们可以问：求值器到底是什么？这里有一种思考方式：想象你是一名电路设计师，你想要自动化电路设计的过程。可以设想，取一个电路图，并以某种方式用电子信号对其进行编码，以表示组件及其连接。现在，你想要构建一个电路，它接收一个表示这些电路图之一的电子版本的信号作为输入，并让这个通用电路重新配置自身，使其行为……

重新配置自身，使其行为与图中描述的电路完全一致。这种通用电路将极其有用，因为我们可以只构建那个通用电路，然后让它表现得像任何其他电路一样。关键问题是，如何构建这样的电路？嗯，这是个难题。

重新配置自身，使其行为与图中描述的电路完全一致。这种通用电路将极其有用，因为我们可以只构建那个通用电路，然后让它表现得像任何其他电路一样。关键问题是，如何构建这样的电路？嗯，这是个难题。

所以，换个角度，假设你正在用过程语言，也就是程序，来描述一个电路。同样的问题依然存在：我们能构建一个程序，它接收任何其他程序的描述作为输入，并重新配置自身吗？

所以，换个角度，假设你正在用过程语言，也就是程序，来描述一个电路。同样的问题依然存在：我们能构建一个程序，它接收任何其他程序的描述作为输入，并重新配置自身吗？

other program as input and reconfigures itself to behave like the described program. As you should realize, the answer is clearly yes — that's exactly what eval is doing. We say that eval is an example of a universal machine, that is, it can behave like any other machine whose process can be described using the language of description, namely as a procedure.

接收其他程序作为输入，并重新配置自身以表现得像所描述的程序。正如你应该意识到的，答案显然是肯定的——这正是 eval 所做的。我们说 eval 是通用机器的一个例子，也就是说，它可以表现得像任何其他机器，只要其过程可以用描述语言（即作为过程）来描述。

This is an incredibly powerful idea, since it says one can describe the process of evaluation for any kind of process. This idea wasn't always that obvious, as is shown by this quote, but it's a very powerful idea and we want to.

这是一个极其强大的想法，因为它表明人们可以描述任何过程的求值过程。这个想法并不总是那么明显，正如这段引文所示，但这是一个非常强大的想法，我们想要……

It's a very powerful idea and we want to briefly explore how this idea of a universal machine affects our understanding of computation in general. Why do we say eval is a universal machine?

这是一个非常强大的想法，我们想要简要探讨通用机器的概念如何影响我们对计算的一般理解。为什么我们说 eval 是一台通用机器？

We have argued that it describes the process of evaluation for any legal expression in our language, and since procedures are our way of capturing processes, this means it describes the evaluation of any process. One consequence of that is that sense of eval itself is a process.

我们已经论证，它描述了语言中任何合法表达式的求值过程，并且由于过程是我们捕捉过程的方式，这意味着它描述了任何过程的求值。其一个后果是，eval 本身就是一个过程。

If eval can simulate itself, indeed that was our example of our meta-circular M.

如果 eval 可以模拟自身，事实上，这正是我们的元循环求值器的例子。

这是我们元循环求值器的一个例子，我们用Scheme的求值器来描述求值过程。这意味着我们可以探索求值的变化，比如惰性求值，只需简单地改变求值描述的第二个后果，即eval可以模拟任何语言的求值器。

这是我们元循环求值器的一个例子，我们用 Scheme 的求值器来描述求值过程。这意味着我们可以探索求值的变化，比如惰性求值，只需简单地改变求值描述的第二个后果，即 eval 可以模拟任何语言的求值器。

因此，我们可以用Scheme编写一个针对C、C++或Fortran的求值器，只需描述我们语言中的求值过程。事实上，这适用于任何语言，也就是说，我们可以用一种语言来描述另一种语言的求值过程。

因此，我们可以用 Scheme 编写一个针对 C、C++ 或 Fortran 的求值器，只需描述我们语言中的求值过程。事实上，这适用于任何语言，也就是说，我们可以用一种语言来描述另一种语言的求值过程。

evaluation of one language in any other language this implies that anything we can compute in one language we can also compute in any other language and that leads to a general notion of computability things computable in one language are computable in any other

用一种语言在另一种语言中求值，这意味着我们在一种语言中能计算的任何东西，在另一种语言中也能计算，这引出了可计算性的一般概念：在一种语言中可计算的事物在另一种语言中也可计算。

Hance the idea of a universal machine this insight of a universal machine and the notion of computability is essentially due to one man Alan Turing an English mathematician who in many ways is the father of computer science

因此，通用机器的概念。通用机器和可计算性概念的这一洞见本质上归功于一个人：艾伦·图灵，一位英国数学家，他在许多方面是计算机科学之父。

here is a very brief sketch of Touring's idea as the student touring was trying

以下是图灵思想的简要概述。作为学生，图灵试图……

Idea as the student touring was trying to address a famous mathematical problem posed by David Hilbert. It asked whether there was a fixed definite process by which one could answer any mathematical question.

作为学生，图灵试图解决大卫·希尔伯特提出的一个著名数学问题。该问题问是否存在一个固定的确定过程，通过它人们可以回答任何数学问题。

The motivation came from considering the problem of proving theorems in geometry. One could imagine a process in which one first considered all proofs that followed in one step from a fixed set of axioms, then in two steps, and so on.

其动机来自考虑几何中证明定理的问题。可以想象一个过程，首先考虑从一组固定公理出发一步内得出的所有证明，然后两步，依此类推。

Touring was trying to answer this problem, and he did so by interpreting the notion of process.

图灵试图回答这个问题，他通过非常字面地解释过程的概念来做到这一点。

so by interpreting the notion of process very literally he constructed a simple kind of machine showed how you could encode other processes in terms of this machine and basically wrote the first eval he then used this Turing machine as it is now called to answer a fundamental question in computation

通过非常字面地解释过程的概念，他构建了一种简单的机器，展示了如何将其他过程编码为这种机器，并基本上编写了第一个 eval。然后，他使用这种现在称为图灵机的机器来回答计算中的一个基本问题。

specifically are there problems that cannot be solved by computational process if there is a problem that a universal machine cannot solve then no machine can solve it and hence there is no effective process for this problem to answer this question

具体来说，是否存在无法通过计算过程解决的问题？如果存在一个通用机器无法解决的问题，那么任何机器都无法解决它，因此对于这个问题没有有效的过程。为了回答这个问题……

Taurine used the following argument; his version was, of course, much more intricate, but the basic idea is the same. First, make a list of all possible programs that take a single input. Arbitrarily number them and think of them as the rows of a big matrix. Second, encode their possible inputs as integers using some mechanism, and let those inputs form the columns of this matrix.

图灵使用了以下论证；他的版本当然要复杂得多，但基本思想是相同的。首先，列出所有接受单个输入的可能程序。任意编号，并将它们视为一个大矩阵的行。其次，使用某种机制将它们的可能输入编码为整数，并让这些输入形成该矩阵的列。

Now, write down the response of each machine to each input as an integer, as an error, or indicate if the machine lives forever for this input. Of course, this setup allows us to analyze the behavior of each program systematically.

现在，将每个机器对每个输入的响应写为整数、错误，或者指示该机器对于该输入是否永远运行。当然，这种设置使我们能够系统地分析每个程序的行为。

Lives forever for this input of course. One wouldn't actually write out all of these values for this matrix, but the argument is that one could now construct a new program whose output on input is whatever the ant's machine outputs for that input plus one if the machine actually provides an answer, otherwise returns zero.

当然，对于这个输入，它会永远运行下去。实际上，人们不会真的写出这个矩阵的所有值，但论证的关键在于，现在可以构造一个新程序，当输入某个值时，它的输出是蚂蚁机器对该输入的输出加一（如果机器确实给出了答案），否则返回零。

Here's the problem: that function f can't possibly be one of the programs in our list, since its output differs from every program in the list by the way we've constructed it. But we just described a process for computing F, and we said that we had a

问题在于：这个函数 f 不可能在我们列表中的任何一个程序里，因为根据我们的构造方式，它的输出与列表中的每个程序都不同。但我们刚刚描述了一个计算 F 的过程，而且我们说过我们有一个

computing F and we said that we had a list of all possible programs so we have a contradiction we have described a program that is not in the set of possible programs so where is the flaw the answer is in our assumption that would be we would be able to determine if any machine would always halt with an answer

计算 F 的过程，而且我们说过我们有一个所有可能程序的列表，所以我们得到了一个矛盾：我们描述了一个不在可能程序集合中的程序。那么缺陷在哪里？答案在于我们的假设，即我们能够确定任何机器是否总会停机并给出答案。

this represents a very fundamental limitation on computation it says that there are some problems for which it is not possible to determine an answer in all cases in particular one cannot predetermine that a machine or program will always halt with an answer

这代表了计算的一个非常根本的限制：它表明有些问题在所有情况下都不可能确定答案，特别是，人们无法预先确定一台机器或程序是否总会停机并给出答案。

program will always halt with an answer as opposed to looping forever this is the first major resultant computability that indicates limits to what can be computed

程序总会停机并给出答案，而不是永远循环下去。这是可计算性理论中第一个重要的结果，它指出了可计算事物的极限。

Touring's insight is important both for showing how things that can be computed can be computed in any language but also that there are things that cannot be computed

图灵的洞见之所以重要，不仅在于它展示了如何用任何语言计算可计算的事物，还在于它表明有些事物是无法计算的。

hence the idea of a universal machine helps us capture the notion of what is computable and forms the basis for establishing the equivalence of programming languages both in terms of computability and

因此，通用机器的概念帮助我们把握了什么是可计算的，并构成了建立编程语言等价性的基础，无论是在可计算性方面还是