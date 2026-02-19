Return-Path: <io-uring+bounces-12326-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id rB/TJbyYlmmVhwIAu9opvQ
	(envelope-from <io-uring+bounces-12326-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 05:59:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9DC15C0FD
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 05:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98E3C30143D1
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 04:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FED284B58;
	Thu, 19 Feb 2026 04:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igCnTZJ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1221F1315
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 04:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771477176; cv=none; b=hoZhB9Ma39AE2Eh8cidYqfn7YDeRfz60RIkbn4wfqOmiChTSNcsT4e3e/iCnp9fAdpyeBB2Mdg8HtgOZBHZoLrsRZsVXaL/QSgOTsSPdNfly2K9t9zElDSO2rO4mSiyYCeUEMHoZmxZkHDDOqrmr5GDrxWrTpJBqwkh/E2cSx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771477176; c=relaxed/simple;
	bh=8toOouew2j+r2RYwsmBEbJ9n5vOF7vdtdZ8kwxzOAew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tG4KOm94sPNrQElh2rVbb+pqqplKTNr6KQdcFOSCbU+1GZ6c8glnDr0o3N98zVK04zGIw22t1bLuJP/G/4Hn+UqLoDiNDiloeb87KsJdU4G1lql49y8ZuIB0Ruz//bbRyJXN3FNYfQb29s6ldIuFq2JOkyFGfF2a5qzJXgjljfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=igCnTZJ5; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2bd3b0bc201so1251538eec.1
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 20:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771477173; x=1772081973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=URVoEWWXIZWs8eLF0NtSZs2yK2ef/h2NoEcTm7ge7Lc=;
        b=igCnTZJ5D8dR3+AYe0CeRKFEavj7nSiQmdrTRBcnV5IgdpUebHap7tSeDI9ngrTMhY
         vZ1z+r0Bfc2CfsrOAe/sMSIWS72odZBT4n9vgiZFeq9d20TMTO1Ah2sgJwYe3wcMdJs2
         GaSDSeHOcnE5wItryjIMApSiuO29OzyUVoy5ddcgjCCPKSfAOeWYiusc49HW/oAP+bGC
         Gs9pjPEh5m3YEwYfdATkIr56sRbnk9pyEJ7xv+uma3Y97fcJXEoL7Bh5KqnJyeZscQDX
         3vndZpdYmPZn4AJuhDQ/MdBrF222t3NJxbM/EDksYCtpP1QYlJY4O5k8WJLLnwncPQw3
         Viqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771477173; x=1772081973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=URVoEWWXIZWs8eLF0NtSZs2yK2ef/h2NoEcTm7ge7Lc=;
        b=j3ItJU5PztBvCP6YOZLXOuLIeIO9ioUiuME19mdGr9Hq+wU2kLBDWjcarwfUJFEmOq
         RhEqbIK7mp63jGV+R871iaTGXOmN2dfgM+xeDH5MiR8K78O8sH4iBsJz8rW/X4+qL5Tu
         VK2BMT45BJlFySgNRdW8e0HIaq3Qb4m/j0RlKeXNjSeyDZWfuxdsqo94quk/HLVvic0/
         WSpgBq0mgBjBf6zUG6SQm/8P/w/BK1hNqKC5iIdf7scDG/8zL1oiskjFCicw2WuKF0Pm
         fz7AHfK1RAS/cwEOilFRUEQUC6NcosVXSpg8Ul7N0TzOjGBmrm0Wnui4XiSLwfBCSS6C
         jCkQ==
X-Gm-Message-State: AOJu0Yyhwi4DWTwvi8P9XQO1Pvsr+CBH+gMdJy6XJAssSrAI4jTRMmI2
	aPlNX0WjyirufdUJeVLnAj/9/AHCh1lx1UAHEaSF0klps/OsekfIqgc3jaDwXXlg
X-Gm-Gg: AZuq6aKtOjUvO7AY+gQ+zchWGzupVVrIeFR992C7lFzG32Ev0Jb4t9BzcUlY/xlP5gO
	tdG8iWGotnrWyqSkOAmogrOAhR11NiQSk3rXgIUSUnMjDCy3yI0uzakaJTTwFrxKVdiCjglp3EY
	ZNRS2+LlAf2kDOvfc2yTfTogznldkR3XpGCX3Zbxy5JJhuGJBWGeIoQlUZoDMMccyDdgYzg2ht/
	6QQ8JrumWJN3vEyNPL6tvC8vUvMvxuqdck8ll+5eRnE17M6ORBaxiyYczw/Xmh+bWy2LI/wsEpT
	hV2dmBHOQPhv878II9Kxpb+DwHjfYrp3hKii7f0YqixLWtLcdzouxlxl8qwpWQVVFblKb4wwZvH
	QoLyO3R4K3GuK01LNYw1jsOsQeoQXdzcvwye0GMNvwTmtz6RFj3LQAgTnbGlfc3oE76FMWnAqj/
	+LmNpmECAdjiB9V/HFsHuzTQbczrejaUELxBM8+Q==
X-Received: by 2002:a05:693c:374c:b0:2b0:52ac:92fe with SMTP id 5a478bee46e88-2bd5b3c7078mr913025eec.21.1771477173288;
        Wed, 18 Feb 2026 20:59:33 -0800 (PST)
Received: from localhost ([2601:646:8100:f8:a787:ffd3:9020:3716])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-2bacb67b638sm20564693eec.31.2026.02.18.20.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 20:59:32 -0800 (PST)
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
Subject: [LINUX PATCH v4] io_uring: Add size check for sqe->cmd
Date: Wed, 18 Feb 2026 20:59:30 -0800
Message-ID: <20260219045930.935755-1-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,lst.de,grimberg.me,szeredi.hu,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12326-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EF9DC15C0FD
X-Rspamd-Action: no action

For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
check if size of user struct does not exceed 80 bytes at compile time.
User doesn't have to track this manually during development.

Replace io_uring_sqe_cmd() inline func with macro and add
io_uring_sqe128_cmd() which checks struct
size for 16 bytes cmd and 80 bytes cmd respectively.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
v4: Rebase on top of for-next
v3: Remove extra parentheses.
v2:
  - Replace all caps macro with lower case definition.
  - Add const qualifier to return type.
  - Rebase on top of series "[PATCH 0/4] ublk: fix struct
    ublksrv_ctrl_cmd accesses"

BRANCH: for-next
---
 drivers/block/ublk_drv.c     | 12 ++++++++----
 drivers/nvme/host/ioctl.c    |  3 ++-
 fs/fuse/dev_uring.c          |  6 ++++--
 include/linux/io_uring/cmd.h | 15 +++++++++++----
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c13cda58a7c6..46a785ce078d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3255,7 +3255,8 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 	/* May point to userspace-mapped memory */
-	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_io_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe,
+							       struct ublksrv_io_cmd);
 	u16 buf_idx = UBLK_INVALID_BUF_IDX;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
@@ -3833,7 +3834,8 @@ static int ublk_validate_batch_fetch_cmd(struct ublk_batch_io_data *data)
 static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
 				     unsigned int issue_flags)
 {
-	const struct ublksrv_io_cmd *ub_cmd = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_io_cmd *ub_cmd = io_uring_sqe_cmd(cmd->sqe,
+							       struct ublksrv_io_cmd);
 	struct ublk_device *ub = cmd->file->private_data;
 	unsigned tag = READ_ONCE(ub_cmd->tag);
 	unsigned q_id = READ_ONCE(ub_cmd->q_id);
@@ -3862,7 +3864,8 @@ static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
 static int ublk_ch_batch_io_uring_cmd(struct io_uring_cmd *cmd,
 				       unsigned int issue_flags)
 {
-	const struct ublk_batch_io *uc = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublk_batch_io *uc = io_uring_sqe_cmd(cmd->sqe,
+							  struct ublk_batch_io);
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_batch_io_data data = {
 		.ub  = ub,
@@ -5253,7 +5256,8 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 	/* May point to userspace-mapped memory */
-	const struct ublksrv_ctrl_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublksrv_ctrl_cmd *ub_src = io_uring_sqe128_cmd(cmd->sqe,
+								    struct ublksrv_ctrl_cmd);
 	struct ublksrv_ctrl_cmd header;
 	struct ublk_device *ub = NULL;
 	u32 cmd_op = cmd->cmd_op;
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
2.53.0


