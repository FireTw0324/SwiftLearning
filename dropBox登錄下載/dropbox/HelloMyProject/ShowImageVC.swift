//
//  ViewController.swift
//  HelloMyProject
//
//  Created by student on 2022/1/4.
//

import UIKit
import SwiftyDropbox


class ShowImageVC: UIViewController {
    
    var metadata : Files.Metadata?
    
    
    @IBOutlet weak var resultImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//
        guard let metadata = metadata else {
            assertionFailure("Invalid metadata")
            return
        }
//        guard let client = DropboxClientsManager.authorizedClient else {
//            assertionFailure("Invalid client.")
//            return
//        }
        DropboxManager.shard.download(filePathName: "/" + metadata.name) { result, error in
            
            if let error = error {
                print("Download file error: \(error)")
                return
            }
            
            guard let (_ , url) = result else {
                return
            }
            
            let image = UIImage(contentsOfFile: url.path)
            self.resultImageView.image = image
            //清除tmp
            try? FileManager.default.removeItem(at: url)

        }
//        let tmpPath = NSTemporaryDirectory()
//        print(tmpPath)
//        let tmpFileURL = URL(fileURLWithPath: tmpPath).appendingPathComponent("\(UUID().uuidString).jpg")
//
        // client.files.download(path:"/" + metadata.name)
        // client.files.download(path: "/" + metadata.name) { url, response in
        //            return tmpFileURL
        // }=
//        client.files.download(path: "/"+metadata.name){ _, _ in tmpFileURL}.response(queue: nil) { result, error in
//
//            if let error = error {
//                print("Download file error: \(error)")
//                return
//            }
//
//            guard let (fileMetadata , url) = result else {
//                return
//            }
//
//            let image = UIImage(contentsOfFile: tmpFileURL.path)
//            self.resultImageView.image = image
//            //清除tmp
//            try? FileManager.default.removeItem(at: tmpFileURL)
//
//        }
    }
        
}
    

