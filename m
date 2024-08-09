Return-Path: <io-uring+bounces-2685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3006C94C98D
	for <lists+io-uring@lfdr.de>; Fri,  9 Aug 2024 07:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D93DC1F23C65
	for <lists+io-uring@lfdr.de>; Fri,  9 Aug 2024 05:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3700D16B75F;
	Fri,  9 Aug 2024 05:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/f7lkwr"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D18167265;
	Fri,  9 Aug 2024 05:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723180729; cv=none; b=R5DEmCzqv2nmgSqZvIdDEUdojxmskA9P8Hnfi3ZhdywA85ivao9f9e7zZN2RV+t3ADw94V7XQLf16pHE6YtZRpaJmxw3NzhnzvK4hFlh0a5iOsSY48m3rfa1AVjZTdHDST9lG1BTCbPaF4454ZIHENG8lnvM7RDCqQtCCyoaZ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723180729; c=relaxed/simple;
	bh=3mXoSfd6SeRX1psM4eVeRTQ7fvXYaRo7W/A8xAyA5oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fve0tXjFDtned86VtEECWbWuOATGzHGZ5x7y7EZ2reGEZErKWXxHq5sms0kbVjIaU3Aaxdm7ZQvHFpPZtgxFVzU9Zv7zyTuQvZlhq6uC4kMtD1OwLqxYH5+TxaWl1aQNJ20PYgFqrEKPR9n8QPZLHBzu2wsNOBgX7d1HgWpJeB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J/f7lkwr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723180728; x=1754716728;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3mXoSfd6SeRX1psM4eVeRTQ7fvXYaRo7W/A8xAyA5oI=;
  b=J/f7lkwrwiQT2qYukiP91xGZ4Zc7p0DjZIQPz5LFbeD8bsCCBiMiDs/s
   SKAPiPlWu1qWvGI10H3BuJ5JI52TqFltqP7HwaUTwQFiARc408Q/1ZrMS
   FBQ+MoVJJDS4gqkF37H16dhBZU0zFi6ShCXJi8ojZQbKaybpeFyihXrFt
   ubMSVVC2XuqHC0NhV/ERILIQk7jZmt84myYymC219KlTbhEqqBBjXP8GL
   +arb0PXN9tIEd28IrG41Y1TzHGKLJpraoSYJ5EjK9CcFsHPrhT6MxoV/W
   EIvOvGrAvVyqtSs99WO3NLcSmcJAqGkAImWtsC9+p4R00m7rhGg0rzVa2
   A==;
X-CSE-ConnectionGUID: 5tFlssK+Q3alnM8S0RnTLw==
X-CSE-MsgGUID: bhnKzdi2Qxyj12DM0RIINg==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21481676"
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="21481676"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 22:18:47 -0700
X-CSE-ConnectionGUID: CVkkeCoKQgu4HTmHYfAxeg==
X-CSE-MsgGUID: jibG+sskQ/KHz+pGXoK10g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="62293005"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 08 Aug 2024 22:18:45 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1scI1S-0006rS-1y;
	Fri, 09 Aug 2024 05:18:42 +0000
Date: Fri, 9 Aug 2024 13:17:58 +0800
From: kernel test robot <lkp@intel.com>
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk, asml.silence@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: Re: [PATCH v7 RESENT] io_uring: releasing CPU resources when polling
Message-ID: <202408091329.zC0XSfdm-lkp@intel.com>
References: <20240808071712.2429842-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808071712.2429842-1-xue01.he@samsung.com>

Hi hexue,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.11-rc2 next-20240808]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/hexue/io_uring-releasing-CPU-resources-when-polling/20240808-153455
base:   linus/master
patch link:    https://lore.kernel.org/r/20240808071712.2429842-1-xue01.he%40samsung.com
patch subject: [PATCH v7 RESENT] io_uring: releasing CPU resources when polling
config: x86_64-randconfig-161-20240809 (https://download.01.org/0day-ci/archive/20240809/202408091329.zC0XSfdm-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408091329.zC0XSfdm-lkp@intel.com/

smatch warnings:
io_uring/rw.c:1183 io_uring_hybrid_poll() warn: unsigned 'runtime' is never less than zero.

vim +/runtime +1183 io_uring/rw.c

  1171	
  1172	static int io_uring_hybrid_poll(struct io_kiocb *req,
  1173					struct io_comp_batch *iob, unsigned int poll_flags)
  1174	{
  1175		struct io_ring_ctx *ctx = req->ctx;
  1176		int ret;
  1177		u64 runtime, sleep_time;
  1178	
  1179		sleep_time = io_delay(ctx, req);
  1180		ret = io_uring_classic_poll(req, iob, poll_flags);
  1181		req->iopoll_end = ktime_get_ns();
  1182		runtime = req->iopoll_end - req->iopoll_start - sleep_time;
> 1183		if (runtime < 0)
  1184			return 0;
  1185	
  1186		/* use minimize sleep time if there are different speed
  1187		 * drivers, it could get more completions from fast one
  1188		 */
  1189		if (ctx->available_time > runtime)
  1190			ctx->available_time = runtime;
  1191		return ret;
  1192	}
  1193	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

