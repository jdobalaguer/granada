
% convert dicom to nifti
%scan_dcm2nii(1:20);

% preprocess
scan3_preprocess();

% clean files
scan_clean();

% glm
scan3_glm();
