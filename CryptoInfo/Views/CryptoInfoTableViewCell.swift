//
//  CryptoInfoTableViewCell.swift
//  CryptoInfo
//
//  Created by serj on 16.08.2025.
//


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

    private var currentImageURL: String?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    // MARK: - UI Setup
        private func setupUI() {
            cryptoImageCell.clipsToBounds = true
            contentView.layer.cornerRadius = 15
            backgroundColor = .clear
        }

        // MARK: - Configure Cell
        func configure(with crypto: Crypto) {
            // Сохраняем текущий URL для проверки при загрузке картинки
            currentImageURL = crypto.image
            
            // Настраиваем текстовые поля
            shortNameLabel.text = crypto.symbol.uppercased()
            nameLabel.text = crypto.name
            priceLabel.text = "$" + String(format: "%.2f", crypto.current_price)
            capitalLaber.text = "$" + String(format: "%.0f", crypto.market_cap)
            changeLabel.text = String(format: "%.2f%%", crypto.price_change_percentage_24h)

            // Плейсхолдер
            cryptoImageCell.image = UIImage(named: "coin")

            guard let url = URL(string: crypto.image) else { return }

            // Проверяем кеш
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                cryptoImageCell.image = cachedImage
                return
            }

            // Загружаем изображение асинхронно
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self else { return }
                guard let data = data, let image = UIImage(data: data) else { return }

                // Сохраняем в кеш
                imageCache.setObject(image, forKey: url.absoluteString as NSString)

                DispatchQueue.main.async {
                    // Проверяем, что URL совпадает с текущей моделью ячейки
                    if self.currentImageURL == url.absoluteString {
                        self.cryptoImageCell.image = image
                    }
                }
            }.resume()
        }

        func configurePlaceholder() {
            nameLabel.text = "—"
            shortNameLabel.text = ""
            priceLabel.text = "—"
            capitalLaber.text = ""
            changeLabel.text = ""
            cryptoImageCell.image = UIImage(named: "coin")
            currentImageURL = nil
        }
}
