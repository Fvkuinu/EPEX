public interface Ray{
  float rayRect(PVector p, PVector d, float x, float y, float z);
  float raySphere(PVector p, PVector d, float r);
}
