//
//  ViewController.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//

import UIKit

class CryptoInfoViewController: UITableViewController {
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    
    var cryptos: [Crypto] = [] // сюда будем сохранять данные

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
                    self.cryptos = cryptos.prefix(5).map { $0 } // сохраняем первые 5
                    self.tableView.reloadData() // перерисовываем таблицу
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoInfoTableViewCell
        let crypto = cryptos[indexPath.row]
        cell.configure(with: crypto) // сюда передаем данные
        return cell
    }
}
