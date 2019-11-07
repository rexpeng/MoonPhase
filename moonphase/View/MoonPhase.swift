//
//  Utils.swift
//  moonphase
//
//  Created by Rex Peng on 2019/11/6.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

@IBDesignable
class MoonPhase: UIView {
    let synmonth = 29.530588853

    
    var date: Date = Date() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var moonBackgroundColor: UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var moonForegroundColor: UIColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1) {
        willSet {
            
        }
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func jDays(year: Int, month: Int, day: Int) -> Double {
        //if year < -400000 || year > 400000 {
        //   return 0
        //}
        let yp = Double(year) + floor((Double(month)-3) / 10)
        var initValue: Double
        var jdy: Double
        if (year>1582) || (year==1582 && month>10) || (year==1582 && month==10 && day>=15) {
            initValue = 1721119.5
            jdy=floor(yp*365.25)-floor(yp/100)+floor(yp/400);
        } else if (year<1582) || (year==1582 && month<10) || (year==1582 && month==10 && day<=4) {
            initValue = 1721117.5;
            jdy=floor(yp*365.25);
        } else {
            return 0
        }
        let mp = (month + 9) % 12
        let jdm = mp*30+Int((mp+1)*34/57);
        let jdd=day-1;
        //var jdh=12/24;
        let jd=jdy+Double(jdm)+Double(jdd)+0.5+initValue;
        return jd;
    }
    
    private func MeanNewMoonDay(jd: Double) -> Double {
        //k為從2000年1月6日14時20分36秒起至指定年月日之陰曆月數,以synodic month為單位
        let k = floor((jd - 2451550.09765) / synmonth) //2451550.09765為2000年1月6日14時20分36秒之JD值。
        let jdt = 2451550.09765 + k * synmonth
        //Time in Julian centuries from 2000 January 0.5.
        let t = (jdt - 2451545) / 36525;//以100年為單位,以2000年1月1日12時為0點
        let thejd = jdt + 0.0001337*t*t - 0.00000015*t*t*t + 0.00000000073*t*t*t*t;
        //2451550.09765為2000年1月6日14時20分36秒，此為2000年後的第一個均值新月
        return thejd;
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let imageData = moonImage.data(using: .utf8)
        let decodeData = Data(base64Encoded: imageData!)
        let image = UIImage(data: decodeData!)
        //let image = UIImage(named: "moon")
        backgroundColor = .clear
        layer.sublayers = nil
        let componts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let jd = jDays(year: componts.year!, month: componts.month!, day: componts.day!)
        let mn = MeanNewMoonDay(jd: jd)
        let p = (jd - mn) / synmonth
        let phai = CGFloat(p) * 2.0 * CGFloat.pi
        
        var ad: CGFloat = 0
        let blackColor = moonBackgroundColor//.withAlphaComponent(1)
        let whiteColor = moonForegroundColor//.withAlphaComponent(1)
        var colorIndex = 0
        if phai <= 0.5*CGFloat.pi {
            colorIndex = 0
            ad=0;
        } else if phai <= CGFloat.pi {
            colorIndex = 1
            ad=0;
        } else if phai <= 1.5*CGFloat.pi {
            colorIndex = 1
            ad=1;
        } else if phai <= 2*CGFloat.pi {
            colorIndex = 0
            ad=1;
        }
        
        //let aDegree = CGFloat.pi / 180
        let center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        let radius = min(rect.width, rect.height)*0.5
        
        // method 1
        let blackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let blackLayer = CAShapeLayer()
        blackLayer.path = blackPath.cgPath
        blackLayer.fillColor = blackColor.cgColor
        //layer.addSublayer(blackLayer)
        
        let whitePath = UIBezierPath()
        if ad == 0 {
            whitePath.addArc(withCenter: center, radius: radius, startAngle: (1.5+ad)*CGFloat.pi, endAngle: (2.5+ad)*CGFloat.pi, clockwise: true)
        } else {
            whitePath.addArc(withCenter: center, radius: radius, startAngle: (2.5+ad)*CGFloat.pi, endAngle: (1.5+ad)*CGFloat.pi, clockwise: false)
        }
        var y: CGFloat = radius
        while y >= -radius {
            let m = CGFloat(sqrtf(Float(radius*radius-CGFloat(y*y)))*cosf(Float(phai)))
            if ad == 0 {
                whitePath.addLine(to: CGPoint(x: center.x+m, y: center.y+CGFloat(y)))
            } else {
                whitePath.addLine(to: CGPoint(x: center.x-m, y: center.y+CGFloat(y)))
            }
            y -= 0.1
        }
        let moonLayer = CAShapeLayer()
        moonLayer.path = whitePath.cgPath
        moonLayer.fillColor = whiteColor.cgColor
        //layer.addSublayer(moonLayer)
        
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: center.x-radius, y: center.y-radius, width: radius*2, height: radius*2)
        imageLayer.position = center
        imageLayer.contents = image?.cgImage
        imageLayer.mask = moonLayer
        layer.addSublayer(imageLayer)
        // method 2
//        let ovalWidth = CGFloat(sqrtf(Float(radius*radius))*cosf(Float(phai)))
//        let mPath = UIBezierPath(ovalIn: CGRect(x: center.x-ovalWidth, y: center.y-radius, width: ovalWidth*2, height: radius*2))
//        let blackPath = UIBezierPath()
//        blackPath.addArc(withCenter: center, radius: radius, startAngle: (0.5+ad)*CGFloat.pi, endAngle: (1.5+ad)*CGFloat.pi, clockwise: true)
//        let whitePath = UIBezierPath()
//        whitePath.addArc(withCenter: center, radius: radius, startAngle: (1.5+ad)*CGFloat.pi, endAngle: (2.5+ad)*CGFloat.pi, clockwise: true)
//        if colorIndex == 1 {
//            whitePath.append(mPath)
//        } else {
//            blackPath.append(mPath)
//        }
//
//        let blackLayer = CAShapeLayer()
//        blackLayer.path = blackPath.cgPath
//        blackLayer.fillColor = blackColor.cgColor
//
//        let whiteLayer = CAShapeLayer()
//        whiteLayer.path = whitePath.cgPath
//        whiteLayer.fillColor = whiteColor.cgColor
//
//        if colorIndex == 1 {
//            layer.addSublayer(blackLayer)
//            layer.addSublayer(whiteLayer)
//        } else {
//            layer.addSublayer(whiteLayer)
//            layer.addSublayer(blackLayer)
//        }
    }
    
    func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x+p2.x)*0.5, y: (p1.y+p2.y)*0.5)
    }
    
    func controlPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPointForPoints(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)
        if p1.y < p2.y {
            controlPoint.y += diffY
        } else {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
    

}
