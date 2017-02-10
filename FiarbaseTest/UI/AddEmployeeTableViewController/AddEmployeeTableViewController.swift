//
//  AddEmployeeTableViewController.swift
//  FiarbaseTest
//
//  Created by Vladimir Budniy on 1/30/17.
//  Copyright © 2017 Vladimir Budniy. All rights reserved.
//

import UIKit

import Firebase
import GoogleMobileAds

class AddEmployeeTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var dateTextField: UITextField?
    @IBOutlet var photoImageView: UIImageView?
    @IBOutlet var datePicker: UIDatePicker?
    @IBOutlet weak var isDeveloper: UISwitch!
    
    var isDev = false
    var dateOfBirthTimeInterval: TimeInterval = 0
    var ref = FIRDatabase.database().reference()
    
    var imagePiker = UIImagePickerController()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTextField()
    }
    
    // MARK: - @IBAction

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField?.resignFirstResponder()
        
        return true
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        if self.isDeveloper.isOn {
            self.isDev = true
        } else {
            self.isDev = false
        }
    }
    
    @IBAction func onDatePicked(sender: AnyObject){
        self.dateOfBirthTimeInterval = (datePicker?.date.timeIntervalSinceNow)!
        self.dateTextField?.text = formateDate(date: datePicker?.date)
    }
    
    @IBAction func onSaveEmployee(sender: AnyObject) {
        let name = self.nameTextField?.text
        let dateString = self.dateTextField?.text
        if  name != "" || dateString != "" {
            let base64String = self.base64StringForUserImage()
            let newEmployee: Dictionary = ["name": name!,
                                           "birthday": self.dateOfBirthTimeInterval,
                                           "photo": base64String,
                                           "developer": isDev] as [String : Any]
            // write data to Firebase
            self.saveEmployee(employee: newEmployee)
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePickerSourceType(type: .camera)
            } else {
                self.imagePickerSourceType(type: .photoLibrary)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Private
    
    private func settingTextField() {
        let textField = self.nameTextField
        textField?.delegate = self
        textField?.returnKeyType = UIReturnKeyType.done
    }
    
    private func imagePickerSourceType(type: UIImagePickerControllerSourceType) {
        let imagePiker = self.imagePiker
        imagePiker.delegate = self
        imagePiker.sourceType = type
        self.present(imagePiker, animated: true)
    }
    
    private func base64StringForUserImage() -> String {
        var data = Data();
        if let image = self.photoImageView?.image {
            data = UIImageJPEGRepresentation(image, 0.1)!
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    private func saveEmployee(employee: Dictionary<String, Any>) {
        let name = employee["name"] as? String
        self.ref.child("employees").child(name!).setValue(employee)
    }
}

    // MARK: - Extension

extension AddEmployeeTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePiker.dismiss(animated: true)
        self.photoImageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
