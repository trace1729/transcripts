# Video Transcript (视频文字稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=6)

## Summary (摘要)

- Types describe the input and output of expressions and procedures, helping to reason about programs and detect errors.
- Higher-order procedures allow capturing computational patterns, such as summation, by taking procedures as arguments.
- Procedures can also return procedures, exemplified by the derivative and average-damp operations.
- Common list-processing patterns are abstracted into map, filter, and reduce, providing powerful tools for data transformation.
- Fixed-point finding and integration are built using higher-order abstractions, demonstrating their expressive power in constructing complex algorithms.
- Type matching and type variables (like A -> B) are essential for composing higher-order procedures correctly.

- 类型描述了表达式和过程的输入与输出，有助于对程序进行推理并检测错误。
高阶过程允许通过将过程作为参数来捕获计算模式，例如求和。
过程也可以返回过程，例如求导和平均阻尼操作。
常见的列表处理模式被抽象为映射、过滤和归约，为数据转换提供了强大的工具。
不动点查找和积分是使用高阶抽象构建的，展示了它们在构造复杂算法中的表达能力。
类型匹配和类型变量（如 A -> B）对于正确组合高阶过程至关重要。

## Outline (大纲)

1. Introduction to Types in Programming / Types for Compound Data / Types for Procedures and Contracts
2. Type Declarations and Strong vs Weak Typing / Types of Expressions and Special Forms
3. Benefits of Types for Reasoning and Design / Procedural Abstraction and Generalizing Patterns / Three Sum Procedures and their Common Pattern / Mathematical Notation for Summation
4. Higher-Order Summation Procedure
5. Procedures Returning Procedures: Derivative Example / Common Patterns in List Processing / Map: Transform Each Element / Filter: Select Elements by Predicate
6. Reduce: Combine Elements into a Value / Combining Higher-Order Procedures for Summation / Expressive Power of Higher-Order Procedures / Building Integral on Top of Sum
7. Fixed Points and Higher-Order Procedures / Fixed Point Procedure and the Golden Ratio / Square Root via Fixed Point and Oscillation Problem
8. Average Damping to Control Oscillation / Comparison with Heron's Algorithm and Cube Root
9. Further Examples and Type Reasoning
10. Compose: A Higher-Order Procedure / Generality and Type Matching in Compose / Type Variables for Higher-Order Procedures / Summary: Types and Higher-Order Procedures

1. 编程中的类型简介 / 复合数据的类型 / 过程和契约的类型
类型声明与强类型与弱类型 / 表达式和特殊形式的类型
类型对推理和设计的好处 / 过程抽象和模式泛化 / 三个求和过程及其共同模式 / 求和的数学符号
高阶求和过程
返回过程的过程：求导示例 / 列表处理中的常见模式 / 映射：转换每个元素 / 过滤：按谓词选择元素
归约：将元素组合成一个值 / 组合高阶过程进行求和 / 高阶过程的表达能力 / 在求和之上构建积分
不动点与高阶过程 / 不动点过程和黄金比例 / 通过不动点求平方根及振荡问题
平均阻尼以控制振荡 / 与希罗算法和立方根的比较
更多示例和类型推理
组合：一个高阶过程 / 组合中的通用性和类型匹配 / 高阶过程的类型变量 / 总结：类型和高阶过程

## Transcript (文字稿)

### 1. Introduction to Types in Programming / Types for Compound Data / Types for Procedures and Contracts (编程中的类型简介 / 复合数据的类型 / 过程和契约的类型)

当们刚开始讨论Scheme表达式时，你可能还记得我们说每个表达式都有语法——我们如何合法地把东西组合在一起；语义——我们如何决定与表达式关联的意义；以及类型。到目前为止，我们关于类型的讨论还不多。今天我们将回到这个主题，讨论与表达式相关的类型，特别是，我们可以利用类型来推理过程，并了解在我们的语言中能构建哪些类型的过程。

当我们刚开始讨论Scheme表达式时，你可能还记得我们说每个表达式都有语法——我们如何合法地把东西组合在一起；语义——我们如何决定与表达式关联的意义；以及类型。到目前为止，我们关于类型的讨论还不多。今天我们将回到这个主题，讨论与表达式相关的类型，特别是，我们可以利用类型来推理过程，并了解在我们的语言中能构建哪些类型的过程。

所以让我们来激发类型这个概念。考虑以下两个小例子。

所以让我们来激发类型这个概念。考虑以下两个小例子。

Type consider the following two little examples. The first expression certainly will evaluate correctly to the value 15. The second expression we know should give an error, even though we'd like sometimes to give a high five, we can't add high two five basically because plus primitive addition operation is expecting to get in integers or at least numbers as its input, and high of course is not, hence the error.

考虑以下两个小例子。第一个表达式肯定会正确求值为15。第二个表达式我们知道应该会出错，即使我们有时想要击掌（high five），我们也不能把“high”和“five”相加，基本上是因为加法原语操作期望输入整数或至少是数字，而“high”当然不是，因此出错。

No, what this says is the procedure has associated with it an idea of what kind of object it expects as input, it's expecting

不，这说的是过程关联了一个关于它期望输入何种对象的概念，它期望

它期望输入的是特定类型，而这里我们给这个程序传入了一个字符串，所以它会报错，说“我无法完成这个任务”。现在，让我们把这个想法正式化：我们希望为语言中几乎每一种表达式都分配一个类型。

它期望输入的是特定类型，而这里我们给这个程序传入了一个字符串，所以它会报错，说“我无法完成这个任务”。现在，让我们把这个想法正式化：我们希望为语言中几乎每一种表达式都分配一个类型。

我们已经见过一些基本的原始类型：数字是其中一种类型，字符串是另一种类型，布尔值则是第三种类型。此外，符号是事物的名称，我们将在接下来的几节课中再讨论它们。

我们已经见过一些基本的原始类型：数字是其中一种类型，字符串是另一种类型，布尔值则是第三种类型。此外，符号是事物的名称，我们将在接下来的几节课中再讨论它们。

对于某些东西，比如数字，我们实际上可以更具体一些，例如区分整数和浮点数。

对于某些东西，比如数字，我们实际上可以更具体一些，例如区分整数和浮点数。

For example, distinguishing integers from real numbers, as we saw with our motivating example, we typically want to know the type of a data structure in order to decide if some procedures are appropriate to apply to that type.

例如，区分整数和实数，正如我们在动机示例中看到的，我们通常需要知道数据结构的类型，以便决定某些过程是否适用于该类型。

These basic primitive data types will usually be sufficient to handle the cases we'll see. For compound data, we saw that the basic element was a pair, and we have a type notation to denote one. Note that we include in this notation a specification of the types of the elements within the pair. We also saw that we could construct...

这些基本的原始数据类型通常足以处理我们将遇到的情况。对于复合数据，我们看到基本元素是序对，我们有一个类型表示法来表示它。注意，在这个表示法中，我们包含了序对中元素类型的规范。我们还看到，我们可以构造...

pair we also saw that we could construct

序对，我们还看到我们可以构造

pair we also saw that we could construct a list out of pairs so we can create a tight notation for that as well in essence we are creating a formal definition for a list we specify that this compound data structure is recursively defined as a pair whose first element is of some type a and whose second element is either another list or the empty list this exactly reflects the description we gave when we introduced lists note that in our type specifications

序对，我们还看到我们可以用序对构造列表，因此我们也可以为此创建一种紧凑的表示法。本质上，我们正在为列表创建一个正式定义：我们指定这个复合数据结构递归地定义为一个序对，其第一个元素是某种类型a，第二个元素要么是另一个列表，要么是空列表。这正好反映了我们引入列表时给出的描述。注意，在我们的类型规范中

we can include the possibility of alternative types of elements as shown in the example now we don't just have

我们可以包含元素类型的替代可能性，如示例所示。现在，我们不仅仅有

In the example now we don't just have data structures in our language we have procedures that operate on them so we want to identify different types of procedures as well. We will do this by creating a notation that indicates the number of arguments to procedure, the type of each, and the type of the value returned by the procedure. For example, number maps to number would indicate a procedure that takes a single number as input and returns a number as output. We've now seen that for procedures we can also associate a type.

在示例中，现在我们的语言中不仅有数据结构，还有操作它们的过程，因此我们也想识别不同类型的过程。我们将通过创建一种表示法来做到这一点，该表示法指示过程的参数数量、每个参数的类型以及过程返回值的类型。例如，number -> number 表示一个过程，它接受一个数字作为输入，并返回一个数字作为输出。我们现在已经看到，对于过程，我们也可以关联一个类型。

can also associate a type in particular

也可以关联一个类型，特别是

Can also associate a type in particular. We can specify procedure that expects a particular number of arguments, and each argument is expected to be of a particular type. Moreover, the procedure's output is also of a particular type.

也可以关联一个类型，特别是。我们可以指定一个过程期望特定数量的参数，并且每个参数期望是特定类型。此外，过程的输出也是特定类型。

And that's going back to our original example. We know that integer addition has a particular expectation on the types of arguments, so we can represent this with the following little notation. We say the type of this procedure is denoted by two numbers being mapped to a number. The first part designates both the number of arguments the procedure expects.

回到我们最初的例子。我们知道整数加法对参数类型有特定的期望，因此我们可以用以下小表示法来表示。我们说这个过程类型表示为两个数字映射到一个数字。第一部分指定了过程期望的参数数量和它们应该是什么类型的对象，第二部分指示了该过程将产生的输出类型。这意味着我们现在可以将我们谈论对象的能力扩展到过程，这里有一些例子。

the number of arguments the procedure takes and the kinds of objects they should be and the second part indicates the kind of output that will be produced by this procedure this means we can now extend our ability to talk about objects to procedures and here are some examples

过程接受的参数数量和它们应该是什么类型的对象，第二部分指示了该过程将产生的输出类型。这意味着我们现在可以将我们谈论对象的能力扩展到过程，这里有一些例子。

the expression 15 obviously is just a number expression high in double quotes is obviously a string the name square we know has been bound by our earlier examples to procedure and it therefore has the type of mapping a number to a number the expression greater than

表达式15显然只是一个数字表达式，带引号的“high”显然是一个字符串，名称square我们知道在之前的例子中已经绑定到一个过程，因此它具有将数字映射到数字的类型。表达式greater-than...

Number the expression greater than something is built-in takes in as input two numbers and maps them to a boolean or true/false value. You can see how the specification of the number and type of arguments and the type of result capture the overall type of the procedure, and in fact we can think of this as a kind of contract.

将表达式编号为“大于”的内置函数，它接收两个数字作为输入，并将它们映射为一个布尔值或真/假值。你可以看到，参数的数量和类型以及结果的类型如何共同刻画了过程的整体类型，事实上，我们可以将其视为一种契约。

It says for this procedure, if the inputs are of the right type and they're the right number of them, the procedure will return a value of the specified type. Otherwise, all bets are off. Note that it doesn't say the procedure will compute the right value.

它表明，对于这个过程，如果输入的类型正确且数量正确，那么该过程将返回指定类型的值。否则，一切皆有可能。请注意，它并没有说该过程会计算出正确的值。

procedure will compute the right value. It just says that it's going to give us the right type of thing. Up there's a more detailed contract that deals with the actual computation of the procedure.

过程会计算出正确的值。它只是说它将返回正确类型的东西。上面有一个更详细的契约，涉及过程的实际计算。

### 2. Type Declarations and Strong vs Weak Typing / Types of Expressions and Special Forms (类型声明与强类型和弱类型 / 表达式和特殊形式的类型)

Note, as an aside, that some languages require the programmer to explicitly state this contract. For example, in C or in Java, or other strongly typed languages, the programmer must state at the time of definition what kinds of arguments the procedure expects and what kind of result will be returned. This allows the system to check for possible errors.

顺便注意，有些语言要求程序员明确声明这个契约。例如，在C或Java等强类型语言中，程序员必须在定义时说明过程期望的参数类型以及返回的结果类型。这允许系统检查可能的错误。

system to check for possible errors and can help the programmer but it also restricts the flexibility of the programmer scheme is known as a weekly type language it doesn't require such explicit type declarations but a good programmer is going to take advantage of such discipline as we're going to see shortly

系统检查可能的错误，并能帮助程序员，但这也限制了程序员的灵活性。Scheme被称为弱类型语言，它不要求这样显式的类型声明，但一个好的程序员会利用这种纪律，我们很快就会看到。

we can actually make this very formal just for a second to be very precise about types a type describes a set of scheme values for example the mapping number to number which describes a procedure actually describes a set it describes the set of all procedures

我们可以暂时非常正式地来精确说明类型。类型描述了一组Scheme值，例如“数到数”的映射，它描述了一个过程，实际上描述了一个集合，它描述了所有过程的集合。

describes the set of all procedures whose result is a number and which require one argument but that must also be a number so that therefore this designation of a type includes a whole bunch of procedures.

它描述了所有结果的类型是数字且需要一个参数（该参数也必须是数字）的过程的集合。因此，这个类型指定包含了一整类过程。

when we're talking about scheme values we say that every scheme value has a type it turns out that some values can be described by many types and in that case we will always choose the type which describes the largest set in order to characterize that particular value.

当我们谈论Scheme值时，我们说每个Scheme值都有一个类型。事实证明，有些值可以用多种类型来描述，在这种情况下，我们总是选择描述最大集合的类型来表征该特定值。

what about things like to find and remember we said things like define or other special form keywords do not name values it was unspecified what define did in the lower part of that to world view for example and therefore special form keywords we say have no type let's see if you're getting this here are three examples scheme expressions if you evaluate each one of them is going to return a particular kind of object and you ought to be able to now figure out what is the type associated with the value returned by each of these.

那么像define这样的东西呢？我们说过，define或其他特殊形式的关键字并不命名值。在那个世界观的下部，define做什么是未指定的，因此我们说特殊形式的关键字没有类型。让我们看看你是否理解了这一点。这里有三个Scheme表达式的例子，如果你对每个表达式求值，它将返回一种特定类型的对象，你现在应该能够找出与每个表达式返回的值相关联的类型。

value returned by each of these expressions when you're ready to look at the answers, hit the next button, and on your browser, and we'll move on. So we know the first thing should return a procedure, because the lambda is going to make that procedure for us. We know the number of arguments is three. Each of them, we can see, should be a number because A is used in a position where greater than expects a number, and B and C are used in a position where plus expects numbers.

每个表达式返回的值。当你准备好查看答案时，点击浏览器上的“下一个”按钮，我们将继续。所以我们知道第一个应该返回一个过程，因为lambda将为我们创建那个过程。我们知道参数的数量是三个。每一个，我们可以看到，应该是一个数字，因为A用在大于期望数字的位置，而B和C用在加号期望数字的位置。

And what's the value returned? Well, if we look at both the consequent and the alternative clause of

那么返回的值是什么？好吧，如果我们看if的

consequent and the alternative Clause of the if we can see that the procedures there will return numbers therefore lambda will also return a number for the second one we again know it's a procedure so it's going to be a mapping the input P we can figure out its type by looking at where it's used it's used as an expression inside the if that expects a revert turn value of a boolean therefore P must itself be a boolean and was returned by the overall lambda well game both the consequent in the alternative return the same type of thing I string so the whole procedure

if的结果部分和替代子句，我们可以看到那里的过程将返回数字，因此lambda也将返回一个数字。对于第二个，我们再次知道它是一个过程，所以它将是一个映射。输入P，我们可以通过查看它的使用位置来确定它的类型：它用作if内部的一个表达式，该if期望返回一个布尔值，因此P本身必须是一个布尔值。而整个lambda返回什么？好吧，结果部分和替代子句都返回相同类型的东西：字符串，所以整个过程

Thing I string so the whole procedure will return the string and of course the last one isn't a procedure at all this is just a normal expression involving numbers and the type returned by the value of the object is a number so to summarize a type is a set of values that characterizes a set of things that belong together due to a common behavior and virtually every expression and scheme has a value that has a type associated with it a particular interest to us are procedures which we can also type based on the number and type

字符串，所以整个过程将返回字符串。当然，最后一个根本不是过程，这只是一个涉及数字的普通表达式，返回的对象值的类型是数字。总结一下，类型是一组值，它刻画了一组因共同行为而属于一起的事物，并且Scheme中几乎每个表达式都有一个具有关联类型的值。我们特别感兴趣的是过程，我们也可以根据参数的数量和类型

type based on the number and type of

类型基于参数的数量和类型

Type based on the number and type of arguments and the type of the return value, as we're going to see, types provide a very nice mathematical framework for reasoning about programs.

类型基于参数的数量和类型以及返回值的类型，正如我们将看到的，类型为推理程序提供了一个非常好的数学框架。

### 3. Benefits of Types for Reasoning and Design / Procedural Abstraction and Generalizing Patterns / Three Sum Procedures and their Common Pattern / Mathematical Notation for Summation (类型对推理和设计的好处 / 过程抽象与模式泛化 / 三个求和过程及其共同模式 / 求和的数学记号)

First, they can provide a basis for preventing common errors in our code. If we know that a procedure expects a particular type of argument, we can use this to ensure that other procedures are expressions supplying the correct kind of argument.

首先，它们可以为防止代码中的常见错误提供基础。如果我们知道一个过程期望特定类型的参数，我们可以利用这一点来确保其他过程或表达式提供正确类型的参数。

Second, we're about to see how types of procedures can serve as a key tool in helping us design other procedures by providing a framework for

其次，我们即将看到过程的类型如何作为帮助我们设计其他过程的关键工具，通过提供一个框架来

procedures by providing a framework for understanding how values are passed between procedures in the rest of this lecture

过程提供一个框架，用于理解值如何在过程之间传递。在本讲座的其余部分，

we're going to use this idea to explore how we can create complex but powerful procedures that manipulate a wide range of information beyond simple numbers

我们将利用这个想法来探索如何创建复杂而强大的过程，这些过程可以处理超出简单数字的各种信息。

so why bother with types well we're going to see that they're very useful in helping us reason about procedures in particular to help us catch errors and to deduce what kinds of inputs and outputs different sorts of procedures should take

那么为什么要费心处理类型呢？我们将看到它们在帮助我们推理过程方面非常有用，特别是帮助我们发现错误并推断不同种类过程应该接受什么样的输入和输出。

so in the rest of this

所以在接下来的

So in the rest of this lecture we're going to see how quickly we can build up to deal with complex patterns where procedures take not just numbers but whole different kinds of beasts. To do this, let's go back for a second and think about what procedure abstraction is really about. The goal of a procedure is to capture common pattern. Here are, for example, three common patterns: I'm multiplying something by itself, whether it's a number or some name for a number. So what I'd like to do is capture that common pattern in a procedure, and of course we know how to.

因此，在本讲剩余部分，我们将看到如何快速构建以处理复杂模式，其中过程不仅接受数字，还接受各种不同类型的对象。为此，让我们先稍作回顾，思考过程抽象的真正含义。过程的目标是捕获共同模式。例如，这里有三种常见模式：我将某物自乘，无论它是一个数字还是某个数字的名称。所以我想做的是在过程中捕获这种共同模式，当然，我们知道如何做到。

procedure and of course we know how to do that we create a lambda that has one formal parameter to be the part of the pattern we want to have replaced and a body which is the actual pattern we're going to want to execute when we go ahead and use this procedure but the key point to stress is what the lambda is doing what the procedure is doing when it makes an obstruction it's capturing a common pattern that we can reuse over and over again and of course once we captured that common pattern we want to be able to refer to it so we give a name

过程，当然我们知道如何做到：我们创建一个 lambda，它有一个形式参数，用于表示我们想要替换的模式部分，以及一个函数体，即当我们使用这个过程时实际要执行的模式。但关键要强调的是 lambda 在做什么，过程在做什么，当它进行抽象时，它是在捕获一个我们可以反复重用的共同模式。当然，一旦我们捕获了那个共同模式，我们就希望能够引用它，所以我们给过程一个名称。

be able to refer to it so we give a name to the procedure and note now we can also characterize the type of this procedure this is simply something that takes a number as input and gives out a number as output so the key idea when we use that idea of procedural abstraction is we took a common pattern we captured it and give it a name so we could treat it as if we had a handle on that particular concept we now have the notion of square as as primitive unit that we can use without worrying about the details of how it's actually done now let's take the idea of capturing

能够引用它，所以我们给过程一个名称。注意，现在我们还可以描述这个过程类型：这只是一个接受数字作为输入并输出数字的东西。因此，当我们使用过程抽象这一思想时，关键是我们取了一个共同模式，捕获它并给它命名，这样我们就可以把它当作对那个特定概念的一个操作柄。我们现在有了 square 作为一个原始单元的概念，我们可以使用它而无需担心其实际实现的细节。现在让我们来探讨捕获

that we can use without worrying about the details of how it's actually done

我们可以使用它而无需担心其实际实现的细节。

now let's take the idea of capturing

现在让我们来探讨捕获

now let's take the idea of capturing patterns and see how far we can push it. so here are three different expressions. from mathematics we have the sum of the integers starting at 1, the sum of the squares of the integers starting at 1, and a funny sum that is 1 over the squares of the odd integers and in fact the mathematicians know there are formulas determining what the values of each of these are. the third one's kind of interesting because it gives us a pretty good approximation to PI squared.

现在让我们来探讨捕获模式，看看我们能将其推进多远。这里有三个不同的表达式。从数学中，我们有从 1 开始的整数之和，从 1 开始的整数平方之和，以及一个有趣的求和，即奇数平方的倒数之和。事实上，数学家们知道有公式可以确定这些表达式的值。第三个有点意思，因为它给出了对 π 平方的一个相当好的近似。

we can certainly write procedures to

我们当然可以编写过程来计算

We can certainly write procedures to compute each of these. This is something we've done before. So here are three different procedures: one for summing all the integers from A to B, one for summing all the squares from A to B, and one for taking this pi sum. And of course, it has the form we expect, which is a nice little recursive call. For example, in summing integers, it says add A to whatever I get by doing the sum from one plus A up to B, and I keep doing that until A is bigger than B, in which case I just add in 0. And the other procedures follow rather naturally from the things we've...

我们当然可以编写过程来计算这些表达式中的每一个。这是我们以前做过的事情。所以这里有三个不同的过程：一个用于对从 A 到 B 的所有整数求和，一个用于对从 A 到 B 的所有平方求和，还有一个用于计算这个 π 求和。当然，它具有我们预期的形式，即一个漂亮的递归调用。例如，在整数求和中，它说将 A 加上我从 1 加 A 到 B 的求和结果，并且我一直这样做直到 A 大于 B，在这种情况下我只需加上 0。其他过程则相当自然地从我们已经……

Rather naturally from the things we've already seen, notice however if we stop here we haven't quite got the same thing. There's a difference between the procedures we've written and the concept of the summation that's going on in the top examples. Each procedure here is just a different thing that does its own summation from one point to another.

相当自然地从我们已经看到的东西中得出。然而请注意，如果我们停在这里，我们还没有完全得到同样的东西。我们编写的过程与上面例子中进行的求和概念之间存在差异。这里的每个过程只是一个不同的东西，它执行从一点到另一点的自身求和。

But there is a common pattern there and that's the idea of a summation. In fact, the mathematicians know how to capture that. They have a notation that says here's how to write a sum, and this is a.

但那里有一个共同模式，那就是求和的思想。事实上，数学家们知道如何捕获它。他们有一种记号，说明如何写一个和，这是一个……

Here's how to write a sum, and this is a more general pattern that basically says specify a beginning and an end point, specify what the actual terms are that you're adding, specify any other conditions, and now you've got the idea of creating that sum. Note that this isn't just notation; this is actually a way of saying there's a common pattern here.

如何写一个和，这是一个更一般的模式，它基本上说：指定一个起点和一个终点，指定你实际相加的项，指定任何其他条件，现在你就有了创建该和的思想。注意，这不仅仅是记号；这实际上是在说这里有一个共同模式。

And now we'd like to know can we get a hold of the same thing? Well, if we look at our procedure examples, we can see that there clearly is a common pattern here as well. If I look at these three examples, I can see that they share a similar structure, just like the sum notation does.

现在我们想知道我们能否掌握同样的东西？好吧，如果我们看看我们的过程示例，我们可以看到这里显然也有一个共同模式。如果我看看这三个例子，我可以看到它们共享一个类似的结构，就像求和记号一样。

If I look at these three examples, I can highlight the only things that are actually different, and there are two of them. There's the actual term that I'm adding in as I do this sum, and there's the method I use to try and get to the next stage.

如果我看看这三个例子，我可以突出显示实际上不同的部分，有两个。一个是当我进行这个求和时实际添加的项，另一个是我用来尝试进入下一阶段的方法。

### 4. Higher-Order Summation Procedure (高阶求和过程)

Now, how do we get from things like x - 2 or x XX - square? Well, we know what we did. We provided a name for the parameter that was going to be the part of the pattern that would change, and we captured the whole thing in a procedure with that parameter.

现在，我们如何从像 x - 2 或 x XX - square 这样的东西出发？好吧，我们知道我们做了什么。我们为参数提供了一个名称，该参数将是模式中会改变的部分，我们将整个东西捕获在一个带有该参数的过程中。

So let's do the same thing here. We'll need a parameter for

所以让我们在这里做同样的事情。我们需要一个参数用于

thing here we'll need a parameter for the term we'll need a parameter for the term we'll need a parameter for the next thing we're going to compute we also have the parameters amv and let's grab this in a procedure so here's the procedure I've now got the four parameters and all I've done is substituting the parameter for each of the places where I was capturing the common pattern but know this looks a little different now than the things we've seen before so let's look at that a bit more carefully on the next slide so this is interesting up until now whenever we used a parameter in part of a procedure we've

这里我们需要一个参数用于项，我们需要一个参数用于我们接下来要计算的东西，我们还有参数 amv，让我们把这个捕获到一个过程中。所以这是过程，我现在有四个参数，我所做的只是将参数替换到每个我捕获共同模式的位置。但要知道，这看起来与我们之前见过的有些不同，所以让我们在下一张幻灯片上更仔细地看看。这很有趣，因为到目前为止，每当我们在过程的一部分中使用参数时，我们

参数在过程的一部分中，我们基本上用它来表示一个数字。我们有将数字映射成数字的过程，这里我们有两个不同的参数，显然它们出现在过程体中的位置不同，它们期望自身是过程。那么这能行吗？让我们先停下来思考一下发生了什么。

参数在过程的一部分中，我们基本上用它来表示一个数字。我们有将数字映射成数字的过程，这里我们有两个不同的参数，显然它们出现在过程体中的位置不同，它们期望自身是过程。那么这能行吗？让我们先停下来思考一下发生了什么。

这个过程的类型是什么？我们可以写出这个复杂的表达式，但我们可以先看看每个部分。我们知道这个过程接受四个输入，并且我们...

这个过程的类型是什么？我们可以写出这个复杂的表达式，但我们可以先看看每个部分。我们知道这个过程接受四个输入，并且我们……

this procedure takes four inputs and we

这个过程接受四个输入，并且我们

this procedure takes four inputs and we see four different expressions and it produces a single output which we know is a number. and what are the inputs well the first one we can see must itself be a procedure by where it's used and its type must be that it takes a number as input and produces a number as output.

这个过程接受四个输入，并且我们看到四个不同的表达式，它产生一个输出，我们知道这是一个数字。那么输入是什么？第一个，我们可以看到，根据它的使用位置，它本身必须是一个过程，并且它的类型必须是接受一个数字作为输入并产生一个数字作为输出。

the second term or second parameter rather is also just clearly a number by the same reasoning. the third parameter must be a procedure that map's a number to a number. and the fourth parameter is again just a number. and overall this whole thing is a procedure it maps those.

第二个项或第二个参数同样显然是一个数。第三个参数必须是一个将数映射到数的过程。第四个参数又只是一个数。整体上，这个过程将这四个参数映射到一个数。

whole thing is a procedure it maps those four parameters into a number it just happens that some of the inputs here are themselves procedures and not just numbers so this is a new kind of beast we call this kind of beast a higher-order procedure that is it's a procedure that takes as input possibly procedure and it may in fact also as we'll see return as output a procedure as well

整体是一个过程，它将这四个参数映射到一个数，只不过其中一些输入本身是过程而不仅仅是数。因此这是一种新的东西，我们称之为高阶过程，即它接受过程作为输入，并且正如我们将看到的，它也可能返回一个过程作为输出。

this is different from what we've seen so far and it's going to be something we're using a lot as we go along through the term note that the inputs could be named

这与我们目前所见的不同，并且随着课程的推进，我们会经常用到它。注意，输入可以是命名的过程，如 square，也可以直接是纯 lambda 表达式。无论哪种情况，根据我们的替换模型，求值将返回一个过程，然后可以将其替换到我们想要的任何地方的函数体中。现在我们看到，我们已经捕捉到了 sum、sum-squares 和 pi-sum 这些常见模式，它们现在都表现为对这个高阶过程的不同变体，在适当的地方使用过程参数和数参数。

that the inputs could be named procedures like square they could be just a pure lambda itself in either case we know by our substitution model that the evaluation will return a procedure that can be then substituted into the body of some everywhere we want it and now we see we've captured that common pattern of some some integers some squares and PI some are all now represented as being a different variation on the use of this higher-order procedure some using parameters of procedures where appropriate and parameters of numbers

在适当的地方使用过程参数和数参数。这真的有效吗？最简单的检查方法是拿出替换模型，用一个简单的例子试一试，看看过程是否被替换到函数体的正确位置，从而使计算真正进行。你应该这样做以说服自己。

appropriate and parameters of numbers were appropriate does this really work well the easiest way to check it is to pull out the substitution model and try that for a simple example to see that in fact procedures are substituted into the body in the right place to make the computation actually work and you ought to do that just to convince yourself so.

在适当的地方使用过程参数和数参数。这真的有效吗？最简单的检查方法是拿出替换模型，用一个简单的例子试一试，看看过程是否被替换到函数体的正确位置，从而使计算真正进行。你应该这样做以说服自己。

### 5. Procedures Returning Procedures: Derivative Example / Common Patterns in List Processing / Map: Transform Each Element / Filter: Select Elements by Predicate (返回过程的过程：导数示例 / 列表处理中的常见模式 / Map：变换每个元素 / Filter：按谓词选择元素)

we have now seen how procedures can be passed in as arguments to other procedures but we can also have procedures return procedures as values where might that be useful well here's a simple mathematical example let's ask a

我们现在已经看到了如何将过程作为参数传递给其他过程，但我们也可以让过程返回过程作为值。这在什么地方可能有用呢？这里有一个简单的数学例子。让我们问一个

simple mathematical example let's ask a fundamental question what is a derivative first we know that given some function f such as the one shown here there are standard rules for finding the derivative of f which we denote D of F as shown we can easily write down a procedure to compute F but what is D in particular can we write a single procedure for D that would take the derivative of any function so what do we know about this beast well it needs to map a function to another function or said slightly differently it needs to take his input any procedure that

简单的数学例子。让我们问一个基本问题：什么是导数？首先，我们知道给定某个函数 f，例如这里所示的函数，有标准的规则来求 f 的导数，我们记为 D(F)，如图所示。我们可以很容易地写出一个计算 F 的过程，但 D 是什么？特别是，我们能否为 D 写一个单一的过程，它可以对任何函数求导？那么我们对这个家伙了解多少呢？它需要将一个函数映射到另一个函数，或者换句话说，它需要接受任何表示数值函数的过程作为输入，并且需要返回一个过程，使得将该返回过程应用于任何值时，都能给出原函数在该点导数的良好近似。数值上，所示的方程对我们来说效果不错。那么我们如何捕捉大 D 的概念呢？就在这里，仔细看这个形式。Drib 接受一个参数，我们看到它必须是一个过程，一个数值参数。在与 Durov 相关的 lambda 体内部，有第二个 lambda，这也是一个接受一个数值参数并返回一个数值的过程。因此我们可以看到这个过程的形式如下：它接受一个过程并返回一个过程，每个过程都是数值过程。现在这有意义吗？

take his input any procedure that represents a numerical function and it needs to return a procedure with the property that applying that return procedure to any value will give us a good approximation to the derivative of the original function at that value numerically the equation shown will do a decent job for us so how do we then capture the idea of Big D well here it is look carefully at this form drib takes one argument which we see must be a procedure one numerical argument inside the body of the lambda associated with

接受任何表示数值函数的过程作为输入，并且需要返回一个过程，使得将该返回过程应用于任何值时，都能给出原函数在该点导数的良好近似。数值上，所示的方程对我们来说效果不错。那么我们如何捕捉大 D 的概念呢？就在这里，仔细看这个形式。Drib 接受一个参数，我们看到它必须是一个过程，一个数值参数。在与 Durov 相关的 lambda 体内部，有第二个 lambda，这也是一个接受一个数值参数并返回一个数值的过程。因此我们可以看到这个过程的形式如下：它接受一个过程并返回一个过程，每个过程都是数值过程。现在这有意义吗？

with with Durov is a second lambda this is also procedure of one numerical argument that returns a numerical value thus we can see the type of this procedure is as shown it takes a procedure to procedure each of which is a numerical procedure now does this make sense

它接受一个过程并返回一个过程，每个过程都是数值过程。现在这有意义吗？

sure suppose we define square as shown and we take the derivative note the nested parentheses in doing this the first compound sub expression should return a procedure as a value for this to make sense and to see that it does use the substitution model we substitute

当然。假设我们定义 square 如图所示，然后我们求导数。注意这样做时的嵌套括号：第一个复合子表达式应该返回一个过程作为值，为了使这有意义，并且为了看到它确实如此，我们使用替换模型，将 square 的值替换到 derivative 函数体的所有位置。我们看到形式参数 F，我们得到的混乱正是如此。现在如果我们完成这个过程，我们将 5 替换为 X，这简化为一个类似于我们之前见过的表达式。

Use the substitution model, we substitute the value of square everywhere in the body of derivative. We see the formal parameter F, the mess that we get does exactly that. Now if we complete the process, we substitute 5 for X, which reduces to an expression similar to those we've seen before.

使用替换模型，我们将 square 的值替换到 derivative 函数体的所有位置。我们看到形式参数 F，我们得到的混乱正是如此。现在如果我们完成这个过程，我们将 5 替换为 X，这简化为一个类似于我们之前见过的表达式。

So we see that this kind of higher-order procedure also has a very valuable role. Now let's see how we can use higher-order procedures on data structures. Remember our list from before, we saw that there were common patterns for using list, especially creating new lists out of old.

所以我们看到这种高阶过程也具有非常有价值的作用。现在让我们看看如何将高阶过程用于数据结构。记住我们之前的列表，我们看到使用列表有一些常见模式，特别是从旧列表创建新列表。

especially creating new lists out of old ones. In particular, we have the idea of generating a list, consing it up as we move down another list. We can generalize that idea so that instead of just making a copy of a list, I do something to each element of the list as I make the copy.

特别是从旧列表创建新列表。特别是，我们有生成列表的想法，当我们沿着另一个列表向下移动时，将其 cons 起来。我们可以推广这个想法，这样我们不仅仅是复制列表，而是在复制时对列表的每个元素做一些事情。

For example, each of these procedures takes a list as input and generates a new list, transforming each element in a fixed way. The first example squares each element of the input list. The second one doubles each element of the list. Notice the form is very similar to our append.

例如，以下每个过程都以列表作为输入，并生成一个新列表，以固定的方式变换每个元素。第一个例子对输入列表的每个元素求平方。第二个例子将列表的每个元素加倍。注意形式与我们的 append 非常相似。

The form is very similar to our append example from before. We walk down the input list one element at a time; however, here we actually apply some procedure to the element before joining it to the output.

形式与之前的 append 示例非常相似。我们一次一个元素地遍历输入列表；然而，这里我们在将元素连接到输出之前，实际上对元素应用了某个过程。

Note how the procedures use the selectors and constructors of the data abstraction to extract elements and create elements, and how the recursive structure of the procedure reflects the recursive structure of the data abstraction. Well, this ought to look familiar.

注意这些过程如何使用数据抽象的选择器和构造器来提取元素和创建元素，以及过程的递归结构如何反映数据抽象的递归结构。嗯，这应该看起来很熟悉。

Clearly, there's a common pattern here. The common pattern is to take a list as

显然，这里有一个常见模式。这个常见模式是接受一个列表作为

The common pattern is to take a list as input, walk our way down the list, construct a new list as output, but do something to each element as we move them all into that list. Well, we know what to do if we see a common pattern: we ought to capture it in a procedure and generalize it.

这个常见模式是接受一个列表作为输入，沿着列表向下遍历，构造一个新列表作为输出，但在将每个元素移入列表时对每个元素做一些事情。嗯，我们知道如果看到常见模式该怎么做：我们应该将其捕捉到一个过程中并加以推广。

So map is a very common interface to a list that does exactly that. And what is map to? Well, it's a higher-order procedure. It takes as argument both a list to be copied or manipulated and the procedure. And at its essence, it walks its way down the list, creating a new list as it goes.

因此，map 是一个非常常见的列表接口，它正是做这件事的。map 是什么？它是一个高阶过程。它接受一个列表（要复制或操作的）和一个过程作为参数。本质上，它沿着列表向下遍历，同时创建一个新列表。

creating a new list as it goes but applying the procedure to each element in turn, so of course both square list and double list are just versions of applying a procedure to the elements of the list as shown.

在遍历过程中创建一个新列表，但依次将过程应用于每个元素，因此显然 square-list 和 double-list 都只是将过程应用于列表元素的版本，如上所示。

Note that in all the previous examples and certainly anything that uses map, the length of the output list will be the same as the length of the input list. That is, for each element in the list, I do something to it, create a new value, and generate that as the element to place into the new list that I'm creating.

注意，在之前的所有示例中，以及任何使用 map 的情况中，输出列表的长度将与输入列表的长度相同。也就是说，对于列表中的每个元素，我对它做一些操作，创建一个新值，并将其作为要放入新列表的元素。

What happens though if we want to create a list that has different

但如果我们想要创建一个长度不同的列表呢？

want to create a list that has different lengths in particular to only select some elements out of the list as we move along it well for that we need another conventional interface or conventional procedure for dealing with lists and that's called a filter much like a coffee filter is going to let some things through and remove other ones notice the nice form of this as before we recursively walk our way along a list if we have an empty list we just return an empty list nothing left to do otherwise we take the first element of the list and apply a predicate to it

特别是，如果我们只想在遍历列表时选择其中的某些元素，那么我们需要另一个处理列表的常规接口或常规过程，称为 filter（过滤器）。就像咖啡过滤器会让一些东西通过而移除其他东西一样。注意其优美的形式：和之前一样，我们递归地遍历列表；如果列表为空，则直接返回空列表，没有剩余工作；否则，我们取列表的第一个元素并将一个谓词应用于它。

the list and apply a predicate to it. Note this must be a procedure, so filter itself is a higher-order procedure.

将谓词应用于列表的第一个元素。注意，这必须是一个过程，因此 filter 本身是一个高阶过程。

If that first element satisfies the predicate, in other words, if that whole expression returns a true value, then we keep the element. So just as before, we copy a version of that element onto whatever we get by filtering the rest of the list with predicate.

如果第一个元素满足谓词，换句话说，如果整个表达式返回真值，那么我们保留该元素。因此，和之前一样，我们将该元素的一个副本附加到用谓词过滤列表其余部分所得的结果上。

If that first element doesn't satisfy the predicate, we throw it away, or rather, we don't copy it and we simply return whatever we get by filtering the rest of the list with predicate.

如果第一个元素不满足谓词，我们将其丢弃，或者更确切地说，我们不复制它，而只是返回用谓词过滤列表其余部分所得的结果。

rest of the list with predicate, otherwise the structure looks much like the other things we've done for manipulating lists. Finally suppose that we want to gather the elements of a list together as we move along them rather than just generating a new list with some coffee of it in there.

用谓词过滤列表的其余部分，否则结构看起来与我们处理列表的其他方法非常相似。最后，假设我们想要在遍历列表时收集元素，而不仅仅是生成一个包含某些副本的新列表。

### 6. Reduce: Combine Elements into a Value / Combining Higher-Order Procedures for Summation / Expressive Power of Higher-Order Procedures / Building Integral on Top of Sum (归约：将元素组合为值 / 组合高阶过程进行求和 / 高阶过程的表达能力 / 在 sum 之上构建 integral)

We may actually want to get some different kind of result out. For instance, if we have a list of numbers, we might want to add them all up. And a nice way to do that is to simply walk our way down the list, adding the first element of the list to whatever we are by adding up the rest.

我们可能实际上想要得到某种不同的结果。例如，如果我们有一个数字列表，我们可能想把它们全部加起来。一个很好的方法是简单地遍历列表，将第一个元素加到我们对剩余元素求和的结果上。

Whatever we are by adding up the rest of them, there's that nice recursive pattern again. Or we could multiply everything together.

将第一个元素加到我们对剩余元素求和的结果上，这里又出现了那个优美的递归模式。或者我们可以将所有元素相乘。

Of course, we have to worry in this case about what is the value we return when we get to an empty list. In the case of addition, when we've got nothing left to add in, we want to add a zero. In the case of multiplication, when we have nothing left to multiply, we want to throw in a 1.

当然，在这种情况下，我们必须考虑当到达空列表时返回什么值。对于加法，当没有剩余元素可加时，我们想要加上 0。对于乘法，当没有剩余元素可乘时，我们想要乘上 1。

But here are two common patterns for trying to turn a list into a value. In both cases, turning a list of numbers into a number, doing some particular operation.

但这里有两个常见的模式，用于将列表转换为一个值。在这两种情况下，都是将数字列表转换为一个数字，执行某个特定的操作。

Into a number doing some particular operation once more, we've got a common pattern here. We ought to be able to capture it, and here is the generalization: a third standard operation on lists called reduce, sometimes also called accumulate. Notice its form: it has three arguments — a procedure op, an initial value init, and a list lst. Its structure is to return the initial value if the list is empty. Otherwise, it returns the value of applying the operator procedure to the first element of the list and whatever we get by reducing the remainder of the list.

将数字列表转换为一个数字，执行某个特定的操作。再次，我们这里有一个共同模式。我们应该能够捕获它，这里是推广：列表上的第三个标准操作称为 reduce（归约），有时也称为 accumulate（累积）。注意其形式：它有三个参数——一个过程 op，一个初始值 init，和一个列表 lst。其结构是：如果列表为空，则返回初始值；否则，返回将操作符过程应用于列表第一个元素和对列表剩余部分进行归约所得结果的值。

we get by reducing the remainder of the list notice the nice use of closure in the recursive structure of the lists and procedure to unwrap this into a simpler version of the same problem these common interfaces by the way are very powerful ways of dealing with sequences of data

对列表剩余部分进行归约所得结果。注意在列表的递归结构和过程中闭包的巧妙运用，它将问题分解为同一问题的更简单版本。顺便说一句，这些常见接口是处理数据序列的非常强大的方式。

they can be applied not only to sequences of numbers but to sequences of other structures and we'll see that many operations of such structures reduced to combinations of map filter and reduce to see how we can use these ideas let's go back to the idea of summation but now

它们不仅可以应用于数字序列，还可以应用于其他结构的序列，我们将看到许多此类结构的操作都归结为 map、filter 和 reduce 的组合。为了看看如何使用这些想法，让我们回到求和的概念，但现在考虑特定形式的和。

back to the idea of summation but now for sums of a particular form suppose we want to add up the values of a function at a regularly spaced set of intervals the mathematical expression captures this idea for M plus 1 regularly spaced samples each Delta apart starting at some point 8 well we can easily capture this idea by using our notions of operations over lists to generate a list of integers we can create a procedure generate interval that conses up a list given the set of integers between 0 and n which we can create using this

回到求和的概念，但现在考虑特定形式的和。假设我们想要计算一个函数在规则间隔的采样点上的值之和。数学表达式捕捉了这个想法：从某个点 a 开始，有 M+1 个规则间隔的样本，每个间隔为 Δ。我们可以通过使用列表操作的概念轻松捕捉这个想法：生成一个整数列表，我们可以创建一个过程 generate-interval，它根据 0 到 n 之间的整数集合构造一个列表，我们可以使用这个过程来创建。

n which we can create using this procedure we can map a procedure down that list computing the function f applied to sample points note how we multiply each term in the integer list by a constant Inc and then add in an offset start to reflect the general formula this creates a new list of samples of F applied to the set of points to add them up we simply fold them together

我们可以使用这个过程来创建整数列表，然后我们可以将过程映射到该列表上，计算函数 f 应用于采样点的值。注意我们如何将整数列表中的每一项乘以常数 inc，然后加上偏移量 start 以反映一般公式。这创建了一个新的样本列表，即 f 应用于这些点的值。要将它们加起来，我们只需将它们折叠在一起。

so we can see that we can combine our idea of higher-order procedures on numbers with higher-order procedures that operate over data structures before we carry on let's stop

因此，我们可以看到，我们可以将关于数字的高阶过程的想法与操作数据结构的高阶过程结合起来。在继续之前，让我们停下来强调一个重要点。

structures before we carry on let's stop to stress an important point here now that we have higher procedures we should ask what they're useful for and we want to stress that this isn't just a matter of making writing easier.

在继续之前，让我们停下来强调一个重要点。现在我们有了高阶过程，我们应该问它们有什么用处，我们要强调这不仅仅是使编写更容易的问题。

order it's really that they provide a tremendous increase in the expressive power available to us that means that we can have building blocks on which we build more complex ideas that are themselves fairly high levels of abstraction this allows us to very easily control complexity in big systems by suppressing unnecessary detail to

更重要的是，它们为我们提供了表达能力的巨大提升。这意味着我们可以拥有构建块，在此基础上构建更复杂的想法，这些想法本身是相当高层次的抽象。这使我们能够通过抑制不必要的细节来轻松控制大型系统中的复杂性。

by suppressing unnecessary detail to stress this idea, let's start with some. We've now captured that common pattern as a higher order procedure, and let's see what we can do by building on top of some as if it was just a primitive operation for us.

为了突出这一思想而省略不必要的细节，我们先从一些内容开始。我们现在已经将这一常见模式捕获为一个高阶过程，接下来看看如果把它当作一个基本操作来使用，我们能在此基础上做些什么。

So what can we do with the idea of summation? Well, remember from calculus you know how to deal with integration. Integration under a curve f is just given by taking a rough sum in particular's form, and let's remind you where that comes from.

那么，我们能利用求和这一概念做些什么呢？回想一下，在微积分中你们知道如何处理积分。曲线 f 下的积分正是通过取某种特定形式的粗略和来得到的，让我提醒你们这是怎么来的。

Given the curve F, we can break it up into little rectangular chunks, each of which...

给定曲线 F，我们可以将其分割成许多小矩形块，每一块……

into little rectangular chunks each of width DX where the top part of it is approximated by the value of the curve at that point. If we make the chunks small enough, we get a better and better approximation. We simply add up the area by taking the area of each of the rectangles and summing them. There's that key factor, and in fact, we can sum them by just summing the values of the heights and then multiplying the whole thing by the width DX.

分割成许多宽度为 DX 的小矩形块，其中每一块的顶部由该点处曲线的值近似。如果我们把块分得足够小，就能得到越来越好的近似。我们只需通过取每个矩形的面积并将它们相加来累加面积。这里有一个关键因素，实际上，我们可以通过将高度值求和，然后将整个结果乘以宽度 DX 来求和。

To capture the idea of integration, we just build on the idea of summation.

为了捕捉积分的概念，我们只需建立在求和概念的基础上。

idea of summation in particular we can reduce the integration to a simpler problem thus we simply sum F between a and B note the use of F is a parameter for the term to be added we use the number of terms in the summation or if you like the number of sample points to determine the increment Delta to add energy stage as well note that the inputs to sum are all of the expected type and some we know returns a number so we can complete the process by multiplying this number by the number Delta clearly as we increase in the number of terms in the summation we get

特别是，我们可以将积分简化为一个更简单的问题：我们只需在 a 和 B 之间对 F 求和。注意，F 作为要添加的项的参数，我们使用求和中的项数，或者如果你愿意，使用采样点的数量来确定每一步要加的增量 Delta。还要注意，sum 的输入都是预期类型，并且我们知道 sum 返回一个数字，因此我们可以通过将这个数字乘以 Delta 来完成这个过程。显然，随着我们增加求和中的项数，我们得到……

Delta clearly as we increase in the number of terms in the summation we get

显然，随着我们增加求和中的项数，我们得到……

number of terms in the summation we get a better approximation to the energy and once I've got the idea of integral again I have an abstraction I've captured a pattern I can use it as a primitive for example a standard way to compute the inverse tangent of a function is to take the integral of a particular form 1 over 1 plus x squared up to the point at which I want to evaluate that so now I can easily build a tan just using integral so note again the key point here we captured the notion of sum as a common pattern it was a higher-order

求和中的项数，我们得到对能量的更好近似，一旦我再次有了积分的概念，我就有了一个抽象，我捕获了一个模式，我可以将其用作原语。例如，计算一个函数的反正切的标准方法是取特定形式 1/(1+x^2) 的积分，直到我想要计算该值的点。所以现在我可以轻松地使用积分来构建 tan。再次注意关键点：我们将求和的概念捕获为一个常见模式，它是一个高阶过程，接受任意过程作为输入。在此基础上，我们可以轻松地生成其他类型的高阶过程，如积分，以及建立在积分之上的东西。通过抑制抽象之下的细节，我们能够专注于手头的问题。

common pattern it was a higher-order procedure that took in any arbitrary procedure as input. Building on top of that, we can easily then generate other kinds of higher-order procedures, integrals, and things that build on top of integrals. And by suppressing the detail below the abstraction, we're able to focus on the problem at hand.

常见模式，它是一个高阶过程，接受任意过程作为输入。在此基础上，我们可以轻松地生成其他类型的高阶过程，如积分，以及建立在积分之上的东西。通过抑制抽象之下的细节，我们能够专注于手头的问题。

Notice how we've generalized things. We've moved from procedures or functions that took in numbers and produce numbers, are computed things if you like, independent of the input number. And now we've moved up to more general methods that work.

注意我们是如何进行概括的。我们从接受数字并产生数字的过程或函数，即计算事物，独立于输入数字。现在我们上升到更一般的方法，这些方法独立于函数而工作。

more general methods that work independent of the function so that in our case of integral it said give us any function and we'll compute the integral of that function for you now let's turn to other ways of capturing common patterns and higher-order procedures

更一般的方法，独立于函数而工作，因此在我们的积分案例中，它说：给我们任何函数，我们将为你计算该函数的积分。现在让我们转向其他捕获常见模式和高阶过程的方法。

### 7. Fixed Points and Higher-Order Procedures / Fixed Point Procedure and the Golden Ratio / Square Root via Fixed Point and Oscillation Problem (不动点与高阶过程 / 不动点过程与黄金比例 / 通过不动点求平方根及其振荡问题)

let's go back to square root but think about it a different way one way to think about square root is to say the square root of x is defined by that value which is equal to X divided by that value if we think of this as a transformation or a mapping that takes values of Y into X over Y then what we

让我们回到平方根，但用一种不同的方式来思考。思考平方根的一种方式是：x 的平方根定义为等于 X 除以该值的那个值。如果我们把这看作一个变换或映射，将 Y 的值映射为 X/Y，那么我们……

Values of Y into X over Y then what we see is if we can find a guess for why that happens to be the square root of x, then f of that value equals that value, and such a Y is called a fixed point of that. So this suggests a different way of trying to capture square roots, namely try and find a good guess such that applying f of this particular form to that value ends up giving us back exactly the same value, or in other words, try and see if we can find fixed points.

将 Y 的值映射为 X/Y，那么我们看到的是：如果我们能找到一个猜测 Y，恰好是 x 的平方根，那么 f 的那个值等于那个值，这样的 Y 被称为该映射的不动点。这提示了一种不同的尝试捕获平方根的方式，即尝试找到一个好的猜测，使得将这种特定形式的 f 应用于该值后，最终返回给我们完全相同的值，换句话说，尝试看看我们是否能找到不动点。

Here's a good way to find fixed points: start with some guess, call it x1.

这里有一个寻找不动点的好方法：从一个猜测开始，称之为 x1。

points start with some guests call it x1 to get the next guess which we'll call X. We'll look at F of x1, that is apply the function to x1. If that's close in fact to x1, then we know we have a fixed point, we can stop. Otherwise, we'll let X to be our new guess and we'll compute F of x2.

不动点，从一个猜测开始，称之为 x1，得到下一个猜测，我们称之为 X。我们将看 F(x1)，即将函数应用于 x1。如果它实际上接近 x1，那么我们知道我们有了一个不动点，可以停止。否则，我们将让 X 作为我们的新猜测，并计算 F(x2)。

In other words, we'll keep computing F of the previous answer until we get close enough. That actually has a familiar ring to it - we looked at something very similar way back. Can we look at the first square root? But let's see how we could capture this idea now in a fixed point, and here's the code.

换句话说，我们将不断计算 F 对前一个答案的结果，直到我们得到足够接近的值。这实际上听起来很熟悉——我们很早以前看过非常类似的东西。我们能否看看第一个平方根？但让我们看看现在如何将这个想法捕获为一个不动点，这是代码。

In a fixed point, and here's the code that'll do it. I need some way of testing where the two values are close enough. And this is a very arbitrary and not particularly good one.

在一个不动点中，这是实现它的代码。我需要某种方法来测试两个值是否足够接近。这是一个非常随意且不是特别好的方法。

What I'm more interested in is the procedure to compute fixed point. Notice what it takes in: it takes in two parameters, a function f that better be a procedure, and a guess which better be a number, given what we're using it for. Inside a fixed point, we have a helper procedure called try.

我更感兴趣的是计算不动点的过程。注意它接受什么：它接受两个参数，一个函数 f，最好是一个过程，以及一个猜测，最好是一个数字，鉴于我们使用它的目的。在 fixed point 内部，我们有一个辅助过程叫做 try。

And it does what it looks at F of G and G, and decides if they're close enough. If they are, we just...

它做的是查看 F(G) 和 G，并判断它们是否足够接近。如果足够接近，我们就……

they're close enough if they are we just return the value otherwise we take the new guess and apply try to notice F is a procedure therefore fixed point and tri are higher-order procedures now that I've got the idea of fixed point I've captured it in the procedure I can use it for example I could apply fixed point to this particular procedure which Maps values of X into 1 plus 1 over X and I'll give it a starting point of 1 gives you back a particular value that doesn't look all that interesting until we realize we're finding the fixed point.

它们足够接近，如果足够接近，我们就返回该值；否则，我们取新猜测并应用 try。注意 F 是一个过程，因此 fixed point 和 try 是高阶过程。现在我已经有了不动点的概念，并将其捕获在过程中，我可以使用它。例如，我可以将 fixed point 应用于这个特定的过程，它将 X 的值映射为 1 + 1/X，并给它一个起始点 1，这会返回一个特定的值，看起来并不那么有趣，直到我们意识到我们正在寻找不动点。

realize we're finding the fixed point where X equals 1 plus 1 over X and that you may recognize it simply being the golden ratio.

意识到我们正在寻找不动点，其中 X 等于 1 + 1/X，你可能认出这其实就是黄金比例。

so clearly fixed point can be used in a lot of different ways let's go back to where we started from to build square root we simply say find the fixed point of the procedure that map's values of Y into X over Y where X is the parameter that we specify the square root and again we give it a starting point of 1 notice once more the type of fixed point it takes in a procedure that map's numbers to numbers and a number

所以很明显，不动点可以用在很多不同的地方。让我们回到最初构建平方根的地方：我们只需说，找到那个将Y映射为X除以Y的过程的不动点，其中X是我们指定的参数，即平方根。我们再次给它一个起始点1。再次注意不动点的类型：它接受一个将数映射到数的过程和一个数，

numbers to numbers and a number and will give us back out a number also notice how crisply we've captured the idea here in one clean trunk we have the idea of what we're trying to do to compute the fixed point

将数映射到数的过程和一个数，然后返回一个数。还要注意，我们在这里多么清晰地捕捉了这个想法：在一个简洁的表述中，我们有了我们想要做的事情的概念，即计算不动点。

so if we go ahead and run this little algorithm we unfortunately discover that it doesn't quite do what we'd like

所以如果我们继续运行这个小算法，不幸的是我们会发现它并不完全符合我们的期望。

if we pass in 1 it computes the value 2 is the next guess if we pass two in it computes the value of 1 is the next guess and it keeps oscillating back and forth without ever converging to the answer we want so I have a problem now

如果我们传入1，它计算出下一个猜测值为2；如果我们传入2，它计算出下一个猜测值为1，然后它不断来回振荡，永远不会收敛到我们想要的答案。所以我现在遇到了一个问题。

### 8. Average Damping to Control Oscillation / Comparison with Heron's Algorithm and Cube Root (平均阻尼控制振荡 / 与希罗算法和立方根的比较)

answer we want so I have a problem now it's not a problem because I made a coding error fact my codes correct the problem is actually in the conceptualization of the topic or the problem I've got an undamped oscillation you may remember those things from 801 when you've seen them before how do I control such a situation well I want to damp out the oscillation and one rice way of doing it is to take the value of the function on computing and the value of the argument at that point and take their average that will tend to smooth out or dampen down the oscillation

我们想要的答案，所以我现在遇到了一个问题。这不是因为我犯了编码错误；事实上，我的代码是正确的。问题实际上出在对主题或问题的概念化上：我遇到了无阻尼振荡。你可能还记得在801课程中见过这些东西。我如何控制这种情况呢？嗯，我想抑制振荡，一种很好的方法是取函数计算的值和该点的自变量值的平均值。这将倾向于平滑或抑制我在这个近似中看到的振荡。

out or dampen down the oscillation that I'm seeing in this approximation and having isolated out the different components I can now easily write a function that dampens using an average notice the form though

抑制我在这个近似中看到的振荡。在隔离出不同的组成部分之后，我现在可以轻松地编写一个使用平均值进行阻尼的函数。但请注意其形式。

average damp takes in a procedure and what does it give back it gives back another lambda or a procedure that computes for any X the average of X and that procedure F applied to X so here we have another kind of higher-order

average damp接受一个过程，它返回什么呢？它返回另一个lambda或过程，该过程计算任意X的X与过程F应用于X的结果的平均值。所以这里我们有另一种高阶过程，它接受过程并返回过程作为输出。让我们检查一下：这是它的类型。

procedure that takes in procedures and also returns procedures as an output let's just check it here's the type of

接受过程并返回过程作为输出的高阶过程。让我们检查一下：这是它的类型。

let's just check it here's the type of the procedure its input is a function number the number its output is the result of that lambda which is another function which also takes numbers two numbers notice there's a hidden lambda inside the define don't get confused by the fact that you see an extra lambda here the lambda that's exposed is the one that's the actual return value and creates a separate procedure this undoubtedly looks a little odd so let's check it out carefully here's our substitution model I'm going to call average damp on square starting with a

让我们在这里检查一下，这是该过程的类型：它的输入是一个函数，一个数字，其输出是该 lambda 的结果，即另一个函数，它也接受数字，两个数字。注意在 define 内部有一个隐藏的 lambda，不要因为看到这里有一个额外的 lambda 而感到困惑；暴露出来的 lambda 是实际返回值的那个，并创建一个单独的过程。这无疑看起来有点奇怪，所以让我们仔细检查一下。这是我们的替换模型，我将对 square 调用 average-damp，从 a 开始

average damp on square starting with a guess of five. Notice the form: average damp itself will return a procedure. By my type, and therefore the value of that first sub-expression, even though there's a pair of open parens there that look strange, the value of that first sub-expression will itself be a procedure which I can then apply to five.

对 square 调用 average-damp，从猜测值 5 开始。注意形式：average-damp 本身将返回一个过程。根据我的类型，因此第一个子表达式的值，即使那里有一对看起来奇怪的括号，第一个子表达式的值本身将是一个过程，然后我可以将其应用于 5。

In fact, when I evaluate that first sub-expression, I get back the body of average damp, which is a lambda of X: average of X and square of X. By my substitution model, I then take the five and substitute it into the body of that.

事实上，当我求值第一个子表达式时，我得到 average-damp 的主体，即 (lambda (x) (average x (square x)))。根据我的替换模型，我然后将 5 代入该主体中。

and substitute it into the body of that lambda wherever I see X which reduces to evaluating average of ten and square of ten. Of course now I can get square of ten, square itself as a procedure applied to ten, which will give me at one hundred, and then average as you might expect simply takes ten and 100, adds them up, divides by 2, and I get back fifty five.

并将其代入该 lambda 的主体中，无论我在哪里看到 X，这都简化为求值 (average 10 (square 10))。当然，现在我可以得到 (square 10)，square 本身作为一个过程应用于 10，这将给我 100，然后 average 正如你所期望的那样，简单地取 10 和 100，将它们相加，除以 2，我得到 55。

Key thing to notice is by our substitution model this does the right thing, and moreover I know that average damp has to be something that returns a procedure because of the formula which

要注意的关键点是，根据我们的替换模型，这做了正确的事情，而且我知道 average-damp 必须返回一个过程，因为公式

procedure because of the formula which is used here with this idea in hand I can go back now and fix up my square root and here it is square root very nicely is going to apply fixed point to an average damp of a procedure and again notice the form of what's getting passed around we start off without entered lambda average damp takes in a procedure gives us back a procedure by its type definition which is exactly the input we need to have to fix point more importantly notice how we've cleanly separated out the ideas here we're computing a fixed point and that

过程，因为这里使用的公式。有了这个想法，我现在可以回去修复我的平方根，这里是平方根，非常漂亮地将 fixed-point 应用于一个过程的 average-damp，再次注意传递的内容的形式：我们从一个未输入的 lambda 开始，average-damp 接受一个过程，根据其类型定义给我们返回一个过程，这正是我们需要输入给 fixed-point 的。更重要的是，注意我们如何在这里清晰地分离了思想：我们正在计算一个不动点，并且

We're computing a fixed point, and that fixed point is of a particular function, which is itself a higher-order procedure that damps down another function. You ought to take this and compare it to the example of Heron's algorithm that we did a few lectures ago, which is in the textbook. This is exactly the same process.

我们正在计算一个不动点，该不动点是某个特定函数的不动点，该函数本身是一个高阶过程，它抑制另一个函数。你应该将此与我们几讲前做的 Heron 算法示例进行比较，该示例在教科书中。这是完全相同的过程。

But notice that the version in the text has all these ideas intertwined with the code, whereas here we very cleanly isolated out the key concepts. And why is that relevant? Well, now imagine instead of computing square root, I want to...关于计算平方根，我想……

但请注意，文本中的版本将这些思想与代码交织在一起，而在这里我们非常清晰地隔离了关键概念。为什么这很重要？好吧，现在想象一下，不是计算平方根，我想……关于计算平方根，我想……

of computing square root I want to compute cube root in the original version of Heron I'd have to go back and change a whole bunch of pieces in the code and it would be tricky to figure out exactly which pieces to do here it's easy to compute the cube root of something I just have to decide what function do I need to take this the fixed point of a next case it's the function that map's values of Y into X over square of Y if you think about it that means that when Y is cubed it's going to equal x which is exactly what we want notice in the code it's easy

计算平方根，我想计算立方根。在 Heron 的原始版本中，我必须回去更改代码中的一大堆部分，并且很难确定到底要更改哪些部分。在这里，计算某物的立方根很容易，我只需要决定我需要将哪个函数作为不动点：在这种情况下，它是将 Y 的值映射到 X 除以 Y 的平方的函数。如果你仔细想想，这意味着当 Y 立方时，它将等于 X，这正是我们想要的。注意在代码中，很容易

going to equal x which is exactly what we want. Notice in the code, it's easy to...

将等于 X，这正是我们想要的。注意在代码中，很容易……

we want notice in the code it's easy to isolate the change and make it so we've isolate the change and make it so we've isolate the change and make it so we've introduced some rather interesting concepts in this lecture especially the idea of higher-order procedures our goal was to show how we could capture common patterns and then reuse them and those patterns might be numeric patterns but they might also be computational patterns and by capturing and suppressing them it allowed us to build clean crisp code that nicely isolated the main ideas and let us focus on let's rerun this one more time just to see how

我们想注意在代码中很容易隔离变化并使其如此，我们已经在本次讲座中引入了一些相当有趣的概念，尤其是高阶过程的思想。我们的目标是展示我们如何捕获常见模式然后重用它们，这些模式可能是数值模式，但也可能是计算模式。通过捕获和抑制它们，它使我们能够构建干净、简洁的代码，很好地隔离主要思想，并让我们专注于让我们再运行一次，只是为了看看如何

### 9. Further Examples and Type Reasoning (更多示例与类型推理)

rerun this one more time just to see how

再运行一次，只是为了看看如何

rerun this one more time just to see how else we can use higher-order procedures. so to remind you a higher-order procedure takes a procedure as argument and may or may not return one as a value as well.

再运行一次，只是为了看看我们还能如何使用高阶过程。所以提醒你，高阶过程将过程作为参数，并且可能也可能不返回一个作为值。

here is a particular example of a higher-order procedure we define hop 1 to be a procedure of F and X that adds 2 to the value of applying F 2x plus 1 we can see by the body that F must be a procedure given where it appears in the expression.

这里有一个高阶过程的特定例子：我们定义 hop 1 为 F 和 X 的过程，它将 2 加到应用 F 2x 加 1 的值上。从函数体可以看出，F 必须是一个过程，因为它出现在表达式中。

if we run through a little substitution model we'll see that it does the right thing if we apply hop one two Square and three by our rules we

如果我们运行一个小的替换模型，我们会看到如果我们应用 hop one two Square 和 three，根据我们的规则，它会做正确的事情。

Two square and three, by our rules, we substitute square for F and 3 for X in the body of hop one. This reduces to a plus two of square of + 3 + 1, and then the rest of the rules just hold as before. This means that we're simply using the rules we'd expect to see.

Two square 和 three，根据我们的规则，我们在 hop one 的函数体中将 square 替换为 F，将 3 替换为 X。这简化为 a 加 2 的 square 加 3 加 1，然后其余的规则照常成立。这意味着我们只是在使用我们期望看到的规则。

And of course the point is hop can be used in arbitrary procedures; we can give it something that squares and do exactly the same thing. So what's the type characterization of hop 1? Well, here's the definition again, and we can look at this and easily reason it out. First of all, what does X have to be?

当然，关键是 hop 可以用于任意过程；我们可以给它一个平方的东西，并做完全相同的事情。那么 hop 1 的类型特征是什么？嗯，这是定义，我们可以看看这个并轻松推理出来。首先，X 必须是什么？

first of all what does X have to be well since A+ is going to be applied to it X better be a number and what does F have to be well we can see that it's used in a place where we expect a procedure we know that it's going to get a number as input in and we know because it's going to be used in result to be added to 2 that it has to produce a number as output and what is the whole thing produce well it just produces a number so there's our type characterization and just to repeat that we see the first argument must be a procedure that takes

首先，X 必须是什么？嗯，因为 A+ 将应用于它，X 最好是一个数字。F 必须是什么？嗯，我们可以看到它被用在我们期望一个过程的地方，我们知道它将得到一个数字作为输入，并且因为它将被用于结果中加上 2，所以它必须产生一个数字作为输出。整个东西产生什么？嗯，它只是产生一个数字，所以这就是我们的类型特征。为了重复这一点，我们看到第一个参数必须是一个过程，它接受

argument must be a procedure that takes

参数必须是一个过程，它接受

argument must be a procedure that takes numbers two numbers in order to make the entire expression make sense second. argument must be a number and the result has to be a number again because of the form of the body and this nicely demonstrates several points.

参数必须是一个过程，它接受数字到数字，以使整个表达式有意义。第二个参数必须是一个数字，结果也必须是一个数字，因为函数体的形式，这很好地展示了几个要点。

one is we now see why reasoning about types is valuable if we have a new procedure we can use the idea of types to decide what kinds of input and output characteristics we expect to see.

一是我们现在看到为什么关于类型的推理是有价值的。如果我们有一个新过程，我们可以使用类型的概念来决定我们期望看到什么样的输入和输出特征。

the second thing we see is again this idea of generalizing for any function now we can compute this higher order method.

我们看到的第二件事是，再次，这种为任何函数泛化的想法，现在我们可以计算这种高阶方法。

### 10. Compose: A Higher-Order Procedure / Generality and Type Matching in Compose / Type Variables for Higher-Order Procedures / Summary: Types and Higher-Order Procedures (组合：一个高阶过程 / 组合中的泛化与类型匹配 / 高阶过程的类型变量 / 总结：类型与高阶过程)

can compute this higher order method. We've captured that pattern and we're able to use it as if it were a primitive.

可以计算这种高阶方法。我们已经捕获了那个模式，并且能够像使用原语一样使用它。

Here's yet another variation on the idea of higher-order procedure. This is a little procedure called compose, and notice what it does. It takes in as input two procedures and a number. It applies the second procedure to the number and then applies the first procedure to that result.

这是关于高阶过程思想的另一个变体。这是一个叫做 compose 的小过程，注意它做什么。它接受两个过程和一个数字作为输入。它将第二个过程应用于数字，然后将第一个过程应用于那个结果。

It's called compose because this is the mathematical operation that we're dealing with. And if we look at a little example, we can see that we can call

它被称为 compose，因为这是我们正在处理的数学运算。如果我们看一个小例子，我们可以看到我们可以调用

dealing with and if we look at a little example we can see that we can call

处理，如果我们看一个小例子，我们可以看到我们可以调用

example we can see that we can call compose on say square and double where they're both procedures that do the obvious things. Substitution says we put square in for F, double in for G, 3 and for X into the body of that procedure, and then we evaluate. We have to get the value of the sub expression, so we first have to get the value of double, which is some procedure which ends up multiplying 3 by 2. That result gets substituted into the body for square, and eventually we get out 36. So we can apply procedures to procedures as part of our process now.

例子，我们可以看到我们可以调用 compose 在比如 square 和 double 上，它们都是做明显事情的过程。替换说我们将 square 放入 F，double 放入 G，3 放入 X 到那个过程的函数体中，然后我们求值。我们必须得到子表达式的值，所以我们首先必须得到 double 的值，它是某个过程，最终将 3 乘以 2。那个结果被替换到 square 的函数体中，最终我们得到 36。所以我们现在可以将过程应用于过程作为我们过程的一部分。

procedures as part of our process now. What's the type of compose? Is it something that takes in two procedures and a number, and gives out a number, where the procedures themselves map numbers to numbers? From a little example, that looks like that's right. But in fact, we're wrong. There's nothing in compose that requires a number. If we look at the body of compose, nowhere is there anything that says a result must be a number.

过程作为我们过程的一部分。compose 的类型是什么？它是接受两个过程和一个数字，并给出一个数字，其中过程本身将数字映射到数字吗？从一个小例子来看，那看起来是对的。但事实上，我们错了。compose 中没有任何东西要求数字。如果我们看 compose 的函数体，没有任何地方说结果必须是数字。

That's different from the reasoning we did on the previous procedures. So compose is much more general. In fact, compose would work on...

这与我们在之前的过程上做的推理不同。所以 compose 更加通用。事实上，compose 可以用于……

General in fact composed would work on other types as well. Here's a different example: I'm going to take the compose of this first procedure on to the second procedure on to the value five. And if I run it, in fact I get out the symbol or the string rather. By I can use my types to help me reason out why this should do the right thing.

通用，事实上 compose 也可以用于其他类型。这里有一个不同的例子：我将取第一个过程与第二个过程组合，应用于值五。如果我运行它，实际上我得到符号或字符串。通过我可以使用我的类型来帮助我推理为什么这应该做正确的事情。

What happens when I use compose? I'm going to apply the second procedure to the third argument. Notice the third argument's a number, and the second procedure takes numbers into boolean. So the value that will be

当我使用 compose 时会发生什么？我将第二个过程应用于第三个参数。注意第三个参数是一个数字，第二个过程将数字带入布尔值。所以值将是

boolean so the value that will be returned will be a boolean that value then gets substituted in for P in the body of the first procedure and the if expects exactly that that / T 16 takes a boolean in as input and gives out a string as output and that's why I'm fact get a string out is my final value so compose is more general as long as the types match up appropriately we ought to be able to do the right thing and what does it mean for types to match up it's not the case that compose will work on anything and here are a couple of examples where in fact it doesn't in the

布尔值，因此返回的值将是一个布尔值，该值随后被替换到第一个过程体中的 P 位置，而 if 期望的正是那个 / T 16 接收一个布尔值作为输入，并输出一个字符串作为输出，这就是为什么我实际上得到的是一个字符串作为最终值，所以 compose 更加通用，只要类型匹配得当，我们就应该能够做正确的事情，而类型匹配意味着什么？并不是说 compose 对任何东西都有效，这里有几个例子，实际上它并不有效，在

examples where in fact it doesn't in the first case we're giving the wrong number of arguments to a procedure and in the second case we're giving the wrong type of argument to a procedure so we still need to use our types to reason through how in fact compose will work

实际上它并不有效的例子中，第一种情况我们给一个过程提供了错误数量的参数，第二种情况我们给一个过程提供了错误类型的参数，所以我们仍然需要使用我们的类型来推理 compose 实际上将如何工作。

so finally we can reason about the actual type of this higher order procedure compose and we'll do that using type variables that is rather than that particular known type we'll use a variable to hold the fact that it could be any of several kinds of types

所以最终我们可以推理这个高阶过程 compose 的实际类型，我们将使用类型变量来做到这一点，也就是说，不是用特定的已知类型，而是用一个变量来持有它可能是几种类型中的任何一种这一事实。

kinds of types and in that case we say compose has the type of a procedure A to B and a procedure C to a and another type C all taken by that procedure into type B. The meaning of the type variables any place where a given type variable appears must match when you fill in the actual operand types, and so you can see why the constraints are here.

类型种类，在这种情况下我们说 compose 具有这样的类型：一个从 A 到 B 的过程和一个从 C 到 A 的过程，以及另一个类型 C，所有这些都被该过程带入类型 B。类型变量的含义是，任何出现给定类型变量的地方，当你填入实际的操作数类型时，它们必须匹配，所以你可以看到为什么这里有这些约束。

We know F and G must be functions of one argument. We also know that the argument type of G has to match the type of X, that says in this case C as the third operand type has to be the same as the procedure in.

我们知道 F 和 G 必须是单参数函数。我们还知道 G 的参数类型必须与 X 的类型匹配，也就是说在这种情况下，第三个操作数类型 C 必须与第二个位置的过程输入相同。

has to be the same as the procedure in the second spot or rather the argument to the procedure in the second spot, similar to the argument type of F, matches the result type of G which is why G has to take something in the type A, which has to be the type of the input to the procedure F, and then finally the result of the whole thing has to be the result type of procedure F, so we see that the bees have to match up.

必须与第二个位置的过程输入相同，或者说第二个位置的过程的参数，类似地，F 的参数类型匹配 G 的结果类型，这就是为什么 G 必须接收类型 A 的东西，而 A 必须是过程 F 的输入类型，然后最终整个事情的结果必须是过程 F 的结果类型，所以我们看到 B 必须匹配。

So in summary what do we have? We've taken the idea of capturing common patterns and procedures and we've generalized it.

那么总结一下我们有什么？我们采纳了在过程中捕获常见模式的想法，并将其推广了。

procedures and we've generalized it. We've generalized it from simply capturing common numeric patterns into capturing patterns of computations themselves. And that's led us to the notion of higher-order procedures—procedures that capture general operations of mapping procedures to values, or capturing patterns over procedures, or maybe even returning a procedure as the output itself. In order to be able to reason about these kinds of higher-order procedures, we've used types. They tell us both the number and type of argument a procedure takes.

过程并对其进行了推广。我们将其从仅仅捕获常见的数值模式推广到捕获计算本身的模式。这引导我们得出了高阶过程的概念——这些过程捕获了将过程映射到值的通用操作，或者捕获了过程上的模式，甚至可能返回一个过程作为输出本身。为了能够推理这类高阶过程，我们使用了类型。它们告诉我们过程接受的参数数量和类型。

type of argument a procedure takes the type of operand that it produces as output and we've used that to be able to reason about how to put together higher-order procedures throughout the term we're going to come back to this idea of using types and using higher-order procedures to capture

过程接受的参数类型，它产生的操作数类型作为输出，我们用它来推理如何组合高阶过程，在整个学期中，我们将回到使用类型和高阶过程来捕获这一想法。