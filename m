Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928D814972D
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 19:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgAYS3c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 13:29:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:36261 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgAYS3c (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 25 Jan 2020 13:29:32 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 10:29:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,362,1574150400"; 
   d="gz'50?scan'50,208,50";a="230774107"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 10:29:24 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivQBP-000DNx-RK; Sun, 26 Jan 2020 02:29:23 +0800
Date:   Sun, 26 Jan 2020 02:28:31 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     kbuild-all@lists.01.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
Message-ID: <202001260201.cxFbFe4r%lkp@intel.com>
References: <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ofyi2way4sdfjwya"
Content-Disposition: inline
In-Reply-To: <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--ofyi2way4sdfjwya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pavel,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20200121]
[cannot apply to linus/master v5.5-rc7 v5.5-rc6 v5.5-rc5 v5.5-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Pavel-Begunkov/splice-2-support-for-io_uring/20200124-114107
base:    bc80e6ad8ee12b0ee6c7d05faf1ebd3f2fb8f1e5
config: x86_64-randconfig-a002-20200125 (attached as .config)
compiler: gcc-7 (Debian 7.5.0-3) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/export.h:43:0,
                    from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from fs/io_uring.c:42:
   fs/io_uring.c: In function 'io_splice_punt':
   fs/io_uring.c:2364:6: error: too few arguments to function 'get_pipe_info'
     if (get_pipe_info(file))
         ^
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                       ^~~~
>> fs/io_uring.c:2364:2: note: in expansion of macro 'if'
     if (get_pipe_info(file))
     ^~
   In file included from include/linux/splice.h:12:0,
                    from include/linux/skbuff.h:36,
                    from include/linux/if_ether.h:19,
                    from include/uapi/linux/ethtool.h:19,
                    from include/linux/ethtool.h:18,
                    from include/linux/netdevice.h:37,
                    from include/net/sock.h:46,
                    from fs/io_uring.c:64:
   include/linux/pipe_fs_i.h:266:25: note: declared here
    struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice);
                            ^~~~~~~~~~~~~
   In file included from include/linux/export.h:43:0,
                    from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from fs/io_uring.c:42:
   fs/io_uring.c:2364:6: error: too few arguments to function 'get_pipe_info'
     if (get_pipe_info(file))
         ^
   include/linux/compiler.h:58:61: note: in definition of macro '__trace_if_var'
    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                                ^~~~
>> fs/io_uring.c:2364:2: note: in expansion of macro 'if'
     if (get_pipe_info(file))
     ^~
   In file included from include/linux/splice.h:12:0,
                    from include/linux/skbuff.h:36,
                    from include/linux/if_ether.h:19,
                    from include/uapi/linux/ethtool.h:19,
                    from include/linux/ethtool.h:18,
                    from include/linux/netdevice.h:37,
                    from include/net/sock.h:46,
                    from fs/io_uring.c:64:
   include/linux/pipe_fs_i.h:266:25: note: declared here
    struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice);
                            ^~~~~~~~~~~~~
   In file included from include/linux/export.h:43:0,
                    from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from fs/io_uring.c:42:
   fs/io_uring.c:2364:6: error: too few arguments to function 'get_pipe_info'
     if (get_pipe_info(file))
         ^
   include/linux/compiler.h:69:3: note: in definition of macro '__trace_if_value'
     (cond) ?     \
      ^~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                               ^~~~~~~~~~~~~~
>> fs/io_uring.c:2364:2: note: in expansion of macro 'if'
     if (get_pipe_info(file))
     ^~
   In file included from include/linux/splice.h:12:0,
                    from include/linux/skbuff.h:36,
                    from include/linux/if_ether.h:19,
                    from include/uapi/linux/ethtool.h:19,
                    from include/linux/ethtool.h:18,
                    from include/linux/netdevice.h:37,
                    from include/net/sock.h:46,
                    from fs/io_uring.c:64:
   include/linux/pipe_fs_i.h:266:25: note: declared here
    struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice);
                            ^~~~~~~~~~~~~

vim +/if +2364 fs/io_uring.c

  2361	
  2362	static bool io_splice_punt(struct file *file)
  2363	{
> 2364		if (get_pipe_info(file))
  2365			return false;
  2366		if (!io_file_supports_async(file))
  2367			return true;
  2368		return !(file->f_mode & O_NONBLOCK);
  2369	}
  2370	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--ofyi2way4sdfjwya
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
uc8aAPI3gR0mgWflXiwFabnx/2V5W7qt9QEA

--ofyi2way4sdfjwya--
