Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB5E42DDBC
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhJNPOZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbhJNPOV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:21 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535ACC06177E
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g25so20459300wrb.2
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0e19RcxB3M/mXWlaTCHlcxe6etGoywnKxkrAIPR6jw=;
        b=j0ij54QqDi/C8eejuYiZNxuzrPn+dAbQgFruqTsFKnvR8ZTTtwIKYLnABlmBodfrFq
         F8KpJRik5MOjm6goeeL+IDmamcIn2LrPnOZcOqI9Hm6B9roQGLa+zZgpYll8YPI7pQ1N
         4vovCJtrVIac2UVBl8LmRRFVJHs2TTZ0cZ0WeoVV+u1ELuHapRgwARhM4jciH/XZyLHq
         oGIYiSb+j01Vq/3kMK8LZkoqGuhJQd95ri18Mj31qONVUJgsev0Gqsn+Aaf8B3YEwQct
         yiPqobGj/vTV3/8ZJp7UEw3tk1Oz6Rj3aVbnbnVoYpY1W+vmF7KgPdG8IvCz4wU4jPxR
         XSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0e19RcxB3M/mXWlaTCHlcxe6etGoywnKxkrAIPR6jw=;
        b=g70i8Vs4fGJwnvuTL2VNLF9OjkktDbwai7F7kKW8dO8uF/Z72wwPvv6VC6HI7f9f5+
         xhO5+LGZIh+/x3Te45pOilUbIemTuEY83PBW2pqwXZ4NmoOYzv9tbRcZG7vwH8LAbFzL
         XSBOsjKSTslopIPCFUvBGTzFDXDmGKFPsI+QG66qVtJ8SpO5YTmOdz/i+zXK9Bggtg0X
         laIhbsd37xG4AL8IXCPb6BWqhlm/e920noCzim6j6vILsc0BkbsnzDbeMQQDIT7RxKLa
         z9qCxTwv2MDOwL9Iw2ZIWynF4RHYJOBElR851lvCIVEmuEvzY3XWscHjeaWSQLPbUlXG
         n9tw==
X-Gm-Message-State: AOAM530mmGTSPtHhfdA/CCRYtCOtv1mWE7P6VBlscm9m+y1yVBVjdtWC
        VRZ0ED7Y/lrQd6AeVCtZ8W6ZpLB5YUU=
X-Google-Smtp-Source: ABdhPJzelhsngGrYYfd8XJuD1/WiGvB9zOcLvzNUN1XBAdDCYXOZ4+jyYpfwCQkEBIYUq/IBiFRttA==
X-Received: by 2002:adf:a294:: with SMTP id s20mr7469073wra.34.1634224273156;
        Thu, 14 Oct 2021 08:11:13 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/8] io_uring: optimise io_import_iovec nonblock passing
Date:   Thu, 14 Oct 2021 16:10:17 +0100
Message-Id: <ee96547e692f6c975c229cd82fc721679571a734.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First, change IO_URING_F_NONBLOCK to take sign bit of the int, so
checking for it can be turned into test + sign-based-jump, makes the
binary smaller and may be faster.

Then, instead of passing need_lock boolean into io_import_iovec() just
give it issue_flags, which is already stored somewhere. Saves some space
on stack, a couple of test + cmov operations and other conversions.

note: we still leave
force_nonblock = issue_flags & IO_URING_F_NONBLOCK
variable, but it's optimised out by the compiler into testing
issue_flags directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 248ef7b09268..9a22a983fb53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -198,8 +198,9 @@ struct io_rings {
 };
 
 enum io_uring_cmd_flags {
-	IO_URING_F_NONBLOCK		= 1,
-	IO_URING_F_COMPLETE_DEFER	= 2,
+	IO_URING_F_COMPLETE_DEFER	= 1,
+	/* int's last bit, sign checks are usually faster than a bit test */
+	IO_URING_F_NONBLOCK		= INT_MIN,
 };
 
 struct io_mapped_ubuf {
@@ -2999,10 +3000,11 @@ static void io_ring_submit_lock(struct io_ring_ctx *ctx, bool needs_lock)
 }
 
 static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
-					  int bgid, bool needs_lock)
+					  int bgid, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
 	struct io_buffer *head;
+	bool needs_lock = !(issue_flags & IO_URING_F_NONBLOCK);
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return kbuf;
@@ -3034,13 +3036,13 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 }
 
 static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
-					bool needs_lock)
+					unsigned int issue_flags)
 {
 	struct io_buffer *kbuf;
 	u16 bgid;
 
 	bgid = req->buf_index;
-	kbuf = io_buffer_select(req, len, bgid, needs_lock);
+	kbuf = io_buffer_select(req, len, bgid, issue_flags);
 	if (IS_ERR(kbuf))
 		return kbuf;
 	return u64_to_user_ptr(kbuf->addr);
@@ -3048,7 +3050,7 @@ static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
 
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
-				bool needs_lock)
+				unsigned int issue_flags)
 {
 	struct compat_iovec __user *uiov;
 	compat_ssize_t clen;
@@ -3064,7 +3066,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 		return -EINVAL;
 
 	len = clen;
-	buf = io_rw_buffer_select(req, &len, needs_lock);
+	buf = io_rw_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3074,7 +3076,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 #endif
 
 static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
-				      bool needs_lock)
+				      unsigned int issue_flags)
 {
 	struct iovec __user *uiov = u64_to_user_ptr(req->rw.addr);
 	void __user *buf;
@@ -3086,7 +3088,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	len = iov[0].iov_len;
 	if (len < 0)
 		return -EINVAL;
-	buf = io_rw_buffer_select(req, &len, needs_lock);
+	buf = io_rw_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3095,7 +3097,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 }
 
 static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
-				    bool needs_lock)
+				    unsigned int issue_flags)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		struct io_buffer *kbuf = req->kbuf;
@@ -3109,14 +3111,14 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
-		return io_compat_import(req, iov, needs_lock);
+		return io_compat_import(req, iov, issue_flags);
 #endif
 
-	return __io_iov_buffer_select(req, iov, needs_lock);
+	return __io_iov_buffer_select(req, iov, issue_flags);
 }
 
 static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
-			   struct iov_iter *iter, bool needs_lock)
+			   struct iov_iter *iter, unsigned int issue_flags)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
@@ -3134,7 +3136,7 @@ static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
+			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
 				return PTR_ERR(buf);
 			req->rw.len = sqe_len;
@@ -3146,7 +3148,7 @@ static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		ret = io_iov_buffer_select(req, *iovec, needs_lock);
+		ret = io_iov_buffer_select(req, *iovec, issue_flags);
 		if (!ret)
 			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
 		*iovec = NULL;
@@ -3285,7 +3287,8 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	struct iovec *iov = iorw->s.fast_iov;
 	int ret;
 
-	ret = io_import_iovec(rw, req, &iov, &iorw->s.iter, false);
+	/* submission path, ->uring_lock should already be taken */
+	ret = io_import_iovec(rw, req, &iov, &iorw->s.iter, IO_URING_F_NONBLOCK);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -3413,7 +3416,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		s = &__s;
 		iovec = s->fast_iov;
-		ret = io_import_iovec(READ, req, &iovec, &s->iter, !force_nonblock);
+		ret = io_import_iovec(READ, req, &iovec, &s->iter, issue_flags);
 		if (ret < 0)
 			return ret;
 
@@ -3541,7 +3544,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		s = &__s;
 		iovec = s->fast_iov;
-		ret = io_import_iovec(WRITE, req, &iovec, &s->iter, !force_nonblock);
+		ret = io_import_iovec(WRITE, req, &iovec, &s->iter, issue_flags);
 		if (ret < 0)
 			return ret;
 		iov_iter_save_state(&s->iter, &s->iter_state);
@@ -4864,11 +4867,11 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 }
 
 static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
-					       bool needs_lock)
+					       unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	return io_buffer_select(req, &sr->len, sr->bgid, needs_lock);
+	return io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 }
 
 static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
@@ -4931,7 +4934,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, !force_nonblock);
+		kbuf = io_recv_buffer_select(req, issue_flags);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
@@ -4983,7 +4986,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, !force_nonblock);
+		kbuf = io_recv_buffer_select(req, issue_flags);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		buf = u64_to_user_ptr(kbuf->addr);
-- 
2.33.0

