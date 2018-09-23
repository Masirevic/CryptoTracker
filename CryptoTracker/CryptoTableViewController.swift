//
//  CryptoTableViewController.swift
//  CryptoTracker
//
//  Created by Ljubomir Masirevic on 9/22/18.
//  Copyright © 2018 Ljubomir Masirevic. All rights reserved.
//

import UIKit
import LocalAuthentication

private let headerHeight: CGFloat = 100.0
private let netWorthHeight: CGFloat = 45.0


class CryptoTableViewController: UITableViewController, CoinDataDelegate {
    
    var amountLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        CoinData.shared.getPrices()
        
       if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            updateSecureButton()
        }
        
    }
    
    func updateSecureButton () {
        if UserDefaults.standard.bool(forKey: "secure") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unsecure App", style: .plain, target: self, action: #selector(secureTap))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Secure App", style: .plain, target: self, action: #selector(secureTap))
        }
    }
    
     @objc func secureTap () {
        if UserDefaults.standard.bool(forKey: "secure") {
            UserDefaults.standard.set(false, forKey: "secure")
        } else {
             UserDefaults.standard.set(true, forKey: "secure")
        }
        
        updateSecureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegte = self
        tableView.reloadData()
        displayNetWorth()
        
    }

  
    func newPrices() {
        tableView.reloadData()
        displayNetWorth()
    }
    func  createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight))
        headerView.backgroundColor = UIColor.white
        let networthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: netWorthHeight))
        headerView.addSubview(networthLabel)
        networthLabel.text = "My Crypto Net Worh"
        networthLabel.textAlignment = .center
        
        amountLabel.frame = CGRect(x: 0, y: netWorthHeight, width:  view.frame.size.width, height: headerHeight - netWorthHeight)
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont.boldSystemFont(ofSize: 60.0)
        headerView.addSubview(amountLabel)
        
         displayNetWorth()
        
        return headerView
    }
    
    func displayNetWorth () {
        amountLabel.text = CoinData.shared.netWorthAsString()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CoinData.shared.coins.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let coin = CoinData.shared.coins[indexPath.row]
        
        if coin.amount != 0.0 {
            cell.textLabel?.text = "\(coin.symbol) \(coin.priceAsString()) - \(coin.amount)"
        } else {
        cell.textLabel?.text = "\(coin.symbol) \(coin.priceAsString())"
        }
        cell.imageView?.image = coin.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinViewController()
         coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)
    }
    

}
