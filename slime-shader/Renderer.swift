//
//  Renderer.swift
//  slime-shader
//
//  Created by Nitesh Kumar Niranjan on 18/11/22.
//

import MetalKit

public class Renderer: NSObject, MTKViewDelegate {
    
    var parent: MetalView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    var vertexBuffer: MTLBuffer
    var indiciesBuffer: MTLBuffer

    var pipelineState: MTLRenderPipelineState
    
    var verticies: [Float] = [
        -1,  1, 0,
        -1, -1, 0,
         1, -1, 0,
         1,  1, 0,
    ]
    
    var indicies: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    
    init(_ parent: MetalView) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        self.vertexBuffer = metalDevice.makeBuffer(bytes: verticies, length: verticies.count * MemoryLayout<Float>.size, options: [])!
        self.indiciesBuffer = metalDevice.makeBuffer(bytes: indicies, length: indicies.count * MemoryLayout<UInt16>.size)!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vert")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "frag")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError()
        }
        
        
        super.init()
    }
    
    
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    
    
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indicies.count, indexType: .uint16, indexBuffer: indiciesBuffer, indexBufferOffset: 0)
        
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}
