//
//  CircleButton.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

struct CircleButton: View {

    private let systemName: String
    private let action: () -> Void
    @State private var isHover: Bool = false

    init(systemName: String,
         action: @escaping () -> Void) {
        self.systemName = systemName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(Image(systemName: systemName))
                .foregroundColor(Color.cellBackground)
                .fontWeight(.black)
                .padding(4)
                .frame(width: 24, height: 24)
                .background(Circle().fill(isHover ? Color.primaryBlue.opacity(0.8) : Color.white).opacity(0.8))
        }
        .buttonStyle(.plain)
        .onHover { isHover = $0 }
    }
}
#if DEBUG
struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(systemName: "pencil") {

        }
    }
}
#endif
