//
//  Breed.swift
//  MacPaw Internship Project
//
//  Created by user on 2020-05-19.
//  Copyright © 2020 TarasenkoSerhii. All rights reserved.
//

import Foundation

struct Breed {
    let name: String
    let id: String
    
    init?(dict: [ String: AnyObject]) {
        guard let name = dict["name"] as? String,
            let id = dict["id"] as? String else { return nil }
        
        self.name = name
        self.id = id
    }
}
