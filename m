Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562C62C76FA
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgK2Auq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729806AbgK2Aup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:45 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B13FC061A47;
        Sat, 28 Nov 2020 16:50:04 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id e23so2521637pgk.12;
        Sat, 28 Nov 2020 16:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Outm6gEC+5HjahTktjjf3Gr4SlDabvLvwFKs6X9GaDo=;
        b=JXkc1J0m8q1ntIjEb8P0oB7txqBuFASeZRfk+omNYk7PSIF9Lb17UYXJw0JZ44Gvpu
         vyhiqCx0fLhJxtWz3BHww882rkN3VXTSCye4KO03ADZCppgAWMFaAD0YnJT5b/5O6paR
         dUvmyrw1IZ8lY1XsFTTaA68OALCpBgBHx4qfU7F3wjQ0GyEWepLcJ1JzQMwaWUVlUxKf
         UTbFHlb8xVyN2aoazAVCVQzhdJmgZ5e9051KiaGjAM7aUu/VmRaReDB+JVMH1qZjVrk9
         P2PAA86vJxpTRJRyw+R+AJyq6lCuWHsizPj3XM9Kj3MgyjYSTTjf3F/9kbLLIBIbmyPo
         cVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Outm6gEC+5HjahTktjjf3Gr4SlDabvLvwFKs6X9GaDo=;
        b=llTR8aAILYkqYv8J6Iy0Zjm3LMkYIew8Vs9Zrzx5Upa+3syBtt2paihl+m+Er67ur2
         QKG5zqSz/zWdjW0S1OoWO1q2UR6l7urn3S8kzv6JpSH00UrljBjzm/OTFdRODuzllF4J
         Aibp6eJcKKd7MZJ4sodbWk+tFB6x5Exvp53w+CPBOQFHp62T7FN8OcH72KwvtpvSwqmw
         9iGY4pXfnbYuIh7tIYOWSZK+C1hDNbUnYR5I3Wo5e4uhDd0slrbivHUh0yJswUIrP9CV
         UUAXwMS/bDATfAsbt6fjFKjJ0DEjsgoMRHwnSKSXIgJNAlSvPkJMy86iyZv2Fy1Cxn8K
         9Iww==
X-Gm-Message-State: AOAM532Bj5OASHFz+L0XOznC/Jp/NCOJ3AV8285w+Hpfvsuu4FwdVWOM
        zyr+npw6Jnc3hL9Gv6TqdkAcCHeQdk1eZg==
X-Google-Smtp-Source: ABdhPJz2e8ontBvjHCkwTIZD/Q/8yELGY7l4hU7c2tROHTtsG+mu9LU/UdHzbTu+WsuKZa2yKMHsQw==
X-Received: by 2002:a63:531b:: with SMTP id h27mr11647606pgb.371.1606611003080;
        Sat, 28 Nov 2020 16:50:03 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:02 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 06/13] iov_iter: support atomic copy_page_from_iter_iovec()
Date:   Sat, 28 Nov 2020 16:45:41 -0800
Message-Id: <20201129004548.1619714-7-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

copy_page_from_iter_iovec() cannot be used when preemption is enabled.

Change copy_page_from_iter_iovec() into __copy_page_from_iter_iovec()
with an additional parameter that says whether the caller runs in atomic
context. When __copy_page_from_iter_iovec() is used in an atomic context
it will gracefully fail but would not lead to a deadlock. The caller
is expected to recover from such failure gracefully.

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
 include/linux/uio.h |  3 +++
 lib/iov_iter.c      | 23 +++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..7c90f7371a6f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -121,6 +121,9 @@ size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
+size_t __copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i, bool atomic);
+
 
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..e597df6a46a7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -246,7 +246,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 }
 
 static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t bytes,
-			 struct iov_iter *i)
+			 struct iov_iter *i, bool atomic)
 {
 	size_t skip, copy, left, wanted;
 	const struct iovec *iov;
@@ -259,14 +259,15 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 	if (unlikely(!bytes))
 		return 0;
 
-	might_fault();
+	if (!atomic)
+		might_fault();
 	wanted = bytes;
 	iov = i->iov;
 	skip = i->iov_offset;
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
+	if (atomic || (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy))) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -295,6 +296,9 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 		buf += copy;
 		kunmap_atomic(kaddr);
 		copy = min(bytes, iov->iov_len - skip);
+		if (atomic)
+			goto done;
+
 	}
 	/* Too bad - revert to non-atomic kmap */
 
@@ -929,8 +933,8 @@ size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 }
 EXPORT_SYMBOL(copy_page_to_iter);
 
-size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
-			 struct iov_iter *i)
+size_t __copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i, bool atomic)
 {
 	if (unlikely(!page_copy_sane(page, offset, bytes)))
 		return 0;
@@ -944,7 +948,14 @@ size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 		kunmap_atomic(kaddr);
 		return wanted;
 	} else
-		return copy_page_from_iter_iovec(page, offset, bytes, i);
+		return copy_page_from_iter_iovec(page, offset, bytes, i, atomic);
+}
+EXPORT_SYMBOL(__copy_page_from_iter);
+
+size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i)
+{
+	return __copy_page_from_iter(page, offset, bytes, i, false);
 }
 EXPORT_SYMBOL(copy_page_from_iter);
 
-- 
2.25.1

