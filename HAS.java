// Hospital Administration System

interface FoodBuying {
	public void buyFood(String foodName, int payment);
}

class HospitalMember {
	protected String name;
	protected int nbDrugsDispensed;
	public HospitalMember(String name, int nbDrugsDispensed) {
		this.name = name;
		this.nbDrugsDispensed = nbDrugsDispensed;
	}

	public HospitalMember(String name) {
		this.name = name;
		this.nbDrugsDispensed = 0;
	}

	public void seeDoctor(int num) {
		System.out.println(" is sick! S/he sees a doctor.");
	}

	public void getDrugDispensed(int num) {
		int nbDrugDispensed;
		if (nbDrugsDispensed < num) {
			nbDrugDispensed = nbDrugsDispensed;
			nbDrugsDispensed = 0;
		} else {
			nbDrugDispensed = num;
			nbDrugsDispensed -= num;
		}
		System.out.println("Dispensed "+ nbDrugDispensed +" drug items, "+ nbDrugsDispensed +" items still to be dispensed.");
	}

}

class Doctor extends HospitalMember implements FoodBuying{
	protected String staffID;
	protected int salary;
	public Doctor(String staffID, String name) {
		super(name);
		this.staffID = staffID;
		this.salary = 100000;
	}

	@Override
	public String toString() {
		return "Doctor "+ name +" ("+ staffID +")";
	}

	@Override
	public void seeDoctor(int num) {
		System.out.print(toString());
		super.seeDoctor(num);
		nbDrugsDispensed += num;
		System.out.println("Totally "+ nbDrugsDispensed +" drug items adminstered.");
	}

	public void getSalary(int amount) {
		salary += amount;
		System.out.println(toString() + " has got HK$"+ salary +" salary left.");
	}

	public void pay(int amount) {
		salary -= amount;
		System.out.println(toString() + " has got HK$"+ salary +" salary left.");
	}

	public void attendClub() {
		System.out.println("Eat and drink in the Club.");
	}

	@Override
	public void buyFood(String foodName, int payment) {
		System.out.println("Buy "+foodName+" and pay $"+payment+".");
		pay(payment);
	}
}

class Patient extends HospitalMember implements FoodBuying{
	protected String stuID;
	protected int money;
	public Patient(String stuID, String name) {
		super(name);
		this.stuID = stuID;
		this.money = 10000;
	}

	@Override
	public String toString() {
		return "Patient "+ name +" ("+ stuID +")";
	}

	@Override
	public void seeDoctor(int num) {
		System.out.print(toString());
		super.seeDoctor(num);
		int max = 15;
		if (num < max - nbDrugsDispensed) {
			nbDrugsDispensed += num;
		} else {
			nbDrugsDispensed = max;
		}
		System.out.println("Totally "+ nbDrugsDispensed +" drug items administered.");
	}

	public void pay(int amount) {
		money -= amount;
		System.out.println(toString() + " has got HK$" + money + " left in the wallet.");
	}

	@Override
	public void buyFood(String foodName, int payment) {
		System.out.println("Buy "+foodName+" and pay $"+payment+".");
		pay(payment);
	}
}

class Visitor implements FoodBuying{
	protected String visitorID;
	protected int money;
	public Visitor(String visitorID) {
		this.visitorID = visitorID;
		money = 1000;
	}

	@Override
	public String toString() {
		return "Visitor "+ visitorID;
	}

	public void pay(int amount) {
		money -= amount;
		System.out.println(toString() + " has got HK$" + money + " left in the wallet.");
	}

	@Override
	public void buyFood(String foodName, int payment) {
		System.out.println("Buy "+foodName+" and pay $"+payment+".");
		pay(payment);
	}
}

class Pharmacy {
	protected String pharmName;
	public Pharmacy(String name) {
		this.pharmName = name;
	}

	@Override
	public String toString() {
		return pharmName + " Pharmacy";
	}

	public void dispenseDrugs(Object person, int numOfDrugs) {
		if (person instanceof HospitalMember) {
			((HospitalMember)person).getDrugDispensed(numOfDrugs);
		} else {
			System.out.println(person.toString()+" is not a pharmacy user!");
		}
	}
}

class Canteen {
	protected String ctnName;
	public Canteen(String name) {
		this.ctnName = name;
	}

	@Override
	public String toString() {
		return ctnName + " Canteen";
	}

	public void sellNoodle(Object person) {
		int price = 40;
		((FoodBuying)person).buyFood("Noodle", price);
	}
}

class Department {
	protected String deptName;
	public Department(String name) {
		this.deptName = name;
	}

	@Override
	public String toString() {
		return deptName + " Department";
	}

	public void callPatient(Object person, int amount) {
		if (person instanceof HospitalMember) {
			((HospitalMember)person).seeDoctor(amount);
		} else {
			System.out.println(person.toString() + " has no rights to get see a doctor!");
		}
	}

	public void paySalary(Object person, int amount) {
		if (person instanceof Doctor) {
			System.out.println(toString() + " pays Salary $" + amount + " to " + person.toString() + ".");
			((Doctor)person).getSalary(amount);
		} else {
			System.out.println(person.toString()+" has no rights to get salary from "+toString()+"!");
		}
	}
}

class StaffClub {
	protected String clubName;
	public StaffClub(String name) {
		this.clubName = name;
	}

	@Override
	public String toString() {
		return clubName + " Club";
	}

	public void holdParty(Object person) {
		if (person instanceof Doctor) {
			((Doctor)person).attendClub();	
		} else {
			System.out.println(person.toString() + " has no rights to use facilities in the Club!");
		}
	}
}

public class HAS {
	public static void main (String args[]) {
		// run the system
		System.out.println("Hospital Administration System:");

		// roles
		Patient alice = new Patient("p001", "Alice");
		Doctor bob = new Doctor("d001", "Bob");
		Visitor visitor = new Visitor("v001");
		Pharmacy mainPharm = new Pharmacy("Main");
		Canteen bigCtn = new Canteen("Big Big");
		Department ane = new Department("A&E");
		StaffClub teaClub = new StaffClub("Happy");

            // roles in different activities
		Object[] person_list = {alice, bob, visitor};
		for (Object person : person_list) {
			System.out.println();
			System.out.println(person.toString()+" enters CU Hospital ...");
			System.out.println(person.toString() + " enters " + ane.toString() + ".");
			ane.callPatient(person, 20);
			System.out.println(person.toString() + " enters " + mainPharm.toString() + ".");
			mainPharm.dispenseDrugs(person, 10);
			mainPharm.dispenseDrugs(person, 25);
			System.out.println(person.toString() + " enters " + bigCtn.toString() + ".");
			bigCtn.sellNoodle(person);
			System.out.println(person.toString() + " enters " + ane.toString() + " again.");
			ane.paySalary(person, 10000);
			System.out.println(person.toString() + " enters " + teaClub.toString() + ".");
			teaClub.holdParty(person);
		}

	}

}
