//
//  ListButtonView.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

@IBDesignable class ListButtonView: RoundedView {
    
    @IBOutlet weak var header: RoundedView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    @IBInspectable var headerColour: UIColor = UIColor.systemYellow {
        didSet {
            header.backgroundColor = headerColour
        }
    }
    
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var amount: Int = 0 {
        didSet {
            amountLabel.text = String(amount)
        }
    }
    
    private func configureView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ListButtonView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        // Set background to be transparent so that the rounded corners show correctly.
        self.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0))
        view.frame = self.bounds
        self.addSubview(view)
        
        // Enable interaction events
        isUserInteractionEnabled = true
        view.isUserInteractionEnabled = false
    }
}
