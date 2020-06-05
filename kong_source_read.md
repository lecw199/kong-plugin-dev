# kong 源码阅读

## 目录结构分析
```
$ tree -L 1
```

├── CHANGELOG.md   
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── COPYRIGHT
├── DEVELOPER.md   // 开发者文档，主要是怎么安装openresty,怎么安装lua包
├── Jenkinsfile  
├── LICENSE
├── Makefile    // 重要文件， 提供了许多方便的make命令
├── README.md
├── UPGRADE.md
├── autodoc
├── bin      // busted 测试框架， grpcurl grpc客户端， kong命令
├── kong       // kong源码
├── kong-2.0.4-0.rockspec
├── kong.conf.default
├── lua-plugins   // 自定义lua插件
├── scripts
├── spec    // 测试代码
└── t      // nginx测试代码，基于Test::Nginx组件


tree没有打印出目录下的.ci文件，那我们指定文件夹名看看
```
$ tree -F -L 1  .ci
```

.ci
├── run_tests.sh*   // 执行test
├── setup_env.sh*   // 安装环境
└── trigger-travis.sh*  // github ci， tavis都是github ci相关的可以不用管



看看kong源码我呢就爱你夹
```
$ tree -F -L 1  --dirsfirst  kong
```

 
kong
├── api/
├── cluster_events/
├── cmd/
├── db/        // 数据库模块
├── pdk/
├── plugins/   // 已开源插件源码，这是我们这期要重点关注的
├── resty/
├── runloop/
├── status/
├── templates/   // 配置文件模版
├── tools/
├── vendor/
├── cache.lua
├── cache_warmup.lua
├── clustering.lua
├── concurrency.lua
├── conf_loader.lua
├── constants.lua
├── error_handlers.lua
├── global.lua
├── globalpatches.lua
├── hooks.lua
├── init.lua
├── meta.lua
├── reports.lua
├── router.lua
└── singletons.lua
