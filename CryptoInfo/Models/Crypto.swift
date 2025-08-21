//
//  Crypto.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//

struct Crypto {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let priceChangePercentage24h: Double

    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.symbol = json["symbol"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.image = json["image"] as? String ?? ""
        self.currentPrice = json["current_price"] as? Double ?? 0
        self.marketCap = json["market_cap"] as? Double ?? 0
        self.priceChangePercentage24h = json["price_change_percentage_24h"] as? Double ?? 0
    }
}
