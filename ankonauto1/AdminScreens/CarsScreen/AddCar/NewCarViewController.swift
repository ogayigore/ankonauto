//
//  NewCarViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/1/25.
//

import UIKit
import PhotosUI

class NewCarViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = NewCarViewModel()
    private weak var activeCell: NewCarCell?
    var carData: [CarField: String] = [:]
    private var selectedImages: [UIImage] = []
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        onDataUpdate()
        fetchBrands()
        addObserver()
        hideKeyboard()
        nextButtonConfigure()
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
        tableView.register(PhotoCollectionCell.self, forCellReuseIdentifier: PhotoCollectionCell.identifier)
        tableView.register(NewCarCell.self, forCellReuseIdentifier: "NewCarCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
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
    
    func onDataUpdate() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            guard let activeField = self.activeCell?.currentField else { return }
            
            let fieldsToReload: [CarField] = [.model, .generation]
            let indexPaths: [IndexPath] = fieldsToReload.compactMap { field in
                guard let index = CarField.allCases.firstIndex(of: field) else { return nil }
                
                if field == activeField {
                    return nil
                }
                return IndexPath(row: index, section: 0)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: indexPaths, with: .none)
            }
            
            switch activeField {
            case .model:
                let models = self.viewModel.models.map { $0.name }
                self.activeCell?.setOptions(models)
            case .generation:
                let generations = viewModel.generations.map { $0.name }
                self.activeCell?.setOptions(generations)
            default:
                break
            }
        }
    }
    
    func fetchBrands() {
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
    
    private func nextButtonConfigure() {
        let nextButton = UIBarButtonItem(title: "Далее", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc private func nextTapped() {
        if areAllFieldsFilled() {
            print("NEXT SCREEN!!!")
        } else {
            let alertController = UIAlertController(title: "Есть незаполненные поля", message: "Пожалуйста, заполните все поля", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        }
    }
    
    private func areAllFieldsFilled() -> Bool {
        return CarField.allCases.allSatisfy { field in
            if let value = carData[field], !value.trimmingCharacters(in: .whitespaces).isEmpty {
                return true
            } else {
                return false
            }
        }
    }
    
    private func showImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension NewCarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarField.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == CarField.allCases.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCollectionCell.identifier) as? PhotoCollectionCell ?? PhotoCollectionCell()
            cell.reload(images: selectedImages)
            cell.onAddPhotoTapped = { [weak self] in
                self?.showImagePicker()
            }
            return cell
        }
        
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
        return 100
    }
}

//MARK: NewCarCellDelegate

extension NewCarViewController: NewCarCellDelegate {
    func newCarCellDidBeginEditing(_ cell: NewCarCell) {
        activeCell = cell
        if let indexPath = tableView.indexPath(for: cell) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    func newCarCellDidFinishEditing(_ cell: NewCarCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let field = cell.currentField,
              let value = cell.getCurrentValue(), !value.isEmpty else { return }
        
        carData[field] = value
        print("Сохранено: \(field.rawValue) = \(value)")
        
        let nextRow = indexPath.row + 1
        if nextRow < CarField.allCases.count {
            let nextIndexPath = IndexPath(row: nextRow, section: 0)
            if let nextCell = tableView.cellForRow(at: nextIndexPath) as? NewCarCell {
                nextCell.focusTextField()
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
    
    func newCarCell(_ cell: NewCarCell, didUpdateText text: String, for field: CarField) {
        carData[field] = text
    }
}

//MARK: - PHPickerViewControllerDelegate

extension NewCarViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                defer { group.leave() }
                if let uiImage = image as? UIImage {
                    self?.selectedImages.append(uiImage)
                }
            }
        }
        
        group.notify(queue: .main) {
            if let index = CarField.allCases.count as Int? {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
}
