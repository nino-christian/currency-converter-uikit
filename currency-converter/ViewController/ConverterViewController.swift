//
//  ConverterViewController.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import UIKit
import SnapKit

class ConverterViewController: UIViewController {
    
    private let inputCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Amount Here"
        textField.accessibilityIdentifier = "InputCurrencyTextField"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textField.textColor = AppTheme.AppColor.navyBlue.uiColor
        textField.keyboardType = .decimalPad
        textField.layer.borderColor = AppTheme.AppColor.lightGray.uiColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.becomeFirstResponder()
        let indentSpacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.leftView = indentSpacer
        
        return textField
    }()
    
    private let outputCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Converted Amount Here"
        textField.accessibilityIdentifier = "OutputCurrencyTextField"
        textField.isUserInteractionEnabled = false
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textField.textColor = AppTheme.AppColor.suvaGray.uiColor
        textField.layer.borderColor = AppTheme.AppColor.lightGray.uiColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        let indentSpacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.leftView = indentSpacer
        
        return textField
    }()
    
    private let inputCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor( AppTheme.AppColor.white.uiColor, for: .normal)
        button.backgroundColor = AppTheme.AppColor.navyBlue.uiColor.withAlphaComponent(0.75)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.accessibilityIdentifier = "InputCurrencyButton"
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let outputCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor( AppTheme.AppColor.white.uiColor, for: .normal)
        button.backgroundColor = AppTheme.AppColor.navyBlue.uiColor.withAlphaComponent(0.75)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.accessibilityIdentifier = "OutputCurrencyButton"
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let hStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let hStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let currenciesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.accessibilityIdentifier = "CurrenciesTableView"
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.identifer)
        
        return tableView
    }()
    
    //private var popupView: PopupView?
    private var selectedButton: UIButton?
    
    private var viewModel: ConverterViewModel
    private var currencies: [CurrencyModel?] = []
    
    private var selectedInputCurrency: CurrencyModel?
    private var selectedOutputCurrency: CurrencyModel?
    
// MARK: ================================================================================
// MARK: LIFECYLE
// MARK: ================================================================================
    init(viewModel: ConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchCurrencies()
        
        
        prepareViews()
    }
}
// MARK: ================================================================================
// MARK: VIEWS CONFIGURATION
// MARK: ================================================================================

extension ConverterViewController: UITextFieldDelegate {
    
    private func prepareViews() {
        self.title = "Currency Converter"
        self.view.backgroundColor = AppTheme.AppColor.whiteSmoke.uiColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: AppTheme.AppColor.navyBlue.uiColor.withAlphaComponent(0.8)]
        
        prepareConverterForm()
        prepareObservables()
    }
    
    private func prepareConverterForm() {
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(15)
        }
        
        stackView.addArrangedSubview(hStackView1)
        stackView.addArrangedSubview(hStackView2)
        
        hStackView1.addArrangedSubview(inputCurrencyTextField)
        hStackView1.addArrangedSubview(inputCurrencyButton)
        
        
        inputCurrencyTextField.delegate = self
        inputCurrencyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        inputCurrencyTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        inputCurrencyButton.addTarget(self, action: #selector(inputCurrencyButtonTapped(_:)), for: .touchUpInside)
        inputCurrencyButton.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(80)
        }
        
        hStackView2.addArrangedSubview(outputCurrencyTextField)
        hStackView2.addArrangedSubview(outputCurrencyButton)
        
        outputCurrencyTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        outputCurrencyButton.addTarget(self, action: #selector(outputCurrencyButtonTapped(_:)), for: .touchUpInside)
        outputCurrencyButton.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(80)
        }
        
        currenciesTableView.delegate = self
        currenciesTableView.dataSource = self
        self.view.addSubview(currenciesTableView)
        currenciesTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func tableHeaderview() -> UIView {
        let headerView = UIView()
        let hStack = UIStackView()
        let baseCurrencyLabel = UILabel()
        let currencyLabel = UILabel()

        headerView.backgroundColor = AppTheme.AppColor.navyBlue.uiColor.withAlphaComponent(0.7)
        
        headerView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
       
        hStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        hStack.addArrangedSubview(baseCurrencyLabel)
        baseCurrencyLabel.font = UIFont.systemFont(ofSize: 15.5, weight: .bold)
        baseCurrencyLabel.textColor = AppTheme.AppColor.white.uiColor
        baseCurrencyLabel.text = "Base Currency"
        
        hStack.addArrangedSubview(currencyLabel)
        currencyLabel.font = UIFont.systemFont(ofSize: 15.5, weight: .bold)
        currencyLabel.textColor = AppTheme.AppColor.white.uiColor
        currencyLabel.text = "Currency List"
        
        return headerView
    }
}

extension ConverterViewController {
    
    func prepareObservables() {
        
        viewModel.currencyRates.sink(receiveCompletion: { completion in
            switch completion {
            case .finished: break
                // TODO: Do something if finished
            case .failure(let error):
                print("Error occured: \(error)")
                // TODO: Create a pop up dialog
            }
        }, receiveValue: { currencyList in
            self.currencies = currencyList
            DispatchQueue.main.async { [weak self] in
                print("UI updated")
                guard let this = self else { return }
                this.currenciesTableView.reloadData()
                this.selectedInputCurrency = currencyList[0]
                this.selectedOutputCurrency = currencyList[0]
                this.inputCurrencyButton.setTitle(this.selectedInputCurrency?.name, for: .normal)
                this.outputCurrencyButton.setTitle(this.selectedOutputCurrency?.name, for: .normal)
            }
        })
        .store(in: &viewModel.cancellables)
    }
    
    private func preparePopUp(_ sender: UIButton) {
        selectedButton = sender
        let popupViewController = PopupViewController()
        popupViewController.delegate = self
        popupViewController.setValue(currencies: currencies)
        present(popupViewController, animated: true)
    }
}

extension ConverterViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputCurrencyTextField.layer.cornerRadius = 8
        inputCurrencyTextField.layer.borderColor = AppTheme.AppColor.navyBlue.uiColor.withAlphaComponent(0.9).cgColor
        inputCurrencyTextField.layer.borderWidth = 1.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputCurrencyTextField.layer.borderColor = AppTheme.AppColor.lightGray.uiColor.cgColor
        inputCurrencyTextField.layer.borderWidth = 1
        inputCurrencyTextField.borderStyle = .roundedRect
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension ConverterViewController {
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if textField == inputCurrencyTextField {
            //let baseCurrency = currencies.first(where: { $0?.name == "USD"})
            if let text = textField.text,
               let amount = Double(text),
               let inputRate = selectedInputCurrency?.rate,
               let outputRate = selectedOutputCurrency?.rate {
                let computedResult = viewModel.convertCurrency(amount: amount,
                                                               from: inputRate,
                                                               to: outputRate)
                outputCurrencyTextField.text = String(describing: computedResult)
            } else {
                outputCurrencyTextField.text = ""
            }
            
        }
    }
    
    @objc
    private func inputCurrencyButtonTapped(_ sender: UIButton) {
        preparePopUp(sender)
    }
    
    @objc
    private func outputCurrencyButtonTapped(_ sender: UIButton) {
        preparePopUp(sender)
    }
}

extension ConverterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifer,
                                                       for: indexPath) as? CurrencyTableViewCell else { return UITableViewCell() }
        if let currency = currencies[indexPath.row] {
            cell.setupValues(baseCurrency: "USD", currency: currency)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderview()
    }
    
}

extension ConverterViewController: PopupViewDelegate {
    func didSelectCurrency(currency: CurrencyModel) {
        dismiss(animated: true, completion: nil)
        
        if selectedButton == inputCurrencyButton {
            inputCurrencyButton.setTitle(currency.name, for: .normal)
            selectedInputCurrency = currency
        } else if selectedButton == outputCurrencyButton {
            outputCurrencyButton.setTitle(currency.name, for: .normal)
            selectedOutputCurrency = currency
        } else {}
        
        if let text = inputCurrencyTextField.text,
           let amount = Double(text),
           let inputRate = selectedInputCurrency?.rate,
           let outputRate = selectedOutputCurrency?.rate {
            let computedAmount = viewModel.convertCurrency(amount: amount,
                                                           from: inputRate,
                                                           to: outputRate)
            outputCurrencyTextField.text = String(describing: computedAmount)
        }
    }

}
extension ConverterViewController {
    private func fetchCurrencies() {
        Task {
            await viewModel.getCurrencies()
        }
    }
}
