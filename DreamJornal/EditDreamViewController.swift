//
//  EditDreamViewController.swift
//  DreamJornal
//
//  Created by Adriana Pedroza Larsson on 2019-04-14.
//  Copyright © 2019 Adriana Pedroza Larsson. All rights reserved.
//

import UIKit
import CoreData


class EditDreamViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var titleEditTextField: UITextField!

    
    @IBOutlet weak var editTextViewDream: UITextView!
    
    @IBOutlet weak var imageEdit: UIImageView!
    
  var changingData:NSManagedObject!
    var lastSavedLocation:String?
    
      var newDiary = DreamDiaryCoreData()
    var new: DreamDiaryCoreData? = nil
    
    var dreamArray: [DreamDiaryCoreData] = []

       var i = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    
        
        
        
        titleEditTextField.delegate = self
        editTextViewDream.delegate = self
        
        
        //change the data to update and show the saved data
        
        if changingData != nil{
            
            titleEditTextField.text = changingData.value(forKey: "title") as? String
            editTextViewDream.text = (changingData.value(forKey: "editText") as! String)
             lastSavedLocation = changingData.value(forKey: "address") as? String
            
            // retrieving image data from data base and setting to background image
            imageEdit.image = UIImage(data: changingData.value(forKey: "thumb") as? Data ?? Data())
            
            
            
            //            if let img = newDiary.image {
            //                self.editImage.image = UIImage(data: img as Data)
            //            }
      //
     
        }
    
     
    
       
    
    }
    
  
    // when i press outside oft the texview, the keyborad goes away and when i press the return, when i write in textfiled, the keybord goes away
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        self.editTextViewDream.resignFirstResponder()
        
    }

    
 
    
    //adds and save a new edit cell with text title, text and picture
    
    func addSave(){
        
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let newDiary = DreamDiaryCoreData(context: appDelegate.persistentContainer.viewContext)
            
            newDiary.title = titleEditTextField.text ?? ""
            newDiary.editText = editTextViewDream.text ?? ""
            
            
            if lastSavedLocation != nil {
                newDiary.address = lastSavedLocation
            }
            
            if let image = imageEdit.image, let jpegData = image.jpegData(compressionQuality: 0.8)  {
                newDiary.images = jpegData
                newDiary.thumb = jpegData
                
            }
            
//            if let image = imageEdit.image, let jpegData = image.jpegData(compressionQuality: 0.8)  {
//                newDiary.images = jpegData
//
//
//            }
//            if let image = imageEdit.image {
//                UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
//                let ratio = image.size.width/image.size.height
//                let scaleWidth = ratio*100
//                let offsetX = (scaleWidth-100)/2
//            image.draw(in: CGRect(x: -offsetX, y: 0, width: scaleWidth, height: 80))
//                let thumb = UIGraphicsGetImageFromCurrentImageContext()
//                //UIGraphicsEndImageContext()
//
//                if let thumb = thumb, let jpegData = thumb.jpegData(compressionQuality: 0.8) {
//                    newDiary.thumb = jpegData
//
//                    dismiss(animated: true, completion: nil)
//                    navigationController?.popViewController(animated: true)
//                }
//            }
//
            
            appDelegate.saveContext()
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    

    
    
    // picks code from updatechange and addchange, tis is the save button
    
    @IBAction func saveData(_ sender: UIButton) {
        

     if changingData != nil{


        updateSave()
        
         navigationController?.popViewController(animated: true)

        }else{
        addSave()
        

        navigationController?.popViewController(animated: true)

        }





    }

    

    

            

    
// can take new picture and load upp new picture
    
    @IBAction func newPicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if sender.tag == 1 {
            
            imagePicker.sourceType = .camera
            
        }
        else if sender.tag == 2 {
            
            imagePicker.sourceType = .photoLibrary
            
        }
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageEdit.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        dismiss(animated:true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    //update and save in editviewontroller
    func updateSave(){
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            //                    changingData.title = titleEditTextField.text
            changingData.setValue(titleEditTextField.text, forKey: "title")
            changingData.setValue(editTextViewDream.text, forKey: "editText")
            
                //let dreamImg = newDiary.images
                
           // imageEdit.image = UIImage(data: (dreamImg as? Data)!)
                
            
           
           // if let img = newDiary.images {
             //                  self.imageEdit.image = UIImage(data: img as Data)
               //            }
            //changingData.setValue(imageEdit, forKey: "images")
            
            
            if let image = imageEdit.image, let jpegData = image.jpegData(compressionQuality: 0.8)  {
                //newDiary.images = jpegData
                changingData.setValue(jpegData, forKey: "thumb")
                changingData.setValue(jpegData, forKey: "images")
                
                }
            changingData.setValue(lastSavedLocation, forKey: "address")
            
            appDelegate.saveContext()
          
        
        
        
    }
    
    
    

    
        
}
    //refers to id storyborad name, MapDreamViewController
    // make a string varibel to address so you can save the address to the string varibel lastsavedlocation
    
    @IBAction func openMap(_ sender: Any) {
        let viewC = self.storyboard?.instantiateViewController(withIdentifier: "MapDreamViewController") as? MapDreamViewController
        if lastSavedLocation != nil{
            viewC!.lastSaveLocation = self.lastSavedLocation
        }
        viewC?.delegate = self
        self.navigationController?.pushViewController(viewC!, animated: true)
    }
    
    
}

// confirming location delegate
extension EditDreamViewController:LocationSelectedDelegate {
    func selectedLocation(address: String) {
        self.lastSavedLocation = address
    }
   
    
}



            
            
            
            


        


