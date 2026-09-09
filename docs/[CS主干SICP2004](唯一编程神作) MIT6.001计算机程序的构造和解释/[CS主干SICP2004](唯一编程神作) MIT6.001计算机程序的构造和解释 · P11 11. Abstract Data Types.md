# Video Transcript (视频转录)
[视频链接](https://www.bilibili.com/video/BV1TX4y157hX?p=11)

## Summary (摘要)

- Data abstraction separates the use of a data type from its implementation, improving modularity and robustness over raw efficiency.
- A table is defined by its interface: make, put, and get operations, with contracts that must hold regardless of representation.
- Association lists are simple but expose implementation details, breaking modularity; adding a type tag and hiding operations creates an abstraction barrier.
- A hash table built on vectors and hash functions improves lookup efficiency while keeping the user interface identical.
- Choosing between implementations depends on usage patterns: one is faster for few lookups, the other scales better for large tables.
- The key lesson is to separate abstract operations from internal definitions, enabling change without affecting users.

- 数据抽象将数据类型的使用与其实现分离，提高了模块性和健壮性，而非原始效率。
表由其接口定义：make、put 和 get 操作，且无论表示方式如何，这些契约都必须成立。
关联列表简单但暴露了实现细节，破坏了模块性；添加类型标签并隐藏操作创建了抽象屏障。
基于向量和哈希函数构建的哈希表提高了查找效率，同时保持用户界面不变。
在实现之间进行选择取决于使用模式：一种在少量查找时更快，另一种在大型表时扩展性更好。
关键教训是将抽象操作与内部定义分离，从而在不影响用户的情况下进行更改。

## Outline (大纲)

1. Introduction: Data Abstraction and Trade-offs / Concrete vs Abstract Structures and Robustness / Plan for Today: Three Structures Toward a Table
2. Table Concepts and Abstract Interface
3. Practical Uses and Flexibility of Tables
4. Association Lists as Representation
5. Shadowing and Efficiency Concerns in A-Lists / A-Lists Lack Modularity: Need for Information Hiding
6. Building a Named Table with Constructors and Selectors
7. Abstraction Barrier and Opaque Names
8. Motivation for Hash Tables
9. Hash Table Implementation with Vectors
10. Comparative Analysis and Key Lesson

1. 引言：数据抽象与权衡 / 具体结构与抽象结构及健壮性 / 今日计划：迈向表的三种结构
表的概念与抽象接口
表的实际用途与灵活性
关联列表作为表示
A-列表中的遮蔽与效率问题 / A-列表缺乏模块性：需要信息隐藏
使用构造函数和选择器构建命名表
抽象屏障与不透明名称
哈希表的动机
使用向量实现哈希表
比较分析与关键教训

## Transcript (转录)

### 1. Introduction: Data Abstraction and Trade-offs / Concrete vs Abstract Structures and Robustness / Plan for Today: Three Structures Toward a Table (引言：数据抽象与权衡 / 具体结构与抽象结构及健壮性 / 今日计划：迈向表的三种结构)

In the past couple of lectures, we've introduced the concepts of data abstractions, types, and aggregate structures. What we want to do today is spend some time pulling those pieces together to explore the idea of data abstraction in more detail.

在过去的几节课中，我们介绍了数据抽象、类型和聚合结构的概念。今天我们要做的是花一些时间将这些部分整合起来，更详细地探讨数据抽象的思想。

In doing this, we're going to examine a couple of particular examples, but what we really want you to see is how, in designing any data structure—in fact, in any language, not just in Scheme—we have a trade-off. The trade-off is between concrete structures that are very...

为此，我们将研究几个具体的例子，但我们真正希望你们看到的是，在设计任何数据结构时——实际上在任何语言中，不仅仅是 Scheme——我们都会面临一种权衡。这种权衡存在于非常具体且高效但容易被误用的结构，与能够很好地将实现与使用隔离但可能效率低下的抽象结构之间。

在过去的几节课中，我们一直在探讨相关主题的基础框架。

在过去的几节课中，我们一直在探讨相关主题的基础框架。

concrete structures that are very efficient but prone to misuse versus abstract structures that nicely insulate the implementation from its use but which may suffer from efficiency issues

具体结构非常高效但容易被误用，而抽象结构则能很好地将实现与使用隔离，但可能面临效率问题。

this may sound a bit odd the typical instinct especially for a less experienced programmer is stop for efficiency you want code that really motors right

这听起来可能有点奇怪，特别是对于经验较少的程序员来说，典型的直觉是追求效率，希望代码能够快速运行。

but in fact if you're building parts of a big system that will involve use over extended periods of time like years or decades and that will involve components from a large number of users then robustness modularity and

但实际上，如果你正在构建一个大型系统的组成部分，该系统将在很长一段时间内（如数年或数十年）被使用，并且涉及大量用户，那么健壮性、模块性和易用性通常比速度重要得多。

of users then robustness modularity and ease of use are typically much more important than speed so today we're going to do an initial exploration of this idea

用户的健壮性、模块性和易用性通常比速度重要得多，所以今天我们将对这一思想进行初步探索。

we're going to examine three different kinds of data structures that move from concrete to abstract culminating in the creation of a table data structure

我们将研究三种不同的数据结构，它们从具体走向抽象，最终创建出一个表数据结构。

will also see how design choices influence the implementation of an abstract data structure with different kinds of performance and we'll see that the fundamental issue for designing abstract data types is using this methodology to hide information

我们还将看到设计选择如何影响抽象数据结构的实现，带来不同的性能表现，并且我们将看到设计抽象数据类型的基本问题在于使用这种隐藏信息的方法论。

this methodology to hide information both in the types and in the code okay

这种方法论在类型和代码中隐藏信息，好的。

### 2. Table Concepts and Abstract Interface (表的概念与抽象接口)

here's where we're headed we would like to build an abstract data structure of a table now conceptually a table is just a collection of bindings and we're free to think about different ways of structuring that collection and what's a binding

这就是我们的目标：我们希望构建一个抽象的表数据结构。从概念上讲，表只是绑定的集合，我们可以自由地考虑不同的方式来组织这个集合。什么是绑定？

it's just a pairing of a key and a value or in other words the key tells us the entry into the table or how to find something in the table and the value tells us the thing that's actually associated with that key now we could

它只是键和值的配对，换句话说，键告诉我们表的入口或如何在表中找到某物，而值告诉我们与该键实际关联的内容。现在我们可以

associated with that key now we could define the behavior we want a table to have without having to consider the specifics of the implementation so in particular we want the following abstract interface between a user of a table and the table itself first we need a constructor for building the table we'll just call that make as we're saying we're going to ignore for now the issues of how it's done we can just use make as a user to say give me a new table and it will we need a way of inserting something into a table a binding into the table will assume that

与该键关联的内容。现在我们可以定义表应有的行为，而不必考虑实现的具体细节。特别是，我们希望在表的用户和表本身之间有以下抽象接口：首先，我们需要一个构造函数来构建表，我们称之为 make。我们暂时忽略它是如何实现的，作为用户，我们可以使用 make 来请求一个新表。我们需要一种将绑定插入表的方法，我们将假设

Binding into the table will assume that such an assertion replaces any previous binding for that key, and also note that we don't say whether the old binding is actually physically removed from the table or whether the new binding simply shadows the old one.

将绑定插入表时，我们假设这种断言会替换该键的任何先前绑定，并且注意，我们不说明旧绑定是否从表中物理移除，还是新绑定只是遮蔽了旧绑定。

Why is this relevant? Well, notice that there's likely to be a trade-off here of efficiency in space—whether we keep the old bindings around—versus efficiency in time—how quickly we can add new bindings—and whether keeping old bindings around adversely affects our ability to recover.

为什么这很重要？请注意，这里可能存在空间效率（是否保留旧绑定）与时间效率（添加新绑定的速度）之间的权衡，以及保留旧绑定是否会影响我们恢复绑定的能力。

adversely affects our ability to recover bindings, so at this stage all we said is that put will take a key and a value, create a new binding, put it into the table, and replace the previous binding some way so that we can't get at it.

影响我们恢复绑定的能力，所以在这个阶段，我们只说 put 将接受一个键和一个值，创建一个新绑定，将其放入表中，并以某种方式替换先前的绑定，使我们无法再访问它。

Of course, we need a way of getting things out of the table, so we'll have another abstract interface called get that takes as input a key, looks up the key in the table, and returns the corresponding value. Let's stress again: we've said nothing about how to implement this. From a user's perspective, this is all they need to know, so long as

当然，我们需要一种从表中获取内容的方法，所以我们会有另一个抽象接口叫做 get，它接受一个键作为输入，在表中查找该键，并返回相应的值。再次强调：我们还没有说明如何实现。从用户的角度来看，这就是他们需要知道的一切，只要

This is all they need to know, so long as the contracts for this data abstraction hold. And this, in fact, is a really important point. This definition of an interface to a table really does, in fact, define the abstract data type of a table. From the user's perspective, using these interface abstractions is sufficient to enable them to make use of a table and have it do the right thing.

这就是他们需要知道的一切，只要这个数据抽象的契约成立。而这实际上是一个非常重要的点。这个对表接口的定义确实定义了表的抽象数据类型。从用户的角度来看，使用这些接口抽象就足以让他们能够使用表并使其正确工作。

The details—the code we're about to show—will be an implementation of this abstract data type. But of course, there can be alternative ones, and that's one of the key aspects of this approach.

细节——我们即将展示的代码——将是这个抽象数据类型的一种实现。但当然，可以有其他的实现，这正是这种方法的关键方面之一。

alternative ones and that's one of the points we want to look at nonetheless. This abstract interface really defines a contract between the insertion and retrieval of bindings in a table as well as what kinds of things the table is going to hold.

其他的实现，这正是我们想要考察的要点之一。这个抽象接口确实定义了在表中插入和检索绑定之间的契约，以及表将容纳哪些种类的内容。

### 3. Practical Uses and Flexibility of Tables (表的实际用途与灵活性)

Before we get into the different kinds of data structures that will lead up to a table, let's first think about why they might be useful in obvious places in keeping track of things like personnel data, for example. Suppose you've just started up a wonderful new comm company of some sort; one of the things you might want to do

在我们深入探讨通向表的各种数据结构之前，让我们先想想它们在显而易见的地方可能有什么用处，比如在跟踪人事数据方面。假设你刚刚创办了一家很棒的新通信公司；你可能想做的一件事是……

One of the things you might want to do is have a database of the people who are going to be working for you, so you can keep that obviously in the table, just listed by or keyed by the names of the people that are your employees now.

你可能想做的一件事是拥有一个将要为你工作的员工的数据库，这样你就可以把它放在表中，按当前员工的姓名作为键来列出。

Associated with each key in our table, where key here is the name of a person and employee, we might have another table that lists information about that person: what their age is, what their job title is, how much they get paid, and of course, associated with that might be other information that also will be listed in.

与表中的每个键相关联——这里的键是员工的名字——我们可能还有另一个表，列出关于该人的信息：他们的年龄、职位、薪水，当然，与之相关的可能还有其他信息也会被列出。

information that also will be listed in tables, for example pay structures over the last year or last few years. Not only do our table data abstractions need to be flexible enough to allow for tables to be entries within the components of a table, as we've just seen, but we may have other ways of trying to gather information together in a table system.

这些信息也会列在表中，例如过去一年或几年的薪酬结构。我们的表数据抽象不仅需要足够灵活，以允许表作为表组件中的条目，正如我们刚才看到的，而且我们可能还有其他方式在表系统中收集信息。

For example, we might have another table within our system that lists the ages of all the employees in the company. Certainly, we can build a table where the keys are the ages of the employees here, however the value associated with it

例如，我们可能在系统中有另一个表，列出公司所有员工的年龄。当然，我们可以构建一个表，其中键是员工的年龄，然而与之关联的值……

However, the value associated with it might be something like a list, which we've obviously seen how to build, where the entries of the list point to entries in other tables that are the actual data structures of the people of that particular age. So we see that our tables need to be very flexible, and if they are, they can contain a lot of very valuable information that should be easy to manipulate.

然而，与之关联的值可能是类似列表的东西，我们显然已经知道如何构建列表，其中列表的条目指向其他表中的条目，这些条目是特定年龄的人的实际数据结构。所以我们看到我们的表需要非常灵活，如果它们灵活，它们就能包含大量有价值的信息，并且应该易于操作。

### 4. Association Lists as Representation (关联列表作为表征)

Let's start by looking at the idea of pairing keys and values. This is going to be the heart of a table implementation, and we want to see how.

让我们从考察键和值配对的想法开始。这将是表实现的核心，我们想看看如何……

Implementation and we want to see how different choices influence the way in which that table will behave. A traditional structure for doing this is called an A List or an association list. This is a list in which each element is itself a list of a key and a value, or in other words, it's a list of lists, all of which are two elements long.

实现，我们想看看不同的选择如何影响表的行为方式。一种传统的结构称为A列表或关联列表。这是一个列表，其中每个元素本身是一个键和值的列表，换句话说，它是一个列表的列表，所有列表都有两个元素长。

So for example, if we want to represent this table, and notice this is an abstract definition, it's simply a binding of x + 15 + y + 20. If we want to represent this abstract table as an association list, we can represent it by this list of lists.

例如，如果我们想表示这个表，注意这是一个抽象定义，它只是x + 15 + y + 20的绑定。如果我们想将这个抽象表表示为关联列表，我们可以用这个列表的列表来表示。

can represent it by this list of Lists, each of the inner lists is two elements long and contains the key and the value.

可以用这个列表的列表来表示，每个内部列表有两个元素长，包含键和值。

Or to do this a little more concretely, we could represent this particular table with the following box and pointer structure, the following list of lists.

或者更具体地做这件事，我们可以用下面的盒子和指针结构来表示这个特定的表，即下面的列表的列表。

And you can see the nice structure here, in which each element of the top-level list is a binding, and each of the bindings is just a list of the name and the value, just as the first and second element of a two element long list.

你可以看到这里漂亮的结构，其中顶层列表的每个元素是一个绑定，每个绑定只是一个名称和值的列表，就像两元素长列表的第一个和第二个元素一样。

If we were to make the design choice to use a

如果我们做出设计选择，使用……

were to make the design choice to use a lists as our representation for a table then we just need a couple of operations first of all we'll need to have a way of finding an entry for a key and returning the associated value okay here's the definition for something that would do it let's call it find associate takes in a key and an a-list and what's it do well it basically walks down the a-list looking to see if the first element of that list has a key value that equals the key passed in and note how it does it we have the usual check to see if you've got an

如果我们做出设计选择，使用列表作为我们表的表征，那么我们只需要几个操作。首先，我们需要一种方法来找到键的条目并返回关联的值。好的，这是做这件事的定义，让我们称之为find-assoc，它接受一个键和一个A列表，它做什么呢？它基本上遍历A列表，查看该列表的第一个元素是否有一个键值等于传入的键，注意它是如何做的，我们有通常的检查，看是否……

And note how it does it — we have the usual check to see if you've got an...

注意它是如何做的——我们有通常的检查，看是否……

usual check to see if you've got an empty list in which case we're going to return false saying that the key is not in the list otherwise we use equal to test whether the key is the same as and oh there's that funny car of a car of something so the first car gets out the first element of the a list and the second car will get out the key if those two things are equal we will then return the value associated with that key and if you go back and look at the data structure in the previous slide you'll see that the Kedar does the right thing.

通常的检查，看是否有一个空列表，在这种情况下我们将返回false，表示键不在列表中，否则我们使用equal来测试键是否相同，哦，那里有那个奇怪的car of car of something，所以第一个car取出A列表的第一个元素，第二个car将取出键，如果这两个东西相等，我们将返回与该键关联的值，如果你回头看看上一张幻灯片中的数据结构，你会看到Kedar做了正确的事情。

see that the Kedar does the right thing and of course if this element isn't something that matches the key we'll move on to the next portion of the a list and continue looking for the thing that does match as an example let's give a name to our little simple ace list that we did previously call it a 1 notice the use of the quote in front of the list structure to get the list structure out exactly as we'd expect we saw this a couple of lectures ago then doing find a sock on a1 with the key Y will return the value of 20 and you should trace through the code here

看到Kedar做了正确的事情，当然如果这个元素不是匹配键的东西，我们将移动到A列表的下一个部分，继续寻找匹配的东西。作为一个例子，让我们给我们之前做的简单A列表起个名字，称之为a1，注意在列表结构前面使用引号来得到列表结构，正如我们所期望的，我们在几节课前看到了这个，然后在a1上对键Y做find-assoc将返回值20，你应该在这里追踪代码。

should trace through the code here to see why it does the right thing, particularly looking back at the blocks and pointer structure to see how it walks its way down the list looking for the right piece adding a new entry into.

应当仔细追踪这里的代码，以理解它为何能正确工作，尤其要回顾块和指针结构，看它如何沿着列表向下查找正确的条目并添加新条目。

this a list is pretty easy well just concert on the front all we have to do is take the key in the value that we want to associate together glue them together making a list out of them since that's how we're putting them into the a list and then just constant onto the front of the a list since the a list is

这个列表相当简单，我们只需将键和值关联起来，把它们粘合在一起构成一个列表，因为这就是我们放入关联列表的方式，然后将其常量添加到关联列表的前端，因为关联列表本身是……

### 5. Shadowing and Efficiency Concerns in A-Lists / A-Lists Lack Modularity: Need for Information Hiding (关联列表中的遮蔽与效率问题 / 关联列表缺乏模块性：需要信息隐藏)

front of the list since the list is itself a list, a concept something on the list will give us back a list, so this will have the right form. Note that in this implementation, we don't actually remove the old value from the list; we just shadow it with a new one.

列表的前端，因为列表本身就是一个列表，将某物添加到列表上会返回一个列表，因此这将具有正确的形式。注意，在此实现中，我们实际上并未从列表中移除旧值；我们只是用新值将其遮蔽。

Why is that right? Well, given how we've implemented find a sock, we're guaranteed to see only the most recent binding—the one at the front—and if that means anything, it's that things further down will simply hang around as part of the list but never be accessible. Of course, you might think about what this does to the efficiency of finding a sock.

为什么这是正确的？嗯，鉴于我们实现查找的方式，我们保证只会看到最近的绑定——即最前面的那个——这意味着更后面的绑定只会作为列表的一部分存在，但永远不会被访问。当然，你可能会思考这对查找效率的影响。

this does to the efficiency of finding a sock, for example, if we have to find a binding that was added early on, but where the list has had a lot of other things added to shatter that one, what will happen to the efficiency?

这对查找效率的影响，例如，如果我们要查找一个早期添加的绑定，但列表中添加了许多其他条目遮蔽了它，那么效率会怎样？

nonetheless, here's a nice little implementation. so for example, we can add a new binding to our old table, a1, will add us an association of Y in 10 - that will give it another name, call it a2. notice we need to do this because we need to have a way of referring to the table. now a2 has a this structure that is three two-element

尽管如此，这里有一个不错的实现。例如，我们可以向旧表 a1 添加一个新绑定，添加一个 Y 到 10 的关联——这将给它另一个名字，称为 a2。注意我们需要这样做，因为我们需要一种引用表的方式。现在 a2 具有这种结构，即三个两元素……

This structure that is three two-element long lists with our new binding of why at the front and are all binding ally stinging still hanging around at the end. If we call find a sock with the key why on this new table, notice will return the value 10. And you ought to convince yourself with that by looking at the code from the previous slide. So this looks like a pretty nice little implementation.

这种结构是三个两元素长的列表，新的绑定 Y 在前端，而所有旧的绑定仍然挂在末尾。如果我们用键 Y 在这个新表上调用查找，注意将返回值 10。你应该通过查看上一张幻灯片的代码来说服自己。所以这看起来是一个相当不错的实现。

But let's think about this structure in particular. This is not an abstract data type, and here's why: first of all, we have no constructor here—we're just building the list using list.

但让我们特别思考一下这个结构。这不是一个抽象数据类型，原因如下：首先，我们这里没有构造函数——我们只是使用列表操作来构建列表。

We're just building the list using list operations or quotes. This looks like a nice quick way of doing things, but it has an important impact. In particular, there's no abstraction barrier here. That means that there's no way of separating out the implementation of an A List and the manipulation of it from the use of the A List. In fact, A Lists are designed that way. The definition in the Scheme manual says an A List is a list of pairs, each of which is called an association. The car of that association is called the key, so it's intended in fact to just.

我们只是使用列表操作或引用来构建列表。这看起来是一种快速简便的方法，但它有一个重要的影响。特别是，这里没有抽象屏障。这意味着无法将关联列表的实现和操作与关联列表的使用分离开来。事实上，关联列表就是这样设计的。Scheme 手册中的定义说，关联列表是一个对列表，每个对称为一个关联。该关联的 car 称为键，因此它实际上就是……

the key so it's intended in fact to just be an exposed list as a consequence the implementation is exposed meaning that the user can go in and operate on the a list just using list operations we could go in and do things like this it looks nice and convenient but in fact is a dangerous thing to do

键，因此它实际上就是暴露的列表。结果是实现是暴露的，这意味着用户可以直接使用列表操作来操作关联列表。我们可以做类似这样的事情，看起来方便，但实际上这样做是危险的。

and let's talk about that in the next slide so why do we care why do we care that a lists are not an abstract data type there are a lot of reasons but the primary one is because of modularity this is something that's absolutely key to good software

让我们在下一张幻灯片中讨论这个问题。为什么我们关心关联列表不是抽象数据类型？有很多原因，但主要原因是模块性。这是优秀软件的关键。

that's absolutely key to good software engineering and software design we want to build a program that has created the modules that we can glue together that we can treat as blackbox abstractions and manipulate.

这是优秀软件工程和软件设计的关键。我们希望构建一个程序，其中创建了模块，我们可以将它们粘合在一起，将它们视为黑盒抽象并进行操作。

the real reason we want that is because it will allow us to change one module without having to change any of the rest.

我们真正想要这样做的原因是，它将允许我们更改一个模块而不必更改其他任何模块。

and why does that matter here because a lists have for modularity since we have exposed the basic guts of the implementation to the outside.

为什么这在这里很重要？因为关联列表缺乏模块性，因为我们向外部暴露了实现的基本内部结构。

it means that other people could write programs that use operations like filter and map directly on the a list.

这意味着其他人可以编写直接对关联列表使用 filter 和 map 等操作的程序。

filter and map directly on the a list. There is no way of separating out the use of the table from the implementation of the table. If later on we decide to change the implementation of the table, we may be screwed because these operations are assuming that a lists are the basic implementation. They're assuming that they can do these kinds of operations too onto the table.

直接对关联列表使用 filter 和 map。无法将表的使用与表的实现分离开来。如果以后我们决定更改表的实现，我们可能会陷入困境，因为这些操作假设关联列表是基本实现。它们假设可以对表进行这些类型的操作。

As a consequence, if you decide to create a different table structure, you're going to have to go through and change every piece of code that manipulates it. And how do we do this?

因此，如果你决定创建不同的表结构，你将不得不遍历并更改所有操作它的代码。那么我们该怎么做呢？

that manipulates and how do we do this well basically we're going to hide information to get good modularity we're going to hide details in particular we'll hide the fact that the table is implemented as a list we'll separate that out from the use of the table this has two parts the first part is that will then create new kinds of abstractions to get at the parts of the table new constructors and selectors and will insist that in fact anything outside of the internal implementation and the other part of the program cannot use list operations but has to use those

操作它的所有代码，我们该怎么做呢？基本上，我们将隐藏信息以获得良好的模块性。我们将隐藏细节，特别是隐藏表实现为列表的事实。我们将把它与表的使用分离开来。这有两个部分：第一部分是创建新的抽象来访问表的各个部分，即新的构造函数和选择器，并且坚持要求内部实现之外的任何东西都不能使用列表操作，而必须使用这些……

Use list operations but has to use those abstract interfaces. This is exactly what abstract data types are about. There are techniques for allowing us to create clean interfaces between the internals of an abstraction and the use of the abstraction, and we want to be disciplined in how we enforce this.

不能使用列表操作，而必须使用这些抽象接口。这正是抽象数据类型的意义所在。有一些技术允许我们在抽象的内部和抽象的使用之间创建清晰的接口，我们希望在执行这一点上保持纪律。

### 6. Building a Named Table with Constructors and Selectors (使用构造函数和选择器构建命名表)

So let's build on this idea. We know that we should be able to use a list to represent the internal structure of the table, but we need to do this hiding of information, this separation between the internals of the table and the outside world. And here's how we'll do it.

让我们在这个想法的基础上构建。我们知道应该能够使用列表来表示表的内部结构，但我们需要进行这种信息隐藏，这种表内部与外部世界之间的分离。下面是我们将如何做到这一点。

world and here's how we'll do it. First we'll need a constructor make table. I'll call a make table one because we're going to do different versions of this, and this will simply put a tag on front of a table structure. And we've given a definition of table one tag to be the quoted symbol table one, just to give us something.

世界，我们将这样做。首先，我们需要一个构造函数 make-table。我将其称为 make-table-one，因为我们将制作这个函数的不同版本，而这将简单地在表结构前面加上一个标签。我们已经给出了 table-one-tag 的定义，即带引号的符号 table-one，只是为了给我们一些东西。

Now we can create a get operation on a table by saying, given a table, remove the tag, get the actual table implementation, and then use find a sock to look up the key in that table. So we're using a representation of an A

现在我们可以通过在表上创建一个获取操作来实现，即给定一个表，移除标签，获取实际的表实现，然后使用 find-assoc 在该表中查找键。因此，我们使用一个 A 列表的表示作为表的内部部分。

我们使用一个A列表的表示作为表格的内部部分。要向表格中添加新内容，我们可以再次获取整个表格（除了标签之外），也就是那个A列表，然后像之前一样使用add-assoc操作，将一个新的键值对添加到该列表中。这会为我们返回一个新的列表，即包含新绑定项的A列表。

我们使用一个 A 列表的表示作为表格的内部部分。要向表格中添加新内容，我们可以再次获取整个表格（除了标签之外），也就是那个 A 列表，然后像之前一样使用 add-assoc 操作，将一个新的键值对添加到该列表中。这会为我们返回一个新的列表，即包含新绑定项的 A 列表。

我们唯一需要做的另一件事就是把标签重新放回表格上，我们可以使用一个不寻常的操作来完成，这个操作我们将在几节课后再回来讨论。这个新操作就是set-car，或者你可以把它理解为——

我们唯一需要做的另一件事就是把标签重新放回表格上，我们可以使用一个不寻常的操作来完成，这个操作我们将在几节课后再回来讨论。这个新操作就是 set-car，或者你可以把它理解为——

The operation set could be thought of as taking the box and pointer structure pointed to by the argument or the value of tbo, finding the cutter of that pair, and changing that pointer to point to this new structure, this new list. We're not going to worry too much about this new operation.

set 操作可以被认为是取参数或 tbo 的值所指向的盒子和指针结构，找到该对的 car，并将该指针更改为指向这个新结构、这个新列表。我们不会过多担心这个新操作。

We simply want to take note of the fact that we can add a new table or a new Association list to the tag and return that as the value of the whole thing. So let's see how this works if you need to flip back to the previous slide to check out the code.

我们只需注意到，我们可以向标签添加一个新的表或一个新的关联列表，并将其作为整个事物的值返回。所以，让我们看看这是如何工作的，如果你需要翻回上一张幻灯片查看代码。

previous slide to check out the code as we go along first let's create a table we'll define tag table 1 or TT 1 to be the new table we get by using the constructor here's what that looks like TT 1 points to a list structure the car of that list is the symbol table 1 that was our tag that we put in there and the coder is just the empty list we don't have anything in that a list yet

上一张幻灯片查看代码，我们继续。首先，让我们创建一个表，我们将定义 tag-table-1 或 TT1 为我们通过使用构造函数得到的新表。这是它的样子：TT1 指向一个列表结构，该列表的 car 是符号 table-1，那是我们放入的标签，而 cdr 只是空列表，我们还没有在该 A 列表中放入任何内容。

now let's put a new appearing or a new binding of a key in a value into our table so let's put the binding of Y and xx into our table so what happens well table put uses add a sock it gets out

现在让我们向表中添加一个新的出现或键和值的新绑定，所以让我们将 Y 和 20 的绑定放入表中。那么会发生什么？table-put 使用 add-assoc，它取出

table put uses add a sock it gets out everything but the tag type that is the empty list and it creates a new binding of the symbol y and the value 20 as an association list and causes that onto the front of it creating this structure.

table-put 使用 add-assoc，它取出除标签类型之外的所有内容，即空列表，并创建符号 y 和值 20 的新绑定作为关联列表，并将其 cons 到前面，创建这个结构。

Then we use this new operation to take the box pointed to by TT 1 and mutate or change its cutter to point to this new structure. Notice what we have now: we have a new table it has a tag on the front and it has an a list at the back that has one binding in it. Now let's add another thing to our table.

然后我们使用这个新操作来获取 TT1 指向的盒子，并修改或更改其 cdr 以指向这个新结构。注意我们现在有什么：我们有一个新表，前面有标签，后面有一个 A 列表，其中包含一个绑定。现在让我们向表中添加另一个东西。

let's add another thing to our table let's put the binding for X and 15 into the same table again if you look back at the code you can see what this does add a sock first takes the table part of the table that is removes the tag and gets that structure pointed to by in blue it then creates a new binding a pairing of X and 15 as a to list and conses that on to the front of this new structure as shown here in red this new structure is our new a list and it has in it 2 bindings and then we once more use that set cutter operation to take the thing

让我们向表中添加另一个东西，让我们将 X 和 15 的绑定放入同一个表中。如果你再看一下代码，你可以看到这是做什么的：add-assoc 首先取出表的表部分，即移除标签并获取蓝色指向的结构，然后创建一个新的绑定，将 X 和 15 配对作为 A 列表，并将其 cons 到这个新结构的前面，如红色所示。这个新结构是我们的新 A 列表，其中包含 2 个绑定，然后我们再次使用 set-cdr 操作来获取

set cutter operation to take the thing

set-cdr 操作来获取

set cutter operation to take the thing point it to by T t1 and change its coder point it to by T t1 and change its coder point it to by T t1 and change its coder to point to this new value removing the to point to this new value removing the to point to this new value removing the old binding so we now have a new a list

set-cdr 操作来获取 TT1 指向的东西，并更改其 cdr 以指向这个新值，移除旧绑定，因此我们现在有一个新的 A 列表

old binding so we now have a new a list old binding so we now have a new a list associated with this table if we get a value out of the table that is we get the pairing associated with the binding of Y from this table table get does a very similar thing

旧绑定，因此我们现在有一个新的 A 列表与此表关联。如果我们从表中获取一个值，即我们获取与 Y 的绑定关联的配对，table-get 做了非常类似的事情

in particular it removes the tag gets the pointer to the a list and then use this find a sock on that a list

特别是，它移除标签，获取指向 A 列表的指针，然后在该 A 列表上使用 find-assoc

find the value associated with this key and return that value just like before so now we have a nice little

找到与该键关联的值并返回该值，就像之前一样。所以现在我们有一个漂亮的小

so now we have a nice little implementation of a table with the tag out front with some constructors and selectors associated with that table and using inside of this table and a list to actually do the representation of bindings of keys and values.

所以现在我们有一个漂亮的小表实现，前面有标签，有一些与该表关联的构造函数和选择器，并在该表内部使用 A 列表来实际表示键和值的绑定。

### 7. Abstraction Barrier and Opaque Names (抽象障碍与不透明名称)

now what is it that makes a table one an abstract data type first it has a type tag well that's careful programming with that alone is not enough to turn it into an ADT what else it has a constructor again having a separate interface is a help but that's not sufficient and it also has x-axis or selectors and.

现在，是什么让 table-one 成为一个抽象数据类型？首先，它有类型标签，但仅靠仔细编程并不足以将其转变为 ADT。它还有什么？它有一个构造函数，拥有单独的接口是有帮助的，但这还不够。它还有选择器，以及

Also has x-axis or selectors and mutators that set could or thing is that. What makes it happen? Well, a grain that's not enough. After all, a lists have this opportunity as well. In fact, the key issue is the isolation of the abstraction from its users.

还有选择器和修改器，如 set-cdr 之类。是什么让它成为 ADT？嗯，这还不够。毕竟，A 列表也有这个能力。事实上，关键问题在于抽象与其用户之间的隔离。

We don't use any list processors like car, code, or map, or filter on the tables. And in fact, we can't, because the type of the object passed back by accessing a table is wrong and won't work for such procedures.

我们不会在表上使用任何列表处理器，如 car、cdr、map 或 filter。事实上，我们不能，因为通过访问表返回的对象类型是错误的，并且不适用于此类过程。

What we have done is actually hide the implementation of the guts of a table from the users of tables.

我们所做的是实际上将表的内部实现隐藏起来，不让表的使用者看到。

from the users of tables, this abstraction barrier allows us to freely change our implementation without affecting anything written by a consumer of tables. And that's the key: we've hidden away the a list from everything else. We could change that and nothing should have to change on the outside. This is a key point and one worth generalizing by creating a distinct data structure type for tables.

不让表的使用者看到，这个抽象障碍使我们能够自由更改实现，而不会影响表的使用者编写的任何内容。这就是关键：我们已经将 A 列表隐藏起来，与所有其他内容隔离。我们可以更改它，外部不应该有任何变化。这是一个关键点，值得通过为表创建独特的数据结构类型来推广。

We have, in essence, hidden information behind a name. We've made that name opaque to the user. What do we mean by this? Well, it says that the corrupt by creating a new type.

我们本质上是在名称后面隐藏了信息。我们已经使该名称对用户不透明。我们这是什么意思？嗯，它说通过创建新类型来隐藏信息。

that the corrupt by creating a new type in this way its name hides the details for example suppose I give you a new data type and simply tell you that it exists but not anything about its details just call it my type further let's suppose we have two procedures with the following type contracts m1 takes a number as input and creates for us a new thing of this type MyType and m2 takes in one of these things of my type and does something to it given just that information we can ask the following questions which of these two expressions is actually acceptable and

通过这种方式创建新类型来隐藏细节，例如，假设我给你一个新的数据类型，只告诉你它存在，但不告诉你任何细节，就称它为 MyType。进一步假设我们有两个过程，其类型契约如下：m1 接受一个数字作为输入，并为我们创建一个这种 MyType 类型的新事物；m2 接受一个这种 MyType 类型的事物，并对其执行某些操作。仅凭这些信息，我们可以问以下问题：这两个表达式哪个是可接受的，哪个不是？

expressions is actually acceptable and which one is not well clearly the first is fine and let's see why the type of object returned by m1 is the type expected by m2 we don't know anything about that type but the contract the Akos of the name allows us to separate that out and we're guaranteed to be able to do the right thing here on the other hand the second expression should bomb out because here the type of object returned by m1 is not appropriate for a procedure like car we don't know that the thing coming back is actually a pair

哪个表达式是可接受的，哪个不是？显然第一个是好的，让我们看看为什么。m1 返回的对象的类型是 m2 所期望的类型。我们对那个类型一无所知，但名称的契约（即名称的“阿科斯”）使我们能够将其分离出来，并保证我们在这里能做正确的事情。另一方面，第二个表达式应该会出错，因为这里 m1 返回的对象的类型不适合像 car 这样的过程。我们不知道返回的东西实际上是一个序对。

the thing coming back is actually a pair

返回的东西实际上是一个序对。

the thing coming back is actually a pair and we should not be able to assume that. In essence, the opaque name and the infrastructure hidden behind it meaning the data abstraction that isolates the Assessors that can use the object from the details that implemented this opaque name has guaranteed clean behavior for this particular data type. As a consequence, this means we can change those representations without affecting anything that's on the other side of that opaque name. So for tables, here's everything that a user needs to know: first, we have this opaque type.

返回的东西实际上是一个序对，我们不应该假设它是。本质上，不透明名称及其背后隐藏的基础设施——即数据抽象，它将可以使用该对象的访问器与实现该不透明名称的细节隔离开来——保证了该特定数据类型的干净行为。因此，这意味着我们可以更改这些表示，而不会影响不透明名称另一边的任何东西。所以对于表，以下是用户需要知道的一切：首先，我们有这个不透明类型。

first we have this opaque type this thing called a table one that has inside of a two arguments of types K and V or set another way table one using this notation it's constructed out of pairings of k's and v--'s but we haven't said anything about how our constructor for this type takes no argument as input and gives us back one of these data types a table one where the elements that are paired together within it can be of any type our constructor table put takes one of these abstract types plus a K in a V and it doesn't give us back

首先，我们有这个不透明类型，称为 table-one，其内部包含两个类型为 K 和 V 的参数，或者用另一种方式说，table-one 使用这种表示法，它由 K 和 V 的配对构造而成，但我们还没有说明我们的构造器是如何工作的。这个类型不接受任何参数作为输入，并返回一个这种数据类型 table-one，其中配对的元素可以是任何类型。我们的构造器 table-put 接受一个这种抽象类型加上一个 K 和一个 V，并且它不返回任何东西，因为它只是对结构本身进行操作。而我们的访问器 table-get 接受一个这种抽象类型加上一个 K，要么返回与之关联的 V，要么返回空列表。再次注意，这就是程序员（用户）需要知道的一切，这里没有提到列表、常量、car 或其他任何东西。

K in a V and it doesn't give us back anything because it's just doing something to the structure itself, and our accessor table get takes in one of these abstract types plus a K and either gives us back the V associated with it or the empty list. Note again, this is everything that the programmer, the user needs to know, and nothing is said here about lists or constants or cars or anything else.

K 和一个 V，并且它不返回任何东西，因为它只是对结构本身进行操作。而我们的访问器 table-get 接受一个这种抽象类型加上一个 K，要么返回与之关联的 V，要么返回空列表。再次注意，这就是程序员（用户）需要知道的一切，这里没有提到列表、常量、car 或其他任何东西。

It simply defines an interaction between one of these abstract data types, a table, and the elements within it, hiding below that abstraction barrier, hiding behind that.

它只是定义了一个抽象数据类型（表）与其内部元素之间的交互，隐藏在抽象屏障之下，隐藏在其后。

abstraction barrier hiding behind that opaque name is the actual implementation. Here we've made a choice in particular: we've said that the implementation for this abstract data type of a table is a symbol identifying the kind of table, glued together with an association list.

抽象屏障隐藏在不透明名称背后的是实际实现。这里我们做了一个特定的选择：我们说这个抽象数据类型（表）的实现是一个标识表类型的符号，与一个关联列表粘合在一起。

And a list whose elements are pairings of K's and V's—and what's an A-list? Well, we've seen it's just a list of lists, a list of pairings of K, V, and nil. So that internal representation of K cross V cross nil says it's a list of K and a V, and the overall list is simply a...

而一个列表，其元素是 K 和 V 的配对——什么是 A-list？嗯，我们已经知道它只是一个列表的列表，一个 K、V 和 nil 的配对列表。所以那个内部表示 K 叉 V 叉 nil 表示它是一个 K 和一个 V 的列表，而整个列表只是一个……

And a V and the overall list is simply a collection of all of those things glued together. This is our particular choice right now for how to build a table, but this is hidden from the user.

一个 V，而整个列表只是所有这些事物粘合在一起的集合。这是我们目前构建表的一个特定选择，但这对于用户是隐藏的。

So here are the key messages so far. First, we've seen that we can use this Association list structure to represent the internals of a table, but we also have seen that we need to separate it out. And the data abstraction technique allows us to use that representation while hiding that information.

所以到目前为止的关键信息是：首先，我们看到了可以使用关联列表结构来表示表的内部，但我们也看到了需要将其分离出来。数据抽象技术使我们能够使用该表示，同时隐藏该信息。

In general, this is going to be an important point using the notion.

一般来说，这将是一个重要的观点，利用构造器和访问器的概念。

Be an important point using the notion of constructors and accessors to support information hiding, burying the details from what is actually seen by the user. That's essential, as we've said, to building modular systems, which is absolutely essential for good software design.

利用构造器和访问器的概念来支持信息隐藏，将细节埋藏在用户实际看到的东西之下。正如我们所说，这对于构建模块化系统至关重要，而模块化系统对于良好的软件设计绝对必要。

### 8. Motivation for Hash Tables (哈希表的动机)

Now let's look at how the data abstraction allows us to alter the internal implementation at the table without affecting anything that consumes tables. That's been our point all along. To motivate this, suppose we build the table and monitor its usage and further suppose we find that a lot of time is

现在让我们看看数据抽象如何允许我们改变表的内部实现，而不影响任何使用表的代码。这一直是我们的观点。为了说明这一点，假设我们构建了表并监控其使用情况，进一步假设我们发现大量时间花费在 get 操作上。

Suppose we find that a lot of time is spent in the get operation. In other words, most of the time, as you might expect, is spent retrieving information from the table rather than actually adding to the table. If that's the case, it would be really nice if we could come up with a faster implementation of the get operation while preserving all of the contracts associated with the table itself.

假设我们发现大量时间花费在 get 操作上。换句话说，大多数时间（正如你可能期望的）都花在从表中检索信息上，而不是实际添加到表中。如果是这样，如果我们能提出一个更快的 get 操作实现，同时保持与表相关的所有契约不变，那就太好了。

In fact, there's a standard data structure for fast table lookup called a hash table. And indeed, you'll see a lot more about things like hash tables and

事实上，有一种用于快速表查找的标准数据结构叫做哈希表。确实，你会在后续课程中看到更多关于哈希表等内容。

more about things like hash tables and courses like six oh four six for us it's courses like six oh four six for us it's courses like six oh four six for us it's simply enough to say that the idea simply enough to say that the idea simply enough to say that the idea behind a hash table is to keep a bunch behind a hash table is to keep a bunch behind a hash table is to keep a bunch of Association list rather than one and of Association list rather than one and of Association list rather than one and to choose which Association list to use to choose which Association list to use to choose which Association list to use based on a function called a hash based on a function called a hash based on a function called a hash function what that function does is take function what that function does is take function what that function does is take the key the thing we're searching for in the key the thing we're searching for in the key the thing we're searching for in the table and compute a number between 0 the table and compute a number between 0 the table and compute a number between 0 and the number of Lists we have that and the number of Lists we have that and the number of Lists we have that will tell us which list to look in and will tell us which list to look in and will tell us which list to look in and only in that list will be then go and only in that list will be then go and only in that list will be then go and try and find the key you can already see try and find the key you can already see try and find the key you can already see why this should be faster rather than

更多关于哈希表以及像六零四六这样的课程的内容。对我们来说，简单地说，哈希表背后的想法是维护一组关联列表，而不是一个，并根据一个称为哈希函数的函数来选择使用哪个关联列表。该函数的作用是接受键（即我们要在表中搜索的东西），并计算一个介于0和列表数量之间的数字，这个数字将告诉我们查找哪个列表，然后我们只在该列表中查找键。你已经可以看出为什么这应该更快，而不是

Why should this be faster rather than having to search one really big table to find a key? If we can make the hash function fast enough, we can cut this down into searching a much smaller table structure to try and find the key. By the way, you'll find that when you take six double-O for that, this idea is regularly used by computer designers to support fast memory access and what are known as caches.

为什么这应该比搜索一个非常大的表来查找键更快呢？如果我们能让哈希函数足够快，我们就可以将其缩减为搜索一个更小的表结构来尝试找到键。顺便说一句，你会发现，当你学习六零零四这门课时，这个想法经常被计算机设计者用来支持快速内存访问，即所谓的缓存。

For our purposes, we want to look at the idea of a hash table as a way of building a much more efficient abstract data type for a table. So what does a

就我们的目的而言，我们想将哈希表视为构建更高效的抽象数据类型表的一种方式。那么，一个

data type for a table so what does a hash function look like well it simply needs to be a function or procedure that takes as input a key as we said and computes a number between 0 and some defined range and it should always do the same thing for that key so that we always look in the right place for the thing associated with the key.

表的数据类型，那么哈希函数长什么样呢？它只需要是一个函数或过程，接受一个键作为输入，并计算一个介于0和某个定义范围之间的数字，并且对于该键它应该总是做同样的事情，这样我们总能找到与键相关联的东西的正确位置。

as an example suppose we have a table where the keys are points that is XY coordinates of points in the plane for example points that are going to be on a graphic display of some sort and associated with each point will be some

举个例子，假设我们有一个表，其中的键是点，即平面上点的XY坐标，例如将要显示在某种图形显示器上的点，并且与每个点相关联的是某个

associated with each point will be some graphical object that points part of a particular structure like a circle of radius 4 or a square of size 8 for example if my little graphic system includes some simulations and I'm about to move one object in that screen I'd like to know which points are covered by that object and this means a nice way to do that is to take a point be able to look up the objects that cover that point and then do the appropriate manipulation to decide which point should be rebranded in which points can be left alone for us the question is how

与每个点相关联的是某个图形对象，该点是特定结构的一部分，比如半径为4的圆或大小为8的正方形。例如，如果我的小型图形系统包含一些模拟，并且我即将在屏幕上移动一个对象，我想知道该对象覆盖了哪些点。这意味着一个很好的方法是取一个点，能够查找覆盖该点的对象，然后进行适当的操作来决定哪些点应该被重新标记，哪些点可以保持不变。对我们来说，问题是

be left alone for us the question is how do I create a hash function that would take points as input and compute a number between 0 and 1 so for our purposes the real question is how do we build a hash function and here's a simple one for this little example given a point and a number n we'll take the x and y coordinates of that point notice we're assuming some data abstraction to get them out add those two numbers together and then return that value modulo N and modulo means we take the remainder of that number divided by n so we're guaranteed to get a number between

保持不变，对我们来说，问题是如何创建一个哈希函数，它以点为输入并计算一个介于0和1之间的数字。所以对于我们的目的，真正的问题是如何构建一个哈希函数。这里有一个简单的例子：给定一个点和一个数字n，我们将取该点的x和y坐标（注意我们假设某种数据抽象来获取它们），将这两个数字相加，然后返回该值对n取模的结果。取模意味着我们取该数除以n的余数，所以我们保证得到一个介于

We're guaranteed to get a number between 0 and n minus 1. You might already realize that a good hash function should be something that uniformly distributes the keys among its possible output answers, or as uniformly as it can.

我们保证得到一个介于0和n减1之间的数字。你可能已经意识到，一个好的哈希函数应该能够将其键均匀地分布在其可能的输出答案中，或者尽可能均匀。

And that's often an issue for interesting design sources here. Given that we assume points are randomly distributed in the plane, this function will do a pretty good job of giving us a roughly equal distribution of keys and values of the hash function.

这通常是设计中有趣的问题所在。鉴于我们假设点在平面上随机分布，这个函数将很好地为我们提供键和哈希函数值的大致均匀分布。

So a hash function basically chooses a bucket into which to put an object or from which to search.

所以哈希函数基本上选择一个桶来放入对象或从中搜索。

### 9. Hash Table Implementation with Vectors (使用向量的哈希表实现)

put an object or from which to search for objects. The idea is that given a key, we first apply the hash function, which computes an index that is a value between 0 and n minus 1. That index then tells us which set of things to look in, which bucket, as I said earlier, to look in in order to find the object we're interested in.

放入对象或从中搜索对象。这个想法是，给定一个键，我们首先应用哈希函数，它计算一个索引，该索引是介于0和n减1之间的值。然后该索引告诉我们查找哪一组东西，即我之前说的哪个桶，以找到我们感兴趣的对象。

And as we said, if the hash function is reasonably well behaved, this means that on average we're only going to be doing 1 over n the amount of search for a get operation that we did in the straightforward implementation, and as long as the hash

正如我们所说，如果哈希函数表现得相当好，这意味着平均而言，对于获取操作，我们只需要进行直接实现中搜索量的1/n，只要哈希

implementation and as long as the hash function is efficient we should get a big net benefit out of this idea. Note that we haven't said anything about how those buckets are glued together. This kind of looks like a list but we don't have to do it in a list, and in fact in a second we'll see that we won't.

实现，只要哈希函数高效，我们就应该从这个想法中获得巨大的净收益。注意，我们还没有提到这些桶是如何组合在一起的。这看起来有点像列表，但我们不必用列表来实现，事实上，稍后我们会看到我们不会用列表。

The main idea here is that if a key is in the table, then it is going to be in the association list of the bucket whose index is given by the hash function applied to that key. OK, now to build a hash table that actually implements a hash table, we need an efficient way of doing it.

这里的主要思想是，如果一个键在表中，那么它将在由该键的哈希函数给出的索引对应的桶的关联列表中。好的，现在要构建一个实际实现哈希表的哈希表，我们需要一种高效的方法。

hash table we need an efficient way of gathering the buckets together we're still going to represent each bucket as an association list but since we have an ordered sequence of buckets we'd like an efficient way of representing them for this will introduce another common abstract data type of vector this is a fixed size collection where access is determined by an index and number it's a little like a list but with two important exceptions first the size or length of the vector is fixed at construction time and secondly given an index into the vector we can retrieve

哈希表，我们需要一种高效的方法来将各个桶聚集在一起。我们仍然将每个桶表示为一个关联列表，但由于我们有一个有序的桶序列，我们希望有一种高效的方法来表示它们。为此，我们将引入另一种常见的抽象数据类型：向量。这是一个固定大小的集合，其中访问由索引和编号决定。它有点像列表，但有两个重要的例外：首先，向量的大小或长度在构造时是固定的；其次，给定向量中的一个索引，我们可以检索

index into the vector we can retrieve the contents of that location in constant time, whereas as you remember with the list it would take linear time to walk down to that point in the list. With that idea in mind, here's the contract for this data abstraction. As before, the type is opaque in order to hide the details, and in fact the elements of the type are just going to be some arbitrary type a. We're not going to worry about that, and we're not going to worry that much about the implementation of vector. We're going to treat it as an abstract data type.

给定向量中的一个索引，我们可以在常数时间内检索该位置的内容，而正如你所记得的，对于列表，要走到列表中的那个位置需要线性时间。带着这个想法，这里是这种数据抽象的契约。和以前一样，类型是不透明的，以隐藏细节，事实上，该类型的元素只是某种任意类型 a。我们不必担心这一点，也不必过多担心向量的实现。我们将把它视为一个抽象数据类型。

Treat it as an abstract data type. Associated with this data abstraction is a constructor make vector and two operations vector ref that gets out an element from the vector and vector set that goes in and changes an element of a vector.

将其视为一个抽象数据类型。与这种数据抽象相关联的是一个构造函数 make-vector 和两个操作：vector-ref，用于从向量中取出一个元素；以及 vector-set，用于进入并更改向量的一个元素。

Examples of the kinds of operations we'd expect to see are shown at the bottom of the slide. We can create a vector with a size number of locations, each of which initially contains some value that we specified. We can get back whatever is stored at a particular index of the vector, and we can certainly go in

幻灯片底部显示了我们所期望的这类操作的示例。我们可以创建一个向量，其大小为我们指定的位置数，每个位置最初包含我们指定的某个值。我们可以取回存储在向量特定索引处的任何内容，而且我们当然可以进入

of the vector and we can certainly go in and change what's stored it in index of a vector and of course you have to be careful about making sure we don't try to go beyond the end of the vector.

进入向量并更改存储在向量索引中的内容，当然，你必须小心确保不会试图超出向量的末尾。

this then gives us a hash-table a new data type we've built an implementation of it on top of another kind of data type we can just assume it does the right thing that's part of our goal of that abstract data types and we've seen that this hash table should have a different kind of behavior in terms of how it retrieves and stores things what we want to now turn to is how to use the

这然后给了我们一个哈希表，一种新的数据类型，我们在另一种数据类型之上构建了它的实现，我们可以假设它做了正确的事情，这是我们的抽象数据类型目标的一部分，而且我们已经看到这个哈希表在检索和存储事物方面应该有不同的行为。我们现在要转向的是如何使用

We want to now turn to is how to use the idea of a hash table to change our implementation of an overall table given our abstract data type of a hash table factor we've built one but given that abstraction let's go back and see how we can use it to change the implementation for our top-level table. Our goal is to see how we can replace the implementation, change the efficiency of the operations, but not change anything that is using those tables, so that a programmer using a table doesn't see any of this. The main changes in how we construct a table as before will have a

我们现在要转向的是如何使用哈希表的思想来改变我们整体表的实现，鉴于我们的哈希表抽象数据类型，我们已经构建了一个，但鉴于该抽象，让我们回去看看如何使用它来改变我们顶层表的实现。我们的目标是看看我们如何替换实现，改变操作的效率，但不改变任何使用这些表的东西，这样使用表的程序员就不会看到这些。主要的变化在于我们如何构造一个表，和以前一样，我们将有一个

construct a table as before will have a tag but now when we construct a table we'll specify two things the hash function we're going to use within the implementation and how big a hash function we want to have that is how many buckets we want to break our representation down into.

构造一个表，和以前一样，将有一个标签，但现在当我们构造一个表时，我们将指定两件事：我们将在实现中使用的哈希函数，以及我们希望哈希函数有多大，也就是说，我们希望将表示分解为多少个桶。

Notice what we do we list together the tag the size the hash function and the actual buckets that is the vector that represents the places where we're going to store everything and of course associated with this will have some selectors to get back out the pieces of the table.

注意我们做了什么：我们将标签、大小、哈希函数和实际的桶（即表示我们将存储所有内容的位置的向量）列在一起，当然，与此相关联的将有一些选择器来取回表的各个部分。

back out the pieces of the table. Something to think about, by the way, is for each function on this slide, what kind of beast is it: a constructor, an accessor, an operation, or maybe none of the above?

取回表的各个部分。顺便说一下，值得思考的是，这张幻灯片上的每个函数是什么类型的野兽：构造函数、访问器、操作，或者以上都不是？

So with this change, how do we do gets in this table? Well, we're still going to have the same inputs, a table and a key. Here, we're going to get the hash function out of the table—notice the selector pulling it out now. We're going to apply that to the key and the size of the argument, noticing the selector to get that out of the table. That will tell us which of the buckets

因此，有了这个变化，我们如何在这个表中进行 get 操作？嗯，我们仍然有相同的输入，一个表和一个键。在这里，我们将从表中取出哈希函数——注意选择器现在将其拉出。我们将把它应用于键和参数的大小，注意选择器将其从表中取出。这将告诉我们该查看哪个桶

that will tell us which of the buckets to look in. we'll call it index with that temporary binding using the left and then just as before we use our association list to find that key in the right spot.

这将告诉我们该查看哪个桶。我们将使用 let 将该临时绑定称为 index，然后和以前一样，我们使用关联列表在正确的位置找到该键。

and what's the right spot we use the index and the buckets of the table to find the right Association list and vector ref will give us back exactly that list.

什么是正确的位置？我们使用索引和表的桶来找到正确的关联列表，vector-ref 将正好返回那个列表。

this seems like a lot of code but stop and look at it if you do you'll realize that we're simply using the selectors and constructors but in particular the selectors of our data

这看起来像是很多代码，但停下来看看它，如果你这样做，你会意识到我们只是在使用选择器和构造函数，特别是我们数据抽象的选择器

particular the selectors of our data abstractions to pull out the right pieces at the table and find therefore the right thing inside of it also notice this function has exactly the same type as our original get and that's important.

特别是我们数据抽象的选择器来取出表的正确部分，从而在其中找到正确的东西。还要注意，这个函数与我们的原始 get 具有完全相同的类型，这很重要。

it means that somebody using this can rely on it doing the right thing and not have to make any changes just because we've changed the internal implementation to put something into this table.

这意味着使用它的人可以依赖它做正确的事情，而不必仅仅因为我们更改了内部实现而进行任何更改。

we do basically the same thing notice again the type is going to be exactly the same as the original put a table the key in a

我们基本上做同样的事情。再次注意，类型将与原始的 put 完全相同，一个表、一个键和一个值

as the original put a table the key in a value here we once more get the hash value here we once more get the hash value here we once more get the hash function associated with the table using that selector apply it to the key in the size that tells us which bucket to look in we then pull out the buckets of that table and use our new abstraction of vectors to try and pull out the right piece having found that we go in and change the Association using our Association list manipulation and a once more using the selector to pull out the right piece and as we noted earlier while it looks like a lot of changes just walk your way through the code to

与原始的 put 完全相同，一个表、一个键和一个值。在这里，我们再次获取哈希值，我们再次获取与表关联的哈希函数，使用该选择器将其应用于键和大小，这告诉我们该查看哪个桶，然后我们取出该表的桶，并使用我们新的向量抽象来尝试取出正确的部分，找到后，我们使用关联列表操作进入并更改关联，再次使用选择器取出正确的部分，正如我们之前指出的，虽然看起来有很多变化，但只需逐步浏览代码

just walk your way through the code to realize how the selectors are simply getting the new Association list out of the right bucket of the vector and doing the right thing with it.

只需逐步浏览代码，以意识到选择器是如何简单地从向量的正确桶中取出新的关联列表并对其进行正确操作的。

so let's look at a little example to see how the behavior has changed in terms of efficiency but not in terms of view from the user.

那么，让我们看一个小例子，看看行为在效率方面发生了怎样的变化，但从用户的角度来看却没有变化。

let's define a new little table using our constructor notice again it has to take in both in size and the hash function we'll use that hash a point we had before and here's a representation of the structure we get tt-to for tagged.

让我们用构造函数定义一个新表，注意它必须同时接受大小和哈希函数，我们将使用之前用过的那个哈希点，这里是我们得到的结构的表示，即带标签的 tt-to。

The structure we get tt-to for tagged table points to a list. The first element of which is the symbol the tag, saying what kind of thing it is. The second of which is the size of the hash function. The third of which is the actual procedure itself, and we're just going to represent that as this double bubble for reasons we'll see in a few weeks.

我们得到的带标签的 tt-to 表结构指向一个列表。列表的第一个元素是符号标签，表示它是什么类型的东西。第二个是哈希函数的大小。第三个是实际的过程本身，我们将其表示为这个双气泡，原因我们将在几周后看到。

And finally, the last part of this is a pointer to a vector, and because the size is for this vector has four slots in it, that's what the structure looks like. So now let's manipulate this table. Let's put into this table one of those points.

最后，这个结构的最后一部分是指向一个向量的指针，因为大小是四，这个向量有四个槽位，这就是结构的样子。现在让我们操作这个表。让我们把其中一个点放入表中。

put into this table one of those points with an association paired with it if you look back at the code you'll see that this operation does the following.

把其中一个点及其关联对放入表中，如果你回顾代码，你会看到这个操作执行以下步骤。

first it gets the hash function and the size and applies that to this key make point in order to determine which part of the vector to look in having found that right part of the vector.

首先，它获取哈希函数和大小，并将其应用于这个键 make point，以确定要查看向量的哪个部分，找到向量的正确部分后。

it takes the Association list stored there and glues on front of that Association list and new pairing a new pairing of the point and the value as shown here as we've been saying this should be much

它取出存储在那里的关联列表，并将新的配对（点和值的配对）粘在该关联列表的前面，如图所示。正如我们所说，这应该会高效得多。

we've been saying this should be much more efficient since we're only looking into one of four Association lists to do this work let's do the same thing with another Association of putting something into the table and in exactly the same way this will create a new Association list hanging off of one of the buckets of the vector as before

我们一直说这应该会高效得多，因为我们只查看四个关联列表中的一个来完成这项工作。让我们用另一个关联做同样的事情，将某物放入表中，以完全相同的方式，这将创建一个新的关联列表挂在向量的一个桶上，如前所述。

now remember our reason for making this change was that we wanted a table that was much more efficient in terms of getting things out so let's see what happens if we now try and do a get from this table of one of

现在记住我们进行这一改变的原因是，我们想要一个在取出东西方面更高效的表，所以让我们看看如果我们现在尝试从这个表中获取一个我们相信存储在表中的东西会发生什么。

and do a get from this table of one of the things that we believe is stored somewhere in that table. If you look back at the code, you'll see that get for this kind of table does the following: it takes the key, that point structure, it takes up the size and the hash function that are part of the table and applies those to this key to determine which vector to look in.

并从这个表中获取一个我们相信存储在表中的东西。如果你回顾代码，你会看到这种表的 get 操作执行以下步骤：它接受键（那个点结构），取出表的大小和哈希函数，并将它们应用于这个键以确定要查看哪个向量。

In our case, we know that that should be the third bucket of the vector. It then goes straight to that bucket, pulls out that Association list, and then uses normal a list operations to find the pairing and return.

在我们的例子中，我们知道那应该是向量的第三个桶。然后它直接转到那个桶，取出那个关联列表，然后使用普通的关联列表操作来找到配对并返回。

to find the pairing and return the appropriate value associated with that pairing. The key thing to notice here is that it's searching a much smaller list. In fact, as we expected, we should do only a quarter of the amount of work we would have done in a normal case.

找到配对并返回与该配对关联的适当值。这里要注意的关键是，它搜索的列表要小得多。事实上，正如我们所预期的，我们只需做正常情况四分之一的工作。

### 10. Comparative Analysis and Key Lesson (比较分析与关键教训)

The second key thing to note is that from the point of view of the user, this is all invisible. So what have we done? We've built an abstract data type—a table—a way of collecting information together, and we've then built two different implementations of the table with the

第二个关键点是，从用户的角度来看，这一切都是不可见的。那么我们做了什么？我们构建了一个抽象数据类型——表——一种收集信息的方式，然后我们构建了表的两种不同实现，其

implementations of the table with the

表的实现，其

implementations of the table with the key idea being that the user of a table will not in principle see any difference. That is, the type contracts between the constructors and selectors of the table are identical. At the same time, we said one reason for doing it was to try and create a more efficient implementation of the table.

表的实现，其关键思想是，表的使用者在原则上不会看到任何差异。也就是说，表的构造函数和选择器之间的类型契约是相同的。同时，我们说这样做的一个原因是试图创建一种更高效的表实现。

So which is better? Well, I've kind of led you down a garden path because I suggested earlier that table two would be much better, but in fact the answer is that it depends. It depends on what use you want to make of it. For example, table one has an

那么哪个更好呢？嗯，我有点引导你走了一条弯路，因为我之前暗示表二会好得多，但实际上答案是：这取决于情况。这取决于你想如何使用它。例如，表一具有

For example, table one has an extremely fast constructor and an extremely fast put operation, but its get operation is order n, where n is the number of calls to put. You can see that because, in principle, it is going to have to look down a long association list to find the right thing.

例如，表一具有极快的构造函数和极快的 put 操作，但其 get 操作是 O(n) 的，其中 n 是 put 调用的次数。你可以看到这一点，因为原则上它必须沿着一个长关联列表查找正确的东西。

Table two, on the other hand, trades things off differently. First of all, this constructor is going to use up more space; it's going to have to use up enough space as determined by its input argument. Its put operation is going to have to compute a hash function and that.

另一方面，表二以不同的方式权衡。首先，这个构造函数会占用更多空间；它必须根据输入参数使用足够的空间。它的 put 操作必须计算哈希函数，而且

have to compute a hash function and that we course know may be slow or fast depending on how clever we can be about designing the hash function. The get operation again has to compute the hash function plus it has to do order in operations where this end in principle should be smaller, it'll be the average length of a bucket rather than the total length of the association list.

必须计算哈希函数，而且我们当然知道这可能慢也可能快，取决于我们设计哈希函数的巧妙程度。get 操作同样必须计算哈希函数，此外还要执行 O(n) 操作，其中这个 n 原则上应该更小，它将是桶的平均长度，而不是关联列表的总长度。

What this says then is the table one will be better if we're doing very few gets or if the tables very small. Table two will typically be better but we have to be

这说明，如果我们很少进行 get 操作，或者表非常小，那么表一会更好。表二通常会更好，但我们必须

Typically be better, but we have to be sure that we can both predict the size of what we're going to need and pick a good hash function that spreads things out evenly among all of the buckets.

通常会更好，但我们必须确保既能预测所需的大小，又能选择一个好的哈希函数，使数据均匀分布在所有桶中。

So why did we do all of this? Well, basically several reasons. We wanted to show you a new data structure, but more importantly, we wanted to show you how we can separate out the use of the data structure from the actual implementation.

那么我们为什么要做这一切呢？基本上有几个原因。我们想向你们展示一种新的数据结构，但更重要的是，我们想向你们展示如何将数据结构的使用与实际实现分离开来。

And we've used two different ideas here to show that indeed the goal of the abstract data type methodology is to hide information, to use opaque names.

我们在这里使用了两个不同的概念来表明，抽象数据类型方法论的目标确实是隐藏信息，使用不透明的名称。

hide information to use opaque names to distinguish between the operations we want to use on that data type and the internal definitions that actually make the data type go and that's the lesson we hope you take away from this.

隐藏信息，使用不透明的名称来区分我们想在该数据类型上使用的操作和实际使数据类型运转的内部定义，这就是我们希望你们从中学到的教训。