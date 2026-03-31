Return-Path: <io-uring+bounces-12904-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4LqlLVw4zGn7RQYAu9opvQ
	(envelope-from <io-uring+bounces-12904-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:10:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 01BBF37169C
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 237CB304486B
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 21:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A013F7E85;
	Tue, 31 Mar 2026 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dq5heiMU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E551B421A1C
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991260; cv=none; b=noL79pEI+reVDTldpQ3oq9gMmY8gUjCVk/DAZeYnI2tS3WyFRfhO0y0kmf4i4F8GFF+R3xft7GQPKclmru4xmnBQ3WA6jk0zwQD0rPuBZOgOAh4z2e1tBnZ03Qd6MrbHbTjgKkNPlPtM8F8/8tUsfKZA7L8M5IUpQN1SuADeKhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991260; c=relaxed/simple;
	bh=Gq32s5tYKhbS4ootE2KfxYlA7AVpiFPecbymE0oIebY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFZwZZkXA7OWF6mqVyuGpnVLbvRrRsaiNbaw2n/iQ4d6+7werBM18i77hGZxfVeAxT2aYzNRjn/KYZxQyy/R4m4NN5V5OrIt4YXz0xxgmDYyyH4COcpspV7/Isqttud9avn4ZFjvpDTCbzyUeUW/9fgl287epxctTEOfZQUbw6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dq5heiMU; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b8e8e7432so5045489f8f.1
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 14:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774991257; x=1775596057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KM1fZLaVB3LcWo3TFeDG4Fp8xcZW77vC4Fuw3DPa4mk=;
        b=dq5heiMU1DoMZpJs5nr7BsiOKgOjyOUl9wSdUN2enPtUweYnfXkGvZoysfLPesBFlQ
         c8TYAAEuR+GWX2oDHr0Fg0ETdctUxfD80x6aD2ESYskycWi//ImxpWDg2G/U9TOfezXB
         64+Fqy0dE/sQqmxDOw0OVDqakD/oaVaJA4pfaJulwn0BMrvxL7yLNhtbasnM4GZMzrSm
         KsuqK/ebQsKYozw44m6PKzFRa8Qw0LoB8mrzs9fIjRif1M0lzLjD2Z6BY2mdR4FiLHNK
         p+4Bktn3JsZ+vo2bCHvqz8VncIlwRXtBvyRBCPCPXULsmDi/DdoWrJjV/4xWBkRd7jsP
         KSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991257; x=1775596057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KM1fZLaVB3LcWo3TFeDG4Fp8xcZW77vC4Fuw3DPa4mk=;
        b=TJj0ts7pYIv6UM4jl3NEL46Ea/7KORM4y/UaCwZu76qAO2JpJLzE9cDqacWbEcqMEV
         1h/h6ua1Blkgie+BJJdrRU1Bi1R/gExceNGLyEAhOCVUR2EG7J0JaX97n9jy3taH2Dp2
         b40t4+z5fhmTLrvyJBpnUyKBw/lbFlQAwfqRen266zgjakhYAWEISEicpU6v0VBEPO2n
         Sh1NUCCEcJvilXb5LtRUynVz8B11gtYs4v38+WXbtLw6bMC6pbx71w3QPbV6UAmvI5eA
         TlPqPPLQqzxDp3PRLGK/YGvUGJ6wab50s6OceMFz65HQz6zjIq6GdAyHQTRTzORiNCUs
         GWOQ==
X-Gm-Message-State: AOJu0Yz6HpaLE/y3ANNLQ1ssVi1jQjtQJjFyvSXLEnQYnLO50tpW3xd0
	u+Ko/YjHv5mWYOsKH/gNttMIMfWdFIkkm3iC3ll91IfGBLGiHlRb714E/GL68g==
X-Gm-Gg: ATEYQzyEsBQ+NzXX1329qo0lT4dkC/ebhCIEPxNs1Q1p68mvWNK01QESQjms3UkTv6C
	R5BTagkoxhL89PPdBrUH9G2J4ufP5tWSQuEMm16k5ZC1XGDwsbeu5uhSf1ZRsftxDsZ/xKQEwfX
	47ZTlP/3A19/puEXtBpggmh1IXHLPOHbKiss6zVsxq1HNU602Cacs67HbSvt6j8V9FZL7v4fQHZ
	V5FzJKgypg4NZIz/vYIWDIeD2Kh4QMWmEPZvvC+1zPE6q3vRMlTVAs6XsnTsUnGKEmAGvDBOOj0
	iZGYwQpzchFn6SkRGH8eB7ATgaFE/hhTS+FWCPvA+za2HwkkitZRPyNTJ0dO7LPbhHFGgbt8faP
	smI0/Wn1fjeADI5Sc1Gg7Tpsn7s6hb0jS+Q6hYtPJBCWqe2daEpwOAZR7/rJ8OK3piRvjHAY9TX
	hQgEn+JKSPYbcBVL9Xb75zY9+5AxTEJMnUMcPyRB70WFkpJH4a7+6lmpA+A1CSyCC31kYEkhBEe
	I40BYjYObFFAonhvxj+OlTL2UuaYA==
X-Received: by 2002:a05:6000:3112:b0:43d:714:34c3 with SMTP id ffacd0b85a97d-43d150dd750mr1858412f8f.43.1774991256803;
        Tue, 31 Mar 2026 14:07:36 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf2570b18sm32431393f8f.31.2026.03.31.14.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 14:07:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v3 3/6] io_uring/zcrx: don't use mark0 for allocating xarray
Date: Tue, 31 Mar 2026 22:07:40 +0100
Message-ID: <f232cfd3c466047d333b474dd2bddd246b6ebb82.1774780198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774780198.git.asml.silence@gmail.com>
References: <cover.1774780198.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12904-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 01BBF37169C
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
index b8f15439d5df..5c0a49340722 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -929,12 +929,12 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 
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


