//
//  NewCarCell.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/1/25.
//

import UIKit

protocol NewCarCellDelegate: AnyObject {
    func newCarCell(_ cell: NewCarCell, didSelect option: String, for field: CarField)
    func newCarCellDidBeginEditing(_ cell: NewCarCell)
    func newCarCellDidFinishEditing(_ cell: NewCarCell)
    func newCarCell(_ cell: NewCarCell, didUpdateText text: String, for field: CarField)
}

class NewCarCell: UITableViewCell {
    //MARK: - Properties
    
    private var options: [String] = []
    private(set) var currentField: CarField?
    weak var delegate: NewCarCellDelegate?
    
    //MARK: - UI Elements
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor(white: 1, alpha: 0.1)
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let nextButton = UIBarButtonItem(title: "Далее", style: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexSpace, nextButton], animated: false)
        return toolBar
    }()
    
    //MARK: - Lifecicle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        inputTextField.inputView = picker
        inputTextField.inputAccessoryView = toolBar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(inputTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            inputTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            inputTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            inputTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with field: CarField, options: [String] = [], selectedValue: String? = nil) {
        self.currentField = field
        self.options = options
        titleLabel.text = field.rawValue
        inputTextField.placeholder = field.rawValue
        
        configureKeyboardType(for: field)
        
        if let selected = selectedValue {
            inputTextField.text = selected
        } else {
            inputTextField.text = nil
        }
        
        inputTextField.reloadInputViews()
    }
    
    func setOptions(_ options: [String]) {
        self.options = options
        picker.reloadAllComponents()
        
        if let field = currentField {
            switch field {
            case .dateOfManufacture, .mileage, .engineCapacity, .enginePower, .price:
                inputTextField.inputView = nil
            default:
                inputTextField.inputView = options.isEmpty ? nil : picker
            }
        } else {
            inputTextField.inputView = options.isEmpty ? nil : picker
        }
        inputTextField.reloadInputViews()
    }
    
    @objc private func doneTapped() {
        inputTextField.resignFirstResponder()
        delegate?.newCarCellDidFinishEditing(self)
    }
    
    func focusTextField() {
        inputTextField.becomeFirstResponder()
    }
    
    func configureKeyboardType(for field: CarField) {
        switch field {
        case .dateOfManufacture, .mileage, .engineCapacity, .enginePower, .price:
            inputTextField.inputView = nil
            inputTextField.keyboardType = .decimalPad
        default:
            inputTextField.inputView = options.isEmpty ? nil : picker
            inputTextField.keyboardType = .default
        }
        inputTextField.inputAccessoryView = toolBar
    }
    
    func getCurrentValue() -> String? {
        return inputTextField.text
    }
}

//MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension NewCarCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.isEmpty ? 1 : options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options.isEmpty ? "Нет данных" : options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard !options.isEmpty else { return }
        let selectedValue = options[row]
        inputTextField.text = selectedValue
        if let field = currentField {
            delegate?.newCarCell(self, didSelect: selectedValue, for: field)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = currentField else { return }
        delegate?.newCarCell(self, didUpdateText: textField.text ?? "", for: field)
    }
}

//MARK: - UITextFieldDelegate

extension NewCarCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.newCarCellDidBeginEditing(self)
    }
}
