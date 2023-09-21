
// this is an example tux file. put your own here.

var config = {};

function wins(){ 
    var windows = [];
    for(var i = 0; i < arguments.length; i++){
        windows.push({ cmd: arguments[i] });
    }
    return(windows);
}

function shvim(){ return(wins("", "vim")); }
function lsvim(){ return(wins("ls", "vim")); }

config.ls_vim = {
    cwd: "~/",
    windows: lsvim()
};

config.two_ls = {
    cwd: "~/",
    windows: wins("ls", "ls")
};

exports.config = config;

