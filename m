Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A22B2C76EA
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgK2AuU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgK2AuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:20 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDC2C0613D1;
        Sat, 28 Nov 2020 16:49:55 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id u2so4493025pls.10;
        Sat, 28 Nov 2020 16:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83/pAMCHdug8q8KigZ36pmo9dSTEa8sHBk2e7NUwP3o=;
        b=bCpV6IgtHQXk2QH2Zlsg3vh2B7/GfpfNHPlsnAma2TRGOcvHcbjlz+xl7io++EOCWk
         jdLLzMbmhRktYiF/6eME+TN8jJuGMsxFMDFibSsOpxO9SMC2Q1cGds5hrDAGfW4Z14wU
         fNU7LsprK26F1GnVYtoKHv8mpt0IxTA0A2CTkx9Ob4JKAQ5EQ7zwW0ipW6JDzXyNcHae
         CdweGA+A3jU+sEHEmYlbZo/t3Y7A6eCl1mh5scSrAfb0VwzMb9bys+e3mdDNKpAA2MV/
         PTgyilLJa2jm3vdaPgOua3PVsz/wY7F6wgB+XeV3AEuh9T7zQeuRAFdb136eWDZRC41y
         niMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83/pAMCHdug8q8KigZ36pmo9dSTEa8sHBk2e7NUwP3o=;
        b=QMXpSiHwD4vz2KjJISZokpBjCQt1Iy/g1n6oDn0dC9a6qszFLUpdpCqKrNcvcfkkyQ
         0OJ49g/v70Ui7D0qYan+IVXe8l9Qcw6ABBivJ3JZuLXgyVhosg+qReRaIsLOk0PiAV6F
         NR0Otl0tt+3WOnQnXVVGb1/Xd8TaFCS1sLMkRWHGgKJwzd+K3SHIbWgiw9kBoDxVOWyB
         ssLmvaLfeFuHYoogzPE2mDheM7+gpFTQxHgK5Y9vmCDVwCCMnQdvcf+0m8Dhv9gHmJz6
         jP57K5okn3XKvyRcPWjCOV6t6dtV1cQIR7Xxt+W2gQ4wzwp4+Y+7B5u1HOG1LUr/6hJ0
         bhew==
X-Gm-Message-State: AOAM533tQLILIHoB80BJJsnS8dH54Ow/BN07rMI85dQwV+uMyeN8gZpe
        5N+78bQ/TliKadRDBEWyT9UV4ik4mJaF0w==
X-Google-Smtp-Source: ABdhPJwssGQhlhKBeDInAf63q82cFfSyhEr5h2dKa38xdU3BGUUE7ohK+TqMxjkvOwaD6/IEaP4B/g==
X-Received: by 2002:a17:902:bd8c:b029:d8:db1d:2a35 with SMTP id q12-20020a170902bd8cb02900d8db1d2a35mr12843288pls.66.1606610994387;
        Sat, 28 Nov 2020 16:49:54 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:49:53 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 00/13] fs/userfaultfd: support iouring and polling
Date:   Sat, 28 Nov 2020 16:45:35 -0800
Message-Id: <20201129004548.1619714-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

While the overhead of userfaultfd is usually reasonable, this overhead
can still be prohibitive for low-latency backing storage, such as RDMA,
persistent memory or in-memory compression. In such cases the overhead
of scheduling and entering/exiting the kernel becomes dominant.

The natural solution for this problem is to use iouring with
userfaultfd. But besides one bug, this does not provide sufficient
performance improvement and the use of ioctls for zero/copy limits the
use of iouring for synchronous "reads" (reporting of faults/events).
This patch-set provides four solutions for this overhead:

1. Userfaultfd "polling" mode, in which the faulting thread polls after
reporting the fault instead of being de-scheduled. This fits cases in
which the handler is expected to poll for page-faults on a different
thread.

2. Asynchronous-reads, in which the faulting thread reports page-faults
(and other events) directly to the userspace handler thread. For this
matter asynchronous read completions are being introduced.

3. Write interface, which provides similar services to the zero/copy
ioctls. This allows the use of iouring for zero/copy without changing
the iouring code or making it to be userfaultfd-aware. The low bits of
the "position" are being used to encode the requested operation
(zero/cop/wp/etc).

4. Async-writes, in which the zero/copy is performed by the faulting
thread instead of the iouring thread. This reduces caching effects as
the data is likely to be used by the faulting thread and find_vma()
cannot use its cache on the iouring worker.

I will provide some benchmark results later, but some initial results
show that these patches reduce the overhead of handling a user
page-fault by over 50%.

The patches require a bit more cleanup but seem to pass the tests.

Note that the first three patches are bug fixes. I did not Cc them to
stable yet.

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Nadav Amit (13):
  fs/userfaultfd: fix wrong error code on WP & !VM_MAYWRITE
  fs/userfaultfd: fix wrong file usage with iouring
  selftests/vm/userfaultfd: wake after copy failure
  fs/userfaultfd: simplify locks in userfaultfd_ctx_read
  fs/userfaultfd: introduce UFFD_FEATURE_POLL
  iov_iter: support atomic copy_page_from_iter_iovec()
  fs/userfaultfd: support read_iter to use io_uring
  fs/userfaultfd: complete reads asynchronously
  fs/userfaultfd: use iov_iter for copy/zero
  fs/userfaultfd: add write_iter() interface
  fs/userfaultfd: complete write asynchronously
  fs/userfaultfd: kmem-cache for wait-queue objects
  selftests/vm/userfaultfd: iouring and polling tests

 fs/userfaultfd.c                         | 740 ++++++++++++++++----
 include/linux/hugetlb.h                  |   4 +-
 include/linux/mm.h                       |   6 +-
 include/linux/shmem_fs.h                 |   2 +-
 include/linux/uio.h                      |   3 +
 include/linux/userfaultfd_k.h            |  10 +-
 include/uapi/linux/userfaultfd.h         |  21 +-
 lib/iov_iter.c                           |  23 +-
 mm/hugetlb.c                             |  12 +-
 mm/memory.c                              |  36 +-
 mm/shmem.c                               |  17 +-
 mm/userfaultfd.c                         |  96 ++-
 tools/testing/selftests/vm/Makefile      |   2 +-
 tools/testing/selftests/vm/userfaultfd.c | 835 +++++++++++++++++++++--
 14 files changed, 1506 insertions(+), 301 deletions(-)

-- 
2.25.1

