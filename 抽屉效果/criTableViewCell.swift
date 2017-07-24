//
//  criTableViewCell.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/16.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class criTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replyheight: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var replycontent: UITextField!
    @IBOutlet weak var replylist: UITableView!
    @IBOutlet weak var likenumber: UILabel!
    @IBOutlet weak var deletemessage: UIButton!
    @IBOutlet weak var islike: UIButton!
    @IBOutlet weak var reply: UIButton!
    
    
    
    var secondid:String = ""
    var messageid:String = ""
    var uid:String = ""
    var i=0
    var nsarray:NSArray? = []
    var nsarray2:NSArray? = []
    var likeid:String = ""
    var likebool:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        replylist.delegate=self
        replylist.dataSource=self
        
        //创建一个重用的单元格
        self.replylist!.register(UINib(nibName:"replyTableViewCell", bundle:nil),
                                   forCellReuseIdentifier:"replycell")
        replylist.isScrollEnabled=false
        
        
    }

    //加载数据
    func reloadData(Uid:String, Secondid:String,Messageid:String,Nsarray:NSArray,Content:String,Likebool:Bool,Likeid:String,Nsarray2:NSArray) {
        //设置标题
        self.content.text = Content
        //保存回复数据
        self.likebool=Likebool
        self.messageid=Messageid
        self.uid=Uid
        self.secondid=Secondid
        self.nsarray=Nsarray
        self.likeid=Likeid
        self.nsarray2=Nsarray2
        //重新加载数据
        self.replylist.reloadData()
        //更新高度约束
        self.replyheight.constant = CGFloat((self.nsarray?.count)!*44)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (nsarray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replycell", for: indexPath)as! replyTableViewCell
        let co = (self.nsarray?[indexPath.row])as! NSDictionary
        cell.content.text=(co["content"])as! String
        if (co["firstid"])as! String == "" {
            cell.name.setTitle("一位不愿透漏姓名的人:", for: .normal)
        }else{
            cell.name.setTitle((co["firstid"])as! String+":", for: .normal)
        }
        cell.replyid=(co["id"])as! String
        //cell添加长按手势
        let long = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture))
        cell.addGestureRecognizer(long)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func longPressGesture(){
        print("yeah!!!!")
    }
    @IBAction func replythis(_ sender: Any) {
        let replything=replycontent.text as! String
        if(replything==""){
            return
        }
        
        self.addreply(Messageid: messageid, Firstid: uid, Secondid: secondid, Content: replything)
        //延时操作
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)) {
            self.replycontent.text=""
            self.replycontent.placeholder="说点什么吧"
            FriendcriController.tablefriend.reloadData()
        }

    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let co = (self.nsarray?[indexPath.row])as! NSDictionary
        let replyid=co["id"]as! String
        let sendreplyid=co["firstid"]as! String
        let getreplyid=co["secondid"]as! String
        if(self.uid==sendreplyid){
            //设计左划菜单
            let add = UITableViewRowAction(style: .normal, title: "删除") { action, index in
                
                self.deletereply(Replyid: replyid)
                //延时操作
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)) {
                    FriendcriController.tablefriend.reloadData()
                }
            }
            add.backgroundColor = UIColor.red
            return [add]
        }
        else if(self.uid==getreplyid){
            //设计左划菜单
            let add = UITableViewRowAction(style: .normal, title: "删除") { action, index in
                self.deletereply(Replyid: replyid)
                //延时操作
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)) {
                    FriendcriController.tablefriend.reloadData()
                }
            }
            add.backgroundColor = UIColor.red
            return [add]
        }
        else {
            return []
        }
    }
    func deletereply(Replyid:String){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1062&zson=%7bid:\"\(Replyid)\"%7d"
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
                    self.getreply2(messageid: self.messageid,type: 2)
                }
                else{
                }
            }
            
        }
        task.resume()
    }
    //绘制单元格底部横线
    override func draw(_ rect: CGRect) {
        //线宽
        let lineWidth = 1 / UIScreen.main.scale
        //线偏移量
        let lineAdjustOffset = 1 / UIScreen.main.scale / 2
        //线条颜色
        let lineColor = UIColor(red: 0xe0/255, green: 0xe0/255, blue: 0xe0/255, alpha: 1)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //创建一个矩形，它的所有边都内缩固定的偏移量
        let drawingRect = self.bounds.insetBy(dx: lineAdjustOffset, dy: lineAdjustOffset)
        
        //创建并设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.maxY))
        
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置笔触宽度
        context.setLineWidth(lineWidth)
        
        //绘制路径
        context.strokePath()
    }
    func addreply(Messageid:String,Firstid:String,Secondid:String,Content:String){
        //没有一下三步会导致上传的content乱码或者是无法由于内容有字符导致访问失败
        let con=Content.data(using: String.Encoding.utf8)//转化为utf-8编码
        let dogString=Content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)//解析dagstring（data）
        let contentfinal=(dogString)as! String//转化为String
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1061&zson=%7bfirstid:\"\(Firstid)\",secondid:\"\(Secondid)\",messageid:\"\(Messageid)\",content:\"\(contentfinal)\"%7d"
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
                    self.getreply2(messageid: Messageid, type: 1)
                }
                else{
                }
            }
            
        }
        task.resume()
    }
    func getreply2(messageid:String,type:Int){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1063&zson=%7bmessageid:\"\(messageid)\"%7d"
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
                    self.nsarray=json["replyList"] as! NSArray
                    var j=0
                    for co in FriendcriController.reply{
                        let content = co!
                        let list = (content[0])as! NSDictionary
                        if(self.messageid==((list["messageid"])as! String)){
                            FriendcriController.reply.remove(at: j)
                            j=j-1
                        }
                        j=j+1
                    }
                    FriendcriController.reply.append(self.nsarray)
                }
                else{
                    var j=0
                    for co in FriendcriController.reply{
                        let content = co!
                        let list = (content[0])as! NSDictionary
                        if(messageid==((list["messageid"])as! String)){
                            FriendcriController.reply.remove(at: j)
                            j=j-1
                        }
                        j=j+1
                    }
                }
            }
            
        }
        task.resume()
    }
    @IBAction func addlike(_ sender: Any) {
        if(self.likebool==false){
            addlike()
            likelist()
            self.islike.setImage(#imageLiteral(resourceName: "hongxin"), for: .normal)
            let likenumberint:Int=Int(self.likenumber.text!)!+1
            self.likenumber.text=String(stringInterpolationSegment: likenumberint)
            self.likebool=true
        }
        else{
            for co in self.nsarray2!{
                let coo = co as! NSDictionary
                let id:String=(coo["id"])as! String
                let thisuid:String=(coo["uid"])as! String
                if(thisuid == self.uid){
                    deletelike(ID: id)
                }
            }
            self.islike.setImage(#imageLiteral(resourceName: "heixin"), for: .normal)
            let likenumberint:Int=Int(self.likenumber.text!)!-1
            self.likenumber.text=String(stringInterpolationSegment: likenumberint)
            self.likebool=false
        }
    }
    func deletelike(ID:String){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1042&zson=%7bid:\"\(ID)\"%7d"
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
                }
                else{
                    self.islike.setImage(#imageLiteral(resourceName: "hongxin"), for: .normal)
                    var likenumberint:Int=Int(self.likenumber.text!)!+1
                    self.likenumber.text=String(stringInterpolationSegment: likenumberint)
                    self.likebool=true
                }
            }
            
        }
        task.resume()
    }
    func addlike(){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1041&zson=%7bmessageid:\"\(self.messageid)\",uid:\"\(self.uid)\"%7d"
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
                }
                else{
                    self.islike.setImage(#imageLiteral(resourceName: "heixin"), for: .normal)
                    var likenumberint:Int=Int(self.likenumber.text!)!-1
                    self.likenumber.text=String(stringInterpolationSegment: likenumberint)
                    self.likebool=false
                }
            }
            
        }
        task.resume()
    }
    func likelist(){
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1043&zson=%7bmessageid:\"\(self.messageid)\"%7d"
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
                    var j=0
                    for co in FriendcriController.likelist{
                        let content = co!
                        let list = (content[0])as! NSDictionary
                        if(self.messageid==((list["messageid"])as! String)){
                            FriendcriController.likelist.remove(at: j)
                        }
                        j=j+1
                    }
                    FriendcriController.likelist.append(code2)
                    self.nsarray2=code2
                }
                else{
                    var j=0
                    for co in FriendcriController.likelist{
                        let content = co!
                        let list = (content[0])as! NSDictionary
                        if(self.messageid==((list["messageid"])as! String)){
                            FriendcriController.likelist.remove(at: j)
                        }
                        j=j+1
                    }
                }
            }
            
        }
        task.resume()
    }
}
