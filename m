Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BEE7A9E18
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjIUTzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 15:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjIUTzU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 15:55:20 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C1DD7DAC
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:14 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-79f96830e4dso3974739f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320953; x=1695925753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n7GcjJMAhJ6aBbgmYVJaY498tX8EJz+zoUNU1lZL1rI=;
        b=ngZqedEV7ZMStk8XskreSyJNHKF8ywnk9yqbagMHECW5e7nf71QmJ9f4u2B/GxJV+e
         0PzpBsyZZUVloGZml7PmeG7m5AUyyH3n6g+kTY3N98jlL46WUctlIc8CA6KvXf7RNDG6
         IV+lQeLpNf78+FCoCaJ5nS1UiVDwJCiRfs1yvL52RPYNGtMduQfXbOruOKKoc3821PAk
         XYwW5MHqL2b5aBjoaCAJs1/4oaS6QaIdr9u1WHHL48lyY+YVkpytAKPah9XWLe8qgawH
         KGWvDZED9FWVbElHgPY34xO6t2bRbdZdRkY4sMAS1AaJSRYjt6oehEn5DTXJkGGPSXdV
         mSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320953; x=1695925753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n7GcjJMAhJ6aBbgmYVJaY498tX8EJz+zoUNU1lZL1rI=;
        b=Tv7AeUPXkMMmii+QTEQ26DOaUKE196dY/n4lNOXTihYfk0NdrHYhIwOP55XXcb5OOI
         u6VSZDShNJPlJ7vXTCn69UpBQtc1QySyzzAM4uWuXP9NbuJttEB7pwwd8xYcj+y7BE1l
         kAnqgyLWbSQUoUYjDJGeTm+xZlzQTvhRXNiSRguapgOYdB/j2en3BE3IdT0FE2A4ciOD
         QS6WvVw6KMNtxK8206M4p+/cQx8I4uXrqCSswKvCBb6ByHWhiTkyS2SCsPrOG/ordz2T
         6HX9ccP9AfUogGD6Il7SdG90/A+hni35eoj8rm0PaCnbzJE+ZHVtV/45l5bCZxlic4xB
         xDhA==
X-Gm-Message-State: AOJu0YwdfCdfej4O1V7omR22eOBj7j5cWm6VvufCFfpuA7VYM4vUaG/Z
        uQLj5RTMp0ctvBeR+97SbZpapfXFong4dT1jn7vTEQ==
X-Google-Smtp-Source: AGHT+IHE7Lk9+sqMzkjjeGzrzHe84uoDOIyaaU24bCU7dQoZLk/cH/1sZHIUid/9ym+MM1zqX21qAw==
X-Received: by 2002:a92:dc08:0:b0:34f:a4f0:4fc4 with SMTP id t8-20020a92dc08000000b0034fa4f04fc4mr7234640iln.2.1695320953475;
        Thu, 21 Sep 2023 11:29:13 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de
Subject: [PATCHSET v5] Add io_uring futex/futexv support
Date:   Thu, 21 Sep 2023 12:29:00 -0600
Message-Id: <20230921182908.160080-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
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
 io_uring/futex.c               | 376 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  36 ++++
 io_uring/io_uring.c            |   7 +
 io_uring/opdef.c               |  34 +++
 kernel/futex/futex.h           |  20 ++
 kernel/futex/requeue.c         |   3 +-
 kernel/futex/syscalls.c        |  18 +-
 kernel/futex/waitwake.c        |  49 +++--
 13 files changed, 535 insertions(+), 27 deletions(-)

You can also find the code here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-futex

V5:
- Rebase on PeterZ's futex2 changes. Pulled in the tip locking/core
  branch.
- Shuffle order of some io_uring patchsets, which changed the value
  of the futex opcodes.

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


