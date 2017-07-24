//
//  PopViewController.swift
//  抽屉效果
//
//  Created by li on 2017/7/8.
//  Copyright © 2017年 li. All rights reserved.
//

import UIKit

class PopViewController: UITableViewController {

    var dataArray = ["我的好友","我的设备"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        preferredContentSize = CGSize(width: 150, height: 70)
        tableView.rowHeight = 35
    }
    
    //MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==0){
            let one = UIStoryboard(name:"Main",bundle:Bundle.main)
            let two = one.instantiateViewController(withIdentifier: "friend")
            self.present(two, animated: true, completion: nil)
            
        }
        if(indexPath.row==1){
            let three = UIStoryboard(name:"Main",bundle:Bundle.main)
            let four = three.instantiateViewController(withIdentifier: "hardware")
            self.present(four, animated: true, completion: nil)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
