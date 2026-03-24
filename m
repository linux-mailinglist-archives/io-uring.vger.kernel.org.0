Return-Path: <io-uring+bounces-12846-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLveFwAOw2lKnwQAu9opvQ
	(envelope-from <io-uring+bounces-12846-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:19:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB31831D450
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B4AE317BCB3
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EF613DDA4;
	Tue, 24 Mar 2026 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQnceK4t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F28156677
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774390528; cv=none; b=tNMI5NLNLySGt1jq3iNWzeN3iSissk/aQ3wz8oI6C1l2pecKE0jXolbju6YEwZr9odlePKhLqrGmAUZa0XfvOIDdMsow4w0LXjiU0xwkqrl89BM8j7H85Vjq+TTaA94II/tqzbP6SJE3zETsi/40zURCjjxsXtfejNp8RpxCft4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774390528; c=relaxed/simple;
	bh=xoxrfaP6FmisESQzVemwgClfvwcVqPttjwTOO0ieXY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6NFFNONvHxsZvl8SJJTmsN2tUOxPpi2ddE7WNFsTw4ryEhbO5ZtG3CaT8Lz+8vWepQ5SzAlvs9zvNdJWZOhT4j1a+tBbnWD5ds72HByc/8cSCOhiDNzbuBVyxWDo5zD3ieJJFao6HeX5M5uxqPPKl9BBpo/63b9lrmbWe4xb58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sQnceK4t; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ad4d639db3so20146275ad.0
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774390527; x=1774995327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRbgcyVVx8jvHxSVnLCZM6TjLQ2Q0UzfaY7xPa2KLNA=;
        b=sQnceK4tmV+6ElcQdnGnOMi1F749Yo7qoinqvnZQ8q+6Z1KnYqyTrz+y8IqAq2vvyb
         +UG9q8PtqSjW7/a68cKNrdXgtr4by6DrMWEBged6D3KFL/CyYWQ12Jaa6GqWmuCzevOh
         1y+4fsqKSPIZv8gRB0yZNr1kz5NSSq4d285taekO1rG+3u6p5jyt9eDF6P7/5uC1e8Wk
         4w2bXD3jcXpvJGy9kc/dEa+rthgBGNtXCGQDyLu8IjwfR6xEA+wHtvXgrQElQrbitGhu
         BdzsOFvN4D9+H1GAijCn79S3YPyocbcit7xUdm0uPBQHCEpw+d3lScVwF7rWD+WdojqK
         1JJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390527; x=1774995327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KRbgcyVVx8jvHxSVnLCZM6TjLQ2Q0UzfaY7xPa2KLNA=;
        b=dmIiuq4jo4O1eP22kpMvQM8UzjIfT2n/5HPWryEdKsxMF1JjQuWVMxuuCaz6u2W+UF
         z797wZCaWT1JNPCJRQsswS39ztXEjbTT3yJMohgIiMaSwCgUX3N+h9m8juvCyF403ZGl
         o/PmRJJXfyfpiG4oztxnoFcjYxnwyyHbYy0dKzIBDU/a05iWWkDnTaTgFGEPstg8RXGR
         rRx2XzU0ApudyV1u+5+yikFArssiSECprV1uHxS2PVCdVH3R8lG59YQD6fOxoPOSlYKw
         kOPLN5TCEqkA/aLp6BUG6pklBl0vB9zBV1BlLNW/zGI2odgdscVO+j6rj5+SG+VgSlYx
         Hwig==
X-Forwarded-Encrypted: i=1; AJvYcCWAfe+pxyiGPsG+6gEMRClfIkx75kvKKojyURqCFcZ9iujGEMVQ5NNGg6tSo8FeZhzhVthxODGnBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyX/FIXaJxBM/btZoIiKunFJ1UHiETO/0pfVjwdxrBxQr62xfOn
	HNNrMWVN0OPP3NNTFJLa1+speCCeQP2mpGWoFtPK5yfnXRWg6svMd5z/
X-Gm-Gg: ATEYQzyltpZASdoXxkcXdIqHv6ubf2WUMtpHQqCvTMtIsgW0sAz4oRRupilPJjQvHcf
	TqbiwMVUfmgCwAvYcQyGkYzL5nNH6n5iuce7aoH9e8o2ePUt4rlfrGQKzknSQ926ByB1AfX9E/T
	7g3eZ0MuGdCbt9mtw4TESbWoKivlumCVR7Hph9RJvpqGNaucY0fAioXIRRfUXcDdWHVcxE4Azph
	pkPnC5YvcMYhPiSATMjPM9oTh0xxJnSZJkEIhFyUSDkcvRtLywuSXkcyQSBVPyvHDA3ZuKuz8ja
	tiJHZ0lmTdYWCyhBBxx5XBv477+3DS8XoxiaJ6i/FPyexjHJqdkSOzJT+h8loFwUM+vbpg3+YP9
	ngL/tUS1BUKt+7oyVWoA0vzmWxD8ZbU5enDhhI/wSoGk1OnwoIA/j6VldEmGzPvv33NsGHezFYG
	5/l2DZSACbriG69vMxyLkUthJNN1/T
X-Received: by 2002:a17:903:2291:b0:2b0:5b4e:3704 with SMTP id d9443c01a7336-2b0b0ab93c5mr13625945ad.36.1774390522342;
        Tue, 24 Mar 2026 15:15:22 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08354bcf0sm162095695ad.33.2026.03.24.15.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 15:15:21 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v3 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
Date: Tue, 24 Mar 2026 15:14:26 -0700
Message-ID: <20260324221426.3436334-6-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12846-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BB31831D450
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_uring_registered_mem_region_get() helper to allow io_uring
command handlers to retrieve the vmapped pointer to the ring's
registered memory region's pages as well as the size of the region. This
provides a way for uring cmd implementations to directly access
pre-registered memory for passing data.

This will be used by fuse for reading/writing header data between the
kernel and the server.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  9 +++++++++
 io_uring/rsrc.c              | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index b4d1d5e8e851..ade0eb807da6 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -51,6 +51,9 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
+void *io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
+					 unsigned *nr_pages,
+					 unsigned issue_flags);
 
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
@@ -132,6 +135,12 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline void *io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
+						       unsigned *nr_pages,
+						       unsigned issue_flags)
+{
+	return NULL;
+}
 static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index cf5638406a0c..c706324fd66d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1182,6 +1182,24 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+void *io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
+					 unsigned *nr_pages,
+					 unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	void *ptr;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	ptr = ctx->param_region.ptr;
+	*nr_pages = ctx->param_region.nr_pages;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(io_uring_registered_mem_region_get);
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
-- 
2.52.0


