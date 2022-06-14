Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC254B11F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiFNMdp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243039AbiFNMdR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1974349B
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h19so7844054wrc.12
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=obSQQwk17/90WPMZCevKKqsKigOTbYBa/LrnwI3FmBU=;
        b=YcPryrhOIyTKgNVkPSz0LIMX7aI8wjALAuZIh10qGvmLFjBXRRMOdtg2s40eQ25/nw
         QM2EfxPX7kIxoi7ifPxee9db2Tme79F2QveAuq34QtC3zrdqtYDIYDEvYv2MJ0U0nqgB
         0m7kfluvAvgmvVR6Jz92O6YtDOsd7jJ7tvHhl2BpqeOYSr70bshpejDpGpfMTs7Pz/+5
         XLJO0mYzAkjcO5BTn2FgYoA3g5uAq/bVxgQuwB6SYxPFhjqZVkizpf+z0a2L47kVrlv6
         4nhm+lmQd1H3RzyWAQdXvKoA7U0VDISewzyNKqBU6Ko8tz2KdkQQYoEFmF/p6FNavRzI
         V9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=obSQQwk17/90WPMZCevKKqsKigOTbYBa/LrnwI3FmBU=;
        b=Z4uXscBslIqNID+FY3RgkR7VZzoYmAlDWA+Qf8bZefZVn3aXnH3gWhu6eN9aZ8Eehg
         kHupwTQu+6B3CoofznLu2Ui1fj6Q97OKMVQdGPwNdf9784OvkVy+Ws+zna8QxgR9bSYo
         cQhpjV2lK5lkWO6+duNP6RXbGzhDDCkNOrL3RowU60pNvL+m5hVj/mCC6cDIjUD7NT7y
         nQZFZOEs+dnsZZmsJmzqo7/kBe5eA9Ir5ugy3gNK7jCJ4tbVCsbru83j3ZCnxlB333XY
         ndMn+pN9x+5oLk1yvQREJUnJ/nvpcXjfQR1Uc4H3YhsOSzpH8lKK4iLp9pj8JtajHXzj
         BTcw==
X-Gm-Message-State: AJIora/cbihoUZLGumcBmKi8jwUDkbgePhD6ndJzwhc0xVxbevZj6kbM
        Aiym2WAakYNkRY76rhrpMTYhp6TJwnpuSA==
X-Google-Smtp-Source: AGRyM1vST7akFz5JBHdJ5gxH4mFAYfTsgQGBsvX25szb8eD8+9V2WldlGsL3J3uayL427spGgJyqRQ==
X-Received: by 2002:a05:6000:1789:b0:219:2aa8:7159 with SMTP id e9-20020a056000178900b002192aa87159mr4684755wrg.474.1655209834384;
        Tue, 14 Jun 2022 05:30:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 00/25] 5.20 cleanups and poll optimisations
Date:   Tue, 14 Jun 2022 13:29:38 +0100
Message-Id: <cover.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-13 are cleanups after splitting io_uring into files.

Patch 14 from Hao should remove some overhead from poll requests

Patch 15 from Hao adds per-bucket spinlocks, and 16-19 do a little
bit of cleanup. The downside of per-bucket spinlocks is that it adds
additional spinlock/unlock pair in the poll request completion side,
which shouldn't matter much with 20/25.

Patch 20 uses inline completion infra for poll requests, this nicely
improves perf when there is a good tw batching.

Patch 21 implements the userspace visible side of
IORING_SETUP_SINGLE_ISSUER, it'll be used for poll requests and
later for spinlock optimisations.

22-25 introduces ->uring_lock protected cancellation hashing. It
requires us to grab ->uring_lock in the completion side, but saves
two spin lock/unlock pairs. We apply it automatically in cases the
mutex is already likely to be held (see 25/25 description), so there
is no additional mutex overhead and potential latency problemes.


Numbers:

I used a simple poll benchmark temporarily stored at [1], which
each iteration queues a batch of 32 POLLIN poll requests and triggers
all of them with read (+write).

baseline (patches 1-18):
    11720 K req/s
base + 19 (+ inline completion infra)
    12419 K req/s, ~+6%
base + 19-25 (+ uring_lock hashing):
    12804 K req/s, +9.2% from the baseline, or +3.2% relative to patch 19.

[1] https://github.com/isilence/liburing/tree/poll-bench

Hao Xu (2):
  io_uring: poll: remove unnecessary req->ref set
  io_uring: switch cancel_hash to use per entry spinlock

Pavel Begunkov (23):
  io_uring: make reg buf init consistent
  io_uring: move defer_list to slow data
  io_uring: better caching for ctx timeout fields
  io_uring: refactor ctx slow data placement
  io_uring: move cancel_seq out of io-wq
  io_uring: move small helpers to headers
  io_uring: inline ->registered_rings
  io_uring: don't set REQ_F_COMPLETE_INLINE in tw
  io_uring: never defer-complete multi-apoll
  io_uring: kill REQ_F_COMPLETE_INLINE
  io_uring: refactor io_req_task_complete()
  io_uring: don't inline io_put_kbuf
  io_uring: remove check_cq checking from hot paths
  io_uring: pass poll_find lock back
  io_uring: clean up io_try_cancel
  io_uring: limit number hash buckets
  io_uring: clean up io_ring_ctx_alloc
  io_uring: use state completion infra for poll reqs
  io_uring: add IORING_SETUP_SINGLE_ISSUER
  io_uring: pass hash table into poll_find
  io_uring: introduce a struct for hash table
  io_uring: propagate locking state to poll cancel
  io_uring: mutex locked poll hashing

 include/uapi/linux/io_uring.h |   5 +-
 io_uring/cancel.c             |  27 ++--
 io_uring/cancel.h             |   4 +-
 io_uring/fdinfo.c             |  11 +-
 io_uring/io-wq.h              |   1 -
 io_uring/io_uring.c           | 149 +++++++++++-----------
 io_uring/io_uring.h           |  17 +++
 io_uring/io_uring_types.h     | 109 +++++++++-------
 io_uring/kbuf.c               |  33 +++++
 io_uring/kbuf.h               |  38 +-----
 io_uring/poll.c               | 229 ++++++++++++++++++++++++----------
 io_uring/poll.h               |   3 +-
 io_uring/rsrc.c               |   9 +-
 io_uring/tctx.c               |  34 +++--
 io_uring/tctx.h               |   7 +-
 io_uring/timeout.c            |   7 +-
 16 files changed, 426 insertions(+), 257 deletions(-)

-- 
2.36.1

