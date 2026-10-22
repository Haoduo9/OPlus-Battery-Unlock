#!/system/bin/sh
# 卸载或禁用时恢复原厂默认值
VOTABLES="TARGET_SHUTDOWN_VOLTAGE GAUGE_SHUTDOWN_VOLTAGE TARGET_TERM_VOLTAGE GAUGE_TERM_VOLTAGE"
for v in $VOTABLES; do
    path="/proc/oplus-votable/$v"
    if [ -d "$path" ]; then
        echo 0 > "$path/force_active" 2>/dev/null
    fi
done
