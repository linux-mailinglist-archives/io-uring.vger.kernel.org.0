Return-Path: <io-uring+bounces-12838-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJmrHInXwmllmgQAu9opvQ
	(envelope-from <io-uring+bounces-12838-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:27:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3544E31ACFE
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B01393065F48
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 18:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1540F3A0E80;
	Tue, 24 Mar 2026 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyHT9wob"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10C7399036
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376547; cv=none; b=SUZIKmYkMqH8y+gMzPKhnWozeZntkUbSfJ0dgbL2MFd8QHGzL4ZzqpOUnKLvbQpxUfvVhK8X44JWvhf4u4jEjo4rnJskQts9BlMEOqNqRSyLqNF0TIcMJICAJs38dIA5cbjecPnhjc6trm6TnGNAVgrUp/nOzhjxUDszVt1EbxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376547; c=relaxed/simple;
	bh=CtJyLxHrOX30Kyi8BsUS7jFwRq4BTORUiIDs7P3/XuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVo01cvOiJ5xoG9oL7RyevmTRLXa2Xg/wYqsAnOIlGknaEwcfbtcBrZKvy29KgEKYd1j+p5bR89Y+MzNezO6ZETF/t6dQ7sq2SgYLQWITFY8fluxf05lJ4HS4Hysl4ABP/h9B2GU/Okdv1+eHBpVqc+yD6xRjjwD0w+p+P+WC0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyHT9wob; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad617d5b80so38510805ad.1
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 11:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774376545; x=1774981345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRx5aLIGSgbFJc9IlKhWetIFRhSAX3F1Al3AWYZ5XUw=;
        b=gyHT9wobs6LpU8SSt8EZasKQ5jvV+hhWcU67oGH6pVR9LqPCRP2Ge2/x43R4nt6N5E
         1FNNjZsuJtRbW+auS0giSg3CfToPWSQ2Cjt/1n58hUx48Q5D43psr5GuFp6x/yZ2W1Yu
         uOlhxfWQ949KupifmvO7lhYuBUuuCJ5TO88dZBWBU8zTFlf+gBULiuvo1QLI+3dRP9wP
         kCB97n3mG+2kFyNhE2PtMQczfQkZgLTDA5bVyC1BGvbGFnwowA4R0CPQfJyeaCgAGl+N
         zomXQTieFXhtyJJPmGQkr1m4tvQjGsrIpZpcYwnrYCfIvCfhCh2W3lY1BhNNw0NwVLKk
         uR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774376545; x=1774981345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rRx5aLIGSgbFJc9IlKhWetIFRhSAX3F1Al3AWYZ5XUw=;
        b=H9CRBZMIPx6z0XxA0xyq62SV8Ds4Bz9UQB/JjqIZ/EG9VgJEezB+l+dTs+12iVITZm
         rVOuvQ6MxbkwA2DNl5Qj1iEfAct/eBizqdpU2Ojz+uUmJRBg7MW9Bm6ewuNp6Py6D2GP
         qdbaPuWW8poaD+YT6blqXjUcK2506P5RPo+HThXaMuBiV4Y4RLZlJFsieyNfkejm1CNf
         gEhGSfAfjn3wmqL3Oz7MJWD55bc283N3eaJ1M5JKVWQgcQv/exOlVbXhPXa9+D8Tjqkl
         S92YEUixQYe2c7AJ68Fw2zqTskgHkIWJcRqbowu0GBV6JlXZNOI9QbTdgsIgba4Xs+BC
         Gbiw==
X-Forwarded-Encrypted: i=1; AJvYcCVW3Nckodb8rF2qy3NmWqgy7o3zB9amxzaTTIQLylchCGeTu3nEmqbjktZjtIQ6C2/VJVYyhc5Ltg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXVFmkLPlSHi162Mdps25eZ8PPX3jRyNd4QqbOjilZ5rY+OvtW
	c33VaKxZIOk4xUJe4O8/mLdGbW9XJM9kDwM2vnLv5acWrd28yvnzb8uyQWr3Ug==
X-Gm-Gg: ATEYQzzPH/TCO7x+VQVcZSazqAkI0uZPbe8l8KwOw7J0B7QrIIkK2SbRFkSP4LTlHgN
	+lJeGhiF8koo/hWhFtsSyxnlwBgmdDYEGnm0XK5QJ1JotacCWpbi7rOhaAXSPEFNoK7pDH5/crw
	lI2FrHnsRXGti+972EutRR2v5IQJcoclCyuY6A3Mn383xaxeJFzuR1SbmCsbUTYSHQWyi5GhCxR
	UzKtYZ6XKLRQYcC2SNuojrBciX6KSOs0753Kuz+JtEwUpz1zVVReYSKq3VXKat2GopzauQZwbEe
	XK7tExRU4h5aIkFyeo/NnoUTA1iEK+zv6zhs1iqZ7shDMqFmlfqEVStmEb1GMD43M3CFpLMPxwI
	i9KQAk7LU1LrW8Mr+KmjWrvXMb6y+MXoiwY1JTU9rfEPBFEvHkPUGoS0tM9CcOscA2QQgC9UXgz
	9aU3mwUGeLNNaIZ4CLRw==
X-Received: by 2002:a17:903:388e:b0:2ae:fc60:2650 with SMTP id d9443c01a7336-2b0b0ad0da3mr5581345ad.39.1774376544886;
        Tue, 24 Mar 2026 11:22:24 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655b68sm197491285ad.43.2026.03.24.11.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:22:24 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v2 4/5] io_uring/rsrc: add io_buffer_register_bvec()
Date: Tue, 24 Mar 2026 11:21:56 -0700
Message-ID: <20260324182157.990864-5-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12838-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 3544E31ACFE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 12 ++++++++++++
 io_uring/rsrc.c              | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 165d436073a4..f054ec1c8912 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -110,6 +110,9 @@ struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 			       void (*release)(void *), unsigned int index,
 			       unsigned int issue_flags);
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index, unsigned int issue_flags);
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags);
 #else
@@ -198,6 +201,15 @@ static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+					  const struct bio_vec *bvs,
+					  unsigned int nr_bvecs,
+					  unsigned int total_bytes, u8 dir,
+					  unsigned int index,
+					  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
 				       unsigned int index,
 				       unsigned int issue_flags)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 73ee03f85509..d3079fff2d62 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1007,6 +1007,38 @@ int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
+/*
+ * bvs is copied internally. caller may free it on return.
+ */
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec *bvec;
+	unsigned int i;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, dir, NULL,
+				    NULL, index);
+	if (IS_ERR(imu)) {
+		ret = PTR_ERR(imu);
+		goto unlock;
+	}
+
+	bvec = imu->bvec;
+	for (i = 0; i < nr_bvecs; i++)
+		bvec[i] = bvs[i];
+
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags)
 {
-- 
2.52.0


