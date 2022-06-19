using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PixelatedCamera : MonoBehaviour
{
    public int scaledHeight;
    public RawImage display;

    private int screenWidth, screenHeight;

    public RenderTexture[] outputs = new RenderTexture[4];
    public Material mat;

    void Start()
    {
        Init();
    }

    public void Init()
    {
        screenWidth = Screen.width;
        screenHeight = Screen.height;
        if (scaledHeight <= 0 || scaledHeight > screenHeight)
        {
            scaledHeight = screenHeight;
        }
        var width = scaledHeight * screenWidth / screenHeight;
        var height = scaledHeight;

        var camera = GetComponent<Camera>();
        camera.targetTexture = null;

        var buffers = new RenderBuffer[outputs.Length];
        for (var i = 0; i < outputs.Length; ++i)
        {
            outputs[i].Release();
            outputs[i].width = width;
            outputs[i].height = height;
            outputs[i].depth = 24;
            outputs[i].filterMode = FilterMode.Point;
            outputs[i].antiAliasing = 1;
            outputs[i].Create();
            buffers[i] = outputs[i].colorBuffer;
        }

        camera.SetTargetBuffers(buffers, outputs[0].depthBuffer);
    }

    void Update()
    {
        if (Screen.width != screenWidth || Screen.width != screenHeight)
        {
            Init();
        }
    }
}