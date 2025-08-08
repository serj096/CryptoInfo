//
//  ViewController.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//

import UIKit

class CryptoInfoViewController: UITableViewController {
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchCryptoData()
    }
    
    func fetchCryptoData() {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error)")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                DispatchQueue.main.async {
                    for crypto in cryptos.prefix(5) {
                        print("💰 \(crypto.name) (\(crypto.symbol.uppercased()))")
                        print("   Цена: $\(crypto.current_price), Капитализация: $\(crypto.market_cap)")
                        print("   Изменение за 24ч: \(crypto.price_change_percentage_24h)%")
                        print("   Лого: \(crypto.image)\n")
                    }
                }
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }
        task.resume()
    }
}

