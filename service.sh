#!/system/bin/sh
# ==============================================================================
#  Realme GT6 (RMX3800) / OPlus 电池深度解锁与容量释放守护脚本
#  功能：
#  1. 破解放电截止电压门限 (3300mV -> 3000mV)，完全释放底部 5%~8% 被锁电量
#  2. 重置深度放电惩罚计数与累积衰减偏差 (deep_dischg_counts)
#  3. 拦截提前满电策略，保证涓流恒压阶段吃饱真实物理容量
# ==============================================================================

# 等待系统引导完全就绪
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 3
done

sleep 5

# 1. 解锁放电截止电压 (强制下调至 3000mV)
VOTABLES="TARGET_SHUTDOWN_VOLTAGE GAUGE_SHUTDOWN_VOLTAGE TARGET_TERM_VOLTAGE GAUGE_TERM_VOLTAGE"
for v in $VOTABLES; do
    path="/proc/oplus-votable/$v"
    if [ -d "$path" ]; then
        chmod 666 "$path/force_val" 2>/dev/null
        chmod 666 "$path/force_active" 2>/dev/null
        echo 3000 > "$path/force_val" 2>/dev/null
        echo 1 > "$path/force_active" 2>/dev/null
    fi
done

# 2. 清零深放惩罚计数，防止系统内核加权扣减 FCC
if [ -f /sys/class/oplus_chg/common/deep_dischg_counts ]; then
    chmod 666 /sys/class/oplus_chg/common/deep_dischg_counts 2>/dev/null
    echo 0 > /sys/class/oplus_chg/common/deep_dischg_counts 2>/dev/null
fi
if [ -f /sys/class/oplus_chg/common/deep_dischg_count_cali ]; then
    chmod 666 /sys/class/oplus_chg/common/deep_dischg_count_cali 2>/dev/null
    echo 0 > /sys/class/oplus_chg/common/deep_dischg_count_cali 2>/dev/null
fi

# 3. 清除历史安卓系统电池假统计文件 (仅当首次或电量计失准时)
rm -f /data/system/batterystats.bin 2>/dev/null
rm -f /data/system/batterystats-checkin.bin 2>/dev/null

# 4. 后台常驻巡检守护：防止系统待机唤醒后重新覆盖恢复 3300mV
(
    while true; do
        sleep 60
        for v in $VOTABLES; do
            path="/proc/oplus-votable/$v"
            if [ -d "$path" ]; then
                cur_act=$(cat "$path/force_active" 2>/dev/null)
                if [ "$cur_act" != "1" ]; then
                    echo 3000 > "$path/force_val" 2>/dev/null
                    echo 1 > "$path/force_active" 2>/dev/null
                fi
            fi
        done
    done
) &
