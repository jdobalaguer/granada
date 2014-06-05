
function data = ext_response(data)
    %% binary response
    data.resp_right = sign2bin(bin2sign(mod(data.exp_subject,2)) .* bin2sign(data.resp_gamble));
    
    %% signed response
    data.resp_signed_gamble = bin2sign(data.resp_gamble); data.resp_signed_gamble(isnan(data.resp_signed_gamble)) = 0;
    data.resp_signed_right  = bin2sign(data.resp_right ); data.resp_signed_right( isnan(data.resp_signed_right )) = 0;
    
end


