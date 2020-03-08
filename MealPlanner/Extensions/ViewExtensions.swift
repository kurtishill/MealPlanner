//
//  ViewExtensions.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/7/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import SwiftUI

extension View {

    func onFrameChange(_ frameHandler: @escaping (CGRect)->(),
                    enabled isEnabled: Bool = true) -> some View {

        guard isEnabled else { return AnyView(self) }

        return AnyView(self.background(GeometryReader { (geometry: GeometryProxy) -> Color in

            let absoluteFrameOfBackgroundView = geometry.frame(in: .global)

            return Color.clear.beforeReturn {

                frameHandler(absoluteFrameOfBackgroundView)
            }
        }))
    }

    private func beforeReturn(_ onBeforeReturn: ()->()) -> Self {
        onBeforeReturn()
        return self
    }
}
