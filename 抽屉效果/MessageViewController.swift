//
//  MessageViewController.swift
//  抽屉效果
//
//  Created by li on 2017/7/8.
//  Copyright © 2017年 li. All rights reserved.
//
import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let a = UserDefaults.standard
//        if a.string(forKey: "islogin") == nil || a.string(forKey: "islogin")! == "0" {
            performSegue(withIdentifier: "login", sender: nil)
//        }else{
//            print("已经登陆过")
//        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 打开左边菜单
    @IBAction func buttonClick(_ sender: Any) {
        
        DrawerViewController.shareDrawer?.openLeftMenu()
    }
    //MARK: - 更多功能
    @IBAction func showAlert(_ sender: UIBarButtonItem) {
        
        let popVC = PopViewController()
        popVC.modalPresentationStyle = UIModalPresentationStyle.popover
        popVC.popoverPresentationController?.barButtonItem = sender
        popVC.popoverPresentationController?.delegate = self
        popVC.popoverPresentationController?.backgroundColor = UIColor.white
        present(popVC, animated: true, completion: nil)
        
    }

}

extension MessageViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
}
