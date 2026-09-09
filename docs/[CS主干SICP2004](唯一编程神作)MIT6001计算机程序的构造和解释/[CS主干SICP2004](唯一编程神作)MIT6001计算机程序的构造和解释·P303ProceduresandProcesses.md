# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=3)

## Summary (摘要)

- The lecture introduces the substitution model of computation, a simplified model to trace the evaluation of Scheme expressions, enabling us to understand how procedures generate computational processes.
- Two types of computational processes are compared: recursive processes, characterized by deferred operations and linear space growth, and iterative processes, which maintain constant space by updating state variables without accumulation.
- A systematic method for designing iterative algorithms is presented, involving accumulating partial answers, identifying state variables, and using a state table to specify initialization, update rules, stopping condition, and answer location.
- The lecture transitions to formal logic, covering propositions, logical operators (conjunction, disjunction, negation, implication, equivalence), and the concept of proof as a chain of logical deductions.
- Mathematical induction is introduced as a powerful proof technique, with a clear procedure: establish the base case, prove the inductive step, and conclude universal truth.
- Induction is applied to verify program correctness, as demonstrated with factorial, and also as a design principle for recursive procedures: identify base cases and assume the solution for smaller instances.

- 本讲座介绍了代换模型，这是一种简化的计算模型，用于追踪Scheme表达式的求值过程，使我们能够理解过程如何生成计算过程。
比较了两种类型的计算过程：递归过程，其特征是延迟操作和线性空间增长；迭代过程，通过更新状态变量而不累积，保持恒定空间。
- 提出了一种设计迭代算法的系统方法，包括累积部分答案、识别状态变量，并使用状态表来指定初始化、更新规则、停止条件和答案位置。
- 讲座转向形式逻辑，涵盖命题、逻辑运算符（合取、析取、否定、蕴含、等价）以及证明作为逻辑演绎链的概念。
- 数学归纳法作为一种强大的证明技术被引入，并给出了清晰的步骤：建立基础情形，证明归纳步骤，并得出普遍真理。
- 归纳法被应用于验证程序正确性，如阶乘示例所示，同时也作为递归过程的设计原则：识别基础情形并假设较小实例的解。

## Outline (大纲)

1. Introduction to the Substitution Model
2. Rules of the Substitution Model and Simple Examples
3. Detailed Example: Average and Square
4. Factorial Problem and Recursive Design
5. Tracing Recursive Factorial with Substitution Model
6. General Steps for Designing Recursive Procedures
7. Towards Constant Space: Iterative Factorial
8. Formalizing the Iterative Process
9. Comparing Recursive and Iterative Processes
10. Ensuring Correctness and Introduction to Formal Proofs

1. 代换模型简介
2. 代换模型的规则与简单示例
3. 详细示例：平均值与平方
4. 阶乘问题与递归设计
5. 用代换模型追踪递归阶乘
6. 设计递归过程的一般步骤
7. 迈向恒定空间：迭代阶乘
8. 形式化迭代过程
9. 递归过程与迭代过程的比较
10. 确保正确性与形式证明简介

## Transcript (转录)

### 1. Introduction to the Substitution Model (代换模型简介)

In this lecture, we are going to put together the basic pieces of Scheme that we introduced in the previous lecture, in order to start capturing computational processes inside procedures. To do this, we will introduce a model of computation called the substitution model. We're going to show how that model helps us relate the choices we make in designing a procedure to the actual process of evaluation that occurs when we use that procedure. Thus, during this lecture, we're going to first look at the model itself, then at an example of using that.

在本讲座中，我们将整合上一讲中介绍的Scheme的基本构件，以便开始在过程中捕捉计算过程。为此，我们将引入一种称为代换模型的计算模型。我们将展示该模型如何帮助我们将在设计过程时所做的选择与实际使用该过程时发生的求值过程联系起来。因此，在本讲座中，我们将首先考察模型本身，然后通过一个示例来使用它。

then at an example of using that substitution model to make sure you understand its mechanics and finally we're going to use it to examine two different approaches to creating procedures. Now that we have the ability to create procedures and use them, we need some way of figuring out what happens during the evolution of a procedure application.

然后通过一个示例来使用代换模型，以确保你理解其机制，最后我们将用它来考察两种不同的过程创建方法。既然我们有了创建过程和使用它们的能力，我们需要某种方法来弄清楚过程应用演化过程中发生了什么。

For that we have this thing called the substitution model. You've actually seen this but we just didn't call it that, and now we're going to make it quite explicit. The role of the substitution model is to provide us

为此，我们有这个称为代换模型的东西。你实际上已经见过它，只是我们没有这样称呼它，现在我们将使其非常明确。代换模型的作用是为我们提供

The substitution model is to provide us with the means of determining how an expression evolves. In examining the substitution model, we stress that this is not a perfect model of what goes on inside the computer. In fact, later in the term we'll see a much more detailed and accurate model of computation.

代换模型的作用是提供一种方法来确定表达式如何演化。在考察代换模型时，我们强调这并非计算机内部实际运行的完美模型。事实上，在本学期后期我们将看到一个更详细、更准确的计算模型。

But this model suffices for our purposes. Indeed, we don't really care about using the substitution model to figure out the actual value of an expression — we can use the computer to do that. Rather, we want to use the substitution model to

但这个模型足以满足我们的目的。实际上，我们并不真正关心使用代换模型来计算表达式的实际值——我们可以用计算机来做这件事。相反，我们想使用代换模型来

To use the substitution model to understand the process of evaluation, so that we can use that understanding to reason about choices and designing procedures. Given that understanding, we can work backwards using a desired pattern of evaluation to help us design the correct procedure to generate that evaluation pattern.

使用代换模型来理解求值过程，以便利用这种理解来推理设计过程中的选择。有了这种理解，我们可以逆向工作，利用期望的求值模式来帮助我们设计出能生成该求值模式的正确过程。

### 2. Rules of the Substitution Model and Simple Examples (代换模型的规则与简单示例)

So here are the rules for the substitution model. Given an expression, we want to determine its value. If the expression is a simple expression, there are several possibilities. If it's just a self-evaluating expression, like a number, we just return it.

以下是代换模型的规则。给定一个表达式，我们想要确定其值。如果表达式是简单表达式，有几种可能性。如果它只是一个自求值表达式，比如数字，我们直接返回它。

expression like a number we just return that value. On the other hand, if it's a name something we created with a define expression, then we replace the name with the corresponding value associated with it.

如果是一个数字之类的表达式，我们直接返回该值。另一方面，如果它是一个名称，即我们用define表达式创建的东西，那么我们用与之关联的相应值替换该名称。

If the expression is a special form, there are also several possibilities. For example, if it's a lambda, then we replace that lambda expression with some representation of the actual procedure object associated with it.

如果表达式是特殊形式，也有几种可能性。例如，如果是lambda，那么我们用与之关联的实际过程对象的某种表示来替换该lambda表达式。

If the expression is some other special form, like for example an if expression, then we follow specific rules for evaluating.

如果表达式是其他特殊形式，例如if表达式，那么我们遵循特定的求值规则。

we follow specific rules for evaluating the sub expressions of that otherwise the expression is a compound expression one of those things that's nested in parentheses in that contains several sub expressions here we apply exactly the same set of rules to each of the sub expressions of the compound expression in some arbitrary order

我们遵循特定的规则来求值该表达式的子表达式；否则，如果表达式是复合表达式，即括号内嵌套的包含多个子表达式的东西，我们对复合表达式的每个子表达式应用完全相同的规则，顺序任意。

we then look at the value of the first sub expression if it's a primitive procedure one of the built-in things like x or plus then we just apply that procedure to the values of the other sub expressions on the other hand if the

然后我们查看第一个子表达式的值；如果它是基本过程，即内置的东西如x或plus，那么我们直接将该过程应用于其他子表达式的值；另一方面，如果

expressions on the other hand if the value of the first sub expression is a compound procedure something that was created by evaluating a lambda then we substitute the value of each subsequent sub expression for the corresponding procedure parameter in the body of the procedure we replace the entire expression with its instantiated body and repeat the process.

如果第一个子表达式的值是复合过程，即通过求值lambda创建的东西，那么我们将每个后续子表达式的值替换为过程体中相应的过程参数；我们将整个表达式替换为其实例化的体，并重复该过程。

so here is a simple example suppose we have defined square to be the obvious procedure that multiplies a value by itself now let's use the substitution model to trace out the evolution of applying that procedure

这里有一个简单的例子：假设我们定义了square为明显的将值自乘的过程。现在让我们使用代换模型来追踪应用该过程的演化过程。

the evolution of applying that procedure. the substitution model says that to trace the evaluation of square of four, we first determined that this is a compound expression. since it is, we evaluate each of the sub expressions using the same rules.

应用该过程的演化。替换模型说，要追踪 square of four 的求值，我们首先确定这是一个复合表达式。既然它是，我们就用同样的规则求值每个子表达式。

thus the first sub expression square is just a name, and we look up its value, getting back the procedure we created when we evaluated the lambda. the second sub expression is just a number, so that's its value. now the rule says to substitute for everywhere we see the formal parameter X in the body of the procedure and replace

因此，第一个子表达式 square 只是一个名字，我们查找它的值，得到我们在求值 lambda 时创建的过程。第二个子表达式只是一个数字，所以它的值就是它本身。现在规则说，要在过程体中所有出现形式参数 X 的地方进行替换，并将

in the body of the procedure and replace the original expression with this instantiated body expression as shown. Thus this reduces the evaluation of square of four to the evaluation of the expression times four four. This is also a compound expression, so again we get the values of the sub expressions. In this case, the application is just of a primitive procedure, so we simply apply it to reduce the expression to its final value 16. Here's a more detailed example.

在过程体中所有出现形式参数 X 的地方进行替换，并用这个实例化的过程体替换原始表达式，如图所示。这样就把 square of four 的求值化简为对表达式 times four four 的求值。这也是一个复合表达式，所以我们再次获取子表达式的值。在这种情况下，应用的是一个原始过程，所以我们只需应用它，将表达式化简为最终值 16。下面是一个更详细的例子。

### 3. Detailed Example: Average and Square (详细示例：平均值与平方)

First, let's create two procedures. These expressions will each generate a

首先，让我们创建两个过程。这些表达式每一个都会生成一个

Expressions will each generate a procedure through the lambda expressions, and the defines will then associate a name with each of them. Thus, in our environment, we have pairings of the name Square and average to the Associated procedure objects, each with its own parameter list and its own body.

表达式每一个都会通过 lambda 表达式生成一个过程，然后 define 会将一个名字与每个过程关联起来。因此，在我们的环境中，我们有名字 Square 和 average 与相关联的过程对象的配对，每个过程对象都有自己的参数列表和过程体。

So now, let's use these procedures to evaluate this first expression using the substitution model. I need to get the values of the sub expressions. The value of average I get by looking up this name in the environment, giving me the Associated procedure object.

现在，让我们使用这些过程，用替换模型来求值这第一个表达式。我需要获取子表达式的值。average 的值我通过在环境中查找这个名字得到，给我相关联的过程对象。

the Associated procedure object the value of five is easy the last sub expression is itself a combination so I recursively apply the rules by the same reasoning I get the procedure associated with square and the value three then substitute three into the body of square for X this reduces to another combination which I can recognize is an application of a primitive or built-in procedure so this reduces to the number nine the recursive application of the substitution model yields a simpler combination note the format here I first evaluate the sub expressions then

相关联的过程对象。5 的值很容易。最后一个子表达式本身是一个组合，所以我递归地应用规则。通过同样的推理，我得到与 square 相关联的过程和值 3，然后将 3 代入 square 的过程体中的 X，这化简为另一个组合，我可以识别出这是一个原始（或内置）过程的应用，所以这化简为数字 9。替换模型的递归应用产生了一个更简单的组合。注意这里的格式：我首先求值子表达式，然后

Evaluate the sub expressions then substitute and apply the procedure. This is called an applicative order evaluation model. Note in particular that under this model, I need to get the value of the operands first, which caused me to evaluate that interior compound expression before I got around to applying average.

求值子表达式，然后替换并应用过程。这被称为应用序求值模型。特别注意，在这个模型下，我需要先获取操作数的值，这导致我在应用 average 之前先求值了那个内部复合表达式。

Once I have simple values, I can continue the substitution. In this case, I use the body of the procedure associated with average, now substituting 5 and 9 for X and Y in that body. Note that there's no confusion about which X I'm referring to—it's the

一旦我有了简单的值，我就可以继续替换。在这种情况下，我使用与 average 相关联的过程体，现在将 5 和 9 分别替换为过程体中的 X 和 Y。注意，这里不会混淆我指的是哪个 X——它是指

关于我提到的那个X，它是指与过程关联的那个，而不是之前平方的那个。我将它代入这个过程的主体中，然后继续递归地将规则应用到每个子表达式上。

与 average 过程相关联的那个 X，而不是之前平方过程中的那个。我将它代入这个过程的过程体，然后继续递归地将规则应用于每个子表达式。

在复合表达式的情况下，我必须先将其化简为一个更简单的值，然后才能继续处理表达式的其余部分。同时要注意，当应用涉及原始过程时，我只需执行相应的操作。

在复合表达式的情况下，我必须先将其化简为一个更简单的值，然后才能继续处理表达式的其余部分。同时要注意，当应用涉及原始过程时，我只需执行相应的操作。

关键的想法是要看到这种替换的概念如何让我们追踪一个表达式的演变过程。

关键的想法是要看到这种替换的概念如何让我们追踪一个表达式的演变过程。

### 4. Factorial Problem and Recursive Design (阶乘问题与递归设计)

trace out the evolution of an expressions evaluation reducing an application of a procedure to the evaluation of a simpler Express now let's look at a little less trivial example suppose I want to compute factorial of M which is defined as the product of n by n minus 1 and so on down to 1 note that I'm assuming n is an integer and is greater than or equal to 1.

追踪一个表达式求值的演化，将过程的应用化简为对更简单表达式的求值。现在让我们看一个不那么琐碎的例子。假设我想计算 n 的阶乘，它定义为 n 乘以 n 减 1，一直乘到 1。注意，我假设 n 是整数且大于等于 1。

so how do I create a procedure to compute factorial event well I need to think carefully here since my choice in designing this procedure will impact the evolution of the process when I use it

那么我如何创建一个过程来计算阶乘呢？我需要仔细思考，因为我在设计这个过程时的选择将影响我使用它时过程的演化。

Evolution of the process when I use it. One way to look at factorial is to group the computation into multiplying n by all the other multiplications, but I can recognize that this line computation is just factorial of n minus 1.

使用它时过程的演化。看待阶乘的一种方式是将计算分组为将 n 乘以所有其他乘法，但我可以认识到这个计算就是 n 减 1 的阶乘。

Notice what this does: it reduces a computation to a simpler operation, multiplication, and a simpler version of the same problem, in this case factorial of a smaller number. So I have reduced one version of a problem to a simpler version of the same problem plus some simple operations. This is a very common pattern that we're going to use a lot.

注意这样做的作用：它将一个计算化简为一个更简单的操作（乘法）和一个相同问题的更简单版本（在这种情况下是较小数字的阶乘）。所以我已经将一个问题的版本化简为相同问题的更简单版本加上一些简单操作。这是我们将经常使用的一个非常常见的模式。

Pattern that we're going to use a lot in designing procedures. In fact, given this common pattern, we can write a procedure to capture this idea. Here it is: the first part says to give the name 'fact' to the procedure created by the lambda, which has a single argument 'm' and a particular body.

我们在设计过程中将经常使用的模式。事实上，鉴于这个常见模式，我们可以编写一个过程来捕捉这个想法。这里是：第一部分说将名字 'fact' 赋予由 lambda 创建的过程，该过程有一个参数 'm' 和一个特定的过程体。

Now what does the lambda say to do? It has two different parts which we need to look at carefully. First of all, it has a new kind of expression in the interior, that equal sign. This is an example of a predicate—a procedure that takes some arguments and returns

现在 lambda 说要做什么？它有两个不同的部分，我们需要仔细看。首先，它内部有一种新的表达式，即等号。这是一个谓词的例子——一个接受一些参数并返回

that takes some arguments and returns either true or false in this case based on the test for numerical equality the more interesting part is the body of the lambda and it is a new special form called an F because this is a special form it means that in valuation does not follow the normal rules for combination ifs are used to control the order of evaluation and contain three pieces its first sub expression we call a predicate its second sub expression we call a consequent and its third sub expression we call an alternative now here's why an

接受一些参数并返回真或假的过程，在这种情况下基于数值相等的测试。更有趣的部分是 lambda 的过程体，它是一个新的特殊形式，称为 if。因为这是一个特殊形式，意味着它的求值不遵循组合的正常规则。If 用于控制求值顺序，包含三个部分：它的第一个子表达式我们称为谓词，第二个子表达式我们称为结果，第三个子表达式我们称为替代。现在这里是为什么 if 是特殊形式的原因：

we call an alternative now here's why an if is a special form an if expression first evaluates its predicate using the same set of rules recursively on this expression it does this before it ever looks at either the other two expressions now if the predicate evaluates to a true value then the if expression takes the consequent and evaluates it returning that value as the value of the overall expression on the other hand if the predicate evaluates to a false value then the if expression takes the alternative expression evaluates it and returns that value note

我们称为替代。现在这里是为什么 if 是特殊形式的原因：一个 if 表达式首先使用相同的规则递归地求值其谓词，在查看其他两个表达式之前进行。如果谓词求值为真值，则 if 表达式取结果并求值它，返回该值作为整个表达式的值。另一方面，如果谓词求值为假值，则 if 表达式取替代表达式，求值它并返回该值。注意

evaluates it and returns that value note that the only one of the consequent and alternative expressions is evaluated during an if in the case of our fact procedure we can now see how the evaluation will proceed when we apply fact to some argument we first test to see if that value is 1 the if expression does this by first evaluating the predicate before ever considering the other expressions thus changing the order of evaluation

对其进行求值并返回该值。注意，在 if 表达式中，只有 consequent 和 alternative 中的一个会被求值。以我们的 fact 过程为例，现在我们可以看到当我们把 fact 应用于某个参数时求值将如何进行：我们首先测试该值是否为 1。if 表达式通过首先对谓词进行求值来实现这一点，然后才考虑其他表达式，从而改变了求值顺序。

### 5. Tracing Recursive Factorial with Substitution Model (用替换模型追踪递归阶乘)

if the predicate is true then we simply return the value one if it is false then we will evaluate the

如果谓词为真，那么我们直接返回值 1；如果为假，那么我们将求值

It is false, then we will evaluate the last expression with appropriate substitution, thus unwinding factorial of n into the multiplication of the value of n by the result of evaluating factorial of n minus 1.

如果为假，那么我们将用适当的替换来求值最后一个表达式，从而将 n 的阶乘展开为 n 的值乘以对 n 减 1 的阶乘求值的结果。

Here is a tracing of the substitution model in action for this procedure to evaluate factorial of three. We substitute into the body of fact, leading to the next expression. The if first evaluates the predicate, leading to the following expression.

下面是替换模型作用于该过程的追踪示例，以计算 3 的阶乘。我们将参数替换到 fact 的函数体中，得到下一个表达式。if 首先对谓词求值，得到如下表达式。

Since the predicate value is false, the entire if expression is replaced by the alternative with appropriate substitution.

由于谓词值为假，整个 if 表达式被替换为 alternative，并进行适当的替换。

alternative with appropriate substitutions to evaluate this expression we need to get the values of the sub expressions so this entire expression reduces to a multiplication of 3 by the value of fact of to note how this is unwound the computation in to a particular form a deferred multiplication and a recursive call to a simpler version of the same problem this process repeats using the if to unwind another level of computation and this continues just using the substitution model until finally the predicate is true in this case we are left with an

用适当的替换来求值这个表达式，我们需要得到子表达式的值，所以整个表达式化简为 3 乘以 fact(2) 的值。注意计算是如何展开成一种特定形式的：一个延迟的乘法和对同一问题更简单版本的一次递归调用。这个过程重复进行，使用 if 来展开另一层计算，并继续使用替换模型，直到最终谓词为真。在这种情况下，我们剩下一个

true in this case we are left with an expression just involving primitives and we can complete the multiplications thus reducing the computation to a simple answer.

为真，在这种情况下，我们剩下一个只涉及原语操作的表达式，我们可以完成乘法，从而将计算化简为一个简单的答案。

note the form shown in red in which an expression is reduced to this pattern of a simpler operation and a simpler version of the same problem this unwrapping continues until we are left with a nested expression whose innermost sub expression only involves simple expressions and operations at which point the deferred operations are evaluated this means that fact gives

注意红色所示的形式，其中表达式被化简为这种模式：一个更简单的操作和一个更简单版本的同一问题。这种展开持续进行，直到我们剩下一个嵌套表达式，其最内层的子表达式只涉及简单的表达式和操作，此时延迟的操作被求值。这意味着 fact 产生

evaluated this means that fact gives

求值，这意味着 fact 产生

evaluated this means that fact gives rise to what we call a recursive process. In the substitution model we can see that this is characterized by a set of deferred operations in which the multiplication is deferred awhile we go off and yet the sub computation of the simpler version of fact. Once we get to a simple case we can start accumulating those stacked up operations. We'll come back to this idea next time.

求值，这意味着 fact 产生了一种我们称之为递归过程的东西。在替换模型中，我们可以看到这以一组延迟操作为特征，其中乘法被延迟，而我们继续去进行更简单版本的 fact 的子计算。一旦我们到达简单情况，我们就可以开始累积那些堆积的操作。我们下次会回到这个想法。

### 6. General Steps for Designing Recursive Procedures (设计递归过程的一般步骤)

Now that we've seen our first more interesting procedure fact, let's step back and generalize the ideas we've used to capture this computation in a procedure.

既然我们已经看到了第一个更有趣的过程 fact，让我们退后一步，概括我们用来将这种计算捕获到过程中的思想。

capture this computation in a procedure. what are the general steps that we use in creating a recursive procedure like this? we have three stages as shown here. the first stage is called wishful thinking. the idea is as follows. if I want to create a solution to some problem, I first assume that I have available a procedure that will solve the problem, but only for versions of the problems smaller than the current one. in the case of factorial, I assume wishfully that I can solve factorial for problems of size smaller than n. given that assumption, the

将这种计算捕获到过程中。我们创建像这样的递归过程时使用的一般步骤是什么？我们有三步，如下所示。第一步称为愿望思维。其思想如下：如果我想为某个问题创建一个解决方案，我首先假设我有一个可用的过程可以解决这个问题，但仅限于比当前问题更小的版本。在阶乘的情况下，我愿望式地假设我可以解决规模小于 n 的阶乘问题。基于这个假设，

smaller than n given that assumption the second stage proceeds to design a solution to the problem in particular I can use the existence of a solution to the smaller size problem plus a set of simple operations to design the solution to the larger size problem we saw this with factorial where we combined the solution to a smaller version of factorial plus a multiplication to create the solution to the full version of vectorial note that the second step here requires some ingenuity one should be careful to think through this strategy before beginning to code up a

小于 n。基于这个假设，第二步继续设计问题的解决方案。特别是，我可以利用较小规模问题的解的存在，加上一组简单操作，来设计较大规模问题的解。我们在阶乘中看到了这一点，我们将较小版本的阶乘的解与乘法结合起来，创建了完整版本的阶乘的解。注意，这里的第二步需要一些独创性。在开始编写解决方案之前，应该仔细思考这个策略。

strategy before beginning to code up a solution in the case of factorial we saw how we did this decomposition into a multiplication and a smaller version of factorial with this we can build a first version of the procedure as shown at the bottom of this slide of course you already know that this won't quite work but let's think about why if we apply that version of fact to some argument it will keep unwinding the application of factorial into a multiplication and a smaller version of factorial but before we can compute that multiplication we

在开始编写解决方案之前，在阶乘的情况下，我们看到了如何将问题分解为乘法和较小版本的阶乘。有了这个，我们可以构建该过程的第一个版本，如本幻灯片底部所示。当然，你已经知道这不会完全奏效，但让我们想想为什么。如果我们将该版本的 fact 应用于某个参数，它会不断将阶乘的应用展开为乘法和较小版本的阶乘，但在我们计算那个乘法之前，

我们可以计算那个乘法，我们必须得到较小版本的阶乘的值，而这将继续展开到另一个版本，无限循环下去。问题在于我没有用到我的第三步，我没有考虑我能直接解决的最小的规模问题，而不需要借助愿望思维。

我们必须得到较小版本的阶乘的值，而这将继续展开到另一个版本，无限循环下去。问题在于我没有用到我的第三步，我没有考虑我能直接解决的最小的规模问题，而不需要借助愿望思维。

在阶乘的情况下，那就是知道1的阶乘就是1。一旦我找到了那个最小的规模问题，我就能通过检查那个情况来控制计算的展开，并在那个情况下直接进行计算。

在阶乘的情况下，那就是知道 1 的阶乘就是 1。一旦我找到了那个最小的规模问题，我就能通过检查那个情况来控制计算的展开，并在那个情况下直接进行计算。

And doing the direct computation when appropriate in this way, I will terminate the recursive unwinding of the computation and accumulate all of the deferred operations. This is in fact a very common form, a common pattern for a recursive algorithm that has a test, a base case, and a recursive case. The if controls the order of evaluation to decide whether we have the base case or the recursive case.

并以这种方式在适当的时候进行直接计算，我将终止计算的递归展开并累积所有延迟的操作。这实际上是一种非常常见的形式，一种递归算法的常见模式，它有一个测试、一个基本情况和一个递归情况。if 控制求值顺序以决定我们是处于基本情况还是递归情况。

The recursive case controls the unwinding of the computation, doing so until we reach the base case. To summarize, we've now seen how to design recursive algorithms by

递归情况控制计算的展开，直到达到基本情况。总结一下，我们现在已经看到了如何通过

How to design recursive algorithms by using this idea of wishful thinking. Separate out the problem into simpler versions of the same problem, do that decomposition, and identify the smallest size problem that will stop that unwinding of a computation into simpler versions of the same problem.

如何通过使用愿望思维的思想来设计递归算法。将问题分解为同一问题的更简单版本，进行这种分解，并确定能停止计算展开为同一问题更简单版本的最小规模问题。

As a consequence, the algorithms associated with this kind of approach have a test, a base case, and a recursive case to control the order of evaluation in order to unwind the computation into simpler versions of the same problem. We're going to use these ideas throughout the term.

因此，与这种方法相关的算法具有一个测试、一个基本情况和一个递归情况，以控制求值顺序，从而将计算展开为同一问题的更简单版本。我们将在整个学期中使用这些思想。

to use these ideas throughout the term so we've introduced recursive procedures and we've now seen an example of building a recursive procedure in this case to implement factorial.

在整个学期中我们都会用到这些思想，所以我们引入了递归过程，并且我们已经看到了一个构建递归过程的例子，在这个例子中是为了实现阶乘。

### 7. Towards Constant Space: Iterative Factorial (走向常数空间：迭代阶乘)

Now let's look at a different kind of procedure an iterative procedure for computing factorial.

现在让我们来看一种不同类型的过程，一种用于计算阶乘的迭代过程。

In doing this we're going to see how we can develop procedures with different evolutions that compute the same basic computation, and we're going to see how we do that using the substitution model to trace that evaluation.

通过这样做，我们将看到如何开发具有不同演化过程的过程，这些过程计算相同的基本计算，并且我们将看到如何使用替换模型来跟踪这种求值过程。

Here's a factorial from last time. Remember it was this nice little recursive procedure that checked to see if we were in the base case. If we were, we returned the answer 1; otherwise, we reduced the computation to a multiplication of N by a recursive call to a simpler version of the same procedure.

这是上次的阶乘。记住，它是一个漂亮的小递归过程，检查我们是否处于基本情况。如果是，我们返回答案1；否则，我们将计算简化为N乘以对同一过程的更简单版本的递归调用。

One of the properties we saw of this procedure was that factorial, as implemented this way, had a set of deferred operations to compute fact 4. It had to hold on to the multiplication of 4 while it went off to get the problem of fact of 3, and to compute fact 3, it again had to hold...

我们看到的这个过程的一个特性是，以这种方式实现的阶乘，在计算fact 4时有一组延迟操作。它必须在进行fact 3的子问题之前保留乘以4的操作，而为了计算fact 3，它又必须保留……

to compute factor 3 it again had to hold on to a deferred operation when often got the solution to a subproblem in other words the computer has to keep track of all these deferred operations and it does it in a very straightforward way it simply says I've got a multiplication left to do here's what I have to go off and do as a sub problem

为了计算fact 3，它又必须保留一个延迟操作，当它得到子问题的解时，换句话说，计算机必须跟踪所有这些延迟操作，它以一种非常直接的方式做到这一点：它只是说，我这里有一个乘法要做，这是我必须作为子问题去做的事情。

we'd like to see if there's a different way of doing this in particular a way that doesn't have to keep accumulating more and more space as we compute bigger and bigger arguments the specific question we're after is can we design an

我们想看看是否有不同的方法来做这件事，特别是一种不需要随着参数增大而不断积累更多空间的方法。我们追求的具体问题是：我们能否设计一个……

question we're after is can we design an algorithm to compute factorial but doesn't use anything more than constant amount of space or in other words does not have to accumulate more and more deferred operations as the argument grows

我们追求的问题是：我们能否设计一个算法来计算阶乘，但只使用常数量的空间，换句话说，不随着参数的增大而积累越来越多的延迟操作？

so our goal is to design an algorithm that doesn't hold on to deferred operations doesn't have to accumulate all those extra things but rather computes factorial in a different way and here's the intuition behind it

所以我们的目标是设计一个算法，不保留延迟操作，不必积累所有那些额外的东西，而是以不同的方式计算阶乘。以下是其背后的直觉。

let's think about how you would compute factorial if you were trying to do it say for example you wanted to compute 4

让我们想想，如果你试图计算阶乘，你会怎么做，例如，你想计算4。

Say for example you wanted to compute 4. What you do is take the first two numbers and multiply them together, and keep track of that product, 12. You then take 12 and the next number in the sequence, multiply that, and accumulate that product, 24. Then do the last multiplication, realize you're done, and give back the answer of 24.

例如，你想计算4。你取前两个数相乘，并跟踪那个乘积，12。然后你取12和序列中的下一个数相乘，并积累那个乘积，24。然后做最后一次乘法，意识到你完成了，并返回答案24。

What you're doing is simply keeping track at each stage of how much you've done so far and how much you have left to go. So what are you actually doing here? At each step, you're simply keeping track of two things.

你所做的只是在每个阶段跟踪你已经完成了多少以及你还剩多少。那么你实际上在这里做什么？在每一步，你只是跟踪两件事。

Of two things: what's the previous product I've computed so far, and what's the next number I have to go? I'm not doing anything more than accumulating a new product by multiplying the next term and reducing what I have left to do by one as I go along.

两件事：到目前为止我已经计算出的前一个乘积是什么，以及我必须处理的下一个数是什么？我只是通过将下一项相乘来积累一个新的乘积，并随着我继续前进将剩余的工作减少一。

As a consequence, we can see that we should be using just a constant amount of space here. And let me stress this: in the recursive case, the computer literally had to keep track of what operations it had not yet done. Think of it as holding onto a piece of paper that says "I got to do this multiply when I"...

因此，我们可以看到，这里应该只使用常数量的空间。让我强调一下：在递归情况下，计算机确实必须跟踪它尚未执行的操作。可以把它想象成拿着一张纸，上面写着“当我……时，我必须做这个乘法”

says I got to do this multiply when I get back an answer to this sub-problem, which then reduces to creating another piece of paper that says here's another multiplier I have to do while I will often do this sub-problem. All those pieces of paper that are being accumulated are the deferred operations, and they take space. Here I only have to remember two numbers: what my current product is and what the next multiplier is. And no matter how big an argument I take to the procedure, that amount of space does not change. The reason we can do this is because of two nice

上面写着“当我得到这个子问题的答案时，我必须做这个乘法”，然后这又变成创建另一张纸，上面写着“当我将去做这个子问题时，这里有另一个我必须做的乘法”。所有这些积累起来的纸就是延迟操作，它们占用空间。在这里，我只需要记住两个数字：我当前的乘积是什么，下一个乘数是什么。无论我给过程传递多大的参数，这个空间量都不会改变。我们能做到这一点的原因是由于两个很好的数学性质。

do this is because of two nice properties from mathematics. multiplication is associative and commutative, which basically says I can do the multiplications in any order and accumulating things along the way will not change the final result. therefore I can come up with an algorithm that uses only constant space to do the computation.

我们能做到这一点的原因是由于两个很好的数学性质。乘法是结合的和交换的，这基本上说明我可以按任何顺序进行乘法，并且沿途积累不会改变最终结果。因此，我可以提出一个只使用常数空间来进行计算的算法。

so now let's capture that idea a little more formally. I can use the same sort of notion in a table in which I have one column for each piece of information I'm going to use and one row for each step of the computation. in each step here

所以现在让我们更正式地捕捉这个想法。我可以使用同样的概念，在一个表格中，每一列代表我将使用的每条信息，每一行代表计算的一步。在这里的每一步……

Of the computation in each step here means how do I go from the current state of a product I've accumulated so far and encounter for where I am to the next stage. Now what I need to do is come up with a little rule for how I'm going to change the values in the table in particular.

在计算的每一步中，这里的意思是，我如何从当前状态（我已经积累的乘积以及我所在位置的计数器）进入下一阶段。现在我需要做的是提出一个小规则，用于如何改变表格中的值，特别是……

### 8. Formalizing the Iterative Process (形式化迭代过程)

To get the next value for product in that column, I take the current value of product, the current value of counter, multiply them together, and that gives me the next value of product just like I did before. Similarly, I need a rule for the counter, so I take the current rose value.

为了得到该列中乘积的下一个值，我取乘积的当前值、计数器的当前值，将它们相乘，这给了我乘积的下一个值，就像我之前做的那样。类似地，我需要一个计数器的规则，所以我取当前行的值。

Counter so I take the current rose value for counter I add one to it that generates the column entry for counter in the next row and of course I can keep repeating this process updating the values for the product column and the counter column until I'm ready to stop.

计数器，所以我取当前行的计数器值，加一，这生成下一行中计数器列的条目，当然我可以继续重复这个过程，更新乘积列和计数器列的值，直到我准备好停止。

And how do I know when I'm ready to stop? Well, that's easy. The last row I want in the table is the one when counter is bigger than n. Ah, and that says therefore I'm going to need to keep track of one more thing: I'll need a column for keeping track of n, since that's another.

我怎么知道我什么时候准备好停止？嗯，这很容易。我想要的表格中的最后一行是计数器大于n的那一行。啊，那说明我将需要跟踪另一件事：我需要一列来跟踪n，因为那是另一个……

keeping track of n since that's another piece of information I'm going to need. Once I'm done I still need to get the answer out but I know where that is: that's sitting in product, so I simply return the element from the last row in the product column and I'm set.

跟踪n，因为那是我需要的另一条信息。一旦我完成了，我仍然需要得到答案，但我知道答案在哪里：它就在乘积中，所以我只需返回乘积列中最后一行的元素，我就完成了。

The only other thing I have to do is figure out how to start this whole thing off, and that also turns out to be easy. My first row will deal with the equivalent of my base case: zero factorial is just 1, so I can start my product at 1, my counter at 1, and at whatever argument I have, and then I can just use my rules to keep going.

我唯一需要做的另一件事是弄清楚如何启动整个过程，结果这也很容易。我的第一行将处理相当于我的基础情况：零的阶乘就是 1，所以我可以从 1 开始我的乘积，计数器从 1 开始，无论参数是什么，然后我就可以用我的规则继续下去。

then I can just use my rules to keep going now let's write a procedure to do this. I'm going to define I fact for iterative fact to be my computation here.

然后我就可以用我的规则继续下去，现在让我们写一个过程来做这件事。我将定义 I fact 来表示迭代阶乘，作为我的计算。

it's a procedure there's the lambda to create it, it takes one argument and since I want to compute factorial of N, and in this case I'm going to use another procedure to help me out, i fact helper.

它是一个过程，这里有创建它的 lambda，它接受一个参数，既然我想计算 N 的阶乘，在这种情况下我将使用另一个过程来帮助我，即 i fact helper。

and the reason I want that is clear from my previous situation, I need to have three pieces of information in my table. I'm writing this procedure to capture the notion of the table, so I'm.

我需要它的原因从我之前的情况中很清楚，我需要在我的表格中有三条信息。我写这个过程是为了捕捉表格的概念，所以我将。

capture the notion of the table so I'm going to need a fact helper to take three arguments: a product, a counter, and n, free to the columns in my table. So why fact helper again is a procedure, there's the lambda to create it, and look at the case or the body of that procedure.

捕捉表格的概念，所以我需要一个 fact helper 来接受三个参数：一个乘积、一个计数器和 n，对应我表格中的列。所以 fact helper 又是一个过程，这里有创建它的 lambda，看看那个过程的主体或情况。

It looks a lot like factorial. It has a test to see if I'm done, checking whether the counter is greater than n. It has, in this case, not a base case, but a value to return if I am done.

它看起来很像阶乘。它有一个测试来检查是否完成，检查计数器是否大于 n。在这种情况下，它没有基础情况，但有一个如果完成则返回的值。

And otherwise, it has a procedure call to the same thing, but now with a different set of arguments. This says the value I

否则，它有一个对同一事物的过程调用，但现在使用一组不同的参数。这表示我将 I fact helper 应用于某个乘积、计数器和 n 所得到的值，与将 I fact helper 应用于乘积、计数器和 n 的不同版本所得到的值相同。所以现在让我们想想如果我调用这个会发生什么。我在某个 n 值上调用 I fact，这表示 fact helper 被调用在 1、1 和 N 上，这基本上就是设置我的表格的第一行。

set of arguments this says the value I get when I apply I fact helper to some product counter and n is the same as the value I get by applying I fact helper to a different version of product a different version of counter and n so now let's think what happens if I call this I call I fact on some value of n that says I fact helper gets called on 1 1 and N and that's just setting up basically the first my table.

一组参数，这表示我将 I fact helper 应用于某个乘积、计数器和 n 所得到的值，与将 I fact helper 应用于乘积、计数器和 n 的不同版本所得到的值相同。所以现在让我们想想如果我调用这个会发生什么。我在某个 n 值上调用 I fact，这表示 fact helper 被调用在 1、1 和 N 上，这基本上就是设置我的表格的第一行。

Then I look at what happens inside I fact helper and I can see that applying I fact helper basically computes the next row of the table.

然后我看看 I fact helper 内部发生了什么，可以看到应用 I fact helper 基本上计算了表格的下一行。

computes the next row of the table it says given a product a counter and an end I'm going to call I fact helper again with a different product an update rule for it if you like a different counter there's the update rule and the same value of n so this is just generating at each stage another row of my table.

计算表格的下一行，它说给定一个乘积、一个计数器和 n，我将再次调用 I fact helper，使用不同的乘积（如果你愿意，可以称之为更新规则）、不同的计数器（这里有更新规则）和相同的 n 值。所以这只是每一步生成我的表格的另一行。

and what else do I need just to determine when to stop so I've got a test to check when that happens and I know that the answer is in the product column of the last row so when I get there I just return the value of product let's look.

我还需要什么？只需要确定何时停止。所以我有一个测试来检查何时发生，我知道答案在最后一行的乘积列中，所以当我到达那里时，我只需返回乘积的值。让我们看看。

Return the value of product let's look at this to see how this works and we know how to do that we use our substitution model. So here's a repeat of fact helper since that's the key element.

返回乘积的值，让我们看看这是如何工作的，我们知道怎么做，我们使用我们的替换模型。所以这里是 fact helper 的重复，因为它是关键元素。

And if I call fact on say the argument 4, we know what to do. The argument 4 is substituted into the body of our fact, which means we will be calling fact helper with the arguments 1, 1, and 4. Now the substitution model says substitute the arguments 1, 1 & 4 into the body of the procedure for fact helper, so we place those in and that reduces to an evaluation of this if statement.

如果我调用 fact，比如说参数为 4，我们知道该怎么做。参数 4 被替换到我们的 fact 主体中，这意味着我们将调用 fact helper，参数为 1、1 和 4。现在替换模型说将参数 1、1 和 4 替换到过程 fact helper 的主体中，所以我们把它们放进去，这简化为对这个 if 语句的求值。

reduces to an evaluation of this if expression and we know what to do with it if we're going to first evaluate the predicate and based on its result either evaluate the consequent or the alternative. Here the predicate is false, so it says the value of I fact helper of 1 1 4 is going to be the same as the call to I fact helper with a new set of arguments, and particularly the one shown.

简化为对这个 if 表达式的求值，我们知道如何处理它，如果我们首先求值谓词，然后根据其结果求值结果部分或替代部分。这里谓词为假，所以它说 I fact helper 对 1 1 4 的值将与调用 I fact helper 使用一组新参数（特别是所示的那组）相同。

This means in our substitution model we've reduced to this expression I fact helper of one two and four, and notice an important point we now have were taken a

这意味着在我们的替换模型中，我们已经简化为这个表达式 I fact helper of one two and four，注意一个重要点，我们现在已经采取了。

important point we now have were taken a fact helper of one set of arguments and said the value of that expression is the same as the value of a different call to I fact helper with a different set of arguments but there are no deferred operations stacked up here and we can just repeat this process we now take the values of 1 2 & 4 substitute those into the body of I fact helper for the appropriate parameters this reduces to another if expression and I gain evaluate the predicate it's false so I'm going to reduce this expression to another call to I fact helper with a

重要点，我们现在已经采取了 fact helper 对一组参数的值，并说该表达式的值与对 I fact helper 使用不同参数集的调用相同，但这里没有堆积的延迟操作，我们可以重复这个过程。我们现在取 1、2 和 4 的值，将它们替换到 I fact helper 的主体中，对应适当的参数，这简化为另一个 if 表达式，我再次求值谓词，它为假，所以我将这个表达式简化为对 I fact helper 的另一个调用，使用一组不同的参数。

Another call to I fact helper with a different set of arguments, and that process continues until eventually the predicate for if is true, and in that case, returning the value of product. So the substitution model shows us how to trace all of this out.

对 I fact helper 的另一个调用，使用一组不同的参数，这个过程持续进行，直到最终 if 的谓词为真，在这种情况下，返回乘积的值。所以替换模型向我们展示了如何追踪这一切。

Notice a key thing, however: look at the read exam. They're constant — they don't grow. There are no deferred operations; they are exactly the same in size. All that's happening is that each time we go to a new version of I fact helper, we're updating the parameters of the argument, which is capturing that table.

然而，注意一个关键点：看这些表达式。它们是恒定的——它们不增长。没有延迟操作；它们在大小上完全相同。所发生的只是每次我们进入 I fact helper 的新版本时，我们都在更新参数，这捕捉了那个表格。

which is capturing that table computation, so this says the shape of this computation the way it evolved over time is very different than what happened with the factorial we did the previous time. It's constant in space, there are no deferred operations, nothing is growing in terms of the amount of space I need as I increase the argument.

这捕捉了表格计算，所以这表示这个计算的形状，它随时间演变的方式，与我们之前做的阶乘非常不同。它在空间上是恒定的，没有延迟操作，随着我增加参数，我需要的空间量没有增长。

let's compare that to the recursive version. Remember in the recursive version we had that pending operation, and that caused the evolution to have this growing behavior because I had to keep track of all of those things.

让我们将其与递归版本进行比较。记住在递归版本中，我们有那个挂起的操作，这导致演变具有这种增长行为，因为我必须跟踪所有那些东西。

keep track of all of those things explicitly in terms of different versions of the multiply. So the pending operations make it grow. Compare that to the iterative version—notice there's no pending operation here.

明确地跟踪所有那些东西，以不同的乘法版本的形式。所以挂起的操作使它增长。将其与迭代版本进行比较——注意这里没有挂起的操作。

The value of I fact helper of some set of arguments reduces to the value of another version of I fact helper, and as a consequence there are no pending operations, there's no growth; it's a fixed size and is constant. So these are two different implementations of the same idea.

I fact helper 对一组参数的值简化为另一个版本的 I fact helper 的值，因此没有挂起的操作，没有增长；它是固定大小的，是恒定的。所以这是同一思想的两种不同实现。

### 9. Comparing Recursive and Iterative Processes (比较递归和迭代过程)

What this does for us then is let us see that in fact we can have algorithms that have.

那么，这让我们看到，事实上我们可以有算法，它们具有……

In fact, we can have algorithms that have linear growth, which is our recursive version. We can also have algorithms that have constant growth, and we've talked about how to develop an iterative algorithm by a specific set of methods.

事实上，我们可以有线性增长的算法，即我们的递归版本。我们也可以有常数增长的算法，而且我们已经讨论了如何通过一套特定的方法来开发迭代算法。

In these methods, we try and figure out how to accumulate partial answers, how to identify a set of state variables that characterize the computation, and then write out a table that actually very specifically analyzes that stage—how to initialize the first row, how to go to update rules to move from one row.

在这些方法中，我们试图弄清楚如何累积部分答案，如何识别一组表征计算的状态变量，然后写出一张表，非常具体地分析那个阶段——如何初始化第一行，如何通过更新规则从一行移动到另一行。

go to update rules to move from one row to the next row, how to know when to stop, and where the answer will be when we do.

如何通过更新规则从一行移动到下一行，如何知道何时停止，以及停止时答案会在哪里。

As a consequence, we have two different kinds of algorithms that are going to both be very useful for handling complex problems.

因此，我们有两种不同类型的算法，它们对于处理复杂问题都将非常有用。

### 10. Ensuring Correctness and Introduction to Formal Proofs (确保正确性与形式证明导论)

So how do we know that our code is actually correct? It will be nice if we could guarantee that our code would always run correctly, provided we give it a proper input, but how do we ensure this?

那么我们如何知道我们的代码实际上是正确的呢？如果我们能保证代码在给定正确输入时总能正确运行，那将是很好的，但我们如何确保这一点呢？

Well, there's several possibilities. We could just accept the word of someone with power over our future, like say a...

嗯，有几种可能性。我们可以只接受某个对我们未来有影响力的人的话，比如一个……

With power over our future, like say a 6.1 professor, the code is in fact right. Clearly not a wise idea, though it is shocking how often this approach is used.

一个对我们未来有影响力的人，比如一位6.1课程的教授，说代码实际上是正确的。这显然不是一个明智的主意，尽管令人震惊的是这种方法经常被使用。

A more common method is to rely on statistics, that is, to try our code on a bunch of example inputs and hope that if it works on all the ones we try, it'll work on every input. Sometimes this is the best you can do, but clearly there are no guarantees with this approach.

更常见的方法是依赖统计，也就是说，在一堆示例输入上测试我们的代码，并希望如果它在所有测试的输入上都有效，那么它将在所有输入上都有效。有时这是你能做的最好的，但显然这种方法没有保证。

All too often, programmers rely on the third method, also known as arrogance. They just assumed that they wrote correct code.

很多时候，程序员依赖第三种方法，也称为傲慢。他们只是假设自己写了正确的代码。

Assumed that they wrote correct code and are stunned when it fails the best method, when possible, is to actually formally prove that your code is correct. And it is this method that we're going to briefly explore here. We won't show you all the elements of proving programs correct, but we will provide you with the basis for understanding how this is done.

假设他们写了正确的代码，并在失败时感到震惊。最好的方法，在可能的情况下，是实际正式证明你的代码是正确的。我们在这里将简要探讨这种方法。我们不会向你展示证明程序正确的所有要素，但我们将为你提供理解如何做到这一点的基础。

And more importantly, for using the reasoning pattern underlying this proof method to help you design good code. First, we need to talk about what constitutes a formal proof. Technically, a proof of a mathematical or logical

更重要的是，利用这种证明方法背后的推理模式来帮助你设计好的代码。首先，我们需要讨论什么构成形式证明。从技术上讲，一个数学或逻辑命题的证明是……

proof of a mathematical or logical proposition is a chain or sequence of logical deductions that starts with a base set of axioms and heads towards or leads towards the proposition we are attempting to prove. Now we need to fill in the details on those pieces. First, a proposition is basically a statement that's either true or false. Typically in propositional logic we have a set of atomic propositions, that is simple statements of fact. For example, N equals 0 is an atomic proposition; it's either true or false given some value for the variable n.

一个数学或逻辑命题的证明是一系列逻辑演绎的链条或序列，它从一组基础公理开始，并朝着或导向我们试图证明的命题。现在我们需要填补这些部分的细节。首先，命题基本上是一个要么为真要么为假的陈述。通常在命题逻辑中，我们有一组原子命题，即简单的事实陈述。例如，N等于0是一个原子命题；给定变量n的某个值，它要么为真要么为假。

given some value for the variable n, there's no other choice of course that assumes it ends a number more interesting propositions and things were more likely to be interested in proving are created by combining simpler propositions. There are five standard ways of creating compound propositions.

给定变量n的某个值，没有其他选择，当然假设它是一个数字。更有趣的命题，以及我们更可能感兴趣证明的东西，是通过组合更简单的命题来创建的。有五种标准的方法来创建复合命题。

One can take the conjunction, which acts like an 'and', meaning the compound proposition is true if and only if both of the individual ones are. One can take the disjunction, which acts like an 'or', meaning the compound proposition is true if and only if one or the other of the

可以采用合取，它类似于“与”，意味着复合命题为真当且仅当两个个体命题都为真。可以采用析取，它类似于“或”，意味着复合命题为真当且仅当其中一个……

If and only if one or the other of the individual propositions is true, one can take the negation of a proposition, which just means the proposition is true if and only if the initial one is false. We can create the implication, which means that if P is true then Q is true, and we can establish an equivalence, which means that P is true if and only if Q is true.

当且仅当其中一个个体命题为真时，复合命题为真。可以对一个命题进行否定，这意味着该命题为真当且仅当初始命题为假。我们可以创建蕴含，这意味着如果P为真则Q为真，我们还可以建立等价，这意味着P为真当且仅当Q为真。

Note, by the way, that compound propositions can have elements that are themselves compound propositions, so that we can create very deeply nested logical propositions. We can capture the logical structure of

顺便注意，复合命题的元素本身可以是复合命题，这样我们就可以创建非常深层的嵌套逻辑命题。我们可以通过简单地查看所有可能的情况来捕捉……

We can capture the logical structure of these compound propositions by simply looking at all the possible cases. If we consider all possible combinations for the base propositions, we can chart out the veracity of the compound proposition.

我们可以通过简单地查看所有可能的情况来捕捉这些复合命题的逻辑结构。如果我们考虑基础命题的所有可能组合，我们可以绘制出复合命题的真值。

Thus, in this chart, we see that p and q behaves as we would expect: it is true as a statement if and only if both P and Q themselves are true. Negation and disjunction also behave as expected, as does equivalence, since the combination can only be true when both simpler elements are the implications.

因此，在这个图表中，我们看到p和q的行为符合我们的预期：作为一个陈述，它当且仅当P和Q本身都为真时才为真。否定和析取也符合预期，等价也是如此，因为只有当两个更简单的元素都是蕴含时，组合才可能为真。

Elements are the implications a bit more puzzling. The proposition is defined to be true if either P is false or Q is true. To see this, let's take a simple example.

元素是蕴含，这有点令人困惑。该命题被定义为：如果P为假或Q为真，则为真。为了理解这一点，让我们看一个简单的例子。

Suppose we consider the proposition: if n is greater than 2, then n squared is greater than 4. Then for example, if n equals 4, both propositions are true, and our truth table also states that the implication is true. Since the first part is true, therefore the second part is true, therefore the implication is true.

假设我们考虑命题：如果n大于2，则n的平方大于4。例如，如果n等于4，两个命题都为真，我们的真值表也表明蕴含为真。因为第一部分为真，因此第二部分为真，因此蕴含为真。

If, for example, n equals negative 4, then the first proposition is false, and the second proposition is true.

如果，例如，n等于负4，那么第一个命题为假，第二个命题为真。

and the second proposition is true the compound statement is true as we see from the truth table and this makes sense since the consequent can clearly still be true even if the precedent is not.

而第二个命题为真，复合陈述为真，正如我们从真值表中看到的，这是有道理的，因为即使前件不为真，后件显然仍然可以为真。

finally suppose N equals 1 in this case both propositions are false however the statement as a whole is true this particular combination thus has a rather count intuitive aspect as it is always true if the first part is false.

最后假设N等于1，在这种情况下两个命题都为假，然而整个陈述为真。这个特殊的组合因此具有相当反直觉的一面，因为如果第一部分为假，它总是真的。

now given that we can construct propositions we want to be able to prove their correctness by chaining together a sequence of logical deductions starting

现在，既然我们可以构造命题，我们希望能够通过将一系列逻辑演绎串联起来来证明它们的正确性，从……开始

Sequence of logical deductions starting from a set of axioms, which are just propositions that are soon to be true. The basic idea is that we start with statements that are correct and then use these standard deductions to reason about statements whose veracity we are attempting to establish.

从一组公理出发进行的一系列逻辑演绎，公理就是那些被认定为真的命题。基本思想是，我们从正确的陈述出发，然后利用这些标准的演绎规则来推理那些我们试图确定其真实性的陈述。

For example, a common inference rule which has been around at least since Aristotle is known as modus ponens. It basically says that if we have a proposition that is true and we have an implication, say P implies Q, that is also true, then we can deduce.

例如，一个至少从亚里士多德时代就存在的常见推理规则被称为“肯定前件”（modus ponens）。它基本上是说，如果我们有一个为真的命题，并且我们有一个蕴含式，比如 P 蕴含 Q，也为真，那么我们就可以推出 Q。

Q that is also true then we can deduce that Q itself is a true proposition a related and equally old for inference rule is known as modus tollens this basically states that if we have an implication that P implies Q and we also know that Q is not true then we can infer that P is not true.

Q 也为真，那么我们就可以推出 Q 本身是一个真命题。另一个相关且同样古老的推理规则被称为“否定后件”（modus tollens），它基本上是说，如果我们有一个蕴含式 P 蕴含 Q，并且我们还知道 Q 不为真，那么我们就可以推断出 P 不为真。

Now given these tools we could go off and prove statements of fact unfortunately the things we want to prove about programs for example does this code run for all correct inputs require potentially infinite propositions since we would have to take a conjunction of propositions one for

有了这些工具，我们就可以去证明事实性陈述了。不幸的是，我们想要证明的关于程序的事情，例如“这段代码对所有正确的输入都能运行”，可能需要无穷多个命题，因为我们必须取一个命题的合取，每个不同的输入值对应一个命题。

a conjunction of propositions, one for each different input value, so we need to extend our propositional logic to predicate logic. We handle this by creating propositions with variables and then specifying the set of values, called the universe or domain of discourse, over which the variable may range.

一个命题的合取，每个不同的输入值对应一个命题，所以我们需要将命题逻辑扩展为谓词逻辑。我们通过创建带有变量的命题来处理这个问题，然后指定变量可以取值的集合，称为论域（universe）或 discourse 的域。

Since predicates supply over ranges, we can also put conditions on these predicates. The two basic quantifiers are known as 'for all' and 'there exists'. They capture the cases in which the predicate is true for all possible values in the universe and

由于谓词是在一定范围内取值的，我们也可以对这些谓词加上条件。两个基本的量词被称为“全称量词”（for all）和“存在量词”（there exists）。它们分别刻画了谓词在论域中所有可能取值都为真的情况，以及谓词在论域中至少有一个取值为真的情况。

All possible values in the universe and in which the predicate is true for at least one value in the universe. Now we're ready to put these tools together to prove things about predicates. We are particularly interested in a proof method called proof by induction, which is shown here stated somewhat informally.

所有可能取值都为真的情况，以及谓词在论域中至少有一个取值为真的情况。现在我们准备把这些工具组合起来，去证明关于谓词的命题。我们特别感兴趣的一种证明方法叫做“数学归纳法”（proof by induction），这里以一种不太正式的方式陈述。

This method basically says the following: suppose you can show that the predicate is true for some initial case. Here we're assuming the universe is the set of non-negative integers, so this initial case would be N equals 0. If the universe were different...

这种方法基本上是说：假设你能证明谓词对某个初始情况为真。这里我们假设论域是非负整数集，所以这个初始情况就是 N 等于 0。如果论域不同……

equals 0 if the universe were different, the initial case would also be different. Now suppose you can somehow also show that for any value of n in the universe, the implication that if the proposition is true for that n then it is also true for an incremented n is in fact true in this case.

等于 0；如果论域不同，初始情况也会不同。现在假设你还能以某种方式证明，对于论域中的任意值 n，蕴含式“如果命题对 n 为真，那么它对 n+1 也为真”在这个情况下确实为真。

Induction allows you to deduce that the proposition is true for all values of n in the universe. Note what this buys you: it says that you need only show the statement is true for some base case, and you need only show that for some arbitrary value of n if the

归纳法允许你推出该命题对论域中的所有 n 值都为真。注意这给你带来了什么：它说你只需要证明该陈述对某个基础情况为真，并且你只需要证明对于某个任意的 n 值，如果……

some arbitrary value of n if the proposition is true for that n then you can show it's also true for the next value of n you don't need to check all values you just need to show that the implication holds in essence you can bootstrap a proof that the statement is always true

对于某个任意的 n 值，如果命题对该 n 为真，那么你可以证明它对下一个 n 值也为真。你不需要检查所有的值，你只需要证明蕴含关系成立。本质上，你可以通过引导（bootstrap）来证明该陈述总是为真。

let's make this a bit less murky with an example suppose I want to prove the predicate shown here for all non-negative values of n that is the sum of the powers of two can be captured by the simple expression shown on the right to prove this by induction I reallyundefined

让我们用一个例子来让这一点不那么模糊。假设我想证明这里显示的谓词对所有非负 n 值成立，即 2 的幂之和可以用右边显示的简单表达式来刻画。为了用归纳法证明这一点，我确实需要……

To prove this by induction, I really should specify the universe, which I said was going to be all non-negative integers. Then I need to show that this is true for the base case when N equals zero. That's easy: I just substitute in N equals zero on both sides of the equation and then check that 1 is equal to 2 minus 1, clearly.

为了用归纳法证明这一点，我确实应该指定论域，我之前说过论域是所有非负整数。然后我需要证明这在基础情况 N 等于 0 时成立。这很容易：我只需在等式两边代入 N 等于 0，然后检查 1 是否等于 2 减 1，显然成立。

Now for the inductive step, let's start with the left-hand side of the equation for the n plus 1 case. I can rewrite this as shown in the first step. Now I want to rewrite in this way because the first term on the right is just the same predicate but now for...

现在对于归纳步骤，让我们从 n+1 情况下的等式左边开始。我可以像第一步所示那样重写它。我想这样重写，因为右边的第一项正是同一个谓词，但现在参数是……

Just the same predicate but now for argument n. But by induction, I simply want to show that if this version of the predicate is true, so is the version I'm considering. So I can replace that summation with the implication from the predicate, and then some simple arithmetic shows that I get the expression I want.

正是同一个谓词，但现在参数是 n。但根据归纳假设，我只需要证明如果这个版本的谓词为真，那么我正在考虑的版本也为真。所以我可以将那个求和替换为谓词中的蕴含式，然后一些简单的算术运算表明我得到了我想要的表达式。

I've now shown that if the proposition is true for n, then it must also be true for n plus 1. And by induction, I can conclude it is therefore true for all legal values of n. So what we have is a way of proving things by induction; the steps are just as shown.

我现在已经证明了，如果命题对 n 为真，那么它必然对 n+1 也为真。通过归纳法，我可以得出结论，因此它对所有合法的 n 值都为真。所以我们有了一种通过归纳法证明命题的方法；步骤正如所示。

Induction, the steps are just as shown. Here we first define the predicate we want to prove correct, including specifying what the variable denotes and the range of legal values of the variable.

归纳法，步骤正如所示。这里我们首先定义我们想要证明正确的谓词，包括指定变量表示什么以及变量的合法取值范围。

We then prove that the predicate is true in the base case, which we have here assumed is for n equal to 0. We subsequently prove that the implication holds, and this allows us to conclude that the predicate is always true.

然后我们证明谓词在基础情况下为真，这里我们假设基础情况是 n 等于 0。随后我们证明蕴含关系成立，这使我们能够得出结论：该谓词总是为真。

So finally, we can relate this back to programs. Suppose you want to prove that our code for factorial is correct, that is, it will always run.

最后，我们可以将此与程序联系起来。假设你想证明我们的阶乘代码是正确的，也就是说，它将始终运行。

Correct, that is it will always run correctly. Note that there's a hidden assumption here, namely that we give it a correct input. Here we've made the unstated assumption that factorial only applies to integers greater than or equal to 1. If we provide some other value, all bets are off. In other words, our universe here is positive integers.

正确，也就是说它将始终正确运行。注意这里有一个隐含的假设，即我们给它一个正确的输入。这里我们做了一个未明说的假设，即阶乘只适用于大于或等于 1 的整数。如果我们提供其他值，一切 bets 都 off（无法保证）。换句话说，我们这里的论域是正整数。

So here's our code and our proposition is that this code correctly computes n factorial, given a legal value for n. To prove this, we first consider the base case. Remember that here our base case is n equal 1, since that's the starting point.

所以这是我们的代码，我们的命题是：这段代码在给定合法 n 值的情况下正确计算 n 的阶乘。为了证明这一点，我们首先考虑基础情况。记住这里我们的基础情况是 n 等于 1，因为那是起点。

n equal 1 since that's the starting point for our universe of values is our proposition valid sure we know that our if statement will in this case take the path through the consequent expression and just return the value 1 which you also know is the desired answer so what about the inductive step in this case we can assume our code works correctly for some arbitrary but legal value of n and we want to show that under that assumption it also works correctly for n plus 1 in this case we'll take the consequent path through the if

当 n 等于 1 时，因为这是我们值宇宙的起点，我们的命题是否成立？当然成立，我们知道我们的 if 语句在这种情况下会走 consequent 分支，直接返回 1，而你也知道这正是期望的答案。那么归纳步骤呢？在这种情况下，我们可以假设我们的代码对于某个任意但合法的 n 值是正确的，并且我们要证明在该假设下，它对于 n+1 也是正确的。在这种情况下，我们会走 if 的 consequent 分支。

consequent path through the if

走 if 的 consequent 分支

consequent path through the if expression our substitution model says that the value of this expression is found by finding the values of the sub expressions and then applying the first to the others finding the value of star is easy as is the value of the sum by induction we can assume that the value of the last sub expression will be the correct value of factorial as a consequence applying the multiplication operator to the value of n plus 1 and n factorial will of course return n plus 1 all factorial and as we can conclude that this will always produce the right

走 if 表达式的 consequent 分支。我们的替换模型表明，这个表达式的值是通过先求子表达式的值，然后将第一个应用于其他子表达式来得到的。求 star 的值很容易，求和的值也很容易；通过归纳，我们可以假设最后一个子表达式的值将是 factorial 的正确值。因此，将乘法运算符应用于 n+1 的值和 n 的阶乘，当然会返回 n+1 的阶乘。由此我们可以得出结论，这将总是产生正确的结果。

that this will always produce the right answer now let's pull all this together the message to take away from this exercise is that induction provides a basis for understanding analyzing and proving correctness of recursive procedure definitions moreover exactly this kind of thinking can be used when you design programs not just when you analyze them when given a new problem to solve it's very valuable to identify the base case and find a solution for then turn to the issue of breaking the problem down into a simpler version of the same problem

这将总是产生正确的结果。现在让我们把这一切整合起来。从这个练习中要传达的信息是，归纳为理解、分析和证明递归过程定义的正确性提供了基础。此外，正是这种思考方式可以在你设计程序时使用，而不仅仅是在分析程序时。当面对一个新问题需要解决时，识别基本情况并为其找到解决方案是非常有价值的，然后转向将问题分解为同一问题的更简单版本。

version of the same problem assuming that the code will solve that version and using that to construct the inductive step how to solve the full version of the problem what we hope is that you'll use this approach when you

同一问题的更简单版本，假设代码能解决该版本，并利用它来构造归纳步骤，从而解决完整版本的问题。我们希望你在设计程序时能采用这种方法。