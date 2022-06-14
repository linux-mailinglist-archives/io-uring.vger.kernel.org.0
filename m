Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64D254B3A4
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiFNOhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiFNOhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:41 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33522BC17
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:40 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id q15so4782237wmj.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qur2mUk2lIwWV+4MC4+GnNmiI8AMpMlKR0W9PM7hs9o=;
        b=IpwiF00CRutFMZanlKTqmIl/hkvR0iwzzoMpwLgzcqoghhFnHw+BUd+I7d4bM6kGaz
         v6QZvo+QIx5eg2mnZSjW/khUdv2Xn8LUBE8AyrPy0FEZltqF+w9SlW5NMbco8eTvoLy4
         SDRPEylpztmOmGx3QzVYl5k74PO6q/EgUWfvaLd94eCWBqYxQxDoRzrSvNONLr/rgKSo
         cE9n2FcRMeLSXlMxOxmw9uYLt9lHCQRoFohON8PAowNCBHnKAMaBKZwTuzNnASvVl4s4
         7T7oNI1oHFzp/KHjbKhJoGcz3Duj/7nwHAIfe5p8+A+1v6zb96XQQoXHJ9EwKQyZyzC0
         kA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qur2mUk2lIwWV+4MC4+GnNmiI8AMpMlKR0W9PM7hs9o=;
        b=YwsuXQ+agy91z6Ig7qP7MQRmRYYApfQnlGN7b0jg6l/Oc3x9LxQauQXVY2zvR0lEKD
         1sccA7/7MTdrkCn89YIpl9UFdMPwrMnSc+WnkD3fdf/U7iMtVyvlHghUyRuu+M6i6Rkc
         1I6KBH1oX02Ytkod7jQ5V4MS+sE4l7+FBupJSQv8tdyTrJDPxZD4jUbLSeXAyU6A/Cgp
         zWoVPGnutR/jady8+kUsBB+/KZwAH4LkSy9SJ18P+p9XKFJn/Ar8y0RwiMvFuXxjkmFS
         d+xpBVGGhCWC0DiIDfcoJE83uxpgE0vcWBoB9W919VcpRQtoPejv00ZV8OeyCLw3qghQ
         qPqA==
X-Gm-Message-State: AOAM531jQ3+WSmuaxvpiMk9megC4iOJz+UiTLjj/ynJ098D5vV6jPfw5
        R/TRdEWaMFVm2aphy93eUj0PrNsOsopuSg==
X-Google-Smtp-Source: ABdhPJy+ohdR5LeBWLFYxR2zz2BrCI3VDKYMtUIWh4BawkjiVNiSzDkyzTXTI26lG3GcozD4I8TA2A==
X-Received: by 2002:a05:600c:34c4:b0:39c:9236:4e9e with SMTP id d4-20020a05600c34c400b0039c92364e9emr4612180wmq.67.1655217458434;
        Tue, 14 Jun 2022 07:37:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 00/25] 5.20 cleanups and poll optimisations
Date:   Tue, 14 Jun 2022 15:36:50 +0100
Message-Id: <cover.1655213915.git.asml.silence@gmail.com>
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

The used poll benchmark each iteration queues a batch of 32 POLLIN
poll requests and triggers all of them with read (+write).

baseline (patches 1-18):
    11720 K req/s
base + 19 (+ inline completion infra)
    12419 K req/s, ~+6%
base + 19-25 (+ uring_lock hashing):
    12804 K req/s, +9.2% from the baseline, or +3.2% relative to patch 19.

Note that patch 19 only helps performance of poll-add requests, whenever
25/25 also improves apoll.

v2:
  don't move ->cancel_seq out of iowq work struct
  fix up single-issuer

Hao Xu (2):
  io_uring: poll: remove unnecessary req->ref set
  io_uring: switch cancel_hash to use per entry spinlock

Pavel Begunkov (23):
  io_uring: make reg buf init consistent
  io_uring: move defer_list to slow data
  io_uring: better caching for ctx timeout fields
  io_uring: refactor ctx slow data placement
  io_uring: move small helpers to headers
  io_uring: explain io_wq_work::cancel_seq placement
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
 io_uring/cancel.c             |  23 +++-
 io_uring/cancel.h             |   4 +-
 io_uring/fdinfo.c             |  11 +-
 io_uring/io-wq.h              |   1 +
 io_uring/io_uring.c           | 145 +++++++++++-----------
 io_uring/io_uring.h           |  17 +++
 io_uring/io_uring_types.h     | 108 +++++++++--------
 io_uring/kbuf.c               |  33 +++++
 io_uring/kbuf.h               |  38 +-----
 io_uring/poll.c               | 219 +++++++++++++++++++++++++---------
 io_uring/poll.h               |   3 +-
 io_uring/rsrc.c               |   9 +-
 io_uring/tctx.c               |  36 ++++--
 io_uring/tctx.h               |   7 +-
 io_uring/timeout.c            |   3 +-
 16 files changed, 416 insertions(+), 246 deletions(-)

-- 
2.36.1

