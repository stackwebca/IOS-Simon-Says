//
//  AboutViewController.swift
//  Simon Says
//
//  Created by Steve Masterson on 2020-02-27.
//  Copyright © 2020 com.jrsm.entertainment. All rights reserved.
//

import UIKit
import MessageUI


class AboutViewController: UIViewController {

    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var emailAdd: UITextField!
    @IBOutlet weak var fullName: UITextField!
    
    override func viewDidLoad() {
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backGo(_ sender: Any) {
    performSegue(withIdentifier: "goHome", sender: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["info@jrsm.ca"])
            mail.setMessageBody(message.text ?? "Sent by mistake", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
            print("cannot send mail")
        }

              func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
              switch result.rawValue {
              case MFMailComposeResult.cancelled.rawValue:
                  print("Cancelled")
              case MFMailComposeResult.saved.rawValue:
                  print("Saved")
              case MFMailComposeResult.sent.rawValue:
                  print("Sent")
              case MFMailComposeResult.failed.rawValue:
                  print("Error: \(String(describing: error?.localizedDescription))")
              default:
                  break
              }
              controller.dismiss(animated: true, completion: nil)
          }
    // Dispose of any resources that can be recreated.
    }
    

}
