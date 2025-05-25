#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;     // Uses indices 0 (x) and 1 (y)
uniform float sigma;         // Index 2
uniform float topExtent;     // Index 3
uniform float bottomExtent;  // Index 4
uniform float leftExtent;    // Index 5
uniform float rightExtent;   // Index 6
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

    // Check if fragment is in any blur region
    bool inTop = topExtent > 0.0 && fragCoord.y < topEdge;
    bool inBottom = bottomExtent > 0.0 && fragCoord.y > bottomEdge;
    bool inLeft = leftExtent > 0.0 && fragCoord.x < leftEdge;
    bool inRight = rightExtent > 0.0 && fragCoord.x > rightEdge;
    bool inBlurRegion = inTop || inBottom || inLeft || inRight;

    if (inBlurRegion) {
        // Calculate distance to the closest edge
        float edgeDistance = 1e6; // Initialize with a large value
        if (inTop) edgeDistance = min(edgeDistance, topEdge - fragCoord.y);
        if (inBottom) edgeDistance = min(edgeDistance, fragCoord.y - bottomEdge);
        if (inLeft) edgeDistance = min(edgeDistance, leftEdge - fragCoord.x);
        if (inRight) edgeDistance = min(edgeDistance, fragCoord.x - rightEdge);

        // Compute Gaussian blur
        const float shiftPower = 4.0;
        const int mSize = 21;
        const int kSize = (mSize-1)/2;
        float kernel[mSize];
        vec3 final_colour = vec3(0.0);

        float Z = 0.00;
        for (int j = 0; j <= kSize; ++j)
            kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma);

        for (int j = 0; j < mSize; ++j)
            Z += kernel[j];

        for (int i=-kSize; i <= kSize; ++i) {
            for (int j=-kSize; j <= kSize; ++j)
                final_colour += kernel[kSize+j]*kernel[kSize+i]*texture(uTexture, (fragCoord.xy+vec2(float(i),float(j))) / uViewSize).rgb;
        }

        // Blend factor based on closest edge
        float val = clamp(shiftPower * edgeDistance / (max(uViewSize.x, uViewSize.y) * 0.3), 0.0, 1.0);
        FragColor = vec4(final_colour/(Z*Z), 1.0) * val + color * (1.0 - val);
    } else {
        FragColor = color;
    }
}