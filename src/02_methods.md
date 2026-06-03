# 轨道衰减理论基础

## 大气阻力定义

### 大气阻力加速度模型

对于低地球轨道（LEO）卫星，大气阻力是最主要的非保守摄动力。根据流体动力学理论，阻力加速度的大小与大气密度、卫星的迎风面积、阻力系数以及卫星相对于大气的速度平方成正比，方向则与相对速度矢量相反 [@kinghele1964; @vallado2013]：

$$
\mathbf{a}_{\text{drag}} = -\frac{1}{2} \rho \frac{C_D A}{m} v_r \mathbf{v}_r \qquad (1)
$$

式中：  
$\rho$ —— 大气密度（kg/m³），受太阳活动和地磁活动强烈调制；  
$C_D$ —— 阻力系数（无量纲），典型值 2.2±0.2，依赖卫星形状与表面材料；  
$A$ —— 卫星参考迎风面积（m²）；  
$m$ —— 卫星质量（kg）；  
$\mathbf{v}_r$ —— 卫星相对于大气的速度矢量（m/s），$v_r = \|\mathbf{v}_r\|$。

定义弹道系数 $B = C_D A / m$，则阻力加速度可简记为  

$$
\mathbf{a}_{\text{drag}} = -\frac{1}{2} \rho B v_r \mathbf{v}_r \qquad(2)
$$

弹道系数集中反映了卫星自身属性对阻力摄动的敏感程度：$B$ 值越大，阻力作用越强，轨道衰减也越快。

### 大气相对速度的确定

大气并非静止不动，而是随地球自转近似共转。设地球自转角速度矢量为 $\boldsymbol{\omega}_e$（大小 $\omega_e = 7.292115\times10^{-5}$ rad/s，方向沿地轴指向北极），则在惯性系（如 GCRF）中，大气共转速度可写作 [@bate1971]：

$$
\mathbf{v}_{\text{atm}} = \boldsymbol{\omega}_e \times \mathbf{r} \qquad(3)
$$

其中 $\mathbf{r}$ 为卫星的地心位置矢量。因此卫星相对于大气的速度为  

$$
\mathbf{v}_r = \mathbf{v} - \boldsymbol{\omega}_e \times \mathbf{r} \qquad(4)
$$

将 (4) 代入 (1)，得到惯性系下完整的阻力加速度表达式：

$$
\mathbf{a}_{\text{drag}} = -\frac{1}{2} \rho B \|\mathbf{v} - \boldsymbol{\omega}_e \times \mathbf{r}\| (\mathbf{v} - \boldsymbol{\omega}_e \times \mathbf{r}) \qquad(5)
$$

该模型已在 Orekit 等轨道动力学库中标准实现 [@orekitjb2008]。

### 阻力加速度在 RTN 坐标系下的分解

高斯型摄动方程通常采用 RTN（径向‑横向‑法向）坐标系描述摄动加速度分量。RTN 坐标系定义如下 [@vallado2013]：  

径向 $\hat{\mathbf{r}} = \mathbf{r} / r$，沿地心指向卫星；  
横向 $\hat{\mathbf{t}} = \hat{\mathbf{h}} \times \hat{\mathbf{r}}$，其中 $\hat{\mathbf{h}} = (\mathbf{r} \times \mathbf{v}) / \|\mathbf{r} \times \mathbf{v}\|$，在轨道平面内垂直于径向且指向运动方向；  
法向 $\hat{\mathbf{n}} = \hat{\mathbf{r}} \times \hat{\mathbf{t}}$，沿轨道角动量方向。

摄动加速度 $\mathbf{a}_{\text{drag}}$ 在 RTN 下的三个分量为  

$$
S = \mathbf{a}_{\text{drag}} \cdot \hat{\mathbf{r}}, \quad
T = \mathbf{a}_{\text{drag}} \cdot \hat{\mathbf{t}}, \quad
N = \mathbf{a}_{\text{drag}} \cdot \hat{\mathbf{n}} \qquad(6)
$$

对于大气阻力，由于相对速度 $\mathbf{v}_r$ 主要包含横向分量（轨道速度远大于大气共转速度），通常 $S$ 和 $T$ 为负值，而 $N$ 很小但不为零（取决于大气共转与轨道倾角）。

### 大气密度模型 JB2008

JB2008 大气模型是一种用于描述地球热层密度变化的经验模型，由美国空军空间司令部与 Space Environment Technologies 联合提出，是在 Jacchia 系列模型基础上的改进模型。该模型主要用于计算低轨卫星所受的大气阻力及轨道衰减过程，在卫星轨道预报、空间目标定轨以及空间环境研究中具有广泛应用。JB2008 模型以卫星拖曳观测数据和多源空间环境参数为基础，引入了 F10.7 太阳射电流量、S10 紫外辐射指数、M10 中层大气指数以及 Y10 X 射线与莱曼-α 辐射指数等多种太阳活动参数，同时结合 Dst 修正项以表征地磁扰动对热层密度的影响，因此相比传统 Jacchia 模型能够更准确地反映高太阳活动和强磁暴条件下的大气密度变化特征。该模型在强空间天气事件期间对热层密度突增现象具有较好的响应能力，能够有效提高低轨卫星轨道衰减计算精度，因此被广泛应用于空间天气效应分析与航天任务轨道动力学研究中。

式 (1) 中的大气密度 $\rho$ 是计算摄动的关键输入。由于 $\rho$ 随高度、地方时、太阳活动（F10.7 指数及其 81 天均值）和地磁活动（Ap 和 Dst 指数）剧烈变化，必须采用经验或半经验模型。本文采用 JB2008（Jacchia‑Bowman 2008）热层密度模型，其主要特征 [@bowman2008]：覆盖高度 175 km 至 1000 km，适用于绝大多数 LEO 卫星使用改进的太阳极紫外（EUV）和远紫外（FUV）辐射指标（$S_{10.7}$、$S_{10.7}^{81}$、$M_{10.7}$ 等）；引入 $D_{st}$ 指数驱动地磁暴期间的全球密度响应；与 CHAMP、GRACE、GOCE 等高精度加速度计反演密度比对，偏差优于 15%。

JB2008 已被 COSPAR 推荐为热层密度参考模型，并集成于 Orekit 等主流轨道动力学库中 [@pardini2026; @orekitjb2008]。

## 能量法计算半长轴衰减的理论基础

### 机械能与半长轴的关系

两体问题中，卫星在中心天体引力场中运动的比机械能（单位质量的总能量）由动能与势能之和给出：

$$
\mathcal{E} = \frac{v^2}{2} - \frac{\mu}{r} \qquad(7)
$$

其中 $v = \|\mathbf{v}\|$，$r = \|\mathbf{r}\|$，$\mu = GM$ 为地球引力常数。根据轨道力学基本结果，比机械能也可用轨道半长轴 $a$ 简单表示为  

$$
\mathcal{E} = -\frac{\mu}{2a} \qquad(8)
$$

这一关系对椭圆轨道（$a>0$）成立：轨道能量完全由半长轴决定，能量越低（越负）时轨道半径越小，卫星束缚越紧 [@vallado2013; @bate1971]。

### 能量耗散与半长轴变化率

将比机械能 $\mathcal{E}$ 对时间求导：

$$
\frac{d\mathcal{E}}{dt} = \mathbf{v} \cdot \frac{d\mathbf{v}}{dt} + \frac{\mu}{r^3} \mathbf{r} \cdot \mathbf{v} \qquad(9)
$$

地球中心引力加速度为 $-\mu \mathbf{r}/r^3$，因此卫星总加速度为  

$$
\frac{d\mathbf{v}}{dt} = -\frac{\mu}{r^3}\mathbf{r} + \mathbf{a}_{\text{drag}} \qquad(10)
$$

代入 (9) 得  

$$
\frac{d\mathcal{E}}{dt} = \mathbf{v} \cdot \left(-\frac{\mu}{r^3}\mathbf{r} + \mathbf{a}_{\text{drag}}\right) + \frac{\mu}{r^3} \mathbf{r} \cdot \mathbf{v}
= \mathbf{v} \cdot \mathbf{a}_{\text{drag}} \qquad(11)
$$

可见，大气阻力引起的比机械能变化率 $\dot{\mathcal{E}}$ 恰好是单位质量的阻力瞬时功率 $P_m = \mathbf{v} \cdot \mathbf{a}_{\text{drag}}$。  
由式 (8) 对时间求导：

$$
\frac{d\mathcal{E}}{dt} = \frac{\mu}{2a^2} \frac{da}{dt} \qquad(12)
$$

联立 (11) 与 (12) 得  

$$
\frac{da}{dt} = \frac{2a^2}{\mu} \mathbf{v} \cdot \mathbf{a}_{\text{drag}} \qquad(13)
$$

再将 (1) 代入，得到更具物理直观性的方程  

$$
\frac{da}{dt} = -\frac{a^2}{\mu} \rho \frac{C_D A}{m} \|\mathbf{v}_r\| (\mathbf{v} \cdot \mathbf{v}_r) \qquad(14)
$$

式 (14) 定量给出了半长轴瞬时衰减率与大气密度、卫星弹道系数以及速度几何关系之间的联系 [@shoemaker2014; @rubincam1982]。由于大气密度和速度方向均随时间变化，$da/dt$ 并非恒定，通常需要数值积分求解总衰减量。

### 能量法的数值实现

由式 (13)，卫星从初始历元 $t_0$ 到 $t$ 的半长轴总变化量为  

$$
\Delta a(t) = a(t) - a(t_0) = \int_{t_0}^{t} \frac{da}{d\tau} d\tau
= \int_{t_0}^{t} \frac{2a^2(\tau)}{\mu} \mathbf{v}(\tau) \cdot \mathbf{a}_{\text{drag}}(\tau) d\tau \qquad(15)
$$

对于离散观测数据（例如从精密星历 CSV 文件读取的一系列轨道状态），可采用梯形法则近似：

$$
\Delta a \approx \sum_{i=1}^{n-1} \frac{1}{2} \left[ \left(\frac{da}{dt}\right)_i + \left(\frac{da}{dt}\right)_{i-1} \right] (t_i - t_{i-1}) \qquad(16)
$$

这种基于能量耗散直接积分得到半长轴衰减量的方法，相较于直接数值积分轨道状态向量具有更清晰的物理意义，且便于耦合不同的大气密度模型 [@frey2019; @kinghele2024]。

## 大气阻力摄动与高斯型变分方程的理论基础

### 高斯型摄动方程

高斯变分方程给出了摄动加速度分量对经典轨道根数 $(a, e, i, \Omega, \omega, M)$ 的瞬时变化率。对于阻力摄动（非保守力），其完整形式为 [@bate1971; @vallado2013]：

半长轴变化率  

$$
\frac{da}{dt} = \frac{2}{n\sqrt{1-e^2}} \left[ S e \sin f + T \frac{p}{r} \right] \qquad(17)
$$

偏心率变化率  

$$
\frac{de}{dt} = \frac{\sqrt{1-e^2}}{na} \left[ S \sin f + T\left( \cos f + \frac{r}{p}(1+e\cos f) \right) \right] \qquad(18)
$$

轨道倾角变化率  

$$
\frac{di}{dt} = \frac{r \cos(f+\omega)}{na^2\sqrt{1-e^2}} N \qquad(19)
$$

升交点赤经变化率  

$$
\frac{d\Omega}{dt} = \frac{r \sin(f+\omega)}{na^2\sqrt{1-e^2} \sin i} N \qquad(20)
$$

近地点幅角变化率  

$$
\frac{d\omega}{dt} = \frac{\sqrt{1-e^2}}{nae} \left[ -S \cos f + T \left(1+\frac{r}{p}\right) \sin f \right] - \cos i \frac{d\Omega}{dt} \qquad(21)
$$

平近点角变化率  

$$
\frac{dM}{dt} = n - \frac{2Sr}{na^2} - \frac{1-e^2}{nae} \left[ -S \cos f + T \left(1+\frac{r}{p}\right) \sin f \right] \qquad(22)
$$

式中：  
$n = \sqrt{\mu / a^3}$ —— 平均角速度；  
$p = a(1-e^2)$ —— 半通径；  
$r = p / (1+e\cos f)$ —— 地心距；  
$f$ —— 真近点角；  
$\omega$ —— 近地点幅角；  
$\Omega$ —— 升交点赤经；  
$i$ —— 轨道倾角；  
$M$ —— 平近点角。

### 基于高斯方程的半长轴摄动计算

由式 (17) 可知，半长轴的变化率主要由摄动加速度的径向分量 $S$ 和横向分量 $T$ 决定。对于大气阻力，$S$ 和 $T$ 均为负值，因此 $da/dt < 0$，半长轴不断减小。

数值实现时，给定初始轨道根数 $\mathbf{X}_0 = [a_0,e_0,i_0,\Omega_0,\omega_0,M_0]^\top$，通过时间步进积分（如四阶 Runge‑Kutta 方法）即可获得任意时刻的轨道根数：

$$
\mathbf{X}(t) = \mathbf{X}_0 + \int_{t_0}^t \dot{\mathbf{X}}(\tau)\, d\tau \qquad(23)
$$

其中 $\dot{\mathbf{X}}$ 由式 (17)–(22) 计算所得，$S,T,N$ 由式 (5) 和 (6) 呈现。积分过程中每一步都需要调用大气密度模型（本文采用JB2008大气模型）获取当前时间序列以及当前位置的瞬时密度 $\rho$，进而更新 $\mathbf{v}_r$ 和 $\mathbf{a}_{\text{drag}}$。这种严格积分摄动方程的方法称为高斯变分数值法，能够较为精确的反映大气阻力对轨道半长轴衰减的体现，并不像仅依赖于能量耗散的宏观积分 [@frey2019]。

## 平均轨道理论与长期衰减提取

### 密切轨道与平均轨道的基本概念

在摄动轨道力学中，任意时刻卫星的真实运动状态可由密切轨道（osculating orbit）精确描述。密切轨道假设该瞬时所有摄动加速度突然消失，卫星将严格沿一个二体 Kepler 轨道运行。密切轨道根数 $\boldsymbol{\sigma}_{\text{osc}} = (a_{\text{osc}}, e_{\text{osc}}, i_{\text{osc}}, \Omega_{\text{osc}}, \omega_{\text{osc}}, M_{\text{osc}})^\top$ 不仅包含长期演化趋势，还叠加了与轨道周期和地球自转周期同量级的高频短周期振荡。这些短周期项主要源于地球非球形引力场的田谐部分、大气密度随地方时的日变化以及太阳光压的周期性作用 [@vallado2013]。

为了研究轨道的长期演化行为（例如大气阻力引起的半长轴衰减），通常需要分离短周期项，仅保留平均轨道根数 $\bar{\boldsymbol{\sigma}} = (\bar{a}, \bar{e}, \bar{i}, \bar{\Omega}, \bar{\omega}, \bar{M})^\top$。平均根数反映了摄动力的累积效应，剔除了高频变化，从而使得长期变化可以用较简单的微分方程描述，并且可采用大步长数值积分，显著提高计算效率 [@brouwer1959; @lyden1987]。

### 平均化的数学定义与摄动分析

设卫星的真实状态 $\mathbf{x}(t)$ 满足运动方程  

$$
\frac{d\mathbf{x}}{dt} = \mathbf{f}_0(\mathbf{x}) + \varepsilon \mathbf{f}_1(\mathbf{x}, t), \qquad(24)
$$

其中 $\mathbf{f}_0$ 是 Kepler 主项，$\varepsilon \mathbf{f}_1$ 为小摄动项（$\varepsilon \ll 1$）。我们寻求一个近恒等变换  

$$
\mathbf{x} = \boldsymbol{\Phi}(\bar{\mathbf{x}}, t), \quad \boldsymbol{\Phi}(\bar{\mathbf{x}}, t) = \bar{\mathbf{x}} + \varepsilon \boldsymbol{\Phi}_1(\bar{\mathbf{x}}, t) + \varepsilon^2 \boldsymbol{\Phi}_2(\bar{\mathbf{x}}, t) + \cdots , \qquad(25)
$$

使得变换后的平均状态 $\bar{\mathbf{x}}$ 满足平均化运动方程  

$$
\frac{d\bar{\mathbf{x}}}{dt} = \bar{\mathbf{f}}(\bar{\mathbf{x}}) + O(\varepsilon^2), \qquad(26)
$$

其中 $\bar{\mathbf{f}}$ 不显含时间（或仅含长周期变化）。数学上，这等价于对摄动项在轨道周期 $T$ 上取平均：

$$
\bar{\mathbf{f}}_1(\bar{\mathbf{x}}) = \frac{1}{T} \int_0^{T} \mathbf{f}_1\big(\boldsymbol{\Phi}(\bar{\mathbf{x}}, t), t\big) \, dt, \qquad(27)
$$

实际操作中通常对轨道根数建立平均变分方程。设 $\boldsymbol{\sigma}$ 为密切根数，其变分方程为  

$$
\frac{d\boldsymbol{\sigma}}{dt} = \sum_k \mathbf{g}_k(\boldsymbol{\sigma}, t), \qquad(28)
$$

其中 $\mathbf{g}_k$ 对应第 $k$ 种摄动加速度产生的根数变化率。平均根数 $\bar{\boldsymbol{\sigma}}$ 定义为  

$$
\bar{\boldsymbol{\sigma}}(t) = \langle \boldsymbol{\sigma}(t) \rangle = \lim_{T\to\infty} \frac{1}{T} \int_{t-T/2}^{t+T/2} \boldsymbol{\sigma}(\tau) \, d\tau, \qquad(29)
$$

去除了所有周期项。则平均根数的运动方程为  

$$
\frac{d\bar{\boldsymbol{\sigma}}}{dt} = \sum_k \mathbf{G}_k(\bar{\boldsymbol{\sigma}}), \qquad(30)
$$

其中 $\mathbf{G}_k$ 是 $\mathbf{g}_k$ 的平均化结果。

### DSST 半解析法的平均化处理

DSST（Draper Semi-analytical Satellite Theory）对每个摄动项分别推导平均化后的贡献。下面给出主要摄动项的经典平均化公式。

#### 地球带谐项（$J_2$ 项）的平均化

地球非球形引力势的带谐部分在轨道根数下的摄动函数（以 $J_2$ 为例）为  

$$
R_{J_2} = \frac{\mu J_2 R_e^2}{2 r^3} \left(3\sin^2\varphi - 1\right), \qquad(31)
$$

其中 $R_e$ 为地球赤道半径，$\varphi$ 为地心纬度。经轨道要素展开并平均化后，得到长期变化率（拉格朗日行星方程的平均结果）[@brouwer1959]：

$$
\begin{aligned}
\frac{d\bar{a}}{dt} &= 0, \quad
\frac{d\bar{e}}{dt} = 0, \quad
\frac{d\bar{i}}{dt} = 0, \\[4pt]
\frac{d\bar{\Omega}}{dt} &= -\frac{3}{2} J_2 \frac{R_e^2}{\bar{a}^2} n \frac{\cos\bar{i}}{(1-\bar{e}^2)^2}, \\[4pt]
\frac{d\bar{\omega}}{dt} &= \frac{3}{4} J_2 \frac{R_e^2}{\bar{a}^2} n \frac{5\cos^2\bar{i} - 1}{(1-\bar{e}^2)^2}, \\[4pt]
\frac{d\bar{M}}{dt} &= n + \frac{3}{4} J_2 \frac{R_e^2}{\bar{a}^2} n \frac{\sqrt{1-\bar{e}^2}(3\cos^2\bar{i} - 1)}{(1-\bar{e}^2)^2},
\end{aligned}
\qquad(32)
$$

其中 $n = \sqrt{\mu/\bar{a}^3}$ 为平均角速度。注意带谐项对 $\bar{a}, \bar{e}, \bar{i}$ 无长期贡献（仅引起短周期振荡），因此长期衰减主要由非保守力（大气阻力）主导。

#### 大气阻力的平均化

对于大气阻力，摄动加速度为式 (5)。将其投影到 RTN 分量，代入高斯方程 (17)–(18) 得到 $\dot{a}$ 和 $\dot{e}$ 的瞬时表达式。在 DSST 中，采用共转大气假设，并认为密度随高度指数衰减，在轨道周期内对 $\dot{a}$ 取平均。忽略短周期变化，平均半长轴衰减率可写为 [@kinghele1964; @dersch2015]

$$
\frac{d\bar{a}}{dt} = -\frac{2}{\bar{n}} \frac{C_D A}{m} \bar{\rho} \bar{v}_r \bar{v}_t, \qquad(33)
$$

其中 $\bar{\rho}$ 是轨道高度上的平均密度，$\bar{v}_r$ 是平均相对速度大小，$\bar{v}_t$ 是平均横向速度（近似为 $\sqrt{\mu/\bar{a}}$）。更严格的 DSST 实现采用密度沿轨积分的方式，利用 JB2008 模型输出沿轨道一圈的平均密度 $\langle \rho \rangle$，然后近似  

$$
\frac{d\bar{a}}{dt} \approx -\frac{2}{\bar{n}} \frac{C_D A}{m} \langle \rho \, v_r^2 \rangle, \qquad(34)
$$

其中 $v_r^2 = v^2 + (\omega_e r)^2 - 2 v \omega_e r \cos\psi$，$\psi$ 为轨道面与赤道面的夹角。对于近圆轨道，可进一步简化。

#### 太阳光压与第三体引力

太阳光压加速度模型为  

$$
\mathbf{a}_{\text{srp}} = -C_r \frac{A}{m} P_{\odot} \frac{(\mathbf{r} - \mathbf{r}_{\odot})}{\|\mathbf{r} - \mathbf{r}_{\odot}\|^3}, \qquad(35)
$$

其中 $P_{\odot}$ 为太阳辐射压强（约 $4.56\times10^{-6}$ N/m²）。DSST 中将其平均化为沿速度方向和径向的长期效应，并引入日食因子。第三体（月球、太阳）引力摄动作为保守力，其平均化后得到 $\bar{\Omega}$、$\bar{\omega}$ 的长周期进动，对 $\bar{a}$ 无长期贡献 [@davidson2013]。

### 由密切轨道反演平均轨道：固定点转换

在星载 GPS 或精密星历（如 SP3）中，我们只能获得离散时刻的密切状态 $(\mathbf{r}_j, \mathbf{v}_j)$，需要反求出对应的平均轨道根数 $\bar{\boldsymbol{\sigma}}_j$。Orekit 中采用 FixedPointConverter 实现这一反演。

设正向映射 $\mathcal{P}$：给定平均根数 $\bar{\boldsymbol{\sigma}}$，通过添加所有力模型的短周期项得到密切根数  

$$
\boldsymbol{\sigma}_{\text{osc}} = \mathcal{P}(\bar{\boldsymbol{\sigma}}). \qquad(36)
$$

其逆映射 $\mathcal{P}^{-1}$ 理论上存在，但难以直接解析表达。FixedPointConverter 通过迭代求解下列方程  

$$
\bar{\boldsymbol{\sigma}} = \bar{\boldsymbol{\sigma}} + \big( \boldsymbol{\sigma}_{\text{osc}}^{\text{true}} - \mathcal{P}(\bar{\boldsymbol{\sigma}}) \big) \qquad(37)
$$

的固定点。具体迭代格式为：  

初始化 $\bar{\boldsymbol{\sigma}}^{(0)} = \boldsymbol{\sigma}_{\text{osc}}^{\text{true}}$；  
对 $k = 0,1,\dots$ 迭代：  

   $$
   \boldsymbol{\sigma}_{\text{osc}}^{(\text{rec})} = \mathcal{P}(\bar{\boldsymbol{\sigma}}^{(k)}), \quad
   \bar{\boldsymbol{\sigma}}^{(k+1)} = \bar{\boldsymbol{\sigma}}^{(k)} + \big( \boldsymbol{\sigma}_{\text{osc}}^{\text{true}} - \boldsymbol{\sigma}_{\text{osc}}^{(\text{rec})} \big); \qquad(38)
   $$

当 $\|\bar{\boldsymbol{\sigma}}^{(k+1)} - \bar{\boldsymbol{\sigma}}^{(k)}\|$ 小于阈值时停止。

可以证明，若 $\mathcal{P}$ 在平均根数附近是压缩映射，则该迭代线性收敛。由于短周期项的振幅通常很小（对半长轴而言典型值 $O(J_2 R_e^2/a) \sim 10^4$ m），迭代 3–5 次即可达到米级精度 [@orekitfixedpoint; @dersch2019]。该方法的优势是不依赖时间积分，可逐历元独立计算，非常适合批量处理。

### 长期半长轴衰减的提取

对于大气阻力主导的 LEO 卫星，平均半长轴 $\bar{a}(t)$ 在时间区间内近似线性衰减。设  

$$
\bar{a}(t) = a_0 + \dot{a} \cdot t + \delta a(t), \qquad(39)
$$

其中 $a_0$ 为初始平均半长轴，$\dot{a}$ 为线性衰减率（m/h），$\delta a(t)$ 为残余的短周期振荡及随机误差。通过最小二乘法拟合 $\dot{a}$ 和 $a_0$：

$$
\hat{\dot{a}} = \frac{\sum_{j=1}^{N} (t_j - \bar{t})(\bar{a}_j - \bar{\bar{a}})}{\sum_{j=1}^{N} (t_j - \bar{t})^2}, \quad
\hat{a}_0 = \bar{\bar{a}} - \hat{\dot{a}} \bar{t}, \qquad(40)
$$

其中 $\bar{t} = \frac{1}{N}\sum t_j$，$\bar{\bar{a}} = \frac{1}{N}\sum \bar{a}_j$。拟合优度用决定系数评估：

$$
R^2 = 1 - \frac{\sum (\bar{a}_j - \hat{a}_0 - \hat{\dot{a}} t_j)^2}{\sum (\bar{a}_j - \bar{\bar{a}})^2}. \qquad(41)
$$

残差序列  

$$
r_j = \bar{a}_j - (\hat{a}_0 + \hat{\dot{a}} t_j) \qquad(42)
$$

残差值反映了短周期项的残留与力学模型模拟的误差。如果残差呈现明显的周期性（比如GRCE-A卫星的 90 分钟 轨道周期），说明短周期分离不足，可能需要增加更精准力模型或进行更高阶的球谐函数展开项；如果残差随机且均方根值较小证明平均轨道提取的较为成功。

### Savitzky‑Golay 滤波器

在实际轨道数据处理中，从精密星历或星载 GPS 获得的半长轴序列常混杂高频噪声（如热层波动、姿态抖动引起的阻力系数瞬时变化）以及未被完全消除的短周期轨道振荡。为准确提取长期衰减趋势，需要对时间序列进行平滑处理。Savitzky‑Golay（S‑G）滤波器是一种基于局部多项式最小二乘拟合的有限长单位冲激响应（FIR）滤波器，由 Savitzky 和 Golay 于 1964 年提出 [@Savitzky1964]。与常见的移动平均滤波器不同，S‑G 滤波器在抑制高频噪声的同时，能够较好地保持信号的高阶矩特征（如峰值宽度和形状），因此特别适用于处理具有缓慢变化趋势的轨道衰减数据。

对于以索引 $i$ 为中心、窗口长度 $N = 2m+1$（$m$ 为正整数，$N$ 为奇数）的滑动窗口，假设窗口内的数据点 $\{ (x_j, y_j) \}_{j=-m}^{m}$ 可用 $k$ 次多项式（$k < N$）进行局部拟合：

$$
p(x) = c_0 + c_1 x + c_2 x^2 + \cdots + c_k x^k, \qquad(43)
$$

其中 $x_j$ 取等间距归一化坐标（通常令 $x_j = j$，窗口中心处 $x=0$），$y_j$ 为原始观测值。通过最小二乘法极小化残差平方和 $\sum_{j=-m}^{m} \bigl[ p(x_j) - y_j \bigr]^2$，确定多项式系数 $\{c_i\}$，则滤波后中心点的值即取多项式在 $x=0$ 处的估计值 $\tilde{y}_i = p(0) = c_0$。可以证明，该过程等价于对原始信号 $y_j$ 进行固定系数的卷积运算：

$$
	ilde{y}_i = \sum_{j=-m}^{m} h_j \, y_{i+j}, \qquad(44)
$$

其中卷积系数 $\{h_j\}$ 仅由窗口半径 $m$ 和多项式阶数 $k$ 决定，与具体数据无关 [@Schafer2011]。在实际应用中，通常取 $k=2$ 或 $4$，窗口长度对应数十分钟至数小时的轨道弧段（例如 $m$ 对应 10~20 个轨道周期）。S‑G 滤波器不仅可以平滑半长轴序列，还能够计算中心点的导数（通过 $c_1$ 给出），从而直接估计瞬时衰减率。与事后最小二乘拟合相比，S‑G 滤波可实时处理流式数据，且对局部非线性的适应性更强，因此在星上自主轨道预报和地面批量预处理中均有应用。
