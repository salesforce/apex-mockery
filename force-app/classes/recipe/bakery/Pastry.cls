public class Pastry {
  public String name;

  public Pastry(final String name) {
    this.name = name;
  }

  public Boolean equals(Object other) {
    if (other instanceof Pastry) {
      Pastry p = (Pastry) other;
      return (p.name == this.name);
    }
    return false;
  }

  public Integer hashCode() {
    return this.name?.hashCode();
  }
}
