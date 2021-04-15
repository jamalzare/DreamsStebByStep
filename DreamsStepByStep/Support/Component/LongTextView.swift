//
//  LongTextView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/6/21.
//

import Foundation
import SwiftUI

struct LongTextEditeView: View {
    @Environment(\.presentationMode) var presentaionMode
    var title: String = ""
    @Binding var bindedText: String
    @Binding var editMode: Bool?
    var onDone = {}
    var onDelete: (()->Void)?
    
    @State private var text: String = ""
    
    var body: some View {
        DynamicList {
            
            AppLabel(title: title)
            
//            MultiLineTextField(text: $text)
//                .frame(height: 300)
//                .padding(10)
//                .overlay(RoundedRectangle(cornerRadius: 40)
//                    .stroke(Color.black.opacity(0.1), lineWidth: 1))
//                .id(title.hashValue)
            AppTextEditor(text: $text)
                .id(title.hashValue)
            HStack{
                Spacer()
                AppButton(title: "Done"){ self.done() }
                if editMode !=  nil{
                    if editMode == true{
                        DeleteButton { self.delete() }
                    }
                }
                CancelButton{ self.dismiss() }
                Spacer()
            }
        }.padding(.top)
            .onAppear{
                self.text = self.bindedText
            }
    }
    
    func delete(){
        onDelete?()
        dismiss()
    }
    
    func done(){
        bindedText = text
        onDone()
        dismiss()
    }
    
    func dismiss(){
        text = ""
        presentaionMode.wrappedValue.dismiss()
    }
    
}

//struct LongTextView_Previews: PreviewProvider {
//
//    static var previews: some View {
////        LongTextEditeView(text: .constant("Something new")){
////            print("yes")
////        }
//    }
//}

struct MultiLineTextField: UIViewRepresentable{
    
    @Binding var text: String
    
    private let placeHolderColor = UIColor.black.withAlphaComponent(0.1)
    
    func makeCoordinator() -> MultiLineTextField.Coordinator {
        return MultiLineTextField.Coordinator(parent: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTextField>) -> UITextView {
        
        let tvView = UITextView()
        tvView.isEditable = true
        tvView.isUserInteractionEnabled = true
        tvView.isScrollEnabled = true
        tvView.text = text
        tvView.textColor = UIColor.black.withAlphaComponent(0.5)
        
        if text.isEmpty{
            tvView.text = "Type Here"
            tvView.textColor = placeHolderColor
        }
        
        
        tvView.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        
        tvView.delegate = context.coordinator
        
        tvView.backgroundColor = .clear
        return tvView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTextField>) {
        if text != "" || uiView.textColor != placeHolderColor{
            uiView.text = text
        }else{
            uiView.text = "Type Here"
        }
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        
        var parent: MultiLineTextField
        
        init(parent: MultiLineTextField){
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "Type Here" {
                textView.text = ""
            }
            textView.textColor = UIColor.black.withAlphaComponent(0.5)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = "Type Here"
                textView.textColor = parent.placeHolderColor
            }
        }
    }
}
