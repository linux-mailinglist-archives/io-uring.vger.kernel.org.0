Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B263975E6
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhFAPAi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 11:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbhFAPAh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 11:00:37 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433DCC06174A;
        Tue,  1 Jun 2021 07:58:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c3so14655692wrp.8;
        Tue, 01 Jun 2021 07:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fnFOnDFO90lpgr7SPsBF2iN72KW5Q5F7DjzMlkhIf9M=;
        b=tnkXQWE4wo64WeUdkoVJHrFBNR7iUT3UdEp4m2ss9MgND9xzKnM4iUtyPe6KlJsRFH
         /Q7NgHvrxLOaiW6ryMrxRZbY9CSvFeawf7fDdVroj0rreDRJTqTKcPxchYM1zqBsfltt
         20fJ10T+H9Yq9NQmH4/oVNYis2ppD5R9QkFrNyJP3Wp+nhxH74SiGDxwBEcC0MJflE4V
         cJDEmvQvxtlkFMoaMHh6R1Qf0gs2rlPg8NuC4pGu+96WAXVNIo2RAstxoIPW1XG2rQWk
         PTUErK8D3pfMyG/Rdamkdj/y3Ku9mxpMxbUjFhBYg78kuF4nXqFlr33voxqNKpA3nCVl
         XMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fnFOnDFO90lpgr7SPsBF2iN72KW5Q5F7DjzMlkhIf9M=;
        b=OO11/jF8Qog1wl9RMjFkkHAmzJVqNLJ+ENB8KKOfKSzfw+PgQGgcXfqqTNGNZMAgQE
         m7/D5bxE7C0VJ8jBnpQcPxyzJuOHoxKeIfbIqT0UZ9YPgbfAE7CUgQ0Sh36XKG8EQdBE
         SCOYxPDyCE6/0l4Qe04spMmYf/R2ng+xijintCeAUVMO3NATcM2P4/ryk7NsRVQbzbel
         3ylrdmE6o1rXApq6X6VYhy4dmy0Vg0DrDNnixrtoB2Z15Vjbg4qsdqkL6BtepNey9jFr
         VKDQKXViu+jO6hZ6A9c2YE0CbRQm5zSfKcJSGnDStT/6Qn7NhJ1x0faTvzURoZIQUo/m
         vBAw==
X-Gm-Message-State: AOAM533aX5jtgnLAJP2t0imPDjJr5ouCfexnr/enbtHx3LhrjJJHGdrX
        HX42Ams5197QvK+h46aaa+fD23JVFLHdww==
X-Google-Smtp-Source: ABdhPJw0YF/iXLXc8AamVFuWhnAptJspLCdzJm0QS4kqOrQ28N+oT0orofarR3RB3+LpnEwWaWWwdg==
X-Received: by 2002:adf:fed0:: with SMTP id q16mr15645980wrs.426.1622559533671;
        Tue, 01 Jun 2021 07:58:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id b4sm10697061wmj.42.2021.06.01.07.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:58:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC 3/4] io_uring: support futex wake requests
Date:   Tue,  1 Jun 2021 15:58:28 +0100
Message-Id: <06240a288ce2a0bac00e81a9217613c1e132b664.1622558659.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622558659.git.asml.silence@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for futex wake requests, which also modifies the addr and
checks against it with encoded operation as FUTEX_WAKE_OP does, but only
operates with a single address as may be problematic to squeeze into SQE
and io_kiocb otherwise.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 48 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h | 10 +++++++-
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c6b14a3a4f6..99f4f8d9f685 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -668,6 +668,12 @@ struct io_unlink {
 
 struct io_futex {
 	struct file			*file;
+	unsigned int			futex_op;
+
+	unsigned int			nr_wake;
+	unsigned int			wake_op_arg;
+	unsigned int			flags;
+	void __user			*uaddr;
 };
 
 struct io_completion {
@@ -5874,12 +5880,50 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return -EINVAL;
+	struct io_futex *f = &req->futex;
+	u64 v;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->len)
+		return -EINVAL;
+	f->flags = READ_ONCE(sqe->futex_flags);
+	if (f->flags & ~IORING_FUTEX_SHARED)
+		return -EINVAL;
+
+	v = READ_ONCE(sqe->off);
+	f->nr_wake = (u32)v;
+	f->wake_op_arg = (u32)(v >> 32);
+	f->futex_op = READ_ONCE(sqe->futex_op);
+	f->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	return 0;
 }
 
 static int io_futex(struct io_kiocb *req, unsigned int issue_flags)
 {
-	return -EINVAL;
+	bool nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct io_futex *f = &req->futex;
+	int ret;
+
+	switch (f->futex_op) {
+	case IORING_FUTEX_WAKE_OP:
+		ret = futex_wake_op_single(f->uaddr, f->nr_wake, f->wake_op_arg,
+					   !(f->flags & IORING_FUTEX_SHARED),
+					   nonblock);
+		/* retry from blocking context */
+		if (nonblock && ret == -EAGAIN)
+			return -EAGAIN;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
 }
 
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6a1af5bb2ddf..6fa5a6e59934 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -17,7 +17,10 @@
 struct io_uring_sqe {
 	__u8	opcode;		/* type of operation for this sqe */
 	__u8	flags;		/* IOSQE_ flags */
-	__u16	ioprio;		/* ioprio for the request */
+	union {
+		__u16	ioprio;		/* ioprio for the request */
+		__u16	futex_op;	/* futex operation */
+	} __attribute__((packed));
 	__s32	fd;		/* file descriptor to do IO on */
 	union {
 		__u64	off;	/* offset into file */
@@ -161,6 +164,11 @@ enum {
  */
 #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
 
+/*
+ * sqe->futex_flags
+ */
+#define IORING_FUTEX_SHARED	(1U << 0)
+
 /*
  * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
  * command flags for POLL_ADD are stored in sqe->len.
-- 
2.31.1

