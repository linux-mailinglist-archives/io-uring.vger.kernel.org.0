Return-Path: <io-uring+bounces-153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D9C7F77A3
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 16:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 366C81C20FAC
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 15:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197452E84E;
	Fri, 24 Nov 2023 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQZp5LgA"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100241735;
	Fri, 24 Nov 2023 07:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700839435; x=1732375435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CS7YuWfYA9yy3IYn3cxyi1vQx5XwqiX4ba5CyfDQodI=;
  b=HQZp5LgAIj0DPl6dnTaSVUytciQ6LAwn+kSFq1o8qbIAOuw2VqRsh9Vw
   qOPtzvZyeGr6oIpOfpJaxhYJCzI2XbE3kY6flj1RJ8FucnJlIDuSa+5n5
   AytTeJKmzHgpi0zmcyZQJAIEARUBQt+IwAtOHDOLOKMUoLI7bDtSsy8ne
   d7V5UADvzfqjx/8+ArFfjo7K7ld5+hPrejs8roJeY+bIH5Us9lKTkV1D+
   Qf1w6cCYsafwhYB/uHLuHterLnlQ7q/opzhmMdRP+RamLMzzNSnijOrtJ
   WKQvJLipbWtTBgQEHPv1BmVs7oSI3zyAB7BRxMHT0Uf5YtAUllSvmJg+c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="456781772"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="456781772"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 07:23:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="1014935600"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="1014935600"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2023 07:23:52 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r6Y22-0002wf-0M;
	Fri, 24 Nov 2023 15:23:50 +0000
Date: Fri, 24 Nov 2023 23:23:20 +0800
From: kernel test robot <lkp@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
	linux-block@vger.kernel.org, ming.lei@redhat.com,
	joshi.k@samsung.com
Subject: Re: [PATCH 1/3] io_uring: split out cmd api into a separate header
Message-ID: <202311241614.Z6qymw0W-lkp@intel.com>
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
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231124/202311241614.Z6qymw0W-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231124/202311241614.Z6qymw0W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311241614.Z6qymw0W-lkp@intel.com/

All errors (new ones prefixed by >>):

>> security/selinux/hooks.c:6940:28: error: incomplete definition of type 'struct io_uring_cmd'
           struct file *file = ioucmd->file;
                               ~~~~~~^
   include/linux/fs.h:1913:8: note: forward declaration of 'struct io_uring_cmd'
   struct io_uring_cmd;
          ^
   1 error generated.


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

