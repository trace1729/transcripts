# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=16)

## Summary (摘要)

- The lecture demonstrates the is-a and has-a relationships using a family tree example with named object, person, and mother classes.
- It explains how to define classes with local state variables and methods, such as add-child and half-child, and how these methods manipulate object relationships.
- The implementation details cover the inheritance chain: each class creates a message handler that passes unmatched messages to the parent handler.
- A step-by-step trace of the create-instance and make-person procedures shows how object instances and handlers are built in the Scheme environment model.
- The lecture illustrates message dispatch by tracing how the 'name' method is found through the chain of handlers.
- It concludes by emphasizing local state, relationships via pointers, and message passing as core features, and recommends practice with more examples.

- 本讲座通过一个包含命名对象、人和母亲类的家谱示例，演示了is-a和has-a关系。
它解释了如何定义带有局部状态变量和方法的类，例如add-child和half-child，以及这些方法如何操纵对象关系。
- 实现细节涵盖了继承链：每个类创建一个消息处理器，将未匹配的消息传递给父处理器。
- 对create-instance和make-person过程的逐步追踪展示了在Scheme环境模型中对象实例和处理器是如何构建的。
- 讲座通过追踪'name'方法如何在处理器链中被找到，说明了消息分发。
- 最后强调了局部状态、通过指针的关系以及消息传递作为核心特性，并建议通过更多示例进行练习。

## Outline (大纲)

1. Introduction to the is-a and has-a Example
2. Named Object Class Definition
3. Person and Mother Class Diagram
4. Example Usage and Instance Diagram
5. Person Class Implementation Details
6. Mother Class Implementation and half-child Method
7. Concrete Representation: Creating Instance and Handler
8. Inheritance from Named Object
9. Message Passing Example: Asking for a Name
10. Recap: Features of the Object-Oriented System

1. is-a和has-a示例简介
2. 命名对象类定义
3. Person和Mother类图
4. 示例用法和实例图
5. Person类实现细节
6. Mother类实现和half-child方法
7. 具体表示：创建实例和处理器
8. 从命名对象继承
9. 消息传递示例：询问名字
10. 回顾：面向对象系统的特性

## Transcript (转录)

### 1. Introduction to the is-a and has-a Example (is-a和has-a示例简介)

we want to do one more example to help solidify our understanding of our scheme object-oriented programming system our goal in this example is to show the difference between is ax and has a relationships our previous examples mostly explored how to define and use classes with inherited methods in this example we want to show that classes and instances can build relationships between distinct instances our example will be to implement some classes that establish family relationships between instance here's our type hierarchy a

我们想再做一次示例，以帮助巩固我们对Scheme面向对象编程系统的理解。本示例的目标是展示is-a和has-a关系之间的区别。我们之前的示例主要探讨了如何定义和使用带有继承方法的类。在本示例中，我们想展示类和实例可以在不同实例之间建立关系。我们的示例将实现一些类，以建立实例之间的家庭关系。这里是我们的类型层次结构：

instance here's our type hierarchy a mother is a kind of person which is a kind of named object which is a root object so that we have a chain of super classes but no multiple inheritance we want to look at these classes from the perspectives we've already learned about class and instance diagrams some desire behavior how we define and scheme these classes and methods and then finally how our instances are represented under the covers in a scheme environment model

实例，这里是我们的类型层次结构：母亲是人的一种，人是命名对象的一种，命名对象是根对象的一种，因此我们有一个超类链，但没有多重继承。我们想从我们已经学过的类和实例图的角度来审视这些类，一些期望的行为，我们如何在Scheme中定义这些类和方法，以及最后我们的实例在Scheme环境模型中是如何在底层表示的。

### 2. Named Object Class Definition (命名对象类定义)

first the named object class definition we've already seen this so we just note

首先是命名对象类定义，我们已经见过这个，所以我们只注意

We've already seen this, so we just note that this is a very simple class with simple the state and behavior in particular. We have a name local state variable which an outside user can access through the name method. Named objects inherit from our root object class and so support is a method as well.

我们已经见过这个，所以我们只注意这是一个非常简单的类，具有简单的状态和行为。特别是，我们有一个name局部状态变量，外部用户可以通过name方法访问它。命名对象继承自我们的根对象类，因此也支持is-a方法。

### 3. Person and Mother Class Diagram (Person和Mother类图)

Note that we also have a names of procedure defined here; this is just a handy way to get a list of names corresponding to a list of named objects. Here's our new class diagram for person and mother classes; a person will have local state variables for mother father.

注意我们还定义了一个names过程；这只是获取与命名对象列表对应的名称列表的便捷方式。这是我们新的person和mother类的类图；person将具有mother、father的局部状态变量。

local state variables for mother, father, and children. The mother variable should be a link to an object of type mother, while father will just be a link to a person object. You're, of course, welcome to create a new father subclass if you'd like to clean this up. Children will be a list of objects of type person.

局部状态变量为mother、father和children。mother变量应该是指向mother类型对象的链接，而father将只是指向person对象的链接。当然，如果您愿意，可以创建一个新的father子类来清理这一点。children将是一个person类型对象的列表。

The person class provides some methods to both access and change this state information. We see that mother inherits from, or is, a person and only provides one additional method, half child. It also overrides or extends the type method as required of all classes in our

person类提供了一些方法来访问和更改这些状态信息。我们看到mother继承自person，或者说是person的一种，并且只提供了一个额外的方法half-child。它还按照我们系统中所有类的要求，覆盖或扩展了type方法。

### 4. Example Usage and Instance Diagram (示例用法和实例图)

方法（method），这是系统内所有类所要求的。那么我们希望在类中的方法具备哪些行为呢？这里有一个使用新类的例子，它展示了其中一些行为。我们将创建一个母亲，名叫A，和一个父亲，名为Ball。我们可以询问他们的名字、类型等等。

方法（method），这是系统内所有类所要求的。那么我们希望在类中的方法具备哪些行为呢？这里有一个使用新类的例子，它展示了其中一些行为。我们将创建一个母亲，名叫A，和一个父亲，名为Ball。我们可以询问他们的名字、类型等等。

现在，我们让Anne与Ball育有一个孩子，这个孩子将被命名为Cindy。之后，我们让Anne再生一个孩子，这次命名为Ann。然后，我们可以询问Ann或Bob关于他们孩子的名字，或者问Dan他母亲的名字，并得到相应的回答。

现在，我们让Anne与Ball育有一个孩子，这个孩子将被命名为Cindy。之后，我们让Anne再生一个孩子，这次命名为Ann。然后，我们可以询问Ann或Bob关于他们孩子的名字，或者问Dan他母亲的名字，并得到相应的回答。

dan for the name of his mother and get back Ann as shown here another way to picture the results from the example behaviors in our previous slide is to draw an instance diagram here we see Ann and Bob instances each with their own lists of children we also see that Cindy and Dan are appropriately wired up with their mother and father variables to establish their parent relationships a little later we'll return to this diagram to see how our half child method accomplishes this wiring here's our person class definition this has our

dan，询问他母亲的名字，并得到Ann作为回答，如图所示。另一种描绘我们上一张幻灯片中示例行为结果的方式是绘制实例图。这里我们看到Ann和Bob实例，每个都有他们自己的子列表。我们还看到Cindy和Dan被适当地连接了mother和father变量，以建立他们的父母关系。稍后我们将回到这个图，看看我们的half-child方法如何完成这种连接。这是我们的person类定义，这有我们的

### 5. Person Class Implementation Details (Person类实现细节)

person class definition this has our standard structure but now we have both internal inheritance relationships and other local state variables for hazard.

person类定义，这有我们的标准结构，但现在我们既有内部继承关系，也有其他局部状态变量用于has-a。

to implement the inheritance of named objects we have to do three things first we have an internal named object handler called name part here second we override the type method with our standard type extent to indicate that the person type extends all of the type stuff contained in our name part third at the very bottom we use get method to pass along the message to the inherited name part.

为了实现命名对象的继承，我们必须做三件事：首先，我们有一个内部命名对象处理器，称为name-part；其次，我们用标准的type-extend覆盖type方法，以表明person类型扩展了name-part中包含的所有类型内容；第三，在底部，我们使用get-method将消息传递给继承的name-part。

the message to the inherited name part in case the message is not handled directly here now in the person class we have local variables per father mother and children in this example these are all nil by default and only gets set or changed when the various methods are a vote for example add child will add a specific trial to the internal list of children inside our person

如果消息没有直接在这里处理，则将消息传递给继承的name-part。现在在person类中，我们有局部变量father、mother和children。在这个例子中，这些默认都是nil，只有在各种方法被调用时才会被设置或更改。例如，add-child将向person内部的子列表中添加一个特定的对象。

### 6. Mother Class Implementation and half-child Method (Mother类实现和half-child方法)

in addition to mutator methods we also have access or methods like mother father and children our last class implementation is for mother this is a relatively simple class mostly just inheriting from

除了修改器方法，我们还有访问器方法，如mother、father和children。我们最后一个类实现是mother，这是一个相对简单的类，主要只是继承自

simple class mostly just inheriting from the person class with the exception of the new half child method. The job of this method is to create a new child and then wire up the various family relationships appropriately.

简单类大多只是继承自 person 类，除了新的 half-child 方法。该方法的任务是创建一个新孩子，然后适当地建立各种家庭关系。

Let's look at how the have child method works using an instance diagram to help us keep things straight. As you write object-oriented code, you will find such instance diagrams indispensable to keep track of what your system is doing. As shown here, we have the A and B instances resulting from the evaluation of the two define expressions creating.

让我们通过实例图来了解 have-child 方法是如何工作的，以帮助我们理清思路。在编写面向对象代码时，你会发现这样的实例图对于跟踪系统正在做什么是不可或缺的。如图所示，我们有两个 define 表达式求值产生的 A 和 B 实例。

Of the to define expressions creating these objects, we want to ask what happens when we evaluate and then apply the body of the half child method from inside the a instance.

对于创建这些对象的两个 define 表达式，我们想问：当我们在 a 实例内部求值并应用 half-child 方法体时会发生什么？

First, we create a new person with a specified name Cindy in this case; so far we just have the handle on this object through the child pointer. Next, we have to do the wiring: we ask the child to set its mother variable to its mother. Note that the method itself does not take the mother as an argument; however, the self variable is available and it points to the surrounding mother.

首先，我们创建一个新的人，名字指定为 Cindy；到目前为止，我们只是通过 child 指针持有这个对象的句柄。接下来，我们必须进行连接：我们要求孩子将其 mother 变量设置为其母亲。注意，方法本身并不将母亲作为参数；然而，self 变量是可用的，它指向周围的母亲。

然而，self 变量是可用的，它指向周围的母体。

然而，self 变量是可用的，它指向周围的母体。

and it points to the surrounding mother object in a similar fashion, we ask the child to set its father variable to point to the father. In this case, this pointer is available directly as an incoming argument.

并且它指向周围的母亲对象。以类似的方式，我们要求孩子将其 father 变量设置为指向父亲。在这种情况下，这个指针可以直接作为传入参数使用。

Next, we ask the mother again through the self variable to add a child, to include the new child in her list of children. And finally, we do the same for the father, so through a series of method calls, the half child method has set up the various family relationships resulting from the birth of a new child object.

接下来，我们再次通过 self 变量要求母亲添加一个孩子，将新孩子包含在她的孩子列表中。最后，我们对父亲做同样的事情，因此通过一系列方法调用，half-child 方法已经建立了由新孩子对象出生所产生的各种家庭关系。

### 7. Concrete Representation: Creating Instance and Handler (具体表示：创建实例和处理程序)

As we have seen previously, the instance diagram is an

正如我们之前所见，实例图是

previously the instance diagram is an abstract representation of objects and relationships between object instances these objects also have a concrete representation in our scheme system let's remind ourselves step-by-step of how the scheme representation of a person is created in the environment model we begin with the create person call which just results in a call to create instance as shown here so what happens first create instance calls make instance this drops a frame corresponding to the make instance call with nothing in it and then drops

之前实例图是对象以及对象实例之间关系的抽象表示。这些对象在我们的 Scheme 系统中也有具体表示。让我们逐步回顾在环境模型中如何创建一个人的 Scheme 表示。我们从 create-person 调用开始，它只是导致对 create-instance 的调用，如图所示。那么首先发生的是 create-instance 调用 make-instance，这会丢弃一个对应于 make-instance 调用的帧，其中没有任何内容，然后从该帧再丢弃另一个帧用于 let 语句。在这里，handler 变量暂时绑定到 sharp-F。然后我们求值 make-instance 中的 lambda，它创建了我们所谓的实例消息处理程序，其唯一的工作是响应 set-handler 消息（我们稍后将使用），此后将所有消息传递给 person 的实际消息处理程序。

with nothing in it and then drops another frame from this for the left statement here we have the handler variable bound for the moment - sharp F we then evaluate the lambda in make instance which creates what we call the instance message handler whose only job is to respond to the set handler message which we'll use in just a moment and thereafter to pass along all messages to the actual message handler for the person.

其中没有任何内容，然后从该帧再丢弃另一个帧用于 let 语句。在这里，handler 变量暂时绑定到 sharp-F。然后我们求值 make-instance 中的 lambda，它创建了我们所谓的实例消息处理程序，其唯一的工作是响应 set-handler 消息（我们稍后将使用），此后将所有消息传递给 person 的实际消息处理程序。

the next job of create instance in red is to apply the make person procedure with instance and name as arguments.

create-instance 的下一个工作（红色部分）是应用 make-person 过程，以 instance 和 name 作为参数。

arguments。所以现在运行 make person 过程，注意 self 被绑定到我们的整体实例对象上，同时 name 被绑定到 Cindy，这是调用 make person 时在局部帧中产生的。

参数。所以现在运行 make-person 过程，注意 self 被绑定到我们的整体实例对象上，同时 name 被绑定到 Cindy，这是调用 make-person 时在局部帧中产生的。

在 make person 内部，我们有一个 lambda 表达式，它将帧丢弃，以持有变量 mother、father、children 和 name。最后，在 lambda 的主体中，我们求值该表达式，创建消息处理过程，从而为我们提供所有针对 person 类定义的方法。

在 make-person 内部，我们有一个 lambda 表达式，它将帧丢弃，以持有变量 mother、father、children 和 name。最后，在 lambda 的主体中，我们求值该表达式，创建消息处理过程，从而为我们提供所有针对 person 类定义的方法。

See that the make person call thus gives our instance both the local state and the methods specified by our class definition for person. One additional detail: after the maker procedure for person has been called to generate this person handler, back in our instance frame we bind the variable handler to this person handler. This is done by the line shown in the create instance procedure, which uses the set handler message in the instance handler.

可以看到，make-person 调用因此为我们的实例提供了局部状态和 person 类定义所指定的方法。一个额外的细节：在调用 person 的 maker 过程生成这个 person 处理程序之后，回到我们的实例帧，我们将变量 handler 绑定到这个 person 处理程序。这是通过 create-instance 过程中显示的行完成的，该行使用实例处理程序中的 set-handler 消息。

After this, our instance message handler knows how to pass along any messages to the person handler when asked. Our object is now fully functional, with the local state and methods defined by the class, and the handler set to receive and dispatch messages effectively.

此后，我们的实例消息处理程序知道如何在被要求时将任何消息传递给 person 处理程序。我们的对象现在完全可用，具有类定义的局部状态和方法，并且处理程序已设置为有效地接收和分发消息。

### 8. Inheritance from Named Object (从命名对象继承)

Person handler when asked our object is not quite complete yet inside make person, we have a call to make named object in order to inherit the state and behavior of named objects in the same way we have seen before. This creates some local frames and local message handler for the named object, and inside the make named object procedure we have a call to make root object, which results in the creation of the root object message handler as shown here.

当被要求时，person 处理程序——我们的对象还不完全完整。在 make-person 内部，我们调用 make-named-object 以继承命名对象的状态和行为，正如我们之前看到的那样。这会为命名对象创建一些局部帧和局部消息处理程序，并且在 make-named-object 过程内部，我们调用 make-root-object，这导致创建根对象消息处理程序，如图所示。

So the overall person object generated by the innocent-looking call to create person is finally shown here in our explanation.

因此，由看似简单的 create-person 调用生成的整个 person 对象最终在我们的解释中展示出来。

person is finally shown here in our example this person instance eventually gets bound to the variable C in the global environment as one final use of our environment diagram for our new person let's consider what happens when we ask C for her name.

person 最终在我们的示例中展示出来。这个 person 实例最终绑定到全局环境中的变量 C。作为我们新 person 的环境图的最后一次使用，让我们考虑当我们询问 C 的名字时会发生什么。

### 9. Message Passing Example: Asking for a Name (消息传递示例：询问名字)

Recall that ask first calls get method on the object and then applies that method to the arguments. In this case there aren't any, so first get method is called on our person instance, which is just the instance message handler as shown here. The instance method handler doesn't find the message name locally.

回想一下，ask 首先在对象上调用 get-method，然后将该方法应用于参数。在这种情况下没有参数，所以首先在我们的 person 实例上调用 get-method，它只是实例消息处理程序，如图所示。实例方法处理程序在本地找不到 name 消息。

doesn't find the message name locally. Indeed, the only message the instant handler knows is sent handler, so it passes the message along to its bound handler. Step two then is to look in the person handler for the name. Message is not found there, so the person handler passes it along again through the call to get method at the bottom of the message handler code, this time to the internal named park handler.

在本地找不到 name 消息。实际上，实例处理程序知道的唯一消息是 sent-handler，因此它将消息传递给其绑定的处理程序。第二步是在 person 处理程序中查找 name。消息在那里找不到，因此 person 处理程序通过消息处理程序代码底部的 get-method 调用再次传递它，这次传递给内部的 named-part 处理程序。

Step three is to look in the named object handler for the name message, where it is indeed found. The return result from the name Clause in the...

第三步是在命名对象处理程序中查找 name 消息，在那里确实找到了。name 子句的返回结果在……

result from the name Clause in the message handler case statement is the lambda statement shown in step four thus

消息处理程序 case 语句中 name 子句的结果是步骤四中显示的 lambda 语句，因此

the method returned by the get method call is the procedure object corresponding to this lambda

get-method 调用返回的方法是与此 lambda 对应的过程对象

the last step is to apply this method to no arguments as shown in step 5

最后一步是将此方法应用于无参数，如步骤 5 所示。

this results in the body of the method being evaluated which is simply the expression name in the environment labeled e 2 here

这导致方法体被求值，而方法体就是环境 e2 中的表达式 name。

tracing back up the frame sequence for this environment we see that name is finally found up in the named object local frame and the value Cindy is

沿着该环境的帧序列向上追溯，我们看到 name 最终在命名对象的局部帧中被找到，其值为 Cindy。

### 10. Recap: Features of the Object-Oriented System (回顾：面向对象系统的特性)

local frame and the value Cindy is finally returned. This example has further illustrated several aspects of our object-oriented system. We have seen that classes in our system can have local state and local methods. The local state might include not only primitive data like a name, which is a symbol, but also can have variables that indicate relationships by way of pointers to other instances in the system. These relationships complement what we've seen previously, which was invocation of methods through the inheritance chain.

局部帧中的值 Cindy 最终被返回。这个例子进一步展示了我们面向对象系统的几个方面。我们看到，在我们的系统中，类可以拥有局部状态和局部方法。局部状态不仅包括原始数据（如作为符号的 name），还可以包含通过指向系统中其他实例的指针来表示关系的变量。这些关系补充了我们之前看到的通过继承链调用方法的内容。

methods through the inheritance chain in addition we have seen a further example of how instances in our system work in particular we've seen how instance creation builds up a sequence of message and state handlers for each class in the inheritance chain and then how messages get passed along this sequence of handlers to find the desired method.

除了通过继承链调用方法之外，我们还看到了系统中实例如何工作的进一步示例。特别是，我们看到了实例创建如何为继承链中的每个类构建一系列消息处理器和状态处理器，然后消息如何沿着这一系列处理器传递以找到所需的方法。

you will need to practice with more examples like these in order to gain experience in both writing object-oriented scheme code and in understanding how the object-oriented system works in scheme.

你需要通过更多这样的例子进行练习，以便在编写面向对象的 Scheme 代码和理解面向对象系统在 Scheme 中的工作原理方面获得经验。