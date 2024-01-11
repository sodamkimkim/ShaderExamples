Shader "KCH/07_Hologram"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
			float3 viewDir;
            float3 worldPos;
        };
        /*
        <struct Input에서 받을 수 있는 변수들>
        float3 viewDir : 카메라가 바라보는 방향
        float4 color: COLOR : 버텍스 컬러
        float4 screenPos : 스크린 공간에서의 위치
        float3 worldPos : 월드 공간에서의 위치
        float3 worldNormal : 월드 노멀 벡터
        float3 worldRefl : 월드 반사 벡터
        */

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //o.Albedo = c.rgb;
			o.Emission = float3(0, 1, 0);
			float rim = saturate(dot(o.Normal, IN.viewDir));
			rim = pow(1 - rim, 3); // rim값을 보수값 세제곱으로 만들어서
            //o.Alpha = rim;// 카메라 가까운 곳을 투명하게
            //o.Alpha = rim * sin(_Time.y);
             // o.Alpha = rim * (sin(_Time.y)*0.5 + 0.5);
            // o.Alpha = rim * abs(sin(_Time.y));

            o.Alpha = 1;
            o.Emission = IN.worldPos.rgb;
            o.Emission = IN.worldPos.g;
            o.Emission = frac(IN.worldPos.g); // 소숫점만 반환하는 함수 frac
            o.Emission = pow(frac(IN.worldPos.g), 30);
            o.Emission = pow(frac(IN.worldPos.g*3), 30);
            
            o.Emission = pow(frac(IN.worldPos.g*3- sin(_Time.y)), 30);
            o.Albedo = float3(0, 1, 0) * abs(sin(_Time.y))+float3(0, 0.02, 0);
          //  o.Emission = pow(frac(rim*3- _Time.y), 30);
            //o.Albedo = c.rgb;
          //  o.Albedo = float3(0,1,0) * sin(_Time.y);
           // o.Emission= frac(float3(0, 1, 0) - _Time.y)+float3(0,0.2,0);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
