using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Diagnostics;



namespace fractals
{
    class root
    {
        public int x;
        public int[,] colors = new int[15, 3] { { 32, 132, 140 }, { 68, 148, 76 }, { 28, 148, 196 }, { 64, 84, 140 }, { 32, 20, 100 }, { 82, 20, 100 }, { 139, 0, 0 }, { 255, 215, 0 }, { 92, 192, 192 }, { 255, 127, 80 }, { 0, 132, 140 }, { 32, 55, 190 }, { 32, 0, 140 }, { 32, 200, 120 }, { 32, 32, 32 } };
        public double real, img;
        public root(int x, double real, double img)
        {
            this.real = real;
            this.img = img;
            this.x = x;
        }
    }
    class element
    {
        public int power;
        public double preFactor = 0;
        public bool has_x = false;
        double[] output = new double[2];       
        int[] prefactors;
        public element(string s)
        {
            if (s.Contains('x'))
            {
                has_x = true;
                string prefactor = "";
                int i = 0;
                while (s[i] != 'x')
                {
                    prefactor += s[i];
                    i++;
                }
                if (prefactor == "") prefactor += '1';
                preFactor = double.Parse(prefactor);
                prefactor = "";
                i += 2;
                while (i < s.Length)
                {
                    prefactor += s[i];
                    i++;
                }
                if (prefactor != "")
                {
                    power = int.Parse(prefactor);
                }
            }
            else
            {
                preFactor = double.Parse(s);
            }
            prefactors = get_prefactors(power);
        }
        public element(double prf, int power, bool cont)
        {
            preFactor = prf;
            has_x = cont;
            this.power = power;
            prefactors = get_prefactors(power);


        }      
        double pow(double x, int a)
        {        
            double b = 1;
            for(int i = 1; i <= a; i++)
            {
                b *= x;
            }
            return b;
        }
        public double[] get_values(double a, double b)
        {
            output[0] = 0;
            output[1] = 0;     
            for (int i = 0; i <= power; i++)
            {
                if (i % 2 == 0)
                {
                    if (i % 4 != 0)
                    {
                        output[0] -= preFactor * prefactors[i] * pow(a, power - i) * pow(b, i);
                    }
                    else
                    {
                        output[0] += preFactor * prefactors[i] * pow(a, power - i) * pow(b, i);
                    }
                }
                else
                {
                    if ((i - 1) % 4 != 0)
                    {
                        output[1] -= preFactor * prefactors[i] * pow(a, power - i) * pow(b, i);

                    }
                    else
                    {
                        output[1] += preFactor * prefactors[i] * pow(a, power - i) * pow(b, i);
                    }
                }

            }              
            return output;
        }
        int[] get_prefactors(int degree)
        {            
            int[] x = new int[degree + 1];
            for (int i = 0; i <= degree; i++)
            {
                x[i] = (factorial(degree) / (factorial(i) * factorial(degree - i)));
            }
            return x;
        }
        int factorial(int x)
        {
            int a = 1;
            for (int i = x; i > 1; i--)
            {
                a *= i;
            }
            return a;
        }
    }
    class polynomial
    {

        public List<element> vals = new List<element>();
        List<char> op = new List<char>();
        public List<element> dals = new List<element>();
        double[] pol_val = new double[2];
        double[] pol_derv_val = new double[2];
        double[] output = new double[2];
        double real;
        double img;
        public polynomial(string s)
        {
            string obj = "";
            for (int i = 0; i < s.Length; i++)
            {
                switch (s[i])
                {
                    case '+':
                        op.Add(s[i]);
                        vals.Add(new element(obj));
                        obj = "";
                        break;
                    case '-':
                        op.Add(s[i]);
                        vals.Add(new element(obj));
                        obj = "";
                        break;
                    default:
                        obj += s[i];
                        break;
                }
            }
            if (obj != "") vals.Add(new element(obj));
            for (int i = 1; i < vals.Count; i++)
            {
                if (op[i - 1] == '-')
                {
                    vals[i].preFactor = vals[i].preFactor * -1;
                }
            }
            foreach (var a in vals)
            {
                switch (a.has_x)
                {
                    case true:
                        switch (a.power)
                        {
                            case 0:
                                dals.Add(new element(a.preFactor, 0, false));
                                break;
                            default:
                                dals.Add(new element(a.preFactor * a.power, a.power - 1, true));
                                break;
                        }
                        break;
                    case false:
                        break;
                }
            }
        }
        public int get_degree()
        {
            List<int> degrees = new List<int>();
            foreach (var a in vals)
            {
                degrees.Add(a.power);
            }
            degrees.Sort();
            return degrees[degrees.Count - 1];
        }
        public double[] get_aproximation(double a, double b)
        {
            img = 0;
            real = 0;
            foreach (var el in vals)
            {
                if (el.has_x)
                {
                    if (el.power > 1)
                    {
                        real += el.get_values(a, b)[0];
                        img += el.get_values(a, b)[1];
                    }
                    else
                    {
                        real += el.preFactor * a;
                        img += el.preFactor * b;
                    }
                }
                else
                {
                    real += el.preFactor;
                }
            }
            pol_val[0] = real;
            pol_val[1] = img;
            img = 0;
            real = 0;      
            foreach (var el in dals)
            {
                if (el.has_x)
                {
                    if (el.power > 1)
                    {
                        double[] x = el.get_values(a, b);
                        real += x[0];
                        img += x[1];
                    }
                    else
                    {
                        real += el.preFactor * a;
                        img += el.preFactor * b;
                    }
                }
                else
                {
                    real += el.preFactor;
                }
            }
            pol_derv_val[0] = real;
            pol_derv_val[1] = img;
            output[0] = a - ((pol_val[1] * pol_derv_val[1] + pol_val[0] * pol_derv_val[0]) / (pol_derv_val[0] * pol_derv_val[0] + pol_derv_val[1] * pol_derv_val[1]));
            output[1] = b - (pol_val[1] * pol_derv_val[0] - pol_val[0] * pol_derv_val[1]) / (pol_derv_val[0] * pol_derv_val[0] + pol_derv_val[1] * pol_derv_val[1]);         
            return output;
        }
    }
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            AllocConsole();
        }

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool AllocConsole();
        private void Form1_Paint(object sender, PaintEventArgs e)
        {       
             
            AllocConsole();
            string s = "x^13-1";
            Console.WriteLine("lol");
            Bitmap myBitmap = new Bitmap(@"C:\Users\user\Desktop\intel.png");
            polynomial u = new polynomial(s);
            root[] rs = new root[u.get_degree()];
            HashSet<Tuple<double, double>> roots = new HashSet<Tuple<double, double>>();
            get_roots(u, ref roots, u.get_degree());
            int h = 0;
            foreach (var a in roots)
            {
                rs[h] = new root(h, a.Item1, a.Item2);
                h++;
            }
             Stopwatch stop = new Stopwatch();
            stop.Start();
            int ab = myBitmap.Width / 2;
            int ba = myBitmap.Height/ 2;
            for (int Xcount = 0; Xcount <ab*2; Xcount++)
            {
                
                for (int Ycount = 0; Ycount < ba*2; Ycount++)
                {
                   
                        get_root((double)3 * Xcount / ab - 3, ((double)3 * Ycount / ba - 3), Xcount, Ycount, ref u, ref rs, myBitmap);
                    
                }
                e.Graphics.DrawImage(myBitmap, 0, 0, myBitmap.Width,
          myBitmap.Height);
            }          
            


            return;
        }
        static void get_roots(polynomial u, ref HashSet<Tuple<double, double>> roots, int degree)
        {
            for (double i = 0; i < 300; i++)
            {
                for (double k = 0; k < 300; k++)
                {
                    double[] x = getroots((k - 150) / 75, (i - 150) / 75, u);
                    roots.Add(Tuple.Create(Math.Round(x[0], 2), Math.Round(x[1], 2)));
                    if (roots.Count >= degree) return;
                }
            }
        }
        static double[] getroots(double x, double y, polynomial u)
        {
            double[] nauja = new double[2];
            nauja[0] = x;
            nauja[1] = y;
            int i = 0;
            while (i < 500)
            {
                nauja = u.get_aproximation(nauja[0], nauja[1]);
                i++;
            }
            return nauja;
        }
        static void get_root(double x, double y, int A, int B, ref polynomial u, ref root[] a, Bitmap map)
        {
            double[] nauja = new double[2];
            nauja[0] = x;
            nauja[1] = y;
            int i = 0;
            bool br = false;
           
            while (i < 1000 && br == false)
            {
                nauja = u.get_aproximation(nauja[0], nauja[1]);
                foreach (var g in a)
                {
                    if (Math.Round(u.get_aproximation(nauja[0], nauja[1])[0], 2) == g.real && Math.Round(u.get_aproximation(nauja[0], nauja[1])[1], 2) == g.img)
                    {                       
                        map.SetPixel(A, B, Color.FromArgb(g.colors[g.x,0], g.colors[g.x, 1], g.colors[g.x, 2]));                                                                 
                        br = true;
                        break;
                    }
                } 
                i++;
            }        
        }
    }
 }


