// https://docs.unity3d.com/Manual/SL-SurfaceShaders.html

Shader "KCH/01_Color" // 이 쉐이더 명
// ㄴ object 머티리얼넣을 때 쉐이더 고를 때 KCH 그룹 -> 01_Color
{
	Properties // 속성 지정
	   // inspector에 나오는 것들
	   // 외부에 값 받아올 것들을 여기에 정의
	{
	   _colorR("Color R", Range(0, 1)) = 1
	   // 변수명("인스펙터에 나타나는 이 속성의 이름", 자료형이라고 생각 - '0~1사이 값을 받는 변수이다'를 정의.))
	   // 기본값은 1
	   _colorG("Color G", Range(0, 1)) = 1
	   _colorB("Color B", Range(0, 1)) = 1

		// 기본으로 들어가 있는 애들
		// 반사, 거칠기 등
		_Metallic("Metallic", Range(0, 1)) = 1
		_Glossiness("Glossiness", Range(0, 1)) = 1
	}

		SubShader
		// subShader가 존재한다는 것은 쉐이더 하나에 여러개의 쉐이더가 동시에 연산될 수 있다는 의미
	{
	   CGPROGRAM // 엔비디아에서 사용하는 shader 언어 ~ ENDCG

	   // #pragma surface surfaceFunction lightModel [optionalparams]
	   #pragma surface surf Standard 
	   // ㄴ #pragma : 컴파일러에게 Shader 설정값 알려주는 것
	   // # surf : 지금부터 우리는 surface shader를 돌릴건데 그 코드가 담겨있는 함수는 surf이다.
	   // # Standard : 조명은 물리기반 랜더링으로 연산. 즉 유니티에서 기본적으로 사용하는 shader연산은 그대로 쓰고 
	   //필요한것만 custom하겠다는 것
	   struct Input // structure 정의
	   {
		  float4 color : COLOR; // float이 4개 있는 자료형 사용. 
		  // 자료형 변수 명 : symentic.
		  // COLOR : pipeline으로 들어오는 정보들 중에서 어떤 정보를 들고올 지 명시
		};

	   fixed _colorR; // fixed는 1byte 자료형. 
	   fixed _colorG; // inspector에서 가져온 값을 위해 저장하는 변수이랑 코드에서 사용하는 변수랑 메모리가 다르다.
	   // 변수명을 맞춰줌으로써 property에서 받아오는 정보를 이 코드에서 사용할 수 있게 된다.
	   fixed _colorB;

	   half _Metallic;
	   half _Glossiness;

	   //struct SurfaceOutputStandard
	   //{
	   //   fixed3 Albedo;      // 반사되는 색
	   //   fixed3 Normal;      // 법선
	   //   half3 Emission;      // 발산되는 색
	   //   half Metallic;      // 0=메탈 영향 없음, 1=메탈
	   //   half Smoothness;    // 0=거칠게, 1=부드럽게
	   //   half Occlusion;     // 차폐로 인한 환경광의 영향도 (기본 1)
	   //   fixed Alpha;        // 투명도
	   //};

	   // Input in -> 우리가 정의한 구조체에서 받아오는 정보. 즉 COLOR정보.
	   // inout : 내부에서 정보를 변경하면 외부도 바뀐다.
	   // 서피스에서 내보내는 정보
	   // 파이프라인이 지나갈 때, in을 받아서 가공하고 inout으로 내보낸다.
	   // 나가는 정보는 고정이기 때문에 해당 정보들은 전부 적어줘야 한다.
	   void surf(Input In, inout SurfaceOutputStandard o)
	   {
		   // 마지막에 나가는게 색상값
		   // ㅇ = inout 뒤에 있는 o 이다  ↗
		   //float 3개짜리를 만들면서 rgb를 만들어준것
		   o.Albedo = float3(_colorR, _colorG, _colorB); //  albedo는 조명 처리한 후의 색상
		   o.Emission = float3(_colorR, _colorG, _colorB); // 조명 상관없는 원래 색
		   o.Metallic = _Metallic;
		   o.Smoothness = _Glossiness;
		   // float3 col = float3(1, 0, 0) + float(0, 1, 0);p
		   // o.Emission = col + float4(col, 1);
		   // o.Emission = In.color; // 버택스 색. 물체에 텍스처 안입혔을 때 가지는 색

		   // <기억할 조명 용어>
		   // Albedo
		   // Emission
		   // defuse : 난반사광 .. 색이 가진 원래색
		   // specular : 집중광
		   // ambient : 주변광

		   // 감산혼합. 가산혼합 .. 가산은 색을 섞을수록 밝아지는 것
		   // 빛은 가산혼합. 물감은 감산혼합
		}

		ENDCG
	}
}