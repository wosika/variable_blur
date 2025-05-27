#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;
uniform float sigma;
uniform float topExtent;
uniform float bottomExtent;
uniform float leftExtent;
uniform float rightExtent;
uniform vec4 blurTint;
uniform sampler2D uTexture;
uniform sampler2D uOriginalTexture;

out vec4 FragColor;

float getGaussianWeight(int offset, float sig) {
    return 0.39894 * exp(-0.5 * float(offset * offset) / (sig * sig)) / sig;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uViewSize;
    
    vec4 originalColor = texture(uOriginalTexture, uv);
    vec4 horizontalBlurred = texture(uTexture, uv);
    
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
        FragColor = originalColor;
        return;
    }
    
    // Calculate distance to closest edge for smooth transition
    float edgeDistance = 1e6;
    if (inTop) edgeDistance = min(edgeDistance, topEdge - fragCoord.y);
    if (inBottom) edgeDistance = min(edgeDistance, fragCoord.y - bottomEdge);
    if (inLeft) edgeDistance = min(edgeDistance, leftEdge - fragCoord.x);
    if (inRight) edgeDistance = min(edgeDistance, fragCoord.x - rightEdge);
    
    // Adaptive kernel size
    int kSize = min(int(ceil(3.0 * sigma)), 17);
    vec3 result = vec3(0.0);
    float weightSum = 0.0;
    
    // Vertical blur pass
    for (int j = -kSize; j <= kSize; ++j) {
        vec2 offset = vec2(0.0, float(j) / uViewSize.y);
        float weight = getGaussianWeight(j, sigma);
        result += texture(uTexture, uv + offset).rgb * weight;
        weightSum += weight;
    }
    
    vec3 blurred = (result / weightSum) * blurTint.rgb;
    
    // Smooth edge transition
    float maxDimension = max(uViewSize.x, uViewSize.y);
    float transitionWidth = maxDimension * 0.15;
    float blendFactor = smoothstep(0.0, 1.0, edgeDistance / transitionWidth);
    
    // Final blending
    vec4 blurredColor = vec4(blurred, blurTint.a);
    FragColor = mix(originalColor, blurredColor, blendFactor);
}