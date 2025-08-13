//
//  CryptoInfoTableViewCell.swift
//  CryptoInfo
//
//  Created by serj on 08.08.2025.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>() // кэш для картинок

class CryptoInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cryptoImageCell: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var capitalLaber: UILabel!
    @IBOutlet weak var changeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        cryptoImageCell.layer.cornerRadius = cryptoImageCell.frame.size.width / 2
        cryptoImageCell.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        backgroundColor = .clear
    }

    func configure(with crypto: Crypto) {
        shortNameLabel.text = crypto.symbol.uppercased()
        nameLabel.text = crypto.name
        priceLabel.text = "$" + String(format: "%.2f", crypto.current_price)
        capitalLaber.text = "$" + String(format: "%.0f", crypto.market_cap)
        changeLabel.text = String(format: "%.2f%%", crypto.price_change_percentage_24h)

        // Сначала ставим плейсхолдер
        cryptoImageCell.image = UIImage(systemName: "bitcoinsign.circle")

        guard let url = URL(string: crypto.image) else { return }

        // Проверяем кеш
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            cryptoImageCell.image = cachedImage
            return
        }

        // Загружаем в фоне
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, let image = UIImage(data: data) {
                // Кешируем
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    self?.cryptoImageCell.image = image
                }
            }
        }.resume()
    }
}
