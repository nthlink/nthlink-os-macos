## 构建 leaf.xcframework

构建 `leaf.xcframework` 的步骤跟 iOS 一致，构建出来的 `leaf.xcframework` 可以同时用于 iOS 和 macOS，请参考 iOS demo readme 中的方法。

同样把 `leaf.xcframework` 放到当前 demo 的根目录即可用 Xcode 打开项目文件 `teonvpn-macos-demo.xcodeproj` 进行编译。

## 关于 macOS demo

macOS demo 基本上和 iOS demo 是一样的。

这个 demo 演示了 JSON 格式的 leaf 配置，JSON 格式比 `.conf` 格式更灵活。`.conf` 格式有一个缺点是没有对 `#` 进行转义导致如果某个代理配置项中包含 `#` 的话就会解析出错。

macOS demo 在 `PacketTunnel/PacketTunnelProvider.swift` 中设置了环境变量 `LOG_CONSOLE_OUT=true` 可以使 leaf 的日志输出到 `Console.app` 中。
