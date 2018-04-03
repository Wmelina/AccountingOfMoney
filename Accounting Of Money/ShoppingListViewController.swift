//
//  ShoppingListViewController.swift
//  Accounting Of Money
//
//  Created by Alexandr Kurdyukov on 29.03.2018.
//  Copyright © 2018 Alexandr Kurdyukov. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrayOfNames = [String]()
    var arrayOfPrices = [String]()
    
    @IBOutlet weak var operationName: UITextField!
    @IBOutlet weak var operationPrice: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func addItem(_ sender: Any) {
        appendNewItem(name: operationName.text!, price: operationPrice.text!)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShoppingListTableViewCell
        cell.name.text? = "  \(arrayOfNames[indexPath.row])"
        cell.price.text? = "-\(arrayOfPrices[indexPath.row]) ₽"
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //////////////////////
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let result = try managedContext.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "listName") as! String
                let money = data.value(forKey: "listMoney") as! String
                arrayOfNames.append(name)
                arrayOfPrices.append(money)
            }
        } catch {
            print("Failed")
        }
        /////////////////////
    }
    
    func appendNewItem(name: String, price: String) {
        if operationName.text! != "" && operationPrice.text! != "" {
            
            /////////////
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ShoppingList", in: managedContext)
            let newGood = NSManagedObject(entity: entity!, insertInto: managedContext)
            newGood.setValue(name, forKey: "listName")
            newGood.setValue(price, forKey: "listMoney")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            
            arrayOfPrices.append(price)
            arrayOfNames.append(name)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: arrayOfNames.count-1, section: 0)], with: .automatic)
            tableView.endUpdates()
            var alert: Actions? = Actions()
            self.present(alert!.showWarningAlert(title: "Success", message: "Your operation successfully added"), animated: true)
            alert = nil
            operationPrice.text = ""
            operationName.text = ""
        } else {
            var alert: Actions? = Actions()
            self.present(alert!.showWarningAlert(title: "Error", message: "You should input both values"), animated: true)
            alert = nil
        }
    }

}
