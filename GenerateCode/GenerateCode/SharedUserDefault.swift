//
//  SharedUserDefault.swift
//  GenerateCode
//
//  Created by zhengjiacheng on 2018/1/24.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

import Cocoa

let SharedUserDefaultSuiteName = "group.com.zhengjiacheng.generate-code"
let MappingKey = "JCMappingKey"

class SharedUserDefault: NSObject {
    static let shared = SharedUserDefault.init()
    var sharedUD: UserDefaults!
    
    fileprivate var _mapping: [String: String] = [:]
    var mapping: [String: String] {
        if let map = UserDefaults(suiteName: SharedUserDefaultSuiteName)?.value(forKey: MappingKey) as? [String: String]{
            return map
        }
        return [:]
    }
    
    private override init(){
        sharedUD = UserDefaults(suiteName: SharedUserDefaultSuiteName)
        if let map = sharedUD.value(forKey: MappingKey) as? [String: String]{
            _mapping = map
        }
    }
    
    func saveMapping(dic: [String: String]){
        self.sharedUD.set(dic, forKey: MappingKey)
        self.sharedUD.synchronize()
        _mapping = dic
    }
    
}
