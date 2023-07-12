Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3811750E3E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjGLQVn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjGLQV3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:21:29 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127C12715
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-78706966220so32743239f.1
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689178822; x=1691770822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GB+TVOcEAGohMo/9qjG0tcL6VxFJuBiixHc0IQwbD98=;
        b=JqNSJM5QCDkw+R1ww+DDY6XYeGWUbAsCxQxhbbvdBaY2g7Yo9mq1Utaza/2CKVSM8B
         yDUYnnK6aVmrxP9r7gx+AZAaNJ1K4hxf2piEFU+6mlK1+eDms+kicmruEfTrHp0ik2Tt
         Vm+ktb+O8l708FmhVBKRZMaPK84pe3A7EU5PKUaNKk1VKGdOjQpM1eH+d+KC1BnPFvt6
         LUxcTf90msPzRfcZqu0dh/LdCvPF+veHMiBnP5SgE1py/1HsKWqogpgveuIjiLxf1NZq
         M15munixc7UyORn1PlwYnauNOx1mIl1XABPGBcoCcjS+zit6CSyO2n9iVqMNJ3wR1riJ
         bYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178822; x=1691770822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GB+TVOcEAGohMo/9qjG0tcL6VxFJuBiixHc0IQwbD98=;
        b=TmNdP4W1o0tnIe37Jc8NLFUYJTNVQa1fQwt4wJikMTmcATeFhbuG4W0f6XvhZ3KTcU
         5m199o02vyI4EPQXJnAX/pLZ5Z8EvRSy3Ks8nzWTE2nBbsjZzZnBnJcS55iP+94Z7SQz
         dyDWCE/RzVlQ1UJ/VsVkrBRGKPgQd9aCGGgYTggkFxp/yBfzgz8Jk/0ah6jKA52D8UmH
         tJSIDtCjxGgFW9prZJx0s66evqfLGu24ebYExEHNN83u97ZawsbcSX5IBEbqzTU/x7rC
         v0D3WlUZKhzsGSuFPhUK3iyVRgKrnKVo4aYRUu0OlvOjhr1I5QXt0OUX5LN9WiU6kzU9
         fdNA==
X-Gm-Message-State: ABy/qLY8FxqrBBxcdDZcV5F1dzhWBvB12FSnFVSgE3OVnaxNh9AieXXN
        smnviUVHKJmmed7A279L1iXeTnOqm5HMtJcprGE=
X-Google-Smtp-Source: APBJJlHtuORB22XquZ9IWPiPN1Pbeftomu0zTo5Kw9NMbEPkmyQCmhyPA1/w87Jx09AggSZc60s2vQ==
X-Received: by 2002:a6b:1489:0:b0:780:cde6:3e22 with SMTP id 131-20020a6b1489000000b00780cde63e22mr18243438iou.0.1689178822177;
        Wed, 12 Jul 2023 09:20:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x24-20020a029718000000b0042aec33bc26sm1328775jai.18.2023.07.12.09.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:20:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de
Subject: [PATCHSET v2 0/8] Add io_uring futex/futexv support
Date:   Wed, 12 Jul 2023 10:20:09 -0600
Message-Id: <20230712162017.391843-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This patchset adds support for first futex wake and wait, and then
futexv. Patches 1..3 are just prep patches, patch 4 adds the wait
and wake support for io_uring, and then patches 5..7 are again prep
patches to end up with futexv support in patch 8.

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
 io_uring/futex.c               | 376 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  36 ++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  35 ++-
 kernel/futex/futex.h           |  33 +++
 kernel/futex/requeue.c         |   3 +-
 kernel/futex/syscalls.c        |  27 ++-
 kernel/futex/waitwake.c        |  49 +++--
 13 files changed, 548 insertions(+), 36 deletions(-)

You can also find the code here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-futex

V2:
- Abstract out __futex_wake_mark() helper. Use it both in the
  futex and io_uring code. This also fixes a missing WARN_ON
  on the io_uring side.
- Have futex_op_to_flags() unconditionally clear flags to
  zero rather than do that in both callers.
- Remove comment on needing to open-code futex_queue(),
  and associated hunk doing that. This was a leftover
  from an earlier version.
- Expand the commit message logs in various patches.

-- 
Jens Axboe


