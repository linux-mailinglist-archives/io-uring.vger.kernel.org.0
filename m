Return-Path: <io-uring+bounces-4774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 852B29D1460
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 16:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C677282E7C
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 15:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1831AA1C5;
	Mon, 18 Nov 2024 15:24:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977C019E998;
	Mon, 18 Nov 2024 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731943444; cv=none; b=P0qbHzL6Q9LVDXEQRnZRH2MV3xQeT71rbFC5W5cspOh70HRKhyHa7IVBmkIfTP+hWkSB8qB1pJvWezuC3GBrp8c2XawuyJ8MSYR47Afb2Z8StYgoTEkHllIFEoUqWHWUVcatiwuSWydcffJzhQ9ZpA/kpAzGNJwa3OiPGyYRYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731943444; c=relaxed/simple;
	bh=p3iN8DZuOevOGnMI17kwOFArRNlkmk9v/MRI3sg5Upo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7AukAQaIqTAUiSDjRFW/5fXFW8pmjSuTOKXNEIn3HDB4NXKWcBtRdh7U9OygWCLKYR2/HYoduxI5ZxlLzTtaBIA3duKWU1UHhnfEhPV9zNWyPLbYl9E8Z104fiPSsB9SDD/FkknuShTk7AIPRwwhsyjee/IRW+tKDae1Lfkqtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5CDE968D31; Mon, 18 Nov 2024 16:23:57 +0100 (CET)
Date: Mon, 18 Nov 2024 16:23:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: don't reorder requests passed to ->queue_rqs
Message-ID: <20241118152357.GA7513@lst.de>
References: <20241113152050.157179-1-hch@lst.de> <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com> <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk> <20241114041603.GA8971@lst.de> <0236980b-b892-460c-802e-a87a79b7ac0b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0236980b-b892-460c-802e-a87a79b7ac0b@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 08:14:11AM -0700, Jens Axboe wrote:
> > that goes back to the scheme currently used upstream in nvme and virtio
> > that just cuts of the list at a hctx change instead of moving the
> > requests one by one now that the block layer doesn't mess up the order.
> 
> I think that would be useful. I can test.

I played with this a bit, and I really hate keeping prev for the
unlinking.  So this version uses a slightly different approach:

 ‐ a first pass that just rolls through all requests and does the prep
   checks.  If they fail that is recorded in a new field in the iod
   (could also become a request flag)
 - the submission loop inside sq_lock becomes a bit more complex
   as it handles breaking out of the inner loop for hctx changes,
   and to move the previously failed commands to the resubmit list.

But this completely gets rid of the prev tracking and all list
manipulation except for the final list_pop.

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5f2e3ad2cc52..3470dae73a8c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -233,6 +233,7 @@ struct nvme_iod {
 	struct nvme_request req;
 	struct nvme_command cmd;
 	bool aborted;
+	bool batch_failed;
 	s8 nr_allocations;	/* PRP list pool allocations. 0 means small
 				   pool in use */
 	unsigned int dma_len;	/* length of single DMA segment mapping */
@@ -843,6 +844,7 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	blk_status_t ret;
 
 	iod->aborted = false;
+	iod->batch_failed = false;
 	iod->nr_allocations = -1;
 	iod->sgt.nents = 0;
 
@@ -904,54 +906,51 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
-static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct rq_list *rqlist)
+static void nvme_submit_cmds(struct rq_list *rqlist,
+		struct rq_list *requeue_list)
 {
-	struct request *req;
+	struct request *req = rq_list_peek(rqlist);
+	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 
 	spin_lock(&nvmeq->sq_lock);
 	while ((req = rq_list_pop(rqlist))) {
 		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-		nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+		if (iod->batch_failed)
+			rq_list_add_tail(requeue_list, req);
+		else
+			nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+
+		if (!req->rq_next || req->mq_hctx != req->rq_next->mq_hctx)
+			break;
 	}
 	nvme_write_sq_db(nvmeq, true);
 	spin_unlock(&nvmeq->sq_lock);
 }
 
-static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
-{
-	/*
-	 * We should not need to do this, but we're still using this to
-	 * ensure we can drain requests on a dying queue.
-	 */
-	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
-		return false;
-	if (unlikely(!nvme_check_ready(&nvmeq->dev->ctrl, req, true)))
-		return false;
-
-	return nvme_prep_rq(nvmeq->dev, req) == BLK_STS_OK;
-}
-
 static void nvme_queue_rqs(struct rq_list *rqlist)
 {
-	struct rq_list submit_list = { };
 	struct rq_list requeue_list = { };
-	struct nvme_queue *nvmeq = NULL;
 	struct request *req;
 
-	while ((req = rq_list_pop(rqlist))) {
-		if (nvmeq && nvmeq != req->mq_hctx->driver_data)
-			nvme_submit_cmds(nvmeq, &submit_list);
-		nvmeq = req->mq_hctx->driver_data;
+	rq_list_for_each(rqlist, req) {
+		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-		if (nvme_prep_rq_batch(nvmeq, req))
-			rq_list_add_tail(&submit_list, req);
-		else
-			rq_list_add_tail(&requeue_list, req);
+		/*
+		 * We should not need to do this, but we're still using this to
+		 * ensure we can drain requests on a dying queue.
+		 */
+		if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)) ||
+		    unlikely(!nvme_check_ready(&nvmeq->dev->ctrl, req, true)) ||
+		    unlikely(nvme_prep_rq(nvmeq->dev, req) != BLK_STS_OK))
+			iod->batch_failed = true;
 	}
 
-	if (nvmeq)
-		nvme_submit_cmds(nvmeq, &submit_list);
+	do {
+		nvme_submit_cmds(rqlist, &requeue_list);
+	} while (!rq_list_empty(rqlist));
+
 	*rqlist = requeue_list;
 }
 

