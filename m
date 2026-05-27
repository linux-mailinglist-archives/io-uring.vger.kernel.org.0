Return-Path: <io-uring+bounces-13519-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AXVOVnQFmowsgcAu9opvQ
	(envelope-from <io-uring+bounces-13519-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 13:07:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D3E5E314D
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 13:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D6203018D67
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 11:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E4A3F44E7;
	Wed, 27 May 2026 11:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="Rx2XAw4e"
X-Original-To: io-uring@vger.kernel.org
Received: from out-13.smtp.spacemail.com (out-13.smtp.spacemail.com [63.250.43.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B803914FF;
	Wed, 27 May 2026 11:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879905; cv=none; b=AqT1U21bsJ4tJ3nzWtywvqoLr2AVPBbJAbOQu/xJQFnGG6HBuwlURj/uoEvF0uDXUL5hSsSE2CJ2mIiq+OAwWg24eCpdbMAkZ3uI5HSGlPYIGZrbm9DkAwSIN0/9hUtIXOLwIysntL8fiLELAUa6pcMnmENfpAkUmwfqquw4Ggs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879905; c=relaxed/simple;
	bh=RFxwCps8BRo0X7Ta0ylRSygPBnYr60aPkBIthbUKDbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oy+ECP3p/dGb4t0Nj5cHbMf8tkvAMcKSccsWP+Yh9y0ownMl7YMyHvJDhimdXzHbIc05uXIukX46igCeg53iuOo0WW3zxCSslPFlrgN0115z3Q7oPBJM3c4YtnTQKQIVWa1eyZEvPt3hNyJ6Wp6NxNxXhMlI0TY4QGCuiN3getI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=Rx2XAw4e reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Received: from Kyren (unknown [49.207.213.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4gQRTS2sMkz8sWq;
	Wed, 27 May 2026 10:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1779879584;
	bh=DgDokx5pIAzNQ53sXah/UBDCt3R4wUhOvqyXIza65bI=;
	h=From:To:Cc:Subject:Date:From;
	b=Rx2XAw4eoq8Z2KPLh2pTGEvqZSYW4KJh8StEC5Wo5cla2t6eNVJDOKBrahImyNtr5
	 H89keCEG4V2JSzgSBJq7SHrgTnouVGVc9CP0DnRv9t1kGfZXGgtrQE6Xrst+1KgUqV
	 VYgv9kx+oYMmjP2ab6b+Fm6Q9MQ0ot3DGD9/WJbPDD9jzp0TJehelBPQOc3tbIhUqK
	 73huw5rtNvtzyQeHEWizESIsEG5oqxN7aY6Wf+4TJ1VzAVQpIStdHLIL622s9JhK2E
	 p0+rtVzXP9OWzH6x9S2No4F+xw9kRAeDp0EYk+crHk8Lkf2BbodzWYEwYiVz93mTki
	 hHh5i3fJ2zojQ==
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
	stable@vger.kernel.org
Subject: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch from shared SQE
Date: Wed, 27 May 2026 16:29:18 +0530
Message-ID: <20260527105931.3950913-1-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[rexion.ai];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_PERMFAIL(0.00)[rexion.ai:s=spacemail];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13519-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rc@rexion.ai,io-uring@vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.983];
	DKIM_TRACE(0.00)[rexion.ai:~];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,rexion.ai:mid,rexion.ai:email]
X-Rspamd-Queue-Id: 45D3E5E314D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

scsi_bsg_uring_cmd() and scsi_bsg_map_user_buffer() read bsg_uring_cmd
fields directly from the shared mmap'd io_uring submission ring via
io_uring_sqe128_cmd().  On the inline execution path, io_uring has not
yet copied the SQE to kernel memory, so a concurrent userspace thread
can modify fields between reads.

cmd->request_len is read for the bounds check, for the cmd_len
assignment, and for the copy_from_user length.  A racing thread can
change request_len between the bounds check (passes with <= 32) and
copy_from_user (uses the enlarged value), overflowing the 32-byte
scmd->cmnd[] buffer into subsequent struct scsi_cmnd fields.

scsi_bsg_map_user_buffer() independently re-derives its cmd pointer
from the same shared SQE, re-reading dout_xfer_len, din_xfer_len,
dout_xferp, and din_xferp, enabling direction confusion and buffer
length races.

Copy struct bsg_uring_cmd to a stack-local variable before use in both
functions.  The pointer variable 'cmd' is redirected to the local copy
so the rest of each function is unchanged.

Tested with KASAN on QEMU (virtio-scsi, 2 vCPUs).  Without this fix,
a two-thread race produces:

  BUG: KASAN: wild-memory-access in scsi_queue_rq+0x4a3/0x58a0
  Write of size 96 at addr dead000000001000 by task poc/67
  Call Trace:
   kasan_report+0xce/0x100
   __asan_memset+0x23/0x50
   scsi_queue_rq+0x4a3/0x58a0
   scsi_bsg_uring_cmd+0x942/0x1570
   io_uring_cmd+0x2f6/0x950
   io_issue_sqe+0xe5/0x22d0

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 drivers/scsi/scsi_bsg.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..244740655eb0 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -78,13 +78,21 @@ static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
 				    unsigned int issue_flags, gfp_t gfp_mask)
 {
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
-	bool is_write = cmd->dout_xfer_len > 0;
-	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
-	unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
+	struct bsg_uring_cmd local_cmd;
+	const struct bsg_uring_cmd *cmd;
+	bool is_write;
+	u64 buf_addr;
+	unsigned long buf_len;
 	struct iov_iter iter;
 	int ret;
 
+	memcpy(&local_cmd, io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd),
+	       sizeof(local_cmd));
+	cmd = &local_cmd;
+	is_write = cmd->dout_xfer_len > 0;
+	buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
+	buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
+
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		ret = io_uring_cmd_import_fixed(buf_addr, buf_len,
 						is_write ? WRITE : READ,
@@ -104,13 +112,18 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 			       unsigned int issue_flags, bool open_for_write)
 {
 	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
+	struct bsg_uring_cmd local_cmd;
+	const struct bsg_uring_cmd *cmd;
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags = 0;
 	gfp_t gfp_mask = GFP_KERNEL;
 	int ret;
 
+	memcpy(&local_cmd, io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd),
+	       sizeof(local_cmd));
+	cmd = &local_cmd;
+
 	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
 	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
 		return -EINVAL;
-- 
2.54.0


