//
//  Network.swift
//  Thursday
//
//  Created by Scott Begin on 10/5/22.
//

import Foundation
import SwiftUI


class Network: ObservableObject {
    
    @Published var contests: [Contest] = []
    @Published var entries: [Entry] = []
    @Published var entryPair: [Entry] = []
    @Published var mediaItems: [MediaItem] = []
    
    @StateObject var errorHandling = ErrorHandling()
    
    
    //let server = "http://127.0.0.1:8000/"
    let server = AppConstants.amazonEBUrl
    
    
    func getContestsByStatusAndOwner(status: String = "", ownerId: String = "") async throws -> [Contest] {
        var contests: [Contest] = []
        guard let url = URL(string: server+"thursday/contests/"+status+"?owner_id="+ownerId) else { fatalError("Missing URL") }
        
        do {
            try await contests = getContestsByUrl(url: url)
        } catch {
            print(error)
            throw error
        }
        return contests
    }
    
    func getContestsByStatusAndSearch(status: String = "", search: String = "") async throws  {

        guard let url = URL(string: server+"thursday/contests/"+status+"?search="+search) else { fatalError("Missing URL") }

        do {
            try await contests = getContestsByUrl(url: url)
        } catch {
            print(error)
            throw error
        }
    }
    
    func getContestsBySearch(search: String = "") async throws -> [Contest] {
        var contests: [Contest] = []
        guard let url = URL(string: server+"thursday/contests/"+"?search="+search) else { fatalError("Missing URL") }

            do {
                try await contests = getContestsByUrl(url: url)
            } catch {
                print(error)
                throw error
            }

        return contests
    }
    
    func getContestById(contestId: String) async throws -> Contest {
        var contests: [Contest] = []
        guard let url = URL(string: server+"thursday/contests/?contest_id="+contestId) else { fatalError("Missing URL") }
        
        do {
            try await contests = getContestsByUrl(url: url)
        } catch {
            print(error)
            throw error
        }
        return contests[0]
    }
    
    func getContestsByUrl(url: URL) async throws -> [Contest]{
        var contests: [Contest] = []
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.configSession.data(for: urlRequest)
            contests = try JSONDecoder().decode([Contest].self, from: data)
            
        } catch let error {
            print(error)
            throw error
        }
        
        return contests
    }
    
    
    func getEntriesByOwner(ownerId: String = "") async throws {
        guard let url = URL(string: server+"thursday/entries/"+"?owner_id="+ownerId) else { fatalError("Missing URL") }
        do {
            try await getEntriesByUrl(url: url)
        } catch let error {
            print(error)
            throw error
        }
        
    }
   
    func getEntriesToVoteOn(contestId: String, entryCount: String) async throws -> [Entry] {
        
        guard let url = URL(string: server+"thursday/entries/contest/"+"?contest_id="+contestId+"&limit="+entryCount) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.configSession.data(for: urlRequest)
            let decodedEntries = try JSONDecoder().decode([Entry].self, from: data)
            return decodedEntries
            
        } catch let error {
            print(error)
            throw error
        }
    }
    
    func getEntryPair(contestId: String) async throws -> [Entry] {
        
        guard let url = URL(string: server+"thursday/entries/pair/"+"?contest_id="+contestId) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.configSession.data(for: urlRequest)
            let decodedEntries = try JSONDecoder().decode([Entry].self, from: data)
            return decodedEntries
            
        } catch let error {
            print(error)
            throw error
        }
    }
    
    func getEntryLeaderboardByContest(id: String, limit: String) async throws {
        guard let url = URL(string: server+"thursday/entries/leaders/"+"?contest_id="+id+"&limit="+limit) else { fatalError("Missing URL") }
        do {
            try await getEntriesByUrl(url: url)
        } catch {
            print(error)
            throw error
        }
    }
    
    func getEntriesByUrl(url: URL) async throws {
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.configSession.data(for: urlRequest)
            let decodedEntries = try JSONDecoder().decode([Entry].self, from: data)
            self.entries = decodedEntries
        } catch {
            print(error)
            throw error
        }
        
                       
    }
    
    func getMediaItemsByOwner(ownerId: String = "") async throws {
        guard let url = URL(string: server+"thursday/mediaitems/?owner_id="+ownerId) else { fatalError("Missing URL") }
        do {
            try await self.mediaItems = getMediaItemsByUrl(url: url)
        } catch {
            print(error)
            throw error
        }
    }
    

    func getMediaItemsByUrl(url: URL) async throws -> [MediaItem] {
        var mediaItems: [MediaItem] = []
        let urlRequest = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.configSession.data(for: urlRequest)
            mediaItems = try JSONDecoder().decode([MediaItem].self, from: data)

        } catch let error {
            print("Error decoding: ", error)
            throw error
        }
        return mediaItems
    }
    
    func deleteMediaItemById(id: Int) async throws -> Bool {
        guard let url = URL(string: server+"thursday/mediaitems/"+String(id)) else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.configSession.data(for: urlRequest)
            print("Deleting media item: "+String(id))
//            print(response)
//            mediaItems = try JSONDecoder().decode([MediaItem].self, from: data)
            return true

        } catch let error {
            print("Error deleting: ", error)
            throw error
            return false
        }
    }

    
//    func createEntry(userId: String, contestId: String, videoUrl: String, thumbnailUrl: String, name: String) async throws {
//
//        let newId = try await String(createMediaItem(userId: userId, videoUrl: videoUrl, thumbnailUrl: thumbnailUrl, name: name) )
//
//        let json: [String: Any] = ["contest_id": contestId, "media_item": newId]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
////        let encodedData = try? JSONEncoder()
////            .encode(Entry(media_item: MediaItem(owner_id: Int(userId)!, video_url: videoUrl, thumbnail_url: thumbnailUrl), contest_id: Int(contestId)!))
////        print("Encoded Data:")
////        print(encodedData)
//
//        let url = URL(string: self.server+"thursday/entries/")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        do {
//            let (_, response) = try await URLSession.configSession.data(for: request)
//            print(response)
////            let jsonDecoder = JSONDecoder()
////            let loadData = try jsonDecoder.decode(Entry.self, from: data)
//        } catch let error {
//            throw error
//        }
//    }
    
    func createEntry(contestId: String, mediaItemId: String) async throws {

        let json: [String: Any] = ["contest_id": contestId, "media_item": mediaItemId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        

        let url = URL(string: self.server+"thursday/entries/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
            
        do {
            let (_, response) = try await URLSession.configSession.data(for: request)
            print(response)

        } catch let error {
            print(error)
            throw error
        }
    }
    
    func createMediaItem(userId: String, videoUrl: String, thumbnailUrl: String, caption: String, key: String) async throws -> Int {
        
        let encodedData = try? JSONEncoder().encode(MediaItem(name: caption, owner_id: Int(userId)!, video_url: videoUrl, thumbnail_url: thumbnailUrl, filename_key: key))
        
        // create post request
        let url = URL(string: server+"thursday/mediaitems/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
        request.httpBody = encodedData
        
        do {
            let (data, _) = try await URLSession.configSession.data(for: request)
            let jsonDecoder = JSONDecoder()
            let loadData = try jsonDecoder.decode(MediaItem.self, from: data)
            print(loadData)
            return loadData.media_item_id!
            
        } catch let error {
            print(error)
            throw error
        }
    }
    
//    func submitEntry(userId: String, contestId: String, localVideoURL: String, name: String) async throws{
//
//        let key = UUID().uuidString
//        let tempDir = FileManager.default.temporaryDirectory
//
//        let videoFileName = key+".mp4"
//        let awsVideoUrl = AppConstants.amazonS3Url+videoFileName
//
//        let imageFileName = key+".jpg"
//        let awsImageUrl = AppConstants.amazonS3Url+imageFileName
//        let localImageURL = tempDir.absoluteString+imageFileName
//        Task{
//            do {
//                let thumbImage = try await getThumbnailImageFromVideoUrl(url: URL(string: localVideoURL)!)
//                try await saveThumbnail(image: thumbImage, saveDir: tempDir, key: key)
//                try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: videoFileName , file: localVideoURL)
//                try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: imageFileName , file: localImageURL)
//                try await createEntry(userId: userId, contestId: contestId, videoUrl: awsVideoUrl, thumbnailUrl: awsImageUrl, name: name)
//                FileManager.default.clearTmpDirectory()
//            } catch {
//                self.errorHandling.handle(error: error, context: "SubmitEntryView submitEntry")
//                print(error)
//            }
//        }
//    }
    func submitMediaItem(userId: String, localVideoURL: String, caption: String) async throws -> Int {
//        var newId: Int
        
        let key = UUID().uuidString
        let tempDir = FileManager.default.temporaryDirectory
        
        let videoFileName = key+".mp4"
        let awsVideoUrl = AppConstants.amazonS3Url+videoFileName
        
        let imageFileName = key+".jpg"
        let awsImageUrl = AppConstants.amazonS3Url+imageFileName
        let localImageURL = tempDir.absoluteString+imageFileName
//        Task{
            do {
                let thumbImage = try await getThumbnailImageFromVideoUrl(url: URL(string: localVideoURL)!)
                try await saveThumbnail(image: thumbImage, saveDir: tempDir, key: key)
                try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: videoFileName , file: localVideoURL)
                try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: imageFileName , file: localImageURL)
                FileManager.default.clearTmpDirectory()
                return try await createMediaItem(userId: userId, videoUrl: awsVideoUrl, thumbnailUrl: awsImageUrl, caption: caption, key: key)
            } catch {
                print(error)
                throw error
            }
//        }
    }
    
//    func submitDraft(userId: String, localVideoURL: String, caption: String) async throws {
//        let key = UUID().uuidString
//        let tempDir = FileManager.default.temporaryDirectory
//        
//        let videoFileName = key+".mp4"
//        let awsVideoUrl = AppConstants.amazonS3Url+videoFileName
//        
//        let imageFileName = key+".jpg"
//        let awsImageUrl = AppConstants.amazonS3Url+imageFileName
//        let localImageURL = tempDir.absoluteString+imageFileName
//      
//        Task{
//            do {
//                let thumbImage = try await getThumbnailImageFromVideoUrl(url: URL(string: localVideoURL)!)
//                try await saveThumbnail(image: thumbImage, saveDir: tempDir, key: key)
//                try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: videoFileName , file: localVideoURL)
//                try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: imageFileName , file: localImageURL)
//                let _ = try await createMediaItem(userId: userId,  videoUrl: awsVideoUrl, thumbnailUrl: awsImageUrl, caption: caption, key: key)
//                
//                FileManager.default.clearTmpDirectory()
//            } catch {
//                self.errorHandling.handle(error: error, context: "SubmitEntryView submitDraft")
//                print(error)
//            }
//        }
//    }
    
    func castVote(voterId: String, entryChosen: String, entryDeclined: String) throws {
        let encodedData = try? JSONEncoder().encode(Vote(owner_id: Int(voterId)!, chosen: Int(entryChosen)!, declined: Int(entryDeclined)!))
        
        let url = URL(string: server+"thursday/vote/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData
        Task {
            do {
                let (data, _) = try await URLSession.configSession.data(for: request)
                let jsonDecoder = JSONDecoder()
                let loadData = try jsonDecoder.decode(Vote.self, from: data)
                print(loadData)
                
            } catch let error {
                print(error)
                throw error
            }
        }
        
    }
    
    func saveThumbnail(image: UIImage, saveDir: URL, key: String) async throws {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            print("Error with image")
            return
        }
        guard let directory = try? saveDir as NSURL else {
            print("Error with directory")
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent(key+".jpg")!)
            print("after try data.write: ")
            print(directory.appendingPathComponent(key+".jpg")!)
            
        } catch {
            print("in catch")
            print(error.localizedDescription)
            throw error
        }
    }
    
    func setProfilePhoto(userId: String, localPhotoUrl: String) async throws -> String {
        
        let key = UUID().uuidString
//        let tempDir = FileManager.default.temporaryDirectory
        let imageFileName = key+".jpg"
        let awsImageUrl = AppConstants.amazonS3Url+imageFileName
        
//        let json: [String: Any] = ["user_id": userId, "profile_pic": awsImageUrl]
        let json: [String: Any] = ["profile_pic": awsImageUrl]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
//        let encodedData = try? JSONEncoder().encode(MediaItem(owner_id: Int(userId)!, video_url: videoUrl, thumbnail_url: thumbnailUrl))
        
       
        let url = URL(string: server+"thursday/users/"+userId+"/")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            try await ServiceHandler().uploadFile(bucket: AppConstants.amazonS3BucketName, key: imageFileName , file: localPhotoUrl)
            let (data, response) = try await URLSession.configSession.data(for: request)
            print(response)
            print(String(data: data, encoding: String.Encoding.utf8)!)
            return await LoginManager().getUserById(id: userId).profile_pic!

            
        } catch let error {
            print(error)
            throw error
        }
    }
    
    func changePassword(newPassword1: String, newPassword2: String, oldPassword: String) async throws -> String{
      
        let json: [String: Any] = ["new_password1": newPassword1, "new_password2": newPassword2, "old_password": oldPassword]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: server+"dj-rest-auth/password/change/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.configSession.data(for: request)
            print(response)
            return String(data: data, encoding: String.Encoding.utf8)!
            
        } catch let error {
            print(error)
//            self.errorHandling.handle(error: error, context: "SubmitEntryView submitDraft")
            throw ThursError.registrationError(message: error.localizedDescription)
        }
    }
    
    
}

// This allows a computed value of 'configSession' to be available on URLSession type to set auth token
extension URLSession {
    static var configSession: URLSession {
        let config = URLSessionConfiguration.default
        print("Setting config token as: "+(UserDefaults.standard.string(forKey: "userToken") ?? ""))
        config.httpAdditionalHeaders = ["Authorization": "Token " + (UserDefaults.standard.string(forKey: "userToken") ?? "")]
        return URLSession(configuration: config)
    }
}
