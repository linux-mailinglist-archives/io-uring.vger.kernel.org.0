Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4351DE94
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 20:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386395AbiEFSH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 14:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345265AbiEFSH2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 14:07:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D99F62BE8;
        Fri,  6 May 2022 11:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651860224; x=1683396224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OEeiocmrZj4jCiG19y+euPcErILSfJpaxWvMo3EnA18=;
  b=QTtbuzxzZOAEbjazWj+MyrtZleqM6J9lJzwEdXuk8gwCdQjdVpBaMQ8O
   KxU1eaNcmBdb92GLPH+yFX26bsTtqQLkYeQsdsjEq6PANGA0xXSP0AZ+B
   FGkg8BQ8SHtmq3yuKfYcmlYGFBvAzQg+Div/Mb0MuXoOv/YEwpLhs1Kvx
   8TOAhCQRRsCO+fxAABz+Y8LQ4Qv5GInIYssaFKut2JZ22mp5WyV9/0kLn
   urIKPvVKXRcSTaciV7rgb/M3WbEvP71pXjFhr0muXyU55imh5iK2K/5pe
   8tMq+zxCdiiFAOMzBKgrAemJumFwDrwbftCFCtEXJFBS0VOYsCrlszRmD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="249069964"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="249069964"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:03:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="600670596"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 06 May 2022 11:03:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nn2IV-000Djb-Rm;
        Fri, 06 May 2022 18:03:23 +0000
Date:   Sat, 7 May 2022 02:02:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
Message-ID: <202205070134.WJEE4sX5-lkp@intel.com>
References: <20220506070102.26032-4-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506070102.26032-4-haoxu.linux@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Hao,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on f2e030dd7aaea5a937a2547dc980fab418fbc5e7]

url:    https://github.com/intel-lab-lkp/linux/commits/Hao-Xu/fast-poll-multishot-mode/20220506-150750
base:   f2e030dd7aaea5a937a2547dc980fab418fbc5e7
config: x86_64-randconfig-s021 (https://download.01.org/0day-ci/archive/20220507/202205070134.WJEE4sX5-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/6001c3e95550875d4328aa2ca8b342c42b0e644e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hao-Xu/fast-poll-multishot-mode/20220506-150750
        git checkout 6001c3e95550875d4328aa2ca8b342c42b0e644e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   fs/io_uring.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/io_uring.h):
   include/trace/events/io_uring.h:488:1: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] op_flags @@     got restricted __kernel_rwf_t const [usertype] rw_flags @@
   include/trace/events/io_uring.h:488:1: sparse:     expected unsigned int [usertype] op_flags
   include/trace/events/io_uring.h:488:1: sparse:     got restricted __kernel_rwf_t const [usertype] rw_flags
   fs/io_uring.c: note: in included file (through include/trace/perf.h, include/trace/define_trace.h, include/trace/events/io_uring.h):
   include/trace/events/io_uring.h:488:1: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] op_flags @@     got restricted __kernel_rwf_t const [usertype] rw_flags @@
   include/trace/events/io_uring.h:488:1: sparse:     expected unsigned int [usertype] op_flags
   include/trace/events/io_uring.h:488:1: sparse:     got restricted __kernel_rwf_t const [usertype] rw_flags
   fs/io_uring.c:3280:23: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] flags @@     got restricted __kernel_rwf_t @@
   fs/io_uring.c:3280:23: sparse:     expected unsigned int [usertype] flags
   fs/io_uring.c:3280:23: sparse:     got restricted __kernel_rwf_t
   fs/io_uring.c:3477:24: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected void [noderef] __user * @@     got struct io_buffer *[assigned] kbuf @@
   fs/io_uring.c:3477:24: sparse:     expected void [noderef] __user *
   fs/io_uring.c:3477:24: sparse:     got struct io_buffer *[assigned] kbuf
   fs/io_uring.c:3864:48: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __kernel_rwf_t [usertype] flags @@     got unsigned int [usertype] flags @@
   fs/io_uring.c:3864:48: sparse:     expected restricted __kernel_rwf_t [usertype] flags
   fs/io_uring.c:3864:48: sparse:     got unsigned int [usertype] flags
   fs/io_uring.c:5187:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct file *file @@     got struct file [noderef] __rcu * @@
   fs/io_uring.c:5187:14: sparse:     expected struct file *file
   fs/io_uring.c:5187:14: sparse:     got struct file [noderef] __rcu *
   fs/io_uring.c:5974:68: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted __poll_t [usertype] _key @@     got int apoll_events @@
   fs/io_uring.c:5974:68: sparse:     expected restricted __poll_t [usertype] _key
   fs/io_uring.c:5974:68: sparse:     got int apoll_events
   fs/io_uring.c:5979:48: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:5983:59: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:5991:74: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted __poll_t [usertype] val @@     got int @@
   fs/io_uring.c:5991:74: sparse:     expected restricted __poll_t [usertype] val
   fs/io_uring.c:5991:74: sparse:     got int
   fs/io_uring.c:5991:60: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted __poll_t [usertype] mask @@     got unsigned short @@
   fs/io_uring.c:5991:60: sparse:     expected restricted __poll_t [usertype] mask
   fs/io_uring.c:5991:60: sparse:     got unsigned short
   fs/io_uring.c:5997:58: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected signed int [usertype] res @@     got restricted __poll_t [usertype] mask @@
   fs/io_uring.c:5997:58: sparse:     expected signed int [usertype] res
   fs/io_uring.c:5997:58: sparse:     got restricted __poll_t [usertype] mask
   fs/io_uring.c:6027:68: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6027:57: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted __poll_t [usertype] val @@     got unsigned int @@
   fs/io_uring.c:6027:57: sparse:     expected restricted __poll_t [usertype] val
   fs/io_uring.c:6027:57: sparse:     got unsigned int
   fs/io_uring.c:6108:45: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:6108:45: sparse:     expected int events
   fs/io_uring.c:6108:45: sparse:     got restricted __poll_t [usertype] events
   fs/io_uring.c:6143:40: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int mask @@     got restricted __poll_t [usertype] mask @@
   fs/io_uring.c:6143:40: sparse:     expected int mask
   fs/io_uring.c:6143:40: sparse:     got restricted __poll_t [usertype] mask
   fs/io_uring.c:6143:50: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:6143:50: sparse:     expected int events
   fs/io_uring.c:6143:50: sparse:     got restricted __poll_t [usertype] events
   fs/io_uring.c:6235:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted __poll_t [assigned] [usertype] mask @@
   fs/io_uring.c:6235:24: sparse:     expected int
   fs/io_uring.c:6235:24: sparse:     got restricted __poll_t [assigned] [usertype] mask
   fs/io_uring.c:6252:40: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int mask @@     got restricted __poll_t [assigned] [usertype] mask @@
   fs/io_uring.c:6252:40: sparse:     expected int mask
   fs/io_uring.c:6252:40: sparse:     got restricted __poll_t [assigned] [usertype] mask
   fs/io_uring.c:6252:50: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:6252:50: sparse:     expected int events
   fs/io_uring.c:6252:50: sparse:     got restricted __poll_t [usertype] events
   fs/io_uring.c:6262:47: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:6262:47: sparse:     expected int events
   fs/io_uring.c:6262:47: sparse:     got restricted __poll_t [usertype] events
>> fs/io_uring.c:6287:33: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted __poll_t [usertype] mask @@     got int @@
   fs/io_uring.c:6287:33: sparse:     expected restricted __poll_t [usertype] mask
   fs/io_uring.c:6287:33: sparse:     got int
   fs/io_uring.c:6300:22: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:6300:22: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6300:22: sparse:    right side has type int
   fs/io_uring.c:6305:30: sparse: sparse: invalid assignment: &=
   fs/io_uring.c:6305:30: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6305:30: sparse:    right side has type int
   fs/io_uring.c:6307:22: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:6307:22: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6307:22: sparse:    right side has type int
   fs/io_uring.c:6335:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected int mask @@     got restricted __poll_t [assigned] [usertype] mask @@
   fs/io_uring.c:6335:33: sparse:     expected int mask
   fs/io_uring.c:6335:33: sparse:     got restricted __poll_t [assigned] [usertype] mask
   fs/io_uring.c:6335:50: sparse: sparse: incorrect type in argument 6 (different base types) @@     expected int events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:6335:50: sparse:     expected int events
   fs/io_uring.c:6335:50: sparse:     got restricted __poll_t [usertype] events
   fs/io_uring.c:6449:24: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:6449:24: sparse:    left side has type unsigned int
   fs/io_uring.c:6449:24: sparse:    right side has type restricted __poll_t
   fs/io_uring.c:6450:65: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6450:29: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6450:38: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __poll_t @@     got unsigned int @@
   fs/io_uring.c:6450:38: sparse:     expected restricted __poll_t
   fs/io_uring.c:6450:38: sparse:     got unsigned int
   fs/io_uring.c:6502:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected int apoll_events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:6502:27: sparse:     expected int apoll_events
   fs/io_uring.c:6502:27: sparse:     got restricted __poll_t [usertype] events
   fs/io_uring.c:6541:43: sparse: sparse: invalid assignment: &=
   fs/io_uring.c:6541:43: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6541:43: sparse:    right side has type int
   fs/io_uring.c:6542:62: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6542:43: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:6542:43: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6542:43: sparse:    right side has type unsigned int
   fs/io_uring.c:2536:17: sparse: sparse: context imbalance in 'handle_prev_tw_list' - different lock contexts for basic block
   fs/io_uring.c:7610:39: sparse: sparse: marked inline, but without a definition
   fs/io_uring.c:7610:39: sparse: sparse: marked inline, but without a definition
   fs/io_uring.c:7610:39: sparse: sparse: marked inline, but without a definition
   fs/io_uring.c:7610:39: sparse: sparse: marked inline, but without a definition

vim +6287 fs/io_uring.c

  6280	
  6281	static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
  6282	{
  6283		const struct io_op_def *def = &io_op_defs[req->opcode];
  6284		struct io_ring_ctx *ctx = req->ctx;
  6285		struct async_poll *apoll;
  6286		struct io_poll_table ipt;
> 6287		__poll_t mask = POLLERR | POLLPRI;
  6288		int ret;
  6289	
  6290		if (!def->pollin && !def->pollout)
  6291			return IO_APOLL_ABORTED;
  6292		if (!file_can_poll(req->file))
  6293			return IO_APOLL_ABORTED;
  6294		if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
  6295			return IO_APOLL_ABORTED;
  6296		if (!(req->flags & REQ_F_APOLL_MULTISHOT))
  6297			mask |= EPOLLONESHOT;
  6298	
  6299		if (def->pollin) {
  6300			mask |= POLLIN | POLLRDNORM;
  6301	
  6302			/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
  6303			if ((req->opcode == IORING_OP_RECVMSG) &&
  6304			    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
  6305				mask &= ~POLLIN;
  6306		} else {
  6307			mask |= POLLOUT | POLLWRNORM;
  6308		}
  6309		if (def->poll_exclusive)
  6310			mask |= EPOLLEXCLUSIVE;
  6311		if (req->flags & REQ_F_POLLED) {
  6312			apoll = req->apoll;
  6313		} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
  6314			   !list_empty(&ctx->apoll_cache)) {
  6315			apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
  6316							poll.wait.entry);
  6317			list_del_init(&apoll->poll.wait.entry);
  6318		} else {
  6319			apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
  6320			if (unlikely(!apoll))
  6321				return IO_APOLL_ABORTED;
  6322		}
  6323		apoll->double_poll = NULL;
  6324		req->apoll = apoll;
  6325		req->flags |= REQ_F_POLLED;
  6326		ipt.pt._qproc = io_async_queue_proc;
  6327	
  6328		io_kbuf_recycle(req, issue_flags);
  6329	
  6330		ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
  6331		if (ret || ipt.error)
  6332			return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
  6333	
  6334		trace_io_uring_poll_arm(ctx, req, req->cqe.user_data, req->opcode,
  6335					mask, apoll->poll.events);
  6336		return IO_APOLL_OK;
  6337	}
  6338	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
