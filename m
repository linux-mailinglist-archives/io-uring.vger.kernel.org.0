Return-Path: <io-uring+bounces-10446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8CAC41610
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 20:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86CD9188C324
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 19:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A31241CB6;
	Fri,  7 Nov 2025 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fq4Ps+y3"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DB9134AB;
	Fri,  7 Nov 2025 19:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542195; cv=none; b=FuNsL3U7x5jk8mvyCxX323Q1SKEYS+btDdUtPx4f/ohEYoIMFJ4j5DuWIv2SOLQsx/RDvbMC84fTtk+6WSSJwzd93puI2G6aF5ZvQuvgcSsUb0qUSBpA6aJjYJtdHosA4ITGy82cyVn1oKa5C8zN1ORqH424G4U9/wddx7UMYS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542195; c=relaxed/simple;
	bh=bPqk3Q+eO6IY6LZKH9QHzMEyAi7mgDk5om75cwBmsCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JloA/qAL/VfBv6kWj4YT44NWiYoa5kyu5UVpJo5+le0sz1pC/RmvUOYBk0aHyQoAtcAwOYMZSVO0WiRfuWKrXvZ2PykkXLaeCvp55UnQ3d6J9QnU1Qh0sTSr9BmXnGvQ8EGe/NMQ02HWJEBkttU3cWcDHkb+mdbVpo58hYmf3Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fq4Ps+y3; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762542194; x=1794078194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bPqk3Q+eO6IY6LZKH9QHzMEyAi7mgDk5om75cwBmsCY=;
  b=fq4Ps+y3Q1Yii4v+DdXkkZG63Gte+lXEvNg3SDEIKTWmB01ATEwpQ72p
   U0i6VbG9gGTuFcYy9xs/kHwa3uQQPFgmWZJH5jRHiLbjyYx+SChFX/lS7
   S0/H1QgYwMnhNsUWuOugYxQg/GIqYbSjUIIGS9G01wzc1OgZZLj/39Ttp
   mIvTDaY3ZIYNT1lcP3gnH6c/8jMPM0Wh1RQ+cXr1it2DWhmsmidGfa2LQ
   0e2g4NtdV9AEvmL+auqLe6yID7pEjNzhy0RbrJY/fZEPXnDme0ZS8VejM
   CEpInFLFZkcef7Km6dcPqr2z1BRpv0txWvwN5aM+Snt/CRhPLRumtiyyu
   A==;
X-CSE-ConnectionGUID: Irw7PjP9QKK0Zze9NLDk5Q==
X-CSE-MsgGUID: gSUy2LGOQvWWtjWRpyQyeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="75809582"
X-IronPort-AV: E=Sophos;i="6.19,287,1754982000"; 
   d="scan'208";a="75809582"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 11:03:13 -0800
X-CSE-ConnectionGUID: W8YChswmTui/RPJdj8+/gA==
X-CSE-MsgGUID: ARfXSstZQeanC60Om1BsTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,287,1754982000"; 
   d="scan'208";a="187833773"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 07 Nov 2025 11:03:11 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vHRjo-0000Gd-2E;
	Fri, 07 Nov 2025 19:03:08 +0000
Date: Sat, 8 Nov 2025 03:02:35 +0800
From: kernel test robot <lkp@intel.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
Message-ID: <202511080257.ZRnK6f2W-lkp@intel.com>
References: <20251104162123.1086035-4-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104162123.1086035-4-ming.lei@redhat.com>

Hi Ming,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251104]
[cannot apply to bpf-next/net bpf-next/master bpf/master linus/master v6.18-rc4 v6.18-rc3 v6.18-rc2 v6.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-prepare-for-extending-io_uring-with-bpf/20251105-002757
base:   next-20251104
patch link:    https://lore.kernel.org/r/20251104162123.1086035-4-ming.lei%40redhat.com
patch subject: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
config: parisc-randconfig-r121-20251107 (https://download.01.org/0day-ci/archive/20251108/202511080257.ZRnK6f2W-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251108/202511080257.ZRnK6f2W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511080257.ZRnK6f2W-lkp@intel.com/

All errors (new ones prefixed by >>):

   io_uring/bpf.c: In function 'uring_bpf_ops_is_valid_access':
>> io_uring/bpf.c:117:9: error: implicit declaration of function 'bpf_tracing_btf_ctx_access'; did you mean 'bpf_sock_convert_ctx_access'? [-Werror=implicit-function-declaration]
     return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
            ^~~~~~~~~~~~~~~~~~~~~~~~~~
            bpf_sock_convert_ctx_access
   In file included from include/linux/bpf_verifier.h:7,
                    from io_uring/bpf.c:9:
   io_uring/bpf.c: In function 'io_bpf_init':
   include/linux/bpf.h:2044:50: warning: statement with no effect [-Wunused-value]
    #define register_bpf_struct_ops(st_ops, type) ({ (void *)(st_ops); 0; })
                                                     ^~~~~~~~~~~~~~~~
   io_uring/bpf.c:303:8: note: in expansion of macro 'register_bpf_struct_ops'
     err = register_bpf_struct_ops(&bpf_uring_bpf_ops, uring_bpf_ops);
           ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from <command-line>:
   In function 'io_kiocb_cmd_sz_check',
       inlined from 'io_uring_bpf_prep' at io_uring/bpf.c:41:32:
   include/linux/compiler_types.h:603:38: error: call to '__compiletime_assert_513' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:584:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:603:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
     ^~~~~~~~~~~~
   In function 'io_kiocb_cmd_sz_check',
       inlined from '__io_uring_bpf_issue.isra.4' at io_uring/bpf.c:58:32,
       inlined from 'io_uring_bpf_issue' at io_uring/bpf.c:72:9:
   include/linux/compiler_types.h:603:38: error: call to '__compiletime_assert_513' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:584:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:603:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
     ^~~~~~~~~~~~
   In function 'io_kiocb_cmd_sz_check',
       inlined from '__io_uring_bpf_issue.isra.4' at io_uring/bpf.c:58:32,
       inlined from 'io_uring_bpf_issue' at io_uring/bpf.c:77:9:
   include/linux/compiler_types.h:603:38: error: call to '__compiletime_assert_513' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:584:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:603:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
     ^~~~~~~~~~~~
   In function 'io_kiocb_cmd_sz_check',
       inlined from 'io_uring_bpf_fail' at io_uring/bpf.c:82:32:
   include/linux/compiler_types.h:603:38: error: call to '__compiletime_assert_513' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:584:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:603:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
     ^~~~~~~~~~~~
   include/linux/io_uring_types.h: In function 'io_uring_bpf_cleanup':
   include/linux/compiler_types.h:603:38: error: call to '__compiletime_assert_513' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:584:4: note: in definition of macro '__compiletime_assert'


vim +117 io_uring/bpf.c

   111	
   112	static bool uring_bpf_ops_is_valid_access(int off, int size,
   113					       enum bpf_access_type type,
   114					       const struct bpf_prog *prog,
   115					       struct bpf_insn_access_aux *info)
   116	{
 > 117		return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
   118	}
   119	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

