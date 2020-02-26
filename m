Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0285116F9A9
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 09:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBZIiz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 03:38:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57326 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZIiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 03:38:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8crKT159185;
        Wed, 26 Feb 2020 08:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=2s1kfrTp5VgYkGSu4A6cB/Hn4JvN4if7I+45uwNilxA=;
 b=dX2rZ+w8qth3Y/IbzxMIy1AulnG63/NrNBvtArohESRIzbnGeBPE9N0zL/EtcFOGGWEr
 BoBLz4X4+yABy/DWa7CE//EbDBQG6xFcc0K077xNt9qAOqUlnweOeIO+McHQh26ygiH3
 jnWOIVrKy2tg/FbOwLa8Wt9E0zRVRJb4E+jup0AjggYgSyRSRJLqRVqXdz0xzFgSofA1
 t5ZQwlYdRtddZ9DXwAhjyYKHbSftYKDuo84sAIF+QDwct9hRNCVWL+7Up/fQU+y2yfq/
 l7fseoRXqY1HEfDOhQq0s2CkccFpzp2Fs546SnNtw0P+5GhvWO/+DQ5sCicZuxL53Iry ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct31wt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8c3uw005079;
        Wed, 26 Feb 2020 08:38:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ydj4gxdka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q8cqrh012380;
        Wed, 26 Feb 2020 08:38:52 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 00:38:51 -0800
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        io-uring@vger.kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 2/4] bio-integrity: introduce two funcs handle protect information
Date:   Wed, 26 Feb 2020 16:37:17 +0800
Message-Id: <20200226083719.4389-3-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200226083719.4389-1-bob.liu@oracle.com>
References: <20200226083719.4389-1-bob.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce two funcs handle protect information passthrough from
user space.

iter_slice_protect_info() will slice the last segment as protect
information.

bio_integrity_prep_from_iovec() attach the protect information to
a bio.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 block/bio-integrity.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h   | 14 ++++++++++
 2 files changed, 91 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 575df98..0b22c5d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 #include "blk.h"
 
 #define BIP_INLINE_VECS	4
@@ -305,6 +306,53 @@ bool bio_integrity_prep(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_prep);
 
+int bio_integrity_prep_from_iovec(struct bio *bio, struct iovec *pi_iov)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
+	struct bio_integrity_payload *bip;
+	struct page *user_pi_page;
+	int nr_vec_page = 0;
+	int ret = 0, interval = 0;
+
+	if (!pi_iov || !pi_iov->iov_base)
+		return 1;
+
+	nr_vec_page = (pi_iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (nr_vec_page > 1) {
+		printk("Now only support 1 page containing integrity "
+			"metadata, while requires %d pages.\n", nr_vec_page);
+		return 1;
+	}
+
+	interval = bio_integrity_intervals(bi, bio_sectors(bio));
+	if ((interval * bi->tuple_size) != pi_iov->iov_len)
+		return 1;
+
+	bip = bio_integrity_alloc(bio, GFP_NOIO, nr_vec_page);
+	if (IS_ERR(bip))
+		return PTR_ERR(bip);
+
+	bip->bip_iter.bi_size = pi_iov->iov_len;
+	bip->bio_iter = bio->bi_iter;
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
+
+	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
+		bip->bip_flags |= BIP_IP_CHECKSUM;
+
+	ret = get_user_pages_fast((unsigned long)(pi_iov->iov_base), nr_vec_page,
+			op_is_write(bio_op(bio)) ?  FOLL_WRITE : 0,
+			&user_pi_page);
+	if (unlikely(ret < 0))
+		return 1;
+
+	ret = bio_integrity_add_page(bio, user_pi_page, pi_iov->iov_len, 0);
+	if (unlikely(ret != pi_iov->iov_len))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_integrity_prep_from_iovec);
+
 /**
  * bio_integrity_verify_fn - Integrity I/O completion worker
  * @work:	Work struct stored in bio to be verified
@@ -378,6 +426,35 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 }
 
 /**
+ * iter_slice_protect_info
+ *
+ * Description: slice protection information from iter.
+ * The last iovec contains protection information pass from user space.
+ */
+int iter_slice_protect_info(struct iov_iter *iter, int nr_pages,
+		struct iovec **pi_iov)
+{
+	size_t len = 0;
+
+	/* TBD: now only support one bio. */
+	if (!iter_is_iovec(iter) || nr_pages >= BIO_MAX_PAGES - 1)
+		return 1;
+
+	/* Last iovec contains protection information. */
+	iter->nr_segs--;
+	*pi_iov = (struct iovec *)(iter->iov + iter->nr_segs);
+
+	len = (*pi_iov)->iov_len;
+	if (len > 0 && len < iter->count) {
+		iter->count -= len;
+		return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(iter_slice_protect_info);
+
+/**
  * bio_integrity_trim - Trim integrity vector
  * @bio:	bio whose integrity vector to update
  *
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3cdb84c..6172b13 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -749,6 +749,8 @@ static inline bool bioset_initialized(struct bio_set *bs)
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
+extern int bio_integrity_prep_from_iovec(struct bio *bio, struct iovec *pi_iov);
+extern int iter_slice_protect_info(struct iov_iter *iter, int nr_pages, struct iovec **pi_iov);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
@@ -778,6 +780,18 @@ static inline bool bio_integrity_prep(struct bio *bio)
 	return true;
 }
 
+static inline int bio_integrity_prep_from_iovec(struct bio *bio,
+		struct iovec *pi_iov)
+{
+	return 0;
+}
+
+static inline int iter_slice_protect_info(struct iov_iter *iter, int nr_pages,
+		struct iovec **pi_iov)
+{
+	return 0;
+}
+
 static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 				      gfp_t gfp_mask)
 {
-- 
2.9.5

