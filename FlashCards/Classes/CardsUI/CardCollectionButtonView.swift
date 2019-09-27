//
//  CardCollectionButtonView.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 26/09/2019.
//

import UIKit

class CardCollectionButtonView: UIView {

    var nextPressedCallback: (()->())?
    var previousPressedCallback: (()->())?
    
    var styleManager: StyleManager? {
        didSet {
            applyColorScheme()
        }
    }
    
    private let nextButton: UIButton
    private let previousButton: UIButton
    
    override init(frame: CGRect) {
        self.nextButton = UIButton.autolayoutView()
        self.previousButton = UIButton.autolayoutView()
        
        super.init(frame: frame)
        
        addSubview(nextButton)
        addSubview(previousButton)
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonPressed(sender:)), for: .touchUpInside)
        
        nextButton.imageView?.contentMode = .scaleAspectFit
        let imageNext = UIImage(named: "next-card-icon")?.withRenderingMode(.alwaysTemplate)
        nextButton.setImage(imageNext, for: .normal)
        
        previousButton.imageView?.contentMode = .scaleAspectFit
        let imagePrevious = UIImage(named: "prev-card-icon")?.withRenderingMode(.alwaysTemplate)
        previousButton.setImage(imagePrevious, for: .normal)
        
        setUpLayout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            previousButton.topAnchor.constraint(equalTo: topAnchor),
            previousButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            previousButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    @objc private func nextButtonPressed(sender: UIButton) {
        nextPressedCallback?()
    }
    
    @objc private func previousButtonPressed(sender: UIButton) {
        previousPressedCallback?()
    }
    
    @objc private func applyColorScheme() {
        nextButton.imageView?.tintColor = styleManager?.currentColorScheme.navBarBackgroundColor
        previousButton.imageView?.tintColor = styleManager?.currentColorScheme.navBarBackgroundColor
    }
}
