#!/usr/bin/perl

use strict;
use warnings;

my $ip = 0;
my $sp = 0;

my @stack;
my @jmp_stack;

open CODE, '<', $ARGV[0];

my @code = <CODE>;
my $codestr = join("", @code);
$codestr =~ s/\R//g;
@code = split("", $codestr);

@stack = split('}', $codestr);
my $stackstr = $stack[0];
$stackstr =~ s/{//g;
@stack = split(/\|/, $stackstr);

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
    }

    if($ARGV[1] && $ARGV[1] eq 'v')
    {
	print $e;
	print "\n".join('|', @stack)."\n";
    }

    if($e eq '?')
    {
	$ip = $stack[$sp];
    }
    else
    {
	$ip++;
    }
}
