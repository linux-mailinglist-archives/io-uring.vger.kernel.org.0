Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D4F287716
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbgJHP16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730990AbgJHP15 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:27:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1A9C061755
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 08:27:56 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q9so6579869iow.6
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kf1FHcscdRPc5Run8iqbfToPP1jlTdzpFNUhRWFKvq8=;
        b=eYrIc4DKiojP3lwG3IPCBV8LMMb4cffXdyL4ngIrVpvRzeUq+7RJO4ggvSr5oq3PH+
         9R5/J3k0eSpWrwe9oQl6dEOM1xMkNmNTCQ81bMxRRnydgDx+nsn3xsq5DAbU5UE7F3iC
         oUy5jC8M7b5N/aL4BFL2YOavkNQ7bqXveYSgK/57ErT4ZfrcnGXDvN1KerT2oE27cLaa
         zU7OTlgAr6BHrFX1LyHCDC3JCpknJddQyblZxkA1nVYEYcI/q7lr8nNTr3bjbF3oLM7P
         x7ZTutF7y0Af9ieWXhFaSYTec5l+a380qOK7Y2yaDTda/KCVYlsKDiBFhpQFpw8kbGac
         EOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kf1FHcscdRPc5Run8iqbfToPP1jlTdzpFNUhRWFKvq8=;
        b=hHWWicEmuRruDVPeTI3h3Y9rl44VomgEKYvg8j3iAyiW6e3ncvdz9SbwNFgVoasxVK
         pnyQGuwgTz5eZXeNvoEkN79V8OZSS0h6e6Hl/Qx23ZvxXi3ZSNpnhnjUKQiTVdz/cmOL
         q7Qz9j7BbWPJjl3UBuzccHvVpWJb1Yvm0o+SlP0lu3/qZrxRdMDCkOwZuQ/XjlygFPQn
         qBy6h+7vKFd3maXT8C+0XHoE5Oe9k0a4SyHyx8fVABG0OfpsQBJoL8/9/Qpo+teXbO2B
         4w765Lp/luJrdqcCfX9J4VT4DZ4ehEV+t7C/ICfSfgD1mGYUXqOUXuyJAhxhZjM56P4t
         e70Q==
X-Gm-Message-State: AOAM531GkJ+ba3XKmRXwE6HbM+acUIy3ctzs6G3eB/oBj0TXNHreQVhw
        6FxLhMueKP9cibfBhqUHdFHeCA==
X-Google-Smtp-Source: ABdhPJxS38WsptZEv2BWRJ7clN9DvJ5Lqor+vrAgcuBuwv1RTMrhVhavYM519/V3o3lz7GRRKxeEOg==
X-Received: by 2002:a5d:8188:: with SMTP id u8mr6754266ion.66.1602170875610;
        Thu, 08 Oct 2020 08:27:55 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l77sm2866260ill.4.2020.10.08.08.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:27:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Subject: [PATCHSET v4] Add support for TIF_NOTIFY_SIGNAL
Date:   Thu,  8 Oct 2020 09:27:48 -0600
Message-Id: <20201008152752.218889-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

The goal is this patch series is to decouple TWA_SIGNAL based task_work
from real signals and signal delivery. The motivation is speeding up
TWA_SIGNAL based task_work, particularly for threaded setups where
->sighand is shared across threads. See the last patch for numbers.

v4 is nicely reduced, thanks to feedback from Oleg, dropping two of the
core patches and resulting in something that is easier to adopt in other
archs as well.

 arch/alpha/kernel/signal.c         |  1 -
 arch/arc/kernel/signal.c           |  2 +-
 arch/arm/kernel/signal.c           |  1 -
 arch/arm64/kernel/signal.c         |  1 -
 arch/c6x/kernel/signal.c           |  4 +--
 arch/csky/kernel/signal.c          |  1 -
 arch/h8300/kernel/signal.c         |  4 +--
 arch/hexagon/kernel/process.c      |  1 -
 arch/ia64/kernel/process.c         |  2 +-
 arch/m68k/kernel/signal.c          |  2 +-
 arch/microblaze/kernel/signal.c    |  2 +-
 arch/mips/kernel/signal.c          |  1 -
 arch/nds32/kernel/signal.c         |  4 +--
 arch/nios2/kernel/signal.c         |  2 +-
 arch/openrisc/kernel/signal.c      |  1 -
 arch/parisc/kernel/signal.c        |  4 +--
 arch/powerpc/kernel/signal.c       |  1 -
 arch/riscv/kernel/signal.c         |  4 +--
 arch/s390/kernel/signal.c          |  1 -
 arch/sh/kernel/signal_32.c         |  4 +--
 arch/sparc/kernel/signal_32.c      |  4 +--
 arch/sparc/kernel/signal_64.c      |  4 +--
 arch/um/kernel/process.c           |  2 +-
 arch/x86/include/asm/thread_info.h |  2 ++
 arch/x86/kernel/signal.c           |  5 +++-
 arch/xtensa/kernel/signal.c        |  2 +-
 include/linux/entry-common.h       |  6 ++++-
 include/linux/entry-kvm.h          |  4 +--
 include/linux/sched/signal.h       | 20 ++++++++++++---
 include/linux/tracehook.h          | 31 ++++++++++++++++++++--
 kernel/entry/common.c              |  3 +--
 kernel/entry/kvm.c                 |  7 ++---
 kernel/events/uprobes.c            |  2 +-
 kernel/signal.c                    |  8 +++---
 kernel/task_work.c                 | 41 +++++++++++++++++++++---------
 35 files changed, 113 insertions(+), 71 deletions(-)

Also find the changes here:

https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work

Changes since v3:

- Drop not needed io_uring change
- Drop syscall restart split, handle TIF_NOTIFY_SIGNAL from the arch
  signal handling, using task_sigpending() to see if we need to care
  about real signals.
- Fix a few over-zelaous task_sigpending() changes
- Cleanup WARN_ON() in restore_saved_sigmask_unless()

-- 
Jens Axboe


