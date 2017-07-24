//
//  Hardwarelist.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/9.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit
class Hardwarelist: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    private var nsarray:NSArray? = []
    private var i=0
    private var uid=" "
    var refreshControl=Refreshview()
    @IBOutlet weak var hardwarelisttable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gethardlist()
        let a = UserDefaults.standard
        uid = a.string(forKey: "userid")as! String
        // Do any additional setup after loading the view.
        hardwarelisttable.dataSource=self
        hardwarelisttable.delegate=self
        //添加刷新
        refreshControl.addTarget(self, action: #selector(self.refreshData),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        hardwarelisttable.addSubview(refreshControl)
        self.refreshData()
    }
    @IBAction func hardback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func refreshData() {
        
        
        gethardlist()
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(2)) {
 
            //更新数据源
            self.hardwarelisttable.reloadData()
            //刷新结束
            self.refreshControl.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return i
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Hardlist", for: indexPath)as!Hardlisttableviewcell
 
        
        //添加数据
        let co = (self.nsarray?[indexPath.row])as! NSDictionary
        cell.hard_id.text = (co["id"])as! String
        cell.hard_name.text=(co["uname"])as! String
        cell.hard_type.text=(co["ipaddress"])as! String
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)//在之前tableview一直好好的点击之后不会处于选中状态，但之后又一段时间一直会点击后一直灰下去，加上这句应该是改变他的选中状态吧
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //设计左划菜单
        let add = UITableViewRowAction(style: .normal, title: "添加") { action, index in
            let co = (self.nsarray?[indexPath.row])as! NSDictionary
            //弹出提示框
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您确定要添加该设备吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                //点击确定后执行
                self.addhard(hardid: (co["id"])as! String)
                self.refreshData()
                
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        add.backgroundColor = UIColor.blue
        return [add]
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // 要显示自定义的action,cell必须处于编辑状态
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 同时你也需要实现本方法,否则自定义action是不会显示的,啦啦啦
    }
    func addhard(hardid:String){  //添加设备
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1021&zson=%7buid:%22\(self.uid)%22,hardwareid:%22\(hardid)%22%7d"
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
                    
                    let alertController = UIAlertController(title: "添加成功!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                    
                }
                else{//弹出提示框
                    
                    let alertController = UIAlertController(title: "添加失败!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
                
            }
            
        }
        task.resume()
    }
    func gethardlist(){//获取设备列表信息
        
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1099&zson=%7butype:%220%22%7d"
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
                    
                }
                let code2:NSArray=(json["userList"])as! NSArray
                self.nsarray=code2
                self.i=code2.count
            }
            
        }
        task.resume()
    }

}
