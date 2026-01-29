Return-Path: <io-uring+bounces-11982-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKneNl/ze2lnJgIAu9opvQ
	(envelope-from <io-uring+bounces-11982-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 00:55:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C45AB5C7B
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 00:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09F08300E38A
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863811C5D5E;
	Thu, 29 Jan 2026 23:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQsuiook"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141183446C0
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769730898; cv=none; b=jnHQ28pf7DfY7fygkpXs2wLiE13BN/Nw+/R/RTNhPTILF+94bg5cnyNI4CMX+4rdTnpsP5pTs0UCLG/uu7HeBW9zqq1Wwsbx3ICVWa6wlo14fb/YVL5XRLjQX2oampco4KQSUaCjx9s9Z+lu9/HIVeBB35hxhbl7AlEbRXqznQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769730898; c=relaxed/simple;
	bh=RB985I9Qh73pV3Wq6FZ5dL+LNBhdLOw2TaIL/OOLc3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1kawwbEXVWYNKhV4i1ahdWZCSj6gQAJ2DvULVuNbZoklJFbYk1/EqPJmY2knZzH+LHCAx2+J0Ozj8R+L9mSAydzqTNodj1c5yqBjaU75V3KoLVV7FefvxXzpa8ObRclbjYlag8+xOQP+qap63GMNpT0ZR0pmW/3H0zpY9yJlz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQsuiook; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b6fd5bec41so3274455eec.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 15:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769730896; x=1770335696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wd2raMo+ux6XXSgch8FCEw1i0/HtbrlenzfkkbkZi8Q=;
        b=XQsuiookR9ngrrpL+vhTN8c79XRa4EOCCRzWPGojCFzQ7qL8dGFK/1KI8/22H0xxMx
         r7vj2fuIZQnw7+tQT/3u3C5q9fpn76nOvh+/kFKFMVrVarzDLrcuGtqNd7Mw4fwFZb8P
         E4jG46MdswVLyEJw3NGfYED/8y/GAMdfhoIrbcleI6i1BZzR1hHLbmdCXJJ9W+Pr8ngp
         AawFKhPsVDzhdjvuwZAvA+wTTL9lAoVRs+dcHDQO3GmGydtXligawlDJ4RM42/Tc83XQ
         n0NjP99btgv68PCmHNmBGfr/LvzRHVIQD0craTbtDM4B+3hL2Au5SM/jUazhW5P3otQ0
         lE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769730896; x=1770335696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wd2raMo+ux6XXSgch8FCEw1i0/HtbrlenzfkkbkZi8Q=;
        b=ntImDzvNR2CRNwQ+6LZC+jnHT6xDC78HtbDpAdccoL0bR/hwrWI/88TMIheQl/GePS
         twMYberxxnephdp1OL0haQBXWho25IKIc2Aj3b8i5w7bEgcM2P0cqx9+kWd9z/DZarM8
         2PJnpFIWKCPjC+XMoWePT6eJH2Pyru3cf9NEOmkJr17vym5nUqBZABxjNUg2TbGm8A4A
         7XAr9mftez1hta/4bg4Oy9rrx0mH7JNeqkB5Ge8+qGvUuWWz/2rc5B4zDxqTzWQpUtcx
         yt9weDPYx4kNrSA/XMmkKDcaM4aqWH9JsaO3/cXuB/xatliudiwJ/nry7Ue1C85xN6dB
         ujaw==
X-Gm-Message-State: AOJu0YxTbkFhCLpf1yadvqjT6SkGRZl2sNLx+FR04xY2M7Dt75+Q/MQu
	Nc5K/OTmcEoj8FAo3Mp3HNN5bR0/UbYl8vAyDWW015LJvJjyYCuG/bHV7OAMUg==
X-Gm-Gg: AZuq6aIqi+Vz3g4MPnX2J9pnft4L1bjTGgRNT9ibPX69xSxYAAlixugC1kBFdTJT9Dm
	B5MrEwMwdnphj6H3dg/8xs5RL7MLKWs7ysQ5Pw1Qvnhmw2OL87eAdz6W4k/AT/KElpSqTLOsc/y
	9KeTagnsshGIGYEG5wNlD7wqqhWm1TjRUMfg7JingUqxarmthYkBECD3q1beo5nPsIFgfbSdIG9
	2aKpy4UUvJW0S+zPDwxALLva0UMsjIdeUGK0W7Hdc+d+ICGsFUBXTHRK8Ke7bo3SzzP3WilYvtu
	RwEz/Q/OEopZIJNjqfOc5yqWDcCVCsPB9EgDQrTPXutqfe0jfSokaRJC0mNDEwnwZHaEbPfzDJu
	uqoKxPLS5nMGQTTKeVDD1/8+57BaniiTEHlOfgukvLG1D+7PhRJ07GY/npmW/lkp0YJ7w6T9VQ/
	dwJzMVeYS2taw/EA8=
X-Received: by 2002:a05:7300:7493:b0:2b7:1320:f280 with SMTP id 5a478bee46e88-2b7c8663e38mr610033eec.15.1769730895748;
        Thu, 29 Jan 2026 15:54:55 -0800 (PST)
Received: from localhost ([2601:646:8100:f8:a787:ffd3:9020:3716])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-2b7a16d01c4sm8988063eec.2.2026.01.29.15.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 15:54:55 -0800 (PST)
From: Govindarajulu Varadarajan <govind.varadar@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk
Cc: ming.lei@redhat.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	miklos@szeredi.hu,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH v2] io_uring: Add size check for sqe->cmd
Date: Thu, 29 Jan 2026 15:54:34 -0800
Message-ID: <20260129235434.418973-1-govind.varadar@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,lst.de,grimberg.me,szeredi.hu,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11982-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6C45AB5C7B
X-Rspamd-Action: no action

For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
check if size of user struct does not exceed 80 bytes at compile time.
User doesn't have to track this manually during development.

Replace io_uring_sqe_cmd() inline func with macro and add
io_uring_sqe128_cmd() which checks struct
size for 16 bytes cmd and 80 bytes cmd respectively.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
---
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
index 375fd048c4cb..7245b975c55d 100644
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
+	BUILD_BUG_ON(sizeof(type) > ((sizeof(struct io_uring_sqe)) -		\
+				     offsetof(struct io_uring_sqe, cmd)));	\
+	(const type *)(sqe)->cmd;						\
+})
 
 static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
 {
-- 
2.52.0


