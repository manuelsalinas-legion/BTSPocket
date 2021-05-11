//
//  UIColor+extensions.swift
//  BTSPocket
//
//

import Foundation
import UIKit

extension UIColor
{
    func hexdecimal(_ hexString: String, alpha: CGFloat? = 1.0) -> UIColor
    {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func intFromHexString(_ hexStr: String) -> UInt32
    {
        var hexInt: UInt32 = 0
        
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        
        return hexInt
    }
    
    convenience init(_ hex: UInt)
    {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor
{
    //MARK: MESSAGE COLORS
    class func success() -> UIColor
    {
        return UIColor(red:0.117647, green: 0.694118, blue: 0.541176, alpha: 1)
    }
    
    class func information() -> UIColor
    {
        return UIColor(red: 0.054902, green: 0.466667, blue: 0.866667, alpha: 1)
    }
    
    class func warning() -> UIColor
    {
        return UIColor(red: 1.000000, green: 0.968627, blue: 0.643137, alpha: 1)
    }
    
    //MARK: FLAT COLORS
    class func greenTurquoise() -> UIColor
    {
        return UIColor(red: 0.164706, green: 0.733333, blue: 0.611765, alpha: 1)
    }
    
    class func greenEmerald() -> UIColor
    {
        return UIColor(red: 0.223529, green: 0.796078, blue: 0.454902, alpha: 1)
    }
    
    class func greenUFO() -> UIColor
    {
        return UIColor(red: 0.227451, green: 0.831373, blue: 0.462745, alpha: 1)
    }
    
    class func greenNephritis() -> UIColor
    {
        return UIColor(red: 0.188235, green: 0.678431, blue: 0.384314, alpha: 1)
    }
    
    class func greenSea() -> UIColor
    {
        return UIColor(red: 0.137255, green: 0.623529, blue: 0.521569, alpha: 1)
    }
    
    class func greenMint() -> UIColor
    {
        return UIColor(red: 0.109804, green: 0.717647, blue: 0.580392, alpha: 1)
    }
    
    class func greenApple() -> UIColor
    {
        return UIColor(red: 0.423529, green: 0.686275, blue: 0.317647, alpha: 1)
    }
    
    class func greenJune() -> UIColor
    {
        return UIColor(red: 0.733333, green: 0.858824, blue: 0.380392, alpha: 1)
    }
    
    class func blueRiver() -> UIColor
    {
        return UIColor(red: 0.227451, green: 0.600000, blue: 0.850980, alpha: 1)
    }
    
    class func blueSummer() -> UIColor
    {
        return UIColor(red: 0.235294, green: 0.678431, blue: 0.870588 ,alpha: 1)
    }
    
    class func blueElectron() -> UIColor
    {
        return UIColor(red: 0.101961, green: 0.525490, blue: 0.878431, alpha: 1)
    }
    
    class func blueSky() -> UIColor
    {
        return UIColor(red:  0.447059, green: 0.639216, blue: 0.988235, alpha: 1)
    }
    
    class func blueBelize() -> UIColor
    {
        return UIColor(red: 0.184314, green: 0.505882, blue: 0.717647, alpha: 1)
    }
    
    class func blueDevil() -> UIColor
    {
        return UIColor(red: 0.152941, green: 0.439216, blue: 0.568627, alpha: 1)
    }
    
    class func blueGreek() -> UIColor
    {
        return UIColor(red: 0.227451, green: 0.294118, blue: 0.964706, alpha: 1)
    }
    
    class func purpleAmethyst() -> UIColor
    {
        return UIColor(red: 0.603922, green: 0.360784, blue: 0.705882, alpha: 1)
    }
    
    class func purpleWisteria() -> UIColor
    {
        return UIColor(red: 0.552941, green: 0.282353, blue: 0.670588, alpha: 1)
    }
    
    class func purpleExodus() -> UIColor
    {
        return UIColor(red: 0.423529, green: 0.380392, blue: 0.894118, alpha: 1)
    }
    
    class func purpleCove() -> UIColor
    {
        return UIColor(red: 0.074510, green: 0.066667, blue: 0.247059, alpha: 1)
    }
    
    class func purpleKoamaru() -> UIColor
    {
        return UIColor(red: 0.192157, green: 0.207843, blue: 0.411765, alpha: 1)
    }
    
    class func purpleLucky() -> UIColor
    {
        return UIColor(red: 0.176471, green: 0.176471, blue: 0.325490, alpha: 1)
    }
    
    class func blackAsphalt() -> UIColor
    {
        return UIColor(red: 0.207843, green: 0.286275, blue: 0.364706, alpha: 1)
    }
    
    class func blackMidnight() -> UIColor
    {
        return UIColor(red: 0.176471, green: 0.243137, blue: 0.309804, alpha: 1)
    }
    
    class func blackDracula() -> UIColor
    {
        return UIColor(red: 0.180392, green: 0.203922, blue: 0.211765, alpha: 1)
    }
    
    class func blackSteel() -> UIColor
    {
        return UIColor(red: 0.294118, green: 0.294118, blue: 0.294118, alpha: 1)
    }
    
    class func blackBaltic() -> UIColor
    {
        return UIColor(red: 0.239216, green: 0.239216, blue: 0.239216, alpha: 1)
    }
    
    class func yellowSun() -> UIColor
    {
        return UIColor(red: 0.941176, green: 0.764706, blue: 0.188235, alpha: 1)
    }
    
    class func yellowLemon() -> UIColor
    {
        return UIColor(red: 0.996078, green: 0.913725, blue: 0.670588, alpha: 1)
    }
    
    class func yellowBeekeeper() -> UIColor
    {
        return UIColor(red: 0.960784, green: 0.894118, blue: 0.572549, alpha: 1)
    }
    
    class func yellosYarow() -> UIColor
    {
        return UIColor(red: 0.988235, green: 0.792157, blue: 0.458824, alpha: 1)
    }
    
    class func yellowSand() -> UIColor
    {
        return UIColor(red: 0.921569, green: 0.796078, blue: 0.435294, alpha: 1)
    }
    
    class func yellowDesert() -> UIColor
    {
        return UIColor(red: 0.796078, green: 0.678431, blue: 0.403922, alpha: 1)
    }
    
    class func oranged() -> UIColor
    {
        return UIColor(red: 0.945098, green: 0.607843, blue: 0.172549, alpha: 1)
    }
    
    class func orangeCarrot() -> UIColor
    {
        return UIColor(red: 0.894118, green: 0.490196, blue: 0.192157, alpha: 1)
    }
    
    class func orangePumpkin() -> UIColor
    {
        return UIColor(red: 0.819608, green: 0.329412, blue: 0.098039, alpha: 1)
    }
    
    class func orangeVille() -> UIColor
    {
        return UIColor(red: 0.874510, green: 0.439216, blue: 0.349020, alpha: 1)
    }
    
    class func redAlizarin() -> UIColor
    {
        return UIColor(red: 0.898039, green: 0.301961, blue: 0.258824, alpha: 1)
    }
    
    class func redCarmine() -> UIColor
    {
        return UIColor(red: 0.913725, green: 0.305882, blue: 0.309804, alpha: 1)
    }
    
    class func redWatermelon() -> UIColor
    {
        return UIColor(red: 0.988235, green: 0.286275, blue: 0.356863, alpha: 1)
    }
    
    class func redPomegranate() -> UIColor
    {
        return UIColor(red: 0.745098, green: 0.227451, blue: 0.192157, alpha: 1)
    }
    
    class func whiteVirgin() -> UIColor
    {
        return UIColor(red: 1.000000, green: 1.000000, blue: 1.000000, alpha: 1)
    }
    
    class func whiteClouds() -> UIColor
    {
        return UIColor(red: 0.925490, green: 0.941176, blue: 0.945098, alpha: 1)
    }
    
    class func whiteSwan() -> UIColor
    {
        return UIColor(red: 0.968627, green: 0.945098, blue: 0.894118, alpha: 1)
    }
    
    class func silver() -> UIColor
    {
        return UIColor(red: 0.741176, green: 0.764706, blue: 0.780392, alpha: 1)
    }
    
    class func grayCity() -> UIColor
    {
        return UIColor(red: 0.874510, green: 0.901961, blue: 0.913725, alpha: 1)
    }
    
    class func grayConcrete() -> UIColor
    {
        return UIColor(red: 0.584314, green: 0.647059, blue: 0.650980, alpha: 1)
    }
    
    class func grayAbsestos() -> UIColor
    {
        return UIColor(red: 0.498039, green: 0.549020, blue: 0.552941, alpha: 1)
    }
    
    class func grayAmericanRiver() -> UIColor
    {
        return UIColor(red: 0.388235, green: 0.431373, blue: 0.443137, alpha: 1)
    }
    
    class func pinkPronus() -> UIColor
    {
        return UIColor(red: 0.901961, green: 0.278431, blue: 0.576471, alpha: 1)
    }
    
    class func pinkPico() -> UIColor
    {
        return UIColor(red: 0.984314, green: 0.482353, blue: 0.658824, alpha: 1)
    }
    
    class func pinkGlamour() -> UIColor
    {
        return UIColor(red: 0.992157, green: 0.466667, blue: 0.466667, alpha: 1)
    }
    
    class func pinkDate() -> UIColor
    {
        return UIColor(red: 0.972549, green: 0.694118, blue: 0.635294, alpha: 1)
    }
    
    class func brownStone() -> UIColor
    {
        return UIColor(red: 0.666667, green: 0.650980, blue: 0.615686, alpha: 1)
    }
    
    class func brownTooth() -> UIColor
    {
        return UIColor(red: 0.819608, green: 0.800000, blue: 0.756863, alpha: 1)
    }
    
    class func brownPorcelain() -> UIColor
    {
        return UIColor(red: 0.517647, green: 0.505882, blue: 0.478431, alpha: 1)
    }
}
