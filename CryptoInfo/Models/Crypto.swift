//
//  Crypto.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//


struct Crypto: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let market_cap: Double
    let price_change_percentage_24h: Double
}