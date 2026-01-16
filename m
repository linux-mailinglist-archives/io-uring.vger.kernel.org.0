Return-Path: <io-uring+bounces-11760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5D0D2D787
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 08:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 00F5F30242B8
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 07:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF962D0C79;
	Fri, 16 Jan 2026 07:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="atcBNeCH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D65129B233
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 07:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768549626; cv=none; b=lreqFymM2YSsqHKDQ2ZaORCo5A87BwFJY4RoJZgFz2PkOXQGCuaBFMb2GbUn8Kg8r3iXb+flabp67YN3j7+Th9EFI5jtxxHsD7pPOD4rB9b7hyl9Ag3PLMJzgXxxFm3X3Ti474JwLnYxy4udH5lIBxIcRvojdn/sJzYXYvfilo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768549626; c=relaxed/simple;
	bh=d/em8dEIhNFzLh3V4Mq+pSuqhcyzwUDjQ/OXAArZapc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/1Tr2HqSDRRKKCSPXwQ76NKq0sqFT3+WASULl3n2+aIvGSCnKexF7iDwxG7ABL46ttBo9RKpzPBdeM7+Xhf0jzf9qxTVYQ3qls/pN9e7ltRoHnx4RR3KWZxkS80aE3mg6J7Uv/zlP/vXU/wyPN9PN/GLxCVsabdIJwMphZY2ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=atcBNeCH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768549623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8X1E3UYPtNmvX23q+Lx4/Evy7h2o/ZPpablc61QY0k=;
	b=atcBNeCH3pFDd0leuTaf1vtHT1W+MSHNvpeI4793vd0Ry01J9MMaYraJ0sYwMuOHJ7PEYz
	h4HuYxcDNvP0hlXxH48eK66lLgG2hJk4vneBtMa0ZsQOht7d34hXFA2w3a1VrCmAwOE31+
	k2HlVYpAXbX8t1wugufJvnnc05G+99w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-_KNBCSLFNt6k-E4IvZMDtA-1; Fri,
 16 Jan 2026 02:46:59 -0500
X-MC-Unique: _KNBCSLFNt6k-E4IvZMDtA-1
X-Mimecast-MFC-AGG-ID: _KNBCSLFNt6k-E4IvZMDtA_1768549618
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89C9819560A7;
	Fri, 16 Jan 2026 07:46:57 +0000 (UTC)
Received: from localhost (unknown [10.72.116.198])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91B551800994;
	Fri, 16 Jan 2026 07:46:56 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/2] nvme/io_uring: optimize IOPOLL completions for local ring context
Date: Fri, 16 Jan 2026 15:46:38 +0800
Message-ID: <20260116074641.665422-3-ming.lei@redhat.com>
In-Reply-To: <20260116074641.665422-1-ming.lei@redhat.com>
References: <20260116074641.665422-1-ming.lei@redhat.com>
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

This patch passes the polling io_ring_ctx through io_comp_batch's new
poll_ctx field. In io_do_iopoll(), the polling ring's context is stored
in iob.poll_ctx before calling the iopoll callbacks.

In nvme_uring_cmd_end_io(), we now compare iob->poll_ctx with the
request's owning io_ring_ctx (via io_uring_cmd_ctx_handle()). If they
match (local context), we complete inline with io_uring_cmd_done32().
If they differ (remote context) or iob is NULL (non-iopoll path), we
use task_work as before.

This optimization eliminates task_work scheduling overhead for the
common case where a ring polls and finds its own completions.

~10% IOPS improvement is observed in the following benchmark:

fio/t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -O0 -P1 -u1 -n1 /dev/ng0n1

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/ioctl.c | 20 +++++++++++++-------
 include/linux/blkdev.h    |  1 +
 io_uring/rw.c             |  6 ++++++
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index e45ac0ca174e..fb62633ccbb0 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -426,14 +426,20 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
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
+	if (blk_rq_is_poll(req) && iob &&
+	    iob->poll_ctx == io_uring_cmd_ctx_handle(ioucmd)) {
+		if (pdu->bio)
+			blk_rq_unmap_user(pdu->bio);
+		io_uring_cmd_done32(ioucmd, pdu->status, pdu->result, 0);
+	} else {
+		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+	}
 	return RQ_END_IO_FREE;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 438c4946b6e5..251e0f538c4c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1822,6 +1822,7 @@ struct io_comp_batch {
 	struct rq_list req_list;
 	bool need_ts;
 	void (*complete)(struct io_comp_batch *);
+	void *poll_ctx;
 };
 
 static inline bool blk_atomic_write_start_sect_aligned(sector_t sector,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c33c533a267e..4c81a5a89089 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1321,6 +1321,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	struct io_kiocb *req, *tmp;
 	int nr_events = 0;
 
+	/*
+	 * Store the polling io_ring_ctx so drivers can detect if they're
+	 * completing a request in the same ring context that's polling.
+	 */
+	iob.poll_ctx = ctx;
+
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
 	 * off our complete list.
-- 
2.47.0


