Shader "AJ/Pass1"
{
    Properties
    {
        _Color ("Color", Color) = (1.000000,1.000000,1.000000,1.000000)
        _MainTex ("Albedo", 2D) = "white" { }
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                fixed4 diff : COLOR0;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 pos : TEXCOORD1;
                fixed4 diff : COLOR0;
            };

            struct f2a
            {
                float4 col0 : COLOR0;
                float4 col1 : COLOR1;
                float4 col2 : COLOR2;
                float4 col3 : COLOR3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
                
                return o;
            }

            sampler2D _MainTex;
            float4 _Color;

            f2a frag(v2f i) : SV_Target
            {
                f2a OUT;
                OUT.col0 = tex2D(_MainTex, i.uv) * _Color;
                OUT.col1 = float4(i.pos, 1);
                OUT.col2 = i.diff;
                OUT.col3 = tex2D(_MainTex, i.uv) * _Color;
                return OUT;
            }
            ENDCG
        }
    }
}