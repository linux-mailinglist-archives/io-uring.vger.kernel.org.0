Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF59F7B23D0
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjI1RZ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjI1RZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:27 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA91B2
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9ae3d7eb7e0so355425566b.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921922; x=1696526722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8pRMDZlUcod193GRSUiqTpOfle5RoPKyrld6Nxx5gVw=;
        b=phx3tBm4U0ZtfTa8GEk7f6iAvZMgfvJB7s8ddyCffRsHtsUb5BaR64uBZ1t9wY1Gsz
         i8ZVMXukvbVjr37N0OrJ4cn3OnAOqHEzGEfbSgysasNF95Z8Ew/TAylXkIFzNMB1Ivrt
         bK8U76M+aFpnDcO+vESd7F2m0hicx6VmWMOTrIZMsXuSyt2QgOSNN7UGUqJSOOfYHIjF
         GBCZxwDs7m6H0uCQPQ2eN4HpqSsI7xHLYrNjrxbK7sGZy27iQwQj22YaNSTiI+Bol7Wq
         15FCbSBKqAa0rTUWVz4Ozs60nSIRR2sLe5LU5gDZwwBLL7ejzK+G+K0dz7vN/w/n0oh8
         50eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921922; x=1696526722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pRMDZlUcod193GRSUiqTpOfle5RoPKyrld6Nxx5gVw=;
        b=e6aTgQWvfcWxK5eYEVW5wpbqpeoIJna+L25XH9K2CzSNaB9FcnCheZ5yRdP4TcKKQx
         g4A4C2Jnv9iZzYOYL11Y2nfyP/4yjw8pqSIVTa7YTMw0toNEv046M/E2YiqJgT0gDy5v
         mZ/1ACqlfuZ5bpMg9v9ReWKl1iwdQNMdZ6qmmCn/+3vBYgPbbBXpxqLTRUDnVv9uUrJ3
         xO0tf4LD+u54l0x/esMsUQQE4LBbrFkGRisD2K8lr3jLBtAFRz3MH6GvLYgu0aGu06sp
         L/u5/P4sBQ+HZpvtv8vAcfrDZc36B7GcFzuP2Xzczbd/+RCDiJznLGXTe0yR/lBrSDug
         GhcQ==
X-Gm-Message-State: AOJu0YyftsBec2+cjU5tB1yChqzprQ9/ddKbNfkVV6sWEI1JEoMUgSFK
        1nV+4Pp/PmJ/0QtgFRgiEtjrst/ZukhWug8irRi1vrut
X-Google-Smtp-Source: AGHT+IGKafiy4APuWliGQtm5Yjs9WsrsjFtqNHykh2FK58LqmEMCBi74MTPNBNB+enKIHstwZq6+hA==
X-Received: by 2002:a17:906:112:b0:9a5:9f3c:961f with SMTP id 18-20020a170906011200b009a59f3c961fmr1526456eje.3.1695921922284;
        Thu, 28 Sep 2023 10:25:22 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de
Subject: [PATCHSET v6] Add io_uring futex/futexv support
Date:   Thu, 28 Sep 2023 11:25:09 -0600
Message-Id: <20230928172517.961093-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This patchset adds support for first futex wake and wait, and then
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

In terms of testing, there's a functionality and beat-up test case
in liburing, and I've run all the ltp futex test cases as well to
ensure we didn't inadvertently break anything. It's also been in
linux-next for a long time and haven't heard any complaints.

 include/linux/io_uring_types.h |   5 +
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/Makefile              |   1 +
 io_uring/cancel.c              |   5 +
 io_uring/cancel.h              |   4 +
 io_uring/futex.c               | 386 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  36 +++
 io_uring/io_uring.c            |   7 +
 io_uring/opdef.c               |  34 +++
 kernel/futex/futex.h           |  20 ++
 kernel/futex/requeue.c         |   3 +-
 kernel/futex/syscalls.c        |  18 +-
 kernel/futex/waitwake.c        |  49 +++--
 13 files changed, 545 insertions(+), 27 deletions(-)

You can also find the code here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-futex

V6:
- Expand the two main commit messages describing command layout
- Fix double conversion of FUTEX2_* flags (Peter)
- Use FLAGS_STRICT for IORING_OP_FUTEX_WAKE, so we return 0 wakes
  when the caller asked for 0 (Peter)
- Fix issue with IORING_OP_FUTEX_WAITV and futex_wait_multiple_setup()
  doing futex_unqueue_multiple() if we had a wakeup while setting up.
- Cleanup IORING_OP_FUTEX_WAITV issue path
- Don't use sqe->futex_flags for the FUTEX2_* flags, reserve it for
  future internal use.
- Add more liburing test cases.
- Rebase on current tree (for-6.7/io_uring + tip locking/core)

-- 
Jens Axboe


