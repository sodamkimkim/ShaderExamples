Shader "KCH/06_Lambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test 
		// ㄴ standard말고우리가 custom한 조명 모델인 Test를 쓰겠다는 것.

		// lambert
		// phong
		// standard

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

		// <픽셀 하나 정보 셋팅하는 곳>
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = c.a;
        }
		// <조명 계산하는 곳>
		// - 이 함수는 램버트가 실제로 계산되는 방식을 custom 처럼 구현해 본것임
		// - custom한 조명모델 함수 이름은 Lighting + 함수이름
		float4 LightingTest (SurfaceOutput s, 
			// standard쉐이더 안쓰고 우리가만든 custom 쓰기때문에 SurfaceOutputStandard말고 SurfaceOutput 쓴다. 
			// standard에서 필요없는거 제외하고 갖고 옴.
		                     float3 lightDir,
							 float atten) { // Attenuation. 감쇠
			float ndotl = saturate(dot(s.Normal, lightDir)); 
			// # normal dot lighting 
			// ( normal 이랑 light방향 내적) => 물체에 표현되는 조명 밝기 -> saturate로 0~1값으로 환산
			float4 final;
			final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten; 
			// # _LightColor0.rgb 
			// ㄴ 조명의 색을 적용하고 싶으면 조명색을 곱해줘야 들어간다. (원래 standard로 자동으로 하고있었는데 지금은 수동으로 적어줘야 함)
			// ㄴ _LightColor0.rgb 는 전역 변수라서 이 script에 정의되지 않음. 조명 여러 개면 뒤에 번호 붙음. 여기서는 한개라 안붙음
			
			// # atten -> 감쇠 값이 없어도 색은 반영되지만, 멀어진다고 밝기가 감쇠하진않는다.  감쇠값을 적용해 주려면 이 변수를 곱해줘야 하는 것.
			
			final.a = s.Alpha;
			return final; // 조명계산이 완료된 픽셀 색 하나 반환
		}
        ENDCG

		//struct SurfaceOutput
		//{
		//	half3 Albedo;		// 기본 색상
		//	half3 Normal;		// Normal Map
		//	half3 Emission;		// 빛의 영향을 받지않는 색상
		//	half Specular;		// 반사광
		//	half Gloss;			// Specular의 강도
		//	half Alpha;			// 알파
		//};
    }
    FallBack "Diffuse"
}
