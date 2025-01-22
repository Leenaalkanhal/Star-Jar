//
//  Untitled.swift
//  StarJar
//
//  Created by Leena  on 19/07/1446 AH.
//


import SwiftUI

struct TasksView: View {
    @State private var showOverlay = false // State to control the overlay visibility
    @State private var taskDescription = "" // User's description input
    @State private var detailsDescription = "" // User's description input for details
    @State private var selectedTime = 5 // Default timer duration (5 minutes)
    @State private var tasks: [Task] = [] // Store tasks (description + timer)
    @State private var editingTask: Task? = nil // Track the task being edited
    @State private var navigateToCharacter = false // State for navigation to CharacterSelectionView
    @State private var selectedTask: Task? = nil // Store the selected task for navigation
    @State private var selectedCharacter: String = "Alex" // Default character
    let day: Int // The day passed to this view

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea() // Ensure a proper background

                VStack(alignment: .leading, spacing: 16) {
                    // Title and "+" button on the same horizontal level
                    HStack {
                        Text("Tasks for Day \(day)")
                            .font(.system(size: 27, weight: .bold))
                           

                        Spacer() // Push the "+" button to the right

                        Button(action: {
                            editingTask = nil // Clear editing state for new task
                            showOverlay.toggle()
                        }) {
                            Image(systemName: "plus")
                                .font(.title3) // Slightly smaller button
                                .foregroundColor(.black) // Black color for the button
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5) // Adjust position

                    // Task List Section
                    List {
                        ForEach(tasks) { task in
                            HStack {
                                // Checkbox for marking task as completed
                                Button(action: {
                                    toggleTaskCompletion(task)
                                }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                }
                                .buttonStyle(PlainButtonStyle())

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(task.description)
                                        .font(.headline)
                                        .bold()
                                        .strikethrough(task.isCompleted, color: .gray)
                                        .foregroundColor(task.isCompleted ? .gray : .black)
                                    Text("Details: \(task.details)")
                                        .font(.subheadline)
                                        .foregroundColor(task.isCompleted ? .gray : .black)
                                    Text("Timer: \(task.timer) minutes")
                                        .font(.subheadline)
                                        .foregroundColor(task.isCompleted ? .gray : .black)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            .onTapGesture {
                                selectedTask = task // Save the selected task
                                navigateToCharacter = true // Trigger navigation
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                // Delete Action
                                Button(role: .destructive) {
                                    deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                // Edit Action
                                Button {
                                    editingTask = task
                                    taskDescription = task.description
                                    detailsDescription = task.details
                                    selectedTime = task.timer
                                    showOverlay = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                // Overlay for adding or editing tasks
                if showOverlay {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            VStack {
                                // Close button
                                HStack {
                                    Button(action: { showOverlay.toggle() }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Circle().fill(Color.black))
                                    }
                                    Spacer()
                                }
                                .padding()

                                // Form for task input
                                VStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Task Title")
                                            .fontWeight(.bold)
                                        TextEditor(text: $taskDescription)
                                            .placeholder("Enter task title...", show: taskDescription.isEmpty)
                                            .frame(minHeight: 60)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    }

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Details")
                                            .fontWeight(.bold)
                                        TextEditor(text: $detailsDescription)
                                            .placeholder("Enter task details...", show: detailsDescription.isEmpty)
                                            .frame(minHeight: 60)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    }

                                    VStack(alignment: .leading) {
                                        Text("Timer")
                                            .fontWeight(.bold)
                                        Picker("Select Timer", selection: $selectedTime) {
                                            ForEach([5, 10, 15, 20, 25, 30], id: \.self) { time in
                                                Text("\(time) min").tag(time)
                                            }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(height: 150)
                                    }

                                    HStack(spacing: 20) {
                                        Button(action: { showOverlay.toggle() }) {
                                            Text("Cancel")
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray.opacity(0.3))
                                                .foregroundColor(.black)
                                                .cornerRadius(8)
                                        }
                                        Button(action: {
                                            saveTask()
                                            showOverlay.toggle()
                                        }) {
                                            Text("Save")
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                        )
                        .transition(.opacity)
                }
            }
            .navigationDestination(isPresented: $navigateToCharacter) {
                if let task = selectedTask {
                    CharacterSelectionView(
                        selectedCharacter: $selectedCharacter,
                        timerDuration: task.timer
                    )
                }
            }
        }
    }

    // MARK: - Task Actions
    private func saveTask() {
        if let editingTask = editingTask, let index = tasks.firstIndex(where: { $0.id == editingTask.id }) {
            tasks[index].description = taskDescription
            tasks[index].details = detailsDescription
            tasks[index].timer = selectedTime
        } else {
            let newTask = Task(description: taskDescription, details: detailsDescription, timer: selectedTime)
            tasks.append(newTask)
        }
        clearInput()
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    private func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    private func clearInput() {
        taskDescription = ""
        detailsDescription = ""
        selectedTime = 5
        editingTask = nil
    }
}

// MARK: - Placeholder Extension
extension View {
    func placeholder(_ placeholder: String, show: Bool = true) -> some View {
        ZStack(alignment: .topLeading) {
            if show {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            self
        }
    }
}

// MARK: - Task Model
struct Task: Identifiable {
    var id = UUID()
    var description: String
    var details: String
    var timer: Int
    var isCompleted: Bool = false
}

// MARK: - Preview
#Preview {
    TasksView(day: 3)
}









