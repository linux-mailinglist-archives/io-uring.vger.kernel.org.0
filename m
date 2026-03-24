Return-Path: <io-uring+bounces-12836-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yGuwKiHXwmllmgQAu9opvQ
	(envelope-from <io-uring+bounces-12836-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:25:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B8B31AC8B
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DB3A43016B0A
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 18:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765FE396566;
	Tue, 24 Mar 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rsJ5A37A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2273F3A382A
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376543; cv=none; b=X7kDGRF379G3vK1AwaODBLCTuMstYn+rcNIYniucPb9ZHwL4nnI1mXP+7lbJmGohWXRi3BWAbCwik9IhIGlkhQVjXSeRYAzvimTpYR/jujXL9ZXAAI/DejATtpBAdaFPBhzsVG2HzomDyhjM90/AJqHGWB2vmmHfMRFDYzMT3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376543; c=relaxed/simple;
	bh=jDHb0oGpKw2/p1FkZvgPZUE6Q4HwMySZmI7SPSkSP5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sclJT45FBGu0pn9gzayzLR0q6c/yPUnM7UJBsvatMOv9+Kvkq0kfj4C+6mnnNbIfpWa/sMqxDN8ZvDekGhnHQjRFxsV2fbmkqFQ5E84fxJDn3dr6ILRGQfGavVw2rFc1ZBki6yokVHQzdOCO3+rdGfKVZbDybY2+HA8MugPOVYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rsJ5A37A; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-356337f058aso3249404a91.2
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 11:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774376541; x=1774981341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzWwvdiHIAmz1WtEcS2GhJHgqbneIfEw6RWn0REYzQI=;
        b=rsJ5A37A4wYAdxAvlRTna48TXppiy7nbYpUV3NeCMPzIeGxg0lx3xhDXdAY29skQrC
         R5nGD7Mwjer/ZGnrB+t7zCW0yBdz9HrmeVS3XBXQdulhTUfFba3kSv0DmYLgPE+2kS+A
         4Ol9Fw8nrMAMB4mMtX4ARgZ0Tft58PqXG5c/EjQeoiavZqUEdff9ngRztXzIq+nNfWZU
         3m/HB8G2dCmlErq5yvbN8P66zqFbsfJNtQka9EuyG9rbJbeAKKBlNI3Vi1/4r+dkHiUI
         Ohdbk7/gfnx18hx7AvCk1UaFWW8VLMac41n3ogmPMuFZnA/TL7VRrJBWM/md76QZacGA
         qNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774376541; x=1774981341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qzWwvdiHIAmz1WtEcS2GhJHgqbneIfEw6RWn0REYzQI=;
        b=heMHVhy4u/bQRDFGIN99yoarKXiLgGLZl2Ov2zroYRTdqIxq9+KJDFQ++zCoQIt+/7
         H74SiRC7LnYsNrDp+NVOkxaxcKjMrDjeJlTpNi/xfSH/R41VhF5OSJeZpRuO3fWltr5V
         6Y4L2VwuSZWwqyQCFZnlDo8hcv+K75GC470y2gut5j6cp23BLAa7x5UX87va70LsAxew
         4OT/bBxwoGrw5Qu0/Ta+BC+BdDhYk6sB0rPoTeYsvX1gEJipojmqtYwCqAbGTC4/cL0t
         KbyJvbTB8cD2cGOfVTIHtv9MvAFQY36Strvk6YCBdgxvfhzANwY7iC/rwOjlUo/vhQxK
         LgIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVM0YNQmDhUVsUYkoBiz3dxBCPd2xMsOvGaHxBC/A68Z8e4O6er+D2zz38ItaKhC+qgya9BuJxCtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyupFHZwc+fVjypVLaX1X07of1KMEr/fd6nX5p+32XbxdOBpHMD
	KfWGxUE6wLgiQSpBiVNakiiXWgBdpxuecRRisRhf5Zp99sRd6M2CypES
X-Gm-Gg: ATEYQzyn6mSOFhmpYBAfiZJsOIhxZb/iBAutovNiG91jS2WwdxXImZ0ZW2cVMunushc
	IW5Le+5nUoNuxuABeDWI+2x+cPJSuv/zz8HVAIqPiWHwlrIb/KRSmZH0KqlEKcENMbsRr+Je59V
	aonjVkiFLHPOh92IbNWf/g1Koxm53HhGVK9ADyAtBDnxl0Ufb5u+KnBpO+5jGehmtdJzdj5C0mJ
	LErWR5rLEcqQrhesSeQhOLrm0Uf2Egobaw/bEVfs2bBDCabziLqBtarlcfuMKfaQ1+jXLmQQ3y/
	hEn+T7cVENSz4bgA6JZAfRDBT4WyV8oJKsIQaE6LWPibvEhrTlwCT/UlZAmznPOPV4TtxFGWOT4
	atDfI/oy/eoB1V2awrx3w7ouR8EYORKhF5A3GcoSUhVkLA3E1ILmienhIAM0RkXM2mXPbHpYOC6
	hSE0dEoD4jZPjTIxr/8w==
X-Received: by 2002:a17:90a:dfc8:b0:35a:24f3:2c88 with SMTP id 98e67ed59e1d1-35c0dca9cc1mr337201a91.8.1774376541202;
        Tue, 24 Mar 2026 11:22:21 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c031354f3sm3567860a91.6.2026.03.24.11.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:22:20 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v2 2/5] io_uring/rsrc: split io_buffer_register_request() logic
Date: Tue, 24 Mar 2026 11:21:54 -0700
Message-ID: <20260324182157.990864-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324182157.990864-1-joannelkoong@gmail.com>
References: <20260324182157.990864-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12836-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B3B8B31AC8B
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
index 7579f6992a25..01c3619e5f07 100644
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
+	imu->dir = dir;
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
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes,
+				    1 << rq_data_dir(rq), release, rq, index);
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


