Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5273F1600EC
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgBOWRo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:17:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37090 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOWRo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:17:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id a6so14604083wme.2;
        Sat, 15 Feb 2020 14:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6CyS3ovMTI3rLTwxaFUWikmoGbQY45rGievk0K7pkXs=;
        b=QoT9Ba5vwhWGe5BhQyrXiNAb4BHAJciC3YyMro1VVl0leRo63jYo2Be+uiIikz289g
         i4FlxPcBDaTlmn7BSZNvB8zZJPqDXGnHvNpRHO6JEPKhu3qxaEhinW96BQ1Uhbog3gSy
         U9Hc8Fv2DNkYAPPGYjLNppDTBRSsfTcBFwTCJLdTPK2EQOSHQnhyXkyaG1vRvWBJgtSg
         uLUYI2EEkKuxtxfoqJFKuiZOhB0d2tlhqi3kBKLAN1HgvJJciqYF1N8xvojuqvvVLW3Q
         byNkQ9IvqNEHnRQu5agcmhqPeWWddWMkg6Q8i0zVlBYZ9i8i2FaZX7yhC/aUX/t1hMGZ
         nCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6CyS3ovMTI3rLTwxaFUWikmoGbQY45rGievk0K7pkXs=;
        b=GjC+VYCEpyiIVsI/rNP4LhWCf18ABhr58ar3Q2Dhr7U5pdoOGkqpm0Omui2LaNfDrp
         P1saYO9PYC+v0Ju/fRoe/+iO05GAIxH3h2mACFkhklJOoVN/3GqJb4mHxGs0sqC1wlNk
         LxNDC4NvqYIcu1dCyHs5Lbkcjnp+ZOfsx256YQkS1B7fsTFTuXrOSdCmuqd/W6NzMxLT
         azEQA1D5KNRwYTAb+F85DmIkz/tj61+cKXILxd4KJfTEk299taKKRqlyp9SKTXaIlLIU
         56TNMlxBsBGIut1Ph8qp4jSZktEAtPPzTPBnQrGThd1aMKPdo+OVl8yMJKypV+3v7qxX
         +Xbw==
X-Gm-Message-State: APjAAAWc0ZQ1a3GgmnKnIlAakXjPnMYRd97OksjbPJN1Va3QL7+kOM5n
        6kuyl4mmsjsJglmXeU2AGBg=
X-Google-Smtp-Source: APXvYqwB0GmNLQ3gRXb6Nnv1U7xrRXgUT0KVZYH9DYmJv29qnWT/qNBPoOyJ/ea5dsP9oOa4iJDCRg==
X-Received: by 2002:a1c:9ed7:: with SMTP id h206mr12281354wme.67.1581805061815;
        Sat, 15 Feb 2020 14:17:41 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id u14sm12888802wrm.51.2020.02.15.14.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:17:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 1/2] splice: add splice(2) helpers
Date:   Sun, 16 Feb 2020 01:16:53 +0300
Message-Id: <bbb5b5bb4344d931c0296855c5ba8ae2eb0e89ff.1581804801.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581804801.git.asml.silence@gmail.com>
References: <cover.1581804801.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice helpers and update io_uring.h

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Quick update for extra newline and the fixed fd comment

 src/include/liburing.h          | 11 +++++++++++
 src/include/liburing/io_uring.h | 14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 8ca6cd9..0628255 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -191,6 +191,17 @@ static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
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

