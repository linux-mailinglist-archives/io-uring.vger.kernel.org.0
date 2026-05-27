Return-Path: <io-uring+bounces-13535-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ML3WBJRDF2ov/AcAu9opvQ
	(envelope-from <io-uring+bounces-13535-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 21:18:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F3D5E971B
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 21:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5127A302D0FB
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 19:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B31636DA1D;
	Wed, 27 May 2026 19:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="EjRuH8fk"
X-Original-To: io-uring@vger.kernel.org
Received: from out-03.smtp.spacemail.com (out-03.smtp.spacemail.com [63.250.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A577634CFA7;
	Wed, 27 May 2026 19:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779909521; cv=none; b=BrsBLrZOr/jRGHWK5XKUXtNpMLkOb/1g1nvOKC1KGTvDUwzJQG8SzIeedBlw+HCjRRysdcdWUPKpuWqPSbXXxYVjHQXNy3dtfBa58Go26oQ189TrraA7lzyeGj2Xd6FcAebLxD4ug+/8K6FD+UwA77WKiZdgPONAOdsoBr2xNUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779909521; c=relaxed/simple;
	bh=kvGJAsELGXPJZk9NrIuTIvUOIwiNkTJ+kqt3GBsOj7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diDBvCMn4gyFdIIgCcLqgQSb0JTf5VlHt0ALdnbXWLJOjmzRweXl4xtqQ7P7FddvCl8ZA6vHCmYzzMPa75Oroszug+rfYaxcAAlljoNLx1vb6jo+BSqosvc4tUkS1ABB2QYDE0Y7cXoStzJwaFuXfS5+ZLIUD7wn7uVk8C6ewrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=EjRuH8fk reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Received: from Kyren (unknown [49.207.213.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4gQfXz1DXhz2x9B;
	Wed, 27 May 2026 19:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1779909511;
	bh=WIUEG4zzn5ErfYY0sg41nrfwYjNTMLRAi91DY7rABh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjRuH8fkN/sKcyDD/1ESBz24ZL4/qv+1gT0ShRF5ooMigtOU3T+TS5bg87K7LWW31
	 q4wndmGXchDtpI+kDbxzk7sgSc/Ifv7qnwhk3efvuFx4Z4PAikZ8c+wyPF2O6McaLY
	 vUw970HuKC4/t9V44aaBJ2O8D/w75ciTxru4Otu0XRK84bcZxmR0RzFWdfGFZKOnl1
	 7m319TvwdbM1y1w2FRTI6mC33sP2482hlnBNiFkZrluh+Iub4AwMxIiE/63FLgtuLR
	 MwVNt+F9kOrWMRP/lqUtT5ij7NT5dJAjAuksxh9IxmgXTTgwR6yHXr7z+0/z6BrlYo
	 V6TRvLdqQ/b+w==
From: Rahul Chandelkar <rc@rexion.ai>
To: rc@rexion.ai,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: bsg: read io_uring command fields once
Date: Thu, 28 May 2026 00:47:41 +0530
Message-ID: <20260527191817.142769-1-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527105931.3950913-1-rc@rexion.ai>
References: <20260527105931.3950913-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[rexion.ai];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_PERMFAIL(0.00)[rexion.ai:s=spacemail];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13535-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rc@rexion.ai,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.928];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[rexion.ai:~];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,rexion.ai:mid,rexion.ai:email]
X-Rspamd-Queue-Id: A2F3D5E971B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

scsi_bsg_uring_cmd() reads struct bsg_uring_cmd fields directly from the
shared mmap'd io_uring SQE.  On the inline execution path, io_uring may
still point at userspace-visible SQE storage, so a concurrent userspace
thread can change fields between validation and use.

request_len is checked against the size of scmd->cmnd, then used again for
scmd->cmd_len and copy_from_user().  If userspace changes request_len after
the bounds check, the later copy can overflow the 32-byte scmd->cmnd
buffer.  Transfer fields are also read again by scsi_bsg_map_user_buffer(),
leaving direction, address and length open to the same race.

Use READ_ONCE() to load each bsg_uring_cmd field needed by
scsi_bsg_uring_cmd() into a local variable, then use those locals for both
validation and execution.  Pass the stable transfer direction, address and
length into scsi_bsg_map_user_buffer() so the helper no longer re-derives
them from the SQE.

This fixes the double-fetch without copying the whole io_uring command
payload.

Tested with KASAN on QEMU (virtio-scsi, 2 vCPUs).  Without this fix, a
two-thread race produces:

  BUG: KASAN: wild-memory-access in scsi_queue_rq+0x4a3/0x58a0
  Write of size 96 at addr dead000000001000 by task poc/67
  Call Trace:
   kasan_report+0xce/0x100
   __asan_memset+0x23/0x50
   scsi_queue_rq+0x4a3/0x58a0
   scsi_bsg_uring_cmd+0x942/0x1570
   io_uring_cmd+0x2f6/0x950
   io_issue_sqe+0xe5/0x22d0

Link: https://lore.kernel.org/all/20260527105931.3950913-1-rc@rexion.ai/T/#u
Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
Changes in v2:
- Use READ_ONCE() for individual fields instead of memcpying the command
  payload.
- Pass stable transfer parameters to scsi_bsg_map_user_buffer() so it does
  not re-read the SQE.
- Do not carry the Reviewed-by tag from v1 because the implementation
  strategy changed.

 drivers/scsi/scsi_bsg.c | 54 ++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..ccbe3d98e4ff 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -76,12 +76,10 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
 static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
-				    unsigned int issue_flags, gfp_t gfp_mask)
+				    unsigned int issue_flags, gfp_t gfp_mask,
+				    bool is_write, u64 buf_addr,
+				    unsigned long buf_len)
 {
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
-	bool is_write = cmd->dout_xfer_len > 0;
-	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
-	unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
 	struct iov_iter iter;
 	int ret;
 
@@ -104,26 +102,40 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 			       unsigned int issue_flags, bool open_for_write)
 {
 	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
+	const struct bsg_uring_cmd *cmd =
+		io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags = 0;
 	gfp_t gfp_mask = GFP_KERNEL;
+	u64 request = READ_ONCE(cmd->request);
+	u32 request_len = READ_ONCE(cmd->request_len);
+	u32 protocol = READ_ONCE(cmd->protocol);
+	u32 subprotocol = READ_ONCE(cmd->subprotocol);
+	u32 max_response_len = READ_ONCE(cmd->max_response_len);
+	u64 response = READ_ONCE(cmd->response);
+	u64 dout_xferp = READ_ONCE(cmd->dout_xferp);
+	u32 dout_xfer_len = READ_ONCE(cmd->dout_xfer_len);
+	u32 dout_iovec_count = READ_ONCE(cmd->dout_iovec_count);
+	u64 din_xferp = READ_ONCE(cmd->din_xferp);
+	u32 din_xfer_len = READ_ONCE(cmd->din_xfer_len);
+	u32 din_iovec_count = READ_ONCE(cmd->din_iovec_count);
+	u32 timeout_ms = READ_ONCE(cmd->timeout_ms);
 	int ret;
 
-	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
-	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
+	if (protocol != BSG_PROTOCOL_SCSI ||
+	    subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
 		return -EINVAL;
 
-	if (!cmd->request || cmd->request_len == 0)
+	if (!request || request_len == 0)
 		return -EINVAL;
 
-	if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+	if (dout_xfer_len && din_xfer_len) {
 		pr_warn_once("BIDI support in bsg has been removed.\n");
 		return -EOPNOTSUPP;
 	}
 
-	if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
+	if (dout_iovec_count > 0 || din_iovec_count > 0)
 		return -EOPNOTSUPP;
 
 	if (issue_flags & IO_URING_F_NONBLOCK) {
@@ -131,20 +143,20 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		gfp_mask = GFP_NOWAIT;
 	}
 
-	req = scsi_alloc_request(q, cmd->dout_xfer_len ?
+	req = scsi_alloc_request(q, dout_xfer_len ?
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
 	scmd = blk_mq_rq_to_pdu(req);
-	if (cmd->request_len > sizeof(scmd->cmnd)) {
+	if (request_len > sizeof(scmd->cmnd)) {
 		ret = -EINVAL;
 		goto out_free_req;
 	}
-	scmd->cmd_len = cmd->request_len;
+	scmd->cmd_len = request_len;
 	scmd->allowed = SG_DEFAULT_RETRIES;
 
-	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
+	if (copy_from_user(scmd->cmnd, uptr64(request), request_len)) {
 		ret = -EFAULT;
 		goto out_free_req;
 	}
@@ -154,12 +166,18 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		goto out_free_req;
 	}
 
-	pdu->response_addr = cmd->response;
-	scmd->sense_len = cmd->max_response_len ?
-		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
+	pdu->response_addr = response;
+	scmd->sense_len = max_response_len ?
+		min(max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
 
-	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
-		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+	if (dout_xfer_len || din_xfer_len) {
+		bool is_write = dout_xfer_len > 0;
+		u64 buf_addr = is_write ? dout_xferp : din_xferp;
+		unsigned long buf_len = is_write ? dout_xfer_len : din_xfer_len;
+
+		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
+					       gfp_mask, is_write, buf_addr,
+					       buf_len);
 		if (ret)
 			goto out_free_req;
 		pdu->bio = req->bio;
@@ -167,8 +185,8 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		pdu->bio = NULL;
 	}
 
-	req->timeout = cmd->timeout_ms ?
-		msecs_to_jiffies(cmd->timeout_ms) : BLK_DEFAULT_SG_TIMEOUT;
+	req->timeout = timeout_ms ?
+		msecs_to_jiffies(timeout_ms) : BLK_DEFAULT_SG_TIMEOUT;
 
 	req->end_io = scsi_bsg_uring_cmd_done;
 	req->end_io_data = ioucmd;
-- 
2.54.0

