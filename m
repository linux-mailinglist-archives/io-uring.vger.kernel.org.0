Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC8E342942
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCTABG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTAAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:00:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1944C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=B//N6pehAzHsB9qMCPmyMWzPeiwswVALiGblVEWxL5E=; b=hU8HkjsSnknRD7r+McJOVdgTFH
        AW/RoMDvjija7tH0egzzOw307dWZGlNX9IlomXg5uMU5E1Bc7mAHlVKArj/UzjaWN8OTzFn6mMslW
        GyesvM569h17U05ew4hh2zueTHtT9Vi6COXcqx7hmaOLrT+NpK2qVLGM7AVaX2BTY8vYSEv0h5Ya9
        M0kBLa9MeuCJtpu/txUxrqCOd+ppHCNQ3ho3gff4TcVSqisU0f7sbSyiy5tC6DlOqCLo0RwImI55n
        EOIk2XdLaFcSsn0ua/MLT8fINViH6iahzagaTjCX3Umx5Rcx5JTVJtsWhLmoDSSRzZF2DhvYF49wb
        jTefwTYTrJTr1Y1U9RCK3LqWMzoGbpiCVHMYx7dgWm4R2znFbmBFdFyl39UibdXa3SoDOsBWf6Foz
        PN1XSCJH0emTgxakvNbJEtYKt/yikJ6ttORWhRW9iX/l7tU9SwqwtDo42eRv5lUnNEr/MHt18OrXP
        FRz/AekplzC35pY9hlA4Y84P;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNP2l-0007WH-O9; Sat, 20 Mar 2021 00:00:39 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 0/5] Complete setup before calling wake_up_new_task() and improve task->comm
Date:   Sat, 20 Mar 2021 01:00:26 +0100
Message-Id: <cover.1616197787.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

now that we have an explicit wake_up_new_task() in order to start the
result from create_io_thread(), we should things up before calling
wake_up_new_task().

There're also some improvements around task->comm:
- We return 0 bytes for /proc/<pid>/cmdline

While doing this I noticed a few places we check for
PF_KTHREAD, but not PF_IO_WORKER, maybe we should
have something like a PS_IS_KERNEL_THREAD_MASK() macro
that should be used in generic places and only
explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
difference matters.

There are also quite a number of cases where we use
same_thread_group(), I guess these need to be checked.
Should that return true if userspace threads and their iothreds
are compared?

I did some basic testing and found the problems I explained here:
https://lore.kernel.org/io-uring/F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk/T/#t
They appear with and without my changes.

Changes in v2:

- I dropped/deferred these changes:
  - We no longer allow a userspace process to change
    /proc/<pid>/[task/<tid>]/comm
  - We dynamically generate comm names (up to 63 chars)
    via io_wq_worker_comm(), similar to wq_worker_comm()

Stefan Metzmacher (5):
  kernel: always initialize task->pf_io_worker to NULL
  io_uring: io_sq_thread() no longer needs to reset
    current->pf_io_worker
  io-wq: call set_task_comm() before wake_up_new_task()
  io_uring: complete sq_thread setup before calling wake_up_new_task()
  fs/proc: hide PF_IO_WORKER in get_task_cmdline()

 fs/io-wq.c     | 17 +++++++++--------
 fs/io_uring.c  | 22 +++++++++++-----------
 fs/proc/base.c |  3 +++
 kernel/fork.c  |  1 +
 4 files changed, 24 insertions(+), 19 deletions(-)

-- 
2.25.1

