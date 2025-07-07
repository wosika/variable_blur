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
uniform float kernelSize;
uniform float tintR;
uniform float tintG;
uniform float tintB;
uniform float tintA;
uniform sampler2D uTexture;

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
    
    vec4 color = texture(uTexture, uv);
    
    // Early return if sigma is 0 - no blur needed
    if (sigma <= 0.0) {
        // Apply tint color even without blur if tint alpha > 0
        if (tintA > 0.0) {
            vec3 tintColor = vec3(tintR, tintG, tintB);
            vec3 blended = mix(color.rgb, tintColor, tintA);
            FragColor = vec4(blended, color.a);
        } else {
            FragColor = color;
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
        FragColor = color;
        return;
    }
    
    // Use kernel size provided from Dart side, ensure minimum value using float max
    float kSizeFloat = max(kernelSize, 1.0);
    int kSize = int(kSizeFloat);

    vec3 result = vec3(0.0);
    float weightSum = 0.0;
    
    // Horizontal blur pass with fixed loop bounds
    // Use 100 to match the exact maximum from Dart code (baseKernelSize.clamp(9.0, 100.0))
    const int MAX_KERNEL_SIZE = 100;
    for (int i = -MAX_KERNEL_SIZE; i <= MAX_KERNEL_SIZE; ++i) {
        // Skip iterations outside the actual kernel size using logical comparison
        if (i < -kSize || i > kSize) continue;
        
        vec2 offset = vec2(float(i) / uViewSize.x, 0.0);
        vec2 sampleUV = uv + offset;
        float weight = getGaussianWeight(float(i), sigma);
        result += texture(uTexture, sampleUV).rgb * weight;
        weightSum += weight;
    }
    
    vec3 blurred = result / weightSum;
    
    // Apply tint color to blurred result
    if (tintA > 0.0) {
        vec3 tintColor = vec3(tintR, tintG, tintB);
        blurred = mix(blurred, tintColor, tintA);
    }
    
    FragColor = vec4(blurred, color.a);
}