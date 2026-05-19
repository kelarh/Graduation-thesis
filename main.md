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

2003年万圣节磁暴是第23太阳活动周内最强的地磁扰动事件之一，对低地球轨道卫星产生了显著的轨道衰减影响。本文以CHAMP卫星为研究对象，利用其2003年10月1日至12月1日（约两个月）的L06精密轨道数据，系统研究了极端空间天气条件下卫星半长轴的衰减特征。数据来源于德国地学研究中心信息与数据中心，通过批处理下载、坐标转换（ITRF至GCRF）及数据清洗，形成高质量的Parquet格式数据集。为捕捉磁暴期间轨道衰减的时变特性，设计了窗口长度为1小时、步长为1小时的滑动窗口分析框架，并在每个窗口内独立运行三种不同原理的计算方法：能量法（基于机械能守恒及数值积分扣除保守力）、高斯变分数值积分法（严格积分高斯型摄动方程，耦合JB2008大气密度模型）以及DSST平均轨道提取法（辅以Savitzky‑Golay滤波）。同期空间天气指标（Dst、Kp、ap、F10.7）取自NASA OMNIWeb平台。

研究结果表明：平静期（Dst > –30 nT，Kp ≤ 3）CHAMP卫星的半长轴衰减率约为2.5–7.5 m/h；磁暴主相期间衰减率急剧增大，10月29日至11月1日峰值达到19.3 m/h（约为平静期的3.6倍），11月20日极端磁暴（Dst = –422 nT）峰值约为18.2 m/h，中等磁暴（Dst约–100 nT）也可使衰减率提升至8.8 m/h。三种方法计算的衰减率曲线在全时段几乎重合，最大偏差小于5%，验证了基于精密轨道数据反演磁暴期间轨道衰减的准确性与普适性。此外，衰减率峰值相对于Dst极小值存在约3–6小时的滞后，反映了热层大气对能量输入的响应时间。

本文所建立的滑动窗口分析框架及多方法互验流程，为低轨卫星在极端空间天气条件下的轨道衰减监测与预警提供了可靠的技术手段。未来可将该方法扩展至更多卫星任务和磁暴事件，融合高分辨率太阳风参数，发展机器学习短期预报模型，并推动开源共享，服务于空间天气业务化预警。

**关键词**：磁暴；CHAMP卫星；轨道衰减；半长轴；能量法；高斯变分方程；DSST；滑动窗口分析；空间天气

\newpage

# Abstract{-}

The 2003 Halloween storm is one of the strongest geomagnetic disturbance events during solar cycle 23, which caused significant orbital decay of low‑Earth‑orbit satellites. This study takes the CHAMP satellite as the research object and systematically investigates the semi‑major axis decay characteristics under extreme space weather conditions, using L06 precise orbit data from October 1 to December 1, 2003 (about two months). The data were obtained from the Information System and Data Center of the German Research Centre for Geosciences, and were processed through batch downloading, coordinate transformation (from ITRF to GCRF), and data cleaning, resulting in a high‑quality Parquet dataset. To capture the time‑varying nature of orbital decay during geomagnetic storms, a sliding‑window analysis framework with a window length of 1 hour and a step size of 1 hour was designed. Within each window, three independent methods were implemented: the energy method (based on conservation of specific mechanical energy and numerical integration to subtract conservative force contributions), the Gauss variational numerical integration method (strict integration of the Gauss planetary equations coupled with the JB2008 atmospheric density model), and the DSST mean orbital extraction method (supplemented with a Savitzky‑Golay filter). Concurrent space weather indices (Dst, Kp, ap, F10.7) were obtained from the NASA OMNIWeb platform.

The results show that during quiet periods (Dst > –30 nT, Kp ≤ 3), the decay rate of the CHAMP satellite’s semi‑major axis is approximately 2.5–7.5 m/h. During the main phase of geomagnetic storms, the decay rate increases sharply, reaching a peak of 19.3 m/h from October 29 to November 1 (about 3.6 times the quiet‑period level), and about 18.2 m/h during the extreme storm on November 20 (Dst = –422 nT). Even a moderate storm (Dst ≈ –100 nT) can raise the decay rate to 8.8 m/h. The decay rate curves obtained by the three methods nearly coincide over the entire period, with a maximum deviation of less than 5%, confirming the accuracy and universality of using precise orbit data to retrieve orbital decay during geomagnetic storms. Furthermore, the peak decay rate lags the Dst minimum by about 3–6 hours, reflecting the response time of the thermosphere to energy input.

The sliding‑window analysis framework and the multi‑method cross‑validation procedure established in this paper provide a reliable technical means for monitoring and warning of orbital decay of low‑Earth‑orbit satellites under extreme space weather conditions. Future work will extend the method to more satellite missions and magnetic storm events, integrate high‑resolution solar wind parameters, develop machine‑learning‑based short‑term forecast models, and promote open sharing, aiming to support operational space weather services.

**Keywords**: geomagnetic storm; CHAMP satellite; orbital decay; semi‑major axis; energy method; Gauss variational equations; DSST; sliding window analysis; space weather