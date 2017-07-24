//
//  WindViewController.swift
//  test2
//
//  Created by cys on 2017/7/11.
//  Copyright © 2017年 cys. All rights reserved.
//

import UIKit

class WindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        wind1_1.isOn=false
//        wind1_2.isOn=false
//        wind1_3.isOn=false
//        wind2_1.isOn=false
//        wind2_2.isOn=false
//        wind2_3.isOn=false
//        wind3_1.isOn=false
//        wind3_2.isOn=false
//        wind3_3.isOn=false
//        wind4_1.isOn=false
//        wind4_2.isOn=false
//        wind4_3.isOn=false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var wind1: UIView!
    @IBOutlet weak var wind2: UIView!
    @IBOutlet weak var wind3: UIView!
    @IBOutlet weak var wind4: UIView!
    
    @IBAction func change(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            wind1.isHidden = false
            wind2.isHidden = true
            wind3.isHidden = true
            wind4.isHidden = true
        case 1:
            wind1.isHidden = true
            wind2.isHidden = false
            wind3.isHidden = true
            wind4.isHidden = true
        case 2:
            wind1.isHidden = true
            wind2.isHidden = true
            wind3.isHidden = false
            wind4.isHidden = true
        case 3:
            wind1.isHidden = true
            wind2.isHidden = true
            wind3.isHidden = true
            wind4.isHidden = false
        default:
            break
        }
    }

    @IBOutlet weak var wind1_1: UISwitch!
    @IBOutlet weak var wind1_2: UISwitch!
    @IBOutlet weak var wind1_3: UISwitch!
    @IBOutlet weak var wind2_1: UISwitch!
    @IBOutlet weak var wind2_2: UISwitch!
    @IBOutlet weak var wind2_3: UISwitch!
    @IBOutlet weak var wind3_1: UISwitch!
    @IBOutlet weak var wind3_2: UISwitch!
    @IBOutlet weak var wind3_3: UISwitch!
    @IBOutlet weak var wind4_1: UISwitch!
    @IBOutlet weak var wind4_2: UISwitch!
    @IBOutlet weak var wind4_3: UISwitch!
    @IBAction func wind11(_ sender: Any) {
        if(wind1_1.isOn==true){
            wind1_2.isOn=false
            wind1_3.isOn=false
        }
    }
    
    @IBAction func wind12(_ sender: Any) {
        if(wind1_2.isOn==true){
            wind1_1.isOn=false
            wind1_3.isOn=false
        }
    }
    
    @IBAction func wind13(_ sender: Any) {
        if(wind1_3.isOn==true){
            wind1_2.isOn=false
            wind1_1.isOn=false
        }
    }
    
    @IBAction func wind21(_ sender: Any) {
        if(wind2_1.isOn==true){
            wind2_2.isOn=false
            wind2_3.isOn=false
        }
    }
    
    @IBAction func wind22(_ sender: Any) {
        if(wind2_2.isOn==true){
            wind2_1.isOn=false
            wind2_3.isOn=false
        }
    }
    
    @IBAction func wind23(_ sender: Any) {
        if(wind2_3.isOn==true){
            wind2_2.isOn=false
            wind2_1.isOn=false
        }
    }
    
    @IBAction func wind31(_ sender: Any) {
        if(wind3_1.isOn==true){
            wind3_2.isOn=false
            wind3_3.isOn=false
        }
    }
    
    @IBAction func wind32(_ sender: Any) {
        if(wind3_2.isOn==true){
            wind3_1.isOn=false
            wind3_3.isOn=false
        }
    }
    
    @IBAction func wind33(_ sender: Any) {
        if(wind3_3.isOn==true){
            wind3_2.isOn=false
            wind3_1.isOn=false
        }
    }
    
    @IBAction func wind41(_ sender: Any) {
        if(wind4_1.isOn==true){
            wind4_2.isOn=false
            wind4_3.isOn=false
        }
    }
    
    @IBAction func wind42(_ sender: Any) {
        if(wind4_2.isOn==true){
            wind4_1.isOn=false
            wind4_3.isOn=false
        }
    }
    
    @IBAction func wind43(_ sender: Any) {
        if(wind4_3.isOn==true){
            wind4_2.isOn=false
            wind4_1.isOn=false
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

}
