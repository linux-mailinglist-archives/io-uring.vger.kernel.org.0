Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5A3B93DB
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhGAP1Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 11:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhGAP1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 11:27:16 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B2FC061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 08:24:46 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 22so7652713oix.10
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 08:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qWaJJE5+MU4VkiWNfPKUoOfBbLRWtxFhVowk7Rfi0Bw=;
        b=VGMV8LxtffbMOHvCn0kVy9cwfovIO1t/YgKjpOvK3gmX3bUsE/q6W0vQ/Qja+0JheR
         LXh35IbqtfI2KrZhMmttuaCFJPtmE7oCnRVEmePNXN1o6d1aX7Vc6OqXvQd8F/8FiO75
         VXlnBMlLvsy+74tvMd1iziCXl5AkGWMoYGsZK9m/y1k3VICebCzgiXO4gj1j/1vV66JL
         T+lFckacdNCaPu3h/xjJIOfZ/FQIfFPAyXx4ay+8FFzHl9ikefaBQ1BSCHte48rBHx/M
         99tG87T54PP4uL2rQQlS/4l81uMWv6WZN+BGbZXc1KB1oGEDSSZoXVNkV499iU42C0DW
         PVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qWaJJE5+MU4VkiWNfPKUoOfBbLRWtxFhVowk7Rfi0Bw=;
        b=TOZ1dIE+xUMw/2YzJj/KBDE8P0s5UsOS2Y8ht5G2nl1wPv7etAZC/FDH4wSy3e4nF7
         Z6I9PeBnA4RDr/h48xiVmUwrDIsyRU7Iza8gxkbZIHLQzO2bvZ1UgiCaSYfE0FKGkiLa
         G0cTdRy2LFDOronSZQSdgKMd6q24sM5D3VmaHw1OmYeBBUwofzYP8sq9xrvNkKm5yvKW
         6bQWnY2tdXCA+dmj56YC+NPg5INub/YeHSio/ue7SXw8P09ViwNdjdco2FwClpGpafG+
         9MzgA5j/Iul8LIDBsLlmHjKBhQE4nFA+N2JdSziVxM1XJxSFuoQeuHsK/wCph9XrENLu
         uAAQ==
X-Gm-Message-State: AOAM532DFI5Aqccuq6q1HcG9tb2dprJ6hQ9Kcoodxtth0G9Ya85itu3h
        NGHQ18O/M+kTuwCJUrDt3b/QbxwYjAfPXg==
X-Google-Smtp-Source: ABdhPJx3/TlZ7wMHGT6hxnJHojVzhdmrCjvHFk4w//XyxZauQDG9T/cFcLPOYimLh6PUMz14SJd2pw==
X-Received: by 2002:aca:6207:: with SMTP id w7mr1419459oib.177.1625153085176;
        Thu, 01 Jul 2021 08:24:45 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id e29sm45537oiy.53.2021.07.01.08.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 08:24:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <54ce324e-ef03-4f00-ab95-95e3e047f4b0@kernel.dk>
Date:   Thu, 1 Jul 2021 09:24:44 -0600
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
window. Identical to the pull request sent the other day, just with the
vfs changes dropped, and hence the io_uring mkdirat, symlinkat, and
linkat removed as well.

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

  git://git.kernel.dk/linux-block.git tags/for-5.14/io_uring-2021-06-30

for you to fetch changes up to e149bd742b2db6a63fc078b1ea6843dc9b22678d:

  io_uring: code clean for kiocb_done() (2021-06-30 14:15:40 -0600)

----------------------------------------------------------------
for-5.14/io_uring-2021-06-30

----------------------------------------------------------------
Colin Ian King (2):
      io_uring: Fix incorrect sizeof operator for copy_from_user call
      io-wq: remove redundant initialization of variable ret

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

 fs/io-wq.c                      |  103 ++-
 fs/io-wq.h                      |    3 +-
 fs/io_uring.c                   | 1324 +++++++++++++++++++++------------------
 include/trace/events/io_uring.h |  106 ++--
 include/uapi/linux/io_uring.h   |   28 +-
 5 files changed, 874 insertions(+), 690 deletions(-)

-- 
Jens Axboe

