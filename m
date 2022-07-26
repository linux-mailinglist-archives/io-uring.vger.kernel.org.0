Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F24581885
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 19:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiGZRib (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 13:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbiGZRi3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 13:38:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3062E9DA
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:27 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QFWBBH010634
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wyQlYXUSk9g4uiRzXyUdO+frsHVF03nRChlrghL7lbQ=;
 b=SUaqRJtfBCby4ucNynjP1m/xojgFMlMgeK1MkAqYQ3fw/74tt2Qod2L+6KfjaCjVDBV5
 D0zRJwMZEwvX1SvMGX7s9TXhAZxTw9k4pGgJi5hKVVUtXVZ6LRB/UNl9EOsOmBN8BNxf
 qQvaECuspcK2Mx9KK/W+cExQjvtTaaER/UA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hhxbwr9p8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:27 -0700
Received: from twshared30313.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 10:38:24 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 6A7F7698E4AE; Tue, 26 Jul 2022 10:38:15 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 3/5] block: add dma tag bio type
Date:   Tue, 26 Jul 2022 10:38:12 -0700
Message-ID: <20220726173814.2264573-4-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726173814.2264573-1-kbusch@fb.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: l25mreEg8PTHWbDEmHcR6_lck66kZMgQ
X-Proofpoint-ORIG-GUID: l25mreEg8PTHWbDEmHcR6_lck66kZMgQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_05,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped to the driver specific data structure. Repurpose
the bi_io_vec with the driver specific tag as they are mutually
exclusive, and provide all the setup and split helpers to support dma
tags.

In order to use this, a driver must implement the .dma_map() callback.
If the driver provides this callback, then it must be aware that any
given bio may be using a dma_tag instead of a bio_vec.

Note, this isn't working with blk_integrity.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio.c               | 25 ++++++++++++++++++++++++-
 block/blk-merge.c         | 18 ++++++++++++++++++
 include/linux/bio.h       | 21 ++++++++++++---------
 include/linux/blk-mq.h    | 12 ++++++++++++
 include/linux/blk_types.h |  6 +++++-
 5 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ce3bc3578ac4..472bdc4fd419 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -229,7 +229,8 @@ static void bio_free(struct bio *bio)
 	WARN_ON_ONCE(!bs);
=20
 	bio_uninit(bio);
-	bvec_free(&bs->bvec_pool, bio->bi_io_vec, bio->bi_max_vecs);
+	if (!bio_flagged(bio, BIO_DMA_TAGGED))
+		bvec_free(&bs->bvec_pool, bio->bi_io_vec, bio->bi_max_vecs);
 	mempool_free(p - bs->front_pad, &bs->bio_pool);
 }
=20
@@ -762,6 +763,8 @@ static int __bio_clone(struct bio *bio, struct bio *b=
io_src, gfp_t gfp)
 	bio_set_flag(bio, BIO_CLONED);
 	if (bio_flagged(bio_src, BIO_THROTTLED))
 		bio_set_flag(bio, BIO_THROTTLED);
+	if (bio_flagged(bio_src, BIO_DMA_TAGGED))
+		bio_set_flag(bio, BIO_DMA_TAGGED);
 	bio->bi_ioprio =3D bio_src->bi_ioprio;
 	bio->bi_iter =3D bio_src->bi_iter;
=20
@@ -1151,6 +1154,21 @@ void bio_iov_bvec_set(struct bio *bio, struct iov_=
iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
=20
+static void bio_iov_dma_tag_set(struct bio *bio, struct iov_iter *iter)
+{
+	size_t size =3D iov_iter_count(iter);
+
+	bio->bi_vcnt =3D iter->nr_segs;
+	bio->bi_dma_tag =3D iter->dma_tag;
+	bio->bi_iter.bi_bvec_done =3D iter->iov_offset;
+	bio->bi_iter.bi_size =3D size;
+	bio->bi_opf |=3D REQ_NOMERGE;
+	bio_set_flag(bio, BIO_NO_PAGE_REF);
+	bio_set_flag(bio, BIO_DMA_TAGGED);
+
+	iov_iter_advance(iter, bio->bi_iter.bi_size);
+}
+
 static int bio_iov_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int offset)
 {
@@ -1287,6 +1305,11 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
 iov_iter *iter)
 		return 0;
 	}
=20
+	if (iov_iter_is_dma_tag(iter)) {
+		bio_iov_dma_tag_set(bio, iter);
+		return 0;
+	}
+
 	do {
 		ret =3D __bio_iov_iter_get_pages(bio, iter);
 	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4c8a699754c9..240eae7666d4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -276,6 +276,24 @@ static struct bio *blk_bio_segment_split(struct requ=
est_queue *q,
 	const unsigned max_bytes =3D get_max_io_size(q, bio) << 9;
 	const unsigned max_segs =3D queue_max_segments(q);
=20
+	if (bio_flagged(bio, BIO_DMA_TAGGED)) {
+		int offset =3D offset_in_page(bio->bi_iter.bi_bvec_done);
+
+		nsegs =3D ALIGN(bio->bi_iter.bi_size + offset, PAGE_SIZE) >> PAGE_SHIF=
T;
+		if (bio->bi_iter.bi_size > max_bytes) {
+			bytes =3D max_bytes;
+			nsegs =3D (bytes + offset) >> PAGE_SHIFT;
+		} else if (nsegs > max_segs) {
+			nsegs =3D max_segs;
+			bytes =3D PAGE_SIZE * nsegs - offset;
+		} else {
+			*segs =3D nsegs;
+			return NULL;
+		}
+
+		goto split;
+	}
+
 	bio_for_each_bvec(bv, bio, iter) {
 		/*
 		 * If the queue doesn't support SG gaps and adding this
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ca22b06700a9..649348bc03c2 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -61,11 +61,17 @@ static inline bool bio_has_data(struct bio *bio)
 	return false;
 }
=20
+static inline bool bio_flagged(const struct bio *bio, unsigned int bit)
+{
+	return (bio->bi_flags & (1U << bit)) !=3D 0;
+}
+
 static inline bool bio_no_advance_iter(const struct bio *bio)
 {
 	return bio_op(bio) =3D=3D REQ_OP_DISCARD ||
 	       bio_op(bio) =3D=3D REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES;
+	       bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES ||
+	       bio_flagged(bio, BIO_DMA_TAGGED);
 }
=20
 static inline void *bio_data(struct bio *bio)
@@ -98,9 +104,11 @@ static inline void bio_advance_iter(const struct bio =
*bio,
 {
 	iter->bi_sector +=3D bytes >> 9;
=20
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -=3D bytes;
-	else
+		if (bio_flagged(bio, BIO_DMA_TAGGED))
+			iter->bi_bvec_done +=3D bytes;
+	} else
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
 }
@@ -225,11 +233,6 @@ static inline void bio_cnt_set(struct bio *bio, unsi=
gned int count)
 	atomic_set(&bio->__bi_cnt, count);
 }
=20
-static inline bool bio_flagged(struct bio *bio, unsigned int bit)
-{
-	return (bio->bi_flags & (1U << bit)) !=3D 0;
-}
-
 static inline void bio_set_flag(struct bio *bio, unsigned int bit)
 {
 	bio->bi_flags |=3D (1U << bit);
@@ -447,7 +450,7 @@ static inline void bio_wouldblock_error(struct bio *b=
io)
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_s=
egs)
 {
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iov_iter_is_dma_tag(iter))
 		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e10aabb36c2c..3eb045a9ba41 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1141,6 +1141,18 @@ static inline int blk_rq_map_sg(struct request_que=
ue *q, struct request *rq,
 }
 void blk_dump_rq_flags(struct request *, char *);
=20
+static inline void *blk_rq_dma_tag(struct request *rq)
+{
+	return rq->bio && bio_flagged(rq->bio, BIO_DMA_TAGGED) ?
+		rq->bio->bi_dma_tag : 0;
+}
+
+static inline size_t blk_rq_dma_offset(struct request *rq)
+{
+	return rq->bio && bio_flagged(rq->bio, BIO_DMA_TAGGED) ?
+		rq->bio->bi_iter.bi_bvec_done : 0;
+}
+
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int blk_rq_zone_no(struct request *rq)
 {
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1ef99790f6ed..ea6db439acbe 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -299,7 +299,10 @@ struct bio {
=20
 	atomic_t		__bi_cnt;	/* pin count */
=20
-	struct bio_vec		*bi_io_vec;	/* the actual vec list */
+	union {
+		struct bio_vec		*bi_io_vec;	/* the actual vec list */
+		void			*bi_dma_tag;    /* driver specific tag */
+	};
=20
 	struct bio_set		*bi_pool;
=20
@@ -334,6 +337,7 @@ enum {
 	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
+	BIO_DMA_TAGGED,		/* Using premmaped dma buffers */
 	BIO_FLAG_LAST
 };
=20
--=20
2.30.2

