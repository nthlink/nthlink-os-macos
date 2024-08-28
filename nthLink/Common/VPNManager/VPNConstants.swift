//
//  VPNConstants.swift
//  nthLink
//
//  Created by Vaneet Modgill on 17/02/24.
//

import Foundation
import NetworkExtension

var serverConfig = """
{
    "log": {
        "level": "debug"
    },
    "dns": {
        "servers": [
            "1.1.1.1"
        ]
    },
    "inbounds": [
        {
            "protocol": "tun",
            "tag": "tun",
            "settings": {
                "fd": {{TUN-FD}},
                "fakeDnsExclude": [
                    "*"
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "chain",
            "tag": "Proxy",
            "settings": {
                "actors": [
                    "tls",
                    "ws",
                    "trojan"
                ]
            }
        },
        {
            "protocol": "tls",
            "tag": "tls",
            "settings": {
                "insecure": false
            }
        },
        {
            "protocol": "ws",
            "tag": "ws",
            "settings": {
                "path": "server_path"
            }
        },
        {
            "protocol": "trojan",
            "tag": "trojan",
            "settings": {
                "address": "server_address",
                "port": server_port,
                "password": "server_password"
            }
        }
    ]
}
"""

var vpnManager = NEVPNManager.shared()
let appGroup = "group.com.nthlink.macos.client"
let configKey = "CONFIG_KEY"

struct VPNConstants {
    static let localizedDescription = "nthLink"
    static let serverAddress = "nthLink"
}

