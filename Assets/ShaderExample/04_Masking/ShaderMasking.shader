Shader "KCH/04_Masking"
{ 
    // 원하는 부분만 보이게 하는게 Masking
    // 해당 픽셀을 찍을 때 찍을 지 말지를 결정해야 하기 때문에 shader의 영역이다.
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex3 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex4 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex5 ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" } // 랜더타입 불투명

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;
        sampler2D _MainTex5;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex);
            //o.Emission = c.rgb * c2.rgb; // 색깔 출력

			fixed4 maskC = tex2D (_MainTex, IN.uv_MainTex); // 색칠해져있는 texture
			fixed4 baseC = tex2D (_MainTex2, IN.uv_MainTex); // 벽돌 texture
			fixed4 c3 = tex2D (_MainTex3, IN.uv_MainTex); // 불?
			fixed4 c4 = tex2D (_MainTex4, IN.uv_MainTex); // 풀?
			fixed4 c5 = tex2D (_MainTex5, IN.uv_MainTex); // 물?

			//o.Albedo = lerp(baseC.rgb, c3.rgb, maskC.r); 
   //         // maskC.r이 없는 픽셀이면 baseC(벽돌)픽셀이 그려짐
			//o.Albedo = lerp(o.Albedo, c4.rgb, maskC.g);
			//o.Albedo = lerp(o.Albedo, c5.rgb, maskC.b);

            // lerp 연산량이 많아서 이걸로 만들어씀
            // 픽셀쉐이더는 픽셀마다 연산 들어가서 하나당 시간 좀만 많이들어가도 느려짐 => 연산량 최대한 줄여야함.
            // 버텍스 쉐이더는 최적화 덜해도 괜찮지만.
			o.Albedo = c3.rgb * maskC.r +
					   c4.rgb * maskC.g +
					   c5.rgb * maskC.b +
			           baseC * (1 - (maskC.r + maskC.g + maskC.b));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
