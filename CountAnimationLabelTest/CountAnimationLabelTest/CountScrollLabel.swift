
import UIKit

class CountScrollLabel: UILabel {
    
    var fullText = ""
    
    private var scrollLayers: [CAScrollLayer] = []
    private var scrollLabels: [UILabel] = []
    
    private let duration = 0.7
    private let durationOffset = 0.2
    
    private let textsNotAnimated = [",", "."]

    func configure(with number: Int) {
        let text = number.formatted
        fullText = text
        clean()
        setupSubviews()
    }
    
    func animate(ascending: Bool = true) {
        createAnimations(ascending: ascending)
    }

    private func clean() {
        self.text = nil
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        scrollLayers.removeAll()
        scrollLabels.removeAll()
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
                self.addSubview(label)
                
                x += label.bounds.width
            } else {
                let label = UILabel()
                label.frame.origin = CGPoint(x: x, y: y)
                label.textColor = textColor
                label.font = font
                label.text = "0"
                label.textAlignment = .center
                label.sizeToFit()
                createScrollLayer(to: label, text: text)
                
                x += label.bounds.width
            }
        }
    }
    
    private func createScrollLayer(to label: UILabel, text: String) {
        let scrollLayer = CAScrollLayer()
        scrollLayer.frame = label.frame
        scrollLayers.append(scrollLayer)
        self.layer.addSublayer(scrollLayer)
        
        createContentForLayer(scrollLayer: scrollLayer, text: text)
    }
    
    private func createContentForLayer(scrollLayer: CAScrollLayer, text: String) {
        var textsForScroll: [String] = []
        let number = Int(text)!
        
        textsForScroll.append("0")
        for i in 0...9 {
            textsForScroll.append(String((number + i) % 10))
        }
        textsForScroll.append(text)
        
        var height: CGFloat = 0
        for text in textsForScroll {
            let label = UILabel()
            label.text = text
            label.textColor = textColor
            label.font = font
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: height, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
            scrollLayer.addSublayer(label.layer)
            scrollLabels.append(label)
            height = label.frame.maxY
        }
    }
    
    private func createAnimations(ascending: Bool) {
        var offset: CFTimeInterval = 0.0
        
        for scrollLayer in scrollLayers {
            let maxY = scrollLayer.sublayers?.last?.frame.origin.y ?? 0.0
            
            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            animation.duration = duration + offset
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            if ascending {
                animation.fromValue = maxY
                animation.toValue = 0
            } else {
                animation.fromValue = 0
                animation.toValue = maxY
            }
 
            scrollLayer.scrollMode = .vertically
            // custom key 설정
            scrollLayer.add(animation, forKey: nil)
            scrollLayer.scroll(to: CGPoint(x: 0, y: maxY))
            
            offset += self.durationOffset
        }
    }
}
