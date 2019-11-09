import UIKit

class CountPushWithoutContainerLabel: UILabel {
    
    var fullText = ""
    private let textsNotAnimated = [",", "."]
    
    func configure(with number: Int) {
        let text = number.formatted
        fullText = text
        clean()
        setupSubviews()
    }
    
    func animate() {
        animateSubviews()
    }
    
    private func clean() {
        self.text = nil
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupSubviews() {
        let stringArray = fullText.map { String($0) }
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        stringArray.enumerated().forEach { index, text in
            if text == "," || text == "." || text == "만" {
                let label = UILabel()
                label.frame.origin = CGPoint(x: x, y: y)
                label.textColor = textColor
                label.font = font
                label.text = text
                label.textAlignment = .center
                label.sizeToFit()
                self.addSubview(label)
                
                x += label.bounds.width
            } else {
                let label = CountdownSingleLabel()
                label.frame.origin = CGPoint(x: x, y: y)
                label.textColor = textColor
                label.font = font
                label.text = "0"
                label.textAlignment = .center
                label.sizeToFit()
                label.maxCount = Int(text) ?? 0
                self.addSubview(label)
                
                x += label.bounds.width
            }
        }
    }
    
    private func animateSubviews() {
        var currentAnimationRound = 1
        let singleLabels = self.subviews.compactMap { $0 as? CountdownSingleLabel }
        
        singleLabels.enumerated().forEach { index, label in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if index != 0 {
                    let beforeLabelMaxCount = singleLabels[index-1].maxCount
                    if label.maxCount < beforeLabelMaxCount {
                        currentAnimationRound += 1
                    }
                }
                label.animate(stopRound: currentAnimationRound)
            })
        }
    }
}

private class CountdownSingleLabel: UILabel {
    
    var counter = 0 {
        didSet {
            if counter > 9 {
                currentRound += 1
                counter = 0
            }
        }
    }
    
    var maxCount = 0
    var duration = 0.0
    
    var stopRound = 1
    var currentRound = 1
    
    func animate(duration: CFTimeInterval = 0.07, stopRound: Int = 1) {
        self.duration = duration
        self.currentRound = 1
        self.counter = 0
        self.stopRound = stopRound
        
        self.counter += 1
        self.text = "\(counter)"
        self.animate()
    }
    
    private func animate() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .moveIn
        animation.subtype = .fromTop
        animation.delegate = self
        
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
// MARK: CAAnimationDelegate
extension CountdownSingleLabel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if counter == maxCount && currentRound == stopRound {
            self.layer.removeAllAnimations()
            return
        }
        
        self.counter += 1
        self.text = "\(counter)"
        self.animate()
    }
}
