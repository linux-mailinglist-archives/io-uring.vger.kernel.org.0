Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038FB430D19
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 02:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344845AbhJRAbg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 20:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344859AbhJRAbg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 20:31:36 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B53C061765
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y12so65513723eda.4
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Smn5PvaC+wlkpFDXIaE+a1qnZMfKJhDOlB87h4t7O2Y=;
        b=X03EtCY/AVxyp6VcVCjFA2mabcMwghN5Ba36bbiMeuZ21Rwi5k9LDOmG1VM6LuNZAf
         grjVb8PS8mNa9O3dpFmlx7wcyjf5PjV6ksH2Wn85PfJ0iW/MJDYCQGMdyOVolb6RDmHz
         NsRsqxf9GK2VRr2Egu44D6jWG/4G7mQH7AEU/nQgTPHWO9Fee1PesdzYbcfJt0sKTzKy
         lKL/5bPHDO5NgPPs8nPS5ltaSn8BbBwbKVUoiwdcepRrugwWkc7DOjaLYOJIAcw/ZieZ
         lX2LXLnAjW59q9Q/XShfxFs+pNTPid7iA7rqAlsyrf3Fuk2PdhCb5WkFBEpP1+bKD8+V
         IcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Smn5PvaC+wlkpFDXIaE+a1qnZMfKJhDOlB87h4t7O2Y=;
        b=UNHW/MI4Wc2xCCGnitR73dcHpM+b/x8zNoxHzztT8TrU4nfTdq6LbQBGshRUfJwf+v
         hECILj2209MxCcbO4QshwJgr20crSE3EY+IDtmMzfDqjiXKPiP5WcbCIk/uazZ78W3Fa
         gqQ8xXMxwD32mZX8jtQbvO40+xcIpyKRp7cZByNdHWmM1tC8C+vrY1lXZQ7sCLty2dmg
         JBKxAuh9gPjqBtKLmsqiHHIqr+GMmqGKSACA0b8gWJq1Bj8O/ZuOH4AzKv8Ub6JmJM5l
         H6J4i+iyzDHDC72ZeYw3lxMUAwuRHVhVoXyfno5P0ew5WFlZQMIP/wwp4FkGuAZFj6nh
         1VyA==
X-Gm-Message-State: AOAM533I4/xhAozvaGFGrxWjKhnHtaIAr/Hbh2/v9NtmETg/BFgWHDx0
        D7hD/VKOzweiMiS8W3XhgHDnxi9HX6OeGg==
X-Google-Smtp-Source: ABdhPJwBH8+AfOVjtmGKhkSEYK10pHpMuqZhakjXFRV8OqXt/9ciygKRTuvhm3YCR1AfA3Hugwh9TQ==
X-Received: by 2002:a05:6402:b84:: with SMTP id cf4mr38867840edb.385.1634516963984;
        Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id q11sm8881489edv.80.2021.10.17.17.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/4] io_uring: typed ->async_data
Date:   Mon, 18 Oct 2021 00:29:36 +0000
Message-Id: <0d703f525bf1ae185915f3342d26b48a06a34162.1634516914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634516914.git.asml.silence@gmail.com>
References: <cover.1634516914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->async_data is a void* pointer, which opcodes use to store some extra
data. Enclose it into a union, where each new flavour of ->async_data
has it's own alias with a type. Opcodes should only access their own
version of it. Explicit types are easier and help to remove some
ugliness as in io_poll_queue_proc().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 95 ++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 51 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4507b711a688..d24bcbdb27a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -869,13 +869,21 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
-	/* opcode allocated if it needs to store data for async defer */
-	void				*async_data;
 	struct io_wq_work		work;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
+	/* opcode allocated if it needs to store data for async defer */
+	union {
+		void			*async_data;
+		struct io_async_connect *connect_data;
+		struct io_async_msghdr	*msg_data;
+		struct io_async_rw	*rw_data;
+		struct io_timeout_data	*timeout_data;
+		/* second poll entry */
+		struct io_poll_iocb	*poll_data;
+	};
 };
 
 struct io_tctx_node {
@@ -1522,9 +1530,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	__must_hold(&req->ctx->completion_lock)
 	__must_hold(&req->ctx->timeout_lock)
 {
-	struct io_timeout_data *io = req->async_data;
-
-	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+	if (hrtimer_try_to_cancel(&req->timeout_data->timer) != -1) {
 		if (status)
 			req_set_fail(req);
 		atomic_set(&req->ctx->cq_timeouts,
@@ -2026,11 +2032,9 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 	struct io_kiocb *link = req->link;
 
 	if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
-		struct io_timeout_data *io = link->async_data;
-
 		io_remove_next_linked(req);
 		link->timeout.head = NULL;
-		if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (hrtimer_try_to_cancel(&link->timeout_data->timer) != -1) {
 			list_del(&link->timeout.list);
 			io_cqring_fill_event(link->ctx, link->user_data,
 					     -ECANCELED, 0);
@@ -2584,7 +2588,7 @@ static void kiocb_end_write(struct io_kiocb *req)
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
-	struct io_async_rw *rw = req->async_data;
+	struct io_async_rw *rw = req->rw_data;
 
 	if (!req_has_async_data(req))
 		return !io_req_prep_async(req);
@@ -2901,10 +2905,11 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		       unsigned int issue_flags)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-	struct io_async_rw *io = req->async_data;
 
 	/* add previously done IO, if any */
-	if (req_has_async_data(req) && io->bytes_done > 0) {
+	if (req_has_async_data(req) && req->rw_data->bytes_done > 0) {
+		struct io_async_rw *io = req->rw_data;
+
 		if (ret < 0)
 			ret = io->bytes_done;
 		else
@@ -3279,7 +3284,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 			  const struct iovec *fast_iov, struct iov_iter *iter)
 {
-	struct io_async_rw *rw = req->async_data;
+	struct io_async_rw *rw = req->rw_data;
 
 	memcpy(&rw->s.iter, iter, sizeof(*iter));
 	rw->free_iovec = iovec;
@@ -3328,7 +3333,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 		}
 
 		io_req_map_rw(req, iovec, s->fast_iov, &s->iter);
-		iorw = req->async_data;
+		iorw = req->rw_data;
 		/* we've copied and mapped the iter, ensure state is saved */
 		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
 	}
@@ -3337,7 +3342,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 
 static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 {
-	struct io_async_rw *iorw = req->async_data;
+	struct io_async_rw *iorw = req->rw_data;
 	struct iovec *iov;
 	int ret;
 
@@ -3402,7 +3407,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
  */
 static bool io_rw_should_retry(struct io_kiocb *req)
 {
-	struct io_async_rw *rw = req->async_data;
+	struct io_async_rw *rw = req->rw_data;
 	struct wait_page_queue *wait = &rw->wpq;
 	struct kiocb *kiocb = &req->rw.kiocb;
 
@@ -3453,7 +3458,6 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec *iovec;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	struct io_async_rw *rw;
 	ssize_t ret, ret2;
 
 	if (!req_has_async_data(req)) {
@@ -3461,8 +3465,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
-		rw = req->async_data;
-		s = &rw->s;
+		s = &req->rw_data->s;
 		/*
 		 * We come here from an earlier attempt, restore our state to
 		 * match in case it doesn't. It's cheap enough that we don't
@@ -3522,8 +3525,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret2;
 
 	iovec = NULL;
-	rw = req->async_data;
-	s = &rw->s;
+	s = &req->rw_data->s;
+
 	/*
 	 * Now use our persistent iterator and state, if we aren't already.
 	 * We've restored and mapped the iter to match.
@@ -3538,7 +3541,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_advance(&s->iter, ret);
 		if (!iov_iter_count(&s->iter))
 			break;
-		rw->bytes_done += ret;
+		req->rw_data->bytes_done += ret;
 		iov_iter_save_state(&s->iter, &s->iter_state);
 
 		/* if we can retry, do so with the callbacks armed */
@@ -3589,9 +3592,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
-		struct io_async_rw *rw = req->async_data;
-
-		s = &rw->s;
+		s = &req->rw_data->s;
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
@@ -4691,7 +4692,7 @@ static int io_setup_async_msg(struct io_kiocb *req,
 		kfree(kmsg->free_iov);
 		return -ENOMEM;
 	}
-	async_msg = req->async_data;
+	async_msg = req->msg_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	async_msg->msg.msg_name = &async_msg->addr;
@@ -4715,7 +4716,7 @@ static int io_sendmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
-	ret = io_sendmsg_copy_hdr(req, req->async_data);
+	ret = io_sendmsg_copy_hdr(req, req->msg_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4754,7 +4755,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
+		kmsg = req->msg_data;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)
@@ -4930,7 +4931,7 @@ static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
-	ret = io_recvmsg_copy_hdr(req, req->async_data);
+	ret = io_recvmsg_copy_hdr(req, req->msg_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4972,7 +4973,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
+		kmsg = req->msg_data;
 	} else {
 		ret = io_recvmsg_copy_hdr(req, &iomsg);
 		if (ret)
@@ -5136,7 +5137,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_connect_prep_async(struct io_kiocb *req)
 {
-	struct io_async_connect *io = req->async_data;
+	struct io_async_connect *io = req->connect_data;
 	struct io_connect *conn = &req->connect;
 
 	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
@@ -5165,7 +5166,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	if (req_has_async_data(req)) {
-		io = req->async_data;
+		io = req->connect_data;
 	} else {
 		ret = move_addr_to_kernel(req->connect.addr,
 						req->connect.addr_len,
@@ -5186,7 +5187,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -ENOMEM;
 			goto out;
 		}
-		memcpy(req->async_data, &__io, sizeof(__io));
+		memcpy(req->connect_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)
@@ -5285,7 +5286,7 @@ static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
 	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
 	if (req->opcode == IORING_OP_POLL_ADD)
-		return req->async_data;
+		return req->poll_data;
 	return req->apoll->double_poll;
 }
 
@@ -5786,7 +5787,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->async_data);
+	__io_queue_proc(&pt->req->poll, pt, head, &pt->req->poll_data);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -5899,9 +5900,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
 {
-	struct io_timeout_data *data = req->async_data;
-
-	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
+	if (!(req->timeout_data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
 		req_set_fail(req);
 	io_req_complete_post(req, -ETIME, 0);
 }
@@ -5929,7 +5928,6 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 					   __u64 user_data)
 	__must_hold(&ctx->timeout_lock)
 {
-	struct io_timeout_data *io;
 	struct io_kiocb *req;
 	bool found = false;
 
@@ -5941,8 +5939,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	if (!found)
 		return ERR_PTR(-ENOENT);
 
-	io = req->async_data;
-	if (hrtimer_try_to_cancel(&io->timer) == -1)
+	if (hrtimer_try_to_cancel(&req->timeout_data->timer) == -1)
 		return ERR_PTR(-EALREADY);
 	list_del_init(&req->timeout.list);
 	return req;
@@ -5995,7 +5992,7 @@ static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	if (!found)
 		return -ENOENT;
 
-	io = req->async_data;
+	io = req->timeout_data;
 	if (hrtimer_try_to_cancel(&io->timer) == -1)
 		return -EALREADY;
 	hrtimer_init(&io->timer, io_timeout_get_clock(io), mode);
@@ -6015,7 +6012,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 		return PTR_ERR(req);
 
 	req->timeout.off = 0; /* noseq */
-	data = req->async_data;
+	data = req->timeout_data;
 	list_add_tail(&req->timeout.list, &ctx->timeout_list);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), mode);
 	data->timer.function = io_timeout_fn;
@@ -6125,7 +6122,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (io_alloc_async_data(req))
 		return -ENOMEM;
 
-	data = req->async_data;
+	data = req->timeout_data;
 	data->req = req;
 	data->flags = flags;
 
@@ -6151,7 +6148,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_timeout_data *data = req->async_data;
+	struct io_timeout_data *data = req->timeout_data;
 	struct list_head *entry;
 	u32 tail, off = req->timeout.off;
 
@@ -6520,16 +6517,12 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 		case IORING_OP_WRITE: {
-			struct io_async_rw *io = req->async_data;
-
-			kfree(io->free_iovec);
+			kfree(req->rw_data->free_iovec);
 			break;
 			}
 		case IORING_OP_RECVMSG:
 		case IORING_OP_SENDMSG: {
-			struct io_async_msghdr *io = req->async_data;
-
-			kfree(io->free_iov);
+			kfree(req->msg_data->free_iov);
 			break;
 			}
 		case IORING_OP_SPLICE:
@@ -6878,7 +6871,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 	 * before we got a chance to setup the timer
 	 */
 	if (req->timeout.head) {
-		struct io_timeout_data *data = req->async_data;
+		struct io_timeout_data *data = req->timeout_data;
 
 		data->timer.function = io_link_timeout_fn;
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
-- 
2.33.1

