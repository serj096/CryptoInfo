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

let imageCache = NSCache<NSString, UIImage>()

final class CryptoInfoTableViewCell: UITableViewCell {

    static let identifier = "CryptoInfoTableViewCell"
    private var currentImageURL: String?

    private let cryptoImageCell: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()

    private let nameLabel = UILabel()
    private let shortNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let capitalLaber = UILabel()
    private let changeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cryptoImageCell.layer.cornerRadius = cryptoImageCell.frame.width / 2
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true

        [cryptoImageCell, nameLabel, shortNameLabel, priceLabel, capitalLaber, changeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cryptoImageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cryptoImageCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cryptoImageCell.widthAnchor.constraint(equalToConstant: 60),
            cryptoImageCell.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.leadingAnchor.constraint(equalTo: cryptoImageCell.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            shortNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            shortNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: cryptoImageCell.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),

            capitalLaber.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
            capitalLaber.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),

            changeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            changeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with crypto: Crypto) {
        currentImageURL = crypto.image

        nameLabel.text = crypto.name
        shortNameLabel.text = crypto.symbol.uppercased()
        priceLabel.text = "$" + String(format: "%.2f", crypto.current_price)
        capitalLaber.text = "$" + String(format: "%.0f", crypto.market_cap)
        changeLabel.text = String(format: "%.2f%%", crypto.price_change_percentage_24h)

        cryptoImageCell.image = UIImage(named: "coin")

        guard let url = URL(string: crypto.image) else { return }

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            cryptoImageCell.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                if self.currentImageURL == url.absoluteString {
                    self.cryptoImageCell.image = image
                }
            }
        }.resume()
    }
}
