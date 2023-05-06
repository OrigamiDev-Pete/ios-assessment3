//
//  RoundedView.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

@IBDesignable class RoundedView: UIControl {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var round: Bool = false {
        didSet {
            if round {
                layer.cornerRadius = layer.frame.width / 2
            }
        }
    }

}
