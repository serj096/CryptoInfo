//
//  ViewController.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//

import UIKit

class CryptoInfoViewController: UITableViewController {
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    
    var cryptos: [Crypto] = []

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
                    self.cryptos = Array(cryptos.prefix(5)) // максимум 5 монет, но может быть меньше
                    self.tableView.reloadData()
                }
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoInfoTableViewCell else {
            return UITableViewCell()
        }
        
        if let crypto = cryptos[safeIndex: indexPath.row] {
            cell.configure(with: crypto)
        } else {
            cell.configurePlaceholder()
        }
        
        return cell
    }
}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

