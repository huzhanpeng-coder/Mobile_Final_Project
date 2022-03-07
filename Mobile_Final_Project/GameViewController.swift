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
    
    @IBOutlet weak var Start: UIButton!
    
    @IBOutlet weak var Hit: UIButton!
    
    @IBOutlet weak var Stay: UIButton!
    
    @IBOutlet weak var PlayerLabel: UILabel!
    @IBOutlet weak var HouseLabel: UILabel!
    
    var playerName = ""
    var myDeck: [String] = []
    var counterHouse = 0
    var counterPlayer = 0
    var playerCardvalue: [Int] = []
    var houseCardvalue: [Int] = []
    var cardsCounter = 0
    var flag = true
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let selectStatement = "SELECT * FROM TABLENAMES ORDER BY id DESC;"
        
        var text = ""
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
        
        Start.isHidden = true
        Hit.isHidden = false
        Stay.isHidden = false
        
        myDeck.shuffle()
        card1.image = UIImage(named: myDeck[cardsCounter])
        playerCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        cardsCounter += 1
        card2.image = UIImage(named: myDeck[cardsCounter])
        playerCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        let sum = playerCardvalue.reduce(0, +)
        self.PlayerLabel.text = text + " current hand: " + String(sum)
                
        cardsCounter += 1
        card3.image = UIImage(named: myDeck[cardsCounter])
        houseCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        cardsCounter += 1
        card4.image = UIImage(named: myDeck[cardsCounter])
        houseCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        
        let sum2 = houseCardvalue.reduce(0, +)
        self.HouseLabel.text = " House current hand: " + String(sum2)
        
    }
    
    
    
    @IBAction func Hit(_ sender: UIButton) {
        let card = UIImageView()
        var sum = playerCardvalue.reduce(0, +)
        
        if flag == true {
            card.frame = CGRect(x: 50 + (counterHouse*50), y: 250, width: 80, height: 100)
            cardsCounter += 1
            card.image = UIImage(named: myDeck[cardsCounter])
            playerCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
            counterHouse += 1
                
            view.addSubview(card)
            
            sum = playerCardvalue.reduce(0, +)
            if (sum > 21){
                print("player burst ")
            }
        }
        
        
        self.PlayerLabel.text = "Player Score: " + String(sum)
    }
    
    
    @IBAction func Stay(_ sender: UIButton) {
        
        flag = false
        var i = 0
        var sum2 = houseCardvalue.reduce(0, +)
        
        while (i <= 5){
            
        let card = UIImageView()
        card.frame = CGRect(x: 50 + (counterPlayer*50), y: 700, width: 80, height: 100)
        card.image = UIImage(named: myDeck[cardsCounter])
        houseCardvalue.append(Int(extractNumber(value: myDeck[cardsCounter]))!)
        cardsCounter += 1
        counterPlayer += 1
        sum2 = houseCardvalue.reduce(0, +)
        if (sum2 > 21){
            i=5
        }
        view.addSubview(card)
        i += 1
            
        }
        
        
        self.HouseLabel.text = "House Score: " + String(sum2)
        
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
