Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C083E37F2
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 04:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhHHCIM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 22:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhHHCIL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 22:08:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88B3C061760;
        Sat,  7 Aug 2021 19:07:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so28793796pjs.0;
        Sat, 07 Aug 2021 19:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1KFCzgzs6/mkJLTZRMdu7KL4aRMw+QDalF1MyA5qyPc=;
        b=c1jmo4avM+j7qm/Hvn4rEviWxWdp0pbR8TMWAvIa31LCIWFMHOZDm7tiys7Czcb+26
         CBtHJ07AbujN0rJgMi1sRutrTqJV0PR/Vx5LI3MHcT7nwIjcvyOhVlfqDZdjx+9zCeds
         nTjLHdGvAfcJoDzCFcdmi4aNHdrP6PF0C72yVYyXjbB88jvhpV1HuNKPlaQlU4Wkrc3F
         2slbAD7Ve6CiwjOKbnIfKm6JM0BnL20IQvycWHiaNZBJw10ZWYCwqTuvZjt+jZszQSE6
         wCrGbsO+HvUN/cd4AzMzRZoFrZku4zo8ndOU6uR2CJm0ELT5gvIlDhbF72QvPVUZ7laM
         v+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1KFCzgzs6/mkJLTZRMdu7KL4aRMw+QDalF1MyA5qyPc=;
        b=j7E62lT9sLDriE33PY3NKP4cOojwZrdNcFXpdsiYNhbR/PDJ4dDxfmVZaCoquU4EZk
         vnKKNL59PBYq9cjup874xjBiNLivR0suh/2KILqF4LtUhcK6GiE9EDMsvPGtWyVEwII6
         RDTJ+b9r+a/Qv3VY4X/38VO/rbxY8auZH7uRkmmRzf5Y6ryi+FJst5ys/BSv7gczRnS8
         FjpcAb9QAW1Qto6bTHAfGaXUHGc0fdqRh8vCrgu6azNtbjFeU0yrg4qeo8bdRbH5CFrQ
         OW+6j5wrBG8tYVLYnHcmh+F2UgagJ4DWPAiTMA2Nv3J0UwsV3cYiVEZAK6yGu8sZxGXy
         npuw==
X-Gm-Message-State: AOAM533ntTnYMK5e+1hb7Kr6MyW9EdoqwZPLxnBKd8mVspSrfRk4PpJA
        WkjvRbE/9tDABpavtA5vKZFFRpEGtxKD/A==
X-Google-Smtp-Source: ABdhPJytvGw2/Z+5f1wuXCQ77/SUg5Bv0uYeWV5Hra0kqSaDResaqJ/hxaWnIOzmCfUPHdwMjak1Tg==
X-Received: by 2002:a05:6a00:c81:b029:30e:21bf:4c15 with SMTP id a1-20020a056a000c81b029030e21bf4c15mr17944810pfv.70.1628388473101;
        Sat, 07 Aug 2021 19:07:53 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id o18sm3987432pjp.1.2021.08.07.19.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 19:07:52 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Pavel Emelyanov <xemul@parallels.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] selftests/vm/userfaultfd: wake after copy failure
Date:   Sat,  7 Aug 2021 19:07:24 -0700
Message-Id: <20210808020724.1022515-4-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808020724.1022515-1-namit@vmware.com>
References: <20210808020724.1022515-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

When userfaultfd copy-ioctl fails since the PTE already exists, an
-EEXIST error is returned and the faulting thread is not woken. The
current userfaultfd test does not wake the faulting thread in such case.
The assumption is presumably that another thread set the PTE through
copy/wp ioctl and would wake the faulting thread or that alternatively
the fault handler would realize there is no need to "must_wait" and
continue. This is not necessarily true.

There is an assumption that the "must_wait" tests in handle_userfault()
are sufficient to provide definitive answer whether the offending PTE is
populated or not. However, userfaultfd_must_wait() test is lockless.
Consequently, concurrent calls to ptep_modify_prot_start(), for
instance, can clear the PTE and can cause userfaultfd_must_wait()
to wrongly assume it is not populated and a wait is needed.

There are therefore 3 options:
(1) Change the tests to wake on copy failure.
(2) Wake faulting thread unconditionally on zero/copy ioctls before
    returning -EEXIST.
(3) Change the userfaultfd_must_wait() to hold locks.

This patch took the first approach, but the others are valid solutions
with different tradeoffs.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 tools/testing/selftests/vm/userfaultfd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 2ea438e6b8b1..10ab56c2484a 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -566,6 +566,18 @@ static void retry_copy_page(int ufd, struct uffdio_copy *uffdio_copy,
 	}
 }
 
+static void wake_range(int ufd, unsigned long addr, unsigned long len)
+{
+	struct uffdio_range uffdio_wake;
+
+	uffdio_wake.start = addr;
+	uffdio_wake.len = len;
+
+	if (ioctl(ufd, UFFDIO_WAKE, &uffdio_wake))
+		fprintf(stderr, "error waking %lu\n",
+			addr), exit(1);
+}
+
 static int __copy_page(int ufd, unsigned long offset, bool retry)
 {
 	struct uffdio_copy uffdio_copy;
@@ -585,6 +597,7 @@ static int __copy_page(int ufd, unsigned long offset, bool retry)
 		if (uffdio_copy.copy != -EEXIST)
 			err("UFFDIO_COPY error: %"PRId64,
 			    (int64_t)uffdio_copy.copy);
+		wake_range(ufd, uffdio_copy.dst, page_size);
 	} else if (uffdio_copy.copy != page_size) {
 		err("UFFDIO_COPY error: %"PRId64, (int64_t)uffdio_copy.copy);
 	} else {
-- 
2.25.1

