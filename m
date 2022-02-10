Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3964B0E3F
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242073AbiBJNSA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 08:18:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242071AbiBJNR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 08:17:57 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC881F7;
        Thu, 10 Feb 2022 05:17:56 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E9CA04755B;
        Thu, 10 Feb 2022 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1644498547; x=1646312948; bh=9kSU/I5H2WBh0fkpjBAEh3bUyaugKITtigP
        hDtO9uV0=; b=Ttqqi1I2XyE72hhU9obSMU1w4EbvG+AKHVioG0b8NVDTekSFX52
        Kk11Hpe7PLsQ/rdudLqj9xI5qAsLYeKlxOMDFP7ewtxz05bxNGVWFewLJ5kDlrMo
        Vq4Dfi8X4XBMW6gZkXgORG5Lr1aUfc0+g+X1mucvqtdY3B3QFf/KW+HI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ONqGzW73ilEK; Thu, 10 Feb 2022 16:09:07 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6E34341846;
        Thu, 10 Feb 2022 16:09:07 +0300 (MSK)
Received: from localhost.localdomain (10.178.114.63) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 10 Feb 2022 16:09:04 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v2 1/3] block: bio-integrity: add PI iovec to bio
Date:   Thu, 10 Feb 2022 16:08:23 +0300
Message-ID: <20220210130825.657520-2-a.buev@yadro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210130825.657520-1-a.buev@yadro.com>
References: <20220210130825.657520-1-a.buev@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Added functions to attach user PI iovec pages to bio
and release this pages via bio_integrity_free.

Signed-off-by: Alexander V. Buev <a.buev@yadro.com>
---
 block/bio-integrity.c | 151 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h   |   8 +++
 2 files changed, 159 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 0827b19820c5..8e57aea9c9eb 100644
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
@@ -91,6 +92,19 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
 
+void bio_integrity_release_pages(struct bio *bio)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+	unsigned short i;
+
+	for (i = 0; i < bip->bip_vcnt; ++i) {
+		struct bio_vec *bv;
+
+		bv = bip->bip_vec + i;
+		put_page(bv->bv_page);
+	}
+}
+
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
@@ -105,6 +119,10 @@ void bio_integrity_free(struct bio *bio)
 
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
 		kfree(bvec_virt(bip->bip_vec));
+	else {
+		if (bip->bip_flags & BIP_RELEASE_PAGES)
+			bio_integrity_release_pages(bio);
+	}
 
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity = NULL;
@@ -377,6 +395,139 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 
+static inline
+struct page **__bio_integrity_temp_pages(struct bio *bio, unsigned int nr_needed_page)
+{
+	struct page **pages = 0;
+	unsigned int nr_avail_page;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (bip->bip_max_vcnt > nr_needed_page) {
+		nr_avail_page = (bip->bip_max_vcnt - nr_needed_page) *
+			sizeof(struct bio_vec)/sizeof(struct page *);
+	} else
+		nr_avail_page = 0;
+
+	if (nr_avail_page >= nr_needed_page)
+		pages = (struct page **) (bip->bip_vec + nr_needed_page);
+	else {
+		if (bio->bi_max_vecs - bio->bi_vcnt) {
+			nr_avail_page = (bio->bi_max_vecs - bio->bi_vcnt) *
+				sizeof(struct bio_vec)/sizeof(struct page *);
+			if (nr_avail_page >= nr_needed_page)
+				pages = (struct page **) (bio->bi_io_vec + bio->bi_vcnt);
+		}
+	}
+
+	return pages;
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
+	unsigned int nr_vec_page, intervals;
+	int ret;
+	ssize_t size;
+	size_t offset, len, pg_num, page_count;
+
+	if (unlikely(!bi && bi->tuple_size && bi->interval_exp)) {
+		pr_err("Device is not integrity capable");
+		return -EINVAL;
+	}
+
+	intervals = bio_integrity_intervals(bi, bio_sectors(bio));
+	if (unlikely(intervals * bi->tuple_size < pi_iter->count)) {
+		pr_err("Intervals number is wrong, intervals=%u, tuple_size=%u, pi_len=%zu",
+			intervals, bi->tuple_size, pi_iter->count);
+		return -EINVAL;
+	}
+
+	nr_vec_page = (pi_iter->count + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	/* data of size N pages can be pinned to N+1 page */
+	nr_vec_page += 1;
+
+	bip = bio_integrity_alloc(bio, GFP_NOIO, nr_vec_page);
+	if (IS_ERR(bip))
+		return PTR_ERR(bip);
+
+	/* get space for page pointers array */
+	bio_page = __bio_integrity_temp_pages(bio, nr_vec_page);
+
+	if (likely(bio_page))
+		pi_page = bio_page;
+	else {
+		pi_page = kcalloc(nr_vec_page, sizeof(struct pi_page *), GFP_NOIO);
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
+	size = iov_iter_get_pages(pi_iter, pi_page, LONG_MAX, nr_vec_page, &offset);
+	if (unlikely(size <= 0)) {
+		pr_err("Failed to pin PI buffer to page (%zi)", size);
+		ret = (size) ? size : -EFAULT;
+		goto error;
+	}
+
+	/* calc count of pined pages */
+	if (size > (PAGE_SIZE - offset))
+		page_count = DIV_ROUND_UP(size - (PAGE_SIZE - offset), PAGE_SIZE) + 1;
+	else
+		page_count = 1;
+
+	/* fill bio integrity biovecs the given pages */
+	len = pi_iter->count;
+	for (pg_num = 0; pg_num < page_count; ++pg_num) {
+		size_t page_len;
+
+		page_len = PAGE_SIZE - offset;
+		if (page_len > len)
+			page_len = len;
+		ret = bio_integrity_add_page(bio, pi_page[pg_num], page_len, offset);
+		if (unlikely(ret != page_len)) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		len -= page_len;
+		offset = 0;
+		bip->bip_flags |= BIP_RELEASE_PAGES;
+	}
+
+	iov_iter_advance(pi_iter, size);
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
index 117d7f248ac9..ce008eeeb160 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -317,6 +317,7 @@ enum bip_flags {
 	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
+	BIP_RELEASE_PAGES	= 1 << 5, /* release pages after io completion */
 };
 
 /*
@@ -707,6 +708,7 @@ extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, un
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
+extern int bio_integrity_add_iovec(struct bio *bio, struct iov_iter *iter);
 extern void bio_integrity_trim(struct bio *);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 extern int bioset_integrity_create(struct bio_set *, int);
@@ -747,6 +749,12 @@ static inline void bio_integrity_advance(struct bio *bio,
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
2.34.1

