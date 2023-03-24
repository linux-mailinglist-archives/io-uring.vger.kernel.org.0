Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247746C7F5B
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 15:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjCXOA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 10:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjCXOAT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 10:00:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E5F1BADE
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NN28dKc6XxSu1a4tYzmGw6THkgXaxqwwsT/5pOpys2I=;
        b=FeQqoh/PNrjbdrglowUoP5HpG1RX649ygF8v7QBjRZDMScKpWKzAPhkrr5zAfk0Ofd5wMi
        UXxOUDsrKEpHMaXdm1W7KbgqgM/54sPACstoOWk83Cm/Cs4ngPTu0ro5vtWYNRKIevnHSe
        ZqwaJeE5/jVzk3bcfek5AL/++9zfQq0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-orZJI0ePNO2w2QP9P70RMg-1; Fri, 24 Mar 2023 09:59:04 -0400
X-MC-Unique: orZJI0ePNO2w2QP9P70RMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5500F2817233;
        Fri, 24 Mar 2023 13:59:03 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 789294020C81;
        Fri, 24 Mar 2023 13:59:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 12/17] block: ublk_drv: cleanup ublk_copy_user_pages
Date:   Fri, 24 Mar 2023 21:58:03 +0800
Message-Id: <20230324135808.855245-13-ming.lei@redhat.com>
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clean up ublk_copy_user_pages() by using iov iter, and code
gets simplified a lot and becomes much more readable than before.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 112 +++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 63 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0e7533858c1f..85ceb8c09d0e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -419,49 +419,39 @@ static const struct block_device_operations ub_fops = {
 
 #define UBLK_MAX_PIN_PAGES	32
 
-struct ublk_map_data {
-	const struct request *rq;
-	unsigned long	ubuf;
-	unsigned int	len;
-};
-
 struct ublk_io_iter {
 	struct page *pages[UBLK_MAX_PIN_PAGES];
-	unsigned pg_off;	/* offset in the 1st page in pages */
-	int nr_pages;		/* how many page pointers in pages */
 	struct bio *bio;
 	struct bvec_iter iter;
 };
 
-static inline unsigned ublk_copy_io_pages(struct ublk_io_iter *data,
-		unsigned max_bytes, bool to_vm)
+/* return how many pages are copied */
+static void ublk_copy_io_pages(struct ublk_io_iter *data,
+		size_t total, size_t pg_off, int dir)
 {
-	const unsigned total = min_t(unsigned, max_bytes,
-			PAGE_SIZE - data->pg_off +
-			((data->nr_pages - 1) << PAGE_SHIFT));
 	unsigned done = 0;
 	unsigned pg_idx = 0;
 
 	while (done < total) {
 		struct bio_vec bv = bio_iter_iovec(data->bio, data->iter);
-		const unsigned int bytes = min3(bv.bv_len, total - done,
-				(unsigned)(PAGE_SIZE - data->pg_off));
+		unsigned int bytes = min3(bv.bv_len, (unsigned)total - done,
+				(unsigned)(PAGE_SIZE - pg_off));
 		void *bv_buf = bvec_kmap_local(&bv);
 		void *pg_buf = kmap_local_page(data->pages[pg_idx]);
 
-		if (to_vm)
-			memcpy(pg_buf + data->pg_off, bv_buf, bytes);
+		if (dir == ITER_DEST)
+			memcpy(pg_buf + pg_off, bv_buf, bytes);
 		else
-			memcpy(bv_buf, pg_buf + data->pg_off, bytes);
+			memcpy(bv_buf, pg_buf + pg_off, bytes);
 
 		kunmap_local(pg_buf);
 		kunmap_local(bv_buf);
 
 		/* advance page array */
-		data->pg_off += bytes;
-		if (data->pg_off == PAGE_SIZE) {
+		pg_off += bytes;
+		if (pg_off == PAGE_SIZE) {
 			pg_idx += 1;
-			data->pg_off = 0;
+			pg_off = 0;
 		}
 
 		done += bytes;
@@ -475,41 +465,40 @@ static inline unsigned ublk_copy_io_pages(struct ublk_io_iter *data,
 			data->iter = data->bio->bi_iter;
 		}
 	}
-
-	return done;
 }
 
-static int ublk_copy_user_pages(struct ublk_map_data *data, bool to_vm)
+/*
+ * Copy data between request pages and io_iter, and 'offset'
+ * is the start point of linear offset of request.
+ */
+static size_t ublk_copy_user_pages(const struct request *req,
+		struct iov_iter *uiter, int dir)
 {
-	const unsigned int gup_flags = to_vm ? FOLL_WRITE : 0;
-	const unsigned long start_vm = data->ubuf;
-	unsigned int done = 0;
 	struct ublk_io_iter iter = {
-		.pg_off	= start_vm & (PAGE_SIZE - 1),
-		.bio	= data->rq->bio,
-		.iter	= data->rq->bio->bi_iter,
+		.bio	= req->bio,
+		.iter	= req->bio->bi_iter,
 	};
-	const unsigned int nr_pages = round_up(data->len +
-			(start_vm & (PAGE_SIZE - 1)), PAGE_SIZE) >> PAGE_SHIFT;
-
-	while (done < nr_pages) {
-		const unsigned to_pin = min_t(unsigned, UBLK_MAX_PIN_PAGES,
-				nr_pages - done);
-		unsigned i, len;
-
-		iter.nr_pages = get_user_pages_fast(start_vm +
-				(done << PAGE_SHIFT), to_pin, gup_flags,
-				iter.pages);
-		if (iter.nr_pages <= 0)
-			return done == 0 ? iter.nr_pages : done;
-		len = ublk_copy_io_pages(&iter, data->len, to_vm);
-		for (i = 0; i < iter.nr_pages; i++) {
-			if (to_vm)
+	size_t done = 0;
+
+	while (iov_iter_count(uiter) && iter.bio) {
+		unsigned nr_pages;
+		size_t len, off;
+		int i;
+
+		len = iov_iter_get_pages2(uiter, iter.pages,
+				iov_iter_count(uiter),
+				UBLK_MAX_PIN_PAGES, &off);
+		if (len <= 0)
+			return done;
+
+		ublk_copy_io_pages(&iter, len, off, dir);
+		nr_pages = DIV_ROUND_UP(len + off, PAGE_SIZE);
+		for (i = 0; i < nr_pages; i++) {
+			if (dir == ITER_DEST)
 				set_page_dirty(iter.pages[i]);
 			put_page(iter.pages[i]);
 		}
-		data->len -= len;
-		done += iter.nr_pages;
+		done += len;
 	}
 
 	return done;
@@ -536,15 +525,14 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 	 * context is pretty fast, see ublk_pin_user_pages
 	 */
 	if (ublk_need_map_req(req)) {
-		struct ublk_map_data data = {
-			.rq	=	req,
-			.ubuf	=	io->addr,
-			.len	=	rq_bytes,
-		};
+		struct iov_iter iter;
+		struct iovec iov;
+		const int dir = ITER_DEST;
 
-		ublk_copy_user_pages(&data, true);
+		import_single_range(dir, u64_to_user_ptr(io->addr), rq_bytes,
+				&iov, &iter);
 
-		return rq_bytes - data.len;
+		return ublk_copy_user_pages(req, &iter, dir);
 	}
 	return rq_bytes;
 }
@@ -556,17 +544,15 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
 	if (ublk_need_unmap_req(req)) {
-		struct ublk_map_data data = {
-			.rq	=	req,
-			.ubuf	=	io->addr,
-			.len	=	io->res,
-		};
+		struct iov_iter iter;
+		struct iovec iov;
+		const int dir = ITER_SOURCE;
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
-		ublk_copy_user_pages(&data, false);
-
-		return io->res - data.len;
+		import_single_range(dir, u64_to_user_ptr(io->addr), io->res,
+				&iov, &iter);
+		return ublk_copy_user_pages(req, &iter, dir);
 	}
 	return rq_bytes;
 }
-- 
2.39.2

