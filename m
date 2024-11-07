Return-Path: <io-uring+bounces-4557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 634029C0DBE
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 19:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15F6E1F22D76
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9372170B1;
	Thu,  7 Nov 2024 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zx73TQEF"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2296216A15;
	Thu,  7 Nov 2024 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731004114; cv=none; b=UGNDL68mmyNRsW+ahPqPMdxqaSAlHvwHAPemMRwOBrMYnpsl5keLT6OsxE7Hk+S80ThepGb+kcdYOIblYqqn33rn6O01TDU4SzfzqLbFr2CVrenw8fH7DnH3LkNOk6mvqssRFZ6N4e34TDzgomnO4kHw4D2VEUpTsfwU+IRWl0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731004114; c=relaxed/simple;
	bh=+Wo6r82THbUjNXMk4MeQeta3Cu/1ECzHE0kWbvDojkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R7bGvil6enXac/5gff9t0qvx+qcKtAAsuUvxybGn/6+c6URzD9GlBjhbU1yZgh5f9Tdc/+ItD6/h621vbAQ7YNWuweWp6ve/d6sy/NeccsNHzArOn7LfWb77pBLnjHNPu2ryQ/C+mD5xHNj6B9GliT2xNEiXnx7zEB5HnZlhDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zx73TQEF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731004112; x=1762540112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Wo6r82THbUjNXMk4MeQeta3Cu/1ECzHE0kWbvDojkQ=;
  b=Zx73TQEF16YHYX2GUNQI+E4egK3tFzSpXEgO6wma4wYC/9bod4jPV7AK
   V/+eDkGaCxfdsa0cASC+xkkNNfSzl9FFlm7LZk5/MKIYhRAifGADtRID9
   s49Fqwq7Ux0vuQc9WlYLrj6IrgbKfgogsQWo44qyXJRkVeVIzoH6/r+xT
   GtyBVAd7n4EJJOoXnzmuSAekmRi0fyzJfeZyKNf2OdoY56ehaI3dktYKJ
   D/5a7847ECiwLp1bzoGortKjHMoXEmPSPDFvZCJf4544oidPV2+QlNrhH
   Amgk/5/GdaKU8mS0WB94IJ/CrcjkasyIJshE3f+XO+Bz+8XkPpHme533z
   g==;
X-CSE-ConnectionGUID: tlONnJXGTzyoVTGB2g19vQ==
X-CSE-MsgGUID: olUyjysCSTKeX58uz4Tycw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="48380865"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="48380865"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:28:31 -0800
X-CSE-ConnectionGUID: zurYR6BgQBuTRkxzKAxxFg==
X-CSE-MsgGUID: jgQgNA92TbqFNgqvtzw1+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="85984316"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 07 Nov 2024 10:28:29 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t97F3-000qZq-3B;
	Thu, 07 Nov 2024 18:28:25 +0000
Date: Fri, 8 Nov 2024 02:27:55 +0800
From: kernel test robot <lkp@intel.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 11/12] io_uring/uring_cmd: support leasing device
 kernel buffer to io_uring
Message-ID: <202411080218.NHuzJ77W-lkp@intel.com>
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
config: arc-randconfig-001-20241108 (https://download.01.org/0day-ci/archive/20241108/202411080218.NHuzJ77W-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241108/202411080218.NHuzJ77W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411080218.NHuzJ77W-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from block/fops.c:20:
>> include/linux/io_uring/cmd.h:89:1: error: expected identifier or '(' before '{' token
      89 | {
         | ^
>> include/linux/io_uring/cmd.h:87:19: warning: 'io_uring_cmd_lease_kbuf' declared 'static' but never defined [-Wunused-function]
      87 | static inline int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~


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
  > 87	static inline int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
    88						  struct io_rsrc_node *node);
  > 89	{
    90		return -EOPNOTSUPP;
    91	}
    92	#endif
    93	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

