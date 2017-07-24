//
//  ViewController.swift
//  test2
//
//  Created by cys on 2017/7/7.
//  Copyright © 2017年 cys. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    private var uid=""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBAction func toregister(_ sender: Any) {
        self.performSegue(withIdentifier: "toregister", sender: self)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func tohomepage(_ sender: Any) {
        let a = UserDefaults.standard
        a.setValue("", forKey: "userid")
        a.setValue("0", forKey: "islogin")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func login(_ sender: Any) {

        let t1 = self.text1.text
        let t2 = self.text2.text
        post(t1:t1!,t2:t2!)

        let a = UserDefaults.standard
        let b = a.string(forKey: "login")
        let c = a.string(forKey: "userid")!
        print(c)
        let m = "999"
        if b==m{
            let a = UserDefaults.standard
            a.setValue("1", forKey: "islogin")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            uid = a.string(forKey: "userid")!
            save()
        }else{
            print("登录失败")
            
        }
    }
    
    func post(t1:String,t2:String){
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        request.httpMethod = "POST"
        let poststring = "func=1093&zson={phone:\""+t1+"\",upassword:\""+t2+"\"}"
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
                let user = js.object(forKey: "user")
                let user1 = user as AnyObject
                let user2 = user1.object(forKey: "id")
                let user3 = user2 as! String
                print(user3)
                let a = UserDefaults.standard
                a.setValue(user3, forKey: "userid")
                
            }
            print(k)
            let a = UserDefaults.standard
            a.setValue(k, forKey: "login")
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func save(){
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        request.httpMethod = "POST"
        let poststring = "func=1071&zson={uid:\""+uid+"\",sstatus:\"1\"}"
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
              
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

}

