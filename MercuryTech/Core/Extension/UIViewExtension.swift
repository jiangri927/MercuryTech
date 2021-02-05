//
//  UIViewExtension.swift
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit
import SnapKit
import QuartzCore

extension UIView {
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
    }
}

@IBDesignable extension UIView{
    @IBInspectable
    public var cornerRadius: CGFloat{
        set{
            self.layer.roundCorners(radius: newValue)
        }get{
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        set{
            self.layer.addShadow(radius: newValue)
        }get{
            return self.layer.shadowRadius
        }
    }
}

extension CALayer {
    func addShadow(radius: CGFloat) {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = radius
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        self.masksToBounds = true
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "shadow_layer" {
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "shadow_layer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}

//Flip, Rotate
extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        self.layer.transform = CATransform3DMakeRotation(toValue, 0, 0, 1);
    }
    
    func flip(flipped: Bool = true) {
        self.layer.transform = CATransform3DMakeRotation(flipped ? .pi : 0, 0, 0, 1);
//        let radian = atan2(self.transform.b, self.transform.a)
//        if radian == 0 {
//            self.layer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1);
//        }
//        else {
//            self.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
//        }
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

//Tap Action
extension UIView {
    func addTapAction(target: Any?, action: Selector?) {
        self.gestureRecognizers?.removeAll()
        
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(gesture)
    }
}

extension UIStackView {
    
    func safelyRemoveArrangedSubviews() {
        
        // Remove all the arranged subviews and save them to an array
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }
        
        // Deactive all constraints at once
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}


extension Array where Element: UIView {
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    for view in self {
        view.borderWidth = weight
        view.borderColor = color
    }
  }
  
  func roundBorders(cornerRadius: CGFloat = 10.0) {
    for view in self {
        view.cornerRadius = cornerRadius
    }
  }
    
    func changePlaceHolderColor() {
      for view in self {
        if view.isKind(of: UITextField.self) {
            let textfield = view as! UITextField
            textfield.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainBright])
        }
      }
    }
}

extension CALayer {
  func addShadow(withColor color: UIColor = .black, radius: CGFloat = 5, opacity: Float = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 1, customPath: CGPath? = nil) {
    shadowColor = color.cgColor
    shadowOffset = CGSize(width: offsetX, height: offsetY)
    shadowRadius = radius
    shadowOpacity = opacity
    shadowPath = customPath
    masksToBounds = false
  }
  
  func blink(withDuration duration: CFTimeInterval = 3, times: Float = .infinity, maxOpacity: Float = 1) {
    let maxValue = max(1, maxOpacity)
    let glow = CABasicAnimation(keyPath: "opacity")
    glow.fromValue = NSNumber(value: opacity)
    glow.toValue = NSNumber(value: maxValue)
    glow.autoreverses = true
    glow.repeatCount = times
    glow.duration = duration
    glow.isRemovedOnCompletion = false
    add(glow, forKey: "blinking-animation")
  }
}
extension CAGradientLayer {
  func makeBorder(withWidth width: CGFloat) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineWidth = width
    if let parent = superlayer {
      cornerRadius = parent.cornerRadius
      //Move to the top
      parent.addSublayer(self)
    }
    shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = UIColor.black.cgColor
    mask = shapeLayer
  }
}

extension UIView {
    
    func addGradientRed() {
        _ = self.addGradient(colors: [.redLight, .redMain], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientMain() {
        _ = self.addGradient(colors: [.mainBright, .mainDark], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientOrange() {
        _ = self.addGradient(colors: [.orangeBright, .orangeDark], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientPink() {
        _ = self.addGradient(colors: [.pinkBright, .pinkDark], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientSky() {
        _ = self.addGradient(colors: [.skyBright, .skyDark], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientPurple() {
        _ = self.addGradient(colors: [.purpleBright, .purpleDark], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientBlue() {
        _ = self.addGradient(colors: [.blueBright, .blueDark], direction: .leftToRight, locations: [10, 100])
    }
    func addGradientGreen() {
        _ = self.addGradient(colors: [.greenBright, .greenDark], direction: .leftToRight, locations: [10, 100])
    }
    
    func addGradientBkMain() {
        _ = self.addGradient(colors: [.redMain, .black], direction: .leftToRight, locations: [10, 100])
    }
    
    func addGradientBkMainTopBottom() {
        _ = self.addGradient(colors: [.redMain, .black], direction: .topToBottom, locations: [10, 100])
    }
}

public extension UIView {
    /**
     Get Set x Position
     
     - parameter x: CGFloat
     by DaRk-_-D0G
     */
    @objc internal var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    /**
     Get Set y Position
     
     - parameter y: CGFloat
     by DaRk-_-D0G
     */
    @objc internal var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    /**
     Get Set Height
     
     - parameter height: CGFloat
     by DaRk-_-D0G
     */
    @objc internal var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    /**
     Get Set Width
     
     - parameter width: CGFloat
     by DaRk-_-D0G
     */
    @objc internal var width:CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
}

extension UIView {
    //Animates **count** copies of ***image* with cubic waves up to the **topHeight** specified within the **duration** passed.
    func spread(image: UIImage, topHeight: Int, count: Int? = nil, duration: TimeInterval, elementSize: (min: Int, max: Int)) {
      let maxSpread = frame.size.width / 2
      let total = count ?? Int(arc4random_uniform(50))
      var images: [UIImageView] = []
      //Adds images randomly distributed in the X axis.
      for _ in 0..<total {
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        let size = Int(arc4random_uniform(UInt32(elementSize.max - elementSize.min)) + UInt32(elementSize.min))
        let randomX = Int(arc4random_uniform(UInt32(Int(frame.size.width) - size)))
        image.frame = CGRect(x: randomX,
                             y: Int(frame.size.height / 3),
                             width: size,
                             height: size)
        image.alpha = 0
        addSubview(image)
        images.append(image)
      }
      
      for image in images {
        let initialX = image.frame.origin.x
        let maxDelay = UInt32((duration * 0.25) * 100)
        let randomDelay = arc4random_uniform(100) % 2 == 0 ? Double(arc4random_uniform(maxDelay)) / 100.0 : 0
        
        //Movement limits
        let xShift = CGFloat(arc4random_uniform(UInt32(maxSpread)))
        let upTo = arc4random_uniform(UInt32(topHeight - topHeight / 2)) + UInt32(topHeight) / 2
        
        UIView.animateKeyframes(withDuration: duration, delay: randomDelay, options: .calculationModeCubicPaced, animations: {
          let randomPasses = arc4random_uniform(3) + 2
          var wave = arc4random_uniform(2) % 2 == 0
          for i in 0..<randomPasses {
            let start = Double(i) * (1 / Double(randomPasses))
            let dur = 1 / Double(randomPasses)
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: dur, animations: {
              image.frame.origin.x = initialX + (wave ? xShift : -xShift)
              image.frame.origin.y -= CGFloat(upTo / randomPasses * (i + 1))
            })
            wave = !wave
          }
          
          UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
            image.alpha = 1
          })
          UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
            image.alpha = 0
          })
        }, completion: { _ in
          image.removeFromSuperview()
        })
      }
    }
}

extension UIView{
    func bordered(lineWidth: CGFloat, strokeColor: UIColor = .contentBgColor){
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    func rounded(insets: UIEdgeInsets = .zero){
        let path = UIBezierPath.init(roundedRect: self.bounds.inset(by: insets), cornerRadius: self.frame.width/2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
