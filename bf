#!/usr/bin/perl

use strict;
use warnings;

my $ip = 0;
my $sp = 0;
my $sto = 0;

my @jmp_stack;

open CODE, '<', $ARGV[0];

my @code = <CODE>;
my $codestr = join("", @code);
$codestr =~ s/\R//g;
@code = split("@", $codestr);
my @stack = split(m/\|/, $code[1]);
@code = split("", $code[0]);

while($ip < scalar(@code))
{
    my $e = $code[$ip];

    if(!$stack[$sp])
    {
	$stack[$sp] = 0;
    }

    if($e eq "+")#Traditional Brainfuck
    {
	$stack[$sp]++;	
    }elsif($e eq '-'){
	$stack[$sp]--;	
    }elsif($e eq '<'){
	if($sp == 0)
	{
	    $sp = 1024;
	}
	else
	{
	    $sp--;
	}
    }elsif($e eq '>'){
	if($sp == 1024)
	{
	    $sp = 0;
	}
	else
	{
	    $sp++;
	}
    }elsif($e eq '['){
	push(@jmp_stack, $ip);
    }elsif($e eq ']'){
	if($stack[$sp] <= 0)
	{
	    pop(@jmp_stack);
	    $stack[$sp] = 0;
	}
	else
	{
	    $ip = pop(@jmp_stack);
	    push(@jmp_stack, $ip);
	}
    }elsif($e eq '.'){
	print chr($stack[$sp]);
    }elsif($e =~ m/[0-9A-Fa-f]/){#Type I Extensions #Fast Init
	$stack[$sp] += hex($e) * 10;
    }elsif($e eq '$'){#Set sto
	$sto = $stack[$sp];
    }elsif($e eq '!'){#Get sto
	$stack[$sp] = $sto;
    }elsif($e eq '@'){#jmp to sto stack
	die;
    }

    if($ARGV[1] && $ARGV[1] eq 'v')
    {
	print $e;
	print "\n".join('|', @stack)."\n";
    }

    if($e eq '?')
    {
	$ip = $stack[$sp];
    }elsif($e eq '^'){#jmp to sto ip
	$ip = $sto;
    }
    else
    {
	$ip++;
    }
}
