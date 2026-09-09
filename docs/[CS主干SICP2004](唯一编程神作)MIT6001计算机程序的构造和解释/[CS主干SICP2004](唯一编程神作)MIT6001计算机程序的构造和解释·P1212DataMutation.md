# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=12)

For the past few lectures, we've been exploring the topic of data abstraction and their role in modularizing complex systems, and in particular, the relationship between data structures and the procedures that manipulate them.

在过去的几讲中，我们一直在探讨数据抽象这一主题，以及它们在将复杂系统模块化中的作用，特别是数据结构与操作这些结构的程序之间的关系。

Today, we're going to add a new aspect of that topic by looking at the issue of mutation, that is, how to change or alter a data structure rather than simply coughing it. We're gonna look at two examples of useful and interesting data structures and, in particular, show how while mutation carries some cost with it.

今天，我们将通过探讨变更（mutation）问题来为这一主题增添新的维度，即如何改变或修改一个数据结构，而不是仅仅构造它。我们将研究两个有用且有趣的数据结构的例子，并特别展示变更虽然带来一些代价，

While mutation carries some cost with it, it also supports very efficient implementations of such data structures. Just set the stage for what we're going to do today, let's review what we know about data abstractions. First of all, an abstraction comes with a constructor, that is a way of gluing pieces together into a data object. And remember that in what we saw a few lectures ago, we should probably also attach a type tag to the object as part of this constructor.

尽管变更会带来一些代价，但它也支持这些数据结构的高效实现。为了给今天的内容做铺垫，让我们回顾一下关于数据抽象我们所知道的内容。首先，一个抽象伴随着一个构造函数，即一种将各个部分粘合在一起形成数据对象的方法。并且请记住，在几讲之前我们看到的，作为构造函数的一部分，我们可能还应该给对象附加一个类型标签。

Associated with the constructor, our set of selectors or accessors that get...

与构造函数相关联的是一组选择器或访问器，它们用于……

Of selectors or accessors that get pieces back out, and these are governed by a contract that talks about the relationship between the constructor, which glues things together, and the selectors that unglue those pieces and pull out parts of the data structure.

选择器或访问器用于取回各个部分，而这些选择器受一个契约的约束，该契约规定了构造函数（将各部分粘合在一起）与选择器（将这些部分拆开并提取数据结构中的组件）之间的关系。

Finally, we saw that there would be a set of operations that use the data objects with what out worrying about the details of the implementation. The form is to use the selectors to get out the pieces, do some work to assemble the parts of a new version of the object, and then use the constructor to build up a new object out.

最后，我们看到会有一组操作，它们使用数据对象而无需担心实现的细节。其形式是使用选择器取出各个部分，进行一些工作以组装对象的新版本，然后使用构造函数构建一个新对象。

Constructor to build up a new object out of the pieces we've just built. The new thing we are adding is a mutator; this is a method that will change an existing data structure, that is going and actually alter something in the structure, as opposed to creating a new version of the object.

构造函数用我们刚刚构建的部分构建一个新对象。我们添加的新内容是修改器（mutator）；这是一种将改变现有数据结构的方法，即实际修改结构中的某些内容，而不是创建对象的新版本。

And that's what we're going to turn to, and what follows. Let's start by looking at very simple data structures. For example, we know that we combined a variable or a name to a value. This is not a complex data abstraction, but it has some of the same properties. Here, we know that the special...

这就是我们接下来要转向的内容。让我们从非常简单的数据结构开始。例如，我们知道我们可以将变量或名称与值绑定。这不是一个复杂的数据抽象，但它具有一些相同的属性。在这里，我们知道特殊的……

properties here we know that the special form defined binds the name or symbol given by the first argument to the value of the second expression to get back the value associated with a variable we just use the name itself that is when we evaluate the name it looks up the value bound to it by the define expression.

这里的属性是，我们知道特殊形式 define 将第一个参数给出的名称或符号绑定到第二个表达式的值。要取回与变量关联的值，我们只需使用名称本身，即当我们求值该名称时，它会查找由 define 表达式绑定到它的值，

returns that value in other words it pulls apart the binding of name and value and returns one component now we've introduced the ability to mutate that variable to change the binding associated with it let's look first at

并返回该值。换句话说，它拆开名称和值的绑定并返回其中一个组件。现在，我们引入了修改该变量、改变与其关联的绑定的能力。让我们首先看看

associated with it, let's look first at the expression that does that. It's shown here: open paren, set bang, X, double quote, foo, close double quote, close paren. This is again a special form and it operates as follows: it takes the first argument, X, treats it as a name; it takes the second argument, evaluates it using the normal rules of evaluation, and then it is going to change the binding associated with X.

与其关联的绑定，让我们首先看看执行该操作的表达式。它显示在这里：左括号，set!，X，双引号，foo，双引号，右括号。这又是一个特殊形式，其操作如下：它取第一个参数 X，将其视为名称；取第二个参数，使用正常的求值规则对其进行求值，然后它将改变与 X 关联的绑定。

Now, this looks a lot like a define, but it is not define. Define would simply create a binding for X. Set bang looks for the binding associated with X and actually changes it, thereby altering the existing value.

现在，这看起来很像 define，但它不是 define。Define 只会为 X 创建一个绑定。Set! 会查找与 X 关联的绑定并实际更改它，从而改变现有的值。

with X and actually changes it thereby causing the first value to be lost over. The next few lectures we'll see why set-bang is actually different than defined. But the key thing for now is that set-bang has to find a binding for a previously defined variable, in this case X, and changes its value. So what does adding mutation do to our system? Well, several things.

与 X 关联的绑定并实际更改它，从而导致第一个值丢失。在接下来的几讲中，我们将看到为什么 set! 实际上与 define 不同。但现在关键是 set! 必须找到先前定义的变量的绑定，在本例中是 X，并更改其值。那么，添加修改对我们的系统有什么影响呢？嗯，有几件事。

The first is that we've now broken the substitution model. It's okay; we're going to replace it with a better model next time around, and in fact the substitution model really

首先，我们现在打破了替换模型。没关系；我们将在下次用更好的模型来替代它，事实上，替换模型真正

事实上，替代模型真正假设的是我们处理的是函数式编程，没有变量修改或副作用。那意味着什么呢？函数式编程意味着我们可以概念上把我们的过程当作数学函数来对待。

事实上，替换模型真正假设的是我们处理的是函数式编程，没有变量修改或副作用。那意味着什么呢？函数式编程意味着我们可以概念上把我们的过程当作数学函数来对待。

我知道有些处理的是符号数据，但函数的概念仍然适用。这意味着一个过程是从输入值到输出值的映射。更重要的是，这个映射是一致的，无论我们何时进行评估。

我知道有些处理的是符号数据，但函数的概念仍然适用。这意味着一个过程是从输入值到输出值的映射。更重要的是，这个映射是一致的，无论我们何时进行评估。

To have the value 10 and then I evaluate the expression plus x5, of course I get 15. If I do a whole bunch of other intervening operations and come back and again evaluate plus x5, I will still get 15. The expression has the same value every time it's evaluated; it's the same scope as its binding and nothing has changed.

假设 X 的值为 10，然后我求值表达式 (+ x 5)，当然得到 15。如果我进行一系列其他中间操作，然后回来再次求值 (+ x 5)，我仍然会得到 15。该表达式每次求值都有相同的值；它与其绑定具有相同的作用域，并且没有任何改变。

This means that this expression has a value no matter when in time it occurs, and it really behaves like a mapping from input values to output values. Once we've introduced mutation or assignment into our language, this no longer holds.

这意味着这个表达式无论何时出现都有一个值，并且它确实表现得像从输入值到输出值的映射。一旦我们在语言中引入了修改或赋值，这就不再成立。

Assignment into our language this no longer holds in particular and expressions value now depends on when we evaluate in fact notice what term I used we've introduced time into our system in a very fundamental way now in expressions value depends on the context surrounding it that is what other expressions have been evaluated before it and identical expressions from a syntactic viewpoint may now have very different semantics because that semantics now depends on the context to see this look at the example the game we define X to have the value 10 if we

在我们的语言中引入赋值后，这不再成立。特别是，表达式的值现在取决于我们何时求值。事实上，注意我使用的术语：我们以非常基本的方式将时间引入了我们的系统。现在，表达式的值取决于它周围的上下文，即在此之前求值了哪些其他表达式。从语法角度看相同的表达式现在可能具有非常不同的语义，因为该语义现在取决于上下文。为了看到这一点，看这个例子：我们定义 X 的值为 10。如果我们

see this look at the example the game we define X to have the value 10 if we

看到这一点，看这个例子：我们定义 X 的值为 10。如果我们

define X to have the value 10 if we evaluate the expression plus x5 we of course get 15 because actually just defined to have the value 10 now sometime late we evaluate set bang X 294 remember this goes in and finds the binding or pairing of X in our environment and changes it to have the value 94 if sometime after that we again evaluate plus x5 what's the value for X well it's now 94 and in fact the value of this whole expression is now 99 notice two exactly this identical expressions plus x5 now give rise to different values even though

定义 X 的值为 10。如果我们求值表达式 (+ x 5)，我们当然得到 15，因为实际上刚刚定义 X 的值为 10。现在稍后我们求值 (set! x 294)，记住这会进入我们的环境，找到 X 的绑定或配对，并将其值改为 94。如果在那之后我们再次求值 (+ x 5)，X 的值是多少？嗯，现在是 94，实际上整个表达式的值现在是 99。注意，两个完全相同的表达式 (+ x 5) 现在产生不同的值，即使

Rise to different values even though functionally they appear identical. Time now matters in our system because we have the ability to mutate the expressions and their values. As we'll see shortly, this has some advantages for us, although it also increases some potential dangers in terms of how we set up our programs.

尽管在功能上看似相同，却会上升到不同的值。现在时间在我们的系统中变得重要，因为我们有能力修改表达式及其值。正如我们很快会看到的，这对我们有一些好处，尽管它也增加了我们在设置程序时的一些潜在危险。

Okay, not only can we mutate simple objects, we can also mutate other basic data structures. For pairs of lists, we also have mutators that change the pieces. Let's look at this just to remind you—we of course have a constructor that glues two things together.

好的，我们不仅可以修改简单对象，还可以修改其他基本数据结构。对于序对和列表，我们也有修改器来改变其组成部分。让我们看看这个，只是为了提醒你——我们当然有一个构造函数，它将两个东西粘合在一起。

构造函数和两部分组合在一起构成一对，我们有两个选择器或访问器，即car和cdr，它们能够提取出那一对的正确部分。现在我们有两个修改器，即set-car！和set-cdr！。仔细看它们的功能，每个都是一个普通的过程，它接收两个表达式，首先计算第一个参数以获取指向一个对的指针，在这种情况下是P的值。

构造函数将两部分组合在一起构成一对，我们有两个选择器或访问器，即car和cdr，它们能够提取出那一对的正确部分。现在我们有两个修改器，即set-car！和set-cdr！。仔细看它们的功能，每个都是一个普通的过程，它接收两个表达式，首先计算第一个参数以获取指向一个对的指针，在这种情况下是P的值。

然后它计算第二个表达式以获得一个新值或结构，在set-car！的情况下，其操作是取P对的car部分，而非其他。

然后它计算第二个表达式以获得一个新值或结构，在set-car！的情况下，其操作是取P对的car部分，而非其他。

car part of the pair P where rather the pair pointed to by P and change it to point to the value of new X similarly

取P所指向的序对的car部分，并将其改为指向新X的值；类似地，

set cutter bang takes the cutter part of the pair pointed to by P and changes that to point to the new value that value given by the value of new Y note

set-cdr！取P所指向的序对的cdr部分，并将其改为指向新Y的值所给出的新值。注意

the type definition associated here it takes in a pair and something of any type and what it returns is undefined because it's being used strictly for the side effect for the fact that it's going to go in and change the structure associated with the pair as we'll see

这里相关的类型定义：它接受一个序对和任意类型的东西，返回的是未定义的，因为它严格用于副作用，即它将进入并改变与该序对关联的结构，正如我们将看到的。

associated with the pair as we'll see

与该序对关联的结构，正如我们将看到的。

associated with the pair as we'll see shortly, having the ability to mutate structures certainly buys us some power in terms of our computational engine, but it also raises some interesting problems, and we want to highlight those first.

与该序对关联的结构，正如我们很快将看到的，拥有修改结构的能力确实为我们的计算引擎带来了一些力量，但也引发了一些有趣的问题，我们想首先强调这些。

For example, suppose I create a list of the elements 1 & 2 with that first define statement, and I also give the same structure the name B. That is, defining B to have the value of A will create the structure shown at the right, with both A and B pointing to the same structure. And remember, define does not create a copy of the list.

例如，假设我用第一条define语句创建了一个包含元素1和2的列表，并且我也给同一个结构命名为B。也就是说，将B定义为A的值将创建右侧所示的结构，A和B都指向同一个结构。记住，define不会创建列表的副本。

does not create a copy of the list it simply returns the value of a which is the pointer to that list structure if I asked for the value of a I'll get out the list 1 2 and if I ask for the value of B I also get out the list 1 2 as you'd expect.

不会创建列表的副本；它只是返回A的值，即指向该列表结构的指针。如果我请求A的值，我会得到列表1 2；如果我请求B的值，我也会得到列表1 2，正如你所期望的。

now suppose somewhere else in my code I evaluate the expression shown in red set car bang of a to 10 what does this do we get the value of a that's the pointer to the list structure up in the right we then get the value of 10 which is 10 and we change the car pointer of A to point 2 the value 10 we.

现在假设在我代码的其他地方，我求值红色显示的表达式(set-car! a 10)。这会做什么？我们得到A的值，即指向右侧列表结构的指针；然后我们得到10的值，即10；然后我们改变A的car指针，使其指向值10。我们

Pointer of A to point 2 the value 10. We literally break that first pointer and replace it with a second pointer now pointing to the value 10 as shown. So what well now notice that the value of B has changed. If I ask for the value of B, it points to that list structure and it returns the list 10 and 2, and yet nowhere in my code do I have anything that says I've changed B. In this simple example, we know what's happening, but you can see that there's a potential now for lots of bugs because I can go in and mutate parts of list structure. I may have the potential for confusing what.

将A的指针改为指向值10。我们字面上打破第一个指针，并用第二个指针替换它，现在指向值10，如图所示。那么，现在注意B的值已经改变了。如果我请求B的值，它指向那个列表结构，并返回列表10和2，然而在我的代码中没有任何地方表明我改变了B。在这个简单的例子中，我们知道发生了什么，但你可以看到现在存在产生大量错误的可能性，因为我可以进入并修改列表结构的部分。我可能会混淆我存储在某处的内容，并使值不再指向我认为它们指向的东西。所以现在我有两种简单的修改器：set!用于更改变量的绑定，以及set-car!和set-cdr!用于改变与序对关联的结构，因此显然也改变任何类型的列表结构。

have the potential for confusing what I'm storing in someplace and having values no longer refer to the things I thought they did. So now I have two simple kinds of mutaters: set bank to change bindings of variables, and set car bank and set coder bank that changed the structures associated with pairs and obviously therefore with any kind of list structure.

可能会混淆我存储在某处的内容，并使值不再指向我认为它们指向的东西。所以现在我有两种简单的修改器：set!用于更改变量的绑定，以及set-car!和set-cdr!用于改变与序对关联的结构，因此显然也改变任何类型的列表结构。

In order to use these mutaters, we both want to know what happens if we mutate a particular structure, and equally importantly what kind of mutation do I need to do in order to cause a desired change in a structure.

为了使用这些修改器，我们既想知道如果我们修改一个特定结构会发生什么，同样重要的是，我需要什么样的修改才能引起结构中的期望变化。

In order to cause a desired change in a list structure, for example, suppose I define the following little list structure. I'll define X to be the list of the symbol a and the symbol B. Now let's suppose I want to change that structure to have the form shown here.

为了引起列表结构中的期望变化，例如，假设我定义以下小的列表结构。我将X定义为符号a和符号B的列表。现在假设我想将该结构改变为这里所示的形式。

What do I have to do? What expression do I have to evaluate in order to cause this to happen? When you're ready to answer, hit the mouse to go on to the next part of the slide.

我必须做什么？我必须求值什么表达式才能引起这种情况发生？当你准备好回答时，点击鼠标进入幻灯片的下一部分。

Well, here it is, and we can reason this through. First, we know what we want to change. We want to change the car.

嗯，就在这里，我们可以推理一下。首先，我们知道我们想要改变什么。我们想要改变car。

want to change we want to change the car part of the second part of that list so we're going to need to evaluate quarter of X to get to the second part of the list that will give us the blue part of this structure once we have that we can do a set car on that to change the car part of that pointer and what should that point to well the list 1 2 which is the Box instructure pointer shown in red and we get that by literally evaluating list of one two so notice how we can use an expression to get a particular part of a box in point of structure and then mutate either the

想要改变，我们想要改变该列表第二部分的car部分，所以我们需要求值(cdr X)来获得列表的第二部分，这将给我们结构的蓝色部分。一旦我们有了那个，我们可以对其执行set-car!来改变那个指针的car部分，它应该指向什么？列表1 2，即红色显示的盒指针结构，我们通过字面上求值(list 1 2)得到它。所以注意我们如何使用表达式来获取盒指针结构的特定部分，然后修改该部分的car或cdr以赋予它新值。

of structure and then mutate either the car or coder part of that thing to give it a new value so it might occur to you to ask do we have a problem and what do I mean by that well given that different parts of a structure can now change in particular we can go in and mutate any part of a list structure how do we tell if two things are equivalent

结构的特定部分，然后修改该部分的car或cdr以赋予它新值。所以你可能想到问：我们有问题吗？我是什么意思？鉴于结构的不同部分现在可以改变，特别是我们可以进入并修改列表结构的任何部分，我们如何判断两个东西是否等价？

we already saw in our example a few slides ago that we could have two different names for the same structure and in that case mutating part of one structure would cause the value associated with the

我们在几页幻灯片前的例子中已经看到，我们可以有两个不同的名称指向同一个结构，在这种情况下，修改一个结构的一部分会导致与另一个名称关联的值改变。

Cause the value associated with the other name to change. Well, mutation causes us to ask the question of what does it mean for things to be equivalent. And in fact, as it suggests here, to decide that really means we have to be careful about the definition of equivalent if we want to know if two things are exactly the same object. We have a special test called EQ question mark. EQ question mark returns true if the two expressions literally point to exactly the same structure. Another way of saying that is these two things will be equivalent if making any

导致与另一个名称关联的值改变。那么，修改使我们问这个问题：事物等价意味着什么？事实上，正如这里所暗示的，要决定这一点，如果我们想知道两个东西是否是完全相同的对象，我们确实必须小心等价的定义。我们有一个特殊的测试叫做eq?。如果两个表达式字面上指向完全相同的结构，eq?返回真。另一种说法是，如果进行任何修改，这两个东西将是等价的。

things will be equivalent if making any change to one structure causes a corresponding change to the other apparent structure. So EQ in some sense is the finest level of testing of equality. On the other hand, if we simply want to know whether two objects look the same, that is, well they print out with the same kind of list structure, then we will test that with equal question mark.

如果对一个结构进行任何更改都会导致另一个明显结构发生相应更改，那么这两个事物将是等价的。因此，EQ 在某种意义上是对相等性进行测试的最精细级别。另一方面，如果我们只是想了解两个对象看起来是否相同，也就是说，它们是否以相同的列表结构打印出来，那么我们将用 equal? 来测试。

In the example shown, equal of the list 1 2 & the list 1 2 will return true; they print to the same kind of list structure, but of course we know that these two evaluations of list will.

在所示示例中，equal 对列表 1 2 和列表 1 2 将返回真；它们打印出相同类型的列表结构，但当然我们知道这两个对 list 的求值将……

That these two evaluations of list will generate different versions of the list, because they are built out of constants. And in that case, testing with EQ question mark will return false. These do not point to exactly the same structure inside of the machine.

这两个对 list 的求值将生成不同版本的列表，因为它们是由常量构建的。在这种情况下，用 EQ? 测试将返回假。它们并不指向机器内部完全相同的结构。

So we have two different ways of telling if things are equivalent, two different levels of granularity. This idea of mutation and testing of equality raises some interesting issues. Now, in particular, if we mutate an object, do we still have the same object? And the answer is yes, if we...

所以我们有两种不同的方式来判断事物是否等价，两种不同的粒度级别。这种突变和相等性测试的想法引发了一些有趣的问题。特别是，如果我们修改一个对象，我们仍然拥有同一个对象吗？答案是肯定的，如果我们……

same object and the answer is yes if we retain the same pointer to the object. Another way of saying that is if we have some list structure we have a pointer to the beginning of that list structure, we then go in and mutate some part of that list structure but keep a hold of that pointer to the beginning of the structure, then in fact we still have same object its value has changed but it is still the same object.

同一个对象，答案是肯定的，如果我们保留指向该对象的指针。换句话说，如果我们有一些列表结构，我们有一个指向该列表结构开头的指针，然后我们进入并修改该列表结构的某些部分，但保留指向该结构开头的指针，那么事实上我们仍然拥有同一个对象；它的值已经改变，但它仍然是同一个对象。

This tells us how to keep track of a particular object, how to know we have the same object. Related to that is the question of deciding when two objects actually are.

这告诉我们如何跟踪一个特定的对象，如何知道我们拥有同一个对象。与此相关的是决定两个对象实际上何时共享的问题。

deciding when two objects actually are shared between someone another or said slightly better how do we tell if parts of a data structure are actually shared across different data structures as opposed to being distinct and the answer is if we mutate one and see that the other also changes then we know they're shared

决定两个对象实际上何时在彼此之间共享，或者说得更好一点，我们如何判断数据结构的部分实际上是在不同数据结构之间共享的，而不是截然不同的。答案是，如果我们修改一个，看到另一个也改变了，那么我们就知道它们是共享的。

this again comes back to that notion of equality at the finest level if it points to the same structure any change I make to that structure will be seen by the name that points to it from the other side so what we see then is

这再次回到了最精细级别的相等性概念：如果它指向相同的结构，我对该结构所做的任何更改都将被从另一侧指向它的名称看到。所以我们看到的是……

The other side, so what we see then is that introducing mutation into our language has caused us to change how we think about equality. How do we think about the finest level of detail in our system, and that's going to raise interesting questions about identity?

从另一侧，所以我们看到的是，将突变引入我们的语言导致我们改变了对相等性的思考方式。我们如何思考系统中细节的最精细级别？这将引发关于同一性的有趣问题？

What does it mean for two objects to be the same? What does it mean for two objects similarly, it simply to be equivalent? And what does it mean for objects to share actual structure? Okay, let's see if you're catching on to this. Here are two definitions for x and y, I've created them, there are two.

两个对象相同意味着什么？类似地，两个对象仅仅等价意味着什么？对象共享实际结构又意味着什么？好的，让我们看看你是否理解了这一点。这里有 x 和 y 的两个定义，我已经创建了它们，有两个……

i've created them there are two different list structures as shown and i want to now evaluate set car of X to Y and then see what the value of x is and after doing that I want to evaluate set could or Y to be quarter of X and I want to see what the value of x is after that.

我已经创建了它们，有两个不同的列表结构，如图所示。现在我想求值 (set-car! X Y)，然后看看 x 的值是什么。之后，我想求值 (set-cdr! Y (car X))，然后看看 x 的值是什么。

take a second to think about this when you're ready click the mouse button and we'll see if you've got this.

花点时间思考一下，当你准备好时点击鼠标按钮，我们将看看你是否掌握了这一点。

okay let's evaluate set car bang of X Y first we evaluate X we get the pointer to that top level list structure as shown we also evaluate Y that's also a pointer to

好的，让我们先求值 (set-car! X Y)。首先我们求值 X，得到指向顶层列表结构的指针，如图所示。我们也求值 Y，那也是一个指向……

Also evaluate Y, that's also a pointer to a list structure. And then what do we do? We take the box and pointer structure for X, we take the car pointer of the first pair of X and change it, we break the old pointer and insert a new pointer pointing to the value of Y.

也求值 Y，那也是一个指向列表结构的指针。然后我们做什么？我们取 X 的盒子和指针结构，取 X 的第一个 pair 的 car 指针并改变它，我们打破旧指针并插入一个新指针指向 Y 的值。

If we now ask for the value of X, we can see it's a list two elements long. The first element happens to be the list one two, and the second element is simply the number for, giving us the structure shown now.

如果我们现在询问 X 的值，我们可以看到它是一个两个元素长的列表。第一个元素恰好是列表 1 2，第二个元素就是数字 4，给出如图所示的结构。

Remember that time is important. Once we have mutation, we've already changed X to have a particular structure. If we

记住时间很重要。一旦我们有了突变，我们已经将 X 改变为具有特定的结构。如果我们……

If we evaluate setting the car of Y to be the car of X, notice what happens: we get the value of Y, which is a pointer to that list structure shown at the bottom. We then are going to change the car pointer of that first pair; we break the old pointer, and the new value we have is going to point to the car of X. X is a pointer to the top-level structure; we get the car of that, and we insert the new arrow as shown.

如果我们求值 (set-cdr! Y (car X))，注意会发生什么：我们得到 Y 的值，它是指向底部所示列表结构的指针。然后我们将改变那个第一个 pair 的 cdr 指针；我们打破旧指针，新值将指向 (car X)。X 是指向顶层结构的指针；我们取其 car，并插入新箭头，如图所示。

If we now go back and ask for the value of X, it's changed. It's still a list two elements long, but

如果我们现在回去询问 X 的值，它已经改变了。它仍然是一个两个元素长的列表，但是……

still a list two elements long but notice what happens here the first element is a list also two elements long that is the list one and four no longer the list one two so we've had the ability now to change parts of this structure with some sharing going on

仍然是一个两个元素长的列表，但注意这里发生了什么：第一个元素是一个也是两个元素长的列表，即列表 1 4，不再是列表 1 2。所以我们有能力改变这个结构的部分，同时有一些共享发生。

so to summarize here are the key things we've seen we have in scheme some built-in mutators ways of changing built-in data abstractions namely variables and pairs one of which set bang is set up to change the variable or a binding the other two of which set car banks are coder bang are set up to

所以总结一下，我们所见的关键点有：在 Scheme 中，我们有一些内置的修改器，即改变内置数据抽象的方式，即变量和序对。其中一个是 set!，用于更改变量或绑定；另外两个是 set-car! 和 set-cdr!，用于……

Banks are coder bang are set up to change the Associated parts of a pair. Change the Associated parts of a pair. Change the Associated parts of a pair.

set-car! 和 set-cdr! 用于改变序对的相关部分。改变序对的相关部分。改变序对的相关部分。

And secondly, we've seen that mutation introduces some substantial complexity. In door language, it can lead to unexpected side effects and it has broken our substitution model, which is no longer sufficient.

其次，我们已经看到突变引入了相当大的复杂性。在我们的语言中，它可能导致意外的副作用，并且它打破了我们的替换模型，该模型不再足够。

We now have time inextricably intertwined into our evaluations, and that's changed the aspect of programming. No longer are things simply functional; they actually have to take into account context.

我们现在将时间不可分割地交织到我们的求值中，这改变了编程的方面。事物不再仅仅是功能性的；它们实际上必须考虑上下文。

These sound like negatives, but what we're going to see in the rest of the lecture.

这些听起来像是消极的，但我们在本讲座的其余部分将看到的是……

going to see in the rest of the lecture is how mutation also buys power for us. now what we're going to do is see how mutation can affect our means of building abstractions.

在本讲座的其余部分将看到的是突变如何也为我们带来力量。现在我们要做的是看看突变如何影响我们构建抽象的方式。

and so we're going to first build a new abstraction actually very useful on without mutation, and then see how adding mutation changes the behavior.

因此，我们将首先构建一个新的抽象，实际上没有突变也很有用，然后看看添加突变如何改变行为。

the abstraction we're going to build is called a stack, and this is something you've actually seen before. this data abstraction behaves just like a stack of dishes in a cafeteria.

我们将要构建的抽象称为栈，这实际上是你以前见过的东西。这种数据抽象的行为就像自助餐厅里的一叠盘子。

that is you can push something onto the top of the stack you can take things off at the

也就是说，你可以把某物压入栈顶，你可以从栈顶取出东西，

The stack you can take things off at the top of the stack, but those are the only operations that can affect it. This is also referred to as a last in first out data structure, since the last thing you put into the structure is the first thing you take out of it.

你可以从栈顶取出东西，但只有这些操作能影响它。这也被称为后进先出数据结构，因为你最后放入结构中的东西是你最先取出的东西。

So here's a filled out version of the template that we want. We have a constructor will call it make stack just returns an empty stack. We'll have a set of selectors that we'll have in particular as a single selector called top that returns the current top element of the stack.

所以这是我们想要的模板的完整版本。我们有一个构造函数，称之为 make-stack，它只返回一个空栈。我们将有一组选择器，特别地，我们将有一个名为 top 的选择器，它返回栈的当前栈顶元素。

current top element of the stack that's

栈的当前栈顶元素，那是

current top element of the stack that's the only thing we can take out of it, and we'll have some operations on a stack. We'll have the ability to insert a new element onto the top of the stack, we'll have the ability to return a new stack with the top element removed or deleted, and we'll have a way of testing whether a stack is empty or not.

栈的当前栈顶元素，那是我们唯一能取出的东西，并且我们将有一些对栈的操作。我们将有能力在栈顶插入一个新元素，我们将有能力返回一个删除了栈顶元素的新栈，并且我们将有一种测试栈是否为空的方法。

So notice the selector top gets us the top element of the stack, it's the only thing that gets us something directly from the stack. The operations insert and delete either push a new element onto the stack or remove an element from the stack.

所以注意，选择器 top 获取栈顶元素，它是唯一能直接从栈中获取东西的操作。操作 insert 和 delete 要么将新元素压入栈中，要么从栈中移除一个元素。

the stack or remove an element from the stack and of course empty stack as we said is just our way of telling whether there's anything in the stack to really be careful we should define what the contract is for a stack and in particular what the Associated behaviors are between the constructor the selector and the operations that manipulate a stack.

从栈中移除一个元素，当然，正如我们所说，empty-stack 只是我们判断栈中是否有东西的方法。要真正小心，我们应该定义栈的契约是什么，特别是构造函数、选择器和操作栈的操作之间的关联行为。

and here's a rather formal definition although if you work it through you'll see it makes sense to set up the contract let's let s be the name for stack that was created by our constructor and let's assume that all of

这是一个相当正式的定义，尽管如果你仔细推敲，你会发现它是有道理的。让我们让 s 成为由我们的构造函数创建的栈的名称，并假设所有

constructor and let's assume that all of the subsequent stack operations have been applied where I is the number of insertions that we've made and J is the number of deletions we've made from the stack.

构造函数，并假设所有后续的栈操作都已应用，其中 i 是我们进行的插入次数，j 是我们从栈中进行的删除次数。

then the stack contract has the following behavior if we've made more deletions than insertions we have an error make sense.

那么，栈的契约具有以下行为：如果我们进行的删除操作多于插入操作，我们就会得到一个错误，这合理。

if we've made exactly the same number of insertions and deletions then empty stack will return true and more importantly if we try and get something off the top of the stack or delete something with the stack we'll.

如果我们进行的插入和删除操作次数完全相同，那么空栈将返回真，更重要的是，如果我们试图从栈顶取出元素或对栈进行删除操作，我们将会……

or delete something with the stack we'll get an error there's nothing there. get an error there's nothing there. get an error there's nothing there. if we've made fewer deletions than insertions there should be things still left on the stack and in that case the empty stack is false. more importantly the behavior of the stack is that if we were to insert then delete something from the stack and look at the top of the stack it'll be the same as if we had not done either of those insert or delete operations.

或对栈进行删除操作，我们将会得到一个错误，因为那里什么都没有。得到一个错误，因为那里什么都没有。得到一个错误，因为那里什么都没有。如果我们进行的删除操作少于插入操作，那么栈中应该还有剩余元素，在这种情况下，空栈为假。更重要的是，栈的行为是：如果我们先插入然后从栈中删除一个元素，再查看栈顶，它将与我们没有进行这些插入或删除操作时相同。

now they're words nothing below the stack has changed and finally if we have made no more deletions than we have insertions into

现在，它们下面的栈中没有任何变化，最后，如果我们进行的删除操作不多于插入操作……

deletions than we have insertions into the stack then if we insert something on to the stack and look at the top we'll get exactly that value out for anything that we push on to the stack so we see that this contract specifies what we expected we can only push things on to the stack pop them off the top and if we do that the last thing in will be the first thing out okay we've been proceeding as we normally would in building up a data abstraction we've defined the behavior on it we've defined the contract we specified what kinds of

删除操作不多于插入操作，那么如果我们向栈中插入一个元素并查看栈顶，我们将恰好得到该值，对于任何我们压入栈中的元素都是如此。因此我们看到，这个契约指定了我们所期望的行为：我们只能将元素压入栈中，从栈顶弹出它们，如果我们这样做，最后进入的将最先出来。好的，我们一直在按照通常的方式构建数据抽象：我们定义了它的行为，定义了契约，指定了我们想要的操作类型。

The contract we specified what kinds of operations we want to have now we can go ahead and implement, and our first strategy will be a simple one. Let's just implement a stack as if it was a list. So for example, this list struck might represent a stack. The first element A will be the last thing we pushed onto the stack. B would have been the thing pushed prior to A, and D would have been the first thing pushed onto the stack. Our strategy then will simply be to insert and delete items off the stack by inserting and deleting things from the front of this.

我们指定的契约包括我们想要的操作类型，现在我们可以继续实现，而我们的第一个策略将是一个简单的策略。让我们把栈当作列表来实现。例如，这个列表结构可能表示一个栈。第一个元素 A 将是我们最后压入栈中的元素。B 将是在 A 之前压入的元素，而 D 将是第一个压入栈中的元素。我们的策略将简单地通过在这个列表的前端插入和删除元素来实现栈的插入和删除操作。

deleting things from the front of this list and of course completing the implementation should be something you're now getting somewhat familiar with. Make stack will be a procedure of no arguments that simply returns an empty list, empty stack well we'll just use null to see if it's an empty list or not. We're building on top of that earlier data abstraction. Insert will simply consignee element onto the front of a stack since the stack is represented as a list under the property of closure, costing a new element on it will give us a new list back out and of course we.

从这个列表的前端删除元素，当然，完成实现应该让你现在越来越熟悉了。make-stack 将是一个无参数过程，它只返回一个空列表；empty-stack 我们将使用 null 来检查它是否为空列表。我们构建在之前的数据抽象之上。insert 将简单地把新元素 cons 到栈的前端，因为栈被表示为列表，在闭包性质下，将新元素 cons 到它上面将给我们一个新列表返回，当然我们……

a new list back out and of course we know what we have to do with the contract delete needs to make sure that we take the right thing off of the stack here it'll check to see if we have an empty stack if we do we're in trouble we complain otherwise we take the quarter of the staff that is removed the first element and just return the rest of the stack.

一个新列表返回，当然我们知道我们必须如何处理契约。delete 需要确保我们从栈中取出正确的元素；在这里，它将检查栈是否为空，如果为空，我们就遇到麻烦了，我们会抱怨；否则，我们取栈的 cdr，即移除第一个元素，然后只返回栈的其余部分。

and of course top similarly we'll check to see is there an empty stack here in which case complain otherwise give us the value of the first element the thing at the top of the stack which

当然，top 类似地，我们将检查栈是否为空，在这种情况下抱怨，否则给出第一个元素的值，即栈顶的元素，它……

The thing at the top of the stack, which is sitting in the car, so notice how we've built on top of the list abstraction to build our stack. We've gotten the right kind of behavior, and you can convince yourself by just checking to see that the details of the contract hold for this particular implementation so far. This looks fine.

栈顶的元素，它位于 car 中，所以注意我们是如何在列表抽象之上构建我们的栈的。我们已经得到了正确的行为，你可以通过检查这个特定实现的契约细节来说服自己。到目前为止，这看起来不错。

We've just built a new two data abstraction called a stack. We built it on top of lists, and it seems like we're all set. But notice, in this particular form of implementation, our stacks do not have an identity, and that's a real.

我们刚刚构建了一个新的数据抽象，称为栈。我们把它构建在列表之上，看起来我们已经准备好了。但请注意，在这种特定的实现形式中，我们的栈没有身份，这是一个真正的问题。

have an identity and that's a real problem for example let's give the name s to a new stack and empty stack and if we evaluate as we get back this empty list now let's insert the element a into this into s that in fact returns a list with a single element eight into it but if I ask for the value of s I get back the empty list because I haven't actually changed what s is pointing to I change the list structure I added something to it but I didn't return the pointer to the beginning of that structure that's clearly a problem I don't have an identity associated with

拥有一个身份，这确实是个问题。例如，我们给一个新栈命名为 s，它是一个空栈，如果我们求值 s，我们得到这个空列表。现在让我们把元素 a 插入到 s 中，这实际上返回一个包含单个元素 a 的列表。但如果我询问 s 的值，我得到的是空列表，因为我并没有真正改变 s 所指向的内容。我改变了列表结构，我向其中添加了内容，但我没有返回指向该结构开头的指针。这显然是个问题，我没有与栈关联的身份。

don't have an identity associated with the stack worse yet I can mutate parts of the stack if I insert B into s IATA when in principle have the stack of B na but I can go ahead and change what s is pointing to to point to the value returned by this I get back just the list B so we have a problem here

没有与栈关联的身份。更糟糕的是，我可以修改栈的部分内容。如果我将 B 插入 s，原则上我应该得到栈 B，但我可以继续改变 s 所指向的内容，使其指向这个操作返回的值，我得到的只是列表 B。所以我们这里有个问题。

we haven't isolated out the stack from the operations that can manipulate it we'd really like our data abstraction to only be accessible to the contract operations and not to anything else so let's see how we're going to fix that in the next trunk so we know how to do the

我们还没有将栈与可以操作它的操作分离开来。我们确实希望我们的数据抽象只能被契约操作访问，而不能被其他任何东西访问。那么让我们看看在下一部分中我们将如何修复这个问题。

The next trunk so we know how to do the things we need here to make a better implementation of a stack. The first thing is we need to use defensive programming. Obviously we should put a tag in front of this stack, add a type to it, so we know what kind of beast we're dealing with.

在下一部分中，我们知道如何做我们需要的事情来更好地实现栈。首先，我们需要使用防御性编程。显然，我们应该在这个栈前面加一个标签，给它添加一个类型，这样我们就知道我们在处理什么样的东西。

One of the advantages of this is that it will provide an object whose identity remains even as the object mutates. What do we mean by that? Well, notice if we put a tag on the front of the object, doing it the standard way, then our stack s would look like the structure shown. It will be a list whose

这样做的一个优点是，它将提供一个对象，其身份即使在对象变化时也保持不变。我们这么说是什么意思呢？注意，如果我们按照标准方式在对象前面加一个标签，那么我们的栈 s 将看起来像所示的结构。它将是一个列表，其

structure shown it will be a list whose first element is a tag type saying it's a stack and whose could are points to the actual structure itself in this case the list that is the elements of the stack for example now when I do a delete operation on the stack the behavior I want is for the stack to get out the actual component other than the tag that is the coder part of what s points to change it mutate it to actually point to everything but the first element of the stack as shown and still leave the tag on the front in this case s still points

所示的结构。它将是一个列表，其第一个元素是一个类型标签，表明它是一个栈，而其 cdr 部分指向实际结构本身，在这种情况下，即构成栈元素的列表。例如，现在当我对栈执行删除操作时，我想要的行为是让栈取出除标签外的实际组件，即 s 所指向的 cdr 部分，改变它，使其实际指向除栈的第一个元素之外的所有内容，如图所示，并仍然将标签留在前面。在这种情况下，s 仍然指向

On the front in this case, s still points to the tag structure. All I've done is change the pieces inside, and that will fix the problems I saw previously. Notice, however, we're making a fundamental change to the abstraction.

在这种情况下，s 仍然指向标签结构。我所做的只是改变了内部的部分，这将修复我之前看到的问题。但请注意，我们正在对抽象进行根本性的改变。

We really should make sure that the user is aware of the fact that the object is mutating, so that they can deal with the abstraction correctly. And what we've proposed to do here is exactly that: we're going to change our stack to mutate the actual stack pointers, keeping the tag out front. So let's see what we need to do to change our implementation.

我们确实应该确保用户意识到对象正在变化这一事实，以便他们能够正确地处理抽象。我们在这里提议做的正是如此：我们将改变我们的栈，使其改变实际的栈指针，同时将标签保留在前面。那么让我们看看我们需要做什么来改变我们的实现。

需要改变我们的实现，来添加这个更强大的行为。首先，我们的构造函数会创建栈，它将标签栈与一个空列表粘合在一起。但这里要小心，这实际上表示我正在将两样东西粘合在一起：一个类型标签和一个代表栈本身的结构。

我们需要改变我们的实现，以添加这个更强大的行为。首先，我们的构造函数会创建栈，它将标签栈与一个空列表粘合在一起。但这里要小心，这实际上表示我正在将两样东西粘合在一起：一个类型标签和一个代表栈本身的结构。

完成之后，我可以引入一个谓词，用来判断我正在查看的是一个栈，还是仅仅是某个随处存在的列表。我该怎么做呢？栈问号会检查传入的事物是否确实是一个对。

完成之后，我可以引入一个谓词，用来判断我正在查看的是一个栈，还是仅仅是某个随处存在的列表。我该怎么做呢？栈问号会检查传入的事物是否确实是一个对。

thing passed in is in fact a pair so that I can safely go ahead and get the call that and check to see that it is the tag or symbol stack so I have a way of telling whether something is a stack before I apply any operations to it. In our previous version empty stack just realized on using null to say it's an empty list, but now we can check to make sure that in fact it is a stack object—that is, use our predicate stack—and then having been certain that we're looking at a stack, go in and see if the cutter of the stack, that is the actual implementation itself, removing the type.

传入的事物实际上是一个对，这样我就可以安全地获取其 cdr 并检查它是否是标签或符号栈，因此我可以在对其应用任何操作之前判断某物是否是一个栈。在我们之前的版本中，空栈只是通过使用 null 来判断它是一个空列表，但现在我们可以检查以确保它实际上是一个栈对象——也就是说，使用我们的谓词 stack——然后在确定我们正在查看一个栈之后，进入并查看栈的 cdr，即实际实现本身，移除类型标签。

implementation itself removing the type tag to see whether that's empty or not. So now we have a much more careful way of telling whether we have an empty stack. Our operations on stacks are now going to be mutaters, and I want to follow the convention of adding an exclamation point or a bang at the end to indicate that I'm doing that.

移除类型标签后的实际实现本身，以查看它是否为空。所以现在我们有了一个更仔细的方法来判断我们是否有一个空栈。我们对栈的操作现在将是修改器，我想遵循在末尾添加感叹号或 bang 的约定来表示我正在这样做。

Look at insert to see what it does. First, it uses defensive programming to make sure that we're actually manipulating a stack that it's labeled with the appropriate type. Assuming it is, notice how I'm going to do the right

看看 insert 做了什么。首先，它使用防御性编程来确保我们实际上在操作一个栈，并且它被标记了适当的类型。假设是这样，注意我将如何进行正确的

Notice how I'm going to do the right addition onto a stack. First, I take the cutter of the argument passed in that. That removes the type tag and gives me a pointer to the actual stack itself. I then cons a new element onto the front of that. That gives me back a new list with that element at the beginning.

注意我将如何进行正确的添加到栈上的操作。首先，我取传入参数的 cdr。这移除了类型标签，并给我一个指向实际栈本身的指针。然后我将一个新元素 cons 到该列表的前面。这给我返回一个新列表，该元素在开头。

Now I go into the stack and mutate or change the cutter pointer, the thing that points to the actual stack contents itself, to point to that new list. And then finally, because I cannot rely on what set coder returns, our return stack.

现在，我进入栈并修改或改变 cdr 指针，即指向实际栈内容的东西，使其指向那个新列表。然后最后，因为我不能依赖 set-cdr! 返回什么，我们返回栈。

what set coder returns our return stack

set-cdr! 返回什么，我们返回栈

what set coder returns our return stack as the value of the whole insert the key is to notice what I've done here I still have identity associated with the stack because I have gone in and changed parts of it without changing the overall top pointer and secondly I've used defensive programming to ensure that I'm actually manipulating a stack and thirdly I've used mutation to change the actual contents of the stack part itself having seen insert you should be able to now look at delete and convince yourself that it does the right thing and what's

set-cdr! 返回什么，我们返回栈作为整个 insert 的值。关键是注意我在这里做了什么：我仍然有与栈关联的身份，因为我进入并改变了它的部分而没有改变整体顶部指针；其次，我使用了防御性编程来确保我实际上在操作一个栈；第三，我使用了修改来改变栈部分本身的实际内容。看过 insert 之后，你应该能够现在看看 delete 并说服自己它做了正确的事情，以及什么是

that it does the right thing and what's the right thing here. The right thing here, well, basically it's to take everything but the type tag that is the coder of the element which is pointing to the contents of the stack and change that to point to everything but the first element of the stack.

它做了正确的事情，以及这里什么是正确的事情。这里正确的事情，基本上就是取除类型标签之外的所有内容，即指向栈内容的元素的 cdr，并将其改为指向除栈的第一个元素之外的所有内容。

Draw yourself a little box and pointer diagram to convince yourself this does the right thing. And as before, we'll return the value of stack to give us back the overall structure.

自己画一个盒子和指针图，以说服自己这做了正确的事情。和之前一样，我们将返回栈的值以给我们整体结构。

And finally, to get the top element of the stack, well, we just make sure that we actually have a stack.

最后，要获取栈的顶部元素，我们只需确保我们确实有一个栈。

Make sure that we actually have a stack there and if we do, we take the cooter to get the actual contents of the stack, not the type tag, and then take the car of that to return the value of the first element. So now we have things that work properly.

确保我们确实有一个栈，如果有，我们就用 cdr 来获取栈的实际内容（而不是类型标签），然后取 car 来返回第一个元素的值。这样我们现在就有了能正确工作的东西。

We've got defensive programming to preserve the types of things we have, preservation of identity of the stacks, and we can moreover not go in and do mutations indirectly on them, only through the operations of the stacks themselves. So here we see how mutation gives us additional power; it gives us the ability to change parts of a.

我们采用了防御性编程来保持我们拥有的类型，保持栈的同一性，而且我们也不能间接地对它们进行修改，只能通过栈自身的操作来进行。这里我们看到了修改如何赋予我们额外的能力；它使我们能够改变结构的部分。

The ability to change parts of a structure without using up much in the way of space and yet preserve the identity of the overall structure. Okay, we've seen how mutation can give us different ways of building data abstractions. Now let's really look at how much it helps us by looking at a slightly more complex data abstraction.

在不占用太多空间的情况下改变结构的部分，同时保持整体结构的同一性。好的，我们已经看到了修改如何为我们提供构建数据抽象的不同方式。现在让我们通过一个稍微复杂的数据抽象来看看它对我们有多大帮助。

And that's the abstraction of a cube. A cube behaves like a line, say the line in front of a movie theater. That is, you add things to the end of the queue, you take things off the front of the queue, and as a consequence that has a

那就是队列的抽象。队列的行为类似于一条线，比如电影院前面的那条线。也就是说，你在队列的末尾添加东西，从队列的前面取走东西，因此它具有

Queue and as a consequence that has a different behavior than a stack while a stack was a last in first out data structure, a queue is a first in first out data structure. That is, the first element into the data structure will be the first element out of it.

队列，因此它具有与栈不同的行为。栈是后进先出的数据结构，而队列是先进先出的数据结构。也就是说，第一个进入数据结构的数据将是第一个离开它的数据。

As with all their other data abstractions, we've got a set of operations on it. We got a constructor, will call it make. You will have an accessor that gets us the front element of the queue. We will have some mutators that actually change the structures, and because they're mutators, we know they're going to mutate the

与所有其他数据抽象一样，我们有一组操作。我们有一个构造函数，称之为 make。我们有一个访问器，可以获取队列的前端元素。我们有一些修改器，它们实际上改变结构，并且由于它们是修改器，我们知道它们将修改

we know they're going to mutate the internal components of this data abstraction will have something that inserts a new element into the queue and returns that new queue with the element at the rear of the cube and we'll have an operation or a mutator called delete queue that returns a new queue with the element at the front of the queue removed and finally we'll have an operation called empty queue that just tests whether the queue is empty or not

我们知道它们将修改这个数据抽象的内部组件。我们将有某种东西将新元素插入队列，并返回那个新队列，该队列在队列的尾部带有该元素；我们还将有一个操作或修改器，称为 delete queue，它返回一个新队列，其中队列前端的元素被移除；最后，我们将有一个称为 empty queue 的操作，它只测试队列是否为空。

and as with stacks we'll have a contract for it here let's let Q be a queue created by the constructor and let's let

与栈一样，我们也会有一个契约。这里，让 Q 是由构造函数创建的队列，并让

created by the constructor and let's let the number of queue procedures that follow be denoted by I as the number of insertions and J is the number of deletions. And furthermore let X sub I denote the item inserted into the queue.

由构造函数创建，并让后续的队列过程的数量用 I 表示插入次数，J 表示删除次数。此外，让 X 下标 i 表示插入队列中的项目。

With that notation we can then define the contract that should be associated with the queue. First, if we've tried to delete more items than we have inserted, we should get an error, obviously.

有了这个记号，我们就可以定义与队列相关联的契约。首先，如果我们尝试删除的项目多于我们插入的项目，显然应该得到一个错误。

Second, if we've deleted exactly as many items as we have inserted, then we should have an empty queue and moreover trying to get the

第二，如果我们删除的项目恰好等于我们插入的项目，那么我们应该有一个空队列，而且尝试获取

Queue and moreover trying to get the first element of the queue or to remove an element from the queue should cause an error and then the last condition should say if we have inserted more items than we have deleted then the first element of the queue should be the one that we'd expect to see the one just prior to the next deletion just as we saw with stacks.

队列，而且尝试获取队列的第一个元素或从队列中移除元素应该导致错误；最后一个条件应该说，如果我们插入的项目多于删除的项目，那么队列的第一个元素应该是我们期望看到的那个，即下一次删除之前的那个，就像我们在栈中看到的那样。

Let's start with a simple implementation of a queue and in particular let's simply represent a queue by a list of elements here we'll decide arbitrarily that the order is such that the first element of the list.

让我们从一个简单的队列实现开始，特别是让我们简单地将队列表示为一个元素列表。这里我们任意决定顺序，使得列表的第一个元素

such that the first element of the list is also the first element of the queue. So getting the first element of the queue is easy, we'll just take the car.

使得列表的第一个元素也是队列的第一个元素。所以获取队列的第一个元素很容易，我们只需取 car。

Similarly, deleting an element from the queue will simply remove that element, that is, take the cdr. But notice now that insertion is going to be more difficult.

类似地，从队列中删除一个元素将简单地移除该元素，即取 cdr。但注意现在插入将更加困难。

To insert an element into the queue, we need to put it at the end, and if we're representing things as a list, we're going to need to copy the existing queue onto the front of the new element.

要将一个元素插入队列，我们需要把它放在末尾，如果我们用列表来表示，我们将需要把现有队列复制到新元素的前面。

That is, we're going to need to literally make a copy of that entire list and add it to the beginning of a new list that has the new element as that first element. So there's our strategy: we'll represent a queue as a list, first element of the queue is the first element of the list. And with that in mind, let's see how we build an implementation.

也就是说，我们需要真正复制整个列表，并将其添加到以新元素为第一个元素的新列表的开头。所以这就是我们的策略：我们将队列表示为一个列表，队列的第一个元素是列表的第一个元素。考虑到这一点，让我们看看如何构建一个实现。

Okay, here's the code, and again it should look fairly straightforward to you. Our constructor just makes an empty list since we're using lists to represent queues. Testing to see if you have an empty queue as...

好的，这是代码，它应该看起来相当直接。我们的构造函数只是创建一个空列表，因为我们用列表来表示队列。测试队列是否为空，就像之前一样，我们将使用 null 来检查是否为空列表。要找到队列的前端，嗯，让我们确保我们有一个队列，这样我们就不会出错，如果有，我们只需取列表中第一个元素的值。

To see if you have an empty queue as before, we'll just use null to see if we have an empty list to find the front of the queue. Well, let's make sure we've got a queue so we don't have an error, and if we do, we simply take the value of the first element in the list.

要查看是否有一个空队列，和之前一样，我们只需使用 null 来查看是否有一个空列表。要找到队列的前端，嗯，让我们确保我们有一个队列，这样我们就不会出错，如果有，我们只需取列表中第一个元素的值。

Deletion from the queue, that's easy. As long as we've got a queue here, we simply remove the first element and return the remainder of the list using cutter.

从队列中删除，这很容易。只要我们有一个队列，我们只需移除第一个元素并返回列表的其余部分，使用 cdr。

Inserting an element into the queue, though, is a bit more of a pain. Remember, it's got to go at the end of the queue, so to insert an...

然而，向队列中插入一个元素则有点麻烦。记住，它必须放在队列的末尾，所以要插入一个

at the end of the queue so to insert an element into a queue we use the following little structure if we have an empty queue then it's easy we just build a queue one element long constant element ELT onto an empty queue or the in this case the empty list nil otherwise we're going to have to make a copy of what we have so we're going to cost the first element of the queue onto whatever we get by inserting the element into the remainder of the queue and of course recursively this is going to walk its way down the queue until we find the end of the queue and then glue the new

在队列的末尾，所以要将一个元素插入队列，我们使用以下小结构：如果我们有一个空队列，那么很容易，我们只需构建一个单元素队列，将元素 ELT 放到空队列上，或者在这种情况下是空列表 nil；否则，我们将不得不复制我们已有的内容，所以我们将队列的第一个元素 cons 到通过将元素插入队列其余部分而得到的结果上，当然递归地，这将沿着队列向下走，直到我们找到队列的末尾，然后将新元素粘上。

end of the queue and then glue the new element on you can see that this will satisfy the structure or the contract for queue insertion is going to something at the end of the data abstraction but you can also see is going to come with a cost so in fact let's look at that cost how efficient is this simple implementation of a queue well for queue of length n let's figure out what time is required to do operations on that queue and in particular here we're going to count the number of cons car and could er evaluations that we have to execute and

在队列末尾，然后将新元素粘上去。你可以看到，这将满足结构或契约，即队列插入是在数据抽象的一端添加元素。但你也能看到，这会带来代价。因此，让我们来看看这个代价：这个简单的队列实现效率如何？对于长度为 n 的队列，我们来计算执行操作所需的时间，特别是我们要统计必须执行的 cons、car 和 cdr 求值的次数。

element on you can see that this will satisfy the structure or the contract for queue insertion is going to something at the end of the data abstraction but you can also see is going to come with a cost so in fact let's look at that cost how efficient is this simple implementation of a queue well for queue of length n let's figure out what time is required to do operations on that queue and in particular here we're going to count the number of cons car and could er evaluations that we have to execute and

在队列末尾，然后将新元素粘上去。你可以看到，这将满足结构或契约，即队列插入是在数据抽象的一端添加元素。但你也能看到，这会带来代价。因此，让我们来看看这个代价：这个简单的队列实现效率如何？对于长度为 n 的队列，我们来计算执行操作所需的时间，特别是我们要统计必须执行的 cons、car 和 cdr 求值的次数。

going to come with a cost so in fact let's look at that cost how efficient is this simple implementation of a queue well for queue of length n let's figure out what time is required to do operations on that queue and in particular here we're going to count the number of cons car and could er evaluations that we have to execute and

这会带来代价。因此，让我们来看看这个代价：这个简单的队列实现效率如何？对于长度为 n 的队列，我们来计算执行操作所需的时间，特别是我们要统计必须执行的 cons、car 和 cdr 求值的次数。

well for queue of length n let's figure out what time is required to do operations on that queue and in particular here we're going to count the number of cons car and could er evaluations that we have to execute and

对于长度为 n 的队列，我们来计算执行操作所需的时间，特别是我们要统计必须执行的 cons、car 和 cdr 求值的次数。

number of cons car and could er evaluations that we have to execute and

必须执行的 cons、car 和 cdr 求值的次数。

evaluations that we have to execute and let's look at the space required that is how many new consoles are needed when we execute operations on this queue let's start with the easy ones finding the front element of the queue well it takes time that's simply constant that is it's a single operation to get there

必须执行的求值次数，以及让我们看看所需的空间，即执行队列操作时需要多少个新的 cons 单元。让我们从简单的开始：找到队列的前端元素。这需要的时间是常数，也就是说，只需一个操作即可到达那里。

same thing with delete queue we're just going to take the coder of the queue in this case rather than the car is a single operation in terms of time that's nice and in terms of space similarly it's constant we don't have any new

删除队列也是如此，我们只需取队列的 cdr，而不是 car，这是一个单一操作。在时间上，这很好；在空间上，同样也是常数，我们不需要任何新的……

it's constant we don't have any new

是常数，我们不需要任何新的……

it's constant we don't have any new consoles here that we have to generate we're either getting the car quarter out of a list structure so this is nice and efficient but as we've already hinted insert queues a bit more of a problem first of all what's the time associated with inserting a new element into a queue of length n well as we saw from the structure of the procedure it has to walk its way down the length of the queue to find the end and then insert a new element so it's going to be linear in terms of the number of operations required and in terms of space that is

是常数，我们不需要生成任何新的 cons 单元；我们要么从列表结构中取出 car 或 cdr，所以这既简单又高效。但正如我们已经暗示的，插入队列则更成问题。首先，向长度为 n 的队列中插入一个新元素所需的时间是多少？正如我们从过程结构中看到的，它必须沿着队列的长度走到末尾，然后插入一个新元素，所以在所需操作次数上是线性的。在空间方面，也就是……

required and in terms of space that is required and in terms of space that is how many new consoles does it chew up how many new consoles does it chew up how many new consoles does it chew up well similarly it walks its way not only well similarly it walks its way not only well similarly it walks its way not only down the queue but it makes a copy as it down the queue but it makes a copy as it down the queue but it makes a copy as it goes along consoling up a new version of goes along consoling up a new version of goes along consoling up a new version of it and therefore it's also linear in the it and therefore it's also linear in the it and therefore it's also linear in the amount of space required and of course amount of space required and of course amount of space required and of course the obvious question is can we do better the obvious question is can we do better the obvious question is can we do better so let's go back and look at queues so let's go back and look at queues so let's go back and look at queues again now seeing how mutation can allow again now seeing how mutation can allow again now seeing how mutation can allow us to build a much more efficient us to build a much more efficient us to build a much more efficient implementation as before we'll still implementation as before we'll still implementation as before we'll still have a constructor that returns an empty have a constructor that returns an empty have a constructor that returns an empty queue and an access earth at gets us the

在空间方面，也就是需要多少新的 cons 单元？同样，它不仅沿着队列走，而且边走边复制，用 cons 构建一个新版本，因此在所需空间上也是线性的。当然，显而易见的问题是：我们能做得更好吗？所以让我们回到队列，再次看看变异如何让我们构建一个更高效的实现。和之前一样，我们仍然会有一个构造函数返回一个空队列，以及一个访问器来获取队列的前端元素。

queue and an access earth at gets us the front element of the queue. The big change we're going to make is how we actually put things into and out of the queue. In particular, inserting and deleting elements from the queue. Here, let's do the following: rather than making a copy of the queue and adding a new element at the end, or the rear, of that queue, we're going to go in and actually mutate or modify the structure to directly insert the element at the end.

队列的前端元素。我们要做的重大改变是如何实际将元素放入和取出队列。特别是，从队列中插入和删除元素。在这里，我们这样做：与其复制队列并在其末尾（或 rear）添加新元素，不如直接进入并实际变异或修改结构，将元素直接插入末尾。

So here, we're going to take mutation directly on the structure. Similarly, when we remove an element from the front of the queue...

所以在这里，我们直接对结构进行变异。类似地，当我们从队列前端移除一个元素时……

we remove an element from the front of the queue we're going to mutate that structure not make copies of it and here's the strategy will use as before we'll attach a type tag at the front as a defensive measure so we can identify what kinds of structures we have and to give us a way of maintaining identity of the structure

当我们从队列前端移除一个元素时，我们将变异那个结构，而不是复制它。这是我们使用的策略：和之前一样，我们会在前端附加一个类型标签作为防御措施，以便识别我们拥有的结构类型，并为我们提供一种维护结构身份的方法。

secondly we'll build a structure that holds a list of items in the queue plus two things a pointer to the front of the queue and a pointer to the rear of the queue now we have many ways in which we could do that

其次，我们将构建一个结构，其中包含队列中的项目列表，以及两样东西：一个指向队列前端的指针和一个指向队列后端的指针。现在，我们有很多方法可以做到这一点。

have many ways in which we could do that, but the easiest one is the one shown in the structure that is our queue will be a list whose first element is the type tag Q and whose second element is a pointer to of cards pair that has a pointer to the front and rear of the queue.

有很多方法可以做到这一点，但最简单的是结构中显示的那个：我们的队列将是一个列表，其第一个元素是类型标签 Q，第二个元素是一个指向序对的指针，该序对具有指向队列前端和后端的指针。

that is it literally has a pointer to the first pair in the list that represents the Q and a pointer to the last pair in the list that represents the Q the underlying representation is still a list but now notice we're going to have direct access to the beginning and end of the queue and that's going to

也就是说，它实际上有一个指针指向表示队列的列表中的第一对，还有一个指针指向表示队列的列表中的最后一对。底层表示仍然是一个列表，但现在注意，我们将直接访问队列的开头和结尾，这将

and end of the queue and that's going to help us make much more efficient operations on top of queues given that idea we can create some procedures that are going to manipulate the parts of the queue and as the slide says these should really be hidden inside the abstraction they should be hidden away from the user and only available to things that directly manipulate the queue first of all to get the front pointer of the queue well we'll take the quarter to strip off the type tag and then we'll take the car of that pair to get us the

队列的开头和结尾，这将帮助我们更高效地在队列之上进行操作。基于这个想法，我们可以创建一些过程来操作队列的各个部分，正如幻灯片所说，这些过程应该真正隐藏在抽象内部，对用户隐藏，只对直接操作队列的东西可用。首先，要获取队列的前指针，我们将取队列的 cdr 去掉类型标签，然后取该对的 car 来得到

Take the car of that pair to get us the pointer to the front. If you go back to the previous slide, you'll see that gives us exactly the right thing. Rear pointer, similarly, we'll take coder of the thing to strip off the type tag, and then take coder of that new element to get the pointer to the rear of the queue.

取该对的 car 来得到指向前端的指针。如果你回到上一张幻灯片，你会看到这正好给出了正确的东西。后指针类似地，我们将取队列的 cdr 去掉类型标签，然后取这个新元素的 cdr 来得到指向队列后端的指针。

Both of these structures will return us pointers to pairs in the list that actually represents the queue. Then, given that we have a thing that gives us the front pointer and the rear pointer of the queue, we want to be able to change them, so we'll have two

这两种结构都会返回指向实际表示队列的列表中对的指针。然后，既然我们有东西能给出队列的前指针和后指针，我们希望能够改变它们，所以我们将有两个

to change them so we'll have two mutaters to change the front pointer to point to a new element we'll do the following we'll take the coder of the queue that gives us the actual pair that contains both pointers and we'll change the car part of that which is where the front pointer is to point to a new item and similarly for changing the rear pointer will take quarter of the cue to strip off the type tag and give us the pair that points to the two parts of the queue and we'll change the quarter point of that which is the rear pointer to

改变它们，所以我们将有两个修改器来改变前指针指向一个新元素，我们将做以下操作：取队列的 cdr，得到包含两个指针的实际对，然后改变它的 car 部分（即前指针所在的位置）指向一个新项。类似地，对于改变后指针，我们将取队列的 cdr 去掉类型标签，得到指向队列两个部分的对，然后改变它的 cdr 部分（即后指针）指向

of that which is the rear pointer to point to some new thing now using those point to some new thing now using those point to some new thing now using those ideas we can build a much better q implementation first of all our constructor has a slightly unusual form look at it carefully we first cost together two empty lists these are the two empty pointers for the front and rear of the queue because we have nothing initially in the queue so there's an empty list there and then on top of that we can't saw on the tag queue draw yourself a little box and pointer diagram to see that this generates the structure you'd expect of

它的 cdr 部分（即后指针）指向某个新东西。现在利用这些想法，我们可以构建一个更好的队列实现。首先，我们的构造函数有一个稍微不寻常的形式，仔细看：我们首先将两个空列表连接在一起，这两个是队列前端和后端的空指针，因为初始时队列中没有东西，所以那里有一个空列表，然后在上面我们加上队列标签。自己画一个盒子和指针图，看看这生成了你期望的结构，

Generates the structure you'd expect, of course, with this defensive programming in place. We can also now have a predicate that tells us whether we're actually looking at a queue by making sure it's a pair and then checking to see that the tag is the symbol Q. To see if we have an empty queue, we can be very clever now: we can first check to make sure that there is an actual queue there.

生成了你期望的结构，当然，有了这种防御性编程。我们现在也可以有一个谓词来判断我们是否真的在看一个队列，通过确保它是一个对，然后检查标签是否是符号 Q。要判断是否为空队列，我们现在可以非常聪明：我们可以首先检查确保那里确实有一个队列。

Notice how we're using defensive programming to isolate ourselves out from unexpected side effects, presuming that in fact we are looking at a structure labeled to be a queue. Then we proceed.

注意我们如何使用防御性编程来隔离意外的副作用，假设我们确实在看一个标记为队列的结构。然后我们继续。

structure labeled to be a queue then we take the front pointer of the queue and check to see if it's empty if it is there's nothing in the queue therefore it's an empty queue so far we're just using defensive programming

标记为队列的结构，然后我们取队列的前指针，检查它是否为空。如果是，队列中没有任何东西，因此它是一个空队列。到目前为止，我们只是在用防御性编程。

and the next element looks much the same front of the queue a game we'll check to see if we actually have a structure there and presuming we do we take the front pointer to get the pointer to the beginning of the list that represents the actual elements and then take the car of that to get the first element in the queue itself the tricky parts common

下一个元素看起来也差不多。队列的前端，我们再次检查是否确实有一个结构，假设有，我们取前指针得到指向表示实际元素的列表开头的指针，然后取它的 car 得到队列中的第一个元素。棘手的部分常见的是

The queue itself, the tricky parts common, actually manipulating the queue where we want to mutate the structure that represents the actual elements of the queue. First, let's look at insert. To insert a new element into the queue, we need to do the following. Well, first create a list with just the element in it. This will be the end of the new queue once we put it together. We'll give it a name just temporarily, let's call it new pair. Now, if there's nothing in the queue, then this structure represents actually the queue I want to have, so I simply go in and change the.

队列本身，棘手的部分常见的是实际操作队列，即我们想要修改表示队列实际元素的结构。首先，让我们看看插入。要将一个新元素插入队列，我们需要做以下事情。首先，创建一个只包含该元素的列表。这将是新队列的末尾，一旦我们把它组合起来。我们暂时给它一个名字，叫它 new pair。现在，如果队列中没有任何东西，那么这个结构实际上就代表了我想要的队列，所以我只需进去改变

Have so I simply go in and change the front and rear pointers to point to this list, a list now one element long, and then I'll return the value of Q is the value of the overall structure. If however there is already something in the queue, then I need to do the following. First, I'm going to get the rear pointer to the queue. Remember this will be a pointer to the last pair in the current element of the queue, and then what do I do? I mutate the coder of that pair to point to the new pair. Think carefully about what this does. This now creates a new list, but in fact it does

所以我只需进去改变前指针和后指针，让它们指向这个列表，一个现在只有一个元素的列表，然后我将返回 Q 的值，即整个结构的值。然而，如果队列中已经有东西，那么我需要做以下事情。首先，我要获取队列的后指针。记住这将是指向当前队列元素中最后一对的指针，然后我该怎么做？我修改那对的 cdr 指向新对。仔细想想这是做什么的。这现在创建了一个新列表，但实际上它

creates a new list but in fact it does it by mutating the end of the list to point to this new list structure the new element that I added in. You should convince yourself that this still leaves a list in place but also that notice is going to do it in much more efficient time than we did before.

创建了一个新列表，但实际上它是通过修改列表的末尾指向这个新列表结构（我添加的新元素）来实现的。你应该说服自己，这仍然留下一个列表，但也要注意，这将比以前更高效地完成。

Of course I have to preserve the overall structure of the queue. I've added a new element to the list but now my rear pointer is out of date, so I change the rear pointer to point to this new pair. Again, you ought to draw a little box and pointer diagram.

当然，我必须保持队列的整体结构。我已经向列表中添加了一个新元素，但现在我的后指针过时了，所以我改变后指针指向这个新对。同样，你应该画一个盒子和指针图。

To draw a little box and pointer diagram to convince yourself that this has set up things in the right format and deleting an element from the queue has a similar behavior. First of all, if it's an empty queue, of course we're going to complain. Otherwise, notice what we need to do: we first get the front pointer to the queue, that's going to point at the beginning of the list. We take the quarter of that, which removes the first element from the list and gives us a pointer to the rest of the list representing the elements of the queue, and then we change the front pointer of the queue.

画一个盒子和指针图来说服自己，这已经以正确的格式建立了事物，并且从队列中删除一个元素也有类似的行为。首先，如果它是一个空队列，我们当然会报错。否则，注意我们需要做什么：我们首先获取队列的前端指针，它将指向列表的开头。我们取它的 cdr，这会从列表中移除第一个元素，并给我们一个指向列表其余部分的指针，代表队列的元素，然后我们改变队列的前端指针。

And then we change the front pointer of the overall queue to point to that structure again. If you're not certain, draw a little box and pointer diagram and run an operation to see that this leaves everything in the right form.

然后我们改变整个队列的前端指针，使其再次指向那个结构。如果你不确定，画一个盒子和指针图，运行一个操作，看看这是否使一切保持正确的形式。

So what are the orders of growth now? Well, you should be able to reason things through and realize that in this case, the two expensive operations, insert and delete, are now both constant in terms of time and space.

那么现在的增长阶是什么？你应该能够推理清楚，并意识到在这种情况下，两个昂贵的操作，插入和删除，现在在时间和空间上都是常数阶的。

And as a consequence, mutation has given us a much more efficient way of building abstract data abstractions. So you've seen that we can.

因此，变异给了我们一种更高效的方式来构建抽象数据抽象。所以你已经看到我们可以。

Abstractions so you've seen that we can add mutation to our data abstractions. Mutations are things that operate by side effects; they go in and change the actual values of data structures rather than simply creating new versions of them. And in particular, we saw three kinds: set-bang, which changes the values associated with variables, and set-car-bang and set-cdr-bang that change portions of a pair and therefore any other list structure.

抽象，所以你已经看到我们可以将变异添加到我们的数据抽象中。变异是通过副作用来操作的事物；它们进入并改变数据结构的实际值，而不是简单地创建它们的新版本。特别是，我们看到了三种：set!，它改变与变量关联的值，以及 set-car! 和 set-cdr!，它们改变序对的部分，因此也改变任何其他列表结构。

We can use that idea to actually extend our notion of a data abstraction to include mutators as part of it, and we can see as a...

我们可以利用这个想法来扩展我们对数据抽象的概念，将修改器作为其一部分，并且我们可以看到作为...

Part of it, and we can see as a consequence that we gained some real power. We get much more efficient data structures by having the ability to mutate them.

作为其一部分，并且我们可以看到，作为结果，我们获得了一些真正的力量。通过拥有修改它们的能力，我们得到了更高效的数据结构。

But we can also cause some interesting problems doing this. And in particular, by introducing mutation into our language, we've added a notion of time to our language. Things are no longer functional in terms of programming style. Substitution model no longer works, and we're going to have to

但这样做也会引起一些有趣的问题。特别是，通过在我们的语言中引入变异，我们为语言添加了时间的概念。事物在编程风格上不再具有功能性。替换模型不再有效，我们将不得不

longer works and we're going to have to

不再有效，我们将不得不