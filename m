Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164F041F2AE
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhJARJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbhJARJh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:09:37 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F70C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:07:52 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id dn26so37081593edb.13
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hhyCp4/lo3U6hd9+rk7B9t2UQ0qJX7ESMUmBtaduh9s=;
        b=Z832aeIP0+YFmrxYIPHJFB/mC9R5VGH1SA54UOYB1Pvaq7cJVBV2CBw5YmjtuPk2Ro
         JLpPs9ytSWku9qzdnjdu9ecPa28ajFujm6Cs4IcWXJRJckTmPZhyjmlaN+GX384bUgNg
         ihAxhXcT42cHeepcSm0sRdiSUolbivtaoAmuBJMgStpLjSjH7XwoJ5UwM7kd2PuHJiBH
         M1eDF1GREQ+6TbXboCQUwsunoI3JGX7DnE26GRGUeAkM3MCQbCvT8PCHnGyYhX9QSLKY
         g+UKvust9/J2Q6oNDtqLnc0a07g6PDb+dPuEmu70i4MgIa5jaZqw2552uZcGnNEXazL/
         uIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hhyCp4/lo3U6hd9+rk7B9t2UQ0qJX7ESMUmBtaduh9s=;
        b=ZUs8Dq/Dykd/1mRuxx8v7Cw/NDmWCwdRDnVm1huH3bokGya2la6bH4+6D/wu3xW0yE
         PpPRoUvW9dyfXeQVte3mhEqV+ascZxIligeri1/gfzTiWQfLyq2KZz5MqC6ilczqMdiK
         1P+VK/XRnNvZgPGG33imuRlxLuEQBuezAzDuWkeM84p4dx8DmWy5vrVHijN0n8YqPewv
         /Dgd1iE8NZ8/v7uMLnXzgjAQHsNd0m/F6jvmI2eNbek7rlunMRbxinTxapFkh47D9gF5
         oEVT1ZI0mvBiWe/6AFBJlOJHz3iay7sUFb2tIt3/6FBVteEMsJnIj7uQfpinFK8N8otx
         FI/w==
X-Gm-Message-State: AOAM532x5am8CjEpQxwIxL72+z5LBBcd2kGd7YK80UL4QQBH0awLE10q
        v1GUuhszhPgRue+Xw+nnaNvRgUOv1iE=
X-Google-Smtp-Source: ABdhPJxCQzp9BjBmDqTtIYQvM/wb/Sf46bcS4sGN4fgFfLrCq9a0hHYQqEmJTV8kbRzwTJoDHzcpOg==
X-Received: by 2002:a17:906:71d4:: with SMTP id i20mr2388482ejk.390.1633108071108;
        Fri, 01 Oct 2021 10:07:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id y93sm3604480ede.42.2021.10.01.10.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:07:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: clean up buffer select
Date:   Fri,  1 Oct 2021 18:07:03 +0100
Message-Id: <3e63a6a953b04cad81d9ea827b12344dd57b37b4.1633107393.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633107393.git.asml.silence@gmail.com>
References: <cover.1633107393.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hiding a pointer to a struct io_buffer in rw.addr is error prone. We
have some place in io_kiocb, so keep kbuf's in a separate field
without aliasing and risks of it being misused.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 ++++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ddb23bb2e4b8..cf392b1228d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -573,7 +573,6 @@ struct io_sr_msg {
 	int				msg_flags;
 	int				bgid;
 	size_t				len;
-	struct io_buffer		*kbuf;
 };
 
 struct io_open {
@@ -877,6 +876,7 @@ struct io_kiocb {
 	struct io_mapped_ubuf		*imu;
 	struct io_wq_work		work;
 	const struct cred		*creds;
+	struct io_buffer		*kbuf;
 };
 
 struct io_tctx_node {
@@ -2376,12 +2376,9 @@ static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
 
 static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 {
-	struct io_buffer *kbuf;
-
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return 0;
-	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
-	return io_put_kbuf(req, kbuf);
+	return io_put_kbuf(req, req->kbuf);
 }
 
 static inline bool io_run_task_work(void)
@@ -3003,9 +3000,9 @@ static void io_ring_submit_lock(struct io_ring_ctx *ctx, bool needs_lock)
 }
 
 static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
-					  int bgid, struct io_buffer *kbuf,
-					  bool needs_lock)
+					  int bgid, bool needs_lock)
 {
+	struct io_buffer *kbuf = req->kbuf;
 	struct io_buffer *head;
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -3027,12 +3024,13 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
+		req->flags |= REQ_F_BUFFER_SELECTED;
+		req->kbuf = kbuf;
 	} else {
 		kbuf = ERR_PTR(-ENOBUFS);
 	}
 
 	io_ring_submit_unlock(req->ctx, needs_lock);
-
 	return kbuf;
 }
 
@@ -3042,13 +3040,10 @@ static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
 	struct io_buffer *kbuf;
 	u16 bgid;
 
-	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
 	bgid = req->buf_index;
-	kbuf = io_buffer_select(req, len, bgid, kbuf, needs_lock);
+	kbuf = io_buffer_select(req, len, bgid, needs_lock);
 	if (IS_ERR(kbuf))
 		return kbuf;
-	req->rw.addr = (u64) (unsigned long) kbuf;
-	req->flags |= REQ_F_BUFFER_SELECTED;
 	return u64_to_user_ptr(kbuf->addr);
 }
 
@@ -3104,9 +3099,8 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    bool needs_lock)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		struct io_buffer *kbuf;
+		struct io_buffer *kbuf = req->kbuf;
 
-		kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
 		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
 		iov[0].iov_len = kbuf->len;
 		return 0;
@@ -4872,20 +4866,13 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 					       bool needs_lock)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
-	struct io_buffer *kbuf;
-
-	kbuf = io_buffer_select(req, &sr->len, sr->bgid, sr->kbuf, needs_lock);
-	if (IS_ERR(kbuf))
-		return kbuf;
 
-	sr->kbuf = kbuf;
-	req->flags |= REQ_F_BUFFER_SELECTED;
-	return kbuf;
+	return io_buffer_select(req, &sr->len, sr->bgid, needs_lock);
 }
 
 static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
 {
-	return io_put_kbuf(req, req->sr_msg.kbuf);
+	return io_put_kbuf(req, req->kbuf);
 }
 
 static int io_recvmsg_prep_async(struct io_kiocb *req)
@@ -6475,17 +6462,8 @@ static void io_drain_req(struct io_kiocb *req)
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		switch (req->opcode) {
-		case IORING_OP_READV:
-		case IORING_OP_READ_FIXED:
-		case IORING_OP_READ:
-			kfree((void *)(unsigned long)req->rw.addr);
-			break;
-		case IORING_OP_RECVMSG:
-		case IORING_OP_RECV:
-			kfree(req->sr_msg.kbuf);
-			break;
-		}
+		kfree(req->kbuf);
+		req->kbuf = NULL;
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
-- 
2.33.0

