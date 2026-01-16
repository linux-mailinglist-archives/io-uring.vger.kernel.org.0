Return-Path: <io-uring+bounces-11754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A84D2B609
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 05:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AAAA4306AE69
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 04:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D496345CA2;
	Fri, 16 Jan 2026 04:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lhLNO3sL"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D74434677D;
	Fri, 16 Jan 2026 04:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537577; cv=none; b=Ol8OP50LE4tnQWs3B4bNleUJP+5PIAjnZS24WVQYeDIf/XGiChqcG+LJT7P0fp1iJPSKekExhpduMpdXQxWzQo5UrezJ4kPTgRYXPTMldZVg1Ss3VbDk2Er/vnl4WLjlt90ZYBcB18I1Ieop6jmBv7/r/9RxAS4Ck8xy/LuYEwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537577; c=relaxed/simple;
	bh=p2klTd/Srh5gH2Xh7Rno/RBEd+lVDjqS3EDK5WfVNDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+jV1aL8mushJBUn/Yq08nTVn1rKo3tqb1aRjb9RPTad7KA9Fgm/BSNzwjDqm5QGDCfUQMyk10WBgdBPoz5hM26ljCDUFU1/CF97Og+b+5W6cFXZX51ulXYD8LuefzVr9a8m2XQYj+I7gnGSgL3dYwCvHu3lQiZG/EY66JRVXco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lhLNO3sL; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Lx
	yDPk1hXh19rMvoybSygn47Iohr/8l7TjD3ZG7c+6U=; b=lhLNO3sLwamVvWophh
	KWG1YvEutpZ+DpRbq1crukNNQwxK3fMHPTD8kj9eJ77Fux8NoIS442WyH99IHiKN
	4aRrC07Z+dRkg4i/4pfqb/x+ob/vNDvOZNG30COk2hWRXuoaWxadoOvexUtsFPiP
	mwBNZgAZMjF73xfOc7HMXUKy0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAXCLKuvWlpM1mcFw--.2330S5;
	Fri, 16 Jan 2026 12:25:24 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH v3 3/3] bsg: implement SCSI BSG uring_cmd handler
Date: Fri, 16 Jan 2026 12:25:16 +0800
Message-Id: <c61a760024aec963add4f0e36e26bb5190756eb5.1768536312.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1768536312.git.yangxiuwei@kylinos.cn>
References: <cover.1768536312.git.yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXCLKuvWlpM1mcFw--.2330S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr1DJF4kurWUKw43Kw13twb_yoW3JF1DpF
	W5tw4YvrW5Wr4I9F93JrWDuFyYqws5ua47KFW3uw4fCr1UCr9I93W0kF10qF1fXrWkA342
	qF4vyFZ8CFyjq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jcjjDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hRR4WlpvbSnOAAA3Y

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
---
 drivers/scsi/scsi_bsg.c | 187 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 186 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 4399a25990fc..3a45a597855a 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -10,10 +10,195 @@
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
+/*
+ * BSG io_uring PDU structure overlaying io_uring_cmd.pdu[32].
+ * Stores temporary data needed during command execution.
+ */
+struct scsi_bsg_uring_cmd_pdu {
+	struct bio *bio;		/* mapped user buffer, unmap in task work */
+	struct request *req;		/* block request, freed in task work */
+	u64 response_addr;		/* user space response buffer address */
+	u32 resid_len;			/* residual transfer length */
+	/* Protocol-specific status fields using union for extensibility */
+	union {
+		struct {
+			u8 device_status;	/* SCSI device status (low 8 bits of result) */
+			u8 driver_status;	/* SCSI driver status (DRIVER_SENSE if check) */
+			u8 host_status;		/* SCSI host status (host_byte of result) */
+			u8 sense_len_wr;	/* actual sense data length written */
+		} scsi;
+		/* Future protocols can add their own status layouts here */
+	};
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
+ *   16-23: host_status
+ *   24-31: sense_len_wr
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
+	/* Build res2 with status information */
+	res2 = ((u64)pdu->resid_len << 32) |
+	       ((u64)(pdu->scsi.sense_len_wr & 0xff) << 24) |
+	       ((u64)(pdu->scsi.host_status & 0xff) << 16) |
+	       ((u64)(pdu->scsi.driver_status & 0xff) << 8) |
+	       (pdu->scsi.device_status & 0xff);
+
+	if (pdu->scsi.sense_len_wr && pdu->response_addr) {
+		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,
+				 pdu->scsi.sense_len_wr))
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
+	/* Pack SCSI status fields into union */
+	pdu->scsi.device_status = scmd->result & 0xff;
+	pdu->scsi.host_status = host_byte(scmd->result);
+	pdu->scsi.driver_status = 0;
+	pdu->scsi.sense_len_wr = 0;
+
+	if (scsi_status_is_check_condition(scmd->result)) {
+		pdu->scsi.driver_status = DRIVER_SENSE;
+		if (pdu->response_addr)
+			pdu->scsi.sense_len_wr = min_t(u8, scmd->sense_len, SCSI_SENSE_BUFFERSIZE);
+	}
+
+	pdu->resid_len = scmd->resid_len;
+
+	io_uring_cmd_do_in_task_lazy(ioucmd, scsi_bsg_uring_task_cb);
+	return RQ_END_IO_NONE;
+}
+
+static int scsi_bsg_map_user_buffer(struct request *req,
+				    struct io_uring_cmd *ioucmd,
+				    unsigned int issue_flags, gfp_t gfp_mask)
+{
+	const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
+	struct iov_iter iter;
+	bool is_write = cmd->dout_xfer_len > 0;
+	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
+	unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
+	int ret;
+
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		ret = io_uring_cmd_import_fixed(buf_addr, buf_len,
+						is_write ? WRITE : READ,
+						&iter, ioucmd, issue_flags);
+		if (ret < 0)
+			return ret;
+		ret = blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
+	} else {
+		ret = blk_rq_map_user(req->q, req, NULL, uptr64(buf_addr),
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
+	scmd->cmd_len = cmd->request_len;
+	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
+		ret = -EINVAL;
+		goto out_free_req;
+	}
+	scmd->allowed = SG_DEFAULT_RETRIES;
+
+	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
+		ret = -EFAULT;
+		goto out_free_req;
+	}
+
+	if (!scsi_cmd_allowed(scmd->cmnd, open_for_write)) {
+		ret = -EPERM;
+		goto out_free_req;
+	}
+
+	pdu->response_addr = cmd->response;
+	scmd->sense_len = cmd->max_response_len ?
+		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
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


