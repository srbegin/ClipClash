//
//  ProfilePhotoChooser.swift
//  Thursday
//
//  Created by Scott Begin on 12/19/22.
//

import SwiftUI
import NukeUI

struct ProfilePhotoChooser: View {
    
    @State var user: User
    @State private var showingImagePicker = false
    @State private var newImageUrl: String?
    @State private var inputImage: UIImage?
    
    func loadImage() {
        let tempFileName = UUID().uuidString
        let tempURL = "file://"+NSTemporaryDirectory() + tempFileName + ".jpg"
        newImageUrl = tempURL
        Task {
            guard let inputImage = inputImage else { return }
            if let data = inputImage.jpegData(compressionQuality: 1.0) {
                    try? data.write(to: URL(string: tempURL)!)
                } else {
                    print("issue writing data")
                }
            
            do {
                self.newImageUrl = try await Network().setProfilePhoto(userId: String(self.user.user_id), localPhotoUrl: tempURL)
                FileManager.default.clearTmpDirectory()
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        
        
        HStack {
            Spacer()
            ZStack {
                
                LazyImage(source: !(newImageUrl ?? "").isEmpty ? newImageUrl : user.profile_pic , resizingMode: .aspectFill)
                    .clipShape(Circle())
                    .frame(width: 150, height: 150, alignment: .center)
                    .opacity(0.5)
                    .padding(.top)
                
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, alignment: .center)
                    .opacity(0.8)
                    .offset(y: 10)
            }.onTapGesture {
                showingImagePicker = true
            }
            
            Spacer()
        }.padding(.bottom, 15)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
    }
}

struct ProfilePhotoChooser_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoChooser(user: AppConstants.defaultUser)
    }
}
