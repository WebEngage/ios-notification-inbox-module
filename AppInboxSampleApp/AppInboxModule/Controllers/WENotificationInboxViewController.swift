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
    
    var listOfInboxData = [WEInboxMessage]()
    var hasNextPage = false
    var networkResponse  = ""
    var customTextConfiguration: AnyObject?
    var customBannerConfiguration: AnyObject?
    var customCells: [WECustomCellProtocol]? = []
    var defaultConfiguration: WEPushConfigurationProtocol? = DefaultCellConfiguration()
    
    @IBOutlet weak var optionMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet weak var noNotificationsView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: defaultConfiguration?.optionMenuImage, primaryAction: nil, menu: menuItems())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @objc func callPullToRefresh() {
        updateList(list: [],reset: true)
        loadAppInboxData()
    }

    func menuItems() -> UIMenu {
        let addMenuItems = UIMenu(title: "",options: .displayInline, children: [
            UIAction (title: defaultConfiguration?.optionMenuItems[0] ?? "Read All") { (_) in
                WENotificationInbox.shared.markStatus(self.listOfInboxData, status: .READ)
                    for inboxData in self.listOfInboxData{
                        inboxData.status = "READ"
                    }
                    self.tableView?.reloadData()
            },
            UIAction (title: defaultConfiguration?.optionMenuItems[1] ?? "Bulk Delete") { (_) in
                for inboxData in self.listOfInboxData {
                //                inboxData.markDelete()
                            }
                print("Bulk Delete...")
                self.listOfInboxData = []
                self.tableView?.isHidden = true
                self.tableView?.reloadData()
            }
        ])
        return addMenuItems
    }
    
    func setupCustomConfiguration(customConfiguration: AnyObject, forCellType config  : customConfig){
        
        switch config {
        case customConfig.text:
            customTextConfiguration = customConfiguration
            
        case customConfig.banner:
            customBannerConfiguration = customConfiguration
            
        case customConfig.viewController:
            if let customConfig = customConfiguration as? WEViewControllerConfigurationProtocol{
                defaultConfiguration?.navigationTitle = customConfig.navigationTitle
                defaultConfiguration?.navigationTitleColor = customConfig.navigationTitleColor
                defaultConfiguration?.optionMenuItems = customConfig.optionMenuItems
                defaultConfiguration?.optionMenuImage = customConfig.optionMenuImage
                defaultConfiguration?.navigationBarColor = customConfig.navigationBarColor
                defaultConfiguration?.navigationBarTintColor = customConfig.navigationBarTintColor
                defaultConfiguration?.backgroundColor = customConfig.backgroundColor
            }
    //        if let customCongig = customConfiguration as? WENotificationInboxViewController{
    //            customCongig.addAction(inboxTableView: inboxTableView!)
    //        }
            self.view.backgroundColor = defaultConfiguration?.navigationBarColor
            self.navigationController?.navigationBar.tintColor = defaultConfiguration?.navigationBarTintColor
            self.navigationItem.title = defaultConfiguration?.navigationTitle
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultConfiguration?.navigationTitleColor as Any]
            optionMenu.image = defaultConfiguration?.optionMenuImage
            self.tableView?.backgroundColor = defaultConfiguration?.backgroundColor
        }
    }
    
    func updateList(list:[WEInboxMessage],reset:Bool = false){
        if(hasNextPage && !reset){
            self.listOfInboxData += list
        }else{
            self.listOfInboxData = list
        }
        
        DispatchQueue.main.async {
            self.tableView?.isHidden = false
            self.tableView?.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    func loadAppInboxData(lastInboxData : WEInboxMessage? = nil, shouldResetAllList:Bool = false){
        WENotificationInbox.shared.getNotificationList(lastInboxData: lastInboxData,
                                                       completion: { data, error in
            if let response = data{
                self.updateList(list: response.messageList,reset: shouldResetAllList)
                self.hasNextPage = response.hasNextPage
            }else if let weInboxError = error{
                WELogger.d("Error: \(weInboxError)")
            }
            DispatchQueue.main.async {
                self.tableView?.refreshControl?.endRefreshing()
            }
        })
    }
//    public func addAction(inboxTableView: UITableView){}
    func renderWECells(_ tableView: UITableView, layout: String, cellForRowAt indexPath: IndexPath, inboxData: WEInboxMessage )-> UITableViewCell{
        switch layout {
        case "TEXT":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushTextCell", for: indexPath) as? WEPushTextTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let customCell = customTextConfiguration as AnyObject
            cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
            cell.contentView.backgroundColor = defaultConfiguration?.backgroundColor
            return cell
        case "BANNER":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushBannerCell", for: indexPath) as? WEPushBannerTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let customCell = customBannerConfiguration as AnyObject
            cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
            cell.contentView.backgroundColor = defaultConfiguration?.backgroundColor
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushTextCell", for: indexPath) as? WEPushTextTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let customCell = customTextConfiguration as AnyObject
            cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
            cell.contentView.backgroundColor = defaultConfiguration?.backgroundColor
            return cell
        }
    }
}

extension WENotificationInboxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("APPINBOX you selected one of the cell")
        let inboxData = listOfInboxData[indexPath.row]
                clickEvent(inboxData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfInboxData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inboxData = listOfInboxData[indexPath.row]
        let pushTempleteData  = inboxData.message as? PushNotificationTemplateData
        let detailDictionary = pushTempleteData?.messageMap
        guard let layout = detailDictionary?["layoutType"] as? String else { return UITableViewCell() }
        if let customCells = customCells{
            for customCell in customCells{
                if (customCell.cellReuseIdentifier.rawValue == layout){
                    if let cell = tableView.dequeueReusableCell(withIdentifier: customCell.cellReuseIdentifier.rawValue) as?  UITableViewCell & WECustomCellProtocol{
                        cell.setupcell(inboxData: inboxData, index: indexPath.row)
                        return cell
                    }
                }
            }
            return renderWECells(tableView, layout: layout, cellForRowAt: indexPath, inboxData: inboxData)
        }else {
            return renderWECells(tableView, layout: layout, cellForRowAt: indexPath, inboxData: inboxData)
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = listOfInboxData.count - 1
        if indexPath.row == lastItem {
            if(hasNextPage){
                loadAppInboxData(lastInboxData: listOfInboxData[listOfInboxData.count-1])
            }
        }
    }
}
extension WENotificationInboxViewController: InboxCellDelegate {
    func clickEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.trackClick()
    }
    
    func readEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.markRead()
    }
    
    func unreadEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.markUnread()
    }
    
    func viewEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.trackView()
    }
    
    func deleteEvent(_ inboxData: WEInboxMessage?, sender : Any) {
//        inboxData?.markDelete()
        if let sender = sender as? UIButton{
            let point = sender.convert(CGPoint.zero, to: tableView)
            guard let indexPath = tableView?.indexPathForRow(at: point)
            else {return}
            listOfInboxData.remove(at: indexPath.row)
            tableView?.beginUpdates()
            tableView?.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
            tableView?.endUpdates()
        }
    }
}
