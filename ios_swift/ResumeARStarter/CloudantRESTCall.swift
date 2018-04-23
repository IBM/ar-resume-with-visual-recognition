/**
 
 Copyright 2017 IBM Corp. All Rights Reserved.
 Licensed under the Apache License, Version 2.0 (the 'License'); you may not
 use this file except in compliance with the License. You may obtain a copy of
 the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations under
 the License.
 */

import Foundation
import SwiftyJSON

class CloudantRESTCall {
    
    public static let FIND_DOCUMENTS = "/_find"
    
    // Cloudant URL
    let cloudantURL: String
    //cloudant database
    var database: String?
    
    init(cloudantUrl: String) {
        self.cloudantURL = cloudantUrl
    }
    
    func createDatabase(databaseName: String,completionHandler: @escaping (_ result: JSON) -> Void){
        let urlString = (self.cloudantURL + "/" + databaseName).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        guard let endpointURL: URL = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error while getting response")
                return
            }
            
            let field = httpResponse.statusCode
            guard field == 201 || field == 412 else {
                print("Error with authorization while creating database to cloudant.")
                return
            }
            
            // check for any errors
            guard error == nil else {
                print("error creating db data")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print("Database creation JSON: ",responseData)
            let dbDetails : JSON
            do{
                dbDetails = try JSON(data: responseData)
            }catch {
                print("Error: cannot create JSON")
                return
            }
            completionHandler(dbDetails)
        }
        task.resume()
    }
    
    func getResumeInfo(classificationId: String, completionHandler: @escaping (_ result: JSON) -> Void){
        let urlString = (self.cloudantURL + "/" + self.database! + CloudantRESTCall.FIND_DOCUMENTS).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        guard let endpointURL: URL = URL(string: urlString) else {
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
                print("Error with authorization while getting data from cloudant")
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
            let profileJSON : JSON
            do{
                profileJSON = try JSON(data: responseData)
                print("Profile JSON: ",profileJSON)
            }catch {
                print("Error: cannot create JSON from todo")
                return
            }
            completionHandler(profileJSON)
        }
        task.resume()
        
    }
    
    
    func updatePersonData(userData: JSON, completionHandler: @escaping (_ result: JSON) -> Void){
        let urlString = (self.cloudantURL + "/" + self.database!).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        guard let endpointURL: URL = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonQuery: Data
        do {
            jsonQuery = try userData.rawData()
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
            guard field == 201 else {
                print("Error with authorization while saving to cloudant database.")
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
                print("Error: cannot create JSON")
                return
            }
            completionHandler(profileJSON)
        }
        task.resume()
        
    }
}
