Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F086131FDA2
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBSRLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhBSRK6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:58 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4002FC061756
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:18 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u20so6325171iot.9
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=he34C2TLSTH+Bn8thVkbSPiLn7w4ciDeWWJWi1oA//o=;
        b=yeqmqaNU6yumCkDXMDtRR1eAzojyAEKlOjdPvUQMfODSGY93VOxgPfC1TGz7g+alCB
         Am41VpbmGOrID+E5nBqylsaIuBqzuA5MwhBNmXpT4T+8XSz4YCt2qFka1KRhTRivGA9U
         z0+Vzp1dthAZMpwYbyGUDrO5swnK/Hqm6yKk9rHymsPq5JxdGSrMTxFdmlJyAmLN6Nb9
         FSpoV/BBlxdwO6FVC48E2sTUmQhK7wblT8erJ3F3RKCkOwCwgG5FfH9glOzeyTskcHYH
         fxma9VtpKllv/KW9P9fUkmvsJoHU0FtNFf04YK6rYDaGW/3jvk3RjIiNfVxZ74F5c+54
         wHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=he34C2TLSTH+Bn8thVkbSPiLn7w4ciDeWWJWi1oA//o=;
        b=rRP3e0BaQwCaLCUH6C67OfsNxuchM0jC/gaQ0op5E8ftE3v5k6UmbeI9JHa+f70gMV
         dMyIrhG74zoyRg2AY6vuu/jFbx0jWpEqCWyUQWQqbC7aLPu8tvP0TtQwYuRkuIFgb2qy
         7FmIqeWmwPMvvIQ86RlB3GxTBxBWha3/96hcrEncPboZol6SLV27rf/ED2dP3BfrleRR
         3Dj8cUFN9u5JeSUV6EG3AZknXICqB3i4brT+2coX64cdKoCeUSP+N6Hv5HF2hM/U3pF9
         I/MxmFT26fD6SaWv3zMY+J5QsCxDHYbhnMTLu9V5QxoG6WH4sj7XFARtGj/H02snarz9
         j33w==
X-Gm-Message-State: AOAM530O6hzMv6xDuA3PhfB5cOnb+HQpFIkOzjFZeoP7ZWKcxUqYUDea
        QPR/Ko3Qr8MYUSUSpOY/C6kpJYDMq9NNdoiF
X-Google-Smtp-Source: ABdhPJyBZ7airr2rA+XeLmXpIaZttZUhyeq/Mwf9hVKixPVG9VbaCvJDEYGTP51j4s458LrsU/FnlQ==
X-Received: by 2002:a05:6638:3803:: with SMTP id i3mr10610664jav.26.1613754617375;
        Fri, 19 Feb 2021 09:10:17 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:17 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
Subject: [PATCHSET RFC 0/18] Remove kthread usage from io_uring
Date:   Fri, 19 Feb 2021 10:09:52 -0700
Message-Id: <20210219171010.281878-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

tldr - instead of using kthreads that assume the identity of the original
tasks for work that needs offloading to a thread, setup these workers as
threads of the original task.

Here's a first cut of moving away from kthreads for io_uring. It passes
the test suite and various other testing I've done with it. It also
performs better, both for workloads actually using the async offload, but
also in general as we slim down structures and kill code from the hot path.

The series is roughly split into these parts:

- Patches 1-6, io_uring/io-wq prep patches
- Patches 7-8, Minor arch/kernel support
- Patches 9-15, switch from kthread to thread, remove state only needed
  for kthreads
- Patches 16-18, remove now dead/unneeded PF_IO_WORKER restrictions

Comments/suggestions welcome. I'm pretty happy with the series at this
point, and particularly with how we end up cutting a lot of code while
also unifying how sync vs async is presented.

If you prefer browsing this on cgit, find it here:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-worker.v2

 arch/alpha/kernel/process.c      |   2 +-
 arch/arc/kernel/process.c        |   2 +-
 arch/arm/kernel/process.c        |   2 +-
 arch/arm64/kernel/process.c      |   2 +-
 arch/c6x/kernel/process.c        |   2 +-
 arch/csky/kernel/process.c       |   2 +-
 arch/h8300/kernel/process.c      |   2 +-
 arch/hexagon/kernel/process.c    |   2 +-
 arch/ia64/kernel/process.c       |   2 +-
 arch/m68k/kernel/process.c       |   2 +-
 arch/microblaze/kernel/process.c |   2 +-
 arch/mips/kernel/process.c       |   2 +-
 arch/nds32/kernel/process.c      |   2 +-
 arch/nios2/kernel/process.c      |   2 +-
 arch/openrisc/kernel/process.c   |   2 +-
 arch/riscv/kernel/process.c      |   2 +-
 arch/s390/kernel/process.c       |   2 +-
 arch/sh/kernel/process_32.c      |   2 +-
 arch/sparc/kernel/process_32.c   |   2 +-
 arch/sparc/kernel/process_64.c   |   2 +-
 arch/um/kernel/process.c         |   2 +-
 arch/x86/kernel/process.c        |   2 +-
 arch/xtensa/kernel/process.c     |   2 +-
 fs/io-wq.c                       | 393 +++++--------
 fs/io-wq.h                       |  14 +-
 fs/io_uring.c                    | 917 ++++++++++---------------------
 fs/proc/self.c                   |   7 -
 fs/proc/thread_self.c            |   7 -
 include/linux/io_uring.h         |  20 +-
 include/linux/sched.h            |   3 +
 kernel/ptrace.c                  |   2 +-
 kernel/signal.c                  |   4 +-
 net/socket.c                     |  10 -
 33 files changed, 451 insertions(+), 972 deletions(-)

-- 
Jens Axboe


