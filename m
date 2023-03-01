Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC546A6DDC
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCAOI0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCAOIZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:08:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9232E827
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTiSqUkgIjk2gbhCZoCuEwpFtez4HFv9wv/umxEg0aA=;
        b=FSP/DbJ3AgzjUpiE2wlmtwSyvMkGwXKCOdKdYXUqPeszFD9OiFnPEKUcnvjYr9vN58g+l3
        u3lsBRl0DmHAE+TthvP7bvSHoo7x+hFsTn/IR8Ou79hYkW0r0C1m5WNV6sY306T77sZo2G
        +1JoOaJTjtf3f4kkWdqDNbwswfbCuj4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-d7Zz0fMeOkaLYRMNodORiA-1; Wed, 01 Mar 2023 09:07:40 -0500
X-MC-Unique: d7Zz0fMeOkaLYRMNodORiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FBA18AD540;
        Wed,  1 Mar 2023 14:06:39 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCB8F2166B26;
        Wed,  1 Mar 2023 14:06:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 04/12] io_uring: rename io_mapped_ubuf as io_mapped_buf
Date:   Wed,  1 Mar 2023 22:06:03 +0800
Message-Id: <20230301140611.163055-5-ming.lei@redhat.com>
In-Reply-To: <20230301140611.163055-1-ming.lei@redhat.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prepare to reuse io_mapped_ubuf for feeding fused command
kbuf(bvec based buffer) to io_uring OP.

Meantime rename ->ubuf as ->buf, and -ubuf_end as ->buf_end,
both are actually just used for figuring out buffer offset &
length only.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  6 +++---
 io_uring/fdinfo.c              |  6 +++---
 io_uring/io_uring.c            |  2 +-
 io_uring/rsrc.c                | 26 +++++++++++++-------------
 io_uring/rsrc.h                | 10 +++++-----
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 87342649d2c3..7a27b1d3e2ea 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -244,7 +244,7 @@ struct io_ring_ctx {
 		struct io_file_table	file_table;
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
-		struct io_mapped_ubuf	**user_bufs;
+		struct io_mapped_buf	**user_bufs;
 
 		struct io_submit_state	submit_state;
 
@@ -326,7 +326,7 @@ struct io_ring_ctx {
 
 	/* slow path rsrc auxilary data, used by update/register */
 	struct io_rsrc_node		*rsrc_backup_node;
-	struct io_mapped_ubuf		*dummy_ubuf;
+	struct io_mapped_buf		*dummy_ubuf;
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
@@ -541,7 +541,7 @@ struct io_kiocb {
 
 	union {
 		/* store used ubuf, so we can prevent reloading */
-		struct io_mapped_ubuf	*imu;
+		struct io_mapped_buf	*imu;
 
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 882bd56b01ed..2f663a795411 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -157,10 +157,10 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = ctx->user_bufs[i];
-		unsigned int len = buf->ubuf_end - buf->ubuf;
+		struct io_mapped_buf *buf = ctx->user_bufs[i];
+		unsigned int len = buf->buf_end - buf->buf;
 
-		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, len);
+		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->buf, len);
 	}
 	if (has_lock && !xa_empty(&ctx->personalities)) {
 		unsigned long index;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 09cc5eaec4ab..3df66fddda5a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -298,7 +298,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	if (!ctx->dummy_ubuf)
 		goto err;
 	/* set invalid range, so io_import_fixed() fails meeting it */
-	ctx->dummy_ubuf->ubuf = -1UL;
+	ctx->dummy_ubuf->buf = -1UL;
 
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    0, GFP_KERNEL))
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c41edd197b0a..26c07b28e8bb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -24,7 +24,7 @@ struct io_rsrc_update {
 };
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf **pimu,
+				  struct io_mapped_buf **pimu,
 				  struct page **last_hpage);
 
 #define IO_RSRC_REF_BATCH	100
@@ -136,9 +136,9 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
-static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slot)
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_buf **slot)
 {
-	struct io_mapped_ubuf *imu = *slot;
+	struct io_mapped_buf *imu = *slot;
 	unsigned int i;
 
 	if (imu != ctx->dummy_ubuf) {
@@ -542,7 +542,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
-		struct io_mapped_ubuf *imu;
+		struct io_mapped_buf *imu;
 		int offset = up->offset + done;
 		u64 tag = 0;
 
@@ -1092,7 +1092,7 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
+		struct io_mapped_buf *imu = ctx->user_bufs[i];
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -1106,7 +1106,7 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 }
 
 static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
-				 int nr_pages, struct io_mapped_ubuf *imu,
+				 int nr_pages, struct io_mapped_buf *imu,
 				 struct page **last_hpage)
 {
 	int i, ret;
@@ -1199,10 +1199,10 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 }
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf **pimu,
+				  struct io_mapped_buf **pimu,
 				  struct page **last_hpage)
 {
-	struct io_mapped_ubuf *imu = NULL;
+	struct io_mapped_buf *imu = NULL;
 	struct page **pages = NULL;
 	unsigned long off;
 	size_t size;
@@ -1242,8 +1242,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		size -= vec_len;
 	}
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->ubuf_end = imu->ubuf + iov->iov_len;
+	imu->buf = (unsigned long) iov->iov_base;
+	imu->buf_end = imu->buf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	imu->bvec = imu->__bvec;
 	*pimu = imu;
@@ -1321,7 +1321,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 }
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
+			   struct io_mapped_buf *imu,
 			   u64 buf_addr, size_t len)
 {
 	u64 buf_end;
@@ -1332,14 +1332,14 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
+	if (unlikely(buf_addr < imu->buf || buf_end > imu->buf_end))
 		return -EFAULT;
 
 	/*
 	 * May not be a start of buffer, set size appropriately
 	 * and advance us to the beginning.
 	 */
-	offset = buf_addr - imu->ubuf;
+	offset = buf_addr - imu->buf;
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
 
 	if (offset) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 24329eca49ef..5da54702cad1 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -19,7 +19,7 @@ struct io_rsrc_put {
 	union {
 		void *rsrc;
 		struct file *file;
-		struct io_mapped_ubuf *buf;
+		struct io_mapped_buf *buf;
 	};
 };
 
@@ -45,9 +45,9 @@ struct io_rsrc_node {
 	bool				done;
 };
 
-struct io_mapped_ubuf {
-	u64		ubuf;
-	u64		ubuf_end;
+struct io_mapped_buf {
+	u64		buf;
+	u64		buf_end;
 	unsigned int	nr_bvecs;
 	unsigned int	acct_pages;
 	struct bio_vec	*bvec;
@@ -67,7 +67,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill);
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
+			   struct io_mapped_buf *imu,
 			   u64 buf_addr, size_t len);
 
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
-- 
2.31.1

