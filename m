Return-Path: <io-uring+bounces-12839-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OpVFLvWwmllmgQAu9opvQ
	(envelope-from <io-uring+bounces-12839-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:23:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4B231AC22
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 50465305117A
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 18:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC29A3A3808;
	Tue, 24 Mar 2026 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r8QLcUsM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E3C3A169F
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376549; cv=none; b=AgPE4h2L2VIz9w150ZlchKXnbGMZqpfC+rBqAKk773IC+vmUnxLNwkuoFsND2mkH5E1uzshxt6cLiRUzNKXF+BOxoSdquJagMLsz36CSeBgF/Ttoty97L2X65zlXYoetrqCtJu353uqF73h1l9kCqiJdtAVqFCxs3LOXa0kUcic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376549; c=relaxed/simple;
	bh=Qo8VLcBrpigEQsKNXxJebsmCycrPCFG7WWwsMPj/g2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhunMRueK6C1LW2EYdRqpxRy2crvoDNwD734I4eR47TN3plMFcA3yfiYnevNPzHc+hp2CW5uZHxA9BVdJ6YiIlJ+U+Y8n2rE25Tn5i32+Pr1RaG4BJEVw+GjtFAuUu+hv84nwhOKumqcSeoXqBM3eOXxBsVxPPXCdeSCVwvW9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r8QLcUsM; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35a09e0dd63so5605351a91.3
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 11:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774376548; x=1774981348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmrGeK02QSVfRlbem2qmlgHI2yMRH/tquO7KfP4v1ZQ=;
        b=r8QLcUsMTDXbTY82gD5Ipd7Uy6JcTUMc8C+6I+CUBznTHvEZB17OKP/OjmBQvsBVzO
         l7tSfZm2Bza44T+hhwwAnT4EtGvmkkB3ZLTGqS1aAiu0WVEG01DLjxbG2J73khNY++DW
         VCqtf79DVGKlzihkuqp01AVPlFsMChMbBqh8oIhu7JwKYsLFIOlZuO3E3WwTpwli7ezF
         lpaG2mczUrtRchag9i8cAgPqLt5yzxhjCuUy1rNwGbBflsFziC/8zQ6zC8FB2ExBU+wv
         dgl3SyFCgC8/9o8cZXfVB7tcjcI4uc5JVAhIY94Q5N0yU2QhvtssQ4GbLNgdFhb1hf3y
         P+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774376548; x=1774981348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XmrGeK02QSVfRlbem2qmlgHI2yMRH/tquO7KfP4v1ZQ=;
        b=nk0N35HgwgdpxZuztiUGuJCweJREgqcCWKCG3oLLqI7ReMd+rSoi1iFzOYWgnkrNoJ
         b35sQS1nwRldVMubJf/fKUPHE6+WcIpdoyPZRqqGh9EeMiuRhudZw3+IvUe2/0j5gXjd
         J/6UJ+YupeA+4U40N+Z3NUdqPC+FZMPRU/yGQ1ZfW5BpD8P1t8uSY+b1nMFIcdo0/if2
         om2JLBtUjg2zd/r1/8UuOFvc1Sqc1hMF+hZ37gIFvVi9Rl31QlYj5cToOVk/5CcSDHf7
         PJsiT3k4O5mJ+wanlSIM0jeNA2n/fINAVhsa969wf7GBclHVsCPDtQcaHIrmq33sI7nj
         ewug==
X-Forwarded-Encrypted: i=1; AJvYcCX/YLCdYvjVElGkKbYkEnqU31eMz+Zx37PDUkm/OBDVJLllbzTQYl1cDbdJmHbJ3peFRFlM++hHvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdKeGD21Tj8Tez/c6GGUlN1aAR6tKeVrV1dr89O3qSTNjI5eUr
	i3rxXAcmreUnjju5AGTShmqn1760PcMJgzAtLyIa/KgaNGDPNCtemjxH
X-Gm-Gg: ATEYQzyZGgT2cR8j6ew9LIUuYBYjl1QDlWNFetCEA5BqXCU+AoWklqfujAJ0xWYhxO1
	wKkh6xhTHAZXFIdDnpWt0aSIsQnFdkjTA0rhWJUod6JPlHh5iGa56axbUlTNhsiuMSfuYyibx6s
	wgK5651uey2jlCfxKt7psc3P6ruPXSPHo3OIeiFlFudXa1F7S2/VRcvpzCPlgflOXxjtooWyTKX
	kbQaL4Pbpx6DN7CcK7YIUzSSWF3zVwfn0W6nutZVe4ISp4SGGn+vfkTDMn8Hn9EMQlNGDvBPiVG
	jOvLuUR0eE1TDJJqiITG8tTvjFyhTxg7AlxQJ1gHFN2U8DJ3X/7FrNImaJNpvVESZ4WCMWJmd1+
	5D6pU7z5jEppq7BSp18oUJVRFJKQV4GalRL0l/GWDWCuz8v37Skw9/R2SY+ZIuehwio/5acVs+n
	nUYwRc4/lvpSSNtzOND0FKU4lfgNM=
X-Received: by 2002:a17:90b:3c08:b0:35b:9682:51e6 with SMTP id 98e67ed59e1d1-35c0dd3aba2mr300559a91.16.1774376547531;
        Tue, 24 Mar 2026 11:22:27 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c743a817cffsm10886456a12.11.2026.03.24.11.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:22:27 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v2 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
Date: Tue, 24 Mar 2026 11:21:57 -0700
Message-ID: <20260324182157.990864-6-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12839-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB4B231AC22
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
index f054ec1c8912..82ec6883eda4 100644
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
@@ -131,6 +134,12 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
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
index d3079fff2d62..f9cb095cac73 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1180,6 +1180,24 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
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


