Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB183B7980
	for <lists+io-uring@lfdr.de>; Tue, 29 Jun 2021 22:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhF2Up7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Jun 2021 16:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhF2Up7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Jun 2021 16:45:59 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6CCC061760
        for <io-uring@vger.kernel.org>; Tue, 29 Jun 2021 13:43:31 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a6so431913ioe.0
        for <io-uring@vger.kernel.org>; Tue, 29 Jun 2021 13:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=T3Nr1gmSopsyb/Xl8iGjxyFV34gbuvdUsatD3zeSa40=;
        b=FRySpK0Q8qVtrcnYqUAjzhvsYVdqmSOkZCMZDPfO2WFFZzynHOgMzs7JFTpSCp4cMJ
         9AUcGqwVZx1QR6iT2N4aXNpyGZlgxK4dWLpu5JREHyGH38jyO1lKDz4rB0wK1cJhrqjY
         /+sT7q4fOsoY2GoyDpSUtNrvHnwUzXKEYZ4BOgcKyny9zMaFqGHpEQZsfW9w40A2pcC+
         nxMnEdG0myVJkb2Lex0nqPS2KOsRWq1gMj1bMCJxsOJ9IVkhBQ4xb258HaGPV1vXXC+A
         HCYL4yJHCt/SVFrKRGLMgSeFTgoIEOnB+ybogt/V/3Qp0sw49zvilXoBD9+USD33+WgV
         POrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=T3Nr1gmSopsyb/Xl8iGjxyFV34gbuvdUsatD3zeSa40=;
        b=rxdELiy0KHatlld+mkNbynmO9QE7u1D3r7Qk2S5NX3VOgNk3iVQT68diuW18VM1cGw
         spUaXUwNix7YBFps3BbLsTu5woe3xIoBZePTkjneYELNpMYO86RLldn1B7M1L1bTx/Ht
         E+YdhowNHDGki+pKaPS8lZQ0fgEp3CgA3GJh6DgnEZnQjfxtlAbQRxuhQRZTUbCB4bD1
         JEOvpVNWVOG6vqgx6lfTO7x5eXruYMAcbdxYm3YPN/kM3NCnClsSbFlOhQoB4g+VVtVv
         Ja1jzVhsQ38t/PCoI9UMSm4mJyS4J0pT1c2As18D7YiuhZ1C6pUtRP0IAtvksWIcfXd/
         24lg==
X-Gm-Message-State: AOAM533zfcWpjw0h9gTGApILBWgIc99rk8N/xFkU3foQqMz2Y63YCUvZ
        QN6cFfqk6TQgkjPyB8FdR7vZtWEvJYBWCw==
X-Google-Smtp-Source: ABdhPJz1gIy2gEsv7joVt2zigu3B9a7Q9ZdK1fH9cY5R2CKCEqhQOFakT93i4Io3jzD94g91jvgG/g==
X-Received: by 2002:a02:818c:: with SMTP id n12mr3743357jag.2.1624999410636;
        Tue, 29 Jun 2021 13:43:30 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id n8sm8320813ioj.13.2021.06.29.13.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 13:43:30 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.14-rc1
Message-ID: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
Date:   Tue, 29 Jun 2021 14:43:29 -0600
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

This pull request contains the io_uring updates for the 5.14-rc1 merge
window. In detail:

- Support for mkdirat, symlinkat, and linkat for io_uring (Dmitry)

- Multi-queue iopoll improvement (Fam)

- Allow configurable io-wq CPU masks (me)

- renameat/linkat tightening (me)

- poll re-arm improvement (Olivier)

- SQPOLL race fix (Olivier)

- Cancelation unification (Pavel)

- SQPOLL cleanups (Pavel)

- Enable file backed buffers for shmem/memfd (Pavel)

- A ton of cleanups and performance improvements (Pavel)

- Followup and misc fixes (Colin, Fam, Hao, Olivier)

Please pull!


The following changes since commit 009c9aa5be652675a06d5211e1640e02bbb1c33d:

  Linux 5.13-rc6 (2021-06-13 14:43:10 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.14/io_uring-2021-06-29

for you to fetch changes up to bdfe4dc5bfddf8f3b4080ac4a11a4c5843cbe928:

  io_uring: code clean for kiocb_done() (2021-06-27 16:22:42 -0600)

----------------------------------------------------------------
for-5.14/io_uring-2021-06-29

----------------------------------------------------------------
Colin Ian King (2):
      io_uring: Fix incorrect sizeof operator for copy_from_user call
      io-wq: remove redundant initialization of variable ret

Dmitry Kadashev (9):
      fs: make do_mkdirat() take struct filename
      io_uring: add support for IORING_OP_MKDIRAT
      fs: make do_mknodat() take struct filename
      fs: make do_symlinkat() take struct filename
      namei: add getname_uflags()
      fs: make do_linkat() take struct filename
      fs: update do_*() helpers to return ints
      io_uring: add support for IORING_OP_SYMLINKAT
      io_uring: add support for IORING_OP_LINKAT

Fam Zheng (1):
      io_uring: Fix comment of io_get_sqe

Hao Xu (2):
      io_uring: spin in iopoll() only when reqs are in a single queue
      io_uring: code clean for kiocb_done()

Jens Axboe (4):
      io-wq: use private CPU mask
      io_uring: allow user configurable IO thread CPU affinity
      io_uring: add IOPOLL and reserved field checks to IORING_OP_RENAMEAT
      io_uring: add IOPOLL and reserved field checks to IORING_OP_UNLINKAT

Olivier Langlois (6):
      io_uring: Add to traces the req pointer when available
      io_uring: minor clean up in trace events definition
      io-wq: remove header files not needed anymore
      io_uring: Fix race condition when sqp thread goes to sleep
      io_uring: Create define to modify a SQPOLL parameter
      io_uring: reduce latency by reissueing the operation

Pavel Begunkov (68):
      io_uring: improve sqpoll event/state handling
      io_uring: improve sq_thread waiting check
      io_uring: remove unused park_task_work
      io_uring: simplify waking sqo_sq_wait
      io_uring: get rid of files in exit cancel
      io_uring: make fail flag not link specific
      io_uring: shuffle rarely used ctx fields
      io_uring: better locality for rsrc fields
      io_uring: remove dependency on ring->sq/cq_entries
      io_uring: deduce cq_mask from cq_entries
      io_uring: kill cached_cq_overflow
      io_uring: rename io_get_cqring
      io_uring: don't bounce submit_state cachelines
      io_uring: enable shmem/memfd memory registration
      io_uring: fix blocking inline submission
      io-wq: embed wqe ptr array into struct io_wq
      io-wq: remove unused io-wq refcounting
      io_uring: refactor io_iopoll_req_issued
      io_uring: rename function *task_file
      io-wq: don't repeat IO_WQ_BIT_EXIT check by worker
      io-wq: simplify worker exiting
      io_uring: hide rsrc tag copy into generic helpers
      io_uring: remove rsrc put work irq save/restore
      io_uring: add helpers for 2 level table alloc
      io_uring: don't vmalloc rsrc tags
      io_uring: cache task struct refs
      io_uring: unify SQPOLL and user task cancellations
      io_uring: inline io_iter_do_read()
      io_uring: keep SQ pointers in a single cacheline
      io_uring: move ctx->flags from SQ cacheline
      io_uring: shuffle more fields into SQ ctx section
      io_uring: refactor io_get_sqe()
      io_uring: don't cache number of dropped SQEs
      io_uring: optimise completion timeout flushing
      io_uring: small io_submit_sqe() optimisation
      io_uring: clean up check_overflow flag
      io_uring: wait heads renaming
      io_uring: move uring_lock location
      io_uring: refactor io_req_defer()
      io_uring: optimise non-drain path
      io_uring: fix min types mismatch in table alloc
      io_uring: switch !DRAIN fast path when possible
      io_uring: shove more drain bits out of hot path
      io_uring: optimise io_commit_cqring()
      io_uring: fix false WARN_ONCE
      io_uring: refactor io_submit_flush_completions()
      io_uring: move creds from io-wq work to io_kiocb
      io_uring: track request creds with a flag
      io_uring: simplify iovec freeing in io_clean_op()
      io_uring: clean all flags in io_clean_op() at once
      io_uring: refactor io_get_sequence()
      io_uring: inline __tctx_task_work()
      io_uring: optimise task_work submit flushing
      io_uring: refactor tctx task_work list splicing
      io_uring: don't resched with empty task_list
      io_uring: improve in tctx_task_work() resubmission
      io_uring: don't change sqpoll creds if not needed
      io_uring: refactor io_sq_thread()
      io_uring: fix code style problems
      io_uring: update sqe layout build checks
      io_uring: simplify struct io_uring_sqe layout
      io_uring: refactor io_openat2()
      io_uring: refactor io_arm_poll_handler()
      io_uring: mainstream sqpoll task_work running
      io_uring: remove not needed PF_EXITING check
      io_uring: optimise hot path restricted checks
      io_uring: refactor io_submit_flush_completions
      io_uring: pre-initialise some of req fields

 fs/exec.c                       |    8 +-
 fs/internal.h                   |    8 +-
 fs/io-wq.c                      |  103 ++-
 fs/io-wq.h                      |    3 +-
 fs/io_uring.c                   | 1524 +++++++++++++++++++++++----------------
 fs/namei.c                      |  137 ++--
 include/linux/fs.h              |    1 +
 include/trace/events/io_uring.h |  106 ++-
 include/uapi/linux/io_uring.h   |   32 +-
 9 files changed, 1177 insertions(+), 745 deletions(-)

-- 
Jens Axboe

