Shader "AJ/Pass2"
{
    Properties
    {
        [NoScaleOffset] _Col0 ("Texture", 2D) = "white" {}
        [NoScaleOffset] _Col1 ("Texture", 2D) = "white" {}
        [NoScaleOffset] _Col2 ("Texture", 2D) = "white" {}
        [NoScaleOffset] _Col3 ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _Col0;
            sampler2D _Col1;
            sampler2D _Col2;
            sampler2D _Col3;
            float4 frag (v2f i) : SV_Target
            {
                return tex2D(_Col2, i.uv);
            }
            ENDCG
        }
    }
}