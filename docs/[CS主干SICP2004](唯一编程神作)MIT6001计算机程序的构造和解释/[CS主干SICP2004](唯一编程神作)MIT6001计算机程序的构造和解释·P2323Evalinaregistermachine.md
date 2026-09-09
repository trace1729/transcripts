# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=23)

在过去的两次讲座中，我们一直在研究寄存器机。我们从基本寄存器和一些原始操作的概念出发，探讨了如何将它们组合起来，通过一系列指令来控制计算过程，这些指令将值从一个寄存器移动到另一个寄存器，也可能通过某些操作对这些值进行处理。然后，我们将子程序的概念概括为一种提取计算片段并进行泛化的方式，如果涉及的话，我们还引入了栈的概念。

在过去的两次讲座中，我们一直在研究寄存器机。我们从基本寄存器和一些原始操作的概念出发，探讨了如何将它们组合起来，通过一系列指令来控制计算过程，这些指令将值从一个寄存器移动到另一个寄存器，也可能通过某些操作对这些值进行处理。然后，我们将子程序的概念概括为一种提取计算片段并进行泛化的方式，如果涉及的话，我们还引入了栈的概念。

If we've added in the idea of stacks, you'll recall the goal of a stack was to have a place into which we could store away temporarily values and registers so that we could reuse some computational machinery, some subroutine to do a subproblem, then restore the state of the machine and pick up the rest of that computation. We're now ready to do the idea of building a register machine for any kind of computation, and as we suggested a few times ago, we're going to do this for a Val. Our reason for completing this process by building a Val or register machines is very...

如果我们已经加入了栈的概念，你会记得栈的目标是有一个地方，我们可以临时存储值和寄存器，以便重用某些计算机制、某个子程序来解决子问题，然后恢复机器状态并继续该计算的其余部分。我们现在准备为任何类型的计算构建寄存器机，正如我们几次之前所建议的，我们将为Val（求值器）做到这一点。我们通过为Val构建寄存器机来完成这一过程的理由非常……

Valid or register machines is very simple. Once we've built a Val, we have what we called a universal machine. If Val can then evaluate any other expression, it can simulate any other process by simply providing a description of it to eval.

为Val构建寄存器机的理由非常简单。一旦我们构建了Val，我们就拥有了所谓的通用机器。如果Val能够求值任何其他表达式，它就可以通过向它提供过程的描述来模拟任何其他过程。

So by building a Val out of register machines, we will complete our construction of a simple kind of CPU. We will have connected the underlying Hardware, simple set of registers, simple set of procedures, and some mechanisms for sequencing instructions of things through those registers. We'll have completed that.

因此，通过用寄存器机构建Val，我们将完成对一种简单CPU的构造。我们将把底层硬件、简单的寄存器集合、简单的过程集合以及一些通过这些寄存器对指令进行排序的机制连接起来。我们将完成这一连接。

registers we'll have completed that connection from that up to an actual evaluator or interpreter that can take in any expression in the language and deduce its meaning and return that value. We know the general form that our evaluator should take for a register machine version of eval, and I say that in two ways. One is we certainly know the kinds of pieces that will be there. We need to somehow translate the meta-circular evaluator that we did earlier down into register machine operations. But the second piece about knowing that form is that we also know

寄存器，我们将完成从底层到实际求值器或解释器的连接，该解释器可以接受语言中的任何表达式，推导其含义并返回其值。我们知道我们的求值器应该采用的一般形式，用于寄存器机版本的eval，我这样说有两个方面。一是我们当然知道将会有哪些部分。我们需要以某种方式将我们之前做的元循环求值器翻译成寄存器机操作。但关于知道该形式的第二点是，我们也知道……

knowing that form is that we also know that a val is going to have to walk through a recursive loop evaluating an expression is typically going to reduce to applying a procedure to some arguments which will in turn reduce to evaluating a new expression often the body of that procedure with respect to some new environment and that loop that unwinding of the abstractions is going to require that we use the stack to save a way state in the terms of evaluating one expression we're going to need to hold onto some things while we go off get the value of a sub expression to

知道该形式的第二点是，我们也知道eval必须遍历一个递归循环来求值表达式，通常归结为将过程应用于参数，这又归结为求值新表达式，通常是相对于某个新环境的过程体，而那个循环、那种抽象展开将要求我们使用栈来保存状态，在求值一个表达式的过程中，当我们去获取子表达式的值时，我们需要持有一些东西……

get the value of a sub expression to look at that idea and to remind ourselves of what we saw last time. Consider the following little example: here's a special version of factorial that I've written, different from the normal version of factorial. Normally we would just apply a procedure to one argument, m, to get n factorial. Here, I'm going to deal with both passing the value for n and a product. My little procedure here will display the current value of the product, and then, depending on whether it's in the base case or not, either return the product.

获取子表达式的值，为了审视这个想法并提醒我们上次看到的内容，考虑下面这个小例子：这是我写的一个特殊版本的阶乘，与正常的阶乘版本不同。通常我们只将一个参数m应用于过程，得到n的阶乘。这里，我将同时传递n的值和一个乘积。我的这个小过程将显示当前乘积的值，然后根据是否处于基本情况，要么返回乘积……

Case or not are they return the product or compute the product counting down by one and increasing the product by multiplying by n. Now the reason for using this procedure is that we want to think about what happens as we evaluate this.

要么返回乘积，要么计算乘积，n递减1，乘积乘以n递增。现在使用这个过程的原因是，我们想思考当我们求值这个表达式时会发生什么。

In particular, two questions: what's displayed when we evaluate s fact of four and one, and secondly, does s fact describe an iterative or a recursive process? Think about it for a second, then click the mouse when you're ready to answer.

特别是两个问题：当我们求值s fact of 4 and 1时显示什么？其次，s fact描述的是迭代过程还是递归过程？想一下，然后点击鼠标准备回答。

In terms of what's displayed, we see that s fact basically works from the

关于显示的内容，我们看到s fact基本上是从上到下工作的。

See, that fact basically works from the top down. The first time it's called is going to print out one because the initial product is one. Since n is not equal to one, it's going to call itself again with the first argument of three, and to increase the product by multiplying by the current value of n, which is 4, so we print out four.

看，s fact基本上是从上到下工作的。第一次调用时会打印出1，因为初始乘积是1。由于n不等于1，它会用第一个参数3再次调用自身，并通过将当前n的值（即4）乘以乘积来增加乘积，所以我们打印出4。

And the game will do it around multiplying that product by three, and again go around multiplying that product by two until we're done, and we can return the value. So we're working from the top down here, not a big deal. Of more interest is the

然后游戏会继续，将乘积乘以3，再次继续将乘积乘以2，直到完成，我们可以返回该值。所以我们在这里是从上到下工作的，这没什么大不了的。更有趣的是……

Not a big deal of more interest is the kind of process that 's fact' describes. Does it describe an iterative or recursive one? And the answer we know is, its iterative. There are no deferred operations in this case; it's different than the normal factorial what we'd have to hold on to that multiplication. Well, we went off and got the factorial of something smaller. By changing the way we think about this, we've converted it to an iterative process.

没什么大不了的，更有趣的是s fact描述的过程类型。它描述的是迭代过程还是递归过程？我们知道答案是迭代的。在这种情况下没有延迟操作；这与正常的阶乘不同，在正常的阶乘中，我们必须持有那个乘法。当我们去获取某个更小数的阶乘时，通过改变我们思考这个问题的方式，我们将其转换为迭代过程。

But the question then is: how do I set up an evaluator, a register machine version of eval? That is, a register machine version of eval that...

但接下来的问题是：我如何设置一个求值器，一个寄存器机版本的eval？也就是说，一个寄存器机版本的eval，它……

register machine version of eval that will take advantage of the fact that there are no deferred operations here in order to be very efficient we saw a hint of that last time in the previous lecture let's look at that again in a little more detail now

寄存器机版本的eval将利用这里没有延迟操作的事实，以便非常高效。我们上次在上一讲中看到了这一点，现在让我们更详细地再看一下。

our goal is to build that evaluator to implement a valve in register machines but to do this we actually want a very particular kind of evaluator we want to use that idea from last lecture of dominant doing something that's tail recursive what does that mean

我们的目标是构建那个求值器，用寄存器机实现Val，但要做到这一点，我们实际上想要一种非常特殊的求值器。我们想使用上一讲中关于支配性的想法，做一些尾递归的事情。那是什么意思？

it says the stack should not grow if the procedure being evaluated is

它说，如果被求值的过程实际上是迭代的，那么栈不应该增长。

Grow if the procedure being evaluated is actually iterative. This is not true of most languages; for example, most Java and Pascal systems are not tail-recursive. And as a consequence, you cannot use recursive procedures as loops. The reason is that in fact it will cause the stack to explode on us.

如果被求值的过程实际上是迭代的，那么栈不应该增长。这不是大多数语言的情况；例如，大多数Java和Pascal系统不是尾递归的。因此，你不能使用递归过程作为循环。原因是，实际上这会导致栈对我们爆炸。

Evaluation based on fact would have a recursive growth in which every time we called it we would have to do an evaluation of the body which would cause another call. What would that do to the stack in terms of an evaluator if we didn't use this trick of tail call optimization?

基于fact的求值会有递归增长，每次我们调用它时，我们都必须对过程体进行求值，这会导致另一次调用。如果我们不使用尾调用优化这个技巧，这对求值器的栈会有什么影响？

Well think about it abstractly. Ignore the fact we haven't actually built a value. Suppose our eval did not have tail call optimization; it was just a standard kind of evaluator.

嗯，我们抽象地想一想。忽略我们实际上还没有构建出一个值这一事实。假设我们的求值器没有尾调用优化；它只是一个标准的求值器。

Gee, if we evaluate s factor for and one, for example, with respect to a global environment, that reduces to doing an

哎呀，如果我们求值 s 因子，例如，相对于一个全局环境，那会归结为执行一个

environment that reduces to doing an evaluation of an application but because we want to get that value we have to push that onto the stack, we're going to have to come back and finish evaluating the application after we get the value of the body of this procedure.

环境，归结为执行对一个应用式的求值，但因为我们要得到那个值，我们必须把它压入栈中，我们必须在得到这个过程体的值之后回来完成对应用式的求值。

that says we then go off and evaluate the sequence of the body of display of something in an if and of course we know that once the value of associated with that is returned we're going to hand it back to application but this itself involves another process.

也就是说，我们接着去求值 display 的某个东西在一个 if 中的体序列，当然我们知道一旦与之关联的值被返回，我们会把它交还给应用式，但这本身又涉及另一个过程。

This itself involves another process, so we'd have to push that onto the stack while we go off and evaluate the if. You see the idea: we keep pushing an expression onto the stack while we go off and get the value of the next sub-piece.

这本身又涉及另一个过程，所以我们必须把它压入栈中，同时去求值 if。你明白这个意思：我们不断把一个表达式压入栈中，同时去获取下一个子部分的值。

In fact, for this example, just to unwind s fact by one level, we have to push five different things onto the stack. Each one of them is an evaluation that is waiting for a value to come back.

事实上，对于这个例子，仅仅为了展开 s 因子一层，我们就必须把五个不同的东西压入栈中。它们每一个都是一个等待值返回的求值。

But we know what that value is once we get the final value for s fact. We're going to hand it back to each one of these expressions in turn, each one of which is waiting to receive it.

但一旦我们得到 s 因子的最终值，我们就知道那个值是什么。我们将依次把它交还给这些表达式中的每一个，每一个都在等待接收它。

these expressions in turn each one of these operations and they are simply going to pass that value back through what's the point I didn't need to keep track of this particular sequence of operations on the stack I didn't need to have to hold on to the fact that I'm doing an evaluation of an application well I'll go off and get the sub part because in fact I know if I look ahead at the code that the answer I'm going to return will be passed straight back if I don't do that tail call optimization the stack grows each time around the loop we put

这些表达式依次地，每一个这些操作，它们只是要把那个值传递回去——重点是什么？我不需要跟踪栈上的这一特定操作序列，我不需要必须记住我正在对一个应用式进行求值，然后去获取子部分，因为事实上我知道，如果我向前看代码，我将返回的答案会被直接传递回去。如果我不做那种尾调用优化，栈就会在每次循环时增长，我们放入

grows each time around the loop we put on this sequence in this case of five different pieces onto the stack for each recursive call to s fact which is going to cause the stack potentially to explode if we can use that tail call optimization we can have processes that are inherently iterative behave that way not using up any of the stack having no growth in the stack as a function of the argument call so that's our goal is to build an evaluator order register machine that has exactly this property with that idea in mind let's turn to our

每次循环时增长，我们放入这个序列，在这种情况下是五个不同的片段，每次对 s 因子的递归调用都会这样，这可能导致栈爆炸。如果我们能使用尾调用优化，我们就可以让本质上迭代的过程以那种方式运行，不占用任何栈空间，栈的增长不随参数调用而变化。所以我们的目标是构建一个求值器，一个寄存器机器，它恰好具有这个性质。带着这个想法，让我们转向我们的

with that idea in mind let's turn to our

带着这个想法，让我们转向我们的

With that idea in mind, let's turn to our goal, which is to build a register machine implementation of a Val, to basically build a CPU. We're going to take the ideas we saw earlier in the meta-circular evaluator, which are done in a more abstract way, and map them down into manipulation of registers using very simple built-in procedures.

带着这个想法，让我们转向我们的目标，即构建一个 Val 的寄存器机器实现，基本上就是构建一个 CPU。我们将采用我们之前在元循环求值器中看到的那些思想，它们是以更抽象的方式完成的，并将它们映射到寄存器的操作中，使用非常简单的内置过程。

So we're going to create, if you like, a coupling between the hardware of registers and the idea of the universal machine doing a Val. Now, I need to decide what registers and how many I'm going to have.

所以我们将创建，如果你愿意，一个寄存器硬件与通用机器执行 Val 的思想之间的耦合。现在，我需要决定我将拥有哪些寄存器以及多少个。

registers and how many I'm going to have, and I'm going to arbitrarily choose seven. This is not a particularly magic number; I could do it with a different version or different numbers of them, but seven is going to be convenient. And here are the seven I'm going to use. I'm going to have a register called exp for expression; it will hold the expression to be evaluated. Similarly, I'm going to have a register called M for environment, which will hold the current environment. I'll have a continue register, as we always have before, that holds the return point. I'll have a

寄存器以及我将拥有多少个，我将任意选择七个。这不是一个特别神奇的数字；我可以用不同的版本或不同数量的寄存器来做，但七个会很方便。以下是我将使用的七个。我将有一个名为 exp 的寄存器用于表达式；它将保存要求值的表达式。类似地，我将有一个名为 M 的寄存器用于环境，它将保存当前环境。我将有一个 continue 寄存器，像我们之前一直有的那样，保存返回点。我将有一个

Holds the return point. I'll have a fourth register called Val that is going to be the place into which I store the resulting value. And in fact, if we stop here, we see those four are very similar to things we did earlier. Well, we didn't have the environment, but we basically had a register that held something to be evaluated, we had a return point, and we had a place to store the value.

保存返回点。我将有第四个寄存器，名为 Val，它将是我存储结果值的地方。事实上，如果我们停在这里，我们看到这四个与我们之前做的事情非常相似。嗯，我们没有环境，但我们基本上有一个寄存器保存要求值的东西，我们有一个返回点，我们有一个存储值的地方。

What else do I need? On F will be a pointer or register rather that contains a list of unevaluated expressions, things like the operand lists or sequences of.

我还需要什么？On F 将是一个指针或寄存器，更确切地说，它包含一个未求值表达式的列表，比如操作数列表或序列。

The operand lists or sequences of expressions will also use it as a temporary register in other places where we need something to temporarily store away a value. Those five registers will be involved in evaluating an expression with respect to an environment.

操作数列表或表达式序列，我们也会在其他需要临时存储值的地方将它用作临时寄存器。这五个寄存器将参与相对于环境求值一个表达式。

We'll have two more registers: proc, which is going to hold the operator value, and argyll, which is going to be a list of arguments. Those registers will be used to store the procedure to be applied to a set of arguments and the actual argument list themselves. And indeed we expect to.

我们还将有两个更多的寄存器：proc，它将保存操作符的值，以及 argyll，它将是一个参数列表。这些寄存器将用于存储要应用于一组参数的过程以及实际的参数列表本身。事实上，我们期望

list themselves and indeed we expect to see a loop in which we take an expression in XP and an environment in amp and we unwrap this into an application of a procedure that's stored in proc and some arguments in argyll that's exactly the loop we saw in a Val we're just going to now map this down into registers so our goal now is to take that evaluator we saw before and rewrite it or re implement it in terms of manipulations of these registers before we do though let's stress a few things that are going to be useful for keeping track of what we do first for

列表本身，事实上我们期望看到一个循环，在其中我们取 XP 中的一个表达式和 amp 中的一个环境，我们将其展开为一个过程的应用，该过程存储在 proc 中，以及一些参数在 argyll 中，这正是我们在 Val 中看到的循环。我们现在只是要将其映射到寄存器中。所以我们的目标现在是取我们之前看到的那个求值器，并根据这些寄存器的操作重写或重新实现它。不过在我们这样做之前，让我们强调一些对于跟踪我们所做的事情有用的要点。首先，为了

keeping track of what we do first for clarity we're going to assume a whole bunch of abstract operations as primitives all of these are things that just deal with the syntax like getting out pieces of expressions or creating expressions they don't have to be in fact primitive things it's just easier to think of them that way we know that we can always reimplemented sure things so the abstractions is going to let us focus on the idea of evaluation but what we're doing is assuming that those kinds of syntactical manipulations are

为了跟踪我们所做的事情，首先为了清晰起见，我们将假设一大堆抽象操作作为原语。所有这些都只是处理语法的事情，比如从表达式中取出部分或创建表达式。它们实际上不必是原语；只是这样想更容易。我们知道我们总是可以重新实现这些东西。所以抽象将让我们专注于求值的想法，但我们所做的是假设那些种类的语法操作是

of syntactical manipulations are available as little pieces of hardware. Second, we're going to assume that the environment manipulation procedures are also primitives for the same reason. Third, note that when we talk about an expression being in a register, this means that a pointer to some tree structure that represents the expression is in that register.

语法操作的小片段可以作为硬件小部件来使用。其次，我们假设环境操作过程也是原语，原因相同。第三，注意当我们说一个表达式在寄存器中时，这意味着指向表示该表达式的某个树结构的指针在该寄存器中。

Now that this means we're going to need lots of cons pairs and primitive procedures to manipulate them. We refer to this large collection of pairs as the heap, and we're going to ignore issues of how cells are allocated.

这意味着我们将需要大量的 cons 对和操作它们的原语过程。我们将这一大集合的 cons 对称为堆，并且我们将忽略如何分配单元的问题。

ignore issues of how cells are allocated from the heap to create tree representations at least for now. It also means that our registers can be a fixed size yet represent larger expressions. They're simply pointers to the tree structure. And as we saw with eval, all we need are procedures that can manipulate that tree structure to load new pointers into registers, getting for example new expressions available okay. Now let's do this: let's take our idea of a vowel and let's look at how to map it down into these seven registers and primitive.

忽略如何从堆中分配单元以创建树表示的问题，至少目前是这样。这也意味着我们的寄存器可以是固定大小的，却能够表示更大的表达式。它们只是指向树结构的指针。正如我们在 eval 中看到的，我们所需要的只是能够操作该树结构的过程，以将新的指针加载到寄存器中，例如，获得新的可用表达式。好的，现在让我们这样做：让我们采用我们的 eval 思想，看看如何将其映射到这七个寄存器和原语操作上。

These seven registers and primitive operations on those registers, the operations on those registers, the starting point for our evaluator will be a spot labeled eval-dispatch g that sounds like a convenient label because we know a valve should in fact be a dispatch, a dispatch on type so our entry point into this register machine begins there. We're going to see that we come back many times to a valid dispatch because every time we want to get a value of some sub expression we come back and redo the eval-dispatch.

这七个寄存器以及对这些寄存器的原语操作，我们求值器的起点将是一个标记为 eval-dispatch 的位置，这听起来像是一个方便的标签，因为我们知道 eval 实际上应该是一个分派，一个基于类型的分派，所以我们的寄存器机器的入口点从这里开始。我们将看到我们多次回到 eval-dispatch，因为每当我们想要获取某个子表达式的值时，我们都会回来重新执行 eval-dispatch。

Eval-dispatch has a contract and is shown here in blue. It says the following: it says it expects three inputs.

Eval-dispatch 有一个契约，这里用蓝色显示。它说明如下：它期望三个输入。

它表明期望三个输入。它期望 exp 寄存器持有待求值的表达式，正如我们所说，那可能只是一个指向某个树结构的指针。它期望 em 持有指向环境的指针，我们也期望那可能也是一个树结构。

它表明期望三个输入。它期望 exp 寄存器持有待求值的表达式，正如我们所说，那可能只是一个指向某个树结构的指针。它期望 env 持有指向环境的指针，我们也期望那可能也是一个树结构。

现在我们假设使用抽象操作来实际操纵它。当然，它还期望 continued 持有一个返回点。当我们初次启动时，那个 continue 可能指向顶层的读取-求值-打印循环，但当然，我们知道随着我们展开这段流程的各个部分，

现在我们假设使用抽象操作来实际操纵它。当然，它还期望 continue 持有一个返回点。当我们初次启动时，那个 continue 可能指向顶层的读取-求值-打印循环，但当然，我们知道随着我们展开这段流程的各个部分，

我们知道，在逐步拆解这一评估过程时，持续的记录对于告诉我们下一步该如何操作至关重要。当我们获得某个子表达式的值时，需要依靠它来完成流程的其余部分。这里有三个输入。作为输出，我们将把表达式的值放入 Val 寄存器中。

我们知道，在逐步拆解这一评估过程时，持续的记录对于告诉我们下一步该如何操作至关重要。当我们获得某个子表达式的值时，需要依靠它来完成流程的其余部分。这里有三个输入。作为输出，我们将把表达式的值放入 Val 寄存器中。

就写入内容而言，我们假设对于有效的分派来说，除了 continue 之外的所有部分都会被写入，尽管这并不总是成立。但由于我们需要处理各种表达式，我们必须确保安全性。

就写入内容而言，我们假设对于有效的分派来说，除了 continue 之外的所有部分都会被写入，尽管这并不总是成立。但由于我们需要处理各种表达式，我们必须确保安全性。

dealt with we need to be safe about making that assumption and finally what about the stack we expect it to be unchanged and we remind you that doesn't mean we won't use the stack it simply says when we come into a call to a valid dispatch the stack will be in some form and when we finish at the continue point with an expression value in Val we expect the stack to be back into exactly that same form.

处理完这些之后，我们需要安全地做出这个假设。最后，关于栈，我们期望它保持不变，我们提醒你，这并不意味着我们不会使用栈，它只是说当我们进入一个对 eval-dispatch 的调用时，栈将处于某种形式，当我们完成并在 continue 点处得到 Val 中的表达式值时，我们期望栈恢复到完全相同的状态。

so what does the register machine code for a valid dispatch look like well it's just a big dispatch it's got a sequence of tests and branches and

那么 eval-dispatch 的寄存器机器代码是什么样的呢？它只是一个大的分派，它有一系列的测试和分支，并且

got a sequence of tests and branches and remember what that does the very first expression, for example, uses a primitive procedure called self evaluating again. We're just burying some abstractions here.

有一系列的测试和分支，记住那做什么。例如，第一个表达式使用一个称为 self-evaluating? 的原语过程。我们在这里只是埋藏了一些抽象。

It uses that procedure that operator to look at the expression we held in the exp register and decide if in fact it's true if this expression is self evaluating. It's going to set a bit on the condition register which means the next instruction, the branch instruction, will jump to that label to that point if it's not true. The condition bit does not get set and the

它使用那个过程（那个操作符）来查看我们保存在 exp 寄存器中的表达式，并判断它是否真的是自求值的。如果这个表达式是自求值的，它将在条件寄存器上设置一个位，这意味着下一条指令，即分支指令，如果不为真，将跳转到那个标签。条件位没有被设置，并且

condition bit does not get set and the sequencer immediately goes on to the next place looking at the next test then of course we'll have a whole sequence of these tests dispatching on the type of the expression off to some piece of the register machine to do the work.

条件位没有被设置，序列器立即继续到下一个位置，查看下一个测试，然后当然我们将有一系列这样的测试，根据表达式的类型分派到寄存器机器的某个部分去做工作。

this of course looks just exactly like the big cond we saw an earlier of valves dispatching on type at the end of all of this we'll have a fail-safe a go-to that jumps to some piece of the code that handles the fact that we've given an expression it does not know how to deal

这当然看起来就像我们之前看到的 eval 中的大 cond 一样，根据类型进行分派。在这一切的末尾，我们将有一个故障安全，一个 go-to，跳转到处理我们给出一个它不知道如何处理的表达式的代码片段，

expression it does not know how to deal with, although we haven't shown it here, and it's certainly in the textbook. We also know the order in which we need to test for the different kinds of expressions. We're going to first look at the primitives, and then we'll move on to the special forms, then we'll check for an application, and after that we'll go to the failsafe.

一个它不知道如何处理的表达式，尽管我们这里没有显示，但教科书里肯定有。我们也知道我们需要测试不同类型表达式的顺序。我们将首先查看原语，然后转向特殊形式，然后检查应用，之后我们将进入故障安全。

But that order is important in terms of how we decide where to dispatch. Okay, now let's look at some of these eval helpers. Notice first of all that they use the same contract as a valid dispatch and

但这个顺序对于决定我们如何分派很重要。好的，现在让我们看一些 eval 辅助函数。首先注意它们使用与 eval-dispatch 相同的契约，并且

same contract as a valid dispatch and that means that we can easily see how to build these. In particular, we know that the exp and env register hold the expression in the environment. We also know that continue holds the return point, and we know what we want is out, but we want the value assent put into val, and then we want to head to the continue register, making sure the stack stays the way it was.

与 eval-dispatch 相同的契约，这意味着我们可以很容易地看到如何构建这些。特别是，我们知道 exp 和 env 寄存器持有表达式和环境。我们也知道 continue 持有返回点，我们知道我们想要的是值，但我们想要将值放入 val，然后我们想要前往 continue 寄存器，确保栈保持原样。

Also notice that when we dispatch to here from a value, we didn't use the stack. We didn't have to save away something that says come back to eval when you've got.

还要注意，当我们从 eval 分派到这里时，我们没有使用栈。我们不必保存一些东西，说当你得到答案时回到 eval。

says come back to eval when you've got the answer because we're assuming that each one of these helpers is going to directly return the value to the continue register there's that nice notion of saving the stack space okay

说当你得到答案时回到 eval，因为我们假设这些辅助函数中的每一个都将直接返回 continue 寄存器中的值，这是节省栈空间的好方法。好的，

let's look at a few of these to see how we can do it and we'll start with the easiest ones for example suppose the expressions just a number a self evaluating thing what we know what to do we simply take what's in the exp register that pointer to that element itself we move a copy of it into Val we now have the expressions value in Val

让我们看几个这样的例子，看看我们如何做到这一点，我们将从最简单的开始。例如，假设表达式只是一个数字，一个自求值的东西，我们知道该怎么做。我们只需取 exp 寄存器中的内容，即指向该元素本身的指针，我们将它的副本移入 Val，现在我们就在 Val 中有了表达式的值。

now have the expressions value in Val and what is the rest of the contracts say to do says go to wherever continue points do return to the place that asked for this value and we satisfied the contract stack is in the same state answers in Val and other registers may or may not have been written but we don't care if the expression is a variable a symbol well we'll just manipulate the environment will use that primitive procedure to get the thing out of the environment again putting the value in Val or rather if you like a pointer to whatever the value is in

现在，表达式的值已经在 Val 中，而契约的其余部分要求做什么？它说，转到 continue 指向的任何地方，返回到请求该值的位置，并且我们满足了契约：栈处于相同状态，答案在 Val 中，其他寄存器可能被写入也可能没有，但我们不关心。如果表达式是变量（一个符号），那么我们将操作环境，使用那个基本过程从环境中取出东西，将值放入 Val，或者更确切地说，如果你愿意，放入一个指向该值（无论它是什么）的指针。

Pointer to whatever the value is in valve, since it may itself be tree structure again. We can go straight to the continue point because we don't have to do any use of the stack. In fact, we're saving the use of the stack, and we satisfied the contract if we get us first.

指向 Val 中值的指针，因为它本身可能又是树结构。我们可以直接转到 continue 点，因为不必使用栈。事实上，我们节省了栈的使用，并且如果我们先这样做，就满足了契约。

Special form a lambda, we need to do a little more work. In particular, if we're evaluating a lambda expression, notice we're evaluating not applying. If we're evaluating a lambda expression, we just want to create a procedure, but the procedure needs to wrap several things together. So we'll

对于特殊形式 lambda，我们需要做更多工作。特别是，如果我们在求值一个 lambda 表达式，注意我们是在求值而不是应用。如果我们在求值一个 lambda 表达式，我们只想创建一个过程，但该过程需要将几样东西包装在一起。所以我们将

wrap several things together so we'll use our selectors our built in selectors are primitive selectors to get out the pieces first thing we'll do is get out the parameters of the lambda from that thing that's pointed to him from the exp register well temporarily stick that in on it because we need a place to hold on to it we can then go off and get the body of the lambda and stick that in exp notice the order having held on to the parameters we're safe now in clobbering what was in the X register because we're no longer going to need it we've

将几样东西包装在一起，所以我们将使用我们的选择器（内置的选择器是基本选择器）来取出各个部分。我们要做的第一件事是从 exp 寄存器指向的那个东西中取出 lambda 的参数；暂时将它放在 on 中，因为我们需要一个地方来保存它。然后我们可以去获取 lambda 的主体，并将其放入 exp。注意顺序：既然我们已经保存了参数，现在覆盖 X 寄存器中的内容就是安全的，因为我们不再需要它了。我们已经

No longer going to need it. We've replaced the X register with just the body of the procedure. Finally, we can actually create the procedure. What does that say to do? Use the primitive constructor, the thing we're assuming they're syntactically gluing together.

不再需要它了。我们已经用过程的主体替换了 X 寄存器。最后，我们实际上可以创建过程了。那要求做什么？使用基本构造函数，我们假设它在语法上将东西粘合在一起。

The parameters as a list or tree structure, the body also as a list or tree structure, and of course the environment, since we want to attach that as well.

参数作为列表或树结构，主体也作为列表或树结构，当然还有环境，因为我们也要附加它。

And whatever is returned by make procedure, which we know is just some other tree structure or list structure sitting in the heap, we put a pointer to it.

而 make procedure 返回的任何东西，我们知道它只是堆中的某个其他树结构或列表结构，我们将一个指针指向它。

sitting in the heap we put a pointer to that thing in a Val Y because our contract says we want the result in Val and having done that we can go straight to continue again notice no manipulation of the stack no wasted space and we're straight to where we want to be so

在堆中，我们将指向那个东西的指针放入 Val，因为我们的契约要求结果在 Val 中，完成后我们可以直接转到 continue。注意没有操作栈，没有浪费空间，我们直接到达我们想去的地方。所以

here's just a recap of that in words as we said self evaluating just puts the expression itself as the return value in Val a variable uses the abstract operation to get the thing out from the environment and for a lambda we know what we want to do we want to make a

这里只是用文字回顾一下：正如我们所说，自求值表达式只是将表达式本身作为返回值放入 Val；变量使用抽象操作从环境中取出东西；对于 lambda，我们知道我们想做什么：我们想从中创建一个过程，所以我们简单地将各部分粘合在一起，暂时使用 exp 和 on 来存储东西，并以正确的顺序进行，这样我们就不会在过程中丢失信息。

What we want to do, we want to make a procedure out of this, so we simply glue the pieces together temporarily using exp and on AF to store things and doing it in the right order so we don't lose information along the way.

我们想做什么，我们想从中创建一个过程，所以我们简单地将各部分粘合在一起，暂时使用 exp 和 on 来存储东西，并以正确的顺序进行，这样我们就不会在过程中丢失信息。

So what have we done? We've basically just translated the pieces for simple evaluation, or rather evaluation of simple expressions, into register machine manipulation. The value dispatches off based on the test of the type, and each one of these simple pieces simply constructs up a new return value and goes to the point with that value in.

那么我们做了什么？我们基本上只是将简单求值（或者说简单表达式的求值）的各个部分翻译成了寄存器机器操作。值调度基于类型测试进行分派，而这些简单部分中的每一个都只是构造一个新的返回值，并带着该值转到那个点。

and goes to the point with that value in the right spot. Now let's look at a more complicated evaluation. Suppose the expression we're trying to evaluate is a definition. We know generally what we want to do: we need to get out the variable part of the definition, the name, and we need to get the value of the expression that is the value part of the definition. Then we need to bind them together in the environment.

并带着值在正确位置转到那个点。现在让我们看一个更复杂的求值。假设我们试图求值的表达式是一个定义。我们大致知道我们想做什么：我们需要取出定义的变量部分（即名字），并且我们需要得到作为定义的值部分的表达式的值。然后我们需要在环境中将它们绑定在一起。

Now let's look at how we would do this. Well, the first part is easy: to get the variable out, we just use that abstract operation on that tree structure to go.

现在让我们看看如何做到这一点。嗯，第一部分很容易：要取出变量，我们只需使用那个抽象操作在那个树结构上进行操作，以进入 X 指向的树中，并拉出对应于实际变量定义（或者说我们将用来赋值给值的名字）的那一块。

operation on that tree structure to go into the tree pointed to by X and pull out the piece that corresponds to the actual definition of the variable or rather the name that we're going to use to assign of value to and notice again because of that abstract type there we don't know whether that's in the second place or somewhere else it will do the right thing with the tree structure temporarily let's stuff side and uh nav because we're going to have to hold on to that while we go off and do other things so there's the easy part what

操作在那个树结构上进行，进入 X 指向的树中，并拉出对应于实际变量定义（或者说我们将用来赋值给值的名字）的那一块。再次注意，由于抽象类型，我们不知道它是在第二个位置还是其他地方，它将正确处理树结构。暂时让我们把它塞进 side 和 nav，因为当我们去做其他事情时，我们必须保存它。所以这是容易的部分。

things so there's the easy part what

所以这是容易的部分。

things so there's the easy part what else do we need else do we need else do we need oh we need the value of the other expression the value that's going to be bound to this name but that means we need to evaluate it and AHA that says we've got to both get that part of the definition into the exp register that's the first line in blue we take what's currently in exp pull some pieces off of that and stick that back into exp notice we're assuming we can do this safely and in fact we can because we're no longer going to need the expression that was in the XP we've done that because we've

所以这是容易的部分。我们还需要什么？哦，我们需要另一个表达式的值，即将要绑定到这个名字上的值。但那意味着我们需要求值它，而啊哈，那说我们必须把定义的那部分放入 exp 寄存器——那是第一行蓝色部分。我们取当前在 exp 中的内容，从中拉出一些部分，然后将其放回 exp。注意我们假设我们可以安全地这样做，事实上我们可以，因为我们不再需要之前在 exp 中的表达式了。我们这样做是因为我们已经

the XP we've done that because we've saved away the other part we needed the variable name up in on a.m. so we're safe and doing this the next thing we need to do though is we need to get that expressions value and that says we've got to go to a valve dispatch we've got to do this cycle one more time and we know what the contract says for a valid dispatch for valid dispatch we need an expression in exp we need an environment in env ah that's okay we've left the same environment there I mean that's exactly right we want the value this

我们已经保存了需要的另一部分（变量名）在 on 中，所以这样做是安全的。接下来我们需要做的是获取那个表达式的值，那说我们必须进入值调度，我们必须再经历一次这个循环。我们知道值调度的契约要求：我们需要在 exp 中有一个表达式，在 env 中有一个环境。啊，那没问题，我们保留了相同的环境。我的意思是，那正是我们想要的：我们想要这个值。

exactly right we want the value this expression with respect to the overall environment in which we're doing the define it's a choice of our language what else do we need we need a pointer in the continue register as to where to go when when I get that value and then oh we need to worry about the stack so notice what we've done we put a new expression in X first blue line we put a new label and continue that's today so we're to go back to when I want to come back with the value and we're about to head off to a valve dispatch notice what would happen if we went to there now

完全正确，我们希望这个表达式的值相对于我们进行定义的整体环境而言。这是对我们语言的一种选择。我们还需要什么？我们需要在 continue 寄存器中有一个指针，指向当我们得到那个值后该去哪里。然后，哦，我们还需要担心栈。注意我们做了什么：我们先把新表达式放入 X（第一条蓝线），我们把一个新标签放入 continue，那是今天的，所以当我们想要带着值返回时，我们要回到那里，而且我们即将前往 eval-dispatch。注意，如果我们现在去那里会发生什么。

would happen if we went to there now. eval-dispatch would get the value of that expression whatever it is and by contract when it came back to F definition one the next spot in this code the value of that expression would be sitting in Val exactly where we want.

如果我们现在去那里会发生什么。eval-dispatch 会得到那个表达式的值，无论它是什么，按照约定，当它回到 F-definition-one 时，在这段代码中的下一个位置，那个表达式的值就会正好在 Val 中，正是我们想要的位置。

Also notice the form setting up some import registers putting a label in to continue going to a place and coming back to the neck point immediately below where we've got the value we want. Ah, but notice a problem: if we just did that, we can't guarantee that the expression we're.

还要注意，这种形式设置了一些输入寄存器，把一个标签放入 continue，去到一个地方，然后回到紧接在我们得到所需值的位置下方的那个点。啊，但注意一个问题：如果我们只是那样做，我们无法保证我们正在求值的表达式不会覆盖我们寄存器中已有的其他东西。特别是，我们将需要在 F 中的变量名，而且我们不知道那个应用本身是否不会创建一个新环境。因此，我们必须做以下事情。

guarantee that the expression we're evaluating won't overwrite some of the other things that we have in our registers. In particular, we're going to need the variable name in F, and we don't know that that application isn't itself something that's going to create a new environment. Therefore, we have to do the following.

保证我们正在求值的表达式不会覆盖我们寄存器中已有的其他东西。特别是，我们将需要在 F 中的变量名，而且我们不知道那个应用本身是否不会创建一个新环境。因此，我们必须做以下事情。

So before we set up the contract, that is, before we set up the registers that our input registers to a valid dispatch, we need to save away the state of the world. We save F because we know we're going to need it. We save N because we don't know that.

所以，在我们建立约定之前，也就是说，在我们设置好作为 eval-dispatch 输入寄存器的那些寄存器之前，我们需要保存世界的状态。我们保存 F，因为我们知道我们会需要它。我们保存 N，因为我们不知道。

we save n because we don't know that somebody else won't use a new environment as part of the process and we save continue because a game we're about to clobber we're about to change it to come back to here and we need to keep track of who called this particular evaluation and having done that then we can safely go off with the dispatch now notice once we've gone to a valve dispatch by contract when we come back to F definition one we know that the resulting value is in Val the stack is back to the state it was just before we went there and therefore we can restore

我们保存 N，因为我们不知道别人不会在过程中使用新环境，而且我们保存 continue，因为我们要覆盖它，我们要把它改成回到这里，而且我们需要跟踪是谁调用了这个特定的求值。做完这些之后，我们就可以安全地去 eval-dispatch 了。现在注意，一旦我们去了 eval-dispatch，按照约定，当我们回到 F-definition-one 时，我们知道结果值在 Val 中，栈回到了我们刚去那里之前的状态，因此我们可以恢复。

Went there and therefore we can restore the state of the stack that is move things back off the stack into the registers we wanted and again notice they're done in the opposite order to which they were saved because it's a last-in first-out kind of structure.

去了那里，因此我们可以恢复栈的状态，也就是说，把东西从栈中移回我们想要的寄存器。再次注意，它们是以与保存时相反的顺序完成的，因为它是一种后进先出的结构。

Having gotten here we can then actually do the definition that is go off and take the name, the value, and the environment and create a new binding of that name and that value in that environment.

到了这里，我们就可以实际执行定义了，也就是说，去取名字、值和环境，并在该环境中创建该名字和该值的新绑定。

Having done all of that we then make a choice we need to put some return value in Val and here we could

做完所有这些之后，我们做一个选择：我们需要在 Val 中放一些返回值，在这里我们可以。

Return value in Val and here we could have anything we choose to put in just the constant. Okay, we could have chosen to put in the value that we actually created, we could have put anything else in; it's our choice in terms of what is returned, since basically a define is around for the side-effect, not for the actual value being returned.

在 Val 中放返回值，在这里我们可以放任何我们选择放入的常量。好的，我们可以选择放入我们实际创建的值，我们可以放入任何其他东西；这是我们对于返回什么的选择，因为基本上 define 是为了副作用而存在的，而不是为了实际返回的值。

And then, having done all of that, we can go off to register continue to whoever asked for this when we start it. So let's step back from this and recap some of the bigger issues first: why did we save away on FM...

然后，做完所有这些之后，我们可以去 continue 寄存器，去找当我们启动它时谁请求了这个。所以让我们退一步，回顾一些更大的问题：首先，为什么我们要在 F、M 上保存……

issues first why did we save away on FM and continue well we answered it basically we know that they're going to need those values after the recursive call and we don't know that they aren't going to be overwritten by Val dispatch they may not be we may have wasted some space here but we can't guarantee it and the contract for Val dispatch they could be written since I need the values when I come back I better save them away second why did we use exp in the recursive call well again we're relying on the contract from a valid dispatch it expects the expression to be

问题首先，为什么我们要在 F、M 和 continue 上保存？我们基本上已经回答了：我们知道在递归调用之后我们会需要那些值，而且我们不知道它们不会被 eval-dispatch 覆盖。它们可能不会被覆盖，我们可能在这里浪费了一些空间，但我们不能保证。而且对于 eval-dispatch 的约定，它们可能被写入，既然我回来时需要这些值，我最好保存它们。第二，为什么我们在递归调用中使用 exp？我们再次依赖于 eval-dispatch 的约定：它期望要计算的表达式在 exp 中。所以我们需要把定义的那部分，即表达式部分，移到 exp 中，以便我们保证当我们回来时正确的答案在 Val 中。这就是 eval-dispatch 所期望的。

dispatch it expects the expression to be evaluated in exp so we need to move that part of the definition that expression part into exp so that we can guarantee when we come back the right answer is in Val that's what eval-dispatch is expecting

dispatch 期望要计算的表达式在 exp 中，所以我们需要把定义的那部分，即表达式部分，移到 exp 中，以便我们保证当我们回来时正确的答案在 Val 中。这就是 eval-dispatch 所期望的。

now we also know that a valve dispatch expects env to be set up it should have an environment in there but we didn't do an explicit assignment here and as we said that's because the expression part of the define is evaluated in the same environment as the define itself hadn't been changed we don't need to change it

现在我们也知道 eval-dispatch 期望 env 被设置好，它应该有一个环境在里面，但我们这里没有做显式赋值。正如我们所说，那是因为 define 的表达式部分在与 define 本身相同的环境中求值，而环境没有被改变，我们不需要改变它。

been changed we don't need to change it it's just sitting there and finally why did I use unev in line one in that first line the answer is it's just temporary storage I could have used any other register I could have decided to create a special register just to hold these things but that's kind of wasteful

没有被改变，我们不需要改变它，它就在那里。最后，为什么我在第一行使用 unev？答案是它只是临时存储。我可以使用任何其他寄存器，我可以决定创建一个特殊的寄存器来保存这些东西，但那有点浪费。

I need to however move that piece of the expression the variable name into some place so that I can take the rest of the expression and put it into exp I do need temporary storage the choice of which register is really up to me notice that

然而，我需要把表达式的那部分，即变量名，移到某个地方，以便我可以把表达式的其余部分放入 exp。我确实需要临时存储，选择哪个寄存器真的取决于我。注意。

register is really up to me notice that for the expressions dealt with to this point we didn't really need to worry about the stack much. The only place was in the definition part, and even there it was a simple use of the stack. More particularly, whenever we dispatched off to one of these expressions, we could rely on whatever point in the continue register that asks for that value to simply be the same point we could return from, saving any stack use and simply going directly to the point when we've got the right expression done.

寄存器真的取决于我。注意，对于到目前为止处理的表达式，我们实际上不需要太担心栈。唯一的地方是在定义部分，即使在那里也是简单使用栈。更具体地说，每当我们分派到这些表达式之一时，我们可以依赖于 continue 寄存器中请求该值的那个点，它就是我们能返回的同一个点，从而避免任何栈使用，并直接在我们完成正确表达式时到达那个点。

got the right expression done now we can

完成正确表达式后，现在我们可以。

Got the right expression done now we can move on to the heart of the evaluator, which is dealing with recursive calls and trying to optimize them to be tail-recursive whenever possible. Let's start by looking at ifs again.

完成正确表达式后，现在我们可以进入求值器的核心，即处理递归调用，并尽可能优化它们为尾递归。让我们先再看看 if。

We know what we should see. We know that from our normal meta-circular evaluator we need to use a selector to get out the predicate. We then need to evaluate that expression and, depending on the value returned — whether true or false — we need to either evaluate the consequent or the alternative. So let's see what we have to do to make this work.

我们知道应该看到什么。我们知道，从我们正常的元循环求值器出发，需要使用选择器取出谓词。然后我们需要对该表达式求值，并根据返回的值——无论是真还是假——我们需要求值结果分支或替代分支。所以让我们看看需要做什么才能使这工作。

See what we have to do to make this happen? Well, we know the exp register holds a tree structure that has a big if expression in it. So in principle, we should just go in and pull out the predicate part of that if expression using something that walks the tree and gets that piece, and stick that into e^x.

看看我们需要做什么才能实现这一点？嗯，我们知道 exp 寄存器保存着一个树结构，其中包含一个大的 if 表达式。所以原则上，我们应该直接进入其中，使用某种遍历树并获取该部分的方法，取出该 if 表达式的谓词部分，并将其放入 e^x。

That's the second line in blue—that's allowing us to basically put the predicate expression in exp. We could put a label and continue that says come back to here when you're done.

那是蓝色中的第二行——它允许我们基本上将谓词表达式放入 exp。我们可以放置一个标签并继续，说完成后回到这里。

And then we could head off to a valve dispatch; in fact, that's exactly what we

然后我们可以前往一个 valve 调度；事实上，这正是我们

dispatch in fact that's exactly what we want because a valve dispatch will evaluate that expression with respect to ah the same environment we're in now because we haven't changed that and when we're done we'll come back to F decide the label we put in with the value of the predicate sitting in valve that would allow us to then carry on with the rest of the process as with the last case however we have to be careful we know the contract for a valve dispatcher says expression in X environment and M returned point and continue all of which we've done but we have to worry about

调度，事实上这正是我们想要的，因为 valve 调度将相对于我们当前所处的相同环境来求值该表达式，因为我们没有改变环境，当我们完成后，我们将带着谓词的值回到我们放置的标签 F decide，这将允许我们继续处理其余过程，就像上一个案例一样。然而，我们必须小心，我们知道 valve 调度器的契约说表达式在 X 中，环境在 M 中，返回点和继续，所有这些我们都做了，但我们必须担心

我们完成了一部分，但必须关注堆栈的问题。特别是，记住我们最初是用exp寄存器保存整个if表达式的。当我们带着谓词的值回来时，仍然需要能够获取到consequent或alternative的句柄，以便执行正确的操作，所以最好把exp表达式或exp寄存器中的指针保存起来，这样我们还能保留它。

我们完成了一部分，但必须关注堆栈的问题。特别是，记住我们最初是用 exp 寄存器保存整个 if 表达式的。当我们带着谓词的值回来时，仍然需要能够获取到 consequent 或 alternative 的句柄，以便执行正确的操作，所以最好把 exp 表达式或 exp 寄存器中的指针保存起来，这样我们还能保留它。

同样地，我们无法保证在递归求值过程中环境不会被改变，所以最好也把环境保存起来。当然，无论谁来处理，这都是必要的。

同样地，我们无法保证在递归求值过程中环境不会被改变，所以最好也把环境保存起来。当然，无论谁来处理，这都是必要的。

save that away and of course whoever asked for the value of this if expression still wants that answer returned that was initially sitting and continue so we need to save that away.

保存起来，当然，无论谁要求这个 if 表达式的值，仍然希望返回那个答案，那个答案最初是在 continue 中，所以我们需要保存它。

said slightly differently we have to obey the contract for Val dispatch which says any register that holds a value I might need upon return a better save away because I can't guarantee it won't get clobbered having saved those away we can now do the dispatch in blue when we come back we can just restore the stack back to where we wanted it to be and at.

换句话说，我们必须遵守 Val 调度的契约，它说任何保存着我返回时可能需要的值的寄存器，最好保存起来，因为我不能保证它不会被破坏。保存了这些之后，我们现在可以执行蓝色的调度，当我们回来时，我们可以将堆栈恢复到我们想要的位置，并且

back to where we wanted it to be and at the end of that third of the last set of red expressions or read read instructions rather we know where we are we have the value of the predicate sitting in Val the stacks back to its normal state and we can now carry on and

回到我们想要的位置，在最后一组红色表达式或读取指令的第三部分结束时，我们知道我们在哪里，我们有了谓词的值在 Val 中，堆栈恢复到正常状态，我们现在可以继续，并且

what does carry on me well it says we can now execute a branch we can make a decision about which thing to do we take what's in valve which we know is the value of the predicate and we check to see if it's true we set a condition bit if it is if in fact that condition bit is on then at the next instruction

继续意味着什么？它说我们现在可以执行一个分支，我们可以决定做哪件事，我们取 Val 中的内容，我们知道那是谓词的值，我们检查它是否为真，我们设置一个条件位，如果是，事实上如果条件位开启，那么在下一个指令

is on then at the next instruction program counter will cause us to jump to F if consequent down to that point in the code.

开启，那么在下一个指令，程序计数器将导致我们跳转到 F if consequent，向下到代码中的那个点。

if on the other hand the value is not true the condition bit will not be said and the sequencer will then drop down to the next instruction which we've labeled as F if alternative just to put a value or a label there so we can see it which means we're going to go straight to evaluating the alternative in either case we do basically the same thing we walk the tree pulling out the part of the expression that is held in the exp.

另一方面，如果值不为真，条件位将不会被设置，序列器将下降到下一个指令，我们将其标记为 F if alternative，只是在那里放置一个值或标签以便我们看到，这意味着我们将直接去求值替代分支。在任何一种情况下，我们基本上做同样的事情，我们遍历树，取出 exp 中保存的表达式的部分。

The expression that is held in the exp register and putting it back into exp in one case we get the consequent part out in the other case we get the alternative part out but we're simply putting a new expression in exp notice what else we have the environments back to the environment we started with.

exp 寄存器中保存的表达式，并将其放回 exp，在一种情况下我们取出 consequent 部分，在另一种情况下我们取出 alternative 部分，但我们只是简单地将一个新表达式放入 exp。注意，我们还有什么？环境回到了我们开始时的环境。

The continue register holds the pointer to the place that asked for this that is the place we were at when we tried to get an if expression evaluated so in both cases we can now go straight to eval-dispatch and there's that nice tail.

continue 寄存器保存着指向请求此求值的位置的指针，也就是我们尝试求值 if 表达式时所处的位置，所以在两种情况下，我们现在都可以直接前往 eval-dispatch，并且那里有很好的尾递归。

eval-dispatch and there's that nice tail recursion because what does this say it says whatever answer you get out for evaluating either the alternative or the consequent whichever branch them down that answer is exactly the answer I want for the entire expression. There's no sense coming back to this part of the code just to pass it along just to restore the continue register if you like, so I can go straight to the place I want, no wasted space on the stack. And there you have it.

eval-dispatch 和那里有很好的尾递归，因为这意味着什么？它说，无论你从求值 alternative 或 consequent 中得到什么答案，无论哪个分支，那个答案正是我想要的整个表达式的答案。没有必要回到代码的这一部分只是为了传递它，只是为了恢复 continue 寄存器，如果你愿意，所以我可以直接去我想要的地方，不在堆栈上浪费空间。就是这样。

And if we save away some state, set up a call to a Val to get the predicate, come back, restore.

如果我们保存一些状态，设置一个对 Val 的调用来获取谓词，回来，恢复。

To get the predicate come back, restore the state and then check to see which branch we want to take. So let's just summarize these key points.

获取谓词，回来，恢复状态，然后检查我们想要走哪个分支。所以让我们总结这些关键点。

Notice that for the predicate part of an if, we do a normal recursive call to a value. That is, we save some state on the stack and return, including a return pointer, do the work, and come back to that point.

注意，对于 if 的谓词部分，我们进行正常的递归调用以获取值。也就是说，我们在堆栈上保存一些状态并返回，包括返回指针，做工作，然后回到那个点。

On the other hand, for both the consequent and the alternative, we use tail call optimization. There are no saves and restores. We don't have to save something, do the evaluation, and come back.

另一方面，对于 consequent 和 alternative，我们使用尾调用优化。没有保存和恢复。我们不必保存某些东西，进行求值，然后回来。

do the evaluation and come back and restore just a return we go straight to the place we want it to and indeed this is exactly what makes the loop in s fact iterative the fact that that if says the value of whatever that if expression is is in fact exactly the value I want back allows me to have this happen to drive

进行求值，然后回来并恢复，只是返回，我们直接去我们想要的地方，确实，这正是使 s fact 中的循环成为迭代的原因，即 if 说那个 if 表达式的值正是我想要返回的值，这允许我发生这种情况来驱动

this point home here's the code we would use without the tail recursive call it says basically having done the evaluation of the predicate we come back to the if alternative and here's what we need to do we save away the continue register that's the person

为了强调这一点，这里是我们没有尾递归调用时会使用的代码，它基本上说，在完成谓词的求值后，我们回到 if alternative，这里我们需要做的是保存 continue 寄存器，那是请求整个 if 值的人

The continue register that's the person who asked for the value of the whole if itself, we put a new label into the continue register, put the alternative into exp, just what we wanted to go off to eval-dispatch as before. When we come back, we have the answer in Val.

continue 寄存器，那是请求整个 if 值的人，我们将一个新标签放入 continue 寄存器，将 alternative 放入 exp，就像之前我们想要去 eval-dispatch 一样。当我们回来时，我们在 Val 中有答案。

We then restore continue, just so we can go to that point. There's that useless use of the stack, that extra piece of information that we'd have to use up on the stack. Of course, we do the same thing with the consequent version of this as well, by not wasting space on the stack.

然后我们恢复继续，以便能到达那个点。这里对栈的使用是无用的，那部分额外信息我们不得不占用在栈上。当然，对于这个的后续版本我们也做同样的事情，即不在栈上浪费空间。

Well, by not wasting space on the stack by using this tail call optimization, we create a structure in which iterative things behave as iterative things with no extra use of the stack. And now we can see very nicely the difference between a normal recursive call and a tail recursive call.

通过使用这种尾调用优化，我们不在栈上浪费空间，从而创建了一种结构，使得迭代的事物表现得像迭代的事物，而不额外使用栈。现在我们可以很清楚地看到普通递归调用和尾递归调用之间的区别。

Having seen one example of a place where tail recursion helps, let's now move on to the second place where it's going to help us with sequences—things that begin with 'begin', for example. As before, this is a helper for 'valid', and it has the same contract as 'valid': it dispatches, and it expects an expression in exp.

在看到了一个尾递归有帮助的例子之后，让我们继续讨论第二个它将对序列有帮助的地方——例如，以“begin”开头的事物。和之前一样，这是“valid”的一个辅助函数，并且它与“valid”有相同的约定：它进行分派，并期望在exp中有一个表达式。

dispatch it expects an expression in exp. dispatch it expects an expression in exp. it expects an environment in M expects a continue point and continue and it's going to come back to there with an answer in Val here.

调度它期望在exp中有一个表达式。调度它期望在exp中有一个表达式。它期望在M中有一个环境，期望一个继续点，并且继续，它将带着Val中的答案返回到那里。

however we're going to do things slightly differently for a reason that will be clearer shortly. in particular when we get to this point as a dispatch something that's a sequence with a begin we're going to save the continue register on the stack move all of the other parts of the expression that is all of the causes of clauses themselves other than the label begin.

然而，我们将以略有不同的方式处理事情，原因稍后会更加清楚。特别是，当我们到达这一点时，作为分派某个带有 begin 的序列，我们将把 continue 寄存器保存在栈上，将表达式的所有其他部分（即除了标签 begin 之外的所有子句本身）移入一个 F，然后我们将进入一个 F，然后我们将进入一个 F，然后我们将进入一个特殊的东西，称为 F sequence F，到一个特殊的东西，称为 F sequence F，到一个特殊的东西，称为 F sequence F sequence 也有一个契约，它 sequence 也有一个契约，它 sequence 也有一个契约，它将被某些东西使用，将被某些东西使用，将被某些东西使用，被 begin 和 apply lambda 体使用，这些 begin 和 apply lambda 体也包含一系列表达式，也包含一系列表达式，也包含一系列表达式，在它们内部，这里是契约，这里是契约，这里是契约，对于 F sequence，它将期望一个，对于 F sequence，它将期望一个，对于 F sequence，它将期望一个表达式列表，树结构作为表达式列表，树结构作为表达式列表，树结构如前所述，如前所述，如前所述，在这种情况下，坐在和导航集合中，在这种情况下，坐在和导航集合中，在这种情况下，坐在和导航集合中，尚未被评估的事物集合，尚未被评估的事物集合，尚未被评估的事物集合，它将有一个环境在 em 中，就像之前一样，并且在这个栈上，它将假设

themselves other than the label begin into an F and then we're going to go off into an F and then we're going to go off into an F and then we're going to go off to a special thing called F sequence F to a special thing called F sequence F to a special thing called F sequence F sequence also has a contract it's sequence also has a contract it's sequence also has a contract it's something that's going to be used by something that's going to be used by something that's going to be used by begins and by applies lambda bodies that begins and by applies lambda bodies that begins and by applies lambda bodies that also have a sequence of expressions also have a sequence of expressions also have a sequence of expressions inside of them and here's the contract inside of them and here's the contract inside of them and here's the contract for F sequence it's going to expect a for F sequence it's going to expect a for F sequence it's going to expect a list of expressions tree structure as list of expressions tree structure as list of expressions tree structure as before before before in this case sitting and uh nav the set in this case sitting and uh nav the set in this case sitting and uh nav the set of things that have not yet been of things that have not yet been of things that have not yet been evaluated it's going to have an evaluated it's going to have an evaluated it's going to have an environment in em just as before and on environment in em just as before and on environment in em just as before and on this stack is going to assume that the

它们本身，除了标签 begin 之外，被移入一个 F，然后我们将进入一个 F，然后我们将进入一个 F，然后我们将进入一个特殊的东西，称为 F sequence F，到一个特殊的东西，称为 F sequence F，到一个特殊的东西，称为 F sequence F sequence 也有一个契约，它 sequence 也有一个契约，它 sequence 也有一个契约，它将被某些东西使用，将被某些东西使用，将被某些东西使用，被 begin 和 apply lambda 体使用，这些 begin 和 apply lambda 体也包含一系列表达式，也包含一系列表达式，也包含一系列表达式，在它们内部，这里是契约，这里是契约，这里是契约，对于 F sequence，它将期望一个，对于 F sequence，它将期望一个，对于 F sequence，它将期望一个表达式列表，树结构作为表达式列表，树结构作为表达式列表，树结构如前所述，如前所述，如前所述，在这种情况下，坐在和导航集合中，在这种情况下，坐在和导航集合中，在这种情况下，坐在和导航集合中，尚未被评估的事物集合，尚未被评估的事物集合，尚未被评估的事物集合，它将有一个环境在 em 中，就像之前一样，并且在这个栈上，它将假设

This stack is going to assume that the top value is the return point. So in other words, we're not going to keep this return point in continue; we're gonna leave it at the top of the stack, and we'll see why shortly. Given those inputs, it's going to do all of its work and return a value in Val as its output. That'll typically be the value of the last expression in the sequence. It's going to write everything because it's going to call, well, without doing any saving. When it's done though, we want the stack to be restored to the state it was at.

这个栈将假定栈顶的值是返回点。换句话说，我们不会把这个返回点保存在 continue 中；我们将把它留在栈顶，稍后我们会明白为什么。给定这些输入，它将完成所有工作并在 Val 中返回一个值作为输出。这通常是序列中最后一个表达式的值。它将写入所有内容，因为它将调用，嗯，不进行任何保存。但当它完成时，我们希望栈恢复到原来的状态。

restored to the state it was that is with the top value removed or popped and that means it will put it back to the state it was before we hit ever begin so here we go we now take the sequence of things sitting in on F and we take the first one and move it into exp what are we doing we're setting up to do an evaluation we want to evaluate each of these expressions and turns so we're setting up for the contract for Val we've moved an expression into exp we still have an environment in em and in general we could just go straight to the

恢复到原来的状态，即栈顶值被移除或弹出，这意味着它将恢复到我们进入 begin 之前的状态。所以现在我们取 F 上的序列，把第一个移到 exp 中。我们在做什么？我们正在为求值做准备。我们想要依次求值这些表达式，所以我们正在为 Val 的约定做准备。我们已经把一个表达式移入 exp，环境中仍然有 em，通常我们可以直接进入

general we could just go straight to the process we want to do so let's skip the next two lines. what do we have to do we need to save away anything we might need which includes everything in on F because those are the things we haven't yet evaluated and the environment because we're going to need it when we come back.

通常我们可以直接进入我们想要的过程，所以让我们跳过接下来的两行。我们需要做什么？我们需要保存任何可能需要的东西，包括 on F 中的所有内容，因为那些是我们尚未求值的表达式，以及环境，因为当我们回来时需要它。

we put a new label and continue and we go off to a Val dispatch that's very nice. it says when we come back to F sequence continue we've got the value the first expression in Val and we'll have everything else as before so we can restore the state of the stack.

我们放置一个新的标签并继续，然后我们前往 Val 分派，这非常好。它说当我们回到 F sequence continue 时，我们已经在 Val 中得到了第一个表达式的值，其他一切都和之前一样，所以我们可以恢复栈的状态。

so we can restore the state of the stack putting in the new of the environment back in M then the things we haven't done yet in on F we can then go on to all the remaining expressions in other words we moved the first one because we no longer need it and go back up to F sequence.

所以我们可以恢复栈的状态，将新的环境放回 M，然后将我们尚未完成的东西放回 on F，然后我们可以继续处理所有剩余的表达式，换句话说，我们移动了第一个，因为我们不再需要它，然后回到 F sequence。

so we basically create a little loop in which we take each expression in turn set up for the dispatch to a Val do the work restore the state and carry on so that gives us a little loop that basically walks down the expressions in order evaluating them what happens when

所以我们基本上创建了一个小循环，在其中我们依次取出每个表达式，为分派到 Val 做准备，完成工作，恢复状态，然后继续。这给了我们一个小循环，基本上按顺序遍历表达式并求值。当

order evaluating them what happens when we get to the last expression suppose in fact we now have the last expression loaded up into X as part of that first instruction we do the test to see is this the last one and if it is that branch is going to cause the program counter to change and we'll jump down to F sequence last expression Y well here we can handle things the way we did with if we can be tail recursive and in particular we can now restore continue remember we save that a way back up at the beginning of every n it would have

按顺序求值时，当我们到达最后一个表达式时会发生什么？假设我们现在已经把最后一个表达式加载到 X 中，作为第一条指令的一部分，我们进行测试以查看这是否是最后一个，如果是，那个分支将导致程序计数器改变，我们将跳转到 F sequence last expression Y。在这里，我们可以像处理 if 那样处理事情，我们可以进行尾递归，特别是我们现在可以恢复 continue，记住我们在每个 n 的开头就把它保存起来了。

the beginning of every n it would have been sitting on that stack and no matter how we use the stack and evaluating each of the expressions in this sequence we always got back to the same state with that thing sitting at the top of the stack.

每一次求值的开始，它都会一直位于栈顶，无论我们如何使用栈并求值这个序列中的每个表达式，我们总是回到相同的状态，那个东西就位于栈顶。

what do we do we put that thing back in to continue that was the pointer to the person who asked for this begin to be evaluated in the first place and having done that we can now go to a val dispatch.

我们该怎么办？我们将那个东西放回去以继续，那是指向最初请求求值这个 begin 的人的指针，完成之后，我们现在可以进入 val 分发。

so this again is tail recursive we put the last expression exp we've restored a pointer and to continue and now we've cleared the stack.

所以这又是尾递归，我们放入最后一个表达式 exp，我们恢复了指针并继续，现在我们已经清空了栈。

continue and now we've cleared the stack, we're not going to waste any time getting the value of the last expression, coming back here and then having to again restore continue in order to go back to the person who asked for it. We go straight to that point and now we see that sequences similarly take advantage of tail recursion on the last expression to avoid unnecessary use of the stack.

继续，现在我们已经清空了栈，我们不会浪费时间获取最后一个表达式的值，回到这里，然后再次恢复 continue 以回到请求它的人那里。我们直接到达那个点，现在我们看到序列同样利用最后一个表达式上的尾递归来避免不必要的栈使用。

So in fact, a recap: we've seen that tail call optimization on the last expression, that again we need so that loops like s factorial are iterative, not just the if.

所以事实上，回顾一下：我们已经看到对最后一个表达式的尾调用优化，我们再次需要它，以便像 s factorial 这样的循环是迭代的，而不仅仅是 if。

Factorial are iterative, not just the if but the loop itself, the recursive call will always be in fact an editor thing, or set another way.

Factorial 是迭代的，不仅仅是 if，而是循环本身，递归调用将始终是迭代的，或者换一种说法。

Since s fact has two expressions in its body, we can evaluate the first one, the display, then evaluate the second one, but make sure that we don't have to save anything on the stack for each one of those recursive calls. That makes the whole thing iterative.

由于 s fact 的主体中有两个表达式，我们可以先求值第一个表达式 display，然后求值第二个表达式，但要确保我们不必为每次递归调用在栈上保存任何东西。这使得整个过程是迭代的。

What else do we have? Well, we know that the evaluation of each expression puts the result in Val, but notice in the code we never seem to use Val. Well, that's okay because we know...

我们还有什么？嗯，我们知道每个表达式的求值将结果放入 Val，但注意在代码中我们似乎从未使用 Val。嗯，没关系，因为我们知道……

Use Val well that's okay because we know that those things are done basically for the side effect they don't have to be returned to anybody only the tail call to a Val will put the final result in Val itself that happens automatically and as a consequence that is the value returned for the value of this entire sequence of expressions everything else is just ignored we do it for the side effect mutation or define so why bother to have that return point sitting on the top of the stack and the answer is is essentially just an optimization hack we

使用 Val 没关系，因为我们知道这些事情基本上是为了副作用而做的，它们不必返回给任何人，只有对 Val 的尾调用会将最终结果放入 Val 本身，这自动发生，因此这就是整个表达式序列的值，其他一切都被忽略，我们为了副作用（如 mutation 或 define）而做。那么为什么要在栈顶保留那个返回点呢？答案基本上是一个优化技巧，我们……

essentially just an optimization hack we avoid having to save and restore every time around the loop we certainly could have done that we could have been more clean about always doing that safe and a restore each time we went around the loop so that we always have the stack in the same state when we enter the loop but it's kind of a nuisance as a pure performance optimization we can save that by simply doing the restore on the last expression we can't do the same thing a course with unev and environment because they're used inside the loop

本质上只是一个优化技巧，我们避免了每次循环时保存和恢复的麻烦。我们当然可以那样做，可以更干净地总是进行保存和恢复，这样每次进入循环时栈都处于相同状态，但那有点麻烦。作为纯粹的性能优化，我们可以通过只在最后一个表达式上执行恢复来节省这一点。对于 unev 和环境，我们当然不能做同样的事情，因为它们在循环内部被使用。

because they're used inside the loop and therefore we actually do have to do the saving and restoring as we walk around the loop there nonetheless we now see again how we can build an expression into our register machine for evaluation in this case something that deals with sequences and we can see how we can play this trick to make it very efficient okay what about the heart of a Val Val really comes down to doing an application that is taking an expression that's an application and reducing that to an evaluation of a new X the body of that procedure of that

因为它们在循环内部被使用，因此当我们循环时确实必须进行保存和恢复。尽管如此，我们现在再次看到如何将表达式构建到我们的寄存器机器中进行求值，在这种情况下是处理序列的东西，以及我们如何利用这个技巧使其非常高效。那么，Val 的核心是什么呢？Val 真正归结为执行一个应用，即取一个作为应用的表达式，并将其简化为对新表达式（即该过程的体）的求值，相对于新环境。

the body of that procedure of that application with respect to a new environment so what happens when our evaluator hits something that's an actual application let's sketch out the stages both talking about what parts of the register machine Khobar going to need and what they correspond to in terms of a normal eval so when we hit an application we're going to dispatch off to a helper for eval that actually says here's an application do the right pieces with it that will first get the value of the operator in terms of the normal

该过程的体，即该应用的体，相对于新环境。那么，当我们的求值器遇到一个实际的应用时会发生什么？让我们勾勒出各个阶段，既讨论寄存器机器需要哪些部分，也讨论它们在普通 eval 中对应什么。当我们遇到一个应用时，我们将分派到一个 eval 的辅助函数，该函数说：这里是一个应用，做正确的部分。首先，就普通求值器而言，我们会获取运算符的值。

Operator in terms of the normal evaluator. We know we'd get the operator part of the expression and do an eval on that. We'll have a corresponding piece of the register machine code that gets the value of the application operator. We're going to hang on to that obviously while we set it up.

就普通求值器而言，我们知道会获取表达式的运算符部分并对其进行 eval。我们将有相应的寄存器机器代码来获取应用运算符的值。显然，在设置时我们会保留它。

And in fact, we know we should be sticking that into proc in order to set up for the apply. We also need to get the values of the operands, the arguments. In terms of normal evaluation, we just map a little evaluator down each one of those expressions, walking through them and.

事实上，我们知道应该将其放入 proc 中以便为 apply 做准备。我们还需要获取操作数（即参数）的值。就普通求值而言，我们只是将一个小求值器映射到每个表达式上，遍历它们并。

expressions walking through them and creating a new list, a list of the argument values will have a corresponding part of the register machine that is a loop that walks through each of the pieces of the expression register, getting the values of the arguments.

遍历表达式并创建一个新列表，即参数值的列表。我们将有相应的寄存器机器部分，它是一个循环，遍历表达式寄存器的每个部分，获取参数的值。

Then, having got in a value for an operator and a set of argument values, we can go ahead and do the actual application, and we'll send that off to another dispatch that decides whether this is a primitive or compound procedure, in order to decide how to apply that procedure to that set.

然后，在获得了运算符的值和一组参数值之后，我们可以继续执行实际的应用，并将其发送到另一个分派，该分派决定这是一个基本过程还是复合过程，以便决定如何将该过程应用于该组参数。

how to apply that procedure to that set of arguments now let's look at all of those pieces in turn let's actually start with the bottom one first apply dispatch this is the thing is going to do the actual work of making the procedure be applied to a set of arguments and like eval and a Val sequence it also has a contract its contract says I expect the proc register to hold the actual procedure a pointer to the structure that actually corresponds to that procedure I expect argyll to be a list of the actual argument values and I expect the stack

如何将该过程应用于该组参数。现在让我们依次看看所有这些部分。让我们先从最下面的开始：apply 分派。这是执行实际工作，使过程应用于一组参数的东西。像 eval 和 eval 序列一样，它也有一个契约。它的契约说：我期望 proc 寄存器保存实际的过程，即指向与该过程对应的结构的指针；我期望 argl 是实际参数值的列表；我期望栈处于特定状态。

Argument values and I expect the stack to have a particular state. I want the top value on the stack to be the return point, similar to what we saw with F sequence. Our ply dispatch will then do the work, and when it's done applying that procedure to a set of arguments, it expects the return value to be sitting in VAL. That's its output.

参数值，并且我期望栈处于特定状态。我希望栈顶的值是返回点，类似于我们在 eval 序列中看到的。我们的 apply 分派将执行工作，当它完成将该过程应用于一组参数时，它期望返回值位于 VAL 中。那是它的输出。

It will write everything because it's going to call F sequence inside of it, so it's going to in fact overwrite everything we need. We're going to be careful about that with the stack, and when it's done, when it comes back to...

它会写出所有内容，因为它会在内部调用 F 序列，所以它实际上会覆盖我们需要的一切。我们要小心处理栈，当它完成时，当它返回到……

And when it's done, when it comes back to the point that asks for all of this, it expects the stack to be restored. That is, the top value removed—that top value that we know is the return point that we started with. We're going to come back to that in a second, but with that contract applied, dispatch is actually quite straightforward.

当它完成时，当它返回到要求所有这些的那个点时，它期望栈被恢复。也就是说，栈顶的值被移除——我们知道那个栈顶值就是我们开始时的返回点。我们稍后会回到这一点，但有了这个约定，dispatch 实际上相当直接。

Since proc holds the actual procedure, we can do a dispatch. We test to see if it's a primitive or if it's a compound thing—that is, something we've built ourselves with lambda—just by looking at the labels again. It's an abstraction about...

由于 proc 保存了实际的过程，我们可以进行 dispatch。我们通过再次查看标签来测试它是原始过程还是复合过程——即我们用 lambda 构建的东西。这是一种关于……的抽象。

labels again it's an abstraction about how we manipulate the structures and depending on either those two cases we dispatch off to something that does the actual work which we'll get to in a second otherwise we head off to an error handler that says we have an unknown procedure type here.

再次查看标签，这是一种关于我们如何操作结构的抽象，根据这两种情况中的任何一种，我们 dispatch 到执行实际工作的某个部分，我们稍后会讲到，否则我们进入一个错误处理程序，说这里有一个未知的过程类型。

if it's a primitive procedure one of the built-in pieces of hardware then we just do the work we have some abstract operator called apply primitive procedure that connects to the hardware that takes the procedure in proc the list arguments in argyll does

如果它是一个原始过程，即内置硬件之一，那么我们只需做工作。我们有一个称为 apply primitive procedure 的抽象操作符，它连接到硬件，该操作符接收 proc 中的过程、argyll 中的参数列表，执行工作并将答案放入 Val，正好在我们期望的位置。然后我们将恢复 continue 寄存器，记住我们假设它位于栈顶，所以为了满足约定，我们将其放回，然后前往那个点，现在我们已经完成了工作。

proc the list arguments in argyll does the work and puts the answer in to Val exactly where we expected we're then going to restore the continue register remember we assumed that that was sitting on the top of the stack so to satisfy the contract we put it back in and we then go to that point now having completed our work

proc 中的过程、argyll 中的参数列表，执行工作并将答案放入 Val，正好在我们期望的位置。然后我们将恢复 continue 寄存器，记住我们假设它位于栈顶，所以为了满足约定，我们将其放回，然后前往那个点，现在我们已经完成了工作。

suppose as a compound procedure that is it's something that was built with a lambda then we know what to do from our normal evaluator we need to first get out the parameters of the procedure that's part of that list structure that represents the procedure

假设它是一个复合过程，即用 lambda 构建的东西，那么我们从常规求值器中知道该怎么做：我们首先需要取出过程的参数，这些参数是表示该过程的部分列表结构。

structure that represents the procedure and we'll stick those in unev temporarily. We need to get the environment part of the procedure; we'll stick that in M again temporarily. Notice we're just walking the tree structure of what's represented in proc to get those pieces out.

表示该过程的结构，我们将它们临时放入 unev。我们需要取出过程的环境部分；我们将其临时放入 M。注意我们只是在遍历 proc 中表示的树结构以取出这些部分。

Then we take the list of parameters currently sitting in on M, we take the corresponding list of arguments now sitting in argyll because that's where we expected them to be. We take the current environment sitting in M, and we build a new environment again.

然后我们取出当前在 unev 中的参数列表，取出当前在 argyll 中的相应参数列表，因为那是我们期望它们所在的位置。我们取出当前在 M 中的环境，并再次构建一个新环境。

Build a new environment again. This is just some manipulation of tree structures we saw before, but what gets created is a pointer to a new environment, and we store that in M. Notice what we have: we now have a new environment in M, an extended environment that inherits the original environment but has a new frame—the frame that was dropped by the application of the procedure.

再次构建一个新环境。这只是一些我们之前见过的树结构操作，但创建的是一个指向新环境的指针，我们将其存储在 M 中。注意我们有什么：我们现在在 M 中有一个新环境，一个扩展环境，它继承了原始环境但有一个新框架——该框架是由过程的应用所丢弃的。

We then take what's sitting in proc, that procedure, walk through it using tree structure to get out the body of the procedure, which we assumed, by the way, for our evaluator, is a sequence or a

然后我们取出 proc 中的内容，即那个过程，使用树结构遍历它，取出过程的主体，我们假设，顺便说一下，对于我们的求值器，它是一个序列或一个……

For our evaluator is a sequence or a begin, and we put that in on F. Ah, that's nice because that's exactly what we expect. And now we have satisfied the contract for EV sequence. Notice what's in place here: we've got a continue point on the continue registers on the top of the stack, rather still, that's where we put it to me. We have an environment in M, we have a list or sequence of expressions in on F, and we can go to F sequence having satisfied its contract.

对于我们的求值器，它是一个序列或一个 begin，我们将其放入 unev。啊，这很好，因为那正是我们期望的。现在我们已经满足了 EV sequence 的约定。注意这里的位置：我们在 continue 寄存器上有一个继续点，在栈顶，仍然在那里，那就是我们放置它的地方。我们在 M 中有一个环境，在 unev 中有一个表达式列表或序列，我们可以前往 F sequence，已经满足了它的约定。

When it gets done, it will also restore the state of the stack, doing that pop of the continue.

当它完成时，它也会恢复栈的状态，执行对 continue 寄存器的弹出。

stack doing that pop of the continue register and go to that place with the value of the last expression sitting in valve exactly what we want so now we see compound application does what we'd expect builds a new environment and evaluates an expression or sequence of expressions with respect to that new environment.

对 continue 寄存器的弹出，并前往那个地方，最后一个表达式的值在 val 中，正是我们想要的。所以现在我们看到复合应用做了我们期望的事情：构建一个新环境，并相对于该新环境求值一个表达式或表达式序列。

so let's quickly recap first of all well I have that return point on the top of the stack well we're going to assume or we have assumed that the body of a procedure is a sequence of expressions and we know F sequences

所以让我们快速回顾一下。首先，好吧，我在栈顶有那个返回点。我们假设，或者我们已经假设，过程的主体是一个表达式序列，我们知道 F sequence……

expressions and we know F sequences, assuming that as part of its contract as well, we're going to put it on the top of the stack for exactly the same reason. It's a performance optimization. We also know it has to be saved on the stack in order to go off and get the evaluate of the operator; we need to have it there anyway, so we might as well just leave it there as long as possible in order to avoid unnecessary operations.

表达式序列，我们知道 F sequence，也假设这是其约定的一部分，我们将它放在栈顶，原因完全相同。这是一个性能优化。我们还知道它必须保存在栈上，以便去求值操作符；我们无论如何都需要它在那里，所以我们不妨尽可能长时间地把它留在那里，以避免不必要的操作。

Then to recap, for a compound application, notice that we use F sequence rather than a valid dispatch because we're going to

然后回顾一下，对于复合应用，注意我们使用 F sequence 而不是 val 进行 dispatch，因为我们将……

valid dispatch because we're going to allow bodies of procedures to be sequences. Notice again the use of the tail call optimization, which was going to be allowing us to have tail recursion in our system. Also notice that both N and unev are used as part of the call because they're required by the FC qín scon track, that's why we set them up in that particular way rather than using exp for example.

允许过程的主体是序列。再次注意尾调用优化的使用，这将允许我们的系统中有尾递归。还要注意，N 和 unev 都作为调用的一部分被使用，因为它们是 F sequence 约定所要求的，这就是我们以那种特定方式设置它们的原因，而不是使用 exp 例如。

And as before, notice how we use N and on F in the first two lines just as local temporary storage places. As before, we could have used any register; these are just simply holding.

和之前一样，注意我们在前两行中如何使用 N 和 unev 作为本地临时存储位置。和之前一样，我们可以使用任何寄存器；这些只是简单地持有。

Register these are just simply holding onto things while we get the other pieces we need. Now we can go ahead and actually do the work to set up for that application. So one way of dispatch off to an application, the first thing we do is save the continue register on the top of the stack. As we saw, that's going to stay there until we actually finish everything up and restore it as we do part of the actual application.

寄存器，这些只是简单地持有东西，同时我们获取其他需要的部分。现在我们可以继续实际进行设置以进行该应用。因此，当 dispatch 到应用时，我们做的第一件事是将 continue 寄存器保存在栈顶。正如我们所见，它将一直留在那里，直到我们完成所有事情并在实际应用过程中恢复它。

Having done that, we need to then get the value of the operator, and this now looks a lot like what we did before. We're going to...

完成那一步后，我们需要获取操作符的值，这看起来很像我们之前做的。我们将……

Like what we did before, we're going to put the operands temporarily into NF so that we can take the expression register and put the operator expression into exp. Having done that, in general we want to go off and do an eval on this, so we'll put a label in to continue and go to a Val dispatch as before.

像我们之前做的那样，我们暂时将操作数放入 NF 中，以便我们可以取出表达式寄存器并将运算符表达式放入 exp。完成之后，一般来说我们要对其进行求值，所以我们会放入一个标签以继续，并像之前一样转到 Val 分派。

Though, we again save env and Neph because we're going to need them when we come back. So this has exactly the structure we'd expect.

不过，我们再次保存 env 和 Neph，因为当我们返回时需要它们。所以这具有我们预期的结构。

And when we come back from a Val dispatch to the point labeled F applied it operator, we know that the value of the procedure.

当我们从 Val 分派返回到标记为 F applied it operator 的点时，我们知道过程的值。

know that the value of the procedure will is sitting in Val, we can restore the state of the world and move that over into proc. Before we do that though, let's look at something again: why bother to save the environment away? And here's a nice way of seeing it. How do we know that the expression that's sitting in the operator is just a name? If we know it was just a name, we didn't have to save the environment because we wouldn't change it; we could just go look it up. But of course, that expression could itself be another procedure application, and if it is, we see that.

知道过程的值将位于 Val 中，我们可以恢复世界状态并将其移到 proc 中。但在我们这样做之前，让我们再看一下：为什么要费心保存环境？这里有一个很好的理解方式。我们怎么知道运算符中的表达式只是一个名字？如果我们知道它只是一个名字，我们就不必保存环境，因为我们不会改变它；我们可以直接去查找它。但当然，那个表达式本身可能是另一个过程应用，如果是的话，我们会看到。

application and if it is we see that we're going to create a new environment. We just did that with the application, therefore we have to save the environment away. Otherwise this has the same form we saw before. We're setting up the contract for value dispatch, saving away whatever parts of the world we're going to need and when we come back restoring and moving on.

应用，如果是的话，我们会看到我们将创建一个新环境。我们刚刚在应用时就这样做了，因此我们必须保存环境。否则，这与我们之前看到的具有相同的形式。我们为值分派设置契约，保存我们需要的世界状态，并在返回时恢复并继续。

In this case, putting the value into proc, getting set for the contract for apply, and again to recap, notice how we put continue register on the top of the stack but leave it there untouched until either we...

在这种情况下，将值放入 proc，为 apply 的契约做好准备，再次回顾，注意我们如何将 continue 寄存器放在栈顶但保持不动，直到我们……

Leave it there untouched until either we hit primitive apply where we saw we do the restore or until the end of F sequence in the body of a compound apply that is in the body the expression does the restore so the restore could happen in one of two places but in either case when we're done with the application the stack has returned to the state it was.

保持不动，直到我们遇到原始应用（我们看到在那里进行恢复）或直到复合应用体中的 F 序列结束，即在体中的表达式进行恢复，所以恢复可能发生在两个地方之一，但无论哪种情况，当我们完成应用时，栈已恢复到原来的状态。

In terms of getting the value of the operator we do a standard called eval-dispatch just saving away the set of expressions that are the operands because we're going to need them.

在获取运算符的值方面，我们进行标准的 eval-dispatch，只保存操作数表达式集合，因为我们将需要它们。

because we're going to need them and

因为我们将需要它们，并且

because we're going to need them and saving the environment because we're going to need that to evaluate those operand expressions when we come back at the end. As we noted, we put the operator in proc because we're going to use that if there are no arguments immediately directly, as we're having it in the right place. So having gotten the value of the operator and put it into proc where we want it to be, we're now set to run through this loop.

因为我们将需要它们，并且保存环境，因为我们在最后返回时需要它来求值那些操作数表达式。正如我们注意到的，我们将运算符放入 proc，因为如果没有参数，我们将立即直接使用它，我们把它放在正确的位置。因此，在获取运算符的值并将其放入 proc（我们希望它在的地方）之后，我们现在准备运行这个循环。

And the loop should basically get the values of all the operands and accumulate them together into argyll, so we can head off.

循环应该基本上获取所有操作数的值并将它们累积到 argyll 中，这样我们就可以出发。

Together into argyll so we can head off to apply dispatch. Let's look at what we do though in a little more detail first. We initialize our goal to be an empty list, set up at some starting point, and then we check to see if in fact there are any arguments to this procedure.

累积到 argyll 中，这样我们就可以出发到 apply 分派。让我们先更详细地看看我们做了什么。我们初始化我们的目标为一个空列表，设置某个起始点，然后检查是否确实有任何参数给这个过程。

If uh NAV, the set of things we haven't done yet is empty, there are no operands there, then we're set. We have a procedure in proc, we have an empty list and argyll, and we can go straight to apply dispatch and complete the actual application.

如果 uh NAV，即我们尚未处理的事物集合为空，没有操作数，那么我们就准备好了。我们在 proc 中有一个过程，在 argyll 中有一个空列表，我们可以直接转到 apply 分派并完成实际应用。

If there are arguments however, we're going to have to

如果有参数，那么我们将不得不

arguments however we're going to have to run through this loop of getting their values so in this case and only in this case we actually save proc away notice how we've saved some work on the stack if we don't need it we'll come back and restore proc later on but we put the procedure away and now we run through a loop well we know the general form of the loop we're going to take each expression in turn each thing and uh Neph put it into X and go off to a valve dispatch to get the answer and then when we come back accumulate that into our

如果有参数，那么我们将不得不运行这个循环来获取它们的值，所以在这种情况下，也只有在这种情况下，我们才真正保存 proc。注意我们如何在栈上保存了一些工作，如果不需要，我们稍后会恢复 proc，但我们将过程保存起来，现在运行一个循环。我们知道循环的一般形式：我们将依次取出每个表达式，每个事物，放入 X，然后去进行值分派以获得答案，然后当我们返回时将其累积到我们的……

We come back, accumulate that into our goal. In fact, where that purple line is, there's a bunch of stuff on the next slide that will come too. Well skipped up for now. We know that we're going to simply continue to accumulate values in argyll until we get to the point where we're going to get the value of the last operand.

我们返回，将其累积到我们的目标中。实际上，在紫色线那里，下一张幻灯片上还有一堆东西，现在先跳过。我们知道我们将简单地继续在 argyll 中累积值，直到我们到达获取最后一个操作数的值的点。

In that case, we can go down to ever ply last art. And what does that do? It puts a new label and continue and go straight to a valve dispatch. Oh, there's that tail recursion again of saving us the extra work. We know that when we go

在这种情况下，我们可以转到 ever ply last art。那做什么？它放入一个新的标签并继续，直接转到值分派。哦，又是尾递归，为我们节省了额外的工作。我们知道当我们去……

the extra work we know that when we go

额外的工作，我们知道当我们去……

The extra work we know that when we go off to valve dispatch we don't have to come back here and we store never anything else because we don't need anything more here. So when we go off we get the value of the last argument and come back at that stage we store argyll, put this new value into argyll and restore proc. What have we done? We now have a procedure in proc, we have a list of arguments in argyll, and at this stage we're set to go off to apply dispatch. Remember the continued point is still sitting on the top of the stack, and in terms of evaluating each operand, that.

额外的工作，我们知道当我们去值分派时，我们不必回到这里，我们也不再存储任何东西，因为我们在这里不需要更多了。所以当我们去获取最后一个参数的值并返回时，在那个阶段我们存储 argyll，将这个新值放入 argyll 并恢复 proc。我们做了什么？我们现在在 proc 中有一个过程，在 argyll 中有一个参数列表，在这个阶段我们准备去 apply 分派。记住继续点仍然在栈顶，在求值每个操作数方面，那个……

terms of evaluating each operand that chunk that was missing from the purple spot there well it has the form we'd expect we save away state we're going to need the environment and the things we haven't evaluated yet put a new label and continue go to eval-dispatch when we come back we've got the value of that expression we restore the state add it to argl change what's in on F to remove that first expression because we've done it and go back around the loop so we simply loop through this sequence of getting a new expression into X going

在求值每个操作数方面，紫色位置缺失的那块具有我们预期的形式：我们保存状态，我们需要环境和尚未求值的事物，放入一个新的标签并继续，转到 eval-dispatch，当我们返回时，我们得到了那个表达式的值，恢复状态，将其添加到 argl，改变 on F 中的内容以移除第一个表达式，因为我们已经完成了它，然后回到循环。所以我们简单地循环这个序列：将一个新表达式放入 X，去 eval-dispatch，返回时取其值并累积到目标中。我们只是使用栈来保存我们返回时需要的事物。

getting a new expression into X going off to eval dispatch when we come back, taking its value in accumulating in it. Our goal is just using the stack to save away things we're going to need when we come back.

将一个新表达式放入 X，去 eval-dispatch，返回时取其值并累积到目标中。我们只是使用栈来保存我们返回时需要的事物。

So here are the key things to note about this chunk, and I know we're throwing a lot of code at you, but you should be able to step back and see these points. First of all, in this loop, getting the values of the operands as we pointed out, we check to see if there are no operands so that we avoid going off and doing the evaluation of something if we just got.

那么，关于这一部分，需要记住的关键点如下。我知道我们抛出了大量代码，但你应该能够退一步看到这些要点。首先，在这个循环中，获取操作数的值时，正如我们指出的，我们会检查是否没有操作数，以避免在刚得到空列表时就去评估某个东西。

Evaluation of something if we just got an empty list now why did we save proc way back at the beginning and to restore it at the very end why not just have it hang around? Well, we know inside the loop we're going to call eval and its contract says it writes proc or it may write product. In fact, one of the operand expressions might be an application in which case we're going to need proc there.

评估某个东西，如果我们刚得到一个空列表。那么，为什么我们在一开始保存了proc，并在最后恢复它？为什么不让它一直待在那里？我们知道，在循环内部我们会调用eval，而它的契约规定它会写入proc，或者可能写入product。事实上，其中一个操作数表达式可能是一个应用，在这种情况下我们需要proc。

So we need to save it away in order to make things available for use for other kinds of sub expressions. Same reasoning applies for our goal: we've got to save it away and restore it because...

所以我们需要保存它，以便为其他类型的子表达式提供可用的东西。同样的推理也适用于我们的目标：我们必须保存它并恢复它，因为……

to save it away and restore it because we don't know that one of the sub expressions might be in fact an application that we'll need to reuse it as well. So that contract for eval is helping us decide what things we have to save away.

保存它并恢复它，因为我们不知道某个子表达式可能实际上是一个应用，我们也需要重用它。因此，eval的契约帮助我们决定哪些东西必须保存。

On the other hand, we said we need both proc and argyll, but why save argyll inside the loop and proc outside of it? Aren't we doing a lot more work? And the answer is we are, but of course we need it because we need to change our goal every time around the loop; we need to get it back, add something to it, and save.

另一方面，我们说我们需要proc和argl，但为什么在循环内部保存argl，而在循环外部保存proc？我们不是做了更多的工作吗？答案是，确实如此，但我们需要它，因为每次循环我们都需要改变目标；我们需要取回它，添加一些东西，然后保存。

get it back add something to it and save a new state away whereas proc isn't going to change it's the same procedure no matter which expressions we're evaluating in terms of arguments and finally why do we have that save our goal before the branch to F Apple last argument before we go off to do the last arc logically it really goes with the saves and eval of one operand why not put it there and the answer is basically it's a hack this is an optimization that saves one instruction and it's not really a big deal it would have been more sense to logically put it in with

取回它，添加一些东西，然后保存一个新的状态，而proc不会改变，无论我们评估哪个表达式，它都是同一个过程。最后，为什么我们在分支到F Apple last argument之前保存我们的目标？在我们去处理最后一个参数之前，逻辑上它应该与保存和评估一个操作数放在一起，为什么不放在那里？答案基本上是，这是一个技巧，是一个优化，节省了一条指令，并不是什么大问题。逻辑上把它与那些保存放在一起会更有意义，但事实就是这样。

more sense to logically put it in with those other things that were part of the same set of saves but there you have it so in fact there's most of the register machine code for an evaluator we've really taken the idea of eval and reduced it down to register machine operations now we've cheated a little bit we've gotten all these abstract operations to manipulate expressions and environments but we know those are just tree manipulations and in fact we could easily build each of those pieces indeed if you look in the textbook you'll see

更有意义的是逻辑上把它与那些属于同一组保存的其他东西放在一起，但事实就是这样。所以，实际上，这里包含了求值器的大部分寄存器机器代码。我们确实把eval的思想简化成了寄存器机器操作。现在我们有点作弊了，我们使用了所有这些抽象操作来操作表达式和环境，但我们知道那些只是树操作，实际上我们可以轻松地构建每一个部分。事实上，如果你看教科书，你会看到……

if you look in the textbook you'll see very detailed specifications or how to do those in register machines the other thing we see is how we can reuse the same machinery using the stack disabled way state well we use that contract between eval and apply to get values of sub-expressions and finally we've seen how we can be clever we can avoid using the stack when we don't need it we can use that idea of tail recursion to say if the value of this expression is the same value as the value of an overall expression simply send it straight back rather than

如果你看教科书，你会看到非常详细的规范，说明如何在寄存器机器中实现这些。我们看到的另一件事是，我们如何使用栈以禁用状态的方式重用相同的机制。我们利用eval和apply之间的契约来获取子表达式的值。最后，我们看到了如何变得聪明：我们可以在不需要时避免使用栈，我们可以利用尾递归的思想，如果这个表达式的值与整个表达式的值相同，就直接返回它，而不是……

send it straight back rather than keeping track of things on the stack that I don't need otherwise now we've got a Val we've built a register machine version that connects basic hardware to a universal machine to an evaluator that lets us put in any expression to help you see how this little explicit control evaluator in fact incorporates the ideas of a Val and apply we're going to run through a very simple little trial simulation a simulation of computing factorial of 3 for the standard definition of factorial fact I don't really care about the version of it you

直接返回它，而不是在栈上跟踪那些我不需要的东西。现在我们有了一个Val，我们构建了一个寄存器机器版本，将基本硬件连接到通用机器，再连接到求值器，让我们可以输入任何表达式。为了帮助你看到这个显式控制求值器如何体现eval和apply的思想，我们将运行一个非常简单的模拟，模拟计算3的阶乘，使用标准的阶乘定义。我不在乎你使用哪个版本……

really care about the version of it you may find it convenient to go back and print out slides that correspond to all the pieces of the register machine code so that you can actually follow along as we do this if you want to do that stop do it and come back and redo this part of the lecture to run through this simulation here's what we're going to do

你使用哪个版本。你可能会发现，回去打印出与寄存器机器代码所有部分对应的幻灯片会很方便，这样你可以在我们进行时实际跟随。如果你想这样做，停下来去做，然后回来重新听这部分讲座。为了运行这个模拟，下面是我们将要做的：

we're going to mark every time we hit one of the labels every time we hit a new piece of the register machine code if you like so under label will as far as specify where we are we'll indicate

我们将标记每次到达一个标签，每次到达寄存器机器代码的新部分。如果你愿意，在标签下，我们将指定我们在哪里，我们将指示……

As specified, where we are, we'll indicate what's in each of the registers: expression, environment, value, procedure, argument lists, unev, you ate it, and continue. And we'll show what's on the stack, and we're going to use the stack growing out from left to right so that the top of the stack is at the right as we move along.

按照指定，我们在哪里，我们将指示每个寄存器中的内容：表达式、环境、值、过程、参数列表、unev、you ate it和continue。我们将展示栈上的内容，我们将使用从左到右增长的栈，这样栈顶在右边，随着我们移动。

We'll also highlight in red the things that have changed from stage to stage so you can see how we move things through this register machine. Okay, to start things up, we have an expression loaded into the X preju stir, an environment and loaded into M.

我们还会用红色突出显示从一步到另一步发生变化的内容，这样你可以看到我们如何在这个寄存器机器中移动东西。好的，开始启动时，我们在X寄存器中加载了一个表达式，在M中加载了一个环境。

Stir an environment and loaded into M, and something on the continuation, and basically some infrastructure takes care of this. It reads an expression in this case, calling fact on three, loads it up into X, has a pointer of the global environment in ham, and puts a pointer to the read eval print loop or REPL in the continuation.

在M中加载了一个环境，并且在continuation中加载了一些东西，基本上是一些基础设施负责处理这些。它读取一个表达式，在这种情况下是对3调用fact，将其加载到X中，在ham中有一个指向全局环境的指针，并在continuation中放入一个指向读取-求值-打印循环（REPL）的指针。

We go off to a value dispatch; if L dispatch of course checks the types of these things, figures out it's an application, and does the following: it saves a way to continue register on the stack and puts a new marker into it.

我们进入值分发；如果L分发当然会检查这些事物的类型，发现它是一个应用，并执行以下操作：它将continue寄存器保存到栈上，并在其中放入一个新的标记。

the stack and puts a new marker in to continue that says come back to did the operator when we're set saves the environment and saves everything else about the first part of the expression. Those are things we still have to get. It also by the way puts those in unev as we see along the way and then loads up a new expression into X. So the things we're interested in here is it puts the first part, the operator expression, into X and is going to get its value with respect to the same environment.

在栈上，并在continue中放入一个新的标记，说“回到did the operator”，当我们设置好时，保存环境并保存表达式的第一部分的所有其他内容。这些是我们仍然需要获取的东西。顺便说一下，它还将这些放入unev，正如我们沿途看到的，然后将一个新的表达式加载到X中。所以我们这里感兴趣的是，它将第一部分（运算符表达式）放入X，并将相对于同一环境获取其值。

having on the stack the things that still has to do, if al then looks up the value of.

在栈上保存着尚未完成的事情，然后如果 al 查找值。

To do if al, then looks up the value of fact, it goes off to eval-dispatch, figures out it's a name, looks it up, and puts that value, that procedure, in Val, and heads to did off. At this stage, we've got the value of that first expression saved away. Having done that, we then move that value into the proc register, getting ready for apply restore off of the stack, the things we haven't done yet, and set up to go through the loop.

为了执行 if al，然后查找 fact 的值，它转到 eval-dispatch，识别出这是一个名字，查找它，并将该值（即那个过程）放入 Val，然后前往 did off。在这个阶段，我们已经保存了第一个表达式的值。完成之后，我们将该值移入 proc 寄存器，准备进行 apply，从栈中恢复尚未完成的事情，并设置好以进入循环。

In fact, we're also going to save proc on that progress tree, because we realize that we don't have zero arguments here.

事实上，我们还将 proc 保存在那个进度树上，因为我们意识到这里没有零个参数。

我们这里没有零参数的情况，我们确实有事情要做。注意我们现在正准备好运行循环，从F和Q中取出值，将它们放入那个空列表中，这样我们最终会在proc中得到一个过程，在argyll中得到一个值列表，准备就绪。

我们这里没有零参数的情况，我们确实有事情要做。注意我们现在正准备好运行循环，从 F 和 Q 中取出值，将它们放入那个空列表中，这样我们最终会在 proc 中得到一个过程，在 argyll 中得到一个值列表，准备就绪。

所以我们把第一个表达式从F中移出来，移到X中，这是我们希望它所在的位置，因为我们要去获取它的值，但我们同时注意到这实际上是最后一个参数，所以我们将单独处理它，注意我们还保存了Y。

所以我们把第一个表达式从 F 中移出来，移到 X 中，这是我们希望它所在的位置，因为我们要去获取它的值，但我们同时注意到这实际上是最后一个参数，所以我们将单独处理它，注意我们还保存了 Y。

Separately, notice we've also saved your goal on the list because we're going to have to restore it in order to accumulate things. And now we can head off to eval. Notice we've unwound things; we're now getting the values of the expressions.

另外，注意我们还保存了你的目标在列表中，因为我们必须恢复它以便累积事物。现在我们可以前往 eval。注意我们已经展开了事物；我们现在正在获取表达式的值。

We're going to get the value of 3 with respect to the global environment and expect to accumulate that into our goal. So in fact, we do that value and go to the next spot. Since this is a self-evaluating thing, it simply puts that value in Val.

我们将获取 3 相对于全局环境的值，并期望将其累积到我们的目标中。所以事实上，我们这样做并前往下一个位置。由于这是一个自求值的事物，它简单地将该值放入 Val。

Notice what we have now: we've got the value of the only argument, the last argument in.

注意我们现在有什么：我们已经得到了唯一参数的值，即最后一个参数。

the only argument the last argument in Val we've got a procedure so we can in fact accumulate those things and head to apply or in other words we restore the state of the world we accumulate into our goal the list of arguments in this case just the list of the single value 3 we restore the procedure back into proc and when we get to apply notice what we have the procedure in proc a list of arguments in argyll and a place to continue at the top of the stack exactly what we want the fact that the rest of the registers hold things don't matter寄存器的内容其实并不重要

唯一参数，最后一个参数在 Val 中，我们有一个过程，所以我们可以实际上累积这些事物并前往 apply，或者换句话说，我们恢复世界的状态，我们将参数列表（在这种情况下只是单个值 3 的列表）累积到我们的目标中，我们将过程恢复到 proc 中，当我们到达 apply 时，注意我们有什么：过程在 proc 中，参数列表在 argyll 中，以及一个继续执行的位置在栈顶，这正是我们想要的。其余寄存器中的内容无关紧要。

The registers hold things that don't matter to us. There are residual things left over since this is a compound procedure. Apply basically creates a new environment E by taking the list of arguments in argyll, the list of parameters in the thing sitting in proc, and binding them together, creating a new frame.

寄存器中保存着对我们无关紧要的内容。由于这是一个复合过程，会留下一些残余物。Apply 基本上通过取 argyll 中的参数列表、proc 中事物的参数列表，并将它们绑定在一起，创建一个新环境 E，从而创建一个新框架。

It then puts the body, the sequence of expressions, in on F, which is where we expect it, and heads off to sequence or Val sequence. Notice what we have: we have a sequence of things to do, a none F, an environment with respect to which we're going to do that evaluation in m.

然后它将主体，即表达式序列，放入F中，这正是我们所期望的位置，然后前往sequence或Val sequence。注意我们拥有什么：我们有一个待执行的操作序列，一个none F，以及一个环境，我们将相对于该环境在m中进行求值。

going to do that evaluation in m and still sitting on the top of the stack is the place to go back to the continue and now we simply run through the loop we pull each expression out in turn from the uh nav things and checked it to see if it's the last one.

将在m中进行该求值，并且栈顶仍然保留着返回继续执行的位置，现在我们只需运行循环，依次从nav things中取出每个表达式，并检查它是否是最后一个。

In this case there's only one expression there's just a big if so we put that into X we've got an environment with respect to which we're going to do the evaluation and since it's the last thing we can actually get set to restore the state of the world and in particular we move to

在这种情况下，只有一个表达式，只是一个大的if，所以我们将它放入X中，我们有一个环境，我们将相对于该环境进行求值，并且由于它是最后一个，我们实际上可以开始恢复世界的状态，特别是我们转向

the world and in particular we move to restoring the continue register off the stack and now we're set notice what we have we have a valuation of an expression a big if in this case with respect to a new environment and a place to go to when I'm done and indeed we've actually gone through a very nice cycle the cycle is that we've gone from evaluating an expression with respect to an environment into the application of a procedure with respect to a set of arguments which has reduced to evaluation of a new expression with respect to a new environment

世界的状态，特别是我们转向从栈中恢复continue寄存器，现在我们准备好了。注意我们拥有什么：我们有一个表达式的求值，在这种情况下是一个大的if，相对于一个新环境，以及一个完成后要去的地方。事实上，我们经历了一个非常好的循环：这个循环是，我们从相对于一个环境求值一个表达式，进入相对于一组参数应用一个过程，这又归结为相对于一个新环境求值一个新表达式。

respect to a new environment and notice by the time we get from that cycle of the first eval to the second of Val the continue registers back to where we started from in between we've simply got through a little loop where we get the values of the arguments out of on F and accumulate them in argyll saving away on the stack anything we might need in the meantime but the overall loop is simply shown there in those nice boxes so now let's pick up the pace a game we started off evaluating factorial 3 with respect to the global environment after

相对于一个新环境，注意当我们从第一个eval的循环到达第二个Val时，continue寄存器已经回到了我们开始的地方。在中间，我们只是经历了一个小循环，我们从F中取出参数的值，并将它们累积在argyll中，同时将我们可能需要的任何东西保存在栈上。但整体循环就简单地显示在那些漂亮的盒子中。所以现在让我们加快步伐，我们开始相对于全局环境求值factorial 3，经过

respect to the global environment after a series of steps we saw we got down to evaluating an if expression with respect to some new environment II won which has some bindings for variables in it and we want to get back to the same place on the continuation when we're done. What happens inside of the if? Well basically we know what happens. We grab the first part because if has handles specially. We get out the predicate, move that into expert exp register, saving away things we're going to need on the stack and putting a new continuation point into

相对于全局环境，经过一系列步骤，我们看到我们归结为相对于某个新环境II won求值一个if表达式，该环境包含一些变量绑定，我们希望在完成时回到继续执行的同一位置。if内部发生了什么？嗯，基本上我们知道发生了什么。我们抓取第一部分，因为if有特殊处理。我们取出谓词，将其移动到expert exp寄存器中，将我们需要的东西保存在栈上，并将一个新的继续点放入

putting a new continuation point into the continue register and we head off to eval get the value of the predicate. after some number of steps we know by contract when we get back to that place, we the value of that predicate sitting in valve. in this case it's false, so having done that we can now say ah restore back into the register the expression we saved away.

将一个新的继续点放入continue寄存器，然后我们前往eval获取谓词的值。经过若干步骤后，按照约定，当我们回到那个位置时，谓词的值就放在valve中。在这种情况下它是false，所以做完那件事后，我们现在可以说啊，将我们保存的表达式恢复到寄存器中。

we store back in fact the same environment because we've gone that back, and we store back also the read eval print loop in to continue that is put the state of the world back and move.

我们实际上存储回相同的环境，因为我们已经取回了它，并且我们还将读取-求值-打印循环存储回continue中，也就是说将世界的状态放回去并移动。

put the state of the world back and move into X the consequent the part of the thing we want to deal with because in fact the expression test was false. notice what we've got evaluation of a new expression one of the pieces of the if with respect to an environment and a place to go to and continue. okay we know from factorial that expression is times n factorial of n minus 1.

将世界的状态放回去，并将结果部分（即我们想要处理的那部分）移入X，因为事实上表达式测试是false。注意我们得到了什么：对if的一个组成部分的新表达式相对于一个环境进行求值，以及一个要去的地方和继续。好的，我们知道从factorial中，那个表达式是times n factorial of n minus 1。

and now we see the other piece that's going to happen here we're going to get the value of this expression with respect to e 1 that means we first get out the value or we want to first rather get the value of

现在我们看到这里将要发生的另一部分：我们将相对于e 1获取这个表达式的值，这意味着我们首先取出操作符的值，或者我们想要首先获取

首先，我们想要获取操作符的值，并将其移动到X中保存，同时将栈上需要保留的内容暂时存放起来。一旦在Val中获得了该值，且该操作符的值为乘法（mul），我们就可以恢复之前保存的内容，并进入一个循环，在该循环中我们实际去获取各个参数的值。

首先，我们想要获取操作符的值，并将其移动到X中保存，同时将栈上需要保留的内容暂时存放起来。一旦在Val中获得了该值，且该操作符的值为乘法（mul），我们就可以恢复之前保存的内容，并进入一个循环，在该循环中我们实际去获取各个参数的值。

经过一些步骤后，我们最终会到达以下状态：我们将在相同的环境下评估对阶乘的递归调用，即计算n减1的阶乘，此时在过程（procedure）中已经保存了相关的程序信息，并且环境变量a1也已就绪，我们已将过程保存在proc变量中。

经过一些步骤后，我们最终会到达以下状态：我们将在相同的环境下评估对阶乘的递归调用，即计算n减1的阶乘，此时在过程（procedure）中已经保存了相关的程序信息，并且环境变量a1也已就绪，我们已将过程保存在proc变量中。

we've got the procedure in proc the thing that's going to do the multiplication when we're done and in our goal we got the value of the first argument and which has the value 3 sitting and uh never the remaining things that we have to do we have to get the value of that expression and notice what's sitting on the stack we've got the place we eventually want to return to at the bottom of the stack we got the procedure saved away and we got the argument list system way there by the way or our deferred operations because what's going to happen now when we take

我们已经将过程保存在proc中，即完成后将进行乘法运算的那个东西，而在我们的目标中，我们得到了第一个参数的值，其值为3，并且……嗯，剩下的我们必须做的事情是，我们必须得到那个表达式的值，注意栈上有什么：在栈的底部，我们放置了最终想要返回的位置；我们保存了过程；我们还保存了参数列表。顺便说一下，这就是我们的延迟操作，因为接下来当我们取那个值……

what's going to happen now when we take that value sitting at none F and go and do the work well let's look notice a game by the way how evaluation has run through loop getting evaluation of factorial of 3 with respect to 1

接下来当我们取到那个位于none F的值并去做工作时，会发生什么？让我们看看，顺便注意一下，评估是如何循环运行的：对阶乘3相对于环境1的求值……

environment has reduced to evaluation of a body with respect to another environment which has reduced to evaluation of a recursive call with respect to another environment but with some deferred operations on the stack

环境已经简化为对过程体的求值，相对于另一个环境，而后者又简化为对递归调用的求值，相对于另一个环境，但栈上有一些延迟操作。

and there's the second piece of the cycle there's where in fact we need the stack usage because this is a recursive

这就是循环的第二部分；事实上，这里我们需要使用栈，因为这是一个递归……

stack usage because this is a recursive process, not an iterative one, and what happens when we carry on? Well, basically we're going to run through the same kind of cycle to get the value of factorial of n minus 1 with respect to some environment. We're going to walk through the same cycle of dealing with this as an application, reducing a two-in-fact evaluation of a body which will eventually unwrap to the state shown at the bottom. We're going to have to get evaluation of factorial of n minus 1 with respect to a new environment for the different value of n.

因为这是一个递归过程，而不是迭代过程，所以需要使用栈。当我们继续时会发生什么？基本上，我们将经历同样的循环来得到阶乘n减1相对于某个环境的值。我们将经历同样的循环，将其视为一个应用，简化为对过程体的求值，最终会展开到底部所示的状态。我们将不得不对阶乘n减1相对于一个新环境进行求值，因为n的值不同。

environment for the different value of n, and on the stack will be now two saved operations will have the stack frame if you want to think of it that way at the bottom of the stack for the deferred operation for the top level multiplication you can see the procedure and the argument we're going to need.

因为n的值不同，而在栈上现在将有两个保存的操作。如果你愿意这样想的话，在栈的底部是用于顶层乘法的延迟操作的栈帧，你可以看到我们需要的过程和参数。

and on top of that at the top of the stack is another one that says we also need to do a multiplication by two of whatever we get out of this key point is to see how the stack is now growing gathering together information for each of the

而在其之上，栈顶还有另一个，表明我们还需要对我们从这个关键点得到的任何结果乘以2。关键在于看到栈是如何增长的，为每一个……

Together information for each of the deferred operations as we unwrap this recursive call into more and more evaluations of the body or the recursive call to the procedure with respect to a different environment. And indeed we can now see this top level unwrapping. Evaluating factorial of 3 with respect to the global environment reduces to evaluating factorial of what we know will be 2 with respect to a new environment with some deferred operations on the stack. Which unwinds one more time in this case, it has to be recursive. We have to keep track of those.

为每一个延迟操作收集信息，因为我们把这个递归调用展开为对过程体的更多求值，或对过程相对于不同环境的递归调用。事实上，我们现在可以看到这个顶层的展开。对阶乘3相对于全局环境的求值，简化为对阶乘（我们知道将是2）相对于一个新环境的求值，栈上有一些延迟操作。在这种情况下，它再次展开，必须是递归的。我们必须跟踪这些。

Recursive, we have to keep track of those deferred operations, and we see how the evaluator automatically puts them on the stack for us. Eventually, when we get down to the primitive application, we'll be able to start unwinding all of these deferred operations, reducing the stack back down.

递归的，我们必须跟踪那些延迟操作，我们看到求值器如何自动将它们放在栈上。最终，当我们到达原始应用时，我们将能够开始展开所有这些延迟操作，将栈缩减回去。

But the order of growth of the recursive procedure is now nicely shown by the growth of the stack shown in red. Are each of those stack frames corresponding to each deferred operation?

但是递归过程的增长阶现在很好地由红色显示的栈的增长所展示。每一个栈帧是否对应于每一个延迟操作？

And we also now see how the difference between a tail recursive call on an iterative procedure will allow us to

我们现在也看到了尾递归调用与迭代过程之间的区别将如何使我们能够……

iterative procedure will allow us to avoid that stock usage, but a recursive procedure that's inherently recursive we'll have to use the stack over.

迭代过程将使我们能够避免那种栈的使用，但一个本质上递归的递归过程将不得不使用栈。

Although we've now built our register.

尽管我们现在已经构建了我们的寄存器。