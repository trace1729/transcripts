# LLM架构 · 1414 · [LLM Architect] 13 Kimi K3 门控机制，门控注意力，Gated MLA，KDA的门控分支，MoE 中的SiTU-GLU，SwiGLU
[视频链接](https://www.bilibili.com/video/BV1UNur6pEkZ)

## 总结

- 本期以门控机制为主线，介绍Kimi K3模型中的Gated MLA与SiTU-GLU激活函数，并回顾前身Gated Attention的提出及其在NeurIPS 2025获奖的工作背景。
- Gated Attention的核心是在注意力输出上增加一个由Hidden States经线性变换和Sigmoid得到的门控分支，通过按位相乘来调控信息流；实验表明在SDPA输出和门控分支汇合处添加门控效果最好。
- Kimi K3中的Gated MLA继承了这一思想，在MLA输出处增加Sigmoid门控分支；类似结构也出现在KDA、千问的GLA、Meta开源的MuseGlimmer等模型中，成为近期架构的常见设计。
- 在FFN/MoE部分，Kimi K3用SiTU-GLU替换常见的SwiGLU：SiTU-GLU通过双分支配合贝塔参数（左4、右25）对中间结果做soft cap，使激活值范围受限（约小于等于100），从而提升训练稳定性。
- SiTU-GLU在维度上也做了调整，输入从d_model压缩为d_model/2（如7168变3584），MoE路由专家中DFF中间维度相应变为3072，与经典dense FFN的up-gate-down结构不同。
- 从激活函数演化看，从Sigmoid到SiLU/SwiGLU再到SiTU-GLU的一路改进，核心在于引入门控分支并追求有界性，使更大的模型训练更稳定，这一趋势同样反映在KDA的Alpha参数设计中。

## 大纲

1. 开场与本期路线：聚焦门控机制
2. 门控机制引入：Gated Attention到Gated MLA与GLA实例
3. FFN/MoE中门控激活函数的引入背景
4. Gated Attention的原理与实验细节
5. Gated MLA、GLA与KDA中的门控分支实现
6. Kimi K3中SiTU-GLU的结构与推导
7. FFN/MoE维度设计与激活函数演变对比
8. SiTU-GLU的有界性分析与绘图总结

## 正文

### 1. 开场与本期路线：聚焦门控机制

好亲爱的朋友们，大家晚上好。今天我们继续回到大模型架构这个系列，这期我们继续探索Kimi K3。当然，Kimi K3的介绍可能不只是一两期，未来还会有好多期。我希望大家也跟着我这个系列，去读Kimi K3的时候，以此为案例，为范文，去展开、去探索大模型更新的这个架构里边的架构上的一个细节，当然也包括训练——预训练、后训练，还包括数据工程以及Infra相关的各种各样的概念、原理、表示和计算。

### 2. 门控机制引入：Gated Attention到Gated MLA与GLA实例

那这一期呢，我们的线索非常非常简单，我们这一期highlight的重点是gated，是门控。我们首先会介绍Gated Attention，这是Kimi、千问团队在去年的5月份当时发的一篇语言模型架构探索的工作，他后来其实是中了NeurIPS 2025的Best Paper。那然后这里面其实可能重点就是介绍的是Gated Attention这样一个机制，然后它是应用到了Kimi K3里边的Gated MLA，它是一个自然的一个继承。

当然Gated MLA里边我们可以直接看论文，Kimi K3里边大家可以看到这个图、这个框图，他这个分支——这个原始的Hidden States的一个输入，会除了会经过这个MLA之外，还会经过一个Linear矩阵的一个线性变化，然后再做一个Sigmoid的一个变化，再和这个MLA的一个输出去做按位相乘。因为你Sigmoid之后就是零一之间，它是一个门控的一个机制。大家可以看到Alpha、Beta他这两个路，它其实也有Sigmoid的，也就是说我们待会会介绍Gated Attention的时候，其实大家会看到这样一种Gated的一种旁路。我觉得这个Gated MLA呢，也是某种意义上也是继承了这样一种思想，就是Gated的产生的一个思想。

当然今天发布的、今天这个Meta开源的这个3.4B这样一个小模型叫MuseGlimmer，它里边也是一种Gated的GLA的一种结构。我们看代码的话其实比较清楚，我大家可以去那个VRM里面去看到，这个今天刚提交的这样一个PR的一个代码。大家可以看到，先对Hidden States去做一个Projection，就Linear的一个Projection，然后再乘，再乘以这样再得到这样GIA之后再乘，再用Sigma的去做一个变化，再作用到原始的Attention的Output上，就是Scaled Dot-Product Attention。

### 3. FFN/MoE中门控激活函数的引入背景

而我们介绍完了Gated的参数之后，我们再介绍另外一种门控的一个机制，其实主要是作用在这个激活函数里面。然后这里边呢，我们主要是介绍FFN或者MoE里边的，然后这个Kimi团队提出的这个SiTUGLU这样一种激活函数的一种机制。我们是放在这个激活函数的这个序列里面，去介绍这个SiTU GLU Gated Attention——它是显然就是它是应用在这个Attention里面的，然后这个SiTU GLU它是应用在FFN或者MoE里面的。

### 4. Gated Attention的原理与实验细节

好，我们先不妨先看这个Gated Attention。我们不妨看这个经典的QKV——经典的所谓的这个Attention的这样机制：Q乘以K的转置，再除以这个根号下Dk，再做Softmax，再乘以这个V，这是原始的Attention。原始的Attention呢，就会直接会有一个Output的Projection，会直接存到Wo上。我们这个Gated Attention呢，是在这个原始的Attention的Output的基础之上，再乘以这样一个门控的一个机制，就是X的Hidden States，再乘以这样一个Linear的一个半变换，再用Sigmoid的做一次变换，得到一个门控的一个Gated的一个矩阵，这就是Gated Attention。好，我们不妨看这个这篇论文里边的这个结构，他其实当时做了很多实验，就是我们有一个X，它就会有主要会有两路，一个部分是进入到QKV。一个部分是进入到KKV。

一部分是进入到这个git的一个brunch。左边这一路呢他有WQWKWV，这里面可以加门控。当然你在这个W呃，这个git这个旁路里边也可以加门控。当然你可以在这个wo output projection后面也可以加门控。他实验下来之后，可能两个地方加门控制会比较好。第一部分是这个就是经典啊，就这个论文最后提出的一种思路哈，就加到这个SDPA和这个gt的brunch，这个墨这个地方按微相乘的地方去做门控。然后当然这个WV哈也可以，也会可能会好于其他其他地方啊。这就是get its attention。

### 5. Gated MLA、GLA与KDA中的门控分支实现

那下面自然的就是KIK3里面，因为他这个MLA也是一种git的，也是说X除了进入到除了经过QKV进入到SDPA之外，还有一条路，一个gt的一个矩阵啊，一个project是个linear projection那个矩阵，然后经过所SIGMOID的，然后有这样一个重用到SDPA的attention的一个输出上，然后再做output的一个protection。那自然呢纤维3.5MOE哈，它就是所谓的35BA3B这样一个开源的一个模型哈，他有一个GG的GLAGQA也是如此哈，也有这样一个gay it的一个一个旁路的。当然今天发布的这个muse glimmer哈，gt7QA他是一个非常非常经典的，就像刚代码也看看过了哈。

然后这里边我其实想补充介绍一下这个所谓的KDA里面，它其实也有这样一个门控。他这个原始的这个技术报告里面，大家可以看到哈，有两路啊，第一部分是经过KDA，另外一路是做这个跟这个gay is attention里边完全完全一致的这样一个gay z的一个旁路，然后两路汇合按位相乘呃。我们不妨再回顾一下这个KDA的这个流程，首先他的输入还是b by t by demodel，DEMODEL就是7K哈，b by t by啊G68。他的输出是以同样的输出，只是中间会经过KDA的过程，会得到一个O，中间会有一个O，其实就是这个这个报告里边这个KDA的这里经过KKV阿尔法贝塔啊，删除和写入。

得到一个O之后，得到O之后先做i was now，每个头每个DV128位，就是呃在这个feature维度上去做amazon norm number。补完了之后，再乘二位相乘，这个门控的这个brunch及out a sigmoid的变换之后的一个矩阵对，就是个linear一个矩阵，然后再做signal的变化，然后再按位相乘这样一个KDA的一个输出。KDA的输出先经过一次arm slog对，就是这么简单哈，对就是amazon am再乘以这个g out。

对大家可以看到这个，因为他这个图里面，这个阿尔法和贝塔里面也有这个SIGMOID哈，大家可以看到哈，呃我们这边回顾到他这个TENSORFLOW里面，大家可以看到哈，呃B这个这个这个地方哈，大家可以看到我把它圈出来哈，大家可以看到这个就是阿尔法，这个这个brunch里边，他有这样一个西格玛id的这样一个变化。然后这个贝塔这个brunch里面，它也有这样一个西格玛id的一个变化，就是贝贝塔这个输出是0~1之间的，对阿尔法的话他可能是一的-5~1之间额，但是它是一个呃128维的好对这是KDA，他也在某种意义上来继承这个gay子的tension。

### 6. Kimi K3中SiTU-GLU的结构与推导

我们回到我们这个这届好，下面我们从激活函数的角度，我们来探索这个k me呃，K3在FAN或MOE里边的时候，他引入了这样一个STU GLU的这样一个奇偶函数的一个一个机制哈。那这里边我想讲呃，介绍一下哈，在KIK3之前，大部分的FFN或者MOE哈，它的一种激活的一种机制是什么呢，它有三个矩阵哈，就是get up down。我们看简单看一下哈，首先这个haden states的一个输入哈，经过get it的一个矩阵，然后再做这个a switch的一个非线性的激活，再有这样一个up的一个矩阵。

两个按位相乘，然后再做down的一个projection，get it up down三个矩阵。然后这个LICENMOE哈，KIMI里边它除了有这个输入之外，输入的变化之外，输入是把呃原始的这个7K变成了二分之7K，就原来的7168变成了3584的一个latent hidden states之外。他这个激活函数这个地方大家可以看到哈，它同样有一个W3的这样一个变化，有这样一个类似于git的一个分支，然后两个按位相乘之后再做down projection，只是这里边第一呢这个激活函数从这个switch变成了SITUJLU。

好，我们这里边我把它放大看一下啊，对因为这里有两路哈，大家可以看到有两路SITUGRU，它有两路。我先说这个SHTUGRU哈，它有两路的话，左边这一路哈是假如你这个Z经过这个W1这个矩阵的一个变化得到了A，然后STU他这个gt的这个分支哈，他是贝塔一哈，再乘以tenth，你这个输出再除以贝塔一，再乘以西格玛id的A，就你有一个矩阵A的一个输出，你把这个矩阵A代入到这样一个公式里面，就作为一个git的brunch。

然后同时呢，你这个Z哈经过W3这个矩阵的一个线性变化，你得到一个B，然后这个地方走的是SITUJLU的另外一个分支哈，就是贝塔to乘乘以TENNH啊，B除以贝塔to。然后一般意义上哈，在KBK3里面，用这个贝塔一取的是一个四，贝塔二取的是25，那这样的话两者按位相乘，最终除完之后是小于等于100的，小于等于4×25，小于等于100的。就大家可以不妨可以推一下啊，tan值是-1~1之间，SIGMOID是零一之间对，然后对它的值是-1~1，大家可以不妨自己去看看一下哈。

对他有两个变化，第一是这个input的维度哈，由之前的d model变成二分之d model，原来的7K变成3584，然后另外就是激活函数变了，由原来的switch变成IITUSTUGLU，它是对两个分支都有要求的，左边这个分支乘以了这个贝塔一，右边这个分支乘以了贝塔二啊，其次这个形式也有一些变化好。那下面我们就来展开介绍，这个我们就以这个激活函数为例哈，我们整体做一个串联啊，可能讲之前我们要再再说一下这个事情哈，这个这个维度这个事情哈。

### 7. FFN/MoE维度设计与激活函数演变对比

经典的dance的一个MOPFVN，就是它会有这样一个倍数的关系哈，up的时候up get down吗，up的时候，比如7K变成了33792，变成了有一个4.71倍的一个up的一个projection，共享专家也是如此，然后两个希尔的一个expert，然后在弦儿子里边，这个他这个DFF它也是升维的768变呃，也是降维7168变到6144。然后在路由专家里面，每个小的MOV的export里边，因为我们的输入是已经是latent的Hidden states，就是二分之7K好，就是3584，他这个DFF就是那所谓的update down，那个中间那个维度是3072，这一定要对比啊，他不再是up get down，他把BW1W二W三，下面我们来整体再串一下这个奇偶函数。

首先就是就SIGMOID的额罗伊斯的SIGMOID，它的形式就是11加exponential的负Z，就是这样一个形式，还要看那是的一个形式。然后就是后边我们会一直在不断的介绍SLU，Just sick boy linear units，对他会有会有会对这输入先做一个SAMOID的，再乘以这个输入本身，因为Z哈，你假如原始的是输入是Z哈，你输出是Z行，那就零零点unit，然后再乘以这个c mod的Z的话，就是一个SIGMOID的变化，就叫SIRU。那这个地方有有的地方也叫switch，比如一个self geets激活函数，当然这个这个西格玛Z里面有，有的地方可能也会再重用一个贝塔，就西格玛贝塔Z哈，然后touch里面是有这样一个定义的，AAPI的一个定义的，它其实就是X乘以这个SIGMOID的X。

SIGMOID的X就是逻辑斯特，SIGMOID X是代表着linear，SIGMOID的X代表着SIGMOID的git。它是零一之间的，称之为一个gates，一个门控。

下面我们介绍这个GRU，就是gis linear unit。就是你你经过一个矩阵，你有一个输入，经过一个矩阵，经过一个brunch，然后同时呢你可能有另外一个brunch，同样的一个矩阵的线性变化，只是这个地方要做一个门控，做了一次SIGMOID的一个门控。大家可以看到哈这个GLEU，这个地方，他其实已经有一个两个brunch的一个概念了，就同一个X经过左边的一个零点projection w1哈，经过右边的一个线性变换的一个矩阵哈，零点projection，只是右边这个地方，在做一个SIGMMOID的这个变化，把它变成一个SIGNBOY的一个门控，称之为gay器。

在零点unit transformer里边常见的switch jr u u，就是把这个SIGNIMOID变成SILU，signimoid leaner units对，就这个西格玛这个地方再变成这个SIRU。SILU是什么呢？就是X乘以西格玛的X对，这这也是刚我们在这个PPT里边，我们当时介绍的，我们在对比SITRITU的时候，是对比的是呃，swing jl u和这个GRE语对，大家都是作用在两个brunch上。GRU呢这个门控这块就是SIGMOID的X，然后右边就是X，对于switch加LU，用左边就是SIILU就是X乘以SIGMOE的X，右边还是X，然后对于SITUGREU哈，左边是变成了一个个比较复杂的，右边变成了一个比较复杂的，它的核心目的是追求这个有界，因为之前的承下来都可能是无界的。

### 8. SiTU-GLU的有界性分析与绘图总结

那我基本上就讲清楚了哈，我们再看SITUGRU，就左边就是这个git的分这个支路的分支哈，右边是up的一个给支路的一个分支。那这里面可能有的地方，还有还把这个这个贝塔乘以这个TENNH，再除以这个贝塔，把这个地方叫soft cap，它是用来soft cap a和B哈，是用来限制用B去限制A呃，这个我就不展开讲了，话这个这个其实可能也比较直观，大家画图的话可能比较直观。k me里边，KDA里边，他其实也有一个在算这个阿尔法的时候，他其实也有一个exponential的，SIGNIMOY的这样一个情况，他反正总之哈他是为了追求这个所谓的有界性。对这个机密哈他取五，那自然这个近密乘以这个CMOID就是五，就零到额，就-5~0，然后这个再取expansion的话，就是一的五再乘以一，也就是KDA里面这个阿尔法哈，它是一个接近于零的数到一之间。

最后我们画一下图哈，我们简单画一下这个图图，对我其实可能这里面有一个论述哈，就是SITUGLEU呢，它主要是使得这个有界，但是正常区间像SWIGLU一样。我们简单画下这个图，因为他们GLU额as s i l u或者叫as swil u，或者或者我们KBC3提的SITUJLU，他都是两路哈。我们不妨JLU的话就是一路是X，一路是西格玛的x swag，2U的话一路是X，一路是X乘以GRU呃，X乘以sc void的，就是X就整体就是X乘以GRU，STUGLU哈，就左边一路右边一路左边的这个贝塔一是四，右边的贝塔二是25，就画下来说话，如果在六-6~6之间，大家可以看到它是整体是比较接近的，但是如果对如果后边无限大的话，就这个大家可以看到哈，S i t u j l u，它还保持着一个比较好的一个有界性，右边基本上都会飞出去哈。好以上就是本期的全部内容。好，以上就是本期的全部内容。