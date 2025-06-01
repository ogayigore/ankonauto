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
}

class NewCarCell: UITableViewCell {
    //MARK: - Properties
    
    private var options: [String] = []
    private var currentField: CarField?
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
        textField.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var picker: UIPickerView? = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor(white: 1, alpha: 0.1)
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    //MARK: - Lifecicle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
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
            inputTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with field: CarField) {
        self.currentField = field
        titleLabel.text = field.rawValue
        inputTextField.keyboardType = field.keyboardType
        
        if let options = field.options {
            self.options = options
            inputTextField.inputView = self.picker
        } else {
            inputTextField.inputView = nil
            picker = nil
            inputTextField.inputAccessoryView = nil
        }
    }
    
    @objc private func donePressed() {
        inputTextField.resignFirstResponder()
    }
}

//MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension NewCarCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = options[row]
        inputTextField.text = selectedValue
        if let field = currentField {
            delegate?.newCarCell(self, didSelect: selectedValue, for: field)
        }
    }
}

//MARK: - UITextFieldDelegate

extension NewCarCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.newCarCellDidBeginEditing(self)
    }
}
