using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Menu.Data.constants
{

    public class CustomException
    {
        public static int EmailNotConfirmedCode = 9000;
        public static int BusinessAlreadyCreatedCode = 9001;
        public static int NoOfRestaurantExceededCode = 9002;
        public static int NoOfMenuExceededCode = 9003;
        public static int RestaurantInactiveCode = 9004;
    }

    public class EmailNotConfirmedException
    {
        public static int Code = 9000;
        public static string Message = "EMAIL NOT CONFIRMED";
    }

}
