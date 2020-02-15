Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE341600E1
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBOWIf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:08:35 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42711 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgBOWIe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:08:34 -0500
Received: by mail-wr1-f53.google.com with SMTP id k11so15163799wrd.9;
        Sat, 15 Feb 2020 14:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sbvEo/naFERjUYOPHspLHaY1gFUk55B/2BCDQMZwrgQ=;
        b=dN4Y0XyNBftlvGyup8AQoXBIxj4AiztPyAuswFhHsdvAyvYNgyX6L88EiLQq+xoKY4
         e7RjK/ohm+ADK1MGG6kRqyFvFOY6PiWvaVI82Tjrjmhia1bczujPPy7/UuFB618G8dmW
         K6GXDbRW4TogQnX0ZtCCPF9qygvLZU6G5foz+gtPAwS3Qyt/mh258Kfz/FaPFr882tBt
         ev18lYt13Q0B7MPyo0iNkkKl3HxJw1rSqGqx8JR5xTocUllniZzcqmLoUjfbbgkytdse
         Wqq0XX0VxEmO8YtqMq+j8mBLfKS81tVAdMNmMltz8isGJ8zzKkW06sDvPAjBk8ce9P3v
         TI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbvEo/naFERjUYOPHspLHaY1gFUk55B/2BCDQMZwrgQ=;
        b=QEaC5uDMJfpjKko6NJMqN0hIAL396en2AmCQX2En/O2JCy4Af3mDY1GveexV7wZ2yl
         +LZZU78vu2rAzJ31414cF7LAa7w0L4SZAMlkRFPxfOJySv6WOvjFlUw3QMvnyeSxxzVH
         lUUfYDu6dbUrcGjanBU1fb12AOhhKAdmombTZMAi6MqDRUxPFdLOoUZ7hrlLr99nb8E5
         q9WgG8OiX51jv1J47aRIk2Tw2t4ysVtyiJJysroTiYgJ5QyRI5C6+8BcnPh1cVDmLFP2
         zbLMzxbswJzBjADn7xNoTZl7g84eMHYlCm+B/Xjl0xCv+kEgOc3dvM+7CKd1YymBJzwz
         lDeA==
X-Gm-Message-State: APjAAAWKngycVfRpRXUvfFzKXUFKvUilL2oNE26JQunKZQ1HRZ9Gq1r9
        whtE0HDaTSWfTHB0XFWRUGY=
X-Google-Smtp-Source: APXvYqzjcs6J41+pdTy0r4885gbARd86VIVEpHrGk8yYS4CaSmrrnsGdZWgvBxLiCt/mImUM0jjsig==
X-Received: by 2002:adf:9c8d:: with SMTP id d13mr12498254wre.392.1581804512455;
        Sat, 15 Feb 2020 14:08:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id h71sm14539719wme.26.2020.02.15.14.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:08:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing  1/2] splice: add splice(2) helpers
Date:   Sun, 16 Feb 2020 01:07:35 +0300
Message-Id: <c37123d3112a1c438a7d588a36e021ab8ea03007.1581803684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581803684.git.asml.silence@gmail.com>
References: <cover.1581803684.git.asml.silence@gmail.com>
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
index 8ca6cd9..16ccadd 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -191,6 +191,18 @@ static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
 	sqe->__pad2[0] = sqe->__pad2[1] = sqe->__pad2[2] = 0;
 }
 
+static void io_uring_prep_splice(struct io_uring_sqe *sqe,
+				 int fd_in, loff_t off_in,
+				 int fd_out, loff_t off_out,
+				 unsigned int nbytes, int splice_flags)
+{
+	io_uring_prep_rw(IORING_OP_SPLICE, sqe, fd_out, (void *)off_in,
+			 nbytes, off_out);
+	sqe->splice_fd_in = fd_in;
+	sqe->splice_flags = splice_flags;
+}
+
+
 static inline void io_uring_prep_readv(struct io_uring_sqe *sqe, int fd,
 				       const struct iovec *iovecs,
 				       unsigned nr_vecs, off_t offset)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 424fb4b..0623e00 100644
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
+#define SPLICE_F_FD_IN_FIXED	(1U << 31) /* last bit for __u32 */
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.24.0

