Return-Path: <io-uring+bounces-4655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E519C9C7862
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 17:12:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B131B344F1
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 15:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2080E15C128;
	Wed, 13 Nov 2024 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aBWUwBEq"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84E715C14B;
	Wed, 13 Nov 2024 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731511273; cv=none; b=CX8e1X5w/2PIlBEKfCPtA/rpqlwZZA47bzpgggqBF3QlIPToaEAmUYE23FYOEdkc7I7RM12OBJPAUy6d36UCi2WgP3FZ4NIGGa0wZNf0RybKalLp5N8Eww/S/5HXoEITkAUDLLx4pvkx5U7QZlUIOpl36BoqNMjDVjyswdrIbYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731511273; c=relaxed/simple;
	bh=XMmUlWjN0TLL6fcPi5a7olN02KBQ+xkgwNWYBquc5E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2IWpRQK18PG2rvPQt3FzXDpHee6Cg7IMPyGXkVaBb1fzpC1q2jzs9p+Cbzd0jB0QQJ7f4DfExX/wfxjQUB+az1wRu10J2yj+FAH30PSehB4SKFObHbXmz4Q/93xGmBNdo1qKI7/2JV9Uet9TeNuYJpmRxmUzEK7BQg0BIDy6i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aBWUwBEq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t1k1en1ffmPqOLYLWn7gwg/fiy5HhmQhs9d2dWbdlh8=; b=aBWUwBEq74rkudqhMFi4VyBoTk
	6AK6zfcyClsIJMtQNk7kK/WULcpwHJC/7nkghja0IE/speYOAMYtq/U9nLUrWsaID96RrjxKAPGK/
	qtnuM55IP3ZR+m43Ekd6gwP3ybS3DZfs0lpAoxZrmYffcHo/RiGvQYgNkCb8Es0tbq+2d6CFf7sE2
	qviRGmbvARd86FGjSmClUZK4uzUNF04/fPoVOnSI6ZoD+7f4iV8Kpzc94j2QGikTOwALB76n/ibdg
	4+mkgJ2bRCsmlk+NCjUOsSyuzVvT9sQuGBPw+3ypiGAuBhyrBpZIkRxnkvC7TDfB55r4IWrrdAq+B
	nyXJ5J/g==;
Received: from 2a02-8389-2341-5b80-9e61-c6cf-2f07-a796.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9e61:c6cf:2f07:a796] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tBFB6-00000007HPr-1ybM;
	Wed, 13 Nov 2024 15:21:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org
Subject: [PATCH 5/6] block: don't reorder requests in blk_add_rq_to_plug
Date: Wed, 13 Nov 2024 16:20:45 +0100
Message-ID: <20241113152050.157179-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241113152050.157179-1-hch@lst.de>
References: <20241113152050.157179-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add requests to the tail of the list instead of the front so that they
are queued up in submission order.

Remove the re-reordering in blk_mq_dispatch_plug_list, virtio_queue_rqs
and nvme_queue_rqs now that the list is ordered as expected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             | 4 ++--
 drivers/block/virtio_blk.c | 2 +-
 drivers/nvme/host/pci.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ff0b819e35fc..270cfd9fc6b0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1392,7 +1392,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 	 */
 	if (!plug->has_elevator && (rq->rq_flags & RQF_SCHED_TAGS))
 		plug->has_elevator = true;
-	rq_list_add_head(&plug->mq_list, rq);
+	rq_list_add_tail(&plug->mq_list, rq);
 	plug->rq_count++;
 }
 
@@ -2844,7 +2844,7 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 			rq_list_add_tail(&requeue_list, rq);
 			continue;
 		}
-		list_add(&rq->queuelist, &list);
+		list_add_tail(&rq->queuelist, &list);
 		depth++;
 	} while (!rq_list_empty(&plug->mq_list));
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a19f24c19140..c0cdba71f436 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -514,7 +514,7 @@ static void virtio_queue_rqs(struct rq_list *rqlist)
 		vq = this_vq;
 
 		if (virtblk_prep_rq_batch(req))
-			rq_list_add_head(&submit_list, req); /* reverse order */
+			rq_list_add_tail(&submit_list, req);
 		else
 			rq_list_add_tail(&requeue_list, req);
 	}
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c3a00a13946d..39ba1d0c287d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -943,7 +943,7 @@ static void nvme_queue_rqs(struct rq_list *rqlist)
 		nvmeq = req->mq_hctx->driver_data;
 
 		if (nvme_prep_rq_batch(nvmeq, req))
-			rq_list_add_head(&submit_list, req); /* reverse order */
+			rq_list_add_tail(&submit_list, req);
 		else
 			rq_list_add_tail(&requeue_list, req);
 	}
-- 
2.45.2


