Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C91B16AAB0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgBXQEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:04:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51352 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgBXQEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:04:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so9522074wmi.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 08:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=thsP8H6nSxdgVgrWUzoP7eGdzkH4NG8aUwdxWGwM9XI=;
        b=pdDmGUTeOtdgHKg6cK9vK4Qid50qbJ2mzBIYK6i0H4zwEUIj0UScSaBLKB7CZnc5EF
         d+BBcNDj+Y/UTvZYqrq7WaBHPQjw6P8V0Cp1O1b92OY4Z+ke4YZOeRvFEnUvC55qzY7v
         WAG9+xYfJp36wl/icy0Tpy/DuL2jEtQHsJMD+KpyrFcth43tSE6UVHuevClkXQ6JVukj
         kCV4M5TpLMRpJBYuuHSgxJPZa3tsZKf6eWP6hyKAvKzqofdUjJVpBmGTDeRmNjudxWT8
         gFTOVq3aboWeOWtCq75j6KOK3ebeD9m/K9CPekUFurLAuuPK3Q8L8xI/I6RXs0GWyOa8
         fQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thsP8H6nSxdgVgrWUzoP7eGdzkH4NG8aUwdxWGwM9XI=;
        b=rFSB4/9tXdQYyV3TS17gqcWraKcRCPVXHj5GKkWsDKLzT/1VA27hr6hGurj++fHvXI
         5iFPsKMej77toJeGrzGCmrf+CLrHqAOgTnkcCodqLJKpEy8PeqrvGN0hU3e4K/v+Bqqv
         EQ2s8xlHhMxISoQXJBirwCvgzYwYYckaYw3zUloD6Pq3UAtgH2ZgknS4Um0paXxO1SSz
         jIYLQwrKrEiQldVBovSAdxk3VYpCrhr6HR4TWXe8mOLFIl0gwD9tHJUbSv6mZBwrBxLr
         7BZ6vA47xrika8HT/MHNywWS5kDozalhx16ERPt16hl49/+umjFSITzMRi/WZEzOv/sr
         N2Mg==
X-Gm-Message-State: APjAAAVykzBZ9fqktKxqvVv47susIiqjr/Kkt34YWEPURSnCt7H48gQh
        /1lSEefwP+kVsC/Dm2up2cE=
X-Google-Smtp-Source: APXvYqzMEypn2jGDMMLVO6KYRWmr8QaIo/sScEQSld5rLwsmp6eD3qEiLgQhKvO8YnQ98pznBjmhjQ==
X-Received: by 2002:a7b:c088:: with SMTP id r8mr23024560wmh.18.1582560284528;
        Mon, 24 Feb 2020 08:04:44 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id e11sm8600608wrm.80.2020.02.24.08.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:04:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 1/2] splice: add splice(2) helpers
Date:   Mon, 24 Feb 2020 19:03:49 +0300
Message-Id: <b93aaeab88361e1c08adb97347506f55561c457d.1582560081.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582560081.git.asml.silence@gmail.com>
References: <cover.1582560081.git.asml.silence@gmail.com>
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

