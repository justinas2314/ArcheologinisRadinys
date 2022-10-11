using System;
using System.Collections;

namespace arkliai
{
    class Program {
        static bool MarkPath(ref Queue queuex, ref Queue queuey, bool[,] queued, char[,] board, int[,] dist, int sx, int sy, char dest) {
            int x;
            int y;
            int[,] indexes = {
                {sx - 2, sy - 1},
                {sx - 2, sy + 1},
                {sx + 2, sy - 1},
                {sx + 2, sy + 1},
                {sx - 1, sy - 2},
                {sx - 1, sy + 2},
                {sx + 1, sy - 1},
                {sx + 1, sy + 1}
            };
            for (int i = 0; i < 8; i++) {
                x = indexes[i, 0];
                y = indexes[i, 1];
                if (x < 0 || x > 7 || y < 0 || y > 7 || queued[x, y]) {
                    continue;
                }
                if (board[x, y] == dest) {
                    dist[x, y] = dist[sx, sy] + 1;
                    return true;
                } else if (board[x, y] == '0') {
                    queued[x, y] = true;
                    dist[x, y] = dist[sx, sy] + 1;
                    queuex.Enqueue(indexes[i, 0]);
                    queuey.Enqueue(indexes[i, 1]);
                }
            }
            return false;
        }
        static int PathFinder(char[,] board, int[,] dist, int x, int y, char dest, int delta) {
            Queue queuex = new Queue();
            Queue queuey = new Queue();
            bool[,] queued = new bool[8, 8];
            for (int i = 0; i < 8; i++) {
                for (int j = 0; j < 8; j++) {
                    queued[i, j] = false;
                    dist[i, j] = delta;
                }
            }
            do {
                if (MarkPath(ref queuex, ref queuey, queued, board, dist, x, y, dest)) {
                    return dist[x, y] + 1;
                } else {
                    x = (int)queuex.Dequeue();
                    y = (int)queuey.Dequeue();
                }
            } while (queuex.Count != 0);
            Console.WriteLine("Kelias nerastas");
            return -1;
        }
        static void TransferPath(char[,] board, int[,] output, int[,] dist, int sx, int sy, char dest) {
            int x;
            int y;
            int[,] indexes = {
                {sx - 2, sy - 1},
                {sx - 2, sy + 1},
                {sx + 2, sy - 1},
                {sx + 2, sy + 1},
                {sx - 1, sy - 2},
                {sx - 1, sy + 2},
                {sx + 1, sy - 1},
                {sx + 1, sy + 1}
            };
            for (int i = 0; i < 8; i++) {
                x = indexes[i, 0];
                y = indexes[i, 1];
                if (x < 0 || x > 7 || y < 0 || y > 7) {
                    continue;
                } else if (board[x, y] == dest) {
                    return;
                } else if (dist[x, y] + 1 == dist[sx, sy]) {
                    board[x, y] = 'c';
                    output[x, y] = dist[x, y];
                    TransferPath(board, output, dist, x, y, dest);
                    return;
                }
            }
        }
        static void Spausdinimas(char[,] board, int[,] output) {
            Console.WriteLine("  1 2 3 4 5 6 7 8");
            for (int i = 0; i < 8; i++) {
                Console.Write("{0} ", i + 1);
                for (int j = 0; j < 8; j++) {
                    if (board[i, j] == '0') {
                        Console.Write("- ");
                    }
                    else if (board[i, j] == 'c') {
                        Console.Write("{0} ", output[i, j]);
                    }
                    else {
                        Console.Write("{0} ", board[i, j]);
                    }
                }
                Console.Write("\n");
            }
        }
        static void Nuskaitymas(char[,] board, int[,] dist, int[,] output, out int sx, out int sy, out int ex, out int ey) {
            string[] t;
            string[] text = System.IO.File.ReadAllText("..\\..\\..\\U3.txt").Split('\n');
            sx = 0;
            sy = 0;
            ex = 0;
            ey = 0;
            for (int i = 0; i < 8; i++) {
                t = text[i].Split(' ');
                for (int j = 0; j < 8; j++) {
                    if (t[j][0] == 'Z') {
                        sx = i;
                        sy = j;
                    }
                    else if (t[j][0] == 'K') {
                        ex = i;
                        ey = j;
                    }
                    board[i, j] = t[j][0];
                    dist[i, j] = 0;
                    output[i, j] = 0;
                }
            }
        }
        static void Main(string[] args) {
            int sx, sy, ex, ey;
            string[] t;
            char[,] board = new char[8, 8];
            int[,] dist = new int[8, 8];
            int[,] output = new int[8, 8];
            Nuskaitymas(board, dist, output, out sx, out sy, out ex, out ey);
            int delta = PathFinder(board, dist, sx, sy, 'K', 0);
            if (delta == -1) {
                return;
            }
            TransferPath(board, output, dist, ex, ey, 'Z');
            delta = PathFinder(board, dist, ex, ey, 'Z', delta);
            if (delta == -1) {
                return;
            }
            TransferPath(board, output, dist, sx, sy, 'K');
            Spausdinimas(board, output);
        }
    }
}
