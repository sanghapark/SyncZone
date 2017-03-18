# SyncZone
[Swift] write asynchronous codes in synchronous manner


**Example**
```Swift
SyncZone { await in
  do {
    let user = try await { resolve in self.login(id: "plasticono", pw: "123") { resolve($0) } } as! User
    let avatar = try await { resolve in self.getAvatar(user: user) { resolve($0) } } as! String
  } catch {
    print(error)
  }
}
```
