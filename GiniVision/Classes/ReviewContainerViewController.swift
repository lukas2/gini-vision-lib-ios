//
//  ReviewContainerViewController.swift
//  GiniVision
//
//  Created by Peter Pult on 20/06/16.
//  Copyright © 2016 Gini. All rights reserved.
//

import UIKit

internal class ReviewContainerViewController: UIViewController, ContainerViewController {
    
    // Container attributes
    internal var containerView     = UIView()
    internal var contentController = UIViewController()
    
    // User interface
    fileprivate var continueButton = UIBarButtonItem()

    // Resources
    fileprivate let continueButtonResources = PreferredButtonResource(image: "navigationReviewContinue", title: "ginivision.navigationbar.review.continue", comment: "Button title in the navigation bar for the continue button on the review screen", configEntry: GiniConfiguration.sharedConfiguration.navigationBarReviewTitleContinueButton)
    
    fileprivate lazy var backButtonResources = PreferredButtonResource(image: "navigationReviewBack", title: "ginivision.navigationbar.review.back", comment: "Button title in the navigation bar for the back button on the review screen", configEntry: GiniConfiguration.sharedConfiguration.navigationBarReviewTitleBackButton)
    
    fileprivate lazy var closeButtonResources = PreferredButtonResource(image: "navigationCameraClose", title: "ginivision.navigationbar.camera.close", comment: "Button title in the navigation bar for the close button on the camera screen", configEntry: GiniConfiguration.sharedConfiguration.navigationBarCameraTitleCloseButton)
    
    // Output
    fileprivate var imageData: Data?
    fileprivate var changes = false
    
    init(imageData: Data) {
        super.init(nibName: nil, bundle: nil)
        
        self.imageData = imageData
        
        // Configure content controller and update image data on success
        contentController = ReviewViewController(imageData, success:
            { imageData in
                self.imageData = imageData
                self.changes = true
            }, failure: { error in
                print(error)
            })
        
        // Configure title
        title = GiniConfiguration.sharedConfiguration.navigationBarReviewTitle
        
        // Configure colors
        view.backgroundColor = GiniConfiguration.sharedConfiguration.backgroundColor
        
        // Configure continue button
        continueButton = GiniBarButtonItem(
            image: continueButtonResources.preferredImage,
            title: continueButtonResources.preferredText,
            style: .plain,
            target: self,
            action: #selector(analyse)
        )
        
        // Configure view hierachy
        view.addSubview(containerView)
        
        navigationItem.setRightBarButton(continueButton, animated: false)
        
        // Add constraints
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add content to container view
        displayContent(contentController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure back button. Needs to be done here because otherwise the navigation controller would be nil
        guard let _ = navigationItem.leftBarButtonItem else {
            setupLeftNavigationItem(usingResources: backButtonPreferredResource(), selector:#selector(back))
            return
        }
    }
    
    @IBAction func back() {
        let delegate = (navigationController as? GiniNavigationViewController)?.giniDelegate
        delegate?.didCancelReview?()
        if let navVC = navigationController {
            if navVC.viewControllers.count > 1 {
                _ = navVC.popViewController(animated: true)
            }else{
                navVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func backButtonPreferredResource() -> PreferredButtonResource {
        if let navVC = navigationController {
            if navVC.viewControllers.count > 1 {
                return backButtonResources
            }
        }
        return closeButtonResources
    }
    
    @IBAction func analyse() {
        let delegate = (self.navigationController as? GiniNavigationViewController)?.giniDelegate
        delegate?.didReview(imageData!, withChanges: changes)
        
        // Push analysis container view controller
        navigationController?.pushViewController(AnalysisContainerViewController(imageData: imageData!), animated: true)
    }
    
    // MARK: Constraints
    fileprivate func addConstraints() {
        let superview = self.view
        
        // Container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        ConstraintUtils.addActiveConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
        ConstraintUtils.addActiveConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)
        ConstraintUtils.addActiveConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
        ConstraintUtils.addActiveConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0)
    }
    
}
