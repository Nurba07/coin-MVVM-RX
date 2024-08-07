//
//  CoinTableViewCell.swift
//  MVVM+Rx
//
//  Created by Nurbakhyt on 04.08.2024.
//

import UIKit

class CoinTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "CoinTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
