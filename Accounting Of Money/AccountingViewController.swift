//
//  AccountingViewController.swift
//  Accounting Of Money
//
//  Created by Alexandr Kurdyukov on 29.03.2018.
//  Copyright © 2018 Alexandr Kurdyukov. All rights reserved.
//

import UIKit
import CoreData

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
                statusLabel.text = "everything is ok."
            }
        }
    }
    var arrayOfNames = [String]()
    var arrayOfPrices = [String]()
    var arrayOfOperationSettings = [Int]()
    override func viewWillAppear(_ animated: Bool) {
        //////////////////////
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountList")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let result = try managedContext.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let option = data.value(forKey: "accountOption") as! Int
                let name = data.value(forKey: "accountName") as! String
                let money = data.value(forKey: "accountMoney") as! String
                arrayOfOperationSettings.append(option)
                arrayOfNames.append(name)
                arrayOfPrices.append(money)
            }
        } catch {
            print("Failed")
        }
        /////////////////////
    }
    
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
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccCell", for: indexPath) as! AccountingTableViewCell
        cell.name.text? = "  \(arrayOfNames[indexPath.row])"
        
        if arrayOfOperationSettings[indexPath.row] == 1 {
            cell.backgroundColor = UIColor.red
            cell.price.text? = "-\(arrayOfPrices[indexPath.row]) ₽"
        } else {
            cell.backgroundColor = UIColor.green
            cell.price.text? = "+\(arrayOfPrices[indexPath.row]) ₽"
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
            
            /////////////
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "AccountList", in: managedContext)
            let newGood = NSManagedObject(entity: entity!, insertInto: managedContext)
            newGood.setValue(name, forKey: "accountName")
            newGood.setValue(price, forKey: "accountMoney")
            newGood.setValue(operationIndex, forKey: "accountOption")
                do {
                    try managedContext.save()
                } catch {
                    print(error)
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
}
    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


