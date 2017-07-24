//
//  LeftMenuViewController.swift
//  抽屉效果
//
//  Created by li on 2017/7/8.
//  Copyright © 2017年 li. All rights reserved.
//  
//

import UIKit

//protocol LeftMenuViewControllerDelegate: NSObjectProtocol {
//    
//    func LeftViewController(didSelectRowAt indexPath: IndexPath)
//    
//}

class LeftMenuViewController: UIViewController {

    fileprivate let cellIdentifier = "WLCellIdentifier"
//    weak var delegate: LeftMenuViewControllerDelegate?
    let headerViewH: CGFloat = 200
    
    var dataArray = [["ef商城","sidebar_business"],["ef钱包","sidebar_purse"],["个性装扮","sidebar_decoration"],["我的收藏","sidebar_favorit"],["我的相册","sidebar_album"],["设置","sidebar_file"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerView)
        view.addSubview(tableView)
        
        
    }
    
    private lazy var tableView: UITableView = {
       
        let tab = UITableView(frame: CGRect(x: 0, y: self.headerViewH, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.headerViewH), style: .plain)
        tab.backgroundColor = UIColor(colorLiteralRed: 17 / 255.0, green: 18 / 255.0, blue: 55 / 255.0, alpha: 1.0)
        tab.separatorStyle = UITableViewCellSeparatorStyle.none
        tab.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tab.delegate = self
        tab.dataSource = self
        tab.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        return tab
    }()


    private lazy var headerView: UIView = {
        
       
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.headerViewH))
        let bgImageView = UIImageView(frame: view.frame)
        bgImageView.image = UIImage(named: "background")
        bgImageView.contentMode = UIViewContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        view.addSubview(bgImageView)
        return view
        
    }()

}

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = dataArray[indexPath.row][0]
        cell.imageView?.image = UIImage(named: dataArray[indexPath.row][1])
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==5){
            let sb = UIStoryboard(name:"Main",bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "setpage")
            self.present(vc, animated: true, completion: nil)
            DrawerViewController.shareDrawer?.closeLeftMenu()
        
    }
  }
}
