#!/bin/sh
# This script was generated using Makeself 2.4.3
# The license covering this archive and its contents, if any, is wholly independent of the Makeself license (GPL)

ORIG_UMASK=`umask`
if test "n" = n; then
    umask 077
fi

CRCsum="1711078027"
MD5="a8e693b02e07b55609d244f703d0b97d"
SHA="0000000000000000000000000000000000000000000000000000000000000000"
TMPROOT=${TMPDIR:=/tmp}
USER_PWD="$PWD"
export USER_PWD
ARCHIVE_DIR=`dirname "$0"`
export ARCHIVE_DIR

label="keyboard_firmware"
script="./flash.sh"
scriptargs=""
cleanup_script=""
licensetxt=""
helpheader=''
targetdir="DevTerm_keyboard_firmware_v0.1_utils"
filesizes="98895"
totalsize="98895"
keep="n"
nooverwrite="n"
quiet="n"
accept="n"
nodiskspace="n"
export_conf="n"
decrypt_cmd=""
skip="678"

print_cmd_arg=""
if type printf > /dev/null; then
    print_cmd="printf"
elif test -x /usr/ucb/echo; then
    print_cmd="/usr/ucb/echo"
else
    print_cmd="echo"
fi

if test -d /usr/xpg4/bin; then
    PATH=/usr/xpg4/bin:$PATH
    export PATH
fi

if test -d /usr/sfw/bin; then
    PATH=$PATH:/usr/sfw/bin
    export PATH
fi

unset CDPATH

MS_Printf()
{
    $print_cmd $print_cmd_arg "$1"
}

MS_PrintLicense()
{
  if test x"$licensetxt" != x; then
    if test x"$accept" = xy; then
      echo "$licensetxt"
    else
      echo "$licensetxt" | more
    fi
    if test x"$accept" != xy; then
      while true
      do
        MS_Printf "Please type y to accept, n otherwise: "
        read yn
        if test x"$yn" = xn; then
          keep=n
          eval $finish; exit 1
          break;
        elif test x"$yn" = xy; then
          break;
        fi
      done
    fi
  fi
}

MS_diskspace()
{
	(
	df -kP "$1" | tail -1 | awk '{ if ($4 ~ /%/) {print $3} else {print $4} }'
	)
}

MS_dd()
{
    blocks=`expr $3 / 1024`
    bytes=`expr $3 % 1024`
    # Test for ibs, obs and conv feature
    if dd if=/dev/zero of=/dev/null count=1 ibs=512 obs=512 conv=sync 2> /dev/null; then
        dd if="$1" ibs=$2 skip=1 obs=1024 conv=sync 2> /dev/null | \
        { test $blocks -gt 0 && dd ibs=1024 obs=1024 count=$blocks ; \
          test $bytes  -gt 0 && dd ibs=1 obs=1024 count=$bytes ; } 2> /dev/null
    else
        dd if="$1" bs=$2 skip=1 2> /dev/null
    fi
}

MS_dd_Progress()
{
    if test x"$noprogress" = xy; then
        MS_dd "$@"
        return $?
    fi
    file="$1"
    offset=$2
    length=$3
    pos=0
    bsize=4194304
    while test $bsize -gt $length; do
        bsize=`expr $bsize / 4`
    done
    blocks=`expr $length / $bsize`
    bytes=`expr $length % $bsize`
    (
        dd ibs=$offset skip=1 count=0 2>/dev/null
        pos=`expr $pos \+ $bsize`
        MS_Printf "     0%% " 1>&2
        if test $blocks -gt 0; then
            while test $pos -le $length; do
                dd bs=$bsize count=1 2>/dev/null
                pcent=`expr $length / 100`
                pcent=`expr $pos / $pcent`
                if test $pcent -lt 100; then
                    MS_Printf "\b\b\b\b\b\b\b" 1>&2
                    if test $pcent -lt 10; then
                        MS_Printf "    $pcent%% " 1>&2
                    else
                        MS_Printf "   $pcent%% " 1>&2
                    fi
                fi
                pos=`expr $pos \+ $bsize`
            done
        fi
        if test $bytes -gt 0; then
            dd bs=$bytes count=1 2>/dev/null
        fi
        MS_Printf "\b\b\b\b\b\b\b" 1>&2
        MS_Printf " 100%%  " 1>&2
    ) < "$file"
}

MS_Help()
{
    cat << EOH >&2
${helpheader}Makeself version 2.4.3
 1) Getting help or info about $0 :
  $0 --help   Print this message
  $0 --info   Print embedded info : title, default target directory, embedded script ...
  $0 --lsm    Print embedded lsm entry (or no LSM)
  $0 --list   Print the list of files in the archive
  $0 --check  Checks integrity of the archive

 2) Running $0 :
  $0 [options] [--] [additional arguments to embedded script]
  with following options (in that order)
  --confirm             Ask before running embedded script
  --quiet               Do not print anything except error messages
  --accept              Accept the license
  --noexec              Do not run embedded script (implies --noexec-cleanup)
  --noexec-cleanup      Do not run embedded cleanup script
  --keep                Do not erase target directory after running
                        the embedded script
  --noprogress          Do not show the progress during the decompression
  --nox11               Do not spawn an xterm
  --nochown             Do not give the target folder to the current user
  --chown               Give the target folder to the current user recursively
  --nodiskspace         Do not check for available disk space
  --target dir          Extract directly to a target directory (absolute or relative)
                        This directory may undergo recursive chown (see --nochown).
  --tar arg1 [arg2 ...] Access the contents of the archive through the tar command
  --ssl-pass-src src    Use the given src as the source of password to decrypt the data
                        using OpenSSL. See "PASS PHRASE ARGUMENTS" in man openssl.
                        Default is to prompt the user to enter decryption password
                        on the current terminal.
  --cleanup-args args   Arguments to the cleanup script. Wrap in quotes to provide
                        multiple arguments.
  --                    Following arguments will be passed to the embedded script
EOH
}

MS_Check()
{
    OLD_PATH="$PATH"
    PATH=${GUESS_MD5_PATH:-"$OLD_PATH:/bin:/usr/bin:/sbin:/usr/local/ssl/bin:/usr/local/bin:/opt/openssl/bin"}
	MD5_ARG=""
    MD5_PATH=`exec <&- 2>&-; which md5sum || command -v md5sum || type md5sum`
    test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which md5 || command -v md5 || type md5`
    test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which digest || command -v digest || type digest`
    PATH="$OLD_PATH"

    SHA_PATH=`exec <&- 2>&-; which shasum || command -v shasum || type shasum`
    test -x "$SHA_PATH" || SHA_PATH=`exec <&- 2>&-; which sha256sum || command -v sha256sum || type sha256sum`

    if test x"$quiet" = xn; then
		MS_Printf "Verifying archive integrity..."
    fi
    offset=`head -n "$skip" "$1" | wc -c | tr -d " "`
    fsize=`cat "$1" | wc -c | tr -d " "`
    if test $totalsize -ne `expr $fsize - $offset`; then
        echo " Unexpected archive size." >&2
        exit 2
    fi
    verb=$2
    i=1
    for s in $filesizes
    do
		crc=`echo $CRCsum | cut -d" " -f$i`
		if test -x "$SHA_PATH"; then
			if test x"`basename $SHA_PATH`" = xshasum; then
				SHA_ARG="-a 256"
			fi
			sha=`echo $SHA | cut -d" " -f$i`
			if test x"$sha" = x0000000000000000000000000000000000000000000000000000000000000000; then
				test x"$verb" = xy && echo " $1 does not contain an embedded SHA256 checksum." >&2
			else
				shasum=`MS_dd_Progress "$1" $offset $s | eval "$SHA_PATH $SHA_ARG" | cut -b-64`;
				if test x"$shasum" != x"$sha"; then
					echo "Error in SHA256 checksums: $shasum is different from $sha" >&2
					exit 2
				elif test x"$quiet" = xn; then
					MS_Printf " SHA256 checksums are OK." >&2
				fi
				crc="0000000000";
			fi
		fi
		if test -x "$MD5_PATH"; then
			if test x"`basename $MD5_PATH`" = xdigest; then
				MD5_ARG="-a md5"
			fi
			md5=`echo $MD5 | cut -d" " -f$i`
			if test x"$md5" = x00000000000000000000000000000000; then
				test x"$verb" = xy && echo " $1 does not contain an embedded MD5 checksum." >&2
			else
				md5sum=`MS_dd_Progress "$1" $offset $s | eval "$MD5_PATH $MD5_ARG" | cut -b-32`;
				if test x"$md5sum" != x"$md5"; then
					echo "Error in MD5 checksums: $md5sum is different from $md5" >&2
					exit 2
				elif test x"$quiet" = xn; then
					MS_Printf " MD5 checksums are OK." >&2
				fi
				crc="0000000000"; verb=n
			fi
		fi
		if test x"$crc" = x0000000000; then
			test x"$verb" = xy && echo " $1 does not contain a CRC checksum." >&2
		else
			sum1=`MS_dd_Progress "$1" $offset $s | CMD_ENV=xpg4 cksum | awk '{print $1}'`
			if test x"$sum1" != x"$crc"; then
				echo "Error in checksums: $sum1 is different from $crc" >&2
				exit 2
			elif test x"$quiet" = xn; then
				MS_Printf " CRC checksums are OK." >&2
			fi
		fi
		i=`expr $i + 1`
		offset=`expr $offset + $s`
    done
    if test x"$quiet" = xn; then
		echo " All good."
    fi
}

MS_Decompress()
{
    if test x"$decrypt_cmd" != x""; then
        { eval "$decrypt_cmd" || echo " ... Decryption failed." >&2; } | eval "gzip -cd"
    else
        eval "gzip -cd"
    fi
    
    if test $? -ne 0; then
        echo " ... Decompression failed." >&2
    fi
}

UnTAR()
{
    if test x"$quiet" = xn; then
		tar $1vf -  2>&1 || { echo " ... Extraction failed." > /dev/tty; kill -15 $$; }
    else
		tar $1f -  2>&1 || { echo Extraction failed. > /dev/tty; kill -15 $$; }
    fi
}

MS_exec_cleanup() {
    if test x"$cleanup" = xy && test x"$cleanup_script" != x""; then
        cleanup=n
        cd "$tmpdir"
        eval "\"$cleanup_script\" $scriptargs $cleanupargs"
    fi
}

MS_cleanup()
{
    echo 'Signal caught, cleaning up' >&2
    MS_exec_cleanup
    cd "$TMPROOT"
    rm -rf "$tmpdir"
    eval $finish; exit 15
}

finish=true
xterm_loop=
noprogress=n
nox11=n
copy=none
ownership=n
verbose=n
cleanup=y
cleanupargs=

initargs="$@"

while true
do
    case "$1" in
    -h | --help)
	MS_Help
	exit 0
	;;
    -q | --quiet)
	quiet=y
	noprogress=y
	shift
	;;
	--accept)
	accept=y
	shift
	;;
    --info)
	echo Identification: "$label"
	echo Target directory: "$targetdir"
	echo Uncompressed size: 300 KB
	echo Compression: gzip
	if test x"n" != x""; then
	    echo Encryption: n
	fi
	echo Date of packaging: Fri Dec 17 12:53:50 CST 2021
	echo Built with Makeself version 2.4.3
	echo Build command was: "/usr/local/bin/makeself.sh \\
    \"DevTerm_keyboard_firmware_v0.1_utils\" \\
    \"DevTerm_keyboard_firmware_v0.1_utils.sh\" \\
    \"keyboard_firmware\" \\
    \"./flash.sh\""
	if test x"$script" != x; then
	    echo Script run after extraction:
	    echo "    " $script $scriptargs
	fi
	if test x"" = xcopy; then
		echo "Archive will copy itself to a temporary location"
	fi
	if test x"n" = xy; then
		echo "Root permissions required for extraction"
	fi
	if test x"n" = xy; then
	    echo "directory $targetdir is permanent"
	else
	    echo "$targetdir will be removed after extraction"
	fi
	exit 0
	;;
    --dumpconf)
	echo LABEL=\"$label\"
	echo SCRIPT=\"$script\"
	echo SCRIPTARGS=\"$scriptargs\"
    echo CLEANUPSCRIPT=\"$cleanup_script\"
	echo archdirname=\"DevTerm_keyboard_firmware_v0.1_utils\"
	echo KEEP=n
	echo NOOVERWRITE=n
	echo COMPRESS=gzip
	echo filesizes=\"$filesizes\"
    echo totalsize=\"$totalsize\"
	echo CRCsum=\"$CRCsum\"
	echo MD5sum=\"$MD5sum\"
	echo SHAsum=\"$SHAsum\"
	echo SKIP=\"$skip\"
	exit 0
	;;
    --lsm)
cat << EOLSM
No LSM.
EOLSM
	exit 0
	;;
    --list)
	echo Target directory: $targetdir
	offset=`head -n "$skip" "$0" | wc -c | tr -d " "`
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | MS_Decompress | UnTAR t
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
	--tar)
	offset=`head -n "$skip" "$0" | wc -c | tr -d " "`
	arg1="$2"
    if ! shift 2; then MS_Help; exit 1; fi
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | MS_Decompress | tar "$arg1" - "$@"
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
    --check)
	MS_Check "$0" y
	exit 0
	;;
    --confirm)
	verbose=y
	shift
	;;
	--noexec)
	script=""
    cleanup_script=""
	shift
	;;
    --noexec-cleanup)
    cleanup_script=""
    shift
    ;;
    --keep)
	keep=y
	shift
	;;
    --target)
	keep=y
	targetdir="${2:-.}"
    if ! shift 2; then MS_Help; exit 1; fi
	;;
    --noprogress)
	noprogress=y
	shift
	;;
    --nox11)
	nox11=y
	shift
	;;
    --nochown)
	ownership=n
	shift
	;;
    --chown)
        ownership=y
        shift
        ;;
    --nodiskspace)
	nodiskspace=y
	shift
	;;
    --xwin)
	if test "n" = n; then
		finish="echo Press Return to close this window...; read junk"
	fi
	xterm_loop=1
	shift
	;;
    --phase2)
	copy=phase2
	shift
	;;
	--ssl-pass-src)
	if test x"n" != x"openssl"; then
	    echo "Invalid option --ssl-pass-src: $0 was not encrypted with OpenSSL!" >&2
	    exit 1
	fi
	decrypt_cmd="$decrypt_cmd -pass $2"
	if ! shift 2; then MS_Help; exit 1; fi
	;;
    --cleanup-args)
    cleanupargs="$2"
    if ! shift 2; then MS_help; exit 1; fi
    ;;
    --)
	shift
	break ;;
    -*)
	echo Unrecognized flag : "$1" >&2
	MS_Help
	exit 1
	;;
    *)
	break ;;
    esac
done

if test x"$quiet" = xy -a x"$verbose" = xy; then
	echo Cannot be verbose and quiet at the same time. >&2
	exit 1
fi

if test x"n" = xy -a `id -u` -ne 0; then
	echo "Administrative privileges required for this archive (use su or sudo)" >&2
	exit 1	
fi

if test x"$copy" \!= xphase2; then
    MS_PrintLicense
fi

case "$copy" in
copy)
    tmpdir="$TMPROOT"/makeself.$RANDOM.`date +"%y%m%d%H%M%S"`.$$
    mkdir "$tmpdir" || {
	echo "Could not create temporary directory $tmpdir" >&2
	exit 1
    }
    SCRIPT_COPY="$tmpdir/makeself"
    echo "Copying to a temporary location..." >&2
    cp "$0" "$SCRIPT_COPY"
    chmod +x "$SCRIPT_COPY"
    cd "$TMPROOT"
    exec "$SCRIPT_COPY" --phase2 -- $initargs
    ;;
phase2)
    finish="$finish ; rm -rf `dirname $0`"
    ;;
esac

if test x"$nox11" = xn; then
    if tty -s; then                 # Do we have a terminal?
	:
    else
        if test x"$DISPLAY" != x -a x"$xterm_loop" = x; then  # No, but do we have X?
            if xset q > /dev/null 2>&1; then # Check for valid DISPLAY variable
                GUESS_XTERMS="xterm gnome-terminal rxvt dtterm eterm Eterm xfce4-terminal lxterminal kvt konsole aterm terminology"
                for a in $GUESS_XTERMS; do
                    if type $a >/dev/null 2>&1; then
                        XTERM=$a
                        break
                    fi
                done
                chmod a+x $0 || echo Please add execution rights on $0
                if test `echo "$0" | cut -c1` = "/"; then # Spawn a terminal!
                    exec $XTERM -e "$0 --xwin $initargs"
                else
                    exec $XTERM -e "./$0 --xwin $initargs"
                fi
            fi
        fi
    fi
fi

if test x"$targetdir" = x.; then
    tmpdir="."
else
    if test x"$keep" = xy; then
	if test x"$nooverwrite" = xy && test -d "$targetdir"; then
            echo "Target directory $targetdir already exists, aborting." >&2
            exit 1
	fi
	if test x"$quiet" = xn; then
	    echo "Creating directory $targetdir" >&2
	fi
	tmpdir="$targetdir"
	dashp="-p"
    else
	tmpdir="$TMPROOT/selfgz$$$RANDOM"
	dashp=""
    fi
    mkdir $dashp "$tmpdir" || {
	echo 'Cannot create target directory' $tmpdir >&2
	echo 'You should try option --target dir' >&2
	eval $finish
	exit 1
    }
fi

location="`pwd`"
if test x"$SETUP_NOCHECK" != x1; then
    MS_Check "$0"
fi
offset=`head -n "$skip" "$0" | wc -c | tr -d " "`

if test x"$verbose" = xy; then
	MS_Printf "About to extract 300 KB in $tmpdir ... Proceed ? [Y/n] "
	read yn
	if test x"$yn" = xn; then
		eval $finish; exit 1
	fi
fi

if test x"$quiet" = xn; then
    # Decrypting with openssl will ask for password,
    # the prompt needs to start on new line
	if test x"n" = x"openssl"; then
	    echo "Decrypting and uncompressing $label..."
	else
        MS_Printf "Uncompressing $label"
	fi
fi
res=3
if test x"$keep" = xn; then
    trap MS_cleanup 1 2 3 15
fi

if test x"$nodiskspace" = xn; then
    leftspace=`MS_diskspace "$tmpdir"`
    if test -n "$leftspace"; then
        if test "$leftspace" -lt 300; then
            echo
            echo "Not enough space left in "`dirname $tmpdir`" ($leftspace KB) to decompress $0 (300 KB)" >&2
            echo "Use --nodiskspace option to skip this check and proceed anyway" >&2
            if test x"$keep" = xn; then
                echo "Consider setting TMPDIR to a directory with more free space."
            fi
            eval $finish; exit 1
        fi
    fi
fi

for s in $filesizes
do
    if MS_dd_Progress "$0" $offset $s | MS_Decompress | ( cd "$tmpdir"; umask $ORIG_UMASK ; UnTAR xp ) 1>/dev/null; then
		if test x"$ownership" = xy; then
			(cd "$tmpdir"; chown -R `id -u` .;  chgrp -R `id -g` .)
		fi
    else
		echo >&2
		echo "Unable to decompress $0" >&2
		eval $finish; exit 1
    fi
    offset=`expr $offset + $s`
done
if test x"$quiet" = xn; then
	echo
fi

cd "$tmpdir"
res=0
if test x"$script" != x; then
    if test x"$export_conf" = x"y"; then
        MS_BUNDLE="$0"
        MS_LABEL="$label"
        MS_SCRIPT="$script"
        MS_SCRIPTARGS="$scriptargs"
        MS_ARCHDIRNAME="$archdirname"
        MS_KEEP="$KEEP"
        MS_NOOVERWRITE="$NOOVERWRITE"
        MS_COMPRESS="$COMPRESS"
        MS_CLEANUP="$cleanup"
        export MS_BUNDLE MS_LABEL MS_SCRIPT MS_SCRIPTARGS
        export MS_ARCHDIRNAME MS_KEEP MS_NOOVERWRITE MS_COMPRESS
    fi

    if test x"$verbose" = x"y"; then
		MS_Printf "OK to execute: $script $scriptargs $* ? [Y/n] "
		read yn
		if test x"$yn" = x -o x"$yn" = xy -o x"$yn" = xY; then
			eval "\"$script\" $scriptargs \"\$@\""; res=$?;
		fi
    else
		eval "\"$script\" $scriptargs \"\$@\""; res=$?
    fi
    if test "$res" -ne 0; then
		test x"$verbose" = xy && echo "The program '$script' returned an error code ($res)" >&2
    fi
fi

MS_exec_cleanup

if test x"$keep" = xn; then
    cd "$TMPROOT"
    rm -rf "$tmpdir"
fi
eval $finish; exit $res
� ��a�]�w�Ƴ�W��
�:��mɯ�!��@K����{Na-�mY2Z)���o�3�+�q��!h�s���>fggv>3;��굑����D,k=��������>;�o��O��%W�N�E�Z�۰��
�T&<Rn\ϫ�`�ğ�-��4�
��l�$Sٯ�A~���F����u�L����at8��$�Ь�S�P,
?���ĵ����A ��i:va�����6�f��sl���m�����W�����;�e��ۭ��_��a��/Y��/�h��-�}�����\���[���3��n���q6
�]������m/�����H��C���F�uM��~��=wر���	no��i�|��
�y%�����&�p�e���\N����m�j��f�����7�v� �����_����׿��Ǆ��о%��?�]��o���Q8�G���>���Z6�n�X����{��t6��N�)ܿk��_�������֒�;]�[�Wq��Q,^�XL#�'Q<F�'G`
�(d[�a��~ &�'�[��(
� 
a+�}4�`4e�V �f5�eɱ%E�N
7��� �����N���Ϟ��PxV4Z����
��2&8q`�[�ľ�l��c� )����x��ߛ���4>��0�
�fD�d�-e6�J6�J� �
#��$��_A��	�R�Tِ��{}V�i��l�$�4���A7��T�jǢl��V�s%:���d��,[�|�'v,�zJ�J��5�ۍ�99�X^#����b�eR�������g�9&u_�ԥR9������ J)y􃡍X�"tg��x�t,�%|���1�z�`T�\����4�X�O������o�r����^��-v��Y����T�WK����)�; ��&��8�N�4}�ob/��W:�_�(t�?pSK���rXD�ۛ�"��iJe/b���+�7��L��OPH�2�֧p �B�'0]07j�+h9�%��7�n~�'?< �����:NC�P�8�����z���Qx8}=ztG���y�������8yyAt��4����R��ڏ����X�$�#�'y)k����&�
��)�݂e�^�Z�V1�+-?«�:�E��{��<a�]�C�WN2���S���92Qk
lɇ�-ХC
؟�6�Hg�1K�r�T�?�bL�@዁���)&(�c��E ��)0��$6�8R�(�CL�35��&{Pe�E�u��gC6�1��=�Q���bM
Lh�X�b���I�2�p�L�{��Ð�����Q �*�ݨH�g�%qu]%�zT�I1��	 ��c�Ơd���AO�bQOHRB
�V3Ji�t�,[��qCsq`�,�����̂	�m�e�߬�	=&۳�;�w>���A[��3��
{ώ]f�U�z֊��n�>����qwB��.,A�X��%N
ϓA�G�@y<���2_e�2ىx�)F�ǳ��Q|}�
E9��uz�Kk�I5U�h��RC��c�k����?.���8���������/��U�m�Zg��v���A�o'��b4Nؚ[e,���{��'
���S&���86���("	�sB��;�듻f4`�|�|�@�$�����$��'To��[��y$����,�=Ϲ�6�����	�[fO�(#!7�	CƉ�8 ���B�H+ �ϐ�d�!�ј���b,b� �^�y$�y�k��H\��øm@dچ!���X����LB�5M5��!A�ɨ�����%K��C��2!��g��!�sY�851/�n霁�XB,�*���}�٘��B� _��ׅ]��G��]Mx�͍�a�0�b#HY�HT%��Bl%�>"�N`�B�� J����H$+	���@�����[�~n��	�#������f;��G+ݩЩB�I6$�y fj��#�f������&xD6���� 5��Ɯ�J�Y
Q�8�
܄���B���D���u��)����R]�v�C�QZ��s���M�<>�<��ݡ��PA�8�C"jʧR��{��$�G�)��JH�-�\.��=n�B5�������j	&&-�C)�B<#�f��Ǥ?�"�+��
zP��	����$}.��)x֫2��)��I�
Xh٥N���҂��p�7��$3lb"��������P�&�?�z�&\�)���?5���;�ߵ��t����N��&�O����*�����W��WwS�(�Q:"�;�������±B�x7�vz]fq��x���
!F��Q���5I�@�	�|w:] �Ċ���py��*�v��脂�l���z��ȭ��$��RI��	��2��<h��[���*Rf<o/N�G�&�:�T.`����>�y�K
A]���2�p0����F*I��R\���@�WO���7����
�Dzyv(���t����e���"?wP��Y}r2�ű­AyCf�*ɠ�il�8�Dc`S��	h+�3���M��$��QT�NS
�Xl\J"x����S�&�Y����#�
�T��"K�g9��B0D,5�����3`|�2��G
��a�?��Q���K?TE��+��_�
�fI(A������{��0��;����ݥ��A�0@X�"�ZǞ�H
'�Fi����3Jd�@G�K�Q09�z���9E�x��O"G����j��pg�=��=�D�5O�'eFwaD1�Ҟx>ฎ�@�ϭ`���nҐIeK$a`$N/fh��3��ߘ�S±o8�Mƃ���tO�,�-�	)#w��u��	��aza[�ZA���
�K�@�QYTѣ�� j�����DI �V�:�Q���V�c� m��5�=���}��N��FBS��-o����/ʀ$z^�(��5�T��� A�,i��I���+OJJb��f~v#�b���D��߾�$�R����w�
\ �(l
t3GH�$���*$`7�&�jF��GV i8� D�M~�u������q9��#��(>%p�L�7&H|2
V��$�a��{r��t�w�<c�WB��Ɩ�x�<iA ��e�)z�`�	�U����*���K��!Zy�\��8$m8DMr73:�1^vŹa!���r9,q~ �j�y=d�(Y�O���*���H�q�Xb߫K�&5H�-�ӝ	H�����Z*��&��`r�D��b4�b*}U��?�S��7S΍�T�q��?P����Nt���^��}JD�*s7�V]�M*p�=�~�\�
� 3����@��A'|ӄ�F ���2��?�(�N$�
	��:���/H`���Ҳ�aOӁ���;r+]
�_�F�d�Ju��U�U�����������*�
�V�Ұ�1l�}P����B���Q��Z]8��F>hם�.��_�q�_h=}\��ՙq=p�����&u�q�>=٨��<�3O~k�p�T��	Б-��t�<�r�����W�5�Ï^�{U ��E7�٦9\�.�s4o�ĩ��&E4��&�iEp��R��ғ��1��� 8�6�-����A^���'?���vX�8�T���8�y�N�ᩚ7+�
W2��*�դ^��ax�۳��pm7%��˜�0 ޙlɥ���'.�3;~]�b���9�bx���Vo�?�f�����ٛ�0�7�� �|���h��	�S=�?��c����N�3�z�f*
,�<�ڪS����(����q��L�Ϗg������/w��;�ň��4��\>R���aaG���]�Mʕ�e�U6lQ��I��r���Ǌe�]���LϸV?<e_5�ZGt
	�[hwr��w�o��~ ST�
��n��ܿ���}��ۙU{)����M���b��X�~`�C���}~rǍ/W2��f���N}�=����~����Srs:�ݜ�~Dk���𮂱�b��sY6�Sa�9�!O�y��_���)\�n-���#��zsu�����׏޾|�饈�V;y��<��4�0����Z��?���g,����0���Vc�O��&I"p�v~,��?��۰l�p%t����g�=8dY��y�&�R����Z%צE4
�
������z��ΤW���5�V�V�"�ժ6
�Ro c8��A��{���^��^_��:U��WC���aΘ^M/��E�-�9OM����y���Ii�x��>yQ��[�N��5M�i%����M�/�]����v:��'ju[��K>����c�_[V&/�ɫ��پ����jŲ���e��s^2��T�?#ʚ���q����Rʖ6{�\��k���N�����Q����Z���}�(G|���W9��=^�1N��Qt��mk�K?�u��ȓ8ϓ~��Q�u���xo�f�C�}�ͼ�Z���#���N�ၗ�J��?�����+����7��H7��q�wͶn���:��v�w��p��#I���׎X>Ϗ��h�o{/�~zM�iy��M��?t)kx��q��#����z�'&������o,��e�����ؾ�}6*'�?�tĠ�#�7D�V��Ŗ�^xkU��m��W�Y��o��_)�%�����m���~�0u�������mw�8�]���f.���r������-ٻa����Z���G�W-�ޜ4���XkԖ(�ŵ�E��x���ܝ��mhQ���V3���}�c��J�����>[w۔���{�۔���������<3J^i�2�o}~MN��u��Gz���4� af��+�޴��ҟ��]�f\2�����m;$���u�f�3�1ё��ez4�^閼v0f�e���:�������tHf�&ݻ偳?�mij~�ހ���[ώ���u���V��%R�J��;W��������'߮����V,~���7�_ZI�h���V�;�<r�����ƽ�X2�ӬQYCƬ�g��������Ի=z�ޡ�N4w\���E�%C�..�xj���u��9��SN����s���
vW���QakdKV��)i,�d��|�Ί���uW;������*l�>\6rN�8 4Wy�PQzivdG7�0�������J�e��]fZ!��9��IE��Y����:a�+ng���7k�[^*`O�own远����}h�d/]3$Б�x�v���O����"�/^ƺC���ی�o���ȭ<n�w�q6L�3�5�b�i2�ji�s|r�m�(uR3�ؗ����V�e��Pؤ$��u���]bz�ƅ����l^��јk\�C�wX�%R����?u0l��o�ژ��Ă^G�}��5Y�Ӊ9����g��
�J�ef�m׽5�n~ϑ0������y��Dϳ��e�0�]���:h;�a^�c9�v:��$M3��_�����٬�����?���������e� ��@ ���C�Rڿ�� \�?��k����Z"�X�:�����X�����m#�Y"b����+v�#F��uH��¾�JvHc��z
���7�$K.��`�C�5�p�m��u��9�����2��C��|+b�(��_#~D�f�?��k��J�RH����H @!�!�B�Q �Ɠ�$��/� �����(x��;����Rڿ���"��� x�w��/!��e�q�ſ

	M��O��L?M�I��2)�������4w��κq�^��<��
������ `�4���(�����_Q�� �	  ? �+�����1��Ǡa��j�Ǣ)�B�G������#�w!���:i>i�kbw��)ݺ{��hR��f�j�����ɜ���[�ɝd����;%���Gb��2�@q�,1ei����8:�ێ4�h�ŉ;���d�!�E��:F�$;3;���AɁ��7 ��F��8}{��!�Ͼ����DF¬�8{Uh+������R��rBw���}�������=����ѐ��s.�W��#�Q����G?����$��.�D_�4j+p�2��Y���|k�j�����}����D�Qh(2�%.��8�L�0��R�T*��������? ����V����	<��0��4�/�Rڿ��(���������_��\GE|][9��f�m�R������A�`PX�D&*�H�<��Y̋ �HÓ�$܊�����/����_��������/G����Rڿ��X4j�(���_������2����x8!<�hX4�V�I�p���CO.�C����&��6+��6�3�/��s�p@���}}���d������tϘ�����n�g8-<�X��(n�A
#GR���aa���Nalwc�af�����Z��I%Xʫ�I�� d�^�䆜��<~/�o��~;1<P(�
b[#��S<������c�,���R�&��D"��iD<���@ �D]<#P+���g�'��W=���?a��_)��� �����(���*��A�F�����'|���_wA�x��.��*��֧x��H�	c�,�Ś5�<�Un�]����M5�K�sY�ҳB_z���^m?y�,B8A�5�"mi�k�m��*] λ�D	ʚ�䊿��[��|�][v�)n���?~���Cpẃ�Z�o;!8�����yk�EՍ얗����l��9��!jˣ0�s�����b�*2>7�
R���c��s?����و����!#vVs31�'��8��.ݬ�m�'�âo�HF��h�F�MF��EԨ(���Ό�
�w��<���&������lr�m˼0�<���F�Z:����tz����Y��l ��if��N��^�خr��k����#1��L��u�N3�c��̒ZJm��Y�|g�1�cDe�a6�8�����T��e'ΰl?�.#�>�M��na~��cK2?�Ņ�k����Ǽ�#�q#o$�I�r�,<	.�ᩮ7=yD�X��#X�ő���ٔ���LAL�O�O�]�)��^/��+Qh���Bm22z�/��oa�B��9�fmx����������+��~����m����������D� 
�!x��G������X��b�	��S����^��ǐ�C��G)��ڇv�BE�Htt�=O�KS�;�����k��:#��w�3�����k$C/�1��2���%��� �$�8¯԰Q�Nv�$�̎�����7�g�r��l��Ʉ+ȮF,n�p|��7=��h��(Y���go\�:�O��ph���F�aS��#�o����g���D"�]��D�aHx4E �h��A"�Z��ǟ��Bh����?����������^�?�����������[���c�CmT٬���s������dЛ:�t�<,ޛ�p;uy�oB[�!<��*{�~i�mBY�ԁ�)�Vq2�?�&��(�|�tl���C�$i{˨�}'ߠ0-�����滮r�i5���r�*��r�r�3�^$qU߭dS
b�w�2�k��,������b�j���x��@���s�M�������`y�VT����Oc�9��{�,�9��6W������˴��8f�Q��h	�4lN��Q�`8�k�7�GS+�;*�������m{��I��^�~�g%�W�P~t��ڏ�$��j
[�a.lR������B�#��Y��q~�r�:���J�v�#U�'B�]P��bN�}�ᓱ��cz�qUe}N���}�B"6�T$�)���s�V�,	ܵ��<��g\e>^�s{$�j�_�S����:}�TI͗��!��ј���'"�[.�2�,���I�2���R)�|��A*�'��i.l�-��d�j�'<F�LK�QT��?� ��-�Ah����s{�Ej�<��?�FW��E����9��xs�GKOF���ؠ`*�M�X����{η�+�������ZPӏ ����No��0�%�<��˼^MJ���.�*��x�\�h煬��E�]�X�gRzp�&�Ot��l*������"��6?�Z���pm��K������_kEim����4��?�i8l����U��K���f7�5Y�$��,d+ƾ��%[BE�d��	ٳ��T�)c�"c�n^������s�����>�����,_����׹X�&;�e�f�����G.�G��ߛ�!�E#�q��!q����h4�ApP�łQ@�_���_��p3�����?��O|"��� �?K��!��k��<�9��W�b���bQ��;���O�.������S'�y�L���YX�����7�1��C9R�1k� ��OZ&��}����o�M�X�sp�33�D�³�	�SǑk���H�Ikֽ߲����%����3n�z/�?}����tУh�8&�+�vߛ�
���~ۆfƳ��8	4-��ևvmA��2�,��/mmC�8����G�&\�a��?�ÿ��P�vЏ�C@h8F!�p0
���@` ��aX4�������?f�S���o��gi�a��4 ��?�|��E�?k�lղ?����\��\���IN%c�I���%h�(�u���){>`2��ʟ#O;� �Q� ��Q΁�g!��̐G�<��La�
��!|�LE�X"|y0㗕����e6gq����,Cd������uѐI�����7�k�z�W�ь���W�z��"�*�:d���X�m�w��݊�*���1���B�Ӟe׹��8!�z?G����p�;E��m{6�Z��l�/O��ڑ���]�&U�xi��{�fwh�oM�i�K��fz�T��e��C�ՊV�3�VI�I�Q��u��,�B{�)$�т��Ƿ?ٚ7�.4�'S,uV,u|���L�?vL����X�r����^�å���w0�D����Xss��5j-OD��>v1Sj*D#Z{�� W������uV�ʛ�՜c�O���/ʋ�?c䢋Ti�:ݡ��⁷��n��V�ƒ����Ȟ�׷L(�7�R��`�qT#���h�ow��O?۹SP�$��h��V-j�~��3Q��J��.�6ι��G��\�WN���d.����V5��-ʧѬ�T
<��<K?k;؟ܹT�x̪6��ꎟ~��9~�o\SX�@�}7���K���@�U�Ӝm���.�� �������J�_C��.���
6�,� ���7wV�|�T��'թ�eoU�lo�!�b:3f�_����z��s��"�삈h0�
n/�"Π?1\��ʵ>W��ʦ�)������m6�.���E�x,�[�Ri|��ҍ[�����]A)��.Q7�|T��͈S��a�f�eɕ�O���}ff��޳(����
���4�q��%�/6�������J��Ǒ0ѺS=���z$�Z��FI������>�熠c�ڧ�`��� ��f ��ʢ׎���\��n�7uJ��V��[�����4���5�|%�ct��>�����v�[�qj�̞>�ޘ�Ky����2j 4H�^�2���.��HM5c�]9LA�k��)��4����t��}W��W|��=\��Fs��C��f,��ә�W{v��f������T*��\Ϯ
t
��u�xa�*"��1�TL�IKmQ�d��T�\����&����}ײ|p�5�Ļ�:X�Q-���ku4N�<�2�q%F�kKu��I&��n�'D��Qc��u%o��Ep�U>a����>ު�ǋ�-O@��I
�V������r����=��=y��R$i�G�q��hGV�?��e�U!�O|�ݭB*f봤�%8�6ޒ�a�Շ�FQ���1�>)��Q�Bo֘�B�� �h^CPfEn/��w@���kӞ���Y��A�Z5#mE�@j¼ew���1,-�mQHI1F񊴊�
2�7��\�O6f<��c�H�]${�?X��#.m�S������J�S+7}wС����[ﶜ�gh�=D�m���o��>�uIl�=�l�]�d�ƙJ�V��⤿҆�	X['-#zs͟�W��M�	}���58�����jA�����nxvi�X9�&s�u�M�n`K�������ʺ'9�*l6l���n��,�8N���.��=��jf!8�r�^�q�BgIe���t��ۉ�d@����
_{�H���|�֓�v��ӰZU�(��J��ل9K'0vy�P�Oo��f���8�i��+u�#�������C�"��#�����]<�}3eh+��2�4��:Z�w�+ȿ*���Z�2ϲ���y����Z���&-�\��3�yFS��b�M�n��������z����j�웃����/�4�Ǽ�]�j��X���VA����_�
G��<_ժk#����i�rV/����SLS���9Ml��izs�2�j������i-�jC�{b��!��{�uzje��5����g%�D뽖*C2�#�0jY~�+^�zߴ�f��ך+s��ԩ��mw7�Z+�����=�}�����^���X�����j�i��	m�Y��E�@�y��&..i���"���(j$:��Q��&�N�g�*
 S�7�D��O�	IIX�k��4�=���T�f���<Vmu����K*����M0���߮�{������C���0�9�[3�$�*F�s/
L

�������(���/�����N�ߟ��^��H��V`y���Ŷ+����,�s����i���: }�ˎ�9F�qER]뉌�_��xыJ&zq�|2m������M��R���3���{�y^ܩV+�g������8����/#\#�h@SE5�y:��IG�>�ż|	>'�	�
%%C�E��e�H"��� �m����-`'�D �H�4�E e��v i(���x������'������(�^��^��[�� '����a����9{�L}F@�2c7?�/~�Q�U��Ñn����g�Ur�u��ĺe3�ѩS$۶\'8������/ 0 ��E؁ 66 ��i'%m�� �H�4j������? 9������U���B��c�	[M���������1��������2��o˿uu$�|e��K:gKe��%b	5s�zk���~����z��d�%�=Am�P��ǟ�z=��Nv�dK_P�����?���� �Ҳ� �l��`;[)���K}ga������.�p���������x������Q����?��?�/
:��rc�y��*5j�u�a�S̆���w߻�ĉ�l�(�ҋ>��ݙ��tߠ/~>�'��[�6Y�H4����&D��R���-,IH@��m��p�:�����E�D�YP \�dEO]I[�U5c�f�k�����}s0���f��5Z�����:PN���������ٍ"ڭ
nQ���`6C��V,���Q�~�E����~?��8�.�u�ĞT�ވ9m"vA�46Ȥ-,���uM�zӘ�D���<͎�Ĺ_�G��a��!�M�b]b�S���-��f��ּum�zW�a�]٦˽��&ݯ&�)����+0G	���e��)fD�3Y���:��E�1�đ�hڀ��s�1#�����N
)���؈��3�k
�����4����
"��o5%r;��j>��U��z��fd�d��Q�����x�X�M��춪(�b�ໃ	Q,�^��-5'/����]����/���=_�����eI�8�z|遼 �/#�@x2�G��o= �P����0V|v���A�F�D���	h՝0Z6ܨ^;�n��/��ٯ��R[��
K��P^ֻ垡�h�^E�1tb���f{n�t�E�t����~��@s��^�.�l���O	+l����Fr���|9Z�_;�M ����
jz�<�7�/l�5�X�����������Z+�:�<�ў�+���fB���D������J|��Л���������״<$��7�3�A;r�S����[QbƾL�41����]�ZK�
�	mo&,M�shQ�z��4]��|�:���'{�W��)��	�e�˭W���Q�:h˦]��3ڒ����G��w���gj��<HG�J�e�\��4����
0|/'�.Bx��+{�)���{����Z���>Ƴ{�,(%=�����K3>^��u��ք3u��CD�MEYs��[�w�0R�W�/�HU:�$W�����7m��,|^}�~'�Ξ��P�m��;�R��S��;:6�Nuv�New"�fᅈۥ������
�P����*�br���J�Q�E�����a*���d$d�{�驔!
I�gjUy��U-"+i
7,�0G�QL�4��G\)�Z�H~ا�-/��^�Ɩ_��V��q!CJ7���uM�E&�4�����fG�I$�{Cm^[�8�4���vMfBt�g����ܭ�^�8�?l���"��Xڈ,xKU�s?����z�99�ٗ��#�!~�㋯��Z
\�Ͼ�(��G�j��h�_!�V��2�a��C�Ʈ��Q��cے.�������ִX��Km��-[����17��W}
�89�I��o@�
?IN�qJ���v��nĈd��0\B
�x��2��R�7�����=�:�8T)�Ec�̻y���:[�ʵj���,��rD����2��Os~�{8~;-El��ЌS炜_j��ǲ��;�,T
���������4U�O
z�XB�힦�C�./��F7.˕�}�C1�G��o��i���	��ʹ�E�0l�2n�F�FXI����:-���Q'5�Г���\
)�;�/�㘊��6
x�a�ҙ}c���b�,��u�l��K�<�3A\�M"|7Eq�4xom�.��~��}�侜�,G#c|���x��neZxtcF�}$�WG�|��\�>���yuPv։"#��w&`�)?��g�;�ˬ�����;�{g~4a��}�҈��32��^���$s��࡝5�A��$LS�k�/m����P�W-��쿾$�-a�d{U ��R;�T�?Ӧ�i}�Ǳ��N���C������ʲ��Lvq~*|;����C�A��������(�KA�Xg��a�8nk
c	8�����a�;������矘��������gi����{�a������������������~�nK��[Q��#�]�	�u�,���r��������� ���C������刭m����X������0��4�������_]���@(���� 
�@�o����_���÷��/�?*
���/����s?��\2�g��.��ݧ7�I��D�r����������m2	�.1G�3:�>�Aj�����*�G��X�Pہ����3U;'�|�I��L�c�����ڸ���=h.�r��ovP8w���F�M�g
�ˏ��IπEV��D�� ^�k�#1f��1 9|����`:<T�t�&�6�������?$b�B[�o[b@�[��(�GAa8<�������_ b{��/y����w��P?��m��/�����g��
:a�������_����v:���4ͺv����&����ϖ�l;K��R�Fc5��8��_�mF�O�����t����Lδ�>A�Ü����-~G��&(>����{{���-��~��lIߙ���e^cW���>�f���>�Y]K������Ҟ*�z,��?��zwgM����>�d���t�����]����i����ո����
N�R}�,��-&?q���}9Vk�܃�
��.���MŌK��饛5�S�h�>�� {Zu��
GH�N���B�;��M4���n�����д!��)2���;\�V���7Yj�_����aQ����}���r�[�l���q@sdv�Hl�D�BY̾��i��~c�c�e���&Gԟ
X����E������YB"4�=y9/!�I9���.��6M� =~X��f!s��X��p�Z�FM-�]_D>r�/��%;���k6f�G���e;r�|�ۃ(t���f<x�o�qPX�Z���nLE)~��ݬ%�ip���.J���>��,�.��!�Gɛ����w��t/�A��q~�,m4���9S�ո�qA�W�o��`i?�<�J���b�?�s՘�(�+����"*�9��I�詊�/�H.d�G�Z��:"BQ��ϑ*U�|!�����2'�H���0t��鯡A���b.v�àf��zVS�$�m.c^��{�0a���q�f2��8@?%�)S�RȘ�?0;�ɲy�ԧ���J��h�y���́��!��[U5�C�ɳ��Zo��(���=�Bh���V�"f^�#�2�R.v2X��J
����:��gOŗ�s��gA��&�^kj �2��rn�F�z�++!��Z�����U�f��=��7���B��| �9X5ަS�[U�N��2;9&UR�1�
GguHA3���Un�ؔ��@�0,�����i�S�C�_F����8JM����}�����Z�g��A�UO��L`l�� ��t.͘�eLZ9Ep�HO:;9
X ð�����1��l�x�mѰc
B�E�zk��痽�Q�Ji= ����R��{����A#�.��{K�m�-|~=`_�P\J����5fS3��� 2� _�$�X����ك�m��V�����͏��s��U��L�g"�〾�wk�kQVn*���܂����؃�]x�=�����BTy��e�B�ʫ�8�DX�\���ˀTȠv���T����!g��t��n�]ϼ>�~˓�H��>����2�-~��}�"p�o������#��@iVy��뽻�1�@go#a�$\&C�Jj�`�o�P6�x=N��Ejb��x���e��Gi`3�wW�Q�ÝJZ�q8�T��%������Ǥ�F��[fU�i~}/CV�yr��n!�[�iݤ�q�
TC��m\	��Z_�#U6N�2��5�+'+�ž�&1�e�Z��22�&^�MV0��،f��2���Pᚻ�S�׆[�vK���k3d��ٙ��dlN>��y~5�����t�A 1""��iW��/�b��߾�Le���MQ��h�8��%����ό�q��b�v`�`.;�6T��m����K�-. �Q�4EUR�)V�TN�r�**iBIF힋$�R���;���
=�~�2Ng~��W�'���!O��|�
@��ߏ�=�(��4�O����P����w�QM`��HSA��!4e �B蠂H�]"I@�H'�қH�Dz��@�JM �@���ș[׺�Ώ9kΚ�ֹ��������~�������[VobaJ�ZN*K�4z�d$곒�"av���m�G�1�k�D��H�bN�U��=�ڕ�T�p~��<��gg1a_k�������l�z�MP�3�	�P�����w�2v�����Ϣ�1ӷd�0�<�ʯN�Rж�fۋ��8d�S��~p8����8��:�~�s#=
Z�<�'S�E��ǃ���4��c"2N�2U��� u�����~ws���C��R��fz�����z�{�$�w%B�u�v@,�[�h:e�a�{Hi�����'���m�Bʽ��r$�&ֵ����D)sI�w:aϞܞ���R|4<,�=V���̗+�M��8v��K{@����9�)�_��z�T~�������(;����ݾU��Y��'�OA����I\3*�{h���Π�h���d�O�!yv���p��b�Mᛩ5K�	�U�u�E���S�S,J�v�.nDt�Q���'�3CU?%{���햒>v�D��N�Lq;$��W�-A����/�Ն��t|l�-�(	-z�y|���蚖��#�k�PT�P�x�A�ǆ���IC�O~���ou^�Ac�5��2,�ř$��GX��0k<��Б�)4�'r�L�S%�u<���c#��_�j�b��3�ʉmR|;Q��� =
�[��\��I8"Q�/�E�����B"����-�����aϦmJ�h���G!��ق]9�0�����o�S��v��]��\�S��A�Q��5���>q�|���+�
��K^@S�����X٪�-�ȗYӂoÖ{uң��.����9����
 _�u����}S���פ�
�fofo�T���4�C�ф��Ü��0q���!u4�4�4���¨�A��it�4�t�c]�A $�v�F�ƍ������e���=��Slxz_zP�JHz��J�>F3��>�E0=�r�wlg���HG�aK樴e�u�h��F��ȸ��m�h���c��{�čy5Z���N�i��R
Q}���N�Z��'U�k쳫<�����Z+�sc8��6��&tw��B��ް2n>C?���c�¡�h���B�k���z����%Q?���	^w�\��*�H���Q���J�Վ,�Ad �:�u�C��%3���r����7�:�P1:KD��+B�
�Q�m�2��]o�0Ss�Ֆl4��'^Ak�wI-i+}�m�a��2:�7�6��=E���_p�����
Z��ݓgp��>����"8����LL��+���[�b�����N���̓	��D�uow�RkN_�c�5�O�����d$QgŮ7#���!$���X�z"|��q��U7%���+L�<dR�C>��Gs��
�R=�Kc7�_\d�|��f����n;�1&�dw�>��OZe��)�"W48LQs��,J^�h3ts�L���P@��֊P|��t*_s߱��y\�������zT�	t�vYW_/��i��Ы����C��72��;"hvwqf%���(��~�>94���x�H~.��gˎ"�
F8��!}Լ������#㲈� ����̻PC�6�܍���na��������pU.�ޛP�E@�A��N		6���	��i�n��oop������s��;<��=��Y�&�Z�ǷU!i"�D+3��U���I5���&>JE�~|�.:MR���p�j�����5���o�冩��5�%YVu0��T� �j���`�4�����ĭr��z�������n�X�B}��WԜZxo������ڇ	�Y�`���]���	r�{i��oM}z��#�g�l҄j��W���æ1�Gj�*�e��V���-4͌_�{��E��֑"_�P+U�̜7�|p�^`퐩Ӓ��.f�Ȏ����Cq�0Z�yV&1�~LZ*&^�p���Jzy&nE@5�_^d��,w|R��Lu��y�W��4(D(��<ܜ��{F�4Fy�h�и骘���#rE�ߣq���*e�q�*ȑ��ӗԅ.�/e�dR�q'a�{Rv�/ㄷ��5g���Df��Ys���5W��;󔁴���тr�+5j�����u����LȺJ��~�-�Qט����a�8��ɡ����E���,�9���D�J�ߓ�[quᒥn�
l���N)�ʋ��ִ��}YT�z�Є;�vt��fp>Kd-.�����5ͣ7>��lM�r5f��Ȅ6�*�R�9������>;���m8ԟ���;&���e"f~�A�z�J�r�*���׼'�m���$��H%����I<���r��$ݘᏨ�,�
T�Pˌ�	T�B��ZCre�u]r2� ��HB��j�|ݜ��w����ߺt��K�z�9o[�|����~$��zĊ@<}G㲄.rɯ��1H���uT��I�i%�������E�q��i�
T2-;6o����4"?��}����y���ƈ���Үc�I�gV�
�0o�+��+_�C���%Pr5l�0=�ް��ҁ=E�L�aIT�*�ʭw=�B�gL��[�h2�������$�-'��;���V��e��0��yJ��{#PDQj�U�%��
�Z�.�CY���������&T>W�?ξ5�'ʧV�BX'y�r��.	U�{Ʉ3�P�1��q �ESm��u��A�U�Z}���=O�Ege)�n[�����+(��o�"��>��	�P##)G�zo��|�sU�X�a
Mf֐��tJt�J�a��'�4����M�-���۹�
,��sb��;�WQ��D2<�Ǚw|��o5|a��LȢ�K����7Ώ��	�am�سê\�0�m�¤H��Z�Q �-��u(�Ƕ Y/F[�r/e����./��I�'ymJe����!���ꤹ�ڐ�>�̕Y#�L`%#[�6��V��y�����V��#id�y�@�@9���$
P��H��SOt�]���=�)��"�=�Q@��I���������8TX�|���Qa
��CR,se���NP�/:����v_
r"�ٮ�'�)YN�-M߇�t�e�A��"�|_F�Q�~�Z^�Z�ƭ������z+��;8�՝��G�߆v=`+R#��Y~��誐�Ii�ѓ� ܘf{�H
1�ʭ��.d�%D��د�Av�󊾫���^/����U��M�m�q�/��+L3U���nt����Q�q��J�61g!�A/U�'6������l�����j��:79RI��y��}� 3nQ1��m���T}�"�-��<wE�#:|m�pJ�/~���|�O��aK�U�4D����7z��,a��� ��
C#Y,%zI�K�wT�xĬ/}��eȥ�8
��6e�M�Zj^�~��W��Z���M�y�a�y�������n������Lt��>7�bd�R�S!n�Cc��[�.^��܊E����E��y�s�M�N�v��e�8a�w5z��6ә5q�x&"[��,l���'׆C&��F��y��`��^X���+�尼�ŝ���-m5)w,r	C1O;��vs�Pwa}b�b
��f~.g*Z�U�2�)��_Ц������=E��L%��dy��f��]2�;��6�&TQ��w��/�v�G"*������t
W 0�<e�6[�Oԯ�5#&���3L(����km"l������µV_'�w`}��O���,Z�I��슢
����跿�t�Xz�QRS������*�Π�|���,[���M�&�aw�۰��o� ^O��jg,I������6�o�]��@�6Yj��C��f�����)�g����'����%�m4χfee�V�~�ҋ)B��Zʏv�$�ϗ�8&[8��WB1%J��.���CIC虗#�=�G>��=8CU
�hMae*���i��
;�L%��Ruv�3�5�5K��~��.����h��t[���w�%�����L��F2��iݏBd�y��yG]G���ͨ��觠�eR�g+QnK9B"�y���ubz�%Z�G?�5������c��'�����ب��Z+�5�¡�=*�'΍�^��I�V��C���<rU�|�'�Ҡ�6.��g�dY�単,�D6��a!m<M�^]�p���\.(^-y����3sn�d�"�q���2���J��6	����L$�����Q�ai>/��]$��j�6�t��P�a�
���L�
y�Wxq��͠�w*��9���.5>�������h�
�#�vN8����sj��ZX{�ηsMN6w���B����Y.��6�'L
��Y]�#���]��kLI��
b�͡55���9�]{��i�݂ͽj3̇��f���,E_l�u�+f=�{|m_�n`w��˶��a���#�%��KP6����ݭ�y��ߐ�aӪ��m�M��V]M9
oQ�3�?lJ�:�1T�o?��aOL3d�՞Π?���2>��E���9��H?�*�!�V�f��E���Z���	4������+d޹c#�7
�%Ό�}§w��B��x��rczXd���j���5Z�61b����21�/b�A�9��y��
�u�~2k�BV;;��D.�m\r�TCՖ"nol�<[��|[G��X�Ϟ`�̨�tO��a�2��d^)�nR]�1�����Nmt����ZD�G��_QT��(B|���`��ds�\o��0�������jp��<q��6�X	��㡯wS�
��w�JSf	x!�K�7�՟]��x��ߦ��"�� T�j�Պl>�[�	?'��-��|������t��" ���h�=��u��&NT��k�2�iՉ-*WeT��eE�y��bj׍ܕy�W����9��%��Ҏؤŗ�2���k>,+<�ew@�p��y�O�eQ��j��Ү�`1��`��N5�@��,K�>�R�R�B\�Գf�$�,�E;I�P9θ�[Տ8swuu���;����$���BU��F����+�T� m1vP���C鷾�]u��y����*��*;�����-菱Jѣu�p��V�>��>w^aj��o}`�F�1R�%�3�;	.��$� �t�Ƭ�D�t�[���������&f�-Y���]<��͈���|����P�9������a�����S(.+�� w�H��
���<~�w]V5�^=�!x��):�.�nu�ʸ��{d��G�ݬ��f<�d{-):,�{�J`�g7.N�(����I�u32.���U������Se���PmN#h/:[$&�kb�j�V�A�<��fr]������ ���<ʜ���	�t�{L#y�wO`$�u�,�X[vV�S��k�o�7�Ȳ�}Ü_?�����c�������h�%���J�Ѫ��ґ���ԅ_;ѷ�M�NYI>k!d�O�P}5�~�"��-�B]�����@��'#�fZ�W�k���1�����@����SXhĺ���2H&G\	�)5� F� ������;�/� %��)�E��"�HV��n} �$�I�q��3�oˀ��=v��	����k����H�E01WrlaoawnϢ�#}�L��G�+rJ��}�S��g�
n����g6�G6!f�Vl�x(���@�g�j�9���͘����b@�4�rA���� ЪW�늠��Iώe��c��9͸��<��{��J�I�a�oe e�l�f�KdyGߝ�k���Vl^�!��έ:CXze�*ɚ���&�-b-�������d���0<�r��)>E4��'����뢷<@ x
��~��7�:�Ǿ(p�W$�SB��,jrM-�S�j��3���~T!�试�C3�P~}�{uk~;�E�=���C��c�h���W{L��MmN���� �����-�+��"~.ڛ-[��
�_*`o����6�L%a����q������z�^�o	��P殇�_�GE�\d��ʛك���x� |y#&+~�!�n	�='����|�g�r{���#��`����ߤW��+����q/-��\�q��*Q�	� u-�}���G¯��ӯ��EƬ��#�LgM��b�����*�au|t��P���eI�H��١��E�H��/�a�����xE�a����)X�2�m<����nE(�t��O^{��'�1�36�p�����T6I-ׅQ�N����`bR���L��p]:��������_jԕP��sow׼��3w�5�Q���qF᎔[�-��.���ZVX�N�
{[ٌx[��
	:JI4�v��
�/g�:����;�J�F(�x�~�1�/�K�N��0g�~�Nw4�aȆ��@�81�6���2�Uc�u]��=E:��[oZ��*��M��s�|K^P�Y�_����XAӝ嚣Z����`T�HU��zr��ş����E&��*���n�Z��o��/y$�W��.���x�y=��{����7�����n�?�0�v��
���D
_�a�	m]����qvNX4�U	
�����v�jV��Ë��
O5̵N��nl/��5J$� �7 ӌ�3!�|���~=�?)
��2,���Hx�-ss6HS�w�R�XL*	��v]��!��>հ��V^~X�`��V3��aw!C��Ra��բ�_%�����	�9/����[>��;8:���Ƚ#�s�.T��-������<�9��?�0��׀��@�<w�h=��qOG�
����G<�<��R�֬TU��z֐���Yc2R���h�ފ[&����DՑ��S�����V��w�v�Ȯ
�֕�lC����J�=���p��-�K�¿ȸ�3��1[�z��04Є��BtO ��J.}���s̤8�v�i�{V&|z�E���dai��xxA�H��~:�:�$�999�}��[��P�RL����"�7'������Ah#ć�ze�:զD�īV ���S�s�e40v��^�naI�->a�WG鲮�Yl��I���Q��^el��|T>�t��o6��q����/t\�s�N!cX/:�T[�1�f��RŤi�'U��:;'�2�!@�B�͂�:�j3H<���M�욍��g{݃��ޑ�G�r�J�c���eF������:*&s�e�������OW��A��\�+O�o�*k���>Qu50�B���8��;���YWu�cx�����M9Eq2-'��9��$t]Aٸ��Č��ę�X��5�JM�J��J�R����!��{� ��ފ��c�<,�9��coÀ�w�-;*�b������7S��l3�2w����M���#��Fwj�0��CA�&;VA��޾�Mxs�Z<G��
�~I�9��L`�[���f������]K�U�ܵ�1��'y}/��:D)څ	�ƿG*���Oqm�H]���8����!���V��B��@�u2�t�C����mö�+�$�
�dri|��Ul^w�	TGp��&�V~٧i:����.�X���d/܈'t?���Tp-s��2�([S��r𑵉��f�Km����&Ţ�+����w_�<Ѯ1~v�+�~�&ٳ8Ւ�2�Lo��_�i��?��	���f��v���c�F��2�.����L`%�z�Ӿ����O[��|-血9�NG�X�75�G?�ɪ�'�̎^�B+LAy$��75��!��W�oT8m�2C;]$e�r5X��C�8�~��u�=+���]u�|�fʠ������U͗���"x1��t�Пs0���i�3|�JZ��P �;�5(���5Z�֖IwcW�[A�
P��*���$���<�v��e!�;)��=C��x_,�m�W��3�j�:�,L}؏j+X���/��ο~%l��L+�R��=�F���Fy�j/7�+�;�5fQ1U}�1|Q(��?a(���F�V���F�cϙ��	��xoZ�>����[C~;�ã2m�>J�)'�r@����4���%�c]_a�Q����HT�'���r[هe(�u�@3��3F���`52ED
���G�*�BO\���y'�\�_X�QN15�]�U�z
aۨ"z�+�-:M��"�
�[\ӶQ���K|{���0��J-L�~}�S�XȤAn�'m�p%���Uda�e��J��4�Ez��g�q�4�;얩�f��h�u�j?��j��-�rk�L�(y�G>�eΘ?�.1B2_Nqs�����i������ ����ɠ'�eX��O������aV��g�!�T����Q�^iBST�Uԥ��c70�8���@�򞾫_`a�x�&{�R,>J��=�U��ݰF��B����o�e����TF���ğk`���]o�6�Q�Y
|��II��1#s�}��p`�C�&�|�e�2�ǲ�
���%�a#�o�gK��
_H,���Ї����O\�B���yY:�iE*�������&���c֙���L� �Fŵ	�H�!��PU{�������5
�7�����Ul��B����%���%\qc�JG{���q�2�(:*����G�ҷ�V�$6���� ��.�?������=��<�9|XL0�TO��_�b��o�_��7q뎟PW�ti�1ayN?�<�p�ll��G%�ʵ���1@�U��r)9Ϣ�w��}��g���)�1�l;��l�X(�Lҷ@)U�r��eu�p�JP�;�����3"ƻK��<�ݭen��t�]흢b�t�ga��A��43����_-���ø,��z?'L��$#ZnF�y�����{��^�LW���nM��}X��_��;��,�p�{u���KN�i��~a�V/\�`M��}F���U�L	���M���=ZLӋ����!2�$��`�xf�{�Oq�}9���=����*��@̮���A�]y���͋�U��[�=�
�+���ޣ�P=b�3�4�b������chP'L��)5|�wϭ��b0B�c*q�<}�~��d�N�.�0Ũ���=�ݢ��읷F��8x�����_wMx9/~�%���V�m���)96L���D�H4����i�f`SP~�]���A���	8���G!X�
?�JSy�$h�_�W�>�Q��/���m'M��rۑSbT��n~�0�����(��1�҇9y�t}�[�j�v���?9/���
.�/�a����s��fd58 ��
E�xÄ�^��$�T�����b秲7��5��}����3�i�#{�ZX�
���1N2�e6��o�Z�S��À�W�#��Id�[OQg;�����ɑ���˗ct_űe��{E�+Ek�/gp��h�[��#���ݕB�4<��ϡy��4�ԋ�n�"M�0�9��}C{i��{i����V!�\�x�V���1�P|2�=���/e[[�%�^�u���F<N�s7���
��;�;"jSU��*+ɕ���P|Ov_�UR���^��X}��cz�ŞhY WHۮ+q�N���Y�����6���2E|��+RQ��W�^��鲅�E!#�S�ri��Mi��>T���1���N[����*U��ݴ2��قn�7�}
B���[���E������,=CƐ�����&I��:56�0 ���kg�����+�=;�]C]�jһ�t���o	b���+k��4��B /*��(�a�t�>J����j�{�gҌ��{"�TlBi�z��[�k99,.�!D*�f�j�Sf���=}�Fs���lP���N�>�n�DpU��ˉ���,�6��&�Jg�k� ���R��A�H��	%[��@ֻ�:�X�5����y��ʳm�Ђ�X1cX`�~��	]Ȗ�j��о��!�1,Wz�l�[
�����646�}�G�a;�7�M�hGy�J��I�_�ivvP}��+��}�Y���k����

S�G��JWl��VM�`�(�_M����rɯ
7^�d�&�e�:���'��6y�QX��>�7���D�@���4qak��FbB;�S�;+�<O�)�"8���ek1��ԲU���}�Lo�W����$I��
?6����E&�]�J��b���ky���-�ƞ�?�����\�"&ػ�k�s��c�T��<��$�s�f����o0������$�~@�J��NY)YI�>d�$���=	��$�֬��O�O��03�NWN�x��R��d��=E���GW�^h�Y0f!o�-C���D� �����*Iu��/㺈9��
�$�J���Y$#/):�i�����^����Y?8��^�6��RZ��J���'3G���&�r�GF�_�u�G;����XCc�`
%*�$o%�F׸}@�h� ��O�5g7c1��ƶ��Y"$f@ �'ļL9�����ҍ駁k�;׋פ�Cp�u��
9B�v���~ȳ�1���f&q+y��0<�WI'�5 �h +�*�k��Ȫً�M���8��u�������(���amw�&�ǝ*Ŀho���J��7 )�5_K�k���Ĺ�"VL�0L3!�Tx�f%�LR���P
���Ft��O�+�������>��V(�_Ɇ��x�w]lӔ���_�K�K.ܻ"���_����贝�����E�ՙE�����Y��L�Hv����3������w�e��LR�}Bz����G���.>7�?��%IQ'�������AA}��%l��/�f'�:v�TBl�qɳ
1�K�dQ�#
�jA�l���,ݝm��������6� us��τ�!"��)2gbp���X�)�߱S2�(����+��p�M�v�t�;b��G����#_{@�r?�"~�ܐ���.��]��u�e����۰
ipː\��Z�I�;�|�����ڧ@��b�"U�o���i�)�{Կ�V>/�$���/�-/m�R��T��~�)OG{��f��G�]��"ڇ7hb6���])�駄�5�D�@���"1���>��7��-!��
Wűh�tj/,Z������j6���I��؈�����]�0R&��`��׌o2�cSXg2,�2x��?�(����b(������p��N�&��M��[w�O�
�B&Tj�VBU���.��!�D��C���;���m](���5�V,���A�!�-%�͚e�i��{��d�|r�=�������K��?��b�<�˹���?�,�E`ҁ+�P:`l�\q ?4���p�I�@����Ͷ��[�ڔ�{�f�-���6���@?q���2��eK��][���ֿ�o�s�1�qi��`�fJtz&̘��X�Wd)vu'3�KEA0	�\)��ѽJ��Kj�w[u����� ��ܪw�K���ZJ8��o@d���
���
A�Q����nJ��&º#��D��+�e{P�b�(�7"��t���Ct�v�P^l8'�#�}ձB����� ��'�Y�=�Za(o��	H^3�C��5�W�W���N�.#y�f������!�K�vv��It�/���,PZ~��c�F��zd#PRh�`��!N�E<��.O���aDW���yÍ!Ԩ(��X��3��m��΂y���F)S��^.]	�r
�c�.���a�ݯ�͐��{��zt#�'�RR�u6�#у*ZK�<w4��o�ӥ=�I$đeBH��]�N\!���5���a:�MH�K�T���y���^֗v{<��G2ǔ+���	���+�݃p"�?ę��a��koUB*�͎oE����yi�C��ʒ�!��"@��#<
��1��+1J���b�}g�X����<K$G���P~Lds��!k�����">ё�O ^^��'�0�����{�P&@���'�w"�X
1��`S���+t� ��o�����|r{p�t�hL��}�Kljt8F��'Ӥ������\������W�����M�G+G��c]�S{2w��>��
N�����M�X+�<snk��q?����e�bB���z�r��:�`?�0'�P෗����ʛYnU�
��7ҙ�ӶU���T��<3GG�R�p\S��bF�=��?.P�>�n�fq���Q�A���v��;����嗆
~�r�
r��J�
�+k�_�lXa�'D%4����(D�t�����I.��g�'w���9�{*,��TX�����6ݨj?5��J��
O��`�1�r�^���B��k�����D@"��l���]�ݬ���e�"[�M�ꍅ��[���{���TlX���J؏Ol��FC/~7���$��;�*l��1X�wa~d��m���}�D�"�@���kL�b����~��� m��V�!��e}|��6f��W��K,����/�1*��
�]���&��F���W"��uS���9И���r.�P���*�۝s�*݈.φb�ц��zy��R	K�G��#�ʫxL��Z߽�a�O<���d���O��x�
��=�
�
�2���QY�E�����H�J��~�ߙ���0_����~�����/������������.������������?5�I�( �9P+��ϖ�?-}u��f����=�z����2���^����c=g��YYi�hh�hX��_z*F&V&f&�K�����C�����"�̌����`� ��t� �K�����
1�1�8�	P'yN�ܙއ:S߿�� ���� �S�A�7x�C�\�����7t���_���
:ɦl
��2�Z~�2�a�l����Q�2�BR�@���eb
2���5�I)��Bhk���	<��ˌ?U���?9��;�b��D��,d\B�C�Br���W��z�W�ӡ�����%�x��.�h'����	�8�	�r���Kp?�7�䇂=oO:��g�i��>~G=�o��o����Xߝ>,gpس�q?���38�����\�~V5*���.�5���gp�38�Y�tG>�;���������<���;ag�rw�qw�8���o��l�R` �� @ЁM��0���
��ux����xh�^|�ϧ�iഏ�i?�1���x<8��G<�{&���g��*g�y�әx��3�2H�g═���?B���#^��L���3�6H�g�]����{!���B�?�������0��	��I"��4�_�� ۂ;��Pu]p����4���??�w����������u��\��+pH���`���~�Q�_��J�놔��� h����͋�����<�>o ���<߾��ʏ��?��T��k���@0
�������!O<n��t���z��v�����4�Q;?xX܁��L0��c/�*ώ1�����x������U��,p��=VI~ CJ(@�i>�������@��Ax9S�\�gz��.O*4 �./8��|�:�.�4`�����P:A�S
 �� �o�����#���A�Ay�>̓�N�L���5��/�E��&G	�L� F�'��I\	���I����џ��<;�����À�<�H���a��lNơ�x�V���x��x��[�7],'|V/�r�Z���(��m0/��<V����㤐~£'�B�Ə�%.:$�+�P�o�.�W��;�i+�Ŷb����m��o����/`���˶�_h+޿l�׋�	`��Ͷ������>���`���!+F�!ߑ F���9��8<�O�`y/� |�܂��m<W����1_�'�!���8�7��>	N�O�{�;�C?@��^���C�8}Ҧ^�B�����s̗��^ �9J�p �O�$����uRߩ�:�y��$�R��:"���C:5���.�4F�&�ޖ*L�x\����L�5h^	\w�!�
^�KHI�'c#��|$�.y(%���`�bn ้��S�	�XKY�
7�Rqp��j��@t���Z�@=-]]-�����	d=D��W BO �� ��߆��I���a���!k+���#��A�R�0�v��}h8����=:�V�a{GG�������cphxpt�	���!˞������8�: e-��ă�A���a�?.�GG4g�( �-0vz�Cp�kc�! /
A4l_ ��ё��=�D�x����]��l��a0��,Z4t����iz���	�(��(1��J� ��!�Tp����D_��bu��0�ð���}�p_�A��;4�qH���p��qy��k1p|�W���Æ�<
��������݃r�G��e8�h+Sc4`����|.����|.�������<����g��������������"�¹��=���m����;�7�~���a'�n�g��'�ӳ����ӳ[�?� '������N���]c���?=�>=[�<=��;�k^=�������ǻ�>���_@�'��'�N�|���7O:b�$~�o�'��7���g��������%ř��^D������s3}S3V*z*JZf�QZ{:*�c�?u��>�<���<��%�S��W~����՟rr��9���~λ�8���}G�)��{g���vG��gqG��G�㨀�_�h?����y)
O��y��O}t�����9��8�����������X=��˝��8O^�h��)w2�/��7�O�_�S�C���<����~��yk�e�������s��m�����A�'=�;~�o�~�Ӈ�$?����s�3�u�Ο��G�?�'�e�ϟ�m�:Ə�_�D��?�����燓va�䇽@�����'8ǅqy�����
Ԭ�TT��s:�<8H���R �� Ė9u0q-0qUe]]�HY���?Q�>�cSS3uu*U�~j@S=�*�� � 5t
�pb=� �L��L�U����q�y�
�� L���T`բ�������t����[ \87<}�N��N�_�� �?���?Lʟ�OC���<d��ytd���|xzy��y�����l����ix���I�3�Ow��'8�����_������i���Ӑ���<�sr�x?=�9
�cp}x8�胁��O!d<� i@OB.�����A��[0���}�Їɮ}�T�W���"�����B�������o�W�XB��pB�_�O�<�ϯ��3�&��	/d�5L��	�1a3�ʄ'1��L8�	�0aí�n�sw��'G�]��E
��;�B
��O1���N��;�DI]"%��τ�L�?o����N���=14�v�B}NH��������tR8̗�ֵ�����?I�Y�Yi�__��{S�zI9<��M�yt.��e�&�������E*{��'NLF}�M�I����w�v����H�
~+���������&���FHo�ӟ��K@7�m ��+�6�@� <J9��fc�D�\(���A��LG��/B�o
Ly��M���29�c�ƶ�rml{�T��K���3���Q�7���6������u��鮤(�����b�?M��w��wǑ��S��to{<IO#4JS��R�?��ht��0~|Lc�w�F�
㉍��-���g�p{24�J���������1\���L"{�JT�U��?,��E��^8r�s�H�[�%1�Ƅ����O�[ſB�_��~RE?�I���<�U���b���������b�c�CaL����q�x�p�=�o��U �w�J~/�O����t������\t|G�*~˿��}~�y�~���meұ�ϩ���G��t.���J?��cЮ���˳i��5N2ϭ�ʾ��
6@�7J�����9���X����`%����|�3�H��f��w��>J؀(.�}n���DP����XH������)�(��E�ݱ|����ȗ�����J�"G����=�	��[�(���;Rc{`��?\�{xh<�ez�Xë�F��p�g�=�����yhي�5�Kj����]��.��,�1�d2����?�(����u�'b8��f�^C�L�7|���>t�,)�����������5��]��0��F������|�C���iUD�7�pFp�_��l��i�mD�	��^ׁ���o��38?���4��]Y�ۣ:�B���D���u�w?��[UC�'����Z��m���;h���:45yM�{[F�P���E��:��TiY��CD�Ck�i�Vj�0][�;2�46�m�ѣ�,~E��7P���m%	��jh��cKy���e)�������W�1���e����x���j$Q{�������/A�>4��9���4'~����	���4�u���w�� ��1��B�����[S�iʡ[GY����+��^����dO?L�;-�Bཡ\k�U�4���1hZ==�
:�<)F�*
�)�
���PvP0=`I�o:��A����:�vJ�mm���QL���`Ͳ����|xڕ~�1�M-�і|�w5�����-sm�i�9���/�:=�������_vY>��z���O�Ҏ�?�:�_��:��$𴓺�K ���.:�v>���q-�۽tq����f��T�9ݒ�Ә%�2���^DgX
?k�	����Ct�(�?i�?Y>�ԣ>4��V�{Eξ����e�c� ����y(��)�.�:�W�w��Q��1���7409��fY��'��2zh�m<,���+A������|��|�������J(�/�L�,��hj<	ex?_���h�|��{
��őf��쵀d�O��	����'A�b8�Mn��(u�>���;�ݡ��x��Ia�!>�P��}���eC:�ݣ�{&��#!2�Zk�M�44��+@����j�0[7�w�wꪒ��.O�i�8�����1<�)�zq[�M�}��lM��X�-q�8����|��5�z07�os�4.���K��	`��Ci�i�1�ƭ�h�gy�}���6��I��Q�=A(�5גo�'�z=HLw[v�7�`�>�ދ��Ƣ���:����ہ=�^TBT�Xw,��cu�`5ڒڌ��g�ζ�8�S
�I��l�� ǫ��#\7,���G���nҡ��t��fh8�с228�PG��@>��E��fE��vshhM�y��Mj<W[�9аK��L���F��l�Ƴ� DwC�����/�ll��=_Y��<�٬�l��� Ck�kT��"�1�N������.W���pV]Erc(".��������/�(�#[85Ɖ�>�x��Y��	U��F����+U������v^�%w��z�I����8�ȏ��>�+�1�@!��޼��y�yt=��R�K֛�+8/!�C���(�t���FE�XƆV�H@��e�����..�k,D�u��8N��|_z)��~�����Ա��D��('l��3IC��A�8��=�}��* '�j�>�����#bKm}�<g2�x��̅(�12�jU晈���-��sM��Zӫ�g��r��H.�8P����8������Mr���i�~$�G�v]X�{�s�:��C
��lh���¼��E��1���L�`c3�Q
������?��"M�%��p�ѷ���耕T{�@dV0�1��nKN����0vs.�jQ7�/*�*R�Y���A_��f4FU�˱�G��&g
4�ԡF�J]�b���d���:�1�!�����t��Ǖ���
�6���c'PK��y��Ɩ����o:����_ð�QD^[��+���}I?�����D����.9�Z�/.qJ��8�����K�����������>-�^�ʩlq���F��|�O7Z��g"��_r�Z�9������zq$��$夐OZ�UrR�%�?�	1�#�Kz��d~r�HzI��y�>ɋ�!�nJ'n��g8%�=�v�t���8��Ig��I:G%E����%655�D�E['����U���\rF��%ed�7�q��H�1���p�A[�̄��C���C��v9��i�S��龜=��_dhY�u��3�!�����c����Y��m�c�ls��p�����%/���^���`�o^^�3v�yXawM��7b�R�l�<f���g#�O5����k�Xv�q࢖!Y	����t��$�:�M-vG���\Y#]-��r�]>�6���Ik$����r�l�,+3+�aٛ�H�]/3S�O����5��Q�X�Q���7����h*���O�e��dpXoc��<�C��Ye
1h
��a~@2"��s�"�-z=�޶�U���\U_h8P��Q?Y�.РY-�sbz�9t%��nHic�w0�8��	�]L�m�3g[|�)9сF�u������r��f��w�¯�v5
�>GO��I&����`	%q��4�[s��Đ竒N6a^�x^�$B�{ɞ)/��������T��av)�ם?u778��Hs�i��͙C����?K��憨��k�9Hd�Л��}�;�V���5��uD܂N��+C}�_p���z
����s�BZq��FoZ�6�rSK�i��9u�M��ɩ� �����Ƽq�f���MN� �AX4�|�-�8ڐ�f|RA�߁mO����YI�TTM>|�����-b��'a�1��AG���{�GV�y�� �ӷ���ה��x�KdW��R���N]#�r��k#����Dфol����i(ȥ쨸E�+Z����α���Rj�(�P�[Ш�x��0+���
���U�u&x�����Zg��ΰ����)��p��6���	�	�*�-rIs|)���*������+ށ;�q�ǰ�PVѬ䟀*g�
�ы.ȳ����[���)��J
�B�-�c�=��;�T�)+U#9�o�3�2�r.��c}:�F�Af6"��5]��q����ז�P��eߘ�Kp�iR+�XҎޗs_n(K�zNE����(
�����Ȩa�iM�h ~�S�����p�Έ��!��Dѝ���������� 3���49�E� 6�3��z�{:1�2'��s�@�_���]�g{��t9\x}���H�1�%�����H�\��Q,=�;�p>�^��H�T	����X!�@\���{l�7��o�$h����V���"���i�)�o,G9�/�&ߖ�{��8�����NA���Z�v�\g�,�GdUY��;�:,!k�I�u�ǔw)v��0��� ����Bה
��$������ް���
����(Іj��T�9�/��R�g7�H��������A;�C�R�Mg���ApR�+�/�w:�=)�뤍�رmbq�y#+�Z�b
P���ך`�V��9T�ATPE�D�粠�g�o�<��v��q�x|٠�HHs�7�8G������f��x�|��fِe��k�A_S/0���J�QH1�j�O�����>�y#�F�1�쨾���fY��@"���R�=}|C'��T�#�F@&I��H�q�Q)+f����G�Fp:�*zTٸ�.�Dt�`q �c�T"�Ttv����P��� �κC���
!Bt9cj��8��IX��)�^MlBx|%4>P;�Q����!�\p)�?�a���r�.G��Z;:Nu>"η���=��#Z�`�D�<=�3rF/�/H}��n��X���P��'��I�F�3b��@��W�pE�Z��A�f�1d�0��VQ�T�ˑ@�N���Y�����������_�Ѩ�a�O�4.����O��b����S�=F��%-�8ޭ�1��,E��~˪�� ����GÀץ�9a��o�8��������q�ɛƶ���-?Uh���廄֥��=i��v�ӊG醃TP�o�4��h��^�xB)��qB7z��-nzx~���ׄ�cp�r�7}��=�O�eG�%ig�}���� %����ٹl�u>�q��W��������D����Zj�;M�M��~�
^�L���*ؼ���)Ԍ��,�4��iVmr��s[�q2�ʦf�/��.�>� J#t�����
�]`�D�E�&s�U¯h�����A�5=>�p��LY�<�5�g���EF����=�T����Vd�C���C���L
f#�&gQ��Hg�h�� �O��p�%f$&$�����M�sQ�n~���Y�ӢhS0�	�a��\�u ��3!S�V%�a����0�ge�YLկ\��s����X�Yݭ��I+��Y���&�0o��Q׆�ѵ����H���s&�A]��D��՜�w'��;��ݻ�>v�HyV�iW�bY�q+�1��2���%��~x�C�c���s�c!�W6���= �-��|C�A���ݳ)���0�
�{4�i�TFw{�
z����S*m܆���}��2�g�]b|���`l���m�"Ƴ�Rڻ�Rt��ݓwh�t���cܻ��r��t�2���)?)��I�+��rBf����ɶ~.5Sv�H�p�{���y5޳���:�Fu��0�hV�u���c��8�<����ƒ<��!,�Lʪ@&�[/f��n��`&#B�8�_hU�Y��\����JƏ�����M��tL�ϙ�XI+�iIU�Ԃ��Y�ݜ�����lX��I�,�q�.K�P�L�ӂ�:F�y캈�͢� �
�$$�/�m�3���T�z$�,Z��hrQ9�E?`YT�bs-�֢�lK�ڱ��0�o�#k:q�X��M�
�
2�� @N_է�B1ɭ��6��$Vy�ͨ�c���΅wь6q7:GX��ܷ�5�-�;9nm5����;5�#+ع�.C��t1�~ցk�Ǔy�|�3jV�M��+:�5$?N#�]Zl��3��^}*�V���qӺ�={�1N(+m��ۚj8)�zv<C��4'�ȏq^%�n���E��</q��cʄ�b1X s77o��"4��l���wo��>9�v���N��=x��r)�愚$9*u��]Nṡ�8����6�8����9���Yۚ
����l�Ǔ��`��*���l�M�(��Z��e��:-{@J��u(nb�
��2����	��2�X����>�,���U-��k��*��Xܖjٳ�ƅ��͞R���,���/h�Y�4Ʋ(r^��|��Ca��[=�xh*��`�Pl�c�n�ݼYOX�j�JF�րf�z�u�m�B1�_��%��j��,�ybOh�h+�W"m�|�._A�7�}O�V�U�y
E��ۺ�DW�:���P��/#�m�xzO��1���JA^X�u Ǹm�3ZQ΋6QN�z֏X�W.B�(p���G�fų�uT�*�K�(Vo>��r��7?�y��:k6K�z^#:�PP�8��d��i�o~��l��}
�K0�&�Io�Ң����=z�\K�IkXcs�r�5��D���f�������8�ç��:�UGY����҆������/zt=��ux��<�fHƜ�h���cu�
#��٨<S
6j�c��.�ct`��
�5Fb&�{��ʎ�`�1I���Q��fG>0g�k�f�\:�C׌"�֋OE�$���n{vʸ�ZC�P�=-�\�w�܃=�-�����߸�o{�q9&�l�
nF�:.�:��Ս���ټ�[BL��iBш�T�!��V�3��Rd�e���?���3��)~�Hm���Er�ڃg{Xe�J$;�����)b�G��!�^�_���g?�!�On0b�޸"�QA�i�'j��{?W+X��_�����"��Tc�`�f�%i�5�M'L��6�f�S��̊e��sJ2�l}�n��n�6��u����5�om����&4�3����{��͟�0E�Zp"2�U�"��yEVF̹$Û1������D��[kw�3���K B7�;���bִ��'Z��u�<<�Si}�I�dò�9�8������˳�u�(��%,� _{����V|�� �?���ų0�x��b�a2�<ŀ<��u�2�.�V�b�i%�N�ֱ��r�E	ɭ��	+v��T��������sC�e�l�S�l�o��<�����J�¦e�@��ӰAfh�9�B�rk���L���Mʊ�w�>��U���O��m�/&��>aD�TGY�cƣ�%�g���w�J����9b�Y�
��B��-I�m.�jX�Ƨ��0Q��]9��n`Ō�E��57���G���;���w���c�	��:��V�%�v����M�>���G����j��v�&w�@|Ϛ�$NiK4��o�Ąw��f"�u���Ӕu_�;M(�3��M�G�,����>_�8k�Us(��"�Q��h^[����&�����H�1�ymH9��T�o+\���h	��n�k�7�L�����+��K�SIV�QTMB@�z�j������k#����m�Id�N�ߞN�p*%�-0�l��/hϠpΈ���;!:k�}�] ;}�՝���t;"�N_����X��k������hs.G*q\K����=Fp(Sz6�C��H��v�V�D�MӘ�Ӎ7���l��6-�k��A~ym�97M~&n��};ʓ����Vζ#��.z0�MLh�/m�U��Ӂ��i.������	э��7df:�݇z�N�ʯ�ɲK�=H��*ѩ�":I��
��#;���Nw*�/��۔D��r��fr���/m��L
|uQ�;M���k����!0��h��Z������R�4�u�^qiB,�A����5ίl�[���@t�M����5zt��&�!��l̈́歮�7�v>u�N���V��|��������.�5�.�:�6+J��^
�%�4�Ի@�cS:c��r�QW@�����%E�����:\��䩍���a�dF�F��.g���e6a��\�m;u0�����v�o���V6vqN��ˢ���n����Bf� >l�K:�[�2�+yݩ-����IY��PHwu�TvQ��tn���[j�[�J����qshF�,��Ih�(�NY�}`��6�v�`�)��³��m�w����|�S�Et�̘�ԷQ���N';خ����O�g��''���R]�w�(��Nsӌ6jƻ���#ەR�IJةw3CΓ�1 O2ׅ��ۥ�簅D)N�[c�p�2���)��&��zZ�ԣ�����\��0�m���:�7�F�Hl���6r�8�$�� F���Df�D���x��OvZBwJn��d��uJo�ΈP�����y����&a��������cz���DNk���["�D�є)H�sv�����ȫ����-[���@o��<�G�.�p�A�W6�0����own��O̬1���*��Dh�nq�.�����^C�o��� �5��@����l���u]� ���/_�P�x\�$Wo��o�E߆�}���w�S�H`�:%`���.�dnN��k�z���-�
i�x[ޥ��l���k��>cO&�)�.:���Ɨ�>�|�K��kx��K|{L疮���L���!b��e�G1�m��C]��3����g�fZ�1q�ö|���wo���3�*���t��&)�+�+�AZs2Q'yS~>�]���bʩ��I|�x�p�]�Sސt~(��>B�i��GzF�a�32l��-�	�)��#�:��SP�d�	 h2�gۓ���CvR�1l�5g�9ON�ϰ�F1���F�E��<�W!�< �?LpO�� zb���L��w�9�_o�{�o֯��QI[E�P$�:�)��k����-�|fQܞ+�+�*���7#vi�O�#Y��s���ܷ���\��#��ሄ���xN*���k��sZ
���o��R�-�5]���]�����_
g�9e�q����re8��i�/�JՇNY˓���?q*��8e�D��g�7�
m����+���
mEb~F�ǏW _�|����,��r��{��g�Y��o��?��}H�s0Sҹ�����(Dq�š�o�(�br6�������
rVdlY����'
tZ]�n�S�d��h���$�������:ESt�D�o�%�ZOI���Nb
G�������9���"mlUA	�����S��p_9��$���^��&�?ML���>�SE��Te�m��P��qoo�f���b�o���b(��(>�5�����=R����=���(�x��~��J:]N�UI�tD(34�N�Y�*�Iﴈ8?1���ڥ��ΏfԌh2�8E�;ϩ�`I%D%�o��)� ���wY8��@�0��:�{��Js�?A�����ZӎkX��gL;���b���{$��<�(�7[�h����0�ʔ�=1k����%�;ހC�S��
E~���L���'l���=d�����n����4E��Mh��FŉZ��"�9-����O6��'�!Rb
��fK;��)�y����o�|�t��(v`�󪝦���d�7��G��	�1���D-��ԂNPU�����q=u�c�No�Q��
�a,���4�D*��?��Cd�>!�@4u ��C��|���K�Ȗ\N��
|�ޗ%�>o�|�w�
ǅs:?���u-(�}'�a�Fh���3VyC&��w�1iJ��np߫H������x
�����VX������v`J"��g�c�K�;�u��ףkN;<��P�i��f�(���:�)J��B��f�cU.eé�U�1{��)�_�k)y�.3� ��0���,-
f���۾}L���	��^�}S�ڙ��-ո�J������H����(�]#x�l�61B�/7j5��Ƴ�:��έ&�IR��-Pگ؍b�p�x��s��q����a
X�-A;߅�<���@���)��H*`;�vS���踺��K���v��{x��oj޳��v���ƹ���Ka/h��U��r�K̰��A��� ���D$����	[�I��F��$1�
;R�\߱K
�&3E�w�(Ŏc�~��c*2h�o���H��q&��;O�b�N��̺�j�+_(�I��K�W=�w|wi�e��ם���;�L�K�`�����Ld�0�7T�咓m	a�ZCjy�!}��<N.+��F!?K&aw%��"k���њ��Xe���2�;�i�g��1Lh����9����~�}8a�Nbt�M�X�}`�5�a���pS�W�9�:��S���;f/}��	ss�+gxK�#���X�V�׿�M��:t�n��F6!���=uA���t�͖7���)�<:a�������P��z�o`���,ݍ�U�a��
:I�_d�M��Ewcsu�z��~t��f�X����%��[�lXӵZy�#�
��;ؔ���-DjH�ǆ��Z�w<}-�w�y��۸�u�T��r����sˉo�5�y`�q�	��^��x�*���&_&�g_������q9^{/�������A�
K��^9�iU�4M������$���0|;/�K:�G�<5x���q��������h�z��7U���\�������Ȫ��'����ܾ����B>7
^J���&oq�l��l'�`*�2>vהk,�.��=U��g�(��\����B�zCnm�'ͷJ�q	�B}Q{��Y~�t9Z��m'����9��w����^�{��3���Ԯ����Š��}5��X��]Y]���΃��g�Z�X��`�b���͡��#|yB_��rp�ox��{�;Ww�����M:�f�a�����up[��;<�WN&�|�ݚ�W=�D��k�v��ǜy�#U}�����=�=�|oH^HNG)#9�H�CQ�[�u������r��+�[�����3%<&���=�/�j�^�
JU�et9~�8�xf�x�n���}S6A-Ԓ������Pf��=�&��р�X�I�2�>�>�L|�èfy�5
؂ޟ��2"���߫���F,
��R�C��]���ߎ�M��z��\lu�ޠX�ң�՞|t��з*�A�="��k\�)��g�|'X�G�r�����E�8�h#��-3Pж�4_:��=�R�����`������;W%��Km޺dױ>K�7&/�4�8�R��S2��qa|h!R��>�+�#��@>���[�rln�vq��r�j���n�>!f������E<��W����e|!W���ȕ��#�Y}#���C�/ʒ���S ��;��f�^��8�2,���(���H�͒H��P��j'.�y.�C���Ė��v~ξ���;����^�2������|�q��k��ݨ���!{��G\�d�0�
�K�xZ�W�5(5q����
��������B���s\��G~J���Uk�m׌�)w��l8vE3~ۻ�Q�|~�c�m�5����~b�����ܲ��!O �yK2��e��N+�p�A��A7�1�{�ك�Q�"g��H~���u��A��^2�0��[�X-����?�)z<������J�.�*i�얤}43��=nG��5iZchi�ס��tx/��53R�Ѻ��̥ShO>��Ij�7{���T��Ss�_��(�ʊ��6���]㝧�p�f/��w�<$���\��9E+��ƦC�4A9��i�
��ojJo#�_���嵩�m��V���)��9t̶L�Ss�-�Ͳ)���<�=��<�g&Jꏈ�mL=s_CzcF	�ޣ�1n6\�i4�x�8Ϥ\@ ���	e�m�]�:�]w�pv������3���s�ެh#���5�Aݯ"Έgnx�}>+zJ�ZO�����&�!���&4qʎ3~����z�A��@���,N��si[�|E���b
~1�����`��A�r}g͘�� ��0y'u#���{?�Ǘ���Ĵc�Kv�c#�Gꪜ;��Ε`v%O���=�0ьs�q���,��d|-3	�%N	�v�$FZ��Zc<ůC��H��HD��5��s��Sb1c�wۻ�x�[C�/}��}��v���&ى�ckP�l���r}d��a���
q/���GQ,X'e�%{N�éC�A�u�A�M���\R��%��R�I��"�>X�@��@p��4��)~_���Qk�iP��uDb��xތ�=R&�Ig`�߭��8ň�Z�?.b�F���C�/> �(J��P�\�u�3�:��V�
�su��?d����+��[w�
JC����?�����k&2���Y�NG��s���p�q�w&AP` �^�#e���L�njw��?�ep��sK�k������c�*$[�~���!�E�Lf���'��#�!n�rOlsd}X3n+�m�@�z(�Fl�������P�bэC5�fb'qhu�A���l�-q��;���<NA❐,��G�H�Wmh����}��;��|�c� �g}��ݘ]�"F&�*�j��
�~ߍW��8N�3��k��ĵ�+`H��w&����
����?��;�sN��������2�V���։)�8�-�ѡމy��?m�o#}~�,1Q �S/F]5��U 7m���O�q����G�j(���=�lq�d :O�F5`=�c�t�[H�Q���a��nκ��{���M�US�S2p/��
�c���P�����{��A���]U�J��s0+3�z�K�p�b���u�[�}a�]�RԹu���ԺuW�9UZY�*�q��-v͸"��rĿǯ�wLy[Xk>Q
;Aŕ�g$�$|-�^������/�����ɖ�<�h���Q��U������x��qa2����?�>aՎ?&؄�u�٠�}F��V���e
�.�_֍�o��ك���.�g�����0<7?�EՀ�4 �/r.A�ݎ�n]���gA_��>��.�c�{�}H�Y�D�r�~/�^��	�J��r�z�!ǎ��[sy���w>���zG��H=-�]���5paY|���f�n�� %��)�2Ӱ���s�)�
�^�o�:��-3��.�? � ЕѠ�&
e^Ӄ������
$�I`����4Ȧ��\��[���X�w8\5I�}�f@ܟnK ���p�[/O�}��}*�rX�C�>]��� �iG�久a�������bq+1����9��-��	�i��lhF��f|��f�#��i�A���X���È[�|,�c}~�G�t���o��J/�p�q�x)�]zQ+
����%�,Qv�w���eƳ6���*�A��F2�b��q���W|�,��wv�(�#��_t��Cl��>�����A<dLnE�!:�E*93�PǢ�Y��؏�u��g����6�gN/R�b��풧iӑ��Z	�hC��̢����[��m�L��4���e�^��s��~Ǒ��|�l��.���g��L}�����>��~��E�H�l?A�a������������t��3�U�a.ۗ� ݗN��j�o��<ic�B*=9��~Ǿ���^�Q93 ;�]f|Q��S�{�th��	a]�`�a���s��/F�h�ͤ"���e��LtF�q�m^,u.�g�y����z�g
b�Շ�r�_0#�����?�-T|й���x�a��p�!���g��փz�q�5���U�~ٌ�6b,�0m&�
��~�PgJ&z��T�>OdF�,Eŕ�;Bw:�3!2EK/�u��'�h�������I��@�����R��p�2ʈ����$oS��x7����%�H����w�_/#��KEg��H$SF�>of1P�Ϟ1��*a��r���!���7�k[ÊO9UuO���d�1��cAo�b63[���].�g_ԟ4I.��I$���1�D��T
����gWf�9�=H�l�$J�2��?%^|�+��D�p�Y�M���ړ�W���ӷ��5���3M)W��|^u!�ŀ�Ct�7fЌf�>�M���ߝ��6 ��K��#[���φY~�����EJy��tn��`���S0���s!u��6r��&y�bf�^�63�-4������L�]$y��%\��8ť�˫v�,�Qd��i>���NQ̌�w��p��b̘|�x�+����%(A��V"k�*�5�}�Q�|'u�Mc����`\��ٮ�BH�*	K�Q´YxmV�V�JqE[��d�I��m>3�s�i|��	�h�4�z�Gw���J4�Оb�X!:o�)�����)�k[�h��[X������1��͊.-F���$�΋:��ï:ڃD�K���(�H��	=&��"j� �\,�Qa���F�����Y�A�n��]�����q��N�u��eFE��NJ�9s������*I�$\_|��swo�~<�w��UY�S�z�T�pK=
�%�(aݥ��k�	:E�^�;Zw��x��a�(�l��q���X�ǲ=c���L4��i�t�/Z�.`	,f��y�W�\4>hB�SY�����QJ�kd(F��_@��tn��l�Ys�_�a{P�g�
�hW�ok�߯�+�qym��̕s�2w1����&����i��ol�?ϵg��L���h��׊��b;[����-q�ks���h�
vd��?���x=��#�@��1#X_�{�����.aP|F�^�&���M�u�����bi�����k�w����W�4��O5�d&3�����3x��Z7���S<�!���^�Dԫ;��9l��՟�Ka�!G��q���׍�1/13���{��5�-�h�BX�!(�1��9��o��:R��&�m��6[3sŦc����g-:&�����&����ӑx�K�z5P�~�i�O%h�u�{��}�O�J��8��Q�����0��:+������u�,���ۈ�ݎ�nj��!����}H� ���F�����%>v>CLo^�hr|����Ra���:���YK�q�F���m�#Z��$�����6�[����+1�f��=C���.0&ۻw�D�8�)��߼�|.0Vrx�OV�
�C�4a��1��w>2v��Ql��3�]E!{0��
h�ֱ�T���#_+a��H�[Z�3����R0_=��q�a�߃[â>7������R�X�L��/|�V���ύE�V�7�搔���Ǎ
C�q.+K�������/ض�S���ݎ��&�W�Z1���e���Ɇ�zĽo�uYr��S3�,���B�6v�1�_�������]��nǁw����J��5;Ę9��2f�����oT�އ�ۀ�M�7��7oT��7*t����`G1��|�!�A�v��A�
�L����X����"{0��j{ɍ��c��ܘ�0v���L/+N��N?h��l�E`8	pU��J����wF���h�?%�_>U��3;�"��}����߽ɲ���?ɚ��tЇ3���r<�����F2��k=��A:B���{"HJ$�HU��A�G�	
�Z��(
�I�z1O�/�j�NO-E�ZM�x`�|�|�SdI�4�c�˪ɝ�jY5�S��bQLQ5�pAq!��-n	#��J��Ռ&t�G:pw� �I��H�T���R��	������*����i��VI�8S�����/n�ynQ�\�;�}!�$`=��-��t>������U�.\��8%8oȘ.����!ݨ�É't��Zoх��'�w�Ĉ~E��Ζ�[����]=:
~H��ޗj��{�b��O�y�5�B�b�Ch*�6�����Z�,��d;B��en�{>��n�n7�����ju��\�qց��Ma��4f����@Wq�Ҋ���c9���7���zі�:��qy�����Ԁ�W���W?ݻ�]����뜤O7`{���� ��.Rp�K�T��+�y�["�B���RpOn�������+�;$�����>ܗ�;#����,��!�n���n�\���)�x��
n�����<�-\��JW)�'�Qp�n���
���ۂ{_p�K���E�]���\��D��N)� ��.Rp�K�T��+�y�["�B���RpOn�������+�;$�����>ܗ�;#����,��!�n��|�N)� ��.Rp�K�T��+�y�["�B���RpOn�������+�;$�����>ܗ�;#����,��!�n��i��W�X�/8W�˭C�
i���������P�*/*)��azo���҂kJ�W��F��_�+*_����I��)I���ru]X����v����qȎ��u��ՠ��DC��f\�ss���T]C�#'2���a�4��$��RP*�&��(
T���G�E+P	Z��P�Z�V��(%�qh	���CM�zmDO�X���3jE����D_���	�1�}���N�������Ct��Bg�o���w�[�������$I�r0�	�A�HD�đE�"I�8R���D��K60��3N1Lz�g�ެ���"$'y��%�*��E��m��y����ܢ����*�l�NA�;)}�[� ���ap����z%���ʕG�D���P:��s��� 
��	D�����z�7����{{�K/����?������i��#,c���N�����S�i�g���su[�m߱��v��S��a\�����B�L��Q�����f㑣��Z;ɾ/D���݁��:$[8�o��a����ӑl��p�n�x���t~-��&�9��$E�S"�c:8,���wX��|��%��_XJJ�0��7?�'\��r�XA���\����M���
i��SR�O��6)]�a�dp�>X���¢���ت�%%1��G\٫��*�\��� �Λ�� �{K�������B��{��מp��:yߴ11�����/�~�W_a�^��ď��*k"�_��|ݕ�ڗ�����?u���d�N\{"=�?��C���@'xd�3д������=s�jԛ�
6�������	��H�:}m��I���㓒S'&O��&u�DW�;���2����h��h镕�+��%MHNN�<a��Ĕ	iIAw�W$O��ؔI�&�i���a5qB�����#S�����%�������'�������>�NL��S@]��g�d�����������K1nY�q�@
������,_]4�.,U`���:��VJ鵥��5�,]YJ�bCW�Etaѯ*��W�+��.+�//����\�_^�')�K׬�ˋ+VL�^�Ī5�vO� ����\��.v��x�ڇc�������N�B'�[�'�KW���BI*+צg����tRf:38��)�RO�W�&B��)�2(��)S��?��'_TU\��Al)��ͯ(���*���k�*��rȩ좊�^=R(������������'��0~|�Dm2���Ԕ�{���y�O�4!%5--915yb��d�v���� ����ݽ�?=��@���S��7����MEQ%� C[~y[\YTP���h�z���Jר��:z����Et��ϸ]�6a�������Rմ0n旯��Ē|[X��:!���xUe�w�	��r��Հ�S�;�*�'�S��]�߿137^���7����b:�_1����O���*��m����h�c��x�#���j@��byq/]
��ҳ�$&� �B��4"p���8��%�@ǉ||�x��nUO�¢eK��V��V����(�	3��yٹ�ƭ�(��M������7Γ�Ӈ��8�N��2�AR=Hg��N����K�'�gժ�J�As�Kկo%���O6'�ԓtB>��]
������ ���'��Ӽs���j�W���G�ƕ/��:��0��x�ꪄ��		R+J�{˥dj��q���P�k��>H���#^��Ѡk2ўlj�z��wm��� O��ވ����	�j���j����+�ox����ы��0<}�fx������l��/?vx��yC�}��o~n�rN� ܠo���`1����I$Z�F��K�K��� ~-k9�,�;����T��@��] ^^���E���%���������#�ҥU�KaN�_R���8K�	L�V��Bk�a�-��W�)*�����X����{��8-͞7k)��)��,*�7+�fy���䏬,]%�]�F�-�8����������a��� �V��1�K�������&.���{��W/݀/��{s�5/���y�U^p��[N��t�>��{��m�{���^p����Wwy��^��^po��U/��{vG��J/�1/�0/x���~���=�{������{׽��u�w���~�;�6� ��">?��O�T��֬
~f�����r�?�s�NbS|+��v�������?�`�L_��r��?���Z ��M��
��[.�.�w�o�U��C� ���AD��SJeu���,�B��0�A�?�D�g�G��.�U1��3�|��Lhz��ؔH���p,���9�W�3����z�ꖄ����Ɍa
$� �E�W<���8�Kp/�{�'��	���u�D<>�u+�0�}O��x-������#�}�Ke��ϊ2}��|�OK�|�6Hg��V����j�}�����7X������:G���s,̣gp� <�^w�wݻ�]��{׽��u�w�o�<��<�˼�/#�'J0�={�6�t�!Bس�-L{��y����> �f�����Mb��N����:)�{�t]|�^�`�>�~��g�}X�=ji�G�=dB��.i�9I�r��|@��ԯ��!�z��=W_<qB�F��-���>��ٯ=��
���قo�2�7	~����#��"���o|N�_+�g�㌌��t��e�WU��'%�$j�&��I�N�&jSc���&��������é�}���"�Ġpq�|��Kz�?\�+���^�����S��Wn��}z�?\��g/|������B~H5(\���F��>�t�2�{����������{�S��^��>r�~AA/������K.x(���
G�������KH�[�f	t>*�$����/!pQB�j �8�O��+�����W�����	�
��v_D��5�?����Ҡ�t����|�ӄ�7�+U��)d^$t���K_y���!���&U(�?��B����q���`{=*���(����?Oo�������O����5��S��w�D
GZ���t�#%���:~eiy����U��teYIQeQab�v�vp$�
J�������K�VU��E��K�3 �Wh)>�j��V��BTZR�O�+^��3s�ge.�|��t)�aYڟJ!ZjX�@����1�+ ������Y�,��tFn�>=wi��͜�t^�>7s�������|}~��u���K6:]��i�
�+��z�)��vO�t�����w��������o�~h@���r	�q?�������K��U�%����Z.�����UKWWz3s��**���G�o)�/A�N������� ��oQ
<%�Gx��!���Bz���
�Ky�'��J��<i�W;���_��k��_&LLK����8~�������
e��R ���O���!���B�dO�x�����l�?9���.ɯ�K�h�z~eqIq�Z�1��hU!OϽݹ���E�
��s��ŕ�
�U*-�[�Y�� ��ae)��ed�#�`�|��2`=�˛�4>�8W�xU%M�}K��X��X�}|�v�ůJ�i�k<C Xx�`����GVAV���tIѯ�J�q�K	���n����v?l���?I��?�Dlu	�%kq�1�@�0��S<A�����:�ד�)�_��*�x��5�ޥ����������=O��"#|x��h~���)�ў,g�⣊��EzO)�/u<��t��911��胕��W��)4�,/�Ch7��x�W%c�s�]���دj?I�C��Л���K���?B?1�΀�� �����������G�Yx�<"�>;�ɝ?7�_)�;��-�A?�57 �N�/)^Uğ��O�S�W�X���Z�d
��3E���U	��K��X]PPTQ�|uIbo
M��|��k���N\*�M�˅]�����>��c�i��V%_\|���P���Y�3�����OuG���xP���2��"7��W���n�^f?��Ӵ�N���7��Pe9��$n�O���.��9�(>�R #���=�c�ѿ?HA��g:�g
*@����O���~�x���T �L���2��kf�:K�y�`"�`��M�5`.����E����e���]�#`�T��7'�_��B�Jy���������Z%����e|�w��������f��v�;P�4�Ѳ
�ݫ�c�hܺ�����Q ���a���
9f �����0�#��)1
90L�~��ox�nɪ%�<��n~��������%=#`�8ЁP��������^�k�bcxyi	h#7_��rc��V���@I�G�a���C���
p�~���與�/..~��ac�_�W_�{$qh�W���m���@?�[�6?8;�|�:!��	/�A`�\�?�v:����8��}�%��~��𛆀77���w���@�g;�>�!$��!������=����[�|���!�^z�;!�wA���
�/���L��}��{t�(���녯�N���|����Ag���^p�|�� /�sC�y~��6x�	��k�w�=��? �­�B��p�޺: �����\!� �����|�0��o�<m�,bpy��|���>�^��o"�?{�{���z�����K��釓�ӏ&���|�$���,r�z�j�|��������w�|?���!�_@�@�m�
j�z%S��x�p�~��|��=�?B