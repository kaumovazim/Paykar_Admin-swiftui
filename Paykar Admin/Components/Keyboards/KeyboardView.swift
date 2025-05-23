//
//  KeybordView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct KeyboardView: View {
    @Binding var value: String
    @State var guest = false
    @State var row = ["1","2","3","4","5","6","7","8","9","","0","delete"]
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack{
            Spacer()
            GeometryReader{ reader in
                VStack{
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 3), alignment: .center, spacing: 10) {
                        ForEach(row,id: \.self){ value in
                            Button(action: {buttonAction(value)}){
                                ZStack{
                                    if value == "delete"{
                                        Image("delete-keyboard")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .foregroundColor(Color("Accent"))
                                            .font(.title3)
                                    } else{
                                        Text(value)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("Accent"))
                                            .font(.largeTitle)
                                    }
                                }
                                .frame(width: getWidth(frame: reader.frame(in: .global)), height: getHeight(frame: reader.frame(in: .global)))
                                
                            }
                            .disabled(value == "" ? true : false)
                        }
                    }
                }
            }
            ///MARK::FOR IPAD CHECK
            .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height > 700 ?  UIScreen.main.bounds.height/2.5  : UIScreen.main.bounds.height/2.5 - 20, alignment: .bottom)
            .padding()
            .padding()
            .padding(.bottom, guest ? 60 : 0)
            .background(colorScheme == .light ?  Color("Secondary").opacity(0.7).ignoresSafeArea(.all, edges: .bottom) : Color("Secondary").opacity(0.3).ignoresSafeArea(.all, edges: .bottom))
            .mask(RoundedRectangle(cornerRadius: 30))
        }
    }
    
    func buttonAction(_ value: String){
        if value == "delete" && self.value != ""{
            self.value.removeLast()
        }
        if value != "delete"{
            self.value.append(value)
        }
    }
    
    func getWidth(frame: CGRect) -> CGFloat{
        let width = frame.width
        let actualWidth = width - 60
        return actualWidth/3
    }
    
    func getHeight(frame: CGRect) -> CGFloat{
        let height = frame.height
        let actualHeight = height - 30
        return actualHeight/4
    }
}


