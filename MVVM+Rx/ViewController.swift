//
//  ViewController.swift
//  MVVM+Rx
//
//  Created by Nurbakhyt on 04.08.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confgureUI()
        viewModel.fetchCoins()
        bindTableView()
    }
    
    func confgureUI(){
        //navigationController?.navigationBar.prefersLargeTitles = true
        title = "Coins"
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinTableViewCell")
    }
    
    func bindTableView(){
//        tableView.rx.setDelegate(self).disposed(by: bag)
//        
//        viewModel.coins.bind(to: tableView.rx.items(cellIdentifier: "CoinTableViewCell", cellType: CoinTableViewCell.self)) { (row, item, cell) in
//            cell.textLabel?.text = item.name
//            if let price = item.priceUsd?.toDouble(){
//                let y = String(format: "%.3f", price)
//                cell.detailTextLabel?.text = "\(y) $"
//            }
//        }.disposed(by: bag)
//        
//        tableView.rx.itemSelected.subscribe { indexPath in
//            print(indexPath.row)
//            self.tableView.deselectRow(at: indexPath, animated: true)
//        }.disposed(by: bag)
//        
//        tableView.rx.itemDeleted.subscribe { [weak self] index in
//            guard let self = self else { return }
//            self.viewModel.deleteCoin(index: index.row)
//        }.disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CoinData>> { _, tableView, index, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: index) as! CoinTableViewCell
            cell.textLabel?.text = item.name
            if let price = item.priceUsd?.toDouble(){
                let y = String(format: "%.3f", price)
                cell.detailTextLabel?.text = "\(y) $"
            }
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        self.viewModel.coins.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe { [weak self] index in
            guard let self = self else { return }
            self.viewModel.deleteCoin(index: index)
        }.disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.confirmingAlert(indexPath: indexPath)
            })
            .disposed(by: bag)
    }
    
    func addFavourite(indexPath: IndexPath){
        do {
            let sections = try self.viewModel.coins.value()
            guard sections.indices.contains(indexPath.section),
                  sections[indexPath.section].items.indices.contains(indexPath.row) else { return }
            let coin = sections[indexPath.section].items[indexPath.row]
            self.viewModel.addToFav(coin: coin)
        } catch {
            print("Error retrieving sections: \(error)")
        }

    }
    func confirmingAlert(indexPath: IndexPath){
        let sections = try! self.viewModel.coins.value()
        guard sections.indices.contains(indexPath.section),
              sections[indexPath.section].items.indices.contains(indexPath.row) else { return }
        let coin = sections[indexPath.section].items[indexPath.row]
        
        let alert = UIAlertController(title: "\(coin.name ?? "Confirm")", message: "Do you realy want to Favourite?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Yes", style: .default) { action in
            self.addFavourite(indexPath: indexPath)
        }
        let cancel = UIAlertAction(title: "Not Sure", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension ViewController : UITableViewDelegate{}

