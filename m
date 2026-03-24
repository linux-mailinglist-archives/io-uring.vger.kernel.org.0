Return-Path: <io-uring+bounces-12817-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKDuNYHWwWkIXQQAu9opvQ
	(envelope-from <io-uring+bounces-12817-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:10:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC752FF5D5
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D140C301732E
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 00:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB638632B;
	Tue, 24 Mar 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOEf4uO0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0DB273F9
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 00:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774311026; cv=none; b=r6wTWoUPUBqP9fZf/UlXQX5ffbDtpJnIJHgLn4pSnAxiJO50fiHIPewTcHr4C8V/oZ58+LCJ72lVrU+HjalixHGDkIkkDrq9T7YceyldhPCcOAmjnwVnNhNklKrI0hRlCfLUubFTIqdXsN8q4SxgSct9gqwBEMhQtuTFScpf6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774311026; c=relaxed/simple;
	bh=5bAEVm90sPOWDZn/eKlrWYLlclru24LE76s8mInWlqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+hKEXz/B3vIoB5eY2BEabfICxh+G1IrOQLvvJHRj/DPEVMgh7yGChVkfLR4BLTQfAb8cRKCmriu6St0u/PIXUFHPMdiB0LLZYsjQPi8VsTnslX/Uk1xsA7YG89NhfOf1dJXDVx+1wlP78/NNPVy5Mo2NCouqA+wTI24rIEYj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOEf4uO0; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35a09e0dd63so4437283a91.3
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 17:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774311024; x=1774915824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxHgqjXkPeAKHU5zpc5APcFtsFkmKOW0qKmbmPZ3I+8=;
        b=VOEf4uO0Nu+Hvx+y0S1SOj58Qbbo6jB8cFBw1Nzb9yiPtP8JGxW5uh2ZShnHrfnELS
         aJLQCBigFXEp0EXSuvYw9/2dYGpAOpA89L1sMAfegAFanj99FVgyCO4GkQtZFTLMrAXM
         GXwbx39OwnaSC9/bMQlan/qUoKe326VFp+2JCFU1I60J+toapeGJYDslRFiMC+Ujnbam
         q9v8c4ayU8Q78a7kwwLWTbmauoHKDL1Sqbzh5/q8O2frL2CqpVV54MieOuu2rlSsCf8L
         zfubE8BpagyEaWaeRxTNMXuv0q1Y0Zn4SRSodMUYrIGGTgP5toZ6VT0CtUzlTh+01uLs
         WjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774311024; x=1774915824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OxHgqjXkPeAKHU5zpc5APcFtsFkmKOW0qKmbmPZ3I+8=;
        b=A2GdPMy7U1Gta+ne6T9BuhqdPzIGkgJbBnrL4FuFq2tSQR2/TgrdSfNBB2DSHRppwy
         k3RmfWaQjM6x+zHw2lU8O7MTLUP36wBiArattmLgiUysuO/VZ5df3Fjtk3pe7BtFR6wW
         12JV7nfwwbJ/254yntxCtdaHIDvt/EyEB0hmHJnLNxhAHcb//luVgdSG5lGfynGLLCac
         U6PSbgBwzF/stes92623xDPrfwBCVQK/m9VOlRi7yJHWlUO+8sUj59537B5ckyIXj8Ux
         gkXHNrhqzDlAjizfeOFVLE8op+YTtV/TlebQMCCUlGdg0QUOHRwPlWrKDh1MEwMVJM1D
         n4Zw==
X-Forwarded-Encrypted: i=1; AJvYcCXZ8DC9wf/kTXOAOJ/J+qfcuVzE4FuAygcvviP6XXAxPDBk94fkhbNZ+wTvGeMntJwCUfP8ZWG1sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWpUByJS9z+rS7Yuwo8Fsp896871Yqw9NOgV4TtLVYudg75OF4
	ku8cLfkeZJrFrDDk/iDf54YASpSqojGVsViOJXS8Y0eZdF7cSCCGmmO5
X-Gm-Gg: ATEYQzzCiR/1k1t6jKvQGGzUEZW4LcQfYCPGRoLgvU3h6wWnLLwdwcxnuahuv3zU0DT
	s4XgXVpFPTpHyl3uxTY919ZYl430j8Y7CEKCNNtpUGxVJF7b0RitFcx6TdAzJg04d8eklWVifvw
	5WGO3TE8SX/gqYl7mS5gPw2Q2yxNgCf/znjhkiExXZtXYcQHfMkHxWZed5FZIitYXr8MsRRQanf
	EfvTkWCaKPtD4q9s0IwnQC0G5YlaJTYto7H+eoTVTKT9BIBf97CCtIgkR4NJ8QM3yZaa1eHe0Rw
	WoLE3/6kFNV0JgjQppQ8YXhOSr7YkxI0vrvsQptTwI/WJdDmgVBZkMLydFsCNAm8XHAWViBOhdI
	ms4SytA0EFt7jknjHYZ3T0cCuQfLgQmFDIrl8Zs/IYP6lzWl04Gx9lnPGjwppClll8blNZtiQTX
	c7249/1CVHoED//InDMA==
X-Received: by 2002:a17:90a:6c88:b0:35b:e529:4f4e with SMTP id 98e67ed59e1d1-35be52952e5mr4154237a91.21.1774311024063;
        Mon, 23 Mar 2026 17:10:24 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:18::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03124a94sm255543a91.2.2026.03.23.17.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:10:23 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
Date: Mon, 23 Mar 2026 17:10:07 -0700
Message-ID: <20260324001007.1144471-6-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12817-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1FC752FF5D5
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
index 3fd15bb8f6a7..aea8556cfe64 100644
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


