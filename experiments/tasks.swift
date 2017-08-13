struct Task {
  var description: String
  var estimate: Int
  var elapsed: Int
  var complete: Bool

  init(description: String) {
    self.description = description
    self.estimate = 0
    self.elapsed = 0
    self.complete = false
  }

  init(description: String, estimate: Int) {
    self.description = description
    self.estimate = estimate
    self.elapsed = 0
    self.complete = false
  }
}

class TaskListViewModel {
  var taskList = [Task]()

  func add(_ task: Task) {
    self.taskList.append(task)
  }

  func get(_ n: Int) -> Task {
    return self.taskList[n]
  }
}

// test code
var t = Task(description: "hello", estimate: 5)
t.description = "Hola task"
print(t.description)

var l = TaskListViewModel()
l.add(t)
print(l.get(0).description)
