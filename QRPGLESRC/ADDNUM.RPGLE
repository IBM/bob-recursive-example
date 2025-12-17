**FREE
ctl-opt dftactgrp(*no) actgrp(*caller);

dcl-s number1 int(10) inz(5);
dcl-s number2 int(10) inz(7);
dcl-s sum int(10);

sum = number1 + number2;

dsply ('Sum of ' + %char(number1) + ' and ' + %char(number2) + ' is ' + %char(sum));

*inlr = *on;
return;
