//
//  GetBreedsResponse.swift
//  MacPaw Internship Project
//
//  Created by user on 2020-05-20.
//  Copyright © 2020 TarasenkoSerhii. All rights reserved.
//

import Foundation

struct GetBreedsResponse {
    typealias JSON = [String: AnyObject]
    
    var breeds = [Breed]()
    
    init?(json: Any) {
        guard let array = json as? [JSON] else { return nil }
        
        var breeds = [Breed]()
        for dictionary in array {
            guard let breed = Breed(dict: dictionary) else { continue }
            breeds.append(breed)
        }
        self.breeds = breeds 
    }
    
}
