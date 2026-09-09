# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=4)

In this lecture we're going to take a careful look at the kinds of procedures we can build. We'll first go back to look very carefully at the substitution model to see how the rules for evaluation help us determine the evolution of a process controlled by procedure.

在本讲中，我们将仔细审视我们能够构建的各种过程。首先，我们会回到替换模型，仔细考察求值规则如何帮助我们确定由过程所控制的过程的演化。

We will then see how different kinds of process evolution can occur with different demands in terms of computational resources, and we will see how to characterize those differences formally in terms of something called an order of growth of a process. Finally we will explore examples.

然后，我们将看到不同类型的过程演化如何对计算资源产生不同需求，并学习如何用所谓的“过程的增长阶”来形式化地刻画这些差异。最后，我们将探讨一些实例。

process finally we will explore examples of procedures from different classes of growth helping you to begin to relate how choices in procedure design may affect performance of the actual use of the procedure.

过程，最后我们将探讨来自不同增长类别的过程实例，帮助你开始理解过程设计中的选择如何影响过程实际使用时的性能。

now that we've seen two different implementations two different procedures for the same problem a recursive one and an iterative one we need a way of characterizing why that difference occurs.

既然我们已经看到了同一问题的两种不同实现——递归的和迭代的——我们就需要一种方法来刻画这种差异产生的原因。

and to do that we're going to go back to our substitution model and use a slightly different viewpoint on it in particular we're going to look at the substitution model.

为此，我们将回到替换模型，并采用一个略有不同的视角，特别是我们将审视替换模型。

Going to look at the substitution model as a set of rewrite rules, that is, a set of rules that says given an expression of a particular form, here's how to rewrite that expression into a different form.

我们将把替换模型视为一组重写规则，也就是说，一组规则说明：给定特定形式的表达式，如何将该表达式重写为另一种形式。

So for elementary expressions, basically they're just left alone. That is, if we have a number, an initial name for a primitive procedure, or a lambda expression that's naming a procedure, we simply leave the expression exactly as it is. If our expression is a name that was created by a define, then we'll rewrite the name as the value it has.

对于基本表达式，基本上就是保持原样。也就是说，如果我们有一个数字、一个基本过程的名字或一个命名过程的lambda表达式，我们只需保持表达式不变。如果我们的表达式是一个由define创建的名字，那么我们将把该名字重写为其所具有的值。

rewrite the name as the value it has associated with it by the definition the special form if we'll write using the rules we've seen will evaluate the predicate if it terminates in a non false value then we'll rewrite the entire if expression as the value of the consequent otherwise we'll rewrite it as the value of the alternative

将名字重写为定义所关联的值。对于特殊形式if，我们将使用我们见过的规则：求值谓词，如果它以非假值终止，那么我们将整个if表达式重写为结果表达式的值，否则重写为替代表达式的值。

and finally combinations we use the rule that we first evaluate the operator expression to get the procedure and we evaluate the operands to get the set of arguments if we have a primitive procedure we're going to do just the right thing

最后，对于组合式，我们使用这样的规则：首先求值运算符表达式以得到过程，并求值运算对象以得到参数集合。如果我们有一个基本过程，我们就直接做正确的事情。

going to do just the right thing, otherwise we're going to replace this entire expression with the body of the compound procedure with the substitution of the parameters and the arguments as appropriate. Given that model, we can now try and capture more formally how different processes evolve in different ways.

直接做正确的事情，否则我们将用复合过程体替换整个表达式，并适当地用参数替换形参。基于该模型，我们现在可以更形式化地刻画不同过程如何以不同方式演化。

And we use an idea called orders of growth. This is intended to be a way of measuring how much of a particular resource a process is going to take as it goes through its, and typically the resources we're interested in is how much time will it take.

我们使用一个称为“增长阶”的概念。这旨在衡量一个过程在其运行过程中将消耗多少特定资源，通常我们关心的资源是所需的时间。

interested in is how much time will it take and how much space will it take. What we're going to do is be a little bit formal here as follows: let's let N be a parameter that measures the size of the problem we're interested in. In the case of factorial, N will be simply the size of the argument.

我们关心的是所需的时间和空间。我们将如下进行形式化：令N为衡量我们感兴趣的问题规模的参数。在阶乘的例子中，N就是参数的大小。

We're going to let R of N be a term that denotes the amount of resources we need to compute a procedure of size N. And that's what we want to try and get a handle on. Typically, we're interested in how our algorithm behaves for really large values of N.

我们令R(N)表示计算规模为N的过程所需的资源量。这就是我们想要把握的。通常，我们关心算法在N非常大时的行为。

For really large values of n in the asymptotic limit, we say that our event, that particular expression for the amount of resources we need, has order of growth theta of F of M if we can find a function f of n such that our event is basically of the same orders F of N. And more formally, we say if we can find two constants, that is things that don't depend on n, such that K 1 times f of n is less than or equal to our event is less than or equal to K 2 times F of them when n gets really large. I know this is a lot of mass we're going to make clear in a second when

对于非常大的n，在渐近极限下，我们说我们的资源需求表达式具有增长阶θ(f(N))，如果存在一个函数f(n)使得我们的资源需求基本上与f(N)同阶。更形式化地说，如果存在两个常数（即不依赖于n的常数）K1和K2，使得当n足够大时，K1乘以f(n) ≤ R(N) ≤ K2乘以f(N)。我知道这有点复杂，但稍后我们会通过例子使其清晰。

going to make a clear in a second when we look at some examples but that's the formal definition we're interested in as we said what we're going to do in terms of resources are typically measure space

稍后我们看一些例子时会使其清晰，但这就是我们感兴趣的形式化定义。正如我们所说，就资源而言，我们通常衡量空间。

and that really comes down to counting up how many deferred operations there are and trying to estimate how that changes as n changes in the second one is time here measured by the number of primitive steps we have to go through

这实际上归结为计算有多少延迟操作，并估计随着n的变化这些操作如何变化。第二个是时间，这里通过我们必须经历的基本步骤数来衡量。

and again we're going to try and estimate how many of those we need as a function of the size of the argument so

同样，我们将尝试估计作为参数大小的函数我们需要多少步骤。

function of the size of the argument so

作为参数大小的函数。

function of the size of the argument so now let's combine that idea of treating the substitution model as a set of rewrite rules and this idea of trying to characterize the growth of the procedure to look at our two examples. Here's fact once more and here's a partial trace of fact using those rewrite rules. We start with fact for substituting in reduces to an evaluation of an if and the predicate is not true that reduces to taking the alternative which is that next line and we keep doing this. Key thing to notice are the orange colored lines those show

作为参数大小的函数。现在，让我们将把替换模型视为一组重写规则的想法与试图刻画过程增长的想法结合起来，来看我们的两个例子。这里是fact的再次定义，以及使用这些重写规则对fact进行部分追踪。我们从fact 4开始，代入后简化为对if的求值，谓词不为真，于是简化为取替代分支，即下一行，我们继续这样做。关键要注意的是橙色行，它们显示了

are the orange colored lines those show the results of the evolution of this process fact 4 reduces to a deferred operation of x 4 and factory which reduces a game and notice the shape of this process it grows out and then shrinks back down once we get down to the base case in particular we can see that the number of deferred operations grows linearly with the size of the argument

橙色行显示了该过程演化的结果：fact 4 简化为一个延迟操作×4和fact 3，后者又简化为一个延迟操作，注意这个过程的形状：它先增长然后收缩，一旦我们到达基本情况。特别是，我们可以看到延迟操作的数量随参数大小线性增长。

if I go from four to five I add one more deferred operation we can also see that the number of steps is basically twice the size of the argument I have one step to expand out and another except to

如果我从4到5，就增加一个延迟操作。我们还可以看到，步骤数基本上是参数大小的两倍：我有一半步骤用于展开，另一半用于

to expand out and another except to contract back down and let's compare that to the iterative factorial version. There's the procedure, the helper procedure that we're primarily going to use, and here's the trace of effect. We're just using those rewrite rules to substitute in again. If the helper is going to reduce to a call to 'if', but now the next reduction is just back to a single call to the helper once more.

展开，另一种则收缩回去，让我们将其与迭代阶乘版本进行比较。这是过程，我们主要使用的辅助过程，这里是效果的追踪。我们再次使用那些重写规则进行替换。如果辅助过程将化简为对“if”的调用，但现在下一步的化简只是再次回到对辅助过程的单次调用。

Look at the orange lines, notice the different shape. No deferred operations, no growth in space. The amount of room I need to keep...

看橙色的行，注意形状的不同。没有延迟操作，没有空间增长。我需要保留的空间量……

space the amount of room I need to keep track of this is simply the same no matter what size argument I'll use so we see that there's constant space here. In terms of number of steps, well, there's basically two steps for each operation here, but that basically also comes down to being very similar to our factorial case.

空间，我需要跟踪这个所需的空间量，无论参数大小如何都是相同的，所以我们看到这里是常数空间。就步数而言，每个操作基本上有两步，但这也基本上归结为与我们的阶乘情况非常相似。

So we can formally characterize that we say for fact that it's order of growth in space is linear, and the reasoning we just talked about: the amount of deferred operations increases by one as we increase the argument by one, so it's literally the size of the

因此我们可以正式刻画：对于阶乘，我们说它的空间增长阶是线性的，而我们刚才讨论的理由是：参数每增加一，延迟操作的数量就增加一，所以它确实是参数的大小……

one so it's literally the size of the argument that determines the number of steps we have in terms of time we also say it's linear remember the constant doesn't matter the fact that it takes two steps for each increase in the size of the argument still means it grows linearly an end where n is the size of the problem

一，所以确实是参数的大小决定了我们时间上的步数，我们也说它是线性的。记住常数无关紧要，参数大小每增加一需要两步，仍然意味着它随 n 线性增长，其中 n 是问题的大小。

iterative fact we saw behave differently here in terms of space there are no deferred operations there's nothing being stacked up there's no growth and we say the consequence that it's constant in space which we write a state

迭代阶乘我们看到了不同的行为，在空间方面，没有延迟操作，没有堆积，没有增长，我们说结果是空间上是常数的，我们写作 Θ(1)。

constant in space which we write a state of one saying it does not depend on the size of the argument time here is also linear it grows incrementally with the change in the argument size the actual constant may be slightly different but what we're interested in is the asymptotic behavior and therefore both factorial done recursively and factorial done iteratively have a similar linear growth in time what we can see though is that we can now formally characterize the difference between the two algorithms one is linear both in space and time the other is linear in time but

空间上是常数的，我们写作 Θ(1)，表示它不依赖于参数的大小。时间上也是线性的，它随参数大小的变化而逐步增长。实际常数可能略有不同，但我们感兴趣的是渐近行为，因此递归阶乘和迭代阶乘在时间上都有类似的线性增长。然而，我们现在可以看到，我们可以正式刻画这两种算法之间的区别：一种是空间和时间都是线性的，另一种是时间线性但空间常数。

and time the other is linear in time but constant in space let's step back for a second the key reason for estimating orders of growth isn't just to be able to say what they are what actually to let you begin to recognize how a particular design for an algorithm is going to affect what space and time you use

让我们退一步，估计增长阶的关键原因不仅仅是为了能够说出它们是什么，而是为了让你开始认识到特定算法设计将如何影响你使用的空间和时间。

this will allow you to work backwards to decide how my design choices are actually going to be important as I try and put my algorithm together and so what we're building up are templates for recognizing in this case linear recursive procedures

这将使你能够反向工作，决定我的设计选择在我尝试组合算法时实际上将如何重要。因此，我们正在建立的是识别模板，在这种情况下是线性递归过程……

case linear recursive procedures and linear iterative procedures having seen two different kinds of processes one linear and one constant we want to fill out our repertoire of things by looking at other kinds of processes the next one is an example of an exponential process and it deals with a classic function called Fibonacci its definition is that if it's argument is 0 its value is 0 if his argument is 1 value is 1 and for all other positive integer arguments if the value is the sum of its values for the two preceding arguments we would like to

线性递归过程和线性迭代过程。在看到了两种不同的过程，一种是线性的，一种是常数的之后，我们想通过观察其他类型的过程来充实我们的技能库。下一个是指数过程的例子，它涉及一个经典函数，称为斐波那契。其定义是：如果参数是 0，值为 0；如果参数是 1，值为 1；对于所有其他正整数参数，值为其前两个参数值之和。我们想要……

Two preceding arguments we would like to write a procedure to compute Fibonacci, and in particular see how it gives rise to a different kind of behavior to solve this problem. Let's use our tool of wishful thinking here. Wishful thinking says let's assume that given an argument M, we know how to solve Fibonacci for any smaller sized argument. Using that idea, we can then work out a solution to the problem. With this in hand, it's clear that the solution to the general problem is adjusted to solve two smaller sized problems, then add the results together.

前两个参数值之和。我们想要编写一个计算斐波那契的过程，特别是看看它如何产生一种不同的行为。为了解决这个问题，让我们使用我们的“愿望思维”工具。愿望思维说：假设给定一个参数 M，我们知道如何解决任何更小参数的斐波那契。利用这个想法，我们可以推导出问题的解决方案。有了这个在手，很明显，一般问题的解决方案是解决两个更小的问题，然后将结果相加。

problems then add the results together. Note that in this case we are using wishful thinking twice, not once as in our previous examples. Here's a procedure that captures this idea. First, we introduce a new expression called a cond expression. Kann uses the following rules of evaluation: the kann consists of a set of clauses, each of which has within it a predicate clause and one or more subsequent expressions. Kann proceeds by first evaluating the predicate of the first clause, in this case the N equals 0 case. If it is true, then we evaluate in...

问题，然后将结果相加。注意，在这种情况下，我们使用了两次愿望思维，而不是像之前的例子那样只用一次。这是一个捕捉这个想法的过程。首先，我们引入一个新的表达式，称为 cond 表达式。Cond 使用以下求值规则：cond 由一组子句组成，每个子句内部有一个谓词子句和一个或多个后续表达式。Cond 首先求值第一个子句的谓词，在这种情况下是 N 等于 0 的情况。如果为真，那么我们依次求值……

case if it is true then we evaluate in turn each of the other expressions in this clause returning the value of the last one as the value of the whole thing.

如果为真，那么我们依次求值该子句中的其他表达式，返回最后一个表达式的值作为整个表达式的值。

in the case of the first Clause of this cond that is the expression 0 if the predicate of the first Clause is false we move to the next clause in the content the process this continues for however many clauses are contained in the condon till either a true predicate is reached or we reach a clause with a special keyword else in this latter case that predicate is treated as true and the subsequent expressions are

对于这个 cond 的第一个子句，那就是表达式 0。如果第一个子句的谓词为假，我们移动到 cond 中的下一个子句。这个过程持续进行，无论 cond 中包含多少子句，直到达到一个真谓词，或者我们到达一个带有特殊关键字 else 的子句。在后一种情况下，该谓词被视为真，并且后续表达式被……

the subsequent expressions are I waited given that form for Conte we can see how our Fibonacci works in particular we discursively keep solving smaller sized problems until we get to a base case notice that here we have two of them not one also notice that while this is a recursive procedure it is different from our earlier one here there are two recursive calls to the procedure in the body rather than just one our question is whether this leads to a different kind of behavior or a different order of growth this does in fact give rise to a different kind of

后续表达式被求值。鉴于 cond 的这种形式，我们可以看到我们的斐波那契是如何工作的，特别是我们递归地解决更小的问题，直到达到基本情况。注意这里有两个基本情况，而不是一个。还要注意，虽然这是一个递归过程，但它与我们之前的不同：这里在过程体中有两个递归调用，而不是一个。我们的问题是这是否会导致不同的行为或不同的增长阶。这确实产生了一种不同的……

This fact gives rise to a different kind of behavior which we can easily see with the illustrated diagram. To solve a problem of say size four, note that we have to solve two problems, one of size three and one of size two. Each of these requires solving two smaller problems, and so on. This gives rise to a kind of tree of things that we have to do, and each recursive call requires two smaller subproblems to be solved.

这一事实引发了一种不同类型的行为，我们可以通过图示轻松看到。要解决一个规模为4的问题，注意我们必须解决两个问题，一个规模为3，一个规模为2。每个问题又需要解决两个更小的问题，依此类推。这产生了一棵我们必须完成的任务树，而每次递归调用都需要解决两个更小的子问题。

This leads indeed to a different order of growth. To measure the order of growth, let's let P of n denote the number of time steps we need to solve a problem of

这确实导致了不同的增长阶数。为了衡量增长阶数，我们令 P(n) 表示解决一个规模为 n 的问题所需的时间步数。

Time steps we need to solve a problem of size M from our tree we see that to do this we need to solve a problem of size n minus 1 and a problem of size n minus 2 we can actually work out a detailed analysis of this relationship but for our purposes we can approximate this as roughly the same in solving two problems of size n minus 2 expanding a step further this is roughly the same as solving for problems of size n minus 4 and roughly the same as solving 6 eight problems rather of size n minus 6 a little math shows that in general this

解决规模为 n 的问题所需的时间步数，从我们的树中可以看出，要解决这个问题，我们需要解决一个规模为 n-1 的问题和一个规模为 n-2 的问题。我们实际上可以对这个关系进行详细分析，但就我们的目的而言，我们可以将其近似为大致等同于解决两个规模为 n-2 的问题；进一步展开，这大致等同于解决四个规模为 n-4 的问题，再进一步，大致等同于解决八个规模为 n-6 的问题。一点数学推导表明，一般来说，这

little math shows that in general this

一点数学推导表明，一般来说，这

little math shows that in general this reduces to 2 to the power of n over 2 steps. This is an example of an exponential order of growth and this is very different from what we saw earlier.

一点数学推导表明，一般来说，这归结为 2 的 n/2 次方步。这是一个指数增长阶数的例子，这与我们之前看到的非常不同。

To convince yourself of this assume that each step takes 1 second and see how much time it would take for an exponential process as compared to a linear one as n gets large.

为了说服你自己，假设每一步需要 1 秒，看看当 n 变大时，指数过程与线性过程相比需要多少时间。

In terms of space, our tree shows us that we have basically one deferred operation for each step or in other words the maximum depth of that tree is linear in the size of the problem and the maximum depth.

在空间方面，我们的树表明，基本上每一步都有一个延迟操作，换句话说，该树的最大深度与问题规模成线性关系，而最大深度

of the problem and the maximum depth exactly captures the maximum number of deferred operations. Let's take another quick look at how we can create procedures with different orders of growth to compute the same function as a specific example. Suppose we want to compute Exponentials such as a raised to the B power, but to do so only using the simpler operations of multiplication and addition. How might we use the tools we've been developing so far to accomplish this? So recall the stages we use to solve problems like this: we will reuse some wishful thinking.

问题规模与最大深度恰好捕获了延迟操作的最大数量。让我们再快速看一下如何创建具有不同增长阶数的过程来计算同一个函数，作为一个具体例子。假设我们想要计算指数，比如 a 的 b 次幂，但仅使用乘法和加法这些更简单的运算。我们如何使用到目前为止开发出的工具来实现这一点？回想一下我们解决这类问题所用的步骤：我们将再次使用一些“愿望思维”。

this we will reuse some wishful thinking to assume that solutions to simpler versions of the problem exists we will then decompose the problem into a simpler version of the same problem plus some other simple operations and we'll use this to construct a solution to the more general problem and finally we'll determine the smallest sized subproblem into which we want to do decomposition so let's look at those three pieces those three tools applied to the problem of exponentiation remember that our first stage is wishful thinking which is

我们将再次使用一些“愿望思维”来假设更简单版本的问题的解已经存在；然后我们将问题分解为同一问题的更简单版本加上一些其他简单操作；我们将利用这一点来构造更一般问题的解；最后，我们将确定我们希望分解到的最小子问题规模。那么让我们看看这三个部分，这三个工具应用于求幂问题。记住，我们的第一阶段是愿望思维，即

first stage is wishful thinking which is our tool for using induction it says let's assume that some procedure let's call it my X exists so that we can use it but that it only solves smaller versions of the same problem given that assumption we can then turn to the tricky part which is determining how to decompose the problem into a simpler version of the same problem well here's one method notice that a to the power B mathematically is just taking B products of that factor a but this we can also group together as a times B minus one products of a and that latter we

第一阶段是愿望思维，这是我们使用归纳法的工具。它说让我们假设某个过程（我们称之为 myX）存在，以便我们可以使用它，但它只解决同一问题的更小版本。基于这个假设，我们可以转向棘手部分，即确定如何将问题分解为同一问题的更简单版本。这里有一种方法：注意，a 的 b 次幂在数学上就是 b 个因子 a 的乘积，但我们也可以将其分组为 a 乘以 b-1 个 a 的乘积，而后者我们

products of a and that latter we recognize as a smaller version of the same exponentiation problem, that is we can cluster things together so that we reduce a to the B power as just a times a to the B minus first power and thus we can reduce the problem to a simpler version of the same problem together with some simple operations in this case an additional multiplication.

后者我们认识到是同一求幂问题的更小版本，也就是说，我们可以将事物聚类，从而将 a 的 b 次幂简化为 a 乘以 a 的 b-1 次幂，因此我们可以将问题简化为同一问题的更简单版本加上一些简单操作，在这种情况下是一次额外的乘法。

given that idea here's the start of our procedure for my X notice how it recursively uses my X to solve the subproblem then multiplies the result by a to get the full solution of course as

基于这个想法，这是我们 myX 过程的开始。注意它如何递归地使用 myX 来求解子问题，然后将结果乘以 a 以获得完整解。当然，

a to get the full solution of course as stated that procedure will fail as it will recurse indefinitely to stop on winding into simpler versions of the same problem we need to find a smallest sized sub-problem here that's easy anything to the zeroth power is just 1 and thus we can add our base case to our procedure creating the same kind of procedure we saw earlier for factorial note how the base case will stop unwinding the computation into simpler cases and ground out this current compute you could run the substitution model on this procedure to both verify

当然，如上所述，该过程会失败，因为它会无限递归。为了停止展开为同一问题的更简单版本，我们需要找到一个最小规模的子问题。这里很容易：任何数的零次幂都是 1，因此我们可以将基本情况添加到我们的过程中，创建与我们之前看到的阶乘过程相同类型的过程。注意基本情况将如何停止将计算展开为更简单的情况，并使当前计算落地。你可以在该过程上运行替换模型，既验证

model on this procedure to both verify that it works and determine its growth pattern, however the form is very familiar or should be and we can thus deduce by comparison to factorial that this procedure has linear growth in both space and time.

在该过程上运行替换模型，既验证它是否有效，又确定其增长模式。然而，其形式非常熟悉（或者说应该熟悉），因此我们可以通过与阶乘比较推断出该过程在空间和时间上都具有线性增长。

the time is easy to see there is one additional step for each increment in the size of the argument and therefore it's going to take linear time to do the computation.

时间很容易看出：参数规模每增加一，就多一步，因此计算将花费线性时间。

as for space we see that there is one deferred operation for each recursive call of the procedure so we will stack up a linear number of such deferred

至于空间，我们看到每次递归调用过程都有一个延迟操作，因此我们将堆积线性数量的此类延迟

up a linear number of such deferred operations until we get down to the base case at that point we can then start gathering together operations and completing the deferred multiplications and computing of the full answer as we saw earlier

堆积线性数量的此类延迟操作，直到我们到达基本情况。此时我们可以开始收集操作，完成延迟的乘法，并计算出完整答案，正如我们之前所见。

we expect there are other ways of creating procedures to solve this same problem with factorial we use the idea of a table of state variables with update rules for changing the values of those variables as an alternative we should be able to do the same thing here so recall the idea of our table we set up one column for each

我们期望还有其他方法来创建过程来解决同一问题。对于阶乘，我们使用了状态变量表的思想，并带有更新规则来改变这些变量的值。作为替代，我们应该能够在这里做同样的事情。因此回想一下我们表格的思想：我们为

我们的表格中，为计算过程中每一步所需的每一条信息设置一列。当你为每一步使用一行时，这里的思路就相当直接了当。我们知道，a 的 b 次幂就是连续进行 b 次乘以 a 的运算，因此我们可以直接进行乘法，并记录到目前为止累积的乘积以及还剩下多少次乘法。

我们的表格中，为计算过程中每一步所需的每一条信息设置一列。当你为每一步使用一行时，这里的思路就相当直接了当。我们知道，a 的 b 次幂就是连续进行 b 次乘以 a 的运算，因此我们可以直接进行乘法，并记录到目前为止累积的乘积以及还剩下多少次乘法。

因此，经过一步之后，我们会得到乘积 a，并且剩下 b 减一次乘法；在下一步之后，我们将把当前乘积再乘以 a。

因此，经过一步之后，我们会得到乘积 a，并且剩下 b 减一次乘法；在下一步之后，我们将把当前乘积再乘以 a。

multiply our current product by a and keep track of that new result plus the fact that we have one left singlet and this process we can continue until we reach a point where we have no further multiplies left.

将我们当前的乘积乘以 a，并跟踪这个新结果以及我们还剩下一个单重态的事实，这个过程我们可以继续，直到我们达到一个没有更多乘法可做的点。

now what are the stages of this computation to get the next value for the product we take the current value of the product and the value of a multiplied together and keep that updates one of the state variables to the next get the next value of counter we simply subtract one from the current value since we have done one more of the multiplications that updates.

现在，这个计算的各个阶段是什么？为了得到乘积的下一个值，我们将当前乘积的值与 a 的值相乘，并将该更新保持为状态变量之一，以得到下一个值。为了得到计数器的下一个值，我们只需从当前值中减去一，因为我们已经完成了更多乘法中的一次，这更新了。

More of the multiplications that updates. We know that when the counter gets down to zero, there are no more multiplications to do, so we are done, and we get there we know the answer is sitting in the product column. Finally, we see that the starting point is just that anything to the zeroth power is one, so now we can capture this in a procedure.

更多乘法中的一次更新。我们知道当计数器降到零时，没有更多乘法要做，所以我们就完成了，并且我们到达那里时知道答案就在乘积列中。最后，我们看到起点就是任何数的零次幂等于一，所以现在我们可以将此捕获在一个过程中。

As with factorial, we're going to use a helper procedure to do this because we need a little more information, and as in that case, we can see that this procedure just checks for a base case.

与阶乘一样，我们将使用一个辅助过程来做这件事，因为我们需要多一点信息，并且在这种情况下，我们可以看到这个过程只是检查一个基本情况。

just checks for a base case and if they're simply returns the value of projects otherwise it reduces the computation to a simpler version of exactly the same computation with a new value for prog and a new value for count both obtained using the update rules we just created.

只是检查一个基本情况，如果满足则直接返回项目的值，否则它将计算化简为完全相同计算的更简单版本，其中 prog 和 count 都有新值，这两个值都是通过我们刚刚创建的更新规则获得的。

and what is the order of growth here in time this is still linear as there is one subject computation to perform for each increment in the size of be in space however we see as we did with factorial that here there are no deferred operations so this is constant.

这里的时间增长阶是什么？这仍然是线性的，因为对于 b 的每个增量大小，都有一个子计算要执行。然而在空间方面，我们像阶乘一样看到这里没有延迟操作，所以这是常数。

deferred operations so this is constant in terms of space dust. just as with factorial we see that we can create different procedures to compute exponentiation with different classes so now we've seen three very different kinds of procedures something that gives rise to a constant behavior something that gives rise to a linear behavior something that gives rise to an exponential behavior and those have very different costs in terms of time and space.

延迟操作，所以在空间方面这是常数。正如阶乘一样，我们看到我们可以创建不同的过程来计算不同类别的幂运算，所以现在我们看到了三种非常不同的过程：一种产生常数行为，一种产生线性行为，一种产生指数行为，这些在时间和空间方面有非常不同的代价。

let's finish up by looking at a fourth kind of process that has yet another kind of behavior here the

让我们通过看第四种过程来结束，这种过程有另一种行为。这里

Another kind of behavior here. The problem we're going to look at is how to compute exponentials; that is, to take a to the power of B, where B is an integer, but just using multiplication and addition as our basic primitive stages. As in our previous cases, the key component is to figure out how to reduce this problem to simpler versions of problems I know how to do, either simpler versions of the same problem or other operations that are more primitive.

另一种行为。我们要看的问题是计算指数，即计算 a 的 B 次幂，其中 B 是整数，但仅使用乘法和加法作为我们的基本原始步骤。与之前的情况一样，关键组成部分是弄清楚如何将此问题化简为我知道如何做的更简单版本的问题，要么是同一问题的更简单版本，要么是更原始的其他操作。

Let's start off. If B is an even integer, then a clever trick I can play is to realize that a to the power B is the same thing.

让我们开始。如果 B 是偶数，那么我可以玩一个巧妙的技巧，意识到 a 的 B 次幂是相同的。

that a to the power B is the same thing as taking a and squaring it then taking that to the power of B over 2 since B is even B over 2 is still an integer and the advantage of this is that in one step I've reduced a problem in half well that's okay but what if B is odd

a 的 B 次幂等同于取 a 并将其平方，然后将其取 B 除以 2 次幂，因为 B 是偶数，B 除以 2 仍然是整数，这样做的好处是，在一步中我将问题减半。好吧，那没问题，但如果 B 是奇数呢？

well if B is odd I can't play the same trick so I can simply reduce it to a simpler version of the same problem that is a to the power B is just a times a to the power B minus 1 notice again I'm using that wishful thinking idea I've reduced this down to a simpler version

好吧，如果 B 是奇数，我不能玩同样的技巧，所以我只能将其化简为同一问题的更简单版本，即 a 的 B 次幂就是 a 乘以 a 的 B 减 1 次幂。注意，我再次使用了那种愿望思维的想法，我将其化简为更简单的版本。

reduced this down to a simpler version of the same problem plus some stages that I know how to do and notice the nice thing that's happened here even if B is odd in one step I reduce it to a times a to the B - one but B - one is now even so that says on the next step I can cut this problem in half again so either way in a couple of steps I'm going to be able to reduce the problem in half and the next time around to reduce the problem in half again with those ideas we can build a procedure and here it is it's going to take in two arguments a and B and it's

化简为同一问题的更简单版本加上一些我知道如何做的步骤，并注意这里发生的好事：即使 B 是奇数，在一步中我将其化简为 a 乘以 a 的 B 减 1 次幂，但 B 减 1 现在是偶数，所以这意味着在下一步我可以再次将此问题减半，所以无论哪种方式，在几步之内我将能够将问题减半，并且下一次再次将问题减半。有了这些想法，我们可以构建一个过程，就在这里，它将接受两个参数 a 和 B，并且它

这个函数接收两个参数 a 和 B。它会根据一些情况来处理：如果 V 等于一，我们就进入基本情况，这时计算完成。否则，我们会用一个内置的谓词来检查它是否为偶数。如果是偶数，那么我知道我会调用 fast expurgate，但传入的参数会不同：a 变为 a 的平方，指数变为 B 除以二。

这个函数接收两个参数 a 和 B。它会根据一些情况来处理：如果 V 等于一，我们就进入基本情况，这时计算完成。否则，我们会用一个内置的谓词来检查它是否为偶数。如果是偶数，那么我知道我会调用 fast expurgate，但传入的参数会不同：a 变为 a 的平方，指数变为 B 除以二。

否则，我会将这个计算化简为 a 乘以 fast X（其中参数为 a 和 B 减一）的乘积，这正符合我的规则描述。注意，这个形式在某些情况下很有趣：一种情况下它看起来会表现得像迭代过程，而在另一种情况下则不同。

否则，我会将这个计算化简为 a 乘以 fast X（其中参数为 a 和 B 减一）的乘积，这正符合我的规则描述。注意，这个形式在某些情况下很有趣：一种情况下它看起来会表现得像迭代过程，而在另一种情况下则不同。

As an iterative thing in the other case, it looks like it's going to behave as a recursive thing, so I'm likely to have a few deferred operations but not as many as I had before.

在另一种情况下，它看起来会表现得像递归过程，所以我可能会有一些延迟操作，但不会像以前那么多。

The second and more important question is what happens in terms of time, because I'm cutting down the exponent in half. Do I get better performance?

第二个更重要的问题是时间方面会发生什么，因为我正在将指数减半。我是否获得了更好的性能？

Okay, let's measure the order of growth with a little bit of informal reasoning. We see in this case that if n is an even number, where n is the size of the problem and n is basically the size of the exponential that we're taking.

好的，让我们用一点非正式推理来衡量增长阶。我们看到在这种情况下，如果 n 是偶数，其中 n 是问题的大小，n 基本上是我们所取的指数的大小。

of the exponential that we're taking, then we know that in one step we reduce this to a problem of size n over two. If n is odd, in one step we reduce it to the problem of size n minus one, and in another step we reduce by a factor of two down to a problem of size n over two.

我们所取的指数的大小，那么我们知道在一步中我们将此化简为大小为 n 除以 2 的问题。如果 n 是奇数，在一步中我们将其化简为大小为 n 减一的问题，并且在另一步中我们通过因子 2 将其化简为大小为 n 除以 2 的问题。

This means in either case, after two steps we've cut the problem in half. This means in four steps we've caught the problem in half twice. In six steps we've cut the problem in half three times, or eight times if you like. And in general, in two K steps we reduce the problem.

这意味着在任何一种情况下，两步之后我们已经将问题减半。这意味着在四步中我们已经将问题减半两次。在六步中我们已经将问题减半三次，或者如果你愿意的话是八次。一般来说，在 2K 步中我们将问题化简。

In two K steps we reduce the problem down to a problem of n over 2 to the K. We've reduced it by a factor of 1/2 K. Times how do we tell when we're done? Well, when we get the problem down to a problem of size 1, we're finished. And that says when n over 2 to the K is equal to 1, we're completed.

在 2K 步中我们将问题化简为 n 除以 2 的 K 次幂的问题。我们已经通过 1/2 的 K 次幂的因子减少了它。我们怎么知道什么时候完成？好吧，当我们把问题化简到大小为 1 的问题时，我们就完成了。这表示当 n 除以 2 的 K 次幂等于 1 时，我们完成了。

And that lets us solve for K. In fact, what we find is that K, the number of steps we're going to take, is logarithmic in the size of the problem. This is a very fast algorithm. And again, convince yourself with this by taking some values for N and comparing the log.

这让我们解出 K。事实上，我们发现 K，即我们将采取的步数，是问题大小的对数。这是一个非常快的算法。再次，通过取一些 N 的值并比较对数来让自己信服。

some values for N and comparing the log of n versus 2 to the N versus n to realize that this is a very nice kind of algorithm to how it will complete things very quickly and be a much more efficient way of doing the kinds of things we'd like to do one can actually do the same kind of reasoning and you ought to try this to convince yourself that space is also logarithmic in the size of the problem.

对于某些N值，比较log n与2的N次方以及n，就会意识到这是一种非常好的算法，它能很快完成事情，并且是一种更高效的方式来做我们想做的事情。你也可以尝试同样的推理来说服自己：空间也是问题规模的对数。

to summarize we have now seen how our substitution model helps to explain the evolution of a process that occurs when a procedure is applied using this model we have seen.

总结一下，我们现在已经看到了替换模型如何帮助解释当过程被应用时所发生的过程演化。使用这个模型，我们已经看到。

applied using this model we have seen that very different kinds of behavior can occur even for procedures computing the same abstract function and we saw how to characterize those differences in terms of order of growth in space and time.

使用这个模型，我们已经看到，即使对于计算相同抽象函数的过程，也可能发生非常不同的行为，并且我们看到了如何根据空间和时间的增长阶次来刻画这些差异。

already you can see that there are different classes of algorithms we've seen constant linear exponential and logarithmic part of your task is to learn how to recognize the kinds of procedures that are associated with these different behaviors and to learn how to use that knowledge in designing efficient procedures for a particular.

你已经可以看到有不同类别的算法：我们看到了常数、线性、指数和对数。你的任务的一部分是学会识别与这些不同行为相关联的过程类型，并学会如何利用这些知识来为特定问题设计高效的过程。

efficient procedures for a particular problem let's take one more look at this idea of creating procedures to solve a problem where the procedures can have different behaviors in terms of how their underlying process evolved for a different example let's look at a mathematical problem known as Pascal's triangle the elements of Pascal's triangle are shown here the first store just has a single element the second role has two the third role has three and so on and clearly there's a structure to these elements which we need to understand

为特定问题设计高效的过程。让我们再看一下这个创建过程来解决问题，其中过程在底层过程演化方面可以有不同的行为。对于另一个例子，让我们看一个称为帕斯卡三角形的数学问题。帕斯卡三角形的元素在这里显示：第一行只有一个元素，第二行有两个，第三行有三个，依此类推。显然这些元素有一种结构，我们需要理解它。

elements which we need to understand so let's structure this problem a bit. So let's structure this problem a bit. So let's structure this problem a bit. Let's order the rows and enumerate them. Let's order the rows and enumerate them. Let's order the rows and enumerate them, labeling the first row n equals zero of the second row n equal one and so on. We'll see that this choice of labeling leads to a cleaner description of the problem in a second using this labeling. We can also see that the anthro has n plus 1 elements in it.

我们需要理解这些元素，所以让我们稍微结构化这个问题。让我们对行进行排序并枚举它们。让我们对行进行排序并枚举它们，将第一行标记为n等于零，第二行标记为n等于一，依此类推。我们会看到这种标记选择会在接下来带来更清晰的问题描述。使用这种标记，我们还可以看到第n行有n加1个元素。

Let's use the notation T of JM to denote the J's element of the anthro. Our goal is to determine how to compute all the elements of each row traditionally. Pascal's triangle is constructed by.

让我们使用记号T of J M来表示第n行的第J个元素。我们的目标是确定如何计算每一行的所有元素。传统上，帕斯卡三角形是通过以下方式构造的。

Pascal's triangle is constructed by noting that the first and last element of each row except the first is a 1 and by noting that to get any other element in a row we add the corresponding element of the previous row and its predecessor together. If you use this rule of thumb, you can verify that this works by generating the first few rows of the triangle.

帕斯卡三角形是通过注意每一行（除了第一行）的第一个和最后一个元素都是1，并且注意要得到一行中的任何其他元素，我们将前一行中对应的元素及其前一个元素相加。如果你使用这个经验法则，你可以通过生成三角形的前几行来验证这是有效的。

So we have an informal specification how to generate Pascal's triangle. We can then proceed in a straight forward manner by capturing that idea in a procedure. Note the form we have two base cases.

所以我们有了一个非正式的规范来生成帕斯卡三角形。然后我们可以直接通过将该思想捕获到一个过程中来进行。注意形式，我们有两个基本情况。

procedure note the form we have two base cases one for when we're generating the cases one for when we're generating the cases one for when we're generating the first element of the row and one for the first element of the row and one for the first element of the row and one for the last element of the row last element of the row last element of the row

过程，注意形式，我们有两个基本情况：一个用于生成行的第一个元素，一个用于生成行的最后一个元素。

otherwise we simply rely on smaller otherwise we simply rely on smaller otherwise we simply rely on smaller versions of the same computation to do versions of the same computation to do versions of the same computation to do the job we compute the same element of the job we compute the same element of the job we compute the same element of the previous row and its predecessor and the previous row and its predecessor and the previous row and its predecessor and then add them together to get an element then add them together to get an element then add them together to get an element of a new row you can verify that this is of a new row you can verify that this is of a new row you can verify that this is correct by trying some examples so correct by trying some examples so correct by trying some examples so

否则，我们简单地依赖相同计算的更小版本来完成工作。我们计算前一行中的相同元素及其前一个元素，然后将它们相加以得到新行的元素。你可以通过尝试一些例子来验证这是正确的。

clearly the code also just reflects the clearly the code also just reflects the clearly the code also just reflects the relationship we described in the relationship we described in the relationship we described in the previous slide so what kind of process previous slide so what kind of process previous slide so what kind of process does this procedure engender well

显然，代码也仅仅反映了我们在前一张幻灯片中描述的关系。那么这个过程会产生什么样的过程呢？

Does this procedure engender well, it looks a lot like our computation of Fibonacci, and that's a pretty good clue. Just like Fibonacci, there are two recursive calls to smaller versions of the same process at each stage. In fact, a similar analysis will show that this is a process that is exponential in time and linear in space.

这个过程会产生什么样的过程呢？嗯，它看起来很像我们计算斐波那契数列的过程，这是一个很好的线索。就像斐波那契一样，每一阶段都有两个对相同过程更小版本的递归调用。事实上，类似的分析将表明这是一个在时间上指数、在空间上线性的过程。

We've already suggested that exponential algorithms are costly. In the case of Fibonacci, we didn't look for any other way of structuring the problem, but let's try to do better for Pascal. To do better, we have to go back to the original problem.

我们已经指出指数算法代价高昂。在斐波那契的情况下，我们没有寻找其他方式来构造问题，但让我们尝试为帕斯卡做得更好。要做到更好，我们必须回到原始问题。

have to go back to the original problem. The little information from combinatoric tells us that in actuality Pascal's triangle is capturing the number of different ways of choosing a set of J objects from a set of n objects. This is an obvious, by the way, so just accept it as a fact.

必须回到原始问题。组合学中的一点信息告诉我们，实际上帕斯卡三角形捕捉的是从n个对象中选择J个对象的不同方式的数量。顺便说一下，这是显而易见的，所以只需接受它作为一个事实。

Thus, the first element of a row is the number of ways of picking no objects, which is by definition one. The last element of a row is the number of ways of picking a set of n objects from a set of n objects, since the order in which we pick the objects doesn't matter.

因此，一行的第一个元素是不选择任何对象的方式数，根据定义为一。一行的最后一个元素是从n个对象中选择n个对象的方式数，因为选择对象的顺序无关紧要。

which we pick the objects doesn't matter, there's only one size n subset of a set of size M, hence this element is also one. The general case is the number of different subsets of size J that can be created out of a set of size n, so what is that number?

我们选择对象的顺序无关紧要，一个大小为n的集合只有一个大小为n的子集，因此这个元素也为一。一般情况是从大小为n的集合中可以创建的大小为J的不同子集的数量，那么这个数量是多少呢？

Well, we can pick the first element by selecting any of the N elements of the set, the second element has n minus 1 possibilities, and so on, until we picked out J objects. That product we can represent as a fraction of two factorial products, as you can see. Now we're not quite done, because we said the order in which we picked the objects

那么，我们可以通过选择集合中N个元素中的任意一个来选取第一个元素，第二个元素有n减1种可能，依此类推，直到我们选出J个对象。这个乘积可以表示为两个阶乘乘积的比值，如你所见。现在我们还没完全完成，因为我们说过选取对象的顺序

The order in which we picked the objects doesn't matter. Using the method we just described, we could pick the same set of J objects in J factorial different orderings.

选取对象的顺序并不重要。使用我们刚才描述的方法，我们可以用J的阶乘种不同的顺序来选取同一组J个对象。

So to get the number of distinct subsets of size J, we factor this out as shown. This leads to a straightforward way to compute Pascal: we can just rely on the factorial code we created earlier.

因此，为了得到大小为J的不同子集的数量，我们按所示方式将其约去。这导致了一种直接计算帕斯卡的方法：我们可以直接依赖我们之前创建的阶乘代码。

Here we use factorial 3 times, once for the numerator and twice in the denominator. Notice how a procedural abstraction nicely isolates the details of fact from its use in this case.

这里我们使用了3次阶乘，分子一次，分母两次。注意过程抽象如何在这种情况下很好地隔离了fact的细节与其使用。

Of fact from its use in this case, and the code here cleanly expresses the idea of computing Pascal based on factorial. So do we do any better with this version of Pascal? Sure, we know that this version of fact is linear.

将fact的细节与其使用隔离，这里的代码清晰地表达了基于阶乘计算帕斯卡的思想。那么这个版本的帕斯卡是否更好呢？当然，我们知道这个版本的fact是线性的。

Our Pascal implementation uses fact three different times, but this is still linear in time. A similar analysis lets us also conclude that this is linear in space as well.

我们的帕斯卡实现使用了三次fact，但这仍然是时间线性的。类似的分析也让我们可以得出结论，这在空间上也是线性的。

Because factorial is well, it might take three times as long to run than just running fact. What we're concerned with is the general order or how these processes' computational needs change.

因为阶乘，嗯，运行它可能比只运行fact花费三倍的时间。我们关心的是总体阶数，或者这些过程的计算需求如何变化。

processes computational needs change with changing problem size and both are linear in that change well earlier we saw that there were different ways of computing factorial suppose we use the iterative version instead of the recursive one the same effect takes place

过程的计算需求随问题规模的变化而变化，而两者在该变化中都是线性的。嗯，之前我们看到计算阶乘有不同的方法。假设我们使用迭代版本而不是递归版本，同样的效果会发生。

now we have a version of Pascal that is linear in time and constant in space relying on the fact that factorial under this version is also linear in time and constant in finally if the use of an iterative factorial procedure gives us better performance why not just do this computation directly as well by

现在我们有了一个帕斯卡版本，它在时间上是线性的，在空间上是常量的，这依赖于阶乘在该版本下也是时间线性和空间常量的。最后，如果使用迭代阶乘过程能带来更好的性能，为什么不直接进行这个计算呢？

do this computation directly as well by that we mean just compute the two products one for the numerator and want the denominator and save those extra multiplications that we're doing in the extra call to factorial after all we're just going to compute a product of terms that we know we're going to simply factor out later.

直接进行这个计算，我们的意思是直接计算两个乘积，一个用于分子，一个用于分母，并省去我们在额外调用阶乘时所做的那些额外乘法。毕竟我们只是要计算一些项的乘积，而我们知道稍后我们会简单地将其约去。

we can do the same analysis for this version our health procedures clearly constant in space and linear in time by the analysis we've done earlier. our version of Pascal uses this twice, so while it does take less

我们可以对这个版本进行同样的分析。根据我们之前的分析，我们的健康过程显然是空间常量、时间线性的。我们的帕斯卡版本使用了两次该过程，因此虽然它确实花费更少的

this twice so while it does take less actual time than the previous version it still has the same general behavior linear in time and constant in space

两次，因此虽然它确实比之前的版本花费更少的实际时间，但它仍然具有相同的一般行为：时间线性和空间常量。

thus in practical terms this may be the best version but theoretically it has the same class of behavior as our previous version

因此，在实际应用中，这可能是最好的版本，但从理论上讲，它与我们之前的版本具有相同的行为类别。

and this leads to our concluding point first we stress that the same problem may have many different solutions and that these solutions may have different computational behaviors some problems are inherently exponential in nature

这引出了我们的结论要点。首先，我们强调同一个问题可能有许多不同的解决方案，而这些解决方案可能具有不同的计算行为。有些问题本质上是指数级的。

others may have straightforward solutions that have exponential behavior

其他问题可能有直接的解决方案，但具有指数行为。

solutions that have exponential behavior, but often some additional thoughts can lead to more efficient solutions. Part of our goal is to get you to recognize different classes of behavior and to learn how to use the properties of standard algorithms to help you design

具有指数行为的解决方案，但通常一些额外的思考可以导致更高效的解决方案。我们的部分目标是让你们识别不同类别的行为，并学会如何利用标准算法的性质来帮助你们设计