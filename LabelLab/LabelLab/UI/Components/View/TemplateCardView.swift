//
//  TemplateCardView.swift
//  LabelLab
//
//  Created by Chanhee Jeong on 2022/08/29.
//

import SwiftUI

enum TemplateCardViewType {
    case labelMaker
    case inspirations
}

struct TemplateCardView: View {
    @State var contents: Template
    @State var isOpen: Bool
    @State private var isHover: Bool = false
    var type: TemplateCardViewType = .labelMaker
    var clicked: (() -> Void)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                HStack(alignment: .top) {
                    Text(contents.name)
                        .font(.headline).bold()
                        .padding(.bottom, 12.5)
                    if isOpen {
                        Image("ic_lock_plain")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16 , height: 16)
                    }
                }
                Text(contents.templateDescription)
                    .font(.callout)
                Spacer()
                HStack(spacing: 5) {
                    ForEach(contents.tag, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.footnote).bold()
                    }
                }
            }
            .padding(.top, 5)
            Spacer()
            VStack{
                HStack(spacing: 6){
                    if isHover {
                        Button(action: {updateTemplateVisibility()}){
                            Image(isOpen ? "ic_lock" : "ic_unlock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24 , height: 24)
                        }
                        .buttonStyle(.borderless)
                        Button(action: {deleteTemplate()}){
                            Image("ic_trashcan")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24 , height: 24)
                        }
                        .buttonStyle(.borderless)
                    } else {
                        EmptyView()
                    }
                }
                Spacer()
            }
            .padding(.leading, 15)
        }
        .padding(EdgeInsets(top: 15, leading: 20, bottom: 17, trailing: 15))
        .frame(minWidth: 400)
        .frame(height: 118)
        .background(isHover
                    ? Color.primaryBlue.opacity(0.3)
                    : Color.darkGray)
        .cornerRadius(10)
        .onTapGesture {
            // TODO: PAGINATION
        }
        .onHover { hover in
            isHover = hover
        }
    }
}

// MARK: - Side Effects & Methods
private extension TemplateCardView {
    func updateTemplateVisibility() {
        isOpen = !isOpen
        // ???: Alert 을 띄워서 처리해야할수도있음
        // TODO: update template permission (isOpen)
        // TODO: refreshTemplates(of: User)
    }
    
    func deleteTemplate() {
        // TODO: show alert
    }
}



/*
struct TemplateCardView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCardView()
    }
}
*/
