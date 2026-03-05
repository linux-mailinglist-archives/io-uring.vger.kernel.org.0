Return-Path: <io-uring+bounces-12559-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qF1ZFEXdqGnGxwAAu9opvQ
	(envelope-from <io-uring+bounces-12559-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 02:32:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7585209DC5
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 02:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07C7F3078171
	for <lists+io-uring@lfdr.de>; Thu,  5 Mar 2026 01:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD20273F9;
	Thu,  5 Mar 2026 01:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Pjzy+3gB"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5A91BBBE5;
	Thu,  5 Mar 2026 01:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674211; cv=none; b=b+Un4PtfaS3nDu0cuNVhPv10VUrG/s0Ne1Y9ya2y5nJBTyQiHFAykP8tSrtHAfN/hr5N3kGZq6atEDOx/OQ8YDXt4syT/f7KWT91H7V8mf5MARpuHD80pwZ7MmfJKXAAfLZBBxgUgpXi4jWcnrelZWByYXRhva+6nJIPgmrU0Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674211; c=relaxed/simple;
	bh=7h7iAgaehaGowJLub2iWzs5bBaTqpodKb57T5p22y/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZaWS2ECl385rIg8QiaNfCFLHIL+Q92SCnrFDb4mYA97daqFqY5ZsGVuFOePQ5lEiHACB63Thew7rraXHHkHvSPmHXvQzqsCukPk8i0X+U73K+rz/VRmJE3dvNcSsk8Fw1MzC7QobahMsh8UEEAiFPEbmXxMQnEMB8A848vEFapY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Pjzy+3gB; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=iV
	IzEj15OBqZg8q5GF/ie6nbLyMrr9zGDb0IgIwmMms=; b=Pjzy+3gBWSsAJ3fzlt
	izGQ8Stp1cV2XljPUYcGfmgr54zgxc8yDOSit12XtMws2PHqeiXC71ytikoViTz3
	FbiU6CFNppXHWj/iwh1PaH3J6LCzH2TzYuq3SxcfDeFwHOqtcQYEfyw43WhT+dXC
	+eI/f1Hpw4y+ReV9BkY8Pd/N0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wBXMO9b3Khp6W63OA--.24976S5;
	Thu, 05 Mar 2026 09:29:07 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v6 3/3] scsi: bsg: add io_uring passthrough handler
Date: Thu,  5 Mar 2026 09:28:57 +0800
Message-Id: <20260305012857.2136525-4-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXMO9b3Khp6W63OA--.24976S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3GrWfGrWrXr18urW3Zr13urg_yoW3JF48pF
	W5tw4YvrW5Wr4I9FZayrZ8CFyYqws5Ca47KFW3uw4fGr1UCr9a93W8KF10qF1fArWkAa47
	XF4vqFW5CFyqq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jceOJUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QPTZGmo3GOYRAAA3-
X-Rspamd-Queue-Id: B7585209DC5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12559-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kylinos.cn:mid,kylinos.cn:email]
X-Rspamd-Action: no action

Implement the SCSI-specific io_uring command handler for BSG using
struct bsg_uring_cmd.

The handler builds a SCSI request from the io_uring command, maps user
buffers (including fixed buffers), and completes asynchronously via a
request end_io callback and task_work. Completion returns a 32-bit
status and packed residual/sense information via CQE res and res2, and
supports IO_URING_F_NONBLOCK.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 199 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 198 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 4d57e524e141..5b6ed15b8b19 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -10,10 +10,207 @@
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
+/*
+ * Per-command BSG SCSI PDU stored in io_uring_cmd.pdu[32].
+ * Holds temporary state between submission, completion and task_work.
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
+static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
+						  blk_status_t status,
+						  const struct io_comp_batch *iocb)
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
+	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
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
 static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
 			       unsigned int issue_flags, bool open_for_write)
 {
-	return -EOPNOTSUPP;
+	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
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
+	if (!cmd->request || cmd->request_len == 0)
+		return -EINVAL;
+
+	if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+		pr_warn_once("BIDI support in bsg has been removed.\n");
+		return -EOPNOTSUPP;
+	}
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


