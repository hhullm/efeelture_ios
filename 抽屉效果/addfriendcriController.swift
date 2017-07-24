//
//  addfriendcriController.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/10.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit
class addfriendcriController: UIViewController {

    private var uid="189eace8084b4903"
    public static var content:String=""
    @IBOutlet weak var contentlabel: UITextField!
    @IBOutlet weak var contentfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        contentfield.text=addfriendcriController.content
        // Do any additional setup after loading the view.
    }
    @IBAction func addcontent(_ sender: Any) {
        addfriendcri(content: self.contentlabel.text!)
        addfriendcriController.content=""
        //结束当前页面
        self.presentingViewController?.dismiss(animated: true, completion: nil);
    }
    @IBAction func addback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        addfriendcriController.content=self.contentlabel.text!
        self.presentingViewController?.dismiss(animated: true, completion: nil);

    }

    func addfriendcri(content:String){
        //没有一下三步会导致上传的content乱码或者是无法由于内容有字符导致访问失败
        let con=content.data(using: String.Encoding.utf8)//转化为utf-8编码
        let dogString=content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)//解析dagstring（data）
        let contentfinal=(dogString)as! String//转化为String
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1051&zson=%7buid:%22\(uid)%22,content:%22\(contentfinal)%22,mtype:%221%22%7d"
        request.httpBody = poststring.data(using: .utf8)
        //设置task发送http请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                return
            }
            //返回200 http请求成功
            if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode != 200{
            }
            let responsestring = String(data:data,encoding:.utf8)
            let data1="["+responsestring!+"]"
            let data2=data1.data(using: String.Encoding.utf8)
            //将数据源解析为json类型
            let jsonArr = try! JSONSerialization.jsonObject(with: data2!,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
            for json in jsonArr {
                let code1=(json["resultCode"])as! String
                if code1=="999"{
                    print("连接成功")
                    //弹出提示框
                    
                    let alertController = UIAlertController(title: "发表成功!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                    
                }
                else{//弹出提示框
                    
                    let alertController = UIAlertController(title: "发表失败!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
                
            }
            
        }
        task.resume()
    }

}
