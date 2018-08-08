#!/usr/bin/env bash

username="test"
password="toLocaleTimeString"

function changePassword() {
    read -p "请输入账号" user
    sed -i '' '3s/".*"/'\"$user\"'/' $0;
    read -p "请输入密码" pawd
    #假设密码中没有 \"
    sed -i '' '4s/".*"/'\"$pawd\"'/' $0;

    echo 可以登陆了
}

function getInfo() {
  k=$RANDOM
  urlInfo="https://ipgw.neu.edu.cn/include/auth_action.php?k="$k
  dataInfo="action=get_online_info&key="$k
  res=$(curl -s ${urlInfo} -d ${dataInfo} -k)
  item1=`echo $res | cut -d , -f 1`
  item6=`echo $res | cut -d , -f 6`
  item3=`echo $res | cut -d , -f 3`
  echo 已使用 $((item1/1048576)) M
  echo 余额 $item3 元
  echo 登陆地址 $item6
}

function login() {
  if [[ $username = "test" ]]; then
      changePassword
      echo 请重新登陆
  else
      url="https://ipgw.neu.edu.cn/srun_portal_pc.php?url=&ac_id=1"
      data="action=login&username="$1"&password="$2"&save_me=0"
      res=$(curl -H "User-Agent:$3" -s ${url} -d ${data} -k)
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
  fi
}

function logout() {
  url="https://ipgw.neu.edu.cn/include/auth_action.php"
  data="action=logout&username=$1&ajax=1"
  if [[ "$2" != "" ]]; then
      echo "退出所有设备"
      data=$data"&password=$2"
  else
      echo "退出当前设备"
  fi
  res=$(curl -s ${url} -d ${data} -k)
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
  logout $username
elif [[ $1 = 4 ]]; then
  login $username $password "Android"
elif [[ $1 = 5 ]]; then
  getInfo
elif [[ $1 = 6 ]]; then
  changePassword
else
  echo 1电脑登陆,2全部退出,3当前退出,4手机登陆,5取上线信息,6,修改账号密码,默认先退出后登陆
fi


# 使用方法
# 默认强制登陆
# 参数为 1 登陆
# 参数为 2 退出所有
# 参数为 3 退出当前
# 参数为 4 模拟手机登陆
# 参数为 5 上线信息
# 参数为 6 更改信息
