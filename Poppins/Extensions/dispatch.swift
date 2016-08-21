func dispatch_to_main(_ f: @escaping ()->()) {
    DispatchQueue.main.async(execute: f)
}

func dispatch_to_background(_ f: @escaping ()->()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: f)
}

func dispatch_to_user_initiated(_ f: @escaping ()->()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: f)
}
