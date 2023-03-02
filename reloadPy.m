function ReloadPy()
    %terminate(pyenv)  
    if (count(py.sys.path,'') == 0)
        insert(py.sys.path,int32(0),'');
    end
    warning('off','MATLAB:ClassInstanceExists')
    clear classes
    GetPosition = py.importlib.import_module('GetPosition');
    py.importlib.reload(GetPosition);
end