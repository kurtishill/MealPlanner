//
//  PageView Controller.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/14/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import UIKit
import SwiftUI

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Page
    var pageChanged: (_: Page) -> Void
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[self.currentPage.rawValue]],
            direction: .forward,
            animated: true
        )
    }
    
    func makeCoordinator() -> PageViewController.Coordinator {
        Coordinator(self)
    }
    
    internal class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(_ pageViewController: UIPageViewController,
                                viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
            
            if index == 0 {
                return self.parent.controllers.last
            }
            
            return self.parent.controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index + 1 == self.parent.controllers.count {
                return self.parent.controllers.first
            }
            
            return self.parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController,
                                didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
                                transitionCompleted completed: Bool)
        {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = self.parent.controllers.firstIndex(of: visibleViewController)
            {
                let newPage = Page.Factory.make(value: index)
                
                self.parent.currentPage = newPage
                
                self.parent.pageChanged(newPage)
            }
        }
    }
}
