function reloadPy()
    %terminate(pyenv)  
    if (count(py.sys.path,'') == 0)
        insert(py.sys.path,int32(0),'');
    end
    warning('off','MATLAB:ClassInstanceExists')
    clear classes
    getposition = py.importlib.import_module('getposition');
    py.importlib.reload(getposition);
end