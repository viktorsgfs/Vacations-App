//
//  VacationDetailsListViewController.swift
//  Desired Vacations App
//
//  Created by Synergy on 25.08.21.
//
import Photos
import UIKit

class VacationDetailsListViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    struct Constants {
        static let vacationCellIdentifier = "cell"
        static let remindersSegueIdentifier = "remindersSegue"
    }
    
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyButton: UIButton!
    
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var subtitileLabel: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var moneyAmount: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hotelLabel: UILabel!
    
    @IBOutlet weak var changeImageButton: UIButton!
    
    var vacation: DesiredVacation? = nil
    var saveData: (() -> ())?
    var money: String?
    var imageName: String?
    var strBase64: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        moneyAmount.text = ("\(money!) $")
        
        css(image: UIImage(named: "money")!, button: moneyButton)
        css(image: UIImage(named: "Edit")!, button: titleButton)
        css(image: UIImage(named: "Edit-2")!, button: descriptionButton)
        css(image: UIImage(named: "hotel")!, button: hotelButton)
        css(image: UIImage(named: "location")!, button: locationButton)
        
        buttonCSS(button: changeImageButton, color: UIColor.green, bgcolor: UIColor.white)
        
        titleDicider(label: moneyAmount, target: "money")
        titleDicider(label: subtitileLabel, target: "subtitle")
        titleDicider(label: hotelLabel, target: "hotel")
        
        titleLabel.text = vacation?.name
        locationText.text = vacation?.location
        
        if let imageBase64 = vacation?.imageBase64 {
            // moje da se iznese v suzdavaneto na vacationa
            photoView.image = UIImage(data: imageBase64)
        } else {
            photoView.image = UIImage(named: "defBeachImage")
        }
        
    }
    
    func titleDicider (label: UILabel, target: String){
        switch target {
        case "money":
            money != "0" ? moneyButton.setTitle("Edit money", for: .normal) : moneyButton.setTitle("Add money", for: .normal)
        case "subtitle":
            subtitileLabel.text = vacation?.descript
            vacation?.descript != nil ? descriptionButton.setTitle("Edit description", for: .normal) : descriptionButton.setTitle("Add description", for: .normal)
        case "hotel":
            hotelLabel.text = vacation?.hotel_name
            vacation?.hotel_name != nil ? hotelButton.setTitle("Change hotel", for: .normal) : hotelButton.setTitle("Add hotel", for: .normal)
        default:
            break
        }
    }
    func css(image: UIImage,button: UIButton) {
        let icon = image
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
    }
    
    func buttonCSS(button: UIButton, color: UIColor , bgcolor: UIColor) {
        button.layer.backgroundColor = bgcolor.cgColor
        button.setTitleColor(color, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "remindersSegue" {
            
            let vc = segue.destination as? ReminderViewController
            vc?.destination = vacation
            //vc?.context = context
        }
        
    }
    func alertFunc(titleText: String, confirmTitle: String, label: UILabel, target: String , placeholderText: String){
        let alertController = UIAlertController(title: titleText, message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (_) in
                    if let txtField = alertController.textFields?.first, let text = txtField.text {
                        
                        label.text = text
                        
                        switch target{
                        case "Edit":
                            self.vacation?.name = text
                        case "descript":
                            self.vacation?.descript = text
                        case "money":
                            self.money = text
                            self.moneyAmount.text = ("\(self.money!) $")
                            self.vacation?.necessary_money = Int64(self.money!)!
                        case "hotel":
                            self.vacation?.hotel_name = text
                        case "location":
                            self.vacation?.location = text
                        default:
                            break
                        }
                        
                        do {
                            try self.context.save()
                        }
                        catch {
                            print("coudnt fetch")
                        }
                        self.saveData!()
                        
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = placeholderText
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
    }
// Add money amount
    @IBAction func addMoney(_ sender: Any) {
        
        alertFunc(titleText: "Add the necessary amount of money for your trip", confirmTitle: "Add", label: moneyAmount, target: "money", placeholderText: "Enter amount")
    }
    
    // Edit title
    @IBAction func titleEditAction(_ sender: UIButton) {
        
        alertFunc(titleText: "Add the new title", confirmTitle: "Add", label: titleLabel, target: "Edit", placeholderText: "Enter title")
        
    }
    // Edit description
    @IBAction func editDescription(_ sender: UIButton) {
        
        alertFunc(titleText: "Add description", confirmTitle: "Add", label: subtitileLabel, target: "descript", placeholderText: "add description")

    }
    // Edit hotel
    @IBAction func editHotelAction(_ sender: UIButton) {
        alertFunc(titleText: "Add hotel name", confirmTitle: "Add", label: hotelLabel, target: "hotel", placeholderText: "Enter name")
    }
    // Edit location
    @IBAction func changeLocation(_ sender: UIButton) {
        alertFunc(titleText: "Change the location of your destination", confirmTitle: "Change", label: locationLabel, target: "location", placeholderText: "Type the new location")
    }
    
    @IBAction func goToReminders(_ sender: UIButton) {
        
        performSegue(withIdentifier: Constants.remindersSegueIdentifier, sender: self)
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
            }
        
    }
}
extension VacationDetailsListViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            if let asset = info[.phAsset] as? PHAsset, let fileName = asset.value(forKey: "filename") as? String {
                imageName = fileName
              } else if let url = info[.imageURL] as? URL {
                imageName = url.lastPathComponent
              }
            
            strBase64 = image.jpegData(compressionQuality: 0.5)
            self.photoView.image = UIImage(data: strBase64! as Data)
            vacation?.imageBase64 = strBase64
            self.saveData!()
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
