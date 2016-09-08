#!/usr/bin/env bash

username="2015####"
password="######"
# echo 输入用户名
# read username
# echo 输入密码
# read password

url="http://ipgw.neu.edu.cn:804/srun_portal_pc.php?ac_id=1&"
data="action=login&ac_id=1&user_ip=&nas_ip=&user_mac=&url=&username="$username"&password="$password"&save_me=0"

offurl="http://ipgw.neu.edu.cn:804/include/auth_action.php"
offdata="action=logout&username=$username&password=$password&ajax=1"

offres=$(curl ${offurl} -d ${offdata})
echo ${offres}

res=$(curl ${url} -d ${data})

echo "$res" | grep -q "网络已连接" && echo '网络已连接'
echo "$res" | grep -q "E2531" && echo '帐号错误'
echo "$res" | grep -q "E2553" && echo '密码错误'
echo "$res" | grep -q "E2616" && echo '欠费'
echo "$res" | grep -q "E2606" && echo '未开通'
echo "$res" | grep -q "E2606" && echo '帐号异地正在登录'
echo "$res" | grep -q "You are already online" && echo '你已经在线'
