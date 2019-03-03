#!/bin/bash
#This script will add the numbers by taking the iputs from user
#echo "Enter two value:"
echo "Enter the First number:"
read x
echo "Enter the Second number:"
read y
sum=`expr $x + $y`
echo "Addition of two number is: $sum"
