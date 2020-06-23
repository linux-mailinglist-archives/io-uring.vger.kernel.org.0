Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CA020559E
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732902AbgFWPQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 11:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 11:16:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F7C061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:40 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id e11so19659986ilr.4
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+/GS0T+pM45jQQmGi3dlGIwxYV9kxatM0FmHB82lOAs=;
        b=ePWGUpNOlvm2JT3XtOL3qo9ZcgJXlSSH94I9DmI5xNwO2aIdlLOFwKueQDAaKHS/vK
         ebKUNwTVuKd4CIV7m48qT8FWzuxbiziOC1ZtWrPVbUB5lYleCd72ddM+10NerBGSvm5/
         PlanhQsP8CJV8Qr65c6W7RVP7dGnsrD4VcN3FsJTxIf0SvtW/BFZWw5Ex+cBiDUD6wcK
         RwVzKaird4CqkEFH6o/FuWms2UaEC0wJNhAyR+PAbdklgAVLJr/IxOvW7Dz1CpQVcEFV
         dsKn2qDT085uhUPWRq7UNAJzOSk57cFDw/QmL2xHZNbehsWyTyIisbhUEkQ7UpwikQG3
         +rgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+/GS0T+pM45jQQmGi3dlGIwxYV9kxatM0FmHB82lOAs=;
        b=lylStJrACOvamJHv/XntVvQKOAY/u6R44TN4AhXFYMYDRqpcwB6bkaxkfViG4AsU0+
         AixTOVHCPU475+ffZ3aMswJH7k+iMtU89kdRIKHpW6ooeabZeFiGi6cFQ8RAMRnQYVP9
         SsgJ6cJsUKRtCG+ErSxjR8BvSY6ci3j3/LFk6AoHlG+4wUzOLSNFGxW+LVFH4xpIT+aN
         p2UdocK2KUqhZAYTJ1Y692xPLlXcnd7MmxVPpkEAwh6pXi9IBx6JL9VnxObiWT40fBKQ
         ECdctmvEI6DsXIlAdYHapKid0hXHTGJ/tTZmmNmaKrJTFCsEvHFyGYgHtkVacgcnQQ9y
         X90w==
X-Gm-Message-State: AOAM533kEVoOTjMdPiQ+9l+7dsL9a9H34mvJI0TpZRf9qJ6bP3uEi/kR
        cP05/dqQxsEYnOLi6HHoEbHw4lVQUvI=
X-Google-Smtp-Source: ABdhPJxGTiB+L3Yg8Et8z6obD2c5G8wwoGaZspgyUFAuMSwEudCT8YkhBJpG186ULSmU6C+ivFZgyQ==
X-Received: by 2002:a92:508:: with SMTP id q8mr22365706ile.298.1592925399279;
        Tue, 23 Jun 2020 08:16:39 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k1sm4275180ilr.35.2020.06.23.08.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:16:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     xuanzhuo@linux.alibaba.com, Dust.li@linux.alibaba.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: pass in completion state to appropriate issue side handlers
Date:   Tue, 23 Jun 2020 09:16:28 -0600
Message-Id: <20200623151629.17197-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623151629.17197-1-axboe@kernel.dk>
References: <20200623151629.17197-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Provide the completion state to the handlers that we know can complete
inline, so they can utilize this for batching completions.

Cap the max batch count at 32. This should be enough to provide a good
amortization of the cost of the lock+commit dance for completions, while
still being low enough not to cause any real latency issues for SQPOLL
applications.

Xuan Zhuo <xuanzhuo@linux.alibaba.com> reports that this changes his
profile from:

17.97% [kernel] [k] copy_user_generic_unrolled
13.92% [kernel] [k] io_commit_cqring
11.04% [kernel] [k] __io_cqring_fill_event
10.33% [kernel] [k] udp_recvmsg
 5.94% [kernel] [k] skb_release_data
 4.31% [kernel] [k] udp_rmem_release
 2.68% [kernel] [k] __check_object_size
 2.24% [kernel] [k] __slab_free
 2.22% [kernel] [k] _raw_spin_lock_bh
 2.21% [kernel] [k] kmem_cache_free
 2.13% [kernel] [k] free_pcppages_bulk
 1.83% [kernel] [k] io_submit_sqes
 1.38% [kernel] [k] page_frag_free
 1.31% [kernel] [k] inet_recvmsg

to

19.99% [kernel] [k] copy_user_generic_unrolled
11.63% [kernel] [k] skb_release_data
 9.36% [kernel] [k] udp_rmem_release
 8.64% [kernel] [k] udp_recvmsg
 6.21% [kernel] [k] __slab_free
 4.39% [kernel] [k] __check_object_size
 3.64% [kernel] [k] free_pcppages_bulk
 2.41% [kernel] [k] kmem_cache_free
 2.00% [kernel] [k] io_submit_sqes
 1.95% [kernel] [k] page_frag_free
 1.54% [kernel] [k] io_put_req
[...]
 0.07% [kernel] [k] io_commit_cqring
 0.44% [kernel] [k] __io_cqring_fill_event

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 153 ++++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 67 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d6eb608c105a..0939f5c1a681 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1360,15 +1360,50 @@ static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 	io_cqring_ev_posted(ctx);
 }
 
-static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags)
+static void io_submit_flush_completions(struct io_comp_state *cs)
 {
-	io_cqring_add_event(req, res, cflags);
-	io_put_req(req);
+	struct io_ring_ctx *ctx = cs->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	while (!list_empty(&cs->list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&cs->list, struct io_kiocb, list);
+		list_del(&req->list);
+		io_cqring_fill_event(req, req->result);
+		if (!(req->flags & REQ_F_LINK_HEAD)) {
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(req);
+		} else {
+			spin_unlock_irq(&ctx->completion_lock);
+			io_put_req(req);
+			spin_lock_irq(&ctx->completion_lock);
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	cs->nr = 0;
+}
+
+static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
+			      struct io_comp_state *cs)
+{
+	if (!cs) {
+		io_cqring_add_event(req, res, cflags);
+		io_put_req(req);
+	} else {
+		req->result = res;
+		list_add_tail(&req->list, &cs->list);
+		if (++cs->nr >= 32)
+			io_submit_flush_completions(cs);
+	}
 }
 
 static void io_req_complete(struct io_kiocb *req, long res)
 {
-	__io_req_complete(req, res, 0);
+	__io_req_complete(req, res, 0, NULL);
 }
 
 static inline bool io_is_fallback_req(struct io_kiocb *req)
@@ -3172,14 +3207,14 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
-static int io_nop(struct io_kiocb *req)
+static int io_nop(struct io_kiocb *req, struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	io_req_complete(req, 0);
+	__io_req_complete(req, 0, 0, cs);
 	return 0;
 }
 
@@ -3401,7 +3436,8 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	return i;
 }
 
-static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
+static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
+			     struct io_comp_state *cs)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3420,7 +3456,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_lock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
@@ -3478,7 +3514,8 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	return i ? i : -ENOMEM;
 }
 
-static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
+static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
+			      struct io_comp_state *cs)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3507,7 +3544,7 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
@@ -3538,7 +3575,8 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
+static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock,
+			struct io_comp_state *cs)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
@@ -3550,7 +3588,7 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3695,7 +3733,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_close(struct io_kiocb *req, bool force_nonblock)
+static int io_close(struct io_kiocb *req, bool force_nonblock,
+		    struct io_comp_state *cs)
 {
 	struct io_close *close = &req->close;
 	int ret;
@@ -3722,7 +3761,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 		req_set_fail_links(req);
 	fput(close->put_file);
 	close->put_file = NULL;
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
@@ -3808,7 +3847,8 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return ret;
 }
 
-static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
 {
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
@@ -3857,11 +3897,12 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, bool force_nonblock)
+static int io_send(struct io_kiocb *req, bool force_nonblock,
+		   struct io_comp_state *cs)
 {
 	struct socket *sock;
 	int ret;
@@ -3899,7 +3940,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
@@ -4042,7 +4083,8 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	return ret;
 }
 
-static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
 {
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
@@ -4098,11 +4140,12 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, cflags);
+	__io_req_complete(req, ret, cflags, cs);
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, bool force_nonblock)
+static int io_recv(struct io_kiocb *req, bool force_nonblock,
+		   struct io_comp_state *cs)
 {
 	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
@@ -4154,7 +4197,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, cflags);
+	__io_req_complete(req, ret, cflags, cs);
 	return 0;
 }
 
@@ -4174,7 +4217,8 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_accept(struct io_kiocb *req, bool force_nonblock)
+static int io_accept(struct io_kiocb *req, bool force_nonblock,
+		     struct io_comp_state *cs)
 {
 	struct io_accept *accept = &req->accept;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -4193,7 +4237,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 		req_set_fail_links(req);
 	}
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
@@ -4217,7 +4261,8 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 					&io->connect.address);
 }
 
-static int io_connect(struct io_kiocb *req, bool force_nonblock)
+static int io_connect(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
 {
 	struct io_async_ctx __io, *io;
 	unsigned file_flags;
@@ -4253,7 +4298,7 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock)
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 #else /* !CONFIG_NET */
@@ -5134,7 +5179,8 @@ static int io_files_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, bool force_nonblock)
+static int io_files_update(struct io_kiocb *req, bool force_nonblock,
+			   struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_files_update up;
@@ -5152,7 +5198,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
 
@@ -5353,7 +5399,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		ret = io_nop(req);
+		ret = io_nop(req, cs);
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
@@ -5415,9 +5461,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				break;
 		}
 		if (req->opcode == IORING_OP_SENDMSG)
-			ret = io_sendmsg(req, force_nonblock);
+			ret = io_sendmsg(req, force_nonblock, cs);
 		else
-			ret = io_send(req, force_nonblock);
+			ret = io_send(req, force_nonblock, cs);
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
@@ -5427,9 +5473,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				break;
 		}
 		if (req->opcode == IORING_OP_RECVMSG)
-			ret = io_recvmsg(req, force_nonblock);
+			ret = io_recvmsg(req, force_nonblock, cs);
 		else
-			ret = io_recv(req, force_nonblock);
+			ret = io_recv(req, force_nonblock, cs);
 		break;
 	case IORING_OP_TIMEOUT:
 		if (sqe) {
@@ -5453,7 +5499,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_accept(req, force_nonblock);
+		ret = io_accept(req, force_nonblock, cs);
 		break;
 	case IORING_OP_CONNECT:
 		if (sqe) {
@@ -5461,7 +5507,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_connect(req, force_nonblock);
+		ret = io_connect(req, force_nonblock, cs);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		if (sqe) {
@@ -5493,7 +5539,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_close(req, force_nonblock);
+		ret = io_close(req, force_nonblock, cs);
 		break;
 	case IORING_OP_FILES_UPDATE:
 		if (sqe) {
@@ -5501,7 +5547,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_files_update(req, force_nonblock);
+		ret = io_files_update(req, force_nonblock, cs);
 		break;
 	case IORING_OP_STATX:
 		if (sqe) {
@@ -5541,7 +5587,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_epoll_ctl(req, force_nonblock);
+		ret = io_epoll_ctl(req, force_nonblock, cs);
 		break;
 	case IORING_OP_SPLICE:
 		if (sqe) {
@@ -5557,7 +5603,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_provide_buffers(req, force_nonblock);
+		ret = io_provide_buffers(req, force_nonblock, cs);
 		break;
 	case IORING_OP_REMOVE_BUFFERS:
 		if (sqe) {
@@ -5565,7 +5611,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_remove_buffers(req, force_nonblock);
+		ret = io_remove_buffers(req, force_nonblock, cs);
 		break;
 	case IORING_OP_TEE:
 		if (sqe) {
@@ -5999,33 +6045,6 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs)
-{
-	struct io_ring_ctx *ctx = cs->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	while (!list_empty(&cs->list)) {
-		struct io_kiocb *req;
-
-		req = list_first_entry(&cs->list, struct io_kiocb, list);
-		list_del(&req->list);
-		io_cqring_fill_event(req, req->result);
-		if (!(req->flags & REQ_F_LINK_HEAD)) {
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(req);
-		} else {
-			spin_unlock_irq(&ctx->completion_lock);
-			io_put_req(req);
-			spin_lock_irq(&ctx->completion_lock);
-		}
-	}
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	cs->nr = 0;
-}
-
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
-- 
2.27.0

