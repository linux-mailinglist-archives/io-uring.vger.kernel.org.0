Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B864136CB11
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhD0S0k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 14:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhD0S0j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 14:26:39 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAC8C061574
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 11:25:54 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id l19so9738958ilk.13
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 11:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2/hItITOYcnK3NtJcWVpWma4kgz7M2CcwJQjrO04cTY=;
        b=B362Ta2uxsqisp1LtgDLaNXNmdXcN3zaePamZ6lLA+CxXgrCZLL0p9EH+f+/9Vwd+p
         C56CO2IX0OwHPqd0t9J1LnEKCuO2SUGl2bolbbkKj+usMzHy15e/4LxycP7e2/gSDxXD
         a4gKzkPop7FJMA+eg1bUx1JPu6t9Ziz5Sy4YVZ6Qd4l//Z0cLKpLQswd5X1X2Tdhb5nN
         5HyjPVPFsafhSbMDinEY240cAoQT/dpaW8bFWWqd6/aKKIl8ZP4l6uPYtl4kBDL5d++5
         nme+HMJNULgtCRI2Om5ZUBdmfY2OwTWKAGUM9TauAJO6ydQIERVF4e+FK47pnJ13uaQA
         TiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2/hItITOYcnK3NtJcWVpWma4kgz7M2CcwJQjrO04cTY=;
        b=m/P+Lbg1J8+OGqJ7+Y5gZy3YDFpiACHyjSw28N1aGqVCN8bj0JUFsUTAfhWQQLD7xU
         cVJwb4olYlYmjxzkTOr+IYQv6yGokZdgsuNRoUh7rkEEd5LHDeIEEeTCS8/c6fMPlCm3
         KnnTk40NJbhmLfxVHLZn6O8Vr7Jn3zpco8H/xZXATt2hqEqNZVPSxU/Og5YlCMTRhYqN
         s9eoyWOJKxFbd0lQ08hB5AxfUhN6SIQFP88IpG6VZuVAVLvcFF41R1OIJ6GowfwmFKfy
         ef8NvoLLdDpWS3rWv3FCxab2KgKqwl+mbPrGKZfGMnJAvpbH9HIyqk1CeIV40PZX3TkZ
         4DWQ==
X-Gm-Message-State: AOAM533fRyUMbt4sunBULa8kuMmuPsOVn26pNS09yfN0IZj4LG1I+wiD
        q1BR3cTlPmcb60RKajZibCEE7xMTDrAgsA==
X-Google-Smtp-Source: ABdhPJwXb1fBvff6/xvjCen/A/+KAhYt2OEfhZ+/GT/7VWGzaveowRwC4KJR+ErfW4BofOJ9HWRh2g==
X-Received: by 2002:a92:c80e:: with SMTP id v14mr19100374iln.138.1619547953032;
        Tue, 27 Apr 2021 11:25:53 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v7sm1683458ilo.25.2021.04.27.11.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 11:25:52 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring changes for 5.13-rc
Message-ID: <2f9d2015-5897-1b6e-1d23-c210fef4ff77@kernel.dk>
Date:   Tue, 27 Apr 2021 12:25:51 -0600
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

Here are the io_uring changes queued up for 5.13. This pull request
contains:

- Support for multi-shot mode for POLL requests

- More efficient reference counting. This is shamelessly stolen from
  the mm side. Even though referencing is mostly single/dual user, the
  128 count was retained to keep the code the same. Maybe this
  should/could be made generic at some point.

- Removal of the need to have a manager thread for each ring. The manager
  threads only job was checking and creating new io-threads as needed,
  instead we handle this from the queue path.

- Allow SQPOLL without CAP_SYS_ADMIN or CAP_SYS_NICE. Since 5.12, this
  thread is "just" a regular application thread, so no need to restrict
  use of it anymore.

- Cleanup of how internal async poll data lifetime is managed.

- Fix for syzbot reported crash on SQPOLL cancelation.

- Make buffer registration more like file registrations, which includes
  flexibility in avoiding full set unregistration and re-registration.

- Fix for io-wq affinity setting.

- Be a bit more defensive in task->pf_io_worker setup.

- Various SQPOLL fixes.

- Cleanup of SQPOLL creds handling.

- Improvements to in-flight request tracking.

- File registration cleanups.

- Tons of cleanups and little fixes

Please pull!


The following changes since commit d434405aaab7d0ebc516b68a8fc4100922d7f5ef:

  Linux 5.12-rc7 (2021-04-11 15:16:13 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.13/io_uring-2021-04-27

for you to fetch changes up to 7b289c38335ec7bebe45ed31137d596c808e23ac:

  io_uring: maintain drain logic for multishot poll requests (2021-04-27 07:38:58 -0600)

----------------------------------------------------------------
for-5.13/io_uring-2021-04-27

----------------------------------------------------------------
Bijan Mottahedeh (1):
      io_uring: implement fixed buffers registration similar to fixed files

Colin Ian King (1):
      io_uring: Fix uninitialized variable up.resv

Hao Xu (4):
      io-wq: simplify code in __io_worker_busy()
      io_uring: check sqring and iopoll_list before shedule
      io_uring: update sq_thread_idle after ctx deleted
      io_uring: maintain drain logic for multishot poll requests

Jens Axboe (26):
      io_uring: wrap io_kiocb reference count manipulation in helpers
      io_uring: switch to atomic_t for io_kiocb reference count
      io_uring: don't check for io_uring_fops for fixed files
      io_uring: cache async and regular file state for fixed files
      io_uring: correct comment on poll vs iopoll
      io_uring: transform ret == 0 for poll cancelation completions
      io_uring: mask in error/nval/hangup consistently for poll
      io_uring: include cflags in completion trace event
      io_uring: add multishot mode for IORING_OP_POLL_ADD
      io_uring: abstract out helper for removing poll waitqs/hashes
      io_uring: terminate multishot poll for CQ ring overflow
      io_uring: abstract out a io_poll_find_helper()
      io_uring: allow events and user_data update of running poll requests
      kernel: allow fork with TIF_NOTIFY_SIGNAL pending
      io-wq: eliminate the need for a manager thread
      io_uring: allow SQPOLL without CAP_SYS_ADMIN or CAP_SYS_NICE
      io_uring: fix race around poll update and poll triggering
      task_work: add helper for more targeted task_work canceling
      io-wq: cancel task_work on exit only targeting the current 'wq'
      io_uring: don't attempt re-add of multishot poll request if racing
      io_uring: provide io_resubmit_prep() stub for !CONFIG_BLOCK
      io_uring: disable multishot poll for double poll add cases
      io_uring: put flag checking for needing req cleanup in one spot
      io_uring: tie req->apoll to request lifetime
      io_uring: fix merge error for async resubmit
      io-wq: remove unused io_wqe_need_worker() function

Palash Oswal (1):
      io_uring: Check current->io_uring in io_uring_cancel_sqpoll

Pavel Begunkov (120):
      io_uring: avoid taking ctx refs for task-cancel
      io_uring: reuse io_req_task_queue_fail()
      io_uring: further deduplicate file slot selection
      io_uring: add a helper failing not issued requests
      io_uring: refactor provide/remove buffer locking
      io_uring: use better types for cflags
      io_uring: refactor out send/recv async setup
      io_uring: untie alloc_async_data and needs_async_data
      io_uring: rethink def->needs_async_data
      io_uring: merge defer_prep() and prep_async()
      io_uring: simplify io_resubmit_prep()
      io_uring: simplify io_sqd_update_thread_idle()
      io_uring: don't take ctx refs in task_work handler
      io_uring: optimise io_uring_enter()
      io_uring: optimise tctx node checks/alloc
      io_uring: keep io_req_free_batch() call locality
      io_uring: inline __io_queue_linked_timeout()
      io_uring: optimise success case of __io_queue_sqe
      io_uring: refactor io_flush_cached_reqs()
      io_uring: refactor rsrc refnode allocation
      io_uring: inline io_put_req and friends
      io_uring: refactor io_free_req_deferred()
      io_uring: add helper flushing locked_free_list
      io_uring: remove __io_req_task_cancel()
      io_uring: inline io_clean_op()'s fast path
      io_uring: optimise io_dismantle_req() fast path
      io_uring: abolish old io_put_file()
      io_uring: optimise io_req_task_work_add()
      io_uring: don't clear REQ_F_LINK_TIMEOUT
      io_uring: don't do extra EXITING cancellations
      io_uring: remove tctx->sqpoll
      io-wq: refactor *_get_acct()
      io_uring: don't init req->work fully in advance
      io_uring: kill unused REQ_F_NO_FILE_TABLE
      io_uring: optimise kiocb_end_write for !ISREG
      io_uring: don't alter iopoll reissue fail ret code
      io_uring: hide iter revert in resubmit_prep
      io_uring: optimise rw complete error handling
      io_uring: allocate memory for overflowed CQEs
      io_uring: reg buffer overflow checks hardening
      io_uring: name rsrc bits consistently
      io_uring: simplify io_rsrc_node_ref_zero
      io_uring: use rsrc prealloc infra for files reg
      io_uring: encapsulate rsrc node manipulations
      io_uring: move rsrc_put callback into io_rsrc_data
      io_uring: refactor io_queue_rsrc_removal()
      io_uring: ctx-wide rsrc nodes
      io_uring: reuse io_rsrc_node_destroy()
      io_uring: remove useless is_dying check on quiesce
      io_uring: combine lock/unlock sections on exit
      io_uring: better ref handling in poll_remove_one
      io_uring: remove unused hash_wait
      io_uring: refactor io_async_cancel()
      io_uring: improve import_fixed overflow checks
      io_uring: store reg buffer end instead of length
      io_uring: kill unused forward decls
      io_uring: lock annotate timeouts and poll
      io_uring: simplify overflow handling
      io_uring: put link timeout req consistently
      io_uring: deduplicate NOSIGNAL setting
      io_uring: set proper FFS* flags on reg file update
      io_uring: don't quiesce intial files register
      io_uring: refactor file tables alloc/free
      io_uring: encapsulate fixed files into struct
      io_uring: kill outdated comment about splice punt
      io_uring: clean up io_poll_task_func()
      io_uring: refactor io_poll_complete()
      io_uring: simplify apoll hash removal
      io_uring: unify task and files cancel loops
      io_uring: track inflight requests through counter
      io_uring: unify files and task cancel
      io_uring: refactor io_close
      io_uring: enable inline completion for more cases
      io_uring: refactor compat_msghdr import
      io_uring: optimise non-eventfd post-event
      io_uring: always pass cflags into fill_event()
      io_uring: optimise fill_event() by inlining
      io_uring: simplify io_rsrc_data refcounting
      io_uring: add buffer unmap helper
      io_uring: cleanup buffer register
      io_uring: split file table from rsrc nodes
      io_uring: improve sqo stop
      io_uring: improve hardlink code generation
      io_uring: return back safer resurrect
      io_uring: fix leaking reg files on exit
      io_uring: fix uninit old data for poll event upd
      io_uring: split poll and poll update structures
      io_uring: add timeout completion_lock annotation
      io_uring: refactor hrtimer_try_to_cancel uses
      io_uring: clean up io_poll_remove_waitqs()
      io_uring: don't fail overflow on in_idle
      io_uring: skip futile iopoll iterations
      io_uring: inline io_iopoll_getevents()
      io_uring: refactor io_ring_exit_work()
      io_uring: fix POLL_REMOVE removing apoll
      io_uring: add helper for parsing poll events
      io_uring: move poll update into remove not add
      io_uring: don't fail submit with overflow backlog
      io_uring: fix overflows checks in provide buffers
      io_uring: check register restriction afore quiesce
      io_uring: remove extra sqpoll submission halting
      io_uring: fix shared sqpoll cancellation hangs
      io_uring: move inflight un-tracking into cleanup
      io_uring: safer sq_creds putting
      io_uring: refactor io_sq_offload_create()
      io_uring: move __io_sqe_files_unregister
      io_uring: return back rsrc data free helper
      io_uring: decouple CQE filling from requests
      io_uring: preparation for rsrc tagging
      io_uring: add generic path for rsrc update
      io_uring: enumerate dynamic resources
      io_uring: add IORING_REGISTER_RSRC
      io_uring: add generic rsrc update with tags
      io_uring: keep table of pointers to ubufs
      io_uring: prepare fixed rw for dynanic buffers
      io_uring: add full-fledged dynamic buffers support
      io_uring: fix invalid error check after malloc
      io_uring: fix work_exit sqpoll cancellations
      io_uring: simplify SQPOLL cancellations
      io_uring: fix NULL reg-buffer

Peter Zijlstra (1):
      io-wq: Fix io_wq_worker_affinity()

Stefan Metzmacher (2):
      kernel: always initialize task->pf_io_worker to NULL
      io_uring: io_sq_thread() no longer needs to reset current->pf_io_worker

 fs/io-wq.c                      |  336 +++--
 fs/io-wq.h                      |    1 +
 fs/io_uring.c                   | 2612 +++++++++++++++++++++------------------
 include/linux/io_uring.h        |   12 +-
 include/linux/task_work.h       |    2 +
 include/trace/events/io_uring.h |   11 +-
 include/uapi/linux/io_uring.h   |   40 +
 kernel/fork.c                   |    3 +-
 kernel/task_work.c              |   35 +-
 9 files changed, 1599 insertions(+), 1453 deletions(-)

-- 
Jens Axboe

