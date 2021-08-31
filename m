Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E632C3FCB00
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 17:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhHaPrK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 11:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbhHaPrJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 11:47:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4DBC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 08:46:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q14so28486530wrp.3
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 08:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MT8vtfshxCJnLvDocKdAz90zNScNIKogCIbklr4IzZc=;
        b=uYz6UlakzI/1ZNmYAWHL/yNFYlvxr6lFQmF8sm5OccylN8mv4D6EtQbUWjJn5Ygvnk
         hgM5Hpb0lOxkQXJnW6OpKKMHdOVuz6FI+VwZfUT2UktFo8GXLO8lkV1tmVEOTf5wu8sk
         4wtmoyzV6Mpk4hoVOhS3fuFeCevxXOrcNsyV4Cf99ZjfG60cU7ln0MfmmCEMGyVtuSL5
         OXXCAlxH37mRH+B1LszyfG+ms9Xm5hxKHGEEsd1mCu3OlhyDFF4uNrO2xVHgjdqzlGX9
         bkXjGCpyCvZlIY9NyI1+Kli++CqmmgZnQ2H02odT53BqvSH88yxuddAHyuiVXz9qxxhv
         +0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MT8vtfshxCJnLvDocKdAz90zNScNIKogCIbklr4IzZc=;
        b=IXtQXWW14uEA3HAjvVTLiuqXa2Kl3qcPWh0C98VcxMre1u2hRdDMK2CsJzivY+ZthG
         O9D/pHTfWi65fr2+SkTaipOZB1hNS0JsmC6XPNYrEpvjN7c/Xup7DEdLDyGIxJfpSTGj
         QNlbmbv9ajbuJmo6IOKReNHKMbKdC9I4mkunBki4xFUmyzhoHjlZylbomOK+pWYDcR+f
         ACUlk6yeB4r9i9Kp4TBc20N6pGtnk1vu8u9dY7M8PCZsTccXCceMCpkBf65UNjhBTORS
         tFf5V3DRu8ObNFLvHdB7v8nSSvHd329Re7Sh+RU9J/oBGsFJIxWBj9kW7MR39HEu4pt9
         dLsA==
X-Gm-Message-State: AOAM532tSWh0n5ey5NISFGJEZGRui9Kp2YUWEHy1k6uKe0PrEFZu68aW
        lEPzHP1cf/eiRxhREeues+Z+7GSMbNM=
X-Google-Smtp-Source: ABdhPJxZubdUefMoHNbT+v6jUTDRwgR8zLDCBYrQ0+hhV4dugIMo7zm4twz5fi1uNgKLQZE3lhAjBg==
X-Received: by 2002:adf:eac5:: with SMTP id o5mr31973223wrn.22.1630424772809;
        Tue, 31 Aug 2021 08:46:12 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id t11sm3003591wmi.23.2021.08.31.08.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 08:46:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH liburing v2] liburing: add helpers for direct open/accept
Date:   Tue, 31 Aug 2021 16:45:34 +0100
Message-Id: <b0f00ddc38cdcf1cdd1c93f7fa36c156b0db7b2e.1630424687.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We allow openat/openat2/accept to place new files right into the
internal fixed table, add helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: fix test fallbacks for older releases

 src/include/liburing.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 7b364ce..3b9cfb5 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -231,6 +231,13 @@ static inline void io_uring_sqe_set_flags(struct io_uring_sqe *sqe,
 	sqe->flags = flags;
 }
 
+static inline void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
+						    unsigned int file_index)
+{
+	/* 0 means no fixed files, indexes should be encoded as "index + 1" */
+	sqe->file_index = file_index + 1;
+}
+
 static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 				    const void *addr, unsigned len,
 				    __u64 offset)
@@ -423,6 +430,16 @@ static inline void io_uring_prep_accept(struct io_uring_sqe *sqe, int fd,
 	sqe->accept_flags = flags;
 }
 
+/* accept directly into the fixed file table */
+static inline void io_uring_prep_accept_direct(struct io_uring_sqe *sqe, int fd,
+					       struct sockaddr *addr,
+					       socklen_t *addrlen, int flags,
+					       unsigned int file_index)
+{
+	io_uring_prep_accept(sqe, fd, addr, addrlen, flags);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+}
+
 static inline void io_uring_prep_cancel(struct io_uring_sqe *sqe, void *user_data,
 					int flags)
 {
@@ -467,6 +484,17 @@ static inline void io_uring_prep_openat(struct io_uring_sqe *sqe, int dfd,
 	sqe->open_flags = flags;
 }
 
+/* open directly into the fixed file table */
+static inline void io_uring_prep_openat_direct(struct io_uring_sqe *sqe,
+					       int dfd, const char *path,
+					       int flags, mode_t mode,
+					       unsigned file_index)
+{
+	io_uring_prep_openat(sqe, dfd, path, flags, mode);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+}
+
+
 static inline void io_uring_prep_close(struct io_uring_sqe *sqe, int fd)
 {
 	io_uring_prep_rw(IORING_OP_CLOSE, sqe, fd, NULL, 0, 0);
@@ -529,6 +557,16 @@ static inline void io_uring_prep_openat2(struct io_uring_sqe *sqe, int dfd,
 				(uint64_t) (uintptr_t) how);
 }
 
+/* open directly into the fixed file table */
+static inline void io_uring_prep_openat2_direct(struct io_uring_sqe *sqe,
+						int dfd, const char *path,
+						struct open_how *how,
+						unsigned file_index)
+{
+	io_uring_prep_openat2(sqe, dfd, path, how);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+}
+
 struct epoll_event;
 static inline void io_uring_prep_epoll_ctl(struct io_uring_sqe *sqe, int epfd,
 					   int fd, int op,
-- 
2.33.0

