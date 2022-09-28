Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB765EE357
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiI1Rkp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbiI1Rko (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:40:44 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140669C2CE;
        Wed, 28 Sep 2022 10:40:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8233B68BEB; Wed, 28 Sep 2022 19:40:39 +0200 (CEST)
Date:   Wed, 28 Sep 2022 19:40:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v10 6/7] block: extend functionality to map
 bvec iterator
Message-ID: <20220928174039.GD17153@lst.de>
References: <20220927173610.7794-1-joshi.k@samsung.com> <CGME20220927174639epcas5p22b46aed144d81d82b2a9b9de586808ac@epcas5p2.samsung.com> <20220927173610.7794-7-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927173610.7794-7-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 27, 2022 at 11:06:09PM +0530, Kanchan Joshi wrote:
> Extend blk_rq_map_user_iov so that it can handle bvec iterator.
> It  maps the pages from bvec iterator into a bio and place the bio into
> request.
> 
> This helper will be used by nvme for uring-passthrough path when IO is
> done using pre-mapped buffers.

Can we avoid duplicating some of the checks?  Something like the below
incremental patch.  Note that this now also allows the copy path for
all kinds of iov_iters, but as the copy from/to iter code is safe
and the sanity check was just or the map path that should be fine.
It's best split into a prep patch, though.

---
diff --git a/block/blk-map.c b/block/blk-map.c
index a1aa8dacb02bc..c51de30767403 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -549,26 +549,16 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 EXPORT_SYMBOL(blk_rq_append_bio);
 
 /* Prepare bio for passthrough IO given ITER_BVEC iter */
-static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
-				bool *copy)
+static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 {
 	struct request_queue *q = rq->q;
-	size_t nr_iter, nr_segs, i;
-	struct bio *bio = NULL;
-	struct bio_vec *bv, *bvecs, *bvprvp = NULL;
+	size_t nr_iter = iov_iter_count(iter);
+	size_t nr_segs = iter->nr_segs;
+	struct bio_vec *bvecs, *bvprvp = NULL;
 	struct queue_limits *lim = &q->limits;
 	unsigned int nsegs = 0, bytes = 0;
-	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
-
-	/* see if we need to copy pages due to any weird situation */
-	if (blk_queue_may_bounce(q))
-		goto out_copy;
-	else if (iov_iter_alignment(iter) & align)
-		goto out_copy;
-	/* virt-alignment gap is checked anyway down, so avoid extra loop here */
-
-	nr_iter = iov_iter_count(iter);
-	nr_segs = iter->nr_segs;
+	struct bio *bio;
+	size_t i;
 
 	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
 		return -EINVAL;
@@ -586,14 +576,15 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
 	/* loop to perform a bunch of sanity checks */
 	bvecs = (struct bio_vec *)iter->bvec;
 	for (i = 0; i < nr_segs; i++) {
-		bv = &bvecs[i];
+		struct bio_vec *bv = &bvecs[i];
+
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, fallback to copy.
 		 */
 		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
 			bio_map_put(bio);
-			goto out_copy;
+			return -EREMOTEIO;
 		}
 		/* check full condition */
 		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
@@ -611,9 +602,6 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter,
 put_bio:
 	bio_map_put(bio);
 	return -EINVAL;
-out_copy:
-	*copy = true;
-	return 0;
 }
 
 /**
@@ -635,33 +623,35 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct rq_map_data *map_data,
 			const struct iov_iter *iter, gfp_t gfp_mask)
 {
-	bool copy = false;
+	bool copy = false, map_bvec = false;
 	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
 	struct bio *bio = NULL;
 	struct iov_iter i;
 	int ret = -EINVAL;
 
-	if (iov_iter_is_bvec(iter)) {
-		ret = blk_rq_map_user_bvec(rq, iter, &copy);
-		if (ret != 0)
-			goto fail;
-		if (copy)
-			goto do_copy;
-		return ret;
-	}
-	if (!iter_is_iovec(iter))
-		goto fail;
-
 	if (map_data)
 		copy = true;
 	else if (blk_queue_may_bounce(q))
 		copy = true;
 	else if (iov_iter_alignment(iter) & align)
 		copy = true;
+	else if (iov_iter_is_bvec(iter))
+		map_bvec = true;
+	else if (!iter_is_iovec(iter))
+		copy = true;
 	else if (queue_virt_boundary(q))
 		copy = queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
 
-do_copy:
+	if (map_bvec) {
+		ret = blk_rq_map_user_bvec(rq, iter);
+		if (!ret)
+			return 0;
+		if (ret != -EREMOTEIO)
+			goto fail;
+		/* fall back to copying the data on limits mismatches */
+		copy = true;
+	}
+
 	i = *iter;
 	do {
 		if (copy)
