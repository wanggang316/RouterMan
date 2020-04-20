//
//  RouterDelegate.swift
//  RouterMan
//
//  Created by gang wang on 2020/4/20.
//  Copyright © 2020 GUMP. All rights reserved.
//

import UIKit

public protocol RoutableTypeDelegate: class {
    func shouldShowController(_ controller: UIViewController,
                              fromViewController: UIViewController,
                              segueKind: SegueKind,
                              shouldShow: @escaping (Bool) -> Void)
    
    func willShowController(_ controller: UIViewController,
                            fromViewController: UIViewController,
                            segueKind: SegueKind)
    
    func didShownController(_ controller: UIViewController,
                            fromViewController: UIViewController,
                            segueKind: SegueKind)
}

public protocol RouterDelegate: RoutableTypeDelegate { }

extension RouterDelegate {
    public func shouldShowController(_ controller: UIViewController,
                                     fromViewController: UIViewController,
                                     segueKind: SegueKind,
                                     shouldShow: @escaping (Bool) -> Void) {
        shouldShow(true)
    }
    
    public func willShowController(_ controller: UIViewController,
                                   fromViewController: UIViewController,
                                   segueKind: SegueKind) { }
    
    public func didShownController(_ controller: UIViewController,
                                   fromViewController: UIViewController,
                                   segueKind: SegueKind) { }
}

extension RoutableTypeDelegate {
    public func shouldShowController(_ controller: UIViewController,
                                     fromViewController: UIViewController,
                                     segueKind: SegueKind,
                                     shouldShow: @escaping (Bool) -> Void) {
        shouldShow(true)
    }
    
    public func willShowController(_ controller: UIViewController,
                                   fromViewController: UIViewController,
                                   segueKind: SegueKind) { }
    
    public func didShownController(_ controller: UIViewController,
                                   fromViewController: UIViewController,
                                   segueKind: SegueKind) { }
}
