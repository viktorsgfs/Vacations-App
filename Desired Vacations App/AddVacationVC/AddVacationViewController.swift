//
//  AddVacationViewController.swift
//  Desired Vacations App
//
//  Created by Synergy on 24.08.21.
//
import Photos
import UIKit

class AddVacationViewController: UIViewController{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vacationTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var saveData: (() -> ())?
    var strBase64: Data?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.shadowOpacity = 1
        popUpView.layer.shadowOffset = CGSize.zero
        popUpView.layer.shadowColor = UIColor.darkGray.cgColor
        popUpView.layer.cornerRadius = 10
        titleLabel.font = UIFont(name: "Avenir-HeavyOblique", size: 24)
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowOffset = CGSize.zero
        titleLabel.layer.shadowRadius = 5
        cancelButton.layer.backgroundColor = UIColor.red.cgColor
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.blue.cgColor
        saveButton.layer.backgroundColor = UIColor.white.cgColor
        saveButton.layer.cornerRadius = cancelButton.frame.height / 2
        imageView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func save(_ sender: UIButton) {
        
        vacationTextField.rightViewMode = .never
        locationTextField.rightViewMode = .never
        
        guard vacationTextField.text != "" , let textfield = vacationTextField else {
            
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
//            imageView.image = UIImage(named: "warning.png")
//            imageView.contentMode = .scaleAspectFit
//            vacationTextField.rightView = imageView
            
            vacationTextField.layer.borderColor = UIColor.red.cgColor
            vacationTextField.layer.borderWidth = 1
            vacationTextField.layer.cornerRadius = 5
            vacationTextField.placeholder = "Vacation name required"
            
            vacationTextField.rightViewMode = .always
            return
        }
        guard locationTextField.text != "" , let textfield2 = locationTextField else {
            locationTextField.layer.borderColor = UIColor.red.cgColor
            locationTextField.layer.borderWidth = 1
            locationTextField.layer.cornerRadius = 5
            locationTextField.placeholder = "Location is required"
            return
        }
        let newVacation = DesiredVacation(context: self.context)
        newVacation.name = textfield.text
        newVacation.location = textfield2.text
        newVacation.imageBase64 = strBase64
        newVacation.imageName = imageName
        saveData!()
        dismiss(animated: true)
    }
    @IBAction func addPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
            }
        }
    }

extension AddVacationViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            if let asset = info[.phAsset] as? PHAsset, let fileName = asset.value(forKey: "filename") as? String {
                imageName = fileName
              } else if let url = info[.imageURL] as? URL {
                imageName = url.lastPathComponent
              }
            
            strBase64 = image.jpegData(compressionQuality: 0.5)
//            let dataDecoded : Data = Data(base64Encoded: strBase64 ?? "", options: .ignoreUnknownCharacters)!
//            let decodedimage = UIImage(data: dataDecoded)
            
            self.imageView.image = UIImage(data: strBase64! as Data)
            
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
