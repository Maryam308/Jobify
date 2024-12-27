//
//  Filter.swift
//  Jobify
//
//  Created by Fatima Ali on 04/12/2024.
//

import Foundation
struct FilterSection {
    var title: String
    var isExpanded: Bool
    var items: [String]
    var selectedItems: Set<String> = []
}
