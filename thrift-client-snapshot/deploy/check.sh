#!/usr/bin/env bash
# 服务启动后状态检查脚本。
#
# 注意：
# ----
# 如果项目在 Plus 发布系统上使用的是 MDP 发布类型，则项目不使用当前脚本。参见：https://km.sankuai.com/custom/onecloud/page/424823177#id-1%E6%A6%82%E8%A7%88

set

k=1
echo "check service......"

if [[ -z ${WAIT_SECONDS} ]]; then
    WAIT_SECONDS=30
fi

if [ -z $TEST_URL ]; then
    TEST_URL="127.0.0.1:8080/monitor/alive"
fi

for k in $(seq 1 $WAIT_SECONDS)
do
    sleep 1
    STATUS_CODE=`curl -o /dev/null -s -w %{http_code} $TEST_URL`
    if [ "$STATUS_CODE" = "200" ];then
        echo "$k request test_url:$TEST_URL succeeded!"
        echo "$k response code:$STATUS_CODE"
        break;
    elif [ "$STATUS_CODE" = "000" ];then
        echo "$k request test_url:$TEST_URL failed!"
        echo "$k response code: $STATUS_CODE"
    else
        echo "$k request test_url:$TEST_URL failed!"
        echo "$k response code: $STATUS_CODE"
        exit -1
    fi
    if [ $k -eq $WAIT_SECONDS ];then
        echo "have tried ${k} times, no more try"
        echo "failed"
        exit -1
    fi
done

#测试环境安装arthas
function getEnv(){
    FILE_NAME="/data/webapps/appenv"
    PROP_KEY="env"
    PROP_VALUE=""
    if [[ -f "$FILE_NAME" ]]; then
        PROP_VALUE=`cat ${FILE_NAME} | grep -w ${PROP_KEY} | cut -d'=' -f2`
    fi
    echo $PROP_VALUE
}

function installArthas() {
    if [ -z "$ARTHAS_ENABLED" ]; then
        ARTHAS_ENABLED=true
    fi
    if [ "$ARTHAS_ENABLED" != "true" ]; then
        echo "arthas is disabled."
        return
    fi

    if [ ! -d arthas ]; then
        mkdir arthas
    fi
    cd arthas || return
    if [ ! -x as.sh ]; then
        echo "Need to download and install arthas."
        curl -s -O https://s3plus.sankuai.com/v1/mss_c517ad14def1420690117f60f5150b79/arthas/arthas-3.6.1-mdp.tar.gz
        tar -xzf arthas-3.6.1-mdp.tar.gz
        sh install-local.sh
        echo "Successfully installed arthas."
    else
        echo "Found arthas, no need to install."
    fi
    if [ -x as.sh ]; then
        # 获取 pid
        WORK_PATH=${WORK_PATH:-/opt/meituan/$APP_KEY}
        echo "WORK_PATH: $WORK_PATH"

        targetPackage=$(find "$WORK_PATH" -maxdepth 1 -type f \( -name "*.jar" -o -name "*.war" \) -exec basename {} \;)
        echo "targetPackage: $targetPackage"

        pid=$(ps -ef | grep java | grep "$targetPackage" | awk '{print $2}')
        echo "PID: $pid"

        if [ -z "$pid" ]; then
            echo "Failed to get pid."
            return
        fi

        # 信安要求监听调试端口，并通过JumperProxy方案对JDWP端口自动转发， @DATE:20230413，详细参考 https://km.sankuai.com/collabpage/1640345815
        # 特别说明：目前只支持 HTTP 协议，不支持 Telnet 协议，所以设置 Telnet 端口为 0
        ./as.sh "$pid" --target-ip 127.0.0.1 --telnet-port 0 --http-port 44398 --attach-only
    fi
    echo "Successfully enabled arthas."
    cd ..
}

whoami
echo $PATH

ENV=`getEnv`
if [ "$ENV" == "test" ]; then
    installArthas
fi
exit 0