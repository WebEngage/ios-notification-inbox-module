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
    var customConfiguration: AnyObject?
    var defaultConfiguration: WEPushConfigurationProtocol? = DefaultCellConfiguration()
    
    @IBOutlet weak var optionMenu: UIBarButtonItem!
    @IBOutlet weak var inboxTableView: UITableView?
    
    @IBOutlet weak var noNotificationsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTableView?.delegate = self
        inboxTableView?.dataSource = self
        inboxTableView?.register(UINib(nibName: "WEPushBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "PushBannerCell")
        inboxTableView?.register(UINib(nibName: "WEPushTextTableViewCell", bundle: nil), forCellReuseIdentifier: "PushTextCell")
        // initializing the refreshControl
        inboxTableView?.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        inboxTableView?.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        loadAppInboxData()
        setupCustomConfiguration(customConfiguration: (customConfiguration as AnyObject))
        self.view.backgroundColor = defaultConfiguration?.navigationBarColor
        self.navigationController?.navigationBar.tintColor = defaultConfiguration?.navigationBarTintColor
        self.navigationItem.title = defaultConfiguration?.navigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: defaultConfiguration?.navigationTitleColor as Any]
        optionMenu.image = defaultConfiguration?.optionMenuImage
        inboxTableView?.isHidden = true
    }
    @objc func callPullToRefresh() {
        updateList(list: [],reset: true)
        loadAppInboxData()
    }
    
    @IBAction func optionMenuButtonClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: defaultConfiguration?.optionMenuItems[0], style: .default) { (_) in
            WENotificationInbox.shared.markStatus(self.listOfInboxData, status: .READ)
                for inboxData in self.listOfInboxData{
                    inboxData.status = "READ"
                }
                self.inboxTableView?.reloadData()
        }

        let action2 = UIAlertAction(title: defaultConfiguration?.optionMenuItems[1], style: .default) { (_) in
            for inboxData in self.listOfInboxData {
//                inboxData.markDelete()
                self.listOfInboxData = []
                self.inboxTableView?.reloadData()
                self.inboxTableView?.isHidden = true
                print("Bulk Delete...")
            }
        }
        alertController.addAction(action1)
        alertController.addAction(action2)

        present(alertController, animated: true, completion: nil)
    }
    func setupCustomConfiguration(customConfiguration: AnyObject){
        
        if let customConfig = customConfiguration as? WEViewControllerConfigurationProtocol{
            defaultConfiguration?.navigationTitle = customConfig.navigationTitle
            defaultConfiguration?.navigationTitleColor = customConfig.navigationTitleColor
            defaultConfiguration?.optionMenuItems = customConfig.optionMenuItems
            defaultConfiguration?.optionMenuImage = customConfig.optionMenuImage
            defaultConfiguration?.navigationBarColor = customConfig.navigationBarColor
            defaultConfiguration?.navigationBarTintColor = customConfig.navigationBarTintColor
        }
        
    }
    
    func updateList(list:[WEInboxMessage],reset:Bool = false){
        if(hasNextPage && !reset){
            self.listOfInboxData += list
        }else{
            self.listOfInboxData = list
        }
        
        DispatchQueue.main.async {
            self.inboxTableView?.isHidden = false
            self.inboxTableView?.refreshControl?.endRefreshing()
            self.inboxTableView?.reloadData()
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
                self.inboxTableView?.refreshControl?.endRefreshing()
            }
        })
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
        if let layout = detailDictionary?["layoutType"] as? String{
            if layout == "TEXT" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "PushTextCell") as? WEPushTextTableViewCell {
                    cell.delegate = self
                    let customCell = customConfiguration as AnyObject
                    cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
                    return cell
                }
            }
            else if layout == "BANNER" {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "PushBannerCell") as? WEPushBannerTableViewCell {
                    cell.delegate = self
                    let customCell = customConfiguration as AnyObject
                    cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "PushTextCell") as? WEPushTextTableViewCell {
                    cell.delegate = self
                    let customCell = customConfiguration as AnyObject 
                    cell.setupCell(inboxData: inboxData, index: indexPath.row, cellConfiguration: customCell)
                    return cell
                }
            }
            
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
            let point = sender.convert(CGPoint.zero, to: inboxTableView)
            guard let indexPath = inboxTableView?.indexPathForRow(at: point)
            else {return}
            listOfInboxData.remove(at: indexPath.row)
            inboxTableView?.beginUpdates()
            inboxTableView?.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
            inboxTableView?.endUpdates()
        }
    }
}
protocol InboxCellDelegate: NSObject {
    func readEvent(_: WEInboxMessage?)
    func unreadEvent(_: WEInboxMessage?)
    func viewEvent(_: WEInboxMessage?)
    func clickEvent(_: WEInboxMessage?)
    func deleteEvent(_: WEInboxMessage?, sender: Any)
}
