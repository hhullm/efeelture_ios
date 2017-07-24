//
//  friendlistViewController.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/14.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class friendlistViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var friendtableview: UITableView!
    private var nsarray:NSArray? = []
    private var i=0
    private var uid=" "
    var refreshControl=Refreshview()
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = UserDefaults.standard
        uid = a.string(forKey: "userid")!

        // Do any additional setup after loading the view.
        friendtableview.dataSource=self
        friendtableview.delegate=self
        //添加刷新
        refreshControl.addTarget(self, action: #selector(
            self.refreshData),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        friendtableview.addSubview(refreshControl)
        self.refreshData()
    }

    @IBAction func friendlistback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func refreshData() {
        
        
        getfriendlist()
        //延时操作
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
            //更新数据源
            self.friendtableview.reloadData()
            
            //刷新结束
            self.refreshControl.endRefreshing()
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return i
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendlistTableViewCell=friendtableview.dequeueReusableCell(withIdentifier: "friendcell", for: indexPath)as! friendlistTableViewCell
        let co = (self.nsarray?[indexPath.row])as! NSDictionary
        cell.name.text = (co["secondid"])as! String
        cell.phone.text=(co["id"])as! String
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //设计左划菜单，删除和查看动态
        let more = UITableViewRowAction(style: .normal, title: "动态") { action, index in
            let co = (self.nsarray?[indexPath.row])as! NSDictionary
            let friendid = (co["secondid"])as! String
            thisfriendcriViewController.friendid=friendid
            self.performSegue(withIdentifier: "friendmessage", sender: nil)
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            self.deletefriend(number:indexPath.row)
            self.refreshData()
        }
        favorite.backgroundColor = UIColor.red
        return [more, favorite]
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // 要显示自定义的action,cell必须处于编辑状态
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 同时你也需要实现本方法,否则自定义action是不会显示的,啦啦啦
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//点击跳转到聊天界面
        tableView.deselectRow(at: indexPath, animated: true)//在之前tableview一直好好的点击之后不会处于选中状态，但之后又一段时间一直会点击后一直灰下去，加上这句应该是改变他的选中状态吧
    }

    func getfriendlist(){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1014&zson={firstid:\"\(uid)\",fstatus:\"1\"}"
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

                let code2:NSArray=(json["friendList"])as! NSArray
                self.nsarray=code2
                self.i=code2.count
                }else{
                    self.nsarray=[]
                    //弹出提示框
                    
                    let alertController = UIAlertController(title: "没有好友",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //1秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                    
                }
            }
            
        }
        task.resume()
    }
    func deletefriend(number:Int){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        let co = (self.nsarray?[number])as! NSDictionary
        //设置请求体
        let id=(co["id"])as! String
        let poststring = "func=1016&zson={id:\"\(id)\",fstatus:\"0\"}"
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
                    
                    let alertController = UIAlertController(title: "删除成功!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //1秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                    
                }
                else{//弹出提示框
                    
                    let alertController = UIAlertController(title: "删除失败!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //1秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
                
            }
        }
        task.resume()
    }
}
