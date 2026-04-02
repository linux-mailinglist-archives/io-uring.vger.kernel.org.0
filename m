Return-Path: <io-uring+bounces-12939-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4At4KN6WzmkBowYAu9opvQ
	(envelope-from <io-uring+bounces-12939-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 18:18:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9E338BBFF
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 18:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5C91330219DD
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 16:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4003EDADB;
	Thu,  2 Apr 2026 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfZ/YI8V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70753C277E
	for <io-uring@vger.kernel.org>; Thu,  2 Apr 2026 16:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775146715; cv=none; b=Tz3il47pNj2D3736VWcbVyyzgz/cTrocJHd9hj1tDE5VW+gXmd8XKFfW3IJ8MIgmXZomWQ4wb3h+5WQCnMoKbdv/wRwMJuhA1D8gVfxR/5B3Zj71/+cC5WnIEQrrd9RshDIaSln6ytnYSwEH/pB17fz17M0VNfhdBwu0PO3wNDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775146715; c=relaxed/simple;
	bh=n/1jIzgDr3d5RSjoh2yBBGuLrG8IBmDSw8oHLZ38Pec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2PX5vuy4yey8Xq++mmedXilCChPktj7oJantOwzyCBVgM8dbaEsgls/Ur69G1ffBENE65moNfd8wp3bJMg95OJ5Vks6HdF+Hh7YChZ1zsYYmqp0fG9yeq2m4ocxbYwspjZg0nXM1FicHvOAlnpFKEy2J9wQMlCUwWVY/NCmyqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfZ/YI8V; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-46704177508so670818b6e.0
        for <io-uring@vger.kernel.org>; Thu, 02 Apr 2026 09:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775146712; x=1775751512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sWyM0yCNq1GDZKjAscH2vcaCfP5Cd3vO59MbLv/oaCk=;
        b=nfZ/YI8VRKeExDI/zlW8Nq93I5SmwI0R5s4KI11CAkkF8p1/UUrEWy5sqbNa/sDhyb
         AUEAeQREdWOaRyFBle00eZuKH8jnom43dQO9/sGIuwwf9JlFkkqXz+nzOFBJLUuK8v4J
         Hgc0iT3AsiVEeeCqjLGulIKDbfnlteaA3XX+Sw2oDJj/nRCpT1Tmb/omUInR1mk+uD9+
         cybs8Nk89RQBgLELJtEiN4HllWJ9ESqnCnvJHHIJBk0u5s3qYMVPZPCnX24YF/PBa5BA
         Y9HlBO47U7SIZ0x6488L6Dhid8fBNKeC6C6A5cmsFdZvPJytim9bkcDlYQudnDYrEGGQ
         qZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775146712; x=1775751512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sWyM0yCNq1GDZKjAscH2vcaCfP5Cd3vO59MbLv/oaCk=;
        b=Egf2UzxnBE88IDOGCuqnG6foYEEBoQ6VespV0MyWqBHTdEUZvze6Zn9l4bvL24XclX
         xAMGEBoBO41f3nQd5+3NHYGrfwW4PhJVFP5Ef5yF59/C7QPPaUQnc9qeHMgc01JQzTid
         vNcDlxVzniSnLjfZUIovqP+7uNe2q04CEcouY1WG8wWKuURFkaEO0/SEzXwUkDTZDgQS
         KNfiRVWLGBE6GqcI4BalFM6J4EGV96X3TFiZN1g2/TJ9dx2vI1zbloyY4kITotXnWsKK
         1s7n4ZXJ83qQuRo1gSYiF91z3CIgpTTUIZYHaKzopH8lFcgoeQS0JXXHHGox3uatXSix
         qeQw==
X-Forwarded-Encrypted: i=1; AJvYcCUqLh06wQBij6tAgkwXZetJNlwuaFYPKXTC+2WKEMKnE9+/QsJUPGGMTJL9BPDZDSlr4wrz1eT2qg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOiJ/GrxDCCGSGkpakLy1SbPkH8Pl4CE4lYP2kSmo7B6MedqW+
	PktnpXUKsMTH7+SP4a6iqYzs9P7lNa5RBuF0D9eBqrgTsjSI6/ZmyURjonswjg==
X-Gm-Gg: ATEYQzzsOXCHAryCptpbR2PZUqeY9CtbRhxurNdc4GCgX74tiwFFfbnyy/baasGlGMy
	sxZl8YEPBDPeSyMKNwRc5Rjoyeca2CbsOtbsXnh7sMbpqmSUNSF85CC3dARTtqWs26T2D0DN2xc
	fEcLIxHvdi+icw005glBX4tAxnHcNx1aUzsHUnaRJnfKdDuB1p60TU4K5epIzPmdO/fcPOg4OvS
	8Wjowf915OB/yJvfec1+B/+N+g57uDAoHIjXwL3eyFZ2DFLBhUHypTIFlapvapCxV+JGCBUd7nh
	Os/m/OsgjRE9dkazZOCILf1Hq1hFfgnd/a9+OuHxcDUu7vePJjFPzv82tFTbfRwSggTeFOlGfZp
	+qODVk1xMv/qGKvVBn/olVX4VG6DpoT2j2/bYJZrgqY/cECe19UR6xOYrFUDzW0lr2cOGAgQjCP
	FalkKq4lCTYuLbZjhUJg==
X-Received: by 2002:a17:903:248:b0:2b2:5314:e96a with SMTP id d9443c01a7336-2b269cb94b4mr79929355ad.34.1775146182796;
        Thu, 02 Apr 2026 09:09:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979530sm33697405ad.46.2026.04.02.09.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 09:09:42 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v5 2/4] io_uring/rsrc: split io_buffer_register_request() logic
Date: Thu,  2 Apr 2026 09:09:27 -0700
Message-ID: <20260402160929.2749744-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260402160929.2749744-1-joannelkoong@gmail.com>
References: <20260402160929.2749744-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12939-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 2F9E338BBFF
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
index ed5018c69d8d..5384fbbf684e 100644
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
 		io_cache_free(&ctx->node_cache, node);
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


