Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A54F51E7D1
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385353AbiEGOe1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385256AbiEGOe0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:34:26 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974EA1BE89
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 07:30:38 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v11so8587410pff.6
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 07:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UKK+6bi+13718kkX1uqh/qKGTPhEG9sNp5tyQzz0xfk=;
        b=VcSyjmi+/5/cZGHw5CAJmNh3+G2GKx+vZoYG2xIFldMU52nGEJZDKDKlUG3AE6dJzx
         q1qvNlHbXfwXm6ED6CNuGBFI6W5Nl+GA3UUbWORb1Bk4ym4Fg80LgHmsKQSBpBL7x4il
         iBxe0Kw6cEYwKT3ryOlNM9mV1j2I6h6jAIomAE/mWxIkEqF9Ylqoo5j9/ZfnRc45Ns+i
         pUDcR9j0dAUFPL3pESC8xQezR1f/Keii/XCYt7icqmk2SUWfcSIossZF1MFzvi8Kg8BV
         uctl7jhvHCAQS/sy/f8SvGly2l9KznGFh/ubUY+9hUwXhvnO+Jl8Nv5D21zoUp7DT0ir
         csxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UKK+6bi+13718kkX1uqh/qKGTPhEG9sNp5tyQzz0xfk=;
        b=u1NlkOZ7g5f3N5oR+PctsZp6iEkx7bOvNeLt4t0XY/p5kp9YFvJUlSBZoiliy2Xvms
         P+91ZE1eZbsMZk0jSAsNmcKO5LmjN3FmEFOSa4u9pdcnD2sPsCVRz/x+0tRTGhqwv+Ck
         q+bAe8kbLwV26+ngDUEbrMe6n9nLGwoZvKgbK5n31LtwHa0UVWyCuEyTix9BVKO1L1pR
         E60RBULpecpBm1CM/tBQgv4KkFNDxdhLoPYneOhr6iu83Gl0Zvl7EDN0vNFm85ZYdEy0
         ohES6HRvaMjhLAYNSiwCIWcXYVrd4k26gBPtdTo28ynoHSrW4/oOFMXl8gYnekJ3dU/a
         VNBA==
X-Gm-Message-State: AOAM532C6itdVB/qs3YJId5ztjUhicorzNVqxNvXWR1Cz6dXWjLsl6ir
        Ch7H06rZLfzhoR4b74eSrZU32nv95AF+vg==
X-Google-Smtp-Source: ABdhPJwN9hX7yDfe79pHkxXuxMkFSIZcIVOzRQn2LpVVPGpJ8zQxSAsPvzbv3HdenGcKu+BiGnmyBA==
X-Received: by 2002:a63:5a13:0:b0:3c6:3d28:87e5 with SMTP id o19-20020a635a13000000b003c63d2887e5mr6912576pgb.452.1651933837826;
        Sat, 07 May 2022 07:30:37 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h7-20020aa796c7000000b0050dc76281e3sm5332936pfq.189.2022.05.07.07.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 07:30:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add support for ring mapped supplied buffers
Date:   Sat,  7 May 2022 08:30:31 -0600
Message-Id: <20220507143031.48321-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507143031.48321-1-axboe@kernel.dk>
References: <20220507143031.48321-1-axboe@kernel.dk>
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
 fs/io_uring.c                 | 234 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  28 ++++
 2 files changed, 250 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe68de1ce308..f49b5b872f5d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -282,8 +282,25 @@ struct io_rsrc_data {
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
@@ -800,6 +817,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_BUFFER_RING_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
@@ -850,6 +868,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* buffer selected from ring, needs commit */
+	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
@@ -972,6 +992,12 @@ struct io_kiocb {
 
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
@@ -1462,8 +1488,14 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 
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
@@ -1472,7 +1504,7 @@ static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 {
 	lockdep_assert_held(&req->ctx->completion_lock);
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
 	return __io_put_kbuf(req, &req->ctx->io_buffers_comp);
 }
@@ -1482,7 +1514,7 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 {
 	unsigned int cflags;
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
 
 	/*
@@ -1497,7 +1529,10 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
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
@@ -1527,11 +1562,23 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
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
 
@@ -3476,6 +3523,53 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
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
@@ -3491,6 +3585,9 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 
 	/* selection helpers drop the submit lock again, if needed */
+	if (bl->buf_nr_pages)
+		return io_ring_buffer_select(req, len, bl, issue_flags);
+
 	return io_provided_buffer_select(req, len, bl, issue_flags);
 }
 
@@ -3547,7 +3644,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    unsigned int issue_flags)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
 		iov[0].iov_base = u64_to_user_ptr(req->rw.addr);
 		iov[0].iov_len = req->rw.len;
 		return 0;
@@ -3567,7 +3664,7 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return false;
-	return !(req->flags & REQ_F_BUFFER_SELECTED);
+	return !(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING));
 }
 
 static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
@@ -4806,6 +4903,17 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
+	if (bl->buf_nr_pages) {
+		int j;
+
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
@@ -4832,8 +4940,12 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
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
 
@@ -4981,7 +5093,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;
@@ -4992,6 +5104,11 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -11846,6 +11963,86 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
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
@@ -11974,6 +12171,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
@@ -12059,6 +12268,7 @@ static int __init io_uring_init(void)
 	/* ->buf_index is u16 */
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
 	BUILD_BUG_ON(BGID_ARRAY * sizeof(struct io_buffer_list) > PAGE_SIZE);
+	BUILD_BUG_ON(offsetof(struct io_uring_buf_ring, bufs) != 16);
 
 	/* should fit into one byte */
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 06621a278cb6..989d35549b9e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -370,6 +370,10 @@ enum {
 	IORING_REGISTER_RING_FDS		= 20,
 	IORING_UNREGISTER_RING_FDS		= 21,
 
+	/* register ring based provide buffer group */
+	IORING_REGISTER_PBUF_RING		= 22,
+	IORING_UNREGISTER_PBUF_RING		= 23,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -441,6 +445,30 @@ struct io_uring_restriction {
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

