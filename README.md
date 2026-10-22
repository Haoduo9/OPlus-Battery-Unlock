# Realme GT6 (RMX3800) / OPlus 电池低压释放与解容模块

适用于 **真我 GT6 (RMX3800)** 以及搭载 `oplus_chg_v2` / `oplus-votable` 机制的 ColorOS 14 / 15 / 16、realme UI 机型。

---

## 解决的问题

1. **破解放电截止电压限制（3.30V -> 3.00V）**：
   * 原厂固件在内核投票客户端（`TARGET_SHUTDOWN_VOLTAGE`、`GAUGE_SHUTDOWN_VOLTAGE`、`TARGET_TERM_VOLTAGE`、`GAUGE_TERM_VOLTAGE`）写死了高门限 3300mV。
   * 导致电池电量尚存 5%~8%（约 300~400mAh）时系统便提前触发关机保护。
   * 本模块通过注入 `DEBUG_FORCE_CLIENT` 投票通道，将放电关机门限无损下放至 3000mV（硅碳负极/锂电安全放电标准下限），释放剩余锁死电量，彻底根治电量见底暴毙关机问题。

2. **清零深放扣减惩罚计数（`deep_dischg_counts`）**：
   * 自动清零欧加内核记录的异常深放计次，避免系统根据衰减算法持续压低 `battery_fcc`（满电容量上限）。

3. **重置假数据账本**：
   * 开机清理旧的安卓系统统计缓存，重新根据全新电压放电曲线建立准确电量映射。

---

## 模块特性

* **100% 纯用户态无损脚本**：无需修改系统 `system` / `vendor` / `odm` 只读分区。
* **随时还原**：在 Magisk / KernelSU / APatch 中关闭模块开关或卸载重启，系统底层自动恢复原厂默认值，毫无痕迹。

---

## 作者与鸣谢

* **Author**: 小六六 & 小小六
