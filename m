Return-Path: <io-uring+bounces-12950-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEOrODj8z2nt2AYAu9opvQ
	(envelope-from <io-uring+bounces-12950-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:43:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F2439719D
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0CF3F3017315
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 17:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591DF3CA4B3;
	Fri,  3 Apr 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0bXfYZY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0F03C73D7
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775238125; cv=none; b=DGLWH6cSkPBtBYRO+3FiSQcIOxi+GviQqlS6CcRxFE+bz7+gPmWX2Zceu05bJl/EyoBXQ6oFEhWHGuuPOd3QzF9wVJuOhKHpJmY4SQ4oyh4OUwoiWme5D2BoiqKPecaAH3SHSmaN9skHERaIdrUyPrKNEjSNC6XbTGFWCuNgqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775238125; c=relaxed/simple;
	bh=YqXd6FIUjrhTjF9fRZvBI+ju0/CG0bTLgyHlNlLXYhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfW3ELXNpNdc9JeRxU1xE2CaYikKg8G+TCzS4x2zGTLaGD3Qjrgl7SbymcfzdPWFW9jTNFN5iF1yyIvZ0yipJkj+56y2svvE1hvMOixSoiSn+Z5zseCbyxZ8mO/m8mHlhPT2O7GG1xDJqTwFKsLU0imBhM7X4xfYDB+BbgT37z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0bXfYZY; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a9296b3926so11731745ad.1
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 10:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775238123; x=1775842923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umd2HQCL96rT2BTtAP6XNRqOADWvBTd6QbkXDfPG51k=;
        b=g0bXfYZYcslzKPkcWOLmA84Y3tL51rwof77J1+y7OglnWrm0ivAFAP9GIe3/S0+PCl
         WCLcwo3Y0XvNZs1GACI4aQt1D7g1+PzjgsPZGr0Up1qBUh6a2f/k2Cd4Vx+HMAbBm85Z
         j6H1qSe+vmZsmjftev4pK3wBeQTIkdfHVokiaN2ECPGFVtFVLBF0uN+iD6at0+Tw0B1L
         KLLIAY8OKRYey8xHJkt78FK1YzvGUMGZytcPP+s8tGqfR3+2bj1VUYO0sXhlPNLtMmE1
         LP3Ue9enHSQ2euDTSxm5Lyn6+fGD6rFh7VPgfucLxqVBAIjZ/BixrH8ZKdGE2SW9iyBX
         DlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775238123; x=1775842923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=umd2HQCL96rT2BTtAP6XNRqOADWvBTd6QbkXDfPG51k=;
        b=RNEBAXHfkCDUlmlv/T5M+zUdxcl0yorRzcsvAbS3F7LuliW5nf/lL1MjLlrLib3l/3
         1u9hXmJ0NLztNcHk5Z2xSYIu2NwMbVrMkj5zeL+rjRG9uRmY2iIgJ3k9IxuoA/4EtOBX
         sSpp30jbcHuR/Depvjakj73tRb5tq7EQfB8Ui+CzxinGyOrHDRr3aJC7bH5HDw0/Jzr6
         irDWxnSLn+WWGo/FRn/5ckWPmnYICMRcRJcXVrib/O9LxzJy52c68W9qGbePPKWzzY9p
         q/b8Ri6J/XLd4oE7a/F4YqbTZEDGCJEuWTRcDuLOojNNwJ0KSOIfkpELwGBvzE0uDP4o
         nC4A==
X-Forwarded-Encrypted: i=1; AJvYcCVelYtHQUiKTfooy1pW0gKewOHVsqOTgzAZ21cxjJwi4mO58NbqXoiBLQJy6jW3+MT3cMytOZyOww==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYkHioABbny12GKrliW4sP1VMJImtRtxwCwzOl/QUAAVRtWzcm
	8hoSYp2NITERaiRxi23j+Q5ev06Bp78JYvczfMRiYIUchqkwUJsJDxjJ
X-Gm-Gg: AeBDiesEMxPzdnGvpBGKzFV7F8PSpIhDNBxIebtF0X+2NDh1nbGcxT1HqdcoR7x64j2
	fCNDG7VLOmjBMCBegT413Y/83qP6eqHOVlmxDClk53EkehJK954Y8cl/2gUp5SGD9YjYOinzcqv
	sLgp19Mm/g8bro2MVwRug27KCoj0P8NAtgkz/lNadRXoLP5VhGQO/r8CQzyLFWNYoeK9l2ATWSU
	wYQn0p2Jpvv54CrEEu905CrgCsItSokSUMw4UoKMwoTPRieDskEPV2GGEEXmZzLcKs5yt8ilCG6
	HrI7lB/1ljowry7VjR9lfgfP4BFo2sbno1AOy7WWQMiLZFq7TA5bl1JwqzSjbtTkzKFYwXK2a9o
	5xptE+Xw9aN8L+9IP295EZe/EZwJlbNdY/m7/pIn73rLVtfYxkJYiZG1eVgjbssvxGvu7nDKbgq
	Wkgs+wFLpR8sXZ7O+7
X-Received: by 2002:a17:902:ccc7:b0:2ae:c5fc:b2ef with SMTP id d9443c01a7336-2b2818b3b4amr40937415ad.30.1775238123400;
        Fri, 03 Apr 2026 10:42:03 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d1f1sm82829175ad.10.2026.04.03.10.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 10:42:02 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v6 2/4] io_uring/rsrc: split io_buffer_register_request() logic
Date: Fri,  3 Apr 2026 10:41:37 -0700
Message-ID: <20260403174139.3634824-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260403174139.3634824-1-joannelkoong@gmail.com>
References: <20260403174139.3634824-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12950-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E1F2439719D
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
index b5632db4d72a..6ee699bbbb91 100644
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


