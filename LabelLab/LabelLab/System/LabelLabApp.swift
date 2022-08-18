//
//  LabelLabApp.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/07/18.
//

import FirebaseCore
import SwiftUI

@main
struct LabelLabApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
