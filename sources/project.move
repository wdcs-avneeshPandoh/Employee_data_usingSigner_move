module 0x1::Project{

    use std::debug;
    use std::signer;
    use std::vector;
   const CONTRACT:address = @0x1;


    // struct Employees has store, key, drop, copy{
    //     people : vector<Employee>,
    // }

    struct Employee has store, key, drop, copy{
        employee_id:u64,
        name : vector<u8>,
        age: u64,
        salary: u64,
        isStillAnEmployee:bool
    }


    public fun createEmployee(account:&signer,employee_id:u64,name:vector<u8>,age:u64,salary:u64){
        let isStillAnEmployee = true;
       
        move_to(account, Employee{employee_id, name, age, salary,isStillAnEmployee})
    }
    

    public fun increase_salary(account:&signer,bonus:u64 )acquires Employee{
        let a_ref = &mut borrow_global_mut<Employee>(signer::address_of(account)).salary;
        *a_ref = *a_ref + bonus;
    }


    public fun decrease_salary(account:&signer,cut:u64 )acquires Employee {
        let a_ref = &mut borrow_global_mut<Employee>(signer::address_of(account)).salary;
        *a_ref = *a_ref - cut;
    }

    public fun is_employee_age_odd(account:&signer):bool acquires Employee{
        let b:bool = false;
        let a_ref = &mut borrow_global_mut<Employee>(signer::address_of(account)).age;
        if(*a_ref % 2 != 0) {
            b = true;
        }else {
            b = false;
        };
        b
    }

    public fun is_employee_age_even(account: &signer):bool acquires Employee {
        let a:bool = false;
        let a_ref = &mut borrow_global_mut<Employee>(signer::address_of(account)).age;
        if(*a_ref % 2 == 0) {
            a = true;
        }
        else{
            a = false;
        };
        a
    }
     public fun delete_employee(account:&signer) acquires Employee {
       let a = &mut borrow_global_mut<Employee>(signer::address_of(account)).isStillAnEmployee;
        *a = false;
    }

    #[test(account = @0x2)]
    public fun test_increase_salary(account:&signer) acquires Employee{
        // account::create_account_for_test(signer::address_of(&admin));
        let employee_id = 1;
        let name = b"Avneesh";
        let age =  21 ;
        let salary = 50000;
        createEmployee(account,employee_id,name,age,salary);
        let a_ref = borrow_global_mut<Employee>(signer::address_of(account)).age;
        assert!(a_ref == 21,101);

        increase_salary(account,10000);
        let b_ref = borrow_global_mut<Employee>(signer::address_of(account)).salary;

        assert!(b_ref == 60000,102)

    }

   
     #[test(account = @0x2)]
    public fun test_decrease_salary (account:&signer) acquires Employee{
        let employee_id = 1;
        let name = b"Avneesh";
        let age =  21 ;
        let salary = 50000;
        createEmployee(account,employee_id,name,age,salary);

        decrease_salary(account,10000);
        let b_ref = borrow_global_mut<Employee>(signer::address_of(account)).salary;

        assert!(b_ref == 40000,102)
    }
     #[test(account = @0x2)]

    public fun test_is_employee_age_odd(account:&signer) acquires Employee{
        let employee_id = 1;
        let name = b"Avneesh";
        let age =  21 ;
        let salary = 50000;
        createEmployee(account,employee_id,name,age,salary);

        let a:bool = is_employee_age_odd(account);
        // let b_ref = borrow_global_mut<Employee>(signer::address_of(account)).age;

        assert!(a == true,105)
    }

    #[test(account = @0x2)]

    public fun test_deleteEmployee(account:&signer) acquires Employee {
        let employee_id = 1;
        let name = b"Avneesh";
        let age =  21 ;
        let salary = 50000;
        createEmployee(account,employee_id,name,age,salary);

        delete_employee(account);

        let b_ref = borrow_global_mut<Employee>(signer::address_of(account)).isStillAnEmployee;
        assert!(b_ref == false,108);
    }


    
}


