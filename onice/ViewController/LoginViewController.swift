//
//  LoginViewController.swift
//  onice
//
//  Created by Chaitali Sawant on 04/12/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    func prepareView() {
        self.mainView.layer.cornerRadius = 5
        self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 2
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.showAlert("Username and password cannot be empty.")
            return
        }

        // Call login method from ViewModel
        Task {
            await self.viewModel.login(username: username, password: password)
            
            if self.viewModel.isLoggedIn {
                // Navigate to Channels screen
                self.navigateToChannelsScreen()
            } else {
                // Show error message
                if let errorMessage = viewModel.errorMessage {
                    self.showAlert(errorMessage)
                }
            }
        }
    }
    
    func navigateToChannelsScreen() {
        if let channelsVC = self.storyboard?.instantiateViewController(withIdentifier: "ChannelsViewController") {
            self.navigationController?.pushViewController(channelsVC, animated: true)
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
