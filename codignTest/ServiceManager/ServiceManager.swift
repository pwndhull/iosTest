//
//  ServiceManager.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//
//
import Foundation

@objc protocol ServiceManagerDelegate{
    func onSuccessResponse( _ retrieveData : Data , _ response : URLResponse )
    func onFailureResponse ( _ response : URLResponse , _ error : Error )
}
class ServiceManager {
    
    var delegate : ServiceManagerDelegate! = nil
//    MARK:-  Post Request Base Code  -
    
    class func _requestPost (_ urlString : URL , method : String , parameters : [String : AnyObject] , completion:@escaping (_ data: Data? , _ response : URLResponse? , _ error: Error?) -> Void) {
        
        let api                          = urlString
        let request                     = NSMutableURLRequest(url: api)
        request.httpMethod              = method
        request.timeoutInterval         = 60
        var jsonData : Data!
        
        do{
        
            jsonData = try JSONSerialization.data(withJSONObject: parameters , options: JSONSerialization.WritingOptions.prettyPrinted)
            let dataString = String(data: jsonData, encoding: .utf8)!
            print("PAYLOAD is \(dataString)")
        
        }
        
        catch let error as NSError {
            print("Service Manager (error.description) : - \(error.description)")
        
        }
        
        request.httpBody                = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
            DispatchQueue.main.async {
                if let responseError = error {
                    completion( data , response , responseError )
                }
                else if let httpResponse = response as? HTTPURLResponse {
                    
                    print("HTTP RESPONSE CODE = \(httpResponse.statusCode)")
                    print("HTTP RESPONSE FOR: \(api) is = \(String(describing: data))")
                    if data != nil {
                        do {
                            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            print("JSON RESPONSE = \(jsonDictionary)")
                            if let errorCode = jsonDictionary.value(forKey: "errorCode") as? Int , errorCode == 403 {
                                
                            }else{
                                completion( data! , response , error )
                            }
                        }
                        catch {
                            completion( data! , response , error )
                        }
                    }
                    else {
                        completion( data! , response , error )
                    }
                }
            }
        }
        task.resume()
    }
//    MARK:-  Get Request Base Code  -
    class func _requestGet (_ urlString : URL , method : String ,  completion:@escaping (_ data: Data? , _ response : URLResponse? , _ error: Error?) -> Void) {
           
           let api                         = urlString
           let request                     = NSMutableURLRequest(url: api)
           request.httpMethod              = method
           request.timeoutInterval         = 60
//
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           
           let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
               DispatchQueue.main.async {
                   if let responseError = error {
                       completion( data , response , responseError )
                   }
                   else if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP RESPONSE FOR: \(api) is = \(String(describing: data))")

                       print("HTTP RESPONSE CODE = \(httpResponse.statusCode)")
                       
                       if data != nil {
                           do {
                            let jsonDictionary : NSArray = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                            
//                               print("JSON RESPONSE = \(jsonDictionary)")
                           }
                           catch {
                               completion( data! , response , error )
                           }
                       }
                       else {
                           completion( data! , response , error )
                       }
                   }
               }
           }
           task.resume()
       }
    
    
    
}
