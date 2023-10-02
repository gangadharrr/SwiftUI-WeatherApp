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
    var onDismiss: ((_ model: String) -> Void)?
    @Binding var Location:String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
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
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
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
                            .animation(.easeInOut)
                        }
                    }.padding(.top,20)
                        Button("Search", systemImage:"location.magnifyingglass" , action:{
                            Location=text
                            onDismiss?(Location)
                            presentationMode.wrappedValue.dismiss()
                            }).foregroundColor(.white).padding(10).background( RoundedRectangle(cornerRadius: 8).fill(Color.blue)
                            )

                    Spacer()
                }
                
            }
        }
            
    
}

#Preview {
    LocationSearchView(Location: .constant("Pune"))
}
