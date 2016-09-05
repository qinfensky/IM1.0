//
//  AppDelegate.swift
//  weixin4
//
//  Created by Eran Lee on 16/9/3.
//  Copyright © 2016年 Eran Lee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate{

    var window: UIWindow?
    
    //通道
    var xs: XMPPStream?
    //服务器是否开启
    var isOpen = false
    //密码
    var pwd = ""
    
    //添加状态代理
    var ztDl:ZtDL?
    //添加消息代理
    var xxDl:XxDL?
    
    //连接成功
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        do{
       try xs!.authenticateWithPassword(pwd)
        }catch let error as NSError{ }
    }
    //验证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        goOnLine()
    }
    
    //收到状态
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        let myuser = sender.myJID.user   //我的用户名
        let user = presence.from().user  //好友用户名
        let domain = presence.from().domain
        let PType = presence.type()
        
        //如果状态不是自己
        if(user != myuser){
            var zt = Zhuangtai() //状态保存的结构
            zt.name = user + "@" + domain
            //上线
            if PType == "available"{
                zt.isOnLine = true
                ztDl?.isOn(zt)
            }else if PType == "unavailable"{
                ztDl?.isOff(zt)
            }
        }
    }
    
    //收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        if message.isChatMessage(){
            var msg = WxMessage()
            //对方正在输入中
            if message.elementForName("composing") != nil {
                msg.isComposing = true }
            //离线消息
            if message.elementForName("delay") != nil {
                msg.isDelary = true  }
            //消息正文
            if let body = message.elementForName("body"){
                msg.body = body.stringValue()}
            //完整用户名
            msg.from = message.from().user + "@" + message.from().domain
            //添加到代理中
            xxDl?.newMsg(msg)
        }
    }
    
    
    //建立通道
    func buildStream(){
        //无参初始化通道
        xs = XMPPStream()
        //设置代理
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    //发送上线状态
    func goOnLine(){
        var p = XMPPPresence()
        xs!.sendElement(p)
    }
    
    //发送下线状态
    func goOffLine(){
        var p = XMPPPresence(type: "unavailable")
        xs!.sendElement(p)
    }
    
    //连接服务器（查看服务器是否可连接）
    func connect() -> Bool{
        buildStream()
        
        //通道已连接
        if xs!.isConnected(){
            return true
        }
        //取系统中保存的用户名，密码，和服务器
        let user = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        let password = NSUserDefaults.standardUserDefaults().stringForKey("weixinPW")
        let server = NSUserDefaults.standardUserDefaults().stringForKey("weixinSV")
        
        if(user != nil && password != nil){
            //通道的用户名
            xs!.myJID = XMPPJID.jidWithString(user!)
            xs!.hostName = server!
            //保存密码
            pwd = password!
            
            do{
            try xs!.connect()
            }catch let error as NSError{  } //这里和视频中不一样
        }
        return false
    }
    
    //断开连接
    func disConnect(){
        
        if xs != nil{
            if xs!.isConnected(){
                //先下线
                goOffLine()
                //通道断开
                xs!.disconnect()
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

