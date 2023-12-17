//
//  ViewController.swift
//  Test
//
//  Created by 박인호 on 2023/08/23.
//

import UIKit
import FirebaseDatabase

var ref: DatabaseReference!

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        }
    }
    
    
    
    
    
    
    


