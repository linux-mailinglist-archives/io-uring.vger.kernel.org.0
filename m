Return-Path: <io-uring+bounces-2034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8888D6611
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 17:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE8321C230AF
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 15:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B362156242;
	Fri, 31 May 2024 15:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uw0qR+hO"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CDF155726;
	Fri, 31 May 2024 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170588; cv=none; b=I/7Y6PlCr+o/Ik9w/iGnN5tX7HeBjteS3KQV3jQpRdJy3YWaDd/I+h0a60qIeSPcq1+Zg6mejON30SP5evdqo4m2+mAmHJb048AyyJqD1Xv7K0kX3yAR2VYe7mYPLFFAk47WcK9Pln1y90wjw8LjjS1FQjit6PXXjimCdF02s80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170588; c=relaxed/simple;
	bh=i/GODoG/qqUw/5FjxkcYBVk33tge+/kdSkNcUIAovik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXyYEQoZvFfAywzT2K1NKL6PswUjdVzaSMHKE4MYKVB/BK9DwFBfH5lmYGh9I7PD7xBNEBVb0bAqMepk7kYO4J+7J0VpMV5/gV+BubAr3aWNTOwG/XakCPoTBnAe/iUGquuSO5F6Vq+rz4YO0Exqrr/Ra+DgYBqlY3JVU0bHrpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uw0qR+hO; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717170586; x=1748706586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i/GODoG/qqUw/5FjxkcYBVk33tge+/kdSkNcUIAovik=;
  b=Uw0qR+hOxnGwtIGCcKJGOjqRT8IKybOu72WHhCStwhB2kzGLhSsRe6LB
   VWOPq4UKH3swuYDi8l/1Qt96oqc63Fun4alTMh6E641CIqACeCPCUIyzl
   ezQGko8iTywt5VJKRf8kzfyfaSI1tM7TS5OigsqV0kdu8gF47lOAy3kNK
   8FXzz2ZmGPbVTX/r2jaRlwP+kWKwE9ZGgigtBCG9pdhFh8w4k5/NwyDbO
   MLQj6ntMwVLtpq6dij3DPaANFLostcKkttt3DNKw2U0dJNN4k71/LuHvy
   Ecc3dKKpAkniUSR+AhVJCa2yXMLCIOp2qzLFY7sOlCbWFJRuxuZ/I6qTs
   Q==;
X-CSE-ConnectionGUID: DWbGdItuSiybHPWstNN4ow==
X-CSE-MsgGUID: 2PPdMITyR2WenW0Ny4jtEA==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="17565729"
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="17565729"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 08:49:45 -0700
X-CSE-ConnectionGUID: 5YnRgS3ZT+OJq9zwDlLUuQ==
X-CSE-MsgGUID: As6LDmtJT9WXHsTGK61d1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="36143171"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 31 May 2024 08:49:41 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sD4Vb-000HIV-34;
	Fri, 31 May 2024 15:49:36 +0000
Date: Fri, 31 May 2024 23:49:28 +0800
From: kernel test robot <lkp@intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] fs: sys_ringbuffer() (WIP)
Message-ID: <202405312226.yKqHcQE4-lkp@intel.com>
References: <ytprj7mx37dna3n3kbiskgvris4nfvv63u3v7wogdrlzbikkmt@chgq5hw3ny3r>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ytprj7mx37dna3n3kbiskgvris4nfvv63u3v7wogdrlzbikkmt@chgq5hw3ny3r>

Hi Kent,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.10-rc1]
[cannot apply to tip/x86/asm next-20240531]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kent-Overstreet/fs-sys_ringbuffer-WIP/20240531-115626
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/ytprj7mx37dna3n3kbiskgvris4nfvv63u3v7wogdrlzbikkmt%40chgq5hw3ny3r
patch subject: [PATCH] fs: sys_ringbuffer() (WIP)
config: um-allnoconfig (https://download.01.org/0day-ci/archive/20240531/202405312226.yKqHcQE4-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240531/202405312226.yKqHcQE4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405312226.yKqHcQE4-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:5:
   In file included from include/linux/crypto.h:17:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
>> include/linux/mm_types.h:8:10: fatal error: 'linux/darray_types.h' file not found
       8 | #include <linux/darray_types.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~
   1 error generated.
   make[3]: *** [scripts/Makefile.build:117: arch/um/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1208: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:240: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:240: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +8 include/linux/mm_types.h

     6	
     7	#include <linux/auxvec.h>
   > 8	#include <linux/darray_types.h>
     9	#include <linux/kref.h>
    10	#include <linux/list.h>
    11	#include <linux/spinlock.h>
    12	#include <linux/rbtree.h>
    13	#include <linux/maple_tree.h>
    14	#include <linux/rwsem.h>
    15	#include <linux/completion.h>
    16	#include <linux/cpumask.h>
    17	#include <linux/uprobes.h>
    18	#include <linux/rcupdate.h>
    19	#include <linux/page-flags-layout.h>
    20	#include <linux/workqueue.h>
    21	#include <linux/seqlock.h>
    22	#include <linux/percpu_counter.h>
    23	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

