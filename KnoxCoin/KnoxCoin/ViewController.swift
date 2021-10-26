//
//  ViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/23/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var CompletedLabel: UILabel!
    @IBOutlet weak var PendingLabel: UILabel!
    
    
    
    var lastLabel: UILabel? = nil
    var lastFromLabel: UILabel? = nil
    var lastPendingLabel: UILabel? = nil
    var lastPendingFromLabel: UILabel? = nil
    
    @IBOutlet weak var BalanceLabel: UILabel!
    var balance = 0
    var first = true
    
    func updateUI()
    {
        let text = """
        [{"Transaction": 0, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C", "amount": 5000, "timestamp": 1635038346}, {"Transaction": 1, "Sender": "0xe33d8B80f4A1CB0c66Fb6E0e30c0da2b0c6489D3", "Recipient": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "amount": 50000000, "timestamp": 1635043263}, {"Transaction": 2, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C", "amount": 30000, "timestamp": 1635065106}, {"Transaction": 3, "Sender": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C", "Recipient": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "amount": 10000, "timestamp": 1635065306}, {"Transaction": 4, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xe33d8B80f4A1CB0c66Fb6E0e30c0da2b0c6489D3", "amount": 1000000, "timestamp": 1635065506}]
"""

        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
               var i = 1
                var others: [Any] = []
               for transaction in jsonArray
               {
                   let yesterday: Int = 1635051088
                   let dt = transaction["timestamp"] as! Int
                   print("the damn dt \(dt)")
                   if dt > yesterday
                   {
                       addPendingLabel(transaction: transaction)
                   }
                   else
                   {
                       others.append(transaction)
                   }

                   i += 1

               }
                
                if transferred
                {
                    let transaction = ["Transaction": 5, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C560", "amount": 517, "timestamp": 16350685506] as [String : Any]
                    self.addPendingLabel(transaction: transaction)
                }
                if (lastPendingLabel != nil)
                {
                    CompletedLabel.topAnchor.constraint(equalTo: lastPendingLabel!.bottomAnchor).isActive = true
                }
                else
                {
                    CompletedLabel.topAnchor.constraint(equalTo: PendingLabel!.bottomAnchor, constant: 50.0).isActive = true
                }
                
                i = 1
                for other in others
                {

                    addLabel(transaction: other as! [String : Any], i)
                    i += 1
                }
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }

        
        /*let transDict = try? JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: []) as? [String : Any]
        
        print(transDict!)*/
        
        
        
        
        var transactions: [[String:Any]] = []
        print("getting data")
        //history?acctId=0xA2EEB98051Dc677673E21F9fb23F200C78102488
        
        let session = URLSession.shared

        
        
        //self.getjson(urlPath: "https://knoxcoin-duke.ue.r.appspot.com/history/0xA2EEB98051Dc677673E21F9fb23F200C78102488")
        
        
        BalanceLabel.text = "\(balance) KC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*let completedTransactions = [("a", "b", 124.31), ("c", "a", 124.21), ("d", "a", 738.93), ("a", "g", 182.12)]
        
    
        
        for transaction in completedTransactions {
            
        }*/
        
        updateUI()
        
        

    }
    
    func getjson(urlPath: String) {
        let url = URL(string: urlPath)!
        //let session = URLSession.shared
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: url) { data, response, error in
            print("Task completed")

            guard let data = data, error == nil else {
                print(error?.localizedDescription)
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let transactions = jsonResult as? [[String:Any]] {
                        DispatchQueue.main.async {
                            var i = 1
                             var others: [Any] = []
                            for transaction in transactions
                            {
                                let yesterday: Int = 1635051088
                                let dt = transaction["timestamp"] as! Int
                                print("the damn dt \(dt)")
                                if dt > yesterday
                                {
//                                    if !didRecover
//                                    {
                                        self.addPendingLabel(transaction: transaction as! [String : Any])
                                    //}
                                }
                                else
                                {
                                    others.append(transaction)
                                }

                                i += 1

                            }
                            if (self.lastPendingLabel != nil)
                             {
                                self.CompletedLabel.topAnchor.constraint(equalTo: self.lastPendingLabel!.bottomAnchor).isActive = true
                             }
                             else
                             {
                                 self.CompletedLabel.topAnchor.constraint(equalTo: self.PendingLabel!.bottomAnchor, constant: 50.0).isActive = true
                             }
                             i = 1
                             for other in others
                             {

                                 self.addLabel(transaction: other as! [String : Any], i)
                                 i += 1
                             }
                        }
                    }
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func addPendingLabel(transaction: [String : Any])
    {
        print("easternmichigan")
        print(transaction)
        
        
        
        let newLabel = UILabel()
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //newLabel.backgroundColor = .yellow
        
        newLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.view.addSubview(newLabel)
        
        newLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        newLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
       
        if first
        {
            newLabel.topAnchor.constraint(equalTo: PendingLabel.bottomAnchor).isActive = true
            
        }
        else{
            newLabel.topAnchor.constraint(equalTo: lastPendingLabel!.bottomAnchor).isActive = true
        }
    
        
        
        lastPendingLabel = newLabel
        
        print("recccc")
        print(transaction["Recipient"] as! String)
        let amount = transaction["amount"] as! Int 
        newLabel.text = String(amount) + " KC"
        
        newLabel.textAlignment = .left
        
        
        
        
        let fromLabel = UILabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        fromLabel.addGestureRecognizer(tap)
        
        fromLabel.lineBreakMode = .byCharWrapping
        
        fromLabel.numberOfLines = 0
        
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //fromLabel.backgroundColor = .red
        
        fromLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.view.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20.0).isActive = true
        fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
       
        if first
        {
            fromLabel.topAnchor.constraint(equalTo: PendingLabel.bottomAnchor).isActive = true
        }
        else{
            fromLabel.topAnchor.constraint(equalTo: lastPendingFromLabel!.bottomAnchor).isActive = true
        }
    
        
        let myKey = "0xA2EEB98051Dc677673E21F9fb23F200C78102488"
        
        
        let sender = transaction["Sender"] as! String
        
        if sender != myKey
        {
            fromLabel.text = "From: \(sender)"
        }
        else
        {
            let recipient = transaction["Recipient"] as! String
            fromLabel.text = "To: \(recipient)"
            newLabel.text = "-" + newLabel.text!
        }
        
        fromLabel.textAlignment = .right
        
        
        
        lastPendingFromLabel = fromLabel
        first = false
    }
    
    @objc func doubleTapped()
    {
        print("double!")
        let alert = UIAlertController(title: "Cancel?", message: "If you would like to cancel this transaction, select Yes.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func addLabel(transaction: [String : Any], _ i: Int)
    {
        print("westernmichigan")
        print(transaction)
        
        
        
        
        
        
        let newLabel = UILabel()
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //newLabel.backgroundColor = .yellow
        
        newLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.view.addSubview(newLabel)
        
        newLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        newLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
       
        if i == 1
        {
            newLabel.topAnchor.constraint(equalTo: CompletedLabel.bottomAnchor).isActive = true
        }
        else{
            newLabel.topAnchor.constraint(equalTo: lastLabel!.bottomAnchor).isActive = true
        }
    
        
        
        lastLabel = newLabel
        
        print("recccc")
        print(transaction["Recipient"] as! String)
        let amount = transaction["amount"] as! Int
        newLabel.text = String(amount) + " KC"
        
        newLabel.textAlignment = .left
        
        
        
        
        let fromLabel = UILabel()
        
        fromLabel.lineBreakMode = .byCharWrapping
        
        fromLabel.numberOfLines = 0
        
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //fromLabel.backgroundColor = .red
        
        fromLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.view.addSubview(fromLabel)
        
        fromLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20.0).isActive = true
        fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        
       
        if i == 1
        {
            fromLabel.topAnchor.constraint(equalTo: CompletedLabel.bottomAnchor).isActive = true
        }
        else{
            fromLabel.topAnchor.constraint(equalTo: lastFromLabel!.bottomAnchor).isActive = true
        }
    
        
        let myKey = "0xA2EEB98051Dc677673E21F9fb23F200C78102488"
        
        
        let sender = transaction["Sender"] as! String
        
        if sender != myKey
        {
            fromLabel.text = "From: \(sender)"
            balance += amount
        }
        else
        {
            let recipient = transaction["Recipient"] as! String
            fromLabel.text = "To: \(recipient)"
            newLabel.text = "-" + newLabel.text!
            
            balance -= amount
        }
        
        fromLabel.textAlignment = .right
        
        lastFromLabel = fromLabel
    }


}

