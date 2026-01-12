Return-Path: <io-uring+bounces-11578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B32C3D1150E
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 09:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3FADA305A445
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 08:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B3E342C9A;
	Mon, 12 Jan 2026 08:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="G6BHNV7y"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0534404E;
	Mon, 12 Jan 2026 08:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207603; cv=none; b=BJkiqeUZpU9YNr6HC4FSly6UIIplo0Tip2qiKaG5zfcsyDbe5MSUcNU3qKUUfAoBWbEdpciOBfjB8QI1PHKfP//YhByB5FfDtId8ls3Mx/tCZ218l3J11EJ/wzKzfKlIebc5fsSe7cBb0y/RTMD5moChkIeFXZ7PaGdb+5xYSMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207603; c=relaxed/simple;
	bh=1fQ+wCidl8AdlNQr0yTP+kzimLcX6917SAdUURzbovk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oX8vuOPn/BI0GbIRqz3wwo15/pKYTc4aoWnuYf3VD2rT2EUpF0IhYXej/oyOUAYGjxK1xfk8uVjHEIUU20cqlzO3DaQe9c1lHWw689uozUYCSH2kJaI7cXy0IQBPOWtYYQjpETfMpsqtizL52MvriEVPohAmCIY8vy7HjrAuy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=G6BHNV7y; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=aJ
	mw2UKvTCOZIMChkwQSwywauH0iuPure5AD/kUzQgY=; b=G6BHNV7yiBdvJ8wLym
	Gjd3gzCf+XBI4ZRJZdUbcViRlSRWZlFRKnQJDyNUQaUI764vecgK3PP5P2wVgJ98
	J3u1cxh8UuvQiLyMwnut241g2bEmgWxlyDbwbqUMKSwfQLQoknRoXuPDayNm+Zvq
	Db9nLxJspIdEnGza7HJqJb3ts=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDX7+bQtGRpQ4BSMg--.12084S5;
	Mon, 12 Jan 2026 16:46:13 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH 3/3] bsg: implement SCSI BSG uring_cmd handler
Date: Mon, 12 Jan 2026 16:46:06 +0800
Message-Id: <20260112084606.570887-4-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
References: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDX7+bQtGRpQ4BSMg--.12084S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr1DJF4kurW8JF4rWr4kZwb_yoW3JF1xpF
	W5tw4jvrW5Ww409FykAr4DCFyYqws5ua47KFW5u3ySkr1UCF90ga10kF10qF1fJr4kAa42
	qF4vkF98CF1jq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-8n5UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hXVZmlktNXq7wAA3l

Implement the SCSI-specific io_uring command handler for BSG. This
handler processes SCSI passthrough commands asynchronously via io_uring,
supporting both traditional user buffers and zero-copy fixed buffers.

Key features:
- Async command execution with proper completion handling
- Zero-copy support via io_uring fixed buffers
- Status information returned in CQE res2 field
- Non-blocking I/O support via IO_URING_F_NONBLOCK
- Proper error handling and validation

The implementation uses a PDU structure overlaying io_uring_cmd.pdu[32]
to store temporary state during command execution. Completion is handled
via task work to safely access user space.

This patch replaces the stub implementation from patch 2/3 with the full
implementation.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 4399a25990fc..1c4c29ef7e35 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -10,10 +10,205 @@
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
+/*
+ * BSG io_uring PDU structure overlaying io_uring_cmd.pdu[32].
+ * Stores temporary data needed during command execution.
+ */
+struct scsi_bsg_uring_cmd_pdu {
+	struct bio *bio;		/* mapped user buffer, unmap in task work */
+	struct request *req;		/* block request, freed in task work */
+	u64 sense_addr;			/* user space sense buffer address */
+	u32 resid_len;			/* residual transfer length */
+	u8 sense_len_wr;		/* actual sense data length written */
+	u8 device_status;		/* SCSI device status (low 8 bits of result) */
+	u8 host_status;			/* SCSI host status (host_byte of result) */
+	u8 driver_status;		/* SCSI driver status (DRIVER_SENSE if check condition) */
+};
+
+static inline struct scsi_bsg_uring_cmd_pdu *scsi_bsg_uring_cmd_pdu(
+	struct io_uring_cmd *ioucmd)
+{
+	return io_uring_cmd_to_pdu(ioucmd, struct scsi_bsg_uring_cmd_pdu);
+}
+
+/*
+ * Task work callback executed in process context.
+ * Builds res2 with status information and copies sense data to user space.
+ * res2 layout (64-bit):
+ *   0-7:   device_status
+ *   8-15:  driver_status
+ *   16-23: sense_len_wr
+ *   24-31: host_status
+ *   32-63: resid_len
+ */
+static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
+	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	struct scsi_cmnd *scmd;
+	struct request *rq = pdu->req;
+	int ret = 0;
+	u64 res2;
+
+	scmd = blk_mq_rq_to_pdu(rq);
+
+	if (pdu->bio)
+		blk_rq_unmap_user(pdu->bio);
+
+	res2 = ((u64)pdu->resid_len << 32) |
+	       ((u64)(pdu->host_status & 0xff) << 24) |
+	       ((u64)(pdu->sense_len_wr & 0xff) << 16) |
+	       ((u64)(pdu->driver_status & 0xff) << 8) |
+	       (pdu->device_status & 0xff);
+
+	if (pdu->sense_len_wr && pdu->sense_addr) {
+		if (copy_to_user(uptr64(pdu->sense_addr), scmd->sense_buffer,
+				 pdu->sense_len_wr))
+			ret = -EFAULT;
+	}
+
+	blk_mq_free_request(rq);
+	io_uring_cmd_done32(ioucmd, ret, res2,
+			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+}
+
+/*
+ * Async completion callback executed in interrupt/atomic context.
+ * Saves SCSI status information and schedules task work for final completion.
+ */
+static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
+						  blk_status_t status)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+
+	pdu->device_status = scmd->result & 0xff;
+	pdu->host_status = host_byte(scmd->result);
+	pdu->driver_status = 0;
+	pdu->sense_len_wr = 0;
+
+	if (scsi_status_is_check_condition(scmd->result)) {
+		pdu->driver_status = DRIVER_SENSE;
+		if (pdu->sense_addr)
+			pdu->sense_len_wr = min_t(u8, scmd->sense_len, SCSI_SENSE_BUFFERSIZE);
+	}
+
+	pdu->resid_len = scmd->resid_len;
+
+	io_uring_cmd_do_in_task_lazy(ioucmd, scsi_bsg_uring_task_cb);
+	return RQ_END_IO_NONE;
+}
+
+/*
+ * Map user buffer to request, supporting both zero-copy (fixed buffers)
+ * and traditional mode.
+ */
+static int scsi_bsg_map_user_buffer(struct request *req,
+				    struct io_uring_cmd *ioucmd,
+				    unsigned int issue_flags, gfp_t gfp_mask)
+{
+	const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	struct request_queue *q = req->q;
+	struct iov_iter iter;
+	bool is_write = cmd->dout_xfer_len > 0;
+	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
+	unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
+	bool use_fixed = (ioucmd->flags & IORING_URING_CMD_FIXED) != 0;
+	int ddir = is_write ? WRITE : READ;
+	int ret;
+
+	if (use_fixed) {
+		ret = io_uring_cmd_import_fixed(buf_addr, buf_len, ddir,
+						&iter, ioucmd, issue_flags);
+		if (ret < 0)
+			return ret;
+		ret = blk_rq_map_user_iov(q, req, NULL, &iter, gfp_mask);
+	} else {
+		ret = blk_rq_map_user(q, req, NULL, uptr64(buf_addr),
+				      buf_len, gfp_mask);
+	}
+
+	return ret;
+}
+
 int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
 		       unsigned int issue_flags, bool open_for_write)
 {
-	return -EOPNOTSUPP;
+	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	struct scsi_cmnd *scmd;
+	struct request *req;
+	blk_mq_req_flags_t blk_flags = 0;
+	gfp_t gfp_mask = GFP_KERNEL;
+	int ret = 0;
+
+	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
+	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
+		return -EINVAL;
+
+	if (cmd->cdb_len == 0 || cmd->cdb_len > 32)
+		return -EINVAL;
+
+	if (!cmd->cdb_addr)
+		return -EINVAL;
+
+	if (cmd->dout_xfer_len && cmd->din_xfer_len)
+		return -EOPNOTSUPP;
+
+	if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
+		return -EOPNOTSUPP;
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		blk_flags = BLK_MQ_REQ_NOWAIT;
+		gfp_mask = GFP_NOWAIT;
+	}
+
+	req = scsi_alloc_request(q, cmd->dout_xfer_len ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = cmd->cdb_len;
+	scmd->allowed = SG_DEFAULT_RETRIES;
+
+	if (copy_from_user(scmd->cmnd, uptr64(cmd->cdb_addr), cmd->cdb_len)) {
+		ret = -EFAULT;
+		goto out_free_req;
+	}
+
+	if (!scsi_cmd_allowed(scmd->cmnd, open_for_write)) {
+		ret = -EPERM;
+		goto out_free_req;
+	}
+
+	pdu->sense_addr = cmd->sense_addr;
+	scmd->sense_len = cmd->sense_len ?
+		min(cmd->sense_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
+
+	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
+		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+		if (ret)
+			goto out_free_req;
+		pdu->bio = req->bio;
+	} else {
+		pdu->bio = NULL;
+	}
+
+	req->timeout = cmd->timeout_ms ?
+		msecs_to_jiffies(cmd->timeout_ms) : BLK_DEFAULT_SG_TIMEOUT;
+
+	req->end_io = scsi_bsg_uring_cmd_done;
+	req->end_io_data = ioucmd;
+	pdu->req = req;
+
+	blk_execute_rq_nowait(req, false);
+	return -EIOCBQUEUED;
+
+out_free_req:
+	blk_mq_free_request(req);
+	return ret;
 }
 
 static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
-- 
2.25.1


