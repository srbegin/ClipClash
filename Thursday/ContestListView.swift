//
//  ContestListView.swift
//  Thursday
//
//  Created by Scott Begin on 10/5/22.
//

import SwiftUI
import NukeUI


struct ContestListView: View {
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State var contests: [Contest] = []
    @State var isModal: Bool = false
    @State var isPresentingContest: Contest? = nil
    @State var contestBrowsingStatus = ContestStatus.all
    @State private var searchText = ""
    @State var searching = false
    
    var body: some View {
        
        VStack {
            HStack {
                
                LazyImage(source: userState.userModel.profile_pic, resizingMode: .aspectFill)
                    .clipShape(Circle())
                    .frame(width: 70, height: 70, alignment: .topLeading)
                    .padding(.leading, 8)
                
                SearchBar(searchText: $searchText, searching: $searching.onChange(searchChange(_:)))
            }
            
            
            Picker("", selection: $contestBrowsingStatus.onChange(statusChange)) {
                //Text(ContestStatus.all.rawValue.capitalized).tag(ContestStatus.all)
                Text("Vote").foregroundColor(Color.black).tag(ContestStatus.active)
                Text("Enter").tag(ContestStatus.open).foregroundColor(Color.black)
                //Text("Past").tag(ContestStatus.past).foregroundColor(Color.black)
                Text("Upcoming").tag(ContestStatus.future).foregroundColor(Color.black)
                        }
                        .pickerStyle(.segmented)
            HStack {
                Text(contestBrowsingStatus.rawValue.capitalized+" Contests").font(Font.h4).foregroundColor(Color.black).padding(.leading)
                Spacer()
            }
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    ForEach(network.contests, id: \.id) { contest in
                        HStack(alignment:.top) {
                            ContestListItem(contest: contest, contestListItemType: .list)
                            
                        }.onTapGesture {
                            isPresentingContest = contest
                          }
                        .frame(alignment: .leading)
                        .padding()
                        .background(.white)
                    }.fullScreenCover(item: $isPresentingContest) {contest in
                        ContestDetailView(contest: contest) 
                    }
                }
            }
            .task {
                self.contestBrowsingStatus = userState.contestBrowsingStatus!
                do {
                   try await refreshContests()
                } catch {
                    self.errorHandling.handle(error: error, context: "ContestListView")
                    print(error)
                }
            }.gesture(DragGesture()
                .onChanged({ _ in
                    UIApplication.shared.dismissKeyboard()
                })
            )

        }
            .background(Color.white)
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func statusChange(_ tag: ContestStatus) {
        userState.contestBrowsingStatus = tag
        searchText = ""
        Task {
            do {
                try await refreshContests()
            } catch {
                self.errorHandling.handle(error: error, context: "ContestListView statusChange")
                print(error)
            }
        }
    }
    
    func searchChange(_ tag: Bool) {
        if !searching {
            Task {
                do {
                    try await refreshContests()
                } catch {
                    self.errorHandling.handle(error: error, context: "ContestListView searchChange")
                    print(error)
                }
            }
        }
    }
    
    //TODO: Make backend route for all
    func refreshContests() async throws {
        if (contestBrowsingStatus == .all) {
            try await network.getContestsByStatusAndSearch(status: "", search: searchText)
        } else {
            try await network.getContestsByStatusAndSearch(status: contestBrowsingStatus.rawValue, search: searchText)
        }
    }
}


extension UIApplication {
      func dismissKeyboard() {
          sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

struct ContestListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContestListView(contestBrowsingStatus: ContestStatus.open).environmentObject(Network())
    }
}
