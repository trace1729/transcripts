# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=22)

## Summary (摘要)

- The lecture explains how to extend register machines from iterative algorithms to recursive ones by introducing subroutines, which are labeled instruction sequences that can be reused and called from multiple locations.
- A stack is introduced as a last-in-first-out memory device with save and restore operations, enabling subroutines to preserve register values and return points across recursive calls.
- Subroutines follow a contract that specifies input registers, output registers, which registers are overwritten, and the stack's net behavior, ensuring correctness when used in various contexts.
- Tail recursion optimization is presented as a technique to avoid stack usage for subroutine calls that require no post-call work, allowing recursive procedures to express iterative algorithms without consuming unbounded space.
- A detailed register machine implementation of factorial demonstrates how to save and restore registers on the stack before recursive calls, with the stack growing on descent and contracting on return, and the contract for factorial is defined as: inputs in N and continue, output in Val, no registers permanently overwritten, and stack unchanged.
- The stack's maximum depth corresponds to the space complexity of an algorithm, representing deferred operations, and this concept has modern relevance in asynchronous and cloud computing where deferring tasks optimizes resource use.

- 本讲座解释了如何通过引入子程序（即可以重复使用并从多个位置调用的带标签指令序列）将寄存器机器从迭代算法扩展到递归算法。
引入栈作为后进先出存储设备，具有保存和恢复操作，使子程序能够在递归调用中保留寄存器值和返回点。
- 子程序遵循一个契约，该契约指定输入寄存器、输出寄存器、哪些寄存器被覆盖以及栈的净行为，从而确保在不同上下文中使用的正确性。
- 尾递归优化作为一种避免在不需要调用后工作的子程序调用中使用栈的技术被提出，允许递归过程表达迭代算法而无需消耗无界空间。
- 一个详细的阶乘寄存器机器实现演示了如何在递归调用之前保存和恢复寄存器到栈上，栈在下降时增长，在返回时收缩，阶乘的契约定义为：输入在N和continue中，输出在Val中，没有寄存器被永久覆盖，栈保持不变。
- 栈的最大深度对应于算法的空间复杂度，代表延迟操作，这一概念在现代异步和云计算中具有相关性，其中延迟任务可以优化资源使用。

## Outline (大纲)

1. Introduction: from iterative to recursive register machines
2. Subroutine mechanism: labels, continue, and indirect branches
3. Subroutine contracts and rationale
4. Stack behavior and depth
5. Stack contracts and standard subroutine use
6. Tail call optimization and its importance
7. Recursive algorithms: implementing factorial
8. Saving and restoring registers: the general rule
9. Tracing factorial execution and unwinding the stack

1. 引言：从迭代到递归寄存器机器
2. 子程序机制：标签、continue和间接分支
3. 子程序契约及其原理
4. 栈行为与深度
5. 栈契约与标准子程序使用
6. 尾调用优化及其重要性
7. 递归算法：实现阶乘
8. 保存和恢复寄存器：一般规则
9. 追踪阶乘执行与栈展开

## Transcript (文稿)

### 1. Introduction: from iterative to recursive register machines (引言：从迭代到递归寄存器机器)

Initially, we also drew out data paths to show what registers were connected where, and how the flow control actually went through all of those pieces. But as we saw the controller, the sequence of instructions actually specifies both the connections and the order of flow, and therefore we're going to drop the notion of data paths and what we do from here on in.

最初，我们还绘制了数据路径，以显示寄存器之间的连接位置以及流控制如何通过这些部件。但正如我们所看到的控制器，指令序列实际上同时指定了连接和流顺序，因此我们将放弃数据路径的概念，从现在开始不再使用。

So last time, we built register machines that basically dealt with iterative algorithms. And today, we're going to push on to see what we need to add to create machines that can handle more complex tasks.

上次我们构建了基本上处理迭代算法的寄存器机器。今天，我们将继续推进，看看需要添加什么来创建能够处理更复杂任务的机器。

add to create machines that can handle recursive algorithms that's going to lead us towards embel because we know eval itself has to deal with recursive things so what we're going to see today are iterative algorithms again things we saw a last time like GCD but we're going to look at a couple other examples

添加什么来创建能够处理递归算法的机器，这将引导我们走向embel，因为我们知道eval本身必须处理递归的事情，所以今天我们将看到迭代算法，再次是我们上次看到的东西，如GCD，但我们还将看一些其他例子。

things like increment we're going to follow that with some examples like factorial that use not iterative constant space but recursive non constant space and we'll see that in order to have computations that involve that recursive behavior we're going to

像increment这样的东西，我们将接着看一些例子，如factorial，它不使用迭代的恒定空间，而是使用递归的非恒定空间，我们将看到为了进行涉及这种递归行为的计算，我们将不得不扩展我们的寄存器机器，加入子程序，而子程序特别需要一个地方来临时存储关于计算的信息，这将需要引入栈。现在没关系，我们在这个学期早些时候已经见过栈；现在我们将看到它们的一个非常基本的用途。

That recursive behavior we're going to have to extend our register machines with subroutines, and subroutines in particular are going to need a place to store temporarily information about the computation, and that's going to require the introduction of a stack. Now it's okay, we've seen stacks earlier in the term; now we're going to see a very fundamental use of those.

今天讲座的要点是，每个子程序都带有一个契约。这个契约帮助我们理解哪些信息必须临时存储，以及如何使用它。

What we'll see throughout the point of today's lecture is that every subroutine comes with a contract. That contract helps us understand both what information must be stored away temporarily and how to use it.

临时存储哪些信息，以及如何使用寄存器在需要时重建该状态，我们将看到栈是实现机制，使我们能够使该契约成立，并使递归算法能够在这个小型寄存器机器框架中计算。

stored away temporarily and how to use the registers to reconstruct that state when we need it and we'll see that stacks are the implementation mechanism for allowing us to fête to make that contract hold true and to enable recursive algorithms to be computed in this little register machine kind of framework

我们在普通Scheme中构建的过程经常希望重复使用相同的计算引擎来一遍又一遍地进行计算，无论我们拥有的是迭代过程还是递归过程，我们知道我们经常希望使用相同的计算来解决同一问题的不同版本，然后使用该结果来累积我们试图解决的总体问题的最终解决方案。

one of the things we've seen with procedures we've built in normal scheme is that we often want to reuse the same computational engine to do a computation over and over again whether we're having something that's an iterative or recursive procedure we know

在Scheme中，我们通过递归调用同一过程但使用不同参数来实现这一点。当我们要将其构建到寄存器机器中时，我们必须更加详细，这里我们将使用所谓的子程序。

### 2. Subroutine mechanism: labels, continue, and indirect branches (子程序机制：标签、continue和间接分支)

Iterative or recursive procedure we know that we often want to use the same computation to do a different version of the same problem and then use that result to accumulate the grand solution of the overall problem we're trying to solve.

迭代或递归过程，我们知道我们经常希望使用相同的计算来解决同一问题的不同版本，然后使用该结果来累积我们试图解决的总体问题的最终解决方案。

In Scheme, we do this with a recursive call to the same procedure with just different parameters. When we're going to build this into a register machine, we have to be a little more detailed, and here we're going to use what's known as the subroutine.

在Scheme中，我们通过递归调用同一过程但使用不同参数来实现这一点。当我们要将其构建到寄存器机器中时，我们必须更加详细，这里我们将使用所谓的子程序。

The idea of a subroutine is to create a sequence of instructions that can be

子程序的想法是创建一个指令序列，可以

A sequence of instructions that can be reused over and over again in other words, we can put in some values into input, then use this sequence of instructions and end up somewhere with an output value stored in some other register.

一个可以一遍又一遍重复使用的指令序列，换句话说，我们可以将一些值放入输入，然后使用这个指令序列，最终在某个其他寄存器中存储一个输出值。

To identify this sequence, we need a couple of things: we'll need to start with a label that marks the beginning of the subroutine, and we're going to need to end with an indirect branch that is a way of going off to some other place when we're done. Now, the reason we want an indirect branch is we need to be able

为了识别这个序列，我们需要几样东西：我们需要一个标记子程序开始的标签，并且我们需要以间接分支结束，这是一种在完成时转到其他某个地方的方式。现在，我们想要间接分支的原因是我们需要能够

An indirect branch is we need to be able to go to multiple places rather than always going back to the same place, which we do with the go-to as a consequence. A subroutine can be called from different places within the code.

间接分支是我们需要能够转到多个地方，而不是总是回到同一个地方，这是我们通过go-to所做的。因此，子程序可以从代码中的不同位置调用。

The idea is we set up some values in the input registers that the subroutine expects. We then set up a place to go to when we're done, jump to the subroutine, and at the end of that subroutine use the indirect branch to go back to the place we mark as being where we want it to be when we headed off to the subroutine. Now to make this work we're

其思想是，我们在输入寄存器中设置一些子程序所期望的值。然后我们设置一个完成后的返回位置，跳转到子程序，并在该子程序的末尾使用间接分支返回到我们标记的位置，即我们前往子程序时希望返回的地方。为了使这工作，我们

Subroutine now, to make this work, we're going to introduce two special instructions into our register machine language. The first one has the form shown here: a sign continued label, something in this case, after call 1. What does this do? Well, it puts a mark into the register continue of a very particular thing. In fact, what it does is it stores the instruction number corresponding to that label in that register.

子程序，现在，为了使这工作，我们将在寄存器机器语言中引入两条特殊指令。第一条的形式如下所示：一个标签，后面跟着 continue，在这种情况下，在 call 1 之后。这是做什么的？嗯，它将一个标记放入 continue 寄存器中，这个标记是一个非常特殊的东西。事实上，它做的是将与该标签对应的指令编号存储在该寄存器中。

Why would we want to do this? Well, basically what this is doing is putting an instruction number, which we call the return point, into a

我们为什么要这样做？嗯，基本上这是将一个指令编号（我们称之为返回点）放入一个

which we call the return point into a register that's designed exactly to hold that it's labeling a place in the instruction sequence that I want to come back to after I've gone off and done the work of the subroutine so the idea is that I'm getting along in my computation I've set up a point where I want to use some machinery that somewhere else I put a marker in that says come back to here when you're done with that work in that answer so that I can then go off to that subroutine and at the very end return back to this point and pick up the rest.

我们称之为返回点，放入一个专门设计用来保存它的寄存器中，它标记了指令序列中的一个位置，我希望在完成子程序的工作后回到那里。所以想法是，我在计算过程中，设置了一个点，我想使用某些机制，而我在其他地方放置了一个标记，说“当你完成那项工作后回到这里”，这样我就可以去那个子程序，并在最后返回到这个点，继续执行其余部分。

Back to this point and pick up the rest of the computation. As we said, we'll use the continued register to mark exactly this kind of return point. Here's where I want to come back to when I'm done with this particular sub computation.

回到这个点，继续执行其余的计算。正如我们所说，我们将使用 continue 寄存器来标记这种返回点。这就是我完成这个特定子计算后想要回到的地方。

Typically, we'll use this instruction just before we actually head off or jump to the label that begins the subroutine. And we'll use the mark immediately after that instruction.

通常，我们会在实际前往或跳转到子程序开始的标签之前使用这条指令。并且我们会在该指令之后立即使用这个标记。

So the idea is, we set up anything we want to use in the subroutine call, we mark in where we want to come back to, and we can jump off to that piece of the instruction sequence.

所以想法是，我们设置好子程序调用中要使用的任何东西，标记我们想要返回的位置，然后就可以跳转到指令序列的那一部分。

piece of the instruction sequence that does the subroutine and we'll come back to the point right after this point when we're ready to return. Now to actually come back we need a second special instruction, the form is go to register continue.

指令序列中执行子程序的那一部分，当我们准备好返回时，我们会回到这个点之后的位置。现在，为了实际返回，我们需要第二条特殊指令，其形式是“转到寄存器 continue”。

And what is this - it gets the contents of the continue register, which is one of these instruction numbers, a pointer to a place in the instruction sequence, and we go straight to that place. This is called an indirect branch, and notice what it does: it branches unconditionally, that is going to branch no matter what tests are.

这是什么——它获取 continue 寄存器的内容，这是一个指令编号，一个指向指令序列中位置的指针，然后我们直接转到那个位置。这被称为间接分支，注意它的作用：它无条件分支，也就是说，无论测试结果如何，它都会分支。

Going to branch no matter what tests are going on, but it's going to branch not to a particular pre-specified point but to an indirect point. The point pointed to by wherever continue says, and the actual effect is to change the program counter to the value stored in the register continue, and then go to that place to pick things up.

无论进行什么测试，它都会分支，但它不是分支到一个预先指定的特定点，而是分支到一个间接点。这个点由 continue 所指向的位置决定，实际效果是将程序计数器更改为 continue 寄存器中存储的值，然后转到那个位置继续执行。

So here are the two pieces we need for a subroutine now. Let's turn to an example to see how they make sense. Let's examine these ideas with a very simple little subroutine called increment. Basic idea we'll set a

所以这就是我们实现子程序所需的两部分。现在让我们看一个例子，看看它们如何运作。让我们用一个非常简单的子程序来检验这些想法，这个子程序叫做 increment。基本思想是，我们将设置一个

called increment basic idea we'll set a

叫做 increment，基本思想是，我们将设置一个

called increment basic idea we'll set a register sum to zero then we'll increment it by one then we'll increment the gain and we're going to look at some control sequences to do this what we'll show is that in fact we're going to set up a call to the subroutine we're going to set up a label which is the place we're going to and we're going to set up an indirect jump to get back and let's look at that actual example so here's the register machine code and let's look carefully at what goes on here first instruction basically initializes the sum register to the constant 0 it 0 is

叫做 increment，基本思想是，我们将设置一个寄存器 sum 为零，然后将其加一，然后再加一，我们将看一些控制序列来实现这一点。我们将展示的是，事实上，我们将设置对子程序的调用，我们将设置一个标签作为我们要去的地方，并设置一个间接跳转来返回，让我们看看那个实际的例子。所以这是寄存器机器代码，让我们仔细看看这里发生了什么。第一条指令基本上将 sum 寄存器初始化为常量 0，它是

sum register to the constant 0 it 0 is. sum register to the constant 0 it 0 is. it out to set things going that's fine. it out to set things going that's fine. it out to set things going that's fine.

sum 寄存器初始化为常量 0，它是。sum 寄存器初始化为常量 0，它是。它开始运行，这没问题。它开始运行，这没问题。它开始运行，这没问题。

the next thing we want to do is use a. the next thing we want to do is use a. the next thing we want to do is use a subroutine the increment subroutine and. subroutine the increment subroutine and. subroutine the increment subroutine and. that's marked within the dotted line. that's marked within the dotted line. that's marked within the dotted line down at the bottom notice what it. down at the bottom notice what it. down at the bottom notice what it consists of it has a label a pointer. consists of it has a label a pointer. consists of it has a label a pointer.

接下来我们要做的是使用一个。接下来我们要做的是使用一个。接下来我们要做的是使用一个子程序，即 increment 子程序，并且。子程序，即 increment 子程序，并且。子程序，即 increment 子程序，并且。它被标记在虚线内。它被标记在虚线内。它被标记在虚线内，在底部，注意它。在底部，注意它。在底部，注意它由什么组成，它有一个标签，一个指针。由什么组成，它有一个标签，一个指针。由什么组成，它有一个标签，一个指针。

that says here's how to start into it it. that says here's how to start into it it. that says here's how to start into it it. has a set of instructions in this case. has a set of instructions in this case. has a set of instructions in this case just one that puts into the sum register. just one that puts into the sum register. just one that puts into the sum register the result of adding whatever's in sum. the result of adding whatever's in sum. the result of adding whatever's in sum to the constant one and then it has an. to the constant one and then it has an. to the constant one and then it has an.

它说这是如何开始进入它的。它说这是如何开始进入它的。它说这是如何开始进入它的。它有一组指令，在这种情况下。它有一组指令，在这种情况下。它有一组指令，在这种情况下，只有一个，它将 sum 寄存器设置为。只有一个，它将 sum 寄存器设置为。只有一个，它将 sum 寄存器设置为将 sum 中的内容。将 sum 中的内容。将 sum 中的内容与常量 1 相加的结果，然后它有一个。与常量 1 相加的结果，然后它有一个。与常量 1 相加的结果，然后它有一个。

indirect jump it says go to wherever the. indirect jump it says go to wherever the. indirect jump it says go to wherever the continue register is pointing to an. continue register is pointing to an.

间接跳转，它说转到 continue 寄存器所指向的任何地方。间接跳转，它说转到 continue 寄存器所指向的任何地方。间接跳转，它说转到 continue 寄存器所指向的任何地方。

continue register is pointing to an indirect branch. This in fact is the form of a subroutine, a label and entry point to start a sequence of instructions, and an indirect branch taking us back to whoever called this actual instruction.

continue 寄存器所指向的地方，这是一个间接分支。这实际上就是子程序的形式：一个标签作为入口点来开始一系列指令，以及一个间接分支将我们带回调用者。

Now, how do we call it? Well, that's shown in blue. We put into the continue register a label that says "come back to here when you're done," and then we go to that point. We jump to the subroutine.

那么，我们如何调用它呢？嗯，这用蓝色显示。我们将一个标签放入 continue 寄存器，说“完成后回到这里”，然后我们转到那个点。我们跳转到子程序。

Notice what will happen. Subroutine increment will do work and then come back to wherever the continue register is pointing.

注意将会发生什么。increment 子程序将执行工作，然后回到 continue 寄存器所指向的任何地方。

register continuous pointing and as long as we don't screw things up with continued that is going to point to after call one and notice we have placed that label immediately after that go-to we don't always do that but that's the most common form so the form of the call is set up the return point set up in principle any other arguments when we might need for the subroutine jump to the subroutine and have that return point immediately followed this means when we come back to that return point subroutine increment will have done its work since in this case we wanted in to

寄存器持续指向该位置，只要我们不用 `continue` 把事情搞砸，它就会指向 `call one` 之后的那个标签，注意我们把那个标签紧跟在那个 `go-to` 之后，我们并不总是这样做，但这是最常见的形式。所以调用的形式是：设置返回点，原则上设置我们可能需要的任何其他参数，跳转到子程序，并且让返回点紧跟在后面。这意味着当我们回到那个返回点时，子程序 `increment` 已经完成了它的工作，因为在这个例子中我们想让 `in` 增加两次，我们做完全相同的事情：设置一个新的返回点到 `continue`，跳转到子程序 `increment`，当它完成时，它回到那个返回点，现在我们就准备好了，我们可以带着我们的答案去标签 `done`，正如我们所期望的那样。

### 3. Subroutine contracts and rationale (子程序的契约与原理)

work since in this case we wanted into increment twice we do exactly the same thing we set up a new return point into continue we jump to the subroutine increment when it's done it comes back to that return point and now we're set we can go off to the label done with our answer holding in sum as we'd expect it.

因为在这个例子中我们想让 `in` 增加两次，我们做完全相同的事情：设置一个新的返回点到 `continue`，跳转到子程序 `increment`，当它完成时，它回到那个返回点，现在我们就准备好了，我们可以带着我们的答案去标签 `done`，正如我们所期望的那样。

so now we see the format of this subroutine subroutine itself consists of an increment or so rather a label that's an entry point a sequence of instructions that does the work followed by an indirect jump that takes us back.

所以现在我们看到了这个子程序的格式：子程序本身由一个 `increment` 或类似的东西组成，更确切地说，是一个作为入口点的标签，一个执行工作的指令序列，后面跟着一个间接跳转，把我们带回去。

by an indirect jump that takes us back to the caller that actually set things up, and the actual call initializes the continue register with the return point, jumps to that subroutine, and has the return point immediately following to bring us back to where we were.

通过一个间接跳转把我们带回实际设置好一切的调用者，而实际的调用用返回点初始化 `continue` 寄存器，跳转到那个子程序，并且让返回点紧跟在后面，把我们带回原来的位置。

We can generalize the idea of a subroutine, we can formalize it into a more global kind of behavior which we're going to reuse multiple times as we build more and more complex register machines.

我们可以推广子程序的概念，将其形式化为一种更全局的行为，随着我们构建越来越复杂的寄存器机器，我们将多次重用这种行为。

Each subroutine has as a consequence a contract, and if we're going to use the subroutine properly we need to follow.

每个子程序因此都有一个契约，如果我们想正确使用子程序，就需要遵循这个契约。

subroutine properly we need to follow that contract where we have no guarantee that the register machine won't fail in some very unfortunate and catastrophic way.

如果我们不遵循那个契约，我们就无法保证寄存器机器不会以某种非常不幸和灾难性的方式失败。

what's the contract the contract involves a set of registers first specifying what registers will contain the input values and the return point second what registers will hold the output that's produced and notice it's plural it might be more than one and third all the registers that will be overwritten that is any register whose value is going to be changed in addition to the output registers now you can see

契约是什么？契约涉及一组寄存器：首先，指定哪些寄存器将包含输入值和返回点；其次，哪些寄存器将保存产生的输出，注意是复数，可能不止一个；第三，所有将被覆盖的寄存器，即除了输出寄存器之外，任何值将被改变的寄存器。现在你可以看到

to the output registers now you can see already why this contract is important by specifying the input values and the return point registers that tells us what things we have to set up before we use the subroutine what values we have to install in order to have the subroutine do its thing by specifying what registers are going to contain the output we know where to look for the value when they're actually done now by specifying what registers will be overwritten we know what things may get damaged along the way we'll come back to that shortly when we see how to keep

除了输出寄存器之外，现在你已经可以看出为什么这个契约很重要了。通过指定输入值和返回点寄存器，它告诉我们在使用子程序之前必须设置什么，必须安装什么值才能让子程序完成它的工作。通过指定哪些寄存器将包含输出，我们知道当它们实际完成时去哪里找值。通过指定哪些寄存器将被覆盖，我们知道哪些东西可能会在过程中被损坏。我们稍后会回到这一点，当我们看到如何保持

that shortly when we see how to keep track of or contain values that we're going to need later on even though the registers themselves may get corrupted along the way. So in the case of our little increment subroutine, we can now specify the contract.

稍后当我们看到如何跟踪或保存我们以后需要的值时，即使寄存器本身可能在过程中被破坏。所以在我们的小 `increment` 子程序的情况下，我们现在可以指定契约。

The contract for increment says the following in terms of input it expects two registers, sum, which we know has to be initialized to something, and continue, which is going to hold the return point. Where's the output? It's also going to be in sum, as we saw by this little sequence of operations.

`increment` 的契约如下：在输入方面，它期望两个寄存器，`sum`，我们知道它必须被初始化为某个值，以及 `continue`，它将保存返回点。输出在哪里？它也在 `sum` 中，正如我们通过这一小系列操作所看到的。

By this little sequence of operations we follow through and what gets written—well, in this case, nothing other than the output register itself, which of course we know is going to get overwritten because that's where the output value lists. So there's the contract that increment deals with in terms of expected input registers, output register that holds values, and anything else that may change along the way.

通过这一小系列操作我们跟踪了执行过程，什么被写入——嗯，在这种情况下，除了输出寄存器本身之外没有其他东西，当然我们知道输出寄存器会被覆盖，因为那是输出值所在的地方。所以这就是 `increment` 处理的契约，包括期望的输入寄存器、保存值的输出寄存器，以及任何其他可能改变的东西。

To summarize this part, we've built subroutines, we describe what they consist of, and we've looked at some simple examples. Why do we need them? Well, several reasons. First of...

总结这部分，我们构建了子程序，描述了它们的组成，并看了一些简单的例子。我们为什么需要它们？嗯，有几个原因。首先……

Need them for several reasons. First of all, they allow us to reuse instructions. They let us reuse the same computational engine to do the same performance but just with different input values. As a consequence, they're also going to let us reuse the same data paths, which means we don't need additional machinery to do the same kind of work.

我们需要它们有几个原因。首先，它们允许我们重用指令。它们让我们重用相同的计算引擎来执行相同的操作，只是使用不同的输入值。因此，它们也让我们重用相同的数据路径，这意味着我们不需要额外的机制来做同样的工作。

We can also guess they're going to make instruction sequences more readable. It's just like having helper functions in scheme; we now have a way of making the instructions compact and capturing or modularizing them.

我们也可以猜测它们会使指令序列更易读。就像在 Scheme 中有辅助函数一样，我们现在有了一种使指令紧凑并捕获或模块化它们的方法。

compact and capturing or modularizing the pieces that do different kinds of components as we'll also see very shortly. Using subroutines is going to allow us to support recursion, perhaps the most important reason as we build towards a register machine version of eval and we've seen and will certainly see shortly.

紧凑并捕获或模块化执行不同种类组件的部分，我们很快也会看到。使用子程序将使我们能够支持递归，也许这是最重要的原因，因为我们正在构建一个寄存器机器版本的 `eval`，我们已经看到并且肯定很快就会看到。

In order to have a good handle on understanding subroutines, we talk about the contract associated with each such subroutine. That contract specifies the input registers, the output registers, and any other registers that will be

为了很好地理解子程序，我们讨论了与每个子程序相关联的契约。该契约指定了输入寄存器、输出寄存器以及任何其他将被覆盖的寄存器。

and any other registers that will be overwritten as part of the actual computation of the subroutine. The second thing we're going to need in order to build register machines that support recursion is a stack.

以及任何其他在子程序实际计算过程中被覆盖的寄存器。为了构建支持递归的寄存器机器，我们需要的第二件事是一个栈。

### 4. Stack behavior and depth (栈的行为与深度)

Now we saw stacks earlier in the term when we talked about abstract data types. A stack was a particular kind of storage capability or data type. In particular, it was a last in, first out data structure in which the last thing saved into the stack was the first thing that we took out of the stack.

我们在学期早些时候讨论抽象数据类型时见过栈。栈是一种特殊的存储能力或数据类型。特别地，它是一种后进先出的数据结构，其中最后保存到栈中的东西是第一个从栈中取出的东西。

Here a stack is a very particular kind of memory device.

在这里，栈是一种非常特殊的存储设备。

kind of memory device dealing with registers and it has two operations we can save or register on to the stack this will send the value that register on to the next place on the stack and we can restore a value into a register that is literally get a value from the top of the stack and put it into a designated register notice that the only operations we can do on the stack or to save onto the top of the stack and restore from the top of the stack we cannot access arbitrary locations within the stack we can only get to the objects at the top

一种处理寄存器的存储设备，它有两种操作：我们可以将寄存器中的值保存到栈上，这会把该寄存器的值发送到栈的下一个位置；我们也可以将值恢复到寄存器中，这实际上是从栈顶取出一个值并放入指定的寄存器。注意，我们对栈能做的操作只有保存到栈顶和从栈顶恢复，我们不能访问栈中的任意位置，只能访问栈顶的对象。

can only get to the objects at the top of the stack here's a simple little example machine shown in terms of its data paths the couple of constants that can be loaded into some registers and the ability to move things in to and from the stack through those registers

只能访问栈顶的对象。这里有一个简单的示例机器，以其数据通路的形式展示：有几个常量可以加载到某些寄存器中，并且能够通过这些寄存器在栈和寄存器之间移动数据。

and here's a controller that goes with that that specifies the order in which things will be moved around this says basically put the constant 0 into register a put the constant 5 into register B then take the contents of register a and store them onto the top of the stack finally restore from the

这是与之配套的控制器，它规定了数据移动的顺序。它基本上是说：将常量0放入寄存器A，将常量5放入寄存器B，然后取寄存器A的内容并将其保存到栈顶，最后从栈顶恢复。

Of the stack finally restore from the top of the stack into register B and notice what that will do. The value from A, which was 0, was put into the top of the stack when we store into B. That value is written into B, over writing the 5 that was stored there and putting a 0 into B itself.

最后从栈顶恢复到寄存器B。注意这将产生什么效果：来自A的值（即0）被放入栈顶，当我们存储到B时，该值被写入B，覆盖了原来存储在那里的5，并将0放入B。

Here we're saving from one register and restoring into a different one. We'll see that that's not always the kind of contract we want to follow. More typically, we will save and restore into the same register, but this shows the idea of saving something.

这里我们从一个寄存器保存，恢复到另一个不同的寄存器。我们会看到，这并不总是我们想要遵循的约定。更典型的是，我们将保存和恢复到同一个寄存器，但这个例子展示了保存某些东西的思想。

Shows the idea of saving something temporarily on the stack and then restoring that value back into one of the registers of the machine itself.

展示了将某些东西临时保存在栈上，然后将该值恢复到机器的一个寄存器中的思想。

Now, a stack of course isn't just one register deep, as we saw in that earlier example. It can hold many values in fact, as many as we want to put into it. And it has this last-in, first-out behavior: the last thing put into the stack is the first thing taken out, much like a stack of dishes can only be pushed down from the top and taken off from the top.

当然，栈不仅仅是一个寄存器深度，正如我们在前面的例子中看到的。它可以容纳许多值，事实上，可以容纳我们想放入的任意多个值。它具有后进先出的行为：最后放入栈中的东西最先被取出，就像一叠盘子只能从顶部压下，也只能从顶部取走。

Here's a little machine that we want to look at to see this example. This is a...

这里有一个我们想查看的小机器，以了解这个例子。这是一个……

look at to see this example this is a machine that halts with a 5 in a in a 0 MB and here's the control sequence for it notice what it does it initializes a zero in register a a 5 and register B then saves a followed by B on the stack and then restores first into a and then into B now we're going to look carefully this because notice because of the firt lastin first-out behavior the value that was in b that saved in line three is going to be the value restored into register a we're going to reverse the actual order of the two constants in a

查看这个例子。这是一个以A中为5、B中为0而停机（halt）的机器，这是它的控制序列。注意它的操作：它初始化A寄存器为0，B寄存器为5，然后将A和B依次保存到栈上，接着先恢复到A，再恢复到B。现在我们要仔细查看，因为注意，由于后进先出的行为，在第3行保存的B中的值将被恢复到寄存器A中。我们将颠倒A和B中两个常量的实际顺序。

actual order of the two constants in a

A和B中两个常量的实际顺序

actual order of the two constants in a and B let's check this out in particular and B let's check this out in particular and B let's check this out in particular let's step through the controller and look at the contents of the stack after each step so instruction zero puts a constant zero into a in structure one puts the constant five into be an instruction to then takes the contents of register a which is a zero and saves it on to the top of the stack

A和B中两个常量的实际顺序。让我们特别检查一下。让我们逐步执行控制器，并查看每一步之后栈的内容。指令0将常量0放入A，指令1将常量5放入B，指令2取寄存器A的内容（即0）并将其保存到栈顶。

instruction three then saves the contents of B onto the top of the stack that pushes a 5 on to the stack dropping zero down one and notice the state of the stack they're fives on the top zeros

指令3然后将B的内容保存到栈顶，这将5压入栈，将0向下推一层。注意栈的状态：顶部是5，下面是0。

the stack they're fives on the top zeros below it as a consequence at instruction 4 we take what's on the top of the stack and restore it in this case into a putting the 5 into a and finally an instruction 5 we take the contents at the top of the stack zero and restore that into register B leaving an empty stack behind.

栈的状态：顶部是5，下面是0。因此，在指令4，我们取栈顶的内容并恢复，在这种情况下恢复到A，将5放入A；最后在指令5，我们取栈顶的内容0并恢复到寄存器B，留下一个空栈。

to check that you're getting this try the following simple little example here's the beginning of a controller a sequence of six different instructions draw the state of the stack after step five and in particular note.

为了检查你是否理解，尝试以下简单的例子：这是一个控制器的开头，包含六个不同的指令序列。画出第5步之后栈的状态，并特别注意。

After step five, in particular note what's at the top of the stack when you're ready to see the answer, go ahead and click the mouse. The other thing we'd like you to do is to figure out what restores you want to add so that the final state is to have a three, an A of 5, and B and an eight, and C, and the stack empty. And again, we'll show you both answers when you're ready to go.

在第5步之后，特别注意栈顶是什么。当你准备好查看答案时，请点击鼠标。我们还想让你做的是，确定你需要添加哪些恢复操作，以使最终状态为：A中为3，B中为5，C中为8，并且栈为空。同样，当你准备好时，我们会展示两个答案。

So here you are, the state of the stack is easy to see. B is the first thing saved, so it's going to be at the bottom of the stack—that's the 3. C was the second thing saved, it's now at the middle of the stack.

所以，这就是答案。栈的状态很容易看出。B是第一个被保存的，所以它将在栈底——那是3。C是第二个被保存的，现在它在栈的中间。

thing saved it's now at the middle of the stack that's the 5 and a was the last thing safe so it's at the top of the stack that's the eight to get things back in the places we want them to we want the 8 and C so we'll restore it first followed by a five back in B followed by a three into a to get things into the places we want.

第二个被保存的，现在它在栈的中间——那是5。A是最后一个被保存的，所以它在栈顶——那是8。为了将东西放回我们想要的位置，我们希望8在C中，所以我们将首先恢复它，然后是5回到B，最后是3回到A，以将东西放到我们想要的位置。

having now created stacks seen how to use stacks as part of register machines there are several things we need to worry about in order to start connecting them up towards our recursive procedures of all we have to talk about what a

既然我们已经创建了栈，并看到了如何将栈用作寄存器机器的一部分，为了开始将它们连接到我们的递归过程，有几件事我们需要考虑。首先，我们必须讨论什么是……

### 5. Stack contracts and standard subroutine use (栈约定与标准子程序使用)

首先，我们需要讨论栈深度意味着什么，稍后我们会详细进行。其次，我们将探讨栈与子程序之间的关系。我们之前已经看到，子程序会跟踪哪些寄存器在它们执行工作时会被覆盖，我们准备将栈用作一个临时存储位置，用来存放这些寄存器中的值，这样它们就不会在覆盖过程中丢失。最后，我们会研究一种特定的优化方法，它有助于我们高效地使用栈。

首先，我们需要讨论栈深度意味着什么，稍后我们会详细进行。其次，我们将探讨栈与子程序之间的关系。我们之前已经看到，子程序会跟踪哪些寄存器在它们执行工作时会被覆盖，我们准备将栈用作一个临时存储位置，用来存放这些寄存器中的值，这样它们就不会在覆盖过程中丢失。最后，我们会研究一种特定的优化方法，它有助于我们高效地使用栈。

helps us use stacks very effectively in order to make recursive procedures work extremely well. First, in talking about a stack, we want to refer to its depth, which we define as the number of values that it currently contains. In fact, at any point while the machine is executing, the depth of the stack will simply be the total number of saves that have been used on the stack minus the total number of restores.

有助于我们非常有效地使用栈，以使递归过程能够极其良好地工作。首先，在讨论栈时，我们想提及它的深度，我们将其定义为它当前包含的值的数量。事实上，在机器执行的任何时刻，栈的深度将简单地是栈上已使用的保存总数减去恢复总数。

because it's the last in first out data structure that makes sense. We can only restore things that have been saved. If we try and do more than that, we're going to get an error.

因为这是后进先出的数据结构，所以这是合理的。我们只能恢复那些已被保存的东西。如果我们尝试做更多，我们将会遇到错误。

than that we're going to get an error and of course the things left on the stack the depth of the stack are simply those things that have been saved and not yet restored therefore the limits on the stack depth are easy to determine at the low end is zero if we try and restore something off of an empty stack we're clearly going to be in trouble and the machine will fail at the high end basically there's no limit other than the total amount of memory available and as a consequence we can often then talk about the maximum stack depth associated with a particular

而不是我们会得到错误，当然留在栈上的东西，栈的深度，就是那些已保存但尚未恢复的东西。因此，栈深度的限制很容易确定：下限是零，如果我们试图从空栈中恢复某些东西，显然会遇到麻烦，机器会失败；上限基本上没有限制，除了可用内存的总量。因此，我们常常可以谈论与特定计算相关的最大栈深度。

stack depth associated with a particular computation this measures the space required by an algorithm and in fact we're going to see there's a nice relationship between this maximum stack depth of a particular computation and the orders of growth we talked about much earlier in the term in terms of space required as we're about to see stacks go hand-in-hand with subroutines in fact if we think about a subroutine this is a piece of computation that's going to do some work we put some inputs into certain registers do some working in and out put out of that out of the

与特定计算相关的栈深度，这衡量了算法所需的空间。事实上，我们将看到，特定计算的最大栈深度与我们学期早些时候讨论的增长率之间，在所需空间方面存在一种良好的关系。正如我们即将看到的，栈与子程序紧密相连。事实上，如果我们考虑一个子程序，这是一段将要执行某些工作的计算，我们将一些输入放入某些寄存器，进行一些进出操作，并将输出放入指定的寄存器。

In and out, put out of that, out of the register that we specify. Now, if as any part of that subroutine contract we need to use some registers, we'll need to save away the values in those registers while we do that work, and that's where the stack comes in.

进出操作，将输出放入我们指定的寄存器。现在，如果作为该子程序契约的一部分，我们需要使用某些寄存器，我们就需要在执行该工作时保存这些寄存器中的值，这就是栈的用武之地。

We can save away temporarily on the stack values of registers we may need later on, go off and do the work of the subroutine, then come back and restore the stack to the point it was returning those values. So, in fact, a standard way of dealing with this is to have the contract for a subroutine.

我们可以临时将可能稍后需要的寄存器值保存在栈上，去执行子程序的工作，然后恢复栈到返回这些值时的状态。因此，实际上，处理这个问题的一种标准方式是让子程序的契约包含这些信息。

is to have the contract for a subroutine also include information about what happens to the stack typically that contract will look like this the one that we use for increment in fact increments kind of a cheat because we don't really need the stack here but nonetheless the contract still holds. this contract says here are the input registers are we going to expect values in here's the output register I'm going to deal with and here's the things I'm going to write to and the stack itself will be unchanged meaning the stack will be back into the form it was before.

让子程序的契约也包含关于栈会发生什么的信息。通常，该契约看起来像这样：我们用于 increment 的那个契约实际上有点取巧，因为我们在这里并不真正需要栈，但契约仍然成立。这个契约说明：这里是输入寄存器，我们期望在其中放入值；这里是输出寄存器，我将处理它；这里是我将要写入的东西；而栈本身将保持不变，意味着栈将恢复到之前的形式。

be back into the form it was before. be back into the form it was before subroutine was called when I get to the end of the subroutine in the middle of that process the stack may actually be used in some ways as part of that subroutine but the state will be returned to its original state in other words whatever was the state of the stack before I went to the subroutine call no matter what happens to the stack in the meantime during that subroutine call when I come to that exit point for the subroutine the stack will be back to the same state it was before. occasionally it will be valuable to us

恢复到之前的形式。恢复到子程序被调用之前的形式。当我到达子程序的末尾时，在这个过程中栈可能实际上以某种方式被用作子程序的一部分，但状态将恢复到其原始状态。换句话说，无论在我进行子程序调用之前栈的状态是什么，无论在此期间栈发生了什么，当我到达子程序的出口点时，栈将恢复到之前相同的状态。偶尔，对我们来说，采用稍微不同的栈和子程序契约会很有价值。

occasionally it will be valuable to us to do a slightly different contract for stacks and subroutines. Here's a strange little procedure: an entry point named 'strange' followed by an operation that puts into the register Val some new value, then restores a thing into the continued register and goes to that point.

偶尔，对我们来说，采用稍微不同的栈和子程序契约会很有价值。这里有一个奇怪的小过程：一个名为“strange”的入口点，后面跟着一个操作，将一个新值放入寄存器 Val，然后恢复一个东西到 continue 寄存器，并跳转到那个点。

And notice what that has to say about the contract here: the input is not only a value in the register Val, but it also requires a return point on the top of the stack. That's where that restore is going to come in the output for this.

注意这对契约意味着什么：输入不仅是寄存器 Val 中的一个值，还要求在栈顶有一个返回点。这就是恢复操作将要获取输入的地方。对于这个输出，

is going to come in the output for this

对于这个输出，

is going to come in the output for this contract is vowel of course that's where contract is vowel of course that's where contract is vowel of course that's where I'm putting a value what is it right I'm putting a value what is it right I'm putting a value what is it right

对于这个输出，契约是 Val，当然，那是契约是 Val，当然，那是契约是 Val，当然，那是我放置值的地方，对吧？我放置值的地方，对吧？我放置值的地方，对吧？

well notice it writes the continue well notice it writes the continue well notice it writes the continue register is going to put something into register is going to put something into register is going to put something into the continue register over writing the continue register over writing the continue register over writing whatever was there before and therefore whatever was there before and therefore whatever was there before and therefore the state of the stack has also now the state of the stack has also now the state of the stack has also now changed the top element is removed so changed the top element is removed so changed the top element is removed so

注意它写入了 continue，注意它写入了 continue，注意它写入了 continue 寄存器，将某些东西放入寄存器，将某些东西放入寄存器，将某些东西放入 continue 寄存器，覆盖了之前的内容，覆盖了之前的内容，覆盖了之前的内容，因此栈的状态也发生了变化，栈的状态也发生了变化，栈的状态也发生了变化，顶部元素被移除，所以顶部元素被移除，所以顶部元素被移除，所以

this contract involves an interaction this contract involves an interaction this contract involves an interaction between the subroutine itself and the between the subroutine itself and the between the subroutine itself and the stack we'll see shortly why we stack we'll see shortly why we stack we'll see shortly why we occasionally want to use this somewhat occasionally want to use this somewhat occasionally want to use this somewhat unusual contract rather than the unusual contract rather than the unusual contract rather than the standard one in which the stack is

这个契约涉及子程序本身与栈之间的交互，这个契约涉及子程序本身与栈之间的交互，这个契约涉及子程序本身与栈之间的交互。我们很快就会看到为什么我们偶尔想要使用这种有点不寻常的契约，而不是标准的契约，在标准契约中，栈在子程序调用前后保持不变。

standard one in which the stack is unchanged from before and after the actual subroutine call now as we've said the typical use of a subroutine in the stack would be as follows we know that the subroutine is going to need certain registers set up and that is going to overwrite certain registers as part of its process so we'll save away on the stack the values of any of those registers so that we can get them back when we're done we'll set up new values into those registers that are needed by the subroutine then put in a return point to continue and head off to that subroutine

标准的契约，在子程序调用前后栈保持不变。正如我们所说，子程序和栈的典型用法如下：我们知道子程序需要设置某些寄存器，并且在其过程中会覆盖某些寄存器，因此我们将这些寄存器的值保存在栈上，以便在完成后取回它们；然后为子程序所需的寄存器设置新值；接着放入一个返回点以继续执行，并跳转到该子程序。

continue and head off to that subroutine. When we come back from that subroutine, we can restore off the stack the values into the registers that we saved away, and continue with the rest of that process. That's the common form of an interaction between a subroutine and a stack: save away what I'm going to overwrite and I might need later on, set up new values, go and do the work, and upon return restore the stack back to its normal state, capturing back the values of those registers I saved away.

继续并跳转到那个子程序。当我们从那个子程序返回时，我们可以从栈中恢复我们保存到寄存器中的值，并继续该过程的其余部分。这是子程序与栈之间交互的常见形式：保存我将要覆盖但之后可能需要的内容，设置新值，去执行工作，并在返回时将栈恢复到其正常状态，取回我保存的那些寄存器的值。

### 6. Tail call optimization and its importance (尾调用优化及其重要性)

While this is being very careful, occasionally it's wasteful and it's

虽然这样做非常谨慎，但有时它是浪费的，而且它

occasionally it's wasteful and it's wasteful when we get to something that's known as a tail call. A tail call occurs when there's no work to be done after the call to the subroutine except simply going back to wherever register continue says - in other words except for doing the indirect branch.

有时它是浪费的，当我们遇到所谓的尾调用时，这种浪费就出现了。尾调用发生在调用子程序之后没有工作要做，除了简单地返回到 continue 寄存器所指向的地方——换句话说，除了执行间接分支之外。

Let's look at a little example. Suppose I want to use my increment subroutine. I'm going to initialize the sum register that's part of the contract. I got to get a value in there and then I'm going to initialize as well the return point the continue.

让我们看一个小例子。假设我想使用我的增量子程序。我将初始化 sum 寄存器，这是契约的一部分。我必须在那里放入一个值，然后我还要初始化返回点，即 continue 寄存器。

as well the return point the continue register but of course I may be in the middle of some other computation so I better save away what's on the continue register so I can get it back therefore I'm going to use the stack to hold the current value of the continue register.

还要初始化返回点，即 continue 寄存器，但当然我可能正处于其他计算的中间，所以我最好保存 continue 寄存器上的内容，以便我能取回它，因此我将使用栈来保存 continue 寄存器的当前值。

followed by an assignment of a new return point so that I can head off to the increment label now when I'm done with that increment computation I'll come back to that return point after call in which case I can restore the continue register from the stack put it

接着分配一个新的返回点，这样我就可以跳转到 increment 标签。现在当我完成增量计算后，我会返回到调用后的那个返回点，此时我可以从栈中恢复 continue 寄存器，将其放回，然后直接跳转到那个返回点。

continue register from the stack put it back in and then just head to that but if we think about this this is wasteful returning to this point is just a temporary holding station while I restore continuing returned at that point I'm not doing any work and in fact I should be able to go straight to that return point rather than coming back to here so a much more efficient piece of register machine code would simply do the following it would set up an initial value into some exactly what I would need it would then recognize that when I'm done with

从栈中恢复 continue 寄存器，将其放回，然后直接跳转到那个返回点。但如果我们仔细想想，这是浪费的，返回到这个点只是一个临时的中转站，而我恢复 continue 后，在那个点我并没有做任何工作，事实上我应该能够直接跳转到那个返回点，而不是回到这里。所以更高效的寄存器机器代码应该简单地做以下事情：设置初始值到某个寄存器，正是我所需要的，然后认识到当我完成增量子程序调用后，该子程序调用的值实际上就是整个计算的值，因此我可以直接跳转到 increment 本身。

Then recognize that when I'm done with the increment subroutine call, the value of that subroutine call is in fact the value of this overall computation, and so I can go straight to you increment itself. Notice what will happen: the continue register contains within it the point to go back to when I'm done with all of this.

然后认识到当我完成增量子程序调用后，该子程序调用的值实际上就是整个计算的值，因此我可以直接跳转到 increment 本身。注意会发生什么：continue 寄存器包含了我完成所有这些后要返回的点。

So at the end of the increment subroutine, when I do the indirect branch there, I'm going to head straight off to the place where I started from, not come back to this temporary holding spot and continue on. Notice the savings here instead of...

所以在增量子程序的末尾，当我执行间接分支时，我将直接跳转到我开始的地方，而不是回到这个临时中转站并继续。注意这里的节省，而不是……

Notice the savings here instead of having six or seven lines of register machine code I only have two and that means I can be much more efficient. More importantly, I don't use the stack. This tail recursion optimization is going to be very important when we get to building an evaluator out of register machines, because in fact it allows us to have iterative algorithms that are expressed as recursive procedures but not use up any space.

注意这里的节省，而不是有六行或七行寄存器机器代码，我只有两行，这意味着我可以更高效。更重要的是，我不使用栈。这种尾递归优化在我们用寄存器机器构建求值器时将非常重要，因为事实上它允许我们将迭代算法表示为递归过程，但不占用任何空间。

Set a different way, if we didn't use this optimization then whenever we described an iterative algorithm as a recursive procedure, we'd consume stack space. Specifically, each recursive call would push a return address and local state onto the stack, leading to unbounded growth even for processes that are logically iterative, like a simple loop. That would make the system practical only for small inputs, not for real programs. Tail recursion optimization eliminates this overhead by reusing the current stack frame, so recursive calls loop back without additional memory use.

换句话说，如果我们不使用这种优化，那么每当我们把迭代算法描述为递归过程时，我们就会消耗栈空间。具体来说，每次递归调用都会将返回地址和局部状态压入栈中，导致即使对于逻辑上迭代的过程（如简单循环）也会无限增长。这将使系统只适用于小输入，而不适用于实际程序。尾递归优化通过重用当前栈帧消除了这种开销，因此递归调用无需额外内存即可循环返回。

### 7. Recursive algorithms: implementing factorial (递归算法：实现阶乘)

algorithm as a recursive procedure, something that would call itself again. We would end up using up some space because we would have to store away the return point while we did the subroutine call, and then having come back simply return that value to that return point.

算法作为递归过程，即会调用自身的过程。我们最终会占用一些空间，因为在子程序调用期间我们必须保存返回点，然后返回时只需将该值返回给那个返回点。

But each recursive call to that iterative procedure would use up a little bit more space on the stack. By using this particular optimization, by getting rid of that use of the stack, we don't have that effect. As a consequence, we can describe an iterative algorithm as a recursive procedure.

但每次对该迭代过程的递归调用都会在栈上多占用一点空间。通过使用这种特定的优化，通过消除对栈的使用，我们就没有这种影响了。因此，我们可以将迭代算法描述为递归过程。

Algorithm as a recursive procedure, reuse of the same subroutine but not use up any space it can still be constant in terms of space use because no stack usage is involved if we use this optimization. So in summary for this part, we've now added a stack to our register machine.

算法作为递归过程，重用同一个子程序但不占用任何空间，如果使用这种优化，它在空间使用上仍然是恒定的，因为不涉及栈的使用。所以总结这部分，我们现在已经为我们的寄存器机器添加了一个栈。

It's a last-in first-out memory device that has the behaviors we saw earlier in the term in terms of an abstract data type for a stack but in this case using registers and it has two operations a save that puts data on the top of the stack from a particular register and

它是一个后进先出的存储设备，具有我们本学期早些时候看到的抽象数据类型栈的行为，但这次是使用寄存器实现的，它有两个操作：save 将特定寄存器的数据压入栈顶，以及

stack from a particular register and restore that takes data from the top of the stack and puts it back into a register. Key things to keep in mind with the stack are, first of all, the concept of a stack depth: how many things are saved on the stack, both currently and of course, the maximum depth used within any particular computation.

从特定寄存器将数据压入栈顶，以及 restore 从栈顶取出数据并放回寄存器。关于栈需要记住的关键点，首先是栈深度的概念：栈上保存了多少东西，既包括当前，当然也包括任何特定计算中使用的最大深度。

We've also seen that the stack itself, both its expectations and its effect, are part of the contract that goes hand-in-hand with the subroutine. And finally, we see we can be clever about how we use the stack.

我们还看到，栈本身，无论是其预期还是其效果，都是与子程序相伴的契约的一部分。最后，我们看到我们可以巧妙地使用栈。

We can be clever about how we use the stack, or rather, if you like, avoid using the stack when not necessarily needed. If a subroutine call is not going to do any work after that actual call but can simply pass the value of the return directly back to the person who asked for it in the first place.

我们可以巧妙地使用栈，或者如果你愿意，可以说在不需要时避免使用栈。如果子程序调用在实际调用之后不需要做任何工作，而只是将返回值直接传回给最初请求它的人，那么就可以这样做。

Now, let's put this all together to see how we can use subroutines and stacks to implement recursive algorithms in register machines. Of course, here's our standard recursive algorithm factorial, we know and love this from Scheme. If n is equal to one, the answer is just one otherwise...

现在，让我们把所有这些放在一起，看看如何利用子程序和栈在寄存器机器中实现递归算法。当然，这里是我们标准的递归算法阶乘，我们在Scheme中对此非常熟悉。如果n等于1，答案就是1，否则……

to one the answer is just one otherwise factorial of n is the same thing as multiplying n by the sub computation of factorial on n minus one and we know the behavior to expect we've seen before when we use substitution model to trace this out the calling fact of 3 is going to end up with a deferred operation we're going to hold on to the multiplication of 3 while we go off and do the sub computation to get factorial of 2 and that itself will have another deferred operation we've got to hold on to the multiplication by 2 while we go off and do the sub computation to get factorial of 1, and so on.

否则，n的阶乘就等于n乘以n减1的阶乘的子计算。我们知道预期的行为，之前在使用替换模型追踪时已经见过：调用fact 3最终会产生一个延迟操作，我们将在进行子计算以得到2的阶乘时保留乘以3的操作，而那个子计算本身又会有另一个延迟操作，我们必须在进行子计算以得到1的阶乘时保留乘以2的操作，依此类推。

to the multiplication by 2 while we go off and get the answer to another sub computation factorial of 1 so we stack up those deferred operations until they get down to a simple thing having done that we can then compress those operations back down. Now we expect to see a relationship between this kind of behavior in terms of scheme and what happens inside of a register machine and in particular in terms of the stack keeping track of things in order to allow us to recursively reuse the same machinery to compute factorial. Now the idea is we should build some register

乘以2的操作被保留，同时我们进行另一个子计算以得到1的阶乘，因此我们将这些延迟操作堆叠起来，直到它们归结为一个简单的事情。完成之后，我们可以将这些操作压缩回来。现在，我们期望看到这种在Scheme中的行为与寄存器机器内部发生的事情之间的关系，特别是栈跟踪事物以允许我们递归地重用相同的机制来计算阶乘。现在，我们的想法是构建一些寄存器

machinery to compute factorial now the idea is we should build some register

机器来计算阶乘。现在，我们的想法是构建一些寄存器

idea is we should build some register machine code to compute factorial and of course we want to reuse that code over and over again for every recursive call to factorial we don't have to replicate or duplicate the code inside of the machine but since factorial is going to require reusing the same registers we're going to have to store away some information on the stack the stack is going to remember the return point for each recursive call and it's going to remember the intermediate values basically the values of N the deferred

想法是构建一些寄存器机器代码来计算阶乘，当然我们希望反复重用这段代码，对于每次递归调用阶乘，我们不必在机器内部复制或重复代码。但由于阶乘需要重用相同的寄存器，我们将不得不在栈上存储一些信息。栈将记住每次递归调用的返回点，并且记住中间值，基本上是N的值，即延迟操作，

基本上，N 的值是它必须保留的延迟操作，同时它去执行其余的工作。我们即将查看实际代码，但我们应该能够看到这种行为，即栈会增长，反映机器本身跟踪所有延迟操作的增长顺序，并且要记住完成一些计算后应该返回哪里。

基本上，N的值是它必须保留的延迟操作，同时它去执行其余的工作。我们即将查看实际代码，但我们应该能够看到这种行为，即栈会增长，反映机器本身跟踪所有延迟操作的增长顺序，并且要记住完成一些计算后应该返回哪里。

使用相同的机制，这里有一个计算阶乘的寄存器机器。我们将分阶段查看它，但即使在这里，也能看到栈增长的模式，因为每次递归调用都会在栈上保存状态，直到基础情况满足后再逐步展开。

使用相同的机制，这里有一个计算阶乘的寄存器机器。我们将分阶段查看它，但即使在这里，也能看到栈增长的模式，因为每次递归调用都会在栈上保存状态，直到基础情况满足后再逐步展开。

To look at this in stages, but even here we can see the overall form. We initially set up into the continue register a label that says where to go to when we're done with everything. Then we have three different chunks.

为了分阶段查看，但即使在这里我们也能看到整体形式。我们最初在continue寄存器中设置一个标签，指示所有事情完成后要去哪里。然后我们有三个不同的块。

The register machine one starting with the entry point fact, that ends with a go to tube and does a particular computation we'll look at shortly. A second one starting with the entry point our done, also entering ending with a go to in this case an indirect branch. And another entry point starting with B case ending with another indirect branch. We're going to look at.

寄存器机器从入口点fact开始，以一个go to tube结束，并进行一个特定的计算，我们稍后会查看。第二个从入口点our done开始，也以go to结束，在这种情况下是间接分支。另一个入口点从B case开始，以另一个间接分支结束。我们将查看。

Indirect branch we're going to look at each of these pieces in turn to see how they capture the idea of factorial and how in fact reusing this machinery in conjunction with the stack allows us to compute a recursive procedure. Let's start with the base case of factorial. We know what this should do: it should test to see if the value of n is 1, and if it is, it should just return 1 to whoever is asking for this computation of fact. Now here's the part of the register machine code that corresponds to that. Fact, of course, is our entry point, and the first

间接分支，我们将依次查看这些部分，看看它们如何捕捉阶乘的思想，以及实际上重用这个机制与栈结合如何使我们能够计算递归过程。让我们从阶乘的基础情况开始。我们知道它应该做什么：它应该测试n的值是否为1，如果是，它应该只返回1给任何请求这个fact计算的人。现在这是寄存器机器代码中对应的部分。Fact，当然，是我们的入口点，第一

course is our entry point and the first thing it does is it tests it uses his equal tester on register and in the constant one to see if in fact the value of n is equal to 1 remember what test does it sets a bit on the condition register that tells us whether this test was in fact true.

件事是它测试，它使用他的等于测试器在寄存器n和常量1上，以查看n的值是否等于1。记住测试做什么：它在条件寄存器上设置一个位，告诉我们这个测试是否实际上为真。

the next instruction the branch instruction then says if that bit is true jump to this point in the register machine code or in other words if the value of the register n is 1 we're going to go to the place labeled by B case and what does that do it loads

下一条指令，分支指令，然后说如果那个位为真，跳转到寄存器机器代码中的这个点，或者换句话说，如果寄存器n的值为1，我们将去往标记为B case的地方，它做什么？它加载

by B case and what does that do? It loads the constant one into Val. Val does our register that holds our output, and then it does an indirect branch. It goes to wherever continue sets. So in other words, it jumps to the place that asks for this computation, with the answer now sitting in Val. So in fact, from this little piece of code, we can answer some questions: where does fact expect its input, where does fact expect its return point, and where is it going to put its output?

由B case标记的地方，它做什么？它将常量1加载到Val中。Val是我们的寄存器，保存我们的输出，然后它进行间接分支。它去往continue设置的地方。所以换句话说，它跳转到请求这个计算的地方，答案现在在Val中。因此，从这段小代码中，我们可以回答一些问题：fact期望它的输入在哪里，fact期望它的返回点在哪里，以及它将把输出放在哪里？

when you've figured out the answer, click the mouse button right. This one was pretty straightforward: fact expects its

当你找出答案时，点击鼠标按钮。这个相当直接：fact期望它的

pretty straightforward fact expects its input in the register n is going to put its output in register Val that's where we just set up the answer and where does it expect its return point and continue as always now if we're not in the base case we know that factorial event is going to have to do a recursive call is going to have to do a sub computation to get factorial of n minus 1 and inside of the scheme code we've got that recursive piece ignore for the moment the things around it let's look at what piece of register machine code does this work for us well

相当直接，fact期望它的输入在寄存器n中，将把输出放在寄存器Val中，那就是我们刚刚设置答案的地方，它期望返回点在continue中，一如既往。现在如果我们不在基础情况中，我们知道阶乘事件将不得不进行递归调用，将不得不进行子计算以得到n减1的阶乘，在Scheme代码中我们有那个递归部分，暂时忽略周围的东西，让我们看看寄存器机器代码的哪一部分为我们做这项工作。

Machine code does this work for us well. We just saw the conditions on the contract for fact inside of this computation, which happens to be fact. But inside this computation, we need to do a subroutine called the fact, so what does the contract say?

机器代码为我们做这项工作。我们刚刚看到了fact的契约条件，在这个计算内部，恰好是fact。但在这个计算内部，我们需要调用一个名为fact的子程序，那么契约说了什么？

We need to get a value into register n, so we take the current value of n, subtract 1 from it, and put that into n. That has set up the input register for fact.

我们需要将一个值放入寄存器n，所以我们取当前n的值，从中减去1，并将其放入n。这已经为fact设置了输入寄存器。

We need to put a return point into the continue register. We'll put our done as the point we want to come to when we've done the recursive

我们需要将一个返回点放入continue寄存器。我们将our done作为我们完成递归后想要到达的点。

to come to when we've done the recursive call the idea will be when we get to that point the value of factorial of n minus 1 will be sitting in Val that's the contract for the output is and therefore will be set to carrion and having done that we can do a branch off to fact we can go to that point in the instruction sequence and do the computation of fact

当我们完成递归调用后，到达那个点时，n减1的阶乘值将存放在Val中，这就是输出的约定，因此我们将设置为carrion，完成之后，我们可以分支到fact，可以转到指令序列中的那个点，进行fact的计算。

we know if we've done it right when we come back to the continue register to are done the value of factorial of n minus 1 will be sitting in Val and the rest of the contract for fact as a subroutine call

我们知道，如果我们做得正确，当我们回到continue寄存器并完成时，n减1的阶乘值将存放在Val中，而fact作为子程序调用的其余约定也将就位。

contract for fact as a subroutine call will be in place now assuming we do this right when we get to that point in the computation what register is going to hold the return value of the recursive call right our contract for fact based on our base case was that Val is the place where the return is going to go and that has to be the same place for all calls 2 factorial no matter what the argument so when we get to our done we can expect assuming we do things right that the register Val will hold the value of this sub computation so we're doing a pretty good job of building up

现在假设我们做得正确，当我们到达计算中的那个点时，哪个寄存器将保存递归调用的返回值？根据我们的基本情况，fact的约定是Val是返回值存放的地方，而且对于所有对factorial的调用，无论参数是什么，这个位置都必须相同。因此，当我们到达done时，可以预期，假设我们做得正确，寄存器Val将保存这个子计算的值，所以我们正在很好地构建。

doing a pretty good job of building up the register machine code for computing factorial. We've handled the base case, we saw how to get the value out for that, we've handled the rehearse of recursive call that subroutine called a factorial with another argument, and we've seen that the answer is going to be sitting in Val.

我们正在很好地构建计算阶乘的寄存器机器代码。我们已经处理了基本情况，看到了如何从中获取值，我们处理了递归调用的排练，即用另一个参数调用factorial子程序，并且我们看到答案将存放在Val中。

So now we can deal with what happens after that recursive call, and we know from our overall code what we want. If we're not in the base case, if we've gone off and done a subroutine called a recursive call to factorial with a

所以现在我们可以处理递归调用之后发生的事情，从我们的整体代码中我们知道我们想要什么。如果我们不在基本情况中，如果我们已经去执行了一个子程序调用，即用更小的参数递归调用factorial，

recursive call to factorial with a smaller argument. When we get that value back, we just want to multiply it by n. So the code we'd expect to see would be simply something that takes what's in Val, the return value from that subroutine call, multiplies it by n, and puts that new value into the register Val. There's the value now for factorial of N, and we can then head off to wherever continue says — we can do the indirect branch to carry on.

用更小的参数递归调用factorial。当我们取回那个值时，我们只需要将它乘以n。因此，我们期望看到的代码将简单地是：取Val中的内容，即子程序调用的返回值，乘以n，并将新值放入寄存器Val。这就是N的阶乘的值，然后我们可以前往continue指示的任何地方——我们可以进行间接分支以继续。

This looks great, but let's be really careful: what's sitting in n? We know in principle the value of register Val.

这看起来很好，但让我们非常小心：n中存放的是什么？我们知道原则上寄存器Val的值。

principle the value of register Val holds the computation we want for the subroutine, and in particular we just like to multiply it by n. But remember we changed in we overrode n, we put in n minus 1 in order to set things up to use the machinery for fact.

原则上寄存器Val的值保存了我们想要的子程序计算，特别是我们只想将它乘以n。但请记住，我们改变了n，我们覆盖了n，我们放入n减1以便使用fact的机制。

### 8. Saving and restoring registers: the general rule (保存和恢复寄存器：一般规则)

So we've clobbered register N, and if we try and do this computation here, we're going to be multiplying by the wrong value. Not just n got nailed, continue also got nailed. Remember we overwrote that to set up the return point after the subroutine call, so the continue register no longer.

所以我们破坏了寄存器N，如果我们尝试在这里进行这个计算，我们将乘以错误的值。不仅仅是n被破坏了，continue也被破坏了。记住我们覆盖了它来设置子程序调用后的返回点，所以continue寄存器不再。

call so the continue register no longer holds the return point we had in place when we started factorial event oh well actually it's okay we already can get a sense of what we need to do since we're going to need to have the value of N and the value of continued available to us when we come back from the recursive call.

调用后，continue寄存器不再保存我们开始factorial时设置的返回点。哦，好吧，实际上没关系，我们已经能感觉到我们需要做什么，因为当我们从递归调用返回时，我们需要N的值和continue的值可用。

we somehow need to save them away so we can reuse those registers and how are we going to save them away well the only tool we got available is a stack so we simply have to use the stack to keep track of those values while we go off

我们以某种方式需要保存它们，以便我们可以重用这些寄存器，而我们如何保存它们呢？我们唯一可用的工具是栈，所以我们只需使用栈来跟踪这些值，当我们去执行子计算时。

track of those values while we go off and do the sub computation so here's how we do it much more carefully and notice the things labeled in blue we're going to save a way onto the stack those registers that are going to get written as part of the actual computation of factorial the continue register and the N register having saved them away we can then safely put in a new value to n the value we want for the subroutine call put a new continue label in the place we want to come back to after we've gone off and done that sub computation and head off to that work when we come back

跟踪这些值，当我们去执行子计算时。所以这是我们更仔细的做法，注意标为蓝色的部分：我们将那些在factorial实际计算过程中会被写入的寄存器保存到栈上，即continue寄存器和N寄存器。保存它们之后，我们可以安全地放入n的新值，即我们想要的子程序调用的值，放入新的continue标签，即我们完成子计算后想要返回的位置，然后前往那个工作。当我们回来时，

Head off to that work when we come back to our done to the label we put in after. We want to get done with the sub computation, we can then restore the registers that we saved on the stack.

前往那个工作，当我们回到我们放入的标签后的done时。我们想要完成子计算，然后我们可以恢复我们保存在栈上的寄存器。

Notice the order we restore in is the opposite order to the saves, to make sure we put the right values back into the registers. Also notice the balancing of these saves and restores: after the second restore, the stack will be back to the state it was in before we started all of this.

注意我们恢复的顺序与保存的顺序相反，以确保将正确的值放回寄存器。还要注意这些保存和恢复的平衡：在第二次恢复之后，栈将回到我们开始这一切之前的状态。

Having done that, we can then safely pick up the remaining computation, we've got the right value of the sub routine.

完成之后，我们可以安全地继续剩余的计算，我们有了正确的子程序值。

computation we've got the right value of n we've got the right value of Val we can do the multiplication put that into Val and continue with the process itself

计算，我们有了正确的n值，我们有了正确的Val值，我们可以进行乘法，将其放入Val，并继续过程本身。

so this is a little different than the earlier case remember in the tail recursive case we decided that a save and restore was unnecessary there because we weren't going to do anything to those registers and we were simply wasting space

所以这与之前的情况略有不同。记住在尾递归的情况下，我们决定在那里不需要保存和恢复，因为我们不会对这些寄存器做任何操作，我们只是在浪费空间。

here we have a case where we in fact do need to save a register and we can see the general rules for when we want to save a register we need

这里我们有一个实际上需要保存寄存器的情况，我们可以看到何时需要保存寄存器的一般规则：我们需要

when we want to save a register we need to save a register onto the stack if the value is going to be used after the call and the register is not an output of the subroutine if it was then we don't need to save it because it's going to be available to us and the register is either written as part of the call or is written as part of the subroutine if these conditions hold we need to save the register it says we're going to need that value after the call is not going to be set up by the subroutine itself so we're going to need that value around

当我们需要保存寄存器时，如果该值将在调用后使用，并且该寄存器不是子程序的输出，那么我们需要将寄存器保存到栈上。如果它是输出，那么我们不需要保存它，因为它将对我们可用。并且该寄存器要么在调用过程中被写入，要么在子程序过程中被写入。如果这些条件成立，我们需要保存寄存器，这意味着我们将在调用后需要那个值，而它不会由子程序本身设置，所以我们需要那个值保留。

we're going to need that value around and in fact there's a good chance that the register is going to be damaged as part of the call and for our part of the subroutine and therefore we're going to have to restore the value after we're done okay so now we've built fact let's see if you can write down the contract for this subroutine for factorial you can go back and look at the previous code if you want to a look at an example of that but we'd like to know what's the input part of the contract the output part of the contract what gets written

我们将需要那个值，而且很有可能在调用子程序以及子程序内部的过程中该寄存器会被破坏，因此我们必须在完成后恢复该值。好了，现在我们已经构建了fact，看看你是否能为这个阶乘子程序写出契约。如果需要的话，你可以回头看看之前的代码作为示例，但我们想知道：契约的输入部分是什么，输出部分是什么，哪些寄存器会被写入，

part of the contract what gets written and what's the value or the change in the stack if any as part of this contract when do you think he got the answer get the most so here we go

契约中哪些寄存器会被写入，以及作为契约的一部分，栈的值或变化是什么？你认为什么时候能得到答案？那么，我们开始吧。

clearly the input is N and continue we need a value of n to compute factorial of N and we need the continued register as an input to know where to go with this answer when we're done outputs just Val

显然，输入是N和continue。我们需要一个n的值来计算N的阶乘，并且我们需要continue寄存器作为输入，以知道完成后答案应该去哪里。输出只是Val。

that's where the results going to be placed writes his none nothing gets overwritten and the stack is also unchanged it doesn't say the stack is not used it is during this computation

那是结果存放的地方。写入：无，没有东西被覆盖，栈也保持不变。这并不意味着栈没有被使用；在计算过程中它确实被使用了。

not used it is during this computation, but the state of the stack when we're done with factorial will be exactly the same as the state the stack was in before we started factorial. Wait a minute, is that true? Well, yes, it is in fact.

在计算过程中它确实被使用了，但当我们完成阶乘时，栈的状态将与开始阶乘之前的状态完全相同。等等，这是真的吗？嗯，是的，事实上确实如此。

This procedure, this subroutine call of factorial, does right and continue as part of its process, but notice it saves them before writing and restores them after, so in terms of the overall scope of factorial, these registers are not overwritten. That is, the values that were in them before the subroutine was called.

这个过程，即阶乘的子程序调用，在其过程中确实会写入right和continue，但请注意，它在写入之前保存了它们，并在之后恢复它们，因此就阶乘的整体范围而言，这些寄存器没有被覆盖。也就是说，在子程序被调用之前存在于这些寄存器中的值，

in them before the subroutine was called will also be in them after the subroutine is done and therefore they're not overwritten and the contract says writes none.

在子程序被调用之前存在于这些寄存器中的值，在子程序完成后也将存在于其中，因此它们没有被覆盖，契约中写着“写入：无”。

### 9. Tracing factorial execution and unwinding the stack (追踪阶乘的执行与栈的回退)

okay let's pull this all together by tracing the execution of fact a call to fact as a subroutine with some particular value and n you might want to go back to that slide that had all of the details for fact and print out a copy or otherwise scribble it down so you can follow along as we do this what we're going to do is look at the contents of the registers and the stack.

好的，让我们通过追踪fact的执行来把所有内容整合起来，即调用fact作为子程序并带有某个特定的n值。你可能想回到那张包含fact所有细节的幻灯片，打印一份或抄写下来，以便在我们进行时跟随。我们要做的是查看寄存器和栈的内容。

contents of the registers and the stack itself as we hit each label in that computation and by convention just so we can trace things out we're going to have the top of the stack shown at the left for each one of these things okay let's assume that somehow the value three has been loaded into register and we need something in an in order to start this off

寄存器和栈本身的内容，当我们到达计算中的每个标签时。按照惯例，为了便于追踪，我们将栈顶显示在左侧。好的，假设值3已经被加载到寄存器中，我们需要在n中有某个值才能开始。

so the first thing that happens as after we come into the controller is that we put the label halt in to continue and then we drop down to fact so when we get to the label fact for the first time continue holds a pointer to

所以，当我们进入控制器后发生的第一件事是，我们将标签halt放入continue，然后我们下降到fact。因此，当我们第一次到达标签fact时，continue保存着一个指向halt的指针，

first time continue holds a pointer to halt and has a value we don't know what's in Val could be anything and the stack is empty. we're now at facts so we check to see if we're in the base case by running that test operation it's not true so the next thing we do is save both continue and n onto the stack holding aside basically the computation we're about to do while we set up to do a sub computation the fact we then put a new value into n basically decreasing it by one and we put a new label in to continue and then we can go off to fact and notice what

第一次到达时，continue保存着指向halt的指针，而Val中的值我们不知道，可能是任何值，栈是空的。我们现在在fact处，我们通过运行测试操作来检查是否处于基本情况；它不是真的，所以接下来我们要做的是将continue和n都保存到栈上，基本上把我们即将进行的计算放在一边，同时我们为子计算做准备。然后我们将一个新值放入n，基本上将其减一，并将一个新标签放入continue，然后我们可以去fact，注意我们做了什么。

We can go off to fact and notice what we've done. We've got a place to go to when we're done with this sub computation, and we satisfied the input contract for factorial. We've got something in EM, we got something can continue, and we got a stack.

我们可以去fact，注意我们做了什么。我们有了一个在子计算完成后要去的地方，并且我们满足了阶乘的输入契约。我们在EM中有东西，在continue中有东西，并且我们有一个栈。

Thus, when we hit fact for the second time, we're about to try and compute factorial of 2. On the stack, we've got held some computation that we're going to have to come back and do after we're done with this sub computation.

因此，当我们第二次到达fact时，我们即将尝试计算2的阶乘。在栈上，我们保存了一些计算，这些计算将在子计算完成后回来处理。

All right, we're at fact again. We check to see if we're in the base case. We're not, so as

好的，我们再次到达fact。我们检查是否处于基本情况。我们不是，所以作为

The base case we're not so as a consequence we do exactly the same thing. We save away again the value of and the value of n onto the stack. Notice how the stack depth has grown—we now have two sub computations stored away there.

我们不是基本情况，所以作为结果，我们做完全相同的事情。我们再次将n的值保存到栈上。注意栈的深度如何增长——我们现在已经存储了两个子计算。

We put a new value into n, we put a new label into continued—happens to be the same one as before, but we literally put that new label in, and we go off to fact again.

我们将一个新值放入n，将一个新标签放入continue——恰好和之前一样，但我们确实放入了那个新标签，然后我们再次去fact。

Notice when we come to fact now, we've got a value of n, we've got a continued variable—or sorry, a continued label—in the continue register, and we...

注意，当我们现在到达fact时，我们有一个n的值，我们有一个continue变量——抱歉，是一个continue标签——在continue寄存器中，并且我们……

label in the continue register and we happen to have on the stack some sub computations still pending. Now in this case, when we test to see if we're in the base case, in fact we are, and so we do that unconditional branch, or rather that conditional branch down to base case.

在continue寄存器中有标签，并且我们碰巧在栈上还有一些待处理的子计算。现在在这种情况下，当我们测试是否处于基本情况时，事实上我们确实处于基本情况，因此我们执行那个无条件分支，或者更确切地说，那个条件分支向下到基本情况。

Notice what happens when we hit base case. None of the registers have been changed, so we're now at the point where we've gotten down to a base case. And look at what's on the stack: we're now at the maximum depth for the stack, and the stack in fact holds a set of calls for each of the deferred operations now.

注意当我们到达基本情况时会发生什么。没有任何寄存器被改变，所以我们现在已经到了基本情况。看看栈上有什么：我们现在处于栈的最大深度，栈实际上为每个延迟操作保存了一组调用。

each of the deferred operations now in this case it actually has two values on the stack for each recursive call and in fact we can see how each of those labels the values of the arguments and the return point specify what's known as a stack frame the set of things we have to do when we come back down into the base case.

对于每个延迟操作，在这种情况下，实际上每个递归调用在栈上有两个值，事实上我们可以看到每个标签、参数值和返回点如何指定了所谓的栈帧，即当我们从基本情况返回时需要执行的一组事情。

we're ready now to do the final computation and we should then be able to start unwinding that stack to complete the computation itself so what does base case do or be case do it sets up a return value into Val in this case.将返回值存入Val，在这个情况下。

我们现在准备好进行最终计算，然后我们应该能够开始展开栈以完成计算本身。那么基本情况做什么呢？它设置一个返回值到Val中，在这种情况下。将返回值存入Val，在这个情况下。

up a return value into Val in this case the value is 1 so we finally get a value into Val and then it says go to register continue that is do an indirect branch to we're continue says which is to are done our done is basically basically the entry point we want when we've done one of the recursive calls so we would expect it to be able to restore the state of the machine before we did that recursive call and do some additional computation and in fact it does exactly that it restores a value into n it restores a value into continue in the opposite order to the saves to exactly.

将一个返回值放入 Val，本例中值为 1，所以我们最终将值放入 Val，然后它说转到寄存器 continue，即进行间接跳转到 continue 所指的位置，即我们的 done。我们的 done 基本上是我们完成一次递归调用后想要进入的入口点，因此我们期望它能够恢复在进行该递归调用之前机器的状态，并执行一些额外的计算。事实上它正是这样做的：它恢复 n 的值，恢复 continue 的值，恢复顺序与保存顺序完全相反。

opposite order to the saves to exactly get the last-in first-out behavior and it then puts into Val a new value having gotten back the value of n we wanted we can multiply it by the value we got from the recursive call and put that in as the answer to this call and then we can go to wherever continue says - in other words pick up again and indirect branch.

与保存顺序完全相反，以精确实现后进先出的行为。然后，在取回我们想要的 n 的值之后，它将一个新值放入 Val，我们可以将其与递归调用返回的值相乘，并将结果作为本次调用的答案放入 Val，然后我们可以转到 continue 所指的任何地方——换句话说，再次进行间接跳转。

notice how the stack has deuced because we've done one of the deferred operations we're now back at our done we can unwind again by restoring n restoring continue doing the deferred operation putting the new value.

注意栈是如何缩减的，因为我们已经完成了一个延迟操作，现在我们回到了 done。我们可以再次展开，通过恢复 n、恢复 continue、执行延迟操作、放入新值。

deferred operation putting the new value into Val and going to register continue, which in this case goes to the place we put in when we started all of this, which is namely to halt. And notice the state when we get to halt: the stack is empty, it's back to where it was before we started all of this. The answer sitting in Val, and the value of n happens to be there, but it doesn't matter because all we want is the return value, which is Val. The stack back to empty, and we're at the place we want it to be when we started all of this, so we can see how using the

执行延迟操作，将新值放入 Val，然后转到寄存器 continue，在本例中，它指向我们开始这一切时放入的位置，即 halt。注意我们到达 halt 时的状态：栈为空，回到了我们开始这一切之前的状态。答案在 Val 中，n 的值恰好也在那里，但这无关紧要，因为我们只需要返回值，即 Val。栈回到空，我们处于开始这一切时想要的位置，因此我们可以看到如何使用

All of this so we can see how using the stack saves away a deferred operation, the state of the world while we set up to do a recomputation using the same machinery. And having come back from that recomputation, it restores the world and picks up that deferred operation. Notice in particular the contents of the stack represents all the pending operations.

这一切，因此我们可以看到如何使用栈来保存延迟操作，即在我们设置好使用相同机制进行重新计算时保存世界状态。从该重新计算返回后，它恢复世界状态并拾取该延迟操作。特别要注意，栈的内容代表了所有待处理的操作。

And in fact, at the base case we saw that we had on the stack the maximum depth, and indeed had each of the deferred operations stored, in this case in two values on the stack, if you look at that.

事实上，在基准情形下，我们看到栈达到了最大深度，并且每个延迟操作都被存储起来，在这个例子中是以栈上的两个值的形式存储的，如果你观察那个栈的话。

values on the stack if you look at that stack at that point you can see how it exactly reflects the multiplication by two and the multiplication by 3 that we deferred off while we did all of this.

如果你观察那个时刻的栈，你可以看到它如何精确地反映了我们在进行所有这些计算时延迟的乘以2和乘以3的操作。

In summary, we see that in order to implement recursion, to use procedures that are inherently recursive and not just an iterative algorithm happens to be described recursively, we need a stack. We need to have a way of recording the pending work, the information we're going to need to have when we want to come back from the computation and pick up the rest of the work.

总之，我们看到，为了实现递归，即使用本质上递归的过程，而不仅仅是碰巧用递归描述的迭代算法，我们需要一个栈。我们需要一种方式来记录待处理的工作，即当我们从计算中返回并继续剩余工作时所需的信息。

the rest of the work so as both the values we'll need in terms of variables and the return points we've also seen as a consequence that the maximum stack depth is basically equivalent to the total space required it captures the number of deferred operations we're going to need in these algorithms or at least for most algorithms and it lets us see the relationship between that idea of orders our growth in terms of space number of pending operations and actual use of space in this case the number of deferred operations are the growth of

剩余的工作，既包括我们需要的变量值，也包括返回点。我们还看到，最大栈深度基本上等同于所需的总空间，它捕获了这些算法中我们将需要的延迟操作的数量，或者至少对大多数算法而言是这样，并且它让我们看到空间增长阶数（即待处理操作的数量）与实际空间使用之间的关系，在这个例子中，延迟操作的数量就是增长的量。

Deferred operations are the growth of modern cloud infrastructure, enabling systems to handle asynchronous workloads efficiently without blocking critical paths. By deferring non-essential tasks, organizations can optimize resource utilization, improve responsiveness, and scale more gracefully under varying demand. This approach is foundational to event-driven architectures, where tasks like data processing, notifications, and batch jobs are queued and executed when conditions are optimal, rather than stalling user-facing operations.

延迟操作是现代云基础设施的增长点，使系统能够高效地处理异步工作负载，而不会阻塞关键路径。通过延迟非关键任务，组织可以优化资源利用，提高响应能力，并在不同需求下更优雅地扩展。这种方法是事件驱动架构的基础，在这种架构中，数据处理、通知和批处理作业等任务被排队并在条件最佳时执行，而不是阻碍面向用户的操作。