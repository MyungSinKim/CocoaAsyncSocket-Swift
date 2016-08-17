//
//  ClientVC.swift
//  CocoaAsyncSocket-Swift
//
//  Created by zhuguangyang on 16/8/16.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ClientVC: UIViewController {
    
    
    
    
    /// IP地址
    @IBOutlet weak var iPTF: UITextField!
    
    
    /// 端口
    @IBOutlet weak var portTF: UITextField!
    
    /// 消息
    @IBOutlet weak var msgTF: UITextField!
    
    /// 信息显示
    @IBOutlet weak var infoTV: UITextView!
    
    
    var socket:GCDAsyncSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func addText(text: String) {
        
        infoTV.text = infoTV.text.stringByAppendingFormat("%@\n", text)
        
    }
    
    
    //连接
    @IBAction func connectionAct(sender: AnyObject) {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        do {
            try socket?.connectToHost(iPTF.text!, onPort:UInt16(portTF.text!)!)
            addText("连接成功")
        } catch _{
            addText("连接失败")
        }
        
    }
    
    
    //断开
    @IBAction func disConnectAct(sender: AnyObject) {
        socket?.disconnect()
        addText("断开连接")
    }
    
    
    //发送
    @IBAction func sendMsgAct(sender: AnyObject) {
        socket?.writeData((msgTF.text?.dataUsingEncoding(NSUTF8StringEncoding))!, withTimeout: -1, tag: 0)
    }
}

extension ClientVC: GCDAsyncSocketDelegate {
    func socket(sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        addText("连接服务器" + host)
        self.socket?.readDataWithTimeout(-1, tag: 0)
    }
    
    func socket(sock: GCDAsyncSocket, didReadData data: NSData, withTag tag: Int) {
        let msg = String(data: data, encoding: NSUTF8StringEncoding)
        
        addText(msg!)
        socket?.readDataWithTimeout(-1, tag: 0)
        
    }
}
