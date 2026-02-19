Shader "Custom/OutlineURP" {
    Properties {
        _OutlineColor ("Outline Color", Color) = (1, .5, 0, 1)
        _Outline ("Outline width", Range (0, 1)) = .01
    }
 
    SubShader {
        Tags { 
            "RenderType"="Opaque" 
            "RenderPipeline"="UniversalPipeline" 
            "DisableBatching" = "True" 
        }

        // Pass de Outline
        Pass {
            Name "OUTLINE"
            Tags { "LightMode" = "UniversalForward" }
            Cull Front
            ZWrite On
            Blend SrcAlpha OneMinusSrcAlpha
 
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
 
            struct Attributes {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
            };
 
            struct Varyings {
                float4 positionCS : SV_POSITION;
                half4 color       : COLOR;
            };
 
            float _Outline;
            float4 _OutlineColor;
 
            Varyings vert(Attributes IN) {
                Varyings OUT;
                
                // Extrusión de vértices siguiendo la normal
                float3 pos = IN.positionOS.xyz * (1.0 + _Outline);
                OUT.positionCS = TransformObjectToHClip(pos);
                OUT.color = _OutlineColor;
                return OUT;
            }
 
            half4 frag(Varyings IN) : SV_Target {
                return IN.color;
            }
            ENDHLSL
        }
    }
    Fallback "Universal Render Pipeline/Lit"
}