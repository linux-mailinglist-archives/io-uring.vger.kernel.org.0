Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E988445CD95
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 20:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhKXUCN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 15:02:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:28074 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234835AbhKXUCN (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 24 Nov 2021 15:02:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="234090618"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="234090618"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 11:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="607317869"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 24 Nov 2021 11:59:00 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mpyPz-0005GS-TA; Wed, 24 Nov 2021 19:58:59 +0000
Date:   Thu, 25 Nov 2021 03:58:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, shr@fb.com
Subject: Re: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Message-ID: <202111250356.yBAHK4KL-lkp@intel.com>
References: <20211123181010.1607630-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123181010.1607630-2-shr@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.16-rc2 next-20211124]
[cannot apply to mszeredi-vfs/overlayfs-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Stefan-Roesch/io_uring-add-getdents64-support/20211124-022809
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 136057256686de39cc3a07c2e39ef6bc43003ff6
config: x86_64-randconfig-r006-20211124 (https://download.01.org/0day-ci/archive/20211125/202111250356.yBAHK4KL-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 67a1c45def8a75061203461ab0060c75c864df1c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/94fab53b56d471270b8b7b9afe6d73a8098448be
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Stefan-Roesch/io_uring-add-getdents64-support/20211124-022809
        git checkout 94fab53b56d471270b8b7b9afe6d73a8098448be
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> fs/ksmbd/vfs.c:1139:47: error: too few arguments to function call, expected 3, have 2
           err = iterate_dir(fp->filp, &readdir_data.ctx);
                 ~~~~~~~~~~~                            ^
   include/linux/fs.h:3346:12: note: 'iterate_dir' declared here
   extern int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos);
              ^
   fs/ksmbd/vfs.c:1189:44: error: too few arguments to function call, expected 3, have 2
           ret = iterate_dir(dfilp, &readdir_data.ctx);
                 ~~~~~~~~~~~                         ^
   include/linux/fs.h:3346:12: note: 'iterate_dir' declared here
   extern int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos);
              ^
   2 errors generated.
--
>> fs/ksmbd/smb2pdu.c:3926:58: error: too few arguments to function call, expected 3, have 2
           rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
                ~~~~~~~~~~~                                        ^
   include/linux/fs.h:3346:12: note: 'iterate_dir' declared here
   extern int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos);
              ^
   1 error generated.


vim +1139 fs/ksmbd/vfs.c

f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1122  
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1123  /**
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1124   * ksmbd_vfs_empty_dir() - check for empty directory
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1125   * @fp:	ksmbd file pointer
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1126   *
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1127   * Return:	true if directory empty, otherwise false
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1128   */
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1129  int ksmbd_vfs_empty_dir(struct ksmbd_file *fp)
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1130  {
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1131  	int err;
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1132  	struct ksmbd_readdir_data readdir_data;
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1133  
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1134  	memset(&readdir_data, 0, sizeof(struct ksmbd_readdir_data));
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1135  
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1136  	set_ctx_actor(&readdir_data.ctx, __dir_empty);
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1137  	readdir_data.dirent_count = 0;
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1138  
e8c061917133dd fs/cifsd/vfs.c Namjae Jeon 2021-06-22 @1139  	err = iterate_dir(fp->filp, &readdir_data.ctx);
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1140  	if (readdir_data.dirent_count > 2)
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1141  		err = -ENOTEMPTY;
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1142  	else
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1143  		err = 0;
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1144  	return err;
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1145  }
f44158485826c0 fs/cifsd/vfs.c Namjae Jeon 2021-03-16  1146  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
