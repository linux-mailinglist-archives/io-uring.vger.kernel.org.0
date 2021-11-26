Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3302245E991
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 09:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353539AbhKZItf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 03:49:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:62441 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345082AbhKZIrf (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 26 Nov 2021 03:47:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="235454625"
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="235454625"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 00:44:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="675487932"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 26 Nov 2021 00:44:21 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqWqC-0007qp-IZ; Fri, 26 Nov 2021 08:44:20 +0000
Date:   Fri, 26 Nov 2021 16:43:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, shr@fb.com
Subject: Re: [PATCH v3 2/3] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <202111261631.wvcMUeXO-lkp@intel.com>
References: <20211125232549.3333746-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125232549.3333746-3-shr@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on de5de0813b7dbbb71fb5d677ed823505a0e685c5]

url:    https://github.com/0day-ci/linux/commits/Stefan-Roesch/io_uring-add-getdents64-support/20211126-072952
base:   de5de0813b7dbbb71fb5d677ed823505a0e685c5
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20211126/202111261631.wvcMUeXO-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/018019be0b26997402fe7ba8367e5260ec2aa8c8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Stefan-Roesch/io_uring-add-getdents64-support/20211126-072952
        git checkout 018019be0b26997402fe7ba8367e5260ec2aa8c8
        # save the config file to linux build tree
        make W=1 ARCH=um SUBARCH=i386

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/readdir.c:379:5: warning: no previous prototype for 'vfs_getdents' [-Wmissing-prototypes]
     379 | int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
         |     ^~~~~~~~~~~~


vim +/vfs_getdents +379 fs/readdir.c

   370	
   371	/**
   372	 * vfs_getdents - getdents without fdget
   373	 * @file    : pointer to file struct of directory
   374	 * @dirent  : pointer to user directory structure
   375	 * @count   : size of buffer
   376	 * @ctx_pos : if file pos is used, pass -1,
   377	 *            if ctx pos is used, pass ctx pos
   378	 */
 > 379	int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
   380			 unsigned int count, s64 ctx_pos)
   381	{
   382		struct getdents_callback64 buf = {
   383			.ctx.actor = filldir64,
   384			.ctx.pos = ctx_pos,
   385			.count = count,
   386			.current_dir = dirent
   387		};
   388		int error;
   389	
   390		error = do_iterate_dir(file, &buf.ctx, ctx_pos < 0);
   391		if (error >= 0)
   392			error = buf.error;
   393		if (buf.prev_reclen) {
   394			struct linux_dirent64 __user * lastdirent;
   395			typeof(lastdirent->d_off) d_off = buf.ctx.pos;
   396	
   397			lastdirent = (void __user *) buf.current_dir - buf.prev_reclen;
   398			if (put_user(d_off, &lastdirent->d_off))
   399				error = -EFAULT;
   400			else
   401				error = count - buf.count;
   402		}
   403	
   404		return error;
   405	}
   406	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
