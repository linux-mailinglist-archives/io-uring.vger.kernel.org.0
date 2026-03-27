Return-Path: <io-uring+bounces-12880-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDChHbO/xmmKOQUAu9opvQ
	(envelope-from <io-uring+bounces-12880-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:34:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F5A34870A
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9FB4310D2FD
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 17:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4833C6613;
	Fri, 27 Mar 2026 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cbRqXqRy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21DF2F4A14
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632429; cv=none; b=E3t8ggtnlvRRIoJ+sA+w0IEyKFA7JL47PML5+clCrO6ydDwsBr6/fnndS89XzvbIZSabrq9TiKdv7YxqwQ/nFIE4NdAEV9Y7MnytrCEhyep3UrfpJRhYFz3s/YMokS68GYvDwoIVaDLwpmh4ZHH218ddyu21bZg8Ta1SeO1nVmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632429; c=relaxed/simple;
	bh=jDHb0oGpKw2/p1FkZvgPZUE6Q4HwMySZmI7SPSkSP5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXHNxD/KrNtQmsVTEjBd/tT5PA1yMOG7Frrbx53Ql3lQChaCLRmHIOj4cesB2ouzQfNMs6n3t+UNmVEDyq0RoTdrg5CHFXfr4C3FuI4G27UXF+QuhwLOEAWAFv+1sIvtJo5fOgyH5dTJmZSU9tCaZ2ScalyGRduvxD/gZ/hjX9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cbRqXqRy; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ad4d639db3so11362055ad.0
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 10:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774632427; x=1775237227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzWwvdiHIAmz1WtEcS2GhJHgqbneIfEw6RWn0REYzQI=;
        b=cbRqXqRyMXhcGSQV6AlfKCaRbYdgk1LKxVyJIwDspVX0yQwJ8UdjbtzrZ65kLRVEua
         wLEEAj3anhuFlrnGi7gYou7vrZm4FJeljXJi1mi3ybdJHXnTQbEZrikAt0zj2qFBLK1a
         zOkfT2lYQ+iqtkXbkC+OqvV8EjTRC+5FcGZwzaflq7yBJpHyP0B4EUTmcOsRQb4StWDq
         nXHh0gHRXA8depaD8O++RQCv94yiaEIJxZ2T9vwUHj+1YMLHT0S/uMA7jhtyBwPyOJEi
         QbeCY4SuGeMVXOSsueDrgTfkHXSKv8FziubagIyD1AbAL9BYVEiiiM24UIhppbNHZtVc
         AKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632427; x=1775237227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qzWwvdiHIAmz1WtEcS2GhJHgqbneIfEw6RWn0REYzQI=;
        b=XqMEhEZr5WfO7BxiM3B1rzkpte7XOlasntHKpRnabCYNcJJH73eI5iCj515C9cmQC/
         oJY0MBuPSDBALECMXCZ5xmPQRBedWHcmT6wqm9f5LRMNgz3yU/W3xUbaI4IBlIgJqS1L
         wAVzTQqN74JqOawcuey5BjaVnPC5YuBFtzFRaeDUiy6iFYOnHkn4db/Yu8gQWaw3I6Gf
         53IERl7S98mjoBMbLfVW19CDnMNcEQkhEZicT3NLivVpNw0I1AJfoYnHwm6j+grf/XJR
         sBSfhjRnaJrLmYxwBUfsiFgL2vVagpe7RvQ38aClXT26e0A4qF49zrfa7MrB8Ntn0MBF
         00rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzzQegUKH64dF7H3xl9xnfEcZsnGlu7rWO+mbsgQHKRBWAvl2AznrxMwMJ/CGEqZuiVAxaydzMow==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKFD6D784/T7l4dIcJNPNdz2h8HK3kW+uDRemRXQLQodxUkQbg
	923Clu/CFW3kojnW1mCDqD8/N2PPdxlOIRG54Ys44hQmKX/9caGw+G/t
X-Gm-Gg: ATEYQzwuhqVUmuZlAIXLH7iULXxC4YyQLkAHlvRkPZ2rB1bJbg8r8wYfyungoyhfPvk
	LetMHwBpAkr0cfd8deNvD1UugdaYjt/qUkAqqensZhZMqaseSf+N3qzXxG7Ril9XnFuo6f2b9sB
	VxdrsBO2px/y4P+uYOK03Gv04Ciu7V/zBEa4YP29Bb7fVAJgnkLy9DkvJ8guFaszvuSntbd6Ps4
	A7Nf/0PUFcDhDJOrAR6kirGWehcC+ZWUxRSwMbROAXK2eks2w344AtaJQET0P6cWTZF5m1n0/vn
	KCzuYyby/WIci0Z3kEOXgg+QBK4a0xfJ5x+MzBzwcCr4sZnnCqM4aPoucT4pUsaA7m0pQTCSyJP
	FrdngfZo+Jc67T52TyQtN9T0nN14IkY2Zck0j04kujPSBUnWH6bU5nepZ6YdaBXZxK7FyAdB0rB
	sIoNLT+Fnw+JTHrxfnTw==
X-Received: by 2002:a17:902:e812:b0:2ae:c67c:3b05 with SMTP id d9443c01a7336-2b0cdbf7e2emr36115525ad.10.1774632427222;
        Fri, 27 Mar 2026 10:27:07 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc882339sm64583315ad.43.2026.03.27.10.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 10:27:05 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v4 2/5] io_uring/rsrc: split io_buffer_register_request() logic
Date: Fri, 27 Mar 2026 10:26:28 -0700
Message-ID: <20260327172631.3380702-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327172631.3380702-1-joannelkoong@gmail.com>
References: <20260327172631.3380702-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12880-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: E7F5A34870A
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


