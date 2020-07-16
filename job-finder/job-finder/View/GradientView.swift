import UIKit

class GradientView: UIView {
    
    public var gradientLayer: CAGradientLayer!
    
    var topColor: UIColor = #colorLiteral(red: 0.2099078894, green: 0.5850914121, blue: 0.8388919234, alpha: 1)
    var bottomColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    
    var shadowColor: UIColor = .clear
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = -3
    
    var shadowBlur: CGFloat = 3
    var startPointX: CGFloat = 0
    var startPointY: CGFloat = -1
    
    var endPointX: CGFloat = -1
    var endPointY: CGFloat = 0.5
       
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
    }
}
