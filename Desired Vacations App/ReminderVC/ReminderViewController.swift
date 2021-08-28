//
//  ReminderViewController.swift
//  Desired Vacations App
//
//  Created by Synergy on 27.08.21.
//
import UserNotifications
import UIKit

class ReminderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var destination: DesiredVacation?
    var currentReminders = [Reminder]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var segueIdToAddReminder = "addReminderSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchReminders()
    }
    
    func fetchReminders() {
        do {
            self.currentReminders = try context.fetch(Reminder.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        catch {
            
        }
    }
    

    @IBAction func tappedTest(_ sender: UIButton) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                self.scheduleTest()
            }
            else if error != nil {
                print("error occured")
            }
        })
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello there"
        content.sound = .default
        content.body = "long long body."
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Something went wrong")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToAddReminder {
            
            let vc = segue.destination as? AddReminderViewController
            vc?.title = "New Reminder"
            let reload = {
                self.fetchReminders()
            }
            vc?.reloadData = reload
        }
        
    }
    
    @IBAction func addReminderTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segueIdToAddReminder, sender: self)
        
        
        guard let vc = storyboard?.instantiateViewController(identifier: "addReminderSegueIdentifier") as? AddReminderViewController else {
            return
        }
        vc.title = "New reminder"
    }
    
}

extension ReminderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentReminders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForReminder",for: indexPath)
        let date = currentReminders[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY at hh:mm a"
        cell.textLabel?.text = currentReminders[indexPath.row].title
        cell.detailTextLabel?.text = formatter.string(from: date!)
        
        return cell
    }
}
