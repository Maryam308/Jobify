//
//  AnimationViewController.swift
//  tryingProject
//
//  Created by Maryam Ahmed on 11/12/2024.
//

import UIKit

class AnimationViewController: UIViewController{
    
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    @IBOutlet weak var ProgressLineView: UIView!
    
    
   
    
    
    @IBOutlet weak var progressLineWidthConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            startAnimation()
        }

    private func startAnimation() {
            // Calculate the target width, stopping 45 points before the frame's edge
            let targetWidth = self.view.frame.width - 90
            
            // Animate the width constraint of the progress line
            UIView.animate(withDuration: 2.0, animations: {
                self.progressLineWidthConstraint.constant = targetWidth
                self.view.layoutIfNeeded() // Updates the layout to reflect the change
            }) { _ in
                // After the progress line completes, zoom in on the logo
                self.zoomInLogo()
            }
        }

        private func zoomInLogo() {
            UIView.animate(withDuration: 1.5, animations: {
                self.imgLogo.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
                self.imgLogo.alpha = 0 // Fade out as it zooms in
            }) { _ in
                // Navigate to the next screen after the animation
                self.performSegue(withIdentifier: "finishAnimation", sender: self)
            }
        }
    
    
    
}
