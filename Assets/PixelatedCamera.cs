using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class PixelatedCamera : MonoBehaviour
{

    public int screenScaleFactor = 2;
    public RawImage display;

    private int screenWidth, screenHeight;
    private RenderTexture renderTexture;

    void Start()
    {
        Init();
    }

    public void Init()
    {
        if (screenScaleFactor == 0)
        {
            screenScaleFactor = 1;
        }

        screenWidth = Screen.width;
        screenHeight = Screen.height;
        var width = screenWidth / screenScaleFactor;
        var height = screenHeight / screenScaleFactor;

        renderTexture = new RenderTexture(width, height, 24) {
            filterMode = FilterMode.Point,
            antiAliasing = 1
        };

        var renderCamera = GetComponent<Camera>();
        renderCamera.targetTexture = renderTexture;
        display.texture = renderTexture;
    }

    // Update is called once per frame
    void Update()
    {
        if (Screen.width != screenWidth || Screen.width != screenHeight)
        {
            Init();
        }
    }
}
