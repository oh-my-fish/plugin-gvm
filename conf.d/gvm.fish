for gvm_path in (find $HOME/.gvm/*/current/bin -maxdepth 0)
  if not contains $gvm_path $PATH
    set PATH $gvm_path $PATH
  end

  set -l module_info (echo $gvm_path | perl -ne 'm|(.*/.gvm/(\w+)/current)/bin| && print "$1 $2"')
  set -l module_dir (echo $module_info | awk -F' ' '{print $1}')
  set -l module_name (echo $module_info | awk -F' ' '{print $2}')
  set -l module_home (echo $module_name | tr '[:lower:]' '[:upper:]')_HOME
  set -gx "$module_home" $module_dir
end

# ONLY checked on OSX! Please add for other OS's...
if test -z $JAVA_HOME
  if test -f "/usr/libexec/java_home"
    set -gx JAVA_HOME (/usr/libexec/java_home)
  end

  if test -z $JAVA_HOME
    set -l java_homes "/Library/Java/Home" "/System/Library/Frameworks/JavaVM.framework/Home"
    for file in $java_homes
      if test -d $file
        set -gx JAVA_HOME $file
        break
      end
    end
  end
end

if test -z $JAVA_HOME
  echo "GVM: JAVA_HOME not set please set JAVA_HOME."
end
