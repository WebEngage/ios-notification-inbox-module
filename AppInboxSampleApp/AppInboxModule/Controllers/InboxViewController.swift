//
//  NotificationViewController.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 24/04/23.
//

import Foundation
import UIKit
import WENotificationInbox

class InboxViewController: UIViewController {
    
    var listOfInboxData = [WEInboxMessage]()
    var hasNextPage = false
    var networkResponse  = ""
    var cellHeight: CGFloat = 120
    var customCell: WEPushCellProtocol?
    
    @IBOutlet weak var inboxTableView: UITableView?
    
    @IBOutlet weak var noNotificationsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        inboxTableView?.delegate = self
        inboxTableView?.dataSource = self
        inboxTableView?.register(UINib(nibName: "PushTableViewCell", bundle: nil), forCellReuseIdentifier: "PushCell")
        // initializing the refreshControl
        inboxTableView?.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        inboxTableView?.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
//        inboxTableView?.estimatedRowHeight = 320
//        inboxTableView?.rowHeight = UITableView.automaticDimension
        loadAppInboxData()
        inboxTableView?.isHidden = true
    }
    
    @objc func callPullToRefresh() {
        updateList(list: [],reset: true)
        loadAppInboxData()
    }
    
    @IBAction func moreButtonClicked(_ sender: UIBarButtonItem) {
        let readAll = UIAction(title: "Read All"){
            _ in
        WENotificationInbox.shared.markStatus(self.listOfInboxData, status: .READ)
            for inboxData in self.listOfInboxData{
                inboxData.status = "READ"
            }
            self.inboxTableView?.reloadData()
            
        }
        let bulkDelete = UIAction(title: "Bulk Delete"){
            _ in
            for inboxData in self.listOfInboxData {
//                inboxData.markDelete()
                self.listOfInboxData = []
                self.inboxTableView?.reloadData()
                self.inboxTableView?.isHidden = true
                print("Bulk Delete...")
            }
        }
        let menu = UIMenu(children: [readAll,bulkDelete])
        sender.menu = menu

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

extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PushCell") as? PushTableViewCell {
            cell.delegate = self
            if #available(iOS 13.0, *) {
                if let customCell = customCell {
                    cell.setupCell(inboxData: inboxData, index: indexPath.row, customStyle: customCell)
                }
            } else {
                // Fallback on earlier versions
            }
            cell.contentView.backgroundColor = UIColor(white: 0.98, alpha: 1)
            return cell
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        if let inboxImage = listOfInboxData[indexPath.row].message as? PushNotificationTemplateData{
////            if inboxImage.image != "" {
////                return 320
////            } else {
////                return UITableView.automaticDimension
////            }
////        }
//        return UITableView.automaticDimension
//    }
}
extension InboxViewController: InboxCellDelegate {
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
