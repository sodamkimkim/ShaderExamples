Shader "KCH/09_NPR2Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

		cull front // 앞면을 컬링하겠다.

		// Pass 1 // 뒤에 있는 테두리 먼저 그림
        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient
        // Nolight - 조명계산 x
        // vertex shader를 지금부터 쓸건데 이름이 vert
        // 그림자, 주변광 연산x

        // 정점정보가 들어오면 정점정보를 가공하는 역할
		void vert(inout appdata_full v) { // appdata_full - 버텍스 정보 전부를 가져옴
			v.vertex.xyz += v.normal.xyz * 0.01;
            // 버텍스의 월드 위치를 가공
            // +로 위치를 바꿀건데, 이 버텍스에 들어있는 노멀값을 기준으로 0.01만큼 곱한거 누적 더해줘
            // normal은 크기가 1이니까 월드 위치는 노멀방향으로 0.01만큼 옮겨지는 것.
		}

        struct Input { float4 color:COLOR; };

        void surf (Input IN, inout SurfaceOutput o) {}

		float4 LightingNolight (SurfaceOutput s, float3 lightDir, float atten) {
			return float4(0, 0, 0, 1); // 검은색 테두리 
		}
		ENDCG

		cull back

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
/*
- appdata_base
: position, normal and one texture coordinate.
- appdata_tan
: position, tangent, normal and one texture coordinate.
- appdata_full
: position, tangent, normal, four texture coordinate and color.
*/