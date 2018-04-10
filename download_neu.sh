if [[ $1 = "" ]]; then
    echo 请在命令后输入账号和密码(用空格分开)
elif [[ $2 = "" ]]; then
    echo 请在命令后输入账号和密码(用空格分开)
else
    curl https://raw.githubusercontent.com/xfangfang/studyShell/master/neuNet.sh -o ./neu --progress
    sed -i '' '3s/test/'$1'/' ./neu
    sed -i '' '4s/test/'$2'/' ./neu
    chmod u+x ./neu
    mv ./neu /usr/local/bin/neu
fi
