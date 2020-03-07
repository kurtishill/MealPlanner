//
//  EditableIngredientRow.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import RxSwift

struct EditableIngredientRow: View {
    @State var id: String
    @State var name: String
    @State var notes: String
    var onNameEdited: (String) -> Void
    var onNotesEdited: (String) -> Void
    var onDelete: () -> Void
    
    @Binding var listOffset: CGFloat
    @State var keyboardHeight: CGFloat = 0
    @State var keyboardIsShowing: Bool = false
    
    @State var scrollViewItems: [String:ScrollViewItem] = [:]
    
    private let bag = DisposeBag()
    
    private func delay(for time: Int = 100, _ update: @escaping () -> Void) {
        Observable<NSInteger>.interval(RxTimeInterval.milliseconds(time), scheduler: MainScheduler())
        .take(1)
        .subscribe(onNext: { _ in
            update()
        }).disposed(by: self.bag)
    }
    
    private func textFieldFocusChanged(_ changed: Bool) {
        if changed {
            self.delay {
                print("started")
                let itemPosition = self.scrollViewItems[self.id]
                print(self.keyboardHeight)
                
                if let position = itemPosition?.position {
                    print("Position for \(self.name) = \(position)")
                    self.listOffset = position - self.keyboardHeight
                }
            }
        } else {
            self.delay {
                print("done")
                print(self.keyboardHeight)
            }
        }
    }
    
    var body: some View {
        let nameBinding = Binding<String>(get: {
            self.name
        }) {
            self.name = $0
            self.onNameEdited($0)
        }
        
        let notesBinding = Binding<String>(get: {
            self.notes
        }, set: {
            self.notes = $0
            self.onNotesEdited($0)
        })
        
        return HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                TextField("Name", text: nameBinding, onEditingChanged: { changed in
                    self.textFieldFocusChanged(changed)
                })
                    .autocapitalization(.none)
                    .padding(.all, 1)
                    .frame(width: UIScreen.main.bounds.width - 80)
                    .background(Color("ingredientTextFieldColor"))
                    .mask(RoundedRectangle(cornerRadius: 5))
                HStack {
                    TextField("Notes", text: notesBinding, onEditingChanged: { changed in
                        self.textFieldFocusChanged(changed)
                    })
                        .autocapitalization(.none)
                        .padding(.all, 1)
                        .frame(width: UIScreen.main.bounds.width - 80)
                        .background(Color("ingredientTextFieldColor"))
                        .mask(RoundedRectangle(cornerRadius: 5))
                }
            }.padding(.leading, 8)
            
            Button(action: {
                self.onDelete()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color("mainColor"))
                    .padding(.trailing, 12)
            }
        }.onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                self.keyboardHeight = value.height
                self.keyboardIsShowing = true
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                self.listOffset = 0
                self.keyboardHeight = 0
                self.keyboardIsShowing = false
            }
        }.onFrameChange({ (frame) in
            if !self.keyboardIsShowing || self.scrollViewItems[self.id] == nil {
                DispatchQueue.main.async {
                    self.scrollViewItems[self.id] = ScrollViewItem(id: self.id, position: frame.origin.y)
                }
            }
        })
    }
}

struct ScrollViewItem {
    let id: String
    let position: CGFloat
}

//struct EditableIngredientRow_Previews: PreviewProvider {
//    static var previews: some View {
//        EditableIngredientRow()
//    }
//}
