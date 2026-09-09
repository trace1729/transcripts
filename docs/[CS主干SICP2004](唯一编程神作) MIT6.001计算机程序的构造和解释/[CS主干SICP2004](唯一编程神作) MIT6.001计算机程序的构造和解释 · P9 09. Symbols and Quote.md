# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=9)

In this lecture we're going to introduce a new data type, specifically to deal with symbols. This may sound a bit odd, but if you step back and think about it, you may realize that everything we've done so far in the course has focused on procedures to manipulate numbers. While we've used names for things, we've treated them as exactly that—names associated with values.

在本讲中，我们将引入一种新的数据类型，专门用于处理符号。这听起来可能有点奇怪，但如果你退一步思考，你可能会意识到，到目前为止，我们在课程中所做的一切都集中在操作数字的过程上。虽然我们使用了名称来指代事物，但我们只是将它们视为与值相关联的名称。

Today we're going to create a specific data type for symbols and see how having the notion of a symbol as a unit to be manipulated will lead to different kinds of

今天，我们将创建一种特定的符号数据类型，并看看将符号作为一个可操作的单位这一概念如何导致不同类型的

will lead to different kinds of procedures to set the stage for this recall what we've done when we deal with data abstractions we set a data abstraction in essence consisted of a constructor for building instances of the abstraction selectors are accessors for getting out the pieces of an abstraction a set of operations for manipulating the abstraction while preserving the barrier between the use of the abstraction and the internal details of the representation and most importantly a contract specifying the relationship between the constructor and

导致不同类型的过程。为了为此奠定基础，回顾一下我们在处理数据抽象时所做的事情：本质上，数据抽象由以下几部分组成：用于构建抽象实例的构造函数；用于取出抽象各部分的选择器；一组用于操作抽象的操作，同时保持抽象的使用与表示的内部细节之间的屏障；以及最重要的，一个规定构造函数与选择器之间关系的契约。

relationship between the constructor and selectors and their behaviors. For example, if I want to create an abstraction for manipulating points in the plane, I could create a constructor like this: make-point is a procedure that glues two things together into a list, and here's one of the associated selectors, which in this case takes a data object as built by the constructor and pulls out the first or x-coordinate part of that object.

例如，如果我想创建一个用于操作平面中点的抽象，我可以创建一个这样的构造函数：make-point 是一个将两个东西粘合成一个列表的过程，这里是一个相关的选择器，在这种情况下，它接受一个由构造函数构建的数据对象，并取出该对象的第一个或 x 坐标部分。

Given that I can build objects of this type, I can define operations on them. Notice that the key point about these things is

既然我可以构建这种类型的对象，我就可以定义对它们的操作。注意，这些操作的关键点在于

that the key point about these things is that they use the selectors to get at the pieces of the data object. For example, in this case, we do not use car to get the piece of the object; we use the defined selector and then the key piece.

这些操作的关键点在于它们使用选择器来获取数据对象的各个部分。例如，在这种情况下，我们不使用 car 来获取对象的部分；我们使用定义的选择器，然后是关键部分。

The contract, the thing that relates to the constructor and selectors together, for this example states that however we glue pieces together using the constructor, applying the first selectors of that result will cause the value of the first piece to be returned.

契约，即连接构造函数和选择器的东西，对于这个例子来说，它规定无论我们如何使用构造函数将各部分粘合在一起，对该结果应用第一个选择器将导致返回第一块的值。

So with these ideas of abstractions in mind, let's turn to

因此，带着这些关于抽象的想法，让我们转向

abstractions in mind, let's turn to introducing a new kind of data structure. Let's motivate why we need to do data type. Suppose I ask you the following question: think for a second about how you might respond. I personally would probably respond by saying blue. Now what about this question? If you are thinking carefully about this, you ought to respond by saying your favorite color. So we say two different things in response to these two questions. What's the difference in the questions? If you think carefully about it, you should see that in the first case I got the meaning.

带着这些关于抽象的想法，让我们转向引入一种新的数据结构。让我们来思考为什么我们需要这种数据类型。假设我问你以下问题：想一想你会如何回答。我个人可能会回答“蓝色”。那么这个问题呢？如果你仔细思考，你应该回答“你最喜欢的颜色”。所以我们对这两个问题给出了不同的回答。这两个问题有什么区别？如果你仔细思考，你应该看到在第一种情况下，我得到了含义。

that in the first case I got the meaning associated with the expression your favorite color much like getting the value associated with the name in this second case I got the actual expression.

在第一种情况下，我得到了与表达式“你最喜欢的颜色”相关联的含义，就像获取与名称相关联的值一样；在第二种情况下，我得到了实际的表达式。

the double quotation marks in the second case indicated that I wanted the actual expression well in the first case I wanted the value associated with it that is the actual favorite color versus the phrase favorite color so in many cases we may want to be able to make exactly this kind of distinction between the value associated with an expression and

第二种情况中的双引号表示我想要实际的表达式，而在第一种情况下，我想要与之关联的值，即实际最喜欢的颜色，而不是“最喜欢的颜色”这个短语。所以在许多情况下，我们可能希望能够做出这种区分，即表达式的值与实际的符号或表达式本身之间的区分。

value associated with an expression and the actual symbol or expression itself. This is going to lead us to introduce a new kind of data. Now the next question is how do I create symbols as data structures or data objects? Well, we already saw one way of doing this when we defined a name for a value, and we saw that if we wanted to get back the value associated with that symbol or name, we could just reference it and the evaluator will return The Associated value.

表达式的值与实际的符号或表达式本身之间的区分。这将引导我们引入一种新的数据。下一个问题是如何将符号创建为数据结构或数据对象？嗯，我们已经看到了一种方法，当我们为一个值定义名称时，我们看到如果我们想要取回与该符号或名称关联的值，我们可以直接引用它，求值器将返回关联的值。

But suppose I want to reference the symbol itself, how do I do that in other words, how do I distinguish between the value associated with an expression and the actual symbol or expression itself? This is going to lead us to introduce a new kind of data. Now the next question is how do I create symbols as data structures or data objects? Well, we already saw one way of doing this when we defined a name for a value, and we saw that if we wanted to get back the value associated with that symbol or name, we could just reference it and the evaluator will return The Associated value. But suppose I want to reference the symbol itself, how do I do that in other words, how do I distinguish between

但是假设我想引用符号本身，我该怎么做？换句话说，我如何区分表达式的值与实际的符号或表达式本身？这将引导我们引入一种新的数据。下一个问题是如何将符号创建为数据结构或数据对象？嗯，我们已经看到了一种方法，当我们为一个值定义名称时，我们看到如果我们想要取回与该符号或名称关联的值，我们可以直接引用它，求值器将返回关联的值。但是假设我想引用符号本身，我该怎么做？换句话说，我如何区分

other words how do i distinguish between your favorite color and blue as the value of your favorite color basically we need to back up and think about what the scheme interpreter is doing when we type in an expression and ask for it to be evaluated the reader first converts that expression into an internal form

换句话说，我如何区分“你最喜欢的颜色”和作为“你最喜欢的颜色”的值的蓝色？基本上，我们需要退一步思考 Scheme 解释器在我们输入一个表达式并要求求值时在做什么。读取器首先将该表达式转换为内部形式，

and the evaluator then applies its set of rules to determine the value of the expression here we need a way of telling the reader and evaluator that we don't want to get the value scheme provides this for us with a special form called

然后求值器应用其规则集来确定表达式的值。在这里，我们需要一种方式来告诉读取器和求值器我们不想获取值。Scheme 通过一种称为 quote 的特殊形式为我们提供了这种机制。

this for us with a special form called quote. If we evaluate the example expression using this special form, it returns for us a value of the type symbol that somehow captures that name. Note that it makes sense for quote to be a special form. We can't use normal evaluation rules because that would cause us to get the value associated with the name alpha, but in fact our goal is to simply keep the name, not its value.

如果我们使用这种特殊形式来求值示例表达式，它会返回一个符号类型的值，该值以某种方式捕获了该名称。注意，quote 作为一种特殊形式是有道理的。我们不能使用正常的求值规则，因为那会导致我们获取名称 alpha 关联的值，但事实上我们的目标是仅仅保留名称，而不是它的值。

So what kind of object is a symbol? We can think of it as a primitive data object, hence it doesn't really have a constructor selectors though quote.

那么符号是一种什么样的对象呢？我们可以将其视为一种原始数据对象，因此它实际上没有构造函数，选择器则是 quote。

Constructor selectors, though quote, serve to help us distinguish between the symbol and its value. It does, however, have some operations. In particular, the predicate symbol question mark takes in an object of any type and returns true if that object is a symbol. The operation EQ question mark is used to compare two symbols, among other things, and we're going to return to that in a second.

构造器选择器，尽管有引号，却有助于我们区分符号与其值。然而，它确实有一些操作。特别是，谓词 symbol? 接受任何类型的对象，如果该对象是符号则返回真。操作 eq? 用于比较两个符号等，我们稍后将回到这一点。

So here is our new datatype for creating symbols: that is, data objects that refer to the name itself, rather than the value with which it is associated. To see how this data

因此，这是我们用于创建符号的新数据类型：即引用名称本身而非其关联值的数据对象。要了解这种数据

It is associated to see how this data structure is handled. Let's go back to our two worlds view of evaluation, separating the visible world of the user from the internal execution world of computation.

它被关联以了解这种数据结构是如何处理的。让我们回到我们关于求值的两个世界的观点，将用户可见的世界与计算的内部执行世界分开。

What happens when we consider symbols in this content? First, remember what happened when we evaluated other expressions. For example, if the expression were a lambda expression, then the evaluator checked the type of this expression, realized it was a special form, a lambda, and used the rule for that particular special form. In this case, it...

当我们在这个内容中考虑符号时会发生什么？首先，记住当我们求值其他表达式时发生了什么。例如，如果表达式是 lambda 表达式，那么求值器检查该表达式的类型，意识到它是一个特殊形式，一个 lambda，并使用针对该特定特殊形式的规则。在这种情况下，它……

particular special form in this case it would create the compound procedure represented by that expression and return a pointer to that created object causing the computer to print out information identifying that pointer the idea is some value associated with such a structure

特定特殊形式，在这种情况下，它将创建由该表达式表示的复合过程，并返回一个指向所创建对象的指针，导致计算机打印出标识该指针的信息，其思想是与这种结构相关联的某个值

something different happens with quotes if we type in an expression involving the special name quote the evaluator checks the type of this expression recognize that this special form and uses a rule designed for such special expressions in the case of quote we simply take the second sub expression

对于引号，会发生一些不同的事情。如果我们输入一个涉及特殊名称 quote 的表达式，求值器检查该表达式的类型，识别出这个特殊形式，并使用为这种特殊表达式设计的规则。对于 quote，我们简单地取第二个子表达式

we simply take the second sub expression and create an internal representation for it. The reader recognizes this as a sequence of characters and creates a symbol with that sequence of characters, like a name.

我们简单地取第二个子表达式并为其创建内部表示。读取器将其识别为字符序列，并创建一个具有该字符序列的符号，就像一个名称。

The evaluator then returns to the visible world something to print out: simply the name that we just quoted, beta in this case.

然后求值器返回可见世界一些要打印的东西：仅仅是我们刚刚引用的名称，在这种情况下是 beta。

Now that we have the ability to create this new kind of data object, note that we can use it anywhere we would expect to use such primitive things. For example, we can certainly create a list of normal things like

既然我们有了创建这种新数据对象的能力，请注意我们可以在任何期望使用这种原始事物的地方使用它。例如，我们当然可以创建一个正常事物的列表，比如

Create a list of normal things like numbers. Remember that creating the list of 1 and 2 returns a printed representation of that list structure written as open paren one too close paren, but I could also create a list of quoted things. We evaluate the arguments to list two, getting two symbols, and then create the list of those symbols, finishing with the prison representation of the structure created by gluing those symbols together.

创建一个正常事物的列表，比如数字。记住，创建 1 和 2 的列表会返回该列表结构的打印表示，写成左括号 1 2 右括号，但我也可以创建一个被引用事物的列表。我们求值 list 的两个参数，得到两个符号，然后创建这些符号的列表，最后得到通过将这些符号粘合在一起所创建结构的打印表示。

What does that list look like? Well, list creates a box and pointer structure just as in the case of numbers. Thus at the

那个列表看起来像什么？嗯，list 创建一个盒子和指针结构，就像数字的情况一样。因此在

as in the case of numbers, thus at the top level of that structure we will have a skeleton containing two things ending in the special empty list symbol, and what hangs off this spine is a pointer to the data structure of a symbol.

就像数字的情况一样，因此在那个结构的顶层我们将有一个包含两个事物的骨架，以特殊的空列表符号结束，而悬挂在这个主干上的是一个指向符号数据结构的指针。

Thus we can use symbols in the same places where we might have earlier used numbers within other data structures. In fact, our scheme evaluator is smart and it keeps track of what symbols have been created so far.

因此，我们可以在以前可能使用数字的其他数据结构中的相同位置使用符号。事实上，我们的 scheme 求值器很聪明，它会跟踪到目前为止已经创建了哪些符号。

As a consequence, when we refer to a symbol, scheme gives us a pointer to the unique instance of that symbol. We can illustrate that as shown by evaluating.

因此，当我们引用一个符号时，scheme 会给我们一个指向该符号唯一实例的指针。我们可以通过求值来展示这一点。

illustrate that as shown by evaluating this expression this will create a list of two elements both of which happen to be the symbol Delta scheme will create a box and pointer structure for a two element list but the car of both cons pairs in this list now point to exactly the same object inside of the machine namely the data structure for the symbol Delta this is valuable because it gives us a way of creating predicates for testing equality of symbols and need of other more complicated objects as we're going to see in a few little bit

通过求值这个表达式来展示这一点。这将创建一个包含两个元素的列表，这两个元素恰好都是符号 Delta。Scheme 将为两元素列表创建一个盒子和指针结构，但该列表中两个 cons 对的 car 现在都指向机器内部完全相同的对象，即符号 Delta 的数据结构。这很有价值，因为它为我们提供了一种创建用于测试符号相等性的谓词的方法，而不是需要其他更复杂的对象，我们稍后将看到。

going to see in a few little bit our

稍后我们将看到

going to see in a few little bit our predicate for testing equality of symbols is EQ this is a very powerful procedure used to test the quality of a range of structures as we're going to see EQ is a primitive procedure that is that something built into scheme and it returns the boolean value true if it's two arguments are the same object for our context that says that since we create only one instance of each symbol using EQ to test equality of symbols we will return true if the two expressions evaluate to a pointer to the same symbol data structure here is an example of

稍后我们将看到，我们用于测试符号相等性的谓词是 eq?。这是一个非常强大的过程，用于测试一系列结构的相等性，正如我们将看到的。eq? 是一个原始过程，即内置于 scheme 中的东西，如果它的两个参数是同一个对象，则返回布尔值真。在我们的上下文中，这意味着由于我们只为每个符号创建一个实例，使用 eq? 来测试符号的相等性，如果两个表达式求值为指向相同符号数据结构的指针，我们将返回真。这里有一个例子

data structure here is an example of what we mean by that if we apply EQ to two arguments that evaluate to the same symbol we get a true value return otherwise a false value is returned as

数据结构，这里有一个例子说明我们的意思。如果我们将 eq? 应用于两个求值为相同符号的参数，我们得到真值返回，否则返回假值，如

an aside for those who are interested here's the type of EQ it accepts two arguments of any type and returns a boolean value of true if those two arguments evaluate to the same object

顺便说一句，对于那些感兴趣的人，这是 eq? 的类型：它接受两个任何类型的参数，如果这两个参数求值为同一个对象，则返回布尔值真。

this works great if our two arguments are symbols but care should be taken when applying this to other types particularly numbers and strings for example the behavior of EQ is

如果我们的两个参数是符号，这很有效，但在应用于其他类型，特别是数字和字符串时，应该小心。例如，eq? 的行为是

example the behavior of EQ is unspecified when passing two number expressions or two string expressions we have a separate procedure for numbers equal sign to test equality and a different procedure string equal sign to test equality of strings there are also other predicates for testing equality with nuances of behavior which we will consider later including eqv and equal

例如，当传递两个数字表达式或两个字符串表达式时，eq? 的行为是未指定的。我们有单独的过程用于数字的 = 来测试相等性，以及不同的过程 string=? 来测试字符串的相等性。还有其他用于测试相等性的谓词，具有细微的行为差异，我们将在后面考虑，包括 eqv? 和 equal?。

this now completes our method for creating and dealing with symbols having the ability to intermix numbers and symbols and expressions is a very useful thing as a consequence we'd like to be

这现在完成了我们创建和处理符号的方法。能够在表达式中混合使用数字和符号是非常有用的事情。因此，我们希望

Thing as a consequence we'd like to be able to generalize this to all sorts of data structures. Since our primary data structure is a list, it would be nice if we had the ability to quote list structure in addition to simple names.

事情，因此我们希望能够将其推广到各种数据结构。由于我们的主要数据结构是列表，如果我们能够引用列表结构而不仅仅是简单名称，那就太好了。

In fact, our reader and evaluator will do this for us, since the fundamental representation of expressions in our language is in terms of lists and list structure. The reader is set up to convert every typed in expression into list structure. This is true for any expression created out of parentheses, which denote the boundaries of the lists.

事实上，我们的读取器和求值器会为我们完成这项工作，因为我们语言中表达式的基本表示形式是列表和列表结构。读取器被设置为将每个输入的表达式转换为列表结构。这对于任何由括号（表示列表边界）构成的表达式都是如此。

which denote the boundaries of the lists. As we've seen a few lectures, the evaluator is then set up to take that list structure and manipulate it according to the rules of evaluation to determine the meaning of the expression.

括号表示列表的边界。正如我们在几讲中所看到的，求值器随后会获取该列表结构，并根据求值规则对其进行操作，以确定表达式的含义。

In the case of the special form quote, however, the evaluator simply passes on the list structure without any evaluation. Thus, in general, quoting a printed representation of a list structure, including sublists of numbers and symbols, gets converted to the appropriate list structure internally and then returned; it's printed.

然而，对于特殊形式 quote，求值器只是直接传递列表结构而不进行任何求值。因此，通常，引用一个列表结构的打印表示（包括数字和符号的子列表）会被转换为相应的内部列表结构，然后返回；它会被打印出来。

and then returned it's printed representation will then match the original expression. This is nice because quote now lets us distinguish between names of things and their values for virtually every kind of structure of course.

然后返回，其打印表示将与原始表达式匹配。这很好，因为 quote 现在让我们能够区分事物的名称及其值，几乎适用于所有类型的结构。

Writing out long expressions involving this special symbol quote is a bit tedious, so we have a nice shorthand in scheme namely the single quote mark. Thus quote mark a is just a shorthand for open paren quote a close print, and quote mark open paren one to close is just a shorthand notation for open paren quote.

写出涉及这个特殊符号 quote 的长表达式有点繁琐，所以我们在 scheme 中有一个方便的简写，即单引号。因此，引号 a 只是 (quote a) 的简写，而引号 (1 2) 只是 (quote (1 2)) 的简写。

shorthand notation for open paren quote one to close which we already saw creates for us a list consisting of the number one and the number two. This means in general that placing a single quote mark in front of the printed representation for any list structure will cause the evaluator to create the corresponding list structure.

简写符号 (quote (1 2))，我们之前已经看到，它会为我们创建一个由数字 1 和数字 2 组成的列表。这意味着，一般来说，在任何列表结构的打印表示前加上单引号，都会使求值器创建相应的列表结构。

So let's take a quick break to see if you're getting this idea. Here are a set of expressions. What gets printed out as a result of evaluating each of these? When you think you have the answers, go to the slide. So here are the solutions first.

所以让我们稍作休息，看看你是否理解了这一概念。这里有一组表达式。对每个表达式进行求值后，会打印出什么？当你认为你有了答案时，请转到幻灯片。这里是答案，首先。

slide so here are the solutions first notice that we've defined X to have the value 20 creating a pairing of that value with that name evaluating the first expression just gives us a normal combination resulting in the addition to 3 to the value of X or giving us 23 the next expression the single quote says to just return a list whose printed representation is equivalent to this that is the list of quote plus quote X and quote 3 or if you like the list of the symbol plus the symbol X and the number 3 thus what is printed out is the

幻灯片，这里是答案。首先注意，我们已将 X 的值定义为 20，将该值与名称配对。对第一个表达式求值，我们得到一个普通的组合，将 3 加到 X 的值上，得到 23。下一个表达式，单引号表示只返回一个列表，其打印表示等价于这个，即列表 (quote + quote X quote 3)，或者如果你愿意，可以看作符号 +、符号 X 和数字 3 的列表。因此打印出来的是

Number 3, thus what is printed out is the same expression as what was quoted the same expression as what was quoted the same expression as what was quoted the next expression draws a distinction with this example it says to create a list of a quoted plus the value of x and the quoted value of 3 thus we get a list of the symbol plus because we quoted it the number 20 since we asked for the value of X and the number 3 the next expression returns the same value since quoting a number just returns that number finally what happens if we just ask for a list of + X + 3 well we get a list of the values of each of those expressions as shown thus these examples

数字 3，因此打印出来的是与所引用表达式相同的表达式。下一个表达式与这个例子形成对比，它表示创建一个列表，包含一个被引用的 +、X 的值和被引用的 3。因此我们得到一个列表，包含符号 +（因为我们引用了它）、数字 20（因为我们请求了 X 的值）和数字 3。下一个表达式返回相同的值，因为引用一个数字只是返回该数字。最后，如果我们只请求一个列表 + X + 3 会怎样？我们得到每个表达式值的列表，如下所示。因此这些例子

expressions as shown thus these examples show the variations in the use of quotation within list structure determining when the values of expressions are returned and when the names are simply returned let's take the idea of symbols and combine it with some of the other lessons we've seen so far to see how symbols add to the expressive power of our language

表达式如下所示，因此这些例子展示了在列表结构中使用引用的变化，决定了何时返回表达式的值，何时只返回名称。让我们将符号的概念与我们目前所学的其他课程结合起来，看看符号如何增加我们语言的表现力。

do this we're going to look at the example of symbolic differentiation in particular creating a system to compute symbolic derivatives by that I mean returning symbolic expressions much as you do in calculus

为此，我们将看一个符号微分的例子，特别是创建一个计算符号导数的系统。我的意思是返回符号表达式，就像你在微积分中所做的那样。

expressions much as you do in calculus, thus I want a system that takes some representation for the algebraic expression X plus 3 and some representation for the variable X and returns the derivative of that expression with respect to that variable.

表达式，就像你在微积分中所做的那样。因此，我想要一个系统，它接受代数表达式 X + 3 的某种表示和变量 X 的某种表示，并返回该表达式关于该变量的导数。

To do this I'm going to need a way of representing expressions, which I will do using lists. Thus, the algebraic expression x + 3, I choose to represent as the list open friend plus X 3 close print, that is a list of the symbol plus, the symbol X, and the number 3. For base cases, I will just represent a variable.

为此，我需要一种表示表达式的方法，我将使用列表来表示。因此，代数表达式 x + 3，我选择表示为列表 (plus X 3)，即符号 plus、符号 X 和数字 3 的列表。对于基本情况，我将只用一个变量。

cases I will just represent a variable by its symbol products I'll represent in a similar fashion and give it an expression involving more than two terms I will break into recursive pieces each of which involves at most two terms thus I want to restrict my system to sums and products of it most to terms I haven't said how to build the system of course but only how I'm going to represent expressions in my system as we've already said we would like to build a procedure der if that takes as input some representation of an algebraic expression and a

基本情况，我将只用一个变量，用其符号表示。乘积我将以类似的方式表示，对于涉及两个以上项的表达式，我将分解为递归片段，每个片段最多涉及两个项。因此，我想将我的系统限制为最多两项的和与积。我还没有说如何构建系统，但只说了我将如何在系统中表示表达式。正如我们已经说过的，我们想要构建一个过程 derif，它接受代数表达式的某种表示和一个

Algebraic expression and a representation of the variable with respect to which we want to take the derivative, and returns a representation of the new expression that represents that derivative. So, for example, here is the behavior I would like: I would like to differentiate X plus 3 with respect to X and get back the value 1. Notice the use of the single quote to indicate that I want the list structure itself as the value of the argument, creating a representation of the electric expression. Thus, we want our system to take a symbolic algebraic expression as

代数表达式的表示，以及一个表示我们想对其求导的变量的表示，并返回表示该导数的新表达式的表示。因此，例如，这是我想要的行为：我想对 X + 3 关于 X 求导，并得到值 1。注意使用单引号来表示我想要列表结构本身作为参数的值，创建代数表达式的表示。因此，我们希望我们的系统接受一个符号代数表达式作为

take a symbolic algebraic expression as input and return a new symbolic algebraic expression is output satisfying the rules of calculus to build this system I'm going to stitch together several ideas using lists of lists to represent expressions using symbols to capture algebraic expressions and using procedural abstractions to manipulate the list structures corresponding to those expressions to build a system I'm going to consider several stages focusing on how to initially get things going then on how to build a direct implementation and

以符号代数表达式作为输入，并返回一个新的符号代数表达式作为输出，该输出满足微积分规则。为了构建这个系统，我将把几个想法拼接在一起：使用列表的列表来表示表达式，使用符号来捕获代数表达式，并使用过程抽象来操作与这些表达式对应的列表结构。为了构建这个系统，我将考虑几个阶段，首先关注如何初步启动，然后关注如何构建直接实现，以及

to build a direct implementation and finally how to learn from the direct method to create a better implementation. Throughout, we will see how these ideas of data structures and procedural abstractions work together to implement our system.

构建直接实现，最后关注如何从直接方法中学习以创建更好的实现。在整个过程中，我们将看到数据结构和过程抽象这些想法如何协同工作来实现我们的系统。

We can observe several use of things about what we've done. First, note that a1 and a2 might themselves be complex expressions, in which case we would apply these rules again to each of those pieces. Thus, our procedure will need to recursively walk down those expressions, applying rules to subsequent pieces.

我们可以观察到关于我们所做工作的几点。首先，注意a1和a2本身可能是复杂表达式，在这种情况下，我们将再次对这些部分应用这些规则。因此，我们的过程将需要递归地遍历这些表达式，对后续部分应用规则。

Pieces second as we noted the derivative of a sum is decomposed into simpler versions of the same problem on smaller pieces plus a simple operation that puts the results back together. Putting these two observations together, we can see that expressions might not be lists but lists of lists, sometimes called trees of arbitrary depth.

其次，正如我们所注意到的，和的导数被分解为相同问题的更简单版本，作用于更小的部分，再加上一个简单的操作将结果重新组合。将这两个观察结合起来，我们可以看到表达式可能不是列表，而是列表的列表，有时称为任意深度的树。

That is, we can apply these rules to expressions whose parts are themselves sums or products of elements, who might be sums of products and so on. We simply want to recursively apply the rules to break the problem.

也就是说，我们可以将这些规则应用于其部分本身是元素的和或积的表达式，而这些元素又可能是和或积的乘积，依此类推。我们只需递归地应用规则来分解问题。

apply the rules to break the problem down into simpler pieces until we ultimately reach primitive cases then blew all the parts back together again

应用规则将问题分解为更简单的部分，直到最终达到原始情况，然后将所有部分重新组合在一起。

given our suggestion that we can represent expressions as lists of things that is lists of sub expressions with the symbol for the operator at the front of the list and the arguments behind it

鉴于我们的建议，我们可以将表达式表示为事物的列表，即子表达式的列表，其中运算符的符号位于列表的前面，参数位于其后。

we can nicely associate a data type with each expression first any symbol will represent a variable any number will simply denote a constant and then any other expression denotes its type by the object at the front of the list thus any

我们可以很好地将数据类型与每个表达式关联起来：首先，任何符号将表示变量，任何数字将仅表示常量，然后任何其他表达式通过列表前面的对象来表示其类型。因此，任何

object at the front of the list, thus any expression beginning with a plus is a sum and thus will be subject to the rule for derivatives of sums. Similarly for products, and of course the sub-expressions could themselves be lists, whose type is indicated by the type of the first part of the list.

列表前面的对象，因此任何以加号开头的表达式都是和，因此将受到和的导数规则的约束。类似地，对于乘积，当然子表达式本身可以是列表，其类型由列表第一部分指示。

In other words, except for our primitive expressions, constants and variables, every expression in our system has its type defined by the first sub-expression of the list. This also excludes some kinds of expressions that might be perfectly valid from an algebraic perspective.

换句话说，除了我们的原始表达式（常量和变量）之外，我们系统中的每个表达式的类型都由列表的第一个子表达式定义。这也排除了一些从代数角度来看可能完全有效的表达式。

perfectly valid from an algebraic perspective. Thus expressions with the operator in the middle are not included in our choice of representation. Also we've restricted ourselves for convenience to expressions with exactly two arguments. Algebraic expressions with more than two parts will have to be represented by nested lists of operations.

从代数角度来看完全有效。因此，运算符位于中间的表达式不包括在我们的表示选择中。此外，为了方便起见，我们将自己限制为恰好有两个参数的表达式。具有两个以上部分的代数表达式将必须通过嵌套的操作列表来表示。

Note that we are simply making some design choices in our system, something we are free to do so as we set up this computational structure for implementing that system. Our choice is to allow legal expressions.

请注意，我们只是在系统中做出一些设计选择，这是我们在建立实现该系统的计算结构时可以自由做的事情。我们的选择是允许合法表达式

Our choice is to allow legal expressions consisting of constants, variables, or lists of three elements. The first of which is either a plus or a star, and the other two of which are legal expressions by this definition. So let's formalize this with a type description for our legal expressions in this simple little language of derivatives that we're building in our system.

我们的选择是允许合法表达式由常量、变量或三个元素的列表组成。其中第一个是加号或星号，另外两个根据此定义是合法表达式。因此，让我们用类型描述来形式化这一点，用于我们正在构建的导数小语言中的合法表达式。

And expression, which we denote by exp, are to distinguish them from more general scheme expressions. These expressions can either be a simple expression or compound one; the slash symbol denotes or.

表达式，我们将其表示为exp，以区别于更一般的Scheme表达式。这些表达式可以是简单表达式或复合表达式；斜杠符号表示“或”。

Compound one the slash symbol denotes or, by the way. And what are those? Well, a simple expression is either a type number or symbol corresponding to our constants and variables.

复合表达式，斜杠符号表示“或”，顺便说一下。那么这些是什么？简单表达式是类型为数字或符号的，对应于我们的常量和变量。

A compound expression now has a very particular type: it is a list of three elements, where the first element is either that symbol plus or star, and the other two parts are expressions as defined by this type expression.

复合表达式现在具有非常特定的类型：它是一个三个元素的列表，其中第一个元素是符号加号或星号，另外两个部分是根据此类型表达式定义的表达式。

Note the format for specifying that this is a list of three elements by using our type notation for pairs. Also note how this type definition is recur.

注意使用我们的对类型表示法来指定这是一个三个元素的列表的格式。还要注意这个类型定义是如何递归的。

Is recur, is recur, thus automatically allowing for arbitrary depth expressions. So now we can put together an initial plan for implementing the system. Since we only have a few kinds of expressions, the easiest approach is to use a different procedure to take the derivative of each kind of expression.

是递归的，是递归的，因此自动允许任意深度的表达式。所以现在我们可以制定一个实现该系统的初步计划。由于我们只有几种表达式，最简单的方法是使用不同的过程来对每种表达式求导。

So we could define the Rif to be a procedure. Note the lambda that accepts an expression and a variable, represented using the forms we just discussed, and checks to see if the expression is a simple one. If so, we could have one procedure for handling it.

因此我们可以将Rif定义为一个过程。注意lambda，它接受一个表达式和一个变量，使用我们刚刚讨论的形式表示，并检查表达式是否为简单表达式。如果是，我们可以有一个过程来处理它。

could have one procedure for handling such expressions otherwise we could design a second procedure to handle the compound ones thus we have used the fact that there are two general types of expressions to design our procedure. All we have to do is decide what it means for an expression to be simple—for that we can just look at the type.

可以有一个过程来处理这样的表达式，否则我们可以设计第二个过程来处理复合表达式。因此，我们利用表达式有两种一般类型的事实来设计我们的过程。我们所要做的就是决定表达式为简单意味着什么——为此，我们只需查看类型。

What do we know about these expressions? Well, we know that a compound expression is a list hence starts with a pair, and none of our simple expressions is a pair. So to find a simple expression, we could simply confirm that the expression is not a

关于这些表达式我们知道什么？我们知道复合表达式是一个列表，因此以一对开头，而我们的简单表达式都不是一对。因此，要找到简单表达式，我们可以简单地确认该表达式不是

confirm that the expression is not a pair now we can start completing the implementation by filling in the cases. The first branch deals with simple expressions, and here we can simply set up a branch to deal with each specific type. Since there are only two types of simple expressions, we can just check to see if we're dealing with a number, say, in which case we will apply the appropriate rule; otherwise, we'll apply the rule for variables.

确认该表达式不是一对后，现在我们可以通过填充各个分支来完成实现。第一个分支处理简单表达式，这里我们可以简单地为每种特定类型设置一个分支。由于简单表达式只有两种类型，我们可以检查是否在处理一个数字，例如，如果是，则应用相应的规则；否则，应用变量的规则。

And how do we handle each simple case? We simply go back to our rules from our problem design and description. We said the

那么如何处理每个简单情况呢？我们只需回到问题设计和描述中的规则。我们说

设计描述中我们说过，常数或数字的导数为零，所以我们可以直接填入该情况。同样，我们说过，变量的导数为1，前提是它与我们正在求导的变量相同；否则为0。要处理这种情况，我们只需检查表达式是否与提供的变量相同，为此我们使用EQ，因为我们的变量是用符号表示的。这就是处理简单表达式所需的全部内容。

设计描述中我们说过，常数或数字的导数为零，所以我们可以直接填入该情况。同样，我们说过，变量的导数为1，前提是它与我们正在求导的变量相同；否则为0。要处理这种情况，我们只需检查表达式是否与提供的变量相同，为此我们使用EQ，因为我们的变量是用符号表示的。这就是处理简单表达式所需的全部内容。

对于复合表达式，我们可以使用完全相同的设计方法。

对于复合表达式，我们可以使用完全相同的设计方法。

exactly the same design methodology we can have a different branch of this top-level decision procedure for each type of expression since we only have two types of compound expressions we could simply check to see if the expression is a sum or not to see if the compound expression to the sum will just grab the first sub expression using car since we know it's the list and test to see if it is the symbol plus by comparing using EQ note the use of the quote mark to give us the symbol plus for the comparison based on that decision we will either handle the

完全相同的设计方法，我们可以为每种表达式类型设置这个顶层决策过程的不同分支。由于我们只有两种复合表达式类型，我们可以简单地检查表达式是否为和式，如果不是，则视为积式。要检查是否为和式，我们只需获取第一个子表达式，使用car，因为我们知道它是一个列表，并通过使用EQ比较它是否为符号加号。注意使用引号来给出符号加号进行比较。基于该决策，我们将处理

decision we will either handle the expression as a sum or has a product we can keep working our way through the implementation for example to deal with some expressions we can go back to what our formal math analysis set in particular we need to take the derivatives of the sub expressions and then add them together symbolically to do this we take the cat or the expression which gets out the first part of the sum and apply drift to it to get back to symbolic derivative we do the same thing with the other part of the song if we implement the riff correctly

基于该决策，我们将把表达式作为和式或积式处理。我们可以继续实现，例如处理和式表达式时，我们可以回到正式的数学分析。特别是，我们需要对子表达式求导，然后符号化地将它们相加。为此，我们取表达式的car，得到和式的第一部分，并对它应用deriv以得到符号导数。我们对和式的另一部分做同样的事情。如果我们正确实现了deriv，

song if we implement the riff correctly this should recursively return symbolic expressions for each part then to create the symbolic sum we need to convert the result to the appropriate form namely a list with the symbol plus at the front.

如果我们正确实现了deriv，这应该递归地为每一部分返回符号表达式。然后，为了创建符号和，我们需要将结果转换为适当的形式，即一个以符号加号开头的列表。

notice how the rib thus decomposes the problem into simpler versions of the same problem and then constructs a new form to return based on these parts so now let's try it out using the example of the derivative of plus XY with respect to X instead of getting what we might expect mathematically namely 1 we.

注意deriv如何将问题分解为同一问题的更简单版本，然后基于这些部分构造一个新的形式返回。现在让我们用例子试试：对表达式(+ x y)关于x求导。我们不会得到数学上预期的结果，即1，而是

might expect mathematically namely 1 we get back the list plus 1 0 technically these are the same thing but the return formed is not as satisfying as just returning the simplest possible form of this expression.

数学上预期的结果1，我们得到列表(+ 1 0)。从技术上讲，这两者是相同的，但返回的形式不如返回该表达式的最简形式令人满意。

notice why this happens our procedure always blindly breaks up the pieces of a sump applies to rib and then glues things back together it doesn't try to simplify the result the underlying reason which often happens in direct implementations of methods is that the list structure of the input expression will be exactly preserved in the output we simply replace the

注意为什么会发生这种情况。我们的过程总是盲目地分解和式的各个部分，应用deriv，然后将它们重新组合在一起。它不尝试简化结果。根本原因（在方法的直接实现中经常发生）是输入表达式的列表结构将在输出中完全保留；我们只是将

The output we simply replace the expression at each leaf of that list with this expression's derivative. What if instead we wanted our system to simplify things to more basic terms, thus not preserving the list structure of the input expression? We'll consider that question in the next section, but first let's pull out the key lessons we've seen in taking a direct approach to implementing a system.

输出中，我们只是将列表每个叶子处的表达式替换为该表达式的导数。如果我们希望系统将事物简化为更基本的项，从而不保留输入表达式的列表结构，那该怎么办？我们将在下一节考虑这个问题，但首先让我们提取直接实现系统方法中的关键教训。

First, in almost any system, our program will change after our initial design. In this case, we made an assumption that we didn't realize, namely that the structure of the input

首先，在几乎任何系统中，我们的程序在初始设计后都会改变。在这种情况下，我们做了一个我们没有意识到的假设，即输入

namely that the structure of the input list would be preserved we didn't observe this till we ran some test cases which is often true in real systems and now we need to go back and try and change our code to reflect design but this is hard in this case mostly because our code as it stands is hard to read that is to figure out which parts of the code are handling which parts of the problem

即输入列表的结构将被保留。我们直到运行一些测试用例才观察到这一点，这在真实系统中经常如此。现在我们需要回去尝试修改代码以反映设计，但这在这种情况下很难，主要是因为我们的代码目前难以阅读，即难以确定代码的哪些部分处理问题的哪些部分。

moreover suppose we want to add new expressions to our system things other than sums our products this is hard to do because we've built our code explicitly on the

此外，假设我们想向系统添加新的表达式类型，除了和式或积式之外的东西。这很难做到，因为我们的代码明确基于

我们构建代码时，明确基于一个假设，即每个表达式都有两种选择。假设我们决定改变表达式的表示方式，例如把运算符放在中间，更像真正的代数表达式，这会很困难，因为我们直接使用了实际的列表选择器和构造器，而没有将它们隔离在数据抽象后面。

我们构建代码时，明确基于一个假设，即每个表达式都有两种选择。假设我们决定改变表达式的表示方式，例如把运算符放在中间，更像真正的代数表达式，这会很困难，因为我们直接使用了实际的列表选择器和构造器，而没有将它们隔离在数据抽象后面。

所以幻灯片底部列出了一份总结，指出了导致这些问题的原因，也就是我们可能需要改变的地方，以构建一个更灵活的系统。

所以幻灯片底部列出了一份总结，指出了导致这些问题的原因，也就是我们可能需要改变的地方，以构建一个更灵活的系统。

为了构建一个更灵活的系统，让我们再次尝试构建一个符号求导系统。让我们创建一个新的实现，充分利用这些经验教训。特别是，我们需要一个更好的顶层设计，基于表达式类型来做决策。

为了构建一个更灵活的系统，让我们再次尝试构建一个符号求导系统。让我们创建一个新的实现，充分利用这些经验教训。特别是，我们需要一个更好的顶层设计，基于表达式类型来做决策。

我们将使用Khan来处理基于类型的决策，这比在每个阶段只有两个选择的if语句提供了更大的灵活性。同时，我们将通过构建一个真正的数据抽象，在用户和实现之间建立抽象屏障，来隔离数据的表示和其使用。

我们将使用cond来处理基于类型的决策，这比在每个阶段只有两个选择的if语句提供了更大的灵活性。同时，我们将通过构建一个真正的数据抽象，在用户和实现之间建立抽象屏障，来隔离数据的表示和其使用。

一段抽象的屏障存在于用户和实现者之间。如果我们打算用cond来处理不同类型方法的调度，就需要有能够识别明确类型的谓词。因此，我们会把识别特定表达式类型所需的所有测试汇集到一个单一的过程中。

一段抽象的屏障存在于用户和实现者之间。如果我们打算用cond来处理不同类型方法的调度，就需要有能够识别明确类型的谓词。因此，我们会把识别特定表达式类型所需的所有测试汇集到一个单一的过程中。

例如，确定一个表达式是否为和式，我们会为其他每种想处理的表达式类型做同样的事情。显然，我们需要对复合表达式进行这样的处理。注意，在我们之前的讨论中，隐含了一个假设。

例如，确定一个表达式是否为和式，我们会为其他每种想处理的表达式类型做同样的事情。显然，我们需要对复合表达式进行这样的处理。注意，在我们之前的讨论中，隐含了一个假设。

implicit assumption in our earlier implementation about the representation of simple expressions for example we have directly relied on the fact that a variable was represented as a symbol but we should really isolate this fact and check explicitly four types of simple expressions as well

在我们之前的实现中，关于简单表达式的表示有一个隐含的假设。例如，我们直接依赖于变量被表示为符号这一事实，但我们应该真正隔离这一事实，并明确检查简单表达式的类型。

thus the check of an expression is a variable we should actually first check that it is not a compound thing then check that it is actually of the form we are using to represent variables in this case symbols note the use of the predicate symbol to do this

因此，检查表达式是否为变量时，我们实际上应该首先检查它不是复合事物，然后检查它确实是我们用来表示变量的形式，在这种情况下是符号。注意使用谓词symbol?来做到这一点。

predicate symbol to do this. The second thing we need to do is truly implement a data extraction. We need to eliminate the dependencies within the code on the explicit form of the representation.

使用谓词symbol?来做到这一点。第二件我们需要做的事情是真正实现数据提取。我们需要消除代码中对表示形式的显式依赖。

Thus within the code we should only be using constructors and selectors which will shield the choice of representation from the use of the abstraction. Here, for example, is a constructor for some expressions with one of the associated selectors.

因此，在代码中，我们应该只使用构造器和选择器，这将屏蔽表示的选择与抽象的使用。例如，这里是一个和式表达式的构造器以及一个相关的选择器。

By creating this barrier between code that uses expressions, for example drift, and the actual representation, we're now free.

通过在使用表达式的代码（例如deriv）和实际表示之间建立这个屏障，我们现在可以自由地改变表示方式，而不会影响使用表达式的代码。

The actual representation were now free to change that representation as long as the contract between constructors and selectors is preserved. The code that uses the extraction will still work. Obviously we could complete this representation for sums, for products, and for any other expressions we want in our system.

实际的表示现在可以自由更改，只要保持构造器和选择器之间的约定不变。使用提取器的代码仍然可以工作。显然，我们可以为和、积以及系统中我们想要的任何其他表达式完成这种表示。

Now let's pull these new ideas together into a better derivative. The arguments are the same as before. The top-level structure, however, has a different form. Here we have a large cond expression where each clause dispatches on a different type of expression.

现在让我们把这些新想法整合成一个更好的求导函数。参数与之前相同。然而，顶层结构具有不同的形式。这里我们有一个大的 cond 表达式，其中每个子句根据表达式的不同类型进行分派。

On a different type of expression notice, the nice form here each clause has a predicate that checks for the type of each kind of expression starting with the simple expressions associated with each type is the method to apply to that type.

注意不同类型表达式的良好形式：每个子句都有一个谓词来检查每种表达式的类型，从简单表达式开始，与每种类型关联的是应用于该类型的方法。

Note four in particular the form for sums we use the selectors to get out the pieces we recursively apply drift to those pieces then we use the constructor to glue the pieces together into the correct form.

特别要注意和的处理形式：我们使用选择器取出各个部分，递归地对这些部分应用求导，然后使用构造器将这些部分粘合成正确的形式。

So why bother to go to all this trouble since by doing this riff only uses selectors to get at the pieces.

那么，既然通过这样做，求导函数只使用选择器来获取各个部分，为什么还要费这么大劲呢？

only uses selectors to get at the pieces, we're now free to change the underlying representation without causing any damage to drift or any other procedure that uses the selectors and constructors.

只使用选择器来获取各个部分，我们现在就可以自由地更改底层表示，而不会对求导函数或任何其他使用选择器和构造器的过程造成损害。

let's drive this point home with an example here again is our original example including the case where it's seen to return the wrong answer having separated out a clean data abstraction we can fix this problem very easily without having to touch to riff in particular let's change our constructor when we go to get a sum let's first check to see if we can simplify the

让我们用一个例子来强调这一点。这里又是我们最初的例子，包括它返回错误答案的情况。在分离出清晰的数据抽象之后，我们可以很容易地修复这个问题，而不必修改求导函数。特别是，让我们更改构造器：当我们要构造一个和时，首先检查是否可以简化表达式。

check to see if we can simplify the expression so instead of just creating a list starting with the symbol plus we'll first see if the two expressions are numbers if they are let's just add them together look very carefully at this in the case that both expressions are numbers we will return as the expression the value obtained by applying the operator associated with plus of those values that is we don't create a list here

检查是否可以简化表达式。因此，我们不会仅仅创建一个以加号符号开头的列表，而是先看看这两个表达式是否都是数字。如果是，我们就直接将它们相加。仔细看这一点：在两个表达式都是数字的情况下，我们将返回通过应用与加号相关联的运算符对这些值进行运算所得到的值作为表达式；也就是说，我们这里不创建列表。

we return a numerical value in the other cases we do return a symbolic expression simply choosing to put the number first

我们返回一个数值。在其他情况下，我们确实返回一个符号表达式，只是选择将数字放在前面。

simply choosing to put the number first if there is one the key issue is that we've only changed one thing in our system a constructor what happens to the full system well it nicely gives us the change we wanted in this simple case it returns the value of the numeric sum

如果有数字，就简单地将数字放在前面。关键是我们只更改了系统中的一个东西：构造器。整个系统会发生什么？它很好地给了我们想要的改变。在这个简单的例子中，它返回了数值和的值。

so to summarize by isolating data representations from data use it becomes much easier to make changes in the behavior of our system without requiring detailed and intertwined coding changes this leads to cleaner code which is much

总结一下，通过将数据表示与数据使用隔离开来，在不要求详细且交织的代码更改的情况下，更容易改变系统的行为。这导致了更清晰的代码，这大大简化了维护和扩展。