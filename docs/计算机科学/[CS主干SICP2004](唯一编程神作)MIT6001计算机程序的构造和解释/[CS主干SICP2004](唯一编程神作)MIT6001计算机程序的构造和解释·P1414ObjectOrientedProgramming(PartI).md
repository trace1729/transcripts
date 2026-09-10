# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=14)

## Summary (摘要)

- The lecture introduces object-oriented programming as an alternative approach to breaking systems into modules, contrasting with traditional procedural and data abstractions.
- It demonstrates the concept of message passing by implementing pairs as procedures that capture local state, showing how cons, car, and cdr can be implemented with procedures.
- The lecture illustrates how procedures can capture state and respond to messages, enabling mutation through messages like set-car!, and introduces dot notation for handling arbitrary numbers of arguments.
- Object-oriented systems are built around classes (common behavior) and instances (specific state), with a maker procedure creating instances that respond to messages.
- Extensibility is highlighted by adding new classes (like space stations and torpedoes) and methods (like display and explode), showing flexibility but also complexity.
- Inheritance is introduced via superclasses (like mobile thing) to share common state and methods, simplifying maintenance and modularization.

- 本讲座介绍面向对象编程，作为将系统分解为模块的一种替代方法，与传统的程序抽象和数据抽象形成对比。
- 它通过将序对实现为捕获局部状态的过程来演示消息传递的概念，展示了如何用过程实现 cons、car 和 cdr。
- 讲座说明了过程如何捕获状态并响应消息，通过诸如 set-car! 之类的消息实现变更，并引入了点号表示法来处理任意数量的参数。
- 面向对象系统围绕类（共同行为）和实例（特定状态）构建，通过一个制造过程创建响应消息的实例。
- 可扩展性通过添加新类（如空间站和鱼雷）和方法（如显示和爆炸）得到强调，展示了灵活性但也带来了复杂性。
- 通过超类（如移动物体）引入继承，以共享共同状态和方法，简化维护和模块化。

## Outline (大纲)

1. Introduction to Object-Oriented Programming / Review of Procedural and Data Abstractions
2. Modularizing Systems: Questions and Approaches / Traditional Data Abstractions and Data-Directed Programming
3. Extensibility in Tag-Based Systems
4. Procedures with State: A New View of Data
5. Implementing Pairs as Procedures: Car and Cdr
6. Tracing the Evaluation of Procedures as Data
7. Message Passing for Mutable Data and Generalization
8. Object-Oriented Style, Classes, and Instances
9. Building and Extending an Object-Oriented System
10. Superclasses, Inheritance, and Conclusion

1. 面向对象编程导论 / 程序抽象与数据抽象回顾
2. 系统模块化：问题与方法 / 传统数据抽象与数据导向编程
3. 基于标签系统的可扩展性
4. 带状态的过程：数据的新视角
5. 用过程实现序对：Car 和 Cdr
6. 追踪作为数据的过程的求值
7. 用于可变数据和泛化的消息传递
8. 面向对象风格、类与实例
9. 构建和扩展面向对象系统
10. 超类、继承与结论

## Transcript (文稿)

### 1. Introduction to Object-Oriented Programming / Review of Procedural and Data Abstractions (面向对象编程导论 / 程序抽象与数据抽象回顾)

In this lecture, we're going to look at a very different style of creating large systems. This style is called object-oriented programming, and it focuses on breaking systems up in a different manner than what we've seen prior to this.

在本讲座中，我们将探讨一种创建大型系统的非常不同的风格。这种风格被称为面向对象编程，它侧重于以不同于我们之前所见的方式将系统分解。

To set the stage for this, we're first going to go back and look at the notion of abstractions, use that idea to see how we can capture objects with some internal state that reflects the status of those objects, and how to manipulate that.

为了为此奠定基础，我们首先回顾抽象的概念，利用这一思想来看如何捕获具有反映对象状态的内部状态的对象，以及如何操作这些状态。

We're going to be led from there to a style of programming called message passing.

我们将由此引向一种称为消息传递的编程风格。

style of programming called message passing in which we treat systems as if they consist of large collections of objects that communicate with one another to cause computation to take place.

一种称为消息传递的编程风格，在这种风格中，我们将系统视为由大量相互通信的对象组成，这些对象通过通信来引发计算。

let's start by going back and thinking about the tools we develop so far for thinking about computation - the key ones we've developed have dealt with abstractions we've seen procedural abstractions here the idea is to capture a common pattern of processing into a procedure then isolate the details of the computation from the use of the computation by simply naming the

让我们首先回顾一下迄今为止我们开发的计算思维工具——我们开发的关键工具涉及抽象，我们看到了程序抽象，其思想是将常见的处理模式捕获到一个过程中，然后通过简单地命名过程，将计算的细节与计算的使用隔离开来。

computation by simply naming the procedure and using it with appropriate conditions on its input we saw that this style of approach is particularly useful when dealing with problems that are easily addressed in a functional programming approach that is where we can treat the procedures as generalize mathematical functions meaning that their output for a given input will be the same whenever we evaluate it.

通过简单地命名过程，并在适当的输入条件下使用它，我们看到这种风格的方法在处理易于以函数式编程方法解决的问题时特别有用，也就是说，我们可以将过程视为广义的数学函数，即对于给定的输入，其输出在每次求值时都是相同的。

we've also seen data abstractions here the idea is to modularize our system by creating data structures that capture key parts of the information we need to

我们还看到了数据抽象，其思想是通过创建数据结构来模块化我们的系统，这些数据结构捕获我们需要处理的信息的关键部分。

key parts of the information we need to handle the goal is to hide the details of the representation and storage of the data behind standard interfaces primarily our constructors and selectors.

信息的关键部分，目标是隐藏数据的表示和存储细节，将其置于标准接口（主要是构造函数和选择函数）之后。

this means that the user can then manipulate data objects without having to worry about details of how they were maintained as we might expect often the data abstractions and the procedural abstractions go hand in hand but the procedures used to manipulate the data using the data abstraction interfaces and with the structure of the procedure

这意味着用户可以操作数据对象，而不必担心它们是如何维护的。正如我们可能预期的，数据抽象和程序抽象常常相辅相成，但用于操作数据的过程使用数据抽象接口，并且过程的结构往往反映数据的实际结构。

and with the structure of the procedure tending to mirror the actual structure of the data, the goal in each case is actually the same: we want to hide details of the abstractions so that we can treat complex things as if they are primitive units.

并且过程的结构往往反映数据的实际结构，每种情况下的目标实际上是相同的：我们希望隐藏抽象的细节，以便将复杂的事物视为原始单元。

### 2. Modularizing Systems: Questions and Approaches / Traditional Data Abstractions and Data-Directed Programming (系统模块化：问题与方法 / 传统数据抽象与数据导向编程)

In the case of procedural abstractions, we want to hide the details of the computation and treat the procedure as a primitive computational unit.

在程序抽象的情况下，我们希望隐藏计算的细节，并将过程视为原始的计算单元。

In the case of data abstractions, we want to hide the details of how components are glued together and treat each unit as an abstract collection of parts, given that we want.

在数据抽象的情况下，我们希望隐藏组件如何组合在一起的细节，并将每个单元视为抽象的部分集合，鉴于我们想要。

Collection of parts, given that we want to use abstractions as a tool in controlling complexity in systems, there are several questions that come up when thinking about how to use abstractions. The first is what's the best way to break a new problem area into a set of modules, both data modules and procedure modules?

部分集合，鉴于我们想要使用抽象作为控制系统复杂性的工具，在思考如何使用抽象时会出现几个问题。首先，将一个新的问题领域分解为一组模块（包括数据模块和过程模块）的最佳方式是什么？

As we've already seen in earlier lectures, some problems break down in multiple ways, and breaking them down in different ways makes some things easier and other things less easy. So a key question is: how do I use the idea of abstraction to break systems?

正如我们在之前的讲座中已经看到的，一些问题有多种分解方式，而不同的分解方式会使某些事情变得更容易，另一些则不那么容易。因此，一个关键问题是：我如何使用抽象的思想来分解系统？

idea of abstraction to break systems into modules and what's the right way to do that and the second set of questions we asked basically deal with how easy is it to extend the system if I want to add new data types to my system is it easy to do or hard if I want to add new methods new ways of manipulating data types in my system is it easier if it's hard we've seen several examples of this already we're going to come back now and look at those questions in order to lead to a very different way of breaking big systems up into convenient sized chunks

抽象的思想将系统分解为模块，以及什么是正确的方式；第二组问题基本上涉及系统的可扩展性：如果我想向系统添加新的数据类型，是容易还是困难？如果我想添加新的方法（操作数据类型的新方式），是容易还是困难？我们已经看到了几个例子，现在我们将回到这些问题，以引出一种将大型系统分解为方便大小块的非常不同的方式。

systems up into convenient sized chunks. Let's start by going back to data objects and data abstractions. Here's the traditional way of looking at data, at least as we've done it so far.

将系统划分为大小合适的块。让我们从数据对象和数据抽象开始回顾。这是看待数据的传统方式，至少到目前为止我们是这样做的。

First, we build some complex data structure out of primitives—for example, cons cells or pairs. Secondly, we use tags to identify the type of structure being represented. This tells us how to interpret different slots in the list structure—for example, is the car of the list structure the name of a person, or a batting average, or GPA?

首先，我们用原语构建一些复杂的数据结构——例如，cons 单元或序对。其次，我们使用标签来标识所表示结构的类型。这告诉我们如何解释列表结构中的不同槽位——例如，列表结构的 car 是一个人的名字，还是击球率，还是 GPA？

or is GPA then the data abstraction is actually built by creating a set of procedures that operate on the data that is these are procedures that take in instances of the data use selectors to get out the pieces do some manipulation to create new pieces then use a constructor to reglue the abstraction back together. This led to the concept of data directed programming which we saw earlier use the tag to determine the right set of procedures to apply and this of course allows the user to program in a generic fashion they can just think about what they want to do.

或者，如果 GPA 是数据抽象，那么数据抽象实际上是通过创建一组操作数据的程序来构建的，这些程序接收数据实例，使用选择器取出各部分，进行一些操作以创建新部分，然后使用构造函数将抽象重新粘合在一起。这导致了数据导向编程的概念，我们之前看到过，使用标签来确定要应用的正确程序集，这当然允许用户以通用方式进行编程，他们只需考虑自己想要做什么。

just think about what they want to do, but have the code direct the data to the right place for the actual work. Here's a simple little example to illustrate the point.

只需考虑自己想要做什么，但让代码将数据引导到正确的位置进行实际工作。这里有一个简单的小例子来说明这一点。

Suppose I have a set of different arithmetic objects, this particular geometric objects, things like numbers, lines, shapes, other such things, and I want to write a procedure or an operation that will scale each of those objects by some amount.

假设我有一组不同的算术对象，特别是几何对象，比如数字、线、形状等，我想编写一个程序或操作，将每个对象按一定量缩放。

Then a generic operation under the data directed programming style would look like the procedure shown here, given an object and a scale factor I want to scale by, I use.

那么在数据导向编程风格下，一个通用操作看起来就像这里显示的程序，给定一个对象和我想缩放的缩放因子，我使用对象的类型进行分派。

a scale factor I want to scale by I use a scale factor I want to scale by I use the type of the object to dispatch if the type of the object to dispatch if the type of the object to dispatch if it's a number I just multiply it out if it's a number I just multiply it out if it's a number I just multiply it out if it's a line I ship it to the thing that it's a line I ship it to the thing that it's a line I ship it to the thing that will scale aligned by the right amount will scale aligned by the right amount will scale aligned by the right amount

我想缩放的缩放因子，我使用对象的类型进行分派，如果是数字，我就直接相乘；如果是线，我就将其发送到按正确量缩放线的程序；如果是任意形状，我就将其发送到形状缩放程序。

if it's some arbitrary shape I ship it if it's some arbitrary shape I ship it if it's some arbitrary shape I ship it off to that thing and shape scale for off to that thing and shape scale for off to that thing and shape scale for example might have different procedures example might have different procedures example might have different procedures for different kinds of shapes so there's for different kinds of shapes so there's for different kinds of shapes so there's second level of data direction taking second level of data direction taking second level of data direction taking place here the point of this example is place here the point of this example is place here the point of this example is that I think about things in terms of that I think about things in terms of that I think about things in terms of here are the kinds of objects and my here are the kinds of objects and my here are the kinds of objects and my procedures for manipulating them use the

如果是任意形状，我就将其发送到形状缩放程序，例如，对于不同种类的形状可能有不同的程序，所以这里发生了第二层的数据导向。这个例子的要点是，我根据对象的种类来思考，而我操作它们的程序使用对象类型上的标签来告诉我该做什么以及发送给谁。

procedures for manipulating them use the tag on the type of the object to tell me what to do and who to send it to ok now let's go back to our questions how easy is it to extend such a system a system where we're breaking things up in terms of tag data and using data directed programming first if we add a new data type to our system what do we have to do well we can see from this example here we're going to have to go through and modify all the procedures like this we're going to have to add a new clause to each cond dispatching off to that new

操作它们的程序使用对象类型上的标签来告诉我该做什么以及发送给谁。好了，现在让我们回到我们的问题：扩展这样一个系统有多容易？一个我们根据标签数据和数据导向编程来分解事物的系统。首先，如果我们向系统添加一个新的数据类型，我们需要做什么？从这个例子中我们可以看到，我们将不得不遍历并修改所有像这样的程序，我们将不得不为每个 cond 添加一个新的子句，分派到那个新的类型。

### 3. Extensibility in Tag-Based Systems (基于标签的系统的可扩展性)

to each cond dispatching off to that new

为每个 cond 添加一个新的子句，分派到那个新的类型。

to each cond dispatching off to that new type and as a consequence if there are a lot of such things we got a lot of changes to make both a great deal of code to write and more importantly making sure that we make changes in all of the appropriate dispatches if we add a new operation or method what do we need to do well in that case we just need to develop a sub procedure for each relevant type so it says in this kind of programming the first parts painful adding a new data type to our system the second part is not so bad in that case adding a new operation or method as a

为每个 cond 添加一个新的子句，分派到那个新的类型。因此，如果有很多这样的东西，我们需要做很多更改，既要编写大量代码，更重要的是确保我们在所有适当的分派中进行更改。如果我们添加一个新的操作或方法，我们需要做什么？在这种情况下，我们只需要为每个相关类型开发一个子程序。所以在这种编程中，第一部分是痛苦的：向我们的系统添加一个新的数据类型；第二部分还不错：添加一个新的操作或方法。

adding a new operation or method as a consequence this approach this idea of breaking things up in terms of tag data dispatch on type this approach works best when there are a small number of data abstractions or when the changes are mostly new methods or operations or when the different kinds of data structures in the system are very independent on or unrelated to one another in those cases this style of approach works pretty well

添加一个新的操作或方法。因此，这种方法——根据标签数据和类型分派来分解事物——在数据抽象数量较少，或者更改主要是新方法或操作，或者系统中不同种类的数据结构非常独立或彼此无关时效果最好。在这些情况下，这种风格的方法效果相当好。

but of course we know not everything fits that kind of framework or paradigm so what do we do when we have problems that don't obey

但当然，我们知道并非所有事物都适合这种框架或范式。那么，当我们遇到不遵循这种模型的问题时，我们该怎么办？

when we have problems that don't obey this kind of model so let's step back from this organization for a second one way to think about structuring a large system is to realize that we are likely to have a large number of different data objects or instances of data abstractions and a large number of operations we want to perform on those objects conceptually this means we have a big table where we can use a different row for each operation we want to perform and a different column for each kind of data abstraction we have then at each element of this table we can

当我们遇到不遵循这种模型的问题时，让我们暂时退一步来看这种组织方式。思考构建大型系统的一种方式是认识到我们可能拥有大量不同的数据对象或数据抽象实例，以及大量我们想要对这些对象执行的操作。从概念上讲，这意味着我们有一个大表，其中每一行对应我们想要执行的一个操作，每一列对应我们拥有的一种数据抽象。然后，在这个表的每个元素处，我们可以概念化一个特定的程序，旨在对特定种类的数据对象（例如数字）执行特定操作（例如缩放）。

each element of this table, we can conceptualize having a specific procedure intended to perform the particular operation, for example scaling, on the particular kind of data object, for example a number.

在这个表的每个元素处，我们可以概念化一个特定的程序，旨在对特定种类的数据对象（例如数字）执行特定操作（例如缩放）。

One way of actually building such a system is to focus on the rows of the table, or in other words, the operations. Indeed, our use of tag data was based around this viewpoint, in which we created generic operations that handle the same operation for different data objects, and we used the tag on the data object to dispatch to the appropriate operation.

构建这样一个系统的一种实际方法是关注表格的行，换句话说，关注操作。确实，我们对标签数据的使用就是基于这种观点，我们创建了通用操作，这些操作处理不同数据对象的相同操作，并使用数据对象上的标签来分派到适当的操作。

object to dispatch to the appropriate version of the procedure to handle that kind of data but given this table there is an alternative possible organization which is around the columns of the table. This would focus on creating a generic data object that would know how to handle different kinds of operations for a particular kind of data structure. Well, let's step back and rethink data. Sounds like an odd thing to do, but let's think about data in a very different way. In particular, rather than thinking of data abstractions as a structure with some

对象分派到处理该类数据的适当过程版本，但鉴于这个表格，还有一种可能的组织方式是围绕表格的列。这将侧重于创建一个通用的数据对象，该对象知道如何处理特定数据结构的不同操作。好吧，让我们退一步重新思考数据。听起来很奇怪，但让我们以非常不同的方式思考数据。特别是，与其将数据抽象视为具有某些槽位的结构，不如将数据视为具有某些内部状态的过程。哇，这听起来很奇怪。

### 4. Procedures with State: A New View of Data (具有状态的过程：数据的新视角)

Abstractions as a structure with some...

抽象作为具有某些槽位的结构……

Abstractions as a structure with some slots into which we can put things—let's instead consider data to be a procedure with some internal state. Whoa, that sounds strange. Well, first of all, what is a procedure? Well, it really has two parts: it has a set of parameters and a body—the things that are specified by the lambda expression, which say what things you should be able to pass in and what you want to do when you do that. And, as we've seen in the environment model, it has an environment associated with it which can hold name-value bindings.

抽象作为具有某些槽位的结构，我们可以将东西放入其中——相反，让我们将数据视为具有某些内部状态的过程。哇，这听起来很奇怪。好吧，首先，什么是过程？它实际上有两个部分：它有一组参数和一个主体——由 lambda 表达式指定的内容，说明你应该能够传入什么以及当你这样做时你想做什么。而且，正如我们在环境模型中所看到的，它有一个与之关联的环境，该环境可以保存名称-值绑定。

hold name value bindings that is

保存名称-值绑定，即

hold name value bindings that is pairings of names and values so what you say well we can actually use this idea to capture information about a data structure in particular we could use a procedure to represent a data object a data object with some state what would that mean would say that we could use the local environment of the procedure plus its parameters to hold the values of the data object and secondly we could create local procedures within the procedure to manipulate those values to change the state of the object to change the values associated with the data

保存名称-值绑定，即名称和值的配对，所以你说，我们实际上可以利用这个想法来捕获关于数据结构的信息，特别是我们可以使用过程来表示数据对象，一个具有某些状态的数据对象。那意味着什么？我们会说，我们可以使用过程的局部环境及其参数来保存数据对象的值，其次，我们可以在过程内部创建局部过程来操作这些值，以改变对象的状态，改变与数据相关联的值。

the values associated with the data structure that we're representing this way. This means that the only access to the values held in the environment of the procedure would be through the procedure itself. So we would be nicely encapsulating that data structure inside this procedure. This sounds like a lot of words and probably still sounds kind of odd.

与我们所表示的数据结构相关联的值。这意味着对过程环境中保存的值的唯一访问是通过过程本身。因此，我们将很好地封装该数据结构在这个过程内部。这听起来像是很多话，可能仍然听起来有点奇怪。

So in the next set of slides, let's look at an example to see what we mean. To illustrate this idea of using a procedure to represent a data structure, an object with state, let's look at the

所以在下一组幻灯片中，让我们看一个例子来理解我们的意思。为了说明使用过程来表示数据结构（具有状态的对象）的想法，让我们看看

an object with state let's look at the following rather odd example here's a very different way of implementing a con cell or a pair and let me stress this is not the way it's done inside of scheme although you should know by now that the idea of data abstraction says you shouldn't really care and probably shouldn't be able to tell but it drives home a conceptual point so what do we have here we've implemented a pair as a procedure unless our fundamental data structure is now a procedure not some storage and memory slots so let's look at this carefully

一个具有状态的对象，让我们看看下面这个相当奇怪的例子。这里有一种非常不同的实现 cons 单元或序对的方法，让我强调这不是 Scheme 内部的做法，尽管你现在应该知道数据抽象的思想说你不应该真正关心，可能也不应该能够分辨出来，但它强调了一个概念点。那么我们这里有什么？我们将序对实现为一个过程，除非我们的基本数据结构现在是一个过程，而不是一些存储和内存槽位。所以让我们仔细看看。

### 5. Implementing Pairs as Procedures: Car and Cdr (将序对实现为过程：Car 和 Cdr)

So let's look at this carefully. First note that cons as defined here involves two lambdas — remember there's a hidden lambda inside the syntactic sugar. This means that there's a second one in the body of the cons. So when we evaluate cons of X Y using this particular implementation, we get back as a value a procedure of one parameter MSG, or message.

所以让我们仔细看看。首先注意这里定义的 cons 涉及两个 lambda——记住在语法糖内部有一个隐藏的 lambda。这意味着在 cons 的主体中有第二个 lambda。所以当我们使用这个特定实现求值 cons X Y 时，我们得到的值是一个单参数 MSG（或消息）的过程。

So what does this say? It says when we use cons using this implementation, the thing we get back — the representation for our fundamental way of gluing things together — is now a procedure. It's a lambda of one argument.

那么这意味着什么？它说当我们使用这个实现使用 cons 时，我们得到的东西——我们基本粘合方式的表示——现在是一个过程。它是一个单参数的 lambda。

procedure it's a lambda of one argument. MSG now what would that constant do that? Value we get back since it's a procedure, if we send it a value or apply it if you'd like to an argument note what it does. It uses the value of the message in this case it better be a symbol of a particular kind. It uses that value to decide what value to return. We call this style of programming message passing, because the procedure here accepts a message and then does something based on the particular value of the message it got as input. So this looks a bit weird.

过程，它是一个单参数的 lambda。MSG 现在那个常量会做什么？我们得到的值，因为它是一个过程，如果我们向它发送一个值或应用它（如果你愿意）到一个参数，注意它做什么。它使用消息的值，在这种情况下最好是一个特定种类的符号。它使用该值来决定返回什么值。我们称这种编程风格为消息传递，因为这里的过程接受一个消息，然后根据它收到的消息的特定值做一些事情。所以这看起来有点奇怪。

Got as input, so this looks a bit weird. Our constructor now for gluing things together gives us a procedure as the actual object, but should we care what we know? We shouldn't write to complete the abstraction for a pair; we know what we need to do. We just need to create car and coder to fulfill the contract of the abstraction of a pair.

作为输入，所以这看起来有点奇怪。我们的构造函数现在用于粘合东西，给我们一个过程作为实际对象，但我们应该关心我们知道什么？我们不应该写来完成序对的抽象；我们知道我们需要做什么。我们只需要创建 car 和 cdr 来满足序对抽象的契约。

So each of those is itself a procedure that takes as input a pair, which we know is a procedure, and then applies that procedure to a single argument, which in this case is just a symbolic message, and ideally that message should get us back.

所以每一个本身都是一个过程，它接受一个序对（我们知道是一个过程）作为输入，然后将该过程应用到一个单一参数，在这种情况下只是一个符号消息，理想情况下该消息应该让我们得到。

Ideally that message should get us back the value we need to satisfy the contract. And indeed, if we look at the definition for car, it's taking as input one of these pairs, which is a procedure. And what is the body of car say to do? It says passed that procedure the message car, the symbol car, which in principle should then give us back out the value we use when we glued the two things together.

理想情况下，该消息应该让我们得到满足契约所需的值。确实，如果我们看 car 的定义，它接受一个这样的序对作为输入，这是一个过程。car 的主体说要做什么？它说将消息 car（符号 car）传递给那个过程，原则上应该让我们得到我们粘合两个东西时使用的值。

Note the other procedure we built here, our predicate for testing whether something is a pair, now relies on the pair identifying itself. This is equivalent to...

注意我们在这里构建的另一个过程，我们用于测试某物是否是序对的谓词，现在依赖于序对自我识别。这等同于……

Identifying itself, this is equivalent to our earlier tag, or in other words, before we attach the tag as a symbol to a data structure, here our tags are procedures that identify the kind of object. Okay, let's check it out.

自我识别，这等同于我们之前的标签，或者换句话说，之前我们将标签作为符号附加到数据结构上，这里我们的标签是识别对象类型的过程。好的，让我们检查一下。

### 6. Tracing the Evaluation of Procedures as Data (追踪作为数据的过程的求值)

Let's take this rather strange implementation for a pair. A pair is now represented as a procedure, and let's see if it does the right thing. So let's use it. Let's cost together the numbers one and two, and give them the name foo. So here's an environment diagram that would represent the state of the world before we do this in the global environment.

让我们来看看这个相当奇怪的对（pair）实现。现在一个对被表示为一个过程，让我们看看它是否能正确工作。所以让我们使用它。让我们把数字1和2组合在一起，并给它们命名为foo。所以这里是一个环境图，它表示我们在全局环境中执行此操作之前的世界状态。

we do this in the global environment we have a binding for cons is two this procedure as we just saw in the previous slide so what happens when we evaluate this what conses just a procedure so evaluating the sub expression cons 1 2 says take the value of kant's which is a procedure and apply it there for drop a frame scoped by the same place the procedure is inside that frame bind the parameters x and y to the values 1 and 2 the input parameters and relative to that new environment evaluate the body of the procedure and that body is itself

我们在全局环境中执行此操作，我们有一个cons的绑定，它是这个过程，正如我们在上一张幻灯片中看到的。那么当我们求值这个表达式时会发生什么？cons只是一个过程，所以求值子表达式cons 1 2意味着取cons的值（它是一个过程）并应用它，因此创建一个由该过程所在的同一环境作用域的新框架，在该框架中绑定参数x和y到值1和2（输入参数），然后相对于该新环境求值过程体，而该过程体本身是

of the procedure and that body is itself at lambda so it makes a new procedure object notice the environment pointer points to the frame a 1 because that's the environment in which I was evaluating it and then that entire procedure is returned as the value of the cons.

过程体本身是一个lambda，所以它创建一个新的过程对象。注意环境指针指向框架a1，因为那是我求值它的环境，然后整个过程作为cons的值返回。

what else happens well then we define foo in the global environment which is where we were doing the original evaluation we bind foo to point to that object that procedure.

还有什么其他事情发生？然后我们在全局环境中定义foo，那正是我们进行原始求值的地方，我们将foo绑定到指向那个对象，那个过程。

notice what this does it gives us an object in this environment whereby object I mean the thing enclosed in red here it's a

注意这做了什么：它给了我们一个环境中的对象，这里我所说的对象是指红色包围的东西，它是一个

The thing enclosed in red here it's a procedure that has a local frame with some bindings or values in it, some state information X and bound to 1, Y is bound to 2. That is itself scoped by the global environment and it's referred to by a name outside of it.

红色包围的东西是一个过程，它有一个局部框架，其中包含一些绑定或值，一些状态信息，X绑定到1，Y绑定到2。它本身由全局环境作用域，并且被外部的一个名称所引用。

Thus, from the perspective of a user interacting at the global environment, foo refers to a structure that has within it information about what the first part of the object is one, information about what the second part of the object is two, and it should, if we see in a second, have further details.它应该在一秒后出现。

因此，从在全局环境中交互的用户的角度来看，foo指的是一个结构，其内部包含关于对象第一部分是1的信息，关于对象第二部分是2的信息，并且它应该，如果我们稍后看到，还有更多细节。它应该在一秒后出现。

it should if we see in a second have information about how to get that data back out so this pattern this capturing of a procedure that takes in messages has associated with it an environment frame with some local state and the messages allow us to get different information out of that state this particular structure is a very common pattern

它应该，如果我们稍后看到，有关于如何取回这些数据的信息。所以这种模式，即捕获一个接收消息的过程，并关联一个带有一些局部状态的环境框架，消息允许我们从该状态中获取不同的信息，这种特定的结构是一个非常常见的模式

that we're going to come back to now all we have to do is check that the contract holds for this data abstraction and in doing so we'll see how this structure this object of a procedure that accepts messages and returns information

我们稍后会回到这个模式。现在我们要做的就是检查这个数据抽象的契约是否成立，通过这样做，我们将看到这个结构，这个接受消息并返回信息的过程对象，

messages and returns information actually captures what we want so let's evaluate car of food looks like a normal expression we know it should get converted into sending this object food the message or symbol car but let's see how that actually happens or said another way evaluating car a foo in the global environment says get the values of car which is a procedure and the value of foo which we see is this procedure and apply the car procedure to this argument which is we saw converts this into evaluating foo with the message CA R as a symbol with respect to

接受消息并返回信息，实际上捕获了我们想要的东西。所以让我们求值car of foo，它看起来像一个普通表达式。我们知道它应该被转换为向这个对象foo发送消息或符号car，但让我们看看这实际上是如何发生的。换句话说，在全局环境中求值car a foo意味着取car的值（它是一个过程）和foo的值（我们看到它是一个过程），并将car过程应用于这个参数，这我们看到了，转换为相对于某个新框架求值foo，以符号CA R作为消息，

message CA R as a symbol with respect to some new frame and what does that do ah it says apply foo which is a procedure so just by the standard environment model rules we drop a new frame scoped by the same frame as the procedure is and that's important because this frame III now points into e1 inside that frame. we bind the parameter msg to the value passed in which was car and relative to that frame we evaluate the body of this procedure represented by foo that is your recall is just a big con that looks at the expression the MSG in particular.

以符号CA R作为消息，相对于某个新框架，那会做什么呢？它说应用foo，它是一个过程，所以按照标准环境模型规则，我们创建一个由该过程所在的同一框架作用域的新框架，这很重要，因为这个框架III现在指向e1内部。在该框架中，我们将参数msg绑定到传入的值，即car，然后相对于该框架求值由foo表示的过程体，你记得那只是一个大的cond，它检查表达式，特别是MSG。

At the expression "the MSG" in particular, to see what symbol it is in this case, it says return the value of X with respect to this frame, and what's that? Ah, that's just one. So I'm set, I return out the value one, exactly as I wanted.

在表达式“the MSG”中，特别是要查看它是什么符号，在这种情况下，它说返回相对于此框架的X的值，那是什么？啊，那只是1。所以我完成了，我返回值1，正如我想要的那样。

So what does all this say, aside from showing that our contract holds? What we glue together with cons, we can get back a part using car, and obviously could have the same way. Besides showing that we've also now seen this common pattern that we can create a data structure, a data object, represented as a procedure.

那么这一切说明了什么，除了表明我们的契约成立？我们用cons粘合在一起的东西，我们可以用car取回一部分，显然也可以用同样的方式。除了表明这一点，我们还看到了这个常见模式，即我们可以创建一个数据结构，一个数据对象，表示为过程。

Object represented as a procedure. The procedure has some local state captured in a frame that's accessible only by that procedure, and it has the ability to accept messages and, based on those messages, return information from the local state. So let's see how to build on that idea.

对象表示为过程。该过程具有捕获在框架中的一些局部状态，该框架只能由该过程访问，并且它能够接受消息，并根据这些消息从局部状态返回信息。所以让我们看看如何在此基础上构建。

Okay, so we've seen how to create a data structure as a procedure that has some local state in it. In this case, what we saw was that the procedure could accept messages and return values—values that represented either the value of the state or something that we could potentially.

好的，我们已经看到了如何创建一个作为过程的数据结构，其中包含一些局部状态。在这种情况下，我们看到的是该过程可以接受消息并返回值——这些值表示状态的值或我们可以潜在计算的东西。

something that we could potentially compute off of the state now if we're going to use this ID of message-passing procedures to represent information we also need to have ways of changing the value of the state captured by that procedure in our pair example here's how we do it let's add two more messages or two more ways of dealing with messages to our constructor cons one for dealing with mutating the car one for dealing with mutating the cooter and notice in this case it's a little different if a cost per one of these procedures constructed

我们可以从状态中潜在计算的东西。现在，如果我们要使用这种消息传递过程的想法来表示信息，我们还需要有方法来改变该过程捕获的状态值。在我们的对示例中，这是如何做到的：让我们向构造函数cons添加两个更多的消息，或者两种处理消息的方式，一个用于处理修改car，一个用于处理修改cdr。注意在这种情况下有点不同，如果由cons构造的其中一个过程

### 7. Message Passing for Mutable Data and Generalization (用于可变数据和泛化的消息传递)

Per one of these procedures constructed by cons, we get the message set car bang. We're going to return a procedure that then says give me the new value for car and all make the change to change my old value of car, which remember was X, to be that new value, and similarly for set cooter.

由cons构造的其中一个过程，我们得到消息set car bang。我们将返回一个过程，然后说给我car的新值，我将进行更改，将我的旧car值（记得是X）改为那个新值，同样对于set cdr。

So now a little bit different behavior here: a message gets us back a procedure rather than just a numeric value. As a consequence, the procedures set car bang and set cooter bang have to have a slightly different form.

所以现在这里的行为有点不同：消息让我们得到一个过程，而不仅仅是一个数值。因此，过程set car bang和set cdr bang必须具有稍微不同的形式。

to take in a pair represented by one of these procedures and a new value but now they send the pair that procedure the message set car bang it gives us back a procedure and we then apply that to the new value hence this rather unusual form

接收一个由这些过程之一表示的序对和一个新值，但现在它们向该序对过程发送消息 set car bang，它返回给我们一个过程，然后我们将该过程应用于新值，因此出现了这种相当不寻常的形式。

so let's see how this works here's a definition of Bar we're going to define bar to be the concept three four and here's the global environment in which we're going to do that and what happens when we do this well just like we saw before applying cons will create one of these structures a procedure that takes

让我们看看这是如何工作的。这里有一个 bar 的定义，我们将定义 bar 为概念三和四，这里是我们将进行此操作的全局环境。当我们这样做时会发生什么？就像我们之前看到的，应用 cons 将创建这些结构之一，一个接受消息作为参数的过程。

These structures a procedure that takes in a message as parameter and has a body that does things based on that message. And it contains within it a local frame in which X is bound to three and Y is bound to four. And then of course bar is defined to be that value, so it points to the procedure from the global environment.

这些结构是一个过程，它接受消息作为参数，并且有一个基于该消息执行操作的主体。它包含一个局部框架，其中 X 绑定到三，Y 绑定到四。然后当然 bar 被定义为该值，因此它从全局环境指向该过程。

This structure is just like what we built before—there's one of our message passing objects. So now let's mutate it: let's change the car part of bar to be zero. And as we saw, evaluating this expression set car bar bar that to...

这个结构就像我们之前构建的一样——有一个我们的消息传递对象。现在让我们修改它：让我们将 bar 的 car 部分改为零。正如我们所见，求值这个表达式 set car bar bar 到……

This expression sets car bar bar that to zero in the global environment. It comes down to passing to bar the message set car bang and applying whatever we get from that to the value zero in some frame. This just comes from the code that we had on the previous slide.

这个表达式在全局环境中将 car bar bar 设置为零。它归结为向 bar 传递消息 set car bang，并将我们从该消息得到的任何内容应用于某个框架中的值零。这只是来自我们上一张幻灯片上的代码。

What we want to see is how evaluating this expression causes the right thing to happen. So we need to evaluate that expression, which means we first have to get the value of the sub expression open paren by our quote set car bang close print oh. That's okay, what's the value of bar? It's up there in the global environment.

我们想要看到的是求值这个表达式如何导致正确的事情发生。所以我们需要求值那个表达式，这意味着我们首先必须得到子表达式 open paren by our quote set car bang close print oh 的值。那没关系，bar 的值是什么？它在全局环境中。

up there in the global environment i trace it up and i find it and i'm going to apply that to the symbol set car bank so that drops a frame who scoped by the same place as the environment pointer part of the procedure it's so notice east six points into e4 inside of that frame we bind msg to be the symbol set car bang as we'd expect and relative to that frame or that environment we evaluate the body of car which is a big long conned expression and what that is going to do as we've seen is give us back an expression lambda of new car set

在全局环境中，我追踪它并找到它，我将把它应用于符号 set car bank，因此它丢弃了一个框架，该框架由过程的环境指针部分所在的同一位置限定作用域。所以注意 e6 指向 e4，在该框架内我们将 msg 绑定到符号 set car bang，正如我们所期望的，相对于该框架或该环境，我们求值 car 的主体，这是一个大的连接表达式，正如我们所见，它将返回给我们一个表达式 lambda of new car set。

back an expression lambda of new car set bang x to be new car. bang x to be new car. bang x to be new car. now here comes a critical point remember. now here comes a critical point remember. now here comes a critical point remember.

返回一个表达式 lambda of new car set bang x to be new car。bang x to be new car。bang x to be new car。现在关键点来了，记住。现在关键点来了，记住。现在关键点来了，记住。

we're evaluating the body of bar with respect to e6 which got us down to saying gee given that the message was set car bang evaluate this expression. open paren lambda a bunch of stuff with respect to e6. what does evaluating allow them to do it creates a procedure object but the crucial thing is what's the environment pointer part of that object ah it points to e6 because that's where I was creating it so I create this procedure object one parameter new car in a body.

我们相对于 e6 求值 bar 的主体，这使我们得出结论：鉴于消息是 set car bang，求值这个表达式。open paren lambda 一堆东西相对于 e6。求值 lambda 会做什么？它创建一个过程对象，但关键的是该对象的环境指针部分是什么？啊，它指向 e6，因为那是我创建它的地方，所以我创建了这个过程对象，一个参数 new car 和一个主体。

object one parameter new car in a body that's going to do the right thing but with the environment pointer part pointing into e6 that means that this procedure has access to e6 and therefore e 4 and therefore GE and this procedure is literally the value returned by evaluating open frame bar of quote set car Bank close paren and of course this is exactly what I want because now what do I do

一个参数 new car 和一个主体，它将做正确的事情，但环境指针部分指向 e6，这意味着这个过程可以访问 e6，因此可以访问 e4，因此可以访问 GE，这个过程字面上是求值 open frame bar of quote set car Bank close paren 返回的值，当然这正是我想要的，因为现在我该做什么？

I'm evaluating remember that expression up at the top so I'm going to apply that procedure or that value to the argument zero and what does that say to do just

记住我在求值顶部的那个表达式，所以我要将该过程或该值应用于参数零，那会说什么呢？只是……

zero and what does that say to do just substitution model I drop a frame with the parameter new car that is the parameter this procedure bound to the argument zero and notice this frame points to the same frame as the procedure object did so II seven is scoped by e six which is called by e 4 which is scoped by the global environment I have a nice chain of frames here relative to e 7 I evaluate the body of this procedure which I just made and that says do a set bang of X to new car with respect to the frame eise evan so now we evaluate that set bang x

零，那会说什么呢？只是替换模型，我丢弃一个框架，参数 new car 是这个过程绑定到参数零的参数，注意这个框架指向与过程对象相同的框架，所以 e7 由 e6 限定作用域，e6 由 e4 调用，e4 由全局环境限定作用域，我这里有一个很好的框架链，相对于 e7，我求值我刚创建的这个过程的主体，它说对 X 进行 set bang 到 new car，相对于框架 e7，所以现在我们求值那个 set bang x。

evan so now we evaluate that set bang x to new car expression with respect to e7 and here the rules say g find the binding for x ah start an e7 trace up three six before there it is find the binding for new car starting in e7 it's zero so go up to that place where X was bound and change it removing the old value 3 and replacing it by zero in the appropriate frame

相对于 e7 求值那个 set bang x 到 new car 表达式，这里的规则说：找到 x 的绑定，从 e7 开始追踪到 e6，在那里找到它，找到 new car 的绑定，从 e7 开始是零，所以去那个 x 被绑定的地方改变它，移除旧值 3 并用零替换它，在适当的框架中。

and the key thing to notice if we step away from all these details remember that little squiggly structure around that object that object bar which was a procedure that took messages and

关键要注意的是，如果我们退一步看所有这些细节，记住那个对象周围的微小弯曲结构，那个对象 bar 是一个接受消息并具有一些内部状态的过程。

was a procedure that took messages and had some internal state. Notice what the state looks like now. Now I have the first part X, which is the car part as 0, and the second part Y, which is the cooter part as 4.

是一个接受消息并具有一些内部状态的过程。注意现在状态看起来如何。现在我有第一部分 X，即 car 部分为 0，第二部分 Y，即 cdr 部分为 4。

And so we see with this idea of a procedure capturing local state, not only can it return information about state, but if we send it a message, it can give us back a procedure that causes changes in that state, allowing us to mutate our pairs.

因此我们看到，通过过程捕获局部状态的想法，它不仅能够返回关于状态的信息，而且如果我们向它发送消息，它可以返回给我们一个导致状态变化的过程，使我们能够修改我们的序对。

So this is certainly very different from things we've seen before. Now we have data structures data.

所以这当然与我们之前看到的非常不同。现在我们有了数据结构，数据。

before now we have data structures data objects that are actually themselves objects that are actually themselves procedures a con spare is a procedure car is something that operates on one of those procedures but as we've seen Kant's car encoder we've just built satisfied the data abstraction and therefore behave appropriately the key thing is that we've now built this new idea into our language a data structure is now a procedure it takes a message as input and in this case either returns a data value or a procedure to handle a data value in order to make changes this turns out to be a very handy idea

之前，现在我们有了数据结构，数据对象，它们实际上本身就是过程。一个 cons 序对是一个过程，car 是对这些过程之一进行操作的东西，但正如我们所见，我们刚刚构建的 cons、car 和 cdr 满足了数据抽象，因此表现适当。关键是我们现在已经在我们的语言中构建了这个新想法：数据结构现在是一个过程，它接受消息作为输入，在这种情况下要么返回数据值，要么返回一个过程来处理数据值以进行更改。事实证明这是一个非常方便的想法。

turns out to be a very handy idea so let's generalize it in particular let's create both private state variables as we've done before but also private procedures that belong to each instance of the data abstraction.

事实证明这是一个非常方便的想法，所以让我们推广它，特别是让我们创建私有状态变量，就像我们之前做的那样，同时也创建属于数据抽象每个实例的私有过程。

so notice the difference here now I create internal procedures change car and change coder things that are going to do the right thing but inside of my actual object I not only create those procedures I use them.

所以请注意这里的区别：现在我创建了内部过程 change car 和 change cdr，它们会做正确的事情，但在我的实际对象内部，我不仅创建了这些过程，而且使用了它们。

this has a very nice effect if you look down at the bottom it says when I want to actually do something I don't

这有一个非常好的效果：如果你看底部，它说当我想实际做某事时，我不必

want to actually do something I don't have to remember what kind of thing is returned and what to do with it the use of these procedures is exactly the same or set a little better it makes selectors and mutators perform in a uniform way before we had to remember whether the object returned a value or a procedure in order to complete the process

不必记住返回的是什么类型的东西以及如何处理它。这些过程的使用是完全相同的，或者更好一点，它使选择器和修改器以统一的方式执行。之前我们必须记住对象返回的是值还是过程，以便完成过程。

here the selectors and mutators just send a message to the object and within the implementation of the object we take care of the necessary work to either apply a procedure or just extract the value so the internal procedures here

在这里，选择器和修改器只是向对象发送消息，而在对象的实现内部，我们处理必要的工作，要么应用一个过程，要么直接提取值。所以这里的内部过程

value so the internal procedures here make sense and notice by the way by defining them within the context of the Khans remember that these definitions will create procedures that are scoped within the frame created by the calling of the Khans or set a little bit better it means these procedures belong only to this instance of cons.

所以这里的内部过程是有意义的。顺便注意，通过在 Khans 的上下文中定义它们，记住这些定义将创建过程，这些过程的作用域限定在调用 Khans 时创建的框架内，或者更好一点，这意味着这些过程只属于这个 cons 实例。

what else do we have though well by making this uniform application of mutaters and selectors we've introduced one more thing into our system in particular we need our selectors and mutators to deal with different numbers.

我们还有什么呢？通过使修改器和选择器的应用统一，我们在系统中引入了另一件事，特别是我们需要选择器和修改器处理不同数量的参数。

mutators to deal with different numbers of arguments and yet we want our data abstraction to be a single procedure so we need a way of letting a lambda object specify that it wants to take an arbitrary number of arguments and that's that funny notation of lambda of open paren MSG dot Arg s close paren and on the next slide we're going to come back to that.

修改器处理不同数量的参数，然而我们希望我们的数据抽象是一个单一的过程，所以我们需要一种方法让 lambda 对象指定它想要接受任意数量的参数，这就是那个有趣的记号：lambda 开括号 MSG 点 Arg s 闭括号，在下一张幻灯片我们将回到这一点。

up until now every procedure you've written has required that you specify names of all the input parameters it's going to take and as you've seen if you call the argument with the wrong number of input

到目前为止，你写的每个过程都要求你指定它将接受的所有输入参数的名称，正如你所看到的，如果你用错误数量的输入调用参数，

As you've seen, if you call the argument with the wrong number of input, errors may occur or the function may behave unexpectedly. Properly specifying and handling the number of inputs is crucial for ensuring the function works as intended and avoids runtime issues.

正如你所看到的，如果你用错误数量的输入调用参数，可能会发生错误或函数行为异常。正确指定和处理输入数量对于确保函数按预期工作并避免运行时问题至关重要。

argument with the wrong number of input parameters it causes problems we'd like to have a mechanism that lets a procedure take an arbitrary number of arguments and in some sense you've already seen that with some of the built-ins like plus and times we'd like to have something say add that can take two numbers and do the right thing or four numbers and take the right do the right thing or arbitrary numbers of numbers and do the right thing.

用错误数量的输入参数调用参数会导致问题。我们希望有一种机制让过程接受任意数量的参数，在某种意义上你已经看到了一些内置函数如 plus 和 times，我们希望有类似 add 的东西，它可以接受两个数字并做正确的事情，或者四个数字并做正确的事情，或者任意数量的数字并做正确的事情。

so scheme provides a way of doing this and let's look at the definition let's define add of XY dot rest to be a bunch

所以 scheme 提供了一种方法，让我们看看定义：让我们定义 add 的 X Y 点 rest 为一堆

define add of XY dot rest to be a bunch of things here the syntax is an argument X and argument Y and then a dot and then the argument rest and the behavior is as follows it says when we apply add to a set of arguments the value of the first argument will be bound to X the value of the second argument will be bound to Y and the values of any remaining arguments will be bound as a list to the argument rest.

定义 add 的 X Y 点 rest 为一堆东西，这里的语法是参数 X 和参数 Y，然后是一个点，然后是参数 rest，行为如下：它说当我们对一组参数应用 add 时，第一个参数的值将绑定到 X，第二个参数的值将绑定到 Y，任何剩余参数的值将作为列表绑定到参数 rest。

thus if we add one and two X is bound to one Y is bound to two and rest is bounded just an empty list if we try and add just one we'll get an error

因此，如果我们 add 1 和 2，X 绑定到 1，Y 绑定到 2，rest 绑定到一个空列表。如果我们尝试只 add 1，我们会得到一个错误，

try and add just one we'll get an error because the first two arguments are required I have to have something for both x and y but if we add one two three X will be bound to one y to two and rest will be bound to the list three and if we add one two three four five you get the idea rest in this case we'll be bound to the list three four five thus in this particular notation all of the parameters prior to the dot require a specific value the parameter after the dot will be bound to the list of the values of all the remaining arguments passed in so if

尝试只 add 1，我们会得到一个错误，因为前两个参数是必需的，我必须为 x 和 y 都有东西。但如果我们 add 1 2 3，X 将绑定到 1，y 绑定到 2，rest 将绑定到列表 (3)。如果我们 add 1 2 3 4 5，你明白了，rest 在这种情况下将绑定到列表 (3 4 5)。因此在这种特殊记号中，点之前的所有参数都需要一个特定的值，点之后的参数将绑定到传入的所有剩余参数值的列表。所以如果

### 8. Object-Oriented Style, Classes, and Instances (面向对象风格、类和实例)

the remaining arguments passed in so if we come back to our example we see that if we just take the car of a pair then MSG will be bound to the symbol car and rest will be the empty list on the other hand if we want to set car the pair then MSG will be the symbol set car and args will be a list of one value the new value to be used within the procedure that defines the Const notice what happens if we're going to do a set car we apply the procedure change car to the first argument in the list arts in other words it'll get out the right new value

传入的剩余参数，所以如果我们回到我们的例子，我们看到如果我们只取一个 pair 的 car，那么 MSG 将绑定到符号 car，rest 将是空列表。另一方面，如果我们想 set car 这个 pair，那么 MSG 将是符号 set car，args 将是一个包含一个值的列表，即新值，在定义 Const 的过程中使用。注意如果我们打算做 set car，我们将过程 change car 应用于列表 args 中的第一个参数，换句话说，它将取出正确的新值

Words it'll get out the right new value and cause the appropriate change it will mutate the binding of X to be that new value. And thus we can apply these internal procedures to the right values to cause the right changes to happen.

换句话说，它将取出正确的新值并引起适当的改变；它将改变 X 的绑定为该新值。因此我们可以将这些内部过程应用于正确的值，以引起正确的改变。

Since we've been throwing a lot of details at you, let's step back from this. What we've now seen is a method—using a particular example but a method—for creating a procedure that captures local state. This procedure takes in a message, and based on that message and possibly some other arguments, it either returns...

既然我们已经向你抛出了很多细节，让我们退一步。我们现在看到的是一种方法——使用一个特定的例子，但是一种方法——用于创建一个捕获局部状态的过程。这个过程接收一个消息，基于该消息以及可能的一些其他参数，它要么返回...

some other arguments it either returns values based on the local state or it causes changes in the values of those local state variables. This new method, this idea of a message passing procedure, lets us capture information about a data structure inside a procedure itself. So what does this say? Well, what we've done is introduced the basic idea of a new style for approaching computational systems.

一些其他参数，它要么基于局部状态返回值，要么引起这些局部状态变量值的变化。这种新方法，即消息传递过程的思想，让我们能够将关于数据结构的信息捕获在过程本身内部。那么这意味着什么呢？我们引入了一种新的风格来处理计算系统。

Our traditional style is procedural programming: we organize the system around the procedures that operate on the data. The key here is that we isolate the data in standard list...

我们的传统风格是过程式编程：我们围绕操作数据的过程来组织系统。这里的关键是我们将数据隔离在标准的列表...

we isolate the data in standard list like structures with tags then focus on thinking about what methods or procedures we want to use to manipulate the values within those structures here we've shown the basis for a new approach which is oriented around the data objects themselves note what we did with our example of a pair we focused on capturing the information within a structure where the operations to manipulate the data values were associated directly with that structure more importantly the basic conceptual unit for thinking about a system is the

我们将数据隔离在带有标签的标准列表结构中，然后专注于思考我们想要使用哪些方法或过程来操作这些结构中的值。在这里，我们展示了一种新方法的基础，这种方法以数据对象本身为导向。注意我们在对（pair）的例子中所做的：我们专注于将信息捕获在一个结构中，其中操作数据值的程序直接与该结构相关联。更重要的是，思考系统的基本概念单元是

unit for thinking about a system is the object itself what things should an object do ie what messages should it handle how do we want to capture those methods internally within the object now which approach is better and the answer is it really depends on the problem domain procedural methods are very good when we're dealing with things like numerical operations or when we're dealing with systems are very good for things like simulation or for systems with large numbers of

思考系统的基本概念单元是对象本身。一个对象应该做什么事情，即它应该处理哪些消息？我们希望在对象内部如何捕获这些方法？现在，哪种方法更好？答案是，这确实取决于问题领域。过程式方法在处理数值运算或处理系统时非常好，而面向对象方法非常适合模拟或处理大量对象的系统，

for systems with large numbers of objects where the objects themselves are characterized by small amount of state information and the computation basically involves interaction between the objects causing that state to change.

对于具有大量对象的系统，这些对象本身以少量状态信息为特征，而计算基本上涉及对象之间的交互，导致状态发生变化。

we have seen lots of examples of procedural or functional programming in the first part of the course now we're going to spend some time exploring a second style which is object-oriented programming today we'll explore a relatively simple object-oriented system implemented using message passing objects very much like our message

在课程的第一部分，我们已经看到了许多过程式或函数式编程的例子。现在我们将花一些时间探索第二种风格，即面向对象编程。今天我们将探索一个相对简单的面向对象系统，使用消息传递对象实现，非常类似于我们的消息

objects very much like our message. Passing class example in a later lecture. We'll explore a more sophisticated object-oriented system and scheme to discuss object-oriented programming. We need some terminology in an auto or object-oriented system. We will talk about a class and an instance. A class describes a set of objects with common behavior. For example, constant our previous example was a class by convention. To use a class, we will have a maker procedure that creates instances of this class. An instance will be a particular and specific object generated.

对象非常类似于我们的消息传递类示例。在后面的讲座中，我们将探索一个更复杂的面向对象系统，并在Scheme中讨论面向对象编程。为了讨论面向对象编程，我们需要一些术语。在面向对象系统中，我们将谈论类和实例。类描述一组具有共同行为的对象。例如，我们之前的例子中的cons是一个类，按照惯例。要使用一个类，我们将有一个制造过程来创建该类的实例。实例将是由类生成的特定且具体的对象。

A particular and specific object generated by a class—for example, foo or bar in our earlier examples—were instances of the class. An instance takes messages in the manner defined by the maker procedure and uses them to manipulate the particular values of the instance.

由类生成的特定且具体的对象——例如，我们之前例子中的foo或bar——是类的实例。实例以制造过程定义的方式接收消息，并使用它们来操作实例的特定值。

So we expect, as a consequence, to have lots of instances of each particular class in our system. Here is a good way to conceptualize these ideas and, in particular, the differences between them. First of all, associated with the class, we can draw what we call a class diagram.

因此，我们期望系统中每个特定类都有许多实例。这里有一个很好的方式来概念化这些想法，特别是它们之间的差异。首先，与类相关联，我们可以绘制所谓的类图。

we can draw what we call a class diagram this would contain information such as the name of the class for example a pair information about the private state that belongs to instances of that class in this case x and y as well as what messages public messages in particular that this class recognizes here would be things like car code or pair question mark set car banks at cooter Bank and note that these public messages define the interface to the class objects so this class diagram captures the information about a class its name the state information is captured within it

我们可以绘制所谓的类图，其中包含诸如类名（例如pair）的信息，关于属于该类实例的私有状态的信息（在这种情况下是x和y），以及该类识别的公共消息，特别是诸如car、cdr或pair?、set-car!、set-cdr!等。注意，这些公共消息定义了类对象的接口。因此，这个类图捕获了关于类的信息：它的名称、其中捕获的状态信息，

State information is captured within it, and the message is that it accepts from people outside of it. Thus, in our example from before, Kant's defines a class defining context Y to be that lambda whatever is our way of constructing elements from this class.

状态信息被捕获在其中，以及它从外部接受的消息。因此，在我们之前的例子中，cons定义了一个类，定义上下文Y为那个lambda，无论它是什么，都是我们从该类构造元素的方式。

That leads exactly to the idea of an instance when we use the maker associated with this class. In our case, it was cause we create particular instances of this class, we complete examples from this class. So we'll represent this by an instance diagram, and within that diagram will have.

当我们使用与该类关联的制造过程时，这直接导致了实例的概念。在我们的例子中，它是cons，我们创建该类的特定实例，我们完成该类的示例。因此，我们将用实例图来表示这一点，在该图中将有

Within that diagram will have information, the type, which is the type of the class, of course, as well as specific values for the internal state, and note that these could themselves be other instances of classes.

在该图中将有信息：类型，当然是类的类型，以及内部状态的具体值，注意这些值本身可以是其他类的实例。

So if we define the example expression shown in our instance diagram, we create two instances of the class pair, both created by the maker procedure console. Within each, we have bindings for, or specific values for, the internal state associated with each instance. Notice how these bindings can be simple values like numbers, or pointers to other instances.

因此，如果我们定义实例图中显示的示例表达式，我们创建了类pair的两个实例，两者都由制造过程cons创建。在每个实例中，我们有与每个实例关联的内部状态的绑定或特定值。注意这些绑定可以是简单的值，如数字，或指向其他实例的指针。

numbers or pointers to other instances of classes, so we see that a class defines a set of objects, and an instance is a particular version of an object from some class. So how do we use the ideas of classes and instances to start designing a system?

数字或指向其他类实例的指针，因此我们看到类定义了一组对象，而实例是某个类对象的特定版本。那么我们如何使用类和实例的概念来开始设计一个系统呢？

Let's suppose, as an example, that we want to build a simulator for an amalgamated space wars game, stealing ideas from any different functional worlds. It would have ships that could fly through space, land on space stations, shoot other ships, and so on. We can start by asking ourselves: what kinds of objects do we need?

让我们假设，作为一个例子，我们想要构建一个模拟器，用于一个合并的太空战争游戏，从不同的功能世界借鉴想法。它将有飞船可以在太空中飞行，降落在空间站上，射击其他飞船等等。我们可以从问自己开始：我们需要什么样的对象？

What kinds of objects do we need that will tell us what kinds of class we need? And what state information is needed for a class? And what interfaces between classes are needed? It might say, for example, that we want some ships, since ships will need to move. This helps us decide what kind of state a ship will need.

我们需要什么样的对象，这将告诉我们我们需要什么样的类？一个类需要什么状态信息？类之间需要什么接口？例如，可能会说，我们想要一些飞船，因为飞船需要移动。这帮助我们决定飞船需要什么样的状态。

Thus, we begin thinking about the system in terms of what kinds of objects and what information associated with those objects we want. We can then extend this to start thinking about particular instances of objects—how many, and what state.

因此，我们开始从需要什么样的对象以及与该对象关联的什么信息的角度来思考系统。然后我们可以扩展这一点，开始思考特定的对象实例——有多少，以及什么状态。

instances of objects how many what state for each and so on so let's see how the idea of a class and instances of a class can be used to design an object-oriented system. We will use our space war simulator to explore the use of classes and instances of classes to build object-oriented systems.

对象实例有多少，每个实例的状态是什么，等等。因此，让我们看看如何使用类和类实例的概念来设计一个面向对象的系统。我们将使用我们的太空战争模拟器来探索使用类和类实例来构建面向对象系统。

The first class of objects in my system will be ships, so here is a procedure for making instances of the class of ships. This maker procedure defines the actual class. Given the idea of a ship, we can turn to the question of what behavior we want for instances of that class. Clearly a

我的系统中的第一类对象将是舰船，因此这里有一个用于创建舰船类实例的过程。这个制造过程定义了实际的类。有了舰船的概念，我们就可以转向这样一个问题：我们希望该类的实例具有什么样的行为。显然，一个

for instances of that class clearly a ship needs to be able to move note that this then tells us that we will need some information about where the ship currently lies and how it is moving as part of the class definition.

对于该类的实例，显然一艘舰船需要能够移动。注意，这告诉我们，作为类定义的一部分，我们将需要一些关于舰船当前位置以及它如何移动的信息。

in this case we choose to pass that information in when we actually construct the instance so this tells us we will need position velocity and maybe some other things as inputs to the class constructor.

在这种情况下，我们选择在实际构造实例时传入这些信息，所以这告诉我们，我们将需要位置、速度以及可能其他一些东西作为类构造器的输入。

actually we are getting our local state variables in a sneaky way here we know that in order to move we need to have that kind of information as

实际上，我们在这里以一种隐蔽的方式获得了我们的局部状态变量。我们知道，为了移动，我们需要将这类信息作为

need to have that kind of information as part of the class but in fact we could have created a constructor with no parameters and simply have had within it a let Clause that contained initial default values for the position and velocity.

需要将这类信息作为类的一部分，但事实上，我们可以创建一个没有参数的构造器，只需在其中包含一个 let 子句，为位置和速度提供初始默认值。

notice how thinking about what we want our objects to do helps us to decide what information should be captured as local state and what information should be passed in when we create instances of this class

注意，思考我们希望对象做什么，如何帮助我们决定哪些信息应该被捕获为局部状态，哪些信息应该在创建该类的实例时传入。

and what about the class itself when we use this maker procedure it will return an instance of a ship

那么类本身呢？当我们使用这个制造过程时，它将返回一个舰船的实例。

它将会返回一个ship的实例，这个实例将由一个消息传递lambda来表示。注意它的形式：它接受一个消息作为输入，并且要么返回关于ship状态的信息，要么导致其中一个内部程序被执行。

它将会返回一个ship的实例，这个实例将由一个消息传递lambda来表示。注意它的形式：它接受一个消息作为输入，并且要么返回关于ship状态的信息，要么导致其中一个内部程序被执行。

这看起来很像我们之前为cons spare所使用的广义形式。类似地，我们将会有用于操作数据值的内部程序，这与我们的cons示例非常相似。

这看起来很像我们之前为cons spare所使用的广义形式。类似地，我们将会有用于操作数据值的内部程序，这与我们的cons示例非常相似。

唯一需要注意的另一件事是，我们的消息传递程序的最后一个子句是一个保底子句，它表示：如果你给我一个...

唯一需要注意的另一件事是，我们的消息传递程序的最后一个子句是一个保底子句，它表示：如果你给我一个...

bailout clause it says if you give me a message we don't recognize I'll let you know so that you don't try to do something you can thus here's the definition of a class and make a procedure that creates ships so let's gather that together in our class diagram.

保底子句，它表示：如果你给我一个我们不认识的消息，我会让你知道，这样你就不会尝试做你无法做到的事情。因此，这里是类的定义和一个创建舰船的制造过程。让我们把它汇总到我们的类图中。

We have now a class diagram of a ship and it has a set of variables position velocity number of torpedoes as we saw and it has messages for methods to manipulate those variables and as we said earlier those messages define the interface to instances from this class so now let's make some instances let's.

我们现在有了一个舰船的类图，它有一组变量：位置、速度、鱼雷数量，正如我们所看到的，它还有用于操作这些变量的消息（方法），正如我们之前所说，这些消息定义了来自该类的实例的接口。那么现在让我们创建一些实例。

所以现在让我们创建一些实例。让我们把企业号定义为一艘船的实例。注意，我们为它指定了特定的位置、特定的速度和一定数量的鱼雷。

所以现在让我们创建一些实例。让我们把企业号定义为一艘船的实例。注意，我们为它指定了特定的位置、特定的速度和一定数量的鱼雷。

类似地，我们可以把战鸟号定义为另一艘船。注意我们如何为该实例创建初始位置、速度和防御数量。当然，我们在这里使用了一些向量的抽象，我们并不真正关心它，它只是为我们生成向量，并让我们大概有办法取回这些组成部分。关键要注意的是这一点。

类似地，我们可以把战鸟号定义为另一艘船。注意我们如何为该实例创建初始位置、速度和防御数量。当然，我们在这里使用了一些向量的抽象，我们并不真正关心它，它只是为我们生成向量，并让我们大概有办法取回这些组成部分。关键要注意的是这一点。

Pieces back out key thing to notice is using that maker procedure for a class. I've made two different instances of that class, they have their own state information captured within them. They have their own procedures for manipulating that state information, and the interfaces to them are defined as the set of interfaces from the class itself.

取回这些组成部分。关键要注意的是，使用那个类的制造过程，我创建了该类的两个不同实例，它们各自拥有自己的状态信息，它们拥有自己的操作这些状态信息的程序，并且对它们的接口被定义为来自类本身的接口集合。

### 9. Building and Extending an Object-Oriented System (构建和扩展面向对象系统)

Each of these objects will accept the same set of messages and cause their own internal state to be changing. So let's check this out, let's use our environment diagram to see how our little system evolves.

这些对象中的每一个都将接受相同的消息集合并导致它们自己的内部状态发生变化。那么让我们来检查一下，让我们使用环境图来看看我们的小系统是如何演化的。

little system evolves and I want to stress we want to both watch the idea of instances of classes and classes themselves as a general notion as well as looking at the particular implementation we're using here so let's look at what happens if we evaluate these three expressions in order to see how our classes create instances and how those instances keep track of state information that can be updated as we carry our simulation forward first of all we're going to use our make ship or maker of instances of a class so we use make ship and evaluating that particular

小系统演化，我想强调，我们既要关注类的实例和类本身作为一般概念，也要关注我们在这里使用的具体实现。那么让我们看看，如果我们按顺序求值这三个表达式，看看我们的类如何创建实例，以及这些实例如何跟踪状态信息，这些信息可以在我们进行模拟时更新。首先，我们将使用我们的 make ship 或类的实例制造过程，所以我们使用 make ship，并且求值那个特定的

Make ship and evaluating that particular expression, we know does the following: make ship is a procedure, so applying it creates a frame in which the formal parameters position, velocity, and number of torpedoes are bound to the values of the arguments passed in—in this case, a couple of vectors and a number. This is just standard application of procedures.

Make ship 并求值那个特定的表达式，我们知道会做以下事情：make ship 是一个过程，因此应用它会创建一个框架，其中形式参数 position、velocity 和 number of torpedoes 被绑定到传入参数的值——在这种情况下，是一对向量和一个数字。这只是标准的过程应用。

Having created that frame, we then evaluate the body of the procedure with respect to that frame, and notice what that does. There are a couple of internal definitions: we define move to be a

创建了那个框架之后，我们然后相对于那个框架求值过程体，注意那会做什么。有几个内部定义：我们将 move 定义为一个

Definitions we define move to be a procedure, and the key thing to note is that that procedure has as its environment pointer this frame, because that's where we're evaluating with respect to. The smoove will be a name for an internal procedure which will have access to things like position and velocity, because this environment pointer points to it.

定义，我们将 move 定义为一个过程，关键要注意的是，该过程的环境指针指向这个框架，因为我们是相对于它进行求值的。smoove 将是内部过程的名字，它将能够访问 position 和 velocity 等，因为这个环境指针指向它。

Thus we see that those two internal defines create bindings for other names, move and fire torque, within that frame that happened to point in this case to two local procedures, and thus this overall frame contains the

因此我们看到，这两个内部定义在那个框架内为其他名字创建了绑定，move 和 fire torque，它们恰好指向两个局部过程，因此这个整体框架包含了

thus this overall frame contains the information about this instance of the class the state variables and the local methods that will be used to change those state variables

因此这个整体框架包含了关于该类实例的信息：状态变量和用于改变这些状态变量的局部方法。

having evaluated the local defines that is having created the local methods for this instance we then evaluate the rest of the body of this constructor make ship and that of course evaluates that last lambda creating of the procedure object whose environment pointer also points to this frame

在求值了局部定义之后，也就是说，在为这个实例创建了局部方法之后，我们然后求值这个构造器 make ship 的其余部分，当然，这会求值最后一个 lambda，创建一个过程对象，其环境指针也指向这个框架。

because we're evaluating the body there whose parameters the message whose

因为我们在那里求值过程体，其参数是 message，其

There whose parameters the message, whose body is going to be the thing that does the right stuff with the message, and a binding for enterprise in the global environment is created to that object. So this creates as before one of these nice procedure passing objects, it has local state including information about what procedures to use to cause that state to change.

其参数是 message，其过程体将是根据消息做正确事情的东西，并且在全局环境中为 enterprise 创建一个绑定指向该对象。因此，这像之前一样创建了一个漂亮的、传递消息的过程对象，它具有局部状态，包括关于使用哪些过程来改变该状态的信息。

Now let's ask this particular instance of a ship to move that says send the procedure representing the ship the message move, and we know from the code on the previous slide that reduces.

现在让我们要求这个特定的舰船实例移动，也就是说，向代表该舰船的过程发送消息 move，我们从上一张幻灯片的代码中知道这会归结为...

code on the previous slide that reduces to evaluating the actual procedure move with respect to this frame and what does that say it says apply that procedure there has no arguments here but we still create a frame we just don't bind anything in it and relative to that frame we evaluate the body of this internal move procedure and that says gee change the position and of course evaluating the body of this procedure causes us to mutate the current position to a new position by adding the vectors together and creating a new one so just like we saw on the console we now have

上一张幻灯片上的代码简化为：相对于该框架求值实际的 move 过程，这意味着什么？它说，在那里应用该过程，这里没有参数，但我们仍然创建一个框架，只是不在其中绑定任何东西，并且相对于该框架，我们求值这个内部 move 过程的主体，它说：改变位置。当然，求值该过程的主体导致我们将当前位置改变为一个新位置，通过将向量相加并创建一个新的向量。所以，就像我们在控制台上看到的那样，我们现在有了

Like we saw on the console, we now have changed the state, which means if we ask for the new position of enterprise, we will get this value of the vector out and return that is the appropriate thing. So what we see is our local instance of a ship now captures within it state information, and procedures to change that state information, and the actual object this instance is a procedure that takes messages and does the right thing.

就像我们在控制台上看到的那样，我们现在已经改变了状态，这意味着如果我们询问企业号的新位置，我们将得到这个向量值并返回，这是合适的。所以我们看到的是，我们飞船的局部实例现在在其内部捕获了状态信息，以及改变该状态信息的过程，而这个实例本身就是一个过程，它接收消息并做正确的事情。

One of our claims for object-oriented systems is that they enable relatively easy extensions to a system, so let's try.

我们对于面向对象系统的主张之一是，它们使得对系统的扩展相对容易，所以让我们尝试一下。

easy extensions to a system so let's try this out. What kinds of things could we add to our system? First, we can add new classes, for example a spacestation class, which should have a different behavior from ships. For example, Space Station's may not be able to move while ships can.

对系统的扩展相对容易，所以让我们尝试一下。我们可以向系统添加哪些类型的东西？首先，我们可以添加新的类，例如空间站类，它应该具有与飞船不同的行为。例如，空间站可能无法移动，而飞船可以。

We could add more than one additional class. Perhaps we also want torpedoes to help make the space Wars world entertaining. And we might want to add a display handler, something that draws the position of our objects on a screen. This might be implemented as a procedure since not everything has to be an object.

我们可以添加不止一个额外的类。也许我们还想要鱼雷来让太空战争世界更加有趣。我们可能还想添加一个显示处理器，它可以在屏幕上绘制我们对象的位置。这可能实现为一个过程，因为并非所有东西都必须是对象。

since not everything has to be an object in our system to add a display capability we will need to modify our classes so that every object can display itself on demand. With this framework for modifying our system, let's see how one goes about extending our object-oriented systems.

因为并非所有东西都必须是对象，在我们的系统中，要添加显示能力，我们需要修改我们的类，以便每个对象都能按需显示自身。有了这个修改系统的框架，让我们看看如何扩展我们的面向对象系统。

If we add Space Stations to our system, we will have a new class diagram. In addition to our earlier class, we now have a class for Space Stations with some state information and some methods for manipulating that information. Notice that as part of our design we also add

如果我们向系统添加空间站，我们将有一个新的类图。除了我们之前的类，我们现在有了一个空间站类，它有一些状态信息和一些用于操作该信息的方法。注意，作为我们设计的一部分，我们还添加了

that as part of our design we also add
another new thing to both this class andanother new thing to both this class and

作为我们设计的一部分，我们还添加了
另一个新东西到这两个类，以及另一个新东西到这两个类，以及

another new thing to both this class and
our original ship class a method forour original ship class a method for

另一个新东西到这两个类，以及
我们原始的飞船类，一个用于我们原始的飞船类，一个用于

our original ship class a method for
handling display now watch how we canhandling display now watch how we can

我们原始的飞船类，一个用于
处理显示的方法，现在观察我们如何处理显示的方法，现在观察我们如何

handling display now watch how we can
add new instances to our system and howadd new instances to our system and how

处理显示的方法，现在观察我们如何
向系统添加新实例，以及如何向系统添加新实例，以及如何

add new instances to our system and how
we can easily return to our originalwe can easily return to our original

向系统添加新实例，以及如何
轻松地回到我们原始的轻松地回到我们原始的

we can easily return to our original
design and modify it to add newdesign and modify it to add new

轻松地回到我们原始的
设计并修改它以添加新的设计并修改它以添加新的

design and modify it to add new
components and methods to start here iscomponents and methods to start here is

设计并修改它以添加新的
组件和方法，从这里开始是组件和方法，从这里开始是

components and methods to start here is
our maker procedure for the spaceour maker procedure for the space

组件和方法，从这里开始是
我们空间站类的制造过程，这里唯一的局部我们空间站类的制造过程，这里唯一的局部

our maker procedure for the space
station class here the only localstation class here the only local

空间站类的制造过程，这里唯一的局部
信息是位置，并且信息是位置，并且

station class here the only local
information is position and theinformation is position and the

信息是位置，并且
实例将识别两个方法实例将识别两个方法

information is position and the
instances will recognize two methodsinstances will recognize two methods

实例将识别两个方法
注意我们如何添加方法，注意我们如何添加方法，

instances will recognize two methods
notice how we can add methods thatnotice how we can add methods that

注意我们如何添加方法，
这些方法只是执行一个过程而不这些方法只是执行一个过程而不

notice how we can add methods that
simply execute a procedure withoutsimply execute a procedure without

这些方法只是执行一个过程而不
返回值，例如在显示返回值，例如在显示

simply execute a procedure without
returning a value such as in the displayreturning a value such as in the display

返回值，例如在显示
方法中，这里使用 draw 是为了图形化显示空间站的副作用，并且为了给我们的系统增添一些趣味，我们将让飞船互相射击。所以我们将添加一个新类：鱼雷。

Returning a value such as in the display method here, draw is used for the side effect of graphically displaying the station, and to add some spice to our system we will let ships shoot at each other. So we'll add a new class, a torpedo.

返回值，例如在显示方法中，这里使用 draw 是为了图形化显示空间站的副作用，并且为了给我们的系统增添一些趣味，我们将让飞船互相射击。所以我们将添加一个新类：鱼雷。

To add torpedoes, we again need to update our class diagram, and here it is. Notice that this class has a lot of information similar to that of ships, a point to which we will return later.

要添加鱼雷，我们再次需要更新我们的类图，这就是了。注意，这个类有很多与飞船相似的信息，这一点我们稍后会再讨论。

The top-level point to note is how our design is evolving: we started with a single class and have now added new classes as our desires for this system.

最顶层要注意的是我们的设计是如何演变的：我们从一个单一的类开始，现在根据我们对这个系统的需求添加了新的类。

Classes represent our desires for this system. Expand each class has a set of local state variables and methods that it is capable of handling. The other change to our class diagram is the addition of various new methods for existing and new classes.

类代表了我们对这个系统的需求。每个类都有一组局部状态变量和它能够处理的方法。我们类图的另一个变化是为现有类和新类添加了各种新方法。

For example, we also add a method explode to implement new behavior associated with torpedoes or the effect of torpedoes on ships. Again, note how our design is evolving: we can add new classes and we can extend existing classes by adding new methods, as our desired behaviors for the system demand them. Here is a corresponding marker for this evolution.

例如，我们还添加了一个 explode 方法来实现与鱼雷相关的新行为，或者鱼雷对飞船的影响。再次注意我们的设计是如何演变的：我们可以添加新的类，也可以通过添加新方法来扩展现有类，只要系统所需的行为需要它们。这里是这个演变的相应制造者。

Them here is a corresponding maker for torpedoes. It has a similar structure to what we are used to. Ultimately, we are making a message handling procedure with imbedded local state, local procedures, and public methods.

这里是鱼雷的相应制造者。它的结构与我们习惯的相似。最终，我们制作了一个消息处理过程，其中嵌入了局部状态、局部过程和公共方法。

Here, the explode procedure hints at some subtle behavior. When a torpedo explodes, it is destroyed. So on our simulation world, we may need to manage this, such as by a remove from universe procedure illustrated here.

在这里，explode 过程暗示了一些微妙的行为。当鱼雷爆炸时，它被摧毁。所以，在我们的模拟世界中，我们可能需要管理这一点，例如通过这里展示的 remove from universe 过程。

Indeed, a typical application of object-oriented systems is to create a simulation world and to run that simulation.

事实上，面向对象系统的一个典型应用是创建一个模拟世界并运行该模拟。

and to run that simulation some additional machinery will certainly be needed for example we may need a way to keep track of the instances in our world such as by using a global the universe list in addition there needs to be some controller or clock that invokes methods on instances in the world perhaps in a round robin fashion perhaps in a random fashion

并运行该模拟，当然需要一些额外的机制，例如，我们可能需要一种方法来跟踪我们世界中的实例，例如使用全局的 universe 列表。此外，还需要某种控制器或时钟来调用世界上实例的方法，也许是以轮询方式，也许是以随机方式。

here we have sketched the basic outlines of an object-oriented system and supporting mechanisms like a clock use your imagination and picture running the clock to generate awesome graphic

在此，我们已经勾勒了一个面向对象系统及其支持机制（如时钟）的基本轮廓。发挥你的想象力，设想运行这个时钟来生成令人惊叹的图形。

the clock to generate awesome graphic evolving images of spaceships firing torpedoes at each other in the shadow of a large space station let me remind you of what we've seen so far we are trying to organize a large system around a collection of objects an object can be thought of as a smart data structure a set of state variables that describe the object and an Associated set of methods for manipulating on state variables we expect our systems to have many different instances of the same kind of object for instance think of a bank

这个时钟生成令人惊叹的图形，即不断演化的太空飞船图像，它们在一个大型空间站的阴影下互相发射鱼雷。让我提醒你我们目前所见的内容：我们试图围绕一组对象来组织一个大型系统。一个对象可以被看作一个智能数据结构，即一组描述该对象的状态变量，以及一组用于操作这些状态变量的相关方法。我们期望系统中有许多同一类对象的实例，例如，想象一个银行系统。

Object for instance think of a bank system in which we might have different accounts. Each account would have a set of data values: current balance, overdraft protection, pending deposits. Thus there's the notion of an account as an abstract structure, and there's the idea of different specific versions of this abstract structure. Thus we make a distinction: a class will define the common behavior of a kind of object in our system—the collections of things that are going to behave in the manner defined by those commonalities. Instances capture the specific details of an...

对象，例如，想象一个银行系统，其中可能有不同的账户。每个账户会有一组数据值：当前余额、透支保护、待处理存款。因此，存在一个作为抽象结构的账户概念，以及这个抽象结构的不同具体版本的概念。因此，我们做出区分：一个类将定义我们系统中某一类对象的共同行为——那些以这些共性所定义的方式行事的对象的集合。实例则捕获该类的个体版本的具体细节……

### 10. Superclasses, Inheritance, and Conclusion (超类、继承与结论)

capture the specific details of an individual version of that class in our simple space war system so far we have class diagrams such as those shown here. we have a class for ships a class for Space Station's a class for taquitos and some other classes that we've not shown here.

捕获该类个体版本的具体细节。在我们简单的太空战争系统中，到目前为止，我们有如所示的类图。我们有一个飞船类、一个空间站类、一个玉米卷类，以及一些其他未在此显示的类。

recall that for each class we had two sets of things internal state variables which characterized the state of each instance of the class and a set of methods the things that the class was capable of doing those methods often were characterized by the instance

回想一下，对于每个类，我们有两组东西：内部状态变量，它们表征了该类每个实例的状态；以及一组方法，即该类能够执行的操作。这些方法通常通过实例接受同名消息来表征，然后在系统内的不同对象之间执行某些交互，或改变实例内部状态变量的状态，以说明问题。

were characterized by the instance accepting a message of the same name, then performing some interaction between different objects within the system or changing the status of the internal state variables of an instance in order to make a point.

这些方法通常通过实例接受同名消息来表征，然后在系统内的不同对象之间执行某些交互，或改变实例内部状态变量的状态，以说明问题。

I have changed slightly my definition of a torpedo last time. Torpedo just used a position and a velocity, and it moved until it hit something, at which point it exploded.

上次我对鱼雷的定义略有改动。鱼雷只使用位置和速度，它移动直到击中某物，然后爆炸。

A smarter torpedo might explicitly seek some target and uses state variable like a proximity fuze so that when the torpedo got close enough.

一个更智能的鱼雷可能会明确地寻找某个目标，并使用诸如近炸引信之类的状态变量，这样当鱼雷足够接近时……

that when the torpedo got close enough to its target it would explode one reason for introducing this is to notice that state variables within our instances could actually point to other instances so in the class diagram we would indicate this with a state variable for a target that points to another class a ship in this case.

当鱼雷足够接近其目标时，它就会爆炸。引入这一点的一个原因是注意到我们实例中的状态变量实际上可以指向其他实例，因此在类图中，我们会用一个指向另一个类（此处为飞船类）的目标状态变量来表示这一点。

however the real point to which we want to draw attention in this diagram is the commonality particularly the commonality between ships and torpedoes note that both of these objects comply they both therefore have state information about

然而，我们在此图中真正想引起注意的是共性，特别是飞船和鱼雷之间的共性。注意，这两个对象都符合（移动物体的特征），因此它们都有关于位置和速度的状态信息。

Therefore have state information about position and velocity; they both have methods that deal with position and velocity. Thus, they have a lot of things in common, as well as having a few distinctive properties. We know that a common theme in this course is capturing common patterns and abstracting it.

因此，它们都有关于位置和速度的状态信息；它们都有处理位置和速度的方法。因此，它们有很多共同之处，也有一些独特的属性。我们知道，本课程的一个主题是捕捉共同模式并加以抽象。

So the issue here is whether we can do the same thing in an object-oriented system. Can we take advantage of the fact that torpedos and ships share a lot in common and use that to build more modular systems? Conceptually, we should be able.

所以这里的问题是，我们能否在面向对象系统中做同样的事情。我们能否利用鱼雷和飞船共享许多共同点这一事实，来构建更模块化的系统？从概念上讲，我们应该能够做到。

systems conceptually, we should be able to do this without worrying about implementation details. Let's first pull out that common pattern in our class diagram. Here is an abstraction of that common pattern: a new class called a mobile thing. It has two state variables—position and velocity—and it has some common methods for dealing with those variables.

从概念上讲，我们应该能够做到这一点，而不必担心实现细节。让我们首先在我们的类图中提取那个共同模式。这是该共同模式的一个抽象：一个名为“移动物体”的新类。它有两个状态变量——位置和速度——以及一些处理这些变量的共同方法。

These variables and methods will hold for any mobile object, and thus this defines a new class. Given that new class, we can now create specializations. We can create a subclass: a torpedo is a particular kind of mobile thing. It has

这些变量和方法适用于任何移动物体，因此这定义了一个新类。有了这个新类，我们现在可以创建特化。我们可以创建一个子类：鱼雷是一种特殊的移动物体。它具有……

particular kind of mobile thing it has all the properties of mobile things but it also has characteristics that are particular to torpedoes similarly a ship is a kind of mobile thing it's a specialization that has in addition to the properties of mobile things other characteristics that matter only - as we start designing our system we can begin to put together hierarchies of class diagrams we have base classes like mobile things we also have some specializations or subclasses so that for example a ship is a mobile thing and should therefore inherit the state and

一种特殊的移动物体，它具有移动物体的所有属性，但也有鱼雷特有的特征。类似地，飞船是一种移动物体，它是一种特化，除了移动物体的属性外，还具有其他仅与……相关的特征——当我们开始设计系统时，我们可以开始构建类图的层次结构。我们有像移动物体这样的基类，也有一些特化或子类，例如，飞船是一种移动物体，因此应该继承移动物体的状态和行为，同时拥有自己的属性。反过来，我们说移动物体类是飞船和鱼雷类的超类。现在我们可以开始构建更广泛的设计，其中信息层次结构被捕获在不同的特化、不同的对象类中，当我们充实类图时，我们将拥有类之间的不同关系。例如，鱼雷可以有一个类作为链接。目标始终是此系统的关键部分，它们与飞船和鱼雷的交互将定义核心游戏机制。我们还需要考虑这些类如何随时间演变，添加新功能或改进现有功能以支持更复杂的场景。

should therefore inherit the state and behavior of a mobile thing as well as having its own properties in the other direction we say that the mobile thing class is a superclass of the ship and Torpedo classes. Now we can start building a broader set of designs in which we have hierarchies of information captured in different specializations, different classes of object, and as we fill out our class diagram we will have different relationships between the classes. Torpedos, for example, can have a class as a link. Targets are always going to be a key part of this system, and their interactions with ships and torpedos will define the core gameplay mechanics. We also need to consider how these classes evolve over time, adding new features or refining existing ones to support more complex scenarios.

因此，应该继承移动物体的状态和行为，同时拥有自己的属性。反过来，我们说移动物体类是飞船和鱼雷类的超类。现在我们可以开始构建更广泛的设计，其中信息层次结构被捕获在不同的特化、不同的对象类中，当我们充实类图时，我们将拥有类之间的不同关系。例如，鱼雷可以有一个类作为链接。目标始终是此系统的关键部分，它们与飞船和鱼雷的交互将定义核心游戏机制。我们还需要考虑这些类如何随时间演变，添加新功能或改进现有功能以支持更复杂的场景。

class as a link targets are always going

类作为链接，目标始终是……

class as a link targets are always going to be elements of the ship class note that one of the advantages of creating super classes is that we can nicely isolate the code for the methods of the super classes so that if we want to change one of those methods we only need to worry about the implementation of the super class not about all of the specializations.

类作为链接，目标始终是飞船类的元素。注意，创建超类的一个优点是，我们可以很好地隔离超类方法的代码，这样如果我们想更改其中一个方法，我们只需要担心超类的实现，而不必担心所有的特化。

if for example we decide to change how things move we don't have to search for all the move methods in different subclasses we need only change the method in the superclass this gives us of course a nice modularization of

例如，如果我们决定改变事物移动的方式，我们不必在不同子类中搜索所有移动方法，只需修改超类中的方法即可。这自然使系统模块化，

Us of course a nice modularization of the system by isolating the common methods in a single place for easy maintenance and change. To summarize, we've explored several of the basic elements of object-oriented programming.

通过将公共方法隔离在一个地方，便于维护和修改，我们自然实现了系统的良好模块化。总而言之，我们探讨了面向对象编程的几个基本要素。

Objects are now smart data structures; they have both state information and methods to manipulate state or implement other behaviors. The class specifies the common structure and behavior of instance objects of that class.

对象现在是智能数据结构；它们既有状态信息，也有操作状态或实现其他行为的方法。类规定了该类实例对象的共同结构和行为。

We've briefly introduced the idea of inheritance to share structure and behavior between classes. Today we've

我们简要介绍了继承的概念，以在类之间共享结构和行为。今天我们

behavior between classes today we've looked at message passing objects to implement a simple OOW system next time

在类之间共享行为，今天我们研究了通过消息传递对象来实现一个简单的面向对象系统。下次

we'll look at a more sophisticated o system and scheme in particular to incorporate inheritance that we just

我们将研究一个更复杂的面向对象系统，特别是Scheme，以纳入我们刚刚讨论的继承。