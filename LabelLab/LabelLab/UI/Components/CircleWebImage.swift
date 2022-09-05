//
//  CircleWebImage.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct CircleWebImage: View {
    let url: URL?
    let width: CGFloat

    init(url: URL?, width: CGFloat = 15) {
        self.url = url
        self.width = width
    }

    init(url: String?, width: CGFloat = 15) {
        if let url = url {
            self.url = URL(string: url)
        } else {
            self.url = nil
        }
        self.width = width
    }

    var body: some View {
        WebImage(url: url)
            .resizable()
            .placeholder(content: {
                Rectangle().fill(.cyan)
            })
            .indicator(.activity)
            .scaledToFit()
            .transition(.fade)
            .frame(width: width, height: width, alignment: .center)
            .clipShape(Circle())
    }
}

struct CircleWebImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleWebImage(url: UserInfo.hojonge.profileImage ?? "")
    }
}
