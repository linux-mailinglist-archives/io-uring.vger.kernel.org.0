Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA2B162F81
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 20:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgBRTNX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 14:13:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34769 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgBRTNX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 14:13:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id n10so23388184wrm.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 11:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=b+vvkUBSiFZDLvqouVu5OTzEtjxjRdlXF5VUDV4XS5w=;
        b=mX2ck5vF0DpTW8PzQ25MZrWHzPvzC/o/RlkJi86nSRkOM+cNqSWG9ulQ68NGDRcjPl
         rJZr3pM1BvaC7FxP5dV1mstT3UpBdz1upFexg90t+UkEeB7PKHAo95SpkwQ1ZxPOq71W
         foZc1dN7Osl/I4ki8/W/+5QCJRy94VJbBSc6g2aJ4rz0Tnc+h2Ae+PL+HrZKwLc4G0FK
         P538fKm+sH6jWazTo3gWGIxciulRe/MASn9Jx61h3KE6shWCDqYvq/ijtej+/h3beOYy
         gGFIxH3piV3nqh9AyQ2wv3JSJSoLECbvjL5u656r6bGl9nTtZqBv84zQOM48YKOXUUcy
         g0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b+vvkUBSiFZDLvqouVu5OTzEtjxjRdlXF5VUDV4XS5w=;
        b=EeSKl0moS/qq4lSPcUQ1W6ao780n/7M8uF2sAWvjfbk7hd57aLO/0ZBIg5POmVeVjj
         0o1YSMfT3sQ6o+wXhc+YMD5qnz28fdSXMwP0XBtEal8y9nV9+9Pc5znAEFK9co1KF6FQ
         n6G5HvIzBmKBj9mNHMe4C8zbMgbYfKAaQ7OuZFW3qln+oA94TxDfE6E1w4vCsU9JtoMJ
         CRwTUEzZwS2RDeM8SxU/KxoRLOrbw6fSCVazHHx3NJOCtITiSkUZhmpEOIlf+zqXUu9w
         1u5sSlJrKWq8aKpJHTDrYk8EW50OLwDhGUmfDIDYTEnjoehL8f2WTd1GgyIrEmbU5DLr
         WlFQ==
X-Gm-Message-State: APjAAAUdbYD2Qf/NJY6teVvdmakZjuFhjCLFGOk2VH8Z6rS0fuAtjS8v
        n5+F0flrpKFJQjfqE+vKjw0=
X-Google-Smtp-Source: APXvYqwNZyvW29CH+k8mdZPgDHWjEYEpLozlOy7Ms5Nu/+eoToJ5VXEa7rI4v9QV4S1CUv07m0dVzw==
X-Received: by 2002:adf:cd91:: with SMTP id q17mr31062761wrj.306.1582053200107;
        Tue, 18 Feb 2020 11:13:20 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id h10sm4623561wml.18.2020.02.18.11.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:13:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH liburing v3 1/2] splice: add splice(2) helpers
Date:   Tue, 18 Feb 2020 22:12:29 +0300
Message-Id: <051b5c55ee2d2dc917b84408eccb2cdb42384957.1582052625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582052625.git.asml.silence@gmail.com>
References: <cover.1582052625.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice helpers and update io_uring.h

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h          | 12 ++++++++++++
 src/include/liburing/io_uring.h | 14 +++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 8ca6cd9..0e33640 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -191,6 +191,18 @@ static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 	sqe->__pad2[0] = sqe->__pad2[1] = sqe->__pad2[2] = 0;
 }
 
+static inline void io_uring_prep_splice(struct io_uring_sqe *sqe,
+					int fd_in, loff_t off_in,
+					int fd_out, loff_t off_out,
+					unsigned int nbytes,
+					unsigned int splice_flags)
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
index 424fb4b..755c130 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -23,7 +23,10 @@ struct io_uring_sqe {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
 	};
-	__u64	addr;		/* pointer to buffer or iovecs */
+	union {
+		__u64	addr;	/* pointer to buffer or iovecs */
+		__u64	splice_off_in;
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
+			__s32	splice_fd_in;
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

