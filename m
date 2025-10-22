Return-Path: <io-uring+bounces-10150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E29B0BFE80A
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 01:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2BF3A850C
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 23:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689D730B502;
	Wed, 22 Oct 2025 23:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FKG+sKvH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f97.google.com (mail-lf1-f97.google.com [209.85.167.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729F3308F27
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 23:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761174828; cv=none; b=GZUcTVUrGT6XNjbaCN5kLnqKiTou1lisp/1rEnqgzvS5EyM2EiMye5wCr6AkGfIRl8bWW/iI/mXKlGMCPogCJEV+8loq1T9nqzO0D/+pBQDMmuh0OhncKTsE/CPR7SxPz8rphd3GCG9nZvHW8OtePc9pfnETfalLHKjY2G9KIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761174828; c=relaxed/simple;
	bh=Npt8CIamNyEuH3sVd1A1KqiVJoYsn6LwQFxIQ9NJE+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa9zo3KUZCeysk6oFc6Fsjw4O5oZ73tkSth+Vcv6q9oklVx7A5Gb30jgCmKCyj54Kw1sUMJUMPVOOxM3YxJbPPAlR+UFeXwgAdAKBXor9GidFyvZRp3XrIxEmuwtJxSHiQnZW6pNckx1mPuc7wprPoCQBNQDG8U53BSb6Uti44E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FKG+sKvH; arc=none smtp.client-ip=209.85.167.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f97.google.com with SMTP id 2adb3069b0e04-592f40b1a40so27881e87.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761174823; x=1761779623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NE/3amh4M7tNgNnZVfHQb2pFOExzJd/f5eLPCJymwKM=;
        b=FKG+sKvHTvGcglwczO8wfj2/qFsvKpmkan7Z2dvNuGaNMH4b6mohpLKvaBPjCLdnVj
         m5d2P3GEmi82guV2rsVe5LJn6XJLAEWJwS3tj4mBbwI+8u0emVR6vXHVpjkKp2WHmFmi
         HeFKKgIWd+aYDGxqxRp+ciZZFg63dHTIUFxlmIYZe/fAJbVEUX0F6/spr8ZBztFsqN7R
         iLYjL7LzOd9bJ//8mJZAtTMEcuM5ir/jOAFbON4z5eTfVfFJDO8qqisIFxJmIH7KXY4x
         145zSd3Bjk+qmQj9S7CMJHIdPMjqqynkemZkaGRIw6kuBCws2IulbKUN7X+GN3TVbdi/
         sncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761174823; x=1761779623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NE/3amh4M7tNgNnZVfHQb2pFOExzJd/f5eLPCJymwKM=;
        b=U/Fffe1rJJUrMd8GK3H6q1Cb8J7cAb3pqFDgsF9wneRs2oKKXoeTjdkySLSZPhaEpg
         yTtsGe6jb5nufj4vQWK0cbu8PHq+lGyMwbAON0RaSJ+siavNKc2+CV32r0yS/SwAbPfA
         v88IH2QJm5vPbTanUGbywDLx7hIb42Z0spwHUQ0v80K/ho9g04ntkbk9wjNAWsKAngBW
         Ijt9y3a84z5WcRiZ5x5vGoch10I9nn8Cysly83oTV2/H+nhORo8Pe1shEp1P5YRh9fWl
         hoElWSCdsSdih207ELfEqksOtlTWc1O+XwLoxsQtDVXbyk+YBzSn40A3X+BifvgeCo3Z
         u5zg==
X-Gm-Message-State: AOJu0YwA5B7As1KB77SfzZkdUoZxeUL8cvvkh3cv/w2OvoJWCOb1phQz
	JbmsQxvBqgBxMUdmWqfG6lLR20jj97V9LrvLGCwGywf+CSsSXJRAd2mz3iwDZZ7c2IgauxraUKp
	7OveLDxMgCP1qsS4JvNhlToeXd+iAeZcBwKsWVOHnwMdTrd+p8WCS
X-Gm-Gg: ASbGncvaTxJ69nGrr+qAfwvulwtP5vBd5GBD5i5j0FiuKt2GfSeRbPej+nUnIkF/Q/3
	2Wi5T2617QEYc766rN+s+cvt1ZscQPT/VWzo3DNmJXriz76t1/u4t+qeChENLnkucjYhAYprPxU
	8LJO7XlI8rRLbBImLdxe41au8VR5V1r95cmP2oEtRO2FFp8wG8yoHtfS2OjXnLWKcCFjNZEMYSl
	nEkVFGkag8cWkgmsaAXxOUvIjS7fm0QuPJ28BhYxD8bx66Hp8Cd7wvb5v8I7BJYPrIP+UIOAeya
	OWjZqh9VBSCUzy2GIYGqkLBZF0pYq5sG7yXnm4sLOWwDDuRDtV1/lNLoYLZ+DEmtc6KodUou9Uz
	/berl7uFYWmCC/943
X-Google-Smtp-Source: AGHT+IEu6qVydvgz5FX5gNAmjAkNmVg8S3aqqXExnZUf61/Sip3v+pDczaTy7pMfPzfVmQFRBGfoB1U3Opib
X-Received: by 2002:a05:6512:401b:b0:58b:212:b0b5 with SMTP id 2adb3069b0e04-591ea30a314mr1687437e87.7.1761174823283;
        Wed, 22 Oct 2025 16:13:43 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-592f4e502d3sm34119e87.55.2025.10.22.16.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:13:43 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2290F3407D1;
	Wed, 22 Oct 2025 17:13:39 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 20207E4181C; Wed, 22 Oct 2025 17:13:39 -0600 (MDT)
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
Subject: [PATCH 3/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
Date: Wed, 22 Oct 2025 17:13:26 -0600
Message-ID: <20251022231326.2527838-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251022231326.2527838-1-csander@purestorage.com>
References: <20251022231326.2527838-1-csander@purestorage.com>
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
Introduce a macro DEFINE_IO_URING_CMD_TASK_WORK() to define a
io_req_tw_func_t function wrapping an io_uring_cmd_tw_t. Convert the
io_uring_cmd_tw_t function to the io_req_tw_func_t function in
io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy().
Use DEFINE_IO_URING_CMD_TASK_WORK() to define a io_req_tw_func_t
function for each existing io_uring_cmd_tw_t function. Now uring_cmd
task work dispatch makes a single indirect call to the io_req_tw_func_t
wrapper function, which can inline the io_uring_cmd_tw_t function. This
also allows removing the task_work_cb field from struct io_uring_cmd,
freeing up some additional storage space.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 block/ioctl.c                |  1 +
 drivers/block/ublk_drv.c     |  3 +++
 drivers/nvme/host/ioctl.c    |  1 +
 fs/btrfs/ioctl.c             |  1 +
 fs/fuse/dev_uring.c          |  1 +
 include/linux/io_uring/cmd.h | 45 +++++++++++++++++++++---------------
 io_uring/uring_cmd.c         | 13 ++---------
 7 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d7489a56b33c..7a3756863c9b 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -776,10 +776,11 @@ static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (bic->res == -EAGAIN && bic->nowait)
 		io_uring_cmd_issue_blocking(cmd);
 	else
 		io_uring_cmd_done(cmd, bic->res, issue_flags);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(blk_cmd_complete)
 
 static void bio_cmd_bio_end_io(struct bio *bio)
 {
 	struct io_uring_cmd *cmd = bio->bi_private;
 	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0c74a41a6753..829b049c7c75 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1354,10 +1354,11 @@ static void ublk_cmd_tw_cb(struct io_uring_cmd *cmd,
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
 
 	ublk_dispatch_req(ubq, pdu->req, issue_flags);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(ublk_cmd_tw_cb)
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 {
 	struct io_uring_cmd *cmd = ubq->ios[rq->tag].cmd;
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
@@ -1378,10 +1379,11 @@ static void ublk_cmd_list_tw_cb(struct io_uring_cmd *cmd,
 		rq->rq_next = NULL;
 		ublk_dispatch_req(rq->mq_hctx->driver_data, rq, issue_flags);
 		rq = next;
 	} while (rq);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(ublk_cmd_list_tw_cb)
 
 static void ublk_queue_cmd_list(struct ublk_io *io, struct rq_list *l)
 {
 	struct io_uring_cmd *cmd = io->cmd;
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
@@ -2529,10 +2531,11 @@ static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
 	int ret = ublk_ch_uring_cmd_local(cmd, issue_flags);
 
 	if (ret != -EIOCBQUEUED)
 		io_uring_cmd_done(cmd, ret, issue_flags);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(ublk_ch_uring_cmd_cb)
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	if (unlikely(issue_flags & IO_URING_F_CANCEL)) {
 		ublk_uring_cmd_cancel_fn(cmd, issue_flags);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c212fa952c0f..d4ca46b3abc7 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -405,10 +405,11 @@ static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
 	io_uring_cmd_done32(ioucmd, pdu->status, pdu->result, issue_flags);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(nvme_uring_task_cb)
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 						blk_status_t err)
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 185bef0df1c2..9d395f034403 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4704,10 +4704,11 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
 	kfree(priv->pages);
 	kfree(priv->iov);
 	kfree(priv);
 	kfree(bc->data);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(btrfs_uring_read_finished)
 
 void btrfs_uring_read_extent_endio(void *ctx, int err)
 {
 	struct btrfs_uring_priv *priv = ctx;
 	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(priv->cmd, struct io_btrfs_cmd);
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 71b0c9662716..e2c87c01e021 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1226,10 +1226,11 @@ static void fuse_uring_send_in_task(struct io_uring_cmd *cmd,
 		err = -ECANCELED;
 	}
 
 	fuse_uring_send(ent, cmd, err, issue_flags);
 }
+static DEFINE_IO_URING_CMD_TASK_WORK(fuse_uring_send_in_task)
 
 static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
 {
 	unsigned int qid;
 	struct fuse_ring_queue *queue;
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index b84b97c21b43..5d6e30cc9b0b 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -9,18 +9,13 @@
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
 };
 
@@ -58,13 +53,29 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
  */
 void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret, u64 res2,
 			 unsigned issue_flags, bool is_cqe32);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			    io_uring_cmd_tw_t task_work_cb,
+			    io_req_tw_func_t task_work_cb,
 			    unsigned flags);
 
+/*
+ * uring_cmd_cb should be a function with the signature
+ * void (struct io_uring_cmd *cmd, unsigned issue_flags)
+ */
+#define IO_URING_CMD_TASK_WORK(uring_cmd_cb) uring_cmd_cb##_tw
+
+#define DEFINE_IO_URING_CMD_TASK_WORK(uring_cmd_cb)				\
+void										\
+IO_URING_CMD_TASK_WORK(uring_cmd_cb)(struct io_kiocb *req, io_tw_token_t tw)	\
+{										\
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);\
+										\
+	/* task_work executor checks the deferred list completion */		\
+	uring_cmd_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);			\
+}
+
 /*
  * Note: the caller should never hard code @issue_flags and only use the
  * mask provided by the core io_uring code.
  */
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
@@ -107,11 +118,11 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
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
@@ -131,21 +142,19 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 	return true;
 }
 #endif
 
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
-static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			io_uring_cmd_tw_t task_work_cb)
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
-}
-
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			io_uring_cmd_tw_t task_work_cb)
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
-}
+#define io_uring_cmd_do_in_task_lazy(ioucmd, uring_cmd_cb)			\
+	__io_uring_cmd_do_in_task((ioucmd),					\
+				  IO_URING_CMD_TASK_WORK(uring_cmd_cb),		\
+				  IOU_F_TWQ_LAZY_WAKE)
+
+#define io_uring_cmd_complete_in_task(ioucmd, uring_cmd_cb)			\
+	__io_uring_cmd_do_in_task((ioucmd),					\
+				  IO_URING_CMD_TASK_WORK(uring_cmd_cb),		\
+				  0)
 
 static inline bool io_uring_cmd_should_terminate_tw(struct io_uring_cmd *cmd)
 {
 	return io_should_terminate_tw(cmd_to_io_kiocb(cmd)->ctx);
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 35bdac35cf4d..5a80d35658dc 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -111,29 +111,20 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
-{
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-
-	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
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


