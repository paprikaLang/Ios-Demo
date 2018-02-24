//
//  Category.swift
//  TomorrowNews
//
//  Created by paprika on 2017/8/22.
//  Copyright © 2017年 paprika. All rights reserved.

import Foundation
import ObjectMapper
import Moya

struct CategoryIndexResponse: Mappable {
    var status : String!
    var count : Int!
    var categories : [Category]!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        categories <- map["categories"]
    }
}

struct Category: Mappable {
    var id : Int!
    var title : String!
    var count : Int!
    var slug : String!
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        count <- map["post_count"]
        slug <- map["slug"]
    }
}

extension Category {
    /// 获取新闻分类
    static func request(completion: @escaping ([Category]?) -> Void ) {
        
        let provider = MoyaProvider<MyServer>()
        
        provider.request(.category) { (result) in
            switch result {
            case let .success(moyaResponse):
                let json = try! moyaResponse.mapJSON() as! [String:Any]
                //jsonResponse的类型是CategoryIndexResponse
                if let jsonResponse = CategoryIndexResponse(JSON: json) {
                    
                    completion(jsonResponse.categories)
                    
                }
                
            case .failure:
                print("网络错误")
                completion(nil)
            }
        }
    }
}



