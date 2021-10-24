//
//  CodesViewController.swift
//  KnoxCoin
//
//  Created by Rami Sbahi on 10/23/21.
//

import UIKit
import Security

class CodesViewController: UIViewController {

    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var ButtonStackView: UIStackView!
    
    var currI = -1
    
    var lastLabel: UILabel? = nil
    var lastButton: UIButton? = nil
    
    var privateKeys: [String] = []
    var publicKeys: [String] = []
    
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(numCodes)

        // Do any additional setup after loading the view.
        
        for i in 1...numCodes
        {
            currI = i - 1
            print(i)
            let label1 = randomString(length: 12) // seed1
            let label2 = randomString(length: 12) // seed2
            let publicKeyAttr: [NSObject: NSObject] = [
                        kSecAttrIsPermanent:true as NSObject,
                        kSecAttrApplicationTag:"com.xeoscript.app.RsaFromScrach.public".data(using: String.Encoding.utf8)! as NSObject,
                        kSecAttrApplicationLabel: label1 as NSObject,
                        kSecClass: kSecClassKey, // added this value
                        kSecReturnData: kCFBooleanTrue] // added this value
            let privateKeyAttr: [NSObject: NSObject] = [
                        kSecAttrIsPermanent:true as NSObject,
                        kSecAttrApplicationTag:"com.xeoscript.app.RsaFromScrach.private".data(using: String.Encoding.utf8)! as NSObject,
                        kSecAttrApplicationLabel: label2 as NSObject,
                        kSecClass: kSecClassKey, // added this value
                        kSecReturnData: kCFBooleanTrue] // added this value

            var keyPairAttr = [NSObject: NSObject]()
            keyPairAttr[kSecAttrKeyType] = kSecAttrKeyTypeRSA
            keyPairAttr[kSecAttrKeySizeInBits] = 2048 as NSObject
            keyPairAttr[kSecPublicKeyAttrs] = publicKeyAttr as NSObject
            keyPairAttr[kSecPrivateKeyAttrs] = privateKeyAttr as NSObject

            var publicKey : SecKey?
            var privateKey : SecKey?;

            let statusCode = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)

            if statusCode == noErr && publicKey != nil && privateKey != nil {
                print("Key pair generated OK")
                var resultPublicKey: AnyObject?
                var resultPrivateKey: AnyObject?
                let statusPublicKey = SecItemCopyMatching(publicKeyAttr as CFDictionary, &resultPublicKey)
                let statusPrivateKey = SecItemCopyMatching(privateKeyAttr as CFDictionary, &resultPrivateKey)

                if statusPublicKey == noErr {
                    if let publicKey = resultPublicKey as? Data {
                        print("Public Key: \((publicKey.base64EncodedString()))")
                        if statusPrivateKey == noErr {
                            if let privateKey = resultPrivateKey as? Data {
                                print("Private Key: \((privateKey.base64EncodedString()))")
                                addLabel(privateKey: privateKey.base64EncodedString(), i: i, numCodes: numCodes)
                                privateKeys.append(privateKey.base64EncodedString())
                                publicKeys.append(publicKey.base64EncodedString())
                            }
                        }
                    }
                    
                }

                
                
                
            } else {
                print("Error generating key pair: \(String(describing: statusCode))")
            }
        }
    }
    
    func addLabel(privateKey: String, i: Int, numCodes: Int)
    {
        let textLabel = UILabel()
        StackView.addArrangedSubview(textLabel)
        //textLabel.backgroundColor = UIColor.yellow
        textLabel.widthAnchor.constraint(equalToConstant: StackView.frame.width).isActive = true
        
        StackView.translatesAutoresizingMaskIntoConstraints = false
        if i == 1
        {
            textLabel.topAnchor.constraint(equalTo: StackView.topAnchor).isActive = true
        }
        else
        {
            textLabel.topAnchor.constraint(equalTo: lastLabel!.bottomAnchor).isActive = true
        }
        lastLabel = textLabel
        textLabel.text  = "Code \(i)"
        textLabel.textAlignment = .left
        
        
        let button = UIButton()
        button.accessibilityIdentifier = String(i-1)
        button.backgroundColor = .systemTeal
        button.layer.cornerCurve = .continuous
        button.setTitle("Copy", for: .normal)
        button.addTarget(self, action: #selector(didButtonClick(sender:)), for: .touchUpInside)
        ButtonStackView.addArrangedSubview(button)
        //button.heightAnchor.constraint(equalToConstant: ButtonStackView.frame.height / CGFloat(numCodes) / 2.0).isActive = true
        //textLabel.backgroundColor = UIColor.yellow
        button.widthAnchor.constraint(equalToConstant: ButtonStackView.frame.width).isActive = true
        
        ButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        if i == 1
        {
            button.topAnchor.constraint(equalTo: ButtonStackView.topAnchor).isActive = true
        }
        else
        {
            button.topAnchor.constraint(equalTo: lastButton!.bottomAnchor).isActive = true
        }
        lastButton = button
        
    }
    
    @objc func didButtonClick(sender: Any) {
      // Doing stuff with model object here
        
        print("clicked")
        
        let i = Int((sender as! UIButton).accessibilityIdentifier!)!
        let pasteboard = UIPasteboard.general
        print(i)
        print(privateKeys[i] == privateKeys[0])
        pasteboard.string = privateKeys[i]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let defaults = UserDefaults.standard
        defaults.set(publicKeys, forKey: "publicKeys")
        defaults.set(publicKeys[0], forKey: "publicKey")
        
        let currPrivateKey = privateKeys[0]
        
        let account = UIDevice.current.identifierForVendor!.uuidString
        
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: currPrivateKey]
        
    
        let status = SecItemAdd(query as CFDictionary, nil)
        print(status)
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




enum KeychainError: Error {
    case noKey
    case unexpectedKey
    case unhandledError(status: OSStatus)
}
