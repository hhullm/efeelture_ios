//
//  CarViewController.swift
//  test2
//
//  Created by cys on 2017/7/11.
//  Copyright © 2017年 cys. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var car1: UISwitch!
    @IBOutlet weak var car2: UISwitch!
    @IBOutlet weak var car3: UISwitch!

    @IBAction func cargo(_ sender: Any) {
        if(car1.isOn==true){
            car2.isOn=false
            car3.isOn=false
        }
    }
    
    @IBAction func carback(_ sender: Any) {
        if(car2.isOn==true){
            car1.isOn=false
            car3.isOn=false
        }
    }
    
    @IBAction func cartake(_ sender: Any) {
        if(car3.isOn==true){
            car1.isOn=false
            car2.isOn=false
        }
    }
    
    @IBAction func back1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
