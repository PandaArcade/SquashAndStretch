// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PicoTanks/SquashAndStretch"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_Squash("Squash", Float) = 0
		_Radius("Radius", Float) = 1
		_SquashEffect("SquashEffect", Float) = 1
		_SquashCurve("SquashCurve", Float) = 0
		_StretchEffect("StretchEffect", Float) = 1
		_StretchCurve("StretchCurve", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
		};

		uniform fixed _Radius;
		uniform fixed _StretchCurve;
		uniform fixed _StretchEffect;
		uniform fixed _Squash;
		uniform fixed _SquashEffect;
		uniform fixed _SquashCurve;
		uniform sampler2D _Texture;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break49_g1 = ase_vertex3Pos;
			float xPos52_g1 = break49_g1.x;
			float yPos50_g1 = break49_g1.y;
			float Radius329 = _Radius;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float temp_output_22_0_g1 = ( 1.0 - ( ( sin( ( ( ( abs( yPos50_g1 ) / ( Radius329 / ase_objectScale.x ) ) * ( 0.5 * UNITY_PI ) ) - ( 0.5 * UNITY_PI ) ) ) + 1.0 ) / 2.0 ) );
			float StretchCurve333 = _StretchCurve;
			float StretchEffect332 = _StretchEffect;
			float Squash328 = _Squash;
			float SquashInput77_g1 = Squash328;
			float clampResult18_g1 = clamp( SquashInput77_g1 , -10.0 , 1.0 );
			float Squas23_g1 = clampResult18_g1;
			float lerpResult41_g1 = lerp( 1.0 , ( ( 1.0 - ( temp_output_22_0_g1 * StretchCurve333 ) ) * StretchEffect332 ) , ( atan( ( abs( Squas23_g1 ) * 2.0 ) ) / ( 0.5 * UNITY_PI ) ));
			float StretchMultiplierXZZ45_g1 = lerpResult41_g1;
			float SquashEffect330 = _SquashEffect;
			float SquashCurve331 = _SquashCurve;
			float lerpResult38_g1 = lerp( 0.0 , ( SquashEffect330 * ( 1.0 - ( SquashCurve331 * temp_output_22_0_g1 ) ) ) , Squas23_g1);
			float SquashMultiplierXZZ43_g1 = ( lerpResult38_g1 + 1.0 );
			float clampResult66_g1 = clamp( ( ( Squas23_g1 * 1000.0 ) + 0.5 ) , 0.0 , 1.0 );
			float lerpResult69_g1 = lerp( StretchMultiplierXZZ45_g1 , SquashMultiplierXZZ43_g1 , clampResult66_g1);
			float SquashMultiplierYY47_g1 = ( ( 1.0 - Squas23_g1 ) * yPos50_g1 );
			float zPos51_g1 = break49_g1.z;
			float3 appendResult75_g1 = (fixed3(( xPos52_g1 * lerpResult69_g1 ) , SquashMultiplierYY47_g1 , ( zPos51_g1 * lerpResult69_g1 )));
			v.vertex.xyz = appendResult75_g1;
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			fixed3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			o.Emission = tex2D( _Texture, ( ( (mul( UNITY_MATRIX_MV, fixed4( ase_vertexNormal , 0.0 ) ).xyz).xy * 0.5 ) + 0.5 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15205
2567;29;2546;1374;2429.654;-1295.02;1;True;False
Node;AmplifyShaderEditor.NormalVertexDataNode;175;-2102.082,1447.609;Float;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.MVMatrixNode;186;-2053.082,1360.61;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1818.081,1425.609;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1548.079,1529.61;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;183;-1600.079,1420.609;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-1316.078,1425.609;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1626.63,1779.717;Float;False;Property;_Squash;Squash;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-1623.435,2146.656;Float;False;Property;_StretchEffect;StretchEffect;5;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1627.613,1955.967;Float;False;Property;_SquashEffect;SquashEffect;3;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1624.789,2054.804;Float;False;Property;_SquashCurve;SquashCurve;4;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1622.294,2236.43;Float;False;Property;_StretchCurve;StretchCurve;6;0;Create;True;0;0;False;0;0;1.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1622.342,1868.239;Float;False;Property;_Radius;Radius;2;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;331;-1318.504,2054.479;Float;False;SquashCurve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-1113.077,1426.609;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;330;-1319.702,1956.279;Float;False;SquashEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-1318.906,2236.88;Float;False;StretchCurve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;326;-1305.03,1619.703;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;-1319.506,2146.68;Float;False;StretchEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;328;-1323.702,1780.28;Float;False;Squash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-1320.904,1868.881;Float;False;Radius;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;173;-916.077,1398.61;Float;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;cadb484151570cc409c732981288cd10;aaf14129c2597e54eae53c3a52bab495;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;336;-886.8337,1760.4;Float;False;SquashAndStretch;-1;;1;f8d354f41350d51489ee32fd0240afc5;0;7;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-453.6772,1358.696;Fixed;False;True;2;Fixed;ASEMaterialInspector;0;0;Unlit;PicoTanks/SquashAndStretch;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;185;0;186;0
WireConnection;185;1;175;0
WireConnection;183;0;185;0
WireConnection;177;0;183;0
WireConnection;177;1;178;0
WireConnection;331;0;42;0
WireConnection;182;0;177;0
WireConnection;182;1;178;0
WireConnection;330;0;61;0
WireConnection;333;0;87;0
WireConnection;332;0;154;0
WireConnection;328;0;5;0
WireConnection;329;0;14;0
WireConnection;173;1;182;0
WireConnection;336;1;326;0
WireConnection;336;2;328;0
WireConnection;336;4;329;0
WireConnection;336;5;330;0
WireConnection;336;3;331;0
WireConnection;336;6;332;0
WireConnection;336;7;333;0
WireConnection;0;2;173;0
WireConnection;0;11;336;0
ASEEND*/
//CHKSM=CDDD8F8BA63842B67515E9A156A6E37E831FBDEB