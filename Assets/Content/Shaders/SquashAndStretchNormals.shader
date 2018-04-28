// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PicoTanks/SquashAndStretchNormals"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_Squash("Squash", Float) = 0
		_Radius("Radius", Float) = 0
		_SquashEffect("SquashEffect", Float) = 1
		_SquashCurve("SquashCurve", Float) = 0
		_StretchEffect("StretchEffect", Float) = 1
		_StretchCurve("StretchCurve", Float) = 0
		_Deviation("Deviation", Range( 0 , 1)) = 0.1
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
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform fixed _Radius;
		uniform fixed _StretchCurve;
		uniform fixed _StretchEffect;
		uniform fixed _Squash;
		uniform fixed _SquashEffect;
		uniform fixed _SquashCurve;
		uniform fixed _Deviation;
		uniform sampler2D _Texture;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break49_g3 = ase_vertex3Pos;
			float xPos52_g3 = break49_g3.x;
			float yPos50_g3 = break49_g3.y;
			float Radius329 = _Radius;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float temp_output_22_0_g3 = ( 1.0 - ( ( sin( ( ( ( abs( yPos50_g3 ) / ( Radius329 / ase_objectScale.x ) ) * ( 0.5 * UNITY_PI ) ) - ( 0.5 * UNITY_PI ) ) ) + 1.0 ) / 2.0 ) );
			float StretchCurve333 = _StretchCurve;
			float StretchEffect332 = _StretchEffect;
			float Squash328 = _Squash;
			float SquashInput77_g3 = Squash328;
			float clampResult18_g3 = clamp( SquashInput77_g3 , -10.0 , 1.0 );
			float Squas23_g3 = clampResult18_g3;
			float lerpResult41_g3 = lerp( 1.0 , ( ( 1.0 - ( temp_output_22_0_g3 * StretchCurve333 ) ) * StretchEffect332 ) , ( atan( ( abs( Squas23_g3 ) * 2.0 ) ) / ( 0.5 * UNITY_PI ) ));
			float StretchMultiplierXZZ45_g3 = lerpResult41_g3;
			float SquashEffect330 = _SquashEffect;
			float SquashCurve331 = _SquashCurve;
			float lerpResult38_g3 = lerp( 0.0 , ( SquashEffect330 * ( 1.0 - ( SquashCurve331 * temp_output_22_0_g3 ) ) ) , Squas23_g3);
			float SquashMultiplierXZZ43_g3 = ( lerpResult38_g3 + 1.0 );
			float clampResult66_g3 = clamp( ( ( Squas23_g3 * 1000.0 ) + 0.5 ) , 0.0 , 1.0 );
			float lerpResult69_g3 = lerp( StretchMultiplierXZZ45_g3 , SquashMultiplierXZZ43_g3 , clampResult66_g3);
			float SquashMultiplierYY47_g3 = ( ( 1.0 - Squas23_g3 ) * yPos50_g3 );
			float zPos51_g3 = break49_g3.z;
			float3 appendResult75_g3 = (fixed3(( xPos52_g3 * lerpResult69_g3 ) , SquashMultiplierYY47_g3 , ( zPos51_g3 * lerpResult69_g3 )));
			float3 newPos307 = appendResult75_g3;
			v.vertex.xyz = newPos307;
			float Deviation273 = _Deviation;
			float3 appendResult276 = (fixed3(0 , Deviation273 , 0));
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertexTangent = v.tangent.xyz;
			float3x3 ObjectToTangent269 = float3x3(cross( ase_vertexNormal , ase_vertexTangent ), ase_vertexTangent, ase_vertexNormal);
			float3 break49_g2 = mul( ( appendResult276 + mul( ObjectToTangent269, ase_vertex3Pos ) ), ObjectToTangent269 );
			float xPos52_g2 = break49_g2.x;
			float yPos50_g2 = break49_g2.y;
			float temp_output_22_0_g2 = ( 1.0 - ( ( sin( ( ( ( abs( yPos50_g2 ) / ( Radius329 / ase_objectScale.x ) ) * ( 0.5 * UNITY_PI ) ) - ( 0.5 * UNITY_PI ) ) ) + 1.0 ) / 2.0 ) );
			float SquashInput77_g2 = Squash328;
			float clampResult18_g2 = clamp( SquashInput77_g2 , -10.0 , 1.0 );
			float Squas23_g2 = clampResult18_g2;
			float lerpResult41_g2 = lerp( 1.0 , ( ( 1.0 - ( temp_output_22_0_g2 * StretchCurve333 ) ) * StretchEffect332 ) , ( atan( ( abs( Squas23_g2 ) * 2.0 ) ) / ( 0.5 * UNITY_PI ) ));
			float StretchMultiplierXZZ45_g2 = lerpResult41_g2;
			float lerpResult38_g2 = lerp( 0.0 , ( SquashEffect330 * ( 1.0 - ( SquashCurve331 * temp_output_22_0_g2 ) ) ) , Squas23_g2);
			float SquashMultiplierXZZ43_g2 = ( lerpResult38_g2 + 1.0 );
			float clampResult66_g2 = clamp( ( ( Squas23_g2 * 1000.0 ) + 0.5 ) , 0.0 , 1.0 );
			float lerpResult69_g2 = lerp( StretchMultiplierXZZ45_g2 , SquashMultiplierXZZ43_g2 , clampResult66_g2);
			float SquashMultiplierYY47_g2 = ( ( 1.0 - Squas23_g2 ) * yPos50_g2 );
			float zPos51_g2 = break49_g2.z;
			float3 appendResult75_g2 = (fixed3(( xPos52_g2 * lerpResult69_g2 ) , SquashMultiplierYY47_g2 , ( zPos51_g2 * lerpResult69_g2 )));
			float3 yDeviation308 = appendResult75_g2;
			float3 appendResult275 = (fixed3(Deviation273 , 0 , 0));
			float3 break49_g4 = mul( ( appendResult275 + mul( ObjectToTangent269, ase_vertex3Pos ) ), ObjectToTangent269 );
			float xPos52_g4 = break49_g4.x;
			float yPos50_g4 = break49_g4.y;
			float temp_output_22_0_g4 = ( 1.0 - ( ( sin( ( ( ( abs( yPos50_g4 ) / ( Radius329 / ase_objectScale.x ) ) * ( 0.5 * UNITY_PI ) ) - ( 0.5 * UNITY_PI ) ) ) + 1.0 ) / 2.0 ) );
			float SquashInput77_g4 = Squash328;
			float clampResult18_g4 = clamp( SquashInput77_g4 , -10.0 , 1.0 );
			float Squas23_g4 = clampResult18_g4;
			float lerpResult41_g4 = lerp( 1.0 , ( ( 1.0 - ( temp_output_22_0_g4 * StretchCurve333 ) ) * StretchEffect332 ) , ( atan( ( abs( Squas23_g4 ) * 2.0 ) ) / ( 0.5 * UNITY_PI ) ));
			float StretchMultiplierXZZ45_g4 = lerpResult41_g4;
			float lerpResult38_g4 = lerp( 0.0 , ( SquashEffect330 * ( 1.0 - ( SquashCurve331 * temp_output_22_0_g4 ) ) ) , Squas23_g4);
			float SquashMultiplierXZZ43_g4 = ( lerpResult38_g4 + 1.0 );
			float clampResult66_g4 = clamp( ( ( Squas23_g4 * 1000.0 ) + 0.5 ) , 0.0 , 1.0 );
			float lerpResult69_g4 = lerp( StretchMultiplierXZZ45_g4 , SquashMultiplierXZZ43_g4 , clampResult66_g4);
			float SquashMultiplierYY47_g4 = ( ( 1.0 - Squas23_g4 ) * yPos50_g4 );
			float zPos51_g4 = break49_g4.z;
			float3 appendResult75_g4 = (fixed3(( xPos52_g4 * lerpResult69_g4 ) , SquashMultiplierYY47_g4 , ( zPos51_g4 * lerpResult69_g4 )));
			float3 xDeviation306 = appendResult75_g4;
			float3 normalizeResult318 = normalize( cross( ( yDeviation308 - newPos307 ) , ( xDeviation306 - newPos307 ) ) );
			v.normal = normalizeResult318;
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
2567;29;2546;1374;4832.2;-1292.313;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;258;-5408.339,2381.919;Float;False;1078.618;465.5402;object to tangent matrix without tangent sign;5;269;264;262;260;259;Object to tangent matrix;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;260;-5352.339,2683.14;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TangentVertexDataNode;259;-5361.761,2539.534;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CrossProductOpNode;262;-5009.762,2475.534;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;266;-4168.698,2379.405;Float;False;2019.216;789.0195;move the position in tangent X direction by the deviation amount;15;306;300;347;348;349;344;345;346;288;289;275;278;268;324;267;delta X position;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;265;-4160.55,2071.364;Float;False;Property;_Deviation;Deviation;7;0;Create;True;0;0;False;0;0.1;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;263;-4159.276,3328.917;Float;False;2014.379;800.5861;move the position in tangent Y direction by the deviation amount;15;308;296;340;343;342;338;341;339;290;291;274;276;271;272;270;delta Y position;1,1,1,1;0;0
Node;AmplifyShaderEditor.MatrixFromVectors;264;-4833.762,2507.534;Float;False;FLOAT3x3;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.PosVertexDataNode;267;-4072.697,2699.406;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;268;-4111.703,2590.909;Float;False;269;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-4072.697,2475.406;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;270;-4079.277,3632.917;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;-4577.763,2507.534;Float;False;ObjectToTangent;-1;True;1;0;FLOAT3x3;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;-3857.852,2071.164;Float;False;Deviation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;-4063.279,3424.917;Float;False;273;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;-4111.275,3536.917;Float;False;269;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.DynamicAppendNode;275;-3816.696,2491.406;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;-3823.279,3584.917;Float;False;2;2;0;FLOAT3x3;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-3816.696,2619.406;Float;False;2;2;0;FLOAT3x3;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;276;-3823.279,3456.917;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;288;-3624.696,2539.406;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;290;-3631.279,3504.917;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;-3672.696,2683.406;Float;False;269;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-4165.174,1447.266;Float;False;Property;_Squash;Squash;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-4164.36,1535.966;Float;False;Property;_Radius;Radius;2;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-4160.838,1903.978;Float;False;Property;_StretchCurve;StretchCurve;6;0;Create;True;0;0;False;0;0;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-4161.979,1814.204;Float;False;Property;_StretchEffect;StretchEffect;5;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;-3679.279,3664.917;Float;False;269;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-4163.333,1722.352;Float;False;Property;_SquashCurve;SquashCurve;4;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-4166.157,1623.516;Float;False;Property;_SquashEffect;SquashEffect;3;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;345;-3164.969,2703.908;Float;False;329;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;343;-3185.733,3917.534;Float;False;332;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;348;-3166.365,2956.445;Float;False;332;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;328;-3862.246,1447.829;Float;False;Squash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;342;-3184.338,4001.247;Float;False;333;0;1;FLOAT;0
Node;AmplifyShaderEditor.MVMatrixNode;186;-2053.082,1360.61;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-3164.97,3040.157;Float;False;333;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;-3163.576,2621.586;Float;False;328;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;330;-3858.246,1623.828;Float;False;SquashEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;-3858.05,1814.228;Float;False;StretchEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;326;-3843.574,1287.252;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;339;-3184.336,3750.105;Float;False;330;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;-3182.944,3582.675;Float;False;328;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;175;-2102.082,1447.609;Float;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;-3391.279,3504.917;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;346;-3164.969,2789.017;Float;False;330;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;-3336.696,2539.406;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-3857.45,1904.428;Float;False;StretchCurve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;347;-3169.154,2879.708;Float;False;331;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;341;-3184.336,3664.998;Float;False;329;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;331;-3857.048,1722.028;Float;False;SquashCurve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-3859.448,1536.43;Float;False;Radius;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;340;-3188.521,3840.797;Float;False;331;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;356;-2704.543,2546.247;Float;False;SquashAndStretch;-1;;4;f8d354f41350d51489ee32fd0240afc5;0;7;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;355;-2723.91,3507.335;Float;False;SquashAndStretch;-1;;2;f8d354f41350d51489ee32fd0240afc5;0;7;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;354;-3425.377,1427.949;Float;False;SquashAndStretch;-1;;3;f8d354f41350d51489ee32fd0240afc5;0;7;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1818.081,1425.609;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1548.079,1529.61;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;183;-1600.079,1420.609;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;308;-2391.433,3500.731;Float;False;yDeviation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-1566.957,1737.37;Float;False;308;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;306;-2387.809,2544.703;Float;False;xDeviation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;323;-1550.957,1822.371;Float;False;307;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-3107.149,1423.577;Float;False;newPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1566.957,1916.37;Float;False;306;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-1550.59,2002.837;Float;False;307;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;313;-1278.956,1742.37;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-1316.078,1425.609;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;314;-1277.956,1920.37;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;317;-999.9548,1742.371;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-1113.077,1426.609;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;318;-775.9524,1742.371;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;173;-916.077,1398.61;Float;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;None;aaf14129c2597e54eae53c3a52bab495;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;335;-803.7978,1604.579;Float;False;307;0;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-514.6569,1356.749;Fixed;False;True;2;Fixed;ASEMaterialInspector;0;0;Unlit;PicoTanks/SquashAndStretchNormals;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;262;0;260;0
WireConnection;262;1;259;0
WireConnection;264;0;262;0
WireConnection;264;1;259;0
WireConnection;264;2;260;0
WireConnection;269;0;264;0
WireConnection;273;0;265;0
WireConnection;275;0;324;0
WireConnection;274;0;271;0
WireConnection;274;1;270;0
WireConnection;278;0;268;0
WireConnection;278;1;267;0
WireConnection;276;1;272;0
WireConnection;288;0;275;0
WireConnection;288;1;278;0
WireConnection;290;0;276;0
WireConnection;290;1;274;0
WireConnection;328;0;5;0
WireConnection;330;0;61;0
WireConnection;332;0;154;0
WireConnection;296;0;290;0
WireConnection;296;1;291;0
WireConnection;300;0;288;0
WireConnection;300;1;289;0
WireConnection;333;0;87;0
WireConnection;331;0;42;0
WireConnection;329;0;14;0
WireConnection;356;1;300;0
WireConnection;356;2;344;0
WireConnection;356;4;345;0
WireConnection;356;5;346;0
WireConnection;356;3;347;0
WireConnection;356;6;348;0
WireConnection;356;7;349;0
WireConnection;355;1;296;0
WireConnection;355;2;338;0
WireConnection;355;4;341;0
WireConnection;355;5;339;0
WireConnection;355;3;340;0
WireConnection;355;6;343;0
WireConnection;355;7;342;0
WireConnection;354;1;326;0
WireConnection;354;2;328;0
WireConnection;354;4;329;0
WireConnection;354;5;330;0
WireConnection;354;3;331;0
WireConnection;354;6;332;0
WireConnection;354;7;333;0
WireConnection;185;0;186;0
WireConnection;185;1;175;0
WireConnection;183;0;185;0
WireConnection;308;0;355;0
WireConnection;306;0;356;0
WireConnection;307;0;354;0
WireConnection;313;0;309;0
WireConnection;313;1;323;0
WireConnection;177;0;183;0
WireConnection;177;1;178;0
WireConnection;314;0;311;0
WireConnection;314;1;310;0
WireConnection;317;0;313;0
WireConnection;317;1;314;0
WireConnection;182;0;177;0
WireConnection;182;1;178;0
WireConnection;318;0;317;0
WireConnection;173;1;182;0
WireConnection;0;2;173;0
WireConnection;0;11;335;0
WireConnection;0;12;318;0
ASEEND*/
//CHKSM=B67AE5901DEBFDF6A36611C27AC04446E7F69E53