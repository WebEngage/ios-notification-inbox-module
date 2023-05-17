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
    private var customTextConfiguration: AnyObject?
    private var customBannerConfiguration: AnyObject?
    private var customCells: [WECustomCellProtocol]? = []
    private var defaultConfiguration: WEPushConfigurationProtocol? = DefaultCellConfiguration()
    private var customNoNotifications: UIView?
    private var visitedIndex: [Int] = []
    
    @IBOutlet weak var optionMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet weak var noNotificationsView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: defaultConfiguration?.optionMenuImage, primaryAction: nil, menu: menuItems())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @objc func callPullToRefresh() {
        updateList(list: [],reset: true)
        loadAppInboxData()
    }

    private func menuItems() -> UIMenu {
        let addMenuItems = UIMenu(title: "",options: .displayInline, children: [
            UIAction (title: defaultConfiguration?.optionMenuTitles[0] ?? "Read All") { [unowned self] (_) in
                WENotificationInbox.shared.markStatus(self.listOfInboxData, status: .READ)
                    for inboxData in self.listOfInboxData{
                        inboxData.status = "READ"
                    }
                    self.tableView?.reloadData()
            },
            UIAction (title: defaultConfiguration?.optionMenuTitles[1] ?? "Bulk Delete") {[unowned self](_) in
                for inboxData in self.listOfInboxData {
                                inboxData.markDelete()
                            }
                print("Bulk Delete...")
                self.listOfInboxData = []
                self.tableView?.backgroundView?.isHidden = false
                self.tableView?.reloadData()
            }
        ])
        return addMenuItems
    }
    
    func setupCustomConfiguration(customConfiguration: AnyObject, customizationFor config  : customConfig){
        switch config {
        case customConfig.text:
            customTextConfiguration = customConfiguration
            
        case customConfig.banner:
            customBannerConfiguration = customConfiguration
            
        case customConfig.viewController:
            if let customConfig = customConfiguration as? WEViewControllerConfigurationProtocol{
                defaultConfiguration?.navigationTitle = customConfig.navigationTitle
                customNoNotifications = customConfig.noNotificationsView
                defaultConfiguration?.navigationTitleColor = customConfig.navigationTitleColor
                defaultConfiguration?.optionMenuTitles = customConfig.optionMenuTitles
                defaultConfiguration?.optionMenuImage = customConfig.optionMenuImage
                defaultConfiguration?.navigationBarColor = customConfig.navigationBarColor
                defaultConfiguration?.navigationBarTintColor = customConfig.navigationBarTintColor
                defaultConfiguration?.backgroundColor = customConfig.backgroundColor
            }
        }
    }
    
    func setupCustomCell(customCell: WECustomCellProtocol, forCellType cellType  : cellType){
        var usersCell = customCell
        usersCell.cellReuseIdentifier = cellType
        customCells?.append(usersCell)
    }
    
    private func setupView() {
        noNotificationsView.isHidden = true
        defaultConfiguration?.noNotificationsView = customNoNotifications ?? noNotificationsView
        self.tableView?.backgroundView = defaultConfiguration?.noNotificationsView
        self.tableView?.backgroundView?.isHidden = true
        self.view.backgroundColor = defaultConfiguration?.navigationBarColor
        self.navigationController?.navigationBar.tintColor = defaultConfiguration?.navigationBarTintColor
        self.navigationItem.title = defaultConfiguration?.navigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultConfiguration?.navigationTitleColor as Any]
        optionMenu.image = defaultConfiguration?.optionMenuImage
        self.tableView?.backgroundColor = defaultConfiguration?.backgroundColor
      
    }
    
    private func updateList(list:[WEInboxMessage],reset:Bool = false){
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
            self.tableView?.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    private func loadAppInboxData(lastInboxData : WEInboxMessage? = nil, shouldResetAllList:Bool = false){
        WENotificationInbox.shared.getNotificationList(lastInboxData: lastInboxData,
                                                       completion: { [weak self] data, error in
            if let response = data{
                self?.updateList(list: response.messageList,reset: shouldResetAllList)
                self?.hasNextPage = response.hasNextPage
            }else if let weInboxError = error{
                WELogger.d("Error: \(weInboxError)")
            }
            DispatchQueue.main.async {
                self?.tableView?.refreshControl?.endRefreshing()
            }
        })
    }
    
    private func renderWECells(_ tableView: UITableView, layout: String, cellForRowAt indexPath: IndexPath, inboxData: WEInboxMessage )-> UITableViewCell{
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
        if !(visitedIndex.contains(indexPath.row)) {
            visitedIndex.append(indexPath.row)
            viewEvent(inboxData)
        }
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
        inboxData?.markDelete()
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
