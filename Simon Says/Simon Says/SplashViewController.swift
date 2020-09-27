//
//  SplashViewController.swift
//  Simon Says
//
//  Created by Steve Masterson on 2020-02-27.
//  Copyright © 2020 com.jrsm.entertainment. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class SplashViewController: UIViewController {

    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var gameLogo: UIImageView!
    @IBOutlet weak var gameTitle: UIImageView!
    @IBOutlet weak var adSpace: UIImageView!
    
    override func viewDidLoad() {
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
        UIView.animate(withDuration: 5) {
            self.bg.alpha = 0
            self.gameTitle.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.backgroundColor = UIColor.green
            self.gameLogo.alpha = 1
            self.adSpace.alpha = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
             self.view.backgroundColor = UIColor.red
             }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.view.backgroundColor = UIColor.blue
             self.copyright.alpha = 1
             }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
               self.view.backgroundColor = UIColor.yellow
               }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.bg.alpha = 1
               }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
             self.performSegue(withIdentifier: "homepage", sender: nil)
            }
        }
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
