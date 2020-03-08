//
//  Model.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/5/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift

protocol BaseDto {
    var id: String { get set }
    
    func getChildrenObjects<T>() -> List<T>? where T : BaseDto
}
