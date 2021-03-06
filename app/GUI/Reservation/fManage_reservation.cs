﻿using app.BUS;
using app.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace app.GUI.Reservation
{
    public partial class fManage_reservation : Form
    {
        public fManage_reservation()
        {
            InitializeComponent();
        }


        private void label1_Click(object sender, EventArgs e)
        {

        }

        private int id_reservation;


        public int Id_reservation
        {
            get
            {
                return id_reservation;
            }

            set
            {
                id_reservation = value;
            }
        }


        private void Load_Data()
        {
            this.cb_status_reservation.SelectedIndex = 0;
            List<Reservation_DTO> list_resevation = Reservation_BUS.Instance.GetListReservationByFilter(0);
            List<Reservation_DGV> list_reservation_dgv = new List<Reservation_DGV>();
            foreach(Reservation_DTO reservation in list_resevation)
            {
                Reservation_DGV reservation_dgv = new Reservation_DGV(reservation.Id_reservation, reservation.Customer.Name, reservation.Is_group, reservation.People, reservation.Staff.Username, reservation.Status_reservation);
                list_reservation_dgv.Add(reservation_dgv);
            }
            dgv_reservation.DataSource = list_reservation_dgv;
        }

        private void fManage_reservation_Load(object sender, EventArgs e)
        {
            Load_Data();
        }

        private void dgv_reservation_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                int id_reservation = (int)dgv_reservation.Rows[e.RowIndex].Cells[0].Value;
                this.id_reservation = id_reservation;
                Reservation_DTO reservation = Reservation_BUS.Instance.GetInfoReservation(id_reservation);
                Calendar_DTO calendar = Calendar_BUS.Instance.GetCalendarReservationUsing(id_reservation);

                lb_id.Text = id_reservation.ToString();
                lb_customer.Text = reservation.Customer.Name;
                if(calendar != null)
                {
                    lb_start_date.Text = calendar.Start_date.ToString();
                    lb_end_date.Text = calendar.End_date.ToString();
                }
                else
                {
                    Calendar_DTO calendar_laster = Calendar_BUS.Instance.GetInfoCalendarLaster(id_reservation);
                    lb_start_date.Text = calendar_laster.Start_date.ToString();
                    lb_end_date.Text = calendar_laster.End_date.ToString();
                }

                if (reservation.Is_group == true)
                    lb_group.Text = "Yes";
                else
                    lb_group.Text = "No";

                lb_people.Text = reservation.People.ToString();
                if(reservation.Status_reservation == 0)
                {
                    lb_status.Text = "Đã hủy";
                }else
                {
                    if(reservation.Status_reservation == 1)
                    {
                        lb_status.Text = "Hoàn tất";
                    }
                    else if(reservation.Status_reservation == 2) {
                        lb_status.Text = "Chưa thanh toán";
                    }
                    else
                    { lb_status.Text = "Chưa Đặt cọc"; }
                }
            }
            catch
            {
                MessageBox.Show("Selected Error!");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {

        }

        private void btn_room_Click(object sender, EventArgs e)
        {
            if(this.id_reservation != 0)
            {
                fCheck_room frm = new fCheck_room();
                frm.Id_reservation = this.id_reservation;
                frm.ShowDialog();
                this.id_reservation = 0;
            }
            else
            {
                MessageBox.Show("You must select reservation!");
            }
            
        }

        private void btn_service_Click(object sender, EventArgs e)
        {
            if(this.id_reservation != 0)
            {
                fCheck_Service frm = new fCheck_Service();
                frm.Id_reservation = this.id_reservation;
                frm.ShowDialog();
                this.id_reservation = 0;
            }
            else
            {
                MessageBox.Show("You must select reservation!");
            }
        }

        private void btn_calendar_Click(object sender, EventArgs e)
        {
            if (this.id_reservation != 0)
            {
                fCheck_calendar frm = new fCheck_calendar();
                frm.Id_reservation = this.id_reservation;
                frm.ShowDialog();
                this.id_reservation = 0;
            }
            else
            {
                MessageBox.Show("You must select reservation!");
            }
        }

        private void btn_refresh_Click(object sender, EventArgs e)
        {
            Load_Data();
        }

        private void btn_add_Click(object sender, EventArgs e)
        {
            fAdd_reservation frm = new fAdd_reservation();
            frm.ShowDialog();
            this.Load_Data();
        }

        private void btn_delete_Click(object sender, EventArgs e)
        {
            if(this.id_reservation != 0)
            {
                int status = Reservation_BUS.Instance.GetInfoReservation(this.id_reservation).Status_reservation;
                if(status != 0 && status != 1)
                {
                    if (Reservation_BUS.Instance.Cancel_Reservation(this.id_reservation))
                    {
                        MessageBox.Show("Canced Reservation!");
                        this.id_reservation = 0;
                        Load_Data();
                    }
                    else
                    {
                        MessageBox.Show("Error! Resevation was cancel!");
                    }
                }
                else
                {
                    MessageBox.Show("Error! Reservation is not cancel!");
                }
            }
            else
            {
                MessageBox.Show("You must select Reservation");
            }

            this.id_reservation = 0;
        }

        private void btn_back_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_chechout_Click(object sender, EventArgs e)
        {
            if (this.id_reservation != 0)
            {   //Thoi hien tai phai lon hon thoi gian cua phieu dat
                if(Reservation_BUS.Instance.GetInfoReservation(this.id_reservation).Status_reservation == 2)
                {
                    if (DateTime.Compare(DateTime.Now, Calendar_BUS.Instance.GetCalendarReservationUsing(this.id_reservation).End_date) > 0)
                    {
                        if (Reservation_BUS.Instance.CheckConfirmBillByReservation(id_reservation) == false)
                        {
                            int id_bill = Bill_BUS.Instance.InsertBill(this.id_reservation, DTO.Session.username);
                            GUI.Bill.fCheckOut frm = new GUI.Bill.fCheckOut();
                            frm.Id_bill = id_bill;
                            this.Close();
                            frm.ShowDialog();
                            this.id_reservation = 0;
                        }
                        else
                        {
                            MessageBox.Show("Reservation has finshed paid!");
                            this.id_reservation = 0;
                        }
                    }
                    else
                    {
                        MessageBox.Show("The reservation cannot check out! Please edit date end of the reservation");
                        this.id_reservation = 0;
                    }
                }
                else
                {
                    MessageBox.Show("The reservation cannot check out");
                    this.id_reservation = 0;
                }
            }
            else
            {
                MessageBox.Show("You must select reservation");
                this.Id_reservation = 0;
            }
            
        }

        private void btn_search_Click(object sender, EventArgs e)
        {
            bool flat = true;
            if(txt_search.Text == "")
            {
                flat = false;
                MessageBox.Show("Error! Key word is not emtyl");
                return;
            }
            if(cb_search.SelectedIndex == -1)
            {
                flat = false;
                MessageBox.Show("Error! You must select option!");
                return;
            }

            if (flat)
            {

                this.dgv_reservation.DataSource = null;
                List<Reservation_DTO> list_resevation = Reservation_BUS.Instance.Search_Reservation(this.cb_search.SelectedIndex, txt_search.Text);
                List<Reservation_DGV> list_reservation_dgv = new List<Reservation_DGV>();
                foreach (Reservation_DTO reservation in list_resevation)
                {
                    Reservation_DGV reservation_dgv = new Reservation_DGV(reservation.Id_reservation, reservation.Customer.Name, reservation.Is_group, reservation.People, reservation.Staff.Username, reservation.Status_reservation);
                    list_reservation_dgv.Add(reservation_dgv);
                }
                dgv_reservation.DataSource = list_reservation_dgv;
            }
        }

        private void btn_details_Click(object sender, EventArgs e)
        {
            fReservation_info frm = new fReservation_info();
            frm.ShowDialog();
        }

        private void btn_check_deposit_Click(object sender, EventArgs e)
        {
            if(this.id_reservation != 0)
            {
                fCheck_deposit frm = new fCheck_deposit();
                frm.Id_reservation = this.id_reservation;
                frm.ShowDialog();
                this.id_reservation = 0;
            }
            else
            {
                MessageBox.Show("You must select reservation");
                this.Id_reservation = 0;
            }
            
        }

        private void btn_edit_Click(object sender, EventArgs e)
        {
            if(this.id_reservation != 0)
            {
                int status = Reservation_BUS.Instance.GetInfoReservation(this.id_reservation).Status_reservation;
                if (status != 0 && status != 1)
                {
                    fOption_reservation frm = new fOption_reservation();
                    frm.Id_reservation = this.Id_reservation;
                    this.Hide();
                    frm.ShowDialog();
                    this.Show();
                    this.id_reservation = 0;
                }
                else
                {
                    MessageBox.Show("Error! Reservation is not edit!");
                }
            }
            else
            {
                MessageBox.Show("You must select reservation!");
            }

            this.Load_Data();
        }

        private void cb_status_reservation_SelectedIndexChanged(object sender, EventArgs e)
        {

            List<Reservation_DTO> list_resevation = Reservation_BUS.Instance.GetListReservationByFilter(this.cb_status_reservation.SelectedIndex);
            List<Reservation_DGV> list_reservation_dgv = new List<Reservation_DGV>();
            foreach (Reservation_DTO reservation in list_resevation)
            {
                Reservation_DGV reservation_dgv = new Reservation_DGV(reservation.Id_reservation, reservation.Customer.Name, reservation.Is_group, reservation.People, reservation.Staff.Username, reservation.Status_reservation);
                list_reservation_dgv.Add(reservation_dgv);
            }
            dgv_reservation.DataSource = list_reservation_dgv;

        }

        private void btn_detail_Click(object sender, EventArgs e)
        {
            if (this.id_reservation != 0)
            {
                if (System_BUS.Instance.Get_Account(DTO.Session.username).Id_type == 1)
                {
                    fReservation_info frm = new fReservation_info();
                    frm.Id_reservation = this.id_reservation;
                    frm.ShowDialog();
                }
                else
                {
                    MessageBox.Show("You don't have permission to view details!");
                    this.id_reservation = 0;
                }
            }
            else
            {
                MessageBox.Show("You must select customer!");
            }
        }

        private void ptb_export_Click(object sender, EventArgs e)
        {
            Microsoft.Office.Interop.Excel._Application excel = new Microsoft.Office.Interop.Excel.Application();
            Microsoft.Office.Interop.Excel._Workbook workbook = excel.Workbooks.Add(Type.Missing);
            Microsoft.Office.Interop.Excel._Worksheet worksheet = null;

            try
            {

                worksheet = workbook.ActiveSheet;

                worksheet.Name = "Data Export";

                worksheet = workbook.ActiveSheet;
                worksheet.Range[worksheet.Cells[1, 1], worksheet.Cells[1, dgv_reservation.Columns.Count]].Merge();
                worksheet.Cells[1, 1].Value = "List Reservation";
                worksheet.Cells[1, 1].Font.Size = 20;

                for (int i = 1; i <= dgv_reservation.Columns.Count; i++)
                {
                    worksheet.Cells[2, i] = dgv_reservation.Columns[i - 1].HeaderText;

                    worksheet.Cells[2, i].Font.Bold = true;
                }

                for (int i = 1; i <= dgv_reservation.Rows.Count; i++)
                {
                    for (int j = 1; j <= dgv_reservation.Columns.Count; j++)
                    {
                        worksheet.Cells[i + 2, j] = dgv_reservation.Rows[i - 1].Cells[j - 1].Value.ToString();
                    }
                }



                SaveFileDialog saveDialog = new SaveFileDialog();
                saveDialog.Filter = "Excel files (*.xlsx)|*.xlsx|All files (*.*)|*.*";
                saveDialog.FilterIndex = 2;

                if (saveDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    workbook.SaveAs(saveDialog.FileName);
                    MessageBox.Show("Export Successful");
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                excel.Quit();
                workbook = null;
                excel = null;
            }
        }

        Bitmap bmp;
        private void printDocument1_PrintPage(object sender, System.Drawing.Printing.PrintPageEventArgs e)
        {
            e.Graphics.DrawImage(bmp, 0, 0);
        }

        private void ptb_print_Click(object sender, EventArgs e)
        {
            try
            {
                int heght = dgv_reservation.Height;
                dgv_reservation.Height = dgv_reservation.RowCount * dgv_reservation.RowTemplate.Height * 2;
                bmp = new Bitmap(dgv_reservation.Width, dgv_reservation.Height);
                dgv_reservation.DrawToBitmap(bmp, new Rectangle(0, 0, dgv_reservation.Width, dgv_reservation.Height));
                dgv_reservation.Height = heght;
                printPreviewDialog1.ShowDialog();
                dgv_reservation.Height = 301;
                dgv_reservation.Width = 655;
            }
            catch
            {
                MessageBox.Show("Not find data!");
                dgv_reservation.Height = 301;
                dgv_reservation.Width = 655;
            }
        }
    }
}
