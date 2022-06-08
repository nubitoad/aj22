using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

[ExecuteInEditMode]
public class StandardShaderReplacer : MonoBehaviour
{
    public Shader pbrDefaultShader;

    void OnGUI()
    {
        Assert.IsNotNull(pbrDefaultShader);
        foreach (var renderer in (Renderer[]) Object.FindObjectsOfType(typeof(Renderer)))
        {
            foreach (var mat in renderer.sharedMaterials) {
                if (mat.shader.name == "Standard")
                {
                    Debug.LogWarning("Replacing shader on '" + renderer.gameObject.name + "'...");
                    mat.shader = pbrDefaultShader;
                }
            }
        }
    }
}
