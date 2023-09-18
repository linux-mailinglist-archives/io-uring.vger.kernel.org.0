Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D137A3FF2
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbjIRENd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbjIRENJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:13:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DC5B6
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7H3F07jM47TzAxqTwg2x9XRWNY0CBRdRHslqoChDfbc=;
        b=iSzeCLWBHKcYjPdo50SkF0ke30telVICBjQCx2fn0gx6oZUZAjOyjoTVbjjrBA9tnUigwQ
        j0dX+YFo0HaR4GfHOQmzOLNvFNl58GMHMIuogkgN44mTXP01pXC7vLHjwNtBvd/yFJ/ncA
        Edy5IeNaDlgaGKxcLrmFI2apFgiWrDA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-692-Gxpd5jc0PA2L0sieXE1sbQ-1; Mon, 18 Sep 2023 00:12:02 -0400
X-MC-Unique: Gxpd5jc0PA2L0sieXE1sbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B49741875045;
        Mon, 18 Sep 2023 04:12:01 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A785B1006B6D;
        Mon, 18 Sep 2023 04:12:00 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 10/10] ublk: simplify aborting request
Date:   Mon, 18 Sep 2023 12:11:06 +0800
Message-Id: <20230918041106.2134250-11-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now ublk_abort_queue() is run exclusively with ublk_queue_rq() and the
ubq_daemon task, so simplify aborting request:

- set UBLK_IO_FLAG_ABORTED in ublk_abort_queue()

- abort request in ublk_queue_rq() if UBLK_IO_FLAG_ABORTED is observed,
and no need to check ubq_daemon any more

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 46 ++++++++++++----------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 90e0137ff784..0f54f63136fd 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1077,13 +1077,10 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 {
 	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
 
-	if (!(io->flags & UBLK_IO_FLAG_ABORTED)) {
-		io->flags |= UBLK_IO_FLAG_ABORTED;
-		if (ublk_queue_can_use_recovery_reissue(ubq))
-			blk_mq_requeue_request(req, false);
-		else
-			ublk_put_req_ref(ubq, req);
-	}
+	if (ublk_queue_can_use_recovery_reissue(ubq))
+		blk_mq_requeue_request(req, false);
+	else
+		ublk_put_req_ref(ubq, req);
 }
 
 static void ubq_complete_io_cmd(struct ublk_io *io, int res,
@@ -1221,30 +1218,12 @@ static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
 	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
-static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
+static inline void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 {
 	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
-	struct ublk_io *io;
-
-	if (!llist_add(&data->node, &ubq->io_cmds))
-		return;
 
-	io = &ubq->ios[rq->tag];
-	/*
-	 * If the check pass, we know that this is a re-issued request aborted
-	 * previously in exit notifier because the ubq_daemon(cmd's task) is
-	 * PF_EXITING. We cannot call io_uring_cmd_complete_in_task() anymore
-	 * because this ioucmd's io_uring context may be freed now if no inflight
-	 * ioucmd exists. Otherwise we may cause null-deref in ctx->fallback_work.
-	 *
-	 * Note: exit notifier sets UBLK_IO_FLAG_ABORTED and ends this request(releasing
-	 * the tag). Then the request is re-started(allocating the tag) and we are here.
-	 * Since releasing/allocating a tag implies smp_mb(), finding UBLK_IO_FLAG_ABORTED
-	 * guarantees that here is a re-issued request aborted previously.
-	 */
-	if (unlikely(io->flags & UBLK_IO_FLAG_ABORTED)) {
-		ublk_abort_io_cmds(ubq);
-	} else {
+	if (llist_add(&data->node, &ubq->io_cmds)) {
+		struct ublk_io *io = &ubq->ios[rq->tag];
 		struct io_uring_cmd *cmd = io->cmd;
 		struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 
@@ -1274,6 +1253,7 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 {
 	struct ublk_queue *ubq = hctx->driver_data;
 	struct request *rq = bd->rq;
+	struct ublk_io *io = &ubq->ios[rq->tag];
 	blk_status_t res;
 
 	/* fill iod to slot in io cmd buffer */
@@ -1293,13 +1273,12 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ublk_queue_can_use_recovery(ubq) && unlikely(ubq->force_abort))
 		return BLK_STS_IOERR;
 
-	blk_mq_start_request(bd->rq);
-
-	if (unlikely(ubq_daemon_is_dying(ubq))) {
+	if (unlikely(io->flags & UBLK_IO_FLAG_ABORTED)) {
 		__ublk_abort_rq(ubq, rq);
 		return BLK_STS_OK;
 	}
 
+	blk_mq_start_request(bd->rq);
 	ublk_queue_cmd(ubq, rq);
 
 	return BLK_STS_OK;
@@ -1429,6 +1408,9 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
 
+		if (!(io->flags & UBLK_IO_FLAG_ABORTED))
+			io->flags |= UBLK_IO_FLAG_ABORTED;
+
 		if (!(io->flags & UBLK_IO_FLAG_ACTIVE)) {
 			struct request *rq;
 
@@ -1437,7 +1419,7 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 			 * will do it
 			 */
 			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
-			if (rq)
+			if (rq && blk_mq_request_started(rq))
 				__ublk_fail_req(ubq, io, rq);
 		}
 	}
-- 
2.40.1

