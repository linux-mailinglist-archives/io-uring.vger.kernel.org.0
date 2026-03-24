Return-Path: <io-uring+bounces-12843-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +I90F7QNw2lKnwQAu9opvQ
	(envelope-from <io-uring+bounces-12843-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:18:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8979731D41D
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8A97E30435DA
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2BD3C6A49;
	Tue, 24 Mar 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qTAGvevF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E7D3C5DB2
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774390518; cv=none; b=u0tAyckQSe2bW/j0A+D0/Nu2V79mkQT1R6i7ALgG5q10H7qpgYr25z1PyXAsJDMR8Us3VAD+X81dIsG0mND9jR6BiWAF/dZC/3RqrEKq52hpOlbJySujHDE6J2n8bE5ruVDwhT08HzOwJucCqJCmvhEmw6xiULa+d84EpJA5LpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774390518; c=relaxed/simple;
	bh=jDHb0oGpKw2/p1FkZvgPZUE6Q4HwMySZmI7SPSkSP5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gben9JUYLSFBDUe8DSZ1pp4HF+2SZQQe1PFdMogcAAynN/ejcDVGb+kkEXakGkcNidROag59gpZyoVxMn1UOOAeP1KX1Wfq1g0BGuCJ7GNk+XFQ0m82VqMzI5zc+OfImJKPdQLi8AvLDtgMHRD8aJvdnis9VDz5oMtKwVD7zcUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qTAGvevF; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-359f35dfef6so2645472a91.2
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774390516; x=1774995316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzWwvdiHIAmz1WtEcS2GhJHgqbneIfEw6RWn0REYzQI=;
        b=qTAGvevFAsZpSAkdY5e0zMIP4MEqv1ZQHGxTSar+FfS1E2LcngH74DTYnbIhP5ifIO
         334nOWOb6yMdvxhyFc4oulC63I5pdCvYrhmiluyB83trRZ3my2Ojy5ovftoVybZPT3ke
         M8prg3a1B/6ULRTofrogP6SeWfc2N2JxykpEv9KEvm8ywQSt57c0VybWKyVQn0FHMp2V
         KDV0MXIVRefQfewCzUrzYFCilGsFJE+P0LBLiCqRKPAf94PhpM7PBygPn4b16430oCqs
         hYwjOT4a0e6FcJIS6YCHfWVrMP6qfZxVldTX0k4BDoDBfwhHTqIZbqQEIrrCBOaU4spE
         IfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390516; x=1774995316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qzWwvdiHIAmz1WtEcS2GhJHgqbneIfEw6RWn0REYzQI=;
        b=DMZ8sKxI4gGs1esKEI2/l2hx3U7O+rQcA19++K8/iKud4C9sJ/VeOTrBlGQQWDe4mO
         kg8zWoTS/Vi/nmnj28RmFGxgevu1HakuPczyT554JU6s7J3uGzW7fY1ifZwrhjFd7y/S
         LWCWuYisZ13z8n/yVV/YXi1PfMw1AxOdwR2QrzGW37CWm2h6/E21FWBBrM9hKx/wpm1I
         vRntpj1refXgFMXa4HmiUoZc4f58tnYyNCFE3K3L1pi7IXiU3mvQhh/9hzByzmqX3DS6
         00bMfSJcuDb9dc3/ZdqeHk3Ac/Krot8Cy03LVL3RBrKCGWN8vPiAWI73lxzGM8Zap6YN
         uElw==
X-Forwarded-Encrypted: i=1; AJvYcCVkyuSPUC8JIsBQOfs2U12Po2CCPmgK4Vxnno7IOcF8zFLGhCp9GCGp5omMZeOJ7y/1dfnc4sbgNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsLnltP6jrUktdtyM43tQtddhXYBkzkeKLUQCojG4eR9pkTBXT
	Db+4AkONENx5TUkf7WvKuwLwtZdCFH4DU8z7LMpZ7SxcEV2ozp4GnwB2UtpHTw==
X-Gm-Gg: ATEYQzyajpXjJGMb/jMgwdlo0VolZwmOI0gYBgH+hNHahXLExKe8TWj0vzv8GcJAyXZ
	u2qKULWNAh9yEpymTDEf3G+iryJItnMZtXnbuW/Mqvz1t9Yg7o/+XyNwfS+bA0ctLsZYgugyRsi
	jZt//sdUAM+OVLHL8+ksuIx/MAXpR5G/e0MyBjDukep7821wfF+B2p1ADiyutpFK5CEJ6OJoEwE
	LVU0V7sEAISvv9UJqg47IQvafMIFMhTkdQXRA/20fUPg9bjqPlqtPdmbATMZkwqSF6/KTcMiGbY
	L3809tt0yokKo7A98GM1JvlXTmn5r4tfs9qKR7YzwCM840wyXUbClS65c8ll+nBIDm377RQYPx7
	X+8UXdDoHDBwl9lCb39fGnUaRqL1rLaT0Ot6EMlsEjLv8ggz+KLYfdCC4CRY0WwB1E1skRwxtOV
	uI2zkaPrWbtEh2hrlWgA==
X-Received: by 2002:a17:90b:2ccc:b0:35b:e4d8:e21d with SMTP id 98e67ed59e1d1-35c0dc5ec71mr892138a91.2.1774390515736;
        Tue, 24 Mar 2026 15:15:15 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0dc2a2b4sm152741a91.1.2026.03.24.15.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 15:15:15 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v3 2/5] io_uring/rsrc: split io_buffer_register_request() logic
Date: Tue, 24 Mar 2026 15:14:23 -0700
Message-ID: <20260324221426.3436334-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324221426.3436334-1-joannelkoong@gmail.com>
References: <20260324221426.3436334-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12843-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 8979731D41D
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


