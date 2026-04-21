Return-Path: <io-uring+bounces-13084-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJGSDFKE52m+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13084-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 808AC43BBD8
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C642305EE6F
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C083D668C;
	Tue, 21 Apr 2026 13:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="lGL6Y7Y5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661A02D9EC2
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779798; cv=none; b=YUR6ES3qMUm+Wo/yXlrO7ZXXHPo9GCVbFOae1Des2mGN7g3jLMcqIrOWPhDLT+yAczm2wKfsIZ/3DnpTShqP7a6Lj/BSsqfWSkzl0c+ywjhCDuUcpyz7DcIH/QZU8FNdyc2L5GDecZYvAYT44Om2jexmPmOD/BGnofhkzr8zFJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779798; c=relaxed/simple;
	bh=NfyaQ5tAQXt1thNuLiGOQacLHo7mjr3LxbcV8JXcvZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsphBPoDWcPYT5bWGLiVaJ7r56j0afI5uFDgwXF80Ie96PIbE/REgs6PpXK60kWLMfp/XcC7KFAW5zxYW6pcpu8uAixMZq8XOl2RyNL9hnN3dv7GCPEOhdkUNudINmfdIpH/Uh8/R4yJC49zdWJ3saV0ANlaU1ZnHxb3+lAgj8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=lGL6Y7Y5; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-409de4132b5so2667443fac.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779796; x=1777384596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQumuCrV/YCb7guXkPqjc1FwMZmuvspfr+/5Sw2Nn/Y=;
        b=lGL6Y7Y5Ak17zkyI6SUVTY6Cs8Zx+rRKymUDxTWGh7x38glSaYdO8KXOVGRAkLjXnE
         J5SRJUdnXiBcd8M3mfzr3bjIrTpENZfP4hu/i+Z98vYu1g5r3swOvnXRxl9VH38B92/9
         YjvyJJndky0QNer0kgkBEhAEnlqW2xxU/DATLtySNS0fTSEpIoWCNBLTwuXpXLsZ/nVc
         rxnKMIg9rlZRg9DVtHcKGd524X7sNRKUDgtvNvvzmCoIej5ZlAQ4sCAyoqEhEfK+Yxpe
         3tS141eRKlzsZ+g/j37136azllFF23MisdnBL+s4qAGbf/8m8+iTFumqkFbHW5zpEeDL
         Q8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779796; x=1777384596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JQumuCrV/YCb7guXkPqjc1FwMZmuvspfr+/5Sw2Nn/Y=;
        b=mk7zNxYrhxR7BQ2wu+dZdao6z7FbbRauC7bYll9MBLCi0T5KEC0fv8swGWQXjJaKIe
         XZjvqyOlnAJA3C8dY2M1Meyb5AR5FuGvHlGL2tYrLOMtoCs9eTpBDIRn0ox782Y6lRUI
         RZhDtSwMoSG/0MdEpJ1e+3fe/Js06i+4S/YJW3aYidY9+CVyeHP3GF2jCTVbIJL2ga66
         JPeWsx/RNIgKqeecrBsuMZxcD69T+b0jbWlenH0TCIP9DM+ZmYwg+MvxNWSOny4uQcMo
         bXrXfyMvWcYIS9zID+4bY76HKd7yIuFRPPXgJQ4bSU1oKkBKser4BdgABAfuFZdse/3J
         O8JQ==
X-Gm-Message-State: AOJu0YwqgoH08fcG5j1XaCCLU1A8U0lt0hqJvy82ZdMaQUufL+1/C3DG
	v+cxJQl4+weIAn6zH4mqz1KYL8gRRgS1Od9B+TMC3u6ncMFKVXwUUUdC0mq5FRipSOy40JON3Z5
	ABgwmcQk=
X-Gm-Gg: AeBDietKz+v0g2rvZr3kibn6dR+ol1C0tE8dQsfKxhdE/UW5yT6faZpp27xT/8Kfs1Q
	9Ohkg9DPx1EioNeDMsCuf1XspSWY/x+Pqw9miVUSCXtwhttv/D0Va4rQGfT9+eAbcwPlIpKcs36
	5g6H3/SMhm/jdFEf84mHz5S9mK9q5AoKELwUxWVLGRM4bMGAHS+hJxDcIA7jJb2e4NM3iyTdrX6
	v+7VvXI+86bXPN6L/ElKcGVnRAyFXV/kGrtpCO0OnfmKJcwTp49ihaQUGox6hwcTMkqC87V/yyZ
	+gwEJAkWu24S1rHSBW83PWs8r6qBbEhWydk4ejwxthiUX4g49WJzY1G/FyyaAPY33R/b9fn3HXC
	Yf4jpYGdSZdUpuu4WheyiU11+EzZ7nxXeStge8txyDpUrr2chwpkFqfLhz9oSs7sg4rPDYMySXv
	hkNPiPKN6uqNgM/IXFtNxI0ryF3ibAxQZP7s7gz+8rNUzwoiMMt3DgyzXev2m9y8rv+cF0N9guu
	ia5HNDu/aaai1RbPw==
X-Received: by 2002:a05:6870:b0c7:b0:41b:cc55:c398 with SMTP id 586e51a60fabf-42abf2d96ccmr11916034fac.15.1776779795962;
        Tue, 21 Apr 2026 06:56:35 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@kernel.org
Subject: [PATCH 6/6] io_uring/register: fix ring resizing with mixed/large SQEs/CQEs
Date: Tue, 21 Apr 2026 07:51:43 -0600
Message-ID: <20260421135626.581917-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421135626.581917-1-axboe@kernel.dk>
References: <20260421135626.581917-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13084-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 808AC43BBD8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The ring resizing only properly handles "normal" sized SQEs or CQEs, if
there are pending entries around a resize. This normally should not be
the case, but the code is supposed to handle this regardless.

For the mixed SQE/CQE cases, the current copying works fine as they
are indexed in the same way. Each half is just copied separately. But
for fixed large SQEs and CQEs, the iteration and copy need to take that
into account.

Cc: stable@kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 24e593332d1a..dce5e2f9cf77 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -599,10 +599,20 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (tail - old_head > p->sq_entries)
 		goto overflow;
 	for (i = old_head; i < tail; i++) {
-		unsigned src_head = i & (ctx->sq_entries - 1);
-		unsigned dst_head = i & (p->sq_entries - 1);
-
-		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
+		unsigned index, dst_mask, src_mask;
+		size_t sq_size;
+
+		index = i;
+		sq_size = sizeof(struct io_uring_sqe);
+		src_mask = ctx->sq_entries - 1;
+		dst_mask = p->sq_entries - 1;
+		if (ctx->flags & IORING_SETUP_SQE128) {
+			index <<= 1;
+			sq_size <<= 1;
+			src_mask = (ctx->sq_entries << 1) - 1;
+			dst_mask = (p->sq_entries << 1) - 1;
+		}
+		memcpy(&n.sq_sqes[index & dst_mask], &o.sq_sqes[index & src_mask], sq_size);
 	}
 	WRITE_ONCE(n.rings->sq.head, old_head);
 	WRITE_ONCE(n.rings->sq.tail, tail);
@@ -619,10 +629,20 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		goto out;
 	}
 	for (i = old_head; i < tail; i++) {
-		unsigned src_head = i & (ctx->cq_entries - 1);
-		unsigned dst_head = i & (p->cq_entries - 1);
-
-		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
+		unsigned index, dst_mask, src_mask;
+		size_t cq_size;
+
+		index = i;
+		cq_size = sizeof(struct io_uring_cqe);
+		src_mask = ctx->cq_entries - 1;
+		dst_mask = p->cq_entries - 1;
+		if (ctx->flags & IORING_SETUP_CQE32) {
+			index <<= 1;
+			cq_size <<= 1;
+			src_mask = (ctx->cq_entries << 1) - 1;
+			dst_mask = (p->cq_entries << 1) - 1;
+		}
+		memcpy(&n.rings->cqes[index & dst_mask], &o.rings->cqes[index & src_mask], cq_size);
 	}
 	WRITE_ONCE(n.rings->cq.head, old_head);
 	WRITE_ONCE(n.rings->cq.tail, tail);
-- 
2.53.0


