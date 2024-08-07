//
//  StringExtension.swift
//  MVVM+Rx
//
//  Created by Nurbakhyt on 06.08.2024.
//

import Foundation
import UIKit

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
