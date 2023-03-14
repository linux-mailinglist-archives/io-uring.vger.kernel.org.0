Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A836B9CD9
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCNRRc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCNRRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:17:31 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D97CAE10D
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:10 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i19so8973450ila.10
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678814229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJ0PlvpHYVvLi0iT8vRNCY/MoXBOga4VImL2haXj/2E=;
        b=VZBzB9Ak2pXaE022TbG3v390TDWdntSrYUpVxGz8egNEf6HnuwBbEXu9CAV8lQbvGM
         yDEYKHz4yCN5UjYK2k88TrM/RnvUFkqSXXl2v/R3c17njr9Hm5b2sOlg2vE7LomtmHvl
         QeqoOgqEPXMgJD1s+zTH6EVXG+k8gBnF+zrUKw3pCWEOLx+waG3Tw20W8P1zl6EMu171
         2onRWY9d0lDpJUnWe04trWs2sZKHMsx4dG1KskTPBav54EW6tbp57EA8p6E0Am2556Y8
         v4kZykOt05A//pfDa+oqptBK3RQ+hRtr6PbGnH02jMT0YWxlkGBr6krhh0E3TmvgCYnx
         6nfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJ0PlvpHYVvLi0iT8vRNCY/MoXBOga4VImL2haXj/2E=;
        b=YyTE1ixDzxuIhegE45fYEhPoZUpqmG/NXPIGeXHnD+WoDqPYoi02vmZ6PZVLzveKWL
         WydkCwrKenPt7MmjNOMMt8tS9t1KS8swP1Ek3DujvrNVmGG/2SGUP7XzScSOpUc5kEmn
         T8buitaSdUuCyKqgK+M2pPNPPeC9dgV8elNaoPlltYp2i5x8Ndly8Ey7eZegyrUNTqAR
         SwAPGxT7/XQKWO97/B/8Vp4cpKMzM2Tni+5iWkAghsu1ROPxwfIxGBv+qGOvWeQs1Ds6
         slJOCkU8j4rQeMfS5JXz4gSM5uRVSTgWR3UnDKBBkMTuBMeBVkPqRwnUkU6Qq4wyBTUy
         49DA==
X-Gm-Message-State: AO0yUKV1z3h20b/xtMSl+l1Cg/K/S8w5bQJNMdcE7rTyXbwLWa4hFjX4
        XtBKqmYXtYeDDr+qXdaPf+9YxnZMrryIRUdhqLbzKw==
X-Google-Smtp-Source: AK7set8BoC26E40sQskAfa2RaQS2cwfiyZcF1ipj5cpatuUrEG8+/vnBg3RBNYN4D6LnhD2765KlSg==
X-Received: by 2002:a92:7406:0:b0:322:fad5:5d8f with SMTP id p6-20020a927406000000b00322fad55d8fmr6227757ilc.2.1678814229030;
        Tue, 14 Mar 2023 10:17:09 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a056e02068c00b003179b81610csm948950ils.17.2023.03.14.10.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:17:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     deller@gmx.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: add support for user mapped provided buffer ring
Date:   Tue, 14 Mar 2023 11:16:42 -0600
Message-Id: <20230314171641.10542-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314171641.10542-1-axboe@kernel.dk>
References: <20230314171641.10542-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The ring mapped provided buffer rings rely on the application allocating
the memory for the ring, and then the kernel will map it. This generally
works fine, but runs into issues on some architectures where we need
to be able to ensure that the kernel and application virtual address for
the ring play nicely together. This at least impacts architectures that
set SHM_COLOUR, but potentially also anyone setting SHMLBA.

To use this variant of ring provided buffers, the application need not
allocate any memory for the ring. Instead the kernel will do so, and
the allocation must subsequently call mmap(2) on the ring with the
offset set to:

	IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT)

to get a virtual address for the buffer ring. Normally the application
would allocate a suitable piece of memory (and correctly aligned) and
simply pass that in via io_uring_buf_reg.ring_addr and the kernel would
map it.

Outside of the setup differences, the kernel allocate + user mapped
provided buffer ring works exactly the same.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 17 ++++++
 io_uring/io_uring.c           | 13 ++++-
 io_uring/kbuf.c               | 99 +++++++++++++++++++++++++++--------
 io_uring/kbuf.h               |  4 ++
 4 files changed, 109 insertions(+), 24 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c3f3ea997f3a..1d59c816a5b8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -389,6 +389,9 @@ enum {
 #define IORING_OFF_SQ_RING		0ULL
 #define IORING_OFF_CQ_RING		0x8000000ULL
 #define IORING_OFF_SQES			0x10000000ULL
+#define IORING_OFF_PBUF_RING		0x80000000ULL
+#define IORING_OFF_PBUF_SHIFT		16
+#define IORING_OFF_MMAP_MASK		0xf8000000ULL
 
 /*
  * Filled with the offset for mmap(2)
@@ -635,6 +638,20 @@ struct io_uring_buf_ring {
 	};
 };
 
+/*
+ * Flags for IORING_REGISTER_PBUF_RING.
+ *
+ * IOU_PBUF_RING_MMAP:	If set, kernel will allocate the memory for the ring.
+ *			The application must not set a ring_addr in struct
+ *			io_uring_buf_reg, instead it must subsequently call
+ *			mmap(2) with the offset set as:
+ *			IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT)
+ *			to get a virtual mapping for the ring.
+ */
+enum {
+	IOU_PBUF_RING_MMAP	= 1,
+};
+
 /* argument for IORING_(UN)REGISTER_PBUF_RING */
 struct io_uring_buf_reg {
 	__u64	ring_addr;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3adecebbac71..caebe9c82728 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3283,7 +3283,7 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	struct page *page;
 	void *ptr;
 
-	switch (offset) {
+	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
 		ptr = ctx->rings;
@@ -3291,6 +3291,17 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	case IORING_OFF_SQES:
 		ptr = ctx->sq_sqes;
 		break;
+	case IORING_OFF_PBUF_RING: {
+		unsigned int bgid;
+
+		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
+		mutex_lock(&ctx->uring_lock);
+		ptr = io_pbuf_get_address(ctx, bgid);
+		mutex_unlock(&ctx->uring_lock);
+		if (!ptr)
+			return ERR_PTR(-EINVAL);
+		break;
+		}
 	default:
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 4b2f4a0ee962..cd1d9dddf58e 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -137,7 +137,8 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		return NULL;
 
 	head &= bl->mask;
-	if (head < IO_BUFFER_LIST_BUF_PER_PAGE) {
+	/* mmaped buffers are always contig */
+	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
 		buf = &br->bufs[head];
 	} else {
 		int off = head & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
@@ -214,15 +215,27 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
-	if (bl->is_mapped && bl->buf_nr_pages) {
-		int j;
-
+	if (bl->is_mapped) {
 		i = bl->buf_ring->tail - bl->head;
-		for (j = 0; j < bl->buf_nr_pages; j++)
-			unpin_user_page(bl->buf_pages[j]);
-		kvfree(bl->buf_pages);
-		bl->buf_pages = NULL;
-		bl->buf_nr_pages = 0;
+		if (bl->is_mmap) {
+			if (bl->buf_ring) {
+				struct page *page;
+
+				page = virt_to_head_page(bl->buf_ring);
+				if (put_page_testzero(page))
+					free_compound_page(page);
+				bl->buf_ring = NULL;
+			}
+			bl->is_mmap = 0;
+		} else if (bl->buf_nr_pages) {
+			int j;
+
+			for (j = 0; j < bl->buf_nr_pages; j++)
+				unpin_user_page(bl->buf_pages[j]);
+			kvfree(bl->buf_pages);
+			bl->buf_pages = NULL;
+			bl->buf_nr_pages = 0;
+		}
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
 		bl->is_mapped = 0;
@@ -482,6 +495,25 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;
 	bl->is_mapped = 1;
+	bl->is_mmap = 0;
+	return 0;
+}
+
+static int io_alloc_pbuf_ring(struct io_uring_buf_reg *reg,
+			      struct io_buffer_list *bl)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
+	size_t ring_size;
+	void *ptr;
+
+	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
+	ptr = (void *) __get_free_pages(gfp, get_order(ring_size));
+	if (!ptr)
+		return -ENOMEM;
+
+	bl->buf_ring = ptr;
+	bl->is_mapped = 1;
+	bl->is_mmap = 1;
 	return 0;
 }
 
@@ -496,12 +528,18 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
 		return -EINVAL;
-	if (reg.flags)
-		return -EINVAL;
-	if (!reg.ring_addr)
-		return -EFAULT;
-	if (reg.ring_addr & ~PAGE_MASK)
+	if (reg.flags & ~IOU_PBUF_RING_MMAP)
 		return -EINVAL;
+	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
+		if (!reg.ring_addr)
+			return -EFAULT;
+		if (reg.ring_addr & ~PAGE_MASK)
+			return -EINVAL;
+	} else {
+		if (reg.ring_addr)
+			return -EINVAL;
+	}
+
 	if (!is_power_of_2(reg.ring_entries))
 		return -EINVAL;
 
@@ -526,17 +564,21 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 			return -ENOMEM;
 	}
 
-	ret = io_pin_pbuf_ring(&reg, bl);
-	if (ret) {
-		kfree(free_bl);
-		return ret;
-	}
+	if (!(reg.flags & IOU_PBUF_RING_MMAP))
+		ret = io_pin_pbuf_ring(&reg, bl);
+	else
+		ret = io_alloc_pbuf_ring(&reg, bl);
 
-	bl->nr_entries = reg.ring_entries;
-	bl->mask = reg.ring_entries - 1;
+	if (!ret) {
+		bl->nr_entries = reg.ring_entries;
+		bl->mask = reg.ring_entries - 1;
 
-	io_buffer_add_list(ctx, bl, reg.bgid);
-	return 0;
+		io_buffer_add_list(ctx, bl, reg.bgid);
+		return 0;
+	}
+
+	kfree(free_bl);
+	return ret;
 }
 
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
@@ -564,3 +606,14 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 	return 0;
 }
+
+void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
+{
+	struct io_buffer_list *bl;
+
+	bl = io_buffer_get_list(ctx, bgid);
+	if (!bl || !bl->is_mmap)
+		return NULL;
+
+	return bl->buf_ring;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 61b9c7dade9d..d14345ef61fc 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -26,6 +26,8 @@ struct io_buffer_list {
 
 	/* ring mapped provided buffers */
 	__u8 is_mapped;
+	/* ring mapped provided buffers, but mmap'ed by application */
+	__u8 is_mmap;
 };
 
 struct io_buffer {
@@ -53,6 +55,8 @@ unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
+void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
+
 static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
-- 
2.39.2

