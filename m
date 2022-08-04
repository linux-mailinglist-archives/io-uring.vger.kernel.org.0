Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA58589F66
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 18:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiHDQ2e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 12:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiHDQ2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 12:28:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8CD1EAEB;
        Thu,  4 Aug 2022 09:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE9D0B8253E;
        Thu,  4 Aug 2022 16:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF89C433C1;
        Thu,  4 Aug 2022 16:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659630509;
        bh=3nGBH8Czw/HQsUYzRn1iIFLwgs314cOIreWhXVJIAlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kx2SFLzg78PEzBH/Lp3KFQi1QZfq0ISs2BhjEPVV+vaHiC+GjktoC/p6097pF7prO
         cslc8MVXKbo9WR9S8r161Z4fGJgK0g5TQ8rqwP1OQPjHh78fNBxYUHpVFQP1wI2Boc
         5PzzfgHrxP1LhSjjvYsrvHgJF4oc8NniX30oKylEQcb2zbl25C9Zkt7UINcyIWWqw/
         7cyaq5h/TXAUgHPQZ/B44Cb0f8FLl93rlqj8FG39vfg6kzRBxbY1WOYXzN8FnSa6Jh
         6U7t2MRik//L6S3IRMgEgRGACoJK/yjAUacmTYG84I7VNzFtM6yfoKio57QiLuXGZS
         mL1Iper+xn4Mg==
Date:   Thu, 4 Aug 2022 10:28:25 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv2 0/7] dma mapping optimisations
Message-ID: <YuvzqbcXwGUMtKmm@kbusch-mbp.dhcp.thefacebook.com>
References: <20220802193633.289796-1-kbusch@fb.com>
 <5f8fc910-8fad-f71a-704b-8017d364d0ed@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f8fc910-8fad-f71a-704b-8017d364d0ed@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 03, 2022 at 02:52:11PM -0600, Jens Axboe wrote:
> I ran this on my test box to see how we'd do. First the bad news:
> smaller block size IO seems slower. I ran with QD=8 and used 24 drives,
> and using t/io_uring (with registered buffers, polled, etc) and a 512b
> block size I get:
> 
> IOPS=44.36M, BW=21.66GiB/s, IOS/call=1/1
> IOPS=44.64M, BW=21.80GiB/s, IOS/call=2/2
> IOPS=44.69M, BW=21.82GiB/s, IOS/call=1/1
> IOPS=44.55M, BW=21.75GiB/s, IOS/call=2/2
> IOPS=44.93M, BW=21.94GiB/s, IOS/call=1/1
> IOPS=44.79M, BW=21.87GiB/s, IOS/call=1/2
> 
> and adding -D1 I get:
> 
> IOPS=43.74M, BW=21.36GiB/s, IOS/call=1/1
> IOPS=44.04M, BW=21.50GiB/s, IOS/call=1/1
> IOPS=43.63M, BW=21.30GiB/s, IOS/call=2/2
> IOPS=43.67M, BW=21.32GiB/s, IOS/call=1/1
> IOPS=43.57M, BW=21.28GiB/s, IOS/call=1/2
> IOPS=43.53M, BW=21.25GiB/s, IOS/call=2/1
> 
> which does regress that workload.

Bummer, I would expect -D1 to be no worse. My test isn't nearly as consistent
as yours, so I'm having some trouble measuring. I'm only coming with a few
micro-optimizations that might help. A diff is below on top of this series. I
also created a branch with everything folded in here:

 git://git.kernel.org/pub/scm/linux/kernel/git/kbusch/linux.git io_uring/dma-register
 https://git.kernel.org/pub/scm/linux/kernel/git/kbusch/linux.git/log/?h=io_uring/dma-register

-- >8 --
diff --git a/block/bio.c b/block/bio.c
index 3b7accae8996..c1e97dff5e40 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1154,7 +1154,7 @@ void bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
 
-static void bio_iov_dma_tag_set(struct bio *bio, struct iov_iter *iter)
+void bio_iov_dma_tag_set(struct bio *bio, struct iov_iter *iter)
 {
 	size_t size = iov_iter_count(iter);
 
@@ -1165,8 +1165,6 @@ static void bio_iov_dma_tag_set(struct bio *bio, struct iov_iter *iter)
 	bio->bi_opf |= REQ_NOMERGE;
 	bio_set_flag(bio, BIO_NO_PAGE_REF);
 	bio_set_flag(bio, BIO_DMA_TAGGED);
-
-	iov_iter_advance(iter, bio->bi_iter.bi_size);
 }
 
 static int bio_iov_add_page(struct bio *bio, struct page *page,
@@ -1307,6 +1305,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	if (iov_iter_is_dma_tag(iter)) {
 		bio_iov_dma_tag_set(bio, iter);
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
 
diff --git a/block/fops.c b/block/fops.c
index db2d1e848f4b..1b3649c7eb17 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -325,7 +325,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		 * bio_iov_iter_get_pages() and set the bvec directly.
 		 */
 		bio_iov_bvec_set(bio, iter);
-	} else {
+	} else if (iov_iter_is_dma_tag(iter)) {
+		bio_iov_dma_tag_set(bio, iter);
+	}else {
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
 			bio_put(bio);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index dbf73ab0877e..511cae2b7ce9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -113,7 +113,8 @@ static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode);
 struct nvme_dma_mapping {
 	int nr_pages;
 	u16 offset;
-	u8  rsvd[2];
+	bool needs_sync;
+	u8  rsvd;
 	dma_addr_t prp_dma_addr;
 	__le64 *prps;
 };
@@ -556,16 +557,9 @@ static void nvme_sync_dma(struct nvme_dev *dev, struct request *req,
 			  struct nvme_dma_mapping *mapping)
 {
 	int offset, i, j, length, nprps;
-	bool needs_sync;
 
 	offset = blk_rq_dma_offset(req) + mapping->offset;
 	i = offset >> NVME_CTRL_PAGE_SHIFT;
-	needs_sync = rq_data_dir(req) == READ &&
-		 dma_need_sync(dev->dev, le64_to_cpu(mapping->prps[i]));
-
-	if (!needs_sync)
-		return;
-
 	offset = offset & (NVME_CTRL_PAGE_SIZE - 1);
 	length = blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
 	nprps = DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
@@ -643,7 +637,8 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 	if (mapping) {
-		nvme_sync_dma(dev, req, mapping);
+		if (mapping->needs_sync)
+			nvme_sync_dma(dev, req, mapping);
 		if (iod->npages >= 0)
 			nvme_free_prp_chain(dev, req, iod);
 		return;
@@ -894,16 +889,13 @@ static blk_status_t nvme_premapped(struct nvme_dev *dev, struct request *req,
 	int i, offset, j, length, nprps, nprps_left;
 	struct dma_pool *pool;
 	__le64 *prp_list;
-	bool needs_sync;
 	void **list;
 
 	offset = blk_rq_dma_offset(req) + mapping->offset;
 	i = offset >> NVME_CTRL_PAGE_SHIFT;
 	offset = offset & (NVME_CTRL_PAGE_SIZE - 1);
-	needs_sync = rq_data_dir(req) == WRITE &&
-		 dma_need_sync(dev->dev, le64_to_cpu(mapping->prps[i]));
 
-	if (needs_sync) {
+	if (mapping->needs_sync) {
 		dma_sync_single_for_device(dev->dev,
 			le64_to_cpu(mapping->prps[i]),
 			NVME_CTRL_PAGE_SIZE - offset, DMA_TO_DEVICE);
@@ -916,7 +908,7 @@ static blk_status_t nvme_premapped(struct nvme_dev *dev, struct request *req,
 		return BLK_STS_OK;
 
 	if (length <= NVME_CTRL_PAGE_SIZE) {
-		if (needs_sync)
+		if (mapping->needs_sync)
 			dma_sync_single_for_device(dev->dev,
 				le64_to_cpu(mapping->prps[i]),
 				NVME_CTRL_PAGE_SIZE, DMA_TO_DEVICE);
@@ -983,7 +975,7 @@ static blk_status_t nvme_premapped(struct nvme_dev *dev, struct request *req,
 	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
 
 sync:
-	if (!needs_sync)
+	if (!mapping->needs_sync)
 		return BLK_STS_OK;
 
 	i = offset >> NVME_CTRL_PAGE_SHIFT;
@@ -1931,6 +1923,7 @@ static void *nvme_pci_dma_map(struct request_queue *q,
 	if (!mapping->prps)
 		goto free_mapping;
 
+	mapping->needs_sync = false;
 	for (i = 0, k = 0; i < nr_vecs; i++) {
 		struct bio_vec *bv = bvec + i;
 		dma_addr_t dma_addr;
@@ -1959,6 +1952,9 @@ static void *nvme_pci_dma_map(struct request_queue *q,
 		if (i == 0)
 			dma_addr -= mapping->offset;
 
+		if (dma_need_sync(dev->dev, dma_addr))
+			mapping->needs_sync = true;
+
 		for (j = 0; j < ppv; j++)
 			mapping->prps[k++] = cpu_to_le64(dma_addr +
 						j * NVME_CTRL_PAGE_SIZE);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 649348bc03c2..b5277ec189e0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -474,6 +474,7 @@ void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 void bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter);
+void bio_iov_dma_tag_set(struct bio *bio, struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index d370b45d7f1b..ebdf81473526 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1070,6 +1070,9 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		iov_iter_iovec_advance(i, size);
 	} else if (iov_iter_is_bvec(i)) {
 		iov_iter_bvec_advance(i, size);
+	} else if (iov_iter_is_dma_tag(i)) {
+		i->iov_offset += size;
+		i->count -= size;
 	} else if (iov_iter_is_pipe(i)) {
 		pipe_advance(i, size);
 	} else if (unlikely(iov_iter_is_xarray(i))) {
@@ -1077,9 +1080,6 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		i->count -= size;
 	} else if (iov_iter_is_discard(i)) {
 		i->count -= size;
-	} else if (iov_iter_is_dma_tag(i)) {
-		i->iov_offset += size;
-		i->count -= size;
 	}
 }
 EXPORT_SYMBOL(iov_iter_advance);
@@ -1353,6 +1353,9 @@ bool iov_iter_is_aligned(const struct iov_iter *i, unsigned addr_mask,
 	if (iov_iter_is_bvec(i))
 		return iov_iter_aligned_bvec(i, addr_mask, len_mask);
 
+	if (iov_iter_is_dma_tag(i))
+		return !(i->iov_offset & addr_mask);
+
 	if (iov_iter_is_pipe(i)) {
 		unsigned int p_mask = i->pipe->ring_size - 1;
 		size_t size = i->count;
-- 8< --
