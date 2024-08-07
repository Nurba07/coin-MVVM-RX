//
//  ViewMODEL.swift
//  MVVM+Rx
//
//  Created by Nurbakhyt on 04.08.2024.
// "https://api.coincap.io/v2/assets"

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ViewModel{
    var coins = BehaviorSubject(value: [SectionModel(model: "", items: [CoinData]())])
    var favourite = BehaviorSubject(value: [SectionModel(model: "", items: [CoinData]())])

    func fetchCoins(){
        let url = URL(string: "https://api.coincap.io/v2/assets")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let responseData = try JSONDecoder().decode(Coin.self, from: data)
                let sectionCoin = SectionModel(model: "Coins", items: responseData.data)
                let sectionFavourite = SectionModel(model: "Favourite", items: [CoinData]())

                self.coins.on(.next([sectionFavourite, sectionCoin]))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func deleteCoin(index: IndexPath){
        guard var section = try? coins.value() else { return }
        var currentSection = section[index.section]
        currentSection.items.remove(at: index.row)
        section[index.section] = currentSection
        self.coins.onNext(section)
    }
    
    func addToFav(coin: CoinData){
        guard var section = try? coins.value() else { return }
        var currentSection = section[0]
        currentSection.items.append(coin)
        section[0] = currentSection
        self.coins.onNext(section)
    }
}
