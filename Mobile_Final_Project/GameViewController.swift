//
//  GameViewController.swift
//  Mobile_Final_Project
//
//  Created by w0452997 on 2022-03-03.
//

import UIKit
import SQLite3

class GameViewController: UIViewController {

    
    
    @IBOutlet weak var card1: UIImageView!
    
    @IBOutlet weak var card2: UIImageView!
    
    @IBOutlet weak var card3: UIImageView!
    
    @IBOutlet weak var card4: UIImageView!
    
    
    
    @IBOutlet weak var smallCard: UIImageView!
    
    @IBOutlet weak var smallCard2: UIImageView!
    
    @IBOutlet weak var smallCard3: UIImageView!
    
    @IBOutlet weak var smallCard4: UIImageView!
    
    @IBOutlet weak var smallCard5: UIImageView!
    
    
    @IBOutlet weak var smallCard6: UIImageView!
    
    @IBOutlet weak var smallCard7: UIImageView!
    
    @IBOutlet weak var smallCard8: UIImageView!
    
    @IBOutlet weak var smallCard9: UIImageView!
    
    @IBOutlet weak var smallCard10: UIImageView!
    
    @IBOutlet weak var Start: UIButton!
    
    @IBOutlet weak var Hit: UIButton!
    
    @IBOutlet weak var Stay: UIButton!
    
    @IBOutlet weak var PlayerLabel: UILabel!
    @IBOutlet weak var HouseLabel: UILabel!
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    var playerName = ""
    var playerScore = 0
    var myDeck: [String] = []
    
    var playerCardvalue: [Int] = []
    var houseCardvalue: [Int] = []
    var cardsCounter = 0
    var flag = true
    var db: OpaquePointer?
    var imageViews = [UIImageView]()
    var image2Views = [UIImageView]()
    var normalCounter = 0
    var normalCounter2 = 0
    var sum = 0
    var sum2 = 0
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViews.append(smallCard)
        imageViews.append(smallCard2)
        imageViews.append(smallCard3)
        imageViews.append(smallCard4)
        imageViews.append(smallCard5)
        
        image2Views.append(smallCard6)
        image2Views.append(smallCard7)
        image2Views.append(smallCard8)
        image2Views.append(smallCard9)
        image2Views.append(smallCard10)
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("project.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error in sqlite")
            return
        }
        
        let suits = ["hearts","spades","diamonds","clubs"]
        
        for suit in suits{
            for value in 1...13{
                let card = String(value)+suit
                myDeck.append(card)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func extractNumber( value: String) -> String {
        let stringArray = value.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        for item in stringArray {
            if let number = Int(item) {
                return String(number)
            }
        }
        
        return "no value"
    }
       
    @IBAction func Start(_ sender: UIButton) {
        
        Start.isHidden = true
        Hit.isHidden = false
        Stay.isHidden = false
        
        startGame()
        
    }
    
    func startGame(){
        
        let selectStatement = "SELECT * FROM TABLENAMES ORDER BY id DESC;"
        
        var queryStatement: OpaquePointer?
          
          if sqlite3_prepare_v2(db, selectStatement, -1, &queryStatement, nil) ==
              SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
              
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                print("Query result is nil")
                return
              }
            text = String(cString: queryResultCol1)
              
                
          } else {
              print("\nQuery returned no results.")
          }
          } else {
        
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
          }
          
        sqlite3_finalize(queryStatement)
        
        sum = 0
        sum2 = 0
        playerCardvalue = []
        houseCardvalue = []
        
        cardsCounter = 0
        
        myDeck.shuffle()
        card1.image = UIImage(named: myDeck[cardsCounter])
        playerCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        cardsCounter += 1
        card2.image = UIImage(named: myDeck[cardsCounter])
        playerCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        sum = playerCardvalue.reduce(0, +)
                
        cardsCounter += 1
        card3.image = UIImage(named: myDeck[cardsCounter])
        houseCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        cardsCounter += 1
        card4.image = UIImage(named: myDeck[cardsCounter])
        houseCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        sum2 = houseCardvalue.reduce(0, +)
        
        self.PlayerLabel.text = text + " hand: " + String(sum)
        self.HouseLabel.text = "House hand: " + String(sum2)
    }
    
    
    @IBAction func Hit(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "BURST", message: "You lost", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Re-start", style: UIAlertAction.Style.default, handler: { action in
            switch action.style{
                case .default:
                    self.normalCounter=0
                    self.normalCounter2=0
                    self.flag=true
                    for v in self.imageViews {
                        v.image=nil
                    }
                    for v in self.image2Views {
                        v.image=nil
                    }
                    self.startGame()
                    
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        
        
        sum = playerCardvalue.reduce(0, +)
        
        if flag == true {
            
            cardsCounter += 1
            imageViews[normalCounter].image = UIImage(named: myDeck[cardsCounter])
            playerCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
            normalCounter += 1
            
            sum = playerCardvalue.reduce(0, +)
            
            if (sum > 21){
                playerScore -= 50
                ScoreLabel.text = "Score: " + String(playerScore)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.PlayerLabel.text = text + " hand: " + String(sum)
    }
    
    
    @IBAction func Stay(_ sender: UIButton) {
        
        let alert2 = UIAlertController(title: "BURST", message: "Player Wins", preferredStyle: UIAlertController.Style.alert)
        alert2.addAction(UIAlertAction(title: "Re-start", style: UIAlertAction.Style.default, handler: { action in
            switch action.style{
                case .default:
                    self.normalCounter=0
                    self.normalCounter2=0
                    self.flag=true
                    for v in self.imageViews {
                        v.image=nil
                    }
                    for v in self.image2Views {
                        v.image=nil
                    }
                    self.startGame()
                    
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        
        let alert3 = UIAlertController(title: "Sorry", message: "House Wins", preferredStyle: UIAlertController.Style.alert)
        alert3.addAction(UIAlertAction(title: "Re-start", style: UIAlertAction.Style.default, handler: { action in
            switch action.style{
                case .default:
                    self.normalCounter=0
                    self.normalCounter2=0
                    self.flag=true
                    for v in self.imageViews {
                        v.image=nil
                    }
                    for v in self.image2Views {
                        v.image=nil
                    }
                    
                    self.startGame()
                    
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        
        flag = false
        var i = 0
        sum2 = houseCardvalue.reduce(0, +)
        

        while (i < 5){
        
        
        image2Views[normalCounter2].image = UIImage(named: myDeck[cardsCounter])
        houseCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        normalCounter2 += 1
        cardsCounter += 1
        sum2 = houseCardvalue.reduce(0, +)
            
        print(houseCardvalue)
        if (sum2>21){
            i=5;
            playerScore += 50
            ScoreLabel.text = "Score: " + String(playerScore)
            self.present(alert2, animated: true, completion: nil)
        }
        if (sum2 > sum && sum2 < 21){
            i=5;
            playerScore -= 50
            ScoreLabel.text = "Score: " + String(playerScore)
            self.present(alert3, animated: true, completion: nil)
        }
        
        
        i += 1
            
        }
        
        
        self.HouseLabel.text = "House hand: " + String(sum2)
        
    }
    
    /*
     @IBAction func Hit(_ sender: UIButton) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
