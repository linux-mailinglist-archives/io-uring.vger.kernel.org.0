Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CE35167F2
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbiEAVAo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354915AbiEAVAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4867E2CC9F
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so2681751pjv.4
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N9uJskDhQ+Fgr4HPsfdmvFthSuFVK+eucmIba3Pls5U=;
        b=cAopBfZPQs6KToCHEi8cyS/udJLU7jgOLCRkEfdwJenYNzuf4xLLrQjjOPagDkGapx
         v0sHDs5uoikTrGk502RyNXn/nV4eEcgxK0tD1J/8EWUKyW1+JkAQwqnXB2P636WIW6Po
         btweEBd3lrd+YVasAHAguscODPZhfrqbVbRKtYzQDADUJ88CD2PJTOLLxdl1umT6khN7
         0cV2cKL87vF+xnUkO75+Rew25eXoAdPLyrBk0EMD/VOZxc8uio7kAn1Wt2CqWTkHijF+
         IF5TGKHPgDc+vJATbSX2uDC4eIWCQkS48FQOR86gxrxtMCw3hsxAnZ/1cyGF6YbekdWh
         5sKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N9uJskDhQ+Fgr4HPsfdmvFthSuFVK+eucmIba3Pls5U=;
        b=u3bD804p8tIN6PGGd8zTo0lrH2Om3wLFYocENYiemEkJug66aHurHNoJX6Wczz/euu
         FOd9ydh0xbHzwjHBCvspSOHFxUXqD3xYwVGMtwaqBld19c6CMsdoQ6DLM1eJORI2Kn1W
         dokfxtbI3uek4JPs7YPfRLnW42RuaTdNXyDC3h1bOdqka85ETFbMTxM2xcP/KvfYKLRH
         r0YnSBcOun2EBxJ8CaMZ5mcPumL2pErgq69+OKGALXJnhF7SEW3NlV8hCu7QSVNxq/s8
         cL2vevovQTptv38jDK+c2ya0sQMROCbQ7/IGMAOe21Ny3ouHw8WMFosmuF2XgDmXtEhs
         kZeQ==
X-Gm-Message-State: AOAM531WwY/R56BtEEoGDcUcY3zKR6eI3M8xdqmwhkv+NP2iFy1EW4/x
        vZlsBYNRnmyuFH6zxG52cCMDhAM/oF2nbA==
X-Google-Smtp-Source: ABdhPJxUZuqDNP7v0xdsV1OVvGp1N34Px/L3afUU7n0ZcAN8URVeLTdKXz0se82YfguxxOIvcJLBtQ==
X-Received: by 2002:a17:90b:4ac7:b0:1d1:c730:579c with SMTP id mh7-20020a17090b4ac700b001d1c730579cmr14821052pjb.189.1651438632446;
        Sun, 01 May 2022 13:57:12 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/16] io_uring: add support for ring mapped supplied buffers
Date:   Sun,  1 May 2022 14:56:53 -0600
Message-Id: <20220501205653.15775-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Provided buffers allow an application to supply io_uring with buffers
that can then be grabbed for a read/receive request, when the data
source is ready to deliver data. The existing scheme relies on using
IORING_OP_PROVIDE_BUFFERS to do that, but it can be difficult to use
in real world applications. It's pretty efficient if the application
is able to supply back batches of provided buffers when they have been
consumed and the application is ready to recycle them, but if
fragmentation occurs in the buffer space, it can become difficult to
supply enough buffers at the time. This hurts efficiency.

Add a register op, IORING_REGISTER_PBUF_RING, which allows an application
to setup a shared queue for each buffer group of provided buffers. The
application can then supply buffers simply by adding them to this ring,
and the kernel can consume then just as easily. The ring shares the head
with the application, the tail remains private in the kernel.

Provided buffers setup with IORING_REGISTER_PBUF_RING cannot use
IORING_OP_{PROVIDE,REMOVE}_BUFFERS for adding or removing entries to the
ring, they must use the mapped ring. Mapped provided buffer rings can
co-exist with normal provided buffers, just not within the same group ID.

To gauge overhead of the existing scheme and evaluate the mapped ring
approach, a simple NOP benchmark was written. It uses a ring of 128
entries, and submits/completes 32 at the time. 'Replenish' is how
many buffers are provided back at the time after they have been
consumed:

Test			Replenish			NOPs/sec
================================================================
No provided buffers	NA				~30M
Provided buffers	32				~16M
Provided buffers	 1				~10M
Ring buffers		32				~27M
Ring buffers		 1				~27M

The ring mapped buffers perform almost as well as not using provided
buffers at all, and they don't care if you provided 1 or more back at
the same time. This means application can just replenish as they go,
rather than need to batch and compact, further reducing overhead in the
application. The NOP benchmark above doesn't need to do any compaction,
so that overhead isn't even reflected in the above test.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 237 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  28 ++++
 2 files changed, 253 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 505c1d8cad30..6127cc020dc3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -283,8 +283,25 @@ struct io_rsrc_data {
 };
 
 struct io_buffer_list {
-	struct list_head buf_list;
+	/*
+	 * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
+	 * then these are classic provided buffers and ->buf_list is used.
+	 */
+	union {
+		struct list_head buf_list;
+		struct {
+			struct page **buf_pages;
+			struct io_uring_buf_ring *buf_ring;
+		};
+	};
 	__u16 bgid;
+
+	/* below is for ring provided buffers */
+	__u16 buf_nr_pages;
+	__u16 nr_entries;
+	__u16 buf_per_page;
+	__u32 tail;
+	__u32 mask;
 };
 
 struct io_buffer {
@@ -815,6 +832,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_BUFFER_RING_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
@@ -865,6 +883,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* buffer selected from ring, needs commit */
+	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
@@ -989,6 +1009,12 @@ struct io_kiocb {
 
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
+
+		/*
+		 * stores buffer ID for ring provided buffers, valid IFF
+		 * REQ_F_BUFFER_RING is set.
+		 */
+		struct io_buffer_list	*buf_list;
 	};
 
 	union {
@@ -1569,8 +1595,14 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 
 static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	list_add(&req->kbuf->list, list);
+	if (req->flags & REQ_F_BUFFER_RING) {
+		if (req->buf_list)
+			req->buf_list->tail++;
+		req->flags &= ~REQ_F_BUFFER_RING;
+	} else {
+		list_add(&req->kbuf->list, list);
+		req->flags &= ~REQ_F_BUFFER_SELECTED;
+	}
 
 	return IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 }
@@ -1579,7 +1611,7 @@ static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 {
 	lockdep_assert_held(&req->ctx->completion_lock);
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
 	return __io_put_kbuf(req, &req->ctx->io_buffers_comp);
 }
@@ -1589,7 +1621,7 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 {
 	unsigned int cflags;
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
 
 	/*
@@ -1604,7 +1636,10 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 	 * We migrate buffers from the comp_list to the issue cache list
 	 * when we need one.
 	 */
-	if (issue_flags & IO_URING_F_UNLOCKED) {
+	if (req->flags & REQ_F_BUFFER_RING) {
+		/* no buffers to recycle for this case */
+		cflags = __io_put_kbuf(req, NULL);
+	} else if (issue_flags & IO_URING_F_UNLOCKED) {
 		struct io_ring_ctx *ctx = req->ctx;
 
 		spin_lock(&ctx->completion_lock);
@@ -1634,11 +1669,23 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	struct io_buffer_list *bl;
 	struct io_buffer *buf;
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
 	/* don't recycle if we already did IO to this buffer */
 	if (req->flags & REQ_F_PARTIAL_IO)
 		return;
+	/*
+	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
+	 * the flag and hence ensure that bl->tail doesn't get incremented.
+	 * If the tail has already been incremented, hang on to it.
+	 */
+	if (req->flags & REQ_F_BUFFER_RING) {
+		if (req->buf_list) {
+			req->buf_index = req->buf_list->bgid;
+			req->flags &= ~REQ_F_BUFFER_RING;
+		}
+		return;
+	}
 
 	io_ring_submit_lock(ctx, issue_flags);
 
@@ -3591,6 +3638,53 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 	return u64_to_user_ptr(kbuf->addr);
 }
 
+static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+					  struct io_buffer_list *bl,
+					  unsigned int issue_flags)
+{
+	struct io_uring_buf_ring *br = bl->buf_ring;
+	struct io_uring_buf *buf = &br->bufs[0];
+	__u32 tail = bl->tail;
+
+	if (unlikely(smp_load_acquire(&br->head) == tail))
+		return ERR_PTR(-ENOBUFS);
+
+	tail &= bl->mask;
+	if (tail < bl->buf_per_page) {
+		buf = &br->bufs[tail];
+	} else {
+		int index = tail - bl->buf_per_page;
+		int off = index & bl->buf_per_page;
+
+		index = (index >> (PAGE_SHIFT - 4)) + 1;
+		buf = page_address(bl->buf_pages[index]);
+		buf += off;
+	}
+	if (*len > buf->len)
+		*len = buf->len;
+	req->flags |= REQ_F_BUFFER_RING;
+	req->buf_list = bl;
+	req->buf_index = buf->bid;
+
+	if (!(issue_flags & IO_URING_F_UNLOCKED))
+		return u64_to_user_ptr(buf->addr);
+
+	/*
+	 * If we came in unlocked, we have no choice but to
+	 * consume the buffer here. This does mean it'll be
+	 * pinned until the IO completes. But coming in
+	 * unlocked means we're in io-wq context, hence there
+	 * should be no further retry. For the locked case, the
+	 * caller must ensure to call the commit when the
+	 * transfer completes (or if we get -EAGAIN and must
+	 * poll or retry).
+	 */
+	req->buf_list = NULL;
+	bl->tail++;
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	return u64_to_user_ptr(buf->addr);
+}
+
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 				     unsigned int issue_flags)
 {
@@ -3606,6 +3700,9 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 
 	/* selection helpers drop the submit lock again, if needed */
+	if (bl->buf_nr_pages)
+		return io_ring_buffer_select(req, len, bl, issue_flags);
+
 	return io_provided_buffer_select(req, len, bl, issue_flags);
 }
 
@@ -3662,7 +3759,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    unsigned int issue_flags)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
 		iov[0].iov_base = u64_to_user_ptr(req->rw.addr);
 		iov[0].iov_len = req->rw.len;
 		return 0;
@@ -3682,7 +3779,7 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return false;
-	return !(req->flags & REQ_F_BUFFER_SELECTED);
+	return !(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING));
 }
 
 static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
@@ -5204,6 +5301,19 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
+	if (bl->buf_nr_pages) {
+		int j;
+
+		if (WARN_ON_ONCE(nbufs != -1U))
+			return -EINVAL;
+		for (j = 0; j < bl->buf_nr_pages; j++)
+			unpin_user_page(bl->buf_pages[j]);
+		kvfree(bl->buf_pages);
+		bl->buf_pages = NULL;
+		bl->buf_nr_pages = 0;
+		return bl->buf_ring->head - bl->tail;
+	}
+
 	/* the head kbuf is the list itself */
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
@@ -5230,8 +5340,12 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = -ENOENT;
 	bl = io_buffer_get_list(ctx, p->bgid);
-	if (bl)
-		ret = __io_remove_buffers(ctx, bl, p->nbufs);
+	if (bl) {
+		ret = -EINVAL;
+		/* can't use provide/remove buffers command on mapped buffers */
+		if (!bl->buf_nr_pages)
+			ret = __io_remove_buffers(ctx, bl, p->nbufs);
+	}
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -5379,7 +5493,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;
@@ -5390,6 +5504,11 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 			goto err;
 		}
 	}
+	/* can't add buffers via this command for a mapped buffer ring */
+	if (bl->buf_nr_pages) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	ret = io_add_buffers(ctx, p, bl);
 err:
@@ -12333,6 +12452,87 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_buf_ring *br;
+	struct io_uring_buf_reg reg;
+	struct io_buffer_list *bl;
+	struct page **pages;
+	int nr_pages;
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+
+	if (reg.pad || reg.resv[0] || reg.resv[1] || reg.resv[2])
+		return -EINVAL;
+	if (!reg.ring_addr)
+		return -EFAULT;
+	if (reg.ring_addr & ~PAGE_MASK)
+		return -EINVAL;
+	if (!is_power_of_2(reg.ring_entries))
+		return -EINVAL;
+
+	if (unlikely(reg.bgid < BGID_ARRAY && !ctx->io_bl)) {
+		int ret = io_init_bl_list(ctx);
+		if (ret)
+			return ret;
+	}
+
+	bl = io_buffer_get_list(ctx, reg.bgid);
+	if (bl && bl->buf_nr_pages)
+		return -EEXIST;
+	if (!bl) {
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+		if (!bl)
+			return -ENOMEM;
+	}
+
+	pages = io_pin_pages(reg.ring_addr,
+			     struct_size(br, bufs, reg.ring_entries),
+			     &nr_pages);
+	if (IS_ERR(pages)) {
+		kfree(bl);
+		return PTR_ERR(pages);
+	}
+
+	br = page_address(pages[0]);
+	br->head = 0;
+	bl->buf_pages = pages;
+	bl->buf_nr_pages = nr_pages;
+	bl->nr_entries = reg.ring_entries;
+	BUILD_BUG_ON(sizeof(struct io_uring_buf) != 16);
+	bl->buf_per_page = (PAGE_SIZE - sizeof(struct io_uring_buf)) /
+				sizeof(struct io_uring_buf);
+	bl->buf_ring = br;
+	bl->mask = reg.ring_entries - 1;
+	io_buffer_add_list(ctx, bl, reg.bgid);
+	return 0;
+}
+
+static int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_buf_reg reg;
+	struct io_buffer_list *bl;
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (reg.pad || reg.resv[0] || reg.resv[1] || reg.resv[2])
+		return -EINVAL;
+
+	bl = io_buffer_get_list(ctx, reg.bgid);
+	if (!bl)
+		return -ENOENT;
+	if (!bl->buf_nr_pages)
+		return -EINVAL;
+
+	__io_remove_buffers(ctx, bl, -1U);
+	if (bl->bgid >= BGID_ARRAY) {
+		xa_erase(&ctx->io_bl_xa, bl->bgid);
+		kfree(bl);
+	}
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -12461,6 +12661,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_UNREGISTER_RING_FDS:
 		ret = io_ringfd_unregister(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_PBUF_RING:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_pbuf_ring(ctx, arg);
+		break;
+	case IORING_UNREGISTER_PBUF_RING:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_unregister_pbuf_ring(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -12547,6 +12759,7 @@ static int __init io_uring_init(void)
 	/* ->buf_index is u16 */
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
 	BUILD_BUG_ON(BGID_ARRAY * sizeof(struct io_buffer_list) > PAGE_SIZE);
+	BUILD_BUG_ON(offsetof(struct io_uring_buf_ring, bufs) != 16);
 
 	/* should fit into one byte */
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 49d1f3994f8d..8c21068d31a6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -352,6 +352,10 @@ enum {
 	IORING_REGISTER_RING_FDS		= 20,
 	IORING_UNREGISTER_RING_FDS		= 21,
 
+	/* register ring based provide buffer group */
+	IORING_REGISTER_PBUF_RING		= 22,
+	IORING_UNREGISTER_PBUF_RING		= 23,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -423,6 +427,30 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+struct io_uring_buf {
+	__u64	addr;
+	__u32	len;
+	__u16	bid;
+	__u16	resv;
+};
+
+struct io_uring_buf_ring {
+	union {
+		__u32			head;
+		struct io_uring_buf	pad;
+	};
+	struct io_uring_buf		bufs[];
+};
+
+/* argument for IORING_(UN)REGISTER_PBUF_RING */
+struct io_uring_buf_reg {
+	__u64	ring_addr;
+	__u32	ring_entries;
+	__u16	bgid;
+	__u16	pad;
+	__u64	resv[3];
+};
+
 /*
  * io_uring_restriction->opcode values
  */
-- 
2.35.1

