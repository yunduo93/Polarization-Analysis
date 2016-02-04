classdef NaturalSubject < Subject
    % NaturalSubject 
    % a NaturalSubject is a person or animal
    
    properties      
        age %number (decimal please!)
        gender % GenderTypes
        ADDiagnosis % DiagnosisTypes
        causeOfDeath
        
        eyes
    end
    
    methods
        function subject = loadSubject(subject, toSubjectPath, subjectDir)
            subjectPath = makePath(toSubjectPath, subjectDir);
            
            % load metadata
            vars = load(makePath(subjectPath, SubjectNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            subject = vars.metadata;
            
            % load dir name
            subject.dirName = subjectDir;
            
            % load eyes            
            eyeDirs = getMetadataFolders(subjectPath, EyeNamingConventions.METADATA_FILENAME);
            
            numEyes = length(eyeDirs);
            
            subject.eyes = createEmptyCellArray(Eye, numEyes);
            
            for i=1:numEyes
                subject.eyes{i} = subject.eyes{i}.loadEye(subjectPath, eyeDirs{i});
            end
        end
        
        function subject = importSubject(subject, subjectProjectPath, subjectImportPath, projectPath, localPath)           
            dirList = getAllFolders(subjectImportPath);
            
            importEyeNumbers = getNumbersFromFolderNames(dirList);
                
            filenameSection = createFilenameSection(SubjectNamingConventions.DATA_FILENAME_LABEL, num2str(subject.subjectNumber));
            dataFilename = filenameSection; % filename start
                        
            for i=1:length(dirList)
                indices = findInArray(importEyeNumbers{i}, subject.getEyeNumbers());
                
                if isempty(indices) % new eye
                    eye = Eye;
                    
                    eye = eye.enterMetadata(importEyeNumbers{i});
                    
                    % make directory/metadata file
                    eye = eye.createDirectories(subjectProjectPath, projectPath, localPath);
                    
                    saveToBackup = true;
                    eye.saveMetadata(makePath(subjectProjectPath, eye.dirName), projectPath, localPath, saveToBackup);
                else % old eye
                    eye = subject.getEyeByNumber(importEyeNumbers{i});
                end
                
                eyeProjectPath = makePath(subjectProjectPath, eye.dirName);
                eyeImportPath = makePath(subjectImportPath, dirList{i});
                
                eye = eye.importEye(eyeProjectPath, eyeImportPath, projectPath, localPath, dataFilename);
                
                subject = subject.updateEye(eye);
            end            
        end
        
        function subject = updateEye(subject, eye)
            eyes = subject.eyes;
            numEyes = length(eyes);
            updated = false;
            
            for i=1:numEyes
                if eyes{i}.eyeNumber == eye.eyeNumber
                    subject.eyes{i} = eye;
                    updated = true;
                    break;
                end
            end
            
            if ~updated % add new eye
                subject.eyes{numEyes + 1} = eye;
            end            
        end
        
        function eye = getEyeByNumber(subject, number)
            eyes = subject.eyes;
            
            eye = Eye.empty;
            
            for i=1:length(eyes)
                if eyes{i}.eyeNumber == number
                    eye = eyes{i};
                    break;
                end
            end
        end
        
        function eyeNumbers = getEyeNumbers(subject)
            eyeNumbers = zeros(length(subject.eyes), 1); % want this to be an matrix, not cell array
            
            for i=1:length(subject.eyes)
                eyeNumbers(i) = subject.eyes{i}.eyeNumber;                
            end
        end
        
        function nextEyeNumber = getNextEyeNumber(subject)
            lastEyeNumber = max(subject.getEyeNumbers());
            nextEyeNumber = lastEyeNumber + 1;
        end
        
        function subject = enterMetadata(subject, userName, importPath)
            
            %Call to NaturalSubjectMetadataEntry GUI
            [age, gender, ADDiagnosis, causeOfDeath, notes] = NaturalSubjectMetadataEntry(userName, importPath);
            
            %Assigning values to NaturalSubject Properties
            NaturalSubject.age = age;
            NaturalSubject.gender = gender;
            NaturalSubject.ADDiagnosis = ADDiagnosis;
            NaturalSubject.causeOfDeath = causeOfDeath;
            NaturalSubject.notes = notes;
            
        end
        
        function subject = wipeoutMetadataFields(subject)
            subject.dirName = '';
            subject.eyes = [];
        end
    end
    
end

