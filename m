Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F48932F22A
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 19:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCESJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 13:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhCESJM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 13:09:12 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BFFC061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 10:09:12 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id d5so2823730iln.6
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 10:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZL6W1Fo5kYU2PCLKx/eyUBe9dLZ15sotw0fTb9lJHv4=;
        b=aA3yvlLvochquCirQs+Mq5dTwjSToWVu5c8w40NadHgL/JAKhrRg0xofD6TIir3WRv
         Z+i0HtIWMyrlvm1sImjsANFiFLCPyiGlFIgvGaFdAyfrBJY8xa+BWf2NZBRH7pIRUdOg
         DYKoMVCmVyMaopoatkLue7a4NzsnZ/9gfk/gfraH3xtjHmwO22hGj6kHklCu15TecSPZ
         tJ5LUJlnFKSsi/lDaf7hgwyAHsVDCLA7sYNj9FQmkTXwwj7R3KhJzAuN5P01npokLcZc
         jhsS66HocE2fdzox3uifr9DhnC89yF2OOVNIzyggQGsI66xSE+9B2fQ1/9TzMt46JTFO
         rbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZL6W1Fo5kYU2PCLKx/eyUBe9dLZ15sotw0fTb9lJHv4=;
        b=PB68hUvSBYgxllwP7BUZztAMcyUanBmBv1g2JPaSkFbJXO04Z9wcnKRJhSOT/iZqY/
         gEiDsOj/b7fmWXVO0QVUJYfyudPCtaDyBXhta1ANqnoBDx8I9ZEDiAmhBeqBzfL3Dkug
         393V8b4QeOmpi2jpz6CcX7d4iP2soQdsT7T2q3nF8o9YQT0ykPVp4qUIn3342PppEolG
         q+s+/DnQorXa2ceWjU2ubWiI9VZRB/NIwoQUMnoCNeJOAq3HZSabJOsEOa3RZFxQOYJQ
         hwtkW+7ZY2NoRxw4t52Cqm+oosbfpFDh+20si3Oi7NdMCdZ6tO+EG9dUN6RqLL6IJBcy
         Ud/Q==
X-Gm-Message-State: AOAM532Xx1SfjP2Rw50lYSkcasnrxiVND/2oKZf02eKbJ6C8VF0rQSd7
        /m7tLs1lHRNdlLmp4O0w6M8xBwwRfb4slA==
X-Google-Smtp-Source: ABdhPJx5gWdpNvgZQJJTy3Mv5hZvf+kROxa+iCZZuC7Xx1zdeFwbvfH2WKjk+WMILNI72xdpIAnuHA==
X-Received: by 2002:a92:ce03:: with SMTP id b3mr10162782ilo.302.1614967750467;
        Fri, 05 Mar 2021 10:09:10 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q15sm1690333ilt.30.2021.03.05.10.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 10:09:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
Date:   Fri, 5 Mar 2021 11:09:09 -0700
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

A bit of a mix between fallout from the worker change,
cleanups/reductions now possible from that change, and fixes in general.
In detail:

- Fully serialize manager and worker creation, fixing races due to that.

- Clean up some naming that had gone stale.

- SQPOLL fixes.

- Fix race condition around task_work rework that went into this merge
  window.

- Implement unshare. Used for when the original task does unshare(2) or
  setuid/seteuid and friends, drops the original workers and forks new
  ones.

- Drop the only remaining piece of state shuffling we had left, which
  was cred. Move it into issue instead, and we can drop all of that code
  too.

- Kill f_op->flush() usage. That was such a nasty hack that we had out
  of necessity, we no longer need it.

- Following from ->flush() removal, we can also drop various bits of ctx
  state related to SQPOLL and cancelations.

- Fix an issue with IOPOLL retry, which originally was fallout from a
  filemap change (removing iov_iter_revert()), but uncovered an issue
  with iovec re-import too late.

- Fix an issue with system suspend.

- Use xchg() for fallback work, instead of cmpxchg().

- Properly destroy io-wq on exec.

- Add create_io_thread() core helper, and use that in io-wq and
  io_uring. This allows us to remove various silly completion events
  related to thread setup.

- A few error handling fixes.

This should be the grunt of fixes necessary for the new workers, next
week should be quieter. We've got a pending series from Pavel on
cancelations, and how tasks and rings are indexed. Outside of that,
should just be minor fixes. Even with these fixes, we're still killing a
net ~80 lines.

Please pull!


The following changes since commit fe07bfda2fb9cdef8a4d4008a409bb02f35f1bd8:

  Linux 5.12-rc1 (2021-02-28 16:05:19 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-05

for you to fetch changes up to e45cff58858883290c98f65d409839a7295c95f3:

  io_uring: don't restrict issue_flags for io_openat (2021-03-05 09:52:29 -0700)

----------------------------------------------------------------
io_uring-5.12-2021-03-05

----------------------------------------------------------------
Jens Axboe (27):
      io-wq: wait for worker startup when forking a new one
      io-wq: have manager wait for all workers to exit
      io-wq: don't ask for a new worker if we're exiting
      io-wq: rename wq->done completion to wq->started
      io-wq: wait for manager exit on wq destroy
      io-wq: fix double put of 'wq' in error path
      io_uring: SQPOLL stop error handling fixes
      io_uring: don't use complete_all() on SQPOLL thread exit
      io-wq: provide an io_wq_put_and_exit() helper
      io_uring: fix race condition in task_work add and clear
      io_uring: remove unused argument 'tsk' from io_req_caches_free()
      io_uring: kill unnecessary REQ_F_WORK_INITIALIZED checks
      io_uring: move cred assignment into io_issue_sqe()
      io_uring: kill unnecessary io_run_ctx_fallback() in io_ring_exit_work()
      io_uring: kill io_uring_flush()
      io_uring: ensure that SQPOLL thread is started for exit
      io_uring: ignore double poll add on the same waitqueue head
      io-wq: fix error path leak of buffered write hash map
      io_uring: fix -EAGAIN retry with IOPOLL
      io_uring: ensure that threads freeze on suspend
      io-wq: ensure all pending work is canceled on exit
      kernel: provide create_io_thread() helper
      io_uring: move to using create_io_thread()
      io_uring: don't keep looping for more events if we can't flush overflow
      io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return
      io-wq: kill hashed waitqueue before manager exits
      io_uring: make SQPOLL thread parking saner

Pavel Begunkov (14):
      io_uring: run fallback on cancellation
      io_uring: warn on not destroyed io-wq
      io_uring: destroy io-wq on exec
      io_uring: fix __tctx_task_work() ctx race
      io_uring: replace cmpxchg in fallback with xchg
      io_uring: kill sqo_dead and sqo submission halting
      io_uring: remove sqo_task
      io_uring: choose right tctx->io_wq for try cancel
      io_uring: inline io_req_clean_work()
      io_uring: inline __io_queue_async_work()
      io_uring: remove extra in_idle wake up
      io_uring: cancel-match based on flags
      io_uring: reliably cancel linked timeouts
      io_uring: don't restrict issue_flags for io_openat

 fs/io-wq.c                 | 261 +++++++++++------------
 fs/io-wq.h                 |   5 +-
 fs/io_uring.c              | 500 +++++++++++++++++++--------------------------
 include/linux/io_uring.h   |   2 +-
 include/linux/sched/task.h |   2 +
 kernel/fork.c              |  30 +++
 6 files changed, 361 insertions(+), 439 deletions(-)

-- 
Jens Axboe

