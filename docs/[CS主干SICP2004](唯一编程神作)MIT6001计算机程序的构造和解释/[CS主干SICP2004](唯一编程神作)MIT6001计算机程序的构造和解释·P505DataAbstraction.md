# Video Transcript (视频文稿)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=5)

## Summary (摘要)

- The lecture introduces the concept of data abstractions, demonstrating how compound data structures can be built and manipulated while hiding implementation details.
- Procedural abstraction is reviewed, emphasizing the use of contracts and black-box abstractions to isolate process details from usage.
- The implementation of rational numbers serves as a central example, showing how to construct, select, and operate on abstract data types using pairs and lists.
- The lecture illustrates two alternative representations for rationals—normalizing at construction time versus at selection time—and highlights how abstraction barriers allow such changes without affecting high-level operations.
- Violating data abstraction by directly using implementation details (like car/cdr) leads to maintenance difficulties and potential errors, reinforcing the importance of clean boundaries.

- 本讲座介绍了数据抽象的概念，演示了如何构建和操作复合数据结构，同时隐藏实现细节。
回顾了过程抽象，强调使用契约和黑盒抽象来将过程细节与使用隔离。
- 有理数的实现作为核心示例，展示了如何使用序对和列表构造、选择以及操作抽象数据类型。
- 讲座说明了有理数的两种替代表示——在构造时归一化与在选择时归一化——并强调了抽象屏障如何允许这种变化而不影响高层操作。
- 违反数据抽象，直接使用实现细节（如car/cdr），会导致维护困难和潜在错误，从而强化了清晰边界的重要性。

## Outline (大纲)

1. Introduction and procedural abstraction review / Heron's algorithm and procedural abstraction in practice / Block structure and encapsulating internal procedures
2. Hierarchy of language elements: primitives, combination, abstraction
3. Introduction to compound data and the need for gluing / Cons as the basic glue and examples with points and segments
4. Formalizing the pair abstraction: constructor, selectors, predicate / Generalizing to operations on data groups
5. Lists as a primitive for gluing arbitrary numbers of elements
6. List operations: creation, traversal, and recursion
7. Abstraction barriers and contracts for data structures
8. The abstraction barrier and rational numbers as an example
9. Implementations of rationals and building operations on them
10. Alternative representations: reducing by computation in selectors or at construction / Consequences of violating the data abstraction and overall principle

1. 引言与过程抽象回顾 / 希罗算法与过程抽象的实践 / 块结构与内部过程的封装
2. 语言元素的层次：基本元素、组合、抽象
3. 复合数据与粘合需求的引入 / Cons作为基本粘合剂，以及点和线段的示例
4. 形式化序对抽象：构造器、选择器、谓词 / 推广到数据组的操作
5. 列表作为粘合任意数量元素的基本原语
6. 列表操作：创建、遍历和递归
7. 数据结构的抽象屏障与契约
8. 抽象屏障与有理数示例
9. 有理数的实现及其上的操作构建
10. 替代表示：在选择器中计算约简或在构造时约简 / 违反数据抽象的后果与总体原则

## Transcript (文稿)

### 1. Introduction and procedural abstraction review / Heron's algorithm and procedural abstraction in practice / Block structure and encapsulating internal procedures (引言与过程抽象回顾 / 希罗算法与过程抽象的实践 / 块结构与内部过程的封装)

In this lecture, we're going to continue with the theme of building abstractions. Thus far, we focused entirely on procedural abstractions, the idea of capturing a common part of a computation within a procedure and isolating the details of that computation from the use of the concept within some other computation.

在本讲中，我们将继续构建抽象这一主题。到目前为止，我们完全专注于过程抽象，即把计算中的公共部分捕获到过程中，并将该计算的细节与在其他计算中使用该概念隔离开来。

Today, we're going to turn to a complementary issue, namely how to group together pieces of information or data into abstract structures. We will see that the same general theme holds: we can isolate the details of how the data

今天，我们将转向一个互补的问题，即如何将信息或数据片段组合成抽象结构。我们将看到同样的主题依然成立：我们可以将数据如何粘合的细节

We can isolate the details of how the data are glued together from the use of the aggregate data structure as a primitive element in some computation. We will also see that the procedures we use to manipulate the elements of a data structure often have an inherent structure that mimics the data structure. And we will use this idea to help us design or add abstractions and their associated procedures.

我们可以将数据如何粘合的细节与将聚合数据结构作为某个计算中的基本元素来使用隔离开来。我们还将看到，我们用来操作数据结构元素的过程往往具有一种内在结构，这种结构模仿了数据结构本身。我们将利用这一思想来帮助设计或添加抽象及其相关过程。

Let's review what we've been looking at so far in the course, in particular the idea of using procedural abstraction to capture ideas. The game here was to take a common

让我们回顾一下到目前为止我们在课程中所看到的内容，特别是使用过程抽象来捕获思想的想法。这里的游戏是取一个共同的

The game here was to take a common pattern of computation, capture that by formalizing it with a set of parameters that capture the parts that vary, and putting that inside a procedure so that that whole process becomes the body of a new procedure.

这里的游戏是取一个共同的计算模式，通过用一组参数将其形式化来捕获变化的部件，并将其放入过程中，从而使整个过程成为新过程的主体。

Once we have that procedure, we give it a name so that we can refer to it, and then we can use that procedure as if it's a primitive, just using its name and hiding the implementation details from the user who simply wants to use the method and not know what's inside of it.

一旦我们有了这个过程，我们给它一个名字以便引用，然后我们就可以像使用基本元素一样使用这个过程，只需使用其名称，并将实现细节对用户隐藏，用户只想使用该方法而不想知道其内部内容。

can treat the procedure as if it's a kind of black box we need to provide it with inputs of a particular type we know by the contract associated with the procedure that if we do probably apply appropriate inputs to it we'll get out an output of a particular type that satisfies the contract of what the procedure is computing and by giving the whole procedure a name we create this blackbox abstraction in which we use the procedure without knowing any of the details inside or in particular the details of how the contract is enforced

我们可以将过程视为一种黑盒，我们需要向其提供特定类型的输入，通过与该过程相关联的契约我们知道，如果我们可能适当地应用输入，我们将得到特定类型的输出，该输出满足过程所计算的契约。通过给整个过程一个名称，我们创建了这个黑盒抽象，在其中我们使用过程而不知道任何内部细节，特别是契约如何执行的细节。

details of how the contract is enforced that maps inputs to outputs is buried within the procedure and is not of any interest to the user who simply wants to make sure he can use inputs to get to outputs of the appropriate type so let's use this idea to look at a more interesting algorithm than the earlier ones we've examined here again is Heron of Alexandria's algorithm for computing good approximations to the square root of a positive number read the steps carefully as we're about to implement them now let's use the tools we've seen so far to implement

契约如何执行的细节，即将输入映射到输出的细节，被埋藏在过程内部，对用户来说并不感兴趣，用户只想确保他可以使用输入得到适当类型的输出。因此，让我们利用这个思想来研究一个比我们之前检查过的算法更有趣的算法。这里再次是亚历山大的希罗算法，用于计算正数平方根的近似值。仔细阅读步骤，因为我们即将实现它们。现在让我们使用到目前为止所见过的工具来实现

tools we've seen so far to implement this method notice how the first procedure uses the ideas wishful thinking and recursive procedures to capture the basic element of herons method tri is a procedure that takes a current guess and the X and captures the top-level idea of the method it checks to see if the guess is sufficient if it is it simply returns the value of that guess if it is not then it tries again with a new guess note how we were using wishful thinking to reduce the problem to another version of the same problem and to abstract out

到目前为止所见过的工具来实现这个方法。注意第一个过程如何使用愿望思维和递归过程来捕获希罗方法的基本元素。try是一个过程，它接受当前猜测和X，并捕获方法的顶层思想。它检查猜测是否足够，如果足够，则直接返回该猜测的值；如果不够，则用新猜测再次尝试。注意我们如何使用愿望思维将问题简化为同一问题的另一个版本，并抽象出

Of the same problem and to abstract out the idea of both getting a new guess and checking for how good the guess is. These are procedures we can subsequently write, for example, as shown.

同一问题的另一个版本，并抽象出获取新猜测和检查猜测好坏的思想。这些是我们随后可以编写的过程，例如如下所示。

Finally, notice how the recursive call to try will use a different argument for guess, since we will evaluate the expression before substituting into the body. Also notice the recursive structure of try and the use of the special form if to control the evolution of this procedure.

最后，注意对try的递归调用将使用不同的猜测参数，因为我们将在替换到主体之前评估表达式。还要注意try的递归结构以及使用特殊形式if来控制此过程的演化。

The method for improved simply incorporates the ideas from the algorithm and game with a procedure.

improved方法只是将算法和游戏中的思想合并到一个过程中。

algorithm a game with a procedure abstraction to separate out the idea of averaging from the procedure for improving the guess and finally notice how we can build a square root procedure on top of the procedure for try if we think of each of these procedures as its own blackbox abstraction then we can visualize the universe containing these procedures as shown each procedure exists with its own contract but each is accessible to the user simply by referring to it by name well this sounds fine in principle there's a problem with

算法是一个带有过程抽象的游戏，用以将平均的思想与改进猜测的过程分离开来，最终我们注意到，如果我们将这些过程中的每一个都视为其自身的黑箱抽象，那么我们就可以构建一个在尝试过程之上的平方根过程。这样，我们可以将包含这些过程的宇宙可视化，如图所示：每个过程都有其自身的契约，但用户只需通过名称引用即可访问。这个观点在原则上听起来不错，但有一个问题。

Fine in principle there's a problem with this viewpoint. Some of these procedures are general methods such as average and square root and should be accessible to the user who might utilize them elsewhere. Some of them however such as try or good enough are really specific to the computation for square roots.

原则上不错，但这个观点有一个问题。其中一些过程是通用方法，如 average 和 square root，它们应该对用户开放，用户可能在别处使用它们。然而，其中一些过程，如 try 或 good enough，实际上是专门用于平方根计算的。

Ideally we would like to capture those procedures in a way such that they can only be used by square root and not by other methods. Abstractly this is what we'd like to do: we would like to move the abstractions for the special-purpose procedures.

理想情况下，我们希望以某种方式封装这些过程，使它们只能被平方根过程使用，而不能被其他方法使用。抽象地说，这就是我们想要做的：我们想要移动专用过程的抽象。

For the special-purpose procedures inside of the abstraction for squirt, so that only it can use them while leaving more generally useful procedures available to the user in this way, these internal procedures should become part of the implementation details for squirt but be invisible to outside users. Here's how to do this.

对于专用过程，我们将它们移动到 squirt 抽象的内部，以便只有它能使用它们，而将更通用的过程保留给用户使用。这样，这些内部过程应该成为 squirt 实现细节的一部分，但对外部用户不可见。下面是如何做到这一点。

Note that the definition of squirt binds this name to a lambda; within the bounds of that lambda, we have moved the definitions for improved, good enough, and scored err, which is what we renamed try. By moving these

注意，squirt 的定义将这个名称绑定到一个 lambda；在该 lambda 的边界内，我们移动了 improved、good enough 和 scored err 的定义，后者是我们重命名的 try。通过移动这些

These teachers inside the body of the lambda become internal procedures, accessible only to other expressions within the body of that lambda. That is, if we try to refer to one of these names when interacting with the evaluator, we will get an unbound variable error. However, these names can be referenced by expressions that exist within the scope of this lambda.

这些过程被移动到 lambda 体内，成为内部过程，只能被该 lambda 体内的其他表达式访问。也就是说，如果我们试图在求值器中引用这些名称之一，将会得到一个未绑定变量错误。然而，这些名称可以被存在于该 lambda 作用域内的表达式引用。

The rules of evaluation say that when we apply squirt to some argument, the body of this lambda will be evaluated at that point. The internal procedures and the internal definitions.

求值规则规定，当我们对某个参数应用 squirt 时，该 lambda 体将在此时被求值。内部过程和内部定义。

procedures and the internal definitions are evaluated the final expression of the lambda is the expression squirty 21.0 which means when squared is applied to some argument by the substitution model it will reduce to evaluating this expression meaning it will begin the recursive evaluation of guesses for the square root.

过程和内部定义被求值，lambda 的最终表达式是表达式 squirty 21.0，这意味着当 squared 被应用于某个参数时，通过替换模型它将归约为求值这个表达式，这意味着它将开始对平方根的猜测进行递归求值。

in fact we can stress this by drawing a box around the boundary of the outermost lambda clearly that boundary exactly scopes the blackbox abstraction that I wanted this is called block structure and you can find out a

事实上，我们可以通过在最外层 lambda 的边界周围画一个框来强调这一点，显然该边界正好划定了我想要的这个黑箱抽象的范围。这被称为块结构，你可以通过阅读教科书了解更多。

block structure and you can find out a lot more about this by reading in the textbook. Schematically this means that squirt contains within it only those internal procedures that belong to it and behaves according to the contract expected by the user, without the user knowing how those procedures accomplish this contract.

块结构，你可以通过阅读教科书了解更多。从示意图上看，这意味着 squirt 内部只包含那些属于它的内部过程，并且按照用户期望的契约行为，而用户不知道这些过程如何实现该契约。

This provides another method for abstracting ideas and isolating them from other abstractions. So in summary, we've been using procedural abstraction as ways of isolating details of a process from its use and letting the designer decide both.

这提供了另一种抽象思想并将其与其他抽象隔离的方法。总之，我们一直在使用过程抽象作为将过程的细节与其使用隔离的方式，并让设计者决定两者。

use and letting the designer decide both which ideas to isolate and the order in which to do them in order to support general patterns of computation. One of the lessons you should be learning is that good planning is often involved in deciding how to collect the procedures together so that we make new things easier to do.

使用和让设计者决定隔离哪些思想以及以何种顺序进行，以支持一般的计算模式。你应该学到的一个教训是，良好的规划往往涉及决定如何将过程收集在一起，以便使新事物的创建更容易。

### 2. Hierarchy of language elements: primitives, combination, abstraction (语言元素的层次结构：原语、组合、抽象)

So let's take that idea of abstraction and build on it to set the stage for what we're about to do. It's useful to think about how the language elements can be grouped together into a hierarchy. At the atomic level we have a

那么让我们以抽象的思想为基础，为接下来的工作做好准备。将语言元素分组到一个层次结构中是有用的。在原子层面，我们有一个

hierarchy at the atomic level we have a

层次结构，在原子层面，我们有一个

Hierarchy at the atomic level we have a set of primitives and scheme these include primitive data objects numbers strings and booleans, and these include built-in or primitive procedures for numbers things like x plus equal greater than four, strings things like string equals substring, for boolean things like and or not.

层次结构，在原子层面，我们有一组原语，在 Scheme 中这些包括原始数据对象，如数字、字符串和布尔值，以及内置或原始过程，如数字的 x 加、等于、大于、字符串的 string 等于、子串，布尔值的与、或、非。

To put these primitive elements together into more interesting expressions we have a means of combination, that is a way of combining simpler into expressions that can themselves be treated as elements of other expressions. The most common one and the one that

为了将这些原语元素组合成更有趣的表达式，我们有了组合的手段，即一种将更简单的元素组合成表达式的方法，这些表达式本身可以作为其他表达式的元素。最常见的一种，也是我们在之前的讲座中见过的，是过程应用。

the most common one and the one that we've seen in the previous lectures is procedure application. This is the idea of creating a combination of sub expressions nested within a pair of parentheses. The value of the first sub expression is a procedure, an expression that captures the idea of applying that procedure to the values of the other expressions.

最常见的一种，也是我们在之前的讲座中见过的，是过程应用。这是创建嵌套在一对括号内的子表达式组合的思想。第一个子表达式的值是一个过程，一个表达式，它捕捉了将该过程应用于其他表达式的值的思想。

This means, as we have seen, that we can substitute the values of the arguments for the corresponding parameters in the body of the procedure and proceed with the evaluation. We know that these combinations can themselves

这意味着，正如我们所看到的，我们可以将参数的值替换到过程体中的相应参数，并继续求值。我们知道这些组合本身可以

That these combinations can themselves be included within other combinations, and the same rules of evaluation will recursively govern the computation.

这些组合本身可以包含在其他组合中，相同的求值规则将递归地控制计算。

Finally, our language has a means of abstraction, a way of capturing computational elements and treating them as if they were primitives, or set another way, a method of isolating the details of a computation from the use of a computation.

最后，我们的语言具有抽象的手段，一种捕获计算元素并将其视为原语的方法，或者换一种说法，一种将计算的细节与计算的使用隔离的方法。

Our first means of abstraction was defined, the ability to give a name to an element so that we could just use the name, thereby suppressing the details from the use.

我们的第一个抽象手段是定义，即给一个元素命名，以便我们可以直接使用名称，从而从使用中隐藏细节。

suppressing the details from the use of the object this ability to give a name to something is most valuable when used with our second means of abstraction

从对象的使用中隐藏细节，这种给事物命名的能力在与我们的第二个抽象手段结合时最为有价值。

capturing a computation within a procedure this means of abstraction dealt with the idea that a common pattern of computation can be generalized into a single procedure

将计算捕获在过程中，这种抽象手段处理了这样一个思想：一个常见的计算模式可以被泛化为一个单一的过程。

which covered every possible application of that idea to an appropriate value when coupled with the ability to give a name to that procedure we engendered the ability to create an important cycle in our language we can now create

这涵盖了该思想对适当值的每一种可能应用，再加上能够为该过程命名，我们就在语言中创造了一个重要的循环：我们现在可以创建

在我们的语言中，我们现在可以创建过程，为它们命名，并将它们视为语言本身的原始元素。一门高级语言的整个目标是允许我们以这种方式抑制不必要的细节，同时专注于使用过程抽象来支持更复杂的计算设计。

在我们的语言中，我们现在可以创建过程，为它们命名，并将它们视为语言本身的原始元素。一门高级语言的整个目标是允许我们以这种方式抑制不必要的细节，同时专注于使用过程抽象来支持更复杂的计算设计。

### 3. Introduction to compound data and the need for gluing / Cons as the basic glue and examples with points and segments (复合数据导论与粘合的需求 / Cons 作为基本粘合剂，以及点和线段的示例)

今天，我们将把抽象的概念推广到包括那些关注数据而非过程的概念。所以，我们将讨论如何创建复合数据或对象，并我们将检验标准。

今天，我们将把抽象的概念推广到包括那些关注数据而非过程的概念。所以，我们将讨论如何创建复合数据或对象，并且我们将检验标准。

and we're going to examine standard procedures associated with the manipulation of those data structures we'll see that data abstractions mirror many of the properties of procedural abstractions and we will thus generalize the ideas of compound data into data abstractions to complement our procedural abstractions

我们将检验与这些数据结构操作相关的标准过程。我们将看到，数据抽象反映了过程抽象的许多性质，因此我们将把复合数据的思想推广为数据抽象，以补充我们的过程抽象。

so far almost everything we've seen in scheme has revolved around numbers and computations associated with numbers this has been partly delivered on our part because we wanted to focus on the ideas of procedural abstraction without

到目前为止，我们在 Scheme 中看到的几乎所有内容都围绕着数字以及与数字相关的计算。这在一定程度上是我们刻意为之，因为我们想专注于过程抽象的思想，而不

Ideas of procedural abstraction without getting bogged down in other details. There are, however, clearly problems in which it is easier to think in terms of other elements than just numbers, and in which those elements have pieces that need to be glued together and pulled apart while preserving the concept of a larger unit.

过程抽象的思想，而不被其他细节所困扰。然而，显然有些问题中，用数字以外的其他元素来思考更容易，并且这些元素具有需要粘合在一起、同时保持更大单元概念的部件。

So our goal is to create a method for taking primitive data elements, gluing them together, and then treating the result as if it were itself a primitive element. Of course we'll need a way of ungluing the units to get back to constituent parts. What do we mean?

因此，我们的目标是创造一种方法，将原始数据元素粘合在一起，然后将结果视为原始元素本身。当然，我们需要一种方法来拆解这些单元，以回到组成部分。我们是什么意思呢？

To constituent parts, what do we mean when we say we want to treat the result of gluing elements together as a primitive data element? Basically, we want the same properties we had with numbers: we can apply procedures to them, we can use procedures to generate new versions of them, and we can create expressions that include them as simpler elements.

回到组成部分，当我们说要把粘合元素的结果视为原始数据元素时，我们是什么意思？基本上，我们想要与数字相同的性质：我们可以对它们应用过程，我们可以用过程生成它们的新版本，我们可以创建包含它们作为更简单元素的表达式。

The most important point when we glue things together is to actually have a contract associated with that process. That is, we don't care about the details of how things are glued together and unglued.

当我们把东西粘合在一起时，最重要的一点是实际上有一个与该过程相关的契约。也就是说，我们不关心东西如何粘合和拆解的细节。

Things are glued together and unglued if you like what we care about is the contract that says the two mechanisms working hand-in-hand so no matter how we put them together we're guaranteed when we use the right piece to unglue that we get back out what we started with.

如果你愿意，东西被粘合和拆解，我们关心的是契约，即两个机制协同工作，所以无论我们如何将它们组合在一起，当我们使用正确的部件来拆解时，我们保证能取回我们开始时的东西。

And ideally we'd like this process of gluing things together into compound data to have the property of closure. What closure means is that we can take the result of whatever we did when we created a compound data object and treat that thing itself as if it's a primitive so that it can be for example the input.

理想情况下，我们希望这种将东西粘合成复合数据的过程具有封闭性。封闭性意味着我们可以将创建复合数据对象时所做的任何结果，将其本身视为原始元素，以便它可以作为输入。

So that it can be, for example, the input to another operation of creating a compound object. We'll see that not all methods for creating compound data have this property, but the best and most powerful of them do. They are closed under the operation of creation of the data structure, and the results of any one of those things can be used as a primitive anywhere we want.

例如，它可以作为创建复合对象的另一个操作的输入。我们将看到，并非所有创建复合数据的方法都具有这种性质，但最好和最强大的方法确实具有。它们在数据结构创建操作下是封闭的，并且其中任何一个操作的结果都可以在我们想要的任何地方用作原始元素。

Scheme's basic means for gluing things together is called cons, short for constructor, and virtually all other methods for creating compound data objects are based on cons.

Scheme 中用于粘合东西的基本手段称为 cons，是构造器（constructor）的缩写，几乎所有其他创建复合数据对象的方法都基于 cons。

Compound data objects are based on cons. Cons is a procedure that takes two expressions as input; it evaluates each in turn and then glues these values together into something called a pair. Note that the actual pair object is the value returned by evaluating cons.

复合数据对象基于 cons。Cons 是一个过程，它接受两个表达式作为输入；它依次求值每个表达式，然后将这些值粘合在一起，形成称为序对（pair）的东西。注意，实际的序对对象是求值 cons 返回的值。

The two parts of a cons pair are called the car and the coder. If we apply the procedures of those names to a pair, we get back the value of the argument that was evaluated when the pair was created. Note that there's a contract here between cons, car, and coder, in which cons brings together values in some arbitrary pairing.

cons 序对的两个部分称为 car 和 cdr。如果我们将这些名字的过程应用于一个序对，我们得到的是创建该序对时求值的参数值。注意，这里 cons、car 和 cdr 之间存在一个契约，其中 cons 以某种任意方式将值组合在一起。

con su sings together in some arbitrary manner and all that matters is when car for example is applied to that object it get gets back out what we started note. That we can treat a pair as a unit, that is, having built a pair, we can treat it as a primitive and use it anywhere we might want to use any other structure. So we can pass a pair in as an argument to some other data abstraction, we can return a pair's value from have some data abstraction.

cons 以某种任意方式将值组合在一起，重要的是当 car 例如应用于该对象时，它取回我们开始时的东西。注意，我们可以将序对视为一个单元，也就是说，构建了一个序对后，我们可以将其视为原始元素，并在任何我们可能想使用其他结构的地方使用它。所以我们可以将序对作为参数传递给某个其他数据抽象，也可以从某个数据抽象返回序对作为值。

In this way, we can create elements that naturally can be thought of as units which happen.

通过这种方式，我们可以创建自然可以被视为单元的元素，而这些单元恰好

thought of as units which happen themselves to have components within that are also naturally thought of as being units so we can build up levels of hierarchy of data abstractions for

被视为单元，而这些单元本身内部又有组件，这些组件也自然被视为单元，因此我们可以构建数据抽象的层次级别，用于

example suppose we want to build a little system to reason about figures drawn in the plane

例如，假设我们想构建一个小系统来推理平面上的图形。

those figures might be composed of points in the plane which we can easily build it using a constructor given an x and y coordinate we make a point and we have of course things to get back out the pieces building on top of car encoder notice by the way there's a nice little contract between make point as

这些图形可能由平面上的点组成，我们可以很容易地使用构造器构建点，给定 x 和 y 坐标，我们制作一个点，当然我们也有东西来取回部件，建立在 car 和 cdr 之上。顺便注意，make-point 作为构造器与 point-x 和 point-y 作为选择器之间有一个很好的小契约，

little contract between make point as the constructor and point X and point Y as the selectors because they're built on top of Kant's car and coder they inherit the abstraction contract of those things which means that however I glue things together with make point point X will get back out the right piece.

make-point 作为构造器与 point-x 和 point-y 作为选择器之间有一个很好的小契约，因为它们建立在 cons 的 car 和 cdr 之上，它们继承了这些事物的抽象契约，这意味着无论我用 make-point 如何粘合东西，point-x 都会取回正确的部件。

Now if I want to draw a line segments in the plane they have two points an end point and a start point so I can build a segment by simply gluing together two points which notice themselves may also be things glued together using cons and of course I'll

现在，如果我想在平面上绘制线段，它们有两个点，一个终点和一个起点，所以我可以简单地通过将两个点粘合在一起来构建线段，注意这两个点本身也可能是使用 cons 粘合在一起的东西，当然我还会

together using cons and of course I'll have selectors for getting back out pieces like the start point of the segment is the first element at that segment and it itself is a pair that's returned so the point is that cons pairs have this property of closure I can glue things together create an abstraction treat them as a single unit and use them to be glued together into higher-order structures without any problem.

使用 cons 将它们组合在一起，当然我会有选择器来取回各个部分，比如线段的起点是该线段的第一个元素，而它本身也是一个被返回的序对。关键在于，cons 序对具有这种封闭性：我可以将事物粘合在一起，创建抽象，将它们视为一个整体，并毫无问题地将它们用于粘合成更高阶的结构。

### 4. Formalizing the pair abstraction: constructor, selectors, predicate / Generalizing to operations on data groups (形式化序对抽象：构造器、选择器、谓词 / 推广到对数据组的操作)

We can formalize what we've just seen in terms of the abstraction of a pair this abstraction has several standard parts.

我们可以根据序对的抽象来形式化我们刚刚看到的内容，这个抽象有几个标准部分。

Abstraction has several standard parts. First, it has a constructor for making instances of the abstraction. The constructor has a kind of contract in which objects A and B are glued together to construct a new object called a pair with two pieces inside.

抽象有几个标准部分。首先，它有一个构造器，用于创建抽象的实例。构造器有一种契约，其中对象 A 和 B 被粘合在一起，构造出一个称为序对的新对象，内部包含两个部分。

Second, it has some selectors or accessors to get the pieces back out. Notice how the contract specifies the interaction between the constructor and the selectors: whatever is put together can be pulled back apart using the appropriate selector.

其次，它有一些选择器或访问器来取回各个部分。注意契约如何规定构造器和选择器之间的交互：凡是组合在一起的东西，都可以使用相应的选择器重新拆开。

Typically, a data abstraction will also have a predicate, here called pair question mark. Its role is to identify whether a given object is an instance of the abstraction.

通常，数据抽象还会有一个谓词，这里称为 pair?。它的作用是识别给定对象是否是抽象的实例。

here called pair question mark its role is to take in any object and return true if the object is of type pair something constructed by cons this allows us to test objects for their type so that we know whether to apply a particular selector to that object

这里称为 pair?，它的作用是接收任何对象，如果该对象是 cons 构造的序对类型，则返回真。这使我们能够测试对象的类型，以便知道是否对该对象应用特定的选择器。

a key issue here is the contract between the constructor and the selectors the details of how a constructor puts things together are not at issue so long as however the pieces are glued together they can be separated back out into the original parts by the selectors so here's that idea stated one

这里的一个关键问题是构造器和选择器之间的契约。构造器如何将事物组合在一起的细节并不重要，只要这些部分被粘合在一起后，能够被选择器重新分离回原始部分即可。所以这里再次陈述了这个想法：

selectors so here's that idea stated one more time there's a contract between the constructor and the selectors car of a con so something gives us back out that thing coder of a concept something gives us back out that thing it pulls out the right pieces the contract just says they work together the details of how it's done shouldn't matter to the user of this data abstraction

选择器，所以这里再次陈述了这个想法：构造器和选择器之间存在契约，car 和 cons 的组合返回原来的东西，cdr 和 cons 的组合返回原来的东西，它取出正确的部分。契约只是说它们协同工作，具体实现细节对于该数据抽象的用户来说无关紧要。

also again notice how pairs have that nice property of closure we can use the result of a pair as the element of any new pair two constants together in arbitrary form and arbitrary

另外，再次注意序对具有那种良好的封闭性。我们可以将序对的结果用作任何新序对的元素，将两个常量以任意形式和任意结构组合在一起。

Together in arbitrary form and arbitrary structure. So how do we use the idea of pairs to help us in creating computational entities? To illustrate this, let's stick with our example of points and segments. Suppose we construct a couple of points using the appropriate constructor, and we then glue these points together into a segment.

以任意形式和任意结构组合在一起。那么，我们如何使用序对的概念来帮助我们创建计算实体呢？为了说明这一点，让我们继续使用点和线段的例子。假设我们使用适当的构造器构造了几个点，然后将这些点粘合在一起形成一个线段。

Now suppose we want to think about the operation of stretching a point—that is, pulling or pushing a point along a line from the origin through that point. Ideally, we would just think about this in terms of operations on elements of a

现在假设我们想要考虑拉伸一个点的操作——即沿着从原点到该点的直线拉动或推动一个点。理想情况下，我们只需考虑对点的元素进行操作，而不必担心点是如何实现的。

In terms of operations on elements of a point without worrying about how the point is actually implemented, we do this with the code shown. Note how this code creates a new data object; if we stretch point p1, we get a new point. Also note, as an aside, how cons pair of prints out with an open and close parentheses and with the value of the two parts within those parentheses separated by a dot.

对点的元素进行操作，而不必担心点是如何实现的，我们使用所示的代码来完成。注意这段代码如何创建一个新的数据对象；如果我们拉伸点 p1，我们得到一个新的点。另外，顺便注意 cons 序对如何以左右括号打印，括号内两个部分的值以点分隔。

Thus, the point created by applying our stretch procedure has a different value for the x and y parts than the original point, which is still hanging around as.

因此，通过应用我们的拉伸过程创建的点，其 x 和 y 部分的值与原始点不同，原始点仍然存在。

point which is still hanging around as we might expect from the actual code we get out the values of the parts of p1 but then make a new data object with scaled versions of those values as the parts

点仍然存在，正如我们从实际代码中预期的那样，我们取出 p1 的部分值，然后用这些值的缩放版本作为部分创建新的数据对象。

and we can generalize this idea to handle operations on segments as well as points now how each of these procedures builds on constructors and selectors for the appropriate data structure so that in examining the code we have no sense of the underlying implementation these structures happen to be built out of Khan spares but from the perspective of

我们可以推广这个想法来处理线段上的操作以及点上的操作。现在，这些过程中的每一个都建立在适当数据结构的构造器和选择器之上，因此在检查代码时，我们感觉不到底层实现。这些结构恰好是由 cons 序对构建的，但从代码设计者的角度来看，

Khan spares but from the perspective of the code designer we rely only on the contract for constructors and selectors for points and segments. Now suppose we decide that we want to take a group of points and manipulate that group in some way.

cons 序对，但从代码设计者的角度来看，我们仅依赖点和线段的构造器和选择器的契约。现在假设我们决定要取一组点并以某种方式操作该组。

For example, a figure might be defined as a group of ordered points with segments between each consecutive pair of points, and we might want to stretch that whole group or rotate it or do something else to it. How do we group these things together? Well, one possibility is just to use a bunch of cons pairs for example such as shown.

例如，一个图形可能被定义为一组有序的点，每对连续的点之间有一个线段，我们可能想要拉伸整个组、旋转它或对它做其他操作。我们如何将这些事物分组？嗯，一种可能性是使用一堆 cons 序对，例如所示。

Cons pairs, for example, such as shown here, are a perfectly reasonable way to glue things together. However, it's going to be a real bear to manipulate them. Suppose we want to stretch all these points; we would have to write code that would put together exactly the right collections of cars and coders to get out the pieces, perform a computation on them, and then glue them back together again.

例如，这里所示的 cons 序对，是一种完全合理的粘合方式。然而，操作它们将非常麻烦。假设我们想要拉伸所有这些点；我们将不得不编写代码，精确地组合出正确的 car 和 cdr 集合来取出各个部分，对它们进行计算，然后再将它们粘合回去。

### 5. Lists as a primitive for gluing arbitrary numbers of elements (列表作为粘合任意数量元素的基本构造)

This will be a royal pain. It would be much better if we had a more convenient and conventional way of gluing groups of things together. Fortunately, we do: pairs are primitive.

这将非常痛苦。如果我们有一种更方便、更常规的方式来粘合一组事物，那就好多了。幸运的是，我们有：序对是基本的。

Fortunately we do so pairs are primitive way of gluing two things together. This is nice when I just have two things but of course life doesn't just come in pairs. I may also want to be able to glue things together to come in arbitrary numbers of units and I need a way of doing that in a convenient form.

幸运的是，我们有，所以序对是粘合两个事物的基本方式。当我只有两个事物时这很好，但当然生活并不只是成对出现的。我可能还希望能够将事物粘合在一起，以任意数量的单元出现，我需要一种方便的形式来做到这一点。

Fortunately Scheme has such a basis for us, another way of gluing things together that is a more conventional interface into structures, and that form is called a list. So a list is a data object that can hold an arbitrary number of ordered

幸运的是，Scheme 为我们提供了这样的基础，另一种粘合事物的方式，是一种更常规的接口，这种形式称为列表。所以列表是一种数据对象，可以容纳任意数量的有序元素。

can hold an arbitrary number of ordered elements in it now we could just create a list by consoling things together in units until we have the appropriate number built but it's much more convenient to think of a list as a basic structure and here's more formally how we actually characterize it a list is going to be a sequence of pairs with the following properties

可以容纳任意数量的有序元素，现在我们只需通过将元素用 cons 逐步组合起来，直到构建出所需数量即可，但将列表视为一种基本结构要方便得多。下面是我们更正式地描述它的方式：一个列表将是一个具有以下性质的有序对序列。

the car part of a pair in the sequence holds an item one of the things are trying to collect together the cutter part of the pair in the sequence holds a pointer to the rest of the list and of course we need some

序列中一个有序对的 car 部分持有一个元素，即我们试图收集的事物之一；序列中该有序对的 cdr 部分持有一个指向列表其余部分的指针；当然，我们还需要某种方式来指示列表的末尾。

Of the list, and of course we need some way of telling where at the end of the list, so we have a special symbol called nil which signals the empty list, or in particular that there are no more pairs and we're at the end of that structure.

列表的末尾，当然我们需要某种方式来指示列表的末尾，因此我们有一个特殊的符号称为 nil，它表示空列表，或者特别地表示没有更多的有序对，我们位于该结构的末尾。

Another way of saying that is as follows: a list is a sequence of pairs ending in the empty list. Under that kind of definition, we actually see that lists are also closed—they're closed under the operation of cons and coder. In particular, if we have a sequence of pairs ending in the empty list, if we take a cons of something onto a sequence.

另一种说法如下：列表是一个以空列表结尾的有序对序列。在这种定义下，我们实际上看到列表也是封闭的——它们在 cons 和 cdr 运算下是封闭的。特别是，如果我们有一个以空列表结尾的有序对序列，如果我们对某个序列进行 cons 操作。

Take a cons of something onto a sequence of pairs ending in the empty list. What do we get? A new sequence of pairs ending in the empty list, therefore a list. So it's closed under the operation of cons.

对某个以空列表结尾的有序对序列进行 cons 操作，我们会得到什么？一个新的以空列表结尾的有序对序列，因此是一个列表。所以它在 cons 运算下是封闭的。

It's also closed under the operation of coder. If I have a sequence of pairs ending in the empty list, and I take the coder of that, by my construction here, I get a slightly smaller sequence of pairs ending in the empty list, therefore it's a list. Therefore I'm closed under the operation of coder. This closure property means I can use lists anywhere.

它在 cdr 运算下也是封闭的。如果我有一个以空列表结尾的有序对序列，并且我取其 cdr，根据我的构造，我得到一个稍小的以空列表结尾的有序对序列，因此它是一个列表。因此我在 cdr 运算下是封闭的。这种封闭性意味着我可以在任何地方使用列表。

property means I can use lists anywhere I'd use primitive elements so I can build up lists of Lists or lists of lists of Lists the only trick is what happens if I try and take coder of the empty list well this is actually left undefined in many schemes in some schemes coder of the empty list is itself the empty list in order to preserve this property of closure

这种封闭性意味着我可以在任何使用基本元素的地方使用列表，因此我可以构建列表的列表，或列表的列表的列表。唯一的技巧是，如果我尝试对空列表取 cdr 会发生什么？实际上，在许多 Scheme 实现中这是未定义的；在某些 Scheme 实现中，空列表的 cdr 是它自身，以保持这种封闭性。

in other schemes taking quarter of an empty list will give you an error saying you're trying to take apart a structure that doesn't have pieces nonetheless we see we have a new conventional interface

在其他 Scheme 实现中，对空列表取 cdr 会给出一个错误，提示你试图分解一个没有部分的结构。尽管如此，我们看到我们有了一个新的约定接口。

See, we have a new conventional interface: a list as a sequence of ordered items, which we're going to construct out of pairs. To visualize this, we use the following little notation: a cons pair is represented as a pair of boxes glued together.

看，我们有了一个新的约定接口：列表作为有序项的序列，我们将用有序对来构建它。为了可视化这一点，我们使用以下小记号：一个 cons 对表示为两个粘在一起的方框。

The first box holds a pointer to the value of the first expression supplied to cons. The second box holds a pointer to the value of the second expression supplied by cons. And the whole box has a pointer into it, because that pointer is what's returned by evaluating the cons — it gives us a pointer to the pair itself. A list then...

第一个方框持有一个指针，指向提供给 cons 的第一个表达式的值。第二个方框持有一个指针，指向 cons 提供的第二个表达式的值。整个方框有一个指向它的指针，因为该指针是求值 cons 时返回的——它给我们一个指向该有序对本身的指针。那么一个列表……

pointer to the pair itself a list then just consists of a sequence of cons boxes so in fact we see now the very nice structure of it the car element of each box in this sequence points to the element of the list in turn so it's an ordered sequence of things and the quarter box of each box points to the next part of the list so the coders point to the rest of the list including at the very end a special symbol for the empty list which is that slash through the last box this gives a nice way to visualize a list it's kind of like a

指向该有序对本身的指针。那么一个列表就由一系列 cons 方框组成，因此我们现在看到了它的非常优美的结构：该序列中每个方框的 car 元素依次指向列表的元素，所以它是一个有序的事物序列；每个方框的 cdr 方框指向列表的下一部分，所以 cdr 指向列表的其余部分，包括在最后有一个特殊的空列表符号，即最后一个方框上的斜线。这提供了一种很好的可视化列表的方式，它有点像……

Visualize a list, it's kind of like a skeleton. Cutter pointers create the spine of this structure, and they point along in a line.

可视化列表，它有点像骨架。Cdr 指针创建了这个结构的脊柱，它们沿一条线指向。

Hanging off of each of them in the car spot are the ribs, which contain the elements of the list. And again, notice how the sequence is preserved. Also notice how this nicely indicates the closure property of lists.

在 car 位置从每个指针上悬挂下来的是肋骨，它们包含列表的元素。再次注意序列是如何保持的。还要注意这如何很好地指示了列表的封闭性。

If they take the cutter element of any of these boxes, in turn it points to another list, a smaller one that ends in the special symbol of the empty list. Therefore, that property of closure is nicely preserved.

如果取这些方框中任何一个的 cdr 元素，它依次指向另一个列表，一个以空列表特殊符号结尾的较小列表。因此，封闭性得到了很好的保持。

### 6. List operations: creation, traversal, and recursion (列表操作：创建、遍历与递归)

property of closure is nicely preserved over the operation of cutter to check if something as a list, we have two things. First, we have a special predicate to check if something's the empty list; it's called null question mark.

封闭性在 cdr 运算下得到了很好的保持。为了检查某物是否为列表，我们有两件事。首先，我们有一个特殊的谓词来检查某物是否为空列表；它称为 null?。

It takes an object of any type and returns true if that object is actually the empty list with a special symbol nil, otherwise it returns false. To check if a structure is a list, we can just use pair question mark to check to see if it points to the beginning of a structure built out of consus, although technically we really should be careful and check.

它接受任何类型的对象，如果该对象实际上是带有特殊符号 nil 的空列表则返回真，否则返回假。为了检查一个结构是否为列表，我们可以使用 pair? 来检查它是否指向一个由 cons 构建的结构的开头，尽管严格来说我们真的应该小心检查。

我们真的应该小心检查，确保最后一个元素是特殊的空列表符号，因为我们已经用 cons 对构建了列表。我们可以使用 car 和 cdr 来取出各个部分，但今天我们要格外谨慎，将列表操作与配对操作分开处理。

我们真的应该小心检查，确保最后一个元素是特殊的空列表符号，因为我们已经用 cons 对构建了列表。我们可以使用 car 和 cdr 来取出各个部分，但今天我们要格外谨慎，将列表操作与配对操作分开处理。

我们将为列表创建不同的构造函数和选择器，用 first 获取列表的第一个元素，定义 rest 来获取除第一个元素外的其余部分。

我们将为列表创建不同的构造函数和选择器，用 first 获取列表的第一个元素，定义 rest 来获取除第一个元素外的其余部分。

list other than the first element and

除第一个元素外的列表其余部分，以及

list other than the first element and we'll define a join to be the operation of gluing something on to a list a note by the way that these abstractions nicely inherit closure properties from the underlying extractions of cons car and cutter now the key point behind defining a new kind of data abstraction or data structure is that it ought to make certain kinds of operations easy

除第一个元素外的列表其余部分，我们将定义 join 为将某物粘到列表上的操作。注意，顺便说一下，这些抽象很好地从底层的 cons、car 和 cdr 抽象中继承了封闭性。现在，定义一种新的数据抽象或数据结构的关键点在于，它应该使某些类型的操作变得容易。

and so we expect to see a standard set of procedures associated with each data structure that's going to hold true with lists as well in fact one of the common patterns we should see associated with

因此我们期望看到与每种数据结构相关联的一组标准过程，这对于列表也是如此。事实上，我们应该看到的常见模式之一是……

patterns we should see associated with lists are procedures for creating them out of other kinds of data. So here's a simple little procedure that will do it. It generates an interval of integers or numbers from a starting point to an ending point. And notice the nice subtle structure: it's a recursive call that basically says count up from the from point to the to point, generating new lists as we go along. And a particular look at the recursive call, it says add, join, or glue the value of from, which is an integer, on to whatever I get by

与列表相关联的模式是从其他类型的数据创建列表的过程。这里有一个简单的小过程可以做到这一点。它生成一个整数或数字的区间，从起点到终点。注意其优美而微妙的结构：这是一个递归调用，基本上说从 from 点向上计数到 to 点，沿途生成新的列表。特别地，看一下递归调用，它说将 from 的值（一个整数）添加、连接或粘到……

an integer on to whatever I get by generating another list, generating another list from one-plus from up to two and how do I stop well my counter goes past two I'm done and I'll simply return the empty list or that special symbol nil so here's a little procedure that uses the data abstraction to glue things together.

将一个整数加到通过生成另一个列表所得到的结果上，再从一到二生成另一个列表，那么我该如何停止呢？当我的计数器超过二时，我就完成了，只需返回空列表或那个特殊符号 nil。所以这里有一个小过程，它利用数据抽象将各部分粘合在一起。

and notice how that constructor is nicely used to put something on front of the other pieces also notice how its building on a contract if a numerate interval works well for small size problems that is if it generates a list then the adjoint operation is guaranteed

注意构造函数如何被巧妙地用来将某物放在其他部分的前面；还要注意它如何建立在契约之上：如果 enumerate-interval 对于小规模问题运行良好，即如果它生成了一个列表，那么 adjoint 操作就保证……

then the adjoint operation is guaranteed to give me a new list out because it glues something onto the front of a list, which I know by closure generates a list. And there were by inductive reasoning and numerate interval will generate a list for me to check this out. Let's just use our substitution model here are the first few steps where I've abbreviated a new rate interval to e I just for space reasons. So if I numerate the interval from 2 to 4, substituting into the body gets me that if expression. Evaluate the predicate, it's false, so I know as a

那么 adjoint 操作保证会给我一个新列表，因为它将某物粘到列表的前面，而根据闭包性质，我知道这会生成一个列表。通过归纳推理，enumerate-interval 会为我生成一个列表。为了验证这一点，让我们使用替换模型。这里是前几步，为了节省空间，我将 enumerate-interval 缩写为 e。所以如果我枚举从 2 到 4 的区间，代入函数体得到那个 if 表达式。求值谓词，它为假，所以我知道作为……

predicate it's false so I know as a consequence that I'm going to replace the entire if expression with the alternative clause. So evaluating a numerator interval from 2 to 4 reduces to adjoining to on to evaluate an interval from 3 to 4.

谓词为假，所以我知道结果是我将用 alternative 子句替换整个 if 表达式。因此，求值 enumerate-interval 从 2 到 4 就归结为将 2 连接到求值 enumerate-interval 从 3 到 4 的结果上。

Now remember we first must get the values of all the sub expressions before we can do any work, so we have to go off and get AI of 3/4 and by the reasoning we just did that reduces to another adjoint of 3 onto another call to a new rate interval from 4 to 4. Notice the deferred operations that are stacking up here. We expand.

现在记住，在我们做任何工作之前，必须先得到所有子表达式的值，所以我们必须去求 e 3 4，根据我们刚才的推理，它又归结为将 3 连接到另一个调用 enumerate-interval 从 4 到 4 的结果上。注意这里堆积起来的延迟操作。我们展开。

that are stacking up here we expand another level and we get another adjoint pulled out and a numerator interval from 5 to 4 this time when we evaluate that innermost expression the if Clause is going to have a predicate that returns false and in that case we return the value of the overall expression as a nil

这里堆积起来的延迟操作，我们再展开一层，得到另一个 adjoint 被拉出来，以及一个 enumerate-interval 从 5 到 4。这次当我们求值最内层的表达式时，if 子句的谓词将返回假，在这种情况下，我们返回整个表达式的值作为 nil。

again notice the nice recursive build up of deferred operations here we've not created any pairs yet we simply deferred a bunch of creations of pairs until we've gotten down to this base case now we're ready to evaluate adjoint of 4 on

再次注意这里延迟操作的漂亮递归构建；我们还没有创建任何序对，我们只是延迟了一堆序对的创建，直到我们到达这个基本情况。现在我们准备求值 adjoint 4 到……

we're ready to evaluate adjoint of 4 on to nil and that creates a con spare so just to show it here I've actually drawn in the con spare notice how it has the structure of 4 and an empty list the pointer to the pair's which actually returned by this adjoint and that reduces this expression to a simpler one

我们准备求值 adjoint 4 到 nil，这创建了一个 cons 单元。为了展示，我实际上画出了 cons 单元，注意它的结构是 4 和一个空列表，指向该序对的指针实际上由这个 adjoint 返回，这将该表达式简化为一个更简单的表达式。

now I'm ready to evaluate the next expression in this compound expression which is the adjoint of 3 onto that structure and that of course conses another pair onto that structure with 3 is the car and the coder pointing to the rest of the structure

现在我准备求值这个复合表达式中的下一个表达式，即 adjoint 3 到那个结构上，这当然会将另一个序对 cons 到那个结构上，其中 3 是 car，cdr 指向结构的其余部分。

pointing to the rest of the structure and evaluating one more step glues the last pair onto that structure and the value returned by the entire thing is printed out as the list open print two three four close print so there's my list that I've generated.

指向结构的其余部分，再求值一步将最后一个序对粘到该结构上，整个事情返回的值被打印为列表 (2 3 4)。所以这就是我生成的列表。

notice the deferred operations, notice the order in which the things are constructed, and notice how contra turns the pointer to the pair that can be used by the next call to adjoin.

注意延迟操作，注意事物构建的顺序，注意 cons 如何返回指向序对的指针，该指针可被下一次 adjoint 调用使用。

if we have procedures that can generate lists or constant up as we say out of other pieces, we also expect to see procedures that can walk.

如果我们有能够生成列表或如我们所说的从其他部分构造列表的过程，我们也期望看到能够遍历的过程。

Expect to see procedures that can walk their way down a list known as quartering down the list, are there to find some value or to create a new list out of that structure. So here's a simple example in a very handy one, list ref, its goal is to pull out the nth element of the list, where by convention we use zero to point to the first element of the list.

期望看到能够沿着列表向下走的过程，即所谓的遍历列表，以找到某个值或从该结构创建新列表。这里有一个简单且非常方便的例子，list-ref，其目标是取出列表的第 n 个元素，按照惯例我们用零指向列表的第一个元素。

Notice the nice structure of list ref: it says if n is equal to zero, I'm going to get the first element out of the list; otherwise, I'm going to rely on the closure property of lists, namely

注意 list-ref 的漂亮结构：它说如果 n 等于零，我将从列表中取出第一个元素；否则，我将依赖列表的闭包性质，即……

the closure property of lists, namely rest of list is itself a list, to do list rest of list is itself a list to do list. Ref of one less thing, so by the closure property I can recursively walk my way down the list counting down until I find the point I want to, and I'm guaranteed to find the right thing.

列表的闭包性质，即列表的其余部分本身就是一个列表，来做 list-ref 对少一个东西的列表的其余部分。因此，通过闭包性质，我可以递归地沿着列表向下走，倒数直到找到我想要的位置，并且我保证能找到正确的东西。

Unless, of course, I try and reference something beyond the end of the list, in which case I want to get an error. For example, if Jo is this simple list that we created previously, then list ref of Jo and one will say, is n equal to zero? No, so take the quarter of Jo, which grabs the pointer that starts with the pair.

当然，除非我试图引用超出列表末尾的东西，在这种情况下我想得到一个错误。例如，如果 Jo 是我们之前创建的简单列表，那么 list-ref Jo 1 会说：n 等于零吗？不，所以取 Jo 的 cdr，它抓取从该序对开始的指针。

The pointer that starts with the pair with three in the first element and does list ref on that list with n set to zero. In this case, when list ref is run recursively as it is, it says, is n equal to zero? It is, and it returns the value three. So list ref basically recursively walks its way down a list, relying on the closure property of lists under constant coder until it finds the right place and returns the element hanging off the car pointer.

从第一个元素为 3 的序对开始的指针，并对该列表做 list-ref，n 设为 0。在这种情况下，当 list-ref 递归运行时，它说：n 等于零吗？是的，它返回值 3。所以 list-ref 基本上递归地沿着列表向下走，依赖列表在 cons 和 cdr 下的闭包性质，直到找到正确的位置并返回挂在 car 指针上的元素。

I can, of course, do other things as I walk my way down the list. Another very handy procedure is length; it tells...

当然，我可以在沿着列表向下走的过程中做其他事情。另一个非常方便的过程是 length；它告诉我们……

很实用的过程是 length，它告诉我们列表中有多少个元素，或者说那个骨架的脊柱有多长。它通过相同的递归性质来实现这一点：如果我有一个空列表，长度为 0；否则，列表的长度就是 1 加上对列表其余部分求长度所得的值。

很实用的过程是 length，它告诉我们列表中有多少个元素，或者说那个骨架的脊柱有多长。它通过相同的递归性质来实现这一点：如果我有一个空列表，长度为 0；否则，列表的长度就是 1 加上对列表其余部分求长度所得的值。

对于挂在 coder 上的东西，根据闭包性质，如果 LST 是一个列表，那么 rest of list 也是一个列表，因此我可以对其应用 length，并得到那个答案的值。

对于挂在 cdr 上的东西，根据闭包性质，如果 lst 是一个列表，那么 rest of list 也是一个列表，因此我可以对其应用 length，并得到那个答案的值。

所以又一次，我将这个问题分解成了更简单的部分。

所以又一次，我将这个问题分解成了更简单的部分。

again I've broken this down into simpler versions of the same problem using my recursive property. In fact, this is a common kind of effect.

再次，我利用递归性质将问题分解为同一问题的更简单版本。事实上，这是一种常见的效果。

Notice how the procedures we're building have a form or structure that tends to mimic the form or structure of the data abstraction lists or sequences of elements.

注意我们构建的过程具有一种形式或结构，往往模仿数据抽象列表或元素序列的形式或结构。

So procedures to manipulate lists tend to be recursively things that walk down that sequence of elements, using selectors to pull out the right pieces.

因此，操作列表的过程往往是递归地沿着元素序列向下走，使用选择器取出正确的部分。

So let's put those two ideas together, let's think about how we might could or down one list while Consing up

所以让我们把这两个想法放在一起，思考如何在一个列表上向下 cdr 的同时向上 cons 另一个列表。

Could or down one list while Consing up a new list as the output of that process. Here's the simplest possible version of it. Suppose I want to make a copy of a list. Well, notice the form: if my input argument LST is empty, that is if it's null, then I'll just return an empty list, making a copy of it simple. If not, the property of copying my input list consists of making a copy of the first element and putting it on the front of whatever I get by copying the rest of the list. Notice how I'm nicely relying on the data abstraction here. First is...

可以向下遍历一个列表，同时通过 Cons 构造一个新列表作为该过程的输出。这里是最简单的版本。假设我想复制一个列表。注意形式：如果我的输入参数 LST 是空的，即它为 null，那么我只需返回一个空列表，这样复制就很简单。如果不是，复制输入列表的性质包括复制第一个元素，并将其放在复制剩余列表所得结果的前面。注意我在这里很好地依赖于数据抽象。First 是...

data abstraction here first is guaranteed to get me out the first element of the thing I'm copying rest by closures guaranteed to get me out the rest of the list copy by induction can run on that smaller problem and will be guaranteed to return me a list so that adjoining first onto that is guaranteed to give me a list as output therefore copies guaranteed to take a list in and give me a list back out and by what we just saw it will give it back out in exactly the order we put it in well copying is pretty boring does make a lot of sense but here's how we can use that

这里的数据抽象 first 保证能取出我正在复制的东西的第一个元素，rest 通过闭包保证能取出列表的其余部分，通过归纳法可以处理这个更小的问题，并保证返回一个列表，因此将 first 附加到它前面保证输出是一个列表。因此复制保证接收一个列表并返回一个列表，而且根据我们刚才看到的，它会以完全相同的顺序返回。复制虽然有点无聊，但确实很有意义，但我们可以这样利用它。

of sense but here's how we can use that idea. Suppose we want to take two lists and glue them together, append one onto the end. For example, appending the list 1 2 and the list 3 together should give me a new list 1 2 3 4 in that order.

但我们可以这样利用这个想法。假设我们想要将两个列表粘合在一起，将一个附加到另一个的末尾。例如，将列表 1 2 和列表 3 附加在一起应该给我一个新列表 1 2 3 4，顺序如此。

Again, the sequencer or order is preserved. How could I build such a procedure? Well, I can take the thing I just did; I can use the strategy of copying the first list onto the second list, or putting it on the front of that list. So here's a very handy and useful procedure for two lists: append is going to make a copy of the first list and add

同样，顺序或次序被保留。我怎样才能构建这样的过程？好吧，我可以采用我刚才做的事情；我可以使用复制第一个列表并将其放到第二个列表前面的策略，或者将其放到该列表的前面。所以这里有一个非常方便且有用的过程，用于两个列表：append 将复制第一个列表并添加...

To make a copy of the first list and add it to the front of the second list, and notice how it does it. It says if I have an empty first list, then I have nothing to put on the front, so the base case here is simply to return the value of the second list, a pointer to that list.

复制第一个列表并将其添加到第二个列表的前面，注意它是如何做到的。它说如果第一个列表为空，那么我没有东西可以放到前面，所以这里的基本情况就是简单地返回第二个列表的值，即指向该列表的指针。

Otherwise, just as I did in the coffee case, I make a copy of the first element of the first list and put it on the front of whatever I get by appending the rest of the first list onto the second list. There's that nice recursive form that nicely mimics the structure of the data.

否则，就像我在复制案例中所做的那样，我复制第一个列表的第一个元素，并将其放在将第一个列表的其余部分附加到第二个列表所得结果的前面。这就是那种优美的递归形式，它很好地模仿了数据的结构。

that nicely mimics the structure of the data abstraction and allows me to take advantage of the closure properties to guarantee that the program does the right thing. So again, we see procedures that manipulate list structure and generate list structure back out. They all rely on using the selectors and constructors to get out the pieces of the lists and the glue new things together to make new lists.

这种形式很好地模仿了数据抽象的结构，并允许我利用闭包属性来保证程序做正确的事情。因此，我们再次看到操作列表结构并生成列表结构的过程。它们都依赖于使用选择器和构造器来取出列表的各个部分，并将新事物粘合在一起以生成新列表。

So now we can put these ideas to work in handling more complex structures. Let's group together a set of points using a list. Then we can easily write a procedure to stretch the

所以现在我们可以将这些想法应用于处理更复杂的结构。让我们使用一个列表将一组点组合在一起。然后我们可以轻松地编写一个过程来拉伸...

easily write a procedure to stretch the entire group by building on the wonderfully recursive nature of the list. Here it is, note how we subdivide the problem of stretching a group into the operation of stretching a point using the procedure appropriate for points and then adding that to the result we would get by stretching the rest of the group.

轻松编写一个过程来拉伸整个组，方法是建立在列表美妙的递归性质之上。在这里，注意我们如何将拉伸一个组的问题细分为使用适用于点的过程拉伸一个点，然后将该结果添加到拉伸组其余部分所得的结果上。

Because of the recursive nature of a list, we know that the rest of the list is a list, so we can use induction to conclude that stretch group applied to a smaller collection will return a new.

由于列表的递归性质，我们知道列表的其余部分是一个列表，因此我们可以使用归纳法得出结论：将 stretch-group 应用于较小的集合将返回一个新的...

smaller collection will return a new group and thus adjoining the new element to the front of this will give us back a group. And if we want to find the midpoint or centroid of a group, we can put together the pieces we built earlier.

较小的集合将返回一个新的组，因此将新元素附加到其前面将给我们一个组。如果我们想要找到一个组的中心点或质心，我们可以组合我们之前构建的各个部分。

As shown here, add X and add Y have a structure very similar to our earlier examples. They simply cull down the list, gathering up information as they go into a set of deferred operations, in this case deferred additions.

如此处所示，add-X 和 add-Y 的结构与我们之前的示例非常相似。它们只是向下遍历列表，在过程中将信息收集到一组延迟操作中，在这种情况下是延迟的加法。

Each of these will get the sum of the X and y values of all the points in a group. To find the midpoint, we need to get the...

这些中的每一个都将得到组中所有点的 X 和 y 值的总和。要找到中点，我们需要得到...

Find the midpoint we need to get the average x and y value, so we need to know how many elements are in the group. We get that using length; we can combine this information to create a new point at the middle of the group.

要找到中点，我们需要得到平均 x 和 y 值，所以我们需要知道组中有多少个元素。我们使用 length 得到这个；我们可以组合这些信息来创建一个位于组中间的新点。

Note the new form left; you can find the details in the textbook, but it suffices to think of this as an expression in which each of the names in the first set of expressions—X, some Y, some, and how many—are bound to the values of the expressions following those names. Then within the confines of the lead expression, those names are simply local.

注意左侧的新形式；你可以在教科书中找到详细信息，但可以将其视为一个表达式，其中第一组表达式中的每个名称——X、some-Y、some 和 how-many——都绑定到这些名称后面的表达式的值。然后在 let 表达式的范围内，这些名称只是局部的。

expression those names are simply local names for those values and are substituted for just as we would in the standard substitution model.

在表达式中，这些名称只是这些值的局部名称，并像我们在标准替换模型中那样被替换。

### 7. Abstraction barriers and contracts for data structures (数据结构的抽象屏障与契约)

so to summarize we have seen that languages often provide conventional ways of grouping data elements into structures here either in pairs or as arbitrarily long collections associated with these conventional structures.

总结一下，我们已经看到语言通常提供将数据元素分组为结构的常规方式，这里要么是成对的，要么是任意长的集合，这些集合与这些常规结构相关联。

our methods for operating on them and these procedures often have a form that mimics the structure for example in procedures that convert lists into lists we see that the recursive step usually involves.

我们操作它们的方法，这些过程通常具有模仿结构的形式，例如在将列表转换为列表的过程中，我们看到递归步骤通常涉及...

that the recursive step usually involves using the selectors to get out the parts of the list operating on each and then using the constructor to reassemble the parts into a list. this form means that the same inductive proofs we used to reason about our recursive procedures will also apply here. we can often deduce properties of our procedures and their associated data structures by relying on the fact that inductively the procedure operates correctly on smaller sized data structures. so let's step back and examine what we've built so far we've

递归步骤通常涉及使用选择器取出列表的各个部分，对每个部分进行操作，然后使用构造器将各部分重新组装成列表。这种形式意味着我们用来推理递归过程的相同归纳证明也适用于这里。我们通常可以通过依赖归纳过程在较小尺寸的数据结构上正确操作这一事实来推导出我们的过程及其相关数据结构的属性。所以让我们退后一步，检查我们目前构建的内容，我们已经...

examine what we've built so far we've basically built a hierarchy of data abstractions each of which is constructed out of simpler ones at the bottom are pairs where we have a basic contract from scheme about how cons car encoder interact

检查我们目前构建的内容，我们基本上构建了一个数据抽象的层次结构，每个抽象都由更简单的抽象构建而成。底层是序对，其中我们有关于 cons、car 和 cdr 如何交互的基本契约。

is data abstractions on top of that we have built lists but where the user can take advantage of the fact that lists are also pairs in fact we do this directly by using car encoder as our selectors for lists on top of that we just built groups but again the user can take advantage of the knowledge

在这些数据抽象之上，我们构建了列表，但用户可以利用列表也是序对这一事实。事实上，我们直接通过使用 car 和 cdr 作为列表的选择器来做到这一点。在此基础上，我们又构建了分组，但用户同样可以利用分组是由列表构成的列表这一知识。

user can take advantage of the knowledge that groups are constructed as lists of lists but where she shielded from the flag that lists are implemented as pairs.

用户可以利用分组是由列表构成的列表这一知识，但她被屏蔽了列表是由序对实现的这一事实。

in essence what we've done is we've built a set of abstraction barriers in which the implementation details of a data structure are only weakly separated from the use of those structures.

本质上，我们所做的是构建了一组抽象屏障，其中数据结构的实现细节与这些结构的使用之间的分离是薄弱的。

this means that we rely on the user showing discipline and applying procedures and sometimes we're going to be much better off imposing strong abstraction barriers between the details of a data structures.

这意味着我们依赖用户展现自律并应用过程，但有时在数据结构的细节之间施加强抽象屏障会好得多。

between the details of a data structures implementation and its contract for usage or set another way we've tried to separate out different kinds of structures so that we have conventions for helping us think about those structures individually but we've allowed the user to cross over the barrier between those structures to get at the implementation of the structure below it what happens if we decide to make those abstraction barriers much much stronger to really separate out the internal implementation of a data structure from the people that use it

在数据结构的实现细节与其使用契约之间，或者换一种说法，我们试图分离不同类型的结构，以便我们有约定来帮助分别思考这些结构，但我们允许用户跨越这些结构之间的屏障，以触及底层结构的实现。如果我们决定让这些抽象屏障变得更强，真正将数据结构的内部实现与使用它的人分离开来，会发生什么呢？

structure from the people that use it. This then leads us to the notion of a really rigorous data abstraction, and here Shawn prepares are the kinds of things we expect to see in such a data abstraction.

将结构与使用它的人分离开来。这引导我们走向严格数据抽象的概念，在这里，Shawn 准备了我们在这样的数据抽象中期望看到的各种东西。

We'll have a constructor that glues the pieces together. It's going to have a contract between the types of the input and the type of the output, shown here. We'll have a set of accessors or selectors to get the pieces back out, and most importantly, we'll have a contract between the constructor and the selectors so that whatever we glue together with the

我们将有一个构造函数，将各个部分粘合在一起。它将在输入类型和输出类型之间有一个契约，如这里所示。我们将有一组访问器或选择器来取回各个部分，最重要的是，我们将在构造函数和选择器之间有一个契约，以便无论我们用构造函数粘合什么，

### 8. The abstraction barrier and rational numbers as an example (抽象屏障与有理数示例)

whatever we glue together with the

无论我们用构造函数粘合什么，

Whatever we glue together with the constructor we can get back apart by using the appropriate selectors. Notice that this contract says nothing about how the abstractions are actually built; it simply specifies the interrelated behavior will have some operations, standard operations on these data abstractions.

无论我们用构造函数粘合什么，我们都可以通过使用适当的选择器将其拆解。注意，这个契约没有说明这些抽象是如何实际构建的；它只是指定了相互关联的行为。我们将对这些数据抽象有一些标准操作。

For the case of pairs, we have pair question mark that tells us whether something is a pair or not. All of this is separated by what we're going to call an abstraction barrier. Think of it as a wall across this wall; very little can pass and it separates out the

对于序对的情况，我们有 pair? 来判断某物是否为序对。所有这些都被我们所谓的抽象屏障所分隔。把它想象成一堵墙，穿过这堵墙的东西很少，它将抽象的使用——构造事物、访问事物、它们之间的契约、对它们的操作——与序对的实际表示和实现分离开来。

little can pass and it separates out the use of the abstraction constructing things accessing things the contract between them operations on them it separates all of that out from the actual representation and implementation of pairs.

很少能穿过，它将抽象的使用——构造事物、访问事物、它们之间的契约、对它们的操作——与序对的实际表示和实现分离开来。

This means that any user living above that barrier can use the operations specified up there and basically freely manipulate the abstraction to get out pieces and construct new kinds of things.

这意味着任何生活在那道屏障之上的用户都可以使用上面指定的操作，基本上自由地操作抽象，取出各个部分并构造新种类的事物。

This user knows nothing about what's below the barrier and the actual details by which the constructor and selectors are

这个用户对屏障之下的事物一无所知，对构造函数和选择器实际实现的细节也一无所知。

构造器和选择器如何实现，以及它们之间的契约如何被强制执行，我们尚未讨论。现在，让我们用一个更详细的例子来深入说明这一点。记住，我们试图强调的核心思想是：将数据抽象的实现细节与其使用分离开来。我们将在两者之间建立一道坚实的屏障，并探究为何这道屏障能极大地简化我们构建实用系统的过程。我们即将使用的示例是有理数。

构造器和选择器如何实现，以及它们之间的契约如何被强制执行，我们尚未讨论。现在，让我们用一个更详细的例子来深入说明这一点。记住，我们试图强调的核心思想是：将数据抽象的实现细节与其使用分离开来。我们将在两者之间建立一道坚实的屏障，并探究为何这道屏障能极大地简化我们构建实用系统的过程。我们即将使用的示例是有理数。

going to use is rational numbers and simple arithmetic operations on rational numbers. I'll remind you that a rational number is just a ratio of two numbers, a numerator over denominator. For convenience, will make them both integers, although they don't have to be.

我们将使用有理数以及有理数上的简单算术运算。我要提醒你，有理数就是两个数的比，即分子除以分母。为了方便，我们将它们都设为整数，尽管它们不一定是整数。

Associated with rationals, we have operations: we can add them together, we can multiply them, and the rules for that are shown in the next two lines. Notice that we're really cheating here; in fact, I've put the plus sign and the star sign on the left in to distinguish that these are operations.

与有理数相关，我们有运算：我们可以将它们相加，可以相乘，规则如下面两行所示。注意，我们实际上在作弊；事实上，我在左边放了加号和星号以区分这些是运算。

to distinguish that these are operations on rationals and in fact the rules in essence say how to decompose a rational operation into simpler operations the things on the right-hand side of the equal signs are just normal integer multiplications and additions and then the construction of the ratio which is what that division sign is showing now.

以区分这些是对有理数的运算，实际上这些规则本质上说明了如何将有理数运算分解为更简单的运算。等号右边的东西只是普通的整数乘法和加法，然后是构造比值，即除法符号所示。

let's see how we can use the idea of rational numbers to build a data abstraction and use it first here's our data abstraction for rational numbers and we know what we need here we need a constructor we'll just call it make rat

让我们看看如何利用有理数的概念来构建一个数据抽象并使用它。首先，这是我们对有理数的数据抽象，我们知道我们需要什么：我们需要一个构造函数，我们称之为 make-rat。

constructor we'll just call it make rat it's going to take two integers in and reproduce for us one of these rational numbers we'll need some accessors or selectors numr and dena we'll call them they should get out the pieces notice the type takes one of these rational structures in gives us back an integer and most importantly what's the contract well what we'd expect we can use numr on the result of constructing irrational to get back out the first piece and we can use de nom on whatever we get out of constructing irrational get back the

构造函数，我们称之为 make-rat，它接受两个整数，为我们生成一个有理数。我们需要一些访问器或选择器，我们称之为 numer 和 denom，它们应该取出各个部分。注意类型：接受一个有理结构，返回一个整数。最重要的是，契约是什么？我们期望的是，我们可以对构造有理数的结果使用 numer 来取回第一个部分，我们可以对构造有理数的结果使用 denom 来取回第二个部分。

constructing irrational get back the second piece we'll also have some operations on them we'll have something that prints out rationals we're going to have operations as we saw they can add rationals or multiply rationals together.

构造有理数的结果取回第二个部分。我们还将有一些操作，比如打印有理数，以及我们看到的加法和乘法操作。

and of course we're going to separate all of this from the implementation we should be able to have somebody hand us an implementation of rationals constructors and selectors and operations and we should in fact be able to build our own versions of operations just using those constructors and selectors or build other operations on.

当然，我们将所有这些与实现分离开来。我们应该能够让别人给我们一个有理数构造函数、选择器和操作的实现，而我们实际上应该能够仅使用这些构造函数和选择器来构建我们自己的操作版本，或者在其上构建其他操作。

### 9. Implementations of rationals and building operations on them (有理数的实现及在其上构建操作)

selectors or build other operations on top of rationals that never need to know how rationals are actually built we only rely on the contract between constructors and selectors now let's think about actually building an implementation for rationals again we've got all the first pieces of the contract we're going to have constructors accessors or selectors the contract between them the other pieces how would we actually make one of these things that satisfies the contract well here's a simple implementation a particular implementation of a rational would be to

选择器或在有理数之上构建其他操作，而这些操作永远不需要知道有理数实际上是如何构建的；我们只依赖构造函数和选择器之间的契约。现在让我们考虑实际为有理数构建一个实现。我们再次拥有了契约的第一部分：我们将有构造函数、访问器或选择器，以及它们之间的契约。其他部分——我们如何实际制造一个满足契约的东西？嗯，这里有一个简单的实现，一个特定的有理数实现将是

implementation of a rational would be to use const car and cooter our constructor mate rat would be used about a built using cons numr would therefore be car and anomaly be cooter this seems obvious.

有理数的一个实现将是使用 `cons`、`car` 和 `cdr`。我们的构造函数 `make-rat` 将使用 `cons` 构建，因此 `numer` 将是 `car`，而 `denom` 将是 `cdr`。这看起来很明显。

but notice there's an important point here when we're going to come back to but the key point distress is we can enforce the contractor we require between make rat numr and UNAM by inheriting that contract from Kant's car and cooter that is since cons car and could er satisfy this contract by the construction of make rat numeron - nom we get the same behavior.

但请注意，这里有一个重要的点，我们稍后会再回来讨论。关键点是，我们可以通过继承 `cons`、`car` 和 `cdr` 的契约来强制执行我们在 `make-rat`、`numer` 和 `denom` 之间要求的契约。也就是说，由于 `cons`、`car` 和 `cdr` 满足这个契约，通过构造 `make-rat`、`numer` 和 `denom`，我们得到相同的行为。

Numeron - nom we get the same behavior of nonetheless by using make-rat. Numerator known as our constructors and selectors, we've shielded the user from the internals of the fact it's built out of cons, car, and coder, and we'll see shortly why that's actually going to be important.

通过使用 `make-rat`、`numer` 和 `denom` 作为我们的构造函数和选择器，我们向用户屏蔽了它由 `cons`、`car` 和 `cdr` 构建的内部事实，我们很快就会看到为什么这实际上很重要。

In fact, here's exactly why it's important. Here's an alternative implementation for rationals. We could use make-rat as list, numeros, car, and dena mascara, and I'll remind you that quatre gets out the car of the coder of the element it puts in. Does this satisfy the contract? Sure, convince yourself by checking.

事实上，这正是它重要的原因。这是有理数的另一种实现。我们可以使用 `make-rat` 作为 `list`，`numer` 作为 `car`，`denom` 作为 `cadr`，我将提醒你 `cadr` 取出列表中第二个元素的 `car`。这满足契约吗？当然，通过检查来说服自己。

the contract sure convince yourself by running a little example if you're not certain can a user tell which version we've built the list version or the pair version no the whole point of the abstraction barrier is to shield the user from that kind of decision

契约，当然，通过运行一个小例子来说服自己，如果你不确定的话。用户能分辨出我们构建的是列表版本还是序对版本吗？不能，抽象屏障的全部意义在于向用户屏蔽这种决策。

why would we want to have alternative representations what we're going to see that shortly key point here is both of these implementations are valid both of them satisfy the contract from the users perspective that's all that matters for example here's one of the operations

为什么我们想要替代表示？我们很快就会看到。这里的关键点是，这两种实现都是有效的，它们都满足契约。从用户的角度来看，这才是最重要的。例如，这是其中一个操作。

example here's one of the operations we'd like to have one rational something that prints out the value of the rational and in fact it'll use our internal scheme procedures of display to show the parts of the rational with that slash sign between them.

例如，这是我们想要的一个操作：`print-rat`，它打印有理数的值。事实上，它将使用我们内部的 Scheme 过程 `display` 来显示有理数的各个部分，并在它们之间加上斜杠符号。

notice the type takes in rat and doesn't say what is going to return as tight because it's just doing display.

注意类型：它接受一个 `rat`，并且没有说明它将返回什么类型，因为它只是进行显示。

most importantly can this procedure tell which implementation of numeron dena we're using the answer course is no all we're using is selecting out those pieces so we separated out the use from the

最重要的是，这个过程能分辨出我们使用的是 `numer` 和 `denom` 的哪种实现吗？答案当然是不能。我们只是使用选择器来取出那些部分，所以我们把使用与实现细节分离开了。

Separated out the use from the implementation details. What about my other two operations? Well, I can build those and these have a form that's important to look at. Let's look at the first one: adding two rationals. The type says taking two rationals as input and giving us back a rational as output. It's important that when we add two rationals, we get back a rational. What does this say to do? Well, notice the pieces. We first use the selectors to pull those data structures apart—numerator of X, the denominator of Y, numerator and denominator of X. Those selectors are getting out the pieces. We've now reduced.

把使用与实现细节分离开。那我的另外两个操作呢？嗯，我可以构建它们，这些操作的形式很重要，让我们看看第一个：两个有理数相加。类型说明输入两个有理数，输出一个有理数。重要的是，当我们把两个有理数相加时，我们得到一个有理数。这是做什么的？嗯，注意这些部分。我们首先使用选择器将这些数据结构拆开——`numer` 的 X，`denom` 的 Y，`numer` 和 `denom` 的 X。这些选择器取出各个部分。我们现在已经简化了。

Getting out the pieces we've now reduced this to simpler things, to integers, so we can apply integer operations to them. The multiplications in the addition, same thing with the denominator, and then having done those operations, we glue the whole thing back together again with make racket.

取出各个部分后，我们将其简化为更简单的事物，即整数，因此我们可以对它们应用整数运算。加法中的乘法，分母也一样，然后完成这些运算后，我们用 `make-rat` 将整个东西重新粘合在一起。

This is an important and common process to build an operation on a data abstraction. We will tend to take that data abstraction, use the selectors to get out the pieces, reduce the computation to simpler operations on simpler pieces, do some work, and then...

这是在数据抽象上构建操作的一个重要且常见的过程。我们倾向于取出数据抽象，使用选择器取出各个部分，将计算简化为对更简单部分的更简单运算，做一些工作，然后……

simpler pieces do some work and then glue back together the structures that we actually need. Also notice how the types help us here. For example, what's a rationale? It's something that's glued together with the constructor. If I apply numr to it, remember what my contract said: numeration 'el and gives me back an integer. Similarly with the NAM. Therefore I'm guaranteed in the first line of plus rap to get out two integers, so I know I can do the right kinds of work.

更简单的部分，做一些工作，然后重新粘合我们实际需要的结构。还要注意类型在这里如何帮助我们。例如，什么是有理数？它是用构造函数粘合在一起的东西。如果我对其应用 `numer`，记住我的契约说：`numer` 接受一个有理数并返回一个整数。`denom` 也是如此。因此，我保证在 `plus-rat` 的第一行得到两个整数，所以我知道我可以做正确类型的工作。

I'm also guaranteed, when I have that work done, to have two integers back, so that I'm passing those in to make raft.

我也保证，当工作完成时，我有两个整数，所以我可以将它们传递给 `make-rat`。

that I'm passing those in to make raft. What was the contract for make-rat? It took two integers in and constructed a rational, so by the type argument I can see that my contract really is satisfied here.

我将它们传递给 `make-rat`。`make-rat` 的契约是什么？它接受两个整数并构造一个有理数，所以通过类型论证，我可以看到我的契约确实在这里得到满足。

So let's use our little system. Let's create a couple of rationals: make-rat of 1 over 2, we'll call 1/2 because that's what it is. Make-rat of 3 over 4, we'll call 3/4 because that's what it is.

所以让我们使用我们的小系统。让我们创建几个有理数：`make-rat` 1 除以 2，我们称之为 1/2，因为它就是 1/2。`make-rat` 3 除以 4，我们称之为 3/4，因为它就是 3/4。

And we can now create a new rational. We'll define it to be new by using our operation for adding rationals, plus-rat, to those two pieces, and we just seen how.

我们现在可以创建一个新的有理数。我们将使用我们的加法运算 `plus-rat` 将这两个部分相加来定义它，我们刚刚看到了如何做。

to those two pieces and we just seen how to build it we know this is going to go off pull the things apart do some arithmetic computations glue them back together and new will be irrational well it sounds pretty straightforward now.

将这两个部分相加，我们刚刚看到了如何构建它。我们知道这将进行：拆开各部分，做一些算术计算，重新粘合它们，`new` 将是一个有理数。嗯，现在听起来相当直接。

what happens if we look at the pieces of new we say what's the new Maroof new we get out 10 what's the denominator of new we get out 8 wait a minute shouldn't this be 5/4 we add 1/2 to 3/4 we ought to get 5 force but we get 10 8 so if you like it got the right answer but not the correct answer.但是不是正确的答案。

如果我们查看 `new` 的各个部分，我们会说 `numer` 的 `new` 是什么？我们得到 10。`denom` 的 `new` 是什么？我们得到 8。等等，这不应该是 5/4 吗？我们将 1/2 加到 3/4，我们应该得到 5/4，但我们得到 10/8。所以如果你喜欢，它得到了正确的答案，但不是正确的答案。

but not the correct answer and the reason is quite simple go back and look at what we said to do for the arithmetic operations we're just taking the cross products of the numerators and the denominators in fact it's done the right computation it just didn't give us what we expected and in fact that's exactly the point of this whole little exercise having seen that we can build rationals having seen we've got opportunities from different implementations and we should be able to shield the user of rationals from the implementation of rationals

但这不是正确答案，原因很简单：回头看看我们对算术运算所做的，我们只是对分子和分母取叉积。事实上，它做了正确的计算，只是没有给出我们预期的结果。而这正是这整个小练习的意义所在：既然我们已经看到可以构造有理数，也看到了不同实现带来的机会，我们就应该能够将有理数的使用者与有理数的实现隔离开来。

from the implementation of rationals

与有理数的实现隔离开来。

From the implementation of rationals, let's think about what we could do to fix this problem. And what's the problem? We're not quite rationalizing the whole thing, or in particular we're not reducing the rationals we compute to simplest possible terms. How do we fix it? Well, the easiest thing is to simply find the greatest common divisor of the numerator and denominator and divide both portions by that to make something smaller, to reduce it down to the smallest possible forms. Well, to do that, we'll just use GCD, greatest common divisor. Here's a little implementation.

从有理数的实现出发，让我们想想如何解决这个问题。问题是什么？我们并没有完全有理化整个东西，特别是没有将计算出的有理数约简到最简形式。如何修复？最简单的方法是找到分子和分母的最大公约数，并将两部分都除以它，以使其变小，约简到最小的可能形式。为此，我们将使用GCD，即最大公约数。这里有一个小实现。

### 10. Alternative representations: reducing by computation in selectors or at construction / Consequences of violating the data abstraction and overall principle (替代表示：在选择器或构造时通过计算进行约简 / 违反数据抽象及总体原则的后果)

divisor here's a little implementation of it, it's a simple little recursive call that will compute the greatest common divisor of a and B. You can check it out for yourself to convince yourself it does the right thing. Now we can use that to make better rationals.

除数，这里有一个小实现，它是一个简单的递归调用，将计算a和B的最大公约数。你可以自己验证它是否正确。现在我们可以用它来构造更好的有理数。

And here we have a choice. The first strategy says: let's remove the common factors whenever we actually access numer and denom, that is, will make the rationals the normal way, but when somebody asks for a part, will actually reduce it then. So here's a new implementation: make-rat looks just as...

这里我们有一个选择。第一种策略说：当我们实际访问numer和denom时，就移除公因子，也就是说，我们将以正常方式构造有理数，但当有人请求一个部分时，我们将在那时进行约简。所以这里是一个新的实现：make-rat看起来和之前一样……

implementation make-rat looks just as before, it's constructing them together, but numeron and de nom will first compute the GCD of the parts, the car in the quarter the way we've glued it together, and then will give us back out the right answer.

实现make-rat看起来和之前一样，它只是将它们构造在一起，但numer和denom将首先计算各部分的GCD，即我们粘合在一起的car和cdr，然后返回正确的答案。

that is the first element or the second element, respectively, divided by that greatest common divisor. This will in fact fix our previous problem. Now when we add 1/2 to 3/4, and we go off and get new marauder nom, we'll get back the right answer, which is 5/4.

即第一个元素或第二个元素，分别除以最大公约数。这实际上将修复我们之前的问题。现在当我们把1/2加到3/4上，然后去获取新的numer和denom时，我们将得到正确的答案，即5/4。

Also notice that since every operation we're building on

还要注意，由于我们构建的每个操作都基于

every operation we're building on rationals uses the selectors, it means that every other operation still will work correctly. All we have to change is numeron to know every operation built on top of that runs as before, but now inherits the correct behavior. This is exactly the reason why we separate out the use of an abstraction from the implementation of the abstraction. The selectors and constructors are basically the only procedures that can cross over that barrier, and as long as we make a consistent contract between them, use above will still work correctly.

我们构建的每个有理数操作都使用选择器，这意味着所有其他操作仍然能正确工作。我们只需更改numer和denom，所有基于其上的操作都会像以前一样运行，但现在继承了正确的行为。这正是我们将抽象的使用与抽象的实现分开的原因。选择器和构造器基本上是唯一能跨越这个障碍的过程，只要我们确保它们之间有一致的契约，上面的使用仍然能正确工作。

Above will still work correctly and to drive that point home here's another way of making rational rationals. Now the strategy could be to remove the common factors when we actually create the rational number. In this case, numeron de nom will behave as before, the car encoder of something glued together.

上面的使用仍然能正确工作，为了强调这一点，这里有另一种构造有理有理数的方法。现在的策略可以是在实际创建有理数时移除公因子。在这种情况下，numer和denom将像之前一样行为，即取粘合在一起的car和cdr。

But now when we construct the rational, that is when we call make-rat, we'll compute the GCD of the two inputs and construct something that already takes those factors out. As before, the contract still works. Many anything that was relying on...

但现在当我们构造有理数时，即调用make-rat时，我们将计算两个输入的GCD，并构造一个已经去除这些因子的东西。和之前一样，契约仍然有效。任何依赖于……

many anything that was relying on numeron all and make rat still works we have not had to change any of that code but we've inherited the new behavior why would we have alternatives well it depends on efficiency if we're going to be using rationals a lot we might want to do the rationalization when we construct that way saving the computational cost in numeron Dena if we're using the opposite direction we could take the alternative choice to finish making this point think about what would happen if we didn't put in the data abstraction between numeron to nam make-rat cons car

任何依赖于numer、denom和make-rat的东西仍然有效，我们不必更改任何这些代码，但我们已经继承了新的行为。为什么我们会有替代方案？这取决于效率。如果我们打算大量使用有理数，我们可能希望在构造时进行约简，从而节省numer和denom中的计算成本。如果我们使用相反的方向，我们可以选择另一种方案。为了完成这一点，想想如果我们不在numer、denom、make-rat、cons、car和cdr之间放置数据抽象，会发生什么。

between numeron to nam make-rat cons car and quitter for example here's our version of plus rap that we had before. let's suppose instead of nicely separating out the data abstraction from its use we had implemented it directly in car and cooter well here's that implementation looks just like before. I've just stripped away this silly abstraction and just put in the raw const car encoder everything looks just as before but now we decide that we need to deal with this GCD issue we've got to factor out that thing look at what we have to do to change plus rap we've got

在numer、denom、make-rat、cons、car和cdr之间放置数据抽象，例如，这是我们之前的plus-rat版本。假设我们没有将数据抽象与其使用干净地分开，而是直接使用car和cdr实现它。那么这里就是那个实现，看起来和之前一样。我只是去掉了这个愚蠢的抽象，直接放入了原始的cons、car、cdr。一切看起来和之前一样，但现在我们决定需要处理这个GCD问题，我们必须提取出那个东西。看看我们必须做什么来更改plus-rat：我们不得不……

have to do to change plus rap we've got to go in and actually get out the new version of numerator denominator by figuring out what are the right pieces to pull together getting the GCD and doing a lot of work it's not just the amount of work that matters it's the fact that this is very hard code to follow how do we know what are the right places to match what is the car corresponding to how do we be certain that we've actually done the right pieces in all of this the point is that we have here what's known as a big abstraction violation that is by mixing

不得不更改plus-rat，我们必须实际进入并获取新的分子分母版本，通过找出正确的部分来组合，获取GCD并做大量工作。重要的不仅仅是工作量，而是这是非常难以理解的代码。我们怎么知道哪些地方是匹配的？car对应什么？我们如何确定我们确实在所有地方都做了正确的修改？关键在于，我们这里有一个所谓的重大抽象违反，即通过将实现细节与使用混合，通过不强烈地将抽象的使用与实际实现细节分开，我们招致了困难，招致了在修改这些抽象时产生混淆的机会。我们无法保证我们做了正确的修改，也无法保证我们在所有正确的地方都做了修改。

Abstraction violation that is by mixing the implementation details with the use, by not strongly separating out the use of the abstraction from the actual implementation details. We've invited difficulties, we've invited the opportunity to have confusions as we go in to change those abstractions. We can't guarantee we've made the right changes, nor that we've made them in all the right places.

抽象违反，即通过将实现细节与使用混合，通过不强烈地将抽象的使用与实际实现细节分开，我们招致了困难，招致了在修改这些抽象时产生混淆的机会。我们无法保证我们做了正确的修改，也无法保证我们在所有正确的地方都做了修改。

In particular, not only will we have to change plus rat, we'd have to go change multiply rat and any other operation that uses rationals to make sure that they do this work in the.

特别是，我们不仅必须更改plus-rat，还必须去更改multiply-rat以及任何其他使用有理数的操作，以确保它们也完成这项工作。

Sure that they do this work in the previous case, we simply change the selectors and we got the performance we wanted. So the overall point is when we build data abstractions, we will separate the use of that abstraction from the details of how we build it.

当然，在之前的情况下，我们只需改变选择器，就能获得所需的性能。因此，总体要点是，当我们构建数据抽象时，我们将把该抽象的使用与构建它的细节分离开来。

That separation puts in clean boundaries that allow us to think about the uses of the objects without being confused by details, and also allows us to cleanly, ultimately create new implementations of those abstractions, creating new behaviors that are automatically inherited by procedures that simply rely.

这种分离设置了清晰的边界，使我们能够在不被细节困扰的情况下思考对象的使用，同时也使我们能够最终干净地创建这些抽象的新实现，产生新的行为，而这些行为会被那些仅仅依赖这些抽象的过程自动继承。

inherited by procedures that simply rely

被那些仅仅依赖这些抽象的过程自动继承