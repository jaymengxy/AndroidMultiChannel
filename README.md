# AndroidMultiChannel

使用360加固并通过美团 walle 注入多渠道信息

-----

## 用法

- 将`../multi-pack`放入项目的根目录下
- 修改`multi-pack.sh`文件中360加固账号名密码以及签名文件相关信息
- 在`../multi-pack/channel`中定义需要的渠道名
- 在`build.gradle`中添加执行脚本相关的代码
- 使用`assembleRelease`命令打 release 包，即可生成所有渠道包

## 说明

先对打出的 release 包进行加固，让后使用`zipalign`和`apksigner`对加固好的包进行对齐和签名，最后用 walle 注入渠道信息

### 加固

[360加固宝](https://jiagu.360.cn/#/global/index)

使用`../multi-pack/jiagu`目录下`3.2.1.3 for mac`版本加固助手的命令行加固方式

主要使用到的命令如下：

```shell
java -jar ../multi-pack/jiagu/jiagu.jar -login ${ACCOUNT_360} ${PASSWORD_360}
java -jar ../multi-pack/jiagu/jiagu.jar -jiagu ${APK_PATH} ${TEMP_PATH}
```

### 对齐和签名

使用的是`build-tools/28.0.3`下的`zipalign`和`apksigner`

主要使用到的命令如下：

```shell
../multi-pack/zipalign -v 4 ${JIAGU_APK_PATH} ${ZIP_ALIGN_APK_PATH}
../multi-pack/apksigner sign --ks ${APK_KEYSTORE_PATH} --ks-key-alias ${APK_KEY_ALIAS} --ks-pass pass:${APK_KEYSTORE_PWD} --key-pass pass:${APK_KEY_PWD} --out ${SIGNED_APK_PATH} ${ZIP_ALIGN_APK_PATH}
```

### 渠道包生成

[美团 walle](https://github.com/Meituan-Dianping/walle)

使用 walle 提供的 walle-cli 命令行程序，即`../multi-pack`目录下的`walle-cli-all.jar`

主要使用到的命令如下：

```shell
java -jar ../multi-pack/walle-cli-all.jar batch -f ../multi-pack/channel ${SIGNED_APK_PATH} ${CHANNELS_OUT_PATH}
```

官方release v1.1.6的 jar 包打出来的渠道包在 Android P 的手机上安装会出现`INSTALL_PARSE_FAILED_NO_CERTIFICATES`错误

可以查看 [issue#290](https://github.com/Meituan-Dianping/walle/issues/290)  [issue#264](https://github.com/Meituan-Dianping/walle/issues/264)

所以使用 @vclub 自己编译的 [walle-cli-all.jar](https://github.com/Meituan-Dianping/walle/issues/264#issuecomment-440888953) 解决了这个问题

## 参考资料

[walle issue#21](https://github.com/Meituan-Dianping/walle/issues/21)

[APK 签名方案 v2](https://source.android.google.cn/security/apksigning/v2)

[APK 签名方案 v3](https://source.android.google.cn/security/apksigning/v3.html)

[ProtectedApkResignerForWalle](https://github.com/Jay-Goo/ProtectedApkResignerForWalle)

[Android P v3签名新特性](https://xuanxuanblingbling.github.io/ctf/android/2018/12/30/signature/)
