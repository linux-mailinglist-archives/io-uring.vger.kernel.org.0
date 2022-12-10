Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220D8648F7A
	for <lists+io-uring@lfdr.de>; Sat, 10 Dec 2022 16:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLJPgB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Dec 2022 10:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLJPgA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Dec 2022 10:36:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7378619C26
        for <io-uring@vger.kernel.org>; Sat, 10 Dec 2022 07:35:57 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso11213071pjt.0
        for <io-uring@vger.kernel.org>; Sat, 10 Dec 2022 07:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mA1s/o8+B66Z04RXV1T/P38TpwIqpXoliaf3EjJQqKQ=;
        b=igB8OCcTBMWTOOwvafd6gppC/hnJ98uZntLWrv32kjF1vGf/B1phOYGKH30SCAQYU7
         QevxpRHvOOhETaBtxooor2nZUY5L14m+kS9xLSTU9f1Q039LFeHPUqoQeyaB/M1XqNpM
         SBE2RHFl+kNl8OBAQ+nbKrTLGfjJ37BfRvkAE5PaAz5wBQeKos8u5+4MnpLPekwURuuS
         mcOIDX1vKP5S7k37kSXltit9EuqZlhnwt6PRr+u0qJra5I+O/3u3sRxmmil4O6nKpvrw
         hBU42pVchf7u87Fp1mMYUsRXVYBEF7iO63EfPozp6DM2tgPa/bE/juBpNRPlwlIH13aG
         VTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mA1s/o8+B66Z04RXV1T/P38TpwIqpXoliaf3EjJQqKQ=;
        b=Oy4xVvMJD/I1MLuyXZNBY7IXMwUSllLxgRRE3vqryz3/M/a/Db/mp/3jHfc/5TbY27
         qr9hrkn7w7sGSQmA8GOrm1tc+c/JMFi3ae3Pe0x4mnV/AEqbZ4AH05pZF8aMfi3QGAh2
         CV1REY4Z5ESuoLaG3DYX+rI3WJp8cA3HrBY8Xy9Yaba7D8oIKuDG8qezITAlgZr4I75v
         7v795ILsmYqGB+SfyYrImr1Cq8e/y18b3J8ZFGqcy8CyMoIkD0PBpf7YqoqPEmY4dCxd
         9oehBpRQyx0/h9ioS7ZvjrjaDfJyslaHmwP3dWkwmpLWPdMQN3fZsSEGnw+3HXENzdi8
         XV/A==
X-Gm-Message-State: ANoB5plzO4/ALW85wHKK2zi3KzKMrYNKAarSmCqr23EtLRwW5egxd4ba
        vkyiQMLZO9FkyLW6OO1pUP9SkA==
X-Google-Smtp-Source: AA0mqf5kkZi0OrpbcCjXeB0jr9duCfO4MCCn1pwhPvg28qYLcVfQ0MPKpRGnIl2UdNHXbQswdP7ZXA==
X-Received: by 2002:a17:902:ea10:b0:189:b74f:46ad with SMTP id s16-20020a170902ea1000b00189b74f46admr2934162plg.3.1670686556769;
        Sat, 10 Dec 2022 07:35:56 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u17-20020a17090341d100b00187033cac81sm3136363ple.145.2022.12.10.07.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 07:35:56 -0800 (PST)
Message-ID: <a4a56cca-be7c-84de-40f7-69cdd1e96a1d@kernel.dk>
Date:   Sat, 10 Dec 2022 08:35:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] First round io_uring updates for 6.2-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

First part of the io_uring changes for the 6.2 merge window. We ended up
splitting this into two, to avoid unnecessary merge conflicts with fixes
that went into 6.1 later in the cycle.

This pull request contains:

- Always ensure proper ordering in case of CQ ring overflow, which then
  means we can remove some work-arounds for that (Dylan)

- Support completion batching for multishot, greatly increasing the
  efficiency for those (Dylan)

- Flag epoll/eventfd wakeups done from io_uring, so that we can easily
  tell if we're recursing into io_uring again. Previously, this would
  have resulted in repeated multishot notifications if we had a
  dependency there. That could happen if an eventfd was registered as
  the ring eventfd, and we multishot polled for events on it. Or if an
  io_uring fd was added to epoll, and io_uring had a multishot request
  for the epoll fd. Test cases here [1]. Previously these got terminated
  when the CQ ring eventually overflowed, now it's handled gracefully
  (me).

- Tightening of the IOPOLL based completions (Pavel)

- Optimizations of the networking zero-copy paths (Pavel)

- Various tweaks and fixes (Dylan, Pavel)

[1] https://git.kernel.dk/cgit/liburing/commit/?id=919755a7d0096fda08fb6d65ac54ad8d0fe027cd

Please pull!


The following changes since commit eb7081409f94a9a8608593d0fb63a1aa3d6f95d8:

  Linux 6.1-rc6 (2022-11-20 16:02:16 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.2/io_uring-2022-12-08

for you to fetch changes up to 5d772916855f593672de55c437925daccc8ecd73:

  io_uring: keep unlock_post inlined in hot path (2022-11-25 06:11:15 -0700)

----------------------------------------------------------------
for-6.2/io_uring-2022-12-08

----------------------------------------------------------------
Dylan Yudaken (13):
      io_uring: do not always force run task_work in io_uring_register
      io_uring: revert "io_uring fix multishot accept ordering"
      io_uring: allow multishot recv CQEs to overflow
      io_uring: always lock in io_apoll_task_func
      io_uring: defer all io_req_complete_failed
      io_uring: allow defer completion for aux posted cqes
      io_uring: add io_aux_cqe which allows deferred completion
      io_uring: make io_fill_cqe_aux static
      io_uring: add lockdep assertion in io_fill_cqe_aux
      io_uring: remove overflow param from io_post_aux_cqe
      io_uring: allow multishot polled reqs to defer completion
      io_uring: remove io_req_complete_post_tw
      io_uring: spelling fix

Jens Axboe (5):
      eventpoll: add EPOLL_URING_WAKE poll wakeup flag
      eventfd: provide a eventfd_signal_mask() helper
      io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups
      Revert "io_uring: disallow self-propelled ring polling"
      io_uring: kill io_cqring_ev_posted() and __io_cq_unlock_post()

Lin Ma (2):
      io_uring/poll: remove outdated comments of caching
      io_uring: update outdated comment of callbacks

Pavel Begunkov (19):
      io_uring: move kbuf put out of generic tw complete
      io_uring/net: remove extra notif rsrc setup
      io_uring/net: preset notif tw handler
      io_uring/net: rename io_uring_tx_zerocopy_callback
      io_uring/net: inline io_notif_flush()
      io_uring: move zc reporting from the hot path
      io_uring/net: move mm accounting to a slower path
      io_uring: inline io_req_task_work_add()
      io_uring: split tw fallback into a function
      io_uring: inline __io_req_complete_post()
      io_uring: add completion locking for iopoll
      io_uring: hold locks for io_req_complete_failed
      io_uring: use io_req_task_complete() in timeout
      io_uring: remove io_req_tw_post_queue
      io_uring: inline __io_req_complete_put()
      io_uring: iopoll protect complete_post
      io_uring: remove iopoll spinlock
      io_uring: don't use complete_post in kbuf
      io_uring: keep unlock_post inlined in hot path

Stefan Metzmacher (1):
      io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag

Xinghui Li (1):
      io_uring: fix two assignments in if conditions

 fs/eventfd.c                   |  37 ++++---
 fs/eventpoll.c                 |  18 ++--
 include/linux/eventfd.h        |   7 ++
 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/eventpoll.h |   6 ++
 include/uapi/linux/io_uring.h  |  18 ++++
 io_uring/io_uring.c            | 223 ++++++++++++++++++++++++-----------------
 io_uring/io_uring.h            |  43 +++++---
 io_uring/kbuf.c                |  14 +--
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 |  56 +++++++----
 io_uring/notif.c               |  57 +++++++----
 io_uring/notif.h               |  15 ++-
 io_uring/poll.c                |  33 +++---
 io_uring/rsrc.c                |  11 +-
 io_uring/rw.c                  |   6 ++
 io_uring/timeout.c             |  10 +-
 io_uring/uring_cmd.c           |   2 +-
 18 files changed, 355 insertions(+), 207 deletions(-)

-- 
Jens Axboe

