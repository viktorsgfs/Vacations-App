//
//  AddReminderViewController.swift
//  Desired Vacations App
//
//  Created by Synergy on 27.08.21.
//

import UIKit

class AddReminderViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var bodyTextfield: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var reloadData: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let newReminder = Reminder(context: self.context)
        newReminder.title = titleTextfield.text
        newReminder.body = bodyTextfield.text
        newReminder.date = datePicker.date
        do {
            try self.context.save()
        }
        catch {
            print("coudnt fetch")
        }
        self.reloadData!()
        let content = UNMutableNotificationContent()
        content.title = newReminder.title!
        content.sound = .default
        content.body = newReminder.body!
        let targetDate = newReminder.date!
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Something went wrong")
            }
        })
        // close
        dismiss(animated: true)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
