using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

public class Challenge2
{
    int a = 0;
    int b = 0;
    int c = 1;
    int d = 0;
    int instructionPointer = 0;

    private int read(String value)
    {
        if(value == "a") return a;
        if(value == "b") return b;
        if(value == "c") return c;
        if(value == "d") return d;
        return Int32.Parse(value);
    }

    private void write(String address, int value)
    {
        if(address == "a") a = value;
        if(address == "b") b = value;
        if(address == "c") c = value;
        if(address == "d") d = value;
    }

    private Action getCpy(string instruction)
    {
        string pattern = @"cpy (\w+) (\w+)";
        Match  m = Regex.Match(instruction, pattern);
        return () => {
            write(m.Groups[2].ToString(), read(m.Groups[1].ToString()));
            instructionPointer++;
        };
    }

    private Action getInc(string instruction)
    {
        string pattern = @"inc (\w+)";
        Match  m = Regex.Match(instruction, pattern);
        return () => {
            write(m.Groups[1].ToString(), read(m.Groups[1].ToString())+1);
            instructionPointer++;
        };
    }

    private Action getDec(string instruction)
    {
        string pattern = @"dec (\w+)";
        Match  m = Regex.Match(instruction, pattern);
        return () => {
            write(m.Groups[1].ToString(), read(m.Groups[1].ToString())-1);
            instructionPointer ++;
        };
    }

    private Action getJnz(string instruction)
    {
        string pattern = @"jnz (\w+) ([-|\w]+)";
        Match  m = Regex.Match(instruction, pattern);
        return () => {
            if (read(m.Groups[1].ToString()) != 0)
            {
                instructionPointer = instructionPointer + read(m.Groups[2].ToString());
            }
            else
            {
                instructionPointer++;
            }
        };
    }
    
    private  string[] readFile()
    {
        return System.IO.File.ReadAllLines("../day12.txt");
    }

    private Action getInstruction(string instruction)
    {
        instruction = instruction.Trim();
        if (instruction.StartsWith("cpy")) return getCpy(instruction);
        if (instruction.StartsWith("inc")) return getInc(instruction);
        if (instruction.StartsWith("dec")) return getDec(instruction);
        else return getJnz(instruction);
    }

    private void printRegisters()
    {
        System.Console.WriteLine("B is: " + b);
    }

    private void solve()
    {
        string[] lines = readFile();
        IEnumerable<Action> instructions = lines.Select(i => getInstruction(i));
        while(instructionPointer < instructions.Count())
        {
            //System.Console.WriteLine("B is: " + b);
            //System.Console.WriteLine(instructionPointer);
            instructions.ElementAt(instructionPointer)();
        }
        System.Console.WriteLine("A is: " + a);

        
    }
    static public void Main ()
    {
        Challenge2 challenge2 = new Challenge2();
        challenge2.solve();        
    }
}