//
//  NetworkLayer.swift
//  MacPaw Internship Project
//
//  Created by user on 2020-05-19.
//  Copyright © 2020 TarasenkoSerhii. All rights reserved.
//

import Foundation

class NetworkService {
    
    // Api Key
    let apiKey = "85d4232f-37dc-4d80-a63b-2fbfb2148b78"
    
    //MARK: Fetch breeds list
    func fetchTheBreedsList(completion: @escaping (GetBreedsResponse) -> ()){
        
        let headers = ["x-api-key": self.apiKey]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.thecatapi.com/v1/breeds?attach_breed=0")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in

            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                completion(GetBreedsResponse(json: json)!)
            } catch {
                print(error)
            }
            
        })
        dataTask.resume()
        
    }
    
    //MARK: Fetch image froom breed id
    func fetchImageFromBreed(breedId id: String, completion: @escaping(String) -> () ){
        let headers = ["x-api-key": self.apiKey]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.thecatapi.com/v1/images/search?breed_id=\(id)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let currentPicData = try decoder.decode([CurrentPicData].self, from: data)
                completion(currentPicData[0].url)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
          
            
        })
        
        dataTask.resume()
    }
}
