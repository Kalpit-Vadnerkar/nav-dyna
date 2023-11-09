function check_and_create_dir(dir_name)
    if ~exist(dir_name, 'dir')
        mkdir(dir_name);
    end
end
