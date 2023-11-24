Return-Path: <io-uring+bounces-152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 536807F74DC
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 14:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D850FB20D82
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 13:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EABC28DB7;
	Fri, 24 Nov 2023 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B5oSzZ1z"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CA9171E;
	Fri, 24 Nov 2023 05:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700832130; x=1732368130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fOqFaFqOcfG5aRsz5ajHXmD+86uoD5h6antYEOc3rDU=;
  b=B5oSzZ1zDQ2+dQk4/Ds0QjGzI4cBb0/oAwauj3YIt23insxYZx0/lfX8
   rwZ/UaS4r589mczsDzhudQ8sN/zcDZh+nn//3G+6B8vEW3ptFHV3FlKPz
   VoPcojKHKSeHRz9cSkODEUg/2g/hxq3RU1Zh8lCAr595dHY6O79GkTbpb
   OADu91hlTyMgjrSNIxoPfPHNHc74sYWMTHUtsdFyhBZoWvWl4o5zUm51Z
   O2kgWJYLGXu88WbyKpFBSl2LCm/e5WFAKpGmLqjS4grxMgcizMPj4I2TM
   Qg2azFYwUpdIocc5kXNde/GAxjIYhru90Ia/8gnpGta35O+7Nh35OSwdi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="389575394"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="389575394"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 05:21:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="15632187"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 24 Nov 2023 05:21:35 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r6W7g-0002oI-0U;
	Fri, 24 Nov 2023 13:21:32 +0000
Date: Fri, 24 Nov 2023 21:20:08 +0800
From: kernel test robot <lkp@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com, linux-block@vger.kernel.org,
	ming.lei@redhat.com, joshi.k@samsung.com
Subject: Re: [PATCH 1/3] io_uring: split out cmd api into a separate header
Message-ID: <202311241554.6yqiHqSd-lkp@intel.com>
References: <547e56560b97cd66f00bfc5b53db24f2fa1a8852.1700668641.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547e56560b97cd66f00bfc5b53db24f2fa1a8852.1700668641.git.asml.silence@gmail.com>

Hi Pavel,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on linus/master v6.7-rc2 next-20231124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavel-Begunkov/io_uring-split-out-cmd-api-into-a-separate-header/20231123-001742
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/547e56560b97cd66f00bfc5b53db24f2fa1a8852.1700668641.git.asml.silence%40gmail.com
patch subject: [PATCH 1/3] io_uring: split out cmd api into a separate header
config: i386-defconfig (https://download.01.org/0day-ci/archive/20231124/202311241554.6yqiHqSd-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231124/202311241554.6yqiHqSd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311241554.6yqiHqSd-lkp@intel.com/

All errors (new ones prefixed by >>):

   security/selinux/hooks.c: In function 'selinux_uring_cmd':
>> security/selinux/hooks.c:6940:28: error: dereferencing pointer to incomplete type 'struct io_uring_cmd'
     struct file *file = ioucmd->file;
                               ^~


vim +6940 security/selinux/hooks.c

f4d653dcaa4e40 Paul Moore      2022-08-10  6929  
f4d653dcaa4e40 Paul Moore      2022-08-10  6930  /**
f4d653dcaa4e40 Paul Moore      2022-08-10  6931   * selinux_uring_cmd - check if IORING_OP_URING_CMD is allowed
f4d653dcaa4e40 Paul Moore      2022-08-10  6932   * @ioucmd: the io_uring command structure
f4d653dcaa4e40 Paul Moore      2022-08-10  6933   *
f4d653dcaa4e40 Paul Moore      2022-08-10  6934   * Check to see if the current domain is allowed to execute an
f4d653dcaa4e40 Paul Moore      2022-08-10  6935   * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
f4d653dcaa4e40 Paul Moore      2022-08-10  6936   *
f4d653dcaa4e40 Paul Moore      2022-08-10  6937   */
f4d653dcaa4e40 Paul Moore      2022-08-10  6938  static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
f4d653dcaa4e40 Paul Moore      2022-08-10  6939  {
f4d653dcaa4e40 Paul Moore      2022-08-10 @6940  	struct file *file = ioucmd->file;
f4d653dcaa4e40 Paul Moore      2022-08-10  6941  	struct inode *inode = file_inode(file);
f4d653dcaa4e40 Paul Moore      2022-08-10  6942  	struct inode_security_struct *isec = selinux_inode(inode);
f4d653dcaa4e40 Paul Moore      2022-08-10  6943  	struct common_audit_data ad;
f4d653dcaa4e40 Paul Moore      2022-08-10  6944  
f4d653dcaa4e40 Paul Moore      2022-08-10  6945  	ad.type = LSM_AUDIT_DATA_FILE;
f4d653dcaa4e40 Paul Moore      2022-08-10  6946  	ad.u.file = file;
f4d653dcaa4e40 Paul Moore      2022-08-10  6947  
e67b79850fcc4e Stephen Smalley 2023-03-09  6948  	return avc_has_perm(current_sid(), isec->sid,
f4d653dcaa4e40 Paul Moore      2022-08-10  6949  			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
f4d653dcaa4e40 Paul Moore      2022-08-10  6950  }
740b03414b20e7 Paul Moore      2021-02-23  6951  #endif /* CONFIG_IO_URING */
740b03414b20e7 Paul Moore      2021-02-23  6952  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

