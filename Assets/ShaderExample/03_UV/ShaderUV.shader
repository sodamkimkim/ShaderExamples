Shader "KCH/03_ShaderUV"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //o.Emission = IN.uv_MainTex.x;
            //o.Emission = IN.uv_MainTex.y;
            //o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0);
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex + 0.5);
			o.Emission = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
