//
//

import UIKit


extension UIView
{
    //MARK: SIZE ADJUSTMENTS
    func fixSize(_ size: CGSize)
    {
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: size.width))
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: size.height))
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat = 10)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.layer.mask = mask
    }
    
    //MARK: BORDER LINES
    ///This function add a border to the view
    func addBorder(edges: UIRectEdge, color: UIColor = UIColor.white, thickness: CGFloat = 1)
    {
        // Usage:
        /*
         myView.addBorder(edges: [.All]) // All with default arguments
         myView.addBorder(edges: [.Top], colour: UIColor.greenColor()) // Just Top, green, default thickness
         myView.addBorder(edges: [.Left, .Right, .Bottom], colour: UIColor.redColor(), thickness: 3) // All except Top, red, thickness
         */
        
        func border() -> UIView
        {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["top": top]))
            self.addSubview(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["left": left]))
            self.addSubview(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["right": right]))
            self.addSubview(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-(0)-[bottom]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["bottom": bottom]))
            self.addSubview(bottom)
        }
    }
    
    func setUnavailable()
    {
        self.alpha = 0.8
        self.isUserInteractionEnabled = false
    }
    
    func setAvailable()
    {
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    func setBorder()
    {
        self.layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        self.layer.borderWidth = 1
    }
    
    func setBorderAndCornerRadius()
    {
        self.layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        self.layer.borderWidth = 1
        
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
      
    func setBorder(_ color: UIColor)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func setBorderWidth(_ width: CGFloat)
    {
        self.layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        self.layer.borderWidth = width
    }
    
    func setBorder(_ width: CGFloat, color: UIColor, cornerRadius: Bool)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        
        if cornerRadius == true
        {
            self.layer.cornerRadius = 3
            self.clipsToBounds = true
        }
    }
    
    func setBorder(_ width: CGFloat, color: UIColor, radius: CGFloat)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func clearBorder()
    {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    func cornerRadius()
    {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    
    func round()
    {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    func roundAndShadow()
    {
        let round = self.frame.width / 2
        self.cornerRadius(round)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
    }
    
    func addShadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 5, height: -6)
        self.layer.shadowRadius = 10
    }
    
    func hideShadow()
    {
        self.layer.shadowOpacity = 0.0
    }
    
    func addRoundShadow(_ radius: CGFloat, shadowRadius: CGFloat = 1.0)
    {
        self.cornerRadius(radius)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
    
    func cornerRadius(_ radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    //MARK: BLURS
    ///Blur Style Dark
    func blur()
    {
        let visuaEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visuaEffectView.frame = bounds
        visuaEffectView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        visuaEffectView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(visuaEffectView)
    }
    
    ///Blur Style Light
    func blurLight()
    {
        //Remove previous blur effect views
        self.subviews.forEach({
            
            if $0.isKind(of: UIVisualEffectView.self)
            {
                $0.removeFromSuperview()
            }
        })
        
        let visuaEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visuaEffectView.frame = bounds
        visuaEffectView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        visuaEffectView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(visuaEffectView)
    }
    
    ///remove Blur
    func removeBlur()
    {
        self.subviews.forEach({
            
            if $0.isKind(of: UIVisualEffectView.self)
            {
                $0.removeFromSuperview()
            }
        })
    }
    
    //MARK: ANIMATIONS
    ///Animations to make a view shaking. Useful when something is wrong
    func shake()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    //MARK: CHILD VIEWS MANAGEMENT
    ///This is the function to get subViews of a view of a particular type
    func subViews<T : UIView>(type : T.Type) -> [T]
    {
        var all = [T]()
        for view in self.subviews
        {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    ///This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]
    {
        var all = [T]()
        func getSubview(view: UIView)
        {
            if let aView = view as? T{
                all.append(aView)
            }
            
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

