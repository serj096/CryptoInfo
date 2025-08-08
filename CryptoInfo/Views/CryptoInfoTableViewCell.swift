//
//  CryptoInfoTableViewCell.swift
//  CryptoInfo
//
//  Created by serj on 08.08.2025.
//

import UIKit

class CryptoInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cryptoImageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cryptoImageCell.layer.cornerRadius = cryptoImageCell.frame.size.width / 2
        contentView.layer.cornerRadius = 15
        backgroundColor = .clear
        
    }
   

    
    // MARK: - Private methods
//     func configure(with crypto: Crypto) {
//         cryptoImageCell.image = UIImage(named: crypto.image)
//         symbol.text = crypto.symbol
//         nameLabel.text = crypto.name
//         currentPrice.text = crypto.current_price
//        ageLabel.text = crypto.market_cap
//         priceChangePercentagePerDay = crypto.price_change_percentage_24h
//    }

}
