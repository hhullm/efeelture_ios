//
//  RegisterViewController.swift
//  test2
//
//  Created by cys on 2017/7/10.
//  Copyright © 2017年 cys. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

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


    @IBOutlet weak var register_phone: UITextField!
    @IBOutlet weak var register_uname: UITextField!
    @IBOutlet weak var register_upassword: UITextField!
    @IBAction func registerback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        let phone = self.register_phone.text
        let uname = self.register_uname.text
        let upassword = self.register_upassword.text
        postregister(phone: phone!, uname: uname!, upassword: upassword!)
        let a = UserDefaults.standard
        let b = a.string(forKey: "register")
        let m = "999"
        if b==m{
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }else{
            
        }
        
    }
    
    func postregister(phone:String,uname:String,upassword:String){
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        request.httpMethod = "POST"
        let poststring = "func=1096&zson={phone:\""+phone+"\",upassword:\""+upassword+"\",uname:\""+uname+"\"}"
        request.httpBody = poststring.data(using: .utf8)
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                return
            }
            if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200{
            }
            let responsestring = String(data:data,encoding:.utf8)
            print("responseString = \(responsestring)")
            let cys:Data = (responsestring?.data(using: String.Encoding.utf8))!
            let js:AnyObject! = try? JSONSerialization.jsonObject(with: cys, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            let id = js.object(forKey: "resultCode")
            let k = id as! String
            print(k)
            let a = UserDefaults.standard
            a.setValue(k, forKey: "register")
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
}
