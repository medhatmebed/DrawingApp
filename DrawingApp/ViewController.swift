//
//  ViewController.swift
//  DrawingApp
//
//  Created by medhat on 1/28/18.
//  Copyright © 2018 Medhatm3bd. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var preSetStack: UIStackView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var hideState = false
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    @IBOutlet weak var label: UILabel!
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brushWidth: CGFloat = 5.0
    
    var opacity: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.brushSize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        
        if let touch = touches.first as UITouch! {
            
            lastPoint = touch.location(in: self.view)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = true
        
        if let touch = touches.first as UITouch! {
            
            let currentPoint = touch.location(in: view)
            drawLine(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            
            drawLine(lastPoint, toPoint: lastPoint)
            
        }
        
        UIGraphicsBeginImageContext(secondImage.frame.size)
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        secondImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        secondImage.image = nil

        
    }
    
    func drawLine(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        secondImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        secondImage.image = UIGraphicsGetImageFromCurrentImageContext()
        secondImage.alpha = opacity
        UIGraphicsEndImageContext()
        
        
        
    }
    
    @IBAction func red(_ sender: Any) {
        
        (red, green, blue) = (255, 0, 0)
        
    }
    
    @IBAction func green(_ sender: Any) {
        
        (red, green, blue) = (0, 255, 0)
        
    }
    
    @IBAction func blue(_ sender: Any) {
        
        (red, green, blue) = (0, 0, 255)
        
    }
    
    @IBAction func black(_ sender: Any) {
        
        (red, green, blue) = (0, 0, 0)
        
    }
    
    @IBAction func white(_ sender: Any) {
        
        (red, green, blue) = (255, 255, 255)
        
    }
    
    @IBAction func large(_ sender: Any) {
        
        brushWidth += 1
        self.brushSize()
    }
    
    @IBAction func small(_ sender: Any) {
        
        brushWidth -= 1
        self.brushSize()
    }
    
    func brushSize() {
        
        label.text = String(format: "%.0f", brushWidth)
        
        if brushWidth == 100 {
            
            plusButton.isEnabled = false
            plusButton.alpha = 0.25
            
        } else if brushWidth == 1 {
            
            minusButton.isEnabled = false
            minusButton.alpha = 0.25
            
        } else {
            
            plusButton.isEnabled = true
            minusButton.isEnabled = true
            plusButton.alpha = 1
            minusButton.alpha = 1
            
        }
        
    }
    
    
    @IBAction func reset(_ sender: Any) {
        
        imageView.image = nil
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brushWidth = brushWidth
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
        settingsViewController.opacity = opacity
        
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func hideReveal(_ sender: Any) {
        
        if hideState == false {
            
            preSetStack.isHidden = true
            resetButton.isHidden = true
            settingsButton.isHidden = true
            saveButton.isHidden = true

            hideButton.setTitle("Reveal", for: UIControlState.normal)
            
            hideButton.alpha = 0.2
            
            hideState = true
            
        } else {
            
            preSetStack.isHidden = false
            resetButton.isHidden = false
            settingsButton.isHidden = false
            saveButton.isHidden = false
            
            hideButton.setTitle("Hide", for: UIControlState.normal)
            
            hideButton.alpha = 1
            
            hideState = false
            
        }
        
        
        
    }
    
    
    
}

extension ViewController: SettingsViewControllerDelegate {
    
    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
        
        self.brushWidth = settingsViewController.brushWidth
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
        self.opacity = settingsViewController.opacity
        
        self.brushSize()
        
    }
    
}


















