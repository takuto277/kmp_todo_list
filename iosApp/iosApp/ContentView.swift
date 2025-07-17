import SwiftUI
import Shared

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModelWrapper()
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.todos.isEmpty {
                    VStack(spacing: 16) {
                        Text("TODOがありません")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("＋ボタンで追加してください")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.todos, id: \.id) { todo in
                            TodoRow(
                                todo: todo,
                                onToggle: { viewModel.toggleTodo(id: todo.id) },
                                onDelete: { viewModel.deleteTodo(id: todo.id) }
                            )
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("TODOリスト")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTodo = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.loadTodos()
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteTodo(id: viewModel.todos[index].id)
        }
    }
}

struct TodoRow: View {
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                
                // todoDescriptionプロパティを使用
                let todoDesc = todo.todoDescription
                
                if !todoDesc.isEmpty {
                    VStack(alignment: .leading) {
                        Text(todoDesc)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            
                        // デバッグ情報を非表示テキストとして追加
                        Text("Debug: '\(todoDesc)'")
                            .hidden()
                            .onAppear {
                                debugPrint("Todo object: \(todo)")
                                debugPrint("Todo title: '\(todo.title)'")
                                debugPrint("Todo description: '\(todoDesc)'")
                                debugPrint("Description type: \(type(of: todoDesc))")
                            }
                    }
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModelWrapper
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var todoDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("TODO詳細") {
                    TextField("タイトル", text: $title)
                    TextField("説明（任意）", text: $todoDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("新しいTODO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("追加") {
                        viewModel.addTodo(title: title, todoDescription: todoDescription)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// ViewModelのSwiftUIラッパー
class TodoViewModelWrapper: ObservableObject {
    private let viewModel = TodoViewModel()
    @Published var todos: [Todo] = []
    
    init() {
        loadTodos()
    }
    
    func loadTodos() {
        // Kotlinの共通ロジックを使用
        let kotlinTodos = viewModel.getCurrentTodos()
        
        // KotlinのListは自動的にSwiftの配列([Todo])に変換される
        todos = kotlinTodos as! [Todo]
        
        // デバッグ情報の出力
        debugPrint("Loaded todos count: \(todos.count)")
        for todo in todos {
            debugPrint("Todo loaded: id=\(todo.id), title='\(todo.title)', desc='\(todo.todoDescription)'")
        }
    }
    
    func addTodo(title: String, todoDescription: String) {
        // Kotlinの共通ロジックを使用
        viewModel.addTodo(title: title, todoDescription: todoDescription)
        loadTodos()
    }
    
    func toggleTodo(id: String) {
        // Kotlinの共通ロジックを使用
        viewModel.toggleTodo(id: id)
        loadTodos()
    }
    
    func deleteTodo(id: String) {
        // Kotlinの共通ロジックを使用
        viewModel.deleteTodo(id: id)
        loadTodos()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}