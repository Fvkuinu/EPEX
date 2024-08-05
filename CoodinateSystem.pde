public interface CS{
  PVector worldToLocal(float x, float y, float z);
  PVector localToWorld(float x, float y, float z);
  PVector cameraToLocal(float x, float y, float z);
  PVector localToCamera(float x, float y, float z);
}
