//
//  WENotificationInboxViewControllerExtension.swift
//  NotificationInboxSampleApp
//
//  Created by Shubham Naidu on 08/06/23.
//

import Foundation
import UIKit
import WENotificationInbox

// MARK: - Extensions
// ===== TableView Controller Extensions =====
extension WENotificationInboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inboxData = listOfInboxData[indexPath.row]
        if !(visitedIndex.contains(indexPath.row)) {
            visitedIndex.append(indexPath.row)
            viewEvent(inboxData)
        }
        let pushTempleteData  = inboxData.message as? PushNotificationTemplateData
        let detailDictionary = pushTempleteData?.messageMap
        // Based on the LayoutType we decide on how to render the cells in the table view
        guard let layout = detailDictionary?["layoutType"] as? String else { return UITableViewCell() }
        if let customCells = customCells{
            for customCell in customCells{
                if (customCell.cellReuseIdentifier.stringValue == layout){
                    if let cell = tableView.dequeueReusableCell(withIdentifier: customCell.cellReuseIdentifier.stringValue) as?  UITableViewCell & WECustomCellProtocol{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("APPINBOX you selected one of the cell")
        let inboxData = listOfInboxData[indexPath.row]
        clickEvent(inboxData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfInboxData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = listOfInboxData.count - 1
        if indexPath.row == lastItem {
            if(hasNextPage){
                self.tableView?.tableFooterView = createSpinnerFooter()
                loadAppInboxData(lastInboxData: listOfInboxData[listOfInboxData.count-1])
            }
        }
    }
}
// ===== Extension to Perform Opertations on Notifications =====
extension WENotificationInboxViewController: InboxCellDelegate {
    
    func clickEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.trackClick()
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
    
    func readEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.markRead()
    }
    
    func unreadEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.markUnread()
    }
    
    func viewEvent(_ inboxData: WEInboxMessage?) {
        inboxData?.trackView()
    }
}
