Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6706441086
	for <lists+io-uring@lfdr.de>; Sun, 31 Oct 2021 20:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJaToV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Oct 2021 15:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbhJaToV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Oct 2021 15:44:21 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AA4C061714
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 12:41:49 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id e144so19176035iof.3
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 12:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cQfaoE2v69l5M0UOfhVWNH4BCwYhKZGEHrOhvJNZ8TE=;
        b=F+7V9Nqq/1r5aiE4itWrmWnVrCAzF8qPwgjAF4Ryz9lsYuv+7i0MfDu/V9aUcJNkNZ
         pNPhlyF+Z3SwI9op8wBI9T0Qx10vHaD7pMzuzaAf0Ql6vRNYPrbUulm1oebMqqq09RCu
         NLwU//3Lg9XQ5D8ZTOaWR7Vi6NTrIQh2+9LBwS4j+K2nNYk0JgLnFYaPrpizlMuh62XX
         7KgqGHSQx190M0F+DlyoplGK9grCRYujrPkdEA0g6kt84BWCV5BieQRmgI0dKzVc1DIk
         kjGaw7clTXZAC/kmSlwXnt2Sn+znJgn1T3dErX37nofNZlDWKJLOzJEZXD5QnZEZakJ6
         5anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cQfaoE2v69l5M0UOfhVWNH4BCwYhKZGEHrOhvJNZ8TE=;
        b=vkJz0pCQ/9mA4vo0K+19MQlUxtU1dLTGf4323LrSmeaIV5vrNhAkHaoqrW20oVJa+W
         CpTV2x7ulxSpWhakRSv2DRiY2wMiEf2IXl7JCvJYLHSVL2EMQZmbYPNdz1SAKUxrzPwT
         I+W8p1UnEhh+i6nEDB3t+tVj6LJNrD65FmSqBS6gI/61525BXzT48Gii1ASCn2G1M9kM
         U9c+4X7b5+q68s52xpqvRLvm3vm//o3oJiLhW8wowr48jAto0fI1KP9ts82cLjXxNPzB
         PTY1i9DpkKkUgHJYp9InsM3pYQl3KJfR27tgFSw5sG95Boi/VFpsYD8tPsGrMz2nztnI
         t3Rg==
X-Gm-Message-State: AOAM531W2PDjzDV250apysB+5Vm0PaCCI31rcRQ8XHe2Tjfeii4lePK2
        iROGp0Y/KY/E7KyjRcHp2eSp0ygFdINgXA==
X-Google-Smtp-Source: ABdhPJwexcjG5HDDCiujNHo73oxBkMt+rYJ6wCoDD+BvRqGZDZeYtlywyDpO9mHg6s7oCiXvVZIKkg==
X-Received: by 2002:a6b:650f:: with SMTP id z15mr11961280iob.27.1635709308082;
        Sun, 31 Oct 2021 12:41:48 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n1sm2572349ioz.51.2021.10.31.12.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 12:41:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.16-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <c5054513-d496-e15e-91ef-dcdbf9dda2c4@kernel.dk>
Date:   Sun, 31 Oct 2021 13:41:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Sitting on top of the core block branch due to the polling changes, here
are the io_uring updates for the 5.16-rc1 merge window. Light on new
features (basically just the hybrid mode support), outside of that it's
just fixes, cleanups, and performance improvements. In detail:

- Add ring related information to the fdinfo output (Hao)

- Hybrid async mode (Hao)

- Support for batched issue on block (me)

- sqe error trace improvement (me)

- IOPOLL efficiency improvements (Pavel)

- submit state cleanups and improvements (Pavel)

- Completion side improvements (Pavel)

- Drain improvements (Pavel)

- Buffer selection cleanups (Pavel)

- Fixed file node improvements (Pavel)

- io-wq setup cancelation fix (Pavel)

- Various other performance improvements and cleanups (Pavel)

- Misc fixes (Arnd, Bixuan, Changcheng, Hao, me, Noah)

This will throw two merge conflicts, see below for how I resolved it.
There are two spots, one is trivial, and the other needs
io_queue_linked_timeout() moved into io_queue_sqe_arm_apoll().

Please pull!


The following changes since commit e0d78afeb8d190164a823d5ef5821b0b3802af33:

  block: fix too broad elevator check in blk_mq_free_request() (2021-10-19 05:48:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.16/io_uring-2021-10-29

for you to fetch changes up to 1d5f5ea7cb7d15b9fb1cc82673ebb054f02cd7d2:

  io-wq: remove worker to owner tw dependency (2021-10-29 09:49:33 -0600)

----------------------------------------------------------------
for-5.16/io_uring-2021-10-29

----------------------------------------------------------------
Arnd Bergmann (1):
      io_uring: warning about unused-but-set parameter

Bixuan Cui (1):
      io-wq: Remove duplicate code in io_workqueue_create()

Changcheng Deng (1):
      io_uring: Use ERR_CAST() instead of ERR_PTR(PTR_ERR())

Hao Xu (4):
      io_uring: add more uring info to fdinfo for debug
      io_uring: return boolean value for io_alloc_async_data
      io_uring: split logic of force_nonblock
      io_uring: implement async hybrid mode for pollable requests

Jens Axboe (4):
      io_uring: dump sqe contents if issue fails
      io_uring: inform block layer of how many requests we are submitting
      io_uring: don't assign write hint in the read path
      io_uring: harder fdinfo sq/cq ring iterating

Noah Goldstein (1):
      fs/io_uring: Prioritise checking faster conditions first in io_write

Pavel Begunkov (85):
      io_uring: kill off ios_left
      io_uring: inline io_dismantle_req
      io_uring: inline linked part of io_req_find_next
      io_uring: dedup CQE flushing non-empty checks
      io_uring: kill extra wake_up_process in tw add
      io_uring: remove ctx referencing from complete_post
      io_uring: optimise io_req_init() sqe flags checks
      io_uring: mark having different creds unlikely
      io_uring: force_nonspin
      io_uring: make io_do_iopoll return number of reqs
      io_uring: use slist for completion batching
      io_uring: remove allocation cache array
      io-wq: add io_wq_work_node based stack
      io_uring: replace list with stack for req caches
      io_uring: split iopoll loop
      io_uring: use single linked list for iopoll
      io_uring: add a helper for batch free
      io_uring: convert iopoll_completed to store_release
      io_uring: optimise batch completion
      io_uring: inline completion batching helpers
      io_uring: don't pass tail into io_free_batch_list
      io_uring: don't pass state to io_submit_state_end
      io_uring: deduplicate io_queue_sqe() call sites
      io_uring: remove drain_active check from hot path
      io_uring: split slow path from io_queue_sqe
      io_uring: inline hot path of __io_queue_sqe()
      io_uring: reshuffle queue_sqe completion handling
      io_uring: restructure submit sqes to_submit checks
      io_uring: kill off ->inflight_entry field
      io_uring: comment why inline complete calls io_clean_op()
      io_uring: disable draining earlier
      io_uring: extra a helper for drain init
      io_uring: don't return from io_drain_req()
      io_uring: init opcode in io_init_req()
      io_uring: clean up buffer select
      io_uring: add flag to not fail link after timeout
      io_uring: optimise kiocb layout
      io_uring: add more likely/unlikely() annotations
      io_uring: delay req queueing into compl-batch list
      io_uring: optimise request allocation
      io_uring: optimise INIT_WQ_LIST
      io_uring: don't wake sqpoll in io_cqring_ev_posted
      io_uring: merge CQ and poll waitqueues
      io_uring: optimise ctx referencing by requests
      io_uring: mark cold functions
      io_uring: optimise io_free_batch_list()
      io_uring: control ->async_data with a REQ_F flag
      io_uring: remove struct io_completion
      io_uring: inline io_req_needs_clean()
      io_uring: inline io_poll_complete
      io_uring: correct fill events helpers types
      io_uring: optimise plugging
      io_uring: safer fallback_work free
      io_uring: reshuffle io_submit_state bits
      io_uring: optimise out req->opcode reloading
      io_uring: remove extra io_ring_exit_work wake up
      io_uring: fix io_free_batch_list races
      io_uring: optimise io_req_set_rsrc_node()
      io_uring: optimise rsrc referencing
      io_uring: consistent typing for issue_flags
      io_uring: prioritise read success path over fails
      io_uring: optimise rw comletion handlers
      io_uring: encapsulate rw state
      io_uring: optimise read/write iov state storing
      io_uring: optimise io_import_iovec nonblock passing
      io_uring: clean up io_import_iovec
      io_uring: rearrange io_read()/write()
      io_uring: optimise req->ctx reloads
      io_uring: kill io_wq_current_is_worker() in iopoll
      io_uring: optimise io_import_iovec fixed path
      io_uring: return iovec from __io_import_iovec
      io_uring: optimise fixed rw rsrc node setting
      io_uring: clean io_prep_rw()
      io_uring: arm poll for non-nowait files
      io_uring: combine REQ_F_NOWAIT_{READ,WRITE} flags
      io_uring: simplify io_file_supports_nowait()
      io-wq: use helper for worker refcounting
      io_uring: clean io_wq_submit_work()'s main loop
      io_uring: clean iowq submit work cancellation
      io_uring: check if opcode needs poll first on arming
      io_uring: don't try io-wq polling if not supported
      io_uring: clean up timeout async_data allocation
      io_uring: kill unused param from io_file_supports_nowait
      io_uring: clusterise ki_flags access in rw_prep
      io-wq: remove worker to owner tw dependency

 fs/io-wq.c                      |   58 +-
 fs/io-wq.h                      |   59 +-
 fs/io_uring.c                   | 1714 ++++++++++++++++++++-------------------
 include/trace/events/io_uring.h |   61 ++
 include/uapi/linux/io_uring.h   |    1 +
 5 files changed, 1045 insertions(+), 848 deletions(-)


diff --cc fs/io_uring.c
index 5c11b8442743,c887e4e19e9e..5d7234363b9f
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@@ -6945,7 -6906,33 +6903,33 @@@ static void io_queue_linked_timeout(str
  	io_put_req(req);
  }
  
- static void __io_queue_sqe(struct io_kiocb *req)
+ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
+ 	__must_hold(&req->ctx->uring_lock)
+ {
+ 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
+ 
+ 	switch (io_arm_poll_handler(req)) {
+ 	case IO_APOLL_READY:
+ 		if (linked_timeout) {
 -			io_unprep_linked_timeout(req);
++			io_queue_linked_timeout(linked_timeout);
+ 			linked_timeout = NULL;
+ 		}
+ 		io_req_task_queue(req);
+ 		break;
+ 	case IO_APOLL_ABORTED:
+ 		/*
+ 		 * Queued up for async execution, worker will release
+ 		 * submit reference when the iocb is actually submitted.
+ 		 */
+ 		io_queue_async_work(req, NULL);
+ 		break;
+ 	}
+ 
+ 	if (linked_timeout)
+ 		io_queue_linked_timeout(linked_timeout);
+ }
+ 
+ static inline void __io_queue_sqe(struct io_kiocb *req)
  	__must_hold(&req->ctx->uring_lock)
  {
  	struct io_kiocb *linked_timeout;
@@@ -10645,11 -10697,9 +10703,11 @@@ static __cold int io_unregister_iowq_af
  	return io_wq_cpu_affinity(tctx->io_wq, NULL);
  }
  
- static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
- 					void __user *arg)
+ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
+ 					       void __user *arg)
 +	__must_hold(&ctx->uring_lock)
  {
 +	struct io_tctx_node *node;
  	struct io_uring_task *tctx = NULL;
  	struct io_sq_data *sqd = NULL;
  	__u32 new_count[2];

-- 
Jens Axboe

