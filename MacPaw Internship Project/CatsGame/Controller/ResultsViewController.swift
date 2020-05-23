//
//  ResultsViewController.swift
//  MacPaw Internship Project
//
//  Created by user on 2020-05-22.
//  Copyright © 2020 TarasenkoSerhii. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    
    var playerName = String()
    var playerScore = Int()

    var results = [Results]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadResults()
         if !playerName.isEmpty {
             addResultToList(name: playerName, score: playerScore)
         }
         
         saveResults()
         tableView.reloadData()
    }

    func saveResults() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: results, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "Results")
        }
    }
    
    func loadResults() {
        let defaults = UserDefaults.standard
        if let savedResults = defaults.object(forKey: "Results") as? Data {
            if let decodedResults = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedResults) as? [Results] {
                self.results = decodedResults
            }
        }
    }
    
    func addResultToList(name: String, score: Int) {
        let scoreString = String(score)
        results.append(Results(name: playerName, score: scoreString))
    }
    

}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RESULTS LIST"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        
        let sortedResults = results.sorted(by: {
            let score1 = Int($0.score)!
            let score2 = Int($1.score)!
           return score1 > score2
            
        })
        
        switch indexPath.row {
        case 0:
            cell.emojiLabel.text = "👑"
        case 1...5:
            cell.emojiLabel.text = "😻"
        default:
            cell.emojiLabel.text = "🐈"
        }
 
        cell.nameLabel.text = sortedResults[indexPath.row].name
        cell.scoreLabel.text = sortedResults[indexPath.row].score
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}
