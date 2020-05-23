//
//  User.swift
//  MacPaw Internship Project
//
//  Created by user on 2020-05-22.
//  Copyright © 2020 TarasenkoSerhii. All rights reserved.
//

import Foundation

class Results: NSObject ,NSCoding {
    
    var name: String
    var score: String
    
    init(name: String, score: String) {
        self.name = name
        self.score = score
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        score = aDecoder.decodeObject(forKey: "score") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(score, forKey: "score")
    }
    
}
