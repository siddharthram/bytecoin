//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    var coinManager = CoinManager()
    var coinValue: CoinData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.fetchPrice()
    }
}

//MARK: - CoinManager

extension ViewController: CoinManagerDelegate {
    func didFailWithError(theError: Error) {
        print(theError)
    }
    
    func didUpdateCoinValue(_ CoinManager: CoinManager, coin: CoinData) {
        print("Got me coins")
        coinValue = coin
    }
    
    func getCoinData(rownum: Int)->Double {
        
        let selected = coinManager.getCurrency(rownum: rownum)
        var coinRate = 0.0
        
        for i in 0...coinValue!.rates.count - 1  {
            if selected == coinValue!.rates[i].asset_id_quote {
                coinRate = coinValue!.rates[i].rate
            }
        }
        return coinRate
    }
}

//MARK: - UIPickerView

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print("title for row")

        return coinManager.getCurrency(rownum: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //get the currency value
        // update the Label with the value
        print("picked row \(row)")
        
        let cd = getCoinData(rownum: row)
        let rcd = cd.round(to: 2)
        currencyLabel.text = String(rcd)
        currencyNameLabel.text = coinManager.getCurrency(rownum: row)
        
    
    }
    
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        // Make a call to CoinAPI and count the # of coin types

        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let num = coinManager.getCurrencyCount()
        //print("numberof rows \(num)")
        return num
    }
    
    
}

extension Double {
    func round(to places : Int)-> Double{
        let precisionNumber = pow(10,Double(places))
        var n = self
        n = n * precisionNumber
        n.round()
        n = n/precisionNumber
        return n
    }
}
