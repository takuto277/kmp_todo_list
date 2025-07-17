package org.example.project.shared.repository

import org.example.project.shared.models.Todo
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.datetime.Clock
import kotlin.random.Random

class TodoRepository {
    private val _todos = MutableStateFlow<List<Todo>>(emptyList())
    val todos: StateFlow<List<Todo>> = _todos.asStateFlow()

    init {
        // サンプルデータを追加
        _todos.value = listOf(
            Todo(
                id = "1",
                title = "買い物",
                todoDescription = "牛乳、パン、卵を買う",
                isCompleted = false
            ),
            Todo(
                id = "2",
                title = "運動",
                todoDescription = "30分ジョギング",
                isCompleted = true
            ),
            Todo(
                id = "3",
                title = "読書",
                todoDescription = "技術書を読む",
                isCompleted = false
            )
        )
    }

    fun addTodo(title: String, todoDescription: String = "") {
        val newTodo = Todo(
            id = generateId(),
            title = title,
            todoDescription = todoDescription,
            isCompleted = false
        )
        _todos.value = _todos.value + newTodo
    }

    fun toggleTodo(id: String) {
        _todos.value = _todos.value.map { todo ->
            if (todo.id == id) {
                todo.copy(
                    isCompleted = !todo.isCompleted,
                    updatedAt = Clock.System.now()
                )
            } else {
                todo
            }
        }
    }

    fun deleteTodo(id: String) {
        _todos.value = _todos.value.filterNot { it.id == id }
    }

    fun updateTodo(id: String, title: String, todoDescription: String) {
        _todos.value = _todos.value.map { todo ->
            if (todo.id == id) {
                todo.copy(
                    title = title,
                    todoDescription = todoDescription,
                    updatedAt = Clock.System.now()
                )
            } else {
                todo
            }
        }
    }

    private fun generateId(): String {
        return Random.nextLong().toString()
    }
}
