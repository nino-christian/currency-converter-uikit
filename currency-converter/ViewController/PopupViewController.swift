//
//  PopupViewController.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/31/24.
//

import UIKit

protocol PopupViewDelegate: AnyObject {
    func didSelectCurrency(currency: CurrencyModel)
}

class PopupViewController: UIViewController {
    
    weak var delegate: PopupViewDelegate?
    private var currencies: [CurrencyModel?] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
        self.view.accessibilityIdentifier = "PopupViewController"
    }
    
    private func prepareView() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "PopupTableView"
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.register(PopupTableViewCell.self, forCellReuseIdentifier: PopupTableViewCell.identifier)
       
    }
    
    func setValue(currencies: [CurrencyModel?]) {
        self.currencies = currencies
        //tableView.reloadData()
    }
}

extension PopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupTableViewCell.identifier, for: indexPath) as? PopupTableViewCell,
            let currency = currencies[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setValue(currency: currency)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 25
//    }
//    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currency: currencies[indexPath.row]!)
       
    }
}
