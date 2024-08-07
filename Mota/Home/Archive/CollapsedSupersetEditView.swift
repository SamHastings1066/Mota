//
//  CollapsedSupersetEditView.swift
//  Mota
//
//  Created by sam hastings on 06/03/2024.
//

import SwiftUI

//struct CollapsedSupersetEditView: View {
//    @Bindable var superSet: SuperSet
//    @State var selectedSuperSet: SuperSet?
//    @State var isAddExercisePresented = false
//    @Environment(\.modelContext) private var context
//    var isEditable = true
//    
//    var body: some View {
//        
//        HStack {
//            VStack(alignment: .leading) {
//                ForEach( 0..<superSet.consistentExercises.count, id: \.self ) { exerciseNumber in
//                    EditableSingleSetRowCollapsedView(exercise: $superSet.consistentExercises[exerciseNumber], weight: $superSet.consistentWeights[exerciseNumber], reps: $superSet.consistentReps[exerciseNumber], isEditable: isEditable
//                    ) {
//                        superSet.removeExercise(superSet.consistentExercises[exerciseNumber])
//                    }
//                }
//                .onChange(of: superSet.exerciseRounds) { oldValue, newValue in
//                    print("SUPERSET CHANGED")
//                }
//                if isEditable {
//                    HStack {
//                        Spacer()
//                        if superSet.consistentExercises.count > 1 {
//                            Button {
//                                // use .onTapGesture
//                            } label: {
//                                Image(systemName: "arrow.up.arrow.down.square")
//                                    .imageScale(.large)
//                            }
//                            .onTapGesture {
//                                selectedSuperSet = superSet
//                            }
//                        }
//                        
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "plus")
//                        }
//                        .onTapGesture {
//                            isAddExercisePresented.toggle()
//                        }
//                        Spacer()
//                    }
//                    .padding(.top, 10)
//                    .popover(item: $selectedSuperSet) { _ in
//                        RearrangeExerceriseRoundsView(superSet: superSet)
//                    }
//                    .onChange(of: selectedSuperSet, { _, _ in
//                        // TODO: Change this approach. superSet is a Bindable, therefore changing it will not update the view. must use a change in the selectedSuperSet State var to update the view when the order of exercises change.
//                    })
//                    .onChange(of: isAddExercisePresented, { _, _ in
//                        // TODO: Change this approach. superSet is a Bindable, therefore changing it will not update the view. must use a change in the isAddExercisePresented State var to update the view when an exercise is added.
//                    })
//                    .fullScreenCover(isPresented: $isAddExercisePresented)
//                    {
//                        NavigationStack {
//                            AddExerciseView() { exercise in
//                                context.insert(exercise)
//                                superSet.updateExerciseRound(with: exercise)
//                                isAddExercisePresented.toggle()
//                            }
//                            .navigationBarItems(
//                                leading: Button(action: {
//                                    isAddExercisePresented.toggle()
//                                }) {
//                                    Text("Cancel")
//                                }
//                                
//                            )
//                        }
//                        .navigationBarTitle("Add Exercise", displayMode: .inline)
//                    }
//                }
//            }
//            Spacer()
//            VStack(alignment: .center){
//                VStack {
//                    Text("Rounds")
//                        .font(.headline)
//                    if isEditable {
//                        TextField("", value: $superSet.numRounds, formatter: NumberFormatter())
//                            .fixedSize()
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.numberPad)
//                    } else {
//                        Text("\(superSet.numRounds)")
//                    }
//                }
//                
//                VStack {
//                    Text("Rest")
//                        .font(.headline)
//                    if isEditable {
//                        TextField("", value: $superSet.consistentRest, formatter: NumberFormatter())
//                            .fixedSize()
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.numberPad)
//                    } else {
//                        Text("\(superSet.consistentRest.map{ "\($0)" } ?? "-")")
//                    }
//                }
//            }
//            .padding(.all, 10)
//            .background(Color(UIColor.systemGray5))
//            .cornerRadius(10)
//            .fixedSize(horizontal: true, vertical: false)
//        }
//        .onAppear{
//            context.insert(superSet)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}

//#Preview {
//    var dummySuperset = SuperSet(singleSets: [SingleSet(exercise: databaseExercises[0], weight: 50, reps: 5)], rest: 60, numRounds: 8)
//    return Group {
//        CollapsedSupersetEditView(superSet: dummySuperset, selectedSuperSet: nil, isAddExercisePresented: false, isEditable: false)
//        Text("Edit mode:")
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding()
//        CollapsedSupersetEditView(superSet: dummySuperset, selectedSuperSet: nil, isAddExercisePresented: false, isEditable: true)
//    }
//}
