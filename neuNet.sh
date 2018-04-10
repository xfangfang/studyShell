#!/usr/bin/env bash

username="test"
password="test"

function changePassword() {
    basepath=$(cd `dirname $0`; pwd)/$0
    read -p "请输入账号" user
    sed -i '' '3s/test/'$user'/' $basepath;
    read -p "请输入密码" pawd
    sed -i '' '4s/test/'$pawd'/' $basepath;
}

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

function login() {
  url="https://ipgw.neu.edu.cn/srun_portal_pc.php?url=&ac_id=1"
  data="action=login&username="$1"&password="$2"&save_me=0"
  res=$(curl -H "User-Agent:$3" -s ${url} -d ${data})
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
  login $username $password "MAC OS"
elif [[ $1 = 1 ]]; then
  login $username $password "MAC OS"
elif [[ $1 = 2 ]]; then
  logout $username $password
elif [[ $1 = 3 ]]; then
  logout $username $password
  login $username $password "MAC OS"
elif [[ $1 = 4 ]]; then
  login $username $password "Android"
elif [[ $1 = 5 ]]; then
  getInfo
elif [[ $1 = 6 ]]; then
  changePassword
else
  echo 1电脑登陆,2全部退出,3电脑强制登陆,4手机登陆,5取上线信息,6,修改账号密码,默认强制登陆
fi


# 使用方法
# 默认强制登陆
# 参数为 1 登陆
# 参数为 2 退出
# 参数为 3 强制登陆
# 参数为 4 模拟手机登陆
# 参数为 5 上线信息
# 参数为 6 更改信息
