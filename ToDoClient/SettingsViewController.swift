//
//  SettingsViewController.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation
import UIKit

struct SettingsService {
    
    private static let endpointKey = "endpoint"
    private static let defaultEndpoint = "192.168.178.88:8080"
    static var endpoint:String {
        get {
            return UserDefaults.standard.string(forKey: SettingsService.endpointKey) ?? defaultEndpoint
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsService.endpointKey)
        }
    }
}


class SettingsViewController: UIViewController {
    
    
    @IBOutlet var endpointTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endpointTextField.text = SettingsService.endpoint
        endpointTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SettingsService.endpoint = endpointTextField.text ?? ""
    }
    
    
    
}


extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        SettingsService.endpoint = textField.text ?? ""
    }
}
