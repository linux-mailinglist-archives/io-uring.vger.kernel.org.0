Return-Path: <io-uring+bounces-876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB00876DFE
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 789BB1F22FC9
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7785E3F9F8;
	Fri,  8 Mar 2024 23:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZePixnpl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D2C3BBEA
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941860; cv=none; b=k0/DuqQ/tR7mC9acafpTeLHEjU23lXjiq7J7uv24GaRTViNe7A70Lo5rtQiUFjdgYKX31weWkOAY0IEqlc+Xa5rbJK1+dj/soSnxNVcrBDoZKvSh8Vzly7IhdHZFi2LAP8B1m85Nn05Cqraw8fqoxgK0NyWVaNG54b1esFYNxmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941860; c=relaxed/simple;
	bh=0f/06JHYbNUVoaAqdypkyt5OGDkgoXYehmjXsV62DDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id6MW/oGxc/vjRiq0oQ6Ui2GoyDwYypm1ciRh/9o+NVeVUXhN2+kivmRAwcd0mPaZXpl/rX4zmOkil/smXi4iXLR5KC+jJHtnscW71ofLpNFZ7zG64UfZtLWw4veoO3dnQDegR14zo3F7QRgqkvhGDbZ+mFVXuTkN5IIhjFE2IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZePixnpl; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c7ee5e2f59so13679239f.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941856; x=1710546656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkFE7/WkSJbSgjn6rehj95LSRT6ecLGzLQbmnltqDbI=;
        b=ZePixnplB9uQilTPQVZvCvh4TzgpFx0d89YkMCy5rBZul7niLwQyeU7DurpRy/lU4v
         YJp8w2saETxMDBPq9fvZy7w+Rw2oo4NNj2dOvUsh1yUeOUktStS03IhgwdmSb1UIx9ai
         QAtSNAExqRJY2Eyyf6ezuOcoxkRMM17UhOe0aYe6YeR/HsqTlls8kO0Z9sC4zUKsqn38
         dooONJBDt8dbDVlZ/HiB1npXj+gzRUspz1NZDwsdmNCGZ9OROqaUXjG8nJtMW8mkzXtG
         QSsOXErOEmDl/+qPEAAWy5e6jqewnIa1j3gGEEEmNp4xQq2N0uoVXS7miWbZOMrAkvpR
         TMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941856; x=1710546656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkFE7/WkSJbSgjn6rehj95LSRT6ecLGzLQbmnltqDbI=;
        b=Evax20jVeX5DvCF4NE22za15Im9JBwrrbDfsiTkI5ppC8Q5w+tNjoFxt85vcZh9zd7
         TgxkgCiBVaIvUgW0x2R6eThdqNhXhfosgSzNltTwQ0ydP97xfoUtKsBFbYdh++RaFwCo
         52h8qqqxFGGO1kcNSbFfKToeLBJjWytsGt5Ez58D88dwOE5H3BzPHO5TUTNU3oqCR806
         uY0OZpL27qgJ1KyXSMwWyZlSf9bHKQR4LdigLr5dAmXtlnjtYdioQl+pbydRKwz5slIz
         tykpNL6D2Sy/F9gb1aynthlsdyuFnZZBqTILfifVwtR+Aoidijfou6tpezjwUuO29jKu
         qs1Q==
X-Gm-Message-State: AOJu0YxBRPq0PFr5ArX6XKGk3AoQVgA0aueVPbCbQxJajo16KMjrrxv0
	p3l8adpeK/fzGt9r2piCZpT66dGQW13Hk26tb7o31UtSn65sJ0W2G2zihCg9B+wVFCIsc996LmQ
	A
X-Google-Smtp-Source: AGHT+IFe8Pn7m5yraBZ6Gz0BWaRngxB8W8mYnJt6tKNjMuPX7PUZScqdBcyyCtRpXQk817wQiuLmdQ==
X-Received: by 2002:a5d:9f1a:0:b0:7c8:7471:2f59 with SMTP id q26-20020a5d9f1a000000b007c874712f59mr477031iot.0.1709941855326;
        Fri, 08 Mar 2024 15:50:55 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:50:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring/kbuf: add helpers for getting/peeking multiple buffers
Date: Fri,  8 Mar 2024 16:34:08 -0700
Message-ID: <20240308235045.1014125-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240308235045.1014125-1-axboe@kernel.dk>
References: <20240308235045.1014125-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Our provided buffer interface only allows selection of a single buffer.
Add an API that allows getting/peeking multiple buffers at the same time.

This is only implemented for the ring provided buffers. It could be added
for the legacy provided buffers as well, but since it's strongly
encouraged to use the new interface, let's keep it simpler and just
provide it for the new API. The legacy interface will always just select
a single buffer.

There are two new main functions:

io_buffers_select(), which selects up as many buffers as it can. The
caller supplies the iovec array, and io_buffers_select() may allocate
a bigger array if the 'out_len' being passed in is non-zero and bigger
than what we can fit in the provided iovec. Buffers grabbed with this
helper are permanently assigned.

io_buffers_peek(), which works like io_buffers_select(), except they can
be recycled, if needed. Callers using either of these functions should
call io_put_kbufs() rather than io_put_kbuf() at completion time. The
peek interface must be called with the ctx locked from peek to
completion.

This add a bit state for the request:

- REQ_F_BUFFERS_COMMIT, which means that the the buffers have been
  peeked and should be committed to the buffer ring head when they are
  put as part of completion. Prior to this, we used the fact that
  req->buf_list was cleared to NULL when committed. But with the peek
  interface requiring the ring to be locked throughout the operation,
  we can use that as a lookup cache instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   3 +
 io_uring/kbuf.c                | 203 ++++++++++++++++++++++++++++++---
 io_uring/kbuf.h                |  39 +++++--
 3 files changed, 223 insertions(+), 22 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e24893625085..971294dfd22e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -481,6 +481,7 @@ enum {
 	REQ_F_CAN_POLL_BIT,
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
+	REQ_F_BUFFERS_COMMIT_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -559,6 +560,8 @@ enum {
 	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
 	/* don't recycle provided buffers for this request */
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
+	/* buffer ring head needs incrementing on put */
+	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 9be42bff936b..921e8e25e027 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -140,34 +140,57 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 	return NULL;
 }
 
+static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
+				      struct io_buffer_list *bl,
+				      struct iovec *iov)
+{
+	void __user *buf;
+
+	buf = io_provided_buffer_select(req, len, bl);
+	if (unlikely(!buf))
+		return -ENOBUFS;
+
+	iov[0].iov_base = buf;
+	iov[0].iov_len = *len;
+	return 0;
+}
+
+static struct io_uring_buf *io_ring_head_to_buf(struct io_buffer_list *bl,
+						__u16 head)
+{
+	head &= bl->mask;
+
+	/* mmaped buffers are always contig */
+	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
+		return &bl->buf_ring->bufs[head];
+	} else {
+		int off = head & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
+		int index = head / IO_BUFFER_LIST_BUF_PER_PAGE;
+		struct io_uring_buf *buf;
+
+		buf = page_address(bl->buf_pages[index]);
+		return buf + off;
+	}
+}
+
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  struct io_buffer_list *bl,
 					  unsigned int issue_flags)
 {
-	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
 
-	tail = smp_load_acquire(&br->tail);
+	tail = smp_load_acquire(&bl->buf_ring->tail);
 	if (unlikely(tail == head))
 		return NULL;
 
 	if (head + 1 == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
-	head &= bl->mask;
-	/* mmaped buffers are always contig */
-	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
-		buf = &br->bufs[head];
-	} else {
-		int off = head & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
-		int index = head / IO_BUFFER_LIST_BUF_PER_PAGE;
-		buf = page_address(bl->buf_pages[index]);
-		buf += off;
-	}
+	buf = io_ring_head_to_buf(bl, head);
 	if (*len == 0 || *len > buf->len)
 		*len = buf->len;
-	req->flags |= REQ_F_BUFFER_RING;
+	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
@@ -182,6 +205,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
+		req->flags &= ~REQ_F_BUFFERS_COMMIT;
 		req->buf_list = NULL;
 		bl->head++;
 	}
@@ -208,6 +232,159 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ret;
 }
 
+static int io_ring_buffers_peek(struct io_kiocb *req, struct iovec **iovs,
+				int nr_iovs, size_t *out_len,
+				struct io_buffer_list *bl)
+{
+	struct iovec *iov = *iovs;
+	__u16 nr_avail, tail, head;
+	struct io_uring_buf *buf;
+	size_t max_len = 0;
+	int i;
+
+	if (*out_len) {
+		max_len = *out_len;
+		*out_len = 0;
+	}
+
+	tail = smp_load_acquire(&bl->buf_ring->tail);
+	head = bl->head;
+	nr_avail = tail - head;
+	if (unlikely(!nr_avail))
+		return -ENOBUFS;
+
+	buf = io_ring_head_to_buf(bl, head);
+	if (max_len) {
+		int needed;
+
+		needed = (max_len + buf->len - 1) / buf->len;
+		/* cap it at a reasonable 256, will be one page even for 4K */
+		needed = min(needed, 256);
+		if (nr_avail > needed)
+			nr_avail = needed;
+	}
+
+	if (nr_avail > UIO_MAXIOV)
+		nr_avail = UIO_MAXIOV;
+
+	/*
+	 * only alloc a bigger array if we know we have data to map, eg not
+	 * a speculative peek operation.
+	 */
+	if (nr_iovs == UIO_FASTIOV && nr_avail > nr_iovs && max_len) {
+		iov = kmalloc_array(nr_avail, sizeof(struct iovec), GFP_KERNEL);
+		if (unlikely(!iov))
+			return -ENOMEM;
+		nr_iovs = nr_avail;
+	} else if (nr_avail < nr_iovs) {
+		nr_iovs = nr_avail;
+	}
+
+	buf = io_ring_head_to_buf(bl, head);
+	req->buf_index = buf->bid;
+
+	i = 0;
+	while (nr_iovs--) {
+		void __user *ubuf;
+
+		/* truncate end piece, if needed */
+		if (max_len && buf->len > max_len)
+			buf->len = max_len;
+
+		ubuf = u64_to_user_ptr(buf->addr);
+		if (!access_ok(ubuf, buf->len))
+			break;
+		iov[i].iov_base = ubuf;
+		iov[i].iov_len = buf->len;
+		*out_len += buf->len;
+		i++;
+		head++;
+		if (max_len) {
+			max_len -= buf->len;
+			if (!max_len)
+				break;
+		}
+		buf = io_ring_head_to_buf(bl, head);
+	}
+
+	if (head == tail)
+		req->flags |= REQ_F_BL_EMPTY;
+
+	if (i) {
+		req->flags |= REQ_F_BUFFER_RING;
+		*iovs = iov;
+		return i;
+	}
+
+	if (iov != *iovs)
+		kfree(iov);
+	*iovs = NULL;
+	return -EFAULT;
+}
+
+int io_buffers_select(struct io_kiocb *req, struct iovec **iovs, int nr_iovs,
+		      size_t *out_len, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	int ret = -ENOENT;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	bl = io_buffer_get_list(ctx, req->buf_index);
+	if (unlikely(!bl))
+		goto out_unlock;
+
+	if (bl->is_mapped) {
+		ret = io_ring_buffers_peek(req, iovs, nr_iovs, out_len, bl);
+		/*
+		 * Don't recycle these buffers if we need to go through poll.
+		 * Nobody else can use them anyway, and holding on to provided
+		 * buffers for a send/write operation would happen on the app
+		 * side anyway with normal buffers. Besides, we already
+		 * committed them, they cannot be put back in the queue.
+		 */
+		req->buf_list = bl;
+		if (ret > 0) {
+			req->flags |= REQ_F_BL_NO_RECYCLE;
+			req->buf_list->head += ret;
+		}
+	} else {
+		ret = io_provided_buffers_select(req, out_len, bl, *iovs);
+	}
+out_unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+
+int io_buffers_peek(struct io_kiocb *req, struct iovec **iovs, int nr_iovs,
+		    size_t *out_len)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	int ret;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (req->buf_list) {
+		bl = req->buf_list;
+	} else {
+		bl = io_buffer_get_list(ctx, req->buf_index);
+		if (unlikely(!bl))
+			return -ENOENT;
+	}
+
+	/* don't support multiple buffer selections for legacy */
+	if (!bl->is_mapped)
+		return io_provided_buffers_select(req, out_len, bl, *iovs);
+
+	ret = io_ring_buffers_peek(req, iovs, nr_iovs, out_len, bl);
+	if (ret > 0) {
+		req->buf_list = bl;
+		req->flags |= REQ_F_BUFFERS_COMMIT;
+	}
+	return ret;
+}
+
 static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 5218bfd79e87..b4f48a144b73 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -43,6 +43,10 @@ struct io_buffer {
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 			      unsigned int issue_flags);
+int io_buffers_select(struct io_kiocb *req, struct iovec **iovs, int nr_iovs,
+		      size_t *out_len, unsigned int issue_flags);
+int io_buffers_peek(struct io_kiocb *req, struct iovec **iovs, int nr_iovs,
+		      size_t *out_len);
 void io_destroy_buffers(struct io_ring_ctx *ctx);
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
@@ -74,7 +78,7 @@ static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 	 */
 	if (req->buf_list) {
 		req->buf_index = req->buf_list->bgid;
-		req->flags &= ~REQ_F_BUFFER_RING;
+		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
 		return true;
 	}
 	return false;
@@ -98,11 +102,16 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
-static inline void __io_put_kbuf_ring(struct io_kiocb *req)
+static inline void __io_put_kbuf_ring(struct io_kiocb *req, int nr)
 {
-	if (req->buf_list) {
-		req->buf_index = req->buf_list->bgid;
-		req->buf_list->head++;
+	struct io_buffer_list *bl = req->buf_list;
+
+	if (bl) {
+		if (req->flags & REQ_F_BUFFERS_COMMIT) {
+			bl->head += nr;
+			req->flags &= ~REQ_F_BUFFERS_COMMIT;
+		}
+		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
 }
@@ -111,7 +120,7 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
 				      struct list_head *list)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req);
+		__io_put_kbuf_ring(req, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
@@ -133,8 +142,8 @@ static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 	return ret;
 }
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req,
-				       unsigned issue_flags)
+static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
+					  unsigned issue_flags)
 {
 	unsigned int ret;
 
@@ -143,9 +152,21 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 	if (req->flags & REQ_F_BUFFER_RING)
-		__io_put_kbuf_ring(req);
+		__io_put_kbuf_ring(req, nbufs);
 	else
 		__io_put_kbuf(req, issue_flags);
 	return ret;
 }
+
+static inline unsigned int io_put_kbuf(struct io_kiocb *req,
+				       unsigned issue_flags)
+{
+	return __io_put_kbufs(req, 1, issue_flags);
+}
+
+static inline unsigned int io_put_kbufs(struct io_kiocb *req, int nbufs,
+					unsigned issue_flags)
+{
+	return __io_put_kbufs(req, nbufs, issue_flags);
+}
 #endif
-- 
2.43.0


