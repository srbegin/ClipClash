////
////  ContestPickerModal.swift
////  Thursday
////
////  Created by Scott Begin on 10/21/22.
////
//
//import SwiftUI
//
//struct ContestPickerModal: View {
//    
//    @Binding var isPresented: Bool
//    
//    @EnvironmentObject var network: Network
//    @EnvironmentObject var userState: UserState
//    
//    //@State var isModal: Bool = false
//    @State private var isPresentingContest: Contest? = nil
//    @State var contestStatus: ContestStatus
//    @State private var searchText = ""
//    @State var searching = false
//    
//    enum ContestStatus: String {
//        case all = "all" //TODO: Make backend route for all
//        case future = "future"
//        case open = "open"
//        case active = "active"
//        case past = "past"
//    }
//    
//    
//    
//    
//    var body: some View {
//        
//        VStack {
//            SearchBar(searchText: $searchText, searching: $searching.onChange(searchChange(_:)))
//            //Segmented control, TODO: iterate through enum instead
//          
//            ScrollView {
//                VStack(alignment: .leading) {
//                      
//                    ForEach(network.contests, id: \.id) { contest in
//                        HStack(alignment:.top) {
//                            Text("\(contest.id!)")
//
//                            VStack(alignment: .leading) {
//                                Text(contest.name)
//                                    .bold()
//                            }
//                        }.onTapGesture {
//                            //isPresented = false
//                            isPresentingContest = contest
//                          }
//                        
//                        .frame(width: 300, alignment: .leading)
//                        .padding()
//                        .background(Color(#colorLiteral(red: 0.6667672396, green: 0.7527905703, blue: 1, alpha: 0.2662717301)))
//                        .cornerRadius(20)
//                    }.sheet(item: $isPresentingContest) {contest in
//                        ContestDetailView(contest: contest)
//                    }
//                }
//                    }
//                    .onAppear {
//                        network.getContestsByStatusAndSearch(status: contestStatus.rawValue, search: searchText)
//                    }.gesture(DragGesture()
//                        .onChanged({ _ in
//                            UIApplication.shared.dismissKeyboard()
//                        })
//            )
//
//        }//.background(Color.black.edgesIgnoringSafeArea(.all))
//            //.edgesIgnoringSafeArea(.all)
//            .navigationBarHidden(true)
//    }
//    
////    func statusChange(_ tag: ContestStatus) {
////        searchText = ""
////        network.getContestsByStatusAndSearch(status: contestStatus.rawValue, search: searchText)
////        }
////
//    func searchChange(_ tag: Bool) {
//        if !searching {
//            network.getContestsByStatusAndSearch(status: contestStatus.rawValue, search: searchText)
//        }
//        }
//}
//
//
//
//
//struct ContestPickerModal_Previews: PreviewProvider {
//    
//    @State static var presented = false
//    static var previews: some View {
//        ContestPickerModal(isPresented: $presented, contestStatus: ContestPickerModal.ContestStatus.open).environmentObject(Network())
//    }
//}
