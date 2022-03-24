//
//  FilesTableViewController.swift
//  HelloMyProject
//
//  Created by student on 2022/1/4.
//

import UIKit
import SwiftyDropbox
import KRProgressHUD

class FilesTableViewController: UITableViewController {

    var metaDatas = [Files.Metadata]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //登出
        DropboxClientsManager.unlinkClients()
        if DropboxManager.shard.isLinked {
            //ALREADY!
            prepareToUse()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(prepareToUse), name: .dbLinkedNotifucation, object: nil)
    }
    
    
    @objc func prepareToUse(){
        //Add "+" button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadFile))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        downloadFileList()
    }
    @objc
    func uploadFile(){
//        guard let client = DropboxClientsManager.authorizedClient else {
//            assertionFailure("Invalid client.")
//            return
//        }
        guard let fileURL = Bundle.main.url(forResource: "123.jpeg", withExtension: nil)else{
            assertionFailure("Invalid file URL.")
            return
        }
        KRProgressHUD.show()

        let targetFilePathName = "/" + Date().description + ".jpeg"
        
        DropboxManager.shard.upload(url: fileURL, to: targetFilePathName) { metadata, error in
            if let error = error{
                KRProgressHUD.dismiss()
                print("Upload File Error :\(error)")
                return
            }
            print("Upload OK")
            self.downloadFileList()
        }
        
        
//        client.files.upload(path: targetFilePathName, input: fileURL).response(queue: nil){ metadata, error in
//            if let error = error{
//                KRProgressHUD.dismiss()
//                print("Upload File Error :\(error)")
//                return
//            }
//            print("Upload OK")
//            self.downloadFileList()
//        }
    }
    
    
    func downloadFileList(){
        
        DropboxManager.shard.listFolder(path: "") { result,error in
            if let error = error{
                print("Download File List  Error :\(error)")
                KRProgressHUD.dismiss()
                return
            }
            if let result = result {
                print(result.entries)
                self.metaDatas = result.entries
                KRProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
    
    }
    
    @IBAction func linkBtnPressed(_ sender: Any) { //plist Lsapplication
        DropboxManager.shard.performLink(from: self) { AuthRoutes in
                guard let finalResult = AuthRoutes else {
                    assertionFailure("Invalid Result")
                    return
                }
                switch finalResult {
//                case .success(let token):
//                    print("Link ok : \(token)")
                case .success(_):
                    print("Link ok")
                    self.prepareToUse()
                case .error(let error, let message):
                    print("Link Error : \(error),\(message ?? "n/a")")
                case .cancel:
                    print("123")
                }
        }

    }

    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return metaDatas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        
        cell.textLabel?.text = metaDatas[indexPath.row].name

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let targetFilePathName = "/" + metaDatas[indexPath.row].name
            DropboxManager.shard.delete(filePathName: targetFilePathName){ result, error in
                if let error = error {
                    print("Delete file error:\(error)")
                    return
                }
                print("Delete File ok!")
                self.downloadFileList()
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //as? 條件式轉型
        if let targetVC = segue.destination as? ShowImageVC,
           let selectedIndexPath = self.tableView.indexPathForSelectedRow{
            targetVC.metadata = metaDatas[selectedIndexPath.row]
        }
    }
    

}

