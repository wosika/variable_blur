#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;
uniform float sigma;
uniform float topExtent;
uniform float bottomExtent;
uniform float leftExtent;
uniform float rightExtent;
uniform sampler2D uTexture;

out vec4 FragColor;

// Precomputed Gaussian weights for common sigma values
float getGaussianWeight(int offset, float sig) {
    return 0.39894 * exp(-0.5 * float(offset * offset) / (sig * sig)) / sig;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uViewSize;
    
    vec4 color = texture(uTexture, uv);
    
    // Calculate edge positions
    float topEdge = topExtent * uViewSize.y;
    float bottomEdge = (1.0 - bottomExtent) * uViewSize.y;
    float leftEdge = leftExtent * uViewSize.x;
    float rightEdge = (1.0 - rightExtent) * uViewSize.x;
    
    // Check blur regions
    bool inTop = topExtent > 0.0 && fragCoord.y < topEdge;
    bool inBottom = bottomExtent > 0.0 && fragCoord.y > bottomEdge;
    bool inLeft = leftExtent > 0.0 && fragCoord.x < leftEdge;
    bool inRight = rightExtent > 0.0 && fragCoord.x > rightEdge;
    bool inBlurRegion = inTop || inBottom || inLeft || inRight;
    
    if (!inBlurRegion) {
        FragColor = color;
        return;
    }
    
    // Adaptive kernel size based on sigma
    int kSize = min(int(ceil(3.0 * sigma)), 17);
    vec3 result = vec3(0.0);
    float weightSum = 0.0;
    
    // Horizontal blur pass
    for (int i = -kSize; i <= kSize; ++i) {
        vec2 offset = vec2(float(i) / uViewSize.x, 0.0);
        float weight = getGaussianWeight(i, sigma);
        result += texture(uTexture, uv + offset).rgb * weight;
        weightSum += weight;
    }
    
    FragColor = vec4(result / weightSum, color.a);
}