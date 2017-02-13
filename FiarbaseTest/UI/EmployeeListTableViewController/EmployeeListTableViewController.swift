//
//  EmployeeListTableViewController.swift
//  FiarbaseTest
//
//  Created by Vladimir Budniy on 1/30/17.
//  Copyright © 2017 Vladimir Budniy. All rights reserved.
//

import UIKit
import Firebase

class EmployeeListTableViewController: UITableViewController {
    var poeple = [Employee]()

    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.loadDataFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poeple.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let employee = poeple[indexPath.row]
        employee.ref.updateChildValues(["developer": !employee.developer!])
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            poeple[indexPath.row].ref.removeValue()
            poeple.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }

    // MARK: - Private
    
    private func populateTimeInterval(cell: UITableViewCell, timeInterval: TimeInterval) {
        cell.detailTextLabel?.text = formateDate(date: Date(timeIntervalSinceNow: timeInterval))
    }
    
    private func populateImage(cell: UITableViewCell, imageString: String) {
        let decodedData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        cell.imageView?.image = UIImage(data: decodedData!)
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let employee = self.poeple[indexPath.row]
        let timeInterval = employee.birthday! as TimeInterval
        let base64String = employee.photo
        
        cell.textLabel?.text = employee.name
        self.populateTimeInterval(cell: cell, timeInterval: timeInterval)
        self.populateImage(cell: cell, imageString: base64String!)
        self.cellCheckBox(cell: cell, isDeveloper: employee.developer!)
    }

    private func cellCheckBox(cell: UITableViewCell, isDeveloper: Bool) {
        if isDeveloper == false {
            self.cell(cell: cell, accessoryType: .none, textColor: UIColor.red)
        } else {
            self.cell(cell: cell, accessoryType: .checkmark, textColor: UIColor.blue)
        }
    }
    
    private func cell(cell: UITableViewCell, accessoryType: UITableViewCellAccessoryType, textColor: UIColor) {
        cell.accessoryType = accessoryType
        cell.textLabel?.textColor = textColor
        cell.detailTextLabel?.textColor = textColor
    }
    
    private func loadDataFromFirebase() {
        let ref = FIRDatabase.database().reference().child("employees")
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            var array = [Employee]()
            for child in snapshot.children {
                array.append(Employee.createFrom(snapshot: child as! FIRDataSnapshot))
            }
            
            self.poeple = array
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }) { (error) in
            print(error.localizedDescription)
        }
        
//        ref.observe(FIRDataEventType.childAdded, with: { (snapshot) in
//            self.poeple.append(Employee.createFrom(snapshot: snapshot))
//            self.tableView.reloadData()
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
    }
    
    // MARK: - Navigation

    @IBAction func unwindToEmployeeList(sender: UIStoryboardSegue) {
    }

}
