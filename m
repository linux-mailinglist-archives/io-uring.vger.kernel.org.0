Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6583FB88D
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhH3OyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 10:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhH3OyF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 10:54:05 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731E3C061575
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:53:11 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id b7so20268136iob.4
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gOUs+rGbrqrVJBhDzQ6Y4AbTHhyr0tdperH7D33kndk=;
        b=vvlDFIkyUCkmjKf4pJCx4CaZeJ+VykjxrE+h9wZz36SQx30Js5+jEx20qm0qb+Kgky
         +4dg3Nion7xouqPygjB1AFugK0Ycqk7adKoV/DtuJXAkabCowSN61EWNcveEZqsW18ek
         npTxMXRDqKE50FffRtl+Hz7blQ/3n9tiyluhhi9MV95MVbp27i6hbvH/kArVirCveq98
         x66y/eZjXzRCdgvW4Ea98ZQZObxo2R0IR/krC3J6L9wo91H/mNakmY8KGeNxbQLdRRDl
         1EcDaZAlcoBs2ClH3uPUXQb0+mGYWQlm/pC8/Z9StiPz9sA6EQJP9wOTUcUXStkdSqdy
         tpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gOUs+rGbrqrVJBhDzQ6Y4AbTHhyr0tdperH7D33kndk=;
        b=kynwXMTV9Jn7Sf0IRD2wgzTAggwpme0eNufCapFHanfzFHguhzA+0iOMPjxtjWxoSl
         UgwyJq6715a4mKY/xUfLVxPZ3HaPxkjExAlQ0IdvukcffXEs43o6WJgxBGnmmttpy8UD
         LCQ00ipURcDOkImtgvGaXyVZRSYy2C8wSajqvnhNu2fyOSG/NWu+d7wwbD9D5ct6qpE2
         11sVSqy1uoHQBBUDdpgRsi99nGIfjJk6zPJXKfZe5R9UzjPUGeEABnEqC73P3zBm+uZA
         kiqts/VKvER4ELRwzQGdMWxB/YWBymnPQC/f43PTQwylI952lGiWiv3nXfUFqxTDVnqG
         yP7g==
X-Gm-Message-State: AOAM5300gPha7641UedhHReimJPezKXonksaMdpR12qRQ49bPj3N51Pc
        EMCPw/DY7wsbipIj5Ra9IMKFYrRXnac4xQ==
X-Google-Smtp-Source: ABdhPJwAk6b8j1S7YsAByavP38FDCAsYgeOTLXUMGHFtvxG/66f7aD3NG9U1F8UmMhVJTbG6j2EF2w==
X-Received: by 2002:a05:6638:14cf:: with SMTP id l15mr7248402jak.8.1630335190281;
        Mon, 30 Aug 2021 07:53:10 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c25sm8685431iom.9.2021.08.30.07.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 07:53:09 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.15-rc1
Message-ID: <9ef2a5e9-7380-7e56-7959-b65859ed8f05@kernel.dk>
Date:   Mon, 30 Aug 2021 08:53:09 -0600
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

io_uring updates for the 5.15 release:

- Cancelation cleanups (Hao, Pavel)

- io-wq accounting cleanup (Hao)

- io_uring submit locking fix (Hao)

- io_uring link handling fixes (Hao)

- Fixed file improvements (wangyangbo, Pavel)

- Allow updates of linked timeouts like regular timeouts (Pavel)

- IOPOLL fix (Pavel)

- Remove batched file get optimization (Pavel)

- Improve reference handling (Pavel)

- IRQ task_work batching (Pavel)

- Allow pure fixed file, and add support for open/accept (Pavel)

- GFP_ATOMIC RT kernel fix

- Multiple CQ ring waiter improvement

- Funnel IRQ completions through task_work

- Add support for limiting async workers explicitly

- Add different clocksource support for timeouts

- io-wq wakeup race fix

- Lots of cleanups and improvement (Pavel et al)

Please pull!


The following changes since commit e22ce8eb631bdc47a4a4ea7ecf4e4ba499db4f93:

  Linux 5.14-rc7 (2021-08-22 14:24:56 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.15/io_uring-2021-08-30

for you to fetch changes up to 87df7fb922d18e96992aa5e824aa34b2065fef59:

  io-wq: fix wakeup race when adding new work (2021-08-30 07:45:47 -0600)

----------------------------------------------------------------
for-5.15/io_uring-2021-08-30

----------------------------------------------------------------
Hao Xu (8):
      io_uring: extract io_uring_files_cancel() in io_uring_task_cancel()
      io_uring: remove files pointer in cancellation functions
      io_uring: code clean for completion_lock in io_arm_poll_handler()
      io-wq: move nr_running and worker_refs out of wqe->lock protection
      io_uring: fix lack of protection for compl_nr
      io_uring: don't free request to slab
      io_uring: remove redundant req_set_fail()
      io_uring: fix failed linkchain code logic

Jens Axboe (14):
      io-wq: remove GFP_ATOMIC allocation off schedule out path
      io_uring: be smarter about waking multiple CQ ring waiters
      io_uring: run timeouts from task_work
      io_uring: run linked timeouts from task_work
      io_uring: run regular file completions from task_work
      io_uring: remove IRQ aspect of io_ring_ctx completion lock
      io_uring: correct __must_hold annotation
      io_uring: add comments on why PF_EXITING checking is safe
      io_uring: add clarifying comment for io_cqring_ev_posted()
      io-wq: provide a way to limit max number of workers
      io_uring: support CLOCK_BOOTTIME/REALTIME for timeouts
      io-wq: check max_worker limits if a worker transitions bound state
      io-wq: wqe and worker locks no longer need to be IRQ safe
      io-wq: fix wakeup race when adding new work

Pavel Begunkov (64):
      io_uring: use kvmalloc for fixed files
      io_uring: inline fixed part of io_file_get()
      io_uring: rename io_file_supports_async()
      io_uring: avoid touching inode in rw prep
      io_uring: clean io-wq callbacks
      io_uring: remove unnecessary PF_EXITING check
      io-wq: improve wq_list_add_tail()
      io_uring: refactor io_alloc_req
      io_uring: don't halt iopoll too early
      io_uring: add more locking annotations for submit
      io_uring: optimise io_cqring_wait() hot path
      io_uring: extract a helper for ctx quiesce
      io_uring: move io_put_task() definition
      io_uring: move io_rsrc_node_alloc() definition
      io_uring: inline io_free_req_deferred
      io_uring: deduplicate open iopoll check
      io_uring: improve ctx hang handling
      io_uring: kill unused IO_IOPOLL_BATCH
      io_uring: drop exec checks from io_req_task_submit
      io_uring: optimise putting task struct
      io_uring: move io_fallback_req_func()
      io_uring: cache __io_free_req()'d requests
      io_uring: remove redundant args from cache_free
      io_uring: use inflight_entry instead of compl.list
      io_uring: inline struct io_comp_state
      io_uring: remove extra argument for overflow flush
      io_uring: inline io_poll_remove_waitqs
      io_uring: clean up tctx_task_work()
      io_uring: remove file batch-get optimisation
      io_uring: move req_ref_get() and friends
      io_uring: remove req_ref_sub_and_test()
      io_uring: remove submission references
      io_uring: skip request refcounting
      io_uring: optimise hot path of ltimeout prep
      io_uring: optimise iowq refcounting
      io_uring: don't inflight-track linked timeouts
      io_uring: optimise initial ltimeout refcounting
      io_uring: kill not necessary resubmit switch
      io_uring: deduplicate cancellation code
      io_uring: kill REQ_F_LTIMEOUT_ACTIVE
      io_uring: simplify io_prep_linked_timeout
      io_uring: cancel not-armed linked touts separately
      io_uring: optimise io_prep_linked_timeout()
      io_uring: better encapsulate buffer select for rw
      io_uring: reuse io_req_complete_post()
      io_uring: improve same wq polling
      io_uring: fix io_timeout_remove locking
      io_uring: extend task put optimisations
      io_uring: limit fixed table size by RLIMIT_NOFILE
      io_uring: place fixed tables under memcg limits
      io_uring: add ->splice_fd_in checks
      io_uring: flush completions for fallbacks
      io_uring: batch task work locking
      io_uring: IRQ rw completion batching
      io_uring: fix io_try_cancel_userdata race for iowq
      net: add accept helper not installing fd
      io_uring: openat directly into fixed fd table
      io_uring: hand code io_accept() fd installing
      io_uring: accept directly into fixed file table
      io_uring: add task-refs-get helper
      io_uring: clarify io_req_task_cancel() locking
      io_uring: add build check for buf_index overflows
      io_uring: keep ltimeouts in a list
      io_uring: allow updating linked timeouts

wangyangbo (1):
      io_uring: Add register support for non-4k PAGE_SIZE

 fs/io-wq.c                    |  208 +++--
 fs/io-wq.h                    |    3 +-
 fs/io_uring.c                 | 1767 ++++++++++++++++++++++++-----------------
 include/linux/io_uring.h      |   11 +-
 include/linux/socket.h        |    3 +
 include/uapi/linux/io_uring.h |   18 +-
 kernel/exit.c                 |    2 +-
 net/socket.c                  |   71 +-
 8 files changed, 1227 insertions(+), 856 deletions(-)

-- 
Jens Axboe

