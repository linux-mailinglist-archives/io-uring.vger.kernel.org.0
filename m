Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADFE51494C
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359138AbiD2Mbm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359155AbiD2Mbl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76239C90D3
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p6so6994732plf.9
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lB5/nEJaG5fQ+6MbTbFrZh/B0TD9JH3P2L8NOMIsLhY=;
        b=C2Gz6RAOIzE8HzzQISJXc4wZdG0G68m7B6Un3SeO99BUk9tsZI5kV6wv1JJCYvdAn9
         fkQ1oGjBuydMqx9U2hHKu5RmHUGihV04HZrytO6e96pCPPHjFAHT5uA2N18Qx3aEvxDl
         s67pqYK+07jQiBQfkMlqQlfcywqvbNQoObxjm4QMAMDQBLwTrnYIGvPmDZCiCbRcfOuc
         xt7NAQCEq4jIJyAqewWwDKhHdVLdfb+uPEQhfAYLYU7/+D0/BWURS16wpow02KEvQo8p
         tgbKXo955m4A1lNeyYF9AWbGlZ3+/1xK/7Cu/y0aybK05peMShR/mdF3fhnmxN5GzTwk
         x5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lB5/nEJaG5fQ+6MbTbFrZh/B0TD9JH3P2L8NOMIsLhY=;
        b=kd/dqUKMf95aDNY+qnK0lsZlvcYzLUtdxaDXCGlssFPgdRj4omjK0D+RTqAsgxprIC
         SFCTI6COtq43jTfc+6aYvT6jH52lfz2np5hWYIVg3ac/d6IZqj8Y00SLwOoZtTKUDXkV
         1jYy0SPpSVVVuiJFr3ESukxLlpfvAFNjOW29djupLzXJ42zrN2BvAEr4Esqyb+gfyPDZ
         v8RtGTqR7CenrPfk7MHlkxQ9xofleaUGTBZLBbo37ILHFdUaXkdJuTHQYuj7F6rToN+N
         hNI+M6rp0ehttTvvbrje07lGvWdxqjXX6NDyZ/+t9mNDBBIIUzmdo/XiwB3wX955thAS
         q58g==
X-Gm-Message-State: AOAM532E4wQ7sllKGcKDEuJlPYWo83DKSzq+oYwvFPW48hEX6BluJidN
        hhw922V+QGHWdKi/TkRCLXMXvozYls40LuCx
X-Google-Smtp-Source: ABdhPJyaCnT9VwvF1LUxfXT1lBxKvMQxru6GAKhvNeQt4orKUT+LrKbhLO1yRKeaSlROTa3fBXTCkw==
X-Received: by 2002:a17:90a:d593:b0:1d9:2bc9:f1a6 with SMTP id v19-20020a17090ad59300b001d92bc9f1a6mr3628917pju.207.1651235299524;
        Fri, 29 Apr 2022 05:28:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/10] io_uring: add support for ring mapped supplied buffers
Date:   Fri, 29 Apr 2022 06:28:03 -0600
Message-Id: <20220429122803.41101-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 fs/io_uring.c                 | 217 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  26 ++++
 2 files changed, 230 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b0deba430ca..4919585fa20d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -285,7 +285,16 @@ struct io_rsrc_data {
 struct io_buffer_list {
 	struct list_head list;
 	struct list_head buf_list;
+	struct page **buf_pages;
 	__u16 bgid;
+
+	/* below is for ring provided buffers */
+	__u16 buf_nr_pages;
+	__u16 nr_entries;
+	__u16 buf_per_page;
+	struct io_uring_buf_ring *buf_ring;
+	__u32 tail;
+	__u32 mask;
 };
 
 struct io_buffer {
@@ -815,6 +824,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_BUFFER_RING_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
@@ -865,6 +875,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* buffer selected from ring, needs commit */
+	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
@@ -995,8 +1007,15 @@ struct io_kiocb {
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
-	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
-	struct io_buffer		*kbuf;
+	union {
+		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
+		struct io_buffer	*kbuf;
+		/*
+		 * stores buffer ID for ring provided buffers, valid IFF
+		 * REQ_F_BUFFER_RING is set.
+		 */
+		__u32			bid;
+	};
 	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
@@ -1581,21 +1600,32 @@ static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 
 static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
-	struct io_buffer *kbuf = req->kbuf;
 	unsigned int cflags;
 
-	cflags = IORING_CQE_F_BUFFER | (kbuf->bid << IORING_CQE_BUFFER_SHIFT);
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	list_add(&kbuf->list, list);
+	if (req->flags & REQ_F_BUFFER_RING) {
+		struct io_buffer_list *bl;
+
+		/* mark as consumed. would be nice to avoid lookup... */
+		bl = io_buffer_get_list(req->ctx, req->buf_index);
+		bl->tail++;
+
+		cflags = req->bid << IORING_CQE_BUFFER_SHIFT;
+	} else {
+		struct io_buffer *kbuf = req->kbuf;
+
+		cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+		list_add(&kbuf->list, list);
+	}
+	req->flags &= ~(REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING);
 	req->kbuf = NULL;
-	return cflags;
+	return cflags | IORING_CQE_F_BUFFER;
 }
 
 static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 {
 	lockdep_assert_held(&req->ctx->completion_lock);
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
 	return __io_put_kbuf(req, &req->ctx->io_buffers_comp);
 }
@@ -1605,7 +1635,7 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 {
 	unsigned int cflags;
 
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
 
 	/*
@@ -1641,11 +1671,19 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
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
+	 */
+	if (req->flags & REQ_F_BUFFER_RING) {
+		req->flags &= ~REQ_F_BUFFER_RING;
+		return;
+	}
 
 	io_ring_submit_lock(ctx, issue_flags);
 
@@ -3597,6 +3635,52 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
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
+		index = (index >> 8) + 1;
+		buf = page_address(bl->buf_pages[index]);
+		buf += off;
+	}
+	if (*len > buf->len)
+		*len = buf->len;
+	req->flags |= REQ_F_BUFFER_RING;
+	req->bid = buf->bid;
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
+	req->flags &= ~REQ_F_BUFFER_RING;
+	bl->tail++;
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	return u64_to_user_ptr(buf->addr);
+}
+
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 				     unsigned int issue_flags)
 {
@@ -3615,6 +3699,9 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 
 	/* selection helpers drop the submit lock again, if needed */
+	if (bl->buf_pages)
+		return io_ring_buffer_select(req, len, bl, issue_flags);
+
 	return io_provided_buffer_select(req, len, bl, issue_flags);
 }
 
@@ -5209,6 +5296,17 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
+	if (bl->buf_pages) {
+		int j;
+
+		if (WARN_ON_ONCE(nbufs != -1U))
+			return -EINVAL;
+		for (j = 0; j < bl->buf_nr_pages; j++)
+			unpin_user_page(bl->buf_pages[j]);
+		kvfree(bl->buf_pages);
+		bl->buf_pages = NULL;
+	}
+
 	/* the head kbuf is the list itself */
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
@@ -5235,8 +5333,12 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = -ENOENT;
 	bl = io_buffer_get_list(ctx, p->bgid);
-	if (bl)
-		ret = __io_remove_buffers(ctx, bl, p->nbufs);
+	if (bl) {
+		ret = -EINVAL;
+		/* can't use provide/remove buffers command on mapped buffers */
+		if (!bl->buf_pages)
+			ret = __io_remove_buffers(ctx, bl, p->nbufs);
+	}
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -5361,13 +5463,18 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;
 		}
 		io_buffer_add_list(ctx, bl, p->bgid);
 	}
+	/* can't add buffers via this command for a mapped buffer ring */
+	if (bl->buf_pages) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	ret = io_add_buffers(ctx, p, bl);
 err:
@@ -12310,6 +12417,77 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
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
+	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
+		return -EINVAL;
+	if (!reg.ring_addr)
+		return -EFAULT;
+	if (reg.ring_addr & ~PAGE_MASK)
+		return -EINVAL;
+	if (!is_power_of_2(reg.ring_entries))
+		return -EINVAL;
+
+	bl = io_buffer_get_list(ctx, reg.bgid);
+	if (bl)
+		return -EEXIST;
+	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	if (!bl)
+		return -ENOMEM;
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
+	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
+		return -EINVAL;
+
+	bl = io_buffer_get_list(ctx, reg.bgid);
+	if (!bl)
+		return -ENOENT;
+	if (!bl->buf_pages)
+		return -EINVAL;
+
+	__io_remove_buffers(ctx, bl, -1U);
+	list_del(&bl->list);
+	kfree(bl);
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -12438,6 +12616,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
@@ -12523,6 +12713,7 @@ static int __init io_uring_init(void)
 
 	/* ->buf_index is u16 */
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
+	BUILD_BUG_ON(offsetof(struct io_uring_buf_ring, bufs) != 16);
 
 	/* should fit into one byte */
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 49d1f3994f8d..90b70071110a 100644
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
@@ -423,6 +427,28 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+struct io_uring_buf {
+	__u64	addr;
+	__u32	len;
+	__u32	bid;
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
+	__u32	bgid;
+	__u64	resv[3];
+};
+
 /*
  * io_uring_restriction->opcode values
  */
-- 
2.35.1

