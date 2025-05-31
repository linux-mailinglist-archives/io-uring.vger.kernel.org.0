Return-Path: <io-uring+bounces-8173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 875E6AC9A17
	for <lists+io-uring@lfdr.de>; Sat, 31 May 2025 10:35:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F6007A7EA1
	for <lists+io-uring@lfdr.de>; Sat, 31 May 2025 08:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90C523717F;
	Sat, 31 May 2025 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D7GIhCt6"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398E1235BF3;
	Sat, 31 May 2025 08:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748680494; cv=none; b=h8zeArhcNiASGq5SlaqRRmG/gVVnGJ70ZpCobjwPANLDMjH4K4XxnIqeXVTZx6qWhO38iWN/KHE1nUu8tUgZx9YgLj5Qupc0fONEKRqFDKTbgwf5l/Z1l1ocWChj8dDwmG49h84yalgJuLRScWPirFc1uFBt46lnDjnGWwMQjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748680494; c=relaxed/simple;
	bh=HeN3k91sOApQ7ilb4MDhzjIZN7np++nNu/5P5o+DSy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOnEFDoD7xfL3S1cY/C3P2/8TvGqky8QW7KyNGqFD3SCY8gjZ3Yyl/1BWgIyEAK770U1r8XHFcGPbXzD1jsxmbpQmYrRtR0bwgGK8z7yxdXtv/T5chcIxz2nXDVFn3k3Css+19Av/tqLx+636nJE6zZlu2VAuZ9smwqb+eAWmZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D7GIhCt6; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748680493; x=1780216493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HeN3k91sOApQ7ilb4MDhzjIZN7np++nNu/5P5o+DSy0=;
  b=D7GIhCt6tO2oZ67jQbTOpU8KE5Fzs66T+DOxKTKgnQ9uzUQz0pRHSOcb
   S+RGBJEwHdSlCM54M1OGN7QzEKp6g5ME+xeYtjIecObx+HW6Y0r1/UdfC
   ch03It5kdW1eTHyXcQfmTcLhDPaOpQ1tbqaZWgxVUATpB+v0Nsf0vpqR3
   CBs4qpFW+AF9iOkX2b9LTBRhnCshoTWCvMnaGMdfwUYjBXyG56NdCINpK
   vrHMeDV89PPckugzFKpmlNntHKo8oLLUCueKg+2M1u8k5iEc7UShI2xTG
   KKOCXGFsiSP2OIwSFds6Chr57SGVNuIqaE4YWBfHg3hUccJTmokKRJGsC
   Q==;
X-CSE-ConnectionGUID: SxrCAs6oSOGuEyvbElS/fQ==
X-CSE-MsgGUID: TZqikryIT+OwSyxiBcZ/Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11449"; a="62112332"
X-IronPort-AV: E=Sophos;i="6.16,198,1744095600"; 
   d="scan'208";a="62112332"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2025 01:34:52 -0700
X-CSE-ConnectionGUID: pexTbHmsRlCFfRVy4HKntA==
X-CSE-MsgGUID: hi6CG47NTjagHCLkylKQZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,198,1744095600"; 
   d="scan'208";a="145057505"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 31 May 2025 01:34:49 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uLHfz-000YIO-1E;
	Sat, 31 May 2025 08:34:47 +0000
Date: Sat, 31 May 2025 16:34:15 +0800
From: kernel test robot <lkp@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, asml.silence@gmail.com,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 5/5] io_uring/netcmd: add tx timestamping cmd support
Message-ID: <202505311513.4gHg718O-lkp@intel.com>
References: <2308b0e2574858aeef6837f4f9897560a835e0f7.1748607147.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2308b0e2574858aeef6837f4f9897560a835e0f7.1748607147.git.asml.silence@gmail.com>

Hi Pavel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net/main]
[also build test WARNING on net-next/main linus/master next-20250530]
[cannot apply to horms-ipvs/master v6.15]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavel-Begunkov/net-timestamp-add-helper-returning-skb-s-tx-tstamp/20250530-201922
base:   net/main
patch link:    https://lore.kernel.org/r/2308b0e2574858aeef6837f4f9897560a835e0f7.1748607147.git.asml.silence%40gmail.com
patch subject: [PATCH 5/5] io_uring/netcmd: add tx timestamping cmd support
config: riscv-randconfig-r121-20250531 (https://download.01.org/0day-ci/archive/20250531/202505311513.4gHg718O-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 10.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250531/202505311513.4gHg718O-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505311513.4gHg718O-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   io_uring/cmd_net.c:59:32: sparse: sparse: array of flexible structures
   io_uring/cmd_net.c: note: in included file:
   io_uring/uring_cmd.h:21:59: sparse: sparse: array of flexible structures
>> io_uring/cmd_net.c:94:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __poll_t [usertype] mask @@     got int @@
   io_uring/cmd_net.c:94:55: sparse:     expected restricted __poll_t [usertype] mask
   io_uring/cmd_net.c:94:55: sparse:     got int

vim +94 io_uring/cmd_net.c

    81	
    82	static int io_uring_cmd_timestamp(struct socket *sock,
    83					  struct io_uring_cmd *cmd,
    84					  unsigned int issue_flags)
    85	{
    86		struct sock *sk = sock->sk;
    87		struct sk_buff_head *q = &sk->sk_error_queue;
    88		struct sk_buff *skb, *tmp;
    89		struct sk_buff_head list;
    90		int ret;
    91	
    92		if (!(issue_flags & IO_URING_F_CQE32))
    93			return -EINVAL;
  > 94		ret = io_cmd_poll_multishot(cmd, issue_flags, POLLERR);
    95		if (unlikely(ret))
    96			return ret;
    97	
    98		if (skb_queue_empty_lockless(q))
    99			return -EAGAIN;
   100		__skb_queue_head_init(&list);
   101	
   102		scoped_guard(spinlock_irq, &q->lock) {
   103			skb_queue_walk_safe(q, skb, tmp) {
   104				/* don't support skbs with payload */
   105				if (!skb_has_tx_timestamp(skb, sk) || skb->len)
   106					continue;
   107				__skb_unlink(skb, q);
   108				__skb_queue_tail(&list, skb);
   109			}
   110		}
   111	
   112		while (1) {
   113			skb = skb_peek(&list);
   114			if (!skb)
   115				break;
   116			if (!io_process_timestamp_skb(cmd, sk, skb, issue_flags))
   117				break;
   118			__skb_dequeue(&list);
   119			consume_skb(skb);
   120		}
   121	
   122		if (!unlikely(skb_queue_empty(&list))) {
   123			scoped_guard(spinlock_irqsave, &q->lock)
   124				skb_queue_splice(q, &list);
   125		}
   126		return -EAGAIN;
   127	}
   128	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

