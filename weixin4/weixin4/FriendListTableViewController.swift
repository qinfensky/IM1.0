//
//  FriendListTableViewController.swift
//  weixin4
//
//  Created by Eran Lee on 16/9/3.
//  Copyright © 2016年 Eran Lee. All rights reserved.
//

import UIKit

class FriendListTableViewController: UITableViewController,ZtDL, XxDL{
    
    @IBOutlet weak var logstate: UIBarButtonItem!
    
    @IBAction func login(sender: UIBarButtonItem) {
        if logged{
            
            logoff()
            sender.image = UIImage(named: "no")
        }else{
            login()
            sender.image = UIImage(named: "on")
        }
    }
    //未读消息数组
    var unreadList = [WxMessage]()
    //好友状态数组
    var ztList = [Zhuangtai]()
    //聊天对象好友用户名
    var currentFriendName = ""
    
    var logged = false
    //XxDL代理实现
    //收到离线或未读消息
    func newMsg(aMsg: WxMessage) {
        //如果消息不是空
        if(aMsg.body != ""){
            unreadList.append(aMsg)
            
            //通知表格刷新
            self.tableView.reloadData()
        }
        
    }
    
    //ZtDL代理实现
    //自己离线
    func meOff() {
        logoff()
    }
    //上线状态处理
    func isOn(zt: Zhuangtai) {
        //逐条处理
        for(index, oldzt) in ztList.enumerate()  {
            if (zt.name == oldzt.name){
            ztList.removeAtIndex(index)
                break
            }
        }
        //添加新状态到状态数组列表
        ztList.append(zt)
        
        //通知表格视图更新
        self.tableView.reloadData()
    }
    //下线状态处理
    func isOff(zt: Zhuangtai) {
        for(index, oldzt) in ztList.enumerate(){
            if (zt.name == oldzt.name){
            ztList[index].isOnLine = false
                break
            }
        }
        self.tableView.reloadData()
    }
    //获取总代理
    func zdl() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //登入
    func login() {
        zdl().connect()
        logstate.image = UIImage(named: "on")
        logged = true
        
        //获取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        self.navigationItem.title = myID! + "的好友"
        
        //通知当前视图更新
        self.tableView.reloadData()
    }
    
    //登出
    func logoff(){
    
        //清空未读和状态数组
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        zdl().disConnect()
        logstate.image = UIImage(named: "no")
        logged = false
        
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //获取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        
        //取自动登录
        let autologin = NSUserDefaults.standardUserDefaults().boolForKey("wxautologin")
        
        //如果配置了用户名和自动登录，这自动登录
        if(myID != nil && autologin != false){
            self.login()
            
            
            //其他情况转到登录界面
        }else{
            self.performSegueWithIdentifier("tologin", sender: self)
        }
        
    
       
  

    }
    
    override func viewDidAppear(animated: Bool) {
       
        //接管消息代理
        zdl().xxDl = self
        //接管状态代理
        zdl().ztDl = self
       
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
        return ztList.count
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendListCell", forIndexPath: indexPath) as UITableViewCell

        
        //好友名称
        let name = ztList[indexPath.row].name
        
        //未读消息条数
        var unreadNumber = 0
        
        //查找相应好友未读消息数
        for msg in unreadList{
            if (name == msg.from){
                unreadNumber++
            }
        }
        
        //单元格文本
        cell.textLabel?.text = name + "(\(unreadNumber))"
        
        //好友状态
        let onLine = ztList[indexPath.row].isOnLine
        //根据在线状况，调整头像
        if onLine{
            cell.imageView?.image = UIImage(named: "on")
        }else{
            cell.imageView?.image = UIImage(named: "off")
        }
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //保存好友用户名
        currentFriendName = ztList[indexPath.row].name
        
        //清除未读条数
        
        
        //跳转到聊天界面
        self.performSegueWithIdentifier("toChat", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //判断是否转到聊天界面
        if(segue.identifier == "toChat"){
            //取得聊天视图控制器
            let dest = segue.destinationViewController as! ChatTableViewController
            
            //把当前选择单元的用户名传递给聊天视图
            dest.talkWithName = currentFriendName
            
            //把未读消息传递给聊天视图
            for msg in unreadList{
                if msg.from == currentFriendName{
                    dest.msgList.append(msg)
                }
            }
            //清除当前聊天对象未读信息从未读信息组中删除(这里对数组的操作需要好好理解)
//            removeValueFromArray("currentFriendName", aArray: &unreadList)
            unreadList = unreadList.filter{$0.from != self.currentFriendName }
        
            
            //更新表格
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindForSegue(unwindSegue: UIStoryboardSegue) {
        //如果登录界面的完成按钮点击了，开始登录
        let source = unwindSegue.sourceViewController as! LoginViewController
        
        if source.requireLogin {
            //注销前个登录用户
            self.logoff()
            self.login()
        }
    }
    
    //获取正确的删除索引
    func getRemoveIndex(value:String, aArray:[WxMessage]) ->[Int]{
        var rightIndex = [Int]()
        var correctArray = [Int]()
        
        for (index, _) in aArray.enumerate(){
            if(value == aArray[index].from){
                rightIndex.append(index)
            }
        }
        
        for(index, originIndex) in rightIndex.enumerate(){
            var y = 0
            
            y = originIndex - index
            
            correctArray.append(y)
            
        }
        return correctArray
    }
    //根据正确的删除索引，删除掉数组中的元素
    func removeValueFromArray(value:String, inout aArray:[WxMessage]){
        var correctArray = [Int]()
        correctArray = getRemoveIndex(value, aArray: aArray)
        
        //从原数组中删除指定单元（用正确的索引）
        for index in correctArray{
            aArray.removeAtIndex(index)
        }
        
    }

}
