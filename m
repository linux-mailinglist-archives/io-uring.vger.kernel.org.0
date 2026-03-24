Return-Path: <io-uring+bounces-12814-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4CmYDb/XwWkaXQQAu9opvQ
	(envelope-from <io-uring+bounces-12814-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:15:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C74B02FF760
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56BC83079AE9
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 00:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B252940D;
	Tue, 24 Mar 2026 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KE037bwI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FA42745C
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 00:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774311020; cv=none; b=u6QisPOR60vT/LfOwYEci5yFE3PhG5pJEqIL3EXqs1yO6RCmQ3ltjD4YTKfO7g8xKOlE5YM7L1JJIjLLR7/7WUBXajUAqFJkzNGnazDyB1wxDIDskqO3c7VJh1ucnnq8IdNPcX8Ci6zLxerTBTisbCaGEO7pQGY8LRkninjPK6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774311020; c=relaxed/simple;
	bh=ydC2rc58/W2m/2IBMybC5fKEp2w5BNGMW8teOhwyH28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icpHnv4C8GpXNx9TjT9awhJ2Y7laPwzlbQM1zXBirpgQWxRXvCnFGPpDOHmPv5gzAcyfcB8P8n3H8uCMuPZ6xwslmR8pv6qgDU+14na9APTxPHIL74VY5ZDw9Uxx19ghbPUPCBjy83popc62zHZpa0zLWntfb3Zn6pJomnFm80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KE037bwI; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2aaf43014d0so31987945ad.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 17:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774311018; x=1774915818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yau55id+uVBW1b/vau3Ejdk+fKsjwLTXFTw57nQSTT0=;
        b=KE037bwIj4Rl7GT30qUp77sB1AfAcw1paCl3GXC6Fz1byjA3ZjWVCmqVcuEVKpDDtD
         HHBU1xImJX6P7LeRQRd/Izinylcf8UnLQOkfyXWK3mjIwF9brVJ3BtnqxDqam2ZIoTsy
         rDWfO9zL2hVy1gNgDnQgfH/SNX22ngknYZbIvuZp6M/0yB0s8nWs+AXLhLIuSrLCB5A8
         +VsyyT9TcLkZXSgTeRBqhrlBBd5MtAOPwV8x7+gLH8PU7stZlmq4L2Xl2Ksv6fTTlRPI
         5kbRTigkcs/LauUBuPtiMFZO/kkUkTLL9N3gVR/6Fp8dppfbeQvsVc+djqQv7R3iHHka
         xwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774311018; x=1774915818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yau55id+uVBW1b/vau3Ejdk+fKsjwLTXFTw57nQSTT0=;
        b=glDAYAhkeGHSYVPsxJlo50iXZ4gFm67qaTIH0OVboG5WxtZJQf9UL3TGl8bF8Izc6K
         Oq+nwyRVfQ28WJshHsgASlmK2qcOHbrcpweJK4eIpLOGGrsGt3chPA+hV+jCaDzaNqR4
         srAISsX9pcE68k85+m3wY46GWVmqiNFnRKkQVoMh5lDZOGGvhkDu94EzXWi+WwC5aeOf
         MyhjzGvwzt7PQUB1s+cbOQ+8KkEodtMB9jY9um63l10uDaBn7MFMlYhcjollLC+ekrX3
         W9dbDlnVlX35RxtDdr08XQ5jZcP6m/7aOIjjkYmBpEckWsWOF6mCn4G/bCMqr8nNInAT
         Rp0w==
X-Forwarded-Encrypted: i=1; AJvYcCVRdOjfe9TPL7TbmD7FbSbbB4VPMNhvDe8gwLMpdZtHxtfh/D3Tkh148JWjfMjWqTnLxmqShvzt8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjeBSSopny6ig+MBmamwcSFUT+yYDlBsdZxpvaGkYT1AkBFhXP
	YYBWIoWBMNP70XjiMtsAUC141pEQ7Fi9id7eTa4nh1gfxXBkzk6AeVhu
X-Gm-Gg: ATEYQzxn+Tio32pTggwYr5/Jm1Knl5GRwsM3QPq8RFgw7Uki7XCXCa2k4gA0218mtzv
	ETqflzOIGy12YiqVCxPkBqB4xPCaTet3wOjlNGgtJkuc6euJ/Umm0mRMuI9mOhsX4iyfeusiHCu
	UnooBT0rUWl7ooArkqzbYYDZULp45wdVTb0zsJdtwTQAaJXGA+olLpO6k0qDWGQ+L5qc5uYY1Jv
	UBBsQKEcz9jzfCBUbKggYup9CFkvle59Y89DOy9HJ35EVI06NqfRynuKRMb8CloM4uDnM+l/GEK
	96rxeRQmnPpf824a70YPm1Kkt+jBywdqPBdbciwjJzbJl5hEaM7aHkRsDdVkvDYFSH6IGpgaAGX
	ESyyfvSNhVGVi+AlE7RCMgLdEyyNiKeos8nUUDNHMuY95whcoII21axQ+toZkk67Kju8KANYehX
	vJJaqrpkSzZ2SEIEX7wQ==
X-Received: by 2002:a17:903:22d1:b0:2b0:6e8f:8e85 with SMTP id d9443c01a7336-2b0826d73e8mr140576335ad.5.1774311018176;
        Mon, 23 Mar 2026 17:10:18 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655718sm125835835ad.39.2026.03.23.17.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:10:17 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1 2/5] io_uring/rsrc: split io_buffer_register_request() logic
Date: Mon, 23 Mar 2026 17:10:04 -0700
Message-ID: <20260324001007.1144471-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324001007.1144471-1-joannelkoong@gmail.com>
References: <20260324001007.1144471-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12814-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C74B02FF760
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Split the main initialization logic in io_buffer_register_request() into
a helper function.

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which will be reusing this logic.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 84 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 33 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7579f6992a25..1902ab7941ac 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -924,64 +924,82 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
-			       void (*release)(void *), unsigned int index,
-			       unsigned int issue_flags)
+static struct io_mapped_ubuf *io_kernel_buffer_init(struct io_ring_ctx *ctx,
+						    unsigned int nr_bvecs,
+						    unsigned int total_bytes,
+						    u8 dir,
+						    void (*release)(void *),
+						    void *priv,
+						    unsigned int index)
 {
-	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
-	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
-	struct bio_vec bv;
-	unsigned int nr_bvecs = 0;
-	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	if (index >= data->nr) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (index >= data->nr)
+		return ERR_PTR(-EINVAL);
 	index = array_index_nospec(index, data->nr);
 
-	if (data->nodes[index]) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	if (data->nodes[index])
+		return ERR_PTR(-EBUSY);
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
-	if (!node) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!node)
+		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
-	 * but avoids needing to iterate over the bvecs
-	 */
-	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
+	imu = io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
-		ret = -ENOMEM;
-		goto unlock;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	imu->ubuf = 0;
-	imu->len = blk_rq_bytes(rq);
+	imu->len = total_bytes;
 	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
+	imu->nr_bvecs = nr_bvecs;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
-	imu->priv = rq;
+	imu->priv = priv;
+	imu->dir = 1 << dir;
 	imu->flags = IO_REGBUF_F_KBUF;
-	imu->dir = 1 << rq_data_dir(rq);
 
+	node->buf = imu;
+	data->nodes[index] = node;
+
+	return imu;
+}
+
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct req_iterator rq_iter;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec bv;
+	/*
+	 * blk_rq_nr_phys_segments() may overestimate the number of bvecs
+	 * but avoids needing to iterate over the bvecs
+	 */
+	unsigned int nr_bvecs = blk_rq_nr_phys_segments(rq);
+	unsigned int total_bytes = blk_rq_bytes(rq);
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, rq_data_dir(rq),
+				    release, rq, index);
+	if (IS_ERR(imu)) {
+		ret = PTR_ERR(imu);
+		goto unlock;
+	}
+
+	nr_bvecs = 0;
 	rq_for_each_bvec(bv, rq, rq_iter)
 		imu->bvec[nr_bvecs++] = bv;
 	imu->nr_bvecs = nr_bvecs;
 
-	node->buf = imu;
-	data->nodes[index] = node;
 unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
-- 
2.52.0


