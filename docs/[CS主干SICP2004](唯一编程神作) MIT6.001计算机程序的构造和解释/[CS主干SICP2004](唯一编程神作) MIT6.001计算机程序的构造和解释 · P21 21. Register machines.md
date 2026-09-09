# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=21)

在过去的几节课中，我们一直在讨论评估的问题，特别是我们一直用描述过程的语言，即方案，来描述评估过程。这使得我们能够探索构建评估器的各种变化方式。

在过去的几节课中，我们一直在讨论评估的问题，特别是我们一直用描述过程的语言，即方案，来描述评估过程。这使得我们能够探索构建评估器的各种变化方式。

但这给我们留下了一个有点令人困惑的想法：我们正在用方案本身来描述方案的评估。虽然这具有奇妙的元循环性，但在思考这样高层抽象的事物时，它却不是那么方便。

但这给我们留下了一个有点令人困惑的想法：我们正在用方案本身来描述方案的评估。虽然这具有奇妙的元循环性，但在思考这样高层抽象的事物时，它却不是那么方便。

high level abstractions beginning in this lecture we're going to turn around and go the other direction that is rather than building up abstractions in terms of describing evaluation we're going to go down into the details of the machine and build a CPU a central processing unit we're going to design a CPU simply assuming that we have available some wires some logic little networks of gates if you like some registers to hold values and a sequencer that controls how information is moved around within these registers we could of course design machines to do lots of

高层抽象。从本节课开始，我们将转向另一个方向。也就是说，我们不再通过描述评估来构建抽象，而是深入到机器的细节中，构建一个CPU，即中央处理器。我们将设计一个CPU，仅仅假设我们拥有一些导线、一些逻辑（如果你愿意，可以称之为门的小网络）、一些用于保存值的寄存器，以及一个控制信息在这些寄存器之间如何移动的序列器。当然，我们可以设计机器来做大量计算，比如设计一个小处理器来计算阶乘、斐波那契数列或其他特定函数。但这远不如设计一个小处理器来实际计算任何语言中的内容来得方便。因此，我们的目标是构建或设计至少一个小型CPU，将Scheme解释为其机器语言。

当然，我们可以设计机器来做大量计算，比如设计一个小处理器来计算阶乘、斐波那契数列或其他特定函数。但这远不如设计一个小处理器来实际计算任何语言中的内容来得方便。因此，我们的目标是构建或设计至少一个小型CPU，将Scheme解释为其机器语言。

当然，我们可以设计机器来做大量计算，比如设计一个小处理器来计算阶乘、斐波那契数列或其他特定函数。但这远不如设计一个小处理器来实际计算任何语言中的内容来得方便。因此，我们的目标是构建或设计至少一个小型CPU，将Scheme解释为其机器语言。

我们将会看到，我们可以分阶段完成这项工作，从在硬件中构建基本的迭代算法开始，然后逐步添加递归算法。

我们将会看到，我们可以分阶段完成这项工作，从在硬件中构建基本的迭代算法开始，然后逐步添加递归算法。

adding in recursive algorithms and then showing how we can in fact implement all of scheme in hardware itself to set the stage for the journey we're about to embark on. Let's think about what I'd really like to have in terms of computation. Let's assume that I have a little machine that computes greatest common divisor, a GCD machine. It's built out of some wires and registers and logic somehow, and in fact shortly we're going to build such a GCD machine out of some simple pieces, so it's going to be something we can do. Nonetheless, assume

添加递归算法，然后展示我们如何实际上在硬件本身中实现所有的Scheme。为了为我们即将踏上的旅程做好准备，让我们思考一下在计算方面我们真正想要的是什么。假设我有一个计算最大公约数的小机器，一个GCD机器。它以某种方式由一些导线、寄存器和逻辑构建而成，事实上，很快我们将用一些简单的部件来构建这样一个GCD机器，所以这是我们能做到的事情。尽管如此，假设

something we can do nonetheless assume

something we can do nonetheless assume

something we can do nonetheless assume we have such a machine available this means I can pass some signals into the input wires representing input values numbers if you like and a signal will come out the output wire representing the number that's the answer we get when we compute the GCD of these two input numbers

something we can do nonetheless assume我们拥有这样一台机器，这意味着我可以将一些信号传入输入导线，代表输入值（如果你喜欢，可以是数字），然后输出导线上会有一个信号出来，代表我们计算这两个输入数字的GCD时得到的答案数字。

and of course if I've done that right that will hold for any input I put in any input into this GCD machine will give me a new output corresponding to that computation

当然，如果我做得正确，那么对于我放入的任何输入，这都将成立：放入这个GCD机器的任何输入都会给我一个新的输出，对应于该计算。

now I don't really want to build a new machine for everything I'm going to compute that's

现在，我并不真的想为我将要计算的每件事都构建一台新机器，那

Everything I'm going to compute that's far too much work. So here's what I'd really like: I'd like to be able to take a description of that GCD machine, a circuit diagram that tells me exactly what registers and wires and logic to use, and I'd like to be able to pass that description, that circuit diagram, off to another machine — sort of the ultimate machine.

我要计算的每件事都构建一台新机器，那工作量太大了。所以，我真正想要的是这样的：我希望能够获取那个GCD机器的描述，一个电路图，它准确地告诉我使用哪些寄存器、导线和逻辑，并且我希望能够将该描述，即电路图，传递给另一台机器——某种终极机器。

And here's what I want that ultimate machine to do: I want it to reconfigure itself — rearrange the wiring, the connections, the registers, the logic — so that it now looks like GCD, behaves like GCD.

我希望那台终极机器做的是：它重新配置自身——重新排列导线、连接、寄存器和逻辑——以便它现在看起来像GCD，表现得像GCD。

like GCD it behaves like GCD I'd like that ultimate machine in fact to do that for any circuit diagram I give it a circuit diagram it reconfigures itself so if I happen to give it the circuit diagram for GCD it reconfigures itself to look like GCD and then given inputs that are inputs to GCD it will behave like GCD do the right computation and give me out the correct answer and it'll do it for any description of any diagram that I want now how would I design that ultima machine how would I build a machine out of registers and logic and

像GCD一样，它表现得像GCD。我希望那台终极机器实际上能为我给出的任何电路图做到这一点：我给它一个电路图，它重新配置自身，所以如果我碰巧给它GCD的电路图，它重新配置自身以看起来像GCD，然后给定作为GCD输入的输入，它将表现得像GCD，进行正确的计算并给我正确的答案。而且它将为我想要的任何描述的任何图表做到这一点。现在，我将如何设计那台终极机器？我将如何用寄存器、逻辑和

machine out of registers and logic and

机器用寄存器、逻辑和

machine out of registers and logic and wires that would have that property that seems kind of tough and it may be doable but it doesn't seem obvious how you'd go about doing it so let's step back and rethink.

机器用寄存器、逻辑和导线构建，以具有那种属性？这看起来有点困难，也许可行，但如何去做并不明显。所以让我们退一步重新思考。

we said we had a description of GCD we described it as a circuit diagram but there's another way we could describe GCD for example we can describe GCD in our normal way of describing processes as a procedure and we'll do that in a second as well but imagine we have done that now let's think about passing that procedure description into a machine we're going to call a

我们说我们有GCD的描述，我们将其描述为电路图，但还有另一种方式我们可以描述GCD，例如，我们可以用我们描述过程的正常方式将GCD描述为一个过程，我们稍后也会这样做。但想象我们已经这样做了，现在让我们考虑将该过程描述传递给一台机器，我们称之为

a machine we're going to call a universal machine and it has the property that it takes that description reads it in and then reconfigures itself so that it simulates or emulates the process described by GCD meaning if I give it any inputs I'll get the right output for that described procedure

一台机器，我们称之为通用机器，它具有这样的属性：它读取该描述，然后重新配置自身，以便模拟或仿真GCD所描述的过程，这意味着如果我给它任何输入，我将为该描述的过程获得正确的输出。

now the question is could we build that machine and what it looks a lot like the previous thing we had on the left side of this slide in fact we know how to build that machine that's called a vowel that's exactly what a Val is it's a description of a universal machine

现在的问题是，我们能否构建那台机器？它看起来很像我们在这张幻灯片左侧之前有的东西。事实上，我们知道如何构建那台机器，它被称为求值器，那正是求值器是什么：它是一个通用机器的描述。

Description of a universal machine. It says: give me any legal description of a process, and I will emulate that process, taking in inputs and handing out outputs appropriately. So in fact, our goal then is to decide how to build that universal machine, how to build it. In register machines, how to build a Val out of much simpler pieces of hardware. And if we can do that, then we have this property that we can do anything. And in fact, we don't need to build special purpose hardware for other things, because if Val, that universal machine, will do everything we need.

通用机器的描述。它说：给我任何合法的过程描述，我将仿真该过程，适当地接收输入并给出输出。因此，实际上，我们的目标是决定如何构建那台通用机器，如何构建它。在寄存器机器中，如何用更简单的硬件部件构建求值器。如果我们能做到这一点，那么我们就拥有了可以做任何事情的属性。事实上，我们不需要为其他事情构建专用硬件，因为如果求值器，那台通用机器，将做我们需要的一切。

will do everything we need this idea of a universal machine is a central component of computer science as we saw in an earlier lecture this fundamental definition of computation in terms of Universal machines is based on an insight due to Alan Turing touring was addressing Hilbert's famous decision problem which asked whether all the mathematics was decidable that meant could one devise a specific method that could take any assertion about mathematics and determine if it were true to answer this question Turing created a definition of a machine

将做我们需要的一切。通用机器的想法是计算机科学的核心组成部分，正如我们在之前的讲座中看到的，这种基于通用机器的计算的基本定义源于艾伦·图灵的洞见。图灵正在解决希尔伯特著名的判定问题，该问题询问是否所有数学都是可判定的，这意味着能否设计一种特定的方法，可以接受任何关于数学的断言并确定其是否为真。为了回答这个问题，图灵创建了机器的定义。

Turing created a definition of a machine now called a Turing machine that led to the generally widely accepted Church-Turing thesis: any procedure that could reasonably be considered to be an effective procedure can be carried out by a universal machine, and thus by any universal machine. Thus, all we have to do is build one machine out of hardware, as long as we can make that machine a universal machine. For example, if we make it an evaluator, if we can do that, then that machine, that evaluator, can execute the computation for any other process that we can describe in.

图灵创造了一种机器的定义，现在称为图灵机，它导致了被广泛接受的丘奇-图灵论题：任何可以被合理地视为有效过程的程序，都可以由一台通用机器来执行，因此也可以由任何通用机器来执行。因此，我们所要做的就是用硬件制造一台机器，只要我们能使其成为通用机器。例如，如果我们把它做成一个求值器，如果我们能做到这一点，那么那台机器，那个求值器，就能为我们所能合法描述的任何其他过程执行计算。

other process that we can describe in legally and thus includes any other evaluator so let's start working our way towards building that universal machine out of much simpler pieces building that evaluator from registers and logic and wires to do this we're going to look at some simpler processes first and work our way up and in particular let's go back in factor GCD here's a description of the process of GCD we happen to be describing GCD in the language that we've been using namely scheme but here's what it says it says to compute

其他过程，我们所能合法描述的任何其他过程，因此也包括任何其他求值器。所以让我们开始努力用更简单的部件来构建那台通用机器，用寄存器、逻辑和导线来构建那个求值器。为此，我们将首先研究一些更简单的过程，然后逐步深入。特别是，让我们回到 GCD 的因子分解。这里有一个 GCD 过程的描述，我们恰好用我们一直在使用的语言来描述 GCD，即 Scheme，但这里说的是：要计算

Here's what it says: it says to compute the greatest common divisor of two numbers A and B, do the following. If B is zero, then we're done, the answer is just A. Otherwise, the GCD of A and B is the same as the GCD of B and the remainder we get by dividing A by B.

这里说的是：要计算两个数 A 和 B 的最大公约数，请执行以下操作。如果 B 为零，那么我们就完成了，答案就是 A。否则，A 和 B 的 GCD 与 B 和 A 除以 B 所得的余数的 GCD 相同。

And so we have a little description of that process in terms of Scheme. We also have a description here in terms of English. Let's see how we can actually build a machine out of very simple pieces that would do this computation. Well, here's a top-level view of how we're going to build that machine. We're going to need

因此，我们用 Scheme 对这个过程进行了简短的描述。我们这里也有一个用英语进行的描述。让我们看看如何用非常简单的部件实际构建一台能够执行此计算的机器。嗯，这是我们构建那台机器的顶层视图。我们将需要

Build that machine we're going to need some pieces, and in particular we're going to need some pieces to store numbers. We'll call those registers. They're shown here in the square boxes A, B, and T, all different registers. Think of those registers as being large enough to hold some representation in electronic form of a number. Of course, we'll need some way of moving information from one register to another. We'll have to have some way of getting values from one register into a different one, so we've got wires that connect those up.

构建那台机器，我们将需要一些部件，特别是需要一些存储数字的部件。我们将这些部件称为寄存器。它们显示在方框中，即 A、B 和 T，都是不同的寄存器。将这些寄存器视为足够大，能够以电子形式保存数字的某种表示。当然，我们需要某种方式将信息从一个寄存器移动到另一个寄存器。我们必须有某种方法将值从一个寄存器获取到另一个寄存器，因此我们有连接它们的导线。

got wires that connect those up and

有连接它们的导线，并且

got wires that connect those up and we've drawn a little circle with a cross in it to indicate that there's a way of controlling the movement along those wires little buttons that will we be able to push to say when we want information to flow from one register to another. besides registers and wires will also have or assume will have available to us some simple logic little units that we've gone and bought from a supplier somewhere and in this case we've assumed that we have one simple little piece of equipment one little circuit called remainder which is shown in that

有连接它们的导线，并且我们画了一个带十字的小圆圈来表示有一种控制沿这些导线移动的方式，即小按钮，我们可以按下它们来指示何时希望信息从一个寄存器流向另一个寄存器。除了寄存器和导线之外，我们还将拥有或假设拥有一些简单的逻辑，即我们从某个供应商那里购买的小单元，在这种情况下，我们假设我们有一个简单的小设备，一个称为余数的小电路，它显示在那个

remainder which is shown in that trapezoidal shaped box and it has two wires coming in and one wire going out, saying it's taking two inputs and giving us one output.

余数，它显示在那个梯形框中，它有两个输入导线和一个输出导线，表示它接受两个输入并给出一个输出。

And finally we'll need to have ways of testing things, checking to see whether in fact a value has a particular form or not. So we've got little tests shown in circles, like the equal tester up there — a little piece of circuitry — and it has a constant value, in this case zero, shown in the triangle that's passed into it.

最后，我们需要有测试事物的方法，检查一个值是否实际上具有特定形式。因此，我们有显示在圆圈中的小测试，比如上面的相等测试器——一个小电路——它有一个常量值，在这种情况下为零，显示在传入的三角形中。

And there are the pieces of our little circuit diagram in.

这些就是我们的小电路图的部件。

pieces of our little circuit diagram in

我们的小电路图的部件

pieces of our little circuit diagram in fact what we've drawn here as we'll see shortly is a data path a set of connections between the components of our little register machine that are going to let us move data around in particular order. In addition to our data paths, that is our little diagram that has wires and registers and components and circuits all glued together, we need a way of deciding how to move information around in that little system. We have to have an ordering or a controller that sequences how information is moved from one register

我们的小电路图的部件，事实上，正如我们很快将看到的，我们在这里绘制的是一个数据路径，即我们的小寄存器机器组件之间的一组连接，这些连接将允许我们以特定顺序移动数据。除了我们的数据路径，即我们的小图，其中有导线、寄存器、组件和电路都粘合在一起，我们还需要一种决定如何在该小系统中移动信息的方法。我们必须有一个排序或控制器来对信息如何从一个寄存器移动到另一个寄存器进行排序。

information is moved from one register to another for that we'll have a set of instructions and we're going to come back to this but the idea is to have a simple set of instructions that actually describe in what order to move things around.

信息从一个寄存器移动到另一个寄存器，为此我们将有一组指令，我们将回到这一点，但想法是有一组简单的指令，实际上描述以什么顺序移动事物。

for our purposes these instructions will look a lot like skiing in fact they're set up that way so that we could build a simulator to simulate the circuits inside of a register machine but this is not full scheme as we'll see these instructions have very particular forms and they basically allow us to do things

为了我们的目的，这些指令看起来很像 Scheme，事实上它们是这样设置的，以便我们可以构建一个模拟器来模拟寄存器机器内部的电路，但这不是完整的 Scheme，正如我们将看到的，这些指令具有非常特定的形式，它们基本上允许我们做事情

and they basically allow us to do things like decide whether a particular test is true or not, make a decision as to where to go based on that, and otherwise move information from one set of registers into another through the opening of one of those buttons on that previous diagram.

它们基本上允许我们做事情，比如决定特定测试是否为真，基于此决定去哪里，否则通过打开先前图表上的那些按钮之一，将信息从一组寄存器移动到另一组寄存器。

we will come back to the details of what these instructions mean in a second, and in fact we'll connect the two pieces together in a very important way. given that little circuit, given that dataflow with all the registers and pieces in it, and given a sequence of instructions.

我们稍后将回到这些指令的含义细节，事实上我们将以非常重要的方式将两个部分连接起来。给定那个小电路，给定具有所有寄存器和部件的数据流，并给定一系列指令。

and given a sequence of instructions we want to have the constructions control how things are actually moved around in the data paths so we'll have another unit in our little complete register machine called a sequencer it has inside of it a thing called a program counter

并给定一系列指令，我们希望让构造控制事物在数据路径中实际移动的方式，因此我们将在我们完整的寄存器机器中有另一个单元，称为序列器，它内部有一个称为程序计数器的东西。

and the program counter basically just keeps track of which instruction which line of it the instructions we're currently dealing with the sequencer will basically ask the instruction at that line to do its thing and then in general increment the program counter by one and move on to the next instruction

程序计数器基本上只是跟踪我们当前正在处理的指令，即指令的哪一行。序列器将基本上要求该行的指令执行其操作，然后通常将程序计数器加一，并继续下一条指令。

one and move on to the next instruction. As we'll see, most of the instructions will involve the equivalent of opening up one of those buttons in the little data flow diagram, that is moving information from one register into another, or potentially through one of those little circuits, one of those operation boxes, and into another register.

一个，然后继续下一条指令。正如我们将看到的，大多数指令都相当于打开数据流图中的那些按钮之一，也就是将信息从一个寄存器移动到另一个寄存器，或者可能通过那些小电路之一，那些操作框之一，再进入另一个寄存器。

Occasionally, however, the instruction will involve a test, and when that happens, a sequence of things occurs. First of all, using the little circuit that it does, the tester will cause a single bit to be output, a true or false.

然而，偶尔指令会涉及一个测试，当这种情况发生时，会发生一系列事情。首先，使用它所使用的小电路，测试器将导致输出一个单独的比特，即真或假。

single bit to be output a true or false, single bit to be output a true or false. If you like kind of value that output, if you like kind of value that output, if you like kind of value that output, wire goes to a special register called a, wire goes to a special register called a, wire goes to a special register called a condition register, and that sets a value, and that sets a value, and that sets a value in that condition register, that condition register that, in that condition register that condition register then is input to the sequencer, which looks at that bit and makes a decision.

输出一个单独的比特，真或假，输出一个单独的比特，真或假。如果你喜欢那种输出值，如果你喜欢那种输出值，如果你喜欢那种输出值，导线会进入一个称为条件寄存器的特殊寄存器，并在该条件寄存器中设置一个值，该条件寄存器然后作为输入进入序列器，序列器查看该比特并做出决定。

Depending on whether the bid is 1 or 0, the sequencer will either move on to the next instruction, or will go to some other place in the sequencer by changing the program counter or set. In other words, depending on what the value of that condition register is, the program counter may be.

根据该比特是1还是0，序列器要么继续执行下一条指令，要么通过改变程序计数器或设置来转到序列器中的其他位置。换句话说，取决于条件寄存器的值，程序计数器可能会。

register is the program counter may be incremented by one meaning go on to the next instruction or in fact it may be set to some very different value which will cause us to jump to another place in that sequence of instructions so there's what a register Sheen looks like.

寄存器是程序计数器可能会增加一，意味着继续下一条指令，或者实际上可能被设置为某个非常不同的值，这将导致我们跳到指令序列中的另一个位置，所以这就是寄存器机（register machine）的样子。

it's got a set of data paths connecting up registers wires little pieces of circuitry is got a sequence of instructions that decides how to move things around in that data path and it interacts with a little sequencer that lets us control that actual movement of data now what we're going to do is take

它有一组数据路径，连接寄存器、导线、小电路，它有一系列指令决定如何在该数据路径中移动东西，并且它与一个小序列器交互，让我们控制数据的实际移动。现在我们要做的是。

Data now what we're going to do is take these ideas, look at them in more detail, and see how we can start building up machines, beginning with very simple things, about working our way towards building the universal machine.

现在我们要做的是，将这些想法更详细地研究，看看我们如何开始构建机器，从非常简单的东西开始，逐步努力构建通用机器。

So let's look at what we have then. Here's a standard circuit diagram, as we'll see it's the circuit diagram or the data path for, in fact, the GCD machine. And we have inside of there the following: we have registers, which are places that hold numbers; we have operations, little pieces of circuitry that define our primitive kinds of things we have.

那么让我们看看我们有什么。这是一个标准的电路图，正如我们将看到的，它是电路图或数据路径，实际上是GCD机器的。我们里面有这些：我们有寄存器，它们是保存数字的地方；我们有操作，定义我们拥有的原始种类事物的小电路。

primitive kinds of things we have buttons that control movement from either operations or registers into other registers we have wires obviously to do the movement we've got places that hold a constant value for us and we have tests things that set a single bit on a condition register in order to help us decide where to go next and the behavior of each of the components is fairly straightforward a button when pressed causes the value on the input wire to flow through to the output a register is a storage place that holds a number or a

我们拥有的原始种类事物，我们有控制从操作或寄存器到其他寄存器移动的按钮，我们显然有导线来进行移动，我们有保存常量值的地方，我们有测试，在条件寄存器上设置单个比特以帮助我们决定下一步去哪里，每个组件的行为都相当直接：按钮按下时导致输入线上的值流过到输出；寄存器是一个存储位置，保存一个数字或。

a storage place that holds a number or a value if you like inside of it, but it has the property that it outputs that stored value continuously it is constantly putting that value onto its output wire it changes its value only when the button on the input wire is pressed and once it has done that change that new value is constantly output one

一个存储位置，保存一个数字或值，如果你喜欢，但它具有持续输出存储值的特性，它不断将该值放到其输出线上，只有当输入线上的按钮被按下时它才改变其值，一旦完成该改变，新值就持续输出。

of our operations one of our little pieces of circuitry has the property that the output wires value is always some function of the input wires values and that is also constantly output after us appropriately that is also constantly

我们的操作之一，我们的小电路之一，具有输出线的值总是输入线值的某个函数的特性，并且它也持续输出，适当地，它也持续。

us appropriately that is also constantly output on that output wire the same way a register is constantly outputting some value and a test as we saw is some operation that does some sort of computation much like ordinary operations with the difference that its output is a single bit either true or false which goes to at this condition register which is going to be used by the sequencer to decide whether or not to change the program counter in an unusual way let's start with a simple little example of how opening up these buttons on the wires moves information

适当地，它也持续输出在该输出线上，就像寄存器持续输出某个值一样，测试正如我们所见，是某种执行某种计算的操作，与普通操作类似，区别在于其输出是单个比特，真或假，进入条件寄存器，该寄存器将被序列器用来决定是否以不寻常的方式改变程序计数器。让我们从一个简单的例子开始，看看打开这些导线上的按钮如何移动信息。

buttons on the wires moves information around inside of a little register machine and in particular let's look at how we could go about incrementing a register so here's a little data path I've got a single operation ad that takes in two inputs and just adds their results out and I'd like to know what sequence of button presses will result in the register sum containing the value to note that initially we don't know what's inside of some it comes as a register but there could be anything inside of there so we've got to come up with a sequence of button

导线上的按钮在小型寄存器机器内部移动信息，特别地，让我们看看如何递增一个寄存器。所以这里有一个小数据路径，我有一个单一的操作“加”，它接受两个输入并将结果相加输出，我想知道哪一系列按钮按下会导致寄存器“和”包含值2。注意，最初我们不知道“和”里面有什么，它作为一个寄存器，但里面可能有任何东西，所以我们必须想出一系列按钮。

with a sequence of button presses that will move things around. Remember the outputs of the wires from each of these boxes are continuously outputting whatever that constant value is. Well, clearly the first thing I need to do is set some to be zero, zero it out, so that I can start from an initial point that I know about.

一系列按钮按下，将移动东西。记住，每个这些框的输出线持续输出那个常量值。显然，我需要做的第一件事是将“和”设置为零，清零，以便我能从一个已知的初始点开始。

So I'll open up the button X that allows the value 0 coming from that constant to flow through the wire into the Sun box, changing some to be zero, and some small amount of time later that will flow out of the some box, which is just a register.

所以我会打开按钮X，允许来自常量的值0流过导线进入“和”框，将“和”变为零，稍后它会从“和”框流出，这只是一个寄存器。

of the some box which is just a register into the output through the plus taking in the one and that will mean that the value 1 will now be coming out of the plus box notice that that is going to simply keep coming out of the plus box along that wire until it hits the button

从“和”框流出，这只是一个寄存器，进入输出，通过“加”接收1，这将意味着值1现在将从“加”框出来，注意这将持续从“加”框沿导线出来，直到它到达按钮。

Y now that value 1 is sitting in front of the Y button I've got a 1 available so what I could certainly do now is open up Y and push that into sum that is increment the sum register by 1 thus the value 1 flows into the sum register and as a consequence flows through the sum

Y，现在值1位于Y按钮前，我有一个1可用，所以我现在当然可以打开Y并将其推入“和”，即递增“和”寄存器1，因此值1流入“和”寄存器，并因此流过“和”。

As a consequence, flows through the sum register onto the output wire and therefore through the plus operation together at the constant 1, changing the output there to 2, which flows back around to the Y button so we can repeat this again. Pushing the Y button to let that value flow into some changes its value, and that value flows out and through the plus block. And now the value 3 is coming out of the plus box and has gone around that wire and is sitting in front of the Y button. But at this stage we're done; we've come up with the

因此，数值流过总和寄存器到达输出线，并通过加法操作与常数1相加，使那里的输出变为2，然后流回Y按钮，以便我们可以再次重复此过程。按下Y按钮让该值流入某个寄存器会改变其值，该值流出并通过加法块。现在值3从加法盒中流出，绕过那条线，停在Y按钮前。但在这个阶段我们已经完成了；我们已经得到了

We're done. We've come up with the sequence of button presses that gets the constant value 2 into the sum register, and the fact that there's a 3 coming out of the plus box doesn't matter. So in fact, we see that the sequence we want to use here is to press X followed by Y followed by Y, causing sum to increment up until it gets to the value 2.

我们完成了。我们已经得到了将常数2放入总和寄存器的按钮序列，而加法盒中出来的3并不重要。所以事实上，我们看到我们想要使用的序列是先按X，然后按Y，再按Y，使总和递增直到达到值2。

So we can see that coming up with the sequence of button pushes can let us move information around in a little register machine like this, getting things from registers through operations and back into registers.

所以我们可以看到，想出按钮按下的序列可以让我们在这样的微型寄存器机器中移动信息，将东西从寄存器通过操作再移回寄存器。

and back into registers so let's look at how we do GCD here again is the description of GCD and from this we can figure out a few things we'll need at least a register for a and a register for B since we've got to hold those two values we're going to need an equal tester in a constant 0 and we'll need a remainder box and we'll assume that that's available to us

并移回寄存器，所以让我们看看我们如何在这里做GCD。这里再次是GCD的描述，从中我们可以推断出一些事情：我们至少需要一个用于a的寄存器和一个用于B的寄存器，因为我们必须保存这两个值；我们将需要一个相等测试器、一个常数0，以及一个余数盒，我们假设这些对我们可用。

let's turn to building a little register machine that would compete gcd based on this description and this description in some sense tells us the order in which we ought to be pushing

让我们着手构建一个基于这个描述计算GCD的小型寄存器机器，这个描述在某种意义上告诉我们应该按按钮的顺序来移动东西。

order in which we ought to be pushing buttons to move things around the straightforward way to build a data path for GCD is as follows we know we're going to need two registers a and B well assume that initial values get loaded into them somehow that's not crucial

我们应该按按钮的顺序来移动东西。构建GCD数据路径的直接方法如下：我们知道我们需要两个寄存器a和B，我们假设初始值以某种方式加载到它们中，这不是关键。

and we'll need a little remainder box and the idea is very simple we'll take the value of a and B we'll compute the remainder and then we'll let that remainder be the new value for B

我们将需要一个小的余数盒，想法非常简单：我们将取a和B的值，计算余数，然后让该余数成为B的新值。

we'll let the value of B be the new value for a and we'll keep doing this until we get down to the last place when we're done

我们将让B的值成为a的新值，并继续这样做，直到我们到达最后一步，当我们完成时。

down to the last place when we're done, and of course we know we're done when the value of B is equal to zero, in which case the answer sitting in A. We haven't with the test box in there we can imagine doing that.

当我们完成时到达最后一步，当然我们知道当B的值等于零时我们就完成了，在这种情况下答案在A中。我们没有测试盒，但我们可以想象这样做。

Notice that we've got a slight problem though, and the problem is one of synchronization. Let's suppose I open up the button Y, that means the value coming out a remainder will go straight into B. Oops, but I wanted to get the value of B into A, and I've already clobbered that before I could do it. Okay, let's suppose I open up X first.

注意我们有一个小问题，即同步问题。假设我打开按钮Y，这意味着从余数出来的值将直接进入B。哎呀，但我想把B的值放入A，而我已经在能够做到之前破坏了它。好吧，假设我先打开X。

Let's suppose I open up X first. I'll let B flow into A, so I can safely move the remainder in there. Oops, by doing that, I've done that before; I can actually get the remainder of A and B out of the remainder box. So again, I've messed things up. Ah, this suggests I need to add something that will temporarily hold a value while I can move things around.

假设我先打开X。我将让B流入A，这样我可以安全地将余数移到那里。哎呀，通过这样做，我已经在之前做了那件事；我实际上可以从余数盒中取出A和B的余数。所以我又搞砸了。啊，这建议我需要添加一些东西来临时保存一个值，同时我可以移动东西。

Notice in this case of simple register machines, we have to think about how to synchronize the movement of information, which we didn't have to do in higher-level things like a Val. So let's modify.

注意在这种简单寄存器机器的情况下，我们必须考虑如何同步信息的移动，而在更高级的东西如Val中我们不必这样做。所以让我们修改。

level things like a Val so let's modify

更高级的东西如Val，所以让我们修改

level things like a Val so let's modify our diagram to put in a temporary register and another button so we can actually control when things come out of the remainder box into a register and when things go from that register either into B or into a so now let's think about the order in which we want to open up the buttons XY and Z in order to allow information to correctly flow through this data path in order to compute the GCD well here's the sequence assuming we have some values loaded into a and B somehow the first thing we want to do is get that remainder and save it

更高级的东西如Val，所以让我们修改我们的图，放入一个临时寄存器和一个额外的按钮，这样我们可以实际控制何时将东西从余数盒中取出到寄存器中，以及何时将东西从该寄存器进入B或a。现在让我们考虑为了正确计算GCD，我们想要打开按钮X、Y和Z的顺序，以允许信息正确流过这个数据路径。好吧，这是序列，假设我们以某种方式在a和B中加载了一些值，我们想要做的第一件事是获取余数并将其保存起来。

To do is get that remainder and save it away, so we open up Z to remove the remainder down into T temporarily. Having held onto that, we now can go ahead and change the values of A and B, but we need to do them in the right order. We need to open up X to move the current value of B into A. Having done that, we can then safely move the new thing into B by opening up Y, so that the remainder flows into there.

要做的就是获取余数并将其保存起来，所以我们打开Z将余数暂时移到T中。既然已经保存了它，我们现在可以继续更改A和B的值，但我们需要以正确的顺序进行。我们需要打开X将B的当前值移入A。完成之后，我们可以通过打开Y安全地将新东西移入B，这样余数就流入那里。

Having done that, we can then go through exactly the same sequence again. We can compute the new remainder by opening up Z, let the new value of B even flow into there.

完成之后，我们可以再次经历完全相同的序列。我们可以通过打开Z计算新的余数，让B的新值甚至流入那里。

Z let the new value of B even flow into a because we've hold it held on temporarily to what we need and having cleared B we can then open up Y to move the remainder into B and at this stage if we had our tester we'd know that we're done and we can stop notice a couple of things here one is that the order in which we actually do things now matters we've got to make sure we clear one register before we clobber it with the new value and the second thing to notice is that we have a loop if you like here we're going through the same sequence of operations Z then X then Y Z

Z让B的新值甚至流入a，因为我们暂时保存了我们需要的值，并且清除了B之后，我们可以打开Y将余数移入B，在这个阶段如果我们有测试器，我们会知道我们完成了，可以停止。注意这里有两件事：一是我们现在做事的顺序很重要，我们必须确保在用一个新值覆盖一个寄存器之前先清除它；二是注意我们这里有一个循环，我们正在经历相同的操作序列Z然后X然后Y Z

sequence of operations Z then X then Y Z, then X then Y and we keep doing that, then X then Y and we keep doing that, then X then Y and we keep doing that, until our tests actually help we'll come back to that shortly now we need to actually describe somehow that sequence of operations that order of button pushes and for that we have a set of instructions here's the basic form of the instructions for GCD and we want to talk through the kinds of things we can have in these instructions as we noted earlier while these look like scheme expressions don't be fooled they're simply set up that way so that we can write an evaluator for this.

操作序列Z然后X然后Y Z，然后X然后Y，我们不断这样做，然后X然后Y，我们不断这样做，直到我们的测试实际上帮助我们，我们稍后会回到这一点。现在我们需要实际描述那个操作序列，即按钮按下的顺序，为此我们有一组指令。这里是GCD指令的基本形式，我们想讨论这些指令中可以包含的各种东西。正如我们之前注意到的，虽然这些看起来像Scheme表达式，但不要被愚弄，它们只是以这种方式设置，以便我们可以为这个编写一个求值器。

we can write an evaluator for this register machine using the same kind of syntax, but in fact the instructions in this little register machine have a very simple form. The first kind of instruction is an assign instruction, and notice its format: assign takes the name of a register, and in some cases simply a designation for another register, such as open paren reg B. And what that is saying to do is to open up the button that moves the contents of register B into register A. Assign can also have a button that moves the contents through an

我们可以用同样的语法为这个寄存器机器编写一个求值器，但实际上这个小型寄存器机器中的指令形式非常简单。第一种指令是赋值指令，注意它的格式：assign 接受一个寄存器的名称，有时也接受对另一个寄存器的指定，例如 (reg B)。它的意思是打开那个将寄存器 B 的内容移入寄存器 A 的按钮。assign 也可以有一个按钮，让内容通过一个

that moves the contents through an operation box so notice that the first assign a statement here says take the button and open it that causes the values of register a and register B to flow through the remainder box and into register T also notice that these instructions define in some sense the connections that have to be in place within the data flow path itself

让内容通过一个运算盒，所以请注意，这里的第一个 assign 语句说：打开那个按钮，使得寄存器 A 和寄存器 B 的值通过余数盒流入寄存器 T。还要注意，这些指令在某种意义上定义了数据流路径本身内部必须存在的连接。

other instructions in our language deal with branching ways of testing something setting a digital condition register and then going someplace within the instruction set and those places to go

我们语言中的其他指令处理分支方式，即测试某些东西、设置一个数字条件寄存器，然后在指令集内跳转到某个地方，而那些跳转的目标

Instruction set and those places to go to are simply created by putting labels inside of the instruction set, and we'll come back to that shortly. But here basically is the sequence of instructions we have, and let's talk about how we're going to use those to connect to the data path, to connect our instructions to our data machine.

跳转的目标只是通过在指令集中放置标签来创建的，我们稍后会回到这一点。但这里基本上是我们拥有的指令序列，让我们讨论如何利用这些指令来连接到数据路径，将我们的指令连接到数据机器。

We have a controller that generates a sequence of button presses, opens up the valves if you like on those wires. It consists of two parts: a sequencer and a set of instructions. Now, the sequencer is our way of actually

我们有一个控制器，它生成一系列按钮按压，如果你愿意的话，可以打开那些导线上的阀门。它由两部分组成：一个序列器（sequencer）和一组指令。现在，序列器是我们实际

The sequencer is our way of actually activating the instructions, and inside of that sequencer there's a special register called a program counter. It basically points to the location in memory that holds the next instruction, or if you like, has the line number of the next instruction.

序列器是我们实际激活指令的方式，在序列器内部有一个特殊的寄存器，称为程序计数器。它基本上指向内存中保存下一条指令的位置，或者如果你愿意，可以说它保存着下一条指令的行号。

The operation of this sequencer is to basically activate each instruction in turn, using the program counter to say where's the instruction, cause that instruction to be activated, which will generally open up a button and have some information flow through the machine, and then increment.

这个序列器的操作基本上是依次激活每条指令，使用程序计数器来指示指令在哪里，使该指令被激活，这通常会打开一个按钮并让一些信息流过机器，然后递增。

through the machine and then increment the program counter by one, moving on to the next sequence. And it will keep doing that in order until it hits a particular kind of instruction.

让信息流过机器，然后将程序计数器加一，继续下一个序列。它会按顺序一直这样做，直到遇到某种特定类型的指令。

The instructions generally will just command a button press that is, cause information to flow through some portion of the Machine and into a new register. Or, in some cases, it will cause the program counter to change.

指令通常只会命令一次按钮按压，也就是说，让信息流过机器的某个部分并进入一个新的寄存器。或者，在某些情况下，它会导致程序计数器改变。

We call these branch instructions, and we're going to see that we'll have several kinds of branches. These will generally involve either changing the

我们称这些为分支指令，我们将看到会有几种分支。这些通常涉及要么改变

generally involve either changing the

通常涉及要么改变

generally involve either changing the program counter directly or setting up a test that puts a bid into the condition register that lets the program counter change but those are the flavors of our instructions they generate a sequence of button presses causing information to flow through the data paths of the register machine and what we can do now is put these pieces together to start building more interesting kinds of register machines so let's go back to our little example of incrementing a sum there's the data path we had before and we can start to describe the sequence of

通常涉及要么直接改变程序计数器，要么设置一个测试，将一个位放入条件寄存器，从而允许程序计数器改变，但这些就是我们指令的类型：它们生成一系列按钮按压，使信息流过寄存器机器的数据路径。我们现在能做的就是将这些部分组合起来，开始构建更有趣的寄存器机器。所以让我们回到我们的小例子，即递增一个和。那里有我们之前的数据路径，我们可以开始描述操作的序列。

We can start to describe the sequence of operations. In fact, if you go back to that slide, you'll see we can do it very directly. First, we open up the X button that moves the constant 0 into the sum register. And our description for that in terms of our instructions says assign into the sum register the output of the constant 0. Notice this implicitly also defines the data path that I need to have that connection.

我们可以开始描述操作的序列。事实上，如果你回到那张幻灯片，你会看到我们可以非常直接地做到这一点。首先，我们打开 X 按钮，将常量 0 移入 sum 寄存器。我们用指令来描述就是：将常量 0 的输出赋给 sum 寄存器。注意，这隐含地也定义了数据路径，我需要有那个连接。

The next instruction then says open up 1, that is a sign into the sum register what I get by letting the things from sum and the...

下一条指令说打开 1，也就是将 sum 和常量 1 通过加法运算后得到的结果赋给 sum 寄存器，再通过那个按钮 Y 进入 sum。注意，这隐含地定义了需要连接什么，并控制序列器。

By letting the things from sum and the constant one flow through the operation of plus and back in through that button, Y into some notice a game this implicitly defines what needs to be connected and controls the sequin.

通过让 sum 和常量 1 的东西流过加法运算，再通过那个按钮 Y 进入 sum。注意，这隐含地定义了需要连接什么，并控制序列器。

Now, of moving a value into sum and then we saw to get the constant two in there, we needed to open up Y again letting another value flow through and there's the sequence of operations we need.

现在，将一个值移入 sum，然后我们看到为了得到常量 2，我们需要再次打开 Y，让另一个值流过，这就是我们需要的操作序列。

But of course we don't want to have to keep writing a new line for every increment we'd like to do here; we'd really like to write a little loop that says keep.

但当然，我们不想为每次递增都写一行新代码；我们真的想写一个小循环，说继续

write a little loop that says keep opening up Y until you get to the right point so how could we adjust this to allow for the sequencer to keep opening up Y moving a new value into some and incrementing some as many times as we'd like well here's the simplest kind of branch that we can have in our sequence of instructions called an unconditional branch notice the change we make in the little controller we still have our assign of sounder the constant zero our starting point but then we put in a label called increment in this case but

写一个小循环，说继续打开 Y，直到达到正确的点。那么，我们如何调整这个，以允许序列器继续打开 Y，将新值移入 sum，并尽可能多次地递增 sum 呢？好吧，这是我们在指令序列中可以拥有的最简单的一种分支，称为无条件分支。注意我们在小控制器中做的改变：我们仍然有将 sum 赋为常量 0 的赋值作为起点，但然后我们放了一个标签，在这个例子中称为 increment，但

label called increment in this case but a marker that keeps track of where we are we're not actually going to give a line number to that we'll only we'll put a number on the lines that involve some actual movement of things in the data diagram but immediately below that we have that assignment of sum to be a new operation and whereas before we would have done an additional call or additional instruction for signing some we're going to put in a special instruction called a go-to and that go-to says go to the label increment in terms of the little sequence of

标签称为 increment，但这是一个标记，用来跟踪我们所在的位置。我们实际上不会给它一个行号，我们只会在涉及数据图中实际移动事物的行上放一个数字。但紧接其下，我们有那个将 sum 赋为新操作的赋值，而之前我们会做一个额外的调用或额外的指令来赋值 sum，现在我们将放入一个称为 go-to 的特殊指令，这个 go-to 说转到标签 increment。就小指令序列而言，

terms of the little sequence of instructions, it's basically saying jump back to that label and keep following through the instructions starting at that point.

就小指令序列而言，它基本上是说跳回那个标签，并从那个点开始继续执行指令。

In terms of what happens inside of our sequencer, think of it as follows: we have some value sitting in the program counter, and initially we're going to add one to that and put that into a temporary register called the next PC or the next program counter value.

就我们序列器内部发生的事情而言，可以这样理解：程序计数器中存有一个值，最初我们会将其加一，并将结果放入一个临时寄存器，称为下一个PC或下一个程序计数器值。

We will then go off and activate the instruction at the point that program counter indicates, the line number that is indicated by what's in currently in.

然后我们会去激活程序计数器所指示的那条指令，即当前程序计数器中内容所指示的行号。

is indicated by what's in currently in PC typically that will be the next instruction activating that instruction will usually just cause some button to be open and some values to flow through the data path so that then we can update the program counter with what we stored away in next PC and that will typically therefore point to the next value or the next instruction and we'll keep walking through this sequence we'll just keep doing this.

通常，激活那条指令只会导致某个按钮被打开，一些值在数据通路中流动，然后我们可以用存储在下一个PC中的值来更新程序计数器，这样它通常会指向下一个值或下一条指令，我们将继续沿着这个序列走下去，不断重复这个过程。

notice however that if the instruction pointed to by the program counter is one of these go twos that

但请注意，如果程序计数器指向的指令是这些“跳转”指令之一，

counter is one of these go twos that will actually directly write a different value into next PC the value of the corresponding to where increment is which is the value one if you like the next line will get installed into PC when we evaluate line two and this will cause the sequencer to jump to a different point in the instructions other than the next instruction and their pair for pick up the computation at that point in fact let's look at this little system to see what happens we start off with the program counter at zero and therefore the sequencer sets next PC to one

计数器指向的是这些“跳转”指令之一，那么它实际上会直接向下一个PC写入一个不同的值，即对应于增量标签的值，也就是1，如果你愿意，下一行将在我们评估第二行时被装入PC，这将导致序列器跳转到指令序列中的另一个点，而不是下一条指令，并从那里继续计算。事实上，让我们看看这个小系统会发生什么：我们从程序计数器为零开始，因此序列器将下一个PC设置为1。

The sequencer sets next PC to one temporarily and evaluates the instruction at PC that basically says open up button X, assign the constant zero into some. Having done that, we put that temporary next PC value into the program counter and go back around the sequencer, then sets up a new value in the next PC, puts a 2 in there.

序列器暂时将下一个PC设置为1，并评估PC处的指令，该指令基本上是说打开按钮X，将常量0赋给某个变量。完成之后，我们将那个临时的下一个PC值放入程序计数器，然后回到序列器，再在下一个PC中设置一个新值，放入2。

And then it evaluates the instruction at line 1, which basically opens up button Y, moving the value in some and the constant one through the plus and around and into some again, therefore putting a 1 into some. Having done that, this value in next

然后它评估第1行的指令，该指令基本上打开按钮Y，将某个变量中的值和常量1通过加法器，再回到某个变量，因此将1放入某个变量。完成之后，这个下一个PC中的值

Some having done that, this value in next PC is restored to PC, namely a to only go back around. At this stage, the sequencer puts a 3 temporarily into the next PC and operates or activates the instruction at to where the program counter is pointing to.

某个变量完成之后，这个下一个PC中的值被恢复到PC，即2，然后再次循环。此时，序列器暂时将3放入下一个PC，并操作或激活程序计数器指向的第2行的指令。

But in this case, this is a go-to, and what that does is it rewrites into next PC the line number or the pointer location corresponding to the label increment, namely a 1. So it changes next PC. Notice, nothing to press here; there's no instruction that causes a button to be pressed, so we now put.

但在这种情况下，这是一个跳转指令，它所做的是将对应于标签“增量”的行号或指针位置重写进下一个PC，即1。所以它改变了下一个PC。注意，这里没有要按的按钮；没有指令导致按钮被按下，所以我们现在将

A button to be pressed, so we now put what's in next PC into PC and go back around. Aha, that means we've put a 1 into PC. We set up next PC to be a 2 temporarily, and we evaluate the instruction at 1 we've just loaded. Therefore, we open the button Y, a new value flows into sum, and we go and put next PC into the PC, putting a 2 there, and start a game again.

没有按钮被按下，所以我们现在将下一个PC中的内容放入PC，然后循环回去。啊哈，这意味着我们将1放入了PC。我们暂时将下一个PC设置为2，并评估我们刚刚加载的第1行的指令。因此，我们打开按钮Y，一个新的值流入总和，然后我们将下一个PC放入PC，将2放入那里，然后再次开始游戏。

And this is just like before. We now put a 3 temporarily into the next PC, evaluate the instruction at 2 that says, oh, change next PC to have the label 1 corresponding to the increment there, and go around. So in fact, we now have an

这就像之前一样。我们现在暂时将3放入下一个PC，评估第2行的指令，该指令说，哦，将下一个PC改为具有标签1，对应于那里的增量，然后循环。所以事实上，我们现在有了一个

Around so, in fact, we now have an unconditional branch. We're going to loop forever, adding a 1 into either value in sum and constantly incrementing it. But we see that, in fact, by changing what the sequencer looks at, we can jump to places in the sequence of instructions.

循环，所以事实上，我们现在有了一个无条件分支。我们将永远循环，将1加到总和中的值上，并不断递增它。但我们看到，事实上，通过改变序列器所查看的内容，我们可以跳转到指令序列中的不同位置。

Of course, unconditional branches, while useful, aren't always what we want. They're going to create an infinite loop in which we keep, for example, in that little sum case, adding one into what's in sum and doing so until we overflow the register. What we need is a way of deciding when we...

当然，无条件分支虽然有用，但并不总是我们想要的。它们会产生一个无限循环，例如，在刚才那个总和的情况下，我们会不断将1加到总和中的值上，直到寄存器溢出。我们需要一种方法来决定何时……

we need as a way of deciding when we want a branch or not so let's go back to our GCD case and think about what we might like. remember in GCD we saw that we wanted to open up a sequence of buttons in a particular order first moving a value into T then moving B into a then moving what's and T up into b-but repeating that process and so in fact we could create a little loop using one of these unconditional branches stick a label in and have a go to that takes us back around and runs through this sequence of operations the problem is we'll keep

我们需要一种方法来决定何时进行分支，所以让我们回到GCD案例，思考我们可能想要什么。记住，在GCD中，我们看到我们想要按特定顺序打开一系列按钮：首先将值移入T，然后将B移入A，然后将T中的值移入B——但重复这个过程，所以事实上，我们可以使用一个无条件分支来创建一个小循环，放置一个标签，并有一个跳转指令将我们带回循环，运行这一系列操作。问题是我们会不断

operations the problem is we'll keep doing that ad infinitum we'd like to know when to stop and just return the value that we have in a so we need a way of testing to do that we not only add a test box to our system but we set up a particular condition for the sequencer.

操作，问题是我们会无限地这样做；我们想知道何时停止，并返回A中的值，所以我们需要一种测试的方法。为此，我们不仅向系统添加一个测试框，还为序列器设置一个特定条件。

remember that a test operation will do whatever the appropriate piece of circuitry is and then output a single bit that goes into what's called the condition register this bit in essence corresponds to true or false thus in my example here the first line under the

记住，测试操作将执行适当的电路操作，然后输出一个位，进入所谓的条件寄存器。这个位本质上对应于真或假。因此，在我的示例中，标签“测试B”下的第一行是一个测试操作，它说使用连接“等于”输出的导线，给定适当的输入，并将其直接放入条件寄存器，在那里设置一个点。记住，

example here the first line under the label test B is a test operation that says use the wire connecting the output of equal given the appropriate inputs and put that directly into the condition register set up a point there remember.

示例中标签“测试B”下的第一行是一个测试操作，它说使用连接“等于”输出的导线，给定适当的输入，并将其直接放入条件寄存器，在那里设置一个点。记住，

remember that the sequencer automatically goes on to the next instruction so having done this test operation and setting a bit in the condition register the sequencer will take us to the next instruction and there we have what's called a branch instruction.

记住，序列器会自动转到下一条指令，所以执行了这个测试操作并在条件寄存器中设置了一个位之后，序列器将带我们到下一条指令，那里有一个所谓的分支指令。

the branch instruction when executed by the sequencer in essence.

分支指令，当由序列器执行时，本质上

Executed by the sequencer in essence, it does the following: it says check the condition bit. If the condition bit is true, then overwrite what's in the PC counter, take that label G.C. done wherever it points to, and slam that into next PC. In that case, it will cause the sequencer to jump to that point.

由序列器执行时，本质上它执行以下操作：它说检查条件位。如果条件位为真，则覆盖PC计数器中的内容，取那个标签G.C.完成所指向的位置，并将其塞入下一个PC。在这种情况下，它将导致序列器跳转到那个点。

On the other hand, if the condition bit is false, we won't do anything, which means the next PC will automatically drop down to the next instruction. So now we have a conditional branch in which we test the value of something, and when based on what that value is, either continue on with the...

另一方面，如果条件位为假，我们不会执行任何操作，这意味着下一条PC将自动下降到下一条指令。因此，现在我们有了一个条件分支，在其中我们测试某个值，并根据该值是什么，要么继续执行紧接其后的指令序列，要么跳转到某个特定点。

value is either continue on with the sequence of instructions immediately after the next one or jump to a particular point here then are the details of gain of a conditional branch. We have an instruction in our sequencer of the form test this basically says push the button which loads the condition register from this operations output notice again that this description also describes what wires need to be connected the operation equal must have a wire from register B and a wire from the constant 0 into it and test causes the output of that operation

值要么继续执行紧接其后的指令序列，要么跳转到某个特定点。以下是条件分支的细节。在我们的序列器中有一条形式为“test”的指令，它基本上是说按下按钮，将条件寄存器从该操作的输出加载。再次注意，这个描述也描述了需要连接哪些导线：操作“equal”必须有一条来自寄存器B的导线和一条来自常量0的导线，而“test”导致该操作的输出被设置到与测试相关联的条件寄存器中。

test causes the output of that operation equal to set a bit into the condition register associated with that test.

“test”导致操作“equal”的输出在条件寄存器中设置一个位，该位与测试相关联。

instruction will be a branch instruction the instruction immediately below it in almost all cases the branch instruction has as its piece a label that says where to jump to if I want to have things happen again there should be some label is simply put into the code somewhere.

指令将是分支指令。在几乎所有情况下，紧接其下的指令的分支指令都有一个标签作为其组成部分，说明如果要再次发生某些事情，应该跳转到哪里。这个标签只是简单地放在代码中的某个位置。

the effect of a branch instruction is to overwrite the next PC register with that value that point in the sequence of instructions if the conditioned register

分支指令的效果是，如果条件寄存器为真，则用指令序列中该点的值覆盖下一条PC寄存器。

instructions if the conditioned register is true this means if the conditioned register is true one cycle later we're going to jump to that point on the other hand if the conditioned register is false nothing is done branch simply is skipped and that means the sequencer will go automatically to the next instruction in the sequence

如果条件寄存器为真，这意味着如果条件寄存器为真，一个周期后我们将跳转到该点。另一方面，如果条件寄存器为假，则不执行任何操作，分支只是被跳过，这意味着序列器将自动转到序列中的下一条指令。

so we've now seen how to design register machines to compute what are basically iterative operations GCD being one great example some being another one notice we've pointed out though that the instruction sequences we generate here always

因此，我们现在已经看到了如何设计寄存器机器来计算基本上是迭代的操作，GCD是一个很好的例子，另一个是求和。注意，我们已经指出，我们在这里生成的指令序列总是隐含着关于数据路径的信息。

Sequences we generate here always contain implicitly information about what the data paths are in fact just given the instruction sequence we could always draw what the data flow diagrams look like. So as a consequence, we can just skip the data path when describing a register machine.

我们在这里生成的序列总是隐含着关于数据路径的信息。事实上，仅凭指令序列，我们总能画出数据流图的样子。因此，作为结果，在描述寄存器机器时，我们可以跳过数据路径。

We simply need to think about what registers do we want, what operations do we want, and what sequence of instructions do we need to do to move information around. That will make life a little easier for us as we design bigger register machines.

我们只需要考虑我们想要哪些寄存器，我们想要哪些操作，以及我们需要哪些指令序列来移动信息。这将使我们在设计更大的寄存器机器时生活更轻松一些。

Notice as well that every operation we've used

还要注意，我们使用的每个操作

design bigger register machines notice as well that every operation we've used

设计更大的寄存器机器时，还要注意，我们使用的每个操作

Additionally, every operation we've used so far in our register machines has been fairly abstract. By abstract, we mean we've assumed that we can buy a little circuit that computes things like equal, or remainder, or sum, or minus, or any other such operation. At some level, that's okay, but here abstraction really means that there are a set of multiple lower level operations that will implement that particular idea.

此外，到目前为止，我们在寄存器机器中使用的每个操作都相当抽象。所谓抽象，我们指的是我们假设可以购买一个小电路来计算诸如相等、余数、和、差或任何其他此类操作。在某种程度上，这是可以的，但在这里抽象实际上意味着有一组多个较低级别的操作将实现那个特定的想法。

Now, some of those lower level operations are going to involve basic hardware and gates, or gates—the kinds of things you'll deal with in six double of two.

现在，其中一些较低级别的操作将涉及基本的硬件与门、或门——这些是你在6.002中会处理的东西。

You'll deal with in six double of two and six double O four and for our purposes it's convenient to assume that we do have a basic set of primitive pieces of circuitry that we're just going to rely on.

你会在6.002和6.004中处理这些东西，为了我们的目的，方便的做法是假设我们确实有一组基本的原始电路部件，我们将依赖它们。

Some of those lower-level operations however might themselves be just sequences of register machine instructions.

然而，其中一些较低级别的操作本身可能只是寄存器机器指令的序列。

Well, it's reasonable to assume that I could go out and buy an equal tester or a plus operation.

嗯，假设我可以出去买一个相等测试器或一个加法操作是合理的。

What about remainder? Well, in fact, we probably want to be able to build those things just out of manipulation of much simpler register machine instructions.

那余数呢？事实上，我们可能希望能够仅通过操作更简单的寄存器机器指令来构建这些东西。

simpler register machine instructions so now let's go back in and see how we can replace this single instruction assuming we have a remainder box with a sequence of instructions that actually builds remainder directly out of much simpler operations.

更简单的寄存器机器指令，所以现在让我们回去看看如何用一系列指令替换这个单一指令，假设我们有一个余数盒子，用一系列指令直接通过更简单的操作构建余数。

so here's our sequence of instructions for GCD the only change we've made is where before we would have had an assign statement that ran directly through a remainder box we've set up a little loop and notice what that loop does the loop moves the contents of register a into a temporary

所以这是我们的GCD指令序列，我们做的唯一改变是，以前我们会有一个直接通过余数盒子的赋值语句，现在我们设置了一个小循环，注意这个循环的作用：循环将寄存器a的内容移到一个临时寄存器中。

contents of register a into a temporary

寄存器a的内容移到一个临时寄存器中。

contents of register a into a temporary register T which says we're going to have to have a new register use there and then what do we do we check to see if T is less than B or rather the contents of register T are less than the contents of register B if they are our sequencer will jump straight down to the label REM done and we're set we've computed the remainder and we can carry on as before if it's not then we'll subtract what's in B from T put that into T and go back around through the loop checking again to see if we have something so basically we're computing

寄存器a的内容移到一个临时寄存器T中，这意味着我们将不得不使用一个新的寄存器，然后我们检查T是否小于B，或者更确切地说，寄存器T的内容是否小于寄存器B的内容。如果是，我们的序列器将直接跳到标签REM DONE，我们就完成了，我们已经计算了余数，可以像以前一样继续。如果不是，那么我们将从T中减去B中的内容，将结果放入T，然后回到循环中再次检查我们是否有东西。所以基本上我们是在计算

something so basically we're computing remainder by successively subtracting B units off of what's in T until we get something that's small enough that we can actually do the work we want to do.

所以基本上我们是通过从T中连续减去B的单位来计算余数，直到我们得到足够小的东西，以便我们能够做我们想做的操作。

this means we've replaced that single assign instruction with a loop that does the computation for us directly notice that now our sequence of instructions has two loops in it it has the bigger loop between GC done and test B that goes through the computation to get the next stage in GCD and it has an inner loop between REM loop and REM done that

这意味着我们已经用循环替换了那个单一的赋值指令，该循环直接为我们进行计算。注意，现在我们的指令序列中有两个循环：一个是在GC DONE和TEST B之间的较大循环，它通过计算得到GCD的下一阶段；另一个是在REM LOOP和REM DONE之间的内循环，它

循环在REM loop和REM done之间进行实际计算，余数部分我们将在下一次讨论内部循环时再回来。事实上，我们想要利用那个想法。那个想法是什么？原则上，我可以编写一组非常原始的寄存器机器指令来计算余数或其他操作，但我想知道完成后能否提取出这个想法。

循环在REM LOOP和REM DONE之间进行实际计算，余数部分我们将在下一次讨论内部循环时再回来。事实上，我们想要利用那个想法。那个想法是什么？原则上，我可以编写一组非常原始的寄存器机器指令来计算余数或其他操作，但我想知道完成后能否提取出这个想法。

先等一等，为什么我要抽象化它呢？因为我们将要讨论构建一个求值器，一个中央处理器，显然这是一个非常复杂的设备。

先等一等，为什么我要抽象化它呢？因为我们将要讨论构建一个求值器，一个中央处理器，显然这是一个非常复杂的设备。

Clearly a very complicated device, and we're really only interested in the core of the CPU eval and apply, so we're going to use abstract register machine operations for all of the other instruction sequences and circuits.

显然是一个非常复杂的设备，而我们真正感兴趣的只是CPU的核心，即eval和apply，所以我们将为所有其他指令序列和电路使用抽象的寄存器机器操作。

Things like self-evaluating, we'll assume is just simply some operation. It's not any different than what I did before. I'm treating plus or less than as abstract self-evaluating, and it's going to do a similar thing. There's no particular magic there. If I needed to, I could build it out of a sequence of register operations, but for simplicity.

像自我评估这类事情，我们假定它只是某种操作。它与我之前所做的并无不同。我将加或小于视为抽象的自我评估，它将做类似的事情。这里没有什么特别的魔力。如果需要，我可以用一系列寄存器操作来构建它，但为了简化起见。

register operations but for simplicity as we get around to building our CPU we're just going to assume that there's

寄存器操作，但为了简化，当我们着手构建CPU时，我们只是假定存在……