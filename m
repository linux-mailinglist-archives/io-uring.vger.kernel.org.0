Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0F74FC50
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjGLArO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjGLArN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:13 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7287010D4
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:12 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5576ad1b7e7so1011182a12.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122831; x=1691714831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zwf7PNYu4wI0CQUOtfCbpFsxoKlxsJ+HgWgm32SeiN8=;
        b=Rw3RNDZg3dW69P/y+UN3VY5htsidXQx7LlComs7YTCo2SqmTrOqJytbmEZp4w+NXrB
         jQ+KKf9bQ/igYEFDMhLChufOR16aVz8DbZo/IwikkvwmyfRbvRaTRkuoYJTuTtvlrPaG
         c3wp/Up6GiLxRx4Ovry53lQK8ZXjKYrYYrW/egcO3Sln7nnMwniWOnUhaa8qYgkgIrPO
         lDjXjeddBM99F/kFMVojYwxNmAuPkSbuAZsZQgcDWDTzUGYL8idLFLGp/XwZtlXzaJbg
         WzcDbxBKy7Bc5cFtTOnUKENyjjR/g06h71wiBOdWgPbjlcdYzHrP0J5P3pd38dxYspWx
         CBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122831; x=1691714831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zwf7PNYu4wI0CQUOtfCbpFsxoKlxsJ+HgWgm32SeiN8=;
        b=Y0OUsxbJmTM/t0l46XE6LfuaJ4HBG3Ds3F4/7MwSyBnnG3+HOAXpxbpFdT/RLt//zZ
         jWfCTBWD88kZqVbQ6WVwb6k53rrGEuRH7HEQcF60H6Fc5VHHRL1NEkv1PJbHuuPD4wGD
         zPySj6qK3auBtuDI5vaQwCI52kvjYPyj/gX/XPpro/Wxau5D2EvkESH+/chJUMoA4uSs
         Z8RrQfU8MUVA+u8epe29PF6ZQO08Cdx/7MlNpvpZXIzgJJJa90LHdd4pOuwpuJw9Yl+y
         nNwGh7BpdFZO0H3zbGycPzVw7LrdGgg64drm+pcd57enCAm/QjC0ZIwrQSkW/UAWaiBp
         Pl+w==
X-Gm-Message-State: ABy/qLZ0L1N6Hsx/5vk22fuOfDGsBvqq4JqBqNY+NkoGhQyXbDkXZ3QM
        nfI88OkxNLf7EbNBuGFuRpAgeSC+Ko+5fhmQlEM=
X-Google-Smtp-Source: APBJJlFD8UdZUApChBxjg60NDI1ts4leqa2ZFydqdXNwH3ZaztV62kXXwFVWMu8izCDKPN+6XuWE8w==
X-Received: by 2002:a17:902:eccc:b0:1b8:ac61:ffcd with SMTP id a12-20020a170902eccc00b001b8ac61ffcdmr21877660plh.3.1689122831335;
        Tue, 11 Jul 2023 17:47:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org
Subject: [PATCHSET 0/7] Add io_uring futex/futexv support
Date:   Tue, 11 Jul 2023 18:46:58 -0600
Message-Id: <20230712004705.316157-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This patchset adds support for first futex wake and wait, and then
futexv. Patches 1..2 are just prep patches, patch 3 adds the wait
and wake support for io_uring, and then patches 4..6 are again prep
patches to end up with futexv support in patch 7.

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
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/Makefile              |   4 +-
 io_uring/cancel.c              |   5 +
 io_uring/cancel.h              |   4 +
 io_uring/futex.c               | 377 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  36 ++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  35 ++-
 kernel/futex/futex.h           |  30 +++
 kernel/futex/requeue.c         |   3 +-
 kernel/futex/syscalls.c        |  25 ++-
 kernel/futex/waitwake.c        |  19 +-
 13 files changed, 525 insertions(+), 25 deletions(-)

You can also find the code here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-futex

-- 
Jens Axboe


