//
//  settingViewController.swift
//  抽屉效果
//
//  Created by cys on 2017/7/24.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit

class settingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backtoct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backtologin(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
