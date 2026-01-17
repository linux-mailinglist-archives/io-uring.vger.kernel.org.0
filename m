Return-Path: <io-uring+bounces-11796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BF1D38C7A
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 06:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B597F30318C4
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 05:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA46E31A7E1;
	Sat, 17 Jan 2026 05:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bf3Eq89W"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B7A272E6A;
	Sat, 17 Jan 2026 05:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768627726; cv=none; b=OMZWjXjCLzPTEnzTgF9Q8440qvuWWODnLs5VtK14GSHUTaCMfgHF8ufF+EgsxtIcEWWtQE9QisfYK2c0EIDt1B96v04UJ38aGp/77XaHCUWhVIFISPjW1hz50/b36svzaSYWcCSPWvdvB6Om35t6SsRP4jAnRBGKs6TA9oqmnN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768627726; c=relaxed/simple;
	bh=hvdvLGsBla31pDYbU2wB96fi0/hrIS2864cm2zyh9q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7JIiEIqLfTYqTQCTXWBU8hp77Pbxv+iy2tSgG61w/182nwuGmu0OJFzer+o063uJx+NKA1RLjmmVcZ/+kw73Kw5akK9B7UhXXwbOBuRQ6ymYO0W5n1DHi4Sm9QwlGdO2HeY0g0aw/Jdo+oljHdkvZKN83xucTdYWbRTrHJoOyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bf3Eq89W; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768627724; x=1800163724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hvdvLGsBla31pDYbU2wB96fi0/hrIS2864cm2zyh9q8=;
  b=Bf3Eq89WhC9BeqgKfdjDhV7dZWyufMbdQ1Qvb5jT6vjwQDDR5DQugA0r
   2guJHSoLNLXdU2hKBpRCl1a7llQzJFr0DSIhM3pIdSun4dFDc2bIrfPKR
   Bjws1YsARPxamT1fn/ncCkt5UErlMc4kzwjISOYHoaOiB/adjpjWGeOQx
   48WikxESuZJcaR+MxoBWVQpPx2LU2ML6kBP70ViCZXIQcOTrGvhZ8My7f
   Pj0OiU49t/oKNOvCNtw+DoB45UkqaCo4qnqlFReV7UrQfojxiVw9Rp2T4
   EaCKjOzXGZ5QCQl13NQpfh0BM9HufsaGKyRNWWpBDrTo3HR6SC7a+6xy+
   Q==;
X-CSE-ConnectionGUID: DPTtReOjTYqIq3jz5VptIA==
X-CSE-MsgGUID: z3+rI9SpQ2SgsUBIQfiBvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="80574076"
X-IronPort-AV: E=Sophos;i="6.21,233,1763452800"; 
   d="scan'208";a="80574076"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 21:28:44 -0800
X-CSE-ConnectionGUID: XNrTH9sPSOeYG/flK91OTQ==
X-CSE-MsgGUID: FiZ9XvyzT1qCxgV9iJ5Sag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,233,1763452800"; 
   d="scan'208";a="209911125"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 16 Jan 2026 21:28:41 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgyrW-00000000Laa-2BJB;
	Sat, 17 Jan 2026 05:28:38 +0000
Date: Sat, 17 Jan 2026 13:28:38 +0800
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
	miklos@szeredi.hu
Cc: oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org,
	asml.silence@gmail.com, xiaobing.li@samsung.com,
	safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
Message-ID: <202601171304.uwDzXWzy-lkp@intel.com>
References: <20260116233044.1532965-20-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116233044.1532965-20-joannelkoong@gmail.com>

Hi Joanne,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on mszeredi-fuse/for-next linus/master v6.19-rc5 next-20260116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io_uring-kbuf-refactor-io_buf_pbuf_register-logic-into-generic-helpers/20260117-073512
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260116233044.1532965-20-joannelkoong%40gmail.com
patch subject: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
config: sh-randconfig-001-20260117 (https://download.01.org/0day-ci/archive/20260117/202601171304.uwDzXWzy-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260117/202601171304.uwDzXWzy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601171304.uwDzXWzy-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/random.h:6,
                    from include/linux/nodemask.h:94,
                    from include/linux/list_lru.h:12,
                    from include/linux/fs/super_types.h:7,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from fs/fuse/fuse_i.h:17,
                    from fs/fuse/dev_uring.c:7:
   fs/fuse/dev_uring.c: In function 'fuse_uring_clean_up_buffer':
>> fs/fuse/dev_uring.c:926:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     926 |          (u64)kvec->iov_base, kvec->iov_len,
         |          ^
   include/asm-generic/bug.h:205:25: note: in definition of macro 'WARN_ON'
     205 |  int __ret_warn_on = !!(condition);    \
         |                         ^~~~~~~~~
   fs/fuse/dev_uring.c:925:2: note: in expansion of macro 'WARN_ON_ONCE'
     925 |  WARN_ON_ONCE(io_uring_kmbuf_recycle(ent->cmd, FUSE_URING_RINGBUF_GROUP,
         |  ^~~~~~~~~~~~


vim +926 fs/fuse/dev_uring.c

   913	
   914	static void fuse_uring_clean_up_buffer(struct fuse_ring_ent *ent,
   915					       unsigned int issue_flags)
   916		__must_hold(&queue->lock)
   917	{
   918		struct kvec *kvec = &ent->payload_kvec;
   919	
   920		lockdep_assert_held(&ent->queue->lock);
   921	
   922		if (!ent->queue->use_bufring || !kvec->iov_base)
   923			return;
   924	
   925		WARN_ON_ONCE(io_uring_kmbuf_recycle(ent->cmd, FUSE_URING_RINGBUF_GROUP,
 > 926						    (u64)kvec->iov_base, kvec->iov_len,
   927						    ent->ringbuf_buf_id, issue_flags));
   928	
   929		memset(kvec, 0, sizeof(*kvec));
   930	}
   931	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

