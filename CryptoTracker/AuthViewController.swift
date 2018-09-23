//
//  AuthViewController.swift
//  CryptoTracker
//
//  Created by Ljubomir Masirevic on 9/23/18.
//  Copyright © 2018 Ljubomir Masirevic. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
       presentAuth()
    }
    
    func presentAuth () {
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Your Crypto is Proctected by Biometrics") { (success, error) in
            if success {
                DispatchQueue.main.async {
                    let cryptoTableVC = CryptoTableViewController()
                    let navController = UINavigationController(rootViewController: cryptoTableVC)
                    self.present(navController, animated: true, completion: nil)
                }
                
            } else {
                self.presentAuth()
            }
            
        }
   }
}
