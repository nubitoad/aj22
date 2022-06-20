// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

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
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 pos : TEXCOORD1;
                float4 clipPos : POSITION0;
                float4 vertex : POSITION1;
                float3 normal : NORMAL;
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
                o.clipPos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.vertex = v.vertex;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.normal = worldNormal;

                return o;
            }

            f2a frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                int id = UNITY_ACCESS_INSTANCED_PROP(Props, _ID);

                half nl = max(0, dot(i.normal, _WorldSpaceLightPos0.xyz));
                float diff = smoothstep(.4, .4, nl * _LightColor0) * .7 + .3;

                f2a OUT;
                OUT.col0 = tex2D(_MainTex, i.uv) * _Color * diff;
                OUT.col1 = float4(i.normal / 2. + .5, i.clipPos.z);
                OUT.col2 = i.clipPos;
                OUT.col3 = float4(_Color.xyz, id / 256.);
                return OUT;
            }
            ENDCG
        }
    }
}