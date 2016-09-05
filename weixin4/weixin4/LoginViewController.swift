//
//  LoginViewController.swift
//  weixin4
//
//  Created by Eran Lee on 16/9/3.
//  Copyright © 2016年 Eran Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var localhost: UITextField!
    @IBOutlet weak var autoLogin: UISwitch!
    
    //需要登录
    var requireLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == self.doneButton{
            NSUserDefaults.standardUserDefaults().setObject(userName.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(password.text, forKey: "weixinPW")
            NSUserDefaults.standardUserDefaults().setObject(localhost.text, forKey: "weixinSV")
            
            //配置自动登录
            NSUserDefaults.standardUserDefaults().setBool(self.autoLogin.on, forKey: "wxautologin")
            
            //同步用户配置
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //需要登录
            requireLogin = true
        }
    }


}
