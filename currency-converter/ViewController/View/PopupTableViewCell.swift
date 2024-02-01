//
//  PopupTableViewCell.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/31/24.
//

import UIKit

class PopupTableViewCell: UITableViewCell {
    
    // MARK: ================================================================================
    // MARK: VARIABLE DECLARATION AND INITIAL CONFIGURATION
    // MARK: ================================================================================
    
    static let identifier: String = "PopupTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .semibold)
        
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppTheme.AppColor.suvaGray.uiColor
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .regular)
        
        return label
    }()

    // MARK: ================================================================================
    // MARK: LIFECYCLE
    // MARK: ================================================================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareView()
    }
    
    // MARK: ================================================================================
    // MARK: VIEW CONFIGURATION
    // MARK: ================================================================================
    
    private func prepareView() {
        
        self.contentView.addSubview(nameLabel)
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fill
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        hStack.addArrangedSubview(nameLabel)
        //hStack.addArrangedSubview(rateLabel)
        
    }
    func setValue(currency: CurrencyModel) {
        nameLabel.text = currency.name
        rateLabel.text = String(describing: currency.rate)
        
    }

}
