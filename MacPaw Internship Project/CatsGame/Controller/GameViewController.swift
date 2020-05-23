//
//  ViewController.swift
//  MacPaw Internship Project
//
//  Created by user on 2020-05-19.
//  Copyright © 2020 TarasenkoSerhii. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: Variables & Constants
    var scores = 0
    var lifes = 9
    var playerName = String()
    var rightAnswersLine = 0
    var gameOver = true
    
    var imageUrl: URL?
    var breeds = [Breed]()
    let network = NetworkService()
    
    var breedForRound: Breed?
    var breedsForRound = [Breed]()
    
    
    var image: UIImage? {
        get {
            return catImage.image
        } set {
            catImage.image = newValue
            catImage.contentMode = .scaleAspectFill
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var catImage: UIImageView! {
        didSet{
            catImage.layer.cornerRadius = catImage.bounds.height / 16
            catImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newRoundActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var breedButtons: [UIButton]! {
        didSet{
            for i in 0..<breedButtons.count {
                breedButtons[i].layer.cornerRadius = breedButtons[i].bounds.height / 2
                breedButtons[i].clipsToBounds = true
            }
        }
    }
    @IBOutlet weak var nextRoundButton: UIButton! {
        didSet {
            nextRoundButton.layer.cornerRadius = nextRoundButton.bounds.height / 2
            nextRoundButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var lifesCountsLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var saveResult: UIButton! {
        didSet {
            saveResult.layer.cornerRadius = saveResult.bounds.height / 2
            saveResult.clipsToBounds = true
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableButtons(isEnabled: false)
        self.saveResult.isHidden = true
        self.nextRoundButton.setTitle("", for: .normal)
        self.nextRoundButton.isEnabled = false
        self.newRoundActivityIndicator.startAnimating()
        self.newRoundActivityIndicator.isHidden = false
        self.imageActivityIndicator.isHidden = true
        
        
        network.fetchTheBreedsList { (response) in
            self.breeds = response.breeds
            
            DispatchQueue.main.async {
                self.nextRoundButton.setTitle("Start Game!", for: .normal)
                self.nextRoundButton.isEnabled = true
                self.newRoundActivityIndicator.stopAnimating()
                self.newRoundActivityIndicator.isHidden = true
            }
            
        }
        
        
    }
    
    //MARK: Actions
    
    @IBAction func chooseTheBreedButtons(_ sender: UIButton) {
        enableButtons(isEnabled: false)
        
        if sender.currentTitle == breedForRound?.name {
            sender.backgroundColor = .green
            chooseBreed(isRight: true)
        } else {
            sender.backgroundColor = .red
            chooseBreed(isRight: false)
        }
        for i in 0..<breedButtons.count where breedButtons[i].backgroundColor == .blue {
            breedButtons[i].isHidden = true
        }
        nextRoundButton.isEnabled = true
        nextRoundButton.backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.8745098039, blue: 0.6666666667, alpha: 1)
        
    }
    
    @IBAction func startGameButton(_ sender: UIButton) {
        if gameOver {
            newGame()
        } else {
            newRound()
        }
    }
    
    @IBAction func saveResultButton(_ sender: UIButton) {
        saveResult.isHidden = true
        fetchPlayerName()
    }
    
    
    
    //MARK: Alerts
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: Methods
    func newGame() {
        lifesCountsLabel.text = "🐈♥️x\(lifes)"
        lifes = 9
        scores = 0
        scoreLabel.text = "Score: 0"
        lifesCountsLabel.isHidden = false
        saveResult.isHidden = true
        gameOver = false
        newRound()
        
    }
    
    func newRound() {
        lifesCountsLabel.text = "🐈♥️x\(lifes)"
        catImage.image = nil
        imageActivityIndicator.isHidden = false
        imageActivityIndicator.startAnimating()
        setupButtonsForNewRound() 
        fetchImage(forBreed: breedForRound?.id)
        enableButtons(isEnabled: true)
        nextRoundButton.isEnabled = false
        nextRoundButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        nextRoundButton.setTitle("Next Round", for: .normal)
    }
    
    func enableButtons(isEnabled: Bool) {
        if isEnabled {
            for index in 0..<breedButtons.count {
                breedButtons[index].isEnabled = true
            }
        } else {
            for index in 0..<breedButtons.count {
                breedButtons[index].isEnabled = false
            }
        }
    }
    
    func chooseBreed(isRight: Bool) {
        
        if isRight {
            scores += 1
            rightAnswersLine += 1
            
            if rightAnswersLine >= 3 {
                showAlert(title: "Three in a row😻", message: "You know how to play the game! + 1 bonus score!")
                scores += 1
            }
            scoreLabel.text = "Score: \(scores)"
            
        } else {
            rightAnswersLine = 0
            lifes -= 1
            lifesCountsLabel.text = "🐈♥️x\(lifes)"
            if lifes == 0 {
                showAlert(title: "You lost last life😿😿😿", message: "Good luck next time!")
                nextRoundButton.setTitle("😻 New Game 😻", for: .normal)
                lifesCountsLabel.isHidden = true
                saveResult.isHidden = false
                gameOver = true
            } else {
                showAlert(title: "NooooOOoo😿", message: "You dont know how \(String(describing: breedForRound!.name)) looks like?" )
            }
        }
    }
    
    func fetchImage(forBreed breed: String?) {
        if let breed = breed {
            self.network.fetchImageFromBreed(breedId: breed) { (picData) in
                let imageUrl = URL(string: picData)

                guard let url = imageUrl, let imageData = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData)
                    self.imageActivityIndicator.stopAnimating()
                    self.imageActivityIndicator.isHidden = true
                }
            }
        }
    }
    
    func setupButtonsForNewRound(){
        breedsForRound = []
        for _ in 0..<4 {
            guard let breed = breeds.randomElement() else { continue }
            self.breedsForRound.append(breed)
        }
        guard let breedForRound = breedsForRound.randomElement() else { return }
        self.breedForRound = breedForRound
        for index in 0..<self.breedButtons.count {
            self.breedButtons[index].setTitle(self.breedsForRound[index].name, for: .normal)
            self.breedButtons[index].backgroundColor = .blue
            self.breedButtons[index].isHidden = false
        }
    }
    
    func fetchPlayerName() {
        let alert = UIAlertController(title: "Total score: \(scores)", message: "If you want to save result, please, enter your name", preferredStyle: .alert)
        
        var alertTextField = UITextField()
        alert.addTextField { (textFiled) in
            alertTextField = textFiled
            textFiled.placeholder = "Name"
        }
        
        let saveNameAction = UIAlertAction(title: "Save result", style: .default) { (action) in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            self.playerName = text
            self.performSegue(withIdentifier: "showResults", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveNameAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            let destination = segue.destination as! ResultsViewController
            destination.playerName = self.playerName
            destination.playerScore = self.scores
        }
    }
    
    
}


