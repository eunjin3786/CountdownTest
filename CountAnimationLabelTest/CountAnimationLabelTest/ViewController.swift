
import UIKit

class ViewController: UIViewController {
    
    let sampleNumber = 923945
    
    @IBOutlet weak var countScrollAscendingLabel: CountScrollLabel!
    @IBOutlet weak var countScrollDownsendingLabel: CountScrollLabel!
    @IBOutlet weak var countPushLabel: CountPushLabel!
    @IBOutlet weak var countPushWithoutContainerLabel: CountPushWithoutContainerLabel!
    
    @IBAction func animateCountScrollAscendingLabel(_ sender: Any) {
        countScrollAscendingLabel.animate()
    }
    
    @IBAction func animateCountScrollDownsendingLabel(_ sender: Any) {
        countScrollDownsendingLabel.animate(ascending: false)
    }
    
    @IBAction func animateCountPushLabel(_ sender: Any) {
        countPushLabel.animate()
    }
    
    @IBAction func animateCountPushWithoutContainerLabel(_ sender: Any) {
        countPushWithoutContainerLabel.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countScrollAscendingLabel.configure(with: sampleNumber)
        countScrollDownsendingLabel.configure(with: sampleNumber)
        countPushLabel.configure(with: sampleNumber)
    countPushWithoutContainerLabel.configure(with: sampleNumber)
    }
}


