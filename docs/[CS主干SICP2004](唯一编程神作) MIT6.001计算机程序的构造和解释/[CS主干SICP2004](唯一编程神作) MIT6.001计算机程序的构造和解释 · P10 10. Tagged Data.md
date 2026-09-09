# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=10)

In the last lecture we introduced symbols into our language. We showed how we could use them to intermix with numbers to create mixed expressions. Your recall that our big example was a symbolic differentiator that let us reason about algebraic expressions, rather than just numerical ones.

在上一讲中，我们将符号引入了我们的语言。我们展示了如何将它们与数字混合使用，以创建混合表达式。您还记得，我们的大例子是一个符号微分器，它让我们能够对代数表达式进行推理，而不仅仅是数值表达式。

In this lecture, we're going to take that idea of symbols and combine them with lots of different data types to build what we now call tagged data structures. To start, let's motivate why we need a tag as well as what constitutes a tag. Suppose I want...

在本讲中，我们将把符号的概念与许多不同的数据类型结合起来，构建我们现在所称的带标签的数据结构。首先，让我们说明为什么需要标签，以及什么构成标签。假设我想...

as what constitutes a tag suppose I want to get some help in creating a system to create and manipulate complex numbers. remember that a complex number is a number with two parts, the standard way of representing it is in terms of a real part and an imaginary part, and we often represent such numbers as a vector with one component representing the real part of the vector and the other component representing the imaginary part.

作为什么构成标签，假设我想在创建和操作复数的系统方面获得一些帮助。请记住，复数是一个具有两个部分的数，标准的表示方式是实部和虚部，我们通常将这样的数表示为向量，其中一个分量表示向量的实部，另一个分量表示虚部。

because we can think of a complex number as a vector, it's also convenient to think about representing it in terms of a

因为我们可以将复数视为向量，所以也方便考虑用向量的...

about representing it in terms of a magnitude or length of the vector and an angle that is the angle between that vector and say the real axis. Now let's assume we have some data abstractions for complex numbers, that is we have a constructor and we have some selectors that will pull the pieces out. And in fact, let's assume that the selectors are things like real and imaginary part and mag and angle. I've shown therefore the magnitude and angle of the vector as we've seen before when talking about data structures and data abstractions.

考虑用向量的幅度或长度以及一个角度来表示它，该角度是向量与实轴之间的夹角。现在假设我们有一些用于复数的数据抽象，也就是说，我们有一个构造函数和一些选择器，可以将各个部分提取出来。事实上，让我们假设选择器是诸如实部、虚部、幅度和角度之类的。我已经展示了向量的幅度和角度，正如我们在讨论数据结构和数据抽象时之前所看到的那样。

abstractions if we have those constructors and selectors we can just think about writing code for manipulating complex numbers for example here's some code that will do that now.

抽象，如果我们有这些构造函数和选择器，我们就可以考虑编写用于操作复数的代码，例如，这里有一些代码可以做到这一点。

when manipulating complex numbers I can take advantage of the fact that some things are easier to do in one representation than in another for example if I want to add together two complex numbers it's easiest to think of this as just normal vector addition that is to get the sum of two complex numbers I pull out their real parts using their selectors just add those together using.

在操作复数时，我可以利用这样一个事实：某些操作在一种表示中比在另一种表示中更容易完成。例如，如果我想将两个复数相加，最容易的方法就是将其视为普通的向量加法。也就是说，要得到两个复数的和，我使用选择器提取它们的实部，然后使用普通加法将它们相加。

Selectors just add those together using normal addition. I pull out their imaginary parts using the right selectors, just add those together using normal addition, and now I have a new real part and imaginary part. So I can glue them together to make a complex number. In this case, I'm going to use a constructor that knows the inputs are in rectangular coordinates or Cartesian coordinates, and it's going to glue them together to make a new complex number.

选择器，然后使用普通加法将它们相加。我使用正确的选择器提取它们的虚部，然后使用普通加法将它们相加，现在我就有了新的实部和虚部。因此，我可以将它们组合在一起构成一个复数。在这种情况下，我将使用一个构造函数，它知道输入是矩形坐标或笛卡尔坐标形式的，它将把它们组合在一起构成一个新的复数。

On the other hand, multiplication is actually easier to think about in terms of magnitudes and angles of things.

另一方面，乘法实际上更容易从幅度和角度的角度来考虑。

of magnitudes and angles of things so here I can take the magnitude selector to get out the magnet the two vectors or the two complex numbers multiply them together using normal multiplication because these are just numbers I can take out the angles of the two complex numbers just add them together using normal form and then construct a new complex number out of these pieces and in this case my constructor has to know that I'm providing it things in polar or magnitude and angle form not in rectangular or real and imaginary form and note again the key point about a

从幅度和角度的角度来考虑，所以这里我可以使用幅度选择器来提取两个向量或两个复数的幅度，然后使用普通乘法将它们相乘，因为这些只是数字；我可以提取两个复数的角度，然后使用普通加法将它们相加，然后从这些部分构造一个新的复数。在这种情况下，我的构造函数必须知道我是以极坐标或幅度和角度形式提供给它，而不是以矩形或实部和虚部形式。再次注意一个关键点...

And note again the key point about a data abstraction. I haven't yet worried about the details of how this thing is implemented. I'm simply using the constructors and selectors to get out the parts, manipulate them, and create new data structures that I can then go on and use.

再次注意数据抽象的关键点。我还没有担心这个事物实现的细节。我只是使用构造函数和选择器来提取部分，操作它们，并创建新的数据结构，然后我可以继续使用它们。

I can think about complex numbers just as numbers, not having to worry about the details. As we said, it's often convenient just to manipulate the data structures using the abstraction barrier between the details and the use, to separate out those two parts. But ultimately, we're

我可以将复数视为数字，而不必担心细节。正如我们所说，通常方便的做法是使用抽象屏障将细节和使用分开，以便将这两部分分离。但最终，我们...

those two parts but ultimately we're going to have to make an implementation of the data structure we're not to build the guts of it so we need to think about how we would do that well let's pass this task off to our friend Bert and ask Bert to actually implement our specific representation a detailed representation for complex numbers

这两部分，但最终我们将不得不实现数据结构，我们不是要构建它的内部结构，所以我们需要考虑如何做到这一点。好吧，让我们把这个任务交给我们的朋友伯特，请伯特实际实现我们的特定表示，一个详细的复数表示。

first of all Bert's going to need a way of gluing things together so he obviously should just use lists as a way of trying to represent the combinations of two parts it's a standard thing we should do he still has a choice though

首先，伯特需要一种将事物组合在一起的方法，所以他显然应该使用列表作为表示两个部分组合的方式，这是我们应做的标准事情。不过，他仍然有一个选择。

Should he do it? He still has a choice, though. And Bert, being a rather square guy, decides to use rectangular components or rectangular coordinates as his basis. That is, his representation of a complex number will it be a list of the real part and the imaginary part of the complex number? No, what this means is, if he has handed a real and imaginary part, he can construct them by just gluing them together using lists. On the other hand, if he is handed a magnitude and an angle, he'll need to convert that into real and imaginary part, doing a little bit of...

他应该怎么做？不过，他仍然有一个选择。伯特，作为一个相当刻板的人，决定使用矩形分量或矩形坐标作为他的基础。也就是说，他对复数的表示将是复数的实部和虚部的列表。不，这意味着，如果他拿到实部和虚部，他可以通过使用列表将它们组合在一起来构造它们。另一方面，如果他拿到幅度和角度，他将需要将其转换为实部和虚部，做一点...

imaginary part doing a little bit of algebra and then glue things together so that no matter how inputs are provided to the constructor he always represents things in that form of a list of the real part and the imaginary part to complete the representation.

虚部，做一点代数运算，然后将它们组合在一起，这样无论输入如何提供给构造函数，他总是以实部和虚部的列表形式来表示事物，以完成表示。

Bert just has to make sure that he implements selectors that satisfy the contract associated with complex numbers that real and imaginary parts get out the right pieces of the data structure and similarly for magnitude and angle here.

伯特只需要确保他实现的选择器满足与复数相关的契约，即实部和虚部能正确地从数据结构中提取出正确的部分，幅度和角度也是如此。

Part of this is very easy given that Bert has chosen to represent

鉴于伯特选择了表示方式，这部分非常容易。

Bert has chosen to represent in terms of a list of a real and imaginary part. The selector is real in a match, just pull out those pieces of the list. On the other hand, to get out the magnitude of a complex number represented this way, we have to take the real and imaginary parts. Notice how we're going to use those selectors to get them out, then do some algebraic manipulation to convert real and imaginary parts into a magnitude. This is just getting the length of the vector and then returning that value. Similarly, for angle, we have to get out the

伯特选择用实部和虚部的列表来表示。选择器在匹配时是真实的，只需取出列表中的那些部分。另一方面，要得到以这种方式表示的复数的模，我们必须取出实部和虚部。注意我们如何使用这些选择器将它们取出，然后进行一些代数运算将实部和虚部转换为模。这只是求向量的长度，然后返回该值。类似地，对于角度，我们必须取出

For angle, we have to get out the components, the real and imaginary parts, since that's how they are represented, and then do some algebra in this case, taking an 8 and to get out the actual angle.

对于角度，我们必须取出分量，即实部和虚部，因为它们是如此表示的，然后在这种情况下进行一些代数运算，取一个反正切（8）来得到实际角度。

There's Bert's implementation, constructor and selectors does the right thing. Notice that Bert made a design choice; he made a decision as to how he was going to internally represent complex numbers as a list of the real and imaginary part.

这就是伯特的实现，构造函数和选择器做了正确的事情。注意伯特做了一个设计选择；他决定如何内部表示复数，即作为实部和虚部的列表。

Let's suppose at the same time we also handed this task to Bert's friend Ernie and asked Ernie to build a representation for complex

让我们假设同时我们也把这个任务交给了伯特的朋友厄尼，并要求厄尼构建一个复数的表示

build a representation for complex numbers constructors and selectors Ernie as you may know us from Canada and hence he likes cold things so he offs to represent things in polar form that is his basic representation is going to be to represent a complex number as a list of the magnitude and angle of a complex number similar to what Bert did then Ernie has to do a little bit of work for the alternative form so making a complex number from polar form just lists things together if on the other hand Ernie's constructor is given a real in

构建复数的构造函数和选择器。厄尼，如你所知，来自加拿大，因此他喜欢冷的东西，所以他选择用极坐标形式表示事物，即他的基本表示是将复数表示为模和角的列表，类似于伯特所做的。然后厄尼必须为另一种形式做一点工作，所以从极坐标形式创建复数只是将事物列表在一起，如果另一方面，厄尼的构造函数给定实部和

Ernie's constructor is given a real in an imaginary part. We have to do a little bit of work to compute out what the magnitude and the angle of those two things are, and then create a list of those to get things into the form we want. In completing Ernie's task is also very similar: the magnitude and angle selectors just get out the pieces of the list, because things were represented that way in his version.

厄尼的构造函数给定实部和虚部。我们必须做一点工作来计算这两个东西的模和角是什么，然后创建这些的列表以将事物放入我们想要的形式。完成厄尼的任务也非常相似：模和角选择器只是取出列表中的部分，因为在他的版本中事物是以那种方式表示的。

Whereas for real and imaginary part, Ernie's going to have to do a little bit of work to take the magnitude and angle using the right selectors, compute from those what the real and imaginary parts are.

而对于实部和虚部，厄尼将不得不做一点工作，使用正确的选择器取出模和角，从中计算出实部和虚部是什么。

selectors compute from those what the actual real and imaginary parts are and then returning those values once again. Ernie's data structure satisfies the contract between constructors and selectors. All that's changed is how he has chosen to internally represent the complex number. Okay, this sounds fine.

选择器从中计算出实际的实部和虚部是什么，然后再次返回这些值。厄尼的数据结构满足了构造函数和选择器之间的契约。所有改变的是他选择如何内部表示复数。好的，这听起来不错。

We've got two different implementations for complex numbers, one in Cartesian or rectangular coordinates, one in polar coordinates, but both seemed to satisfy the contract we'd like. What's the big deal? Well, suppose we pick up a complex number lying on the floor.

我们有两种不同的复数实现，一种用笛卡尔坐标或直角坐标，另一种用极坐标，但两者似乎都满足我们想要的契约。有什么大不了的？好吧，假设我们从地板上捡起一个复数。

Up a complex number lying on the floor. In particular, suppose we pick up the following object, and we know it represents a complex number. Here's the question: what actual number does this represent? Gee, that sounds funny—it's just a complex number, right? But think about it: if this was a complex number made by Burt, what number would this represent?

从地板上捡起一个复数。特别是，假设我们捡起以下对象，并且我们知道它代表一个复数。问题是：这实际上代表什么数字？哎呀，这听起来很奇怪——它只是一个复数，对吧？但想想看：如果这是伯特制作的复数，这个数字代表什么？

Well, in that case, we know that the first part of this number represents the real part, and the second part of this number represents the imaginary part. So it corresponds to this vector, to this point, or this complex number represented.

好吧，在那种情况下，我们知道这个数字的第一部分代表实部，第二部分代表虚部。所以它对应于这个向量，这个点，或这个复数表示。

Point or this complex number represented in the Cartesian coordinate frame on the other hand, if this was a complex number made by Ernie, then we know the first number in this list represents the magnitude and the second number represents the angle. And in that case, it represents this complex number or the end of this vector.

点或这个复数在笛卡尔坐标框架中表示。另一方面，如果这是厄尼制作的复数，那么我们知道这个列表中的第一个数字代表模，第二个数字代表角。在那种情况下，它代表这个复数或这个向量的末端。

So we've got a problem: depending on who made this complex number, it actually represents a different thing. And how do we tell who made it? Well, that's kind of the problem given what we have here—we can't tell.

所以我们遇到了一个问题：取决于谁制作了这个复数，它实际上代表不同的东西。我们如何分辨是谁制作的？嗯，这就是问题所在，鉴于我们这里有的东西——我们无法分辨。

fortunately the solution is easy let's create designer complex numbers that is let's have them autographed on the back by the designer or set a little less facetiously let's put a label on the object that either says this is a rectangular or Bert style complex number or this is a polar or ernie style complex number

幸运的是，解决方案很简单：让我们创建设计师复数，也就是说，让它们在背面有设计师的签名，或者不那么开玩笑地说，让我们在对象上贴一个标签，要么说这是直角坐标或伯特风格的复数，要么说这是极坐标或厄尼风格的复数。

how do we add a label to our complex numbers well just glue it on the front let's change our constructors in particular let's change our constructor that says if I'm making a complex number from rectangular form I'll put a label up front that says gee

我们如何给复数添加标签？好吧，只需把它粘在前面。让我们改变我们的构造函数，特别是改变我们的构造函数，说如果我从直角坐标形式创建复数，我会在前面放一个标签，说“哎呀”

I'll put a label up front that says gee here's the two pieces the real and imaginary components and here's the label this as its in rectangular form if on the other hand I'm going to make a complex number from polar form that is I'm given a magnitude and an angle all again just glue those together but put a label up front that says that's how it was made it's in polar form and what else do I need in this new kind of data abstraction well I've got a label there so let's have a selector that pulls off the tag that it gets out whether it's

我会在前面放一个标签，说“哎呀，这里有两个部分，实部和虚部，这里有一个标签，标记这是直角坐标形式”。如果另一方面，我要从极坐标形式创建复数，即给定模和角，同样只是将它们粘在一起，但前面放一个标签，说明它是如何制作的，它是极坐标形式。在这种新的数据抽象中我还需要什么？好吧，那里有一个标签，所以让我们有一个选择器，取出标签，得到它是

it gets whether it's rectangular or polar, and another selector that pulls out the contents. Notice the use of 'cutter' here to get the remaining list of elements, that is either the real and imaginary parts, or the magnitude and angle, depending on which piece is used to represent it.

得到它是直角坐标还是极坐标，以及另一个选择器取出内容。注意这里使用“cutter”来获取剩余的元素列表，即要么是实部和虚部，要么是模和角，取决于用于表示它的部分。

Note carefully what I've done here. I've said now, to create a complex number, no matter what format comes in, I'm just going to list those two things together, but I'm simply going to label whether it's rectangular or polar. So I'm not doing any work to convert; I'm simply.

注意我在这里做了什么。我说过，现在要创建复数，无论输入什么格式，我只是将这两个东西列在一起，但我只是标记它是直角坐标还是极坐标。所以我没有做任何转换工作；我只是

doing any work to convert I'm simply gluing the pieces together with the right label to make sure my contract holds. I then have to think about how to change the selectors and here's where I'm going to bury the work now. I'll have a single selector called real; it's going to work with forms that are either in rectangular or polar form, doesn't matter which.

无需做任何转换工作，我只是用正确的标签把各个部分粘合在一起，以确保我的契约成立。然后我必须考虑如何更改选择器，而这里正是我要把工作隐藏起来的地方。我将有一个名为 real 的选择器；它将处理矩形或极坐标形式的复数，无论哪种形式都行。

And what's it going to do? The first thing it's going to do is pull off the tag, rip the tag off of that complex number, and check it to see what kind of beast is it. Notice we're using.

它将做什么呢？它要做的第一件事是取下标签，撕掉那个复数上的标签，并检查它，看看它是哪种类型的野兽。注意我们正在使用。

kind of Beast is it notice we're using

哪种类型的野兽，注意我们正在使用

kind of Beast is it notice we're using EQ to test equality and we're using the quoted symbol rect to say this is a rectangular form so that we can compare it to the tag if in fact this is a rectangular Li constructed complex number then we use the content selector to get out the contents of the context number everything but the tag and then we use the car operation just to get out the real part because we know it's represented the right way on the other hand if the tag says this is a polar form again notice the use of the quote to get the symbol polar note the use of

哪种类型的野兽，注意我们正在使用 EQ 来测试相等性，并且我们使用带引号的符号 rect 来表示这是矩形形式，以便我们可以将其与标签进行比较。如果这确实是一个矩形标签构造的复数，那么我们就使用内容选择器来取出复数的内容，即除标签之外的所有部分，然后使用 car 操作来取出实部，因为我们知道它是以正确的方式表示的。另一方面，如果标签表明这是极坐标形式，再次注意使用引号来获取符号 polar，注意使用

To get the symbol polar, note the use of EQ question mark to test the quality of names or symbols. If the tag says this is polar, then I have to do some work and what's the work? I use contents as a selector to get everything but the tag that is the actual contents of the object. I get the car out which I know represents the magnitude, again get contents and get the car or out to get the angle.

为了获取符号 polar，注意使用 EQ 问号来测试名称或符号的相等性。如果标签表明这是极坐标形式，那么我就必须做一些工作，而工作是什么呢？我使用 contents 作为选择器来获取除标签之外的所有内容，即对象的实际内容。我取出 car，我知道它代表幅度，再次获取 contents 并取出 car 或 cdr 来获取角度。

Use the cosine of that and then do the work to do the right manipulation of the numbers to compute what the real part is. So here I have the following situation: I've just

使用该角度的余弦，然后进行正确的数值运算来计算实部。所以这里我面临以下情况：我刚刚

following situation I've just constructed complex numbers routinely listing them together with the label my selectors now have to do a little bit of work they check the tag to see what kind of beast it is and either just return the right value or compute what the right value should be by converting from polar form to rectangular form

以下情况：我刚刚例行公事地构造了复数，将它们与标签粘合在一起。我的选择器现在必须做一些工作：它们检查标签以确定它是哪种类型的野兽，然后要么直接返回正确的值，要么通过从极坐标形式转换为矩形形式来计算正确的值。

and of course I do the same thing with the other selectors to make sure that the entire system works note the key point here it's not that I'm dealing with complex numbers that's simply a motivation the key point is to notice

当然，我对其他选择器也做同样的事情，以确保整个系统正常工作。注意这里的关键点：并不是说我在处理复数，那只是一个动机；关键是要注意

motivation the key point is to notice how now I can use my complex number procedures the things I wrote to manipulate complex numbers by adding them or multiplying and we're doing other such things I can use all of those procedures on any kind of complex number that's really nice.

动机，关键是要注意现在我如何使用我的复数过程——我编写的那些用于操作复数的过程，比如加法或乘法，以及诸如此类的其他操作。我可以在任何类型的复数上使用所有这些过程，这真的很棒。

it says no matter whether things are glued together in rectangular form in polar form or maybe even in some other form my procedures will still work the selectors do the right thing to pull out the parts notice again how I've made sure that the contracts hold between

它表明，无论事物是以矩形形式、极坐标形式，甚至可能是其他形式粘合在一起的，我的过程仍然有效。选择器会做正确的事情来取出各个部分。再次注意我是如何确保构造函数和选择器之间的契约成立的。

sure that the contracts hold between contractors and selectors that's my standard message about data abstraction and finally notice how tags or types have made this possible for me

确保构造函数和选择器之间的契约成立，这是我关于数据抽象的标准信息。最后注意标签或类型是如何使这一切成为可能的。

my type label now lets an object specify how it should be used it lets us control the use of those objects and in particularly allows us to intertwine different versions of the same kind of object into a single coherent system

我的类型标签现在让对象能够指定它应该如何被使用；它让我们控制这些对象的使用，特别是允许我们将同一类对象的不同版本交织成一个连贯的系统。

so this silly little example motivates then the key idea that we're going to be using today that by putting tags on data structures

所以这个简单的小例子激发了我们将要使用的关键思想：通过给数据结构加上标签，

that by putting tags on data structures, we can identify the right kinds of operations to apply to that data structure. And indeed, a very careful way of programming would always provide tags on those data structures to provide us with the flexibility we'd like.

通过给数据结构加上标签，我们可以识别适用于该数据结构的正确操作类型。事实上，一种非常仔细的编程方式总是会在这些数据结构上提供标签，以赋予我们所需的灵活性。

So tag data now says we have an identifying symbol attached to all non-trivial data values. That means everything except things like numbers and strings.

因此，带标签的数据现在意味着我们为所有非平凡的数据值附加了一个标识符号。这意味着除了数字和字符串等之外的所有东西。

And secondly, we're going to try and set things up so that we always check that tag, that symbol, before operating on the data. Why? Well, as we'll see, there's

其次，我们将尝试设置一些机制，以便在操作数据之前总是检查那个标签，那个符号。为什么？嗯，正如我们将看到的，有

data why well as we'll see there's really two key reasons why tag data is the right way to go the first is that it makes available to us a very powerful idea called data directed programming

数据，为什么？嗯，正如我们将看到的，有两个关键原因说明带标签的数据是正确的方法。第一个是它使我们能够使用一个非常强大的思想，称为数据导向编程。

here the idea is to write procedures that let the type of a data object direct the correct procedure to apply or set a different way we're going to write procedures that look at the type of the data object and use that to determine what is this procedure that specifically tuned to that kind of object if you think about it we just did that in our

这里的思想是编写过程，让数据对象的类型指导应该应用哪个正确过程，或者换一种说法，我们将编写过程，查看数据对象的类型，并使用它来确定哪个过程是针对该特定类型对象专门调优的。如果你仔细想想，我们刚刚在我们的

think about it we just did that in our complex number example we just changed things so that the selectors use the data type to direct to the right computation another example might be an essay a graphics program suppose I want to compute the area of a figure rather than having to write one giant thing that does all of it I could actually use the label on the kind of figure to tell me what's the right thing to do if it's a triangle computed this way if it's a square computed that way if it's a circle compute it that way in all cases getting out the area but letting the

仔细想想，我们刚刚在我们的复数示例中就是这么做的：我们改变了选择器，使它们使用数据类型来指导正确的计算。另一个例子可能是一个图形程序。假设我想计算一个图形的面积，与其编写一个巨大的过程来处理所有情况，我实际上可以使用图形类型上的标签来告诉我该做什么：如果是三角形，就这样计算；如果是正方形，就那样计算；如果是圆形，就那样计算。在所有情况下都得到面积，但让

Getting out of the area but letting the type of the object tell me which procedure to use. This obviously leads to nice modular code that's going to be easier to deal with.

得到面积，但让对象的类型告诉我该使用哪个过程。这显然会导致良好的模块化代码，更容易处理。

The second key reason is that it gives us the ability to do what we call defensive programming. We want to be careful to make sure that we don't have unwarranted assumptions about inputs to our procedures.

第二个关键原因是它赋予我们进行所谓防御性编程的能力。我们要小心确保我们不会对过程的输入做出无根据的假设。

In particular, we want to make sure that we can fail gracefully when a procedure unexpectedly receives incorrect types of inputs, as you saw in my last example where I created the selector for a.

特别是，我们要确保当过程意外收到错误类型的输入时，我们能够优雅地失败，正如你在我的最后一个示例中看到的，我为一个复数创建了选择器。

where I created the selector for a complex number I basically did that I said if it's this kind of thing I know how to do that if it's this kind of thing I know how to do that otherwise tell the user that he gave me something I don't know how to deal with and of course the point is it's always better to give an error message back to the user than to try and assume that it's a particular kind of thing and end up returning garbage.

在我为复数创建选择器时，我基本上是这样做的：我说，如果是这种东西，我知道怎么处理；如果是那种东西，我也知道怎么处理；否则就告诉用户，他给我的东西我不知道怎么处理。当然，关键在于，总是给用户返回一个错误信息，比试图假设它是某种特定类型的东西、最终返回垃圾结果要好得多。

the point being of course that you may not spot that somebody's giving you back garbage till much later in the

重点当然在于，你可能直到计算进行到很后面才会发现有人返回了垃圾结果，

garbage till much later in the computation and then debugging your system becomes much much harder, so to summarize, we've introduced the idea of tagging data types. We've introduced that idea in order to enable us to build modular systems.

直到计算进行到很后面才会发现，然后调试你的系统就会变得困难得多。所以总结一下，我们引入了数据类型标签的概念。我们引入这个概念是为了使我们能够构建模块化系统。

And what we want now to do is look at how having those tags makes it much easier to build such systems, to show how to use both of these ideas—that is, the idea of data-directed programming and the idea of defensive programming. We're going to spend the rest of this lecture looking at an extended example.

我们现在想要做的是，看看拥有这些标签如何使构建这样的系统变得更容易，展示如何使用这两个思想——即数据导向编程和防御性编程。我们将用本讲座的剩余部分来研究一个扩展的例子。

extended example a quick word of warning we're going to look at a fair amount of code as we do this but as you'll see the code all builds on top of earlier versions of things in a nice hierarchical fashion so you should be able to follow along without too much effort and here's the example

扩展的例子，先提醒一句：在这个过程中我们会看到相当多的代码，但正如你将看到的，这些代码都以一种良好的层次化方式构建在早期版本的基础上，所以你应该能够毫不费力地跟上。这就是那个例子：

let's build a system to evaluate arithmetic expressions similar to the ones we built last time with our symbolic differentiator and what do I mean by that not only do I want to be able to create expressions using for example my constructors from before that make up

让我们构建一个求值算术表达式的系统，类似于我们上次用符号微分器构建的那些系统。我这么说是什么意思呢？不仅希望能够使用例如之前的构造函数来创建表达式，这些构造函数可以构造出

constructors from before that make up sums that give me out particular symbolic expressions like the one shown here.

构造函数可以构造出和式，从而给出特定的符号表达式，比如这里所示的这个。

But I also want to be able to try and reduce or evaluate those expressions down to their simplest form if possible.

但我也希望能够尝试将这些表达式化简或求值到它们的最简形式，如果可能的话。

And in the example shown here, I want to take that sum of just numbers and reduce it to the actual value of 38, building a little system that can evaluate these expressions to reduce them to simpler form.

在这个例子中，我想把那个只包含数字的和式化简为实际值38，构建一个小系统，能够对这些表达式进行求值，将它们化简为更简单的形式。

Certainly, will be interesting on its own, but I want to add more to my system. In particular, I want to have my system not

当然，这本身会很有趣，但我想给我的系统添加更多功能。特别是，我希望我的系统不仅

Particularly, I want to have my system not only simplify standard expressions but also be able to work on ranges of numbers. For example, I may only know that a number lies between two bounds, and I want my system to still be able to do computations based on that.

特别是，我希望我的系统不仅能够化简标准表达式，还能处理数字的范围。例如，我可能只知道一个数字位于两个边界之间，我希望我的系统仍然能够基于此进行计算。

As the example shows, it says if I only know that a number lies, say, between three and seven, and another number lies between, say, one and three, I want to be able to still add those ranges together and know that the resulting number must lie somewhere between four and ten.And I want to be

正如例子所示，如果我只知道一个数字位于，比如说，3和7之间，另一个数字位于，比如说，1和3之间，我希望能够将这些范围相加，并知道结果数字必定位于4和10之间。而且我希望

between four and ten and I want to be able to have my system work with scientific experiment numbers that is suppose I only know a number up until sum of precision I'd still like to be able to evaluate those expressions for example saying 100 plus or minus 1 plus 3 plus or minus 1/2 gives me 100 and 3 plus or minus some other range in this case 1 and a half so that's my goal

位于4和10之间，而且我希望我的系统能够处理科学实验中的数字，也就是说，假设我只知道一个数字达到一定的精度，我仍然希望能够对这些表达式进行求值，例如，100加减1加上3加减1/2，得到100和3加减某个其他范围，在这种情况下是1.5。这就是我的目标。

I want to build an arithmetic evaluation system something that evaluates expressions that tries to reduce them to simplest forms and deals with standard expressions ranges and limited precision

我想构建一个算术求值系统，一个对表达式进行求值、试图将它们化简为最简形式，并处理标准表达式、范围和有限精度的系统。

expressions ranges and limited precision values, the basic approach we're going to take is to start with easy things first. In other words, we're going to do this little evaluation system for numbers and then we'll worry about extending it to more complicated things like ranges and limited precision numbers.

表达式、范围和有限精度的值。我们将采用的基本方法是先做简单的事情。换句话说，我们将先为数字实现这个小求值系统，然后再考虑将其扩展到更复杂的事物，如范围和有限精度数字。

This sounds obvious, kind of like motherhood and apple pie, but in fact it's a very important characteristic of a well-designed software engineering project. It's always easier to extend a base system than to try and do the whole thing at once, and that's an important principle.

这听起来显而易见，有点像老生常谈，但实际上，这是一个设计良好的软件工程项目的重要特征。扩展一个基础系统总是比试图一次性完成所有事情更容易，这是一个重要的原则。

thing at once and that's an important lesson to learn as you go to about creating your own systems one of the things you should watch for as we go through this exercise is to notice how by doing it in this way starting with base things and then generalizing enables us to easily extend our system

一次性完成所有事情，这是你在创建自己的系统时需要学习的重要一课。在我们进行这个练习时，你应该注意的一点是，通过这种方式，从基础事物开始，然后进行推广，我们能够轻松地扩展我们的系统。

our goal in fact is to build our evaluator in such a way that it will both extend easily and safely and what does that mean easily means that we're going to have to use data directed programming to make things happen or set a little bit better if we use data

事实上，我们的目标是构建我们的求值器，使其既能轻松扩展又能安全扩展。这意味着什么？轻松意味着我们将不得不使用数据导向编程来实现事情，或者如果我们使用数据导向编程，情况会好一点。

a little bit better if we use data directed programming as we construct our evaluator remember that means we're going to put tags on things and use the tags that tell us how to dispatch off to the right procedure.

如果我们使用数据导向编程来构建我们的求值器，情况会好一点。记住，这意味着我们将给事物打上标签，并使用这些标签来告诉我们如何分派到正确的过程。

if we do that it will then be easy to add in new types of things it's just a matter of creating the right tags for those structures creating the representations for those structures and then creating the dispatch into the procedure to handle that new type of object.

如果我们这样做，那么添加新类型的事物就会变得容易，只需为这些结构创建正确的标签，为这些结构创建表示，然后创建分派到处理该新类型对象的过程。

to support safe extension is going to require that we use defensive programming that is that.

为了支持安全扩展，将要求我们使用防御性编程，也就是说，

use defensive programming that is that we be careful about how we design these things we make sure we put the right error checks in in the right place and we're otherwise conscious about always using the tags to tell us how to go to the right place

使用防御性编程，也就是说，我们要小心设计这些东西，确保在正确的位置放置正确的错误检查，并且始终注意使用标签来告诉我们如何到达正确的位置。

so as I said I'd like you to watch for how both of those themes intertwine here as we build our evaluator for dealing with expressions

所以，正如我所说，我希望你们注意这两个主题在我们构建处理表达式的求值器时是如何交织在一起的。

to do this then here's what we're going to do we're going to first build our evaluator for dealing with simple expressions just numbers

为此，我们将这样做：首先构建我们的求值器来处理简单的表达式，即仅数字。

Going to look at a second version that extends this in the obvious manner, but which we will use to see that in fact it does the wrong thing, that incorrect observed behavior.

然后看第二个版本，它以明显的方式扩展了第一个版本，但我们将用它来看到它实际上做了错误的事情，即观察到的不正确行为。

We're going to then use to actually fix the system, and we're going to continue to execute a series of cycles in which we extend the system, observe the behavior, and use the incorrect behaviors that we actually spot to build a new extension that does the right thing.

然后我们将用它来实际修复系统，并继续执行一系列循环，在循环中我们扩展系统，观察行为，并利用我们实际发现的错误行为来构建一个新的扩展，以做正确的事情。

As a consequence, we're going to walk through a series of such extensions, looking at how both data

因此，我们将逐步经历一系列这样的扩展，考察数据和

extensions looking at how both data directed programming and defensive programming enable us to actually build a system that handles a large range of different kinds of objects. So let's start with our some expressions first, we can build a constructor and here it is. Notice the type, by the way, of this constructor: it's going to take in two expressions of any form and create for us a thing that has a type of a sum expression. And by that we mean an expression that is specifically labeled as being a sum. Notice how we do it: we're going to attach the tag to the front of

扩展，考察数据导向编程和防御性编程如何使我们能够构建一个处理各种不同对象的系统。那么让我们从我们的求和表达式开始，我们可以构建一个构造函数，就在这里。顺便注意一下这个构造函数的类型：它将接受任意形式的两个表达式，并为我们创建一个具有求和表达式类型的东西。我们的意思是，一个被特别标记为求和的表达式。注意我们是如何做到的：我们将标签附加到

going to attach the tag to the front of it and here we're going to take advantage of the fact that plus tells us what kind of thing we have so our constructor takes in two expressions of any form and creates a new tagged data type with the symbol plus identifying that it's a sum as well as the other pieces glued together.

将标签附加到其前面，这里我们将利用加号告诉我们所拥有的东西的种类这一事实，因此我们的构造函数接受任意形式的两个表达式，并创建一个带有符号加号的新标记数据类型，标识它是一个求和，以及其他部分粘合在一起。

associated with this object will be a predicate to detect such objects we have to find sums so here's our predicate notice it's type it takes in something of any form and returns a boolean telling us whether or not this is a song look at the body

与此对象相关联的将是一个谓词来检测此类对象，我们必须找到求和，所以这是我们的谓词，注意它的类型，它接受任意形式的东西并返回一个布尔值，告诉我们这是否是一个求和，看函数体

not this is a song look at the body notice that we first check to see that this expression is a pair you might ask why and the answer course is in order to take the car of that expression we have to make sure it's a pair we want to take the car so we can check to see if the first element of this thing is the special symbol plus in other words is this actually a sum

不是这是否是一个求和，看函数体，注意我们首先检查这个表达式是否是一个序对，你可能会问为什么，答案当然是为了取该表达式的car，我们必须确保它是一个序对，我们想要取car，以便检查这个东西的第一个元素是否是特殊符号加号，换句话说，这实际上是否是一个求和。

so they're two key things here first note the defensive programming we're checking to make sure we can use car that it's safe to do that before we go off and find it so we won't

所以这里有两个关键点，首先注意防御性编程，我们检查以确保我们可以使用car，确保在我们继续并找到它之前是安全的，这样我们就不会

before we go off and find it so we won't hit an error the second thing is notice again the use of the symbol and checking of equality of symbols in order to decide what kind of these this thing is and of course we'll need selectors for the data structures so our types here will be things that take in some expressions and we'll reduce out the expression by pulling out the right pieces.

在我们继续并找到它之前是安全的，这样我们就不会遇到错误；第二点再次注意使用符号和检查符号相等性来决定这个东西是哪种类型，当然我们还需要数据结构的选择器，所以我们的类型将是接受一些表达式并提取正确部分来简化表达式的东西。

notice by the way that we can assume that we've already checked the type of the object before we apply these selectors so we can safely go ahead and get the quatre in the category of those.

顺便注意，我们可以假设在应用这些选择器之前我们已经检查了对象的类型，所以我们可以安全地继续获取这两部分中的car。

get the quatre in the category of those two pieces, this is a pretty standard data abstraction, it's much like the kinds we've been building for the past several lectures. The only difference here is we're checking types, and we're assuming that we've already checked the type before we use selectors.

获取这两部分中的car，这是一个相当标准的数据抽象，很像我们过去几节课一直在构建的那种。这里唯一的区别是我们检查类型，并且我们假设在使用选择器之前已经检查了类型。

The last thing to keep in mind is that here we're just dealing with sums, so the expressions are obviously just going to be expressions of sums, as we might expect. However, as we'll see as we go along, the type of the expression will be different.

最后要记住的是，这里我们只处理求和，所以表达式显然只是求和的表达式，正如我们可能期望的那样。然而，随着我们继续，表达式的类型将会不同。

type of the expression will be different in the different versions of a Val and that's one of the key themes we want to pick up on given this starting point we can fairly easily implement our evaluator for reducing sums notice the type it's going to take in either a number or one of these some expressions and what we want to get back out is a number and how do we do it well if the thing is just a number return that number notice what we're doing here in our data directed style we're going to first check the type of the expression is it a number just using the built in

表达式的类型在Val的不同版本中会不同，这是我们想要抓住的关键主题之一。有了这个起点，我们可以相当容易地实现我们的求值器来化简求和，注意它的类型，它将接受一个数字或这些求和表达式之一，而我们想要返回的是一个数字，我们怎么做呢？如果这个东西只是一个数字，就返回那个数字，注意我们在这里以数据导向的风格所做的是，我们首先检查表达式的类型，它是否是一个数字，只使用内置的

is it a number just using the built in scheme primitive for checking numbers having identified that type we can then just return the value of the expression if it's not a number then we'll check to see is it a sum expression using that predicate we just created if we get one of those those things then notice what we do we use the selectors to pull out the pieces of that expression and I'll remind you that we're safe and applying those because we've used the predicate to check to make sure we have such a sum having pulled out those pieces will

它是否是一个数字，只使用内置的Scheme原语来检查数字，识别出该类型后，我们就可以直接返回表达式的值；如果它不是数字，那么我们将检查它是否是一个求和表达式，使用我们刚刚创建的谓词，如果我们得到其中之一，注意我们使用选择器来提取该表达式的部分，我提醒你我们应用这些是安全的，因为我们已经使用谓词检查确保我们有一个这样的求和，提取出那些部分后，我们将

having pulled out those pieces will recursively apply our evaluator to reduce those sums this will allow us to deal with more complicated things and reduce them down to simpler pieces.

提取出那些部分后，我们将递归应用我们的求值器来化简这些求和，这将使我们能够处理更复杂的事物并将它们化简为更简单的部分。

we're guaranteed that a Val returns a number if we've done it right so we can simply then add up the results of those two things and return that new number as our overall value.

我们保证如果做得正确，Val会返回一个数字，所以我们可以简单地将这两个结果相加，并将那个新数字作为我们的整体值返回。

and finally notice the defense of programming if the beast we get in is neither a number nor a sum expression at this stage we don't know how to deal with it so let's complain to.

最后注意防御性编程，如果我们得到的对象既不是数字也不是求和表达式，在这个阶段我们不知道如何处理它，所以让我们抱怨

how to deal with it so let's complain to the user and let them figure out what's the right thing to do notice by the way

如何处理它，所以让我们向用户抱怨，让他们弄清楚正确的事情是什么，顺便注意

the nice form here in essence what we have is a base case or simple primitives of numbers or a recursive case in which we pull out the pieces reduce it to simpler problems recursively apply the evaluation and then reduce that to another answer

这里的美妙形式，本质上我们有的是一个基本情况，即数字的简单原语，或者一个递归情况，在其中我们提取部分，将其化简为更简单的问题，递归应用求值，然后将其化简为另一个答案。

if we apply this procedure to a sum that includes within it both numbers and other sums in fact it'll do the right thing and you could should be able to trace this truth to realize how given that this is a sum

如果我们将这个过程应用于一个包含数字和其他求和的求和，事实上它会做正确的事情，你应该能够追踪这个过程来意识到，鉴于这是一个求和

realize how given that this is a sum it will first evaluate the first part which is as false in number it will evaluate the second part which is a sum and will recursively reduce that to eight add it to four and give us back the twelve we want so there's a little system takes in some expressions reduces them to simpler forms.

意识到，鉴于这是一个求和，它将首先求值第一部分，它是一个数字，然后求值第二部分，它是一个求和，并将递归化简为8，加上4，给我们返回我们想要的12。所以有一个小系统，接受一些表达式并将它们化简为更简单的形式。

now let's see what happens as we try to extend it okay now let's try the obvious extension let's extend our system to deal with ranges as well here we'll need to build an abstract data type for range and to do it the dumb way

现在让我们看看当我们尝试扩展它时会发生什么。好的，现在让我们尝试明显的扩展，让我们扩展我们的系统来处理区间，这里我们需要为区间构建一个抽象数据类型，并以愚蠢的方式来做

type for range and to do it the dumb way, we'll do it without tags as a consequence. Our constructor for a range will take in two numbers and return one of these range objects, and we'll just do it by listing the min and Max values together in that kind of structure.

对于范围类型，我们采用一种简单的方式，不使用标签。我们的范围构造函数将接受两个数字，并返回一个范围对象，我们只需将最小值和最大值以列表结构的形式组合在一起。

Given that choice for constructor, the selectors are easy. Selectors for min and Max will take in one of these range objects, a list that's been glued together, and we'll simply reduce it down to the piece that you want, either pulling out the car or the cdr to get the min or max value. This just satisfies.

鉴于构造函数的这种选择，选择器就很简单了。最小值和最大值的选择器将接受一个范围对象（一个已组合的列表），然后我们只需将其缩减为你想要的片段，要么取出car，要么取出cdr，以获得最小值或最大值。这正好满足了约定。

the min or max value this just satisfies the contract by building on the contract for lists then building a procedure to add ranges is just a matter of doing the right thing where that means use the selectors to get out the right pieces add them together by applying normal addition to the numbers and then gluing them back together

最小值或最大值，这正好满足了约定，因为它是建立在列表约定之上的。然后，构建一个范围相加的过程，只需做正确的事情，即使用选择器取出正确的部分，通过将普通加法应用于这些数字来将它们相加，然后再将它们组合在一起。

let's look at this carefully we're using range min to select out the parts we know it's going to by its type definition give us out a number so we're safe and applying plus to that to get a new number do the same

让我们仔细看看。我们使用range-min来选择出各个部分，根据其类型定义，我们知道它会给我们一个数字，所以我们可以安全地将加号应用于它，得到一个新的数字。

To that, to get a new number, do the same thing with Max and then having two numbers, we can use the constructor make range to glue those pieces together, which will guarantee that the type of this overall addition is taking a range of two and arrange two in and producing a range two is output. Using this representation for ranges, we can now build our second shot at an evaluator.

对最大值做同样的操作，得到一个新的数字。然后，有了两个数字，我们可以使用构造函数make-range将这些部分组合在一起，这将保证整个加法操作的类型是：接受两个范围，并产生一个范围作为输出。使用这种范围的表示，我们现在可以构建我们的第二个求值器。

Notice the type we'd like for this thing. It should take in either a number or arrange one of these range two things or a sum expression, and we would like it to give back out either a number if the

注意我们希望这个东西具有的类型。它应该接受一个数字、一个范围（即range-two类型的东西）或一个和表达式，并且我们希望它返回一个数字（如果……）

give back out either a number if the thing can be reduced to that or another range if the thing in form of arranged so here's the procedure to do it and look at its structure this is our second evaluator I broken one we admit notice what it does as before it's going to check to see if this is a number and just return that value if it is

返回一个数字（如果该事物可以被化简为数字）或另一个范围（如果该事物是范围形式）。下面是实现它的过程，看看它的结构。这是我们的第二个求值器，我们承认它是有缺陷的。注意它做了什么：和之前一样，它会检查这是否是一个数字，如果是，就直接返回该值。

it's also going to check using the predicate to see and the tag to see if it's a sum expression if it is notice what it's going to do as before is going to try and recursively evaluate those two pieces using the new evaluator

它还会使用谓词和标签来检查它是否是一个和表达式。如果是，注意它将做什么：和之前一样，它将尝试使用新的求值器递归地求值这两个部分。

those two pieces using the new evaluator, and then it's going to try and be clever. And by cleverness we mean if both of the pieces or numbers we'll just add them together to reduce down to a number.

使用新的求值器求值这两个部分，然后它将尝试变得聪明。这里的聪明是指，如果两个部分都是数字，我们就将它们相加，化简为一个数字。

Otherwise we'll use range add to add the two ranges together to give us back the range we want. So the idea is that we've got a sum, we're going to get the values of the pieces recursively and then glue them together using the fact that if they're numbers we want a number, otherwise we want ranges.

否则，我们将使用range-add将两个范围相加，以得到我们想要的范围。所以思路是，我们有一个和，我们将递归地获取各部分的值，然后利用以下事实将它们组合在一起：如果它们是数字，我们想要一个数字；否则，我们想要范围。

And then the last check is if the object is neither a

然后最后一个检查是，如果对象既不是数字也不是……

最后一步检查是看这个对象是否既不是数字也不是某种类型，我们会检查它是否是pair，如果是pair，我们就假定它是一个范围，因为这是我们构建范围时所做的选择。在这种情况下，我们直接返回这个表达式，因为我们无法再进一步简化这个范围了。

最后一步检查是看这个对象是否既不是数字也不是某种类型，我们会检查它是否是pair，如果是pair，我们就假定它是一个范围，因为这是我们构建范围时所做的选择。在这种情况下，我们直接返回这个表达式，因为我们无法再进一步简化这个范围了。

当然，防御性地来说，否则我们会报错。看起来没问题。好吧，让我们看看，正如你可能已经猜到的，其实并不是这样。这里有几个例子说明这个系统不能正常工作。看第一个例子，如果我尝试...

当然，防御性地来说，否则我们会报错。看起来没问题。好吧，让我们看看，正如你可能已经猜到的，其实并不是这样。这里有几个例子说明这个系统不能正常工作。看第一个例子，如果我尝试……

look at the first example if I try and construct a sum of a number and a range and then evaluate that I'm going to get into trouble because in fact I haven't allowed for all possible cases and in this case the system is going to complain you can check through the code to see where it's going to complain and it's basically if you figure it out going to complain because it's going to try and add two ranges together and for obviously isn't a pair it can't do anything with it notice why by the way the system is making this mistake this

看第一个例子，如果我尝试构造一个数字和一个范围的和，然后对其进行求值，我会遇到麻烦，因为实际上我没有考虑到所有可能的情况。在这种情况下，系统会报错。你可以检查代码，看看它会在哪里报错，基本上如果你能弄清楚，它会报错，因为它会尝试将两个范围相加，而对于显然不是pair的东西，它无法做任何操作。顺便注意一下，为什么系统会犯这个错误。

The system is making this mistake, this is in large part because our code is making assumptions about how data structures are represented in the system, in particular, how we're representing ranges. We haven't dealt with all possible cases of crossovers of different types, and this is causing us a problem because we haven't identified the data type properly.

系统会犯这个错误，很大程度上是因为我们的代码对数据结构在系统中的表示方式做了假设，特别是我们如何表示范围。我们没有处理所有可能的类型交叉情况，这给我们带来了问题，因为我们没有正确识别数据类型。

So the first problem is we're missing a case, and here's the second problem: we really weren't very defensive here. Suppose we go ahead and add a limited precision data type to our system, then a val 2

所以第一个问题是我们缺少一种情况，这是第二个问题：我们确实不够防御性。假设我们向系统中添加一个有限精度数据类型，那么eval 2……

data type to our system then a val 2 will produce an answer, but a wrong one. And remember what we really like is for the system to know it can't handle this kind of object and tell us, not give us something that we are misled into believing is actually correct.

向系统中添加一个有限精度数据类型，那么eval 2会产生一个答案，但却是错误的。记住，我们真正希望的是系统知道它无法处理这种对象，并告诉我们，而不是给我们一些误导我们相信它是正确的东西。

In this particular case, we've made a limited precision number using the same idea of just listing things together as we did with ranges. And now when we go ahead and add these two pieces together, we have no way of distinguishing them. It's a lot like our complex number example we started with.

在这个特定的例子中，我们使用与范围相同的想法（即简单地将事物列表化）创建了一个有限精度数字。现在当我们继续将这两个部分相加时，我们无法区分它们。这很像我们开始时提到的复数例子。

complex number example we started with unfortunately in this case the system can blithely go ahead and add these numbers reduce them down but it ends up with giving us something that's completely wrong this should either be the range of 13 to 17 or it should be 15 plus or minus 2 depending whether we want this as a range or as a limit of precision representation

复数例子，不幸的是，在这种情况下，系统可以轻率地继续将这些数字相加，将它们化简，但最终给我们一个完全错误的结果。这应该是范围13到17，或者应该是15加减2，取决于我们想要的是范围表示还是有限精度表示。

but of course it gives us something that's neither and is really confusing and will cause us to be misinterpreting what this object represents so in this case we're not being defensive and we're going to get

但当然，它给我们的东西两者都不是，而且非常令人困惑，将导致我们误解这个对象所代表的内容。所以在这种情况下，我们没有防御性，我们将……

Being defensive and we're going to get ourselves into trouble so even though we're using a very simple example it nicely highlights some of the key lessons to be learned in building computational systems. The first is the one we just observed that we can end up calling the function on the wrong type of data and that can come about for a variety of reasons. It could come about because we missed it-- it could come about because we had brain lock or set a little better we made an assumption about something that wasn't safe to make as we just saw in our

没有防御性，我们将陷入麻烦。所以即使我们使用一个非常简单的例子，它也很好地突出了构建计算系统时要学习的一些关键教训。第一个是我们刚刚观察到的，我们最终可能在错误的数据类型上调用函数，这可能有多种原因。可能是因为我们遗漏了——可能是因为我们思维卡住了，或者更准确地说，我们做了一个不安全的假设，就像我们刚刚在……中看到的那样。

safe to make as we just saw in our example where we ended up representing limit to precision numbers and ranges which in principle talk about the same kind of thing but we mixed the representations together without being able to separate them by type.

正如我们刚才的例子中所看到的，我们可以安全地做出这种表示，其中我们最终用精度限制的数字和范围来表示，原则上它们谈论的是同一种事物，但我们混合了这些表示，却无法按类型将它们分开。

this kind of bug can also show up when we go about changing one part of a program and don't deal with another one that relates to it.

当我们修改程序的一部分而没有处理与之相关的另一部分时，这种错误也会出现。

all three of these sources can cause this kind of problem the result of course is that the system is going to return stuff that's not useful if we're

这三个来源都可能导致这类问题，结果当然是系统会返回无用的东西，如果我们幸运的话，它会在非常简单的事情上失败，我们能够发现它，但情况并非总是如此，有时

return stuff that's not useful if we're lucky it'll actually fail on something very easy and we'll be able to spot it but that's not always the case sometimes

返回无用的东西，如果我们幸运的话，它会在非常简单的事情上失败，我们能够发现它，但情况并非总是如此，有时

the system will produce an answer that is perfectly legitimate but just wrong and that will get passed down through the system being processed by a number of procedures until finally something fails much later downstream but now we're start trying to figure out what caused it the cause may be much earlier in the stage and we won't be able to easily spot it the real bad case is in which the program in fact continues to

系统会产生一个完全合法但错误的答案，然后这个答案会在系统中传递，被许多过程处理，直到最终在更下游的某个地方失败，但现在我们开始试图找出原因，原因可能在更早的阶段，我们不容易发现它。真正糟糕的情况是程序实际上继续

which the program in fact continues to process appropriately, shouldn't say appropriately, continues to process and produces an answer, but one that's completely incorrect. We have no way of spotting that, and that's a real problem.

程序实际上继续适当地处理，不应该说适当地，继续处理并产生一个答案，但一个完全错误的答案。我们没有办法发现它，这是一个真正的问题。

Of course, the key problem here, you can already see, we're being far too loose in how we use underlying data types to represent our current data structures. We're using lists to represent ranges without putting an appropriate label on, and that's the obvious fix to go back in and use tags to keep track of each of the data types.

当然，这里的关键问题，你已经可以看到，我们在使用底层数据类型来表示当前的数据结构时过于松散。我们使用列表来表示范围，而没有加上适当的标签，明显的修复方法是回去使用标签来跟踪每种数据类型。

to keep track of each of the data types and not rely on different underlying base representations to tell us what kind of Beast we have so let's go back and look at our some expressions with this idea of using tagging and in fact they're already tagged the first part of the expression actually tells us what kind of Beast this is so let's pull that out explicitly by restructuring our data abstraction to isolate the tag and its use so we'll create a specific label called a sum tag which we're going to represent is the symbol plus but

跟踪每种数据类型，而不是依赖不同的底层基础表示来告诉我们这是什么类型的野兽。所以让我们回到我们的求和表达式，带着使用标签的想法，事实上它们已经被标记了，表达式的第一部分实际上告诉我们这是什么类型的野兽，所以让我们通过重构我们的数据抽象来明确地提取它，以隔离标签及其使用，我们将创建一个特定的标签称为求和标签，我们将用符号加号来表示，但

represent is the symbol plus but of course we could easily change that because we've built in an abstraction isolating the representation of the sum tag from the name of the sum tag. Then we can change our constructor again. We're going to glue two pieces together in a list and we'll put the sum tag up front.

用符号加号来表示，但当然我们可以很容易地改变它，因为我们已经建立了一个抽象，将求和标签的表示与求和标签的名称隔离开来。然后我们可以再次改变我们的构造函数。我们将把两个部分粘合在一个列表中，并将求和标签放在前面。

Again, notice by using the name sum tag we've isolated out the particulars of how we represent that tag from the use of the tag. And of course the predicate also has to change. Now we're checking to see if the first element of this pair, assuming it is a pair, as actually is.

再次注意，通过使用求和标签这个名字，我们已经将我们如何表示该标签的细节与标签的使用隔离开来。当然，谓词也必须改变。现在我们检查这个对的第一个元素，假设它是一个对，实际上确实是。

As usual, assuming it is a pair as actually is, equal to whatever the value of some tag is. The key point is in this case some expression is not ambiguous; it's only going to return a true value for things that are made by make some, assuming of course that we don't use the tag plus in some other way.

像往常一样，假设它是一个对，实际上确实是，等于求和标签的值。关键点是，在这种情况下，求和表达式不是模糊的；它只对由 make-sum 制作的东西返回真值，当然假设我们不以其他方式使用加号标签。

Also notice how it's going to be easy to change this if we want to use a different representation for some tag. All we have to do is change that definition, and everything else will follow through. Okay, in this new more disciplined way of using tags, we also have to go back and label.

还要注意，如果我们想为求和标签使用不同的表示，改变它会很容易。我们只需要改变那个定义，其他一切都会随之改变。好的，在这种更规范的使用标签的新方式中，我们还必须回去标记

tags we also have to go back and label our basic things our primitives our constants so we'll create a tag for that. We'll use the symbol cost to rent it but again notice how by giving a name to that particular choice we'll be able to also make easy changes.

标签，我们还必须回去标记我们的基本事物，我们的原语，我们的常量，所以我们将为此创建一个标签。我们将使用符号 CONST 来表示它，但再次注意，通过给那个特定选择一个名字，我们也将能够轻松地进行更改。

Now what else do we need? Well in this case we're going to need a specific and explicit constructor something that takes in a number and produces a constant expression by gluing that tag on to the front notice the change from my earlier version where we just use numbers directly and as with

现在还需要什么？好吧，在这种情况下，我们将需要一个具体而明确的构造函数，它接受一个数字并通过将标签粘在前面来产生一个常量表达式，注意与我早期版本的变化，那时我们直接使用数字，并且与

Just use numbers directly. And as with the other things, we'll need a predicate to see if it is a constant expression. Again, notice the use of pair to make sure I can take out pieces of it. Then the checking to see whether the first element of this pair is equal to the value of the constant tag, that is to the symbol in this case CONST. And since I'm building a data structure, not only do I have to get the tag out, I'll also have to get out the value of it.

直接使用数字。与其他事物一样，我们需要一个谓词来检查它是否是一个常量表达式。再次注意使用 pair 来确保我可以取出其中的部分。然后检查这个对的第一个元素是否等于常量标签的值，即在这种情况下是符号 CONST。由于我正在构建一个数据结构，我不仅必须取出标签，还必须取出它的值。

So my selector now will be something that takes in a constant expression, strips off the tag, and reduces down to the value.

所以我的选择器现在将是接受一个常量表达式，剥离标签，并简化为值。

Off the tag and reduces down to the actual value or the number that's associated with it. So again, here we see a tag now at the front of this structure, a particular constructor that glues it together, and predicates and selectors, and the types associated with each of those.

剥离标签并简化为实际值或与之关联的数字。所以再次，我们在这里看到这个结构前面的一个标签，一个特定的构造函数将其粘合在一起，以及谓词和选择器，以及与每个相关联的类型。

Great. Now we can restructure our eval system, and here's the new version. First notice the type with this. It should take in either a constant expression or a sum expression (we haven't gotten to two ranges yet), takes in either constant expression or some expression, and produces out a number.

很好。现在我们可以重构我们的求值系统，这是新版本。首先注意它的类型。它应该接受一个常量表达式或一个求和表达式（我们还没有涉及到两个范围），接受常量表达式或求和表达式，并产生一个数字。

expression and produces out a number it sounds good and notice how it does it in this case it's got a very explicit type checker on each of the tags to decide the kind of beast is it a constant is it a sum we're not using number here to check constant expressions we're using the explicit tag typing.

表达式并产生一个数字，听起来不错，注意它在这种情况下是如何做的，它在每个标签上有一个非常明确的类型检查器来决定它是什么类型的野兽：它是常量还是求和？我们在这里不使用数字来检查常量表达式，我们使用明确的标签类型。

this leads to a very nice overall structure it has a case for each kind of object about which it knows and it has a failsafe there's that defensive program this means if we give it some other thing than a sum or a number it will tell us rather than

这导致了一个非常好的整体结构，它为它知道的每种对象都有一个情况，并且有一个故障保护，这是防御性编程，这意味着如果我们给它一个不是求和或数字的东西，它会告诉我们，而不是

number it will tell us rather than assuming what we gave it fits one of its particular data types and of course for a constant it's easy we just peel off the tag and return the number that's all we want for some well we'll again pull out the pieces using the selectors reduce those by recursively applying our evaluator and then add them together to reduce out the number and return it.

数字，它会告诉我们，而不是假设我们给它的东西符合它的某种特定数据类型。当然，对于常量来说这很容易：我们只需剥掉标签，返回数字即可。对于求和表达式，我们同样使用选择器取出各个部分，通过递归应用我们的求值器来简化它们，然后将它们相加，简化出数字并返回。

looks nice right well in fact it does look like it's got the right form but we've still made a careless assumption and notice what happens if we construct

看起来不错，对吧？事实上，它的形式看起来确实正确，但我们仍然做了一个粗心的假设。注意，如果我们构造一个……

and notice what happens if we construct a sum with the constant 3 and the constant 5 and we evaluate it. Gee, you're just going to first deal with this as a sum, it's going to strip out the pieces, the two constants is going to simplify those and then add them together.

注意，如果我们构造一个由常量3和常量5组成的求和表达式并对其求值，会发生什么。哎呀，你只会先把它当作一个求和来处理，取出各个部分，两个常量，简化它们，然后将它们相加。

But notice what it returns—it returns a number, not an expression. And the problem is that we've made this unwarranted assumption. In particular, not all of the non-trivial values used in this code are tagged, and so we can still bomb out by trying to add a tagged thing to a non-tagged thing.

但注意它返回的是什么——它返回的是一个数字，而不是一个表达式。问题在于我们做了一个没有根据的假设。特别是，并非所有在此代码中使用的非平凡值都带有标签，因此我们仍然可能因为试图将一个带标签的东西与一个不带标签的东西相加而崩溃。

tagged thing tagged thing okay we're getting closer but we still have to fix this fortunately the fix is easy we need to change the type characteristics to return a tagged object that is a constant rather than a number or if you prefer we need to make sure we put the tag on the number as we return it so here is our new and improved eval for the constant expression it just returns the expression as before we're guaranteed that that's labeled if the tag type and notice the difference before we script off the tag and return the number here we're returning the

带标签的东西，带标签的东西。好吧，我们越来越接近了，但我们仍然需要修复这个问题。幸运的是，修复很容易：我们需要改变类型特征，使其返回一个带标签的对象，即一个常量，而不是一个数字；或者，如果你愿意，我们需要确保在返回数字时给它加上标签。所以这是我们新的改进版的常量表达式求值器：它像之前一样直接返回表达式，我们保证它带有标签，如果标签类型正确。注意区别：之前我们剥掉标签并返回数字，而这里我们返回的是整个带标签的东西，以满足我们新的类型特征。对于求和，注意我们做了什么：我们首先使用选择器取出各个部分，即被加数和加数，然后递归应用求值器将它们简化为更简单的表达式。注意，根据我们的约定，如果我们做得正确，它们将返回常量表达式，而不是数字，而是带标签的东西。然后我们使用正确的选择器取出值，保证我们现在得到的是数字，我们可以将它们相加，然后……

the number here we're returning the whole tag thing meeting our new type characteristic for sums notice what we do we first pull out the pieces we're using the selectors for ad end and Audient we then recursively apply a val to those to reduce those to a simpler expression notice by our contract they are going to return if we've done it right constant expressions not numbers but tag things so we'll then select out the values using the right selector for constants guaranteed that we now have numbers we can add them and then we can

数字，我们可以将它们相加，然后通过将常量标签粘在前面来构造一个新的带标签的类型。看起来代码更多了，但实际上它更清晰了。

numbers we can add them and then we can construct back up a new tag type by gluing that constant tag on the front of this. It looks like more code but it's actually a much cleaner again.

取出各个部分，进行简化，取出正确部分，简化，然后创建一个标签结构作为输出。注意，在这两种情况下，我们现在都保证得到一个常量表达式作为输出，而不是一个数字。

Select out the pieces, do the reduction, take that, get out the right portion, reduce that, and then create a tag structure as the output. Notice in both cases now we're guaranteed to get a constant expression out as our output, not a number.

取出各个部分，进行简化，取出正确部分，简化，然后创建一个标签结构作为输出。注意，在这两种情况下，我们现在都保证得到一个常量表达式作为输出，而不是一个数字。

And now this does the right thing. If we evaluate a sum of two constants, it returns the labeled number eight—that is, it's a constant with the

现在这做了正确的事情。如果我们求值两个常量的和，它返回带标签的数字8——也就是说，它是一个常量，带有……

eight that is it's a constant with the tag in front of it and the value eight associated with it it's now satisfying this new type contract and in fact doing the right thing if you look back at this code you can see that in this version as opposed to the previous one every case in the procedure assumes tagged input uses selectors to get out the contents and constructs up a tag output it's meeting a contract that's much better in principle this is a good thing to do it's going to lead to better behavior but in fact it's not actually clean programming notice what we've done we've

8，也就是说，它是一个常量，前面有标签，并且关联值为8。它现在满足了这个新的类型契约，并且实际上做了正确的事情。如果你回顾这段代码，你可以看到，在这个版本中，与之前的版本相比，过程中的每个案例都假设输入是带标签的，使用选择器取出内容，并构造一个带标签的输出。它满足了一个好得多的契约。原则上，这是一件好事，它将带来更好的行为，但实际上这并不是干净的编程。注意我们做了什么：我们实际上将数据类型上的操作交织在了我们的过程中。让我们修复这个问题。让我们将其拉回到外部，作为数据抽象的一部分，然后让我们的求值方法变得更加干净。

Programming notice what we've done we've actually intertwined operations on data types inside our procedure. Let's fix that. Let's pull that back outside to be a part of the data abstraction, and then allow our evaluation method to become much cleaner.

编程，注意我们做了什么：我们实际上将数据类型上的操作交织在了我们的过程中。让我们修复这个问题。让我们将其拉回到外部，作为数据抽象的一部分，然后让我们的求值方法变得更加干净。

In particular, let's let our thing for adding constants use the selectors to get out the parts, do the right thing, and constructs to select extras. I construct a new data structure out the back end. This is the form we've seen before. This is nice and clean, it has a simple type contract, and it does the right thing.

特别是，让我们让我们的常量加法过程使用选择器取出各个部分，做正确的事情，并构造出正确的数据结构。这是我们已经见过的形式。这很好，很干净，有一个简单的类型契约，并且做了正确的事情。

type contract and it does the right thing of using the selectors and constructors associated with this particular data object. Having done that, our evaluator now has a much better form and it still satisfies the same kind of type contract.

类型契约，并且做了正确的事情，即使用与该特定数据对象关联的选择器和构造器。完成这些之后，我们的求值器现在有了更好的形式，并且仍然满足相同类型的契约。

Here it uses predicate Stu to check each type of a data object, with the failsafe to deal with the ones we don't know how to deal with, and otherwise it simply dispatches to the right kind of procedure.

这里它使用谓词来检查数据对象的每种类型，并有一个兜底来处理我们不知道如何处理的类型，否则它只是分派到正确的过程。

There are no data construction and manipulation things intertwined within this evaluator, other than the selectors to pull out the

在这个求值器中，除了用于递归应用求值器的选择器之外，没有数据构造和操作交织在一起。

other than the selectors to pull out the pieces for the recursive application of a Val, so a much cleaner way of doing this that still preserves the behavior we now want in terms of dispatching on type. So now we can step back and see what we've learned here: we now have a standard pattern for building one of these abstract data types with tag data.

除了用于递归应用求值器的选择器之外，没有数据构造和操作交织在一起，因此这是一种更干净的方式，同时仍然保留了我们现在想要的基于类型分派的行为。所以现在我们可以退一步看看我们学到了什么：我们现在有了一个构建带标签数据的抽象数据类型的标准模式。

We're using a variable in the implementation to store the tag, that's going to make it very easy to change the tags without having to change any other parts of the code. We're always attaching

我们在实现中使用一个变量来存储标签，这将使我们很容易更改标签，而无需更改代码的任何其他部分。我们总是将标签附加在……

parts of the code we're always attaching the tag in the constructor as a part of our discipline and then we're using predicate to check that tag. This lets us decide whether an object belongs to the data type or not, and that enables us to in fact build operations that very nicely operate in the same way: they strip off the tag, operate on the contents, and then attach the tag to guarantee that what we get back out is the kind of thing we started with.

代码的其他部分。我们总是将标签附加在构造器中，作为我们纪律的一部分，然后我们使用谓词来检查该标签。这让我们能够决定一个对象是否属于该数据类型，从而使我们能够构建以相同方式良好运行的操作：它们剥掉标签，对内容进行操作，然后附加标签以保证我们得到的是与开始时相同类型的东西。

This pattern is something we want to use over and over again as we build complex structures and complex data types.

这个模式是我们希望在构建复杂结构和复杂数据类型时反复使用的。

structures and complex data types and we've done a much better job of doing it in our particular version of simple evaluation of arithmetic expressions.

结构和复杂数据类型，并且在我们对算术表达式的简单求值中，我们做得更好了。

Notice the discipline though associated with this: we have to use tag data everywhere in order to make sure this really works, and that includes making sure we tag up things that we return and not just assuming we just want the value.

注意与此相关的纪律：我们必须到处使用带标签的数据，以确保这真正有效，这包括确保我们返回的东西都加上标签，而不是仅仅假设我们只想要值。

As we've said, this is a very common pattern and one that you're going to see many times in your career, so despite the simplicity and perhaps boringness of it.

正如我们所说，这是一个非常常见的模式，你在职业生涯中会多次遇到，所以尽管它简单甚至有些乏味。

simplicity and perhaps boringness of this little example, check it out. This little example, check it out. This little example, check it out carefully, make sure you're comfortable. Carefully make sure you're comfortable. Carefully make sure you're comfortable with these ideas and with this disciplined approach to both safe and effective programming.

尽管这个小例子简单甚至有些乏味，但请仔细检查它，确保你熟悉这些思想以及这种既安全又有效的编程方法。

Having learned how to better structure a tag data system, we can go back to where we started. Remember our theme or our goal was to build a correct system for the simpler parts of our overall system, then use the same ideas to generalize to more complex parts.

学会了如何更好地构建带标签的数据系统后，我们可以回到起点。记住我们的主题或目标是：为整个系统中较简单的部分构建一个正确的系统，然后用同样的思想推广到更复杂的部分。

We've now done that for basic sums and numbers, so now we can move on to ranges. How do we deal with those? Well.

我们现在已经为基本的求和与数字做到了这一点，所以现在可以转向范围。我们如何处理它们呢？嗯。

To ranges, how do we deal with those well? I've already answered the question right. Use the same ideas, and what does that mean? First, create a variable for the tag information; there it is. We'll define range tag to have the value of the symbol range, again isolating out the value of the tag from the use of the tag.

对于范围，我们如何处理它们呢？我已经回答了这个问题。使用同样的思想，这意味着什么？首先，为标签信息创建一个变量；就在这里。我们将定义 range-tag 为符号 range 的值，再次将标签的值与标签的使用分离开来。

We'll need a constructor, make range; we've put those two pieces together in a list with the tag, just as we did before. Notice the type of both of these things. As before, we'll need a predicate that takes in any kind of thing and returns a

我们需要一个构造函数 make-range；我们像之前一样将这两部分放在一个带有标签的列表中。注意这两者的类型。和之前一样，我们需要一个谓词，它接受任何类型的东西并返回一个

takes in any kind of thing and returns a

接受任何类型的东西并返回一个

takes in any kind of thing and returns a boolean value as to whether this is the right kind or not. It has exactly the same kind of form as before, and of course we'll need selectors that take in ranges and produce out the number satisfying the contract. So this is very straightforward and just mimics the structure we saw with our last version of the system.

接受任何类型的东西并返回一个布尔值，指示这是否是正确的类型。它的形式与之前完全相同，当然我们还需要选择器，它们接受范围并产生满足契约的数字。所以这非常直接，只是模仿了我们上次系统版本的结构。

OK, we've added ranges in terms of data structures to our system. Now how do we extend our actual evaluator? Well, first let's think about what we want in terms of the performance as specified by the types. This is now

好的，我们已经以数据结构的形式将范围添加到系统中。现在如何扩展我们的实际求值器呢？首先，让我们思考一下根据类型所指定的性能，我们想要什么。这现在是

As specified by the types, this is now going to be something that either takes in a constant expression, a range expression, or some expression all of which will be labeled by tags. What we wanted to produce for us is either a constant expression if we can simplify things, or a range expression if that's the appropriate type to use.

根据类型所指定的，这现在将是一个接受常量表达式、范围表达式或某种表达式的东西，所有这些都将用标签标记。我们想要产生的结果是：如果我们可以简化，就产生一个常量表达式；如果这是合适的类型，就产生一个范围表达式。

Now, what do we know? We know that constants and ranges are things that should just pass through; we can't simplify them any more. So in our evaluator, we'll have two dispatches for those: check to see if it's a constant, just return the thing.

现在，我们知道什么？我们知道常量和范围是应该直接通过的东西；我们无法进一步简化它们。所以在我们的求值器中，我们将有两个针对这些的分派：检查它是否是常量，如果是就直接返回该东西。

it's a constant just return the thing check to see if it's a range just return a thing in both cases it'll give us back the right the kind of beasts

如果是常量就直接返回该东西；检查它是否是范围，如果是就直接返回该东西。在这两种情况下，它都会给我们返回正确类型的对象。

what about sums well for sums we have to deal with the possibility that the parts of the sum could themselves be either constants sums or ranges and we're going to have to do something to try and simplify that

那么求和呢？对于求和，我们必须处理求和的部分本身可能是常量、求和或范围的可能性，我们将不得不做一些事情来尝试简化它。

so as before we'll select out the parts of the sum evaluate them to get back the kind of thing that they reduce to and then we have to deal with how to put them back together if both of

所以和之前一样，我们将选出求和的部分，对它们求值以得到它们化简后的类型，然后我们必须处理如何将它们重新组合在一起。如果这两个

how to put them back together if both of these values are constants then we know we can simplify them and we'll simply pass them on to constant ad notice this nicely separates out this data structures from the operation constant ad we'll take these two constants strip off the tags simplify and then glue back on a tag to make sure that what we get back out is a tag type if the two parts aren't in fact constants then we have to represent this as a ring and here we have to be careful the only really tricky part is how to deal with making sure these things or ranges and

如何将它们重新组合在一起。如果这两个值都是常量，那么我们知道我们可以简化它们，我们将简单地将它们传递给 constant-add。注意，这很好地将数据结构与操作分离开来。constant-add 将接受这两个常量，去掉标签，简化，然后重新粘上标签以确保我们得到的是带标签的类型。如果这两个部分实际上不是常量，那么我们必须将其表示为范围。在这里我们必须小心，唯一真正棘手的部分是如何确保这些东西是范围，而

making sure these things are ranges and that's where Valtor range comes in this is a procedure that checks to see if its argument is a constant in which case it converts it to the trivial range of X to X otherwise it returns the argument itself which it knows is already arranged and guaranteed to get. Two ranges in then range I can do the right thing: take those tagged ranges, strip off the tags, do the right things to add the ranges together, add a tag back on, and return that as a tagged expression, as we did earlier, we can pull this piece.我们像刚才一样，可以把这个零件拉出来。

确保这些东西是范围，而这就是 val-to-range 的作用。这是一个过程，它检查其参数是否为常量，如果是，则将其转换为 X 到 X 的平凡范围；否则返回参数本身，它知道这已经是一个范围并保证如此。得到两个范围后，range-add 可以做正确的事情：取这些带标签的范围，去掉标签，做正确的事情将范围相加，重新加上标签，并将其作为带标签的表达式返回。正如我们之前所做，我们可以把这个部分拉出来。我们像刚才一样，可以把这个零件拉出来。

As we did earlier, we can pull this piece outside into the abstraction and simplify the evaluator. In particular, we can create a new predicate and hence an implicit higher-level kind of data structure that absorbs two simpler data structures, that checks to see whether something is a value by seeing if it's either a constant or a range.

正如我们之前所做，我们可以将这个部分拉出来放入抽象中，并简化求值器。特别是，我们可以创建一个新的谓词，从而创建一个隐式的更高级别的数据结构，它吸收两个更简单的数据结构，通过检查某物是常量还是范围来查看它是否是一个值。

And for this higher-order kind of data structure, that is something that is a value either a constant or a range, we can then have something that adds them together by doing what we just did inside of the evaluator, checking to see if both things

对于这种更高级别的数据结构，即作为值的东西（要么是常量要么是范围），我们可以有一个将它们相加的东西，通过执行我们刚才在求值器内部所做的操作，检查两个东西

Evaluator checking to see if both things are constants and in using constant add on that, otherwise doing range add, making sure we convert things into the right form, namely into range. So again, Val to range is something that, if it gets an argument as a range, returns it; otherwise, it constructs a range from the constant.

求值器检查两个东西是否都是常量，如果是则使用 constant-add，否则执行 range-add，确保将事物转换为正确的形式，即转换为范围。所以再次强调，val-to-range 是：如果它收到一个参数是范围，则返回它；否则，从常量构造一个范围。

And here's why we want to do that: now we can have a nice, crisp, clean version of an evaluator. First, let's check out the type. Now, the evaluator is taking in a value expression, which is either a constant expression or range expression, or is

这就是我们想要这样做的原因：现在我们可以有一个简洁、清晰的求值器版本。首先，让我们检查类型。现在，求值器接受一个值表达式，它要么是常量表达式或范围表达式，要么是

expression or range expression or is taking in a sum expression remember we kind of glued those two others four expressions into this higher order structure what is going to return for us is a value expression as its output type

表达式或范围表达式，要么是接受一个求和表达式。记住，我们将那两个其他表达式粘合到这个更高级别的结构中。它将返回给我们的输出类型是一个值表达式。

and notice what it now does it has simply a dispatch on whether something is a value or a sum just like before

注意它现在做什么：它只是简单地分派某物是值还是求和，就像之前一样。

using the tags to tell us where to go in this case we know what values is just going to return that expression we're all set

使用标签告诉我们去哪里。在这种情况下，我们知道如果值是值，就直接返回该表达式，我们就完成了。

in the case of a sum once more we pull out the parts using the selectors recursively apply a val to

在求和的情况下，我们再次使用选择器取出各个部分，递归地应用 val 来简化它们，然后将这两部分加回去，确保我们得到一个值。

selectors recursively apply a val to simplify them and then add those two things back up guaranteeing we get a value back out and finally we have the el-sayf at the bottom end again notice the structure we have a base case we have a recursive case that recursive call nicely strips the parts down and returns the right kind of beast and perhaps most importantly go back and compare this to our first evaluator it's just a simple literally it's got the same kind of structure but now because of the disciplined way in which we put it together we handle a whole lot more

递归地应用 val 来简化它们，然后将这两部分加回去，确保我们得到一个值。最后，我们在底部再次遇到 el-sayf。注意这个结构：我们有一个基本情况，一个递归情况，该递归调用很好地分解了各个部分，并返回了正确类型的对象。也许最重要的是，回头将这个求值器与我们的第一个求值器进行比较：它很简单，字面上具有相同的结构，但由于我们组合它的方式是有纪律的，我们处理了更多的情况。

It together we handle a whole lot more things. This is exactly why we want data directive programming. And let's think about the key things we've done. We've separated out the data abstraction implementation from its use. We've used the tags to tell us where to go. And we've built in a fail-safe to make sure that everything does the right thing, and if not, we complain about it.

我们处理了更多的情况。这正是我们想要数据导向编程的原因。让我们思考一下我们做的关键事情。我们将数据抽象的实现与其使用分离开来。我们使用标签来指示去向。我们构建了一个故障安全机制，以确保一切做正确的事情，如果没有，我们会抱怨。

Finally, notice the last thing we've done all the way through this process: we've been using the type definitions of the objects and the procedures to help us reason about what sorts of things should.

最后，注意我们在整个过程中做的最后一件事：我们一直在使用对象和过程的类型定义来帮助我们推理哪些类型的东西应该放在哪里。

reason about what sorts of things should go where once more showing the power of the data abstraction to help us do all of this ok the last piece then is to add in the limited precision numbers and here we'll use the same general idea we'll need a tag we'll need a tag data structure with a constructor that builds it out and we'll need just a new base case in our evaluator to deal with those kinds of things and otherwise we can just add the values of the simplified pieces right well think about this for a second then go on to the next slide and

推理哪些类型的东西应该放在哪里，再次展示了数据抽象的力量来帮助我们完成这一切。好的，最后一部分是添加有限精度数，这里我们将使用相同的总体思路：我们需要一个标签，一个带有构造器的标签数据结构，并且我们只需要在我们的求值器中添加一个新的基本情况来处理这些类型的东西，否则我们可以直接添加简化部分的值。好吧，先想一想，然后继续下一张幻灯片。

second then go on to the next slide and of course as you've probably already figured out it's not right and the reason is that we've not been defensive in terms of how we do value add.

然后继续下一张幻灯片，当然，你可能已经想到了，这是不对的，原因是我们没有在如何做值加法方面保持防御性。

Let's see why. Suppose I make a sum of the range from 4 to 6 and the limited precision number 10 plus or minus 1, and I then asked to reduce that. This gives me back something that says it's a range from 14 to 16, and of course that's not right. The right answer should have either be the range 13 to 17 or the limited precision number 15 plus or minus 2. We got this other.

让我们看看为什么。假设我构造一个从 4 到 6 的区间与有限精度数 10 加减 1 的和，然后我要求化简它。这给我返回了一个从 14 到 16 的区间，这当然是不对的。正确的答案应该是区间 13 到 17，或者有限精度数 15 加减 2。我们却得到了另一个。

minus 2 we got this other strange-looking thing instead why and the answer is we weren't really defensive. We didn't explicitly check for all types back in value at we assumed that if something wasn't a constant then it must be a range and that didn't leave any room for a new data type.

加减 2，我们却得到了这个奇怪的东西，为什么？答案是，我们并没有真正防御。我们没有在 value-add 中显式检查所有类型；我们假设如果某物不是常量，那么它一定是区间，这没有为新的数据类型留出空间。

So now we've got to think about how to fix that but just to say it a little more carefully a limited expression is not a constant so falls into the else Clause in value that means that the limited expression 10 plus or minus one passes on to valve.

所以现在我们必须考虑如何修复这个问题，但更仔细地说，有限精度表达式不是常量，因此落入 value-add 中的 else 子句，这意味着有限精度表达式 10 加减 1 被传递给 value-add-range。

10 plus or minus one passes on to valve 2 range and that means that it gets passed on to constant valve which simply returns the 10 it just pulls out that piece just applying the selector what to what it believes is the right thing as a consequence range ad gets called on the value of range 4 to 6 and the range 10 to 10 because valve 2 range takes a 10 and turns it into that simple version and therefore we get back out the incorrect expression and thus to recap we need to be defensive we can't make assumptions that if something isn't a particular kind of thing then it must be

10 加减 1 被传递给 value-add-range，这意味着它被传递给 constant-value，它只是返回 10，它只是应用选择器，取出它认为正确的东西。结果是，range-add 被调用在区间 4 到 6 的值和区间 10 到 10 的值上，因为 value-add-range 将 10 转换为那个简单版本，因此我们得到了不正确的表达式。因此，总结一下，我们需要防御性，我们不能假设如果某物不是特定类型，那么它一定是另一种类型。

particular kind of thing then it must be another kind of thing so what we really need to do is to be sure to check tags before operate it here's the change to value act as before we'll check to see if the two arguments are both constants in which case we'll use constant add to do the right thing

特定类型，那么它一定是另一种类型。所以我们真正需要做的是确保在操作之前检查标签。这是对 value-add 的修改：和之前一样，我们将检查两个参数是否都是常量，如果是，我们将使用 constant-add 来做正确的事情。

now though we'll then go on to check to see if the two things are both values if they are we can convert both of them into ranges and use range add to return the right kind of value expression otherwise we'll complain saying we don't know how to

但现在，我们将继续检查这两个东西是否都是区间值。如果是，我们可以将两者都转换为区间，并使用 range-add 返回正确类型的值表达式。否则，我们将抱怨说我们不知道如何处理这两种类型的东西。

complain saying we don't know how to deal with either these two kinds of things and of course there's a general message here the rule of thumb should be when checking types use the else branch only for errors not to catch other kinds of expressions

抱怨说我们不知道如何处理这两种类型的东西。当然，这里有一个普遍的信息：经验法则应该是，在检查类型时，仅将 else 分支用于错误，而不是用于捕获其他类型的表达式。

and if you go back and look at the earlier version of value-add you see that we didn't do that we use the else clause to assume that if it isn't one kind of thing then it must be another kind of thing

如果你回头看看早期版本的 value-add，你会发现我们没有这样做；我们使用 else 子句来假设如果某物不是一种类型，那么它一定是另一种类型。

so what's the message well actually there are several first as we've hopefully seen data director programming is a very useful

那么信息是什么？实际上有几个。首先，正如我们希望看到的，数据导向编程是一个非常有用的工具。

Director programming is a very useful tool. It's a great way to keep code clean, readable, and easily modifiable. It allows us to extend systems in a straightforward way while making sure that the things can be seen easily within the code and that we've guaranteed that we haven't made problems along the way.

数据导向编程是一个非常有用的工具。它是保持代码干净、可读和易于修改的好方法。它允许我们以直接的方式扩展系统，同时确保事情可以在代码中轻松看到，并且我们保证了没有在过程中制造问题。

The second message is that to support data director programming, we really need to use types. We need to do it in a disciplined fashion, always checking the tags to make sure that it's correct to proceed before we go along, and as we saw in the last case.

第二个信息是，为了支持数据导向编程，我们确实需要使用类型。我们需要以有纪律的方式这样做，始终检查标签以确保在继续之前是正确的，正如我们在上一个案例中看到的。

and as we saw in the last case we're only going to use the else branch in our dispatches to handle errors not to assume that something is of a particular type by a process of elimination.

正如我们在上一个案例中看到的，我们只会在我们的分派中使用 else 分支来处理错误，而不是通过排除法来假设某物是特定类型。

unfortunately many programmers don't do this they think the loss of efficiency is not worthwhile and they basically assume that someone else will do the check for as Andy Grove the founder of Intel says only the paranoid survive so it's probably important to make sure you're a paranoid programmer because it'll really

不幸的是，许多程序员不这样做；他们认为效率的损失不值得，并且基本上假设其他人会进行检查。正如英特尔创始人安迪·格鲁夫所说，只有偏执狂才能生存。所以确保你是一个偏执的程序员可能很重要，因为它真的会……