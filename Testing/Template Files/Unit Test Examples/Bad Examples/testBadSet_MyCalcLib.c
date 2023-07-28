/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: SPL_CalcTest
 * Author: B+R
 ********************************************************************
 * Test set implementation
 ********************************************************************/

#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
#include <AsDefault.h>
#endif

#include "UnitTest.h"

// Bad Name, what is this testing?
_TEST test1(void)
{
    // follows arrange, act, assert but lacks comments to help identify the sections
	instMyCalc.CalcOperator = splMyCalcOPERATOR_MULTIPLICATION;
	instMyCalc.Param1 = 4;
	instMyCalc.Param2 = 4;
	MyCalculator(&instMyCalc);
	TEST_ASSERT_EQUAL_INT(16, instMyCalc.Result);
	TEST_ASSERT_EQUAL_INT(ERR_OK, instMyCalc.Status);
	TEST_DONE;
}

// bad name
_TEST test2(void)
{
    // no comments
	instMyCalc.CalcOperator = splMyCalcOPERATOR_DIVISION;
	
    // Param1 and Param2 aren't initialized, depends on the previous test's values
    MyCalculator(&instMyCalc);
    
    // multiple code paths in test, could pass 1 run but fail the next because different code paths ran
    if (instMyCalc.Param2 == 0)
    {
        TEST_ASSERT_EQUAL_INT(0, instMyCalc.Result);
        TEST_ASSERT_EQUAL_INT(splMyCalcERR_OUT_OF_RANGE, instMyCalc.Status);
    }
    else
    {
        TEST_ASSERT_EQUAL_INT(instMyCalc.Param1 / instMyCalc.Param2, instMyCalc.Result);
        TEST_ASSERT_EQUAL_INT(ERR_OK, instMyCalc.Status);
    }

	TEST_DONE;
}

// bad name
_TEST test3(void)
{
    instMyCalc.CalcOperator = splMyCalcOPERATOR_MULTIPLICATION;
    instMyCalc.Param1 = 2;
    instMyCalc.Param2 = 2;
    MyCalculator(&instMyCalc);

    // Bad: possible deceptive result, was 4 the result because multiplication was done or addition?
    TEST_ASSERT_EQUAL_INT(4, instMyCalc.Result);
    TEST_ASSERT_EQUAL_INT(ERR_OK, instMyCalc.Status);
    TEST_DONE;
}

_TEST test_duplicate_logic(void)
{
    // arrange
    instMyCalc.CalcOperator = splMyCalcOPERATOR_MULTIPLICATION;
    instMyCalc.Param1 = 4;
    instMyCalc.Param2 = 4;
    // act
    MyCalculator(&instMyCalc);
    // assert
    // Bad: we've presumably copied the code to be tested and used it in the assert
    TEST_ASSERT_EQUAL_INT(instMyCalc.Param1 * instMyCalc.Param2, instMyCalc.Result);
    TEST_ASSERT_EQUAL_INT(ERR_OK, instMyCalc.Status);
    TEST_DONE;
}

// Bad: too many test cases combined into 1 test.  If the test fails, why?
// Fix: break up test case into multiple tests, each testing a specific zone
// tests that the proper flaps are open when the machine head is over the flap's zone
_TEST test_flaps(void)
{
    switch (state)
    {
        case 0:
            flapFB.Enable = true;
            TEST_BUSY_CONDITION(flapFB.Busy);
            state = 1;
            break;

        case 1:
            //Check flaps are all false when all zones are disabled
			for (i = 0; i <= MAX_DRAFT_ZONES; i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}
            state = 2;
            break;

        case 2:
            //Enable the first zone and simulate head is in the zone
			flapFB.Parameters.Zones[0].Enable = 1;
			
			flapFB.Parameters.Zones[0].IOIndex = 0;
			
			flapFB.Parameters.Zones[0].XMin = 0;
			flapFB.Parameters.Zones[0].XMax = 1;
			flapFB.Parameters.Zones[0].YMin = 0;
			flapFB.Parameters.Zones[0].YMax = 1;
			
			flapFB.HeadPosition.X = 0.5;
			flapFB.HeadPosition.Y = 0.5;
			state = 3;
        break;

        case 3:
            //Assess all flaps are closed except the one where the head is in the zone
			TEST_ASSERT(flapFB.Flaps[0]);
			
			for (i = 1; i <= MAX_DRAFT_ZONES; i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}
			state = 4;
		break;

        case 4:
            flapFB.HeadPosition.X = 1.5;
			flapFB.HeadPosition.Y = 1.5;
			state = 5;
		break;
		
		case 5:
			//Check flaps are all false
			for (i = 0; i < MAX_DRAFT_ZONES; i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}
			state = 6;
		break;
		
		case 6:	
			//Enable a second zone with the head outside of the zone
			flapFB.Parameters.Zones[1].Enable = 1;
			
			flapFB.Parameters.Zones[1].IOIndex = 1;
			
			flapFB.Parameters.Zones[1].XMin = 1;
			flapFB.Parameters.Zones[1].XMax = 2;
			flapFB.Parameters.Zones[1].YMin = 1;
			flapFB.Parameters.Zones[1].YMax = 2;
			
			flapFB.HeadPosition.X = 2.5;
			flapFB.HeadPosition.Y = 2.5;
			state = 7;
		break;
		
		case 7:
			//Asses status of the 2 enabled zone
			TEST_ASSERT(!flapFB.Flaps[0]);
			TEST_ASSERT(!flapFB.Flaps[1]);
			
			for (i = 2; i <= MAX_DRAFT_ZONES; i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}
			state = 8;
		break;
		
		case 8:
			//Create a zone where the IO index is set to a different index
			flapFB.Parameters.Zones[2].Enable = 1;
			
			flapFB.Parameters.Zones[2].IOIndex = MAX_DRAFT_ZONES;
			
			flapFB.Parameters.Zones[2].XMin = 2;
			flapFB.Parameters.Zones[2].XMax = 3;
			flapFB.Parameters.Zones[2].YMin = 2;
			flapFB.Parameters.Zones[2].YMax = 3;
			
			flapFB.HeadPosition.X = 2.5;
			flapFB.HeadPosition.Y = 2.5;
			
			state = 9;
		break;
		
		case 9:
			//Assess status of enabled zones
			TEST_ASSERT(!flapFB.Flaps[0]);
			TEST_ASSERT(!flapFB.Flaps[1]);
			TEST_ASSERT(flapFB.Flaps[MAX_DRAFT_ZONES]);
			
			for (i = 2; i <= (MAX_DRAFT_ZONES - 1); i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}	 
			state = 10;
		break;
		
		case 10:
			//Create 2 zones where the IO index is set to the same flap. One of them is activated because the head is in the zone but the other is should't be.
			flapFB.Parameters.Zones[3].Enable = 1;
			
			flapFB.Parameters.Zones[3].IOIndex = 3;
			
			flapFB.Parameters.Zones[3].XMin = 3;
			flapFB.Parameters.Zones[3].XMax = 4;
			flapFB.Parameters.Zones[3].YMin = 3;
			flapFB.Parameters.Zones[3].YMax = 4;
			
			flapFB.HeadPosition.X = 3.5;
			flapFB.HeadPosition.Y = 3.5;
			
			flapFB.Parameters.Zones[4].Enable = 1;
			
			flapFB.Parameters.Zones[4].IOIndex = 3;
			
			flapFB.Parameters.Zones[4].XMin = 4;
			flapFB.Parameters.Zones[4].XMax = 5;
			flapFB.Parameters.Zones[4].YMin = 4;
			flapFB.Parameters.Zones[4].YMax = 5;
			
			state = 11;
		break; 
		
		case 11:
			//Assess status of enabled zones
			TEST_ASSERT(!flapFB.Flaps[0]);
			TEST_ASSERT(!flapFB.Flaps[1]);
			TEST_ASSERT(!flapFB.Flaps[MAX_DRAFT_ZONES]);
			TEST_ASSERT(flapFB.Flaps[3]);
			
			for (i = 4; i <= (MAX_DRAFT_ZONES - 1); i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}
			state = 12;
		break;
		
		case 12:
			//Define a new zone and use the test functionality
			flapFB.Parameters.Zones[4].Enable = 1;
			
			flapFB.Parameters.Zones[4].IOIndex = 4;
			
			flapFB.Parameters.Zones[4].XMin = 4;
			flapFB.Parameters.Zones[4].XMax = 5;
			flapFB.Parameters.Zones[4].YMin = 4;
			flapFB.Parameters.Zones[4].YMax = 5;
			
			flapFB.HeadPosition.X = 6;
			flapFB.HeadPosition.Y = 6;
			
			flapFB.TestZone[4] = 1;
			state = 13;
		break; 
		
		case 13:
			//Assess status of enabled zones
			TEST_ASSERT(!flapFB.Flaps[0]);
			TEST_ASSERT(!flapFB.Flaps[1]);
			TEST_ASSERT(!flapFB.Flaps[MAX_DRAFT_ZONES]);
			TEST_ASSERT(!flapFB.Flaps[3]);
			TEST_ASSERT(flapFB.Flaps[4]);
			
			for (i = 5; i <= (MAX_DRAFT_ZONES - 1); i++)
			{
				TEST_ASSERT(!flapFB.Flaps[i]);
			}
			state = 14;
		break;
		
		case 14:
			TEST_DONE;
            break;
    }
    TEST_BUSY;

}

// Bad: testing system/core functionality, this should be left to R&D.
_TEST test_MoveAbsolute(void)
{
    switch (state)
    {
        case TEST_ARRANGE:
            AxisParameters.Position = 10;
            AxisParameters.Velocity = 40;
            state = TEST_ACT;
            break;

        case TEST_ACT:
            switch (ActSubState)
            {
                case 0:
                    MpAxisBasic_0.MoveAbsolute = true;
                    TEST_BUSY_CONDITION(!MpAxisBasic_0.MoveActive);
                    ActSubState = 1;
                    break;
                case 1:
                    TEST_BUSY_CONDITION(MpAxisBasic_0.MoveActive);
                    MpAxisBasic_0.MoveAbsolute = false;
                    state = TEST_ASSERT;
                    break;
            }
            break;

        case TEST_ASSERT:
            TEST_ASSERT_FLOAT_WITHIN(0.01, 10.0, MpAxisBasic_0.Position);
            TEST_DONE;
            break;
    }
    TEST_BUSY;
}


