//
//  WelcomeViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/23/21.
//

import UIKit

var numCodes = 5

class WelcomeViewController: UIViewController {

    @IBOutlet weak var NumCodesField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        numCodes = Int(NumCodesField.text!)!
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
