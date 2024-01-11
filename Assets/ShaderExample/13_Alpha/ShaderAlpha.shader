Shader "KCH/13_Alpha"
{
    SubShader {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert noambient noshadow

		sampler2D _CameraDepthTexture; // position 값인데, 스크린 기준이다.

		struct Input {
			float4 screenPos;
        };

        void surf (Input IN, inout SurfaceOutput o) {
			float2 sPos = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w; // 좌표 변환 후 w값으로 나눠서 w값 1로 보정해주는 과정
			// homogeneous coordinates
			float4 Depth = tex2D(_CameraDepthTexture, sPos);
			o.Emission = Depth.r;
        }
        ENDCG
    }
    FallBack off
}