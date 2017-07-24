//
//  newpwViewController.swift
//  抽屉效果
//
//  Created by cys on 2017/7/24.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit

class newpwViewController: UIViewController {
    private var uid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = UserDefaults.standard
        uid = a.string(forKey: "userid")!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var oldpw: UITextField!
    @IBOutlet weak var newpw: UITextField!
    
    @IBAction func replacepw(_ sender: Any) {
        let t1=self.oldpw.text
        let t2=self.newpw.text
        post(t1:t1!,t2:t2!)
        let a = UserDefaults.standard
        let b = a.string(forKey: "recode")
        let c = "999"
        if(b==c){
            let sb = UIStoryboard(name:"Main",bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "loginpage")as! LoginViewController
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    @IBAction func backtoset(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func post(t1:String,t2:String){
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        request.httpMethod = "POST"
        let poststring = "func=1094&zson={id:\""+uid+"\",upassword:\""+t1+"\",newpassword:\""+t2+"\"}"
        request.httpBody = poststring.data(using: .utf8)
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                return
            }
            if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200{
            }
            let responsestring = String(data:data,encoding:.utf8)
            let cys:Data = (responsestring?.data(using: String.Encoding.utf8))!
            let js:AnyObject! = try? JSONSerialization.jsonObject(with: cys, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            let id = js.object(forKey: "resultCode")
            let k = id as! String
            if(k=="999"){
                let a = UserDefaults.standard
                a.set(k, forKey: "recode")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
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
