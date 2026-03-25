Return-Path: <io-uring+bounces-12849-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JVMEl3Xw2lwuQQAu9opvQ
	(envelope-from <io-uring+bounces-12849-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:38:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A905E32501C
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:38:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5BCE324201D
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 12:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08543D332F;
	Wed, 25 Mar 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LHObvrpC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9639833F5B8
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440500; cv=none; b=YGtQ0wFEx6I5GiIAeIIo3J2iGR7iJ199fmRIjR3K9OaxMnLfJp3tPLxV3tl8kWaz1Rt0pKZpt9+6XvBS8LaIXoVLyoHIyGGKuOS/WLl5dbdvWTzXtwoO9LNdFiiSmvYFlFlYJba9fanN2BSvTGRpZZTMPf6JnvcSQJIvTcW3QbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440500; c=relaxed/simple;
	bh=wslwPRuez/NmFoaze+wn7942cE05rZxcs4td3vhq7ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvsGJmDSTcHwbYlFcUYXGPcOBf8I2Irzd1xdowPFojUqEf1Bqvrhg2rc1mEMFMLKEFbud8KDtbe3qPaBRM0Uha0+rNAnXlKFcJ7YTBnD4EuqwXMGEtCkqpb4LC+man0A8ABSoWcliHCJ8/Yo4KcLZotl15TmF2hW3AEuGbVzI14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LHObvrpC; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b8e8e7432so419579f8f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 05:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774440497; x=1775045297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LF7HDkm7p7yh4zq6uV49ZitMLpCTOaJYCPmWeD6AH8k=;
        b=LHObvrpCExTg1a7BUNAzfSSedPgaqlMglrPEAtumuxax6BFdQPyp219nbkUcQWgmka
         wBX48xXzC4vx21+poPaipsaUIJfKqNHYSSIyU4V/6XEdpq4NCpyaLmX9t1/C88SMNTVq
         6DHVSglok9ovU8W+592z4xgzB1oDjLXbl4RTBL//IGLRYA6QEZyH33mtGYDqcfApLF/3
         0cVLXMfHhpyUsGwMb7cwpCSQaGIbHmuySYfJN2nmat1Z1gH+hcxs6BuTczY94RC7tyTL
         3f4ouxmVBnao6NB1bfo1CLIbuw8sNfz/VsFje7DuxCy97pIrfgOQK8wHq7uXspVXJN7S
         T+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440497; x=1775045297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LF7HDkm7p7yh4zq6uV49ZitMLpCTOaJYCPmWeD6AH8k=;
        b=ZZ05vuXfrWDdoidF50K6SsVT0jU/cXw8NZELaVFagVpC4KIwnmQ2ztotFwvhVQLYtd
         iJCWxP/zFKYIcvDQzhaPfZKv8Ko6QE0F0crUAYvteHLZR8pTePdhcrMuyklpTVlKm9IJ
         E2i2JGSt93YLPopsbrWJtclGQQayjzMCVA9cV8MVJnnrAb0NZIwD3n4dk8tvQzpCQxlC
         mhdq/whmu1VLSOndhbcTzhSO/X7rAl3jmUaSIsYCbRj2ChGgdk6jPbZJaSzEkFh6OCS/
         ukwFRIpQHvR2/NfDF6U7H1YnBMass+HLJKivOOmumznwXw5LWobEYrwTxBhSdNkpM1aX
         fTTQ==
X-Gm-Message-State: AOJu0YxDQUZez1m5x+B0AP4GmH8GVDT8R6inbEpfXxNaiGi80ZiO7Me3
	wW5FLDIV+/r1DKFrgoL5V7s/SH1aM/SM106NM2TcB9HsP377kKzd/MNWg9v9sA==
X-Gm-Gg: ATEYQzyhYZVeMN+sPZjzmc/hTeta3+3dSelBvJoYm5pP2m/kVTqndkmH0nTDpHpyvfb
	l9SAzNW8xZMZaxYhcVtkTtZbB1ssgyCPdsbIg1zWtdPS3IX7W9Wq8CfzEiMJSyvTOp2m6m7lJYJ
	VhHvoGBZP9y0yfsS44J4BSLbwyGdp+j2Y9PmC+qK1mNAKteJzTv8eWOAcQRsjqMBi5/UwTBCG33
	jgSQJ5ChFVmCZCyXLf5e4eX9THz9jSk8oX4k/SXjd2oPu4G9zT45L64ZOD8irvPRmJsz7WD3vH0
	k++1EVDOb2vd7swScJM16ZvaLNqXE9rtI0D6KFWksOkG3mp7KD4MGvVEWvJQdbow95Eartz2Bvw
	sE96SyJnSlEnbOpPXINzACn+axd5Y1U53AXTA+PlZ7sm/hJexF/P5eryJnw1+21aNJ1oCmF2q1O
	rx1C/+NCucj52TzFYtKKNDOFttOHwQjwJfTszcEtfdYiWL+UHTo9twBKQD4RDZO+xvSB4tKOMTv
	qL9HJr9JQ==
X-Received: by 2002:a05:6000:2287:b0:43b:3d80:b0b9 with SMTP id ffacd0b85a97d-43b8898607fmr4698257f8f.12.1774440497351;
        Wed, 25 Mar 2026 05:08:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae37dsm48618289f8f.2.2026.03.25.05.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:08:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 1/4] io_uring/zcrx: don't use mark0 for allocating xarray
Date: Wed, 25 Mar 2026 12:08:18 +0000
Message-ID: <28d55404178759ad982e1c750741bb16356271d6.1774439286.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774439286.git.asml.silence@gmail.com>
References: <cover.1774439286.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12849-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A905E32501C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

XA_MARK_0 is not compatible with xarray allocating entries, use
XA_MARK_1.

Fixes: fda90d43f4fac ("io_uring/zcrx: return back two step unregistration")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f94f74d0f566..695398d2f2e0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -927,12 +927,12 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 
 static inline bool is_zcrx_entry_marked(struct io_ring_ctx *ctx, unsigned long id)
 {
-	return xa_get_mark(&ctx->zcrx_ctxs, id, XA_MARK_0);
+	return xa_get_mark(&ctx->zcrx_ctxs, id, XA_MARK_1);
 }
 
 static inline void set_zcrx_entry_mark(struct io_ring_ctx *ctx, unsigned long id)
 {
-	xa_set_mark(&ctx->zcrx_ctxs, id, XA_MARK_0);
+	xa_set_mark(&ctx->zcrx_ctxs, id, XA_MARK_1);
 }
 
 void io_terminate_zcrx(struct io_ring_ctx *ctx)
-- 
2.53.0


