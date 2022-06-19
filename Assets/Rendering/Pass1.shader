Shader "AJ/Pass1"
{
    Properties
    {
        _Color ("Color", Color) = (1.000000,1.000000,1.000000,1.000000)
        _MainTex ("Albedo", 2D) = "white" { }
        _ID ("ID", Int) = 0
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }

            CGPROGRAM
            #pragma multi_compile_instancing
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                fixed4 diff : COLOR0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 pos : TEXCOORD1;
                float4 vertex : SV_POSITION;
                fixed4 diff : COLOR0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct f2a
            {
                float4 col0 : COLOR0;
                float4 col1 : COLOR1;
                float4 col2 : COLOR2;
                float4 col3 : COLOR3;
            };

            sampler2D _MainTex;
            float4 _Color;
            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(int, _ID)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);

                o.pos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;

                return o;
            }

            f2a frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                int id = UNITY_ACCESS_INSTANCED_PROP(Props, _ID);

                f2a OUT;
                OUT.col0 = tex2D(_MainTex, i.uv) * _Color;
                OUT.col1 = float4(i.pos, 1);
                OUT.col2 = i.diff;
                OUT.col3 = float4(_Color.xyz, id / 256.);
                return OUT;
            }
            ENDCG
        }
    }
}