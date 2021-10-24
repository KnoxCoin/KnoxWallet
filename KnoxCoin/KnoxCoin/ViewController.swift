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
    
    override func viewWillAppear(_ animated: Bool) {
        if didRecover
        {
            print("UPDATING")
            updateUI()
        }
    }
    
    func updateUI()
    {
        let text = """
        [{"Transaction": 0, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C", "amount": 5000000000, "timestamp": 1635038346}, {"Transaction": 1, "Sender": "0xe33d8B80f4A1CB0c66Fb6E0e30c0da2b0c6489D3", "Recipient": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "amount": 5000000, "timestamp": 1635043263}, {"Transaction": 2, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C", "amount": 30000, "timestamp": 1635065106}, {"Transaction": 3, "Sender": "0xCE652fb7aBD86715a870ea3BaaBfEed24d596A8C", "Recipient": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "amount": 10000, "timestamp": 1635065306}, {"Transaction": 4, "Sender": "0xA2EEB98051Dc677673E21F9fb23F200C78102488", "Recipient": "0xe33d8B80f4A1CB0c66Fb6E0e30c0da2b0c6489D3", "amount": 1000000, "timestamp": 1635065506}]
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
                       if !didRecover
                       {
                           addPendingLabel(transaction: transaction)
                       }
                   }
                   else
                   {
                       others.append(transaction)
                   }
                   
                   i += 1

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

        
        
        //self.getjson(urlPath: "http://10.194.77.247:5000/history/0xA2EEB98051Dc677673E21F9fb23F200C78102488")
        
        
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
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            print("Task completed")

            guard let data = data, error == nil else {
                print(error?.localizedDescription)
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let transactions = jsonResult as? [Any] {
                        DispatchQueue.main.async {
                            var i = 1
                            for transaction in transactions
                            {
                                self.addLabel(transaction: transaction as! [String : Any], i)
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

