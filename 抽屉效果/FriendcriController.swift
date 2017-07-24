//
//  FriendcriController.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/9.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit
class FriendcriController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var mainview: UIStackView!
    static var tablefriend:UITableView!
    private var nsarray:NSArray? = []
    private var nsarray2:NSArray? = []
    private var nsarray3:NSArray? = []
    static var reply:[NSArray?]=[]
    static var likelist:[NSArray?]=[]
    private var i=1
    var uid:String = ""
    var refreshControl=Refreshview()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let a = UserDefaults.standard
        uid = a.string(forKey: "userid")!
        
        

        //创建表视图
        FriendcriController.tablefriend = UITableView(frame: self.view.frame, style: .plain)
        FriendcriController.tablefriend.dataSource=self
        FriendcriController.tablefriend.delegate = self;
       
        //去除单元格分隔线
        FriendcriController.tablefriend.separatorStyle = .none
        
        //创建一个重用的单元格
        FriendcriController.tablefriend!.register(UINib(nibName:"headTableViewCell", bundle:nil),
                                   forCellReuseIdentifier:"headcell")
        //设置estimatedRowHeight属性默认值
        FriendcriController.tablefriend.estimatedRowHeight = 44.0;

        
    
        
        //添加刷新
        refreshControl.addTarget(self, action: #selector(self.refreshData),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        FriendcriController.tablefriend.addSubview(refreshControl)
        self.mainview.addSubview(FriendcriController.tablefriend!)
        self.refreshData()
        
    }
    
    @IBAction func criback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func refreshData() {
        
        
        //改变table1数据源
        getfriendcri()
        //延时操作
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
            //更新数据源
            FriendcriController.tablefriend.reloadData()
            //刷新结束
            self.refreshControl.endRefreshing()
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.i
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headcell",for: indexPath) as! headTableViewCell
            return cell
        }
        else{
            FriendcriController.tablefriend!.register(UINib(nibName:"criTableViewCell", bundle:nil),
                                                      forCellReuseIdentifier:"cricell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cricell",for: indexPath) as! criTableViewCell
            //添加数据
            let co = (self.nsarray?[indexPath.row-1])as! NSDictionary
            //下面这两个语句一定要添加，否则第一屏显示的collection view尺寸，以及里面的单元格位置会不正确
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            let messageid=(co["id"])as! String
            if (co["uid"])as! String == "" {
                cell.name.text="匿名"
            }else{
                cell.name.text=(co["uid"])as! String
            }
            cell.time.text=(co["mtime"])as! String
            
            //获取该条replylist
            self.nsarray2=[]
            for replylist in FriendcriController.reply{
                let content = replylist!
                let list = (content[0])as! NSDictionary
                if(((co["id"])as! String)==((list["messageid"])as! String)){
                    self.nsarray2=content
                }
            }
            if(self.uid==(co["uid"]as! String)){
                cell.deletemessage.isHidden=false
            }
            else{
                cell.deletemessage.isHidden=true
            }
            cell.deletemessage.accessibilityLabel=messageid
            cell.deletemessage.addTarget(self, action: #selector(deletemessage(_button:)), for: .touchUpInside)
            
            //获取该条的likelist
            self.nsarray3=[]
            for likelist in FriendcriController.likelist{
                let content = likelist!
                let list = (content[0])as! NSDictionary
                if(((co["id"])as! String)==((list["messageid"])as! String)){
                    self.nsarray3=content
                }
            }
            //获取现在用户是否赞过
            var likebool=false
            var likeid=""
            for thislike in nsarray3!{
                let list = thislike as! NSDictionary
                if(self.uid==list["uid"]as! String){
                    likebool=true
                    likeid=list["id"]as! String
                    
                }
            }
            if likebool==true{
                cell.islike.setImage(#imageLiteral(resourceName: "hongxin"), for: .normal)
            }
            else{
                cell.islike.setImage(#imageLiteral(resourceName: "heixin"), for: .normal)
            }
            let likenumber:String?=String(stringInterpolationSegment: nsarray3!.count)
            cell.likenumber.text=likenumber
            cell.reloadData(Uid: self.uid, Secondid: (co["uid"])as! String, Messageid: (co["id"])as! String, Nsarray: self.nsarray2!, Content: (co["content"])as! String, Likebool: likebool, Likeid: likeid, Nsarray2: nsarray3!)
            //            cell.reply.addTarget(self, action: #selector(afterreply), for: .touchUpInside)
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deletemessage(_button:UIButton){
        //弹出提示框
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定要删除吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //点击确定后执行
            //设置请求url
            var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
            //设置请求方式为post
            request.httpMethod = "POST"
            //设置请求体
            let thisid:String=_button.accessibilityLabel!
            let poststring = "func=1056&zson=%7bid:\"\(thisid)\",mstatus:\"0\"%7d"
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
                        //弹出提示框
                        
                        let alertController = UIAlertController(title: "删除成功!",
                                                                message: nil, preferredStyle: .alert)
                        //显示提示框
                        self.present(alertController, animated: true, completion: nil)
                        self.refreshData()
                        //两秒钟后自动消失
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.presentedViewController?.dismiss(animated: false, completion: nil)
                        }
                        
                    }
                    else{//弹出提示框
                        
                        let alertController = UIAlertController(title: "删除失败!",
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
            
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func getfriendcri(){//获取列表信息
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1054&zson=%7b%7d"
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
                    
                    let code2:NSArray=(json["messageList"])as! NSArray
                    self.nsarray=code2
                    self.i=code2.count+1
                    FriendcriController.reply.removeAll()
                    FriendcriController.likelist.removeAll()
                    var j:Int=0
                    while (j < code2.count){
                        let co = (self.nsarray?[j])as! NSDictionary
                        self.getreply(Messageid: (co["id"])as! String)
                        self.likebool(Messageid: (co["id"])as! String)
                        j=j+1
                    }
                    
                }
                
                
                
            }
            
        }
        task.resume()
    }
    
    func getreply(Messageid:String){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1063&zson=%7bmessageid:\"\(Messageid)\"%7d"
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
                    let code2:NSArray=(json["replyList"])as! NSArray
                    FriendcriController.reply.append(code2)
                    
                }
                else{
                }
            }
            
        }
        task.resume()
    }
    func likebool(Messageid:String){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1043&zson=%7bmessageid:\"\(Messageid)\"%7d"
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
                    let code2:NSArray=(json["likeList"])as! NSArray
                    FriendcriController.likelist.append(code2)
                    
                }
                else{
                }
            }
        }
        task.resume()
    }
    
}
