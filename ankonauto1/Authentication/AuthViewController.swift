//
//  AuthViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/3/25.
//

import UIKit

class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: AuthViewModel
    
    //MARK: - Initializers
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: - Methods
    
    //Вход с Google
    @objc func googleButtonTapped() {
        
        showLoading()
        
        viewModel.signInWithGoogle(presentingVC: self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    
                    self?.hideLoading()
                    
                    if userModel.isAdmin {
                        //Переход в интерфейс админа
                        print("Успешный вход: \(userModel.uid)")
                        let tabBar = AdminTabBarController(authViewModel: self!.viewModel, currentUser: userModel)
                        tabBar.modalPresentationStyle = .fullScreen
                        self?.present(tabBar, animated: true)
                    } else {
                        //Переход в интерфейс клиента
                        print("Не админ")
                    }
                case .failure(let error):
                    
                    self?.hideLoading()
                    
                    print("Ошибка входа: \(error.localizedDescription)")
                    //Алерт
                }
            }
            
        }
    }
    //Переход на главный экран
    func goToHomeViewController() {
        
    }
    
    //MARK: - UI elements
    lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход по номеру телефона", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход через Google", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var appleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход через Apple", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ankonauto_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_auto")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var loadingView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.8
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Setup UI
    
    func setUpUI() {
        view.backgroundColor = .black
        
        view.addSubview(phoneButton)
        view.addSubview(googleButton)
        view.addSubview(appleButton)
        view.addSubview(logoImageView)
        view.addSubview(photoImageView)
        view.addSubview(loadingView)
        loadingView.contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            //phoneButton
            phoneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            phoneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            phoneButton.heightAnchor.constraint(equalToConstant: 50),
            
            //googleButton
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 8),
            googleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            googleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
            
            //appleButton
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 8),
            appleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            appleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            appleButton.heightAnchor.constraint(equalToConstant: 50),
            
            //logoImage
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            logoImageView.bottomAnchor.constraint(equalTo: phoneButton.topAnchor, constant: 16),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            //photoImage
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            photoImageView.topAnchor.constraint(greaterThanOrEqualTo: appleButton.bottomAnchor, constant: 20),
            
            //loadingView
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            //activityIndicator
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    //MARK: - Activity Indicator
    
    func showLoading() {
        loadingView.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}

