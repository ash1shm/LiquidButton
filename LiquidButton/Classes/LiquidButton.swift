//
//  LiquidButton.swift
//  Pods
//
//  Created by Moin on 01/02/17.
//
//

import UIKit
@IBDesignable
public class LiquidButton: UIView {

    @IBInspectable public var buttonColor : UIColor = UIColor.init(red: 24.0/255.0, green: 163.0/255.0, blue: 246.0/255.0, alpha: 1.0);
    @IBInspectable public var buttonFinalColor : UIColor = UIColor.init(red: 0.0/255.0, green: 254.0/255.0, blue: 96.0/255.0, alpha: 1.0);
    @IBInspectable public var frameForButton : CGRect = CGRect(x: 0, y: 0, width: 200, height: 60)
    @IBInspectable public var cornerRadius : CGFloat = CGFloat(8);
    @IBInspectable public var buttonTitle : String = String(){
        didSet{
            self.headingLabel.text = buttonTitle
        }
    }
    
    private var lines: [CAShapeLayer]!
    @IBInspectable public var lineColor: UIColor! = UIColor(red: 250/255, green: 120/255, blue: 68/255, alpha: 1.0) {
        didSet {
            for line in lines {
                line.strokeColor = lineColor.cgColor
            }
        }
    }
    private let lineStrokeEnd = CAKeyframeAnimation(keyPath: "strokeEnd")
    private let lineOpacity = CAKeyframeAnimation(keyPath: "opacity")
    private let lineStrokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
    
    var finalFrame : CGRect = CGRect(x: 0, y: 0, width: 60, height: 60)
    let finalButtonWidth : CGFloat = CGFloat(60);
    
    @IBOutlet var mainVIew: UIView!
    @IBOutlet var headingLabel: UILabel!
    
    public var delegate : LiquidButtonProtocol? = nil;

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        UINib(nibName: "LiquidButton", bundle: Bundle.init(for: LiquidButton.self)).instantiate(withOwner: self, options: nil)
        addSubview(mainVIew);
        mainVIew.frame = self.bounds;
        self.mainVIew.backgroundColor = self.buttonColor;
        self.headingLabel.text = self.buttonTitle
        self.frameForButton = self.bounds;
        loadOtherComponents();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UINib(nibName: "LiquidButton", bundle: Bundle.init(for: LiquidButton.self)).instantiate(withOwner: self, options: nil)
        self.frameForButton = frame;
        self.mainVIew.backgroundColor = self.buttonColor;
        self.headingLabel.text = self.buttonTitle
        addSubview(mainVIew);
        mainVIew.frame = self.bounds;
        loadOtherComponents();
    }
    
    func loadOtherComponents() -> Void {
        
        
        self.lineStrokeEnd.duration = 0.0333 * 18
        self.lineStrokeEnd.duration = 0.0333 * 18
        
        self.finalFrame = CGRect(x: (self.mainVIew.frame.size.width / 2) - (self.finalButtonWidth / 2), y: self.mainVIew.frame.origin.y, width: self.finalButtonWidth, height: self.finalButtonWidth)
        
        self.mainVIew.layer.cornerRadius = cornerRadius;
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe(sender:)))
        self.mainVIew.isUserInteractionEnabled = true
        self.mainVIew.addGestureRecognizer(tap)
    }
    
    func tappedMe(sender: UITapGestureRecognizer) {
        
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.mainVIew.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.mainVIew.layer.cornerRadius = self.finalButtonWidth / 2;
                self.mainVIew.frame = self.finalFrame;
                self.headingLabel.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
//                self.headingLabel.text = "✔︎";
                self.headingLabel.text = "";
            }, completion: {
                (value : Bool) in
                self.startPulsing();
            });
        
    }
    
    func startPulsing() -> Void {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            UIView.setAnimationRepeatCount(2.0)
            self.mainVIew.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: {
            (check : Bool) in
            self.destroyInPulse();
        })
    }
    
    func destroyInPulse() -> Void {
        
        self.addLines();
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mainVIew.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            self.mainVIew.alpha = 0.0;
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mainVIew.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            self.mainVIew.alpha = 0.0;
        }, completion: {
            (check : Bool) in
            self.delegate?.buttonDidDisappear();
        })
    }
    
    func addLines() -> Void {
        let lineFrame = CGRect(x: 0,y: 0 , width: self.frame.size.width * 1.3,height: self.frame.size.height * 1.3)
        lines = []
        for i in 0 ..< 5 {
            let line = CAShapeLayer()
            line.bounds = lineFrame
            line.position = self.mainVIew.center
            line.masksToBounds = true
            line.actions = ["strokeStart": NSNull(), "strokeEnd": NSNull()]
            line.strokeColor = lineColor.cgColor
            line.lineWidth = 1.25
            line.miterLimit = 1.25
            line.path = {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: lineFrame.width / 2, y: lineFrame.height / 2))
                path.addLine(to: CGPoint(x: lineFrame.origin.x + lineFrame.width / 2, y: lineFrame.origin.y))
                return path
            }()
            line.lineCap = kCALineCapRound
            line.lineJoin = kCALineJoinRound
            line.strokeStart = 0.0
            line.strokeEnd = 0.0
            line.opacity = 0.0
            line.transform = CATransform3DMakeRotation(CGFloat(M_PI) / 5 * (CGFloat(i) * 2 + 1), 0.0, 0.0, 1.0)
            self.layer.addSublayer(line)
            lines.append(line)
        }
        lineStrokeStart.duration = 0.6 //0.0333 * 18
        lineStrokeStart.values = [
            0.0,    //  0/18
            0.0,    //  1/18
            0.18,   //  2/18
            0.2,    //  3/18
            0.26,   //  4/18
            0.32,   //  5/18
            0.4,    //  6/18
            0.6,    //  7/18
            0.71,   //  8/18
            0.89,   // 17/18
            0.92    // 18/18
        ]
        lineStrokeStart.keyTimes = [
            0.0,    //  0/18
            0.056,  //  1/18
            0.111,  //  2/18
            0.167,  //  3/18
            0.222,  //  4/18
            0.278,  //  5/18
            0.333,  //  6/18
            0.389,  //  7/18
            0.444,  //  8/18
            0.944,  // 17/18
            1.0,    // 18/18
        ]
        
        lineStrokeEnd.duration = 0.6 //0.0333 * 18
        lineStrokeEnd.values = [
            0.0,    //  0/18
            0.0,    //  1/18
            0.32,   //  2/18
            0.48,   //  3/18
            0.64,   //  4/18
            0.68,   //  5/18
            0.92,   // 17/18
            0.92    // 18/18
        ]
        lineStrokeEnd.keyTimes = [
            0.0,    //  0/18
            0.056,  //  1/18
            0.111,  //  2/18
            0.167,  //  3/18
            0.222,  //  4/18
            0.278,  //  5/18
            0.944,  // 17/18
            1.0,    // 18/18
        ]
        
        lineOpacity.duration = 1.0 //0.0333 * 30
        lineOpacity.values = [
            1.0,    //  0/30
            1.0,    // 12/30
            0.0     // 17/30
        ]
        lineOpacity.keyTimes = [
            0.0,    //  0/30
            0.4,    // 12/30
            0.567   // 17/30
        ]
        
        CATransaction.begin()
        
        for i in 0 ..< 5 {
            lines[i].add(lineStrokeStart, forKey: "strokeStart")
            lines[i].add(lineStrokeEnd, forKey: "strokeEnd")
            lines[i].add(lineOpacity, forKey: "opacity")
        }
        
        CATransaction.commit()

    }
}

public protocol LiquidButtonProtocol {
    func buttonDidDisappear();
}
