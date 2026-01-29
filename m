Return-Path: <io-uring+bounces-11972-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JsmLaG/e2mnIAIAu9opvQ
	(envelope-from <io-uring+bounces-11972-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:14:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B728B4302
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C933830058F7
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 20:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5B7330B3F;
	Thu, 29 Jan 2026 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WB27vRt0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C7F330B2B
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 20:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769717662; cv=none; b=XJXH45KDFVhBGC9QZ1x4tRbZsawVy3v4wMtuFhN8MzHDvan9RoAsF4wwDdqa6iUvScLJZItt/ZAFUno8XGcGC9tAvUMdJF7QadbDC1RXlF9VILN4Ph3ye8ToAlUA1W9FjgB6jrVo/X+D0Iv9pjK9dcs0OxlSyS3O7ID78Z76uOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769717662; c=relaxed/simple;
	bh=Xr4VRTXUMvYOoOTG4xSA4HcMhKtK+SmJXGrOAu9vTVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIMmjuJEicx+Mo+nmYrlxhggkAcoLcCd15wLNM5EycAZN/BOFtfx1CoSVmHXQuZGxiVKGmxahTgUI2t6SwQms0lS/OUW47oAwX1kW8AFWgCx+eFbFTUtcZcfstKi8G0C5E8OZ8MxUKVmABY1Z0t2r9t/ffeWg+wGrf1QO+Ji4h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WB27vRt0; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12331482b8fso327920c88.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 12:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769717660; x=1770322460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cewWuLDuZTRNMH1KXyj53qhsOkE82PWkWpoU3+H5GRM=;
        b=WB27vRt0nSS5Azdqus4UbakFY94QOwnBpOn1i87yVwV4F9sAUlrJPn3h6gM0obOPI7
         OwapZVWKsgvX/7jWq47XpM74kk6Rjm5PcM6oDUvXP0q9fuOMSj/43OMgz0Xb4aQJOo52
         jSw/f+SLo1Vc2JbWN7dZkPRL5shyfcwbu5sp3SIDYNcDPce2gZMTnX8K4u1bBkMVt/sW
         3km5/HzvfS/tCsVTfY23NMq8kTFSxIe5RrCFOAGCMhTyAhTdpyl/kgkYnbVE1GWmftHJ
         R2+btMKUCRvj8DmRbfs0dKJ68mS1JG4iAlYZJRsA9u1nLG+x8StRH6gZOisUCoXemiEm
         memw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769717660; x=1770322460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cewWuLDuZTRNMH1KXyj53qhsOkE82PWkWpoU3+H5GRM=;
        b=UcNSvWhaYoyLl5bbF7PGFdsvX7ZpClRnXUSfyIE8JWH0YLeZ500K9y+MOnBO76Hkb8
         6ekqqWq4zmJjAfJ6mDbcrZgnJwSwRzy5TVKH0SlSD15BI/J+fJTepvJmAT7rey6TvaC+
         O2PpO3HzFND7lnCmFZjrOhTxFqUDRFyW1FD8DHEfao+gwlS4HSLJ3hyQ9dn6ssftRCIm
         KGz0ugVuMv+8Bj4yeCqliECUd4lgqaOfLcrzx5hVRxgWDANH0dV+ekyOiXUOQDOQjBr8
         WQUyGhUKC0U+IDmxEO0FZfibyhQQDTCxrxyaI+vQrlQQk48JP+lRIKEcaacvwx5l3L/b
         zppg==
X-Gm-Message-State: AOJu0Yw7ZQMilh8kA9flqRPx1eAWKW1XM8e2e2VFXvW4QpQhwxsiSTO8
	Mul4+Tn6yY1vLKcBrEqrGxriSz77ZEGOW/Mxrw4AWLCF4jtKPBAqZOVbblFQdw==
X-Gm-Gg: AZuq6aJ61RK+JizOG7bupUB3oxs3fTz0pEs9OR8/Kv938mSIrmN8CqxfvcIJya/KMg3
	qoRZgQNVqZKbVrksBAOgiEnuL0MWruXpXx94j40urU7m4uaG3q4q/s9xZ197a2R1A2Dhz2twJ58
	RzQkH1qPtdWN12uT/I6o0AQxY+4JPGsT4Lc4hEctcSf0gyhxRymixvnNrSdrmBOmbxFC/aHfQMF
	awzh56jjMSAL0vRkYsT2+NrntugrgNWrEw1d5jUtjSj8aHIZkB3M71D6iVdgbrzn+OQNrb1sAIK
	izu4ue6Z5xRIxGdWShmkrIC71YSe0B+RX4Dz1FQPZVt05r4eFCTa0aq/V+mlJZ+Qs6ER0zOU6Bw
	Hsn0wxdGspJxDXCL9y6Gb9TZ1mmvfNWz+YfENvlIUZrbuLV05kahTDUelrifvGiFLoMFeu6EjHg
	WfjVCawTEZ4dzYo2k=
X-Received: by 2002:a05:7300:8186:b0:2b7:c5d7:84b3 with SMTP id 5a478bee46e88-2b7c866dbc3mr405326eec.19.1769717659585;
        Thu, 29 Jan 2026 12:14:19 -0800 (PST)
Received: from localhost ([2601:646:8100:f8:a787:ffd3:9020:3716])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-2b7a1abe57csm9952679eec.22.2026.01.29.12.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 12:14:19 -0800 (PST)
From: Govindarajulu Varadarajan <govind.varadar@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk
Cc: ming.lei@redhat.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	miklos@szeredi.hu,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH 1/2] io_uring: Add size check for sqe->cmd
Date: Thu, 29 Jan 2026 12:13:46 -0800
Message-ID: <20260129201347.411015-2-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129201347.411015-1-govind.varadar@gmail.com>
References: <20260129201347.411015-1-govind.varadar@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,lst.de,grimberg.me,szeredi.hu,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11972-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[govindvaradar@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7B728B4302
X-Rspamd-Action: no action

For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
check if size of user struct does not exceed 80 bytes at compile time.
User doesn't have to track this manually during development.

Replace io_uring_sqe_cmd() with IO_URING_SQE_CMD() which checks struct
size for 16 bytes cmd.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
---
 drivers/block/ublk_drv.c     | 14 ++++++++------
 drivers/nvme/host/ioctl.c    |  2 +-
 fs/fuse/dev_uring.c          |  6 ++++--
 include/linux/io_uring/cmd.h | 15 +++++++++++----
 4 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 4265b7610c95..7c8a23709efa 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3155,7 +3155,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 	/* May point to userspace-mapped memory */
-	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_io_cmd *ub_src = IO_URING_SQE_CMD(cmd->sqe, struct ublksrv_io_cmd);
 	u16 buf_idx = UBLK_INVALID_BUF_IDX;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
@@ -3735,7 +3735,7 @@ static int ublk_validate_batch_fetch_cmd(struct ublk_batch_io_data *data)
 static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
 				     unsigned int issue_flags)
 {
-	const struct ublksrv_io_cmd *ub_cmd = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_io_cmd *ub_cmd = IO_URING_SQE_CMD(cmd->sqe, struct ublksrv_io_cmd);
 	struct ublk_device *ub = cmd->file->private_data;
 	unsigned tag = READ_ONCE(ub_cmd->tag);
 	unsigned q_id = READ_ONCE(ub_cmd->q_id);
@@ -3764,7 +3764,7 @@ static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
 static int ublk_ch_batch_io_uring_cmd(struct io_uring_cmd *cmd,
 				       unsigned int issue_flags)
 {
-	const struct ublk_batch_io *uc = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublk_batch_io *uc = IO_URING_SQE_CMD(cmd->sqe, struct ublk_batch_io);
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_batch_io_data data = {
 		.ub  = ub,
@@ -4653,7 +4653,8 @@ static int ublk_ctrl_del_dev(struct ublk_device **p_ub, bool wait)
 
 static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
 {
-	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_ctrl_cmd *header = IO_URING_SQE128_CMD(cmd->sqe,
+								    struct ublksrv_ctrl_cmd);
 
 	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
 			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
@@ -5061,7 +5062,7 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)io_uring_sqe_cmd(cmd->sqe);
+	struct ublksrv_ctrl_cmd *header = IO_URING_SQE128_CMD(cmd->sqe, struct ublksrv_ctrl_cmd);
 	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	char *dev_path = NULL;
@@ -5152,7 +5153,8 @@ static bool ublk_ctrl_uring_cmd_may_sleep(u32 cmd_op)
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_ctrl_cmd *header = IO_URING_SQE128_CMD(cmd->sqe,
+								    struct ublksrv_ctrl_cmd);
 	struct ublk_device *ub = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	int ret = -EINVAL;
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index fb62633ccbb0..90c49bb727ad 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -447,7 +447,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	const struct nvme_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	const struct nvme_uring_cmd *cmd = IO_URING_SQE128_CMD(ioucmd->sqe, struct nvme_uring_cmd);
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_uring_data d;
 	struct nvme_command c;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5ceb217ced1b..7dddba72f406 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -879,7 +879,8 @@ static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
 static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 				   struct fuse_conn *fc)
 {
-	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	const struct fuse_uring_cmd_req *cmd_req = IO_URING_SQE128_CMD(cmd->sqe,
+								       struct fuse_uring_cmd_req);
 	struct fuse_ring_ent *ent;
 	int err;
 	struct fuse_ring *ring = fc->ring;
@@ -1083,7 +1084,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 static int fuse_uring_register(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags, struct fuse_conn *fc)
 {
-	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	const struct fuse_uring_cmd_req *cmd_req = IO_URING_SQE128_CMD(cmd->sqe,
+								       struct fuse_uring_cmd_req);
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 375fd048c4cb..e8fd93e90cde 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -20,10 +20,17 @@ struct io_uring_cmd {
 	u8		unused[8];
 };
 
-static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
-{
-	return sqe->cmd;
-}
+#define IO_URING_SQE128_CMD(sqe, type)	({						\
+	BUILD_BUG_ON(sizeof(type) > ((2 * sizeof(struct io_uring_sqe)) -		\
+				     offsetof(struct io_uring_sqe, cmd)));		\
+	(type *)(sqe)->cmd;								\
+})
+
+#define IO_URING_SQE_CMD(sqe, type)	({						\
+	BUILD_BUG_ON(sizeof(type) > ((sizeof(struct io_uring_sqe)) -			\
+				     offsetof(struct io_uring_sqe, cmd)));		\
+	(type *)(sqe)->cmd;								\
+})
 
 static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
 {
-- 
2.52.0


