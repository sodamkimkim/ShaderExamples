Shader "KCH/09_NPRShadow"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Toon noambient

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

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5; // 하프램버트로 일단 조명 계산

            // 단계 나눠서 톤 여러개 만들어 줄 수 있음
            // 텍스처와 함께 사용하면 자연스러운 카툰형태쉐이딩을 확인할 수 있음.
			if(ndotl > 0.5) ndotl = 1;
			else ndotl = 0.3;

            // 밑의 방법을 사용하면 위보다 좀 더 편리하게 여러톤으로 만들 수 있다.
			//ndotl = ndotl * 5;
			//ndotl = ceil(ndotl) / 5;

			return ndotl;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
