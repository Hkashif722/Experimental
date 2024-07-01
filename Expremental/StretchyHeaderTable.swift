//
//  StretchyTableHeaderView.swift
//

import Foundation
import UIKit
import TinyConstraints





class StretchyHeaderTable: UITableViewController{
    let headerImageView = UIImageView()
    var headerView : tableHeader?
    let SCREEN_WIDTH = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = (Bundle.main.loadNibNamed("tableHeader", owner: self, options: nil)?[0] as? tableHeader)!
        headerView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            self.tableView.reloadData()
        }
        
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           
            if headerView != nil {
            let yPos: CGFloat = -scrollView.contentOffset.y
               
                if yPos > 0 {
                    var imgRect: CGRect? = headerView?.frame
                    imgRect?.origin.y = scrollView.contentOffset.y
                    imgRect?.size.height = CGFloat(SCREEN_WIDTH/2) + yPos  - CGFloat(SCREEN_WIDTH/2)
                    print( (imgRect?.size.height)!)
                    headerView?.frame = imgRect!
                    self.tableView.sectionHeaderHeight = (imgRect?.size.height)!
                  
                }
            }
        }
    
    
    
    // TableView DataSource Methods
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Return the number of rows for your table
//        
//        return 20
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Dequeue a cell and configure it
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
//        cell.textLabel?.text = "Row \(indexPath.row)"
//        return cell
//    }

}
