module resource_account::Project{

    use std::debug;
    use std::signer;
    use std::vector;
    use aptos_framework::timestamp;

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

    struct Shift has store, key, drop, copy{
        punch_in_time:u64,
        punch_out_time:u64,
        hours_completed:u64,
        shift_completed:bool,
    }


    public entry fun createEmployee(account:&signer,employee_id:u64,name:vector<u8>,age:u64,salary:u64){
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

    public fun shift_completed_or_not(account:&signer):bool acquires Shift{
        let shift_completed = borrow_global<Shift>(signer::address_of(account)).shift_completed;
        shift_completed
    }

    
    public fun punch_in(account:&signer)   {
        move_to(account,Shift{punch_in_time: timestamp(), punch_out_time:0, hours_completed:0, shift_completed:false});
        

    }

    public fun punch_out(account:&signer) acquires Shift{
        let shift_Completed : &mut Shift = borrow_global_mut<Shift>(signer::address_of(account));
        shift_Completed.punch_out_time = timestamp();
        shift_Completed.hours_completed = shift_Completed.punch_out_time - shift_Completed.punch_in_time;
        shift_Completed.shift_completed = if(shift_Completed.hours_completed ==0){
            true
        }else{
            false
        };
        
    }


     public fun delete_employee(account:&signer) acquires Employee {
       let a = &mut borrow_global_mut<Employee>(signer::address_of(account)).isStillAnEmployee;
        *a = false;
    }

    fun timestamp():u64  {
        timestamp::now_seconds()
      
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

    #[test(account =@0x2, aptos_framework=@0x1)]
    public fun test_punch_in(account:&signer, aptos_framework:&signer) acquires Shift  {
        timestamp::set_time_has_started_for_testing(aptos_framework);
        punch_in(account);
         
        let time = borrow_global<Shift>(signer::address_of(account)).punch_in_time;
        assert!(time == timestamp(), 101);
    }
    #[test(account =@0x2, aptos_framework=@0x1)]
    public fun test_punch_out(account:&signer,aptos_framework:&signer) acquires Shift {
        timestamp::set_time_has_started_for_testing(aptos_framework);
        punch_in(account);
        punch_out(account);
        let time = borrow_global<Shift>(signer::address_of(account)).punch_out_time;
        assert!(time == timestamp(),102);
    }


    #[test(account =@0x2, aptos_framework=@0x1)]
    public fun test_shift_completed_or_not(account:&signer,aptos_framework:&signer) acquires Shift {
         timestamp::set_time_has_started_for_testing(aptos_framework);
        punch_in(account);
        punch_out(account);
        let shift_completed:bool = borrow_global<Shift>(signer::address_of(account)).shift_completed;
        assert!(shift_completed == true,103);
    }

//shift_completed_or_not
    
}


