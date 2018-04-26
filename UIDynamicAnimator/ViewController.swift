//
//  ViewController.swift
//  UIDynamicAnimator
//
//  Created by Papoj Thamjaroenporn on 4/3/18.
//  Copyright © 2018 Papoj Thamjaroenporn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var resistanceSlider: UISlider!
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var resistanceLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    
    @IBOutlet weak var toolbarView: UIView!
    
    
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    private var itemBehavior: UIDynamicItemBehavior?
    
    private var resistance: CGFloat = 1.0 {
        didSet {
            updateResistance()
        }
    }
    private var damping: CGFloat = 1.0 {
        didSet {
            updateDamping()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: self.view)
        itemBehavior = UIDynamicItemBehavior(items: [followView])
        itemBehavior?.allowsRotation = false
        itemBehavior?.resistance = 0.0
        animator?.addBehavior(itemBehavior!)
        
//        resistance = 1.0
        damping = 1.0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let touchLocation = touch.location(in: self.view)
        
        if (self.toolbarView.frame.contains(touchLocation)) {
            return false
        }
        return true
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        
        let touchLocation = sender.location(in: sender.view)
        
        if sender.state == .began {
            snapBehavior = UISnapBehavior(item: followView, snapTo: touchLocation)
            snapBehavior?.damping = damping
            
            animator?.addBehavior(snapBehavior!)
        } else if sender.state == .changed {
            if let snapBehavior = snapBehavior {
                /**
                 Use the following line to restrict to y-axis only while dragging
                 */
                 snapBehavior.snapPoint = CGPoint(x: snapBehavior.snapPoint.x, y: touchLocation.y)
                
                /**
                 Use the following line to restrict to y-axis only while dragging
                 */
//                 snapBehavior.snapPoint = CGPoint(x: touchLocation.x, y: snapBehavior.snapPoint.y)
                
                /**
                 Use the following line to move normally while dragging
                 */
//                snapBehavior.snapPoint = touchLocation
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if let snapBehavior = snapBehavior {
                animator?.removeBehavior(snapBehavior)
            }
            snapBehavior = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateResistance() {
        resistanceSlider.value = Float(resistance)
        resistanceLabel.text = "\(resistance)"
        
        if let itemBehavior = itemBehavior {
            itemBehavior.resistance = resistance
        }
    }
    
    func updateDamping() {
        dampingSlider.value = Float(damping)
        dampingLabel.text = "\(damping)"
        if let snapBehavior = snapBehavior {
            snapBehavior.damping = damping
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        if sender == dampingSlider {
            damping = CGFloat(value)
        } else if sender == resistanceSlider {
            resistance = CGFloat(value)
        }
    }
    

}

