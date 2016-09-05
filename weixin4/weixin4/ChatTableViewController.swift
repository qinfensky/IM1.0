//
//  ChatTableViewController.swift
//  weixin4
//
//  Created by Eran Lee on 16/9/3.
//  Copyright © 2016年 Eran Lee. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController,XxDL {
    
    var talkWithName = ""
    
    @IBOutlet weak var messageContent: UITextField!

    //聊天记录
    var msgList = [WxMessage]()

    @IBAction func composing(sender: UITextField) {
        var xmlMessage = DDXMLElement.elementWithName("message") as! DDXMLElement
        
        //增加属性
        xmlMessage.addAttributeWithName("to", stringValue: talkWithName)
        xmlMessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
        
        //构件正文
        var composing = DDXMLElement.elementWithName("composing") as! DDXMLElement
        composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        
        xmlMessage.addChild(composing)
        zdl().xs!.sendElement(xmlMessage)
        
    }
    @IBAction func sendMessage(sender: UIBarButtonItem) {
        //获取文本框内容
        let msgStr = messageContent.text
        
        //如果文本框不为空
        if(msgStr!.isEmpty == false){
            //构建XML元素 message
            var xmlMessage = DDXMLElement.elementWithName("message") as! DDXMLElement
            
            //增加属性
            xmlMessage.addAttributeWithName("type", stringValue: "chat")
            xmlMessage.addAttributeWithName("to", stringValue: talkWithName)
            xmlMessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
            
            //构件正文
            var body = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(msgStr)
            
            //消息的子节点中加入正文
            xmlMessage.addChild(body)
            
            //通过通道发送XML文本
            zdl().xs!.sendElement(xmlMessage)
            
            //清空聊天框
            messageContent.text = ""
            
            //保存自己的信息
            var msg = WxMessage()
            msg.isMe = true
            msg.body = msgStr!
            
            //加入聊天记录
            msgList.append(msg)
            
            //刷新表格
            self.tableView.reloadData()
        }
    }
    
    //获取总代理
    func zdl() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //接管消息代理
        zdl().xxDl = self
    }
    
    //收到消息,实现协议
    func newMsg(aMsg: WxMessage) {
        
        if aMsg.isComposing{
            self.navigationController?.navigationItem.title = "正在输入中"
        }
        //如果消息不是空
        else if(aMsg.body != ""){
            msgList.append(aMsg)
            self.navigationItem.title = talkWithName
            
            //通知表格刷新
            self.tableView.reloadData()
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return msgList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath)

        //取对应的信息
        let msg = msgList[indexPath.row]
        
        //对单元格的文本做调整
        if(msg.isMe){
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.grayColor()
        
        }else{
            cell.textLabel?.textColor = UIColor.blueColor()
        }
        
        //设置单元格文本
        cell.textLabel?.text = msg.body
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
