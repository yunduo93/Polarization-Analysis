classdef Diagnosis
    % Diagnosis
    
    properties
        diagnosisType = [];
        diagnosisLevel = [];
        isPrimaryDiagnosis = false;
    end
    
    methods
        
        function diagnosis = Diagnosis(diagnosisType, diagnosisLevel, isPrimaryDiagnosis)
            if nargin > 0
                diagnosis.diagnosisType = diagnosisType;
                diagnosis.diagnosisLevel = diagnosisLevel;
                diagnosis.isPrimaryDiagnosis = isPrimaryDiagnosis;
            end
        end
        
        function string = getDisplayString(diagnosis)
            string = [diagnosis.diagnosisType.displayString, ' [', diagnosis.diagnosisLevel.displayString, ']'];
            
            if diagnosis.isPrimaryDiagnosis
                string = [string, '*'];
            end
        end
        
        function bool = isADPositive(diagnosis, trial)
            type = trial.subjectType;
            
            diagnosisType = diagnosis.diagnosisType;
            
            switch type
                case SubjectTypes.Human
                    bool = (diagnosisType == DiagnosisTypes.AD_Pos);
                case SubjectTypes.Dog
                    bool = (diagnosisType == DiagnosisTypes.CognitiveImpair);
                otherwise
                    error('Invalid subject type for determining AD Positive status.');
            end
        end
        
    end
    
end

