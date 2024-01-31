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
    private var currencies: [CurrencyModel] = []
    
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    private func prepareView() {
        view.backgroundColor = .black
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PopupTableViewCell.self, forCellReuseIdentifier: PopupTableViewCell.identifier)
        view.addSubview(tableView)
    }
    
    func setValue(currencies: [CurrencyModel]) {
        self.currencies = currencies
        tableView.reloadData()
    }
}

extension PopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupTableViewCell.identifier, for: indexPath) as? PopupTableViewCell else {
            return UITableViewCell()
        }
        let currency = currencies[indexPath.row]
        cell.setValue(name: currency.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currency: currencies[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
