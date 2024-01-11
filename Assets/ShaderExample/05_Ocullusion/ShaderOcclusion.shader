Shader "KCH/05_Occulusion" // ambient occulusion
{
    // Diffuse  : 난 반사광 : 빛 받으면 사방으로 퍼지는거  - 원래색에 가까움
    // speccular : 집중광
    // ambient : 환경광. 주변에서 반사되어 보여지는 것

    // # ambient occlusion : 환경 차폐. - 주변광을 차폐한다.
    // 조명계산할 때 , 해당 부분은 가려진 부분이니까 조명 계산의 정도를 적용하는 것=> normal백터로 계산된 조명 보완
    // ㄴ occlusion 맵 만들어서 어둡고 싶은 곳은 검은색, 밝고싶은 곳은 흰칠해서 texture로 만들어놓은 것.
    // ㄴ SurfaceOutputStandard 의 Occlusion값에다가 저 맵 던져주면 되는 것
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_Occlusion ("Occlusion", 2D) = "white" {} // Occlusion map 들어가는 곳
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Occlusion;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        half _Glossiness;
        half _Metallic;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 n = tex2D (_BumpMap, IN.uv_BumpMap);
			o.Normal = UnpackNormal(n);
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
			o.Occlusion
				= tex2D (_Occlusion, IN.uv_MainTex)*2; // *2 하면 Occulusion 강도 두배
        }
        ENDCG
    }
    FallBack "Diffuse"
}
