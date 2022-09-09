Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA67A5B378F
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 14:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiIIMWd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiIIMWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 08:22:05 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426F87330A;
        Fri,  9 Sep 2022 05:21:03 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B512356C7F;
        Fri,  9 Sep 2022 12:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662726060; x=1664540461; bh=AdKyWRZg91kbrQ/yUaQPzUpBK
        dGJIVcuTOHZzh5zGME=; b=rDhZpX8qlh8plbP3QVn2shxA3/GB5y6C1dxZNYshE
        8Qj8Z1Ddw0P6YJy82SRsGt2vIM3cuG+niQOhQ/DUwzEyWwFeuljIIxXTYO8YGAfQ
        PPcrWenLPYs4eQCn5m3En//BaghG0TigXssFqlln9Rg1p1zCSJKciWutDLY+dQxD
        y0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4ZUanrSN3O2C; Fri,  9 Sep 2022 15:21:00 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2301256C81;
        Fri,  9 Sep 2022 15:21:00 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 15:21:00 +0300
Received: from altair.lan (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 15:20:58 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v4 1/3] block: bio-integrity: add PI iovec to bio
Date:   Fri, 9 Sep 2022 15:20:38 +0300
Message-ID: <20220909122040.1098696-2-a.buev@yadro.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220909122040.1098696-1-a.buev@yadro.com>
References: <20220909122040.1098696-1-a.buev@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.119]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Added functions to attach user PI iovec pages to bio and release this
pages via bio_integrity_free.

Signed-off-by: Alexander V. Buev <a.buev@yadro.com>
---
 block/bio-integrity.c | 163 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h   |   8 +++
 2 files changed, 171 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 3f5685c00e36..bd6b74ae2c95 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -10,6 +10,7 @@
 #include <linux/mempool.h>
 #include <linux/export.h>
 #include <linux/bio.h>
+#include <linux/uio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "blk.h"
@@ -91,6 +92,18 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
 
+void bio_integrity_release_pages(struct bio *bio)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct bio_vec *bv = bip->bip_vec;
+	unsigned short i;
+
+	for (i = 0; i < bip->bip_vcnt; i++) {
+		put_page(bv->bv_page);
+		bv++;
+	}
+}
+
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
@@ -105,6 +118,10 @@ void bio_integrity_free(struct bio *bio)
 
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
 		kfree(bvec_virt(bip->bip_vec));
+	else {
+		if (bip->bip_flags & BIP_RELEASE_PAGES)
+			bio_integrity_release_pages(bio);
+	}
 
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity = NULL;
@@ -378,6 +395,152 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 
+static inline
+struct page **__bio_integrity_temp_pages(struct bio *bio, unsigned int nr_needed_page)
+{
+	unsigned int nr_avail_page = 0;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (bip->bip_max_vcnt > nr_needed_page) {
+		nr_avail_page = (bip->bip_max_vcnt - nr_needed_page) *
+			sizeof(struct bio_vec)/sizeof(struct page *);
+	}
+
+	if (nr_avail_page >= nr_needed_page)
+		return (struct page **) (bip->bip_vec + nr_needed_page);
+	else {
+		if (bio->bi_max_vecs - bio->bi_vcnt) {
+			nr_avail_page = (bio->bi_max_vecs - bio->bi_vcnt) *
+				sizeof(struct bio_vec)/sizeof(struct page *);
+			if (nr_avail_page >= nr_needed_page)
+				return (struct page **) (bio->bi_io_vec + bio->bi_vcnt);
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * bio_integrity_add_iovec - Add PI io vector
+ * @bio:	bio whose integrity vector to update
+ * @pi_iter:	iov_iter pointed to data added to @bio's integrity
+ *
+ * Description: Pins pages for *pi_iov and appends them to @bio's integrity.
+ */
+int bio_integrity_add_iovec(struct bio *bio, struct iov_iter *pi_iter)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	struct bio_integrity_payload *bip;
+	struct page **pi_page = 0, **bio_page;
+	unsigned int nr_vec_page;
+	int ret;
+	ssize_t size;
+	size_t offset, pg_num, page_count;
+
+	if (unlikely(!(bi && bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE))) {
+		pr_err("Device %d:%d is not integrity capable",
+			MAJOR(bio->bi_bdev->bd_dev), MINOR(bio->bi_bdev->bd_dev));
+		return -EINVAL;
+	}
+
+	nr_vec_page = iov_iter_npages(pi_iter,
+		queue_max_integrity_segments(bdev_get_queue(bio->bi_bdev)));
+	bip = bio_integrity(bio);
+	if (bip) {
+		if (nr_vec_page > (bip->bip_max_vcnt - bip->bip_vcnt))
+			return -ENOMEM;
+	} else {
+		bip = bio_integrity_alloc(bio, GFP_NOIO, nr_vec_page);
+		if (IS_ERR(bip))
+			return PTR_ERR(bip);
+	}
+
+	/* get space for page pointers array */
+	bio_page = __bio_integrity_temp_pages(bio, nr_vec_page);
+
+	if (likely(bio_page))
+		pi_page = bio_page;
+	else {
+		pi_page = kcalloc(nr_vec_page,
+					sizeof(struct pi_page *), GFP_NOIO);
+		if (!pi_page) {
+			ret = -ENOMEM;
+			goto error;
+		}
+	}
+
+	bip->bip_iter.bi_size = pi_iter->count;
+	bip->bio_iter = bio->bi_iter;
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
+
+	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
+		bip->bip_flags |= BIP_IP_CHECKSUM;
+
+	do {
+		size = iov_iter_get_pages2(pi_iter, pi_page, LONG_MAX,
+						nr_vec_page, &offset);
+		if (unlikely(size <= 0)) {
+			pr_err("Failed to pin integrity buffer for %d:%d\n",
+				MAJOR(bio->bi_bdev->bd_dev),
+				MINOR(bio->bi_bdev->bd_dev));
+			pr_err("Buffer size=%zu pages=%u err=%zi\n",
+				pi_iter->count, nr_vec_page, size);
+			ret = (size) ? size : -EFAULT;
+			goto error;
+		}
+
+		page_count = DIV_ROUND_UP(offset + size, PAGE_SIZE);
+
+		/* fill bio integrity biovecs the given pages */
+		for (pg_num = 0; pg_num < page_count; ++pg_num) {
+			size_t page_len;
+
+			page_len = min_t(size_t, PAGE_SIZE - offset, size);
+			ret = bio_integrity_add_page(bio, pi_page[pg_num],
+							page_len, offset);
+			if (unlikely(ret != page_len)) {
+				while ((1 + pg_num) > 0) {
+					put_page(pi_page[pg_num]);
+					pg_num--;
+				}
+				ret = -ENOMEM;
+				goto error;
+			}
+			size -= page_len;
+			offset = 0;
+			bip->bip_flags |= BIP_RELEASE_PAGES;
+		}
+
+		nr_vec_page -= page_count;
+
+	} while (pi_iter->count && nr_vec_page);
+
+
+	if (pi_iter->count) {
+		pr_err("Failed to pin whole integrity buffer for %d:%d\n",
+			MAJOR(bio->bi_bdev->bd_dev),
+			MINOR(bio->bi_bdev->bd_dev));
+		pr_err("Data of size=%zi not pined\n", pi_iter->count);
+		ret = -EFAULT;
+		goto error;
+	}
+
+	if (pi_page != bio_page)
+		kfree(pi_page);
+
+	return 0;
+
+error:
+	if (bio_integrity(bio))
+		bio_integrity_free(bio);
+
+	if (pi_page && pi_page != bio_page)
+		kfree(pi_page);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bio_integrity_add_iovec);
+
 /**
  * bio_integrity_trim - Trim integrity vector
  * @bio:	bio whose integrity vector to update
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ca22b06700a9..e7e328425c90 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -317,6 +317,7 @@ enum bip_flags {
 	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
+	BIP_RELEASE_PAGES	= 1 << 5, /* release pages after io completion */
 };
 
 /*
@@ -699,6 +700,7 @@ extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, un
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
+extern int bio_integrity_add_iovec(struct bio *bio, struct iov_iter *iter);
 extern void bio_integrity_trim(struct bio *);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 extern int bioset_integrity_create(struct bio_set *, int);
@@ -739,6 +741,12 @@ static inline void bio_integrity_advance(struct bio *bio,
 	return;
 }
 
+static inline int bio_integrity_add_iovec(struct bio *bio,
+					struct iov_iter *pi_iter)
+{
+	return 0;
+}
+
 static inline void bio_integrity_trim(struct bio *bio)
 {
 	return;
-- 
2.30.2

