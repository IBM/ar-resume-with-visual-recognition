//
//  CloudantRESTCall.swift
//  ResumeAR
//
//  Created by Sanjeev Ghimire on 12/18/17.
//  Copyright © 2017 Sanjeev Ghimire. All rights reserved.
//

import Foundation
import SwiftyJSON


class CloudantRESTCall {

    func getResumeInfo(classificationId: String, completionHandler: @escaping (_ result: JSON) -> Void){
        guard let endpointURL: URL = URL(string: Credentials.CLOUDANT_URL) else {
            print("Error: cannot create URL")
            return
        }
        
        let data: JSON = ["selector": ["classificationId": classificationId] ]
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonQuery: Data
        do {
            jsonQuery = try data.rawData()
            request.httpBody = jsonQuery
        } catch {
            print("Error: cannot create JSON from data")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
          
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error while getting response")
                return
            }
            
            let field = httpResponse.statusCode
            guard field == 200 else {
                print("Error with authorization")
                return
            }
            
            // check for any errors
            guard error == nil else {
                print("error getting profile data")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print("Profile JSON: ",responseData)
            let profileJSON : JSON
            do{
                 profileJSON = try JSON(data: responseData)
            }catch {
                print("Error: cannot create JSON from todo")
                return
            }
            completionHandler(profileJSON)
        }
        task.resume()
      
    }
    


}
