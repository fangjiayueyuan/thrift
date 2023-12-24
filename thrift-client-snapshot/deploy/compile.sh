#!/usr/bin/env bash
# 服务编译构建脚本。
#
# 注意：
# ----
# 如果项目在 Plus 发布系统上使用的是 MDP 发布类型，则项目不使用当前脚本。参见：https://km.sankuai.com/custom/onecloud/page/424823177#id-1%E6%A6%82%E8%A7%88

if [ ! -z "$APP_KEY" ]; then
    echo "start replace appkey...\n"
    find . -type f -name "app.properties" -exec sed -i '1s/app.name=.*/app.name='$APP_KEY'/g' {} +
fi

if [ -z "$ACTIVE_PROFILE" ]; then
    ACTIVE_PROFILE=$PLUS_TEMPLATE_ENV
fi
mvn clean package -P $ACTIVE_PROFILE -DskipTests=true -Dmaven.source.skip=true -Dsource.skip=true