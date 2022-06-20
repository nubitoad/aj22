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
    public RenderTexture[] outputs = new RenderTexture[4];

    private int screenWidth, screenHeight;

    void Start()
    {
        Init();
    }

    public void Init()
    {
        screenWidth = Screen.width;
        screenHeight = Screen.height;
        var scaledWidth = (int) (1.0f * scaledHeight / screenHeight * screenWidth);
        Debug.LogWarning("Initializing textures " + scaledWidth + "x" + scaledHeight);

        var camera = GetComponent<Camera>();
        camera.targetTexture = null;

        var buffers = new RenderBuffer[outputs.Length];
        for (var i = 0; i < outputs.Length; ++i)
        {
            if (outputs[i].IsCreated()) {
                outputs[i].Release();
            }
            outputs[i].width = scaledWidth;
            outputs[i].height = scaledHeight;
            outputs[i].Create();
            buffers[i] = outputs[i].colorBuffer;
        }

        camera.SetTargetBuffers(buffers, outputs[0].depthBuffer);
    }

    void Update()
    {
        if (Screen.width != screenWidth || Screen.height != screenHeight)
        {
            Init();
        }
    }
}