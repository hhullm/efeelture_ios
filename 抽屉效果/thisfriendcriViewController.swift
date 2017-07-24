//
//  thisfriendcriViewController.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/18.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class thisfriendcriViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{


    @IBOutlet weak var mainview: UIStackView!
    
    var friendcri:UITableView!
    private var nsarray:NSArray? = []
    static var friendid:String="189eace8084b4903"
    private var nsarray2:NSArray? = []
    private var reply:[NSArray?]=[]
    private var i=1
    var uid:String = "189eace8084b4903"
    var refreshControl=Refreshview()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //创建表视图
        self.friendcri = UITableView(frame: self.view.frame, style: .plain)
        self.friendcri.dataSource=self
        self.friendcri.delegate = self;
        
        //去除单元格分隔线
        self.friendcri.separatorStyle = .none
        
        //创建一个重用的单元格
        self.friendcri!.register(UINib(nibName:"headTableViewCell", bundle:nil),
                                   forCellReuseIdentifier:"headcell")
        //设置estimatedRowHeight属性默认值
        self.friendcri.estimatedRowHeight = 44.0;
        //rowHeight属性设置为UITableViewAutomaticDimension
        self.friendcri.rowHeight = UITableViewAutomaticDimension;
        //添加刷新
        refreshControl.addTarget(self, action: #selector(self.refreshData),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        friendcri.addSubview(refreshControl)
        self.mainview.addSubview(friendcri)
        
        
    }

    @IBAction func thisback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshData() {
        
        
        //改变table1数据源
        getfriendcri()
        //延时操作
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
            //更新数据源
            self.friendcri.reloadData()
            //刷新结束
            self.refreshControl.endRefreshing()
            if(self.i==1){
                //弹出提示框
                
                let alertController = UIAlertController(title: "暂无动态!",
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.i
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headcell",for: indexPath) as! headTableViewCell
            return cell
        }
        else{
            self.friendcri!.register(UINib(nibName:"criTableViewCell", bundle:nil),
                                       forCellReuseIdentifier:"cricell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cricell",for: indexPath) as! criTableViewCell
            //添加数据
            let co = (self.nsarray?[indexPath.row-1])as! NSDictionary
            getreply(Messageid: (co["id"])as! String)
            //下面这两个语句一定要添加，否则第一屏显示的collection view尺寸，以及里面的单元格位置会不正确
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.likenumber.text=(co["likenumber"])as! String
            let messageid=(co["id"])as! String
            self.nsarray2=[]
            for replylist in reply{
                let content = replylist!
                let list = (content[0])as! NSDictionary
                if(((co["id"])as! String)==((list["messageid"])as! String)){
                    self.nsarray2=content
                }
            }
            cell.reloadData(Uid: self.uid, Secondid: (co["uid"])as! String, Messageid: (co["id"])as! String, Nsarray: self.nsarray2!, Content: (co["content"])as! String, Likebool: false, Likeid: "", Nsarray2: [])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func getfriendcri(){//获取列表信息
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1054&zson=%7buid:\"\(thisfriendcriViewController.friendid)\"%7d"
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
                    self.reply.removeAll()
                    var j:Int=0
                    while (j < code2.count){
                        let co = (self.nsarray?[j])as! NSDictionary
                        self.getreply(Messageid: (co["id"])as! String)
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
                    self.reply.append(code2)
                    
                }
                else{
                }
            }
            
        }
        task.resume()
    }
    @IBAction func returnlast(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil);
    }
    func addlike(Messageid:String){ //点赞
        
    }

}
