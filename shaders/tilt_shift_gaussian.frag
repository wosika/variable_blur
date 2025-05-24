#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uViewSize;
uniform float sigma;
uniform float blurHeight; // Blur extent + direction (sign)
uniform float blurAxis;   // 0.0 = vertical (Y-axis), 1.0 = horizontal (X-axis)
uniform sampler2D uTexture;

out vec4 FragColor;

float normpdf(in float x, in float sigma) {
    return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uViewSize;

    vec4 color = vec4(texture(uTexture, uv).rgb, 1.0);

    float absBlurHeight = abs(blurHeight);
    bool isPositiveDirection = blurHeight >= 0.0;

    // Determine axis (X or Y) and view size for that axis
    float coord = (blurAxis < 0.5) ? fragCoord.y : fragCoord.x;
    float viewSize = (blurAxis < 0.5) ? uViewSize.y : uViewSize.x;

    // Check if fragment is in the blur region
    bool inBlurRegion;
    if (isPositiveDirection) {
        inBlurRegion = coord < viewSize * absBlurHeight;
    } else {
        inBlurRegion = coord > viewSize * (1.0 - absBlurHeight);
    }

    if (inBlurRegion) {
        const float shiftPower = 4.0;
        const int mSize = 35;
        const int kSize = (mSize-1)/2;
        float kernel[mSize];
        vec3 final_colour = vec3(0.0);

        float Z = 0.00;
        for (int j = 0; j <= kSize; ++j)
            kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma );

        for (int j = 0; j < mSize; ++j)
            Z += kernel[j];

        for (int i=-kSize; i <= kSize; ++i) {
            for (int j=-kSize; j <= kSize; ++j)
                final_colour += kernel[kSize+j]*kernel[kSize+i]*texture(uTexture, (fragCoord.xy+vec2(float(i),float(j))) / uViewSize).rgb;
        }

        // Calculate distance from the edge (top/bottom or left/right)
        float edgeDistance;
        if (isPositiveDirection) {
            edgeDistance = viewSize * absBlurHeight - coord;
        } else {
            edgeDistance = coord - viewSize * (1.0 - absBlurHeight);
        }

        // Blend factor for the effect
        float val = clamp(shiftPower * abs(edgeDistance) / (viewSize * 0.3), 0.0, 1.0);
        FragColor = vec4(final_colour/(Z*Z), 1.0) * val + color * (1.0 - val);
    } else {
        FragColor = color;
    }
}