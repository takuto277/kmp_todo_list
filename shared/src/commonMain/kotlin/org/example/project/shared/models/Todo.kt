package org.example.project.shared.models

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

data class Todo(
    val id: String,
    val title: String,
    val todoDescription: String = "", // descriptionはSwiftの予約語と衝突するのでtodoDescriptionに変更
    val isCompleted: Boolean = false,
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now()
)
