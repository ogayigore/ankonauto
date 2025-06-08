//
//  NewCarViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/1/25.
//

import UIKit

class NewCarViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = NewCarViewModel()
    var carData: [CarField: String] = [:]
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchBrands { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Ошибка загрузки брендов: \(error.localizedDescription)")
            }
        }
        setupUI()
        addObserver()
        hideKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - UI elements
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewCarCell.self, forCellReuseIdentifier: "NewCarCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Methods
    func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        tableView.contentInset.bottom = keyboardFrame.height + 20
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset.bottom = 0
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NewCarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarField.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCarCell", for: indexPath) as? NewCarCell else {
            return UITableViewCell()
        }
        let field = CarField.allCases[indexPath.row]
        let selectedValue = carData[field]
        cell.configure(with: field, selectedValue: selectedValue)
        cell.delegate = self
        
        switch field {
        case .brand:
            let brandNames = viewModel.brands.map { $0.name }
            cell.setOptions(brandNames)
        case .model:
            let modelNames = viewModel.models.map { $0.name }
            cell.setOptions(modelNames)
        case .generation:
            let generationNames = viewModel.generations.map { $0.name }
            cell.setOptions(generationNames)
        case .fuelType:
            cell.setOptions(["Бензин", "Дизель", "Гибрид", "Электро"])
        case .transmisson:
            cell.setOptions(["Механика", "Автомат", "Робот"])
        case .driveType:
            cell.setOptions(["Передний", "Задний", "Полный"])
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: NewCarCellDelegate

extension NewCarViewController: NewCarCellDelegate {
    func newCarCellDidBeginEditing(_ cell: NewCarCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    func newCarCell(_ cell: NewCarCell, didSelect option: String, for field: CarField) {
        carData[field] = option
        print("Выбрано: \(field.rawValue) = \(option)")
        
        switch field {
        case .brand:
            if let selectedBrand = viewModel.brands.first(where: { $0.name == option }) {
                viewModel.fetchModels(for: selectedBrand.id)
                carData[.model] = nil
                carData[.generation] = nil
            }
        case .model:
            if let brandName = carData[.brand],
               let brand = viewModel.brands.first(where: { $0.name == brandName }),
               let model = viewModel.models.first(where: { $0.name == option }) {
                viewModel.fetchGenerations(for: brand.id, modelID: model.id)
                carData[.generation] = nil
            }
        default:
            break
        }
    }
}
