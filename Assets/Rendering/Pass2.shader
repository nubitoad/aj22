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

            v2f vert(appdata v)
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

            float4 frag(v2f i) : SV_Target
            {
                float4 col0 = tex2D(_Col0, i.uv);
                float4 col1 = tex2D(_Col1, i.uv);
                float3 norm = col1.xyz * 2. - 1.;
                float4 col2 = tex2D(_Col2, i.uv);
                float4 col3 = tex2D(_Col3, i.uv);

                float4 col = col0;
                float mul = 1;

                float2 ns[4] = {
                    float2(0, +1. / 447.), float2(+1. / 320, 0),
                    float2(0, -1. / 447.), float2(-1. / 320, 0),
                };
                for (uint ns_i = 0; ns_i < 4; ++ns_i)
                {
                    float4 nCol1 = tex2D(_Col1, i.uv + ns[ns_i]);
                    float3 nNorm = nCol1.xyz * 2. - 1.;
                    float4 nCol2 = tex2D(_Col2, i.uv + ns[ns_i]);
                    float4 nCol3 = tex2D(_Col3, i.uv + ns[ns_i]);
                    float normalCos = dot(norm, nNorm) / (length(norm) * length(nNorm));

                    if (col2.z > nCol2.z + .01 / col2.w)
                    {
                        mul = 0.5;
                    }
                    if (col2.z > nCol2.z)
                    {
                        if (normalCos < .1 || length(col3 - nCol3) > .01)
                        {
                            mul = 0.5;
                        }
                    }
                }
                return col * mul;
            }
            ENDCG
        }
    }
}