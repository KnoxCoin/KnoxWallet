//
//  MeViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/24/21.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var AddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let myAddress = defaults.string(forKey: "publicKey")
        
        AddressLabel.text = myAddress

        // Do any additional setup after loading the view.
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
