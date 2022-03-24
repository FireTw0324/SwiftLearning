import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return numOfRecorder
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      
      cell.textLabel?.text = String(indexPath.row + 1)
      cell.detailTextLabel?.text = String("aaa")
      return cell
    }
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var recordingSession: AVAudioSession!  //管理多個APP對音頻硬件設備的class (參考：https://reurl.cc/r1zmbr
    var audioRecorder: AVAudioRecorder!    //數據記錄到檔案內的class
    var audioPlayer: AVAudioPlayer!        //播放檔案的class

    var numOfRecorder: Int = 0 //這方法是從https://reurl.cc/r1zmjr 找的//numOfRecorder 用來記錄檔案錄音順序

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordBtn.setTitle("Record", for: .normal)  //設定初始title為record(因只想設定一個按鈕)
        
        recordBtn.addTarget(nil,action: #selector(ViewController.recordBtnAction),for: .touchDown) //設定所使用的function和動畫(按壓時即執行)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
                            //tableView 裡註冊 Cell
        tableView.delegate = self //控制 (delegate) 選擇 table cell 後該做什麼動作
        tableView.dataSource = self //顯示 table cell 內的資料(datasource)
        
        if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
          numOfRecorder = number //更新並記錄
        }//讀取紀錄的值 ，並驗證是否正確 //參考：https://reurl.cc/bnZ0yl
        
    }
    @IBAction func recordBtnAction(_ sender: Any) {
        
        if audioRecorder == nil { //按下按鈕時 假如值為nil 將其+=1
          numOfRecorder += 1
          
          let destinationUrl = getDirectoryPath().appendingPathComponent("\(numOfRecorder).caf")
                                //存擋
          let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),//音頻格式
                          AVSampleRateKey: 44100,      //採樣率，影響錄音品質
                          AVNumberOfChannelsKey: 2,
                          AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue  //貌似是影響檔案大小
                         ]
          
          do {
            audioRecorder = try AVAudioRecorder(url: destinationUrl, settings: settings) //執行存擋
            audioRecorder.record()
            
            recordBtn.setTitle("Stop", for: .normal)
          } catch {     //報錯
            print("Record error:", error.localizedDescription)
          }
        } else {
          audioRecorder.stop()  //假如值為1 停下錄音 將其+=nil
          audioRecorder = nil
          
          // save file name of record data in tableview
          UserDefaults.standard.set(numOfRecorder, forKey: "myNumber") //存檔
          tableView.reloadData() //刷新頁面
          recordBtn.setTitle("Record", for: .normal) //btn title
        }
    }

    func getDirectoryPath() -> URL {
      // create document folder url
      let fileDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      return fileDirectoryURL
    }
    
    func configRecordSession() {
      recordingSession = AVAudioSession.sharedInstance()
      
      do {
        try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
        try recordingSession.setActive(true)
        recordingSession.requestRecordPermission() { permissionAllowed in
        }
      } catch {
        print("Session error:", error.localizedDescription)
      }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
      var recordFilePath = getDirectoryPath().appendingPathComponent("\(indexPath.row + 1).caf")
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: recordFilePath)
        audioPlayer.volume = 1.0
        audioPlayer.play()
      } catch {
        print("Play error:", error.localizedDescription)
      }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let path = getDirectoryPath().appendingPathComponent("\(indexPath.row + 1).caf")
        if editingStyle == .delete {
            do{
                print("test", indexPath)
                try? FileManager.default.removeItem(at: path)
                numOfRecorder -= 1
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UserDefaults.standard.set(numOfRecorder, forKey: "myNumber")
                
            } catch{
            }
        }
    }

}

