Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21DD54DE11
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358507AbiFPJWq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiFPJWq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:46 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDF811167
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:44 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v14so1047874wra.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNmd1+9exX8vqNoeOAKsnTeV0JM/YxfA4bR6r7fwJCo=;
        b=AqYW+sdA0QfzKwBgpRcEzkYu9iMSLX5incLW3X0uRf3u5ZWMZ9S4gNc1SfzCZm0Hj3
         fT2vEEoMTOcyFRUZnLYraIcB22vGzfMazaV0wwbxw+gZe/86sHxRQE//VV1wv/D2TG4k
         I56penJ2MDR9gNL2pnaprgq18AkV58WVPO3aBYI24QlQHzrqatQOwleP4qwCTjxPL7LC
         hqbzFZAmAbmq74Otfc76IvCYaLU9W1fuDCFHYoQ8yIFOL59ZuP/Jj3azSdl0mT1kC09z
         gjAbFjs6YeVXpUOYf8nEnZJHC7H5yuamrVd2vQmCwk5o/UN8HrwiVlhMoGrH2CMaoD6+
         /0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNmd1+9exX8vqNoeOAKsnTeV0JM/YxfA4bR6r7fwJCo=;
        b=Q0V8Y8lNvI46w+eM9FTNURLPShv6sWNflL/2sm4A4jkkZ2F4tfaakG2jM6aJBEs9Vs
         F2lU4xVyrAMWSC4zrlpg+6D2cgq00xLJbkdMYHkcm7aepfiGL+SAOvvF+g8Q9ooioFrd
         80CLuDMTnl/OcoyHNFA0hsNq8JGnRCDONmekzeynS+vFePTP7NsAqp/UVckCYNRJamMZ
         lRGwSSlnhEVRZOdHBaFMviE+8Vc0u4fgkCpnMa+cVNEAXLS5ghCoAbEEDIpw/ueHU/9r
         EzFOPl4VLQ+S+Fz713MUTTTLVu0rz5wGt9EEwGapJqMSgL7Gvn8f6ml2kqC9LuSFOvgu
         /ZbA==
X-Gm-Message-State: AJIora/i5+mY5BZ1kofeq9REAQYxQd1YtYEO38wCokDpVO0omHNm06SV
        nc/39ilJ8KVpFl0BQxU0hLiEcWaey3pNrg==
X-Google-Smtp-Source: AGRyM1t4BIru6OCEDIq+cG6FSX+GL4ZcDem24gLPIiR/WqXpyrkVe98/A3krz9IUM4x+o4mUs288uw==
X-Received: by 2002:adf:f851:0:b0:21a:3a17:6dbd with SMTP id d17-20020adff851000000b0021a3a176dbdmr361960wrq.155.1655371362742;
        Thu, 16 Jun 2022 02:22:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 00/16] 5.20 cleanups and poll optimisations
Date:   Thu, 16 Jun 2022 10:21:56 +0100
Message-Id: <cover.1655371007.git.asml.silence@gmail.com>
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

1-4 kills REQ_F_COMPLETE_INLINE as we're out of bits.

Patch 5 from Hao should remove some overhead from poll requests

Patch 6 from Hao adds per-bucket spinlocks, and 16-19 do a little
bit of cleanup. The downside of per-bucket spinlocks is that it adds
additional spinlock/unlock pair in the poll request completion side,
which shouldn't matter much with 20/25.

Patch 11 uses inline completion infra for poll requests, this nicely
improves perf when there is a good tw batching.

Patch 12 implements the userspace visible side of
IORING_SETUP_SINGLE_ISSUER, it'll be used for poll requests and
later for spinlock optimisations.

13-16 introduces ->uring_lock protected cancellation hashing. It
requires us to grab ->uring_lock in the completion side, but saves
two spin lock/unlock pairs. We apply it automatically in cases the
mutex is already likely to be held (see 25/25 description), so there
is no additional mutex overhead and potential latency problemes.


Numbers:

The used poll benchmark each iteration queues a batch of 32 POLLIN
poll requests and triggers all of them with read (+write).

baseline (patches 1-10):
    11720 K req/s
base + 11 (+ inline completion infra)
    12419 K req/s, ~+6%
base + 11-16 (+ uring_lock hashing):
    12804 K req/s, +9.2% from the baseline, or +3.2% relative to patch 19.

Note that patch 11 only helps performance of poll-add requests, whenever
16/16 also improves apoll.

v2:
  don't move ->cancel_seq out of iowq work struct
  fix up single-issuer

v3:
  clarify locking expectation around ->uring_lock hashing
  don't complete by hand in io_read/write (see 1/16)

Hao Xu (2):
  io_uring: poll: remove unnecessary req->ref set
  io_uring: switch cancel_hash to use per entry spinlock

Pavel Begunkov (14):
  io_uring: rw: delegate sync completions to core io_uring
  io_uring: kill REQ_F_COMPLETE_INLINE
  io_uring: refactor io_req_task_complete()
  io_uring: don't inline io_put_kbuf
  io_uring: pass poll_find lock back
  io_uring: clean up io_try_cancel
  io_uring: limit the number of cancellation buckets
  io_uring: clean up io_ring_ctx_alloc
  io_uring: use state completion infra for poll reqs
  io_uring: add IORING_SETUP_SINGLE_ISSUER
  io_uring: pass hash table into poll_find
  io_uring: introduce a struct for hash table
  io_uring: propagate locking state to poll cancel
  io_uring: mutex locked poll hashing

 include/uapi/linux/io_uring.h |   5 +-
 io_uring/cancel.c             |  23 +++-
 io_uring/cancel.h             |   4 +-
 io_uring/fdinfo.c             |  11 +-
 io_uring/io_uring.c           |  84 ++++++++-----
 io_uring/io_uring.h           |   5 -
 io_uring/io_uring_types.h     |  21 +++-
 io_uring/kbuf.c               |  33 +++++
 io_uring/kbuf.h               |  38 +-----
 io_uring/poll.c               | 225 +++++++++++++++++++++++++---------
 io_uring/poll.h               |   3 +-
 io_uring/rw.c                 |  41 +++----
 io_uring/tctx.c               |  27 +++-
 io_uring/tctx.h               |   4 +-
 io_uring/timeout.c            |   3 +-
 15 files changed, 353 insertions(+), 174 deletions(-)

-- 
2.36.1

