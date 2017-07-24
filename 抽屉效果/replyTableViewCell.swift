//
//  replyTableViewCell.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/17.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class replyTableViewCell: UITableViewCell {

    @IBOutlet weak var deletereply: UIButton!
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var content: UILabel!
    var replyid:String=""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deletethisreply(_ sender: Any) {
        //设置请求url
        var request = URLRequest(url:URL(string:"http://115.159.120.220:8080/efeelture/mobileAppServlet")!)
        //设置请求方式为post
        request.httpMethod = "POST"
        //设置请求体
        let poststring = "func=1062&zson=%7bid:\"\(replyid)\"%7d"
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
                    print("suddeed")
                    
                }
                else{
                }
            }
            
        }
        task.resume()

    }
    
}
