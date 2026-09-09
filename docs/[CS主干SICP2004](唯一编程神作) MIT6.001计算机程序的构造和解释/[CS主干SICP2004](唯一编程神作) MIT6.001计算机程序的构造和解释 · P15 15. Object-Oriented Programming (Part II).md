# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=15)

## Summary (摘要)

- The lecture presents three views of an object-oriented system: abstract, user, and implementer, with the abstract view being language-independent.
- In Scheme, classes are defined using a make-type procedure, and instances are created via a create-type procedure, following specific conventions.
- The implementer's perspective uses environments, frames, and procedures to represent classes and instances, with each instance containing a self pointer and a message handler.
- Dynamic dispatch is illustrated through a professor example, where methods like lecture can delegate to the self's say method, allowing subclasses like Arrogant Professor to override behavior.
- Multiple inheritance is introduced with a singing arrogant professor, demonstrating that the get method can take multiple arguments to specify precedence among superclasses.
- The lecture concludes by summarizing key design lessons, including the ability to control method inheritance and the power of object-oriented structuring.

- 本讲座从三个视角审视面向对象系统：抽象视角、用户视角和实现者视角，其中抽象视角与具体语言无关。
在Scheme中，类通过make-type过程定义，实例通过create-type过程创建，遵循特定约定。
- 实现者视角使用环境、框架和过程来表示类和实例，每个实例包含一个self指针和一个消息处理器。
- 通过教授示例说明动态分派，其中像lecture这样的方法可以委托给self的say方法，允许像傲慢教授这样的子类覆盖行为。
- 通过歌唱的傲慢教授引入多重继承，演示get方法可以接受多个参数以指定超类之间的优先级。
- 讲座最后总结了关键设计经验，包括控制方法继承的能力和面向对象结构化的力量。

## Outline (大纲)

1. Introduction to OOP in Scheme: Three Views / User and Implementer Views of OO Systems / OO Terminology: Classes, Inheritance, Instances / Class Instance Diagrams and Inheritance
2. Multiple Inheritance in Diagrams / User View of Classes in Scheme / Instance Methods and Type Queries / Self Variable and Example Instance Creation
3. Transition to Class Specification and Message Handlers / Template for Make-Type Procedure and Example
4. Requirements for Instance Creation / Using Instances Through the Ask Procedure
5. Implementer's Perspective: Environment Model / Instance Creation and Ask Implementation / Why Self Variable is Needed
6. Design and Implementation: Person Class / Adding Professor Subclass with Method Shadowing
7. Implementing Lecture Method via Delegation / Dynamic Dispatch vs Delegation in Lecture
8. Adding Question-Answer Behavior and Type-Dependent Answers
9. Lessons and Motivation for Multiple Inheritance / Multiple Inheritance: Singer Implementation and Get Method
10. Demonstration of Multiple Inheritance Behavior / Summary of Key Ideas in OOP

1. Scheme中的OOP简介：三种视角 / 面向对象系统的用户与实现者视角 / OO术语：类、继承、实例 / 类实例图与继承
2. 图中的多重继承 / Scheme中类的用户视角 / 实例方法与类型查询 / Self变量与实例创建示例
3. 过渡到类规范与消息处理器 / Make-Type过程模板与示例
4. 实例创建的要求 / 通过Ask过程使用实例
5. 实现者视角：环境模型 / 实例创建与Ask实现 / 为何需要Self变量
6. 设计与实现：Person类 / 添加Professor子类与方法遮蔽
7. 通过委托实现Lecture方法 / Lecture中的动态分派与委托
8. 添加问答行为与类型相关答案
9. 多重继承的经验与动机 / 多重继承：Singer实现与Get方法
10. 多重继承行为演示 / OOP关键思想总结

## Transcript (转录)

### 1. Introduction to OOP in Scheme: Three Views / User and Implementer Views of OO Systems / OO Terminology: Classes, Inheritance, Instances / Class Instance Diagrams and Inheritance (Scheme中的OOP简介：三种视角 / 面向对象系统的用户与实现者视角 / OO术语：类、继承、实例 / 类实例图与继承)

we want to create an object-oriented programming system in scheme to do this we need to keep in mind three different views of an auto system first we have the abstract view which is independent of scheme or other specific programming languages we'll remind ourselves of this terminology in a moment

我们希望在Scheme中创建一个面向对象的编程系统。为此，我们需要牢记一个自动系统的三种不同视角。首先，我们有抽象视角，它独立于Scheme或其他特定编程语言。我们稍后会提醒自己这些术语。

then we will consider the user view in scheme what are the conventions for writing scheme code to define and create sets of classes and instances including the notion of inheritance

然后我们将考虑Scheme中的用户视角：编写Scheme代码来定义和创建类与实例集合的约定是什么，包括继承的概念。

finally we'll look under the covers as an implementer

最后，我们将作为实现者深入内部。

under the covers as an implementer and see the supporting procedures that provide the object-oriented layer that users can build on top of recall our own terminology a class defines what is common to all instances of some type including local state variables and methods which implement desired behaviors an important capability is inheritance which enables inclusion of other classes in a new class we can define subclasses which specialize a superclass by extending the state and behavior of the superclass thus classes have and is a relationship with other

作为实现者深入内部，看看提供面向对象层的支持过程，用户可以在其上构建。回顾我们的术语：类定义了某个类型的所有实例的共同点，包括局部状态变量和实现所需行为的方法。一个重要的能力是继承，它允许将其他类包含在新类中。我们可以定义子类，通过扩展超类的状态和行为来特化超类。因此，类与其他类具有“拥有”和“是”的关系。

Have and is a relationship with other classes, thereby establishing a type hierarchy. Instances are objects that are created according to the template or plan defined by a class definition. Each instance has its own identity and its own local state. Thus, each instance can perform differently based on that state.

与其他类具有“拥有”和“是”的关系，从而建立类型层次结构。实例是根据类定义所定义的模板或计划创建的对象。每个实例都有自己的身份和局部状态。因此，每个实例可以根据该状态执行不同的操作。

The instances also have a type, their type is that given by the class definition. Class instant diagrams are a useful way of drawing or picturing the abstract view of any auto system we might want to design. The classes are shown in rectangular blocks with the

实例也有类型，它们的类型由类定义给出。类实例图是绘制或描绘我们可能设计的任何自动系统的抽象视图的有用方式。类用矩形块表示，其中包含

shown in rectangular blocks with the class name private variables and the methods or messages that the class supports instances are shown as a blob indicating their class and their specific local state with a dash line.

类名、私有变量以及类支持的方法或消息。实例显示为一个气泡，指示其类和特定局部状态，并用虚线连接。

we have shown the instance of relationship back to the defining class since we usually show the type of the instance inside the instance this instance of relationship is often omitted from the diagram.

我们显示了实例到定义类的实例关系，由于我们通常在实例内部显示实例的类型，这种实例关系在图中通常被省略。

the class instance diagram also allows us to show the inheritance relationships between classes for example a book is a subclass of named.

类实例图还允许我们显示类之间的继承关系。例如，book是named object的子类。

example a book is a subclass of named object, thus named object is a superclass. a book we see that book extends named object by adding a copyright variable as well as a year method. in this case the book instance pointed to by Z is not only a type book but also a type of named object.

例如，book是named object的子类，因此named object是超类。我们看到book通过添加copyright变量和year方法扩展了named object。在这种情况下，由Z指向的book实例不仅是book类型，也是named object类型。

### 2. Multiple Inheritance in Diagrams / User View of Classes in Scheme / Instance Methods and Type Queries / Self Variable and Example Instance Creation (图中的多重继承 / Scheme中类的用户视角 / 实例方法与类型查询 / Self变量与实例创建示例)

when we implement our own system and scheme we will need a way to manage this higher type hierarchy as well. we can also have multiple inheritance as shown here. in this case Class C inheritance from both Class A and Class B, thus Class C inherits the state variables and

当我们实现自己的系统时，在Scheme中，我们需要一种方法来管理这个更高的类型层次结构。我们也可以有多重继承，如图所示。在这种情况下，类C继承自类A和类B，因此类C继承了

C inherits the state variables and methods from both AMD so that Class C has methods Akbar and cop when we implement our own system and scheme we will need a way to manage both single and multiple inheritance type hierarchies. Now the big step: how would a scheme user view our system? By user, we mean a schema programmer who wants to write programs using an object-oriented style.

C继承了A和B的状态变量和方法，因此类C具有方法Akbar和cop。当我们实现自己的系统时，在Scheme中，我们需要一种方法来管理单继承和多继承类型层次结构。现在关键的一步：Scheme用户如何看待我们的系统？这里的用户是指想要使用面向对象风格编写程序的Scheme程序员。

Next, we'll look at how such a user can define classes and then create and use instances. First, what will classes look like in scheme? A class will be defined by a make-type procedure.

接下来，我们将看看这样的用户如何定义类，然后创建和使用实例。首先，在Scheme中类看起来像什么？类将由make-type过程定义。

be defined by a make type procedure. These will be a little more constrained than what we saw in our space for simulation world here. The make type procedure must follow particular conventions, that is to say, have a particular organization or structure in order to work in our system.

由 make type 过程定义。这些将比我们在模拟世界中所见的更为受限。make type 过程必须遵循特定的约定，也就是说，为了在我们的系统中工作，它必须具有特定的组织或结构。

We'll see how to provide local variables, provide a message handler to implement methods, and how to specify what super classes and methods are inherited in the Roo system. There will also be a predefined class called route object; all user-defined classes must inherit either.

我们将看到如何提供局部变量，如何提供消息处理器来实现方法，以及如何在 Roo 系统中指定继承的父类和继承的方法。还有一个预定义的类叫做根对象；所有用户定义的类都必须继承它。

user-defined classes must inherit either from the root object class or from some other user-defined superclass in addition we have a requirement that every user-defined class must implement a type method in a specific way in order to make clear the subclass superclass relationships in the city instances

用户定义的类必须继承自根对象类或某个其他用户定义的父类。此外，我们要求每个用户定义的类必须以特定方式实现 type 方法，以明确实例中的子类-父类关系。

on the other hand will conventionally be created by invoking a create type procedure each instance has its own identity in the sense of the scheme EQ procedure once an instance is created we can invoke methods on the instance in a

另一方面，实例通常通过调用 create type 过程来创建。每个实例都有其自身的同一性，即 Scheme 的 EQ 过程意义上的同一性。一旦创建了实例，我们就可以以标准方式在实例上调用方法。

can invoke methods on the instance in a standard way, standard way, standard way. Specifically we ask the instance to use some method indicated by the specific message on some number of arguments to provide type information. One can ask all instances for their type and a list of the types with the most specific type shown first will be returned. One can also ask an instance if it is a specific type.

我们可以以标准方式在实例上调用方法。具体来说，我们要求实例使用特定消息指示的某个方法，并传入若干参数。为了提供类型信息，可以询问所有实例的类型，返回一个类型列表，最具体的类型排在最前面。也可以询问实例是否属于特定类型。

So the picture a user has of the OO system and scheme is shown here. The named object class inherits from our root class and thus gains the type and is a methods. Now it also that there is a

因此，用户对 Scheme 中面向对象系统的视图如下所示。命名对象类继承自根类，从而获得 type 和 is-a 方法。现在，还有……

This is a methods now it also that there is a type method inside the named object class this emphasizes the requirement in our system that all classes must specialize the type method in order to make explicit what type the class is defining and what classes it inherits from.

这是 is-a 方法。现在，命名对象类内部还有一个 type 方法，这强调了我们的系统中的要求：所有类都必须特化 type 方法，以明确该类定义的类型以及它继承的类。

In addition because all classes in our system must inherit from root either directly or indirectly through other subclasses all of our instances will also have a self variable our oo system will arrange to have the self variable in each instance point back to the instance itself we'll see why this is.

此外，由于我们系统中的所有类都必须直接或间接地通过其他子类继承自根类，我们所有的实例也将有一个 self 变量。我们的面向对象系统将安排每个实例中的 self 变量指向实例本身。我们稍后会看到为什么这很重要。

instance itself we'll see why this is important later so here's a quick example of the user view now in scheme code at the bottom used to create a manipulate an instance we define a scheme variable X to point to a new named object instance with the name variable SiC P from outside the instance we cannot access this variable directly our only access is through the methods provided for that instance thus we can ask X for its name using the named method we can change the state of the instance using the change in a method and we have our type queries using the

实例本身，我们稍后会看到为什么这很重要。这里有一个用户视图的快速示例，底部是用于创建和操作实例的 Scheme 代码。我们定义一个 Scheme 变量 X 指向一个新的命名对象实例，其 name 变量为 SiC P。从实例外部，我们不能直接访问这个变量；我们只能通过该实例提供的方法进行访问。因此，我们可以使用 named 方法询问 X 的名字，可以使用 change-name 方法改变实例的状态，并且我们还有类型查询，使用……

And we have our type queries using the type and its methods back in our abstract view. Recall that we also extended the system to have a book class. Here's how that would be reflected in the scheme users view. Now we create a new book instance and bind that to Z. We can use not only the book method year, but also using the inherited method name. Here the Z instance is a book and also is a named object.

我们还有类型查询，使用 type 和 is-a 方法。回到我们的抽象视图，回想一下我们还扩展了系统，增加了一个 book 类。这将在 Scheme 用户视图中反映如下。现在我们创建一个新的 book 实例并将其绑定到 Z。我们不仅可以使用 book 方法 year，还可以使用继承的 name 方法。这里 Z 实例是一个 book，也是一个 named object。

### 3. Transition to Class Specification and Message Handlers / Template for Make-Type Procedure and Example (过渡到类规范和消息处理器 / make-type 过程的模板和示例)

So far we've seen some examples of the user view in scheme to create and manipulate instances. But how do we specify classes? First, let's consider an

到目前为止，我们已经看到了一些在 Scheme 中创建和操作实例的用户视图示例。但是我们如何指定类呢？首先，让我们考虑一个……

在语音识别和校对后的视频文稿中，我们首先看到一段内容，它可能是在描述视频的初始场景或引言部分。由于这一部分信息较为集中，我们将其作为一个独立的自然段，以保留其完整的语境和开头性。

在语音识别和校对后的视频文稿中，我们首先看到一段内容，它可能是在描述视频的初始场景或引言部分。由于这一部分信息较为集中，我们将其作为一个独立的自然段，以保留其完整的语境和开头性。

specify classes first let's consider an intermediate step and just consider message handlers these are very similar to the message handlers we saw in our space Wars example some maker creates a procedure that takes a message by convention however we now demand that the response to every message must be a procedure that is we must always have a lambda expression for each message that can be handled we refer to the procedure returned freeze message as the method so that a method is the procedure that we can then actually use to do the work thus the message handler simply takes in

指定类，首先让我们考虑一个中间步骤，只考虑消息处理器。这些与我们之前在 Space Wars 示例中看到的非常相似：某个制造者创建一个过程，按约定接受消息。然而，现在我们要求对每个消息的响应必须是一个过程，也就是说，对于每个可以处理的消息，我们必须有一个 lambda 表达式。我们将返回的过程称为方法，因此方法是我们可以实际用来完成工作的过程。因此，消息处理器只是接收……

can then actually use to do the work thus the message handler simply takes in

然后可以实际用来完成工作，因此消息处理器只是接收……

Thus the message handler simply takes in a message or symbol and returns a method or procedure. A quick side point is that we will do this message lookup so often that we will use a more convenient way of writing this in Scheme. Scheme has a case expression with the structure shown here.

因此，消息处理器只是接收一个消息或符号，并返回一个方法或过程。一个快速的附带说明是，我们会经常进行这种消息查找，因此我们将使用一种更方便的 Scheme 写法。Scheme 有一个 case 表达式，其结构如下所示。

For a given message symbol, we simply have a sequence of clauses that are considered one after another. The first clause that matches the message will cause the corresponding expression or method to be returned, so instead of a long cond expression where we

对于给定的消息符号，我们有一系列子句，它们被逐一考虑。第一个匹配消息的子句将导致相应的表达式或方法被返回，因此，与其使用一个冗长的 cond 表达式，在其中我们……

A long cond expression where we specifically call EQ to test the message. We can rewrite our message handling structure as shown here. It's really the same thing but just quicker to read and write. So message handlers are an intermediate step on the road towards full classes in our system.

一个冗长的 cond 表达式，在其中我们专门调用 EQ 来测试消息。我们可以将消息处理结构重写如下所示。这实际上是相同的事情，但读写起来更快。因此，消息处理器是通往我们系统中完整类的道路上的一个中间步骤。

Now the big step here's how a user, a programmer, will define a new class. He or she will write a make type procedure that must follow the template or structure shown below. There are a lot of pieces in this and we'll cover these in some examples, but briefly the make type procedure must.

现在是大步骤：以下是用户（程序员）如何定义一个新类。他或她将编写一个 make type 过程，该过程必须遵循下面所示的模板或结构。这个过程中有很多部分，我们将通过一些示例来介绍，但简要地说，make type 过程必须……

briefly the make type procedure must take as first argument the variable self and then may take additional arguments defining some local variables or local state.

简要地说，make type 过程必须将变量 self 作为第一个参数，然后可以接受额外的参数来定义一些局部变量或局部状态。

second there will usually be an internal left statement that creates some parts of our object out of the inherited super classes and which may contain some additional local state.

其次，通常会有一个内部的 let 语句，用于从继承的父类创建我们对象的某些部分，并且可能包含一些额外的局部状态。

then we have the message handler with the particular messages and methods that the class supports note that every user-defined class must have a type method as shown here to indicate what the type is and what it inherits from.

然后我们有消息处理器，包含该类支持的特定消息和方法。注意，每个用户定义的类都必须有一个 type 方法，如下所示，以指示类型是什么以及它继承自什么。

The type is and what it inherits from. Finally, the last cause in the message. Handler must be a get method as shown. Here, this is what enables the superclass to inherit or find the methods in the super classes of the new class.

类型是什么，以及它从何处继承。最后，消息中的最后一个原因是。处理程序必须是一个 get 方法，如图所示。在这里，这使超类能够继承或在新类的超类中找到方法。

So here's an example with these various parts labeled. We are defining the book class, which will have local state including a name and a copyright. This inherits from the named object superclass, so has a named object part which is the message handler for named objects. Thus, in some sense, any book object will have inside.

下面是一个标注了各个部分的示例。我们正在定义 book 类，它将具有包括名称和版权在内的局部状态。它继承自命名对象超类，因此具有一个命名对象部分，即命名对象的消息处理程序。因此，在某种意义上，任何 book 对象内部都会包含……

Any book object will have inside itself not only the message handler for itself not only the message handler for books but also the message handler for named objects. Looking inside the book message handler, we see the type method which does a type extend to specify that book is a subclass of named object. We also see the local method corresponding to the year message. Finally, we see the get method clause that tells us that the book class will use inherited methods from the named object we've already seen.

任何 book 对象内部不仅包含它自身的消息处理程序，即 books 的消息处理程序，还包含命名对象的消息处理程序。查看 book 消息处理程序内部，我们看到 type 方法执行 type extend 来指定 book 是 named object 的子类。我们还看到了对应于 year 消息的局部方法。最后，我们看到了 get 方法子句，它告诉我们 book 类将使用我们已经见过的命名对象的继承方法。

### 4. Requirements for Instance Creation / Using Instances Through the Ask Procedure (实例创建的要求 / 通过 Ask 过程使用实例)

Examples of instance creation have been shown earlier, but let's be clear on what is required of the process.

实例创建的示例前面已经展示过，但让我们明确该过程的要求。

be clear on what is required of the programmer to make this happen the user must provide a create type procedure for each class in addition to the make type procedure. The create type procedure will have the form shown here. It will make use of the provided create instance higher-order procedure by passing it the message handler make procedure and specifying the specific arguments needed for that class type.

明确程序员需要做什么来实现这一点：用户必须为每个类提供一个 create type 过程，除了 make type 过程之外。create type 过程将具有此处所示的形式。它将使用提供的 create instance 高阶过程，通过传递消息处理程序 make 过程并指定该类类型所需的特定参数来实现。

Note that self is not one of the arguments to create type or create instance. Instead, the create instant procedure will take care of the magic needed to deal with the self.

注意，self 不是 create type 或 create instance 的参数之一。相反，create instance 过程将处理处理 self 所需的魔法。

magic needed to deal with the self variable once the user has defined the create type procedure for his or her new class then we're off and running we can create multiple instances of the type with the user-defined creation procedure.

处理 self 变量所需的魔法。一旦用户为其新类定义了 create type 过程，我们就可以开始运行了。我们可以使用用户定义的创建过程创建该类型的多个实例。

so back in our book class definition example we have added the create book procedure at the top according to the conventions we've just discussed note that this is also a good place to document what the type signature is for instant creation here's another example in this case showing how the user has

回到我们的 book 类定义示例中，我们根据刚刚讨论的约定在顶部添加了 create book 过程。注意，这也是记录实例创建的类型签名的好地方。这里是另一个示例，展示了用户如何……

in this case showing how the user has implemented the named object class this follows the same structure with one minor exception in this case named object does not inherit from another user-defined class instead it inherits only from the predefined route object class we call a user class that only inherits from the root a base class

在这个示例中，展示了用户如何实现 named object 类。这遵循相同的结构，但有一个小例外：在这种情况下，named object 不继承自另一个用户定义的类，而是仅继承自预定义的根对象类。我们称一个仅继承自根类的用户类为基类。

the usual way that a user will actually use an instance is through the provided ask procedure really this is doing too and users can do these parts separately if desired although rarely is this needed but conceptually to use an

用户通常使用实例的方式是通过提供的 ask 过程。实际上，这做了两件事，用户如果需要也可以分别执行这些部分，尽管很少需要这样做。但从概念上讲，要使用一个……

needed but conceptually to use an instance we must first get the method from the instance corresponding to some message and second then apply that method to the method arguments

但从概念上讲，要使用一个实例，我们必须首先从实例中获取对应于某个消息的方法，然后将该方法应用于方法参数。

essentially the asked procedure just does these two steps for us finally here is our user view in the case of multiple inheritance all instances by virtue of inheritance from the root object class support the type and is a methods

本质上，ask 过程只是为我们完成了这两个步骤。最后，这是我们在多重继承情况下的用户视图：所有实例，由于继承自根对象类，都支持 type 和 is a 方法。

so in our case where C is a subclass of both Class A and B these methods work as illustrated here an instance of class a has the type given by the list a

因此，在我们的例子中，C 是 Class A 和 B 的子类，这些方法的工作方式如下所示：类 A 的一个实例具有由列表 a 给出的类型……

has the type given by the list a and has the type given by the list a and root an instance of Class C on the other hand as a more complicated type which includes first its own most specific type C but also the type symbols for the various inherited types.

具有由列表 a 给出的类型，并且具有由列表 a 和 root 给出的类型。另一方面，类 C 的一个实例具有更复杂的类型，其中首先包括其自身最具体的类型 C，但也包括各种继承类型的类型符号。

note that you should not depend on the order of the rest of these types they do not indicate any further ordering on types if we ask instances of a and C about whether each is a specific type we get the boolean results as indicated.

注意，你不应依赖其余这些类型的顺序；它们不表示类型的任何进一步排序。如果我们询问 A 和 C 的实例是否属于特定类型，我们会得到如所示的布尔结果。

### 5. Implementer's Perspective: Environment Model / Instance Creation and Ask Implementation / Why Self Variable is Needed (实现者的视角：环境模型 / 实例创建和 Ask 的实现 / 为什么需要 Self 变量)

now that we've seen how the user will view our scheme object-oriented system we want to look

既然我们已经看到了用户将如何看待我们的 Scheme 面向对象系统，我们想看看……

In an object-oriented system, we want to look under the covers with an implementer's perspective. How is it that we can create the generic object-oriented system on top of Scheme, so that the programmer can then use it as described above?

在面向对象系统中，我们想从实现者的角度深入内部。我们如何在 Scheme 之上创建通用的面向对象系统，以便程序员可以如上所述使用它？

What we want to do is use environments, frames, and procedures in Scheme to imprint our picture of a class instance diagram onto Scheme. As a reminder, here's the class instance diagram showing an instance of a book, as well as the diagram for the book class, which inherits from the named object class, which inherits from the root.

我们想要做的是使用 Scheme 中的环境、框架和过程，将我们对类实例图的图景印刻到 Scheme 中。提醒一下，这里是类实例图，显示了一个 book 实例，以及 book 类的图，book 类继承自 named object 类，后者继承自 root。

root and here is that same class instance diagram but now pictured using the skiing environment model we see that the instance Z is truly and really a very simple message passing handler for that instance. The instance also has a pointer to the handler for the book class, which itself is just the book message handler.

root。这里是同一个类实例图，但现在使用 Scheme 环境模型来描绘。我们看到实例 Z 确实是一个非常简单的消息传递处理程序。该实例还有一个指向 book 类处理程序的指针，而 book 类处理程序本身只是 book 消息处理程序。

Note that the book message handler and only the book message handler has access to the book instance's local state. It also has inside of it a named object part which points to the named object message handler, and that part's local...

注意，book 消息处理程序，且只有 book 消息处理程序，可以访问 book 实例的局部状态。它内部还有一个 named object 部分，指向 named object 消息处理程序，而该部分的局部……

message handler and that parts local state and finally we see the route message handler which is inside of the named object handler by virtue of the inheritance of route by

消息处理程序及其局部状态。最后，我们看到了 root 消息处理程序，它由于 root 被继承而位于 named object 处理程序内部。

thus conceptually the whole big thing is our scheme representation for the book instance drawn is a squiggly blob in the abstract class instance diagram inside of it is the pointer corresponding to the instance of abstract length connecting it to its defining class inside our separate structures each one having a frame in its own message handler implementing each class handler

因此，从概念上讲，整个大块就是我们对 book 实例的 Scheme 表示，在抽象类实例图中绘制为一个弯曲的团块。在其内部，有对应于抽象实例的指针，将其连接到其定义类。在我们的独立结构中，每个都有自己的框架，在自己的消息处理程序中实现每个类处理程序。

handler implementing each class handler and linking to each superclass handler. Remember this diagram, it's essential to understanding the implementation of our object-oriented scheme system now.

处理器实现了每个类处理器，并链接到每个超类处理器。记住这个图，它对于理解我们现在面向对象的 Scheme 系统的实现至关重要。

Exactly how is the instance created? We said that users must call the create instance higher-order procedure. Here it is. It simply creates an instance structure, then makes a handler for the given maker, and then sets the handler pointer inside the instance to that classes message handler. Note that the make instance procedure is pretty simple; it just has the local handler variable.

实例究竟是如何创建的呢？我们说用户必须调用 create-instance 高阶过程。这就是它。它简单地创建一个实例结构，然后为给定的制造者创建一个处理器，然后将实例内部的处理器指针设置为该类的消息处理器。注意，make-instance 过程非常简单；它只有局部变量 handler。

it just has the local handler variable and then its own little set handler message that helps us wire up the instance now when any requests or methods come to the instance it simply turns around and does a get method call to the message handler for that class

它只有局部变量 handler，然后它自己有一个小的 set-handler 消息，帮助我们连接实例。现在，当任何请求或方法到达实例时，它只是转身对该类的消息处理器执行 get-method 调用。

this environment model in the previous slide is what is generated as a result of using this procedure by way of a create book call the method will have all further it will be useful for you on your own to consider what happens when we actually ask an instance to do something to see how the method is found

上一张幻灯片中的环境模型是通过使用这个过程（通过 create-book 调用）所生成的结果。该方法将具有所有进一步的信息。你自己思考一下当我们实际要求一个实例做某事时会发生什么，以了解方法是如何被找到的，这将对你很有用。

something to see how the method is found and then applied but in order to do this you need a couple of more implementation details so how is ask implemented we previously said it does two things first it looks up the method using get method it checks to see if a valid method was returned and if not generates an error if a method is found it then applies the method to the arguments a little side explanation is needed here you can think of open paren apply off args close brand as being turned into an equivalent expression that you're more

为了看到方法是如何被找到并应用的，但要做到这一点，你还需要一些实现细节。那么 ask 是如何实现的呢？我们之前说过它做两件事：首先，它使用 get-method 查找方法；它检查是否返回了有效的方法，如果没有则生成错误；如果找到了方法，它然后将该方法应用于参数。这里需要一点额外的解释：你可以把 (apply off args) 看作是一个等价表达式，你更熟悉的是 off 应用于参数，如 (off r1 r2) 等等。

Equivalent expression that you're more used to, where the off is applied to the args as off R 1 R 2 and so on. We need to add one more thing to our environment model picture for our scheme auto system. Each of the internal message handlers also has a self variable. All of these are simply pointers back to the overall instance object.

我们需要在我们的环境模型图中为我们的 Scheme 系统添加一件事。每个内部消息处理器也有一个 self 变量。所有这些都只是指向整个实例对象的指针。

Why do we need this self variable anyway? This is a little bit subtle, but the user of a no system sometimes finds a need to do, from deep inside some class in a large class hierarchy, is asked the whole instance and not just some part of that.

为什么我们需要这个 self 变量呢？这有点微妙，但使用我们系统的用户有时会发现需要从大型类层次结构中某个类的深处，要求整个实例（而不仅仅是该实例的某一部分）做某事。

instance and not just some part of that instance to do something at this point. It is necessary to be able to ask oneself to do something again. This is a little subtle but should become more clear as we work through an example of a design exercise to illustrate the use of our scheme system. Our goal here is to consider an example of object-oriented design and implementation. This will consist of both the design part and the implementation using our auto system and scheme. During the design part, we will focus abstractly on classes and the.

此时，有必要能够再次要求自己做某事。这有点微妙，但当我们通过一个设计练习的例子来说明我们 Scheme 系统的使用时，应该会变得更加清晰。我们的目标是考虑一个面向对象设计和实现的例子。这将包括设计部分和使用我们的系统及 Scheme 的实现部分。在设计部分，我们将抽象地关注类以及类之间的关系，思考我们希望对象具有的行为以及这些对象之间的交互。在实现这些行为时，我们将注意方法的继承、何时显式调用超类方法，以及如何遮蔽或覆盖超类方法的默认行为。我们将在同一个扩展示例的背景下进行所有这些工作，这个示例的世界由人、教授和学生组成。我们从人的类开始，称之为 person 类。每个 person 实例都有一个类变量保存人的名字。每个实例还有三个方法：第一个是 type 方法，这是我们系统中所有类都需要的；same 方法使 person 说一些话；whoareyou 方法使 person 表明他们的名字。

### 6. Design and Implementation: Person Class / Adding Professor Subclass with Method Shadowing (设计与实现：Person 类 / 添加带方法遮蔽的 Professor 子类)

focus abstractly on classes and the relationships between these classes well think about the behaviors you want our objects to have and interactions between those objects as we implement these behaviors we'll pay attention to inheritance of methods when to explicitly call superclass methods and how to shadow or override default behaviors of superclass methods well do all this in the context of a single extended example the world consisting of people professors and students we start with a class for people which we call the person class each instance of a

抽象地关注类以及类之间的关系，思考我们希望对象具有的行为以及这些对象之间的交互。在实现这些行为时，我们将注意方法的继承、何时显式调用超类方法，以及如何遮蔽或覆盖超类方法的默认行为。我们将在同一个扩展示例的背景下进行所有这些工作，这个示例的世界由人、教授和学生组成。我们从人的类开始，称之为 person 类。每个 person 实例都有一个类变量保存人的名字。每个实例还有三个方法：第一个是 type 方法，这是我们系统中所有类都需要的；same 方法使 person 说一些话；whoareyou 方法使 person 表明他们的名字。

the person class each instance of a person has one class variable holding the person's name each instance also has three methods the first is the type method required of all classes in our system the same method causes the person to say something the whoareyou method causes the person to indicate their name

person 类的每个实例都有一个类变量保存人的名字。每个实例还有三个方法：第一个是 type 方法，这是我们系统中所有类都需要的；same 方法使 person 说一些话；whoareyou 方法使 person 表明他们的名字。

an example of how we want the implementation to behave is also shown here of course we want to be able to create instances such as the person will label p1 named Joe after creating this instance we can ask who are you and see

这里还显示了一个我们希望实现如何表现的例子。当然，我们希望能够创建实例，比如我们将标记为 p1 的名为 Joe 的人。创建这个实例后，我们可以询问 who-are-you 并看到响应。

For instance, we can ask who are you and see the response. If we ask p1 to say the sky is blue, we get that phrase parroted back to us. Here's our implementation of the person class, following exactly the template we've previously introduced for our own scheme system.

例如，我们可以询问 who-are-you 并看到响应。如果我们要求 p1 说“天空是蓝色的”，我们会得到那句话的鹦鹉学舌般的回应。这是我们 person 类的实现，完全遵循我们之前为 Scheme 系统引入的模板。

Note that person inherits only from the root object, from which we get the is-a method as well as the self variable. In most of the class diagrams here, we'll take a shortcut and not draw this inheritance relationship, since it's the same for all of our base classes that only inherit from the root.

注意，person 只继承自根对象，从那里我们得到 is-a 方法以及 self 变量。在大多数类图中，我们将采取捷径，不画出这种继承关系，因为它对于所有仅继承自根对象的基础类都是相同的。

of our base classes that only inherit from the route object but you should remember that it's still there although not shown or whoareyou method is quite simple it takes no arguments and just returns the name the same method is also simple it takes an argument stuff to say and just returns to that stuff finally we have our standard else clause that passes along messages to the root object in case they're not found directly in our person class also at the top of the page we see the create person procedure again following our standard template this is

对于仅继承自根对象的基础类，你应该记住它仍然存在，尽管没有显示。我们的 whoareyou 方法非常简单，它不接受参数，只返回名字。same 方法也很简单，它接受一个参数 stuff-to-say，并返回该内容。最后，我们有标准的 else 子句，将消息传递给根对象，以防它们没有直接在 person 类中找到。在页面顶部，我们还看到了 create-person 过程，再次遵循我们的标准模板。

Following our standard template, this is used to create specific instances used to create specific instances used to create specific instances according to the make person class definition, so that each person instance has the message handler for person behavior.

遵循我们的标准模板，这用于创建特定实例，根据 make-person 类定义，以便每个 person 实例都有用于 person 行为的消息处理器。

Let's consider more closely what our person instances look like in our scheme system. After creating p1, we can use the show instance utility procedure to look under the covers and see the structure of our instance.

让我们更仔细地考虑在我们的 Scheme 系统中 person 实例是什么样的。创建 p1 后，我们可以使用 show-instance 实用程序过程来查看内部结构，看到我们实例的结构。

Thus, we see the structure for instance as implemented in the environment model picture we talked about earlier. This output tells us that p1 is an instance.

因此，我们看到了实例的结构，正如我们之前讨论的环境模型图中所实现的那样。这个输出告诉我们 p1 是一个实例。

output tells us that p1 is an instance which happens to really be a compound procedure in scheme with a hash identifier for in this example the type of our object is the list of to type symbols person root our instances have inside of them the message handler where the handle has both a handler frame holding local state variables and the handler procedure which shows our message passing lambda looking back at the handler frame we see the local variables including self which is just a pointer back to the whole instance which was the compound procedure for and the

输出告诉我们，p1 是一个实例，它实际上是一个带有哈希标识符的 Scheme 复合过程，在这个例子中，我们对象的类型是类型符号列表 person root。我们的实例内部有一个消息处理器，其中处理器既有一个保存局部状态变量的处理器框架，也有处理器过程，它展示了我们的消息传递 lambda。回顾处理器框架，我们看到局部变量包括 self，它只是指向整个实例的指针，该实例是复合过程，以及

was the compound procedure for and the name variable next we add a sub class a person called a professor

是复合过程，以及 name 变量。接下来我们添加一个 person 的子类，称为 professor。

note that this class does not have any specific internal class variables

注意，这个类没有任何特定的内部类变量。

however because it is a sub class of a person it should inherit the class variables of its superclass in other words professors also have a name because their person's superclass instance has such a variable and

然而，因为它是 person 的子类，它应该继承其超类的类变量。换句话说，教授也有名字，因为他们的 person 超类实例有这样的变量，并且

professors have the ability to say things by virtue of being a subclass of person we also see some example code illustrating the behavior we want after

教授作为 person 的子类，因此有能力说话。我们还看到一些示例代码说明了我们想要的行为。

illustrating the behavior we want after creating a professor named Fred which will refer to by using the variable prof 1, we can ask the professor to say something. Because of this hierarchy of classes, prof 1 will use its inherited method from the person class to do this. In our little world, professors have no class variables of their own, ah the irony, but they do have two methods we would like to act: a whoareyou method and a lecture method.

在创建了一个名为 Fred 的教授（我们将用变量 prof1 来引用）之后，我们可以让教授说些什么。由于这种类层次结构，prof1 将使用从 person 类继承的方法来做到这一点。在我们的小世界里，教授没有自己的类变量，啊，真是讽刺，但他们确实有两个我们想要起作用的方法：一个 whoareyou 方法和一个 lecture 方法。

Here we want a professor to have its own whoareyou method, the think from the identically named method in my person if we ask a professor who.

这里我们希望教授有自己的 whoareyou 方法，与 person 类中同名的方法不同。如果我们问一个教授“你是谁”

In my person, if we ask a professor who are you, it will run its own method to answer the question with a different behavior. Specifically, we want the professor to add his or her title prof to his or her name.

在 person 类中，如果我们问一个教授“你是谁”，它将运行自己的方法，以不同的行为来回答这个问题。具体来说，我们希望教授在他的名字前加上头衔 prof。

### 7. Implementing Lecture Method via Delegation / Dynamic Dispatch vs Delegation in Lecture (通过委托实现 Lecture 方法 / 动态分派与 Lecture 中的委托)

When a subclass has a method of the same name as a superclass, the subclass method is set to shadow the inherited method in the superclass of instance. Now in the world we're creating, it is traditional that when a professor lectures, he or she starts every sentence with therefore.

当子类具有与超类同名的方法时，子类方法将遮蔽实例超类中继承的方法。现在，在我们创建的世界中，传统上教授讲课时，每句话都以“因此”开头。

An interesting question to consider when actually implementing...

在实际实现时，一个有趣的问题是……

to consider when actually implementing the professor class is whether this lecture method is a distinct method or whether its share structure from the underlying say method of the inherited person class. let's look at our implementation of the professor class here. we see the inheritance from the person class note that we have both a person part and we type extend from person part. in the case of the lecture method we see that conceptually lecturing is just a little more than saying we simply add the word therefore and then say the remaining text.

在实际实现教授类时，要考虑的问题是，这个 lecture 方法是一个独立的方法，还是它与继承的 person 类的底层 say 方法共享结构。让我们看看这里的教授类的实现。我们看到从 person 类的继承，注意我们既有 person 部分，也有从 person 部分扩展的类型。在 lecture 方法的情况下，我们看到概念上讲，讲课只是比说话多一点：我们只需添加“因此”这个词，然后说出剩余的文本。

And then say the remaining text. This is an example where we explicitly use a method from one of our contains super classes to implement new behavior. This is sometimes called delegation and object oriented systems.

然后说出剩余的文本。这是一个例子，我们显式地使用来自我们包含的超类之一的方法来实现新的行为。这有时被称为对象系统中的委托。

In the case of who are you, we are specializing the default method from the person class. That is to say, we have a mechanism by which subclasses can specialize or use methods found in super classes.

在 who are you 的情况下，我们特化了 person 类的默认方法。也就是说，我们有一种机制，通过它子类可以特化或使用在超类中找到的方法。

This has an important consequence: if we design our object system correctly, we will have a clean modularity of code so that there is only one place to implement saying.

这有一个重要的后果：如果我们的对象系统设计正确，我们将拥有清晰的代码模块化，这样只有一处实现说话。

is only one place to implement saying something and that's only one place to worry about if we decide to change the manner in which this method executes now let's add another new class as a subclass or professor this one is called an arrogant problem an arrogant prophet is distinguished by the fact that he ends everything he says with obviously

只有一处实现说话，并且只有一处需要担心，如果我们决定改变这个方法的执行方式。现在让我们添加另一个新类，作为 professor 的子类，这个类叫做 arrogant professor。一个傲慢的教授的特点是，他说的每句话都以“显然”结尾。

and here's our implementation how do we implement the desired say behavior the obvious way to do this is to have an arrogant profs method of saying simply be a delegation of saying to its

这是我们的实现。我们如何实现期望的 say 行为？显而易见的方法是让 arrogant professor 的 say 方法简单地委托给它的

be a delegation of saying to its superclass or professor was obviously tacked on to the end note that we can only delegate to or ask for help from super classes one step up in the superclass chain that is the only way Arrogant profit can eventually get to the person and it's math the arrogant prof has a pointer to its immediate superclass handler but not to superclass as higher in the chain by asking one step up in the chain the ordinary inheritance mechanism will take over when the system determines that the professor doesn't have a say method

委托给它的超类 professor 的 say 方法，并在末尾加上“显然”。注意，我们只能委托给或向超类链上一级的超类求助。也就是说，Arrogant Professor 最终只能通过这种方式到达 person 类及其方法。Arrogant Professor 有一个指向其直接超类处理器的指针，但没有指向链上更高超类的指针。通过向链上一步询问，当系统确定教授没有 say 方法时，普通的继承机制将接管。

教授类本身没有自己的讲话方法，这就产生了一个有趣的问题。如果我们让一个傲慢的教授去讲课，他应该怎么讲呢？一种观点认为，既然傲慢教授没有讲课方法，讲课将由教授类中的方法处理，而该方法又会委托给人员类来处理，因此结果会显示出来。

教授类本身没有自己的讲话方法，这就产生了一个有趣的问题。如果我们让一个傲慢的教授去讲课，他应该怎么讲呢？一种观点认为，既然傲慢教授没有讲课方法，讲课将由教授类中的方法处理，而该方法又会委托给人员类来处理，因此结果会显示出来。

但另一种观点认为，傲慢教授继承了教授类的讲课方法，所以从概念上讲，讲课方法就存在于傲慢教授类中，因此讲课方法应该让傲慢教授...

但另一种观点认为，傲慢教授继承了教授类的讲课方法，所以从概念上讲，讲课方法就存在于傲慢教授类中，因此讲课方法应该让傲慢教授……

Lecture method should give arrogant profit chance to see whether it knows how to say something rather than instantly delegating to assay method found off the superclass chain and of course arrogant prof does know how to say something it has a say method one that should shadow the same method of a person as a result asking an arrogant prof to lecture under this view should result in the arrogant profit both lecturing was there for the front and showing his arrogance with obviously at the end here's a change in our implementation to achieve this behavior.

讲课方法应该给傲慢教授一个机会，看看它是否知道如何说些什么，而不是立即委托给在超类链上找到的 say 方法。当然，傲慢教授确实知道如何说些什么，它有一个 say 方法，这个方法应该遮蔽 person 类的同名方法。因此，在这种观点下，要求傲慢教授讲课应该导致傲慢教授既在开头说“因此”，又在结尾显示他的傲慢，加上“显然”。这里是我们实现这一行为的改动。

implementation to achieve this behavior, rather than the professor class's lecture method asking its internal person part to say something, we have the professor ask itself to say something in other words, we want to go back to the whole instance and not just the person part to find the same method now asking a p1 to lecture results in the following sequence of events.

实现这一行为的改动，不是教授类的 lecture 方法要求其内部的 person 部分说些什么，而是教授要求自己说些什么。换句话说，我们想要回到整个实例，而不仅仅是 person 部分，来找到 say 方法。现在，要求 a-p1 讲课会导致以下事件序列。

You can't find a lecture method in the arrogant prof class, so use the method from the superclass professor. The lecture method from professor asks the current instance a p1 which is the arrogant prof to say

在傲慢教授类中找不到 lecture 方法，所以使用来自超类教授的方法。教授的 lecture 方法要求当前实例 a-p1（即傲慢教授）说……

a p1 which is the arrogant prof to say the original stuff with therefore prepended to the front. Note what has changed and what hasn't under this view. Lecturing is still saying something with therefore on the front, but now we are asking the current instance an arrogant prop to do the same.

一个 p1，即傲慢教授，说出原始内容，并在前面加上“因此”。注意在这种观点下什么变了，什么没变。讲课仍然是在前面加上“因此”说出某些内容，但现在我们要求当前实例——一个傲慢教授——做同样的事情。

Instead of handing it up to the superclass chain, the arrogant prof has a say method which works by adding obviously to the end of the statement which resulted from a say done back by the next same method that can be found in the inheritance chain.

与其将消息上交给超类链，傲慢教授有一个 say 方法，其工作方式是在语句末尾加上“显然”，而该语句是由继承链中下一个相同方法（即 person 类中的方法）返回的结果。

can be found in the inheritance chain

可以在继承链中找到，结果证明是在 person 类中。

can be found in the inheritance chain, which turns out to be in the person. A key issue we then see is to decide, as we build our object-oriented system, how we want methods to inherit from the other methods. Ideally, we will want the ability to choose as a programmer, when we decide on our class of objects, whether to specialize or inherit behaviors.

可以在继承链中找到，结果证明是在 person 类中。我们随后看到的一个关键问题是，在构建面向对象系统时，如何决定方法如何从其他方法继承。理想情况下，当我们决定对象类时，我们希望作为程序员能够选择是特化还是继承行为。

In some cases, maybe we may want to specialize behaviors in specific super classes, either completely replacing them or by wrapping around existing existing behaviors. In other cases, we may want to simply inherit.

在某些情况下，我们可能希望在特定的超类中特化行为，要么完全替换它们，要么通过包装现有行为来实现。在其他情况下，我们可能只想简单地继承。

cases we may want to simply inherit behaviors by following up the chain of classes through the get method clause at the end now let's add one final type of object to our system a student students are always very polite so they have their own say method which prepends the words excuse me but to the front of everything they so in the implementation for the student class we again specialized the same method and wrap around or add additional behavior if you like to what we get if we ask the person part to say some stuff students ask questions of

在某些情况下，我们可能只想通过沿着类链向上查找 get 方法子句来简单地继承行为。现在让我们向系统添加最后一种对象类型：学生。学生总是非常有礼貌，所以他们有自己的 say 方法，该方法在他们所说的一切前面加上“打扰一下”。因此在学生类的实现中，我们再次特化了 say 方法，并包装或添加了额外行为，如果我们要求 person 部分说一些话，就会得到这些行为。

Some stuff students ask questions of others, well, people in general ask questions of other people as well as respond with answers back to them, except children who ask questions would never seem to answer them. But that's an extension for another day.

学生向他人提问，嗯，一般来说，人们会向他人提问，并回答他们，除了孩子们似乎从不回答问题。但那是另一天的扩展。

### 8. Adding Question-Answer Behavior and Type-Dependent Answers (添加问答行为和类型相关的回答)

Let's consider adding a new question-and-answer behavior. What will be a little different here is that these methods will involve interaction between two different people: a person asked a question of another person, and a person answers back to the asker.

让我们考虑添加一个新的问答行为。这里的不同之处在于，这些方法将涉及两个人之间的互动：一个人向另一个人提问，另一个人回答提问者。

Asker note that by putting these methods in the person class, we are also specified that students as well as professors inherit this ability to question an answer. So for example, a student s one may ask person P one why the sky is blue. The typical answer back to Bert the student is Bert, I do not know about why the sky is blue.

提问者注意，通过将这些方法放在 person 类中，我们也指定了学生和教授都继承这种提问和回答的能力。例如，学生 s1 可能会问 person p1 为什么天空是蓝色的。对伯特（学生）的典型回答是：“伯特，我不知道为什么天空是蓝色的。”

Here is the implementation: we've added some type signatures to the question and answer methods to help clarify how they should be used. Specifically, we see that the question method needs two arguments: the other person of whom the query will be.

以下是实现：我们为 question 和 answer 方法添加了一些类型签名，以帮助澄清它们应如何使用。具体来说，我们看到 question 方法需要两个参数：被提问的其他人，以及问题本身。

other person of whom the query will be made and the query itself similarly the answer method needs to know whom to respond to in this case so they find out that person's name inside of the map ok that wasn't too bad

被提问的其他人，以及问题本身。类似地，answer 方法需要知道在这种情况下要回应谁，因此它会在映射中找到那个人的名字。好吧，那还不算太糟。

but of course while regular people don't know the answer Arrogant professors might have their own way of answering questions and here we want the arrogant professor to do something fairly sophisticated

但当然，虽然普通人不知道答案，傲慢的教授可能有自己回答问题的方式，这里我们希望傲慢的教授做一些相当复杂的事情。

if the question is being asked by a student then the arrogant prof will respond with an answer this should be obvious to you

如果问题是由学生提出的，那么傲慢的教授会回答：“这个答案对你来说应该是显而易见的。”

An answer this should be obvious to you. Obviously, on the other hand, if the question is asked by another professor, then the arrogant profile respond with, "But you wrote a paper about whatever the question was." The reason for introducing this behavior is to provide an example of a class method in which the action of the method depends on the type of the object that initiated it.

“这个答案对你来说应该是显而易见的。显然。”另一方面，如果问题是由另一位教授提出的，那么傲慢的教授会回答：“但你写了一篇关于这个问题的论文。”引入这种行为的原因是为了提供一个类方法的例子，其中方法的行为取决于发起它的对象的类型。

In particular, to incorporate this behavior, the arrogant prof's answer method will need to do something different depending on what kind of object posed the question in the first place.

特别是，为了整合这种行为，傲慢教授的 answer 方法需要根据最初提出问题的对象类型来做不同的事情。

object posed the question in the first place if it was a student then we want to respond one way whereas if it was a professor we want to respond a different way how do we do this here's where we use the is a method that all objects in our system inherit from the rude object class in order to check the type of our objects.

最初提出问题的对象类型。如果是学生，我们想以一种方式回应；而如果是教授，我们想以另一种方式回应。我们怎么做呢？这里我们使用 is_a 方法，所有对象都从根对象类继承该方法，以检查对象的类型。

### 9. Lessons and Motivation for Multiple Inheritance / Multiple Inheritance: Singer Implementation and Get Method (多重继承的教训和动机 / 多重继承：Singer 实现和 Get 方法)

so what are the lessons we can take away from this design and implementation exercise well we can see that as we design a system for supporting the creation of object-oriented systems we need ways for specifying class hierarchies including

那么，从这次设计和实现练习中我们能得到什么教训呢？我们可以看到，在设计一个支持创建面向对象系统的系统时，我们需要指定类层次结构的方法，包括从超类继承结构和方法的特性，我们就有能力控制这些方法的调用，包括超类和子类中定义的方法，或是那些基于完整自实例对象的方法。

指定类层次结构，包括从超类继承结构和方法的特性，我们就有能力控制这些方法的调用，包括超类和子类中定义的方法，或是那些基于完整自实例对象的方法。

指定类层次结构，包括从超类继承结构和方法的特性，我们就有能力控制这些方法的调用，包括超类和子类中定义的方法，或是那些基于完整自实例对象的方法。

最后，我们能够以一种强大的方式扩展类型的理念到类中。现在我们已经看到继承，即超类的内部消息处理器能够为对象的特化提供方法，当遇到多重继承时会发生什么？

最后，我们能够以一种强大的方式扩展类型的理念到类中。现在我们已经看到继承，即超类的内部消息处理器能够为对象的特化提供方法，当遇到多重继承时会发生什么？

当我们遇到多重继承时，换句话说，当对象从不同种类的超类继承方法时，会发生什么？让我们向系统添加一个新对象、一个新类。歌手与人是不同的，它有自己的say方法，总是以tralala结束，并且还有一个sing方法，以“the hills are alive”开头。

当我们遇到多重继承时，换句话说，当对象从不同种类的超类继承方法时，会发生什么？让我们向系统添加一个新对象、一个新类。歌手与人是不同的，它有自己的 say 方法，总是以“tralala”结束，并且还有一个 sing 方法，以“the hills are alive”开头。

在此基础上，我们可以创建一个唱歌的自大教授，天知道它实际上会做什么，尽管你可能在MIT周围见过一些这样的人。这个想法是，一个这样的SAp应该从两者继承方法。

在此基础上，我们可以创建一个唱歌的自大教授，天知道它实际上会做什么，尽管你可能在 MIT 周围见过一些这样的人。这个想法是，一个这样的 SAP 应该从两者继承方法。

an S ap should inherit methods from both an arrogant professor and from a singer this will lead to some interesting questions about how one decides where to inherit a method from then there are multiple choices of methods first we can build our base representation or base class for singer

一个 SAP 应该从傲慢教授和歌手两者继承方法。这将引发一些有趣的问题，关于如何决定从哪个方法继承，因为存在多个方法选择。首先，我们可以为歌手构建基础表示或基类。

in this case the singer inherits only from the root object class and a particular note that the singer is not the kind of person the definition for singer is very simple it has methods for saying and singing as shown noting that singing uses the objects a method

在这种情况下，歌手仅从根对象类继承，并且特别注意歌手不是一种人。歌手的定义非常简单，它有 say 和 sing 方法，如图所示，注意 sing 使用了对象的 a 方法。

singing uses the objects a method this is just like our other class definitions in form including the standard pipe now. We can define the class of a singing arrogant professor. We have within the definition for this class something that inherits structure and behavior from the singer class getting a handler for the singer part by the call to make singer.

sing 使用了对象的 a 方法。这在形式上与其他类定义类似，包括标准的管道。现在，我们可以定义唱歌的傲慢教授的类。在这个类的定义中，我们通过调用 make_singer 获得歌手部分的处理器，从而从歌手类继承结构和行为。

Similarly, we have a part that gives us arrogant professor capabilities using our standard template for a class definition. We also have a type message that shows that a singing arrogant professor.

类似地，我们有一个部分，使用我们定义类的标准模板，赋予我们傲慢教授的能力。我们还有一个类型消息，表明一个会唱歌的傲慢教授。

that shows that a singing arrogant Prophet stands the type of or is a subclass of both the singer part and the arrogant prof part. This says that instances of our singing arrogant professors will accept messages, and in the case of the type message, will handle it directly. However, in the case of multiple inheritance, we see that the get method procedure can take multiple arguments. This says that to find the method for the message, look first in the singer class; in most cases, this will simply get the corresponding method from the singer part and if a method is not

表明一个会唱歌的傲慢教授既属于歌手部分，也属于傲慢教授部分的子类。这表示我们的会唱歌的傲慢教授的实例将接受消息，并且在类型消息的情况下，将直接处理它。然而，在多继承的情况下，我们看到 get 方法过程可以接受多个参数。这表示要查找消息的方法，首先在歌手类中查找；在大多数情况下，这将简单地获取歌手部分中对应的方法，如果方法不在那里，

The singer part and if a method is not there, try next in the arrogant prof. Part in this way, it is possible for a class to inherit from an arbitrary number of super classes. Let's try this out and see what happens.

如果方法不在歌手部分中，则接下来在傲慢教授部分中尝试。通过这种方式，一个类可以继承任意数量的超类。让我们尝试一下，看看会发生什么。

### 10. Demonstration of Multiple Inheritance Behavior / Summary of Key Ideas in OOP (多继承行为演示 / 面向对象编程关键思想总结)

We create Zoe, an arrogant singing professor, which will be labeled SP1. We can ask SP1, "Who are you?" and we see from the response, "Prof", that SP1 has found a response to the message in the inherited professor class and used that method to provide a response.

我们创建了 Zoe，一个傲慢的唱歌教授，将其标记为 SP1。我们可以问 SP1：“你是谁？”从响应“教授”中，我们看到 SP1 在继承的教授类中找到了对该消息的响应，并使用该方法提供了响应。

capability indirectly by virtue of the

能力间接地通过

capability indirectly by virtue of the arrogant professor class itself inheriting from the professor class in the next line. So we ask s if you want to sing, and then to say something, and sure enough we get the expected behavior of a singer based on the inherited singer methods.

能力间接地通过傲慢教授类本身继承自教授类而获得，在下一行中。所以我们问 s 是否想唱歌，然后说点什么，果然我们得到了基于继承的歌手方法的预期歌手行为。

Finally, we ask si p1 to lecture. If you need to look back at the class definitions we previously discussed for professor, for professors, and arrogant professors to figure out what happens here, the lecture method is found in the lecture class, which appends therefore - the result of asking si P want to say.

最后，我们问 si p1 去讲课。如果你需要回顾我们之前讨论过的教授、傲慢教授类的定义，以弄清楚这里发生了什么，讲课方法在讲课类中找到，它附加了因此——询问 si P 想说什么的结果。

The result of asking si P want to say. This guy is blue, but remember what happened when we asked si P to say this before, bonded with the singer say method. So even though we have a say method in the arrogant professor class, that method is never used. This is because in our singing arrogant professor class, our singer superclass has precedence over the arrogant prop superclass.

询问 si P 想说什么的结果。这家伙是蓝色的，但记住当我们之前问 si P 说这个时发生了什么，与歌手说方法绑定。所以即使我们在傲慢教授类中有一个说方法，该方法也从未被使用。这是因为在我们的会唱歌的傲慢教授类中，我们的歌手超类优先于傲慢教授超类。

Now, if this is not the behavior actually desired for example, perhaps we wanted singing arrogant professors to have professor behaviors dominate singing behaviors.

现在，如果这不是实际期望的行为，例如，也许我们希望唱歌的傲慢教授具有教授行为而非唱歌行为。

behaviors dominate singing behaviors, then we could change our implementation to achieve this. And if you wanted even finer control over how the same method is handled, for example to obtain some mix of both the singing and arrogant proper methods, then we could implement the same method in singing arrogant professor to choreograph this.

行为主导唱歌行为，那么我们可以改变我们的实现来实现这一点。如果你想要对同一方法的处理进行更精细的控制，例如获得唱歌和傲慢教授方法的某种混合，那么我们可以在唱歌傲慢教授中实现相同的方法来编排这一点。

Previously, we thought of get method just looking in a single object type for the method corresponding to some message in the singing arrogant professor class definition. We introduced a generalized get method procedure that could take any

之前，我们认为 get 方法只是在单个对象类型中查找与某个消息对应的方法，在唱歌傲慢教授类定义中。我们引入了一个广义的 get 方法过程，它可以接受任意数量的超类。

Get method procedure that could take any number of super classes. Here is how this is implemented, where we see that get method simply looks in order through the argument.

get 方法过程可以接受任意数量的超类。以下是它的实现方式，我们看到 get 方法只是按顺序在参数中查找。

So what we've shown you is how to build an object-oriented system, especially considering the kinds of behaviors we can get. We saw the role of classes, instances, and hierarchies of classes that capture common behavior.

所以我们向你展示的是如何构建一个面向对象的系统，特别是考虑到我们能获得的各种行为。我们看到了类、实例以及捕获共同行为的类层次结构的作用。

In the case of multiple inheritance, we also refined our rule implemented in get method for finding a method in the various super classes. We have thus.

在多继承的情况下，我们还改进了在 get 方法中实现的规则，用于在各种超类中查找方法。因此，我们

Various super classes we have thus introduced you to many of the key ideas in object-oriented programming systems. We've discussed class and instance diagrams, which provide an abstract and indeed language-independent view of a system. Finally, we've also shown how an object-oriented system can be implemented in scheme and what the resulting interface looks like to enable users to define classes, create instances, and manipulate those instances.

各种超类，我们因此向你介绍了面向对象编程系统中的许多关键思想。我们讨论了类和实例图，它们提供了系统的抽象且确实与语言无关的视图。最后，我们还展示了如何在 Scheme 中实现面向对象系统，以及由此产生的接口是什么样的，以使用户能够定义类、创建实例并操作这些实例。

The oops we've created is surprisingly powerful. Indeed, some object-oriented languages like Java avoid the...

我们创建的 OOPS 出奇地强大。事实上，一些面向对象的语言如 Java 避免了……

languages like Java avoids the complexity and power and some would say complexity and power and some would say complexity and power and some would say confusion of multiple inheritance when used well object-oriented programming provides a potent way to structure and

像 Java 这样的语言避免了多继承的复杂性和力量，有些人会说复杂性和力量，有些人会说混乱。当使用得当时，面向对象编程提供了一种强大的方式来构建和