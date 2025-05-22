Return-Path: <io-uring+bounces-8085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7240AC0FD5
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 270837B4F88
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A74B2980CF;
	Thu, 22 May 2025 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fEhnw54A"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21701C4609
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747927268; cv=none; b=DeYMzt3vHP/GB1xYIU6jgEiAljbSgqWhv1R4pJUoVyJrTDJFZKvZbVpfc0MjHwusDiO8IBuGZJPR6ib+tjRRNifleFSxDXzQ+lgq0BzGPFbRM9OH5z/zWDdLRIor8ura5d3xo2gDx9NvIIkTmW9J564p1C7Yqf4DfJTFmB1NNRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747927268; c=relaxed/simple;
	bh=aWQCXI1NGkyeO5ue23iMg7ZP85AURBXDP3Fnnf7VRVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDYRwuySln1HPYjmnMF7bedKjptLTurpyMHY3PO/ITlL4KGa8gplmY8UcbnUAVWqNWF7FltjtywtJOHaRDxTCHpvAfnPX67quuPgfg35u4CC0IGduNrh5gtg4m5n+jbKWPpSShSEtAT/Nl6VpWk+qjnUrSdG76W/hPr4GbRTIGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fEhnw54A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747927265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fFALPIP5B+t0FmBVc3PALdYccUk+3VBMy6MqapTrKoU=;
	b=fEhnw54AitxU8Y/5rxzfLSim385ZBYq9iJkIe2IKuJBU28L1/kSdkoEYoo2a6oBoiwl2oK
	YRu5UcmzI7MRDuLEDefBeIxDmxhwpkDz3wm6P4rVp58bQordKJK70TQKcGQpA61DxpQWqX
	R7Jgeh0tTSRKZI4VLyO/7jntZ82CzTU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632--oqvYgG2Or6vmaEX1TkPyA-1; Thu,
 22 May 2025 11:21:00 -0400
X-MC-Unique: -oqvYgG2Or6vmaEX1TkPyA-1
X-Mimecast-MFC-AGG-ID: -oqvYgG2Or6vmaEX1TkPyA_1747927259
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11B751955DB5;
	Thu, 22 May 2025 15:20:59 +0000 (UTC)
Received: from localhost (unknown [10.72.116.39])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1085F195608F;
	Thu, 22 May 2025 15:20:57 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/2] ublk: run auto buf unregisgering in same io_ring_ctx with registering
Date: Thu, 22 May 2025 23:20:40 +0800
Message-ID: <20250522152043.399824-3-ming.lei@redhat.com>
In-Reply-To: <20250522152043.399824-1-ming.lei@redhat.com>
References: <20250522152043.399824-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

UBLK_F_AUTO_BUF_REG requires that the buffer registered automatically
is unregistered in same `io_ring_ctx`, so check it explicitly.

Document this requirement for UBLK_F_AUTO_BUF_REG.

Drop WARN_ON_ONCE() which is triggered from userspace code path.

Fixes: 99c1e4eb6a3f ("ublk: register buffer to local io_uring with provided buf index via UBLK_F_AUTO_BUF_REG")
Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 19 ++++++++++++++++---
 include/uapi/linux/ublk_cmd.h |  6 +++++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index fcf568b89370..f44ac5526edd 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -84,6 +84,7 @@ struct ublk_rq_data {
 
 	/* for auto-unregister buffer in case of UBLK_F_AUTO_BUF_REG */
 	u16 buf_index;
+	void *buf_ctx_handle;
 };
 
 struct ublk_uring_cmd_pdu {
@@ -1211,6 +1212,8 @@ static bool ublk_auto_buf_reg(struct request *req, struct ublk_io *io,
 	}
 	/* one extra reference is dropped by ublk_io_release */
 	refcount_set(&data->ref, 2);
+
+	data->buf_ctx_handle = io_uring_cmd_ctx_handle(io->cmd);
 	/* store buffer index in request payload */
 	data->buf_index = pdu->buf.index;
 	io->flags |= UBLK_IO_FLAG_AUTO_BUF_REG;
@@ -2111,12 +2114,22 @@ static int ublk_commit_and_fetch(const struct ublk_queue *ubq,
 	if (ublk_support_auto_buf_reg(ubq)) {
 		int ret;
 
+		/*
+		 * `UBLK_F_AUTO_BUF_REG` only works iff `UBLK_IO_FETCH_REQ`
+		 * and `UBLK_IO_COMMIT_AND_FETCH_REQ` are issued from same
+		 * `io_ring_ctx`.
+		 *
+		 * If this uring_cmd's io_ring_ctx isn't same with the
+		 * one for registering the buffer, it is ublk server's
+		 * responsibility for unregistering the buffer, otherwise
+		 * this ublk request gets stuck.
+		 */
 		if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG) {
 			struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
 
-			WARN_ON_ONCE(io_buffer_unregister_bvec(cmd,
-						data->buf_index,
-						issue_flags));
+			if (data->buf_ctx_handle == io_uring_cmd_ctx_handle(cmd))
+				io_buffer_unregister_bvec(cmd, data->buf_index,
+						issue_flags);
 			io->flags &= ~UBLK_IO_FLAG_AUTO_BUF_REG;
 		}
 
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index c4b9942697fc..1c40632cb164 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -226,7 +226,11 @@
  *
  * For using this feature:
  *
- * - ublk server has to create sparse buffer table
+ * - ublk server has to create sparse buffer table on the same `io_ring_ctx`
+ *   for issuing `UBLK_IO_FETCH_REQ` and `UBLK_IO_COMMIT_AND_FETCH_REQ`.
+ *   If uring_cmd isn't issued on same `io_ring_ctx`, it is ublk server's
+ *   responsibility to unregister the buffer by issuing `IO_UNREGISTER_IO_BUF`
+ *   manually, otherwise this ublk request won't complete.
  *
  * - ublk server passes auto buf register data via uring_cmd's sqe->addr,
  *   `struct ublk_auto_buf_reg` is populated from sqe->addr, please see
-- 
2.47.0


