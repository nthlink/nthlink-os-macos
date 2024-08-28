## Building leaf.xcframework

The steps to build `leaf.xcframework` are the same as for iOS, and the built `leaf.xcframework` can be used for both iOS and macOS. Please refer to the method in the iOS demo readme.

Similarly, place the `leaf.xcframework` in the root directory of the current demo so that you can open the project file `teonvpn-macos-demo.xcodeproj` with Xcode and compile it.

## About the macOS demo

The macOS demo is basically the same as the iOS demo.

This demo demonstrates the JSON format of leaf configuration, which is more flexible than the `.conf` format. The `.conf` format has a drawback that it does not escape `#`, causing parsing errors if a proxy configuration item contains `#`.

In the macOS demo, the environment variable `LOG_CONSOLE_OUT=true` is set in `PacketTunnel/PacketTunnelProvider.swift` to allow leaf's logs to be output to `Console.app`.
