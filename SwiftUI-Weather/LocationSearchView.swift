//
//  LocationSearchView.swift
//  SwiftUI-Weather
//
//  Created by Gangadhar C on 9/29/23.
//

import SwiftUI

struct LocationSearchView: View {
    @State var text=""
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    HStack{
                        TextField("Search ...", text: $text)
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                isEditing=true
                                isFocused=true
                            }.focused($isFocused)
                        if isEditing {
                            Button(action: {
                                self.isEditing=false
                                self.isFocused=false
                                self.text = ""
                            }, label: {
                                Text("Cancel")
                            })
                            .padding(.trailing, 10)
                            .transition(.move(edge: .trailing))
                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: 0.5)
                        }
                    }
                    NavigationLink("",destination:ContentView(Location: .constant("pune")))
                        Button("Search", systemImage:"location.magnifyingglass" , action:{
                            dismiss()
                            }).foregroundColor(.white).padding(10).background( RoundedRectangle(cornerRadius: 8).fill(Color.blue)
                            )
                    
                    Spacer()
                }
                
            }
        }
            
    }
}

#Preview {
    LocationSearchView()
}
