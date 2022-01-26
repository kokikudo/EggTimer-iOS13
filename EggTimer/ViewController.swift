import UIKit
import AVFoundation

// 卵の茹で時間 key:好みの硬さ value:茹で時間
let eggTimes: [String : Int] = ["Soft": 5, "Medium": 7, "Hard": 12]

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!  // 音楽再生プレイヤークラス
    var timer = Timer()         // 定期的に処理を行うためのTimerクラス
    var totalSeconds = 0        //　合計カウント値
    var secondsPassed = 0       // 経過した時間
    
    @IBOutlet weak var titleLabel: UILabel!         // タイトル
    @IBOutlet weak var timerBar: UIProgressView!    // 進捗バー
    
    @IBAction func hardnessSlected(_ sender: UIButton) {
        
        // 初期化
        timer.invalidate()
        secondsPassed = 0
        
        // 選んだ硬さから茹で時間をセット
        let hardness = sender.currentTitle!
        totalSeconds = eggTimes[hardness]!
        
        // 指定したカウントごとに処理を実行するTimer.dcheduledTimer()
        // selectorに渡す関数に@objcポインタを付与する必要がある
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(coundDown), userInfo: nil, repeats: true)
    }
    
    // カウントダウン時の処理
    @objc func coundDown() {
        
        // 進捗バーの値を更新
        // Float型の値同士で割り算しないと小数点が切り捨てられた値になる
        let percentageProgress = Float(secondsPassed) / Float(totalSeconds)
        timerBar.progress = percentageProgress
        
        // 進んでる間は経過時間を更新しタイトルに表示
        if secondsPassed < totalSeconds {
            let labelText = totalSeconds - secondsPassed
            titleLabel.text = String(labelText)
            secondsPassed += 1
        } else {
            titleLabel.text = "DONE!!"
            playSound()
        } // タイマーが終わったらタイトルを変更し音声を再生する
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
    }
    // 最初は以下のコードだったがTimerクラスを使った処理があるならそれを使った方がいいかも
    //    func coundDown(time: Int) {
    //        for x in stride(from: time, to: 0, by: -1) {
    //            print(x, "seconds")
    //            usleep(1000000)
    //        }
    //
    //        print("Let eat an egg!!")
    //    }
}
