//
//  SplashVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let mySceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        mySceneDelegate.window?.rootViewController = navigationController
        mySceneDelegate.window?.makeKeyAndVisible()
    }


}
