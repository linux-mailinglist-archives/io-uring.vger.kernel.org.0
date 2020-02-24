Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBC16AE30
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgBXRz5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:55:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36618 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRz4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:55:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so11485362wru.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=thsP8H6nSxdgVgrWUzoP7eGdzkH4NG8aUwdxWGwM9XI=;
        b=AEKn4GgjwHe5UCiJfEFyBXDhYj8DUG0aCfqMkgyEWHwgPzbT2vs7chamvoBhovAgNN
         htlPy3hUuFjFG1PHGxS1gAz+5/xyvRmqW5+CL7lnKFyoj+qiONZMI37bJA3rbZ0wLoc+
         gx/7utfGAmPLAFXWjROHiNYewf2vpFMLjaB5PfnCRCuMswinRn/45FfBTjoE6+6iMImI
         EE0IxbhqxfAuhUEsTtKNSQaX/reeQ+aaam70lttyhM9JNHBCKeWMXb0fcTa33SJk2Pqq
         XLW7dnCyEJQOjWlYHqf32nLo/ThwadMiOvjM4/zbDMyT5NQotHgmzddqiiXEIpcVzYJY
         FAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thsP8H6nSxdgVgrWUzoP7eGdzkH4NG8aUwdxWGwM9XI=;
        b=JP6gRuUr3X81k3m30rDscdcYZ61LkGmQG7TwpgrjctJUfihrHAdxPjSHSfxwe91F8L
         EbylxLP7U/tQfH6fnxXboxyTrPwLHgP9GhodQ2Dfedf91NO2xCSLjH9ggA9FKVNo6DZy
         u1IImx65b7ckmmVKBd/vGhcw3utvS2ZV/IP85iDb7cNF54L7HdiucUGE2Kjut8qcuOWl
         qZC2IEQ0as7KSJ8rAevRUDZRjMjHa1l8h/1f7Xsjyv9cdDvtIw/igs/MRgFH1T2JXVdZ
         XUzhSdVgNr1BorjKTo7gUaJRLEuWY19P9bOBRg+S1thR2wzaVuHctgTDQUQZkv1f3GEp
         yRcA==
X-Gm-Message-State: APjAAAUMaUtQfk1HIXEBgm1m5+NWJUIKpl0BH8bOYYSyb6E/2d+ISfn2
        hwMpu4LIzMBdusjPI9EitHHWqk0M
X-Google-Smtp-Source: APXvYqyr/hrTSzwd/v08sfitBt7eqGDgXfkjuJs+gatGO873emwvF3Yi7YH7Ofedmkq46fOhC9G+eQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr70819547wre.372.1582566954458;
        Mon, 24 Feb 2020 09:55:54 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id 61sm4001687wrf.65.2020.02.24.09.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:55:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v5 1/2] splice: add splice(2) helpers
Date:   Mon, 24 Feb 2020 20:55:00 +0300
Message-Id: <b93aaeab88361e1c08adb97347506f55561c457d.1582566728.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582566728.git.asml.silence@gmail.com>
References: <cover.1582566728.git.asml.silence@gmail.com>
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
index b8bcdf5..7edd4f1 100644
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
index 7e7c2d9..a3d5e25 100644
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

