import UIKit

class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    var topColor: UIColor = #colorLiteral(red: 0.9959616065, green: 0.2667768896, blue: 0, alpha: 1)
    var bottomColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0.2008001506, alpha: 1)
    
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
