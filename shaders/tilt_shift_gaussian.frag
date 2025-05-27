#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;     // Indices 0 (x), 1 (y)
uniform float sigma;         // Index 2
uniform float topExtent;     // Index 3
uniform float bottomExtent;  // Index 4
uniform float leftExtent;    // Index 5
uniform float rightExtent;   // Index 6
uniform vec4 blurTint;       // Index 7 (RGBA)
uniform sampler2D uTexture; // Sampler (index 0)

out vec4 FragColor;

float normpdf(in float x, in float sigma) {
    return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uViewSize;

    vec4 color = vec4(texture(uTexture, uv).rgb, 1.0);

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

    if (inBlurRegion) {
        // Distance to closest edge
        float edgeDistance = 1e6;
        if (inTop) edgeDistance = min(edgeDistance, topEdge - fragCoord.y);
        if (inBottom) edgeDistance = min(edgeDistance, fragCoord.y - bottomEdge);
        if (inLeft) edgeDistance = min(edgeDistance, leftEdge - fragCoord.x);
        if (inRight) edgeDistance = min(edgeDistance, fragCoord.x - rightEdge);

        // Gaussian blur computation
        const int mSize = 35;
        const int kSize = (mSize-1)/2;
        float kernel[mSize];
        vec3 final_colour = vec3(0.0);

        float Z = 0.0;
        for (int j = 0; j <= kSize; ++j)
            kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma);

        for (int j = 0; j < mSize; ++j)
            Z += kernel[j];

        for (int i = -kSize; i <= kSize; ++i) {
            for (int j = -kSize; j <= kSize; ++j) {
                final_colour += kernel[kSize+j] * kernel[kSize+i] * 
                    texture(uTexture, (fragCoord.xy + vec2(float(i), float(j))) / uViewSize).rgb;
            }
        }

        vec3 blurred = final_colour.rgb / (Z * Z);
        blurred *= blurTint.rgb;

        // Smooth edge transition
        float maxDimension = max(uViewSize.x, uViewSize.y);
        float transitionWidth = maxDimension * 0.15;
        float val = smoothstep(0.0, 1.0, edgeDistance / transitionWidth);

        // Final blending with premultiplied alpha
        vec4 blurredColor = vec4(blurred * blurTint.rgb, blurTint.a);
        FragColor = mix(color, blurredColor, val);
    } else {
        FragColor = color;
    }
}