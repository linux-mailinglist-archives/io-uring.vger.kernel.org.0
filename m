Return-Path: <io-uring+bounces-4765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 978E69D0167
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 00:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3F0AB24B13
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 23:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B9C194A63;
	Sat, 16 Nov 2024 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V+74xtRE"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A867729A2;
	Sat, 16 Nov 2024 23:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731798624; cv=none; b=oUQHQ9AzcAxB5wXKbnAXtYEQLE719eDKx6Dp70IYDUm4MXsbf9X44oEY8JdNtwpXe3YVll0yuu30fYptitlJYDAV9i0ik3qoF5jHzmLjpz47oL7jKRsBzVdofjV6lXcRig0GbXF0WFyyAxWHfuHf4LljJnHsiJ5WOXCP5oplVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731798624; c=relaxed/simple;
	bh=J8TdKlbufzk8/hb67F60g16aY7BksH2lDSQzP/7KGb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUMHTiIgU05teSNCP9k54DG685nfPt88NPaQMsntJvcq6h2Ft9e0//mAfZoAy2QWuJSIQ/12WsGUnEmYuOdqVLvjxtLUYjITWO/ZHYPJVGcSQNECjdoJ/B69Byg9RZ1ZmbzIzIr2aVyDb+dFqsZfQlJi2JQu9qVtkl0Gq3kHfMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V+74xtRE; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731798623; x=1763334623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J8TdKlbufzk8/hb67F60g16aY7BksH2lDSQzP/7KGb0=;
  b=V+74xtREoIPt+e7tjT3W3JZ9TmdD0LoOSZiJ6fQyG1Use5m5Wl9iXe5P
   SxH75+4Botx/OlS27k49LGMVtq9BTqHFJvpVDwDQXFipzgrY7CNDBKvkj
   mEHwneJXI8Z8PdTMkPJYWERaARV3HKMVksEQDSbWwVWFOHEKZorSMkjV5
   UjojxUoE707MdDfDlTRD5d7lb/CjYypekU8OusDh2aLvO1gqMEGwbxQdN
   SSmmOKk+UwuBDU6XGbuxj8zEuon2u6J4V2MoMosa2iVMXpPXbfdb++DVB
   X12c8Qe7iMaLpmhVlzUHc67SNkZBwtYxIzuSJTh2HoZqS7704G5PJ3rYo
   g==;
X-CSE-ConnectionGUID: y1qfZXGCQjyjfb3+U2IUoQ==
X-CSE-MsgGUID: Kx4mXAujRWiYYQByjrFX1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11258"; a="19388885"
X-IronPort-AV: E=Sophos;i="6.12,160,1728975600"; 
   d="scan'208";a="19388885"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2024 15:10:22 -0800
X-CSE-ConnectionGUID: 18+FoBMjQe2kvuLxiyxaXA==
X-CSE-MsgGUID: x4jbkL5oTsSTSFJ0eVCDHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,160,1728975600"; 
   d="scan'208";a="89284449"
Received: from lkp-server01.sh.intel.com (HELO 1e3cc1889ffb) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 16 Nov 2024 15:10:17 -0800
Received: from kbuild by 1e3cc1889ffb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tCRvi-00019x-2o;
	Sat, 16 Nov 2024 23:10:14 +0000
Date: Sun, 17 Nov 2024 07:09:45 +0800
From: kernel test robot <lkp@intel.com>
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
	kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <202411170724.GLZyWdlD-lkp@intel.com>
References: <20241114104517.51726-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114104517.51726-7-anuj20.g@samsung.com>

Hi Anuj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20241115]
[cannot apply to brauner-vfs/vfs.all mkp-scsi/for-next hch-configfs/for-next linus/master jejb-scsi/for-next v6.12-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anuj-Gupta/block-define-set-of-integrity-flags-to-be-inherited-by-cloned-bip/20241114-193419
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241114104517.51726-7-anuj20.g%40samsung.com
patch subject: [PATCH v9 06/11] io_uring: introduce attributes for read/write and PI support
config: arc-nsimosci_hs_smp_defconfig (https://download.01.org/0day-ci/archive/20241117/202411170724.GLZyWdlD-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241117/202411170724.GLZyWdlD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411170724.GLZyWdlD-lkp@intel.com/

All warnings (new ones prefixed by >>):

   io_uring/rw.c: In function 'io_prep_pi_indirect':
>> io_uring/rw.c:305:38: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     305 |         if (copy_from_user(&pi_attr, (void __user *)pi_attr_addr, sizeof(pi_attr)))
         |                                      ^
   io_uring/rw.c: In function 'io_prep_attr_vec':
   io_uring/rw.c:321:38: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     321 |         if (copy_from_user(attr_vec, (void __user *)attr_addr, attr_vec_size))
         |                                      ^


vim +305 io_uring/rw.c

   298	
   299	
   300	static inline int io_prep_pi_indirect(struct io_kiocb *req, struct io_rw *rw,
   301					      int ddir, u64 pi_attr_addr)
   302	{
   303		struct io_uring_attr_pi pi_attr;
   304	
 > 305		if (copy_from_user(&pi_attr, (void __user *)pi_attr_addr, sizeof(pi_attr)))
   306			return -EFAULT;
   307		return io_prep_rw_pi(req, rw, ddir, &pi_attr);
   308	}
   309	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

