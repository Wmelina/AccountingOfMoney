//
//  AccountingViewController.swift
//  Accounting Of Money
//
//  Created by Alexandr Kurdyukov on 29.03.2018.
//  Copyright © 2018 Alexandr Kurdyukov. All rights reserved.
//

import UIKit

class AccountingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var finalSumLabel: UILabel!
    
    @IBOutlet weak var bankAccount: UILabel!
    @IBOutlet weak var operationName: UITextField!
    @IBOutlet weak var operationMoney: UITextField!
    @IBOutlet weak var operation: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var finalSum = 0.0 {
        didSet {
            finalSumLabel.text = "\(finalSum) ₽"
            if finalSum < 0 {
                statusLabel.text = "you should work better!"
            } else {
                statusLabel.text = "everything is ok"
            }
        }
    }
    var arrayOfNames : Array<String> = ["Молоко"]
    var arrayOfPrices : Array<String> = ["50,6"]
    var arrayOfOperationSettings: Array<Int> = [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItemToAccTableView(_ sender: Any) {
        updatingTableView(name: operationName.text!, price: operationMoney.text!, operationIndex: operation.selectedSegmentIndex)
    }

    //MARK: - Creating table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccCell", for: indexPath) as! AccountingTableViewCell
        cell.name.text? = arrayOfNames[indexPath.row]
        cell.price.text? = arrayOfPrices[indexPath.row]
        if arrayOfOperationSettings[indexPath.row] == 1 {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.green
        }
        return cell
    }
    // MARK: - Append new item
    func updatingTableView(name: String, price: String, operationIndex: Int) {
        if operationName.text! != "" && operationMoney.text! != "" {
            if let priceDouble = Double(price) {
                if operationIndex == 0 {
                    finalSum += priceDouble
                } else {
                    finalSum -= priceDouble

                }
            }
            arrayOfPrices.append(price)
            arrayOfNames.append(name)
            arrayOfOperationSettings.append(operationIndex)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: arrayOfNames.count-1, section: 0)], with: .automatic)
            tableView.endUpdates()
            var alert: Actions? = Actions()
            self.present(alert!.showWarningAlert(title: "Success", message: "Your operation successfully added"), animated: true)
            alert = nil
            operationMoney.text = ""
            operationName.text = ""
        } else {
            var alert: Actions? = Actions()
            self.present(alert!.showWarningAlert(title: "Error", message: "You should input both values"), animated: true)
            alert = nil
        }
        
    }
    
    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
