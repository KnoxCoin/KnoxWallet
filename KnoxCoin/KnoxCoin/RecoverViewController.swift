//
//  RecoverViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/24/21.
//

import UIKit

var didRecover = false

class RecoverViewController: UIViewController {

    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var OKButton: UIButton!
    @IBOutlet weak var InvalidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        didRecover = true
    }
    
    @IBAction func OKPressed(_ sender: Any) {
        
        let enteredKey = TextField.text!
        var isValidKey = false
        
        didRecover = true
        
        isValidKey = false // update
        
        /*while !isValid(enteredKey)
        {
            InvalidLabel.isHidden = false
        }
       performSegue(withIdentifier: "recoveredSegue", sender: self)*/
    }
    
    func isValid(_ key: String)
    {
        let defaults = UserDefaults.standard
        let publicKeys = defaults.string(forKey: "publicKeys")
        
        let algorithm: SecKeyAlgorithm = .rsaSignatureDigestPKCS1v15SHA256
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
