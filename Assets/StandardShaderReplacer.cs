using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;

[ExecuteInEditMode]
public class StandardShaderReplacer : MonoBehaviour
{
    public Shader[] allowedShaders;
    public Shader pbrDefaultShader;

    void OnGUI()
    {
        Assert.IsNotNull(pbrDefaultShader);
        Assert.IsTrue(allowedShaders.Length != 0);
        foreach (var renderer in (Renderer[]) Object.FindObjectsOfType(typeof(Renderer)))
        {
            foreach (var mat in renderer.sharedMaterials) {
                if (!allowedShaders.Contains(mat.shader))
                {
                    Debug.LogWarning("Replacing shader on '" + renderer.gameObject.name + "'...");
                    mat.shader = pbrDefaultShader;
                }
            }
        }
    }
}
