Return-Path: <io-uring+bounces-11728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D0BD23546
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 10:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBBFE30AA6E4
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 09:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3D433D6FA;
	Thu, 15 Jan 2026 09:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFzdADqd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC932340A7D
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768467612; cv=none; b=HCMx5OwqZYKwnnrvpvraczUeBdTOcCQqERBa2Be/dz28MpkR/pmLQLAfcG2gY3t+2Fu0syOagPZIZXk9UK02A7+n/mOxPuPC9mjtK/0XahznHWU1sUW/6fVg0L8+UH2djOP8IJ1r+PvB05ZOIJ+4ejhq5EU7jfl4th5UUW/Cnbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768467612; c=relaxed/simple;
	bh=Zdt/qisqFDX109KN9gzVhNrGYcWOFfwh4UgesJCoelc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cHUw7H3W3Aezl2TYe6QJZ/SWtprV2NPECiOZGHlwKPa0Rqnrxk6o7Y/+FGpbyPnQTpaW3I1zUCQS1MOvclMj/b4YKqdLROB+pAFFNBYHfoj4+RZcPul0thqjkuK9CFPG/hOfGS4POw9uRdHYUxCxdGTpDf48lSxR9x/JZxORem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFzdADqd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768467610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h/ZZKlHZurqbfW1B7W/nlx38PVNHuIvXpjWS+Iexpd0=;
	b=QFzdADqdUYdKPECsL8DGK2ERBzfjqrLHPoLwAY17+w2Xxafzl947j1Ig3dzLxUu0JnLuG5
	9Sm2Ihq2MOtu9M/vvz2NoB6EG0XtCzNPhyx8IautPm9iMvR5kdrQs7fiDhLkZxHuEAY543
	7poG02rSCZIWuX4lntf+hIXg0YsoQlM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-Gfgta2fEMFivZQFd505cQA-1; Thu,
 15 Jan 2026 04:00:01 -0500
X-MC-Unique: Gfgta2fEMFivZQFd505cQA-1
X-Mimecast-MFC-AGG-ID: Gfgta2fEMFivZQFd505cQA_1768467600
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DFF2180045C;
	Thu, 15 Jan 2026 08:59:59 +0000 (UTC)
Received: from localhost (unknown [10.72.116.198])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 275B818004D8;
	Thu, 15 Jan 2026 08:59:57 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] nvme: optimize passthrough IOPOLL completion for local ring context
Date: Thu, 15 Jan 2026 16:59:52 +0800
Message-ID: <20260115085952.494077-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

When multiple io_uring rings poll on the same NVMe queue, one ring can
find completions belonging to another ring. The current code always
uses task_work to handle this, but this adds overhead for the common
single-ring case.

This patch passes the polling io_ring_ctx through the iopoll callback
chain via io_comp_batch and stores it in the request. In the NVMe
end_io handler, we compare the polling context with the request's
owning context. If they match (local), we complete inline. If they
differ (remote) or it's a non-IOPOLL path, we use task_work as before.

Changes:
- Add poll_ctx field to struct io_comp_batch
- Add poll_ctx to struct request's hash/ipi_list union
- Set iob.poll_ctx in io_do_iopoll() before calling iopoll callbacks
- Store poll_ctx in request in nvme_ns_chr_uring_cmd_iopoll()
- Check local vs remote context in nvme_uring_cmd_end_io()

~10% IOPS improvement is observed in the following benchmark:

fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B[0|1] -O0 -P1 -u1 -n1 /dev/ng0n1

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/ioctl.c | 36 ++++++++++++++++++++++++++++--------
 include/linux/blk-mq.h    |  4 +++-
 include/linux/blkdev.h    |  1 +
 io_uring/rw.c             |  7 +++++++
 4 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a9c097dacad6..0b85378f7fbb 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -425,14 +425,28 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	pdu->result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
-	 * IOPOLL could potentially complete this request directly, but
-	 * if multiple rings are polling on the same queue, then it's possible
-	 * for one ring to find completions for another ring. Punting the
-	 * completion via task_work will always direct it to the right
-	 * location, rather than potentially complete requests for ringA
-	 * under iopoll invocations from ringB.
+	 * For IOPOLL, check if this completion is happening in the context
+	 * of the same io_ring that owns the request (local context). If so,
+	 * we can complete inline without task_work overhead. Otherwise, we
+	 * must punt to task_work to ensure completion happens in the correct
+	 * ring's context.
 	 */
-	io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+	if (blk_rq_is_poll(req) && req->poll_ctx == io_uring_cmd_ctx_handle(ioucmd)) {
+		/*
+		 * Local context: the polling ring owns this request.
+		 * Complete inline for optimal performance.
+		 */
+		if (pdu->bio)
+			blk_rq_unmap_user(pdu->bio);
+		io_uring_cmd_done32(ioucmd, pdu->status, pdu->result, 0);
+	} else {
+		/*
+		 * Remote or non-IOPOLL context: either a different ring found
+		 * this completion, or this is IRQ/softirq completion. Use
+		 * task_work to direct completion to the correct location.
+		 */
+		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+	}
 	return RQ_END_IO_FREE;
 }
 
@@ -677,8 +691,14 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
 
-	if (req && blk_rq_is_poll(req))
+	if (req && blk_rq_is_poll(req)) {
+		/*
+		 * Store the polling context in the request so end_io can
+		 * detect if it's completing in the local ring's context.
+		 */
+		req->poll_ctx = iob ? iob->poll_ctx : NULL;
 		return blk_rq_poll(req, iob, poll_flags);
+	}
 	return 0;
 }
 #ifdef CONFIG_NVME_MULTIPATH
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cae9e857aea4..1975f5dd29f8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -175,11 +175,13 @@ struct request {
 	 * request reaches the dispatch list. The ipi_list is only used
 	 * to queue the request for softirq completion, which is long
 	 * after the request has been unhashed (and even removed from
-	 * the dispatch list).
+	 * the dispatch list). poll_ctx is used during iopoll to track
+	 * the io_ring_ctx that initiated the poll operation.
 	 */
 	union {
 		struct hlist_node hash;	/* merge hash */
 		struct llist_node ipi_list;
+		void *poll_ctx;		/* iopoll context */
 	};
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 72e34acd439c..4ed708912127 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1820,6 +1820,7 @@ void bdev_fput(struct file *bdev_file);
 
 struct io_comp_batch {
 	struct rq_list req_list;
+	void *poll_ctx;
 	bool need_ts;
 	void (*complete)(struct io_comp_batch *);
 };
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c33c533a267e..27a49ce3de46 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1321,6 +1321,13 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	struct io_kiocb *req, *tmp;
 	int nr_events = 0;
 
+	/*
+	 * Store the polling ctx so drivers can detect if they're completing
+	 * a request from the same ring that's polling (local) vs a different
+	 * ring (remote). This enables optimizations for local completions.
+	 */
+	iob.poll_ctx = ctx;
+
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
 	 * off our complete list.
-- 
2.47.1


