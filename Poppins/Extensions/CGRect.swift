extension CGRect {
    func centeredRectForSize(_ size: CGSize) -> CGRect {
        let x = self.midX - size.width / 2
        let y = self.midY - size.height / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }

    func centeredRectForSize(_ size: CGSize, offset: CGPoint) -> CGRect {
        let centeredRect = centeredRectForSize(size)
        let x = centeredRect.origin.x + offset.x
        let y = centeredRect.origin.y + offset.y
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
}
