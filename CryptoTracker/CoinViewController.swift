//
//  CoinViewController.swift
//  CryptoTracker
//
//  Created by Ljubomir Masirevic on 9/22/18.
//  Copyright © 2018 Ljubomir Masirevic. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHeight: CGFloat = 300.0
private let imageSize: CGFloat = 100
private let priceLabelHeight: CGFloat = 25

class CoinViewController: UIViewController, CoinDataDelegate {

    
    var coin : Coin?
    var chart = Chart()
    var priceLabel = UILabel()
    var youOwnLabel = UILabel()
    var worthLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let coin = coin {
        CoinData.shared.delegte = self
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white
            title = coin.symbol
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTaped))
        
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
        chart.yLabelsFormatter = {CoinData.shared.dubleToMoneyString(double: $1)}
        chart.xLabels = [30, 25, 20, 15, 10, 5, 0]
        chart.xLabelsFormatter = {String(Int(round (30 - $1))) + "d"}
        view.addSubview(chart)
        
        let imageView = UIImageView(frame: CGRect(x: view.frame.size.width / 2 - imageSize / 2, y: chartHeight, width: imageSize, height: imageSize))
        view.addSubview(imageView)
        imageView.image = coin.image
        
        
        priceLabel.frame = CGRect(x: 0, y: chartHeight  + imageSize, width: view.frame.size.width, height: priceLabelHeight)
        
        priceLabel.textAlignment = .center
        view.addSubview(priceLabel)
        
        youOwnLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight * 2, width: view.frame.size.width, height: priceLabelHeight)
        youOwnLabel.textAlignment = .center
        youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        view.addSubview(youOwnLabel)
         worthLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight * 3, width: view.frame.size.width, height: priceLabelHeight)
           worthLabel.textAlignment = .center
        view.addSubview(worthLabel)
            
            
        coin.getHistoricalData()
            newPrices()
        }
    }
    
    @objc func editTaped () {
        if let coin = coin {
        let alert = UIAlertController(title: "How much \(coin.symbol) do you own", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "0.5"
                textField.keyboardType = .decimalPad
                if self.coin?.amount != 0.0 {
                    textField.text = String(coin.amount)
                }
                
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let text = alert.textFields?[0].text {
                    if let amount = Double(text) {
                        self.coin?.amount = amount
                        self.newPrices()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func newHistory() {
        if let coin = coin {
        let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    }
    
    func newPrices () {
        if let coin = coin {
        priceLabel.text = coin.priceAsString()
        worthLabel.text = coin.amountAsString()
        youOwnLabel.text = "You own: \(coin.amount) \(coin.symbol)"
        }
    }
    
}
