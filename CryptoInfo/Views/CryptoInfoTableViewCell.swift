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

final class CryptoTableViewCell: UITableViewCell {

    static let identifier = "CryptoTableViewCell"
    private var currentImageURL: String?

    private let cryptoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()
    private let marketCapLabel = UILabel()
    private let changeLabel = UILabel()

    private static let imageCache = NSCache<NSString, UIImage>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cryptoImageView.layer.cornerRadius = cryptoImageView.frame.width / 2
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true

        [cryptoImageView, nameLabel, symbolLabel, priceLabel, marketCapLabel, changeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cryptoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cryptoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cryptoImageView.widthAnchor.constraint(equalToConstant: 60),
            cryptoImageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.leadingAnchor.constraint(equalTo: cryptoImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            symbolLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: cryptoImageView.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),

            marketCapLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
            marketCapLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),

            changeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            changeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with crypto: Crypto) {
        currentImageURL = crypto.image

        nameLabel.text = crypto.name
        symbolLabel.text = crypto.symbol.uppercased()
        priceLabel.text = "$" + String(format: "%.2f", crypto.currentPrice)
        marketCapLabel.text = "$" + String(format: "%.0f", crypto.marketCap)
        changeLabel.text = String(format: "%.2f%%", crypto.priceChangePercentage24h)

        cryptoImageView.image = UIImage(named: "coin")

        guard let url = URL(string: crypto.image) else { return }

        if let cachedImage = Self.imageCache.object(forKey: url.absoluteString as NSString) {
            cryptoImageView.image = cachedImage
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    if self.currentImageURL == url.absoluteString {
                        self.cryptoImageView.image = image
                    }
                }
            }
        }
    }
}
