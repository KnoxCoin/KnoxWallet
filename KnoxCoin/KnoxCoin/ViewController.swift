//
//  ViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/23/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var PendingTransactions: UIStackView!
    @IBOutlet weak var CanceledTransactions: UIStackView!
    @IBOutlet weak var CompletedTransactions: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let completedTransactions = [("a", "b", 124.31), ("c", "a", 124.21), ("d", "a", 738.93), ("a", "g", 182.12)]
        
        
        
        for transaction in completedTransactions {
            
        }
    }


}

