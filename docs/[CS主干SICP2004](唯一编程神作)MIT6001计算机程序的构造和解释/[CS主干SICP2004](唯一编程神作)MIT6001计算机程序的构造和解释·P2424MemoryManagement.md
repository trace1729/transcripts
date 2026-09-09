# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=24)

If we step back from our recent forays into the details of the Machine and take a look at what we have, here's a pretty good block diagram of the structure of our register machine. We said we wanted to be able to register machine that would implement eval our explicit control evaluator, and we did this with a set of seven registers plus a set of primitive operations.

如果我们从最近对机器细节的探讨中退后一步，审视一下我们所拥有的，这里有一个相当不错的框图，展示了我们的寄存器机器的结构。我们说过，我们希望构建一个能够实现 eval（我们的显式控制求值器）的寄存器机器，而我们通过一组七个寄存器加上一组基本操作做到了这一点。

And of course those all need to be connected together, and we can do that using what's known as a bus structure in which we have a wire that connects up all of the

当然，所有这些都需要连接在一起，我们可以使用所谓的总线结构来实现，其中有一条导线将所有

have a wire that connects up all of the registers to all of the boxes and allows us to arbitrarily place arguments from anyone or perhaps a pair of different registers through one of these primitive operations and then back around and into some other register and of course all of that will be controlled by the sequence of instructions and the program counter that tells us how to move things through one of those primitive operations and back around into a register now in addition to those seven registers and the operations that are going to manipulate things in them to cause eval

有一条导线将所有寄存器连接到所有运算盒，并允许我们任意地将来自任何一个或可能一对不同寄存器的参数通过其中一个基本操作，然后再绕回并进入另一个寄存器。当然，所有这些都将由指令序列和程序计数器控制，程序计数器告诉我们如何将数据通过这些基本操作之一移动并绕回寄存器中。现在，除了这七个寄存器和那些用于操作其中内容以实现 eval 的操作之外，

manipulate things in them to cause eval to be implemented we also needed to have a way of saving away State we needed a stack or if you like a big collection of registers into which we could store temporarily values that we wanted to keep hold of until we needed them later on in a computation so the stack of course has to also be connected both to the registers and to the primitive operation so we can manipulate from there now the last piece of the register machine is something we actually haven't talked about much yet and that's

操作其中内容以实现 eval，我们还需要一种保存状态的方法。我们需要一个栈，或者如果你愿意，可以称之为一大组寄存器，我们可以在计算过程中将暂时不需要的值存储在其中，直到稍后需要它们。因此，栈当然也必须连接到寄存器和基本操作，以便我们可以从那里进行操作。现在，寄存器机器的最后一部分是我们实际上还没有怎么讨论过的东西，那就是

Talked about much yet and that's something known as the heap. The heap is just a large collection of memory cells, or if you want to think of them that way, registers into which we can store data structures.

还没有怎么讨论过的东西，那就是所谓的堆。堆只是一大组内存单元，或者如果你愿意这样想的话，是寄存器，我们可以在其中存储数据结构。

And in fact we've seen in our evaluator that we have a big need for data structures. We use list representations or pairs if you like to represent expressions, to represent environments, to represent intermediate states of computation.

事实上，我们在求值器中已经看到，我们对数据结构有巨大的需求。我们使用列表表示或如果你愿意，使用序对来表示表达式、表示环境、表示计算的中间状态。

So we need to also connect a very large set of places to store data in a heap that connects back into our register machine and indeed

因此，我们还需要连接一个非常大的存储数据的地方，即堆，它连接回我们的寄存器机器，而且确实

into our register machine and indeed many of those abstract operations we used manipulating the environment or manipulating the expression structures as tree structure are going to take place in the heap moving things in and out of the heap through the primitive operations and into registers for computation.

连接回我们的寄存器机器，而且确实，我们用于操作环境或操作表达式结构（如树结构）的许多抽象操作都将在堆中进行，通过基本操作将数据移入和移出堆，并进入寄存器进行计算。

now we've looked in detail at the seven registers the eval sequence of control is built on top of those the manipulation of the stack to create a recursive calls and recursive procedures so today we're going to finish up that

现在，我们已经详细研究了七个寄存器，eval 的控制序列建立在这些寄存器之上，以及栈的操作以创建递归调用和递归过程。所以今天我们将完成最后一部分，

So today we're going to finish up that last piece, the heap, or if you like, we're going to look at how we create data storage methods and how we actually manage them in order to let the computation of eval take place. That is, how to create expressions on a tree structure, manipulate those expressions within the registers, and create environments that can also be manipulated the same way.

所以今天我们将完成最后一部分，即堆，或者如果你愿意，我们将研究如何创建数据存储方法以及如何实际管理它们，以便让 eval 的计算得以进行。也就是说，如何创建树结构上的表达式，在寄存器中操作这些表达式，并创建同样可以以相同方式操作的环境。

We've already seen the idea of registers as places into which we can store values. To get the other pieces, we'll use the notion of a vector, and we saw this abstractly.

我们已经看到了寄存器的概念，即我们可以存储值的地方。为了获得其他部分，我们将使用向量的概念，我们已经在抽象层面上看到了这一点。

A vector and we saw this abstractly earlier in the term, but now we're going to make it more concrete. Most hardware supports the operation of random access to memory by specifying an index into a vector. So think of the vector as a long collection of registers, but with the property that to get to a location in the vector—one of those registers—one need only specify the number of slots from the beginning of the vector, also known as the offset, and one can then access that location in constant time.

向量，我们在本学期早些时候已经抽象地看到了，但现在我们将使其更加具体。大多数硬件支持通过指定向量的索引来随机访问内存的操作。因此，将向量视为一长串寄存器，但具有这样的性质：要到达向量中的一个位置——即其中一个寄存器——只需指定从向量开头开始的槽位数，也称为偏移量，然后就可以在常数时间内访问该位置。

Notice this is different from a list where the time required would be linear.

注意，这与列表不同，列表所需的时间是线性的。

where the time required would be linear. In the index I would literally have to walk my way down counting until I found the slot I wanted. Here a vector consists of something accessed in actual constant time, so more specifically we'll need a base address that is a pointer to some starting location in the memory, which we can label by a name such as my vector. We'll need an integer index or offset that tells us how many units or slots from that base address we want to get at things, and then we can store into those slots values themselves. Notice those.

列表所需的时间是线性的。在索引中，我实际上必须沿着列表走下去，计数直到找到我想要的槽位。而这里的向量是在实际常数时间内访问的，所以更具体地说，我们需要一个基地址，它是指向内存中某个起始位置的指针，我们可以用诸如“我的向量”这样的名称来标记它。我们需要一个整数索引或偏移量，告诉我们从该基地址向下多少个单位或槽位来访问内容，然后我们可以将值本身存储到这些槽位中。注意那些

Slots values themselves and notice those values may be just numbers, but we'd also like them to be pointers to other kinds of structures, so they're going to have to be large enough to give us that freedom. Given that abstraction of a vector, a sort of the primitive way of dealing with these kinds of structures inside of memory, we need two ways of interfacing.

槽位中的值本身，注意这些值可能只是数字，但我们也希望它们是指向其他类型结构的指针，所以它们必须足够大以给我们这种自由。鉴于向量的抽象，这是一种在内存中处理这类结构的基本方式，我们需要两种接口方式。

First of all, in terms of standard scheme, we actually provide two primitive operations: a vector ref operation and a vector set operation. A vector ref operation takes a base address, that name at the beginning of the vector.

首先，就标准 Scheme 而言，我们实际上提供了两个基本操作：vector-ref 操作和 vector-set 操作。vector-ref 操作接受一个基地址，即向量开头的那个名称。

address that name at the beginning of that vector if you like and an integer index and will get us the contents of that slop the appropriate number of offsets down from the base address.

地址，如果你愿意，那是向量开头的名称，以及一个整数索引，它将获取从基地址向下适当偏移量的那个槽位的内容。

vector set similarly takes a base address a name for vector or rather a pointer to the beginning of a vector an index or an offset telling us how many slots down to go and I've value to actually store into that particular location.

类似地，vector-set 接受一个基地址，即向量的名称，或者更确切地说，一个指向向量开头的指针，一个索引或偏移量，告诉我们向下多少个槽位，以及一个要实际存储到该特定位置的值。

and of course we'll need a register machine version of this as well and that says for example if we want to get the contents out of a vector will

当然，我们也需要一个寄存器机器版本，例如，如果我们想从向量中取出内容，我们将

get the contents out of a vector will have a primitive operation equivalent to vector ref that takes a vector that is the contents of register that tells us the pointer to a vector takes an index gets that contents out and then stops it.

从向量中取出内容，我们将有一个与 vector-ref 等价的基本操作，它接受一个向量，即寄存器中的内容，该内容告诉我们指向向量的指针，接受一个索引，取出内容，然后将其存储起来。

for example into some other register if we want to do a set into the vector will again specify the beginning of a vector Y the contents of some register as well as an index and a value and it will do the register machine equivalent of vector set in scheme given this vector representation of memory that is we.

例如，如果我们想将某个寄存器中的内容存入向量中，我们会再次指定向量 Y 的开头、某个寄存器的内容以及一个索引和一个值，它将执行 Scheme 中向量设置操作的寄存器机器等价操作，基于这种将内存表示为向量的方式。

representation of memory that is we treat all of memory as just a big long collection of things in a vector that can be indexed in this way it's very easy to implement the notion of a stack

也就是说，我们将所有内存视为一个大的向量集合，可以通过这种方式进行索引，这样实现栈的概念就非常容易了。

we just use a pointer to indicate where the top of the stack is inside of that vector that means we'll have to have a pointer to the beginning of the stack and then just simply an offset and often we refer to that offset as the stack pointer or SP

我们只需使用一个指针来指示栈顶在该向量中的位置，这意味着我们需要一个指向栈底的指针，然后只需一个偏移量，我们通常将该偏移量称为栈指针或 SP。

that stack pointer simply tells us where the top of the stack is the last occupied cell if you like

栈指针只是告诉我们栈顶在哪里，即最后一个被占用的单元（如果你愿意这样理解的话）。

the last occupied cell if you like and if we want to put things onto the stack, we simply have to use the next available self saving a register onto the stack now becomes quite simple we first have a special register called the stack pointer or SP register it contains a number that points to the top of the stack or the number of offsets if you like from the beginning of the stack into that vector what we do we take that stack pointer contents we add the constant 1 to it we increase it by 1 and we put that new value back into the stack pointer register that has

最后一个被占用的单元（如果你愿意这样理解的话）。如果我们要将东西压入栈中，只需使用下一个可用的单元。现在，将寄存器保存到栈中变得非常简单：我们首先有一个特殊的寄存器，称为栈指针或 SP 寄存器，它包含一个数字，指向栈顶，或者说是从栈底到该向量的偏移量。我们取栈指针的内容，加上常数 1，将其增加 1，然后将新值放回栈指针寄存器，这样就基本上将栈向下移动了 1，占用了该向量中的下一个可用元素。

stack pointer register that has basically moved the stack down by 1, taking up the next available element in this vector. And then, to put the actual contents onto that spot in the stack, we simply do a vector set. We take the stack register—ah, that's going to have to be a special register as well—that points to the beginning of the stack.

栈指针寄存器基本上将栈向下移动了 1，占用了该向量中的下一个可用元素。然后，为了将实际内容放到栈中的那个位置，我们只需执行向量设置操作。我们取栈寄存器——那也必须是一个特殊的寄存器——它指向栈底。

We take the SP, or stack pointer register, and we simply move the contents of the register into that spot on the stack. Or, said differently, we take the contents of the specified register and move a copy of those into the specified spot.

我们取 SP（即栈指针寄存器），然后将指定寄存器的内容移动到栈中的那个位置。或者换句话说，我们取指定寄存器的内容，并将这些内容的副本移动到指定的位置。

Movie a copy of those into the specified point on the stack and restoring from the stack into the register just does the right thing as well. In other words, we take the beginning of the stack, we take the value of the stack pointer register, which tells us the offset to the top of the stack, that the register that is the most available to us, and we simply take a reference from that, make a copy of that contents, and put it into the specified register.

将指定寄存器的内容副本移动到栈中的指定位置，从栈恢复到寄存器也同样正确。换句话说，我们取栈底，取栈指针寄存器的值，它告诉我们栈顶的偏移量，即对我们最可用的那个寄存器，然后我们从中取一个引用，复制该内容，并将其放入指定的寄存器。

Having done that, we then pop one level off the stack, that is, we reduce the stack pointer register by one.

完成之后，我们然后将栈弹出（pop）一级，也就是说，我们将栈指针寄存器减 1。

reduce the stack pointer register by one, indicating that we now have a new stack pointer and the stack is one less than what it was. Well, that takes care of the stack; it's pretty easy to do just having this vector representation of memory around.

将栈指针寄存器减 1，表示我们现在有了一个新的栈指针，栈的大小比原来少了一个。好了，这样就处理了栈；有了这种向量的内存表示，实现栈是非常容易的。

What about the heap? Well, remember conceptually the heap is just a collection of free consoles, free pairs, and we should be able to create new ones as needed out of this collection.

那么堆呢？记住，从概念上讲，堆只是一组空闲的 cons 单元（即空闲的序对），我们应该能够根据需要从这个集合中创建新的序对。

Now, large portions of the heap will simply be representations of list structure expressions that we want to evaluate or

现在，堆的大部分内容将只是我们要评估的列表结构表达式或

expressions that we want to evaluate or data structures we built that we want to manipulate, but we're also going to have to be a little bit careful about how we create consoles out of the heat. Since the heap will also hold most of our value in, for valuable information in particular.

我们要评估的表达式或我们构建并要操作的数据结构的表示，但我们也必须小心如何从堆中创建 cons 单元。因为堆还将保存我们的大部分值，特别是环境信息。

Remember what an environment is: it's a big collection of consoles that are glued together in appropriate ways, and those environments need to live and survive in the heap. We can't have accidentally destroying elements of that cell structure by using the wrong cells in the wrong order okay to build the.

记住环境是什么：它是一个大的 cons 单元集合，以适当的方式粘合在一起，这些环境需要在堆中生存和存续。我们不能因为错误地使用错误的单元或错误的顺序而意外破坏该单元结构的元素。

In the wrong order, okay. To build the heap, we will again use the idea of a vector, but now we're going to glue two vectors together in a very specific way. Imagine I have two vectors that I call the cars and the coders. I can use a single index into these two vectors to represent a concept. The location at index J in the cars would represent the car element, and the same location J in the quarters would represent the kut'r element. Note that we'll need to have two more registers in a machine lamp to hold the base pointers to the beginnings of

以错误的顺序，好的。为了构建堆，我们将再次使用向量的概念，但现在我们要以非常特定的方式将两个向量粘合在一起。想象我有两个向量，我称之为 cars 和 coders。我可以使用一个索引来代表一个概念。cars 中索引 J 的位置代表 car 元素，而 coders 中相同的位置 J 代表 cdr 元素。注意，我们需要在寄存器机器中有两个额外的寄存器来保存这两个向量开头的基指针。

The base pointers to the beginnings of both of these vectors, and also notice by the way that we should also have added a pointer to the base of the stack in a special register so that we have that capability as well, given that idea of taking two vectors and gluing them together so that a single offset or a single index specifies both a car and a coder, makes it very easy for us to actually implement our pair abstraction in the register machine.

这两个向量开头的基指针，并且还要注意，我们还应该添加一个指向栈底的指针到一个特殊的寄存器中，以便我们也有这种能力。考虑到将两个向量粘合在一起，使得单个偏移量或单个索引同时指定 car 和 cdr，这使得我们很容易在寄存器机器中实现我们的序对抽象。

Now a car operation has a very particular form. Before we would have said assign into some register the car of some pair.

现在，car 操作具有非常特定的形式。之前我们会说将某个序对的 car 赋值给某个寄存器。

Some register the car of some pair where the car operation was treated as a special operation. Here we see we can be more specific, this actually becomes now a vector operation. We take the cars pointer, that is the register the cars that points to a beginning of a big vector in the memory.

将某个序对的 car 赋值给某个寄存器，其中 car 操作被视为一种特殊操作。在这里我们看到我们可以更具体，这实际上变成了一个向量操作。我们取 cars 指针，即指向内存中一个大向量开头的寄存器。

We take the pair which tells us an offset, there's going to be an index now specific integer, and we use the vector ref operation to go to that spot and pull out the contents and put it where we want it to. That gets the car for us, and of course could our operation looks.

我们取序对，它告诉我们一个偏移量，现在将是一个特定的整数索引，我们使用向量引用操作去那个位置取出内容并将其放到我们想要的地方。这样就得到了 car，当然，cdr 操作看起来

And of course, our operation looks exactly the same but now using the register that holds a pointer to the beginning of the second vector, and otherwise everything is exactly as before. Well, that says we can be very explicit about how we get the values out of existing pairs, how to get the car, the cdr of an existing pair. And of course, we can string together sequences of cars and cdr operations to get elements out of arbitrary tree structures.

当然，cdr 操作看起来完全相同，但现在使用持有第二个向量开头的指针的寄存器，其他一切都与之前完全相同。这样，我们就可以非常明确地如何从现有序对中获取值，如何获取现有序对的 car 和 cdr。当然，我们可以将 car 和 cdr 操作序列串在一起，以从任意树结构中获取元素。

But what about the other direction? What about generating pairs? Or if you

但另一个方向呢？生成序对呢？或者如果你

What about generating pairs? Or if you like, what does Kant's do well? What we needed to do is to select a free slot in the vectors representing the cars and the coders.

那么，关于生成序对呢？或者如果你喜欢，康德（Kant）在这方面做得如何？我们需要做的是在表示汽车和编码器的向量中选择一个空闲槽位。

The method we use for doing this very much depends on how we're going to manage our memory, as we'll see very shortly. For now, consider the following straightforward idea.

我们用来做这件事的方法很大程度上取决于我们将如何管理内存，这一点我们很快就会看到。现在，考虑下面这个简单的想法。

Let's allocate new cells in the memory in a linear fashion. So we'll add one more register to our machine, a register we call 'free,' which points to the next available slot in the pair's vectors.

让我们以线性方式在内存中分配新单元。因此，我们将为我们的机器增加一个寄存器，我们称之为“free”，它指向序对向量中的下一个可用槽位。

In other words, 'free' needs to hold an...

换句话说，“free”需要保存一个……

other words free needs to hold an integer that tells us how many slots down to go from the beginning of both the cars in the coders to find the next available cell. When we use costs, that is when we ask for a new pair, we'll simply use that new cell. We'll take the pair pointed to by free and use that to store in our values that were constant together.

换句话说，free需要保存一个整数，告诉我们从汽车和编码器的开头向下走多少个槽位才能找到下一个可用单元。当我们使用cons时，也就是当我们请求一个新的序对时，我们将简单地使用那个新单元。我们将取free指向的序对，并用它来存储我们常在一起的值。

And of course having done that, we need to change free. And since we've chosen in this case to represent things in a linear manner, we simply increment free by one, pointing to the now next.

当然，做完这些之后，我们需要改变free。由于在这种情况下我们选择以线性方式表示事物，我们只需将free加1，指向现在下一个。

Free by one pointing to the now next available cell. Notice this is one choice of how we can structure memory, allocating things in a linear fashion. It's not the only choice, as we'll see shortly.

free加1，指向现在下一个可用单元。注意，这是我们如何构建内存的一种选择，以线性方式分配事物。这不是唯一的选择，我们很快就会看到。

For that particular choice of handling memory, we can now implement cons directly in a register machine. Remember before, when we used cons, we treated it as a primitive operation. We say, given two values, we'll use cons to generate the pair, and we can stick the result into some specified register. Now we actually use the vector operations to make this happen.

对于那种特定的内存处理选择，我们现在可以直接在寄存器机器中实现cons。记住之前，当我们使用cons时，我们将其视为一个原始操作。我们说，给定两个值，我们将使用cons来生成序对，并且我们可以将结果存入某个指定的寄存器。现在我们实际上使用向量操作来实现这一点。

operations to make this happen. Notice what we have to do takes a little more work now because we have to be more careful, in particular, to generate a cons. We start with the vector; the cars that is a pointer to the beginning of that vector. We use free to tell us how many slots down to go, find the next available spot, and into that spot we store the first value. We do the same thing with the coders, using exactly the same spot, since those two things together represent a pair. Ah, since those represent a pair, that's what I'm going to stick into the register.

操作来实现这一点。注意，我们现在必须做的事情需要更多的工作，因为我们必须更加小心，特别是为了生成一个cons。我们从向量开始；汽车是一个指向该向量开头的指针。我们使用free来告诉我们要向下走多少个槽位，找到下一个可用位置，并将第一个值存储到该位置。我们对编码器做同样的事情，使用完全相同的位置，因为这两者一起表示一个序对。啊，由于它们表示一个序对，那就是我要存入寄存器的内容。

I'm going to stick into the register. Notice in particular what that does the value of free which is an index and integer is put into register that actually makes sense because think about how I would get back out the car or coder of that pair my operation of car or coder says start with the base pointer to either of those two vectors use the value of the offset the number to go that many slots down to get the value out and that's exactly what free is holding therefore I stuck it into register appropriately then having done all of that I need to increment free to

我要存入寄存器。特别注意，free的值（一个索引，一个整数）被放入寄存器，这实际上是有意义的，因为想想我如何取回该序对的car或cdr：我的car或cdr操作说，从这两个向量之一的基指针开始，使用偏移量的值，向下走那么多槽位以取出值，而free正好持有这个值。因此，我适当地将它存入寄存器。然后，做完所有这些之后，我需要递增free以……

All of that I need to increment free to point to the next available cell, and in this case, I just add 1 to the current value of free and store that away. The last thing we need to add to our system is a way of identifying primitive data. For example, if we create some list structure, then the cdr part of a cons cell should point to some other cons cell. But if we just store a number in the cdr that is the index of the cell, how do we know that number is a pointer to a cell and not just a number? How do we tell the difference between a...

所有这些之后，我需要递增free以指向下一个可用单元，在这种情况下，我只需将当前free值加1并存储起来。我们需要添加到系统中的最后一件事是一种识别原始数据的方法。例如，如果我们创建一些列表结构，那么cons单元的cdr部分应该指向另一个cons单元。但是，如果我们只在cdr中存储一个数字，即该单元的索引，我们如何知道该数字是指向单元的指针而不仅仅是一个数字？我们如何区分……

how do we tell the difference between a con spare whose quarter points to another con spare and a con spare whose quarter is just that number well you actually already know the solution

我们如何区分一个cdr指向另一个cons单元的cons单元和一个cdr只是那个数字的cons单元？嗯，你实际上已经知道解决方案了。

we'll use a tag here we'll just use a very primitive kind of tag and so for primitive data what we'll do is take the bit structure representing an object and we'll reserve a few bits typically the higher order bits to identify the kind of data

我们将在这里使用一个标签，我们将使用一种非常原始的标签，因此对于原始数据，我们将做的是取表示对象的位结构，并保留一些位（通常是高位）来标识数据的种类。

so for example we might set aside 4 bits to be a tag and uses remaining 28 bits either to represent the data value or to represent a pointer

例如，我们可以留出4位作为标签，并使用剩余的28位来表示数据值或表示指针。

the data value or to represent a pointer that is an offset into the memory for the four bit tag we have an arbitrary choice here we might for example choose to use the representation 0 0 0 0 to indicate an empty list and 0 0 0 1 to indicate that this is a console pointer that is the remaining 28 bits that follow are an index are an offset to a particular pointer in the list structure where a 0 0 1 0 as a tag would indicate that this is actually an integer that is the remaining 28 bits should be treated as a number 0 0 is 1 1 might be a作为数字0,0是1，1可能是一个。

数据值或表示指针，即内存中的偏移量。对于4位标签，我们在这里有任意的选择，例如，我们可以选择使用表示0 0 0 0来表示空列表，0 0 0 1来表示这是一个cons指针，即后面的28位是指向列表结构中特定指针的索引或偏移量，而0 0 1 0作为标签可能表示这实际上是一个整数，即剩余的28位应被视为一个数字，0 0 1 1可能是一个布尔值，等等。

As a number, 0 0 is 1, 1 might be a boolean, and so on. Thus, for example, the representation 0 0 zero-one followed by all those other things you see there is a pointer to a console because the tag says it's a pointer, and as a pointer, it literally points to the contents of the cell at offset 5 1 4.

作为一个数字，0 0 1 1可能是一个布尔值，等等。因此，例如，表示0 0 0 1后跟你在那里看到的所有其他东西是一个指向cons单元的指针，因为标签说它是一个指针，作为指针，它字面上指向偏移量为5 1 4的单元的内容。

On the other hand, if we change those 4 red numbers to 0 0 1 0, this would indicate that this was the actual integer 5 1 4, not a pointer to some place in Const memory. Of course, remembering that 0 0 0 1 is a pointer and 0 0 1 zeros are integers can be a real pain, so it will be a little more convenient.

另一方面，如果我们将那4个红色数字改为0 0 1 0，这将表明这是实际的整数5 1 4，而不是指向Cons内存中某个位置的指针。当然，记住0 0 0 1是指针而0 0 1 0是整数可能真的很痛苦，所以更方便一点。

So will be a little more convenient about how we represent this, and in particular we can use our representation of primitive data as simply a tag using a letter to indicate, for example, an empty list, a pointer, or a number, as well as the actual content. And we're going to use that in a second to see how we deal with structuring memory.

所以更方便一点关于我们如何表示这一点，特别是我们可以使用我们对原始数据的表示，简单地使用一个标签，用字母来表示，例如，空列表、指针或数字，以及实际内容。我们稍后将使用它来了解如何处理内存结构。

Given our little shorthand notation, we can now trace out the allocation of list structure within the heap. Suppose we've got an empty list structure to start with; we've got the cars and the coders pointing to two.

鉴于我们的小简写符号，我们现在可以追踪堆内列表结构的分配。假设我们从一个空列表结构开始；我们有汽车和编码器指向两个……

Cars in the coders pointing to two vectors and free is currently pointing to the zero slot. Let's look at what happens if we evaluate the following little expression. Well, we know that list is basically just a sequence of Const calls, and in fact the first one to be evaluated will be the deepest one inside of the recursion. The others will become deferred operations until we get to them.

在编码器中，汽车指向两个向量，而空闲指针当前指向零号槽位。让我们看看如果求值下面这个小表达式会发生什么。我们知道，列表基本上就是一系列 Cons 调用的序列，实际上第一个被求值的将是递归中最深的那一个。其他的将成为延迟操作，直到我们处理到它们。

And so by our mechanism, this should go into the first available slot. In terms of our box and pointer notation, it says we'll have a little pair with six in the

因此，根据我们的机制，这应该进入第一个可用的槽位。用我们的盒子和指针表示法来说，就是说我们会有一个小序对，其中 car 部分是 6，

we'll have a little pair with six in the car and an empty list in the coder and we'll actually put the label p0 up on the top to indicate that that went into slot 0 it's a pointer to the pair p0 in terms of our car and could our notation we see that we put in the number 6 and the empty list

我们会有一个小序对，其中 car 部分是 6，cdr 部分是空表，我们实际上会在顶部放上标签 p0 来表示它进入了槽位 0，它是一个指向序对 p0 的指针。用我们的 car 和 cdr 表示法来看，我们看到我们放入了数字 6 和空表。

now that pointer p0 was the value actually returned by this cons and therefore we can do the next cost of the first of the deferred operations causing 7 onto that that will generate up higher in p1 because that's where free is pointing to and again we can update both

现在，指针 p0 是这个 cons 实际返回的值，因此我们可以执行下一个 cons，即第一个延迟操作，将 7 加到它上面，这将生成更高的 p1，因为那是 free 指向的地方，我们同样可以更新两者。

Pointing to, and again, we can update both our box and pointer representation and the vector representation. Notice how the coder contains a pointer to p0, the pair + 0, meaning it is a tag saying this is a pointer to a pair, and the actual offset will be 0.

指向，并且，我们同样可以更新我们的盒子和指针表示以及向量表示。注意 cdr 包含一个指向 p0 的指针，即序对 + 0，意思是它是一个标签，表明这是一个指向序对的指针，实际偏移量将是 0。

Of course, we can complete the last cons pair by putting that in p2, and as a consequence, putting the value 4 in the car at 2 and the pointer P1/2, the other pair in the quarter part of pair 2.

当然，我们可以通过将最后一个 cons 序对放入 p2 来完成它，因此，将值 4 放入索引 2 的 car 中，并将指针 P1/2（另一个序对）放入序对 2 的 cdr 部分。

Notice also that the value of a is actually the pair p2, or if you like, the pointer to p2, it's a number that has...

还要注意，a 的值实际上是序对 p2，或者如果你愿意，可以说是指向 p2 的指针，它是一个数字，具有……

pointer to p2 it's a number that has four bits as a tag that says this is a pointer followed by an offset that says the thing I want is two elements down. And literally we talk about a as having the value of that pointer, and in fact we can see that if we look at the following example.

指向 p2 的指针，它是一个数字，具有四位标签表示这是一个指针，后跟一个偏移量表示我想要的东西是两个元素之后。实际上，我们说 a 具有那个指针的值，事实上，如果我们看下面的例子，我们可以看到这一点。

Suppose we kant's a onto a well cons we'll use the next available cell we're free points - which is going to be pair of three, and what goes into the car well just the value of a which is the pointer p2, and what goes into the coder also the value of a which is still of.

假设我们将 a cons 到 a 上，cons 将使用下一个可用单元，即 free 指向的位置——那将是序对 3，那么 car 中放入什么？就是 a 的值，即指针 p2，而 cdr 中放入什么？也是 a 的值，仍然是……

also the value of a which is still of course the value p2, so notice now in pair three both the car and the coder have a representation that says what store there is a pointer to a pair and it's the pair at index number two. Well, what we've just seen allows us to have a means for allocating cons cells from the heat. We've certainly been able to build something that will generate cons cells as needed. Ideally, if our memory is large enough, we could just do this as needed and never have to worry. But of course, our memory is finite, and if we do enough of this, eventually we're going to use it all up.

也是 a 的值，当然仍然是 p2，所以注意在序对 3 中，car 和 cdr 都有一种表示，说明存储的是一个指向序对的指针，并且是指向索引为 2 的序对。我们刚才看到的使我们有了一种从堆中分配 cons 单元的方法。我们当然能够构建出按需生成 cons 单元的东西。理想情况下，如果我们的内存足够大，我们可以按需这样做而无需担心。但当然，我们的内存是有限的，如果我们做了足够多的这样的操作，最终我们会用完所有内存。

Of this, eventually we're going to use all of the conch cells up. However, when that happens, not all of the cells in the memory are actually useful, and we may be able to take advantage of that to see that. Consider the following example: let's define B to be a constant one and nil, which of course puts into the slot pointed to by free the number one in the empty list, and increments free as we'd expect.

最终，我们会用完所有的 cons 单元。然而，当这种情况发生时，并不是内存中的所有单元都是实际有用的，我们也许可以利用这一点。考虑下面的例子：让我们定义 B 为 cons 1 和 nil，这当然会将数字 1 和空表放入 free 指向的槽位，并像我们预期的那样递增 free。

Now, some times later, let's assume that we change the value for B. We set bang B to be a concept to three con sixth available sell the thing pointed.

现在，过了一段时间，假设我们改变 B 的值。我们设置 bang B 为 cons 2 和 cons 3 到第六个可用的单元，即 free 指向的位置。

第六个可用的卖出操作，指向空闲位置的指针被释放，将数字二放入那些位置，然后将数字三也放入那些位置，接着改变指针的指向，将其上移。但注意，B也发生了变化，它之前指向五，现在指向六。为何这很重要？如果从盒子和指针图的角度来思考，五号对已无法访问，也就是说，在全局环境中，没有任何表达式能引用或到达它，因为没有指针指向它。同样，在车的实际结构中也是如此。

第六个可用的卖出操作，指向空闲位置的指针被释放，将数字二放入那些位置，然后将数字三也放入那些位置，接着改变指针的指向，将其上移。但注意，B也发生了变化，它之前指向五，现在指向六。为何这很重要？如果从盒子和指针图的角度来思考，五号对已无法访问，也就是说，在全局环境中，没有任何表达式能引用或到达它，因为没有指针指向它。同样，在车的实际结构中也是如此。

says in the actual structure of the cars and the quarters that slot five contains things that are no longer accessible we consider them to be garbage meaning that the values associated are stored in those locations cannot possibly influence any future on come of a program because they can't be reached by anyway now that's an important point

在 car 和 cdr 的实际结构中，槽位五包含的东西不再可访问，我们认为它们是垃圾，意味着存储在这些位置的值不可能影响程序未来的任何结果，因为它们无法被任何方式到达。这是一个重要的点。

so let's say it a game what are the cells that contain information that might possibly influence a future computation well we know the only way we can reach an element of the structured memory here is through a sequence of car

所以让我们再说一遍，哪些单元包含可能影响未来计算的信息？我们知道，我们能够到达结构化内存中某个元素的唯一方式是通过一系列 car 和 cdr 操作，从全局环境中存储的值开始。

Memory here is through a sequence of car encoder operations starting from value stored in the global environment, and if this particular pair no longer has a pointer from the global environment, we just changed it, we move B to have from pointing to pair five to pointing somewhere else. Then no matter what sequence of operations we take in terms of cars and coders starting from things stored in the global environment, we can't get to this cell since we can't get to this cell.

内存中的元素是通过从全局环境存储的值开始的一系列 car 和 cdr 操作到达的，如果这个特定的序对不再有来自全局环境的指针，我们刚刚改变了它，我们将 B 从指向序对五改为指向别处。那么无论我们从全局环境中存储的东西出发采取什么 car 和 cdr 操作序列，我们都无法到达这个单元，因为我们无法到达这个单元。

It can't possibly influence future computations, therefore it's garbage and of course.

它不可能影响未来的计算，因此它是垃圾，当然。

therefore it's garbage and of course what we'd like to do is say can we gather that up can we reclaim such cells in order to have more memory available to us. Well, this filling up of memory with things that are actually garbage becomes a problem when we chew up enough memory that we run out.

因此它是垃圾，当然我们想要做的是说，我们能否收集它，能否回收这样的单元以便我们有更多可用的内存。当我们消耗足够多的内存以至于用完时，用实际上是垃圾的东西填满内存就成了一个问题。

Consider the following simple example. This is where of course a very small memory but the eye is the same even when we get to much larger memories. Let's assume that we just have five elements in our memory and we've already defined C to be the

考虑下面这个简单的例子。这当然是一个非常小的内存，但道理是一样的，即使我们面对大得多的内存。假设我们的内存中只有五个元素，我们已经将 C 定义为……

and we've already defined C to be the list 84-76 and so it's generated up a list structure shown here C points to pair three and it has within it all of the list structure the creates of things we'd like to have. Now let's evaluate a set bang of C to be a cons of the code editor of C and the creditor of C what does that do.

我们已经将 C 定义为列表 84-76，因此它生成了这里所示的列表结构，C 指向序对三，并且它包含了我们想要的所有列表结构。现在让我们求值 set bang C 为 cons 的 cdr 的 cdr 和 cdr 的 cdr，这做什么？

Well, of course evaluating const is going to use up the next free cell it's going to use up pair four and oh that means that when we go to increment free we've taken it beyond the bounds of the memory and gee that's too bad because in fact

当然，求值 cons 将使用下一个空闲单元，它将使用序对四，哦，这意味着当我们去递增 free 时，我们已经超出了内存的边界，哎呀，这太糟糕了，因为事实上……

and gee that's too bad because in fact we can actually build the structure we want see pair it points to pair four and to get the car of this we take the code editor of C that is walk down and find the right pointer which is in fact p0 and to take the succour of this we take the creditor of the original C walking down to find that that should in fact be p1 so we can assert those pointers into pair four which is where see currently points and of course we also now smash the old pointer for C it used to point to pair three but it no longer does.

而且这太糟糕了，因为事实上我们可以构建我们想要的结构。看，pair 指向 pair 4，要得到它的 car，我们取 C 的代码编辑器，即向下走并找到右指针，它实际上是 p0；要得到它的 succor，我们取原始 C 的 creditor，向下走找到那应该是 p1，所以我们可以将这些指针断言到 pair 4 中，即 C 当前指向的位置，当然我们现在也破坏了 C 的旧指针，它曾经指向 pair 3，但现在不再指向了。

to pair three but it no longer does because we've changed that. So in fact pairs two and three are actually garbage, we can't reach them in any way, so they don't contain any useful values.

指向 pair 3，但现在不再指向了，因为我们已经改变了它。所以实际上 pair 2 和 pair 3 是垃圾，我们无法以任何方式到达它们，所以它们不包含任何有用的值。

And that's too bad because our free pointer has just gone past the end of memory, meaning that we're out of memory — we have nothing left to allocate. Yet in fact there are cells around that are still usable.

这太糟糕了，因为我们的空闲指针刚刚越过了内存的末尾，这意味着我们内存不足——我们没有任何东西可以分配了。然而事实上，周围还有一些仍然可用的单元。

This then raises two interesting questions. Can we somehow detect which cells are garbage, which things are no longer useful to us, and having done that, can we somehow then

这引出了两个有趣的问题。我们能否以某种方式检测哪些单元是垃圾，哪些东西对我们不再有用，并且做到这一点之后，我们能否以某种方式

Having done that, can we somehow then figure out how to reuse those cells so that we can keep chewing up memory without having to run out of them by just simply because we've gone beyond the end of the currently available structure?

做到这一点之后，我们能否以某种方式找出如何重用这些单元，以便我们可以继续消耗内存而不至于耗尽它们，仅仅因为我们超出了当前可用结构的末尾？

Now, in fact, identification is easy at least in principle, as we stated. The only cells in memory we care about are those that could possibly affect the state of future computations. And, as we've also said, those are determined by the following idea. Remember that the state of the evaluator is completely captured by the contents of the

现在，事实上，识别是容易的，至少原则上如此，正如我们所说。内存中我们关心的唯一单元是那些可能影响未来计算状态的单元。而且，正如我们所说，这些由以下思想决定。记住，求值器的状态完全由

captured by the contents of the registers of the Machine plus the stack, so if we were to trace out sequences of car and could our operations from those registers, this would lead us to the only cells that matter. Everything else is useless, so that would certainly allow us to identify those pieces and might give us a way of figuring out how to reclaim them.

由机器的寄存器内容加上栈完全捕获，所以如果我们从这些寄存器追踪出 car 和 cdr 操作的序列，这将引导我们找到唯一重要的单元。其他一切都是无用的，所以这肯定能让我们识别那些部分，并可能给我们一种找出如何回收它们的方法。

In terms of actually making that happen, we have a couple of different alternatives, and these are basically ways of dealing with the management of the storage of information. The first...

就实际实现而言，我们有几种不同的选择，这些基本上都是处理信息存储管理的方式。第一种……

The storage of information, the first option really just puts the burden on the programmer. That is, it asks the programmer to explicitly worry about allocating and deallocating memory. And in fact, if you're familiar with programming and say C, you know that that happens there are very explicit language constructs or procedures that free up memory as well as allocate memory. It gives control to the programmer, which is nice, but there's also a lot of potential for harm here. You get memory leaks when the memory is consumed but never recovered, and this is a very common bug.

信息存储，第一种选择实际上是把负担放在程序员身上。也就是说，它要求程序员显式地担心内存的分配和释放。事实上，如果你熟悉编程，比如 C 语言，你知道那里有非常明确的语言结构或过程来释放内存以及分配内存。它把控制权交给程序员，这很好，但也有很多潜在的危害。当内存被消耗但从未回收时，你会得到内存泄漏，这是一个非常常见的错误。

recovered and this is a very common bug in C programming similarly you may accidentally overwrite a particular memory cell because you're not careful about how you're structuring the indexing into the Khans pairs that you want to use an alternative and in fact the one that is used by scheme is to free the programmer from having to worry about memory allocation and de-allocation or recovery it's basically just set up an automatic mechanism that finds and reuses memory it's known as garbage collection and it's used in things like

回收，这是 C 编程中非常常见的错误。类似地，你可能会意外覆盖某个内存单元，因为你不小心如何构造索引到你想使用的 cons 对中。另一种选择，事实上是 Scheme 使用的，是让程序员不必担心内存分配和释放或回收；它基本上建立了一个自动机制来查找和重用内存，这被称为垃圾回收，它被用于像

things like Scheme and Java as a way of separating from the programmer the worries about memory allocation. What we're going to turn to now is seeing how we can make that happen inside of Scheme.

像 Scheme 和 Java 这样的语言中，作为一种将内存分配的担忧从程序员那里分离出来的方式。我们现在要转向的是看看我们如何在 Scheme 内部实现这一点。

The first method we'll look out for dealing with garbage collection is known as a mark-sweep algorithm, and the idea is fairly simple. If we have our two vectors, the cars and the coders, in fact here we've shown that simple little example we did earlier with the five-element memory and the structure that we have in it, corresponding to what we did in terms of

我们要看的第一种处理垃圾回收的方法被称为标记-清除算法，其思想相当简单。如果我们有两个向量，cars 和 coders，事实上这里我们展示了我们之前做的那个简单的小例子，有五个元素的内存以及其中的结构，对应于我们之前所做的

Corresponding to what we did in terms of creating C and then redefining it now, given those two vectors we add in a third single bit vector called the marks. And the idea is as follows: those mark bits, which are all initially zero, are going to help us tell which things we want to keep.

对应于我们创建 C 然后重新定义它所做的。现在，给定这两个向量，我们添加第三个单比特向量，称为标记。其思想如下：这些标记位，最初都是零，将帮助我们判断哪些东西我们要保留。

The idea is to start at the root of the good cells, at some beginning point of the cells we want, and then simply walk down that tree structure. The tree structure pointed to by that pair, following the pointers out of the car included two subsequent pairs.

其思想是从好单元的根开始，从我们想要的单元的某个起始点开始，然后简单地沿着树结构向下走。由那个 pair 指向的树结构，沿着 car 中的指针，包括两个后续的 pair。

of the car included two subsequent pairs

包括两个后续的 pair

of the car included two subsequent pairs and simply marking all the good cells once we've done that we'll sweep together all the unmarked cells into a list of free cells G let's look at that to see how that works for simplicity

包括两个后续的 pair，并简单地标记所有好单元。一旦我们完成了，我们将把所有未标记的单元清扫到一个空闲单元列表中。让我们看看这是如何工作的，为了简单起见

assume our route that is the beginning of the good cells starts at C so we start at point c and it in particular points to the pair four so we put a mark in pair for indicating that that's something we want to keep having marked that cell

假设我们的根，即好单元的开始，从 C 开始。所以我们从点 C 开始，它特别指向 pair 4，所以我们在 pair 4 上放一个标记，表示那是我们要保留的东西。标记了那个单元之后

we then walk down the tree structure that is we take the car of pair four and we look at where it goes

我们然后沿着树结构向下走，即我们取 pair 4 的 car，看看它指向哪里

Pair four and we look at where it goes to it points to pair zero so we mark that as also being something we want to keep. We're now sitting at pair zero but it's car is just a number, it's quarter is the empty list so we can back up to where we were and take the coder trail off of pair four. It points to pair one and as a consequence we mark that as something we want to keep, and since the car of pair one is just a number and the coder of pair one points to something that we have already marked. Aha, we don't have to keep doing that, there's no sense.

Pair 4，我们看看它指向哪里，它指向 pair 0，所以我们标记它也是我们要保留的东西。我们现在坐在 pair 0 上，但它的 car 只是一个数字，它的 cdr 是空列表，所以我们可以回到我们之前的位置，然后从 pair 4 取 cdr 路径。它指向 pair 1，因此我们标记它为我们想要保留的东西，并且由于 pair 1 的 car 只是一个数字，而 pair 1 的 cdr 指向我们已经标记过的东西。啊哈，我们不必继续这样做了，没有意义。

to keep doing that there's no sense

继续这样做没有意义

to keep doing that there's no sense tracing anything further in this case, we've traced out everything we possibly can and we've marked all the useful cells. That means we can turn to the second stage, and the second stage is to sweep together all the unmarked cells.

继续这样做没有意义，在这种情况下再追踪任何东西。我们已经追踪了所有可能追踪的，并且标记了所有有用的单元。这意味着我们可以转向第二阶段，第二阶段是将所有未标记的单元清扫到一起。

In fact, every cell that has a zero in the marks is something we know we can recollect because we didn't reach it from anything useful. So to do this, we start an index beginning at zero, the beginning of memory, and we set our free pointer to initially point to an empty list. And now what we're going to do is walk our

事实上，每个在标记位中为零的单元都是我们知道可以回收的，因为我们没有从任何有用的地方到达它。因此，要做到这一点，我们从一个索引开始，从零开始，即内存的起始位置，并将我们的空闲指针初始化为指向一个空列表。现在我们要做的是遍历我们的

Now what we're going to do is walk our way along, so our index initially points to pair 0, and since the mark there is 1, we don't want to reclaim it. As a consequence, we simply reset the mark to zero, saying it's something we want to keep, and we increment our index by one, pointing to the next cell.

现在我们要做的是沿着内存遍历，所以我们的索引最初指向第0对，由于那里的标记是1，我们不想回收它。因此，我们简单地将标记重置为零，表示这是我们想要保留的，并将索引加一，指向下一个单元。

Now index points to pair 1, but the mark there is also 1; it's something we want to keep, so we reset it to zero and increment our index again. Now finally, we reached a cell whose mark is already 0, saying it's garbage, it's something we...

现在索引指向第1对，但那里的标记也是1；这是我们想要保留的，所以我们将其重置为零并再次递增索引。现在，我们终于到达了一个标记已经为0的单元，表示它是垃圾，它是我们想要……

saying it's garbage it's something we want to collect together and as a consequence if we're going to stitch it together in the following way we take the current value of free and we put that into the coder slot we literally smash what was there doesn't matter was just garbage putting in this case the empty list into the coder slot at pair 2 and we then increment free to point to that actual pair free is now pointing to the first available cell pair 2 and in the quarter of that cell is the pointer to the next available pair after this and then we

表示它是垃圾，它是我们想要收集在一起的，因此，如果我们要以以下方式将其缝合在一起，我们取free的当前值并将其放入cdr槽中；我们实际上覆盖了那里的内容，没关系，那只是垃圾，在这种情况下将空列表放入第2对的cdr槽中，然后我们将free递增以指向那个实际的对。free现在指向第一个可用单元，即第2对，并且在该单元的cdr中是指向下一个可用对的指针，然后我们

available pair after this, and then we increment our index to the next pair. Increment our index to the next pair. Increment our index to the next pair. This pair is also garbage because as Mark is zero. Mark is zero. Mark is zero.

指向下一个可用对，然后我们将索引递增到下一对。将索引递增到下一对。将索引递增到下一对。这一对也是垃圾，因为标记为零。标记为零。标记为零。

So we do the same thing: we take the current value of free, which was pointing to pair two, and we stuff that into the coder at this spot. That says the coder here points to the next available cell, and we change free to now point to this cell. Notice what free points to: it says the next available cell is pair three, and it's could or contains a pointer to the cell available after that. Pair to whose coder says, "Oh, empty list, nothing left."

所以我们做同样的事情：我们取free的当前值，它指向第2对，并将其塞入此处的cdr。这表示这里的cdr指向下一个可用单元，我们将free改为现在指向这个单元。注意free指向什么：它说下一个可用单元是第3对，并且它的cdr包含一个指向其后可用单元的指针。第2对的cdr说：“哦，空列表，没有剩余了。”

cooter says oh empty list nothing left and we increment our index to go to the next cell the mark for this cell is 1 saying it's something we want to keep so we simply reset the mark to zero and in this case incrementing the index is going to take us beyond to the end of the memory so we know we're now done.

cdr说哦空列表没有剩余了，然后我们递增索引以转到下一个单元；这个单元的标记是1，表示这是我们想要保留的，所以我们简单地将标记重置为零，在这种情况下，递增索引将使我们超出内存末尾，因此我们知道现在完成了。

and again notice free points to the next available cell in pair 3 its coder points to the next available cell etc and in fact the coders now stitch together the list of available cells the things we've reclaimed to actually implement a mark sweep algorithm.

再次注意，free指向第3对中的下一个可用单元，其cdr指向下一个可用单元，等等；实际上，cdr现在将可用单元列表（即我们回收的单元）缝合在一起，以实现标记-清除算法。

Implement a mark sweep algorithm is fairly straightforward for the mark phase. We need a procedure with the following property: given an object that is a pointer to something, it does the following. If that object's not a pair, it just returns false saying I'm done with this.

实现标记-清除算法对于标记阶段来说相当直接。我们需要一个具有以下属性的过程：给定一个对象，它是一个指向某物的指针，它执行以下操作。如果该对象不是一对，它只返回false，表示我对此完成了。

If, on the other hand, it is a pair, it checks to see whether the mark part of the object is equal to one. If it's not, we set that mark to one saying it's something we want to keep, and then we recursively mark both the car of that object and the cdr of that object. Notice for a pair.

另一方面，如果它是一对，它检查对象的标记部分是否等于1。如果不是，我们将该标记设置为1，表示这是我们想要保留的，然后我们递归地标记该对象的car和cdr。注意对于一对，

notice for a pair, the object is just an integer offset denoting the cell location the place I want to go to. But also notice that mark is doubly recursive: it's going to do a tree walk in which, given a pair, it will mark down the car of that tree and then come back and mark down the code of the tree, just as we saw in our little example.

注意对于一对，对象只是一个整数偏移量，表示单元位置，即我想要去的地方。但也要注意，标记是双重递归的：它将进行树遍历，在给定一对的情况下，它将标记该树的car，然后返回并标记该树的cdr，正如我们在小例子中看到的那样。

For our sweep phase, we just need a procedure that walks along the memory sweeping things up. What is that? Well, given some size of the memory, it takes the index I and says, gee, check to see if I'm equal to size. If I am, I'm done.

对于我们的清除阶段，我们只需要一个过程，它沿着内存遍历并清除东西。那是什么？嗯，给定内存的某个大小，它取索引I并说，哎呀，检查I是否等于大小。如果是，我就完成了。

I'm equal to size if I am I'm done if I'm not then I do the following if the mark at this location is on or if you like it has the value 1 then I set the mark at that location to 0 I'm simply done if on the other hand the mark is not 1 it's 0 then I do what I did in my previous little example I convert that index into an actual pointer and then set the cutter of that pointer to whatever free currently points do that's my global pointer to the things that are available I then change free to point to this location and I continue sweeping doing.

I等于大小，如果是，我就完成了；如果不是，那么我执行以下操作：如果此位置的标记为开，或者如果你喜欢，它的值为1，那么我将该位置的标记设置为0，我就完成了；另一方面，如果标记不是1而是0，那么我像之前的小例子那样，将该索引转换为实际指针，然后将该指针的cdr设置为free当前指向的内容，那是我指向可用事物的全局指针。然后我将free改为指向这个位置，并继续清除，执行

I then change free to point to this location and I continue sweeping doing

然后我将free改为指向这个位置，并继续清除，执行

location and I continue sweeping doing the next cell and I just do that until I reach the end of the memory and of course to glue it all together my garbage collector in this case starts at the root marks everything and then sweeps starting at 0 just capturing the ideas we did with our little example so there's 1 memory management method the mark sweep algorithm notice of course we have to actually go back and do a little extra work we're going to have to change cons remember in our simpler example cons just linearly moved its way through

位置并继续清除下一个单元，我只是这样做直到到达内存末尾；当然，为了将所有部分粘合在一起，我的垃圾收集器在这种情况下从根开始标记所有内容，然后从0开始清除，只是捕捉我们小例子中的想法。所以有一种内存管理方法，即标记-清除算法。注意，我们实际上必须回去做一些额外的工作；我们将不得不改变cons。记住，在我们更简单的例子中，cons只是线性地移动

cons just linearly moved its way through the memory but here the free cells are actually interspersed and so in fact for this kind of memory management we need cons to get the cell pointed to by the free list it actually should say give me that element in the free list and that free list should then be updated to point to the next free cell that is the thing in the quarter of the current cell

cons只是线性地移动通过内存，但在这里空闲单元实际上是交错的，因此对于这种内存管理，我们需要cons获取空闲列表指向的单元；它实际上应该说给我空闲列表中的那个元素，然后该空闲列表应该被更新为指向下一个空闲单元，即当前单元的cdr中的东西。

and this means as before we're going to have to do a little bit of manipulation of the car encoder part of the cell well that change to cost isn't that hard

这意味着像之前一样，我们将不得不对单元的car和cdr部分进行一些操作。好吧，对cons的改变并不难

Well, that change to cost isn't that hard to envision, and that will let us have this ability to stitch together these cells that are garbage in order to be reused.

好吧，对cons的改变并不难设想，这将使我们能够将这些垃圾单元缝合在一起以便重用。

Notice, however, that the mark sweep algorithm also had this tree walk; we had this tree recursion in which, as we went along to do the mark, we had to mark down the car and cdr parts of the tree. And how do we implement that? Oh, we need a stack, and in particular, we're going to need a separate stack, a stack different from the stack associated with the evaluator. So we'll have to allocate one other stack.

然而请注意，标记-清除算法也进行了这种树遍历；我们进行了这种树递归，在遍历过程中进行标记时，我们必须标记树的 car 和 cdr 部分。那么我们如何实现这一点呢？哦，我们需要一个栈，特别是，我们需要一个单独的栈，一个不同于求值器关联的栈。所以我们必须分配另一个栈。

So we'll have to allocate one other piece in our memory, a stack specifically set aside for garbage collection. Well, if we're going to need a stack, we're going to need to have some memory set-aside for it. And one of the questions is how deep might that stack actually be.

因此，我们必须在内存中分配另一块区域，一个专门用于垃圾收集的栈。好吧，如果我们需要一个栈，我们就需要为其预留一些内存。其中一个问题是，这个栈实际上可能有多深。

And the answer is, well, it could actually be as deep as the number of cells in the heap. And we'll leave it to you as an interesting question to think about what kind of data structure would actually cause us to chew up a huge amount of information on the stack for the garbage collector in order to do the mark stage.

答案是，它实际上可能和堆中的单元数量一样深。我们将留给你一个有趣的问题去思考：什么样的数据结构实际上会导致垃圾收集器在标记阶段消耗大量的栈空间。

collector in order to do the mark stage of that mark sweep algorithm our second method for garbage collection is known as stopping coffee here are the ideas that we take our memory and we split it in two in 1/2 the so called working 1/2 we have again two vectors for the cars and the quitters and then the other half the so-called free half we have two other vectors called new cars and new coders we keep filling up things in the first memory the working memory in the linear fashion we did before until we end up at the end of that memory we were

收集器在标记-清除算法的标记阶段。我们的第二种垃圾收集方法被称为停止-复制。其思想如下：我们将内存分成两半，所谓的“工作半区”，我们再次有两个向量用于 car 和 cdr，然后另一半，所谓的“空闲半区”，我们有另外两个向量，称为新 car 和新 cdr。我们像之前一样以线性方式填充第一块内存（工作内存），直到我们到达该内存的末尾。

end up at the end of that memory we were out of memory at that point. We want to stop and copy literally, we want to stop the machine and copy all the useful information from the first memory, the working memory, into the free memory, and then go back and switch the roles.

当我们到达该内存的末尾时，我们就内存不足了。此时，我们想要停止并复制，字面意思就是，我们停止机器，将所有有用的信息从第一块内存（工作内存）复制到空闲内存，然后切换它们的角色。

So when we're ready to do the stop and copy, that is we've run out of memory and we need to copy things, the first phase is that we're going to move all the good cells into the new memory, leaving behind pointers, so-called forwarding pointers, that tells us where we have moved that.

所以当我们准备好进行停止-复制时，也就是说我们已经用完了内存并且需要复制东西，第一阶段是，我们将所有好的单元移动到新内存中，留下指针，即所谓的转发指针，告诉我们它们被移动到了哪里。

That tells us where we have moved that cell into the new memory. Let's assume that our route pointer, that is a register that points to the beginning of the useful structure, points to element four in this memory. This is exactly the same little list structure we had before; we called it C in that case, but now it is simply pointing to pair four.

这告诉我们该单元被移动到了新内存中的哪个位置。让我们假设我们的根指针，即指向有用结构开头的寄存器，指向该内存中的元素 4。这正是我们之前拥有的相同的小列表结构；我们当时称它为 C，但现在它只是指向第 4 对。

Well, the first thing we do then is copy what's in pair four here into the free element of the first element available to us in the new memory, putting a copy literally of that structure into pair zero in the new memory, and having copied that over.

那么，我们做的第一件事就是将第 4 对的内容复制到新内存中第一个可用的元素，将该结构的字面副本放入新内存的第 0 对，并完成复制。

New memory and having copied that over, we put a marker as to where we put it in the cutter part of this cell, a pointer to p0 in the purple memory. You like, and in the car part of this cell, we put in what's known as a broken heart for historical reasons that says that this element has been moved to the new memory, and the cooter tells us where it was moved to.

新内存，并且复制完成后，我们在该单元的 cdr 部分放置一个标记，指示我们将其放在了哪里，即指向紫色内存中 p0 的指针。如果你愿意，在该单元的 car 部分，我们放入一个所谓的“破碎的心”（出于历史原因），表示该元素已被移动到新内存，而 cdr 告诉我们它被移动到了哪里。

Having moved that first cell over to the new memory, we now take its car and trace out the structure from there, deciding whether we need to move those things as well. Now the car of that...

将第一个单元移动到新内存后，我们现在取其 car 并从中追踪结构，决定是否需要移动那些东西。现在，那个的 car……

Those things as well. Now, the car of that first mu cell points back to a pair in the original memory, to pair p0 in fact. So we're going to move that over and update the structure in the old memory.

那些东西。现在，第一个已移动单元的 car 指向原始内存中的一个对，实际上指向第 0 对。所以我们将它移动过去，并更新旧内存中的结构。

We've moved this cell over, so we put a marker as to where we put it. It's now in p1 in the purple memory, and we've put the broken heart in to indicate that we've moved it over to this new memory.

我们已经将这个单元移动过去了，所以我们放置一个标记指示我们将其放在了哪里。它现在在紫色内存的 p1 中，并且我们放置了“破碎的心”来表示我们已经将它移动到了这个新内存。

Now, if we look at pair 1 in the new memory, there's nothing to move here because we just have a number and an empty list, so we can back up to where we were, which was p0 in the new memory.

现在，如果我们查看新内存中的第 1 对，这里没有什么需要移动的，因为我们只有一个数字和一个空列表，所以我们可以回到我们之前的位置，即新内存中的 p0。

were which was p0 in the new memory and now trace things offer the cooter part of that thing that points to pair 2 or rather pair 1 excuse me in the old memory so we moved that pair over to the next available cell in new memory and update the old memory with a broken heart and a forwarding pointer.

我们之前的位置，即新内存中的 p0，然后追踪该事物的 cdr 部分，它指向旧内存中的第 2 对，或者更确切地说，抱歉，是第 1 对。所以我们将该对移动到新内存中下一个可用的单元，并用“破碎的心”和转发指针更新旧内存。

now if we look at pair 2 in the new memory we can see that it's car is just a number and as could or is a pointer ah but it's a pointer to something that already has a broken heart in it it's a pointer to a structure that's already been moved.

现在，如果我们查看新内存中的第 2 对，我们可以看到它的 car 只是一个数字，而它的 cdr 是一个指针，啊，但它是一个指向已经带有“破碎的心”的对象的指针；它是指向一个已经被移动的结构的指针。

structure that's already been moved and to avoid looping forever, we don't need to go back and trace that portion. Having done that, we're now done with everything we've moved over. We have nothing further to trace, so we've actually moved all of the useful cells into the new memory.

一个已经被移动的结构，为了避免无限循环，我们不需要回去追踪那部分。完成这些后，我们现在已经完成了所有移动过来的东西。我们没有任何进一步需要追踪的了，所以实际上我们已经将所有有用的单元移动到了新内存中。

Now we're ready for the second phase of this operation. We've moved everything useful over into the new memory, but the pointers there are pointing back to old memory. They're pointing to the broken hearts that tell us where to find things, so simply all we need to do is now

现在我们准备进行此操作的第二个阶段。我们已经将所有有用的东西移动到了新内存中，但那里的指针仍然指向旧内存。它们指向“破碎的心”，告诉我们去哪里找东西，所以我们现在需要做的只是

So simply all we need to do is now update the pointers and the move cells, update the pointers and the move cells to reflect the new locations, to actually say where they point to in the new memory rather than this indirect through the old memory. So starting with the first cell of new memory, we start in its car and change its pointer from the old value in the old memory, replacing it with the pointer, the forwarding address, the place it points to in the new memory.

所以我们现在需要做的只是更新移动单元中的指针，更新移动单元中的指针以反映新的位置，实际上说明它们在新内存中指向哪里，而不是通过旧内存间接指向。因此，从新内存的第一个单元开始，我们从其 car 开始，将其指针从旧内存中的旧值改为指向新内存中的转发地址。

We do the same with the cooter; this cell we look up its old value in the old memory, or rather its forwarding address in the old memory, and replace it.

我们对 cdr 做同样的事情；对于这个单元，我们查找它在旧内存中的旧值，或者更确切地说，它在旧内存中的转发地址，并将其替换。

in the old memory and replace it directly with that in the new memory, then we move to the next cell in this new memory and do the same thing. Numbers don't have to change in empty lists, and when we move to the next cell we simply update those things. Numbers are the same but the old pointer gets replaced with its forwarding address to the new pointer.

在旧内存中，并直接用新内存中的地址替换它，然后我们移动到新内存中的下一个单元并做同样的事情。数字和空列表不需要改变，当我们移动到下一个单元时，我们只需更新那些东西。数字保持不变，但旧指针被替换为其转发地址，即新指针。

and having reached the end of the new cells that we want to deal with, we're now done. So we can in fact now swap the roles of these two halves of memory; we change our root pointer to point to the

并且当我们到达了要处理的新单元末尾时，我们就完成了。因此，我们现在实际上可以交换这两半内存的角色；我们改变根指针，使其指向

change our root pointer to point to the beginning of this new structure the place where we moved that cell we have our free pointer point to the beginning portion of the memory that is now available to us and we can carry on.

改变根指针，使其指向这个新结构的起始位置，即我们移动那个单元的地方；我们让空闲指针指向现在可供我们使用的内存的起始部分，然后我们可以继续。

Kant's will use what is it currently pointed to by free, will increment by one, and keep doing that until we run out of memory in this memory, and then we'll do exactly the same thing—we'll stop and copy back into that original memory, reverse the roles, and keep on.

Kant 将使用当前由 free 指向的内容，将其递增一，并持续这样做，直到我们耗尽这块内存中的空间，然后我们将做完全相同的事情——停止并复制回原始内存，交换角色，并继续。

now in the mark sweep algorithm we never move the

现在在标记-清除算法中，我们从不移动

Mark sweep algorithm we never move the actual cells that contains useful information, so we were guaranteed that the list structure we had before we did the garbage collection was exactly the same when we were done.

标记-清除算法中，我们从不移动包含有用信息的实际单元，因此我们保证在进行垃圾回收之前拥有的列表结构在完成后完全相同。

Here we've actually moved things around, so the only thing we have to do is make sure we haven't changed anything. And in fact, if we start at the root, which is where C was, if we trace out the structure in the new memory, we'll get the box and pointer diagram shown here, and we can check that that is in fact exactly the same box and pointer diagram as what we had.

这里我们实际上移动了东西，所以我们唯一要做的就是确保我们没有改变任何东西。事实上，如果我们从根开始，也就是 C 所在的位置，如果我们追踪新内存中的结构，我们会得到这里所示的盒子和指针图，我们可以检查这实际上与我们之前拥有的盒子和指针图完全相同。

Pointer diagram as what we had originally, the pairs are different, the actual values of where they're stored are different, but the structure and therefore the things will get out with car encoder operations have not changed, it's been preserved, which is exactly what we want as we've done this stop and copy garbage collection. So here then is a description, a little more algorithmic detail of what we just did.

指针图与我们最初拥有的完全相同，对是不同的，它们存储的实际值不同，但结构以及因此通过 car 和 cdr 操作得到的东西没有改变，它被保留了，这正是我们在进行停止-复制垃圾回收时想要的。所以这里是对我们刚才所做事情的描述，更详细一点的算法细节。

Our stop and copy algorithm is very straightforward. We set the free and scan pointers to the beginning of the new memory when we're

我们的停止-复制算法非常简单。当我们准备停止并复制时，我们将 free 和 scan 指针设置为新内存的开头

beginning of the new memory when we're ready to stop and copy we move the route pair over to the new memory and adjust its pointer to the new location incrementing free as necessary and then we go back and mark old pairs by putting that forwarding pointer that broken heart in telling us where we move things through and the basic cycle is to simply trace the pointers in the car encoder of the cell pointed to by scan back to the old memory we relocate each one if it's a forwarding pointer we just use that address to update the pointers and if it's not a forwarding pointer we copy it

新内存的开头，当我们准备停止并复制时，我们将根对移动到新内存，并调整其指针到新位置，根据需要递增 free，然后我们回去通过放置那个转发指针（那个破碎的心）来标记旧对，告诉我们我们把东西移到了哪里，基本循环是简单地追踪由 scan 指向的单元的 car 和 cdr 中的指针回到旧内存，我们重新定位每一个，如果它是一个转发指针，我们就使用那个地址来更新指针，如果它不是转发指针，我们就复制它

it's not a forwarding pointer we copy it into the free pair in commit free store a forwarding pointer and update the pointers and go back and increment scan and we keep doing that until scan actually catches up to free telling us that we're stopped we've done everything we have to

如果它不是转发指针，我们就将它复制到空闲对中，在空闲存储中提交，放置一个转发指针，并更新指针，然后回去递增 scan，我们持续这样做，直到 scan 实际上赶上 free，告诉我们我们已经停止，我们已经完成了我们必须做的一切

now we can actually implement that and here's a scheme description of that code the GC coffee is going to do the following given a pointer scan it's going to run through that little cycle we just described

现在我们实际上可以实现它，这里是该代码的 Scheme 描述，GC 复制过程将执行以下操作：给定一个指针 scan，它将运行我们刚才描述的那个小循环

if scans not equal to free then I still have something to do and in particular

如果 scan 不等于 free，那么我还有事情要做，特别是

have something to do and in particular, what do I want to do? Well, I'm going to change the car of what's currently points to, to be whatever the forwarding reference is for the current thing in there. And I'm changing the cooter of scan to point to whatever the forwarding reference for the cooter of that thing is. Then I move on and forward.

还有事情要做，特别是，我想做什么？好吧，我将改变当前 scan 指向的单元的 car，使其成为其中当前内容的转发引用。我将改变 scan 的 cdr，使其指向该事物的 cdr 的转发引用。然后我继续前进。

Well, you can look it through, but you can see it just does the right thing of actually walking its way along, finding the right place to point to. So what's the relationship between stop and copy?

嗯，你可以仔细看看，但你可以看到它只是做了正确的事情，实际上一路走来，找到正确的指向位置。那么停止-复制和标记-清除之间有什么关系呢？

relationship between stop and copy

停止-复制和标记-清除之间的关系

relationship between stop and copy garbage collection and mark-sweep and garbage collection and mark-sweep and basically there's some trade-offs the big disadvantage is that in stop and copy we require double the memory or if you want to think of it for a fixed amount of memory we only ever have half of it available at any one point in time because we have to reserve the other half for coffee on the other hand there's an advantage here and the advantage is that this garbage collector compacts things that is when we do this dolfyn coffee it puts all the connected cells at the front of the memory which

停止-复制垃圾回收和标记-清除垃圾回收之间的关系，基本上有一些权衡。最大的缺点是，在停止-复制中，我们需要双倍的内存，或者如果你想认为对于固定数量的内存，我们在任何时间点只能使用一半，因为我们必须保留另一半用于复制。另一方面，这里有一个优势，优势在于这个垃圾回收器会压缩东西，也就是说，当我们做这个停止-复制时，它会把所有连接的单元放在内存的前面，这

Cells at the front of the memory, which both makes consing much more efficient because it just linearly moves things along. And if we have things like paging, something you'll see later on in your courses here in course six, that means that the things we want to get at are actually more easily accessible.

单元放在内存的前面，这既使得构造更高效，因为它只是线性地移动东西。而且如果我们有像分页这样的东西，你将在课程六中稍后看到，这意味着我们想要访问的东西实际上更容易访问。

So what we've seen then is that we can actually build our list-structured memory out of a very simple construct, given this idea of a vector, a string of elements in the memory indexed by an integer, with the ability to get to that point in constant time by simply.

所以我们看到的是，我们实际上可以用一个非常简单的构造来构建我们的列表结构内存，给定这个向量的概念，即内存中由整数索引的元素串，能够通过简单地偏移来在常数时间内到达那个点。

Point in constant time by simply offsetting from some base location we just take two of those and glue them together to give us the idea of a pair and of course the impact on the language is that we have a very flexible compound data mechanism everything we've seen in scheme can be glued together with list structure or tree structure built odourless structure which all relies on having that ability to constants since we're going to use numbers to indicate indices or offsets into that list structure we have to be a little more clever and we use a tagged memory

通过简单地从某个基地址偏移来在常数时间内到达那个点，我们只需取两个这样的东西并将它们粘在一起，给我们对的概念，当然对语言的影响是我们有一个非常灵活的复合数据机制，我们在 Scheme 中看到的一切都可以用列表结构或树结构粘合在一起，构建无气味的结构，这一切都依赖于拥有那种构造能力。既然我们要使用数字来表示列表结构中的索引或偏移量，我们必须更聪明一点，我们使用带标签的内存

We use a tagged memory architecture to do that. This means given a number or given a bit representation of some piece of data, we reserve a small set of bits at the front to indicate a tag: is this a number, is this an empty list, or is this actually a pointer into a pair? That tells us how to in fact interpret the rest of the data structure.

我们使用带标签的内存架构来做到这一点。这意味着给定一个数字或给定某个数据位的表示，我们在前面保留一小部分位来指示一个标签：这是一个数字，这是一个空列表，还是这实际上是一个指向对的指针？这告诉我们如何实际解释数据结构的其余部分。

One of the nice things about this, in terms of the language by the way, is that it allows us to do some amount of runtime type checking. We could actually check at run time to make sure the structures we have are the ones we expect.

关于这一点的一个好处，顺便说一下，就语言而言，是它允许我们进行一定程度的运行时类型检查。我们实际上可以在运行时检查以确保我们拥有的结构是我们期望的。

sure the structures we have are the right source by looking at the types and this also provides a great deal of flexibility in how we build and manipulate the language and finally we've seen the given that we were going to build a language out of this simple pair structure we have a nice way of being able to handle reallocation of that memory

通过查看类型，我们可以确保所拥有的结构是正确的来源，这也为我们构建和操作语言提供了极大的灵活性。最后，我们看到了，既然我们要用这种简单的配对结构来构建语言，我们就有了一种很好的方式来管理该内存的重新分配。

we're going to do garbage collection to find those cells we no longer need and reuse them giving us the impression of having much more memory than we actually have while there's some cost in terms of efficiency by doing

我们将进行垃圾回收，以找到那些不再需要的单元并重新使用它们，从而给我们一种拥有比实际更多内存的印象。虽然这样做在效率上会有一些代价，

cost in terms of efficiency by doing garbage collection there's a very nice impact on the language namely we free up the programmer from having to do the memory management directly and that avoids lots of the constant problems one has in those areas especially when we get memory leaks of accidentally using up more memory than we want and not being able to reclaim it here the machine takes care of it for us

在效率上的代价，即通过进行垃圾回收，对语言有一个非常好的影响，即我们使程序员免于直接进行内存管理，这避免了在这些领域中经常出现的许多持续性问题，尤其是当我们遇到内存泄漏，意外地使用了超出预期的内存而无法回收时。在这里，机器替我们处理了这一切。