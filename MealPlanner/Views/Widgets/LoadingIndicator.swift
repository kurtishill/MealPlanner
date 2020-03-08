//
//  LoadingIndicator.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/29/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct LoadingIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<LoadingIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {

    var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    LoadingIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 4,
                       height: geometry.size.height / 7.5)
                .background(Color("loadingModalColor"))
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
                .shadow(radius: 4)
                .zIndex(2)

            }
        }
    }

}
