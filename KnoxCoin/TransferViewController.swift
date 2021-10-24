//
//  TransferViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/24/21.
//

import UIKit

class TransferViewController: UIViewController,  UITextFieldDelegate {
    @IBOutlet weak var AmountTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AmountTextField.delegate = self
        AddressTextField.delegate = self
        AmountTextField.returnKeyType = .done
        AmountTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func OKPressed(_ sender: Any) {
        
        
        
        let url = URL(string: "https://knoxcoin-duke.ue.r.appspot.com//verify/\(sender)/\(recipient)/\(myAmount)/\(Date().timeIntervalSince1970)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "id": 13,
            "name": "Jack & Jill"
        ]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }

        task.resume()
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
