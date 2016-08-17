//
//  ViewController.swift
//  CocoaAsyncSocket-Swift
//
//  Created by zhuguangyang on 16/8/16.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController {
    
    ///端口
    @IBOutlet weak var portTF: UITextField!
    
    ///消息
    @IBOutlet weak var msgTF: UITextField!
    
    ///信息接收与发送显示
    @IBOutlet weak var infoTV: UITextView!
    
    /// 服务端Socket引用
    var serverSocket:GCDAsyncSocket?
    
    /// 客户端Socket引用
    var clientSocket:GCDAsyncSocket?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        
    }
    
    //用于添加提示内容
    func addText(text: String) {
        
        infoTV.text = infoTV.text.stringByAppendingFormat("%@\n", text)//换行
        
    }
    
    /**
     监听
     
     - parameter sender:
     */
    @IBAction func listeningAct(sender: AnyObject) {
        
        
        
        
        do {
            
            //连接端口号
            try serverSocket?.acceptOnPort(UInt16(portTF.text!)!)
            addText("监听成功")
            
        }catch _ {
            
            addText("监听失败")
        }
        
    }
    
    /**
     发送消息
     
     - parameter sender: UIBUtton
     */
    @IBAction func sendAct(sender: AnyObject) {
        
        let data = msgTF.text?.dataUsingEncoding(NSUTF8StringEncoding)
        
        //向客户端写入信息， -1 代表永不超时   tag 两边一样的标示
        clientSocket?.writeData(data!, withTimeout: -1, tag: 0)
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ViewController: GCDAsyncSocketDelegate {
    
    
    //连接新的Socket时执行
    func socket(sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        
        addText("连接成功")
        addText("连接地址" + newSocket.connectedHost!)
        addText("端口号" + String(newSocket.connectedPort))
        clientSocket = newSocket
        
        //首次开始读取Data
        clientSocket?.readDataWithTimeout(-1, tag: 0)
        
    }
    
    
    func socket(sock: GCDAsyncSocket, didReadData data: NSData, withTag tag: Int) {
        let message = String(data: data, encoding: NSUTF8StringEncoding)
        
        addText(message!)
        
        //再次准备读取Data,y以此来循环读取Data
        //轮寻
        sock.readDataWithTimeout(-1, tag: 0)
        
    }
    
}

