Return-Path: <io-uring+bounces-10312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC54C26E9F
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 21:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C87CD4210A9
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 20:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E842A32B99D;
	Fri, 31 Oct 2025 20:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KWgihmy9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f228.google.com (mail-lj1-f228.google.com [209.85.208.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7FA328B5E
	for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 20:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761942883; cv=none; b=BpP4SudNciXBVZViJoyS7ExEyKfFJA+RdLxOjfr5bj56YIi5lnzFqp8O9bI3yMiqfDqbS1eXPlB9wahR2PIrdfPoiYkoTE6GeMJNEEEn4ER5iIfJ3K6j82/3K19nIdIQoRDWbv3vW6jxVlhAOsRXKwqiqXpvFVAJjGY+QBUzS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761942883; c=relaxed/simple;
	bh=72tFK8pZOMrZopPwBGdVPvV4blvZaCJQpmB0/pwMsu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtOt4DRaV4aaEKonPN6G9Vkg8tbC6ue1FNtm+5pf9309Opa+62YFSULkBneziKaaD+a9WK8x7v670rTEzH1rvuGxZkUclCVmj17kgKuRhYD6VE9SCekM6qJ7y6KXxSZbKNBnLM2GBpf2uKb3SAE47HyvyHyS96ewADf0pjotmY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KWgihmy9; arc=none smtp.client-ip=209.85.208.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lj1-f228.google.com with SMTP id 38308e7fff4ca-378ee1aea77so4347701fa.2
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 13:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761942879; x=1762547679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGUdMmY3TEOqD7WsU/6hYS9vIDX7GU4OMOjEdxKLrbA=;
        b=KWgihmy93YZRAaLdej9Xswa31KceqarQFU6eLRb/toJqCKAT9K10DtWDQ1XGgMbU8H
         WL3r3EVrYb//iydQ5uDf7Gfhwy6iTnr9/uM4gS00HYrHl3Zdd1c25KJJY4JDXDn7IlYZ
         lzoVv95NVLTHtRs7pBVP/upHPslonO+rdma83r6T0z3bgXoWFfk/HHb4RaphBjR9rXdY
         ttsGjaAlrlcdM50Oob/DL4eUdMce1je02A2FFHheA/chLXtzN9uB+YPmo4jzvJyDzJA2
         tPJ8O26D0MlfAA4QP5RmIgOK2xXJAH+O8eqaNfeX4tE5cyq5Uq2j+1ygxm1I4iwan4yM
         +ZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761942879; x=1762547679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGUdMmY3TEOqD7WsU/6hYS9vIDX7GU4OMOjEdxKLrbA=;
        b=K922+hflmqFfOcbaXK4AT7kQnxGvo4zHSECp37okTFevtoAXOgWkVRZVaVDKk1FfXu
         pZhO7KXCw0608yCplx2SfYDus6I5ebOcvpVs8ZOlxdoqCux9tA7TiaBXjgAG0DVf9Zml
         lovCo1emJaVqHqd2MA52SFIyzJao6tFd6bqwmMIE8X9X0AEc+gcl6uI196DCE+WrsAQX
         VGOTECNneNi2lIUwu6Y2emh4xGOIJvB4qAOPZ3337lElh4JInOsrUDB3/3yaqz4lZPw9
         kCH+GgYJg2lTdJrAaQSxZILixP4JVLC7uY6e+FLn31u2s4GVmmzd3IKpOLd0Efs0NtrS
         QEUA==
X-Gm-Message-State: AOJu0YzxY+ROqckQ8g+C91A6o7zDN5tHAuN5ZKDW/aglUkk7L/6+kTgQ
	LnjSY9btjBI9Fjfx8r+5/HOuJS0va9RxFaIEEP+PkNwRNcybrs9MSDwrcpDil9iClXI1EY8/lSk
	huez361qmUTknIT6rbavJhtoEdYDTePEJng4f
X-Gm-Gg: ASbGncszxuznhADk+I4OWAIKN3KMYefMncJN42bcoK8+SCvaR/OZh493VpKfTPnzeHj
	4wviYOh9fGdOD0UY4HZ5oF4mW9dPAS2VTg/shLWUC6VUcw51WgVn2OBmBv/vtMcRwrFybY4A22L
	XSP/moLSRkgdym6d2C7GOppfSe7ogBB7GeFCms66nwODY2/i1GZSsoB80KUMPUWg4aWQ5wYtoID
	cJt8QfcsdN3LFVsJwzeeDHdJVZXI7m868S3wwtMZ5fkFCTd6zQ0UMCdOijnawHjiVFmXtnVYJyi
	xyIoSl1JNMoveefzRCTyr73T0MeYxe6xiqMhYBPhUf42ENS7cTTzSkQiae4lVkneLXjQ+sTnAUt
	JFLZJKqGjEsawdgu0edYIGCapQBuphSc=
X-Google-Smtp-Source: AGHT+IE4ddUYa+Cofm9rutlWedWuknMo6qVls9Yu6Q/zwqmL5WpvM6QFyUl7E64z9L4ozGx1ISPYx081U18s
X-Received: by 2002:a05:6512:4025:b0:55f:433b:e766 with SMTP id 2adb3069b0e04-5941d563f10mr1047588e87.7.1761942878802;
        Fri, 31 Oct 2025 13:34:38 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-5941f5bbcc0sm277197e87.42.2025.10.31.13.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 13:34:38 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 208ED3407E5;
	Fri, 31 Oct 2025 14:34:37 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 1CF7DE41255; Fri, 31 Oct 2025 14:34:37 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 3/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
Date: Fri, 31 Oct 2025 14:34:30 -0600
Message-ID: <20251031203430.3886957-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251031203430.3886957-1-csander@purestorage.com>
References: <20251031203430.3886957-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring task work dispatch makes an indirect call to struct io_kiocb's
io_task_work.func field to allow running arbitrary task work functions.
In the uring_cmd case, this calls io_uring_cmd_work(), which immediately
makes another indirect call to struct io_uring_cmd's task_work_cb field.
Change the uring_cmd task work callbacks to functions whose signatures
match io_req_tw_func_t. Add a function io_uring_cmd_from_tw() to convert
from the task work's struct io_tw_req argument to struct io_uring_cmd *.
Define a constant IO_URING_CMD_TASK_WORK_ISSUE_FLAGS to avoid
manufacturing issue_flags in the uring_cmd task work callbacks. Now
uring_cmd task work dispatch makes a single indirect call to the
uring_cmd implementation's callback. This also allows removing the
task_work_cb field from struct io_uring_cmd, freeing up 8 bytes for
future storage.
Since fuse_uring_send_in_task() now has access to the io_tw_token_t,
check its cancel field directly instead of relying on the
IO_URING_F_TASK_DEAD issue flag.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 block/ioctl.c                  |  6 ++++--
 drivers/block/ublk_drv.c       | 22 +++++++++++-----------
 drivers/nvme/host/ioctl.c      |  7 ++++---
 fs/btrfs/ioctl.c               |  5 +++--
 fs/fuse/dev_uring.c            |  7 ++++---
 include/linux/io_uring/cmd.h   | 22 +++++++++++++---------
 include/linux/io_uring_types.h |  1 -
 io_uring/uring_cmd.c           | 18 ++----------------
 8 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d7489a56b33c..4ed17c5a4acc 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -767,18 +767,20 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 struct blk_iou_cmd {
 	int res;
 	bool nowait;
 };
 
-static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
+static void blk_cmd_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
 
 	if (bic->res == -EAGAIN && bic->nowait)
 		io_uring_cmd_issue_blocking(cmd);
 	else
-		io_uring_cmd_done(cmd, bic->res, issue_flags);
+		io_uring_cmd_done(cmd, bic->res,
+				  IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 }
 
 static void bio_cmd_bio_end_io(struct bio *bio)
 {
 	struct io_uring_cmd *cmd = bio->bi_private;
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0c74a41a6753..e0c601128efa 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1300,14 +1300,13 @@ static bool ublk_start_io(const struct ublk_queue *ubq, struct request *req,
 	}
 
 	return true;
 }
 
-static void ublk_dispatch_req(struct ublk_queue *ubq,
-			      struct request *req,
-			      unsigned int issue_flags)
+static void ublk_dispatch_req(struct ublk_queue *ubq, struct request *req)
 {
+	unsigned int issue_flags = IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;
 	int tag = req->tag;
 	struct ublk_io *io = &ubq->ios[tag];
 
 	pr_devel("%s: complete: qid %d tag %d io_flags %x addr %llx\n",
 			__func__, ubq->q_id, req->tag, io->flags,
@@ -1346,17 +1345,17 @@ static void ublk_dispatch_req(struct ublk_queue *ubq,
 
 	if (ublk_prep_auto_buf_reg(ubq, req, io, issue_flags))
 		ublk_complete_io_cmd(io, req, UBLK_IO_RES_OK, issue_flags);
 }
 
-static void ublk_cmd_tw_cb(struct io_uring_cmd *cmd,
-			   unsigned int issue_flags)
+static void ublk_cmd_tw_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
 
-	ublk_dispatch_req(ubq, pdu->req, issue_flags);
+	ublk_dispatch_req(ubq, pdu->req);
 }
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 {
 	struct io_uring_cmd *cmd = ubq->ios[rq->tag].cmd;
@@ -1364,21 +1363,21 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 
 	pdu->req = rq;
 	io_uring_cmd_complete_in_task(cmd, ublk_cmd_tw_cb);
 }
 
-static void ublk_cmd_list_tw_cb(struct io_uring_cmd *cmd,
-		unsigned int issue_flags)
+static void ublk_cmd_list_tw_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct request *rq = pdu->req_list;
 	struct request *next;
 
 	do {
 		next = rq->rq_next;
 		rq->rq_next = NULL;
-		ublk_dispatch_req(rq->mq_hctx->driver_data, rq, issue_flags);
+		ublk_dispatch_req(rq->mq_hctx->driver_data, rq);
 		rq = next;
 	} while (rq);
 }
 
 static void ublk_queue_cmd_list(struct ublk_io *io, struct rq_list *l)
@@ -2521,13 +2520,14 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 fail_put:
 	ublk_put_req_ref(io, req);
 	return NULL;
 }
 
-static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
-		unsigned int issue_flags)
+static void ublk_ch_uring_cmd_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	unsigned int issue_flags = IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;
+	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	int ret = ublk_ch_uring_cmd_local(cmd, issue_flags);
 
 	if (ret != -EIOCBQUEUED)
 		io_uring_cmd_done(cmd, ret, issue_flags);
 }
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c212fa952c0f..4fa8400a5627 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -396,18 +396,19 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 		struct io_uring_cmd *ioucmd)
 {
 	return io_uring_cmd_to_pdu(ioucmd, struct nvme_uring_cmd_pdu);
 }
 
-static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
-			       unsigned issue_flags)
+static void nvme_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
-	io_uring_cmd_done32(ioucmd, pdu->status, pdu->result, issue_flags);
+	io_uring_cmd_done32(ioucmd, pdu->status, pdu->result,
+			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 						blk_status_t err)
 {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8cb7d5a462ef..3171d9df0246 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4647,12 +4647,13 @@ struct btrfs_uring_priv {
 struct io_btrfs_cmd {
 	struct btrfs_uring_encoded_data *data;
 	struct btrfs_uring_priv *priv;
 };
 
-static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int issue_flags)
+static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
 	struct btrfs_uring_priv *priv = bc->priv;
 	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->iocb.ki_filp));
 	struct extent_io_tree *io_tree = &inode->io_tree;
 	pgoff_t index;
@@ -4693,11 +4694,11 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
 
 out:
 	btrfs_unlock_extent(io_tree, priv->start, priv->lockend, &priv->cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 
-	io_uring_cmd_done(cmd, ret, issue_flags);
+	io_uring_cmd_done(cmd, ret, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 	add_rchar(current, ret);
 
 	for (index = 0; index < priv->nr_pages; index++)
 		__free_page(priv->pages[index]);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index f6b12aebb8bb..f8c93dc45768 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1207,18 +1207,19 @@ static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
 /*
  * This prepares and sends the ring request in fuse-uring task context.
  * User buffers are not mapped yet - the application does not have permission
  * to write to it - this has to be executed in ring task context.
  */
-static void fuse_uring_send_in_task(struct io_uring_cmd *cmd,
-				    unsigned int issue_flags)
+static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	unsigned int issue_flags = IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;
+	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
 	struct fuse_ring_queue *queue = ent->queue;
 	int err;
 
-	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
+	if (!tw.cancel) {
 		err = fuse_uring_prepare_send(ent, ent->fuse_req);
 		if (err) {
 			fuse_uring_next_fuse_req(ent, queue, issue_flags);
 			return;
 		}
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 7509025b4071..375fd048c4cb 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -9,21 +9,17 @@
 /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
 #define IORING_URING_CMD_CANCELABLE	(1U << 30)
 /* io_uring_cmd is being issued again */
 #define IORING_URING_CMD_REISSUE	(1U << 31)
 
-typedef void (*io_uring_cmd_tw_t)(struct io_uring_cmd *cmd,
-				  unsigned issue_flags);
-
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
-	/* callback to defer completions to task context */
-	io_uring_cmd_tw_t task_work_cb;
 	u32		cmd_op;
 	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
+	u8		unused[8];
 };
 
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 {
 	return sqe->cmd;
@@ -58,11 +54,11 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
  */
 void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret, u64 res2,
 			 unsigned issue_flags, bool is_cqe32);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			    io_uring_cmd_tw_t task_work_cb,
+			    io_req_tw_func_t task_work_cb,
 			    unsigned flags);
 
 /*
  * Note: the caller should never hard code @issue_flags and only use the
  * mask provided by the core io_uring code.
@@ -107,11 +103,11 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			    io_uring_cmd_tw_t task_work_cb, unsigned flags)
+			    io_req_tw_func_t task_work_cb, unsigned flags)
 {
 }
 static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
@@ -130,19 +126,27 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 {
 	return true;
 }
 #endif
 
+static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
+{
+	return io_kiocb_to_cmd(tw_req.req, struct io_uring_cmd);
+}
+
+/* task_work executor checks the deferred list completion */
+#define IO_URING_CMD_TASK_WORK_ISSUE_FLAGS IO_URING_F_COMPLETE_DEFER
+
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
 static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			io_uring_cmd_tw_t task_work_cb)
+			io_req_tw_func_t task_work_cb)
 {
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			io_uring_cmd_tw_t task_work_cb)
+			io_req_tw_func_t task_work_cb)
 {
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
 }
 
 static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f064a438ce43..92780764d5fa 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,11 +37,10 @@ enum io_uring_cmd_flags {
 	IO_URING_F_IOPOLL		= (1 << 10),
 
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
-	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index c09b99e91c86..197474911f04 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -111,34 +111,20 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-static void io_uring_cmd_work(struct io_tw_req tw_req, io_tw_token_t tw)
-{
-	struct io_kiocb *req = tw_req.req;
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
-
-	if (unlikely(tw.cancel))
-		flags |= IO_URING_F_TASK_DEAD;
-
-	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, flags);
-}
-
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			io_uring_cmd_tw_t task_work_cb,
+			io_req_tw_func_t task_work_cb,
 			unsigned flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
 
-	ioucmd->task_work_cb = task_work_cb;
-	req->io_task_work.func = io_uring_cmd_work;
+	req->io_task_work.func = task_work_cb;
 	__io_req_task_work_add(req, flags);
 }
 EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
 
 static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
-- 
2.45.2


