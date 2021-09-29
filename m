Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F222C41C289
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbhI2KTP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245538AbhI2KSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:18:54 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ADAC06176F
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j14so1177449plx.4
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NS4JvnSQLrAyYv5FTZFjg7FprLbXY3tGvNy3DVKR7/8=;
        b=CYZ9EoJmvveFBJdtQ/PGTibSmOgKp2o29B77lkPw1lXZ/zOeJeIPX5kLqbF0Yq76ha
         Sk2cDPwiR79iydPhJkK2VFg4CYT/6sRIId4lL5luHgVRHVOZsKNG2VZh4GQ0Gw4B0VEe
         2OqQVm+/uPCk2RtTWqXKfc9ZjTCm03D41zE2sxVpEV2M/N+6D2zBYoM/+3coxBA8g7L1
         +K9Dp/2MGJh8iPtTenRdnnpxq75ZaL6xi69xiTY0v6XWLLglf2kJjKmjUX0bbu8N/YG6
         8RVAL3VEMmJOwPG1teCdX6G4eB7zoHEUEyFge0Ba5myzDypCeHN/4Hj///gw+T/KSraS
         ti7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NS4JvnSQLrAyYv5FTZFjg7FprLbXY3tGvNy3DVKR7/8=;
        b=ey2DRlIdWVifUZldJJJOdEXo3MhXGuP60EjFBWweFU7J33mnjF+5joCU0uErWkp+VU
         z+FiuDS00P/kVWJzq18q693ZaVcCL9eQMp6NLmFFR5UBQt6oTfPUlCre9A9kAzlgHsiy
         KERcPzh13zM6gPAuAtvsmK9O5I2iZ+Veb5p+sN0JR+UfXZSaG5YhXzD/uNOWqO6fbQOl
         DmRLN1pZS7TpFoEPuZB8GqMSOFh+W0AX1iZ4oLJ+1TztcWUr9H4pjp4dlg8cUtPFPaMu
         ICDo7q75loPB9tZz2oDWncp8Ijp9xj/nVPjCzmRAXqe1qt/7Spp4ZBhVqWZ3mr+k70+9
         4ntQ==
X-Gm-Message-State: AOAM532jFLeThFrs53r8lmilTyENqpKVSbOQ7bcH4X30O1HS7YU8eLl3
        FgqeH3Cu9TLcboJiCcB0MI/aBMyD6EBrBBVKAX6n+h6h
X-Google-Smtp-Source: ABdhPJyIKzjzKLzwwWPr640Ie6m3pTsLMV5m7SY6m+6IRQhtRwny3/cGG5IEUX/j7aDOE/UPXYU2ag==
X-Received: by 2002:a17:90b:1bc5:: with SMTP id oa5mr1375895pjb.224.1632910631424;
        Wed, 29 Sep 2021 03:17:11 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:17:10 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCHSET v1 RFC liburing 4/6] Add `liburing_madvise()`
Date:   Wed, 29 Sep 2021 17:16:04 +0700
Message-Id: <20210929101606.62822-5-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do not use `madvise()` directly from the libc in the liburing internal
sources. Wrap them in `src/syscall.c`. This is the part of implementing
the kernel style return value (which later is supposed to support no
libc environment).

`liburing_madvise()` does the same thing with `madvise()` from the libc.
The only different is when error happens, the return value is of
`liburing_madvise()` will be a negative error code.

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/setup.c   | 18 +++++++++---------
 src/syscall.c |  8 ++++++++
 src/syscall.h |  1 +
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index 01cb151..52f3557 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -120,20 +120,20 @@ int io_uring_ring_dontfork(struct io_uring *ring)
 		return -EINVAL;
 
 	len = *ring->sq.kring_entries * sizeof(struct io_uring_sqe);
-	ret = madvise(ring->sq.sqes, len, MADV_DONTFORK);
-	if (ret == -1)
-		return -errno;
+	ret = liburing_madvise(ring->sq.sqes, len, MADV_DONTFORK);
+	if (uring_unlikely(ret))
+		return ret;
 
 	len = ring->sq.ring_sz;
-	ret = madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
-	if (ret == -1)
-		return -errno;
+	ret = liburing_madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
+	if (uring_unlikely(ret))
+		return ret;
 
 	if (ring->cq.ring_ptr != ring->sq.ring_ptr) {
 		len = ring->cq.ring_sz;
-		ret = madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
-		if (ret == -1)
-			return -errno;
+		ret = liburing_madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
+		if (uring_unlikely(ret))
+			return ret;
 	}
 
 	return 0;
diff --git a/src/syscall.c b/src/syscall.c
index cb48a94..44861f6 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -133,3 +133,11 @@ int liburing_munmap(void *addr, size_t length)
 	ret = munmap(addr, length);
 	return (ret < 0) ? -errno : ret;
 }
+
+int liburing_madvise(void *addr, size_t length, int advice)
+{
+	int ret;
+
+	ret = madvise(addr, length, advice);
+	return (ret < 0) ? -errno : ret;
+}
diff --git a/src/syscall.h b/src/syscall.h
index feccf67..32381ce 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -29,5 +29,6 @@ int ____sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 void *liburing_mmap(void *addr, size_t length, int prot, int flags, int fd,
 		    off_t offset);
 int liburing_munmap(void *addr, size_t length);
+int liburing_madvise(void *addr, size_t length, int advice);
 
 #endif
-- 
2.30.2

