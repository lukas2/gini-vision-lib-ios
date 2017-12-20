//
//  ContainerNavigationController.swift
//  GiniVisionExample
//
//  Created by Enrique del Pozo Gómez on 12/19/17.
//  Copyright © 2017 Gini. All rights reserved.
//

import UIKit

final class ContainerNavigationController: UIViewController {
    
    var rootViewController: UINavigationController
    var coordinator: GiniScreenAPICoordinator?
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.isIpad ? .all : .portrait
    }
    
    init(rootViewController: UINavigationController, parent: GiniScreenAPICoordinator) {
        self.rootViewController = rootViewController
        self.coordinator = parent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChildViewController(rootViewController)
        view.addSubview(rootViewController.view)
        rootViewController.willMove(toParentViewController: self)
        rootViewController.didMove(toParentViewController: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootViewController.view.frame = self.view.bounds
    }
}

