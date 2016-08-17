//
//  Singleton.swift
//  CocoaAsyncSocket-Swift
//
//  Created by zhuguangyang on 16/8/17.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

enum SocketOffLineBy:Int {
    case SocketOffLineByServer = 0
    case SocketOffLineByUser = 1
}

class Singleton: NSObject {
    
    var socket: AsyncSocket?
    var socketHost:String?//Host 地址
    var socketPort: UInt16?// Port
    var connectTimer:NSTimer?   //计时器
    
    static let instanceThird = Singleton()
    
    //连接socket
    func socketConnectHost() {
        
        socket = AsyncSocket(delegate: self)
        
        do {
            try socket?.connectToHost(socketHost, onPort: socketPort!, withTimeout: -1)
            
        } catch _ {
            
        }
        
    }
    
    //切断socket
    func cutoffSocket() {
        
        self.socket?.setUserData(SocketOffLineBy.SocketOffLineByUser.rawValue)
        connectTimer?.invalidate()
        socket?.disconnect()
    }
}

extension Singleton : AsyncSocketDelegate{
    //MARK:- 连接成功回调
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("socket连接成功")
        connectTimer = NSTimer.init(timeInterval: 30, target: self, selector: #selector(Singleton.longConnectToSocket), userInfo: nil, repeats: true)
        connectTimer?.fire()
    }
    
    //未连接
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        print("连接者\(sock.userData())连接失败")
        if sock.userData() == SocketOffLineBy.SocketOffLineByServer.rawValue {
            //服务器掉线，重新连接
            socketConnectHost()
        } else if sock.userData() == SocketOffLineBy.SocketOffLineByUser.rawValue {
            
            //用户断开，不进行重连
            return
        }
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        //对得到的data值进行解析与转换即可
        
        socket?.readDataWithTimeout(30, tag: 0)
    }
    
    //心跳连接
    func longConnectToSocket() {
        
        //根据服务器要求发送固定格式的数据，假设为指令longConnect
        let longConnect = "longConnect";
        let dataStream = longConnect.dataUsingEncoding(NSUTF8StringEncoding)
        socket?.writeData(dataStream, withTimeout: -1, tag: 1)
        
        
    }
    
    
}
