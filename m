Return-Path: <io-uring+bounces-10445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A0523C41576
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 19:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 99DD24E417A
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 18:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F3E33B6E8;
	Fri,  7 Nov 2025 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IqTCA9zT"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E273433B6DE;
	Fri,  7 Nov 2025 18:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541535; cv=none; b=Sex+JA5L4xoMip9kh/57a/62iFLvCQoL8wkj5zSYDkXaMuYz/F8wiJr/GvoeW+A2IMNdUw3xA1noQdpj4/17VJn5+U1m5OlISQr25ngmTMcsSytbuv6qvs/NkwLEDiGPeHuVieVlbs46GSR4E5qHlJzSMAv7shaENWyXwQaoqaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541535; c=relaxed/simple;
	bh=xf4LmEs/vCzWiaf2kAF7AgpX2/Ou3FIf/waiEhnB5/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHyJNYmHWrBsEA4F64O+OZaLZpVkz8pDg4iAzYE5o5rRK86I8h8Z2/fAX6KyrfGLnDuPI0sZTSRebRsfSkCbYs0JHNdlQ90+zFjc6kE2DMYxD3mLY2EOSztu0/qmuQNvWkV9yNXZ6wgKUGuNAgCyduRn0XmwUdFNDRWmtBxA0Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IqTCA9zT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762541533; x=1794077533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xf4LmEs/vCzWiaf2kAF7AgpX2/Ou3FIf/waiEhnB5/s=;
  b=IqTCA9zT7EXpZda6QzumWMTbj/1RaB1p5kAhuhBo0cvCAzuq1Pr4gD1c
   ZBhz69MBEBKzFbdJpcgtrVidaCDUyy6Dm4aRAIfG0kHotHIwcGlEYfY4y
   l8N3eNS+Fg5XspPgMzBjzpwIujgL9D/YFaSwZA90+lbSHwIoFblx+2nmY
   WvR5jxi2B2+wqDpuI5QwmVmcvbHxvLXlS1CBqJoCQkUj8yukuo3GYgSDM
   UlhvykSswM3AXHgDQrlRuKqGzojO8V4l5Mc+wKc1xBpXDsmGaT83rQL4B
   ejb2UlLogT2fEHiF1nnS0RLX9Ml9TOJQtWrFWYwb9E98rhtLtD524ZdFM
   g==;
X-CSE-ConnectionGUID: zXxFlq6+S9ONDE1WxZYzhQ==
X-CSE-MsgGUID: ZRp8qJ2BQrOeywolZpG9Qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="82096504"
X-IronPort-AV: E=Sophos;i="6.19,287,1754982000"; 
   d="scan'208";a="82096504"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 10:52:12 -0800
X-CSE-ConnectionGUID: NX74ZQfORwatomIShBOKWA==
X-CSE-MsgGUID: 6hrU/4eyQliBX8lemlmwqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,287,1754982000"; 
   d="scan'208";a="192463422"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2025 10:52:10 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vHRZ9-0000G3-2T;
	Fri, 07 Nov 2025 18:52:07 +0000
Date: Sat, 8 Nov 2025 02:51:51 +0800
From: kernel test robot <lkp@intel.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 5/5] io_uring: bpf: add io_uring_bpf_req_memcpy() kfunc
Message-ID: <202511080255.v8F8GrXF-lkp@intel.com>
References: <20251104162123.1086035-6-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104162123.1086035-6-ming.lei@redhat.com>

Hi Ming,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20251104]
[cannot apply to bpf-next/net bpf-next/master bpf/master linus/master v6.18-rc4 v6.18-rc3 v6.18-rc2 v6.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-prepare-for-extending-io_uring-with-bpf/20251105-002757
base:   next-20251104
patch link:    https://lore.kernel.org/r/20251104162123.1086035-6-ming.lei%40redhat.com
patch subject: [PATCH 5/5] io_uring: bpf: add io_uring_bpf_req_memcpy() kfunc
config: openrisc-allyesconfig (https://download.01.org/0day-ci/archive/20251108/202511080255.v8F8GrXF-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251108/202511080255.v8F8GrXF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511080255.v8F8GrXF-lkp@intel.com/

All warnings (new ones prefixed by >>):

   io_uring/bpf.c: In function 'io_bpf_import_buffer':
>> io_uring/bpf.c:423:47: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     423 |                 return import_ubuf(direction, (void __user *)(addr + offset),
         |                                               ^
   In file included from include/linux/bpf_verifier.h:7,
                    from io_uring/bpf.c:9:
   io_uring/bpf.c: In function 'io_bpf_init':
   include/linux/bpf.h:2044:50: warning: statement with no effect [-Wunused-value]
    2044 | #define register_bpf_struct_ops(st_ops, type) ({ (void *)(st_ops); 0; })
         |                                                  ^~~~~~~~~~~~~~~~
   io_uring/bpf.c:551:15: note: in expansion of macro 'register_bpf_struct_ops'
     551 |         err = register_bpf_struct_ops(&bpf_uring_bpf_ops, uring_bpf_ops);
         |               ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from <command-line>:
   In function 'io_kiocb_cmd_sz_check',
       inlined from 'io_uring_bpf_prep' at io_uring/bpf.c:93:32:
   include/linux/compiler_types.h:603:45: error: call to '__compiletime_assert_598' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:584:25: note: in definition of macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:603:9: note: in expansion of macro '_compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:9: note: in expansion of macro 'BUILD_BUG_ON'
     655 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
         |         ^~~~~~~~~~~~
   In function 'io_kiocb_cmd_sz_check',
       inlined from 'io_uring_bpf_issue' at io_uring/bpf.c:131:32:
   include/linux/compiler_types.h:603:45: error: call to '__compiletime_assert_598' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:584:25: note: in definition of macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:603:9: note: in expansion of macro '_compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:9: note: in expansion of macro 'BUILD_BUG_ON'
     655 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
         |         ^~~~~~~~~~~~
   In function 'io_kiocb_cmd_sz_check',
       inlined from 'io_uring_bpf_fail' at io_uring/bpf.c:148:32:
   include/linux/compiler_types.h:603:45: error: call to '__compiletime_assert_598' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:584:25: note: in definition of macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:603:9: note: in expansion of macro '_compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:9: note: in expansion of macro 'BUILD_BUG_ON'
     655 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
         |         ^~~~~~~~~~~~
   In function 'io_kiocb_cmd_sz_check',
       inlined from 'io_uring_bpf_cleanup' at io_uring/bpf.c:159:32:
   include/linux/compiler_types.h:603:45: error: call to '__compiletime_assert_598' declared with attribute error: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:584:25: note: in definition of macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:603:9: note: in expansion of macro '_compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/io_uring_types.h:655:9: note: in expansion of macro 'BUILD_BUG_ON'
     655 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
         |         ^~~~~~~~~~~~


vim +423 io_uring/bpf.c

   401	
   402	/*
   403	 * Helper to import a buffer into an iov_iter for BPF memcpy operations.
   404	 * Handles both plain user buffers and fixed/registered buffers.
   405	 *
   406	 * @req: io_kiocb request
   407	 * @iter: output iterator
   408	 * @buf_type: buffer type (plain or fixed)
   409	 * @addr: buffer address
   410	 * @offset: offset into buffer
   411	 * @len: length from offset
   412	 * @direction: ITER_SOURCE for source buffer, ITER_DEST for destination
   413	 * @issue_flags: io_uring issue flags
   414	 *
   415	 * Returns 0 on success, negative error code on failure.
   416	 */
   417	static int io_bpf_import_buffer(struct io_kiocb *req, struct iov_iter *iter,
   418					u8 buf_type, u64 addr, unsigned int offset,
   419					u32 len, int direction, unsigned int issue_flags)
   420	{
   421		if (buf_type == IORING_BPF_BUF_TYPE_PLAIN) {
   422			/* Plain user buffer */
 > 423			return import_ubuf(direction, (void __user *)(addr + offset),
   424					   len - offset, iter);
   425		} else if (buf_type == IORING_BPF_BUF_TYPE_FIXED) {
   426			/* Fixed buffer */
   427			return io_import_reg_buf(req, iter, addr + offset,
   428						 len - offset, direction, issue_flags);
   429		}
   430	
   431		return -EINVAL;
   432	}
   433	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

