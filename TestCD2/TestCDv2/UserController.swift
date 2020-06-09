//
//  ViewController.swift
//  TestCDv2
//
//  Created by Zlatan Haljeta on 02/06/2020.
//  Copyright © 2020 Zlatan Haljeta. All rights reserved.
//

import UIKit
import CoreData

class UserController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
   
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var passwordSP: UITextField!
    
    
    @IBOutlet var welcomeMessage: UILabel!
    
    var users: [NSManagedObject] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
      
        userName?.delegate = self;
        password?.delegate = self;
        
        fullName?.delegate = self;
        email?.delegate = self;
        passwordSP?.delegate = self;
        
        
    }
    
    func checkUser(email: String, password: String, users: [NSManagedObject])-> Bool{
        //cheking authentication (need to upgrade)
        for u in users {
            if u.value(forKey: "email") as! String == email &&
                password == u.value(forKey: "password") as!String
            {
                return true
            }
        }
        return false
    }
    
    func getUsers()  {
        //getting all users
       guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else{
            return;
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do{
            users = try managedContext.fetch(fetchRequest)
            
        }catch let error as NSError{
            print("Could not fetch.")
        }
    }

    func checkInputInSingIn(email: String, password: String) -> Bool{
        if email == "" || password == "" {
            return false;
        }
        return true;
    }
    @IBAction func SING_IN(_ sender: Any) {
         //the name says it all
       
        getUsers();
        
        if checkInputInSingIn(email: email.text!, password: password.text!) == false {
            let login = storyboard?.instantiateViewController(identifier: "LoginSB");
            present(showPopUp(check: "emptySignIn"), animated: true, completion: nil);
            present(login!, animated: false, completion: nil);
        }
        
        if checkUser(email: email.text!, password: password.text!, users: users) {
            print("Welcome message!");
        }
        else{
            
            let login = storyboard?.instantiateViewController(identifier: "LoginSB");
            present(showPopUp(check: "signIN"), animated: true, completion: nil);
            present(login!, animated: false, completion: nil);
            
        }
    }
    
    
    
    func showPopUp(check: String) -> UIAlertController{
        
        // showing varius options of pop-ups, upgradeable
        
        var alertController: UIAlertController;
        let okAction = UIAlertAction(title: "OK", style: .default)
        if check == "signIN" {
             alertController = UIAlertController(title: "", message:"The email and password doesn't match any account. Please, try again.", preferredStyle: .alert)
             alertController.addAction(okAction)
            return alertController;
        }
        else if check == "signUP"{
             alertController = UIAlertController(title: "", message:"Email already in use. Please, try with a different one.", preferredStyle: .alert)
          alertController.addAction(okAction)
            return alertController;
        }
        else if check == "emptySignIn" {
            alertController = UIAlertController(title: "", message:"Fill the text boxes with your Login creditentials.", preferredStyle: .actionSheet)
            alertController.addAction(okAction)
            return alertController;
        }
        else if check == "emptySignUp"{
            alertController = UIAlertController(title: "", message:"All the text boxes are required to be filled with your future creditentials.", preferredStyle: .actionSheet)
            alertController.addAction(okAction)
            return alertController;
        }
        
        
        alertController = UIAlertController(title: "", message:"", preferredStyle: .alert)
        return alertController;
        
       
    }
    
    func checkEmail(email: String) -> Bool{
        //checking if email is already in use after sing up
        getUsers()
        for u in users {
            if u.value(forKey: "email") as! String == email{
                return true;
            }
        }
        return false;
    }
    
    func checkInputSignUp(fullName: String, email: String, password: String) -> Bool {
        if fullName == "" || email == "" || password == "" {
            return false;
        }
        return true;
    }
    @IBAction func SING_UP(_ sender: Any) {
        
        // says it all
        if checkInputSignUp(fullName: fullName.text!, email: email.text!, password: passwordSP.text!) == false{
            let signUP = storyboard?.instantiateViewController(identifier: "signUP");
            present(showPopUp(check: "emptySignUp"), animated: true, completion: nil);
            present(signUP!, animated: false, completion: nil);
        }
        
        if checkEmail(email: email.text!){
        
            let signUP = storyboard?.instantiateViewController(identifier: "signUP");
            present(showPopUp(check: "signUP"), animated: true, completion: nil);
            present(signUP!, animated: false, completion: nil);
            
        }
        else{
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                    return
                  }
            let managedContext = appDelegate.persistentContainer.viewContext;
                  
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                  
            let user = NSManagedObject(entity: entity, insertInto: managedContext)
                  
            
            user.setValue(fullName.text!, forKeyPath:"fullName")
            user.setValue(email.text!, forKeyPath:"email")
            user.setValue(passwordSP.text!, forKeyPath:"password")
                  
            do{
                try managedContext.save()
                users.append(user)
            }
            catch {
                    print("Could not save" ) // add error message
            }
        }
    }
    
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.endEditing(true); //dissmises the keyboard after pressing GO
         return true;
         //this method saves the input text after the user pressess the
        //Go button on keyboard
    }

//     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != ""{
//             return true;
//        }
//         else{
//
//
//             return false;
//         }
//         //prevents the user to search without typing a country
//     }
    
    
    
}

