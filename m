Return-Path: <io-uring+bounces-13703-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ElTzFZpVLGpKPgQAu9opvQ
	(envelope-from <io-uring+bounces-13703-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A0867BDDD
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=anoCdeOC;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13703-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13703-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 93D2E309D0B4
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406EC36CE10;
	Fri, 12 Jun 2026 18:53:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3DD3093CB
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 18:53:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781290390; cv=none; b=llRYAiqT3uQ7OVAd64SSRtKOUbSgOTjO8hJAnwzZ6I1jxXW5mKfHUdTSSkD4wSAKnhyyXpJpJdTYhw5raw8DgL042x2o9JUwfGmFnUDrTwnSpFP6r7g6VUPNoF6f3BIIt0A5YUVaXTQFGlpsYVtrArNmOsc+SOJstIOsbtIwUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781290390; c=relaxed/simple;
	bh=hwjAwtnFADFhJB0BzzluvFZTi4YpI0E86+UvrOE/6xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2G/SUc63YPZpIjinnf26/59A9zHml6KqpzBm8iokBLnGmTeKLQHlEDUF6YpgyTHI4VvEPUdR8h2RhM5zQv4E068/HqEnYRAwbtubTzbzwmPe27Rxomd6PahFfxp7s5IU/YqV0sAaTWV1tYd57arX3toEnXzR5BVrXXnJM214Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=anoCdeOC; arc=none smtp.client-ip=209.85.210.178
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-842307473b5so1046143b3a.2
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 11:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781290388; x=1781895188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSxigFkssNDkBz+59vflKp74eZ6To77kDr64l56OQvE=;
        b=anoCdeOCov/yqq3O/Lrul93sbQmxA7V83+yY9Ht4vC2OPOyQAVp4jX4QTxuUHBceC9
         nGc4wgBfyCpjm2xdqOOzWXkyyfLiZ/Y8a1rVj9Gv0zADNzsHYqRUpl5s7X83ZDUJ3GgI
         MQxN7ngY9SukLfh9+ioURcZ1FRjePy54w/f6fecevn0Rgg7oSMbh0Ig/fO/kMsWxZ7r0
         T0/cjN4AJLdMSOEoT3jT2vscOpoo3jNPnFwhiSb4+e7+clsNG+iwEnXdjwJ6/paQt1hZ
         wjHHAUtsVyPXeJAEAFvIZrXNUDnHlluUYnjSAKE97jaiL30LIgYgQ0e+5cJH0/jh8VJi
         aQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290388; x=1781895188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mSxigFkssNDkBz+59vflKp74eZ6To77kDr64l56OQvE=;
        b=mGYd9HzNQC3UWuHvyztkKtBfPxz1bZpdZEJXnGMdS/DHfHAyBlAMRyxVG9qHo/ER3Z
         ruzz91MQR2Y+ih9RsjW56bd9tdLzjvkVKqGLbv2iPYe1vhZB6kPE35cNFae2FEeG0aUY
         pYTqbPeQgeeTKy/fiZxq1NflWSft/2HQzNxuU3OIEoqRGK0IqQhjrqxKftlCxuvdysCl
         a7lUt3IsPCB++P62oWVmRA5rlUyh/vJjfJGL6/XVbaUsaky2kI4X96wDelPm04twmDd1
         2ZKMPmPRgYyFVQ6oxfkHejSL8K/IqJHmpnNDS/butm/YV09S40NM2fFfQ3ZEb7o/sGNf
         u8jQ==
X-Forwarded-Encrypted: i=1; AFNElJ8GQ6f+fQtYa1BSS1CdDzyexk+iU1vNq7QYitxhIymgTieNvYOJxGHEd5AdzAKMlW9TvvNngOuc+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVLmkUP3Y1oybyKaqAudzAa7Mhp8b4Sn8Lpc1rSZFJrwNrcIH1
	xkQFidvRC45OLyo+HSOGOisbQzT+q6soPa9V3S9IhoRmNhArg+QTSaYM50C1Qw==
X-Gm-Gg: Acq92OFMAd8dIwJ1qr1ZI4+vEJ11BHFbwjWUTo7OsZhZBAXGc7FSNOXqN3gHVNKKSiH
	aBpS6Nt5rmVbo2vYlTKmeeDstglRSZmPOnQUrgx6zdRe9M7NFn8tb0cObSF5Ha+TqvqtSPB4RbN
	PZ1lY078NpkCnBs01WbkiQaenkjEbQzzPqFijzpCFCj4tFdpkE8aId6Yp7zrLOcLqVstb1lkmOM
	QKKoFugcbpBblNWX6XR8aw9VyrNDOWVr4ovgO6hBGEkyj6aeVGtFYYT8TmtVVqt4htHLi/agfsR
	5emGww68hBlHhgMFKWkuETX2qeTMQxhFIrlQ9wxYYXeYpIWKzVZRYrh9VFnVRS32JBxvN1NeLSY
	xGnxR/UuxLucLLp2v+nna6+4A0g29BajUGG6gRhmK5BSL9LwkaFKdqGwO9xp8UeTrEy/0BZqjdt
	j5RE+2pyCHbu+YIg11BC3G8XeIAbm8rMQmnqwjr7ieWz8lSNb3YIR1CMZp3ZzULPsfi+j1rTeFg
	Q==
X-Received: by 2002:a05:6a00:1d99:b0:83f:a040:a3d3 with SMTP id d2e1a72fcca58-8434cec7839mr4045735b3a.43.1781290388375;
        Fri, 12 Jun 2026 11:53:08 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434afc8a84sm3498444b3a.38.2026.06.12.11.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:53:07 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: miklos@szeredi.hu,
	csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v7 2/4] io_uring/rsrc: split io_buffer_register_request() logic
Date: Fri, 12 Jun 2026 11:48:38 -0700
Message-ID: <20260612184840.4058966-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260612184840.4058966-1-joannelkoong@gmail.com>
References: <20260612184840.4058966-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13703-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:miklos@szeredi.hu,m:csander@purestorage.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,purestorage.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C0A0867BDDD

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
index 40807994a8f4..5d50b967645b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1015,63 +1015,81 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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


