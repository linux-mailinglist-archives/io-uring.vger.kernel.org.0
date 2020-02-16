Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CAE1603C8
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 12:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgBPLPi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 06:15:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39202 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgBPLPi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 06:15:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so16181072wrt.6
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 03:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=axmBCiB2ZOJFudmjUg1i1mRkrUqk1s6EhOoMP3eebYo=;
        b=WSGFe9i5OpGgpmZlF8Y7B5lOM88Dkv5/aIm5aFK0S4o5R6AsvyDuu6eaRm7AQZKwYC
         le+L1LVMHgIMk0RVma5p09eOKTBqcybyyXaOCAAcEs45hYjdR2m2bvMJ6wvJdK+OMyNo
         cN0KjfYJSs8QeMOaMBGJwYMJYeseIhVMA8+zfNZYcteK8FrlziLlOZ2v0cNygZ551vYP
         9mqTbfUtTUe2Qaqnpdfi/Lmuwkj5c5lf4gJTa+OsTyNCcXnZKLY1z4/2Rz4/G7No8gq2
         3v4XHfbJsX9iJHzEdPSZn4PIgSM84HBAiXF9gaH6UKaMEFQZmbM32+XR+ZP6FcoynlnZ
         lkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axmBCiB2ZOJFudmjUg1i1mRkrUqk1s6EhOoMP3eebYo=;
        b=Ln0aHz5zKEbQN4NKHmqleMoNP8LFd9LLj+r19ggE6412QqoQV9ni3YnGQrF4wKyUyX
         MpOVLtynA4vUOckzII4c6eWKm0Q8G5CucjjrGg0VOJxIYc2WrbZlR72mFRoAp61zDuKF
         1cn5guedSbTXnNpTaIBQuU4Y510MW88f8vfetXRmQUOWT1nxlqM3zcQJB9UJ1ulHeNQO
         Ej85O94Z4WP20W0tHvidI6IURuxhz1tVBI0w6xVij0I12qU5MZTQKU3oPMHjG2SxxRUY
         awSB0acSKgZX8+kzBDBtc2i1r1j03r7ybXL1ZrtGRSD+ylJr9hnJu9lXvEnnALshzfxX
         bsJw==
X-Gm-Message-State: APjAAAU9Y0VZF1hTWZbewonBqg/PO90PUDhasyXAsSg7qneNMgugiFJC
        Z++CBy+GSsyaM/c0PgUgtpjGlqA/
X-Google-Smtp-Source: APXvYqwWDuKStHjApcVw1iWd/GmBquZannsdxIRQguNCYndE6izSOfkubfwrwMekpQUAUF1shfJGBg==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr16207771wre.372.1581851736378;
        Sun, 16 Feb 2020 03:15:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.140.114])
        by smtp.gmail.com with ESMTPSA id 25sm16232033wmi.32.2020.02.16.03.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 03:15:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] splice: add splice(2) helpers
Date:   Sun, 16 Feb 2020 14:14:40 +0300
Message-Id: <a49db514f8b0b7d509c50ed0185688ece5830363.1581851604.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581851604.git.asml.silence@gmail.com>
References: <cover.1581851604.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice helpers and update io_uring.h

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h          | 11 +++++++++++
 src/include/liburing/io_uring.h | 14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 8ca6cd9..9ff2a54 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -191,6 +191,17 @@ static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 	sqe->__pad2[0] = sqe->__pad2[1] = sqe->__pad2[2] = 0;
 }
 
+static inline void io_uring_prep_splice(struct io_uring_sqe *sqe,
+					int fd_in, loff_t off_in,
+					int fd_out, loff_t off_out,
+					unsigned int nbytes, int splice_flags)
+{
+	io_uring_prep_rw(IORING_OP_SPLICE, sqe, fd_out, (void *)off_in,
+			 nbytes, off_out);
+	sqe->splice_fd_in = fd_in;
+	sqe->splice_flags = splice_flags;
+}
+
 static inline void io_uring_prep_readv(struct io_uring_sqe *sqe, int fd,
 				       const struct iovec *iovecs,
 				       unsigned nr_vecs, off_t offset)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 424fb4b..dc78697 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -23,7 +23,10 @@ struct io_uring_sqe {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
 	};
-	__u64	addr;		/* pointer to buffer or iovecs */
+	union {
+		__u64	addr;	/* pointer to buffer or iovecs */
+		__u64	off_in;
+	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
 		__kernel_rwf_t	rw_flags;
@@ -37,6 +40,7 @@ struct io_uring_sqe {
 		__u32		open_flags;
 		__u32		statx_flags;
 		__u32		fadvise_advice;
+		__u32		splice_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -45,6 +49,7 @@ struct io_uring_sqe {
 			__u16	buf_index;
 			/* personality to use, if used */
 			__u16	personality;
+			__u32	splice_fd_in;
 		};
 		__u64	__pad2[3];
 	};
@@ -113,6 +118,7 @@ enum {
 	IORING_OP_RECV,
 	IORING_OP_OPENAT2,
 	IORING_OP_EPOLL_CTL,
+	IORING_OP_SPLICE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -128,6 +134,12 @@ enum {
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
 
+/*
+ * sqe->splice_flags
+ * extends splice(2) flags
+ */
+#define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.24.0

