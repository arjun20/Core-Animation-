//
//  ViewController.swift
//  Core Animation
//
//  Created by Arjun on 09/08/19.
//  Copyright © 2019 Arjun. All rights reserved.
//

import UIKit

func degreeToRedians(deg: CGFloat ) -> CGFloat{
    return (deg * CGFloat.pi) / 180
}
class ViewController: UIViewController {
    
    let transformLayer = CATransformLayer()
    
    var currentOffeset  : CGFloat = 0
    var currentAngle    : CGFloat = 0
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        transformLayer.frame = self.view.bounds
        
        view.layer.addSublayer(transformLayer)

        turnCarousel()
        
        for i in 1 ... 8{
            addImageToCard(imgName: "\(i)")
        }
        
        let panGuestureReconizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.perfomaAction(reconizer:)))
        self.view.addGestureRecognizer(panGuestureReconizer)
    }
    
    func turnCarousel(){
        
        guard let trnasformSublayer = transformLayer.sublayers else{return}
        
        let segmentForImageCard = CGFloat(360 / trnasformSublayer.count)
        var angleOffset         =  currentAngle
        
        for layer in trnasformSublayer{
            var trnasform = CATransform3DIdentity
            trnasform.m34 = -1 / 1500
            trnasform     = CATransform3DRotate(trnasform, degreeToRedians(deg: angleOffset), 0, 1, 0)
            trnasform     = CATransform3DTranslate(trnasform, 0, 0, 280)
            
            CATransaction.setAnimationDuration(0)
            layer.transform = trnasform
            angleOffset += segmentForImageCard
        }
    }
    
    func addImageToCard(imgName : String){
        
        let imageCardSize = CGSize(width: 200, height: 300)
        let imageLayer    = CALayer()
        
        imageLayer.frame  = CGRect(x:  view.frame.size.width / 2 - imageCardSize.width / 2 , y:  view.frame.size.height / 2 - imageCardSize.height / 2 , width: imageCardSize.width, height: imageCardSize.height)
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let imageCard = UIImage(named: imgName)?.cgImage else{return}
        
        imageLayer.contents        = imageCard
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds   = true
        imageLayer.isDoubleSided   = true
        
        imageLayer.borderColor     = UIColor(white: 1, alpha: 0.5).cgColor
        imageLayer.borderWidth     = 5
        imageLayer.cornerRadius    = 10
        
        transformLayer.addSublayer(imageLayer)
        
    }
    @objc func perfomaAction(reconizer :UIPanGestureRecognizer){
        
        let xOffset = reconizer.translation(in: self.view).x
        
        if reconizer.state == .began{
            currentOffeset = 0
        }
        
        let xDiff   =  xOffset - currentOffeset
        
        currentOffeset += xDiff
        currentAngle   += xDiff
        
        turnCarousel()
    }


}

