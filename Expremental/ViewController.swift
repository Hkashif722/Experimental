//
//  ViewController.swift
//  Expremental
//
//  Created by Kashif Hussain on 02/04/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let headerImageView = UIImageView()
    var headerView : tableHeader?
    let SCREEN_WIDTH = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = (Bundle.main.loadNibNamed("tableHeader", owner: self, options: nil)?[0] as? tableHeader)!
        headerView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        
        setupTableView()
        setupTableHeaderView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
    }
    
    func setupTableHeaderView() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
//        tableView.tableHeaderView = headerView
        tableView.tableHeaderView = nil
        tableView.contentInset  = UIEdgeInsets(top: CGFloat(SCREEN_WIDTH/2), left: 0, bottom: 0, right: 0)
        tableView.addSubview(headerView!)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            self.tableView.reloadData()
        }
        
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
           
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
    
    func blur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = (headerView?.bounds)!
           blurEffectView.alpha = 0.9
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           headerView?.addSubview(blurEffectView)
       }
    
    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows for your table
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell and configure it
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }

}
