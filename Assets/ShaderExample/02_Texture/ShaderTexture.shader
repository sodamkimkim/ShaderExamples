Shader "KCH/02_ShaderTexture"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
        _MainTexTo ("Albedo (RGB)", 2D) = "black" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _MainTexTo;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float4 texColor = tex2D (_MainTex, IN.uv_MainTex);
			float4 texToColor = tex2D (_MainTexTo, IN.uv_MainTex);
			//o.Albedo = texColor.rgb;
            //o.Emission = texColor.r * 0.2989 + texColor.g * 0.5870 + texColor.b * 0.1140;
			o.Emission = lerp(texColor.rgb, texToColor.rgb, 0.5);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
