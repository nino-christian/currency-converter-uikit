//
//  PopupView.swift
//  currency-converter
//
//  Created by DNA-User on 1/31/24.
//

import UIKit

protocol PopupViewDelegate: AnyObject {
    func didSelectCurrency(currency: CurrencyModel, forButton: Int)
}

class PopupView: UIView {
    
    weak var delegate: PopupViewDelegate?
    private var currencies: [CurrencyModel] = []
    private var buttonIndex: Int = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PopupTableViewCell.self, forCellReuseIdentifier: PopupTableViewCell.identifier)
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    private func prepareView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setValue(currencies: [CurrencyModel], buttonIndex: Int) {
        self.currencies = currencies
        self.buttonIndex = buttonIndex
    }
}

extension PopupView: UITableViewDelegate, UITableViewDataSource {
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
        delegate?.didSelectCurrency(currency: currencies[indexPath.row], forButton: buttonIndex)
    }
    
}
