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
    var objects = [NSManagedObject]()
    var moreObjects = [NSManagedObject]()
    @IBOutlet weak var operationName: UITextField!
    @IBOutlet weak var operationPrice: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func addItem(_ sender: Any) {
        appendNewItem(name: operationName.text!, price: operationPrice.text!)
    }
    
    var index = 0
    var finalSum = 0.0
    
    
    @IBAction func addToAVC(_ sender: Any) {
        let alert = UIAlertController(title: "Are you serious?", message: "Do you already bought this thing?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {(action) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext /*if let priceDouble = Double(self.arrayOfPrices[self.index]) {
                
                   AccountingViewController.finalSum -= priceDouble
                    
             
            }*/
            /////////////
            let ent = NSEntityDescription.entity(forEntityName: "Final", in: managedContext)
            managedContext.delete(self.moreObjects[0])
            self.finalSum -= Double(self.arrayOfPrices[self.index])!
            let entityZ = NSEntityDescription.entity(forEntityName: "Final", in: managedContext)
            let fff = NSManagedObject(entity: entityZ!, insertInto: managedContext)
            fff.setValue(self.finalSum, forKey: "final")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountList")
            do {
                _ = try managedContext.fetch(request)
            } catch {
                print(error)
            }
            /////////////
            
            let entity = NSEntityDescription.entity(forEntityName: "AccountList", in: managedContext)
            let newGood = NSManagedObject(entity: entity!, insertInto: managedContext)
            newGood.setValue(self.arrayOfNames[self.index], forKey: "accountName")
            newGood.setValue(self.arrayOfPrices[self.index], forKey: "accountMoney")
            newGood.setValue(1, forKey: "accountOption")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            let alert2 = UIAlertController(title: "Chill out", message: "Everything going fine", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(action) in
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
                //request.predicate = NSPredicate(format: "age = %@", "12")
                request.returnsObjectsAsFaults = false
                do {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    //var result = try managedContext.//fetch(request)
                    //result//remove(at: self.index)
                    managedContext.delete(self.self.objects[self.index])
                    self.arrayOfPrices.remove(at: self.index)
                    self.arrayOfNames.remove(at: self.index)
                    self.tableView.reloadData()
                    /*
                     for data in result as! [NSManagedObject] {
                     let name = data.value(forKey: "listName") as! String
                     let money = data.value(forKey: "listMoney") as! String
                     arrayOfNames.append(name)
                     arrayOfPrices.append(money)
                     }*/
                } catch {
                    print("Failed")
                }
            }))
            self.present(alert2, animated: true, completion:  nil)
        }))
            present(alert, animated: true, completion: nil)
        
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        print(index)
        print(arrayOfPrices[index])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToHideKeyboard()
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
                objects.append(data)
            }
        } catch {
            print("Failed")
        }
        /////////////////////
        let requestz = NSFetchRequest<NSFetchRequestResult>(entityName: "Final")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegatez = UIApplication.shared.delegate as! AppDelegate
            let managedContextz = appDelegatez.persistentContainer.viewContext
            let resultz = try managedContextz.fetch(requestz)
            
            for data in resultz as! [NSManagedObject] {
                let final = data.value(forKey: "final") as! Double
                finalSum = final
                moreObjects.append(data)
            }
        } catch {
            print("Failed")
        }
    }
    
    func appendNewItem(name: String, price: String) {
        if operationName.text! != "" && operationPrice.text! != "" {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
            /////////////
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ShoppingList", in: managedContext)
            let newGood = NSManagedObject(entity: entity!, insertInto: managedContext)
            newGood.setValue(name, forKey: "listName")
            newGood.setValue(price, forKey: "listMoney")
            do {
                _ = try managedContext.fetch(request) // если это не сделать - таблица не обновится и вылезет аут оф рэндж
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
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

}
