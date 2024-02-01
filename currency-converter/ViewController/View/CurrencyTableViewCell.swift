//
//  CurrencyTableViewCell.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/27/24.
//

import UIKit

/// Used in ConverterViewController.swift TableView <currenciesTableView>
class CurrencyTableViewCell: UITableViewCell {

    // MARK: ================================================================================
    // MARK: VARIABLE DECLARATION AND INITIAL CONFIGURATION
    // MARK: ================================================================================
    
    static let identifer = "CurrencyTableViewCell"
    
    private let baseCurrencyLabel: UILabel = { 
        let label = UILabel()
        label.textColor = AppTheme.AppColor.navyBlue.uiColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left

        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.AppColor.navyBlue.uiColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let conversionAmount: UILabel = {
        let label = UILabel()
        label.textColor = AppTheme.AppColor.suvaGray.uiColor
        label.font = UIFont.systemFont(ofSize: 12.5, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
//        stackView.spacing = .infinity
//        stackView.distribution = .fill
//        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    // MARK: ================================================================================
    // MARK: LIFECYCLE
    // MARK: ================================================================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        prepareViews()
    }
}

// MARK: ================================================================================
// MARK: VIEW CONFIGURATION
// MARK: ================================================================================

extension CurrencyTableViewCell {
    
    private func prepareViews() {
        
        backgroundColor = AppTheme.AppColor.whiteSmoke.uiColor
        
        self.contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).inset(12)
            make.top.equalTo(self.contentView.snp.top).inset(6)
            make.trailing.equalTo(self.contentView.snp.trailing).inset(12)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(6)
        }
        
        hStack.addArrangedSubview(baseCurrencyLabel)
        hStack.addArrangedSubview(vStack)

        
        vStack.addArrangedSubview(currencyLabel)
        vStack.addArrangedSubview(conversionAmount)

    }
    
}

extension CurrencyTableViewCell {
    
    func setupValues(baseCurrency: String, currency: CurrencyModel) {
        baseCurrencyLabel.text = baseCurrency
        currencyLabel.text = currency.name
        conversionAmount.text = String(describing: currency.rate)
        
    }
}
