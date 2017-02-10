//
//  ViewControllerRootView.swift
//  TestSwiftUI
//
//  Created by Vladimir Budniy on 11/22/16.
//  Copyright © 2016 Vladimir Budniy. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewControllerRootView {
    
    associatedtype RootViewType
    
    var rootView: RootViewType { get }
}

public extension ViewControllerRootView where Self : UIViewController {
    
    var rootView: RootViewType {
        return self.view as! RootViewType
    }
}
