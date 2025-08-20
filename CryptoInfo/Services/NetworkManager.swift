//
//  NetworkManager.swift
//  CryptoInfo
//
//  Created by serj on 19.08.2025.
//

import Foundation


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "https://api.coingecko.com/api/v3"

    func fetchCryptos(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        let endpoint = "\(baseURL)/coins/markets?vs_currency=usd"

        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
