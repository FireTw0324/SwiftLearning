//
//  DropboxManager.swift
//  HelloMyProject
//
//  Created by student on 2022/1/11.
//

import Foundation
import SwiftyDropbox
import UIKit

typealias DBUploadCompletion = (Files.FileMetadata?,CallError<Files.UploadError>?) -> Void
typealias DBListCompletion = (Files.ListFolderResult?, CallError<Files.ListFolderError>?) -> Void
typealias DBDeleteCompletion = (Files.DeleteResult?, CallError<Files.DeleteError>?) -> Void
typealias DBDownloadCompletion = ((Files.FileMetadata, URL)?, CallError<Files.DownloadError>?) -> Void

class DropboxManager{
    static let shard = DropboxManager()
    private init() {}
    
    private var oauthCompletion: DropboxOAuthCompletion?
    //Computed property
    var isLinked:Bool{
       return DropboxClientsManager.authorizedClient != nil
    }
    
    
    func setup(appKey: String){
        DropboxClientsManager.setupWithAppKey(appKey, transportClient: nil)
    }
    
    //login  //escaping 讓closure不會被堆疊
    func performLink(from controller: UIViewController,completion:@escaping DropboxOAuthCompletion){
        oauthCompletion = completion
        DropboxClientsManager.authorizeFromController(UIApplication.shared , controller: controller) { url in
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func handleRedirectURL(url:URL)->Bool{
        
        guard let completion = oauthCompletion else{
            assertionFailure("oauthCompletion is nil")
            return false
        }
        oauthCompletion = nil
        
        return DropboxClientsManager.handleRedirectURL(url, completion: completion)
    }
    
    private var client : DropboxClient{
        guard let client = DropboxClientsManager.authorizedClient else {
            fatalError("Invalid client.")
        }
        return client
    }
    
    func upload(url : URL,
                to path : String,
                completion: @escaping DBUploadCompletion) {
        client.files.upload(path:path,input:url).response(queue: nil, completionHandler: completion)
    }
    
    func listFolder(path:String,completion : @escaping DBListCompletion){
        client.files.listFolder(path: path).response(queue: nil, completionHandler: completion)
    }
    
    func delete(filePathName: String,completion:@escaping DBDeleteCompletion){
        client.files.deleteV2(path: filePathName).response(queue: nil, completionHandler: completion)
    }
    
    func download(filePathName:String ,completion: @escaping DBDownloadCompletion){
        let tmpPath = NSTemporaryDirectory()
        print(tmpPath)
        let tmpFileURL = URL(fileURLWithPath: tmpPath).appendingPathComponent("\(UUID().uuidString).jpg")
        
        client.files.download(path: filePathName){_,_ in tmpFileURL}.response(queue: nil, completionHandler: completion)
    }
}
