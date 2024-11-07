Return-Path: <io-uring+bounces-4558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C779C0EEA
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 20:31:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CABEB22356
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 19:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6403217912;
	Thu,  7 Nov 2024 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Li9WGaIa"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61B9802;
	Thu,  7 Nov 2024 19:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731007896; cv=none; b=h0UvWUyBAiIQxU6yW9vv8eugldI+Hb4jPMq+JsO7wYxNlxpEf6tRYnVILTJf2ePeVTRpbr7bP8a0hUOmlka9nZNOW6StWe1pSjSCVwiliEOFoegGCpZMqOpDouKEnCoCUFZsA4kOzkXPBcRnKKzqzJaEyWBgdsq+DUA5pDPXzvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731007896; c=relaxed/simple;
	bh=2NhBq2Rvaw3AwygHdmYrlmMK0IZQwrr0BGDPozBcT8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQA9KKLLbZab9qKbfUmryMH5nPu56iG0MEej616FeyKmkYK5vHO0xOMZ/+Htb33C0K1s5dLO/nQOLhILVMi+JLndWXTrWx2d2vKDtfmk+Kw2MLnvO2lVoVLVhP1cU2vnuXSiIhynL+8iAYkPoxz3Co6owPVMHGWEQ7lDhui3ZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Li9WGaIa; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731007895; x=1762543895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2NhBq2Rvaw3AwygHdmYrlmMK0IZQwrr0BGDPozBcT8U=;
  b=Li9WGaIav3shDzDKNcNWJtyfZDaoNqz9nQgy2YTLzlAGXmE+JfOzWPji
   DdgbhVuc3gZgty8ZFJlBI1/2cLnFMR2C6Q18Dd+M5G2R1DayzzNbjTsOE
   7wWz2Tk2CabPRyQGm+eETmS827gbPvGE6K+LsWas68V/uqomR4ygBRxlm
   LnGTkslkCobHPN8fcOCBw2uNdPyTU0O2Zn4+BK6b86Zg1Ou+06+WCyjH3
   bSeq5YBhcQfFTtyZlEFXGQAIuQugw4VNIztROeZTZkg4t6Z3J712z1rJA
   THn8BIfeMu7WEGBpt0x5OtyCfwC9ppDmVwnA43KrrMwRLrWMVI4E2ciIP
   A==;
X-CSE-ConnectionGUID: uJLmkPukSW250ApFE9OU+Q==
X-CSE-MsgGUID: YkTGK/S3Swam68fOGBLFDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31044369"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31044369"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 11:31:32 -0800
X-CSE-ConnectionGUID: FwaUpT0wTmCFsegJmHSnGQ==
X-CSE-MsgGUID: lONXDlkQRryYdIGHChLV4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="85205060"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 07 Nov 2024 11:31:30 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t98E3-000qcF-0i;
	Thu, 07 Nov 2024 19:31:27 +0000
Date: Fri, 8 Nov 2024 03:30:32 +0800
From: kernel test robot <lkp@intel.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 11/12] io_uring/uring_cmd: support leasing device
 kernel buffer to io_uring
Message-ID: <202411080354.5JXKXPEW-lkp@intel.com>
References: <20241107110149.890530-12-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107110149.890530-12-ming.lei@redhat.com>

Hi Ming,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on next-20241107]
[cannot apply to linus/master v6.12-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-rsrc-pass-struct-io_ring_ctx-reference-to-rsrc-helpers/20241107-190456
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241107110149.890530-12-ming.lei%40redhat.com
patch subject: [PATCH V10 11/12] io_uring/uring_cmd: support leasing device kernel buffer to io_uring
config: arm64-randconfig-001-20241108 (https://download.01.org/0day-ci/archive/20241108/202411080354.5JXKXPEW-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 592c0fe55f6d9a811028b5f3507be91458ab2713)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241108/202411080354.5JXKXPEW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411080354.5JXKXPEW-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from block/ioctl.c:4:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/arm64/include/asm/cacheflush.h:11:
   In file included from include/linux/kgdb.h:19:
   In file included from include/linux/kprobes.h:28:
   In file included from include/linux/ftrace.h:13:
   In file included from include/linux/kallsyms.h:13:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from block/ioctl.c:15:
>> include/linux/io_uring/cmd.h:89:1: error: expected identifier or '('
      89 | {
         | ^
   3 warnings and 1 error generated.


vim +89 include/linux/io_uring/cmd.h

    62	
    63	int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
    64				    struct io_rsrc_node *node);
    65	#else
    66	static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
    67				      struct iov_iter *iter, void *ioucmd)
    68	{
    69		return -EOPNOTSUPP;
    70	}
    71	static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
    72			ssize_t ret2, unsigned issue_flags)
    73	{
    74	}
    75	static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
    76				    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
    77				    unsigned flags)
    78	{
    79	}
    80	static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
    81			unsigned int issue_flags)
    82	{
    83	}
    84	static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
    85	{
    86	}
    87	static inline int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
    88						  struct io_rsrc_node *node);
  > 89	{
    90		return -EOPNOTSUPP;
    91	}
    92	#endif
    93	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

