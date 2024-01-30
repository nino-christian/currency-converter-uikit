//
//  PopupTableViewCell.swift
//  currency-converter
//
//  Created by DNA-User on 1/31/24.
//

import UIKit

class PopupTableViewCell: UITableViewCell {

    static let identifier: String = "PopupTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareView()
    }
    
    private func prepareView() {
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setValue(name: String) {
        label.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
