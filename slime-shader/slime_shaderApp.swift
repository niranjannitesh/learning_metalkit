//
//  slime_shaderApp.swift
//  slime-shader
//
//  Created by Nitesh Kumar Niranjan on 18/11/22.
//

import SwiftUI
import MetalKit

@main
struct slime_shaderApp: App {
    var body: some Scene {
        WindowGroup {
            MetalView()
        }
    }
}


struct MetalView: NSViewRepresentable {
    func makeCoordinator() -> Renderer {
        Renderer(self)
    }
    
    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        mtkView.drawableSize = mtkView.frame.size
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MetalView>) {
        
    }
}


struct MetalView_Preview: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}
