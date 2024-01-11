Shader "KCH/07_Fresnel"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("NormalMap", 2D) = "bump" {}
		_RimColor("RimColor", Color) = (1, 1, 1, 1)
		_RimPower("RimPower", Range(1, 10)) = 3
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Lambert // Lambert는 자동으로 만들어줌

			sampler2D _MainTex;
			sampler2D _BumpMap;
			float4 _RimColor;
			float _RimPower;

			struct Input
			{
				float2 uv_MainTex;
				float2 uv_BumpMap;
				float3 viewDir; // 카메라가 바라보는 기준의 방향 벡터
			};

			void surf(Input IN, inout SurfaceOutput o)
			{
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb; // albedo에 기본 텍스처 color넣음 (조명의 영향을 받을 색들)
				o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				 float rim = saturate(dot(o.Normal, IN.viewDir)); // 모델의 normal vector와 카메라가 바라보는 기준의 Vector를 내적 => 밝기, 카메라와 가까운 곳, 수직일 수록 밝음
				o.Emission = pow(1 - rim, _RimPower) * _RimColor.rgb; // 조명의 영향을 받지않을 색을  Emission에 넣어줌
				// pow()는 제곱해주는 함수다. rim의 보수값을 제곱(: 카메라와 멀고 수직아닐 수록 밝음)
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
