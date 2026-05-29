---
# ============================================================
# 论文基本信息（同步自 main.tex）
# ============================================================
title: "极端空间天气对低轨卫星轨道衰减影响分析"
author: "黄庆浩"
date: "2026.6"
subject: "航天科学"

# ============================================================
# 模板配置（hnuthesis.cls）
# ============================================================
documentclass: templates/hnuthesis
classoption:
  - bachelor
  - super

# 目录与编号
toc: true
toc-depth: 3
number-sections: true

# 参考文献（hnunumerical.bst）
bibliography: [references/thesis_ref.bib]
link-citations: true

# 资源路径（确保 figures/ 可引用）
resource-path: ["figures", "."]

# ============================================================
# 模板元数据（写入 hnuthesis 变量）
# ============================================================
header-includes:
  - |
    \hnucode{10534}
    \hnuname{湖南科技大学}
    \degree{学士}
    \clc{TP391}
    \secrettext{公开}
    \title{极端空间天气对低轨卫星轨道衰减影响分析}
    \author{黄庆浩}
    \authorid{2222050219}
    \college{地球科学与空间信息工程学院}
    \major{测绘工程}
    \supervisor{何畅勇}
    \outsupervisor{}
    \submitdate{二〇二六年五月十九日}
---

\newpage

# 摘要 {-}

本文以2003年万圣节磁暴和2024年母亲节特大地磁暴为研究窗口，利用CHAMP（约410 km）和GRACE‑FO（约500 km）两颗卫星的精密轨道数据，采用能量法、高斯变分数值积分法和DSST平均轨道提取法三种独立手段反演半长轴的瞬时衰减速率与累计衰减量。通过1.5小时滑动窗口分析，三种方法在趋势上高度一致，但“性格”差异明显：高斯法对短时能量注入最敏感，主相峰值最高，适合捕捉尖峰结构；能量法平滑稳定，累计衰减估算更可靠；DSST加Savitzky‑Golay滤波后得到最干净的长周期曲线。两种磁暴事件均导致衰减率剧烈跃升——CHAMP从平静期的约−4 m/h跌至−17～−20 m/h，GRACE‑FO从约−1 m/h跌至−6～−8 m/h。有趣的是，更高轨道上的相对增幅（约5–6倍）反而超过了低轨（约4倍），这印证了热层膨胀时高海拔区域密度跳升更剧烈的物理直觉。

两次事件共享了多个特征：衰减率曲线呈现双峰甚至多峰结构，对应先后抵达的日冕物质抛射；恢复相衰减率回落极慢，暴后一周多仍明显高于背景水平，说明热层能量注入快、散得慢。将Kp指数后推6小时后做散点统计发现，低Kp下衰减率高度集中，高Kp下离散度急剧放大——Kp达到8–9时，CHAMP的衰减率能从−10 m/h跨到−17 m/h，GRACE‑FO也从−2.5 m/h拉到−6.0 m/h。这说明Kp这个三小时全球平均指数只能告诉你“地磁活动很剧烈”，但具体剧烈到什么程度、能量怎么灌进热层，还取决于CME的持续时长、行星际磁场南向分量的积分强度等细节。整体而言，本文建立了一套不依赖星载加速度计、仅凭精密轨道数据即可反演轨道衰减的技术流程，在第25太阳活动周峰年期间，这套方法可直接用于低轨航天器的轨道预报、碰撞规避和寿命评估。

**关键词**：低轨卫星，轨道衰减，空间天气，能量守恒，高斯变分方程

\newpage

# Abstract{-}

This study investigates two extreme geomagnetic storms—the 2003 Halloween storm and the 2024 Mother’s Day event—using precise orbit data from CHAMP (∼410 km) and GRACE‑FO (∼500 km). Three independent retrieval methods, namely the energy integral method, the Gauss variational numerical integration method, and the DSST mean‑orbit extraction method, are applied to estimate the instantaneous decay rate and cumulative decay of the semi‑major axis. With a 1.5‑hour sliding‑window analysis, the three methods show highly consistent trends but exhibit distinct characteristics: the Gauss method is most sensitive to short‑term energy injections, yielding the highest peaks during the main phase; the energy method is stable and reliable for cumulative decay estimation; and the DSST with Savitzky–Golay filtering produces the smoothest long‑term curves. Both storms caused dramatic increases in the decay rate—from a quiet‑time level of about −4 m/h to −17 – −20 m/h for CHAMP, and from about −1 m/h to −6 – −8 m/h for GRACE‑FO. Interestingly, the relative increase (∼5–6 times) is even larger at the higher altitude than at the lower one (∼4 times), confirming that the fractional density jump becomes more pronounced in the expanded thermosphere at higher altitudes.

The two events share several common features. The decay‑rate curves exhibit double‑peak or even multi‑peak structures, corresponding to successive coronal mass ejections. The recovery phase is remarkably slow—the decay rate remains significantly elevated for more than one week after the storm, indicating that the thermosphere heats up quickly but cools down slowly. After shifting the Kp index forward by 6 hours, scatter plots reveal that at low Kp the decay rates are tightly clustered, whereas at high Kp they become widely scattered. For example, at Kp = 8–9, the CHAMP decay rate ranges from −10 m/h to −17 m/h, and the GRACE‑FO decay rate ranges from −2.5 m/h to −6.0 m/h. This implies that the 3‑hour global average Kp index alone is insufficient to uniquely determine the thermospheric response amplitude during a storm; details such as the duration of the CME and the integrated strength of the southward interplanetary magnetic field also matter. Overall, this work establishes a technical workflow for retrieving orbit decay solely from precise orbit data without relying on onboard accelerometers. During the remaining peak years of Solar Cycle 25, this approach can be directly applied to orbit prediction, collision avoidance, and mission lifetime assessment for low‑Earth‑orbit spacecraft.

**Keywords**: Low Earth Orbit satellites, orbital decay, space weather, energy conservation, Gaussian variational equations