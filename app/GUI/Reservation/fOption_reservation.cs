﻿using System;
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
    public partial class fOption_reservation : Form
    {
        public fOption_reservation()
        {
            InitializeComponent();
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

        private void fOption_reservation_Load(object sender, EventArgs e)
        {
            this.cb_option.SelectedIndex = 0;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if(cb_option.SelectedIndex != -1)
            {
                if(cb_option.SelectedIndex == 0)
                {
                    fChange_calendar frm = new fChange_calendar();
                    frm.Id_reservation = this.Id_reservation;
                    this.Hide();
                    frm.ShowDialog();
                }
                else
                {
                    if (cb_option.SelectedIndex == 1)
                    {
                        GUI.Room.fCancel_room frm = new Room.fCancel_room();
                        frm.Id_reservation = this.id_reservation;
                        this.Hide();
                        frm.ShowDialog();
                    }
                    else
                    {
                        GUI.Room.fSwap_room frm = new Room.fSwap_room();
                        frm.Id_reservation = this.id_reservation;
                        this.Hide();
                        frm.ShowDialog();
                    }
                }
            }
            else
            {
                MessageBox.Show("Error! You check select option");
            }
        }

        private void cb_option_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }
    }
}
