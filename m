Return-Path: <io-uring+bounces-11984-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHlvOioLfGkEKQIAu9opvQ
	(envelope-from <io-uring+bounces-11984-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 02:36:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 55423B632D
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 02:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88EF830086CA
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 01:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C790F314B8E;
	Fri, 30 Jan 2026 01:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RwgD5fSA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA37330D34
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769736969; cv=none; b=IweEh5ACmuG4QK9j9LK9kGkZ/ESS2ra1z7F3A5rE4V6coBtoY4NOF+jD8Xy2ISUG3OOgj8kmYdpK64pHbShD0oMyChNWC1OiJYmx+lzooBq+NQHCp1vl9CV43usLe73VPwibNUG78wNorYv3Ly/692Ouuu8g3At3BV8W/BGKLPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769736969; c=relaxed/simple;
	bh=gxTY6iWb5W801To2X48bbstLVCMtpnhPfoxfZPwE8Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgJk7h67LwuIKWw/aTkWQPutctBToBKtWigkv7VB7H2oUN4PiUQWo6v03vxnu3jv04KcvgUNDZMHO7OnuViGPWXonUNGPQ9sYbk8BsRaZaDkKQ2Cpvhx1DHEpxpI937C4ruPXFiTPwICP8AzAMDV6M3ksQuBt7YWnXGaZXYBV6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RwgD5fSA; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b72e49776eso3040239eec.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 17:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769736966; x=1770341766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xRHjyDEZ8Hznoy7ok1X0g/zskcG9RtYz2AzGgjQ/5lM=;
        b=RwgD5fSAsgBxi7oQSAeHMpyKI6lJjtvlT9gjT630P6QfxcqJmnw3NNk4COudX4pWQi
         qLH2+7mDaH9LFMa9BjX/0+tbgLffaNhZxu866+bzWi1G/T+IcgWOU748sKhhdb6T5Ow2
         bkeK5tKvG2fM00DzM7q1R596qRokJsvSQZAYz4qE1ZdAIG48q2kAsh0QGRrOnDofoC1l
         E3zY75ZoZVR20ifrqRIRfTBUVVK2i8NmRO6bMkL5QSw2DyP19FI1TDgKxf8W0kZ0A+Jc
         xG/0aVrBKmwFK55zl4NFsyWR+iI2Ag+ozMhQOihbww5UV9vdH3Otvrmz79LHtNO4BeIS
         Jn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769736966; x=1770341766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRHjyDEZ8Hznoy7ok1X0g/zskcG9RtYz2AzGgjQ/5lM=;
        b=XSrMbtCbhRuBzC1+mAMwyFExTZBMKwdzXqKVGeZShs+8FvRk4SVomfYR/OglKTnqHk
         C2iZiZcYTC69XOfUGJtoe7w0Rjg/gfcR4fqeYzQQdxKKCclhlbebUOWqmhxw3IKdsZos
         1fJOXXyKyDKz56rNuinqhCz73hglYdR+MzLAtOXIMHmeteGwhGPlChvvDgos/S+YZgBu
         Fqa+CAfDMnvhqK+JlsuYL96UY0EmcGcBWv3P1mRjHXfi50mOkHF+ziXZF7q7xV85agiq
         dTOStNZz1gAbUnU2/+e90w6lWfFZju4uO3MIfMi6G7kvydlHbY/XR0bVUSCUjqyWajOY
         AkJQ==
X-Gm-Message-State: AOJu0YwatI2n36CmJvKzRaNrHuKaC5+w3xb1clJAdlOW3QXPL1ZOumaP
	LYOo5rTEFawBFbvn50Db3F2Wbt0gLNBTUXR91gL0Ga/sTK0mnaOrSVrm3k/luQ==
X-Gm-Gg: AZuq6aIX5ygIO9kf7n6BIlose0ZLyXziEZ1bLIAjAkUUqTjzJR7A6EfwrHmm922CwMX
	u5fcqmWGmpmmWhTeceuqr6aRdkgvdKsCdSZAmUnlhEQiXZ6GOIbKmDOVQFC1XnmAqFNHDZfWuh7
	eQxX5ygmJ1DFpEhClVZj/cA/mn1rwtBEFrihppaTiL8Wvf1LqsY8WKlN1gkeI/H+oRYy4x32cW4
	i3pCW7PQ1OkANjVrlsaJKpVbFnVY+sevvbZXU41HuFqAZA6MMsJtuF3ArPkMol7Il4CQN+8e9et
	wuxfqTErFQK+UGMMFPg0kFClC8V7hlbNsNkr/jmTx8feKSlVr0uBHdG7Sa0bdh9rESfgL5Lvluq
	3yk3uzkM4TVRDt5XlRwVioejJ5tQ17WcCQfVzKIO0uZvR/6EgVfLjrwsK4LFecwAGykRxcEangQ
	Ub8jVc6Y9LzgVz+ys=
X-Received: by 2002:a05:7300:2303:b0:2b7:857:db6c with SMTP id 5a478bee46e88-2b7c88da439mr723344eec.28.1769736965825;
        Thu, 29 Jan 2026 17:36:05 -0800 (PST)
Received: from localhost ([2601:646:8100:f8:a787:ffd3:9020:3716])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-2b7a1add66fsm9008674eec.28.2026.01.29.17.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 17:36:05 -0800 (PST)
From: Govindarajulu Varadarajan <govind.varadar@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	csander@purestorage.com
Cc: ming.lei@redhat.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	miklos@szeredi.hu,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH v3] io_uring: Add size check for sqe->cmd
Date: Thu, 29 Jan 2026 17:36:02 -0800
Message-ID: <20260130013602.422682-1-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.52.0
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,lst.de,grimberg.me,szeredi.hu,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11984-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[govindvaradar@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55423B632D
X-Rspamd-Action: no action

For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
check if size of user struct does not exceed 80 bytes at compile time.
User doesn't have to track this manually during development.

Replace io_uring_sqe_cmd() inline func with macro and add
io_uring_sqe128_cmd() which checks struct
size for 16 bytes cmd and 80 bytes cmd respectively.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
---
v3: Remove extra parentheses.
v2:
  - Replace all caps macro with lower case definition.
  - Add const qualifier to return type.
  - Rebase on top of series "[PATCH 0/4] ublk: fix struct
    ublksrv_ctrl_cmd accesses"

BRANCH: for-7.0/block

Depends-on series: "[PATCH 0/4] ublk: fix struct ublksrv_ctrl_cmd
accesses"
  Needs "[PATCH 2/4] ublk: don't write to struct ublksrv_ctrl_cmd" to
  avoid merge conflict.
---
 drivers/block/ublk_drv.c     | 14 +++++++++-----
 drivers/nvme/host/ioctl.c    |  3 ++-
 fs/fuse/dev_uring.c          |  6 ++++--
 include/linux/io_uring/cmd.h | 15 +++++++++++----
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0e25a59849ae..3f9d6dc3afef 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3244,7 +3244,8 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 	/* May point to userspace-mapped memory */
-	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe,
+							       struct ublksrv_io_cmd);
 	u16 buf_idx = UBLK_INVALID_BUF_IDX;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
@@ -3824,7 +3825,8 @@ static int ublk_validate_batch_fetch_cmd(struct ublk_batch_io_data *data)
 static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
 				     unsigned int issue_flags)
 {
-	const struct ublksrv_io_cmd *ub_cmd = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_io_cmd *ub_cmd = io_uring_sqe_cmd(cmd->sqe,
+							       struct ublksrv_io_cmd);
 	struct ublk_device *ub = cmd->file->private_data;
 	unsigned tag = READ_ONCE(ub_cmd->tag);
 	unsigned q_id = READ_ONCE(ub_cmd->q_id);
@@ -3853,7 +3855,7 @@ static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
 static int ublk_ch_batch_io_uring_cmd(struct io_uring_cmd *cmd,
 				       unsigned int issue_flags)
 {
-	const struct ublk_batch_io *uc = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublk_batch_io *uc = io_uring_sqe_cmd(cmd->sqe, struct ublk_batch_io);
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_batch_io_data data = {
 		.ub  = ub,
@@ -5106,7 +5108,8 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		struct io_uring_cmd *cmd, u64 *addr, u16 *len)
 {
-	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe128_cmd(cmd->sqe,
+								    struct ublksrv_ctrl_cmd);
 	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	void __user *argp = (void __user *)*addr;
 	char *dev_path = NULL;
@@ -5199,7 +5202,8 @@ static bool ublk_ctrl_uring_cmd_may_sleep(u32 cmd_op)
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe128_cmd(cmd->sqe,
+								    struct ublksrv_ctrl_cmd);
 	struct ublk_device *ub = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	int ret = -EINVAL;
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index fb62633ccbb0..8844bbd39515 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -447,7 +447,8 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	const struct nvme_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	const struct nvme_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe,
+							       struct nvme_uring_cmd);
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_uring_data d;
 	struct nvme_command c;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5ceb217ced1b..60f2058feb74 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -879,7 +879,8 @@ static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
 static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 				   struct fuse_conn *fc)
 {
-	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe128_cmd(cmd->sqe,
+								       struct fuse_uring_cmd_req);
 	struct fuse_ring_ent *ent;
 	int err;
 	struct fuse_ring *ring = fc->ring;
@@ -1083,7 +1084,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 static int fuse_uring_register(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags, struct fuse_conn *fc)
 {
-	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe128_cmd(cmd->sqe,
+								       struct fuse_uring_cmd_req);
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 375fd048c4cb..331dcbefe72f 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -20,10 +20,17 @@ struct io_uring_cmd {
 	u8		unused[8];
 };
 
-static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
-{
-	return sqe->cmd;
-}
+#define io_uring_sqe128_cmd(sqe, type)	({					\
+	BUILD_BUG_ON(sizeof(type) > ((2 * sizeof(struct io_uring_sqe)) -	\
+				     offsetof(struct io_uring_sqe, cmd)));	\
+	(const type *)(sqe)->cmd;						\
+})
+
+#define io_uring_sqe_cmd(sqe, type)	({					\
+	BUILD_BUG_ON(sizeof(type) > (sizeof(struct io_uring_sqe) -		\
+				     offsetof(struct io_uring_sqe, cmd)));	\
+	(const type *)(sqe)->cmd;						\
+})
 
 static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
 {
-- 
2.52.0


