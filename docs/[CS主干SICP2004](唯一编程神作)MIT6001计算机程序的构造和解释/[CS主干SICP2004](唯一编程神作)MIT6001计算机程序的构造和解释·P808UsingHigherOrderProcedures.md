# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=8)

## Summary (摘要)

- The lecture demonstrates the integration of data abstraction and procedural abstraction by building a language to describe pictures, exemplified by MC Escher's 'Square Limit'.
- Pictures are represented as procedures that take a frame (a rectangle) and draw lines within it, separating the data (list of segments) from the drawing action, allowing flexible transformations like rotation and scaling.
- Closure is a key property: pictures can be combined via higher-order procedures like beside and above, producing new pictures that can be further combined, enabling recursive patterns like pushing George into a corner.
- The abstraction barrier ensures that changes to internal representations (e.g., vectors as lists) do not affect code that uses constructors and selectors, maintaining robustness.
- By embedding the picture language in Scheme, the system inherits recursion, naming, and higher-order procedures, turning the problem of drawing Escher-like art into a modular and reusable language.
- The lecture concludes that building a domain-specific language with natural primitives, means of combination, and means of abstraction is a powerful and recurring idea in computer science.

- 本讲座通过构建一种描述图片的语言，展示了数据抽象与过程抽象的整合，以MC埃舍尔的《方形极限》为例。
图片被表示为接受一个框架（矩形）并在其中绘制线条的过程，将数据（线段列表）与绘图动作分离，从而允许灵活的变换，如旋转和缩放。
- 闭包是一个关键属性：图片可以通过高阶过程（如beside和above）进行组合，产生新的图片，这些新图片可以进一步组合，从而实现递归模式，如将乔治推入角落。
- 抽象屏障确保内部表示的变化（例如，向量作为列表）不会影响使用构造函数和选择器的代码，从而保持健壮性。
- 通过将图片语言嵌入Scheme，系统继承了递归、命名和高阶过程，将绘制埃舍尔式艺术的问题转化为一个模块化且可复用的语言。
- 讲座总结道，构建一个具有自然原语、组合手段和抽象手段的领域特定语言是计算机科学中一个强大且反复出现的理念。

## Outline (大纲)

1. Introduction and Theme Integration / Procedural Abstractions and Means of Combination / Goal: Building a Language for a Problem Domain
2. Initial Pitfalls in Describing a Picture
3. Data Abstraction for Vectors and Segments
4. Lists and the Closure Property
5. Building George Using Lists and Frames / Frame Abstraction and Insulating Details
6. Pictures as Procedures and Vector Operations
7. Implementing Make-Picture and Generalizing to Arbitrary Frames
8. Combining Pictures and Closure
9. Recursive Application and Achieving Escher-like Results
10. Abstraction and Building a Language

1. 引言与主题整合 / 过程抽象与组合手段 / 目标：为问题领域构建语言
2. 描述图片时的初始陷阱
3. 向量与线段的数据抽象
4. 列表与闭包性质
5. 使用列表和框架构建乔治 / 框架抽象与细节隔离
6. 图片作为过程与向量运算
7. 实现Make-Picture并推广到任意框架
8. 组合图片与闭包
9. 递归应用与实现埃舍尔式效果
10. 抽象与构建语言

## Transcript (转录)

### 1. Introduction and Theme Integration / Procedural Abstractions and Means of Combination / Goal: Building a Language for a Problem Domain (引言与主题整合 / 过程抽象与组合手段 / 目标：为问题领域构建语言)

In this lecture we are going to go back to several themes that we've been exploring over the past few weeks and stitch them together into a single demonstration. We're going to see how quickly we can describe and control a complex system by using the tools we have been building for dealing with abstractions.

在本讲座中，我们将回顾过去几周探索的几个主题，并将它们整合到一个演示中。我们将看到，通过使用我们一直在构建的用于处理抽象的工具，我们能够多么迅速地描述和控制一个复杂系统。

The themes that we are going to stitch together include the following. First, we're going to build on the idea of data abstraction, especially the idea of separating the use of a data structure from the details of its

我们将整合的主题包括以下内容。首先，我们将建立在数据抽象的思想之上，特别是将数据结构的使用与其细节分离的思想。

structure from the details of its implementation we're going to see how that abstraction barrier enables us to quickly describe complex structures without getting lost in their details.

我们将看到，这种抽象屏障如何使我们能够快速描述复杂结构，而不会迷失在细节中。

and how to focus on the use of such structures as entire units while being assured that the interior details will be handled correctly.

以及如何将注意力集中在将此类结构作为整体单元使用上，同时确信内部细节将被正确处理。

we're also going to build on the idea of procedural abstractions the complement of a data abstraction and especially on the idea of capturing common patterns inside a black box and using such abstractions to capture more complex patterns.

我们还将建立在过程抽象的思想之上，这是数据抽象的补充，特别是将常见模式封装在黑盒中，并利用这种抽象来捕获更复杂的模式。

capture more complex patterns third we're going to build on the idea of means of combination that is the idea that we can create simple methods for combining primitive objects into complex things then treating the result is a primitive within a still more complex thing

第三，我们将建立在组合手段的思想之上，即我们可以创建简单的方法将原始对象组合成复杂事物，然后将结果视为更复杂事物中的原始元素。

this will allow us to control complexity by utilizing a modular description or decomposition of the problem domain

这将使我们能够通过利用问题领域的模块化描述或分解来控制复杂性。

so our goal then is to pull these pieces together to build a new language one that is specifically designed for a particular problem

因此，我们的目标是将这些部分整合起来，构建一种新的语言，一种专门为特定问题设计的语言。

so what problem domain should we use well

那么我们应该使用什么问题领域呢？

What problem domain should we use? Well, we're going to create a language that describes pictures such as this famous one by MC Escher called Quadrat Limit or Square Limit. Not only will our language let us describe the process by which such pictures can be created, it will also let us create our own variations on this scene, leading to pictures that have much of a resemblance to the kind of elegant structure shown here in this air print.

我们应该使用什么问题领域呢？我们将创建一种描述图片的语言，例如MC埃舍尔的这幅著名作品《方形极限》。我们的语言不仅能让我们描述创作此类图片的过程，还能让我们创作出这个场景的变体，从而产生与这幅版画中优雅结构相似的图片。

### 2. Initial Pitfalls in Describing a Picture (描述图片时的初始陷阱)

So how do we describe such a system? Well, let's start with some simple examples. Here's a picture of my friend.

那么我们如何描述这样一个系统呢？让我们从一些简单的例子开始。这是我朋友的一张照片。

examples here's a picture of my friend

例子，这是我朋友的照片。

examples here's a picture of my friend George I can start by thinking about at an abstract level what kinds of things would I like to do with this picture first I might like to flip him either about the vertical axis or about the horizontal one by this I mean literally taking this portrait of George and spinning it 180 degrees out of the plane then setting it back down alternatively I might like to rotate him about an axis coming out of the picture causing him to do a cartwheel as I rotate his picture by increments of 90 degrees conceptually this is easy if I think of

例子，这是我朋友乔治的照片。我可以从抽象层面开始思考，我想对这张照片做哪些事情？首先，我可能想翻转他，无论是绕垂直轴还是水平轴。我的意思是，字面上拿起乔治的肖像，将其旋转180度出平面，然后放回去。或者，我可能想让他绕一个从图片中出来的轴旋转，使他翻跟头，因为我以90度的增量旋转他的图片。概念上这很容易，如果我想……

概念上这很容易，如果我把George想象成一张图片，我可以轻松地想象抓住整张图片并对它做些什么。但在实践中我该如何做到这一点呢？

概念上这很容易，如果我把乔治想象成一张图片，我可以轻松地想象抓住整张图片并对它做些什么。但在实践中我该如何做到这一点呢？

这里有一种直接的方法：假设我们有一些基本的绘图方法，称为draw line，它接收一个矩形作为输入，以及一组坐标值，即x和y的起点和终点，并在该矩形内从起点到终点绘制线条。注意，矩形的细节并不重要，我们只是将它们隐藏在抽象之下。因此，第一个表达式

这里有一种直接的方法：假设我们有一些基本的绘图方法，称为draw line，它接收一个矩形作为输入，以及一组坐标值，即x和y的起点和终点，并在该矩形内从起点到终点绘制线条。注意，矩形的细节并不重要，我们只是将它们隐藏在抽象之下。因此，第一个表达式

抽象，因此第一个表达式会绘制一条线，起点在左下角右侧0.25个单位处，终点在距左下角0.35个单位右侧和0.5个单位上方的位置。

抽象，因此第一个表达式会绘制一条线，起点在左下角右侧0.25个单位处，终点在距左下角0.35个单位右侧和0.5个单位上方的位置。

这里有乔治的定义，注意它做了什么：每个表达式给出一个起点和终点，相对于矩形的原点，然后绘制一条线。接着我们按照刚才建议的方式画出草图。

这里有乔治的定义，注意它做了什么：每个表达式给出一个起点和终点，相对于矩形的原点，然后绘制一条线。接着我们按照刚才建议的方式画出草图。

唉，这太具体了，对吧？给定乔治的这个定义，我如何创建一个旋转的乔治或翻转的乔治？

唉，这太具体了，对吧？给定乔治的这个定义，我如何创建一个旋转的乔治或翻转的乔治？

create a rotated George or a flip George it's not obvious and for an important reason here I have intertwined the action of drawing with the data representing George I've not separated those two pieces and moreover I've chosen a very low level representation for the elements of George I really need to isolate those two aspects if I'm going to have any hope of drawing different pictures of George so let's fix this basically we need some data abstractions to isolate points from the use of those points and we can start by asking what is a point or a vector well it's just a

创建一个旋转的乔治或翻转的乔治？这并不明显，而且有一个重要的原因：在这里，我将绘图动作与表示乔治的数据交织在一起。我没有将这两部分分开，而且我为乔治的元素选择了一个非常低级的表示。如果我希望有机会绘制乔治的不同图片，我真的需要隔离这两个方面。所以让我们修复这个问题。基本上，我们需要一些数据抽象来将点与点的使用隔离开来，我们可以从问什么是点或向量开始。嗯，它只是一个……

### 3. Data Abstraction for Vectors and Segments (向量与线段的数据抽象)

is a point or a vector well it's just a way of gluing together an x-coordinate and a y-coordinate so we can create an abstraction for this it simply has a constructor called make vector and two selectors called X core and y core. Notice that the key point here is the inherent contract between these two components. Whatever method we use to glue things together in that constructor, we can get the parts back out using the selectors, but the actual details of how we do that don't matter.

一个点或一个向量，其实就是将x坐标和y坐标粘合在一起的一种方式，因此我们可以为此创建一个抽象，它有一个名为 make vector 的构造函数和两个选择器 X core 和 y core。注意，这里的关键点在于这两个组件之间固有的契约。无论我们在构造函数中使用什么方法将事物粘合在一起，我们都可以使用选择器将部分取回，但实际的操作细节并不重要。

two things that want to simply you. Similarly, we can glue to end points or

两件想要简化的事情。类似地，我们可以将两个端点或

similarly we can glue to end points or vectors together to create a line segment this again is a data abstraction with the contract between the constructor make segments in this case and the selectors start segment and end segment

类似地，我们可以将两个端点或向量粘合在一起以创建一条线段，这同样是一个数据抽象，在构造函数 make segments（本例中）与选择器 start segment 和 end segment 之间具有契约。

so this gives us a way of abstracting vectors and segments note the key point I don't need to know the details of how chosen segments are built i just rely on the contract this means we can think of George in terms of the appropriate elements namely lines rather than details of how those lines are represented

因此，这为我们提供了一种抽象向量和线段的方法。注意关键点：我不需要知道所选线段是如何构建的细节，我只依赖契约。这意味着我们可以用适当的元素（即线条）来思考 George，而不是考虑这些线条如何被表示的细节。

represented so here is George in this format now it looks like we've just put some window dressing around the line segments but hang on as we will see how treating George's and abstraction is going to make life much easier for us in particular note that here we've created an abstraction for the points and a separate abstraction for the line segments moreover these are now defined with respect to some coordinate frame they're not actually being drawn yet so we've also separated the act of drawing from the representation of the data to

表示。所以这是 George 在这种格式下的样子。现在看起来我们只是在线段周围加了一些装饰，但等等，正如我们将看到的，将 George 视为一种抽象将如何使我们的生活变得更容易。特别要注意，这里我们为点创建了一个抽象，为线段创建了另一个独立的抽象。此外，这些现在是相对于某个坐标框架定义的，它们实际上还没有被绘制，因此我们也把绘制行为与待绘制数据的表示分离开来。

from the representation of the data to be drawn first though how do we actually build these vectors in segments well you saw this in the last lecture four pairs of things things that come naturally in twos we just use a console or a pair for larger collections we can use lists and of course lists are simply sequences of consoles glued together into a spine with the elements hanging off of them

与待绘制数据的表示分离开来。不过首先，我们实际上如何构建这些向量和线段呢？你在上一讲中看到了，对于成对出现的事物，我们只需使用 cons 或 pair；对于更大的集合，我们可以使用列表，当然列表就是将 cons 单元串成一条脊骨，元素悬挂在它们上面。

### 4. Lists and the Closure Property (列表与闭包性质)

remember that there are several important properties to pairs and lists they have a contract between constructors and selectors they also have the property of closure that is

记住，对和列表有几个重要的性质：它们在构造函数和选择器之间有契约，它们也具有闭包的性质，即

Have the property of closure, that is, that the result of creating an instance of an object can itself be used to create a new object. This is worth exploring a bit more carefully. So let's ask the question: what is a list by definition? It's a sequence of pairs ending in a special symbol nil or empty list.

具有闭包的性质，即创建一个对象的实例的结果本身可以用来创建新对象。这值得更仔细地探讨。那么让我们问一个问题：列表的定义是什么？它是一系列以特殊符号 nil 或空列表结尾的对。

That's Consing anything on to a list gives you a new sequence of pairs ending in the empty list and hence is a list. Similarly, taking the quarter of a sequence of pairs any in the empty list results in a shorter sequence of pairs ending in the empty list and hence is

将任何东西 cons 到列表上会得到一个新的以空列表结尾的对序列，因此它就是一个列表。类似地，取一个以空列表结尾的对序列的 cdr 会得到一个更短的以空列表结尾的对序列，因此它也是

ending in the empty list and hence is also a list and thus lists are closed under the operations of constant coder. Note that this is not quite right, because what happens if you try to take the quarter of nil well an MIT scheme you get an error and this says that there's a consequence this thing we just stated was not quite right.

以空列表结尾，因此也是一个列表。这样，列表在 cons 和 cdr 操作下是封闭的。注意，这并不完全正确，因为如果你尝试对 nil 取 cdr 会发生什么？在 MIT Scheme 中你会得到一个错误，这说明我们刚才陈述的东西有一个后果，即并不完全正确。

But the definition would really be better to just return the empty list in order to show that closure holds on everything including taking the quitter of the empty list also notice that it would really be better to have distinctive.

但定义实际上最好返回空列表，以表明闭包性质在所有情况下都成立，包括对空列表取 cdr。另外注意，最好有区分性的

Really be better to have distinctive operations for lists as compared to pairs. For example, we should really use something like adjoint, first, and rest instead of cons, car, and coder to distinguish operations on lists from operations on pairs. For historical reasons, we stick with the latter even though it would be better to use this more conceptually cleaner vert.

最好有区分列表和对的操作。例如，我们应该使用类似 adjoint、first 和 rest 这样的名称，而不是 cons、car 和 cdr，以区分对列表的操作和对对的操作。由于历史原因，我们坚持使用后者，尽管使用概念上更清晰的版本会更好。

So we can use this to build a specific version of our abstraction. Notice how our abstraction for both vectors and for segments nicely inherits its contract from the underlying contract for pairs and lists.

因此我们可以用这个来构建我们抽象的一个特定版本。注意，我们对向量和线段的抽象如何很好地从对和列表的底层契约中继承了其契约。

### 5. Building George Using Lists and Frames / Frame Abstraction and Insulating Details (使用列表和框架构建 George / 框架抽象与细节隔离)

underlying contract for pairs and lists, and also notice how points create a nested structure beneath lines that is a line segment is a list of two elements, each of which points to another abstraction namely a pair representing event.

对和列表的底层契约，还要注意点如何在线条之下创建嵌套结构，即一条线段是一个包含两个元素的列表，每个元素指向另一个抽象，即表示一个点的对。

okay now let's put the pieces together George is just defined as a collection, a list in this case, a collection of line segments. All we need to do is take a rectangular frame which is just a pair of orthogonal line segments and draw those initial segments within that rectangle.

好了，现在让我们把各个部分组合起来。George 只是被定义为一个集合，本例中是一个列表，一个线段的集合。我们所要做的就是取一个矩形框架，它只是一对正交的线段，并在该矩形内绘制那些初始线段。

thinking towards the kinds of operations we did on George earlier we would like to be able to draw George in different frames so we would like to be able to define any frame either of different size or even non orthogonal and draw George inside of it what does that mean ideally we could take George defined as a set of segments within a frame and stretch those segments to fit within a new frame here is a nice way to build that abstraction will create our picture within the constraints of a default rectangle of size one that is our

考虑到我们之前对 George 所做的操作类型，我们希望能够在不同的框架中绘制 George，因此我们希望能够定义任何框架，无论是不同大小的还是非正交的，并在其中绘制 George。这意味着什么？理想情况下，我们可以将 George 定义为框架内的一组线段，并将这些线段拉伸以适应新的框架。这里有一个构建该抽象的好方法：我们将在默认的大小为1的矩形约束内创建我们的图片，也就是说，我们的

rectangle of size one that is our

大小为1的矩形，也就是说，我们的

rectangle of size one that is our initial set of segments will have the property that their x and y values all lie between 0 and 1.

大小为1的矩形，也就是说，我们的初始线段集将具有其 x 和 y 值都介于0和1之间的性质。

imagine those segments being attached to a sheet of rubber that fits over a square frame as shown in the lower left.

想象这些线段附着在一张橡胶片上，橡胶片覆盖在一个方形框架上，如左下角所示。

then if we provide some other rectangle which may be shifted over from the first and which may have a different aspect ratio we want our method for drawing to take that sheet of rubber and stretch it to fit over the new rectangles frame.

然后，如果我们提供另一个矩形，它可能相对于第一个矩形有所偏移，并且可能具有不同的宽高比，我们希望我们的绘制方法能拿起那张橡胶片并将其拉伸以适应新矩形的框架。

well that's fine we just need another data structure.

那很好，我们只需要另一个数据结构。

data structure，注意这个结构是由向量构建的，所以我们是在系统中构建另一个抽象层。具体来说，矩形现在被定义为一个从原点或起点出发的向量，以及两个指定框架水平和垂直轴范围的向量。

数据结构，注意这个结构是由向量构建的，所以我们是在系统中构建另一个抽象层。具体来说，矩形现在被定义为一个从原点或起点出发的向量，以及两个指定框架水平和垂直轴范围的向量。

然后，图片只是一个过程，它接收一个矩形（这些抽象之一），并在该矩形内执行一些操作来绘制线条。我们稍后将回到这实际上做什么。现在，构建数据的一个关键问题是…………

然后，图片只是一个过程，它接收一个矩形（这些抽象之一），并在该矩形内执行一些操作来绘制线条。我们稍后将回到这实际上做什么。现在，构建数据的一个关键问题是…………

Now, a key issue in building data abstractions is that it should insulate the details of an abstraction from the actual use of the abstraction. To stress this, suppose you make the following change to our data structures: we change make-vector to be a list, and now why core has to be quatre, which is the car of the car of a list. What else has to change? And note, by the way, that this still satisfies our contract: whatever we construct with make-vector, we can get apart with this using this version of X-core and Y-core. So what else has to change inside of our system?

现在，构建数据抽象的一个关键问题是，它应该将抽象的细节与实际使用抽象隔离开来。为了强调这一点，假设你对我们的数据结构做了如下修改：我们把 make-vector 改为一个列表，现在为什么核心必须是 quatre，即列表的 car 的 car。还有什么需要改变？顺便注意，这仍然满足我们的契约：无论我们用 make-vector 构造什么，我们都可以用这个版本的 X-core 和 Y-core 将其分解。那么，在我们的系统内部还有什么需要改变呢？

change inside of our system and the answer is absolutely nothing that's the whole point any code that we've written that makes use of these constructors and selectors will still run even though the details underneath it have changed so now we can create the pieces of George but how do we actually draw well this is where the slightly strange part comes in

系统内部需要改变，答案是绝对没有，这正是关键所在。任何我们编写的使用这些构造器和选择器的代码仍然会运行，即使底层的细节已经改变了。所以现在我们可以创建 George 的各个部分，但我们究竟如何绘制呢？这就是有点奇怪的地方。

### 6. Pictures as Procedures and Vector Operations (作为过程与向量运算的图片)

we could just create a procedure that draws line segments but we want to have the flexibility in being able to use any frame to draw the same picture so what we're going to do is make a picture be a

我们可以创建一个绘制线段的过程，但我们希望具有灵活性，能够使用任何框架来绘制相同的图片。所以我们要做的是让图片成为一个

we're going to do is make a picture be a procedure and this definitely sounds weird a picture sounds like it should be a data structure a collection of geometric entities but we're going to make it a procedure inside that procedure will be those geometric countries but that procedure will take as input a rectangle and then scale all of those elements to fit within that rectangle and display the results seems odd right in principle a picture is data and we are choosing instead to represent it as a procedural abstraction that captures the process of drawing data in

我们要做的是让图片成为一个过程，这听起来确实很奇怪。图片听起来应该是一个数据结构，一组几何实体，但我们要让它成为一个过程。在那个过程内部，会有那些几何实体，但该过程将接受一个矩形作为输入，然后将所有这些元素缩放以适应那个矩形，并显示结果。这看起来很奇怪，对吧？原则上，图片是数据，而我们却选择将其表示为一个过程抽象，它捕获了在框架中绘制数据的过程。

captures the process of drawing data in a frame. Why? Well, primarily for flexibility. In this way, we have one procedure with inherent data, but it provides an infinite number of versions of the picture.

捕获了在框架中绘制数据的过程。为什么？主要是为了灵活性。这样，我们有一个带有固有数据的过程，但它提供了无限多个版本的图片。

This abstraction allows for very easy manipulation of a picture structure to get new versions. So let's see how that happens. First, we're going to need to be able to manipulate pieces of a picture, and that means we need ways to manipulate vectors themselves. Here are some standard things we'd like to be able to do with vectors. We'd like to be

这种抽象使得对图片结构进行非常容易的操作以获得新版本成为可能。那么让我们看看这是如何发生的。首先，我们需要能够操作图片的各个部分，这意味着我们需要能够操作向量本身。以下是一些我们希望对向量进行的标准操作。我们希望能够

able to do with vectors we'd like to be able to take two vectors and add them together to get a new vector we'd also like to be able to take a vector and stretch it or scale it by stretching both its x and y coordinates by the same amount.

对向量进行的操作，我们希望能够将两个向量相加得到一个新向量，我们还希望能够拉伸或缩放一个向量，即同时拉伸其 x 和 y 坐标相同的量。

now how should we make so here is code to do this for example the first procedure takes two vectors and adds them together to get a new vector it does this by extracting the X and y components of the vectors adding them separately and then creating a new vector with those values for the new components.

现在我们应该如何实现呢？这里是实现这一点的代码，例如，第一个过程将两个向量相加得到一个新向量，它通过提取向量的 X 和 Y 分量，分别相加，然后用这些值创建新向量的新分量来实现。

new components the second procedure takes a vector in a number and stretches or shrinks the vector by that number.

新分量。第二个过程接受一个向量和一个数字，并按该数字拉伸或收缩向量。

rotation is just a matter of applying some trigonometry to the vector to create a new vector the key thing to observe is how we inherit closure from the underlying representation for

旋转只是对向量应用一些三角学知识来创建一个新向量。关键要观察的是我们如何从底层表示中继承闭包，例如，在 + vector 中，V1 可能是另一个 plus vector 操作的结果。注意处理这些抽象时的常见形式，我们经常做同样的事情，即提取出各个部分，对这些部分进行一些简单的操作，然后

example in + vector V 1 could be the result of some other plus vector operation note the common forms here when handling these kinds of abstractions we often do the same thing namely extract out the pieces do some simple operations on those pieces and

对这些部分进行简单的操作，然后构造出同一个对象的新版本，这当然很好地隔离了我们需要改变的抽象屏障。如果我们改变向量的抽象实现，这些过程都不需要改变。

simple operations on those pieces and then construct a new version of the same object back out, and this of course nicely isolates the changes we need to be abstraction barrier. If we change the abstraction implementation for vectors, none of these procedures needs to change.

简单操作，然后构造出同一个对象的新版本，这当然很好地隔离了我们需要改变的抽象屏障。如果我们改变向量的抽象实现，这些过程都不需要改变。

### 7. Implementing Make-Picture and Generalizing to Arbitrary Frames (实现 Make-Picture 并推广到任意框架)

Now we can use all these pieces to assemble a picture. The basic idea is to take a list of segments as input, defined as pairs of vectors using our nice data abstraction. This thing gets passed to a procedure that generates a picture that is a new procedure with the data.

现在我们可以使用所有这些部分来组装一幅图片。基本思想是将一个线段列表作为输入，这些线段使用我们良好的数据抽象定义为向量对。这个列表被传递给一个过程，该过程生成一个图片，即一个带有数据的新过程。

is a new procedure with the data embedded within it. Notice that this make picture procedure is a higher-order procedure. It takes as input list information and creates as output a new procedure. To use a picture, we simply give it a rectangle as a data abstraction, and the picture procedure will then display itself on the screen inside that rectangle.

是一个带有嵌入数据的新过程。注意，这个 make-picture 过程是一个高阶过程。它接受列表信息作为输入，并创建一个新过程作为输出。要使用一幅图片，我们只需给它一个矩形作为数据抽象，图片过程就会在该矩形内将自身显示在屏幕上。

So here's the code for doing that. Note that this is a higher-order procedure. It takes a list as input and returns a procedure as output. That procedure, when given a rectangle as input, will ask each of the line segments

所以这里是实现这一点的代码。注意，这是一个高阶过程。它接受一个列表作为输入，并返回一个过程作为输出。该过程在给定矩形作为输入时，会要求每个线段

Input will ask each of the line segments in the data structure embedded within the procedure to draw itself appropriately scaled within the rectangle for each is just like map except that it doesn't accumulate an answer as it walks down the list applying its internal lambda to each element.

输入时，会要求嵌入在过程中的数据结构中的每个线段在矩形内适当地缩放自身。for-each 就像 map 一样，只是它不累积答案，而是在遍历列表时将内部的 lambda 应用于每个元素。

The key thing to notice is how we are using standard list operations to capture this procedural abstraction of a picture. Just to be careful, what should draw line do? The idea is that this procedure is given a rectangle which contains within it an origin vector and

关键要注意的是我们如何使用标准的列表操作来捕获这种图片的过程抽象。为了小心起见，draw-line 应该做什么？这个想法是，这个过程被赋予一个矩形，其中包含一个原点向量和

contains within it an origin vector and x-axis and a y-axis draw a line takes an x and y coordinate value of a point defined in a canonical rectangle and scales this new horizontal and vertical axis by those amounts and then shifts this by the offset to the origin using the a vector algebra shown doing this for two points automatically

包含一个原点向量和 x 轴和 y 轴。draw-line 接受一个在规范矩形中定义的点的 x 和 y 坐标值，并按这些量缩放新的水平和垂直轴，然后使用所示的向量代数将偏移量平移到原点。对两个点这样做会自动

the shifts and stretches align to fit within the new rectangle so just to complete this idea here is a better definition of George now what's the big deal well George is now both a data abstraction

平移和拉伸以适应新的矩形。所以为了完成这个想法，这里是 George 的一个更好的定义。现在有什么大不了的？嗯，George 现在既是一个数据抽象

Abstraction. George lines a set of segments and a procedure G, a process for drawing those lines within a rectangle. Note that George contains the information about the segments within it as part of the procedure abstraction. This makes it quite easy to use George's building block in other pictures.

抽象。George 包含一组线段和一个过程 G，一个在矩形内绘制这些线段的过程。注意，George 将关于线段的信息作为过程抽象的一部分包含在其中。这使得将 George 作为其他图片的构建块变得非常容易。

And that is what we want to turn to next. Again, remember what a picture is: it's a procedure that takes a rectangle as input and scales its line segments to draw them within that rectangular frame. So we can easily generalize this idea to...

而这正是我们接下来要讨论的。再次提醒，记住什么是图画：它是一个过程，接受一个矩形作为输入，并缩放其线段以在该矩形框架内绘制。因此，我们可以轻松地将这个想法推广到……

Generalize this idea to arbitrary frames, not just rectangular ones. Remember that a frame is just a set of three vectors—an origin and two axes—so by picking vectors for axes that are not orthogonal, we get skewing of the picture for free. To rotate a picture, we can just shift the axes, in particular make the old horizontal axis vertical and the old vertical axis the negative horizontal one.

将这个想法推广到任意框架，而不仅仅是矩形框架。记住，框架只是一组三个向量——一个原点和两个轴——因此通过选择不正交的轴向量，我们可以免费获得图画的倾斜效果。要旋转一幅图画，我们只需移动轴，特别是将原来的水平轴变为垂直轴，将原来的垂直轴变为负的水平轴。

If we do this, then we can see that drawing the picture within this new coordinate frame will accomplish the task of rotating the original picture.

如果我们这样做，那么我们可以看到，在这个新的坐标框架内绘制图画将完成旋转原始图画的任务。

task of rotating the original picture, and we can easily build code to do this. Note what this does in a very cool way.

旋转原始图画的任务，我们可以轻松构建代码来实现这一点。注意这以一种非常酷的方式做了什么。

rotate 90 returns a picture that is a procedure of one argument, a rectangle. That new picture asks the old picture to draw itself but in a new frame.

rotate90 返回一幅图画，它是一个接受一个参数（一个矩形）的过程。那幅新图画要求旧图画在新的框架中绘制自身。

That frame simply comes about by creating a new origin, a new horizontal axis, and a new vertical axis, just as we sketched.

那个框架仅仅是通过创建一个新的原点、一个新的水平轴和一个新的垂直轴而得到的，正如我们刚才所概述的。

Also notice how nicely the data abstractions preserve the cleanliness of this code. It's very easy to see what's being done here, of course there's more to it than that.

还要注意数据抽象如何很好地保持了这段代码的简洁性。这里很容易看出正在做什么，当然，还有更多内容。

### 8. Combining Pictures and Closure (组合图画与闭包)

being done here of course there's nothing that says we can only deal with a single picture together simply asks two pictures to draw themselves in the same frame it does so since each picture is a procedure the draws is in a rectangle and both by supplying the same rectangle to each picture we get a combination of the two and here's an example in act now suppose we have two pictures that draw different things and we want to combine them in other words how do we create a means of combination for pictures suppose we start with two different pictures that draw different

这里正在做什么，当然，没有什么说我们只能处理单个图画。组合只是简单地要求两幅图画在同一框架中绘制自身。它这样做是因为每幅图画都是一个过程，在矩形中绘制，通过向每幅图画提供相同的矩形，我们得到两者的组合。这里有一个例子。现在假设我们有两幅绘制不同内容的图画，我们想要组合它们。换句话说，我们如何为图画创建一种组合手段？假设我们从两幅绘制不同内容的图画开始。

Different pictures draw different things, since the picture is a procedure that takes a frame and draws into it. We could give each of these different pictures a different frame, specifically if we pick a division point and split a frame into two parts, each of those parts can act like a frame, and we can draw different pictures into each part.

不同的图画绘制不同的内容，因为图画是一个接受框架并在其中绘制的过程。我们可以给这些不同的图画各自不同的框架，具体来说，如果我们选择一个分割点并将一个框架分成两部分，每个部分都可以充当一个框架，我们可以在每个部分中绘制不同的图画。

Thus, beside to draw two pictures scaled appropriately next to one another and above should do the obvious thing in the vertical direction. Conceptually, an operation like beside has within it two

因此，beside 将两幅图画适当地缩放并并排绘制，而 above 应该在垂直方向做显然的事情。从概念上讲，像 beside 这样的操作内部包含两个图画过程。当给定一个矩形时，每幅图画在其矩形份额中绘制自身，从而将两个原始图画组合成一个更复杂的图画。这是实现它的代码。

operation like beside has within it two picture procedures. When given a rectangle, each picture draws itself in its share of the rectangle, thus combining two primitive pictures into a more complex one. And here's the code to do it.

让我们逐步分析 beside 以了解它的作用。Beside 接受两幅图画——记住这些是在两个矩形中绘制的过程——它还接受一个比例。

Let's step through beside to see what it does. Beside takes two pictures — remember these are procedures that draw in two rectangles — it also takes a ratio.

它通过简单地按该比例缩小水平轴来创建一个新框架，并保持相同的原点和垂直轴。然后它要求第一幅图画在该框架中绘制自身的一个版本，这将产生一幅沿水平轴被压缩的图画。

It creates a new frame by simply shrinking the horizontal axis by that ratio and otherwise uses the same origin and vertical axis. It then asks the first picture to draw a version of itself in

图画在该框架中绘制自身的一个版本，这将产生一幅沿水平轴被压缩的图画。Beside 还创建了第二个框架，具有相同的垂直范围，水平范围设置为填充原始框架的其余部分。

Picture to draw a version of itself in that frame, which will result in a picture that has been squeezed along the horizontal axis. Beside this, it creates a second frame with the same vertical extent and a horizontal extent that is set up to fill the remainder of the original frame.

然而，这里我们需要将原点或起始点移到第一个框架的末端，因此第二个矩形中有一些向量代数。然后我们要求第二幅图画在该框架内绘制自身。

Here, however, we need to shift the origin or starting point over to the end of the first frame, hence the bit of vector algebra in the second rectangle. And then we ask the second picture to draw itself within this frame.

注意这里的关键点：我们可以将图画视为黑盒抽象，因此我们可以将图画与其他图画组合，而无需担心图画本身的细节。注意抽象如何简单地让我们将图画的框架视为向量操作，而图画本身则随之而来。

Note the key point here: we can treat prick pictures as

注意这里的关键点：我们可以将图画视为黑盒抽象，因此我们可以将图画与其他图画组合，而无需担心图画本身的细节。注意抽象如何简单地让我们将图画的框架视为向量操作，而图画本身则随之而来。

here we can treat prick pictures as blackbox abstractions thus we can combine pictures with other pictures without worrying about the details of the pictures themselves note how the abstraction simply allows us to think about the frames of pictures as vector manipulations and the pictures themselves come along for free

这里我们可以将图画视为黑盒抽象，因此我们可以将图画与其他图画组合，而无需担心图画本身的细节。注意抽象如何简单地让我们将图画的框架视为向量操作，而图画本身则随之而来。

moreover pictures have the property of closure thus we can use our combiners things like above and beside to produce new abstractions that can then be used as primitives within some other combination here's an example of George and his

此外，图画具有闭包性质，因此我们可以使用像 above 和 beside 这样的组合器来产生新的抽象，这些抽象随后可以用作其他组合中的原语。这是乔治和他的小弟弟的一个例子。

Here's an example of George and his little brother. Notice the elegant combination here, nowhere is there a specification of the line segments. We are simply taking the abstract notions of saying, given an empty picture and a picture of George above, will create a new picture. Notice the higher-order procedure abstraction.

这是乔治和他的小弟弟的一个例子。注意这里的优雅组合，没有任何地方指定线段。我们只是采用抽象概念，说给定一个空图画和乔治的图画在上面，将创建一个新图画。注意高阶过程抽象。

That procedure can then be combined with George in a beside fashion to create another one. Notice, by the closure property, simply taking George's picture plus these combinations guarantees we get a picture or one of

那个过程然后可以与乔治的图画以 beside 方式组合以创建另一个。注意，通过闭包性质，简单地取乔治的图画加上这些组合保证我们得到一幅图画或其中一个过程。

Guarantees we get a picture or one of those procedures back. So now let's keep those procedures back, so now let's keep pushing this. Here's another operation that we can do on pictures: we can flip it about the vertical axis. Notice again how flip takes in a picture, a procedure, creates a new procedure for a picture, procedure if you like, back out and simply does it by passing an appropriately constructed rectangle using the abstractions to the original picture.

保证我们得到一幅图画或其中一个过程。所以现在让我们保留这些过程，继续推进。这是我们可以对图画进行的另一个操作：我们可以绕垂直轴翻转它。再次注意 flip 如何接受一幅图画，一个过程，创建一个新的图画过程，如果你愿意，然后通过使用抽象将适当构造的矩形传递给原始图画来简单地完成。

### 9. Recursive Application and Achieving Escher-like Results (递归应用与实现埃舍尔式效果)

So we can use this to put things together, an interesting and that includes combinations built on top of other combinations leading to.

所以我们可以用它来组合事物，有趣的是，这包括建立在其他组合之上的组合，导致……

Other combinations leading to interesting kinds of notice how closure is nicely allowing us to combine complex things, then treat the result as a primitive, and combine again. So what about recursive application of these ideas? Are combining things well one interesting way would be to draw a picture in some fraction of a frame, then draw it again in the same fraction of the remaining part of the frame, and so on for some specified number of times.

其他组合导致有趣的结果。注意闭包如何很好地让我们组合复杂的事物，然后将结果视为原语，并再次组合。那么这些想法的递归应用呢？组合事物的一种有趣方式是，在一幅图画中绘制一部分框架，然后在剩余部分的相同比例中再次绘制，依此类推，进行指定次数。

This would just be a recursive application of the same idea. Note how the code captures this up, bush takes a...

这将是同一想法的递归应用。注意代码如何捕捉这一点，upward 接受一个……

the code captures this up bush takes a picture in and gives us a picture back out we can see that by noticing that the base case returns a picture and the recursive case assuming the base case and my induction lower size cases work also does it since above combines things into pic so we can apply this idea to joke and we can do the same thing pushing things to the side and we can generalize this to both push up and out look at the code carefully to notice how the various combination means guaranteed that pictures are passed at the right level this lets us push George into a

代码捕捉到了这一点：向上灌木丛获取一张图片并返回一张图片。我们可以通过注意到基本情况返回一张图片，而递归情况（假设基本情况和我的归纳中较小尺寸的情况有效）也做到了这一点，因为上面的组合将事物合并成图片，所以我们可以将这个想法应用于笑话，并且我们可以做同样的事情将事物推到一边，并且我们可以将其推广到同时向上和向外推。仔细查看代码，注意各种组合方式如何保证图片在正确的层级传递。这让我们可以把乔治推入一个

level this lets us push George into a corner next we can put copies of things together here we are using the operation of rotate 90 to rotate pictures.

层级，这让我们可以把乔治推入一个角落。接下来，我们可以把事物的副本放在一起。这里我们使用旋转90度的操作来旋转图片。

different amounts repeated is just a higher-order procedure that returns a procedure that applies its first argument a specific number of times in succession to this applied argument again trace through the code to see how elegantly we have captured the idea of making copies of four different pictures rotated appropriate amounts and ultimately with a simple combination of the things we started with pushed into a

不同的量。重复只是一个高阶过程，它返回一个过程，该过程将其第一个参数连续应用特定次数于其第二个参数。再次追踪代码，看看我们多么优雅地捕捉了制作四张不同图片的副本并旋转适当角度的想法，最终通过简单组合我们开始时推入角落的事物，并在四个不同的角落复制它们，我们得到了像这样的有趣组合。

the things we started with pushed into a corner and replicated in the four different corners we get interesting combinations like this one here for comparison here was our original goal now we're not quite as elegant and artist is Escher we certainly don't have the same aesthetic appeal

我们开始时推入角落的事物，并在四个不同的角落复制它们，我们得到了像这样的有趣组合。这里为了比较，这是我们最初的目标。现在我们不如艺术家埃舍尔那样优雅，我们当然没有同样的审美吸引力。

### 10. Abstraction and Building a Language (抽象与构建语言)

notice how we've captured the same recursive behavior that etcher has in his print in our example now is there anything special about drawing line segments of course not this is just another abstraction issue so we could instead take an actual picture and use

注意我们如何在我们的例子中捕捉到了埃舍尔在他的版画中所具有的相同递归行为。现在，绘制线段有什么特别之处吗？当然没有，这只是另一个抽象问题，所以我们可以改为取一张实际的图片，并使用

instead take an actual picture and use exactly the same methods to paint that picture onto a frame for example we can get the same kind of behavior using portraits of Einstein of Escher himself and of the monel so what's the point of all this I claim that what we've done is build a new language a language for describing and thus creating pictures in the style of Escher the language is embedded within scheme and hence inherits the underlying power scheme but at the same time there are some very nice analogies between the two languages that we want to pull out first what are

改为取一张实际的图片，并使用完全相同的方法将该图片绘制到框架上。例如，我们可以使用爱因斯坦、埃舍尔本人和蒙娜丽莎的肖像获得相同类型的行为。那么这一切的意义何在？我声称我们所做的是构建了一种新语言，一种用于描述并从而以埃舍尔风格创作图片的语言。该语言嵌入在Scheme中，因此继承了Scheme的底层力量，但同时，我们想要指出两种语言之间有一些非常好的类比。首先，什么是

That we want to pull out first, what are the primitives of scheme? Here we have standard things, primitive elements like numbers, strings, names for things.

我们想要指出两种语言之间有一些非常好的类比。首先，什么是Scheme的原始元素？这里我们有标准的东西，原始元素如数字、字符串、事物的名称。

Pressure, we have a very different notion of primitive data. As here, the fundamental unit is a picture. And note, we have to make a picture as a procedure, so we really just blurred the boundary between data and procedure.

相比之下，我们有一个非常不同的原始数据概念。在这里，基本单位是图片。注意，我们必须将图片制作成一个过程，所以我们确实模糊了数据和过程之间的界限。

But for a sure language, the primitive thing is a picture. And in scheme, we have primitive procedures for manipulating data objects. And in asure, we also have primitive procedures, but now oriented towards.

但对于一种确定语言，原始事物是图片。在Scheme中，我们有用于操作数据对象的原始过程。在埃舍尔语言中，我们也有原始过程，但现在面向的是

Procedures but now oriented towards manipulating pictures. Note that the implementation involves taking procedures in and giving new procedures back out, but from the perception of the language, it's simply a means of operating on primitive objects.

过程，但现在面向的是操作图片。注意，实现涉及接收过程并返回新过程，但从语言的感知来看，它仅仅是操作原始对象的一种手段。

In Scheme, we have standard means of combining expressions, namely procedure application. Note that in Asscher, we have very elegantly built a similar capability. Our means of combination were ways of gluing pictures together, and just like in Scheme, these means of combination had closure, that is, the...

在Scheme中，我们有标准的组合表达式的方法，即过程应用。注意，在埃舍尔语言中，我们非常优雅地构建了类似的能力。我们的组合方式是将图片粘合在一起，就像在Scheme中一样，这些组合方式具有闭包性，即...

combination had closure that is the results of a combination could be treated as a primitive and thus used as input to another combination also note that since we built a sure on top of scheme for free we got the power of scheme for example the use of recursion and finally we needed a way of naming things so we could treat them as primitives and Escher inherits exactly that capability from scheme the key issue is to see how quickly we used abstraction tools to build a new language we were able to suppress detail so that we could focus on the use of the

组合具有闭包性，即组合的结果可以被视为原始元素，从而用作另一个组合的输入。还要注意，由于我们在Scheme之上免费构建了埃舍尔语言，我们获得了Scheme的力量，例如递归的使用。最后，我们需要一种命名事物的方式，以便我们可以将它们视为原始元素，而埃舍尔语言恰好从Scheme继承了这种能力。关键问题是看到我们如何迅速使用抽象工具来构建一种新语言。我们能够抑制细节，以便专注于元素的使用，在这种情况下是图片，我们自然地被引导到组合图片的想法，而无需担心实际图片的细节。

So that we could focus on the use of the elements in this case pictures, we will naturally led to ideas of combining pictures without ever having to worry about the details of the actual pictures.

以便我们能够专注于元素的使用，在这种情况下是图片，我们自然地被引导到组合图片的想法，而无需担心实际图片的细节。

And this idea of describing a language for problem domain in terms of natural primitives, means of combination, and means of abstraction is a powerful tool that will return too many times during

这种用自然原始元素、组合方式和抽象方式来描述问题领域语言的想法，是一个强大的工具，我们将在课程中多次回到这一点。