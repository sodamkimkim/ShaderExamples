Shader "KCH/11_Cubemap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_Cube ("CubeMap", Cube) = "" {} 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert noambient

		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube; // cubemap은 전용 sampler 쓴다.

		struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldRefl; // world의 반사벡터
			/*
			float3 worldRefl; INTERNAL_DATA - 표면 셰이더가 o.Normal에 기록하는 경우 월드 반사 벡터를 포함합니다. 
			픽셀당 노멀 맵을 기반으로 반사 벡터를 얻으려면 WorldReflectionVector (IN, o.Normal)를 사용해야 합니다.
			예를 들어 리플렉트-범프드(Reflect-Bumped) 셰이더가 있습니다.
			*/
			
			INTERNAL_DATA 
				// 노멀 매핑을 쓰고 있으니까 노멀맵의 벡터를 사용해야한다.
				// 따라서 버텍스가 아니라 픽셀 노멀 기준으로 큐브맵 반사벡터를 구할 수 있도록 해주는 설정을 Input에 명시해 준다.
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal)); // normal 벡터를 고려하여 cube반사백터를 리턴해준다.
			o.Albedo = c.rgb * 0.5;
			o.Emission = re.rgb * 0.5; // 반사된 것은 조명의 영향을 받지 않기 때문에 Emission에 넣는다.
			o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
