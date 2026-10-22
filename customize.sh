#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

ui_print "*****************************************"
ui_print "*  Realme GT6 / OPlus 电池深度解容模块  *"
ui_print "*  适用机型: RMX3800 / ColorOS / RealmeUI*"
ui_print "*****************************************"
ui_print "- 正在检查系统环境..."

MODEL=$(getprop ro.product.vendor.name)
[ -n "$MODEL" ] || MODEL=$(getprop ro.product.name)

ui_print "- 当前识别机型: $MODEL"
ui_print "- 正在设置开机服务脚本与守护权限..."

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/uninstall.sh 0 0 0755

ui_print "- 安装成功！重启后将自动解除 3.3V 关机锁容。"
ui_print "- 禁用或卸载本模块可 100% 恢复原厂设置。"
