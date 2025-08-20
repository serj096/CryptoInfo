//
//  ViewController.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//

import UIKit

final class CryptoInfoViewController: UIViewController {

    private let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    private var cryptos: [Crypto] = []

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CryptoInfoTableViewCell.self, forCellReuseIdentifier: CryptoInfoTableViewCell.identifier)
        tv.rowHeight = 100
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Crypto Info"
        setupTableView()
        fetchCryptoData()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchCryptoData() {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
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
                    self.cryptos = Array(cryptos.prefix(5))
                    self.tableView.reloadData()
                }
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }.resume()
    }
}

// MARK: - UITableViewDataSource & Delegate
extension CryptoInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoInfoTableViewCell.identifier, for: indexPath) as? CryptoInfoTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: cryptos[indexPath.row])
        return cell
    }
}
