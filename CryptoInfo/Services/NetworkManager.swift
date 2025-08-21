//
//  NetworkManager.swift
//  CryptoInfo
//
//  Created by serj on 19.08.2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "https://api.coingecko.com/api/v3"

    func fetchCryptos(completion: @escaping (Result<[Crypto], AFError>) -> Void) {
        let endpoint = "\(baseURL)/coins/markets?vs_currency=usd"

        AF.request(endpoint)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                            completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                            return
                        }

                        let cryptos = jsonArray.map { Crypto(json: $0) }
                        completion(.success(cryptos))

                    } catch {
                        completion(.failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
