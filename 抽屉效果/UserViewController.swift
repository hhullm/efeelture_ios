//
//  ViewController.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/9.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit
class UserViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var hardtitle: UINavigationBar!
    @IBOutlet weak var table1: UITableView!
    private var nsarray:NSArray? = []
    private var i=0
    private var uid = ""
    var refreshControl=Refreshview()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = UserDefaults.standard
        uid = a.string(forKey: "userid")as! String
        // Do any additional setup after loading the view, typically from a nib.
        
        //添加协议！！必须有否则会步伐添加数据和其他一些响应
        table1.dataSource=self
        table1.delegate = self;
    
        //添加刷新
        refreshControl.addTarget(self, action: #selector(UserViewController.refreshData),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        table1.addSubview(refreshControl)
        self.refreshData()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func refreshData() {

        
        //改变table1数据源
        getuserhardlist()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(2)) {
            //更新数据源
            self.table1.reloadData()
            if self.i==0{
                self.hardtitle.topItem?.title="我的设备(无可用设备)"
            }
            else{
                self.hardtitle.topItem?.title="我的设备"
            }
            
            //刷新结束
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    @IBAction func userhardback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getuserhardlist()
        print(self.i)
        return self.i
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)as! TableViewCell
        
        
        //添加数据
        let co = (self.nsarray?[indexPath.row])as! NSDictionary
        cell.hardid.text = (co["id"])as! String
        cell.hardcloudid.text=(co["hardwareid"])as! String
        cell.tyoe.text=(co["uid"])as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let co = (self.nsarray?[indexPath.row])as! NSDictionary
        print((co["id"])as! String)
        tableView.deselectRow(at: indexPath, animated: true)//在之前tableview一直好好的点击之后不会处于选中状态，但之后又一段时间一直会点击后一直灰下去，加上这句应该是改变他的选中状态吧
        
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //设计左划菜单
        let del = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            let co = (self.nsarray?[indexPath.row])as! NSDictionary
            //弹出提示框
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您确定要删除该设备吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                //点击确定后执行
                self.deletehard(hardid: (co["id"])as! String)
                self.refreshData()
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        del.backgroundColor = UIColor.red
        return [del]
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // 要显示自定义的action,cell必须处于编辑状态
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 同时你也需要实现本方法,否则自定义action是不会显示的,啦啦啦
    }
    func deletehard(hardid:String){  //删除并不成功，在网页输入网址进行删除返回了999但却并没有删除成功
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1022&zson=%7bid:%22\(hardid)%22%7d"
        request.httpBody = poststring.data(using: .utf8)
        //设置task发送http请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                return
            }
            //返回200 http请求成功
            if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode == 200{
            
            let responsestring = String(data:data,encoding:.utf8)
            let data1="["+responsestring!+"]"
            let data2=data1.data(using: String.Encoding.utf8)
            //将数据源解析为json类型
            let jsonArr = try! JSONSerialization.jsonObject(with: data2!,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
            for json in jsonArr {
                let code1=(json["resultCode"])as! String
                if code1=="999"{
                    print("删除成功")
                    
                }
            }
            }
            else{
                print("请求错误")
            }
            
        }
        task.resume()
    }
    func getuserhardlist(){//获取设备列表信息
        
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1023&zson=%7buid:\"\(uid)\"%7d"
        request.httpBody = poststring.data(using: .utf8)
        //设置task发送http请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                return
            }
            //返回200 http请求成功
            if let httpStatus = response as? HTTPURLResponse,httpStatus.statusCode == 200{
                
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
                        let code2:NSArray=(json["hardwareList"])as! NSArray
                        self.nsarray=[]
                        self.nsarray=code2
                        self.i=code2.count
                        
                    }
                    else{
                        self.nsarray=[]
                        self.i=0
                    }
                }
            }
            else{
                print("请求错误")
            }
            
        }
        task.resume()
    }
}

