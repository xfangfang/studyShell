#!/usr/bin/env bash

username="test"
password="test"

function getInfo() {
  k=$RANDOM
  urlInfo="https://ipgw.neu.edu.cn/include/auth_action.php?k="$k
  dataInfo="action=get_online_info&key="$k
  res=$(curl -s ${urlInfo} -d ${dataInfo})
  item1=`echo $res | cut -d , -f 1`
  item6=`echo $res | cut -d , -f 6`
  item3=`echo $res | cut -d , -f 3`
  echo 已使用 $((item1/1048576)) M
  echo 余额 $item3 元
  echo 登陆地址 $item6
}
function phoneLogin() {
  url="https://ipgw.neu.edu.cn/srun_portal_phone.php?url=&ac_id=1"
  data="action=login&username="$1"&password="$2"&save_me=0"
  res=$(curl -s ${url} -d ${data})
  k=$RANDOM
  urlInfo="https://ipgw.neu.edu.cn/include/auth_action.php?k="$k
  dataInfo="action=get_online_info&key="$k
  resInfo=$(curl -s ${urlInfo} -d ${dataInfo})
  if [[ $resInfo = "not_online" ]]; then
    echo $res | grep -q "E2531" && echo '帐号错误'
    echo $res | grep -q "E2553" && echo '密码错误'
    echo $res | grep -q "E2616" && echo '欠费'
    echo $res | grep -q "E2606" && echo '未开通'
    echo $res | grep -q "E2620" && echo '帐号异地正在登录'
  else
    echo '网络已连接'
    # getInfo
  fi
}
function login() {
  url="https://ipgw.neu.edu.cn/srun_portal_pc.php?url=&ac_id=1"
  data="action=login&username="$1"&password="$2"&save_me=0"
  res=$(curl -s ${url} -d ${data})
  if  echo $res | grep -q "网络已连接" ; then
   echo '网络已连接'
   getInfo
 else
    echo $res | grep -q "E2531" && echo '帐号错误'
    echo $res | grep -q "E2553" && echo '密码错误'
    echo $res | grep -q "E2616" && echo '欠费'
    echo $res | grep -q "E2606" && echo '未开通'
    echo $res | grep -q "E2620" && echo '帐号异地正在登录'
  fi
}

function logout() {
  url="https://ipgw.neu.edu.cn/include/auth_action.php"
  data="action=logout&username=$1&password=$2&ajax=1"
  res=$(curl -s ${url} -d ${data})
  echo ${res}
}

if [[ $1 = "" ]]; then
  logout $username $password
  login $username $password
elif [[ $1 = 1 ]]; then
  login $username $password
elif [[ $1 = 2 ]]; then
  logout $username $password
elif [[ $1 = 3 ]]; then
  logout $username $password
  login $username $password
elif [[ $1 = 4 ]]; then
  phoneLogin $username $password
elif [[ $1 = 5 ]]; then
  getInfo
fi


# 使用
# 默认强制登陆
# 参数一为登陆
# 参数二为退出
# 参数三为强制登陆
# 参数四为模拟手机登陆
# 参数五取上线信息
