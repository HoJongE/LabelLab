//
//  LabelCollectionView.swift
//  LabelLab
//
//  Created by Chanhee Jeong on 2022/08/29.
//

import SwiftUI

struct LabelCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.injected) private var diContainer: DIContainer
    @EnvironmentObject private var appState: AppState
    
    @State var gridLayout = [ GridItem() ]
    @State var templateMockdata = Template.mockedData // MARK: only for ui-task
    
    var body: some View {
        NavigationView {
            /* SIDEBAR */
            VStack {
                Text("메뉴1")
                Text("메뉴2")
                Text("메뉴3")
            }
            /* CONTENT */
            VStack {
                headerView
                content()
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 28, bottom: 0, trailing: 28))
        }
    }
}

// MARK: - UI Componenets
private extension LabelCollectionView {
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Issue Label Maker")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.white80)
            
            HStack {
                Text("Your Label Collection")
                    .font(.system(.title)).bold()
                Spacer()
                BasicButton(text: "New Collection", type: .primary) {
                    // TODO:  New Collection
                }
            }
            
            Divider()
        }
    }

}


// MARK: - emptyView
private extension LabelCollectionView {
    func emptyView() -> some View {
        VStack{
            Spacer()
            HStack(alignment: .center){
                VStack{
                    Image("ic_flask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45 , height: 45)
                    Text("Ouhh.. it’s empty in here")
                        .font(.system(.title3)).bold()
                    Group {
                        Text("Once you make a label collection,")
                        Text("you’ll see them here")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color.white80)
                }
            }
            Spacer()
        }
    }
}

// MARK: - LabelListView
private extension LabelCollectionView {
    func labelListView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 400))]) {
                ForEach($templateMockdata) { $template in
                    TemplateCardView(contents: template, isOpen: template.isOpen) {
                        print(template.id)
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity)        
    }
}


// MARK: - Content
private extension LabelCollectionView {
    @ViewBuilder
    func content() -> some View {
        if (Template.mockedData.count == 0) {
            emptyView()
        } else {
            labelListView()
        }
    }
}


// MARK: - Preview
#if DEBUG
struct LabelCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        LabelCollectionView()
    }
}
#endif
