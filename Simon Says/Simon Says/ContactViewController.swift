//
//  ContactViewController.swift
//  Simon Says
//
//  Created by Steve Masterson on 2020-02-27.
//  Copyright © 2020 com.jrsm.entertainment. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

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

}
