import UIKit

class CountPushLabel: UILabel {
    
    var fullText = ""
    
    private weak var container: UIView?
    private let textsNotAnimated = [",", "."]
    
    func configure(with number: Int) {
        let text = number.formatted
        fullText = text
        clean()
        setupContainer(width: width(of: number))
        setupSubviews()
    }
    
    func animate() {
        animateSubviews()
    }
    
    private func clean() {
        self.text = nil
        container?.subviews.forEach { $0.removeFromSuperview() }
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupContainer(width: CGFloat) {
        let container = UIView()
        container.frame.origin = CGPoint(x: 0, y: 0)
        container.frame.size = CGSize(width: width, height: self.bounds.height)
        container.clipsToBounds = true
        self.addSubview(container)
        
        self.container = container
    }
    
    private func setupSubviews() {
        let stringArray = fullText.map { String($0) }
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        stringArray.enumerated().forEach { index, text in
            if textsNotAnimated.contains(text) {
                let label = UILabel()
                label.frame.origin = CGPoint(x: x, y: y)
                label.textColor = textColor
                label.font = font
                label.text = text
                label.textAlignment = .center
                label.sizeToFit()
                container?.addSubview(label)
                
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
                container?.addSubview(label)
                
                x += label.bounds.width
            }
        }
    }
    
    private func animateSubviews() {
        let countdownSingleLabels = container?.subviews.compactMap { $0 as? CountdownSingleLabel }
        guard let singleLabels = countdownSingleLabels else { return }

        var currentAnimationRound = 1
        
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
    
    func width(of number: Int) -> CGFloat {
        let text = number.formatted
        var width: CGFloat = 0.0
        text.forEach { char in
            if textsNotAnimated.contains(String(char)) {
                let label = UILabel()
                label.font = font
                label.text = String(char)
                label.textAlignment = .center
                label.sizeToFit()
                width += label.bounds.width
            } else {
                let label = UILabel()
                label.font = font
                label.text = "0"
                label.textAlignment = .center
                label.sizeToFit()
                width += label.bounds.width
            }
        }
        return width
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
        self.stopRound = stopRound
        
        self.currentRound = 1
        self.counter = 0
        
        self.counter += 1
        self.text = "\(counter)"
        self.animate()
    }
    
    private func animate() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .push
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
