//
//  CryptoInfoTableViewCell.swift
//  CryptoInfo
//
//  Created by serj on 08.08.2025.
//
import UIKit

// Глобальный кеш для изображений
let imageCache = NSCache<NSString, UIImage>()

class CryptoInfoTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var cryptoImageCell: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var capitalLaber: UILabel!
    @IBOutlet weak var changeLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        cryptoImageCell.layer.cornerRadius = cryptoImageCell.frame.size.width / 2
        cryptoImageCell.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        backgroundColor = .clear
    }

    // MARK: - Configure Cell
    func configure(with crypto: Crypto) {
        // Проверяем IBOutlet
        guard cryptoImageCell != nil else {
            print("cryptoImageCell is nil! Проверьте IBOutlet в Storyboard/XIB.")
            return
        }

        // Настраиваем текстовые поля
        shortNameLabel.text = crypto.symbol.uppercased()
        nameLabel.text = crypto.name
        priceLabel.text = "$" + String(format: "%.2f", crypto.current_price)
        capitalLaber.text = "$" + String(format: "%.0f", crypto.market_cap)
        changeLabel.text = String(format: "%.2f%%", crypto.price_change_percentage_24h)

        // Ставим плейсхолдер сразу
        cryptoImageCell.image = UIImage(named: "coin")

        // Проверяем валидный URL
        if let url = URL(string: crypto.image) {
            // Проверяем кеш
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                self.cryptoImageCell.image = cachedImage
            } else {
                // Асинхронная загрузка изображения
                URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                    guard let self = self else { return }
                    if let data = data, let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        DispatchQueue.main.async {
                            self.cryptoImageCell.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}
