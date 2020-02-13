//
//  ViewController.swift
//  DateTblCoreDataLocalNotifications
//
//  Created by apple on 2/13/20.
//  Copyright © 2020 Terasoftware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var items: [NSManagedObject] = []
    @IBOutlet weak var tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tbl.delegate = self
        tbl.dataSource = self
        
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(adding))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .orange
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedcontext = appdelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            items = try managedcontext.fetch(fetchrequest)
        }
        catch let err as NSError{
            print("Please to fetch items",err)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
       // cell.textLabel?.text = item
        cell.textLabel?.text = item.value(forKeyPath: "itemName") as! String
        return cell
    }
    @objc func adding (_ sender : Any)
    {
        let alertcontrol = UIAlertController(title: "Adding", message: "Please fill the textfield.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textfield = alertcontrol.textFields?.first,
                let itemtoAdd = textfield.text else { return }
            self.save(itemtoAdd)
            self.tbl.reloadData()
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertcontrol.addTextField(configurationHandler: nil)
            alertcontrol.addAction(saveAction)
            alertcontrol.addAction(cancel)
            present(alertcontrol, animated: true, completion: nil)
            
        }
    func save(_ itemName: String){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
                
            }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext) else { return }
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(itemName, forKey: "itemName")
        do {
            try managedContext.save()
            items.append(item)
        }
        catch let err as NSError {
            print("Failed to save an item",err)
        
        }
    }

}

