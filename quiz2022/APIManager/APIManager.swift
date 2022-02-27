//
//  APIManager.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import Foundation

class APIManager {

     static func httpGet<T>(resClass: T.Type) where T : Decodable {
         let address: String = "https://android-quiz-29a4c.web.app/"
        guard let addressURL = URL(string: address) else { return }
        var urlRequest = URLRequest(url: addressURL)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if(data == nil || error != nil) {
                print("http error",error.debugDescription)
                return
            }
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else { return }
            
            print("Res: \(responseString)")
            
            
            do {
                let res = try JSONDecoder().decode(resClass, from: data)
                NotificationCenter.default.post(name: Notification.Name("APINotification"), object: res)
                
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

extension APIManager {
    static func doGetAPIData() {
        self.httpGet(resClass: LandscapeRes.self)
    }
}
