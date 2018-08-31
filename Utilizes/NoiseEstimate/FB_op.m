function y=FB_op(xx,tt,Phi,block_size,num_rows, num_cols) % Ax and ATx operation for comressive imaging

if tt==0 %Ax
    x = im2col(xx, [block_size block_size], 'distinct');
    y = Phi * x;
else % ATx
    xb = Phi' * xx;
    y = col2im(xb, [block_size block_size], ...
    [num_rows num_cols], 'distinct'); 
end