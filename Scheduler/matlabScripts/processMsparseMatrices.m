if ~ exist('../../test_mat/exported', 'dir')
    mkdir('../../test_mat/exported');
end
    load('../cppFiles/filename.mat','file')
    %file='rajat11';
    % load Matrix from file
    fileName = strcat(file,".mat");
    fprintf('Processing matrix %s\n', fileName);
    structure = load(strcat('../../test_mat/',fileName));
    A = structure.Problem.A;
    if isfield(structure.Problem,'b')
    	B = structure.Problem.b;
    end
    
    % AMD ordering and LU decomposition
    Pamd = amd(A);
    C = A(Pamd, Pamd);
    [Lc, Uc, Pc] = lu(C);
    % [La, Ua, Pa] = lu(A);
    ALUc = Pc * C;
    % ALUa = La * Ua;
    % Store matrices to file
    folderLoc = strcat('../../test_mat/exported/', file);
    mkdir(folderLoc);
    folderLoc = strcat(folderLoc, '/', file);
    saveMatToFile(strcat(folderLoc, '_amd_A.sp'), C);
    
    if isfield(structure.Problem,'B')
    saveMatToFile(strcat(folderLoc, '_B.sp'), B);
    end
    clear structure;
    saveMatToFile(strcat(folderLoc, '_amd_L.sp'), Lc);
    saveMatToFile(strcat(folderLoc, '_amd_U.sp'), Uc);
    saveMatToFile(strcat(folderLoc, '_amd_P.sp'), Pc);
    saveMatToFile(strcat(folderLoc, '_amd_Pamd.sp'), Pamd);
    saveMatToFile(strcat(folderLoc, '_amd_ALU.sp'), ALUc);

    % saveMatToFile(strcat(folderLoc, '_A.sp'), A);
    % %saveMatToFile(strcat(folderLoc, '_B.sp'), B);
    % saveMatToFile(strcat(folderLoc, '_L.sp'), La);
    % saveMatToFile(strcat(folderLoc, '_U.sp'), Ua);
    % saveMatToFile(strcat(folderLoc, '_P.sp'), Pa);
    % saveMatToFile(strcat(folderLoc, '_ALU.sp'), ALUa);
clear;close;
