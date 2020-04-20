//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(theError: Error)
    func didUpdateCoinValue(_ CoinManager: CoinManager, coin: CoinData)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "24AB72B9-6AAF-4D28-A9A8-4533FE3FA80B"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func fetchPrice() {
        let url = "\(baseURL)?apiKey=\(apiKey)"
        performRequest(with: url)
    }
    
    func getCurrencyCount()->Int{
        return currencyArray.count
    }
    
    func getCurrency(rownum: Int)->String {
        return currencyArray[rownum]
    }

    
    
    func performRequest(with urlString: String) {
        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(theError: error!)
                }else {
                    if let safeData = data {
                        if let coinValue = self.parseJSON(safeData) {
                            self.delegate?.didUpdateCoinValue(self, coin: coinValue)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coin: Data)->CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coin)
            let coinValue = CoinData(rates: decodedData.rates)
            return coinValue
        } catch {
            delegate?.didFailWithError(theError: error)
            return nil
        }
    }
    
}
