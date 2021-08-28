//
//  VacationsViewController.swift
//  Desired Vacations App
//
//  Created by Synergy on 23.08.21.
//

import UIKit

class VacationsViewController: UIViewController {
    
    struct Constants {
        static let vacationCellIdentifier = "cell"
        static let vacationDetailsSegueIdentifier = "vacationDetailsSegueIdentifier"
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [DesiredVacation]()
    var vacationToRemove: DesiredVacation?
    var selectedVacation: DesiredVacation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Desired vacations"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        addButton.backgroundColor = .green
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
       
        
        fetchVacations()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVacationSegue" {
            
            let popup = segue.destination as! AddVacationViewController
            
            let popupSave = {
                self.addVacation()
            }
            popup.saveData = popupSave
        }
        if segue.identifier == "vacationDetailsSegueIdentifier" {
             let vc = segue.destination as? VacationDetailsListViewController
            let popupSave = {
                self.fetchVacations()
            }
            
            vc?.vacation = selectedVacation
            vc?.saveData = popupSave
            vc?.money = String(selectedVacation?.necessary_money ?? 0)
            //vc?.saveData = popupSave
            
            
        }
    }
    func fetchVacations(){
        do {
            self.items = try context.fetch(DesiredVacation.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        catch {
            
        }
    }
    
    func addVacation(){
        
        do {
            try self.context.save()
        }
        catch {
            print("coudnt fetch")
        }
        self.fetchVacations()
    }

}


extension VacationsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.vacationCellIdentifier, for: indexPath) as! VacationsTableViewCell
        
        let vacation = self.items[indexPath.row]
        
        if let imageBase64 = vacation.imageBase64 {
            cell.vacationImageView.image = UIImage(data: imageBase64)
        }
        cell.titleLabel?.text = vacation.name ?? "neshto"
       
        cell.locationLabel?.text = vacation.location ?? "nqma lok"
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            

            self.vacationToRemove = self.items[indexPath.row]
           
            self.context.delete(self.vacationToRemove!)
                
                do {
                    try self.context.save()
                }
                catch {
                    
                }
            self.fetchVacations()
        }
            return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(items)
        
         selectedVacation = self.items[indexPath.row]
        performSegue(withIdentifier: Constants.vacationDetailsSegueIdentifier, sender: self)
    }
}
