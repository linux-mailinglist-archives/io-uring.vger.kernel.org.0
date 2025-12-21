Return-Path: <io-uring+bounces-11242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD12CD3FFF
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 13:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15E81300A34D
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 12:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792BC125D0;
	Sun, 21 Dec 2025 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bmENUQ6i"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233AE8248B;
	Sun, 21 Dec 2025 12:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766319861; cv=none; b=s8pLcaJKTBuLnLuKzODIMvRad6vIAjowWQY3ueZiPQzoBlBnmKyKYnuQcZ/ij3ptEToEXQAKdcY32jo3a69oPmhVN3+E0K8MN2H2VR7Ym/sY6b5DwtIJogrGcOLqUIkjM+iBL9KW5s1JLD4mRT6dSWrjnUOY04LQMPpu3BcZNwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766319861; c=relaxed/simple;
	bh=oHXGxvDNAoN1RK4XoFp9y+1KrMsH94ZEtYW2e9P1t+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtXD/c9g2wT4AZJyece+/7inW3T+EdjWxq/ooAuSy3qf+sAvEP0kOgTVyw99Nvrb4xccPqI7y8FO0Sc9vxOntCdYPK2nMCYfJh3O57KqGiguoBBM2qWVMLKXE32qb3YgnfsctdwaakiumYcQBy3lPzHpMXi14cVEWQhl4GSnCPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bmENUQ6i; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766319858; x=1797855858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oHXGxvDNAoN1RK4XoFp9y+1KrMsH94ZEtYW2e9P1t+M=;
  b=bmENUQ6idBkqr8vj/HFb2l29135DrShlSUn2yVe3u+4jTuHymqvOV34u
   moWn9c0bdRiRigWb2g2d119lJ0JVzIhZkgJwx049h452Lrk4RflDmpTYe
   xfW7Kf9o9+y1vARH/uKzZz4T9JjMCfOXPZRk9rdhT94NSW5Ou2q7z1V5l
   9oUSGBoRIsgEFd798id/9UWnRyzStC6H553ECgJhJipUns1a/4TEflE7C
   j4koM0HwODSvrQw5aP33/WRaOlkGq5kYSMm1ZH7RQJUdjXcwFo5/jf4AN
   y4Gvl4M/dlOaldV9HQIMsjD9jpoKXqUhOS1lRvdo66dikP4HESNWUughO
   w==;
X-CSE-ConnectionGUID: MrL2bqA4Tke5d3624LMkZw==
X-CSE-MsgGUID: VfW9qEYzT4mLvFTiQ2neHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="67199236"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="67199236"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 04:24:17 -0800
X-CSE-ConnectionGUID: jvwbb3CURKqpeThAKD+q+Q==
X-CSE-MsgGUID: 7Qmy7wJaQtSTB/iaeJERKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199590146"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 21 Dec 2025 04:24:15 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXITs-000000005fB-3hXj;
	Sun, 21 Dec 2025 12:24:12 +0000
Date: Sun, 21 Dec 2025 20:24:05 +0800
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	csander@purestorage.com, xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 03/25] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <202512212016.Nbc4ikuj-lkp@intel.com>
References: <20251218083319.3485503-4-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218083319.3485503-4-joannelkoong@gmail.com>

Hi Joanne,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on linus/master v6.19-rc1 next-20251219]
[cannot apply to mszeredi-fuse/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io_uring-kbuf-refactor-io_buf_pbuf_register-logic-into-generic-helpers/20251218-165107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20251218083319.3485503-4-joannelkoong%40gmail.com
patch subject: [PATCH v2 03/25] io_uring/kbuf: add support for kernel-managed buffer rings
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20251221/202512212016.Nbc4ikuj-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512212016.Nbc4ikuj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512212016.Nbc4ikuj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   io_uring/kbuf.c: In function 'io_setup_kmbuf_ring':
>> io_uring/kbuf.c:810:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     810 |                 buf->addr = (u64)buf_region;
         |                             ^


vim +810 io_uring/kbuf.c

   781	
   782	static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
   783				       struct io_buffer_list *bl,
   784				       struct io_uring_buf_reg *reg)
   785	{
   786		struct io_uring_buf_ring *ring;
   787		unsigned long ring_size;
   788		void *buf_region;
   789		unsigned int i;
   790		int ret;
   791	
   792		/* allocate pages for the ring structure */
   793		ring_size = flex_array_size(ring, bufs, bl->nr_entries);
   794		ring = kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
   795		if (!ring)
   796			return -ENOMEM;
   797	
   798		ret = io_create_region_multi_buf(ctx, &bl->region, bl->nr_entries,
   799						 reg->buf_size);
   800		if (ret) {
   801			kfree(ring);
   802			return ret;
   803		}
   804	
   805		/* initialize ring buf entries to point to the buffers */
   806		buf_region = bl->region.ptr;
   807		for (i = 0; i < bl->nr_entries; i++) {
   808			struct io_uring_buf *buf = &ring->bufs[i];
   809	
 > 810			buf->addr = (u64)buf_region;
   811			buf->len = reg->buf_size;
   812			buf->bid = i;
   813	
   814			buf_region += reg->buf_size;
   815		}
   816		ring->tail = bl->nr_entries;
   817	
   818		bl->buf_ring = ring;
   819	
   820		return 0;
   821	}
   822	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

