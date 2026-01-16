Return-Path: <io-uring+bounces-11759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D84C0D2D77F
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 08:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0AF53019974
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 07:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C9F72BE647;
	Fri, 16 Jan 2026 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DA7KN5ZL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE0F28B40E
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 07:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768549622; cv=none; b=ig1XAkaLFFT/Quw5IVbmuAdMkdj3wOoxVDLEn3b/M61oyzVV44s475xRfzQmjO1ASAfPZTESU+BA5noVsCoeJHy6Prx3h/VYqtr3XN13vfP3uZBMAEraFUjtscpBkoyDSc/4Tu0djCmJUv+cVu6/TawZ2Rm1IHTpzHEB1oeOnoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768549622; c=relaxed/simple;
	bh=pPBy2PoZobUlCi1p3e2xtH/Ke4F/W324GcqWSXpRiyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8Vhy1Ii5458Pb3lZSIS2+z0sWx2qPKwo+4XXudE0UqJXRfJj0W8S67A8/gONHELgdezGUJR9DCfW3EY2W3Yn6y3+sLP/gA90661Mik4IGSl2a2qfL2yPEsTmwe3DUBybeaLjCoI3nMBD/PIvWn1hNcx3VwKG0SSMJz3vTDjkoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DA7KN5ZL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768549619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iEWt7RXX8F+EBiTwVbLOo/qLf4Yw+ZuQP2YpNrFIFlU=;
	b=DA7KN5ZLz564uckY8JAza6XIze4aQY6ypAa2I+6ZLZbhiWt/8y5G9xaPttUHCfpd3jAJJQ
	6u3ips1VFnJaXMVN+Q5tTe83au0mJgqeVRqIllaTg/fqyQEvrFZqwP9IAlUpG3In7gePra
	dGNfOiC1M+OBWPSAh/GVNm5GOSb08Ms=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-Z4VYSN07NOaGc6f-oEZPLg-1; Fri,
 16 Jan 2026 02:46:54 -0500
X-MC-Unique: Z4VYSN07NOaGc6f-oEZPLg-1
X-Mimecast-MFC-AGG-ID: Z4VYSN07NOaGc6f-oEZPLg_1768549613
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD9C71800357;
	Fri, 16 Jan 2026 07:46:53 +0000 (UTC)
Received: from localhost (unknown [10.72.116.198])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4FCD41801760;
	Fri, 16 Jan 2026 07:46:51 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/2] block: pass io_comp_batch to rq_end_io_fn callback
Date: Fri, 16 Jan 2026 15:46:37 +0800
Message-ID: <20260116074641.665422-2-ming.lei@redhat.com>
In-Reply-To: <20260116074641.665422-1-ming.lei@redhat.com>
References: <20260116074641.665422-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add a third parameter 'const struct io_comp_batch *' to the rq_end_io_fn
callback signature. This allows end_io handlers to access the completion
batch context when requests are completed via blk_mq_end_request_batch().

The io_comp_batch is passed from blk_mq_end_request_batch(), while NULL
is passed from __blk_mq_end_request() and blk_mq_put_rq_ref() which don't
have batch context.

This infrastructure change enables drivers to detect whether they're
being called from a batched completion path (like iopoll) and access
additional context stored in the io_comp_batch.

Update all rq_end_io_fn implementations:
- block/blk-mq.c: blk_end_sync_rq
- block/blk-flush.c: flush_end_io, mq_flush_data_end_io
- drivers/nvme/host/ioctl.c: nvme_uring_cmd_end_io
- drivers/nvme/host/core.c: nvme_keep_alive_end_io
- drivers/nvme/host/pci.c: abort_endio, nvme_del_queue_end, nvme_del_cq_end
- drivers/nvme/target/passthru.c: nvmet_passthru_req_done
- drivers/scsi/scsi_error.c: eh_lock_door_done
- drivers/scsi/sg.c: sg_rq_end_io
- drivers/scsi/st.c: st_scsi_execute_end
- drivers/target/target_core_pscsi.c: pscsi_req_done
- drivers/md/dm-rq.c: end_clone_request

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-flush.c                  |  6 ++++--
 block/blk-mq.c                     |  9 +++++----
 drivers/md/dm-rq.c                 |  3 ++-
 drivers/nvme/host/core.c           |  3 ++-
 drivers/nvme/host/ioctl.c          |  3 ++-
 drivers/nvme/host/pci.c            | 11 +++++++----
 drivers/nvme/target/passthru.c     |  3 ++-
 drivers/scsi/scsi_error.c          |  3 ++-
 drivers/scsi/sg.c                  |  6 ++++--
 drivers/scsi/st.c                  |  3 ++-
 drivers/target/target_core_pscsi.c |  6 ++++--
 include/linux/blk-mq.h             |  4 +++-
 12 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 43d6152897a4..403a46c86411 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -199,7 +199,8 @@ static void blk_flush_complete_seq(struct request *rq,
 }
 
 static enum rq_end_io_ret flush_end_io(struct request *flush_rq,
-				       blk_status_t error)
+				       blk_status_t error,
+				       const struct io_comp_batch *iob)
 {
 	struct request_queue *q = flush_rq->q;
 	struct list_head *running;
@@ -335,7 +336,8 @@ static void blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 }
 
 static enum rq_end_io_ret mq_flush_data_end_io(struct request *rq,
-					       blk_status_t error)
+					       blk_status_t error,
+					       const struct io_comp_batch *iob)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a29d8ac9d3e3..cf1daedbb39f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1156,7 +1156,7 @@ inline void __blk_mq_end_request(struct request *rq, blk_status_t error)
 
 	if (rq->end_io) {
 		rq_qos_done(rq->q, rq);
-		if (rq->end_io(rq, error) == RQ_END_IO_FREE)
+		if (rq->end_io(rq, error, NULL) == RQ_END_IO_FREE)
 			blk_mq_free_request(rq);
 	} else {
 		blk_mq_free_request(rq);
@@ -1211,7 +1211,7 @@ void blk_mq_end_request_batch(struct io_comp_batch *iob)
 		 * If end_io handler returns NONE, then it still has
 		 * ownership of the request.
 		 */
-		if (rq->end_io && rq->end_io(rq, 0) == RQ_END_IO_NONE)
+		if (rq->end_io && rq->end_io(rq, 0, iob) == RQ_END_IO_NONE)
 			continue;
 
 		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
@@ -1458,7 +1458,8 @@ struct blk_rq_wait {
 	blk_status_t ret;
 };
 
-static enum rq_end_io_ret blk_end_sync_rq(struct request *rq, blk_status_t ret)
+static enum rq_end_io_ret blk_end_sync_rq(struct request *rq, blk_status_t ret,
+					  const struct io_comp_batch *iob)
 {
 	struct blk_rq_wait *wait = rq->end_io_data;
 
@@ -1688,7 +1689,7 @@ static bool blk_mq_req_expired(struct request *rq, struct blk_expired_data *expi
 void blk_mq_put_rq_ref(struct request *rq)
 {
 	if (is_flush_rq(rq)) {
-		if (rq->end_io(rq, 0) == RQ_END_IO_FREE)
+		if (rq->end_io(rq, 0, NULL) == RQ_END_IO_FREE)
 			blk_mq_free_request(rq);
 	} else if (req_ref_put_and_test(rq)) {
 		__blk_mq_free_request(rq);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a6ca92049c10..e9a7563b4b2f 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -295,7 +295,8 @@ static void dm_kill_unmapped_request(struct request *rq, blk_status_t error)
 }
 
 static enum rq_end_io_ret end_clone_request(struct request *clone,
-					    blk_status_t error)
+					    blk_status_t error,
+					    const struct io_comp_batch *iob)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7bf228df6001..19b67cf5d550 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1333,7 +1333,8 @@ static void nvme_queue_keep_alive_work(struct nvme_ctrl *ctrl)
 }
 
 static enum rq_end_io_ret nvme_keep_alive_end_io(struct request *rq,
-						 blk_status_t status)
+						 blk_status_t status,
+						 const struct io_comp_batch *iob)
 {
 	struct nvme_ctrl *ctrl = rq->end_io_data;
 	unsigned long rtt = jiffies - (rq->deadline - rq->timeout);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a9c097dacad6..e45ac0ca174e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -410,7 +410,8 @@ static void nvme_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
-						blk_status_t err)
+						blk_status_t err,
+						const struct io_comp_batch *iob)
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b78c55a8f38c..08c8a941f49e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1618,7 +1618,8 @@ static int adapter_delete_sq(struct nvme_dev *dev, u16 sqid)
 	return adapter_delete_queue(dev, nvme_admin_delete_sq, sqid);
 }
 
-static enum rq_end_io_ret abort_endio(struct request *req, blk_status_t error)
+static enum rq_end_io_ret abort_endio(struct request *req, blk_status_t error,
+				      const struct io_comp_batch *iob)
 {
 	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 
@@ -2861,7 +2862,8 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 }
 
 static enum rq_end_io_ret nvme_del_queue_end(struct request *req,
-					     blk_status_t error)
+					     blk_status_t error,
+					     const struct io_comp_batch *iob)
 {
 	struct nvme_queue *nvmeq = req->end_io_data;
 
@@ -2871,14 +2873,15 @@ static enum rq_end_io_ret nvme_del_queue_end(struct request *req,
 }
 
 static enum rq_end_io_ret nvme_del_cq_end(struct request *req,
-					  blk_status_t error)
+					  blk_status_t error,
+					  const struct io_comp_batch *iob)
 {
 	struct nvme_queue *nvmeq = req->end_io_data;
 
 	if (error)
 		set_bit(NVMEQ_DELETE_ERROR, &nvmeq->flags);
 
-	return nvme_del_queue_end(req, error);
+	return nvme_del_queue_end(req, error, iob);
 }
 
 static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 67c423a8b052..5d541c2a46a5 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -247,7 +247,8 @@ static void nvmet_passthru_execute_cmd_work(struct work_struct *w)
 }
 
 static enum rq_end_io_ret nvmet_passthru_req_done(struct request *rq,
-						  blk_status_t blk_status)
+						  blk_status_t blk_status,
+						  const struct io_comp_batch *iob)
 {
 	struct nvmet_req *req = rq->end_io_data;
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f869108fd969..1e93390c5a82 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2085,7 +2085,8 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 }
 
 static enum rq_end_io_ret eh_lock_door_done(struct request *req,
-					    blk_status_t status)
+					    blk_status_t status,
+					    const struct io_comp_batch *iob)
 {
 	blk_mq_free_request(req);
 	return RQ_END_IO_NONE;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 57fba34832ad..1a521f9d821a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -177,7 +177,8 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 } Sg_device;
 
 /* tasklet or soft irq callback */
-static enum rq_end_io_ret sg_rq_end_io(struct request *rq, blk_status_t status);
+static enum rq_end_io_ret sg_rq_end_io(struct request *rq, blk_status_t status,
+				       const struct io_comp_batch *iob);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
 static int sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
@@ -1309,7 +1310,8 @@ sg_rq_end_io_usercontext(struct work_struct *work)
  * level when a command is completed (or has failed).
  */
 static enum rq_end_io_ret
-sg_rq_end_io(struct request *rq, blk_status_t status)
+sg_rq_end_io(struct request *rq, blk_status_t status,
+	     const struct io_comp_batch *iob)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
 	struct sg_request *srp = rq->end_io_data;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 168f25e4aaa3..8aeaa3b68c25 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -525,7 +525,8 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 }
 
 static enum rq_end_io_ret st_scsi_execute_end(struct request *req,
-					      blk_status_t status)
+					      blk_status_t status,
+					      const struct io_comp_batch *iob)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 	struct st_request *SRpnt = req->end_io_data;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index db4e09042469..823b2665f95b 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -39,7 +39,8 @@ static inline struct pscsi_dev_virt *PSCSI_DEV(struct se_device *dev)
 }
 
 static sense_reason_t pscsi_execute_cmd(struct se_cmd *cmd);
-static enum rq_end_io_ret pscsi_req_done(struct request *, blk_status_t);
+static enum rq_end_io_ret pscsi_req_done(struct request *, blk_status_t,
+					 const struct io_comp_batch *);
 
 /*	pscsi_attach_hba():
  *
@@ -1001,7 +1002,8 @@ static sector_t pscsi_get_blocks(struct se_device *dev)
 }
 
 static enum rq_end_io_ret pscsi_req_done(struct request *req,
-					 blk_status_t status)
+					 blk_status_t status,
+					 const struct io_comp_batch *iob)
 {
 	struct se_cmd *cmd = req->end_io_data;
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cae9e857aea4..18a2388ba581 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -13,6 +13,7 @@
 
 struct blk_mq_tags;
 struct blk_flush_queue;
+struct io_comp_batch;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_DEFAULT_RQ	128
@@ -22,7 +23,8 @@ enum rq_end_io_ret {
 	RQ_END_IO_FREE,
 };
 
-typedef enum rq_end_io_ret (rq_end_io_fn)(struct request *, blk_status_t);
+typedef enum rq_end_io_ret (rq_end_io_fn)(struct request *, blk_status_t,
+					  const struct io_comp_batch *);
 
 /*
  * request flags */
-- 
2.47.0


