﻿using app.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace app.DAO
{
    public class Staff_DAO
    {
        private static Staff_DAO instance;

        internal static Staff_DAO Instance
        {
            get { if (instance == null) instance = new Staff_DAO(); return Staff_DAO.instance; }
            private set { instance = value; }
        }

        private Staff_DAO() { }



        //@Note:
        //    Khi truy vấn query sẽ sử dụng 3 hàm sau: (Có thể xem chi tiết trong file "DTO/Staff_DTO.cs" )
        //    1, Select sử dụng ExecuteQuery
        //    2, Insert, Update, Delete sử dụng ExecuteNonQuery
        //    3, Đếm số lượng, tính giá trị max, min, giá trị trung bình cộng sử dụng ExecuteScalar


        //@Description:
        //    Lấy ra danh sách nhân viên trong hệ thống
        //@Prameter:
        //    nope
        //@Proc:
        //    exec USP_GetProfile @username
        //@Return:
        //    Staff_DTO  -----------     Trả về thông tin của nhân viên

        public Staff_DTO Get_Info(string username)
        {
            // tạo chuỗi thực thi Strod Procdure
            string query = "exec USP_GetProfile @username";

            //Đổ dữ liệu và 1 bảng có sẵn trong hệ thống tên là "DataTable"
            DataTable Staff_info = Connect.Instance.ExecuteQuery(query, new object[]{ username });

            Staff_DTO staff = null;

            // Đỗi tượng DataRow là từng dòng trong đối tượng DataTable 
            // (Có thể bỏ vòng lặp này do số lượng dòng ta cấn truy xuất bằng 1 hoặc 0)
            foreach (DataRow item in Staff_info.Rows)
            {
                  staff = new Staff_DTO(item);
            }

            return staff;
        }

        //@Description:
        //    Lấy ra danh sách nhân viên trong hệ thống
        //@Prameter:
        //    nope
        //@Proc:
        //    exec USP_GetListStaff
        //@Return:
        //    List<Staff_DTO>  -----------     Trả về danh sách nhân viên
        public List<Staff_DTO> List_Staff ()
        {
            string query = "exec USP_GetListStaff";
            DataTable List_staff = Connect.Instance.ExecuteQuery(query);

            List<Staff_DTO> list_staff = new List<Staff_DTO>();
            foreach (DataRow item in List_staff.Rows)
            {
                Staff_DTO staff = new Staff_DTO(item);
                list_staff.Add(staff);
            }
            return list_staff;
        }


        //@Description:
        //    Chỉnh sửa thông tin cá nhân của nhân viên
        //@Prameter:
        //    Staff_DTO staff       ---------------- Nhận vào 1 thông tin của nhân viên cần sửa.
        //@Proc:
        //    exec USP_EditStaff @username , @displayname , @sex , @birthday , @address , @phone , @email , @image
        //@Return:
        //    Boolean  -----------     Trả về thành công hay thất bại

        public bool Edit_Info_Staff(Staff_DTO staff)
        {
            string query = "exec USP_EditStaff @username , @displayname , @sex , @birthday , @address , @phone , @email , @image";
            // #record trả về số lượng dòng đã được update hay insert.
            int record = Connect.Instance.ExecuteNonQuery(query, new object[] { staff.Username, staff.Name, staff.Sex, staff.Birthday, staff.Address, staff.Phone, staff.Email, staff.Image });

            return record == 1;
        }



        public List<Staff_DTO> Search_Staff(String keyword, int type_search)
        {
            List<Staff_DTO> list_search_staff = new List<Staff_DTO>();
            return list_search_staff;
        }
        

        public int Get_Role(String username)
        {
            string query = "exec USP_GetRole @username";
            DataTable table = Connect.Instance.ExecuteQuery(query, new object[] { username });
            int role = -1;
            foreach (DataRow item in table.Rows)
            {
                role = (int)item["id_type"];
            }
            return role;
        }

        public bool Check_Username(string username)
        {
            string query = "exec USP_CheckUserName @username";
            int x = (int)Connect.Instance.ExecuteScalar(query, new object[] { username });
            return x == 0;
        }


        public bool Insert_Account(string username, string password, int id_type)
        {
            string query = "exec USP_InsertAccount @username , @password , @id_type";
            int x = Connect.Instance.ExecuteNonQuery(query, new object[] { username, password, id_type });
            return x == 1;
        }

        public bool Ban_Account(string username)
        {
            string query = "exec USP_BanAccount @username";
            int x = Connect.Instance.ExecuteNonQuery(query, new object[] { username });
            return x == 1;
        }

        public bool Check_Email(string email)
        {
            string query = "exec USP_CheckEmailStaff @email";
            int x = (int)Connect.Instance.ExecuteOutPut(query, new object[] { email });
            return x == 1;
        }

        public bool Insert_Staff(System_DTO account, Staff_DTO staff)
        {
            string query = "exec USP_AddStaff @username , @password , @role , @displayname , @sex , @birthday , @address , @phone , @email , @image";
            int x = (int)Connect.Instance.ExecuteOutPut(query, new object[] { account.Username, account.Password, account.Id_type, staff.Name, staff.Sex, staff.Birthday, staff.Address, staff.Phone, staff.Email, staff.Image });
            return x == 2;
        }

       public List<Staff_DTO> GetListStaffSearch(string keyword)
        {
            string query = "exec USP_SearchStaff @keyword";
            DataTable List_staff = Connect.Instance.ExecuteQuery(query, new object[] { keyword });

            List<Staff_DTO> list_staff = new List<Staff_DTO>();
            foreach (DataRow item in List_staff.Rows)
            {
                Staff_DTO staff = new Staff_DTO(item);
                list_staff.Add(staff);
            }
            return list_staff;
        }
    }
}
