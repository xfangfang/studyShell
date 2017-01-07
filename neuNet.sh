#!/usr/bin/env bash

# echo 输入用户名
# read username
# echo 输入密码
# read password
flag="1"
echo 输入1登录，输入2下线
read flag
if [[ "$flag"x = "1"x ]]; then
  url="https://ipgw.neu.edu.cn/srun_portal_pc.php?url=&ac_id=1"
  data="action=login&username="$username"&password="$password"&save_me=0"
  res=$(curl ${url} -d ${data})
  echo "$res" | grep -q "网络已连接" && echo '网络已连接'
  echo "$res" | grep -q "E2531" && echo '帐号错误'
  echo "$res" | grep -q "E2553" && echo '密码错误'
  echo "$res" | grep -q "E2616" && echo '欠费'
  echo "$res" | grep -q "E2606" && echo '未开通'
  echo "$res" | grep -q "E2606" && echo '帐号异地正在登录'
  echo "$res" | grep -q "You are already online" && echo '你已经在线'
elif [[ "$flag"x = "2"x ]]; then
  offurl="https://ipgw.neu.edu.cn/include/auth_action.php"
  offdata="action=logout&username=$username&password=$password&ajax=1"
  offres=$(curl -q ${offurl} -d ${offdata})
  echo ${offres}
fi
