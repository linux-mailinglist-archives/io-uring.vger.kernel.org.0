Return-Path: <io-uring+bounces-7031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8593EA57A85
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 14:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBDE31895528
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 13:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7371C6FF1;
	Sat,  8 Mar 2025 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q2EkWaQS"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C721BC41;
	Sat,  8 Mar 2025 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741440983; cv=none; b=n113Bu5rRaZET5WwhDXR8ADRe2S1Xexu2RDxKNcjCm7ftcSTH8hPm68/zR/JmTruExcAThcov2RZ/9ax5CeRAIXy2DxClYsUW41B+etgVWLwCTPNqdoaFfY4379Ux8qkiBsU/i7lWB+sXIvMuhTG629EsNncqjBIIL9xW82xB5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741440983; c=relaxed/simple;
	bh=WM7b4EhgJ9Elb2J//99kUcCyNjVVSd3WMLVSJauZ8qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULtZ9xENQxrtPySjD3VVXFhJjdQPjtqIleX5AyRycOp20yptg7aLFV6oRWBQSMEeJUYojmx8JxuNF9WzTUG3YZ0EQgabM1VuXVs2XGQEp8SrtB719BBHEzV5bjgsRmTpIwR+6qfxGUpf5b0gPrWldOZRmTlpOa8TP+Iw9I2DZ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q2EkWaQS; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741440982; x=1772976982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WM7b4EhgJ9Elb2J//99kUcCyNjVVSd3WMLVSJauZ8qU=;
  b=Q2EkWaQSXARj9jWOOPqBRCIKy1DI17fjF0OfbMZ5Kqvu686Knjeayw9y
   nNyWWJnt36aGFCQuAkuWgCSLDH5+N+igWmW7VI3mq/EaRV3s6WRGwkxiT
   YY83eYc8/HAcQH4yIlAqU62XkLpIJUoh/4/wyD4mMv4BfaqUswioeTBtH
   wO7/bB4bvFfSxvmvYz46p7h7UYso9jrnJ5J8CDP6fQbaVX6XKj9QXaUrx
   0l/0/OIApIUXwXr/eDpamOGW7ogtpO4JqdHZvGBgYheZBUQcO09ajpOG4
   BYg6F2p7Bf4llzd+u/8XYLvjEttM6oq1Bwe1k+NKjSX/A3VrMQU/e6A0a
   A==;
X-CSE-ConnectionGUID: AdeM49ZkQAa//gDyMBBM3A==
X-CSE-MsgGUID: 6aGyUOVgSkOfxL0u7gPeqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11367"; a="64921391"
X-IronPort-AV: E=Sophos;i="6.14,232,1736841600"; 
   d="scan'208";a="64921391"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2025 05:36:21 -0800
X-CSE-ConnectionGUID: 306oRoH8RmmrYWtwACr4Dw==
X-CSE-MsgGUID: syZEQ7H3R2Gs+oRwBssLrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="156778569"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 08 Mar 2025 05:36:18 -0800
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tquLf-0001vk-2f;
	Sat, 08 Mar 2025 13:36:15 +0000
Date: Sat, 8 Mar 2025 21:35:54 +0800
From: kernel test robot <lkp@intel.com>
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	audit@vger.kernel.org, axboe@kernel.dk,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
Message-ID: <202503082153.UnKZ6sGP-lkp@intel.com>
References: <20250307161155.760949-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307161155.760949-1-mjguzik@gmail.com>

Hi Mateusz,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.14-rc5 next-20250307]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mateusz-Guzik/fs-support-filename-refcount-without-atomics/20250308-002442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20250307161155.760949-1-mjguzik%40gmail.com
patch subject: [PATCH] fs: support filename refcount without atomics
config: i386-buildonly-randconfig-003-20250308 (https://download.01.org/0day-ci/archive/20250308/202503082153.UnKZ6sGP-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250308/202503082153.UnKZ6sGP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503082153.UnKZ6sGP-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
>> include/linux/fs.h:2875:19: error: no member named 'owner' in 'struct filename'
    2875 |         VFS_BUG_ON(name->owner != current && !name->is_atomic);
         |                    ~~~~  ^
   include/linux/vfsdebug.h:35:47: note: expanded from macro 'VFS_BUG_ON'
      35 | #define VFS_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
         |                                               ^~~~
   include/linux/build_bug.h:30:63: note: expanded from macro 'BUILD_BUG_ON_INVALID'
      30 | #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
         |                                                               ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   include/linux/fs.h:2884:19: error: no member named 'owner' in 'struct filename'
    2884 |         VFS_BUG_ON(name->owner != current && !name->is_atomic);
         |                    ~~~~  ^
   include/linux/vfsdebug.h:35:47: note: expanded from macro 'VFS_BUG_ON'
      35 | #define VFS_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
         |                                               ^~~~
   include/linux/build_bug.h:30:63: note: expanded from macro 'BUILD_BUG_ON_INVALID'
      30 | #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
         |                                                               ^
   2 errors generated.
   make[3]: *** [scripts/Makefile.build:102: arch/x86/kernel/asm-offsets.s] Error 1 shuffle=2759713076
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1264: prepare0] Error 2 shuffle=2759713076
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:251: __sub-make] Error 2 shuffle=2759713076
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:251: __sub-make] Error 2 shuffle=2759713076
   make: Target 'prepare' not remade because of errors.


vim +2875 include/linux/fs.h

  2866	
  2867	static inline void makeatomicname(struct filename *name)
  2868	{
  2869		VFS_BUG_ON(IS_ERR_OR_NULL(name));
  2870		/*
  2871		 * The name can legitimately already be atomic if it was cached by audit.
  2872		 * If switching the refcount to atomic, we need not to know we are the
  2873		 * only non-atomic user.
  2874		 */
> 2875		VFS_BUG_ON(name->owner != current && !name->is_atomic);
  2876		/*
  2877		 * Don't bother branching, this is a store to an already dirtied cacheline.
  2878		 */
  2879		name->is_atomic = true;
  2880	}
  2881	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

