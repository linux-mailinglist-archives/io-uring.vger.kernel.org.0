Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101AA2C8DF2
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgK3TVU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbgK3TVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 14:21:09 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16123C0613D6
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:20:29 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id p8so17735995wrx.5
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yRbEc/xiARjxbSt19/KTGYFwnE31Op1SY0hUuBSc+fM=;
        b=naaQVHRJ461h8AkGhsHW88M5c/jIa6sva9pBAb7K+6qY8cH3xXbPFH3oQD9nhJ8A9A
         PLllVbbBt7Cq4MpvIilpLjxDSh0HfMdG1YqhJKDmzPEExiAuvxnm33TXGcIoyofZ/Ub7
         Zjv1K7egxNGY3F9Ho7hyuKO7I0WZ+yyVPB9ToyUvWuDaQtAp7UyJLQmRwx7V1i+jsEnP
         lC6VilMqalD+7vlqU/bOgrWFvnFMCz33W1f5IYcMc7T+WT+bvPSqkLiynVB9/wzVhOOh
         X++fxrtQl5mNQP5cw5toPfN/sxDr3qqndpAkqc/IrAlI+vEyHV4Y4bRsRESRDibTl9hv
         b9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yRbEc/xiARjxbSt19/KTGYFwnE31Op1SY0hUuBSc+fM=;
        b=RTjq0Xd0tl+dRKsjYTmJEfchtOjQyqIpC02rK1zeBVaCBp/+WxQvA2iJfUVRLjculc
         KVuyXHz4kNM10nWHU8oBPORjzZ1Tvx3kxlkHNNA23BdvnDIQwF5CDbIXcTZ8nzaqlnHG
         ojORKWUkmbIUr45oVwnnM+ygim/h23MEjlhnk7nawtpMg8Krol0kTDWefmhzJ7jChUQ+
         BMP0R+zxkKm49PBaQ4skYVnN41wM1iQ5YND5T1Hhuzr1uCKAvS1GPXWxTGLDAQEbB6o2
         93diFgvPWPyW35B1ZUlnxL3vGy46Wet1+wF/sHFr1arvI+3k476+oBv1Su/z2TMjrD0S
         rxzQ==
X-Gm-Message-State: AOAM530dgZ+u3lpGPtNlR4KhLMQlcQHIKw+3W7dL3D0txPuG9oTfPKF7
        cnqecMTv1Gh1N7VPaQ9NsF1bEYXMeXKmjQ==
X-Google-Smtp-Source: ABdhPJzaknZEEePq/e3Rf8kxfnZ8aSEYWbop9lX+65Jk7mwgHSw2O4f5n3qrynTfGO0XZIHKfSmJAA==
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr29822012wrr.64.1606764025412;
        Mon, 30 Nov 2020 11:20:25 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id i11sm29886775wrm.1.2020.11.30.11.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:20:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 1/2] Add timeout update
Date:   Mon, 30 Nov 2020 19:17:01 +0000
Message-Id: <242ea3b5898da635d753ea62747fb16ff84d4eca.1606763705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606763704.git.asml.silence@gmail.com>
References: <cover.1606763704.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_uring_prep_timeout_update() helper and update io_uring.h.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h          | 9 +++++++++
 src/include/liburing/io_uring.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index cc32232..ebfc424 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -326,6 +326,15 @@ static inline void io_uring_prep_timeout_remove(struct io_uring_sqe *sqe,
 	sqe->timeout_flags = flags;
 }
 
+static inline void io_uring_prep_timeout_update(struct io_uring_sqe *sqe,
+						struct __kernel_timespec *ts,
+						__u64 user_data, unsigned flags)
+{
+	io_uring_prep_rw(IORING_OP_TIMEOUT_REMOVE, sqe, -1,
+				(void *)(unsigned long)user_data, 0, (__u64)ts);
+	sqe->timeout_flags = flags | IORING_TIMEOUT_UPDATE;
+}
+
 static inline void io_uring_prep_accept(struct io_uring_sqe *sqe, int fd,
 					struct sockaddr *addr,
 					socklen_t *addrlen, int flags)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 8555de9..0bb55b0 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -155,6 +155,7 @@ enum {
  * sqe->timeout_flags
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
+#define IORING_TIMEOUT_UPDATE	(1U << 1)
 
 /*
  * sqe->splice_flags
-- 
2.24.0

