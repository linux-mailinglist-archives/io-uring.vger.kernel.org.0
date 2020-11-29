Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BAA2C76F3
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgK2Au1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbgK2AuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:24 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C286CC0613D4;
        Sat, 28 Nov 2020 16:49:59 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 34so7361490pgp.10;
        Sat, 28 Nov 2020 16:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D/z5ByovhoEdVL8szr+fSEwF5ZNkk28Asd+MEkdD3Ag=;
        b=GziQO65x+u6+WDoZ+XN9JcohGtqXWOJB/8548oruYWdOlTqqFPBl9BOvrXP6yjikxi
         WBeU7LZiVpLv/RPCN6vQAx7JQEBFD7Znjv0EIbOdHYXbdRlYANazPi4waUhUVlvIh88m
         Q8HguvIVtgJGhFjl5CRq5b6n0ktK0tMI59BRDIfaxO8hpYFVjvJk7wD/9gR2LLvfb/Ee
         cvt/Uy8Wcy0eFMX34cPqt5c3oPNHvDO17d+eZVvJD1aRe6YbN7bDZEbYmNjSQUKqGRJi
         +d99YpQ7fcQFDZVBCy1y+/hzuY9kQCkbk6RG2sLp2JbLY8njbQFAKac7o5BMBlKwbuQm
         Nnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/z5ByovhoEdVL8szr+fSEwF5ZNkk28Asd+MEkdD3Ag=;
        b=QB4PSAIJP5ntvbedyGRXnTuhDL47wMl6Ai6TlsGdm5vEDGKykxctDPpWy9Ur5XAV8b
         2Mcy++P5qiWeoDzpNQXLCGlqx2XCaOMbG0NlzPC8ASv6XCTbanIQ7Z6SDiFlV1c2bmSU
         SJi7YJpadFlmfqjqKGRyfI8mfdGZr6fKdptGEM5/yTFKXo5LyIdJwUcglZPQ8gSvfCVo
         jM8bnwm3XRKUdZgUMl50Qj1Qb7SSwT/a3p5Lh4/HSwxCLd24gZZbc6I/rPQyZgHz5I3k
         bwLjAfhAq4kmHJraJdX8liAZ3L3aXxFH8+7JJDGdHT4bAQgQO+FAHhCTW0bJ+XaHLJF1
         ULlg==
X-Gm-Message-State: AOAM533uEabqtyz0WsFUk2SzuonJySWR8pF72sNaM3/eX7/gQiD59BAh
        NjTNw2AV+6OVRRSxvM7WQgChmMnAr/cibw==
X-Google-Smtp-Source: ABdhPJx5I5FhNnaPnDfa9lHm0Zbkp/wck0FGO+VujxBdT+kZFIITcdBhelWGIcdFEAHPv5tn7RTRdA==
X-Received: by 2002:a63:ca4d:: with SMTP id o13mr12226852pgi.116.1606610998789;
        Sat, 28 Nov 2020 16:49:58 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:49:58 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 03/13] selftests/vm/userfaultfd: wake after copy failure
Date:   Sat, 28 Nov 2020 16:45:38 -0800
Message-Id: <20201129004548.1619714-4-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
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
index 9b0912a01777..f7e6cf43db71 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -484,6 +484,18 @@ static void retry_copy_page(int ufd, struct uffdio_copy *uffdio_copy,
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
@@ -507,6 +519,7 @@ static int __copy_page(int ufd, unsigned long offset, bool retry)
 				uffdio_copy.copy);
 			exit(1);
 		}
+		wake_range(ufd, uffdio_copy.dst, page_size);
 	} else if (uffdio_copy.copy != page_size) {
 		fprintf(stderr, "UFFDIO_COPY unexpected copy %Ld\n",
 			uffdio_copy.copy); exit(1);
-- 
2.25.1

