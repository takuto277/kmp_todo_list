package org.example.project.shared.viewmodel

import org.example.project.shared.models.Todo
import org.example.project.shared.repository.TodoRepository
import kotlinx.coroutines.flow.StateFlow

class TodoViewModel {
    private val repository = TodoRepository()
    
    val todos: StateFlow<List<Todo>> = repository.todos

    fun addTodo(title: String, todoDescription: String = "") {
        if (title.isNotBlank()) {
            repository.addTodo(title, todoDescription)
        }
    }

    fun toggleTodo(id: String) {
        repository.toggleTodo(id)
    }

    fun deleteTodo(id: String) {
        repository.deleteTodo(id)
    }

    fun updateTodo(id: String, title: String, todoDescription: String) {
        repository.updateTodo(id, title, todoDescription)
    }

    // iOS/Swift用のヘルパー関数
    fun getCurrentTodos(): List<Todo> {
        return todos.value
    }
}
