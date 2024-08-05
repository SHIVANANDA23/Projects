x_2=[3,-1,0,1,3,2,0,1,2,1];
h=[1,1,1,0,0];
M=3;
L=3;
N=L+M-1;
x1=[0,0,3,-1,0];
x2=[-1,0,1,3,2];
x3=[3,2,0,1,2];
x4=[1,2,1,0,0];
X1=[];
X2=[];
X3=[];
X4=[];
H=[];
%y1=[-1,0,3,2,2];
%y2=[4,1,0,4,6];
%y3=[6,7,5,3,3];
%y=[3,2,2,0,4,6,5,3,3];

X1=dft_fun(N,X1,x1)
X2=dft_fun(N,X2,x2)
X3=dft_fun(N,x3,x3)
X4=dft_fun(N,X4,x4)
H=dft_fun(N,H,h);
function X=dft_fun(N,X,x)
for k = 1:N
    X(k) = 0;
    for n = 1:N
        X(k) = X(k) + x(n) * exp(-1i * 2 * pi * (k-1) * (n-1) / N);
    end
end 
end
