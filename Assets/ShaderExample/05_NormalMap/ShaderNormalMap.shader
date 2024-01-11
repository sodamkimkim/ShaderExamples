Shader "KCH/05_NormalMap"
{ // low-poly 조명 계산을 high - poly로 하는 기법
	// ㄴ 모델은 low -poly로 사용하고, high - poly의 normal map사용해서 계산한 조명 값을 사용
	// unwrap한 모델에다가 똑같은 위치에 컬러값이 아니라 normal값 저장 (is normal map)

	// <normal map 종류>
	// # bump
	
	// # tangent space - Normal vector 계산 기준을 면으로 잡는 거
	// 로컬은 모델, 월드는 space, view는 카메라 기준. tangent space는 tangent값을 기준으로 좌표 잡는거
	// bump normal 맵(tangent space기준으로 생성된 normal값 저장 중)을 world 공간으로 다시 계산해줘야 z값으로만 계산된 nomal 맵이 원래의 poly면 기준으로 normal vector계산된다.
	// 마모셋 / 크레이지 범프를 쓰면 해결된다. (is tangent space가 적용된 노말맵)
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_BumpMap("NormalMap", 2D) = "bump" {} // normalMap - bump 사용
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200  // level of detail - 거리에 따라 200 보다 넘으면 기본쉐이더로 바뀌게. 

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0 // 쉐이더 버전

		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input
		{
			// 같은 위치의 uv쓰기 떄문에 하나만 있어도 무방하긴 함
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};
		// normal map은 컬러값이 아니라 normal값을 저장하는 텍스쳐(x, y, z)

	half _Glossiness;
	half _Metallic;

	void surf(Input IN, inout SurfaceOutputStandard o) // 픽셀 하나 만드는 함수
	{
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
		fixed4 n = tex2D(_BumpMap, IN.uv_BumpMap);
		o.Normal = UnpackNormal(n); // tangent space의 normal 값 -> world 기준 normal 값 
		// -  조명 계산은 픽셀단위 계산된다. (퐁쉐이딩)-> 고정파이프라인에서는 못하고 픽셀 쉐이더를 써서 픽셀단위 연산을 해야 가능하다.
		// <조명계산하는 모델>
		// 플랫쉐이딩 - 면단위
		// 고러드 - 플랫에서 살짝 발전
		// 
		// 퐁쉐이딩 - 픽셀단위 계산
		o.Albedo = c.rgb;
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Alpha = c.a;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
