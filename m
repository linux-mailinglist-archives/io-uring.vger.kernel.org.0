Return-Path: <io-uring+bounces-2032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B65B8D628A
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 15:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D3531C25155
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 13:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF2815921B;
	Fri, 31 May 2024 13:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4DKkVwb"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FA4158DC3;
	Fri, 31 May 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717161138; cv=none; b=Vu1o8cTfD+LU+NVAaqZCAn3LSw1Gu+FNk1tdUQHB6kpRbp4E9CCPeav5PRMgc/xMpzKWmT4qcWwQIU9mVXK0U2y1mqPwjlTvWxTTkRlonWd7bIV67lIJYlPJQE+WYPWeN/xkofH7fYuKgmyRufHN/dfRU1oBkquqwvsQnepR9bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717161138; c=relaxed/simple;
	bh=25Z6DAQycunMds44dtwFH80eMUBSwTTavxBmP3PpFeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pV0sov+zuW5WhcLYn3ouBWvQYHgww7LiXVAWkNaPtB5uFsdg98Uw4QIlh76oP9QVhHylqkSHvMgyJiyGGBNE/V1nzDBiwFs7SWV8/SQsv6cH/Vtuy/dEdwTTSs1AEOXH0JNTUljh3XyBzNeoye2399mJJNTf1bYimXWRXkHmx+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4DKkVwb; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717161136; x=1748697136;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=25Z6DAQycunMds44dtwFH80eMUBSwTTavxBmP3PpFeQ=;
  b=e4DKkVwbEcGz1F/4cj+qUHRC2l+HBJncZuVlcb1k7bCKNV8vuvMJr8gi
   RR1SH64qkPjt9bGiRxhiNSOBZ1KtkyWUwQWMQIqJ23rFkv+9cCZCfMJU5
   nFXlYp2/GvoGGZ68SNUat41mjqSYsGNbX52yUCvQDjRIaPOyBj3jg4T/I
   gvRShphA7Nrc+/V62aoRachM8cvt8X0pDaxiMVSt+RoivSmI0JiRHZILU
   cSeEMhI/Out8G7vuCS4CFEwhVwAGOar9Fs6W+A2A5tDhqJBY1nZ5NtVla
   /xW/isO5NlYb8B6Ot/hj7gP09TpVZZxUEKOaAeNXCz14yvB+FANwAljXh
   w==;
X-CSE-ConnectionGUID: WXmEGQFaS3qSX59WpJJbJg==
X-CSE-MsgGUID: 00NsbryXT72KY09ZdrVaVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13462654"
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="13462654"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 06:12:15 -0700
X-CSE-ConnectionGUID: jo99xN1lTV+hw4hFYdn9bg==
X-CSE-MsgGUID: 5/w1+c2oRuW19KyNsIJ5RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="41081267"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 31 May 2024 06:12:11 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sD235-000H7l-2o;
	Fri, 31 May 2024 13:12:03 +0000
Date: Fri, 31 May 2024 21:11:48 +0800
From: kernel test robot <lkp@intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: oe-kbuild-all@lists.linux.dev, Miklos Szeredi <miklos@szeredi.hu>,
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
Message-ID: <202405312050.MkVo7MG8-lkp@intel.com>
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
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20240531/202405312050.MkVo7MG8-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240531/202405312050.MkVo7MG8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405312050.MkVo7MG8-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/sched/signal.h:14,
                    from include/linux/ptrace.h:7,
                    from arch/openrisc/kernel/asm-offsets.c:28:
>> include/linux/mm_types.h:8:10: fatal error: linux/darray_types.h: No such file or directory
       8 | #include <linux/darray_types.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~
   compilation terminated.
   make[3]: *** [scripts/Makefile.build:117: arch/openrisc/kernel/asm-offsets.s] Error 1
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

