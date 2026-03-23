Return-Path: <io-uring+bounces-12800-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mK9eNts2wWl1RgQAu9opvQ
	(envelope-from <io-uring+bounces-12800-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:49:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E3CC22F2342
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 88A2230216E9
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51242BEC3F;
	Mon, 23 Mar 2026 12:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WTFsMfSa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753933AC0ED
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269864; cv=none; b=MQ48nThIsYgfV/PObdfeUA8dVbrjFbspabsw8Cr/xcPat6y7FqPMKz4ZyGwH+xzNdmEplrTNqcx04JfwYhiFaNl44SG8dFkVA7M10Pj51y5KrPXjBhq3bDtkgJ6PKWE0mfGCICXIzuNm8TACxgBQdiWZaR5KxGofFdgZfnRrcHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269864; c=relaxed/simple;
	bh=yIWu5pdnrtOkrME6WXuvUL0ap4Njt0Xp57JYC6efENU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKv6GGkvRsvB0sS4wRv+zobr/DBcAO6IiaJo+tBlFybF8MUdf/oVkBhw8m0nV+XCqCO0hkixlK1853IavVIPlajb4Wglyb0rCzViyMbIOtO5kfWwvOjbVNZ9F4CWDEi4pUXJuvLBnqv9eSpFkoLYP5Alb2b5W2rQ78MfSSEJnsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WTFsMfSa; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43b40fb7f95so115689f8f.3
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269861; x=1774874661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8T3jLqw58WVei3u9zgKQPg6WFseRWKGvJWz8TfzBKw=;
        b=WTFsMfSaTnjRBDKM0Tb8+I+evMNGrghFDSWHo9hvYG5vkzdwfi78tmwbgEOK6DBvhX
         77x9MOOuwWGBZoOwAFMo47mLp4U8ozhyz7apLHCYMVRJifyFMqE9T7I/ktB/qP1LMpVc
         0VAy4F7fbhRzvqY3oDUohxS7gkDEhuuVvYKlMRw5vwScXZgGjxKg0UF48bzuqfmpEf7i
         qHxN2WMXjLSjQ0T8Gv2SxRxZ5BybCVrjjRY7ABs/J7OexM9QjxxnpKsYIo+eWyehWKAs
         QSYNylWLK/+c3J0Y5JHrcQXfXvLmVPQ3IJVb3eC1TYV1ZeXdXAxkzMaIkMcwCESvlIfR
         J/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269861; x=1774874661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c8T3jLqw58WVei3u9zgKQPg6WFseRWKGvJWz8TfzBKw=;
        b=YWXO4V9qE47N3slUpCtbwpOiUXoYoBcHlRU+NSBhunywgMqBKZwBF4hHRYmxQXSclL
         jdKrryikEafs3IbJh5sio/OuCAuE2HcnfZpgLkxchO51ywsvLGR+mwll0dNThWl5/Zzi
         Vm3XKsdrYeiBy7JaGaW/9DP/l0fedo6xIQ7cw7hnEl79BiOKlgTREI8wPECS1yZCMBd6
         xqKYGFtZmRI6I7EWoZ9OFq/fnn9EcohZYArq/JFxMM24QE8H2mVtGHPLcVoQFVUXyMQj
         GOt9FIqZUcBhIm8tYIpll1Ep+wE6vhux5lvIVuFygQD0wOeZbFA8d6POcWBkF2reaecj
         sCjA==
X-Gm-Message-State: AOJu0Yyf4cj09R+v+oCzuGk37iYermF5ipg0ATG+S+utRyYI4LLU2M7L
	eg/50HTREr3s6tRKeiWtSOQEXRudX45f495W8MthmO74GIPAzmsm/E3Ze2aRrg==
X-Gm-Gg: ATEYQzxrCkjoGovdGaCZ4qMkpupGoYp2gbdSEMLMz3O53eI4R0UeRvmN9UiH8Jb2bHG
	8PS1rltz+cH0okJpKVRfssAr7StNt8QQPOwibyh+5Zorn+1UE8KyS1R0c549pv/dFbDVAhvxNoK
	kI8/dEVxP7BUPuKQ1N2bmuaEtCFCZIj0CXqLhyQ5ISOi0tjTR12Wmp/9dTQdVYJTRnycq1onsVb
	AW0+LuTIzadSY9o+4xsB3GSIsK2QfBDSjkTZwKAUxqlY/R8Zxgkyr8HW5R4B9CZttYTXe+kbrK3
	6B5CEJyHdZ2vy0FDpO19LEBLAZsaHoC9e+y/6Lupdk7rWijuv6p28u59w9+caV298sFTkl1qXqG
	gphx+PopsL4O7LfI5pLyVG4am1/1aoB2B1fn4JvLXDZB7Jz0RYHwmSJ5eHHF0u50+a4I2YbVCIC
	WIUc1y/Q2VdKA8GoF5vsKSVLBHTj57t+bVpDg3GUuj/0RooLkEmz4nQzHwNAhwHeuOQ7qCI5yBF
	xVlptt6hA==
X-Received: by 2002:a05:6000:25c1:b0:439:b3bb:2777 with SMTP id ffacd0b85a97d-43b6423bc5bmr19588109f8f.22.1774269861386;
        Mon, 23 Mar 2026 05:44:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 16/16] io_uring/zcrx: rename zcrx [un]register functions
Date: Mon, 23 Mar 2026 12:44:05 +0000
Message-ID: <657874acd117ec30fa6f45d9d844471c753b5a0f.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12800-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E3CC22F2342
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Drop "ifqs" from function names, as it refers to an interface queue and
there might be none once a device-less mode is introduced.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  2 +-
 io_uring/register.c |  2 +-
 io_uring/zcrx.c     |  6 +++---
 io_uring/zcrx.h     | 10 +++++-----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 34104c256c88..16122f877aed 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2156,7 +2156,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	io_sqe_buffers_unregister(ctx);
 	io_sqe_files_unregister(ctx);
-	io_unregister_zcrx_ifqs(ctx);
+	io_unregister_zcrx(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
 	io_free_alloc_caches(ctx);
diff --git a/io_uring/register.c b/io_uring/register.c
index 489a6feaf228..35432471a550 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -900,7 +900,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_register_zcrx_ifq(ctx, arg);
+		ret = io_register_zcrx(ctx, arg);
 		break;
 	case IORING_REGISTER_RESIZE_RINGS:
 		ret = -EINVAL;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 620482cdb083..c2f4fd93b928 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -816,8 +816,8 @@ static int zcrx_register_netdev(struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
-int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
-			  struct io_uring_zcrx_ifq_reg __user *arg)
+int io_register_zcrx(struct io_ring_ctx *ctx,
+		     struct io_uring_zcrx_ifq_reg __user *arg)
 {
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
@@ -955,7 +955,7 @@ void io_terminate_zcrx(struct io_ring_ctx *ctx)
 	}
 }
 
-void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
+void io_unregister_zcrx(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 3e07238a4eb0..75e0a4e6ef6e 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -76,9 +76,9 @@ struct io_zcrx_ifq {
 
 #if defined(CONFIG_IO_URING_ZCRX)
 int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_arg);
-int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
+int io_register_zcrx(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
-void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
+void io_unregister_zcrx(struct io_ring_ctx *ctx);
 void io_terminate_zcrx(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
@@ -86,12 +86,12 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id);
 #else
-static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
-					struct io_uring_zcrx_ifq_reg __user *arg)
+static inline int io_register_zcrx(struct io_ring_ctx *ctx,
+				   struct io_uring_zcrx_ifq_reg __user *arg)
 {
 	return -EOPNOTSUPP;
 }
-static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
+static inline void io_unregister_zcrx(struct io_ring_ctx *ctx)
 {
 }
 static inline void io_terminate_zcrx(struct io_ring_ctx *ctx)
-- 
2.53.0


