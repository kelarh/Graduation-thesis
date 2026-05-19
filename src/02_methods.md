# 理论基础

## 能量法计算半长轴衰减的理论基础

### 比机械能与半长轴的关系

在两体问题中，卫星在中心天体引力场中运动的比机械能（单位质量的总能量）是守恒量，由动能与势能之和给出：

$$
\mathcal{E} = \frac{v^2}{2} - \frac{\mu}{r} \tag{1}
$$

其中 $v = \|\mathbf{v}\|$ 为卫星速度大小，$r = \|\mathbf{r}\|$ 为地心距，$\mu = GM$ 为地球引力常数。

根据轨道力学的基本结果，比机械能也可以用轨道半长轴 $a$ 简单地表示为：

$$
\mathcal{E} = -\frac{\mu}{2a} \tag{2}
$$

这一关系对于椭圆轨道（$a>0$）成立，其物理意义在于：卫星的轨道能量完全由半长轴决定，且能量越低（越负）时轨道半径越小，卫星束缚越紧 [@vallado2013; @bate1971]。该式建立了轨道能量与轨道尺度的直接对应，为下文利用能量耗散率推导 $a$ 的变化率奠定了基础。

### 能量耗散与半长轴变化率

将比机械能 $\mathcal{E}$ 对时间求导：

$$
\frac{d\mathcal{E}}{dt} = \mathbf{v} \cdot \frac{d\mathbf{v}}{dt} + \frac{\mu}{r^3} \mathbf{r} \cdot \mathbf{v} \tag{3}
$$

地球中心引力加速度为 $-\dfrac{\mu}{r^3} \mathbf{r}$，因此卫星的总加速度为：

$$
\frac{d\mathbf{v}}{dt} = -\frac{\mu}{r^3}\mathbf{r} + \mathbf{a}_{\text{drag}} \tag{4}
$$

将式 (4) 代入式 (3)：

$$
\frac{d\mathcal{E}}{dt} = \mathbf{v} \cdot \left(-\frac{\mu}{r^3}\mathbf{r} + \mathbf{a}_{\text{drag}}\right) + \frac{\mu}{r^3} \mathbf{r} \cdot \mathbf{v}
= \mathbf{v} \cdot \mathbf{a}_{\text{drag}} \tag{5}
$$

可见，大气阻力引起的比机械能变化率 $\dot{\mathcal{E}}$ 仅由阻力加速度与速度的点积决定，该物理量即单位质量的阻力瞬时功率 $P_m = \mathbf{v} \cdot \mathbf{a}_{\text{drag}}$。

由式 (2)，比机械能与半长轴的关系可导出对时间的变化率：

$$
\frac{d\mathcal{E}}{dt} = \frac{d}{dt}\left(-\frac{\mu}{2a}\right) = \frac{\mu}{2a^2} \frac{da}{dt} \tag{6}
$$

综合式 (5) 与式 (6)，可得：

$$
\frac{\mu}{2a^2} \frac{da}{dt} = \mathbf{v} \cdot \mathbf{a}_{\text{drag}} \quad\Longrightarrow\quad
\frac{da}{dt} = \frac{2a^2}{\mu} \mathbf{v} \cdot \mathbf{a}_{\text{drag}} \tag{7}
$$

将式 (11)（阻力加速度表达式）代入式 (7)，可得更具物理直观性的方程：

$$
\frac{da}{dt} = -\frac{a^2}{\mu} \rho \frac{C_D A}{m} \|\mathbf{v}_r\| (\mathbf{v} \cdot \mathbf{v}_r) \tag{8}
$$

式 (8) 明确给出了半长轴的瞬时衰减率与大气密度、卫星弹道系数以及速度几何关系的定量联系 [@shoemaker2014; @rubincam1982]。由于大气密度和速度方向均随时间变化，$da/dt$ 并非恒定值，通常须通过数值积分求解半长轴的总衰减量。

### 能量法的数值实现

由式 (7)，卫星从初始历元 $t_0$ 到 $t$ 的半长轴总变化量可通过数值积分累加得到：

$$
\Delta a(t) = a(t) - a(t_0) = \int_{t_0}^{t} \frac{da}{d\tau} d\tau
= \int_{t_0}^{t} \frac{2a^2(\tau)}{\mu} \mathbf{v}(\tau) \cdot \mathbf{a}_{\text{drag}}(\tau) d\tau \tag{9}
$$

在离散观测数据下（例如从精密星历 CSV 文件读取的一系列时刻的轨道状态），半长轴变化量的近似值可采用梯形法则计算：

$$
\Delta a \approx \sum_{i=1}^{n-1} \frac{1}{2} \left[ \left(\frac{da}{dt}\right)_i + \left(\frac{da}{dt}\right)_{i-1} \right] \cdot (t_i - t_{i-1}) \tag{10}
$$

这种基于能量耗散直接积分得到半长轴衰减量的方法，相较于直接数值积分轨道状态向量具有更清晰的物理意义，且可以方便地与不同的大气密度模型耦合使用 [@frey2019; @kinghele2024]。


## 大气阻力摄动与高斯型变分方程的理论基础

### 大气阻力加速度模型

大气阻力是低地球轨道（LEO）卫星受到的最主要的非保守摄动力。根据流体动力学理论，阻力加速度的大小与大气密度、卫星的迎风面积、阻力系数以及卫星相对于大气的速度平方成正比，方向与相对速度矢量相反 [@kinghele1964; @vallado2013]：

$$
\mathbf{a}_{\text{drag}} = -\frac{1}{2} \rho \frac{C_D A}{m} v_r \mathbf{v}_r \tag{11}
$$

式中：

- $\rho$ —— 大气密度（kg/m³），随高度、太阳活动和地磁活动变化；
- $C_D$ —— 阻力系数（无量纲），通常取 2.2 ± 0.2，与卫星形状和表面材料有关；
- $A$ —— 卫星的参考迎风面积（m²）；
- $m$ —— 卫星质量（kg）；
- $\mathbf{v}_r$ —— 卫星相对于大气的速度矢量（m/s），$v_r = \|\mathbf{v}_r\|$。

定义弹道系数（ballistic coefficient）为 $B = \dfrac{C_D A}{m}$，则阻力加速度可简记为：

$$
\mathbf{a}_{\text{drag}} = -\frac{1}{2} \rho B v_r \mathbf{v}_r \tag{12}
$$

弹道系数集中反映了卫星自身属性对阻力摄动的敏感程度：$B$ 值越大，阻力作用越强，轨道衰减越快。

### 大气相对速度的确定

大气并非静止不动，而是随着地球自转近似以共转运动方式旋转。设地球自转角速度矢量为 $\boldsymbol{\omega}_e$（大小为 $\omega_e = 7.292115 \times 10^{-5}$ rad/s，方向沿地轴指向北极），则在惯性系（如 GCRF）中，大气共转速度可表示为 [@bate1971]：

$$
\mathbf{v}_{\text{atm}} = \boldsymbol{\omega}_e \times \mathbf{r} \tag{13}
$$

其中 $\mathbf{r}$ 为卫星的地心位置矢量。因此，卫星相对于大气的速度矢量为：

$$
\mathbf{v}_r = \mathbf{v} - \boldsymbol{\omega}_e \times \mathbf{r} \tag{14}
$$

将式 (14) 代入式 (11)，得到惯性系下完整的阻力加速度表达式：

$$
\mathbf{a}_{\text{drag}} = -\frac{1}{2} \rho B \|\mathbf{v} - \boldsymbol{\omega}_e \times \mathbf{r}\| (\mathbf{v} - \boldsymbol{\omega}_e \times \mathbf{r}) \tag{15}
$$

该模型已在 Orekit 等轨道动力学库中标准实现 [@orekitjb2008]。

### 阻力加速度在 RTN 坐标系下的分解

高斯型摄动方程通常采用 **RTN**（径向‑横向‑法向）坐标系描述摄动加速度分量。RTN 坐标系定义如下 [@vallado2013]：

- **径向单位矢量** $\hat{\mathbf{r}} = \mathbf{r} / r$，沿地心指向卫星；
- **横向单位矢量** $\hat{\mathbf{t}} = \hat{\mathbf{h}} \times \hat{\mathbf{r}}$，其中 $\hat{\mathbf{h}} = (\mathbf{r} \times \mathbf{v}) / \|\mathbf{r} \times \mathbf{v}\|$，在轨道平面内垂直于径向且指向运动方向；
- **法向单位矢量** $\hat{\mathbf{n}} = \hat{\mathbf{r}} \times \hat{\mathbf{t}}$，沿轨道角动量方向。

摄动加速度 $\mathbf{a}_{\text{drag}}$ 在 RTN 下的三个分量记为：

$$
S = \mathbf{a}_{\text{drag}} \cdot \hat{\mathbf{r}}, \quad
T = \mathbf{a}_{\text{drag}} \cdot \hat{\mathbf{t}}, \quad
N = \mathbf{a}_{\text{drag}} \cdot \hat{\mathbf{n}} \tag{16}
$$

其中 $S$ 为径向分量（正指向外），$T$ 为横向分量（正指向运动方向），$N$ 为法向分量（正指向轨道角动量方向）。对于大气阻力，由于相对速度 $\mathbf{v}_r$ 主要包含横向分量（轨道速度远大于大气共转速度），通常 $S$ 和 $T$ 为负值（阻力作用），而 $N$ 很小但非零（取决于大气共转与轨道倾角）。

### 高斯型摄动方程

高斯变分方程给出了摄动加速度分量对经典轨道根数 $(a, e, i, \Omega, \omega, M)$ 的瞬时变化率。对于阻力摄动（非保守力），其完整形式为 [@bate1971; @vallado2013]：

**半长轴变化率** 

$$
\frac{da}{dt} = \frac{2}{n\sqrt{1-e^2}} \left[ S e \sin f + T \frac{p}{r} \right] \tag{17}
$$

**偏心率变化率** 

$$
\frac{de}{dt} = \frac{\sqrt{1-e^2}}{na} \left[ S \sin f + T\left( \cos f + \frac{r}{p}(1+e\cos f) \right) \right] \tag{18}
$$

**轨道倾角变化率** 

$$
\frac{di}{dt} = \frac{r \cos(f+\omega)}{na^2\sqrt{1-e^2}} N \tag{19}
$$

**升交点赤经变化率** 

$$
\frac{d\Omega}{dt} = \frac{r \sin(f+\omega)}{na^2\sqrt{1-e^2} \sin i} N \tag{20}
$$

**近地点幅角变化率** 

$$
\frac{d\omega}{dt} = \frac{\sqrt{1-e^2}}{nae} \left[ -S \cos f + T \left(1+\frac{r}{p}\right) \sin f \right] - \cos i \frac{d\Omega}{dt} \tag{21}
$$

**平近点角变化率** 

$$
\frac{dM}{dt} = n - \frac{2Sr}{na^2} - \frac{1-e^2}{nae} \left[ -S \cos f + T \left(1+\frac{r}{p}\right) \sin f \right] \tag{22}
$$

式中各符号含义为：

- $n = \sqrt{\mu / a^3}$ —— 平均角速度；
- $p = a(1-e^2)$ —— 半通径；
- $r = p / (1+e\cos f)$ —— 地心距；
- $f$ —— 真近点角；
- $\omega$ —— 近地点幅角；
- $\Omega$ —— 升交点赤经；
- $i$ —— 轨道倾角；
- $M$ —— 平近点角。

### 基于高斯方程的半长轴摄动计算

由式 (17) 可见，半长轴的变化率主要由摄动加速度的径向分量 $S$ 和横向分量 $T$ 决定。对于大气阻力，$S$ 和 $T$ 均为负值，导致 $da/dt < 0$，即半长轴不断减小。

在数值实现中，给定初始轨道根数 $\mathbf{X}_0 = [a_0,e_0,i_0,\Omega_0,\omega_0,M_0]^\top$，通过时间步进积分（如四阶 Runge‑Kutta 方法）即可获得任意时刻的轨道根数：

$$
\mathbf{X}(t) = \mathbf{X}_0 + \int_{t_0}^t \dot{\mathbf{X}}(\tau)\, d\tau \tag{23}
$$

其中 $\dot{\mathbf{X}}$ 由式 (17)–(22) 计算，$S,T,N$ 由式 (16) 和 (15) 给出。积分过程中，每一步都需要调用大气密度模型（如 JB2008）获取当前时刻、当前位置的瞬时密度 $\rho$，并更新 $\mathbf{v}_r$ 和 $\mathbf{a}_{\text{drag}}$。这种严格积分摄动方程的方法称为**高斯变分数值法**，它能够精确反映大气阻力对轨道演化的累积效应，而不仅仅依赖于能量耗散的宏观积分 [@frey2019]。

### 大气密度模型 JB2008

式 (11) 中的大气密度 $\rho$ 是摄动计算的**关键输入**。由于其随高度、地方时、太阳活动（F10.7 指数及其 81 天均值）、地磁活动（Ap 和 Dst 指数）剧烈变化，必须采用经验或半经验模型进行计算。本文采用 **JB2008**（Jacchia‑Bowman 2008）热层密度模型，其主要特征如下 [@bowman2008]：

- 覆盖高度范围 175 km 至 1000 km，适用于绝大多数 LEO 卫星；
- 使用改进的太阳极紫外（EUV）和远紫外（FUV）辐射指标（$S_{10.7}$、$S_{10.7}^{81}$、$M_{10.7}$ 等）；
- 引入 $D_{st}$ 指数驱动地磁暴期间的全球密度响应；
- 与 CHAMP、GRACE、GOCE 等高精度加速度计反演密度比对，偏差优于 15%。

JB2008 已被 COSPAR 推荐为热层密度参考模型，并集成于 Orekit 等主流轨道动力学库中 [@pardini2026; @orekitjb2008]。


## 平均轨道理论与长期衰减提取

### 密切轨道与平均轨道的基本概念

在摄动轨道力学中，任意时刻卫星的真实运动状态可由**密切轨道**（osculating orbit）精确描述。密切轨道假设该瞬时所有摄动加速度突然消失，卫星将严格沿一个二体 Kepler 轨道运行。密切轨道根数 $\boldsymbol{\sigma}_{\text{osc}} = (a_{\text{osc}}, e_{\text{osc}}, i_{\text{osc}}, \Omega_{\text{osc}}, \omega_{\text{osc}}, M_{\text{osc}})^\top$ 不仅包含长期演化趋势，还叠加了与轨道周期和地球自转周期同量级的高频**短周期振荡**。这些短周期项主要源于地球非球形引力场的田谐部分、大气密度随地方时的日变化以及太阳光压的周期性作用 [@vallado2013]。

为了研究轨道的长期演化行为（例如大气阻力引起的半长轴衰减），通常需要分离出短周期项，仅保留**平均轨道根数** $\bar{\boldsymbol{\sigma}} = (\bar{a}, \bar{e}, \bar{i}, \bar{\Omega}, \bar{\omega}, \bar{M})^\top$。平均根数反映了摄动力的累积效应，剔除了高频变化，从而使得长期变化可以用较简单的微分方程描述，并且可采用大步长数值积分，显著提高计算效率 [@brouwer1959; @lyden1987]。

### 平均化的数学定义与摄动分析

设卫星的真实状态 $\mathbf{x}(t)$ 满足运动方程  

$$
\frac{d\mathbf{x}}{dt} = \mathbf{f}_0(\mathbf{x}) + \varepsilon \mathbf{f}_1(\mathbf{x}, t), \tag{24}
$$

其中 $\mathbf{f}_0$ 是 Kepler 主项（$\varepsilon$ 量级为零），$\varepsilon \mathbf{f}_1$ 为小摄动项（$\varepsilon \ll 1$）。我们寻求一个**近恒等变换**

$$
\mathbf{x} = \boldsymbol{\Phi}(\bar{\mathbf{x}}, t), \quad \boldsymbol{\Phi}(\bar{\mathbf{x}}, t) = \bar{\mathbf{x}} + \varepsilon \boldsymbol{\Phi}_1(\bar{\mathbf{x}}, t) + \varepsilon^2 \boldsymbol{\Phi}_2(\bar{\mathbf{x}}, t) + \cdots , \tag{25}
$$

使得变换后的平均状态 $\bar{\mathbf{x}}$ 满足**平均化运动方程**

$$
\frac{d\bar{\mathbf{x}}}{dt} = \bar{\mathbf{f}}(\bar{\mathbf{x}}) + O(\varepsilon^2), \tag{26}
$$

其中 $\bar{\mathbf{f}}$ 不显含时间（或仅含长周期变化）。数学上，这一过程等价于对摄动项在轨道周期 $T$ 上取平均：

$$
\bar{\mathbf{f}}_1(\bar{\mathbf{x}}) = \frac{1}{T} \int_0^{T} \mathbf{f}_1\big(\boldsymbol{\Phi}(\bar{\mathbf{x}}, t), t\big) \, dt, \tag{27}
$$

实际操作中通常对轨道根数建立平均变分方程，而不是直接对直角坐标。设 $\boldsymbol{\sigma}$ 为密切根数，其变分方程可写为

$$
\frac{d\boldsymbol{\sigma}}{dt} = \sum_k \mathbf{g}_k(\boldsymbol{\sigma}, t), \tag{28}
$$

其中 $\mathbf{g}_k$ 对应第 $k$ 种摄动加速度产生的根数变化率。平均根数 $\bar{\boldsymbol{\sigma}}$ 定义为

$$
\bar{\boldsymbol{\sigma}}(t) = \langle \boldsymbol{\sigma}(t) \rangle = \lim_{T\to\infty} \frac{1}{T} \int_{t-T/2}^{t+T/2} \boldsymbol{\sigma}(\tau) \, d\tau, \tag{29}
$$

去除了所有周期项（短周期）。则平均根数的运动方程为

$$
\frac{d\bar{\boldsymbol{\sigma}}}{dt} = \sum_k \mathbf{G}_k(\bar{\boldsymbol{\sigma}}), \tag{30}
$$

其中 $\mathbf{G}_k$ 是 $\mathbf{g}_k$ 的平均化结果。

### DSST 半解析法的平均化处理

**DSST**（Draper Semi-analytical Satellite Theory）对每个摄动项分别推导了平均化后的贡献。下面给出主要摄动项的经典平均化公式。

#### 地球带谐项（$J_2$ 项）的平均化

地球非球形引力势的带谐部分在轨道根数下的摄动函数为（以 $J_2$ 为例）

$$
R_{J_2} = \frac{\mu J_2 R_e^2}{2 r^3} \left(3\sin^2\varphi - 1\right), \tag{31}
$$

其中 $R_e$ 为地球赤道半径，$\varphi$ 为地心纬度。经轨道要素展开并保留到 $J_2$ 量级，平均化后得到长期变化率（拉格朗日行星方程的平均结果）[@brouwer1959]：

$$
\begin{aligned}
\frac{d\bar{a}}{dt} &= 0, \quad
\frac{d\bar{e}}{dt} = 0, \quad
\frac{d\bar{i}}{dt} = 0, \\[4pt]
\frac{d\bar{\Omega}}{dt} &= -\frac{3}{2} J_2 \frac{R_e^2}{\bar{a}^2} n \frac{\cos\bar{i}}{(1-\bar{e}^2)^2}, \\[4pt]
\frac{d\bar{\omega}}{dt} &= \frac{3}{4} J_2 \frac{R_e^2}{\bar{a}^2} n \frac{5\cos^2\bar{i} - 1}{(1-\bar{e}^2)^2}, \\[4pt]
\frac{d\bar{M}}{dt} &= n + \frac{3}{4} J_2 \frac{R_e^2}{\bar{a}^2} n \frac{\sqrt{1-\bar{e}^2}(3\cos^2\bar{i} - 1)}{(1-\bar{e}^2)^2},
\end{aligned}
\tag{32}
$$

其中 $n = \sqrt{\mu/\bar{a}^3}$ 为平均角速度。注意：带谐项对 $\bar{a}, \bar{e}, \bar{i}$ 无长期贡献（仅引起短周期振荡），因此长期衰减主要由非保守力（大气阻力）主导。

#### 大气阻力的平均化

对于大气阻力，摄动加速度为式 (15)。将其投影到 RTN 分量，代入高斯方程 (17)–(18) 得到 $\dot{a}$ 和 $\dot{e}$ 的瞬时表达式。在 DSST 中，采用**共转大气**假设，并认为密度随高度呈指数衰减，在轨道周期内对 $\dot{a}$ 取平均。忽略短周期变化，平均半长轴衰减率可写为 [@kinghele1964; @dersch2015]

$$
\frac{d\bar{a}}{dt} = -\frac{2}{\bar{n}} \frac{C_D A}{m} \bar{\rho} \bar{v}_r \bar{v}_t, \tag{33}
$$

其中 $\bar{\rho}$ 是轨道高度上平均密度，$\bar{v}_r$ 是平均相对速度大小，$\bar{v}_t$ 是平均横向速度（近似为 $\sqrt{\mu/\bar{a}}$）。更为严格的 DSST 实现采用**密度沿轨积分**的方式，利用 JB2008 模型输出沿轨道一圈的平均密度 $\langle \rho \rangle$，然后近似

$$
\frac{d\bar{a}}{dt} \approx -\frac{2}{\bar{n}} \frac{C_D A}{m} \langle \rho \, v_r^2 \rangle, \tag{34}
$$

其中 $v_r^2 = v^2 + (\omega_e r)^2 - 2 v \omega_e r \cos\psi$，$\psi$ 为轨道面与赤道面夹角。对于近圆轨道，可进一步简化。

#### 太阳光压与第三体引力

太阳光压加速度模型为

$$
\mathbf{a}_{\text{srp}} = -C_r \frac{A}{m} P_{\odot} \frac{(\mathbf{r} - \mathbf{r}_{\odot})}{\|\mathbf{r} - \mathbf{r}_{\odot}\|^3}, \tag{35}
$$

其中 $P_{\odot}$ 为太阳辐射压强（约 $4.56\times10^{-6}$ N/m²）。DSST 中将其平均化为沿速度方向和径向的长期效应，并引入日食因子。第三体（月球、太阳）引力摄动作为保守力，其平均化后得到 $\bar{\Omega}$、$\bar{\omega}$ 的长周期进动，对 $\bar{a}$ 无长期贡献 [@davidson2013]。

### 由密切轨道反演平均轨道：固定点转换

在星载 GPS 或精密星历（如 SP3）中，我们只能获得离散时刻的密切状态 $(\mathbf{r}_j, \mathbf{v}_j)$。需要反求出对应的平均轨道根数 $\bar{\boldsymbol{\sigma}}_j$。Orekit 中采用 **FixedPointConverter** 实现这一反演。

设正向映射 $\mathcal{P}$ 为：给定平均根数 $\bar{\boldsymbol{\sigma}}$，通过添加所有力模型的短周期项（即摄动函数的周期部分）得到密切根数

$$
\boldsymbol{\sigma}_{\text{osc}} = \mathcal{P}(\bar{\boldsymbol{\sigma}}). \tag{36}
$$

其逆映射 $\mathcal{P}^{-1}$ 理论上存在，但难以直接解析表达。FixedPointConverter 通过迭代求解下列方程

$$
\bar{\boldsymbol{\sigma}} = \bar{\boldsymbol{\sigma}} + \big( \boldsymbol{\sigma}_{\text{osc}}^{\text{true}} - \mathcal{P}(\bar{\boldsymbol{\sigma}}) \big) \tag{37}
$$

的固定点。具体迭代格式为：

1. 初始化 $\bar{\boldsymbol{\sigma}}^{(0)} = \boldsymbol{\sigma}_{\text{osc}}^{\text{true}}$；
2. 对 $k = 0,1,\dots$ 迭代：
   $$
   \boldsymbol{\sigma}_{\text{osc}}^{(\text{rec})} = \mathcal{P}(\bar{\boldsymbol{\sigma}}^{(k)}), \quad
   \bar{\boldsymbol{\sigma}}^{(k+1)} = \bar{\boldsymbol{\sigma}}^{(k)} + \big( \boldsymbol{\sigma}_{\text{osc}}^{\text{true}} - \boldsymbol{\sigma}_{\text{osc}}^{(\text{rec})} \big); \tag{38}
   $$
3. 当 $\|\bar{\boldsymbol{\sigma}}^{(k+1)} - \bar{\boldsymbol{\sigma}}^{(k)}\|$ 小于阈值时停止。

可以证明，若 $\mathcal{P}$ 在平均根数附近是压缩映射，则该迭代线性收敛。由于短周期项的振幅通常很小（对半长轴而言典型值 $O(J_2 R_e^2/a) \sim 10^4$ m），迭代 3–5 次即可达到米级精度 [@orekitfixedpoint; @dersch2019]。该方法的优势是**不依赖时间积分**，可逐历元独立计算，非常适合批量处理。

### 长期半长轴衰减的提取

对于大气阻力主导的 LEO 卫星，平均半长轴 $\bar{a}(t)$ 在时间区间内近似线性衰减。设

$$
\bar{a}(t) = a_0 + \dot{a} \cdot t + \delta a(t), \tag{39}
$$

其中 $a_0$ 为初始平均半长轴，$\dot{a}$ 为线性衰减率（m/h），$\delta a(t)$ 为残余的短周期振荡及随机误差。通过最小二乘法拟合 $\dot{a}$ 和 $a_0$：

$$
\hat{\dot{a}} = \frac{\sum_{j=1}^{N} (t_j - \bar{t})(\bar{a}_j - \bar{\bar{a}})}{\sum_{j=1}^{N} (t_j - \bar{t})^2}, \quad
\hat{a}_0 = \bar{\bar{a}} - \hat{\dot{a}} \bar{t}, \tag{40}
$$

其中 $\bar{t} = \frac{1}{N}\sum t_j$，$\bar{\bar{a}} = \frac{1}{N}\sum \bar{a}_j$。拟合优度用决定系数评估：

$$
R^2 = 1 - \frac{\sum (\bar{a}_j - \hat{a}_0 - \hat{\dot{a}} t_j)^2}{\sum (\bar{a}_j - \bar{\bar{a}})^2}. \tag{41}
$$

残差序列

$$
r_j = \bar{a}_j - (\hat{a}_0 + \hat{\dot{a}} t_j) \tag{42}
$$

反映了未被消除的短周期项和建模误差。若残差呈现明显的周期性（如约 90 分钟的轨道周期），说明短周期分离不足，可能需要增加力模型或调整平均化阈值；若残差随机且均方根值较小，则证明平均轨道提取成功。


### Savitzky-Golay滤波器


Savitzky‑Golay（S‑G）滤波器是一种基于局部多项式最小二乘拟合的有限长单位冲激响应（FIR）滤波器，由Savitzky和Golay于1964年提出[@Savitzky1964]。对于以索引 $i$ 为中心、长度 $N = 2m+1$（奇数）的滑动窗口，假设窗口内的数据点 $\{ (x_j, y_j) \}_{j=-m}^{m}$ 可用 $k$（$k < N$）次多项式拟合：

$$
p(x) = c_0 + c_1 x + c_2 x^2 + \cdots + c_k x^k, \tag{43}
$$

其中 $x_j$ 取等间距归一化坐标（通常 $x_j = j$，窗口中心 $x=0$）。通过最小二乘法极小化残差平方和 $\sum_{j=-m}^{m} \left[ p(x_j) - y_j \right]^2$ 确定系数 $\{c_i\}$，则滤波后中心点的值为 $p(0) = c_0$。该计算过程可等价为对原始信号 $y_j$ 的固定卷积运算：

$$
\tilde{y}_i = \sum_{j=-m}^{m} h_j \, y_{i+j}, \tag{44}
$$

其中卷积系数 $\{h_j\}$ 仅由 $m$ 和 $k$ 决定，与数据本身无关[@Schafer2011]。S‑G滤波器在抑制高频噪声的同时能较好地保持信号的峰值宽度和形状等高阶矩特征，因而广泛应用于光谱平滑、数值微分以及时间序列的预处理[@Cai2011]。