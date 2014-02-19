
if blockstruct.nb_trials > i_trial; return; end

% end of block
end_of_block = 1;

% close textures
for i_texture = 1:blockstruct.nb_trials
    Screen('Close', blockstruct.vb_g(i_texture));
end
