using System;

namespace paieska {
    class Program {
        static int FindOne(char[,] A, string word, int n) {
            int index;
            int count = 0;
            for (int i = 0; i < n; i++) {
                index = 0;
                for (int j = 0; j < n; j++) {
                    if (A[i, j] == word[index]) {
                        index++;
                    } else {
                        index = 0;
                    }
                    if (index == word.Length) {
                        count++;
                        index = 0;
                    }
                }
            }
            return count;
        }
        static int FindTwo(char[,] A, string word, int n) {
            int index;
            int count = 0;
            for (int i = 0; i < n; i++) {
                index = 0;
                for (int j = 0; j < n; j++) {
                    if (A[j, i] == word[index]) {
                        index++;
                    } else {
                        index = 0;
                    }
                    if (index == word.Length) {
                        count++;
                        index = 0;
                    }
                }
            }
            return count;
        }
        static int FindThree(char[,] A, string word, int n) {
            int x = 0;
            int y = 0;
            int index = 0;
            int count = 0;
            while (x < n && y < n) {
                if (A[x, y] == word[index]) {
                    index++;
                } else {
                    index = 0;
                }
                if (index == word.Length) {
                    count++;
                    index = 0;
                }
                x++;
                y++;
            }
            for (int i = 1; i < n; i++) {
                x = i;
                y = 0;
                index = 0;
                while (x < n && y < n) {
                    if (A[x, y] == word[index]) {
                        index++;
                    } else {
                        index = 0;
                    }
                    if (index == word.Length) {
                        count++;
                        index = 0;
                    }
                    x++;
                    y++;
                }
                x = 0;
                y = i;
                index = 0;
                while (x < n && y < n) {
                    if (A[x, y] == word[index]) {
                        index++;
                    } else {
                        index = 0;
                    }
                    if (index == word.Length) {
                        count++;
                        index = 0;
                    }
                    x++;
                    y++;
                }
            }
            return count;
        }
        static void Print(string[] words, char[,] A, int n) {
            Console.WriteLine("n = {0}", n);
            foreach (string word in words) {
                Console.WriteLine("{0} {1}", word.ToLower(), FindOne(A, word.ToLower(), n) + FindTwo(A, word.ToLower(), n) + FindThree(A, word.ToLower(), n));
            }
        }
        static void Fill(char[,] A, char[] temp, int length, int n) {
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    A[i, j] = n * i + j < length ? temp[n * i + j] : ' ';
                }
            }
        }
        static void FillTemp(string file, char[] temp, ref int length) {
           for (int i = 0; i < file.Length; i++) {
                if (file[i] != '\n') {
                    temp[length++] = file[i];
                }
            }
        }
        static void Main(string[] args) {
            int length = 0;
            char[,] A = new char[45, 45];
            char[] temp = new char[2000];
            string file = System.IO.File.ReadAllText("../../../Trecias.txt").ToLower();
            string[] words = System.IO.File.ReadAllLines("../../../Zodziai.txt");
            FillTemp(file, temp, ref length);
            int n = (int)Math.Ceiling(Math.Sqrt(length));
            Fill(A, temp, length, n);
            Print(words, A, n);
        }
    }
}
