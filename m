Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17C76721B
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjG1Qmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjG1Qml (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:41 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4203C3B
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:40 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-34770dd0b4eso1764205ab.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562559; x=1691167359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/OOfQIOyddXf1iPYxVmgbHM6Gt5WcR6H0xW6nDVgvxY=;
        b=etHWFh8Jem7D9UeaRMdFrlmvncC+Vu4hM+PZ9MpCA13NynAunJlQJcsnTb/IEXiY9y
         zLHF9606ee9GgXcnYNQjw9J0sA7t9wUBfZvLKsbzLLXyVt/gbXhHitXxBvokhSZbbqy8
         sS4AxNztnUoLHoJWZl18xOj/vt8wb+Qzzf9x3oF85aLZMhtUjXGm1M72a5C4qHjhcqpm
         /BHyGpzWMa92LzuyC3EHJb6HNb9pzT8bnQFDpO3hcmHqUzte/y41zYKFA/ojoHCxtbFz
         /iQtA+EreKvMACv+Q2a5XegicabE9a1OsJpwbVQh5/5QQSzZFaGb9oflFwvnwtoZGwvt
         Yb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562559; x=1691167359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/OOfQIOyddXf1iPYxVmgbHM6Gt5WcR6H0xW6nDVgvxY=;
        b=SKNZ2QDgmAr0jVLWAUWUrUzYj9mqTJXmwh939wmQe4W3LT8x6kdppIfZ7KvIu4DvSo
         AzlOUnj/QAj3AH7q/uYB2OrOvryT1MJM5Su4IsY3ThSwwsRZ+cQ6QmwOBOZSwuKp/ZvZ
         Lwjn5eL+JIfnWikDSxHzYxY+coj0kLyYE/AYkRm2qjanWkPTwVIkThE6Caza1onPMbyR
         7VxxFs9ir8sMmislZ6amvEt4U0KMc9bRZe5isLNmEOJmSe4X29VJuhr1yhh1vpCUPfEY
         pK01OAh3dA756tuUqfCzx5lhP6cX/98gq93EnVKMNWrR/prFdunWlTiWp90NLvC/DZ7V
         aZ0A==
X-Gm-Message-State: ABy/qLYuXWCcaAFHnSi5o26J3+8eqDuMwLBM9X6r2u5PzfWWsW71Tfkj
        Gu8MFLFj14qJyRMvb9d7/SW621fzXI7k89VLIMI=
X-Google-Smtp-Source: APBJJlGGutqgSsV5x0C7bGONCaBKQLO7o5xNiEXX9l9/8h6JLQA6odt1Tn6HfmTCDQUZyOjz+umiZA==
X-Received: by 2002:a6b:5d02:0:b0:783:6ec1:65f6 with SMTP id r2-20020a6b5d02000000b007836ec165f6mr83225iob.1.1690562559412;
        Fri, 28 Jul 2023 09:42:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de
Subject: [PATCHSET v4] Add io_uring futex/futexv support
Date:   Fri, 28 Jul 2023 10:42:23 -0600
Message-Id: <20230728164235.1318118-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

s patchset adds support for first futex wake and wait, and then
futexv.

For both wait/wake/waitv, we support the bitset variant, as the
"normal" variants can be easily implemented on top of that.

PI and requeue are not supported through io_uring, just the above
mentioned parts. This may change in the future, but in the spirit
of keeping this small (and based on what people have been asking for),
this is what we currently have.

When I did these patches, I forgot that Pavel had previously posted a
futex variant for io_uring. The major thing that had been holding me
back from people asking about futexes and io_uring, is that I wanted
to do this what I consider the right way - no usage of io-wq or thread
offload, an actually async implementation that is efficient to use
and don't rely on a blocking thread for futex wait/waitv. This is what
this patchset attempts to do, while being minimally invasive on the
futex side. I believe the diffstat reflects that.

As far as I can recall, the first request for futex support with
io_uring came from Andres Freund, working on postgres. His aio rework
of postgres was one of the early adopters of io_uring, and futex
support was a natural extension for that. This is relevant from both
a usability point of view, as well as for effiency and performance.
In Andres's words, for the former:

"Futex wait support in io_uring makes it a lot easier to avoid deadlocks
in concurrent programs that have their own buffer pool: Obviously pages in
the application buffer pool have to be locked during IO. If the initiator
of IO A needs to wait for a held lock B, the holder of lock B might wait
for the IO A to complete.  The ability to wait for a lock and IO
completions at the same time provides an efficient way to avoid such
deadlocks."

and in terms of effiency, even without unlocking the full potential yet,
Andres says:

"Futex wake support in io_uring is useful because it allows for more
efficient directed wakeups.  For some "locks" postgres has queues
implemented in userspace, with wakeup logic that cannot easily be
implemented with FUTEX_WAKE_BITSET on a single "futex word" (imagine
waiting for journal flushes to have completed up to a certain point). Thus
a "lock release" sometimes need to wake up many processes in a row.  A
quick-and-dirty conversion to doing these wakeups via io_uring lead to a
3% throughput increase, with 12% fewer context switches, albeit in a
fairly extreme workload."

Some basic io_uring futex support and test cases are available in the
liburing 'futex' branch:

https://git.kernel.dk/cgit/liburing/log/?h=futex

testing all of the variants. I originally wrote this code about a
month ago and Andres has been using it with postgres, and I'm not
aware of any bugs in it. That's not to say it's perfect, obviously,
and I welcome some feedback so we can move this forward and hash out
any potential issues.

 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/futex.h     |  17 +-
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/Makefile              |   4 +-
 io_uring/cancel.c              |   5 +
 io_uring/cancel.h              |   4 +
 io_uring/futex.c               | 376 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  36 ++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  35 ++-
 kernel/futex/futex.h           |  92 +++++++-
 kernel/futex/requeue.c         |   3 +-
 kernel/futex/syscalls.c        |  41 ++--
 kernel/futex/waitwake.c        |  53 +++--
 14 files changed, 630 insertions(+), 48 deletions(-)

You can also find the code here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-futex

V4:
- Refactor the prep setup so it's fully independent between the vectoed
  and non-vectored futex handling.
- Ensure we -EINVAL any futex/futexv wait/waitv that specifies unused
  fields.
- Fix a comment typo
- Update the patches from Peter.
- Fix two kerneldoc warnings
- Add a prep patch moving FUTEX2_MASK to futex.h

-- 
Jens Axboe


