//
//  APIRequest.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/04.
//

import Foundation
import Alamofire

class API {
    
    enum PathType: String {
        case search
        case channels
    }
    
    static let shared = API()
    private let baseUrl = "https://www.googleapis.com/youtube/v3/"
    
    
    func request<T:Decodable>(path: PathType, params:[String: Any],type:T.Type, completion: @escaping (T) -> Void){
        let path = path.rawValue
        let url = baseUrl + path + "?"
        var params = params
        params["key"] = "AIzaSyDoCxbRXDQjB7BhwHBvIbrbjiHulcx6pMw"
        params["part"] = "snippet"
        
        //二つの似たような処理を一つにまとめるときに使用したパラメーターでの結合を自動でしてくれる
        let request = AF.request(url, method: .get, parameters: params)
        request.responseJSON { (response) in
            //httpsのレスポンスが300以上の時は処理は走らないので事前にifで制限をつけておく
            guard let statusCode = response.response?.statusCode else {return}
            if statusCode <= 300 {
                do {
                    let decoder = JSONDecoder()
                    guard let data = response.data else {return}
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                }catch{
                    print("変換に失敗しました。:",error)
                }
            }
        }
    }
}
