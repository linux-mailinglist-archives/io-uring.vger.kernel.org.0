Return-Path: <io-uring+bounces-5201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D64C89E3E0E
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0951659F2
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 15:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00B020C00D;
	Wed,  4 Dec 2024 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ni1PLMfM"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6108320B81B;
	Wed,  4 Dec 2024 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733325654; cv=none; b=PGyS5pSQZ30IbhqN2jUmjHulbPaABnHGwEMtp1WZvjGUCknzu8m++xulgNAGRo1s4aktcVVuV2kaMaLne0UTWP0Q9E8R1s+Vz0Ky+lZklof3Grc2FcX0cdU3lSdOBlthSKyKwQSUBfNgsSF11JDMtaS9tgKaClPMSO0UuDWXFd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733325654; c=relaxed/simple;
	bh=WyRjM3dv0HfOFrfDDpXygkHRnEpGiIWkVJqm3wA3pXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WP1xifmo43o7r1a69TfJsipNaGSI+2LROX0dOCUGTuzHhKy+Z0+5FiEOOtgkBp6ax6TCXaGWdqxTH0x6M+BYE3sRUTedfV45HcpQt1bUhR1rERsMdQVR3EEzCOAhv2ALu89EU4Syx4iFemP7nGEIVemlVHeKs2GC783/Ebju/mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ni1PLMfM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733325652; x=1764861652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WyRjM3dv0HfOFrfDDpXygkHRnEpGiIWkVJqm3wA3pXE=;
  b=Ni1PLMfMIhvWYxOwDp4jN0JepGI+OKx/wOAjaO3qV0I15y8hB/1BxbSC
   R2A9GJ4KsA/QkQ+RvgTFYr5V/e5uXk7mruRWgdcy6wmSq3pcZgwvTInmR
   e2k9gX45OAFjAhPh5BxUsjHcmmnicTEAwzedFAXxm/oUGPOi//R0MD4/z
   1uEaQns2Rr9JSKt10cMlNizv/2f1aIk0EQTh44EgGRghIdPkI057l1Fq8
   PHFccOGM06dSJc9elSMzLEgncWACK7GEe6Rcgw7Ulxad2sxDHVgHK1xFE
   k2B69JLJZamGm+C+JDxZunr2TL6TxLKicpg9iJpbhQ/jyNNGI+bHIl7JQ
   A==;
X-CSE-ConnectionGUID: OV03fxL9Sy6iri83F8Z/Bg==
X-CSE-MsgGUID: 9RQ31si5SZOMXjIB0qwQ4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="51129354"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="51129354"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 07:20:52 -0800
X-CSE-ConnectionGUID: hBni0WmKRv2OsT7jczMqAg==
X-CSE-MsgGUID: vC0+38RLS1mXsFi1u5XvFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="97861589"
Received: from lkp-server02.sh.intel.com (HELO 1f5a171d57e2) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 04 Dec 2024 07:20:49 -0800
Received: from kbuild by 1f5a171d57e2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tIrBC-0003Cf-0n;
	Wed, 04 Dec 2024 15:20:43 +0000
Date: Wed, 4 Dec 2024 23:19:48 +0800
From: kernel test robot <lkp@intel.com>
To: Ferry Meng <mengferry@linux.alibaba.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: Re: [PATCH 2/3] virtio-blk: add uring_cmd support for I/O passthru
 on chardev.
Message-ID: <202412042324.uKQ5KdkE-lkp@intel.com>
References: <20241203121424.19887-3-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203121424.19887-3-mengferry@linux.alibaba.com>

Hi Ferry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.13-rc1 next-20241203]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ferry-Meng/virtio-blk-add-virtio-blk-chardev-support/20241203-202032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241203121424.19887-3-mengferry%40linux.alibaba.com
patch subject: [PATCH 2/3] virtio-blk: add uring_cmd support for I/O passthru on chardev.
config: i386-randconfig-063-20241204 (https://download.01.org/0day-ci/archive/20241204/202412042324.uKQ5KdkE-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241204/202412042324.uKQ5KdkE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412042324.uKQ5KdkE-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/block/virtio_blk.c:144:28: sparse: sparse: restricted __virtio32 degrades to integer
>> drivers/block/virtio_blk.c:1337:53: sparse: sparse: restricted blk_opf_t degrades to integer
>> drivers/block/virtio_blk.c:1337:59: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted blk_opf_t [usertype] opf @@     got unsigned int @@
   drivers/block/virtio_blk.c:1337:59: sparse:     expected restricted blk_opf_t [usertype] opf
   drivers/block/virtio_blk.c:1337:59: sparse:     got unsigned int
>> drivers/block/virtio_blk.c:1405:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __virtio64 [assigned] [usertype] sector @@     got restricted __virtio32 @@
   drivers/block/virtio_blk.c:1405:26: sparse:     expected restricted __virtio64 [assigned] [usertype] sector
   drivers/block/virtio_blk.c:1405:26: sparse:     got restricted __virtio32
>> drivers/block/virtio_blk.c:1410:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int rq_flags @@     got restricted blk_opf_t [usertype] @@
   drivers/block/virtio_blk.c:1410:26: sparse:     expected unsigned int rq_flags
   drivers/block/virtio_blk.c:1410:26: sparse:     got restricted blk_opf_t [usertype]
>> drivers/block/virtio_blk.c:1414:26: sparse: sparse: invalid assignment: |=
   drivers/block/virtio_blk.c:1414:26: sparse:    left side has type unsigned int
   drivers/block/virtio_blk.c:1414:26: sparse:    right side has type restricted blk_opf_t
   drivers/block/virtio_blk.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/slab.h):
   include/linux/page-flags.h:237:46: sparse: sparse: self-comparison always evaluates to false
   include/linux/page-flags.h:237:46: sparse: sparse: self-comparison always evaluates to false

vim +144 drivers/block/virtio_blk.c

   141	
   142	static bool virtblk_is_write(struct virtblk_command *cmd)
   143	{
 > 144		return cmd->out_hdr.type & VIRTIO_BLK_T_OUT;
   145	}
   146	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

