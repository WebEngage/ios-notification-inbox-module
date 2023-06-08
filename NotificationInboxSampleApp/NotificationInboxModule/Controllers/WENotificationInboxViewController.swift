//
//  NotificationViewController.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 24/04/23.
//

import Foundation
import UIKit
import WENotificationInbox

class WENotificationInboxViewController: UIViewController {
   
    // ===== MARK: - Vars =====
    
    var listOfInboxData = [WEInboxMessage]()
    var hasNextPage = false
    var networkResponse  = ""
    var visitedIndex: [Int] = []
    var customCells: [WECustomCellProtocol]? = []
    
    private var customTextConfiguration: AnyObject?
    private var customBannerConfiguration: AnyObject?
    private var defaultConfiguration = DefaultCellConfiguration()
    private var customNoNotifications: UIView?
    
    @IBOutlet weak var optionMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var noNotificationsView: UIView!
    
    // ===== MARK: - Overridden methods =====
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: defaultConfiguration.optionMenuImage, primaryAction: nil, menu: menuItems())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WENotificationInbox.shared.onNotificationIconClick()
        setupView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "WEPushBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "PushBannerCell")
        tableView?.register(UINib(nibName: "WEPushTextTableViewCell", bundle: nil), forCellReuseIdentifier: "PushTextCell")
        // initializing the refreshControl
        tableView?.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        tableView?.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tableView?.refreshControl?.beginRefreshing()
        loadAppInboxData()
        
    }
    // ===== MARK: - Private Methods =====
    
    @objc private func callPullToRefresh() {
        updateList(list: [],reset: true)
        loadAppInboxData()
    }
    
    func createSpinnerFooter()-> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func loadAppInboxData(lastInboxData : WEInboxMessage? = nil, shouldResetAllList:Bool = false){
      // ===== Medthod to get the Notification List =====
        WENotificationInbox.shared.getNotificationList(lastInboxData: lastInboxData,
                                                       completion: { [weak self] data, error in
           
            if let response = data{
                self?.updateList(list: response.messageList,reset: shouldResetAllList)
                self?.hasNextPage = response.hasNextPage
            }else if let weInboxError = error{
                WELogger.d("Error: \(weInboxError)")
            }
            DispatchQueue.main.async {
                self?.tableView?.tableFooterView = nil
                self?.tableView?.refreshControl?.endRefreshing()
            }
        })
    }

    private func menuItems() -> UIMenu {
        // ===== This method is used to add the more items option =====
        let addMenuItems = UIMenu(title: "",options: .displayInline, children: [
            UIAction (title: defaultConfiguration.optionMenuTitles[0] ) { [unowned self] (_) in
                WENotificationInbox.shared.markStatus(self.listOfInboxData, status: .READ)
                    for inboxData in self.listOfInboxData{
                        inboxData.status = "READ"
                    }
                    self.tableView?.reloadData()
            },
            UIAction (title: defaultConfiguration.optionMenuTitles[1] ) {[unowned self](_) in
                for inboxData in self.listOfInboxData {
                    inboxData.markDelete()
                }
                print("Bulk Delete...")
                if !self.hasNextPage {
                    self.listOfInboxData = []
                    self.tableView?.backgroundView?.isHidden = false
                } else {
                    let lastItem = listOfInboxData[listOfInboxData.count-1]
                    self.listOfInboxData = []
                    self.tableView?.refreshControl?.beginRefreshing()
                    loadAppInboxData(lastInboxData: lastItem)
                }
                self.tableView?.reloadData()
            }
        ])
        return addMenuItems
    }
    
    func renderWECells(_ tableView: UITableView, layout: String, cellForRowAt indexPath: IndexPath, inboxData: WEInboxMessage )-> UITableViewCell{
        // ===== This method is used to render the tableview cell.
        // ===== The defualt type of cell is TEXT cell.
        switch layout {
        case "TEXT":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushTextCell", for: indexPath) as? WEPushTextTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let customCell = customTextConfiguration as AnyObject
            cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
            cell.contentView.backgroundColor = defaultConfiguration.backgroundColor
            return cell
        case "BANNER":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushBannerCell", for: indexPath) as? WEPushBannerTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let customCell = customBannerConfiguration as AnyObject
            cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
            cell.contentView.backgroundColor = defaultConfiguration.backgroundColor
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushTextCell", for: indexPath) as? WEPushTextTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let customCell = customTextConfiguration as AnyObject
            cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
            cell.contentView.backgroundColor = defaultConfiguration.backgroundColor
            return cell
        }
    }
    
    @objc func setupCustomConfiguration(customConfiguration: AnyObject, customizationFor config  : customConfig){
       // ===== This method is used to store the customizations done from the client side. =====
        switch config {
        case customConfig.text:
            customTextConfiguration = customConfiguration
            
        case customConfig.banner:
            customBannerConfiguration = customConfiguration
            
        case customConfig.viewController:
            setupCustomViewController(customConfiguration: customConfiguration)
        
        default:
             break
        }
    }
    
    @objc func setupCustomCell(customCell: WECustomCellProtocol, forCellType cellType  : CellType){
        // ===== This method is used to hold the Custom Cells provided by the client. =====
        let usersCell = customCell
        usersCell.cellReuseIdentifier = cellType
        customCells?.append(usersCell)
    }
    
    private func setupView() {
        //===== Initial View Setup for the ViewController =====
        noNotificationsView.isHidden = true
        if let customNoNotifications = customNoNotifications {
            self.tableView?.backgroundView = customNoNotifications
        } else {
            self.tableView?.backgroundView = noNotificationsView
        }
        self.tableView?.backgroundView?.isHidden = true
        self.view.backgroundColor = defaultConfiguration.navigationBarColor
        self.navigationController?.navigationBar.tintColor = defaultConfiguration.navigationBarTintColor
        self.navigationItem.title = defaultConfiguration.navigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultConfiguration.navigationTitleColor as Any]
        optionMenu.image = defaultConfiguration.optionMenuImage
        self.tableView?.backgroundColor = defaultConfiguration.backgroundColor
      
    }
    
    private func setupCustomViewController(customConfiguration:AnyObject){
        //===== THis method is used to apply customization to the ViewController.=====
        if let customConfig = customConfiguration as? WEViewControllerConfigurationProtocol{
            if let noNotificationsView = customConfig.noNotificationsView {
                customNoNotifications = noNotificationsView
            }
            if let navigationTitle = customConfig.navigationTitle {
                defaultConfiguration.navigationTitle = navigationTitle
            }
            
            if let navigationTitleColor = customConfig.navigationTitleColor {
                defaultConfiguration.navigationTitleColor = navigationTitleColor
            }
            
            if let optionMenuTitles = customConfig.optionMenuTitles {
                defaultConfiguration.optionMenuTitles = optionMenuTitles
            }
            
            if let optionMenuImage = customConfig.optionMenuImage {
                defaultConfiguration.optionMenuImage = optionMenuImage
            }
            
            if let navigationBarColor = customConfig.navigationBarColor {
                defaultConfiguration.navigationBarColor = navigationBarColor
            }
            
            if let navigationBarTintColor = customConfig.navigationBarTintColor {
                defaultConfiguration.navigationBarTintColor = navigationBarTintColor
            }
            
            if let backgroundColor = customConfig.backgroundColor {
                defaultConfiguration.backgroundColor = backgroundColor
            }
        }
    }
    
    private func updateList(list:[WEInboxMessage],reset:Bool = false){
      // ===== This method is used to perform pagination in the TableView Controller =====
        var noNotificationViewStatus: Bool = false
        if(hasNextPage && !reset){
            self.listOfInboxData += list
            noNotificationViewStatus = true
        }else{
            if !list.isEmpty || reset{
               noNotificationViewStatus = true
            }
            self.listOfInboxData = list
        }
        
        DispatchQueue.main.async {
            self.tableView?.backgroundView?.isHidden = noNotificationViewStatus
            self.tableView?.reloadData()
        }
    }
     
}

           
