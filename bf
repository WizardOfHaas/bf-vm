#!/usr/bin/perl

use strict;
use warnings;

my $ip = 0;

my $sp = 0;
my $sn = 0;

my $sto = 0;

my @jmp_stack;

open CODE, '<', $ARGV[0];

my @code = <CODE>;
my $codestr = join("", @code);
$codestr =~ s/\R//g;
@code = split("@", $codestr);
my @stack = split(m/\|/, $code[1]);
@code = split("", $code[0]);

my @stacks = ([@stack], []);

while($ip < scalar(@code))
{
    my $e = $code[$ip];

    if(!$stacks[$sn][$sp])
    {
	$stacks[$sn][$sp] = 0;
    }

    if($e eq "+")#Traditional Brainfuck
    {
	$stacks[$sn][$sp]++;	
    }elsif($e eq '-'){
	$stacks[$sn][$sp]--;	
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
	if($stacks[$sn][$sp] <= 0)
	{
	    pop(@jmp_stack);
	    $stacks[$sn][$sp] = 0;
	}
	else
	{
	    $ip = pop(@jmp_stack);
	    push(@jmp_stack, $ip);
	}
    }elsif($e eq '.'){
	print chr($stacks[$sn][$sp]);
    }elsif($e =~ m/[0-9A-Fa-f]/){#Type I Extensions #Fast Init
	$stacks[$sn][$sp] += hex($e) * 10;
    }elsif($e eq '$'){#Set sto
	$sto = $stacks[$sn][$sp];
    }elsif($e eq '!'){#Get sto
	$stacks[$sn][$sp] = $sto;
    }elsif($e eq '@'){#jmp to sto stack
	die;
    }

    if($ARGV[1] && $ARGV[1] eq 'v')
    {
	print $e;
	print "\n".join('|', $stacks[$sn])."\n";
    }

    if($e eq '?')
    {
	$ip = $stacks[$sn][$sp];
    }elsif($e eq '^'){#jmp to sto ip
	$ip = $sto;
    }
    else
    {
	$ip++;
    }
}
