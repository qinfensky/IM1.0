//
//  WxMessage.swift
//  weixin4
//
//  Created by Eran Lee on 16/9/3.
//  Copyright © 2016年 Eran Lee. All rights reserved.
//

import Foundation

//消息模型
struct WxMessage {
    var body:String = ""
    var from:String = ""
    var isComposing:Bool = false
    var isDelary:Bool = false
    var isMe:Bool = false
}

//消息模型
struct Zhuangtai{
    var name: String = ""
    var isOnLine:Bool = false
}