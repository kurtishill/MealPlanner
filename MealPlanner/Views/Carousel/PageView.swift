//
//  PageView.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/14/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI

struct PageView<T>: View where T : View {
    var viewControllers: [UIHostingController<T>] = []
    
    @State var currentPage: Page = Page.Current
    
    @EnvironmentInject var appViewModel: AppViewModel
    
    init(_ views: [T]) {
//        views.forEach { self.viewControllers.insert(UIHostingController(rootView: $1), at: $0.rawValue) }
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }
    
    var body: some View {
        PageViewController(controllers: viewControllers, currentPage: self.$currentPage) { page in
            switch page {
            case .Before:
                self.appViewModel.calendarState.lastMonthTapped()
            case .After:
                self.appViewModel.calendarState.nextMonthTapped()
            default:
                fatalError()
            }
        }
    }
}

enum Page: Int {
    case Current = 0
    case After = 1
    case Before = 2
    
    struct Factory {
        static func make(value: Int) -> Page {
            switch value {
            case 0:
                return Page.Before
            case 1:
                return Page.Current
            case 2:
                return Page.After
            default:
                fatalError()
            }
        }
    }
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView()
//    }
//}
