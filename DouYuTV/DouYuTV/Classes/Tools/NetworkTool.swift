//
//  NetworkTool.swift
//  AlamofireTest
//
//  Created by GaiPengwei on 2017/5/11.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType{
    case get
    case post
}

class NetworkTool {

    class func requestData(_ type : MethodType, requestURL : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(requestURL, method: method, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error as Any)
                return
            }
            
            // 4.结果回调
            finishedCallback(result)
            
        }
    }
}
