//
//  SignInViewController.swift
//  SpeechRecognitionServerExample
//
//  Created by Guo Xiaoyu on 9/21/16.
//
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    @IBOutlet var uniqueCodeTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    var rootRef : FIRDatabaseReference!
    var uniqueCode = "dummy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rootRef = FIRDatabase.database().reference(fromURL: "https://speechtolatex.firebaseio.com/")
        let email = "test@gmail.com"
        let password = "gmailhello"
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showAlert(title: "Failed Sign In", message: "Try Again")
                return
            }
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        uniqueCode = uniqueCodeTextField.text! == "" ? "dummy" : uniqueCodeTextField.text!
        rootRef.child("users/").child(uniqueCode).observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            
            if !snapshot.exists() {
                self.showAlert(title: "Wrong Code", message: "Please Try Agan")
                return
            }
            
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "speechVC"))! as UIViewController
            let userDefault = UserDefaults.standard
            userDefault.set(self.uniqueCode, forKey: "uniqueCode")
            self.present(vc, animated: true, completion: nil)
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
