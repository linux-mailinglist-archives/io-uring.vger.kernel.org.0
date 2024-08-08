Return-Path: <io-uring+bounces-2683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2045694C2C3
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 18:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAF1C28163E
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 16:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6E418EFDC;
	Thu,  8 Aug 2024 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SA5PN9Zu"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5E018E04F;
	Thu,  8 Aug 2024 16:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723134679; cv=none; b=pde0IGhozzeM2242A7dqZnFbHXZLm+Y+TSj/i+JETd4mm2ain/rQ+g40DcAMbZhf2QjurNogDS7G3F0L2BTdCbOXXKDBHRHL0F4yp0drDAyipx9y6nwRPb/8liQOBD4KFuxYu5Clpcu+YOpXjtL9cyNq1Ey8XSIWwi/CJ8yrMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723134679; c=relaxed/simple;
	bh=i6y2cqEWTEwCDBsqoXKv1SRsckm/rq5zK8+VNost7X4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNvj8BfLhf09k2tzIlN1yhvISmfz0ykPz7K6Ck9cH+lIdZk4A18SWTF43Tx7YnVuj2rY9Y+4dDpEjhhosbjP5q4a4enWKPyCexHnBBuh+i6B00XUK+i9/tEesfbWnQuSafw5jNx3UqMSikiRVT70HX2moux8TcyZ3FpBOQtO+4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SA5PN9Zu; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723134677; x=1754670677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i6y2cqEWTEwCDBsqoXKv1SRsckm/rq5zK8+VNost7X4=;
  b=SA5PN9ZuaBVRJ3JViqpEMDZYGuiBsbw+Gkk+Cya/+2Sq7+CIiHgCii8G
   mFTdnQ8k2gO3Tozi0xD0+x5E7PcHqZ74BDslaobGXCqX623GeZBnGCQSV
   eBCuYLxdvoh83izk54Mqx4nheBvwD7Q2g/GHOr1JtCAwSBLw44cdWmsDw
   fzh5ePsjiwYwluy3HwDthwxPWHu51KbwhSKtBh6M4SGDDkkGwir2gFibb
   1ZXMD8/ZGP3qOj/FQVZxqPC7zak7SiCifBpogLmda0ce3eejtXMSXulSI
   Of11Syls/D5YkBzE2T2Sx3EgxxgnlBO4sWbRrt1SNt42oVIrx4gaA60H5
   Q==;
X-CSE-ConnectionGUID: U8083nwQRBWC/REyjvc7sg==
X-CSE-MsgGUID: mz9Wrs4ORh6m9iU3i8etkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21444969"
X-IronPort-AV: E=Sophos;i="6.09,273,1716274800"; 
   d="scan'208";a="21444969"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 09:31:02 -0700
X-CSE-ConnectionGUID: li47KWzYSFWtivNEm2pgFg==
X-CSE-MsgGUID: L+tLVbAjTfSewiVpaReS6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,273,1716274800"; 
   d="scan'208";a="62223974"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 08 Aug 2024 09:31:00 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sc62T-0006Jq-1n;
	Thu, 08 Aug 2024 16:30:57 +0000
Date: Fri, 9 Aug 2024 00:30:42 +0800
From: kernel test robot <lkp@intel.com>
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk, asml.silence@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: Re: [PATCH v7 RESENT] io_uring: releasing CPU resources when polling
Message-ID: <202408090038.uF18SUul-lkp@intel.com>
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
config: alpha-defconfig (https://download.01.org/0day-ci/archive/20240809/202408090038.uF18SUul-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240809/202408090038.uF18SUul-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408090038.uF18SUul-lkp@intel.com/

All warnings (new ones prefixed by >>):

   io_uring/rw.c: In function 'io_do_iopoll':
>> io_uring/rw.c:1210:30: warning: unused variable 'file' [-Wunused-variable]
    1210 |                 struct file *file = req->file;
         |                              ^~~~


vim +/file +1210 io_uring/rw.c

e61753df273102 hexue          2024-08-08  1193  
f3b44f92e59a80 Jens Axboe     2022-06-13  1194  int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
f3b44f92e59a80 Jens Axboe     2022-06-13  1195  {
f3b44f92e59a80 Jens Axboe     2022-06-13  1196  	struct io_wq_work_node *pos, *start, *prev;
54bdd67d0f8848 Keith Busch    2023-03-20  1197  	unsigned int poll_flags = 0;
f3b44f92e59a80 Jens Axboe     2022-06-13  1198  	DEFINE_IO_COMP_BATCH(iob);
f3b44f92e59a80 Jens Axboe     2022-06-13  1199  	int nr_events = 0;
f3b44f92e59a80 Jens Axboe     2022-06-13  1200  
f3b44f92e59a80 Jens Axboe     2022-06-13  1201  	/*
f3b44f92e59a80 Jens Axboe     2022-06-13  1202  	 * Only spin for completions if we don't have multiple devices hanging
f3b44f92e59a80 Jens Axboe     2022-06-13  1203  	 * off our complete list.
f3b44f92e59a80 Jens Axboe     2022-06-13  1204  	 */
f3b44f92e59a80 Jens Axboe     2022-06-13  1205  	if (ctx->poll_multi_queue || force_nonspin)
f3b44f92e59a80 Jens Axboe     2022-06-13  1206  		poll_flags |= BLK_POLL_ONESHOT;
f3b44f92e59a80 Jens Axboe     2022-06-13  1207  
f3b44f92e59a80 Jens Axboe     2022-06-13  1208  	wq_list_for_each(pos, start, &ctx->iopoll_list) {
f3b44f92e59a80 Jens Axboe     2022-06-13  1209  		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
a1119fb0711591 Jens Axboe     2022-09-02 @1210  		struct file *file = req->file;
f3b44f92e59a80 Jens Axboe     2022-06-13  1211  		int ret;
f3b44f92e59a80 Jens Axboe     2022-06-13  1212  
f3b44f92e59a80 Jens Axboe     2022-06-13  1213  		/*
f3b44f92e59a80 Jens Axboe     2022-06-13  1214  		 * Move completed and retryable entries to our local lists.
f3b44f92e59a80 Jens Axboe     2022-06-13  1215  		 * If we find a request that requires polling, break out
f3b44f92e59a80 Jens Axboe     2022-06-13  1216  		 * and complete those lists first, if we have entries there.
f3b44f92e59a80 Jens Axboe     2022-06-13  1217  		 */
f3b44f92e59a80 Jens Axboe     2022-06-13  1218  		if (READ_ONCE(req->iopoll_completed))
f3b44f92e59a80 Jens Axboe     2022-06-13  1219  			break;
f3b44f92e59a80 Jens Axboe     2022-06-13  1220  
e61753df273102 hexue          2024-08-08  1221  		if (ctx->flags & IORING_SETUP_HY_POLL)
e61753df273102 hexue          2024-08-08  1222  			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
e61753df273102 hexue          2024-08-08  1223  		else
e61753df273102 hexue          2024-08-08  1224  			ret = io_uring_classic_poll(req, &iob, poll_flags);
5756a3a7e713bc Kanchan Joshi  2022-08-23  1225  
f3b44f92e59a80 Jens Axboe     2022-06-13  1226  		if (unlikely(ret < 0))
f3b44f92e59a80 Jens Axboe     2022-06-13  1227  			return ret;
f3b44f92e59a80 Jens Axboe     2022-06-13  1228  		else if (ret)
f3b44f92e59a80 Jens Axboe     2022-06-13  1229  			poll_flags |= BLK_POLL_ONESHOT;
f3b44f92e59a80 Jens Axboe     2022-06-13  1230  
f3b44f92e59a80 Jens Axboe     2022-06-13  1231  		/* iopoll may have completed current req */
f3b44f92e59a80 Jens Axboe     2022-06-13  1232  		if (!rq_list_empty(iob.req_list) ||
f3b44f92e59a80 Jens Axboe     2022-06-13  1233  		    READ_ONCE(req->iopoll_completed))
f3b44f92e59a80 Jens Axboe     2022-06-13  1234  			break;
f3b44f92e59a80 Jens Axboe     2022-06-13  1235  	}
f3b44f92e59a80 Jens Axboe     2022-06-13  1236  
f3b44f92e59a80 Jens Axboe     2022-06-13  1237  	if (!rq_list_empty(iob.req_list))
f3b44f92e59a80 Jens Axboe     2022-06-13  1238  		iob.complete(&iob);
f3b44f92e59a80 Jens Axboe     2022-06-13  1239  	else if (!pos)
f3b44f92e59a80 Jens Axboe     2022-06-13  1240  		return 0;
f3b44f92e59a80 Jens Axboe     2022-06-13  1241  
f3b44f92e59a80 Jens Axboe     2022-06-13  1242  	prev = start;
f3b44f92e59a80 Jens Axboe     2022-06-13  1243  	wq_list_for_each_resume(pos, prev) {
f3b44f92e59a80 Jens Axboe     2022-06-13  1244  		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
f3b44f92e59a80 Jens Axboe     2022-06-13  1245  
f3b44f92e59a80 Jens Axboe     2022-06-13  1246  		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
f3b44f92e59a80 Jens Axboe     2022-06-13  1247  		if (!smp_load_acquire(&req->iopoll_completed))
f3b44f92e59a80 Jens Axboe     2022-06-13  1248  			break;
f3b44f92e59a80 Jens Axboe     2022-06-13  1249  		nr_events++;
f3b44f92e59a80 Jens Axboe     2022-06-13  1250  		req->cqe.flags = io_put_kbuf(req, 0);
a9165b83c1937e Jens Axboe     2024-03-18  1251  		if (req->opcode != IORING_OP_URING_CMD)
a9165b83c1937e Jens Axboe     2024-03-18  1252  			io_req_rw_cleanup(req, 0);
544d163d659d45 Pavel Begunkov 2023-01-12  1253  	}
f3b44f92e59a80 Jens Axboe     2022-06-13  1254  	if (unlikely(!nr_events))
f3b44f92e59a80 Jens Axboe     2022-06-13  1255  		return 0;
f3b44f92e59a80 Jens Axboe     2022-06-13  1256  
f3b44f92e59a80 Jens Axboe     2022-06-13  1257  	pos = start ? start->next : ctx->iopoll_list.first;
f3b44f92e59a80 Jens Axboe     2022-06-13  1258  	wq_list_cut(&ctx->iopoll_list, prev, start);
ec26c225f06f59 Pavel Begunkov 2023-08-24  1259  
ec26c225f06f59 Pavel Begunkov 2023-08-24  1260  	if (WARN_ON_ONCE(!wq_list_empty(&ctx->submit_state.compl_reqs)))
ec26c225f06f59 Pavel Begunkov 2023-08-24  1261  		return 0;
ec26c225f06f59 Pavel Begunkov 2023-08-24  1262  	ctx->submit_state.compl_reqs.first = pos;
ec26c225f06f59 Pavel Begunkov 2023-08-24  1263  	__io_submit_flush_completions(ctx);
f3b44f92e59a80 Jens Axboe     2022-06-13  1264  	return nr_events;
f3b44f92e59a80 Jens Axboe     2022-06-13  1265  }
a9165b83c1937e Jens Axboe     2024-03-18  1266  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

