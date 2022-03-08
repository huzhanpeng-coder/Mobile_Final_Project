//
//  MainViewController.swift
//  Mobile_Final_Project
//
//  Created by w0452997 on 2022-03-03.
//

import UIKit
import SQLite3

class MainViewController: UIViewController {

    @IBOutlet weak var playerName: UITextField!
    
    
    
    var db: OpaquePointer?
    
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("project.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error in sqlite")
            return
        }
            
        let tableSQLITE = "CREATE TABLE IF NOT EXISTS TABLENAMES (id INTEGER PRIMARY KEY AUTOINCREMENT, text CHAR(255))"
        
        if sqlite3_exec(db, tableSQLITE, nil, nil, nil) != SQLITE_OK {
            print("Error")
            return
        }
        
        print("it's working")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nameButton(_ sender: UIButton) {
        let textfield = playerName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (textfield?.isEmpty)!{
            print("Name is empty")
            return;
        }
        
        var stmt: OpaquePointer?
        
        let inQuery = "INSERT INTO TABLENAMES (text) VALUES (?); "
        
        if sqlite3_prepare_v2(db, inQuery, -1, &stmt, nil) == SQLITE_OK{
               // 3
               sqlite3_bind_text(stmt, 1, textfield, -1, nil)
               // 4
               if sqlite3_step(stmt) == SQLITE_DONE {
                 print("\nSuccessfully inserted row.")
               } else {
                 print("\nCould not insert row.")
               }
             } else {
               print("\nINSERT statement is not prepared.")
             }
        
        sqlite3_finalize(stmt)
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
