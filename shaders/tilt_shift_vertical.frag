#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;
uniform float sigma;
uniform float topExtent;
uniform float bottomExtent;
uniform float leftExtent;
uniform float rightExtent;
uniform float isAndroid;
uniform float edgeIntensity;
uniform float kernelSize;
uniform float tintR;
uniform float tintG;
uniform float tintB;
uniform float tintA;
uniform sampler2D uTexture;
uniform sampler2D uOriginalTexture;

out vec4 FragColor;

// Optimized Gaussian weight calculation
float getGaussianWeight(float offset, float sig) {
    return exp(-0.5 * offset * offset / (sig * sig));
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uViewSize;
    
    // Fix coordinate system for cross-platform compatibility
    if (isAndroid > 0.5) {
        uv.y = 1.0 - uv.y;
    }
    
    vec4 originalColor = texture(uOriginalTexture, uv);
    vec4 horizontalBlurred = texture(uTexture, uv);
    
    // Early return if sigma is 0 - no blur needed
    if (sigma <= 0.0) {
        // Apply tint color even without blur if tint alpha > 0
        if (tintA > 0.0) {
            vec3 tintColor = vec3(tintR, tintG, tintB);
            vec3 blended = mix(originalColor.rgb, tintColor, tintA);
            FragColor = vec4(blended, originalColor.a);
        } else {
            FragColor = originalColor;
        }
        return;
    }
    
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
    
    // Use kernel size provided from Dart side, ensure minimum value using float max
    float kSizeFloat = max(kernelSize, 1.0);
    int kSize = int(kSizeFloat);

    vec3 result = vec3(0.0);
    float weightSum = 0.0;
    
    // Vertical blur pass with fixed loop bounds
    // Use 100 to match the exact maximum from Dart code (baseKernelSize.clamp(9.0, 100.0))
    const int MAX_KERNEL_SIZE = 100;
    for (int j = -MAX_KERNEL_SIZE; j <= MAX_KERNEL_SIZE; ++j) {
        // Skip iterations outside the actual kernel size using logical comparison
        if (j < -kSize || j > kSize) continue;
        
        vec2 offset = vec2(0.0, float(j) / uViewSize.y);
        vec2 sampleUV = uv + offset;
        float weight = getGaussianWeight(float(j), sigma);
        result += texture(uTexture, sampleUV).rgb * weight;
        weightSum += weight;
    }
    
    vec3 blurred = result / weightSum;
    
    // Apply tint color to blurred result
    if (tintA > 0.0) {
        vec3 tintColor = vec3(tintR, tintG, tintB);
        blurred = mix(blurred, tintColor, tintA);
    }
    
    // Smooth edge transition
    float maxDimension = max(uViewSize.x, uViewSize.y);
    float transitionWidth = maxDimension * edgeIntensity;
    float blendFactor = smoothstep(0.0, 1.0, edgeDistance / transitionWidth);
    
    // Final blending between original and tinted blurred result
    vec4 blurredColor = vec4(blurred, originalColor.a);
    FragColor = mix(originalColor, blurredColor, blendFactor);
}