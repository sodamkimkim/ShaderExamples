Shader "KCH/08_Phong"
{ // Phong은 하프 벡터를 노멀 벡터와 내적
    // 하프 벡터는 조명벡터랑 카메라벡터 더한 벡터를 normalize 한거 
    // (l + v) / | l + v |
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "white" {}
        _SpecPower ("SpecPower", Range(100, 0)) = 50
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test noambient

        sampler2D _MainTex;
		sampler2D _BumpMap;
        fixed _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = c.a;
        }

		float4 LightingTest (SurfaceOutput s,
		                     float3 lightDir, 
							 float3 viewDir,
							 float atten) {
			// Specular
			float3 H = normalize(lightDir + viewDir); // 조명벡터랑 카메라벡터 더해서 normalize 벡터 구함(두 벡터의 중간 위치 벡터의 normal을 구함)
            // 참고로 유니티에서 쓰는 조명이랑 카메라 벡터는 내적에 사용할 수 있도록 원래 방향에서 반대방향으로 주어진다.
			float spec = saturate(dot(H, s.Normal)); // h를 모델의 normal 벡터랑 내적해서 조명을 받아 카메라에 비쳐지는 모델의 조명 밝기를 구현. 
			spec = pow(spec, _SpecPower);
			return spec;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
