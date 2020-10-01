Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB5C2807E3
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 21:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgJATmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 15:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730093AbgJATmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 15:42:13 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09187C0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 12:42:13 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so8224383ior.2
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 12:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Xf9F6UGNaiLG5H3YRSBPm6b9L4CcWmTNfiW9AANHnQ=;
        b=bV2f4yXxPht1ORgAZbL+26LUq3j6/+meqvYDo3OiiVlm8PoQQ7LK0gSy3has1kGbwT
         FLFOHSQi2YZjxnQ33QvdLk/x9Rm175KTVzKx1kiZtIslEDlpYIngERmsIx3pak+pXqJn
         c2oOqWAi/Tmg6OQXmQxaGr42zj7bbYzyW/nam0Z/xpPGdak5gdfNdTZVvC7yZGKnG8yJ
         V4bIV83uzV/oB4dl4SRQ620jWjbzjsnJIDqPE9oHCzwCU+X1eNcZOpJweR4z7JcCyrng
         z7kZKAEKdmJU4UovQ9mSTJdNm0mm7zZVBzqy+6uhsNJRPspxVJ62OPjSlwLsYaQOx+a3
         uq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Xf9F6UGNaiLG5H3YRSBPm6b9L4CcWmTNfiW9AANHnQ=;
        b=J1Uun4HSFZDIrSa9TWd9cT2WOOO21k3WMHBMVL6iQ5ZI8HokRf9z0Xc1nmsyqGAy1v
         5BP4Dv+FGXu10cbqRYrN8cjlDrtLRwD0k0RsoUe2/mdWy7+PKfxPRS8hfnH6NeuHw5N2
         iafFoyiS1AxZ6FUXcz4cM5ulpsy+triQx5FIw3W+lIEakfyyXv42bSjfYMRBp3C78De1
         fkK4EAw+IHvrtGrl34ksxubcO+bDlFsElBZhvxWqAeau0MVvhqUlzlBo36X/YkNloepM
         N+OcKlviR7NTJopo4JG32S7kxVivAqdUjamP0tDSS5fBp43O1CD7y2z8Ulbl4S4bMynb
         4fbA==
X-Gm-Message-State: AOAM532JL795Hu/FVZd0Msl8W0m2O11IGEMjiJ2b43mBBsOQWONyV95T
        AgzTgrpuvuOp4iY+x4M7nKBCXQ==
X-Google-Smtp-Source: ABdhPJyyzY9YdiPTxsCObl8ukT4pWzeiXFcI57sXQik+Qzyt7trv1gaUwlW2RBKM9Q14WwloQm5VLA==
X-Received: by 2002:a6b:244:: with SMTP id 65mr6591713ioc.7.1601581332210;
        Thu, 01 Oct 2020 12:42:12 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t11sm739609ill.61.2020.10.01.12.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 12:42:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Subject: [PATCHSET RFC 0/3] kernel: decouple TASK_WORK TWA_SIGNAL handling from signals
Date:   Thu,  1 Oct 2020 13:42:05 -0600
Message-Id: <20201001194208.1153522-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I split this up into 3 pieces instead of the messy single patch, hope
this helps with review.

Patch 1 adds task_sigpending(), which tests TIF_SIGPENDING. Core use
cases that need to check for an actual signal pending are switched to
using task_sigpending() instead of signal_pending(). This should fix
Oleg's concern on signal_pending() == true, but no signals pending,
for actual signal delivery.

Patch 2 adds x86 and generic entry code support for TIF_TASKWORK.

Patch 3 adds task_work support for TIF_TASKWORK, if the arch supports it.

There's no need for any io_uring specific changes, so I've dropped those.
If TIF_TASKWORK is used, then JOBCTL_TASK_WORK will never be true and
hence we won't enter that case. If TIF_TASKWORK isn't available, then
we still need that code.

I've run this through my usual liburing test, and it passes. I also ran
it through all the ltp signal testing, and no changes from mainline in
terms of all tests passing.

 arch/x86/include/asm/thread_info.h |  2 ++
 arch/x86/kernel/signal.c           | 32 +++++++++++---------
 include/linux/entry-common.h       | 20 +++++++++++--
 include/linux/sched/signal.h       | 32 ++++++++++++++++----
 kernel/entry/common.c              | 14 +++++++--
 kernel/events/uprobes.c            |  2 +-
 kernel/ptrace.c                    |  2 +-
 kernel/signal.c                    | 12 ++++----
 kernel/task_work.c                 | 48 ++++++++++++++++++++++--------
 9 files changed, 118 insertions(+), 46 deletions(-)

Changes can also be viewed/pulled from this branch:

git://git.kernel.dk/linux-block tif-task_work

https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work

-- 
Jens Axboe


