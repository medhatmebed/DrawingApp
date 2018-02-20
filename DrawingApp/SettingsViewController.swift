//
//  SettingsViewController.swift
//  DrawingApp
//
//  Created by medhat on 1/28/18.
//  Copyright © 2018 Medhatm3bd. All rights reserved.
//


import UIKit

protocol SettingsViewControllerDelegate: class {
    
    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController)
    
}

class SettingsViewController: UIViewController {
    
    var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var brushLabel: UILabel!
    
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var opacityLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    var brushWidth: CGFloat = 5.0
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var opacity: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        brushLabel.text = String(format: "Brush Size: %.0f", brushWidth)
        brushSlider.value = Float(brushWidth)
        
        opacityLabel.text = String(format: "Opacity: %.0f", opacity)
        opacitySlider.value = Float(opacity)
    
        redSlider.value = Float(red * 255)
        greenSlider.value = Float(green * 255)
        blueSlider.value = Float(blue * 255)

        redLabel.text = String(format: "%.0f", redSlider.value)
        greenLabel.text = String(format: "%.0f", greenSlider.value)
        blueLabel.text = String(format: "%.0f", blueSlider.value)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        self.updatePreview()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    @IBAction func brushSize(_ sender: Any) {
        
        brushWidth = CGFloat(round(brushSlider.value))
        brushLabel.text = String(format: "Brush Size: %.0f", brushWidth)
        
        self.updatePreview()
        
    }
    
    @IBAction func opacityChange(_ sender: Any) {
        
        opacity = CGFloat(opacitySlider.value)
        opacityLabel.text = String(format: "Opacity: %.1f", opacity)
        
        self.updatePreview()
        
    }
    
    @IBAction func redColour(_ sender: Any) {
        
        red = CGFloat(redSlider.value / 255)
        redLabel.text = String(format: "%.0f", redSlider.value)
        
        self.updatePreview()
        
    }
    
    @IBAction func greenColour(_ sender: Any) {
        
        green = CGFloat(greenSlider.value / 255)
        greenLabel.text = String(format: "%.0f", greenSlider.value)
        
        self.updatePreview()
    }
    
    @IBAction func blueColour(_ sender: Any) {
        
        blue = CGFloat(blueSlider.value / 255)
        blueLabel.text = String(format: "%.0f", blueSlider.value)
        
        self.updatePreview()
    }
    

    func updatePreview() {
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        
        context?.move(to: CGPoint(x: 120.0, y: 120.0))
        context?.addLine(to: CGPoint(x: 120.0, y: 120.0))
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
    
    
    
}
