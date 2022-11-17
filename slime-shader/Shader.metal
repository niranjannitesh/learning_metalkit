//
//  Shader.metal
//  slime-shader
//
//  Created by Nitesh Kumar Niranjan on 18/11/22.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 vert(const device packed_float3 *verticies [[buffer(0)]], uint vertexId [[vertex_id]]) {
    return float4(verticies[vertexId], 1);
}

fragment half4 frag() {
    return half4(1, 1, 0, 1);
}
