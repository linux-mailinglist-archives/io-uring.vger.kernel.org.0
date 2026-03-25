Return-Path: <io-uring+bounces-12856-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4A0ANVXkw2lvugQAu9opvQ
	(envelope-from <io-uring+bounces-12856-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:34:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E684325DC2
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3C6B310B5F8
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E40330C359;
	Wed, 25 Mar 2026 13:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xg/6L6nw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419BD3D9046
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444163; cv=none; b=I2Jk3RNhO5Ozdrrjd0jzDh/HYe9RrtKQfVqDHWJVpoAUMwG8M/LIydmDH5EUc4BMFqrr3hqBejkLZpz2d6xjvC70oOzf8oNTXCwu+dxqJGr6DkVfUEHmgep0yc8GoSbUwcYI6xmZsqmmsMZM4cHgM1BLxy+2m6APxGqp2H5GG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444163; c=relaxed/simple;
	bh=r7gVySrUUNsfBFCPZKXFqbsg/O6mHB+cNjJyBEtDGEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuB3DwW93P6OpgD/8tKmlKQY09qSJ5bXI4dxbfyzwSLs5FzYnLtgX4wJcVVZtUK7kHZ56laLVnd9zu5Y3xp7SVARGMToLXN7qwHECioTmwkXv+6pvQvsZbjB/gj+NkvZzEqfqlCJt7LAr3+IUjU4/mG9CsB+yBvrIlbCQHHBRh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xg/6L6nw; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439fe4985efso4399754f8f.3
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774444160; x=1775048960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAc4mOPKFfNTckqGfMJzU1oKEn8ryqKVY5PrIYqGkRA=;
        b=Xg/6L6nwusJlKn3TzOUIApUWgodS1tPyL0p2LNCR60T9mgVXZqB+k2X9FyetxG2xWJ
         UUEp6Sn8fUKJXPWu7Ke1zJ1BhyvjLsRODH6cvhmz05iFHbDVdRYRm1K2cY0B3Jqt0HT1
         Yt0K2+FPFFf/5OlkLKU62yYSHlKA5oS4s/23G852lb7urzetIxmQIomIxln5IPte5Xob
         ZXJMU5+4EsYWSDAbO315xMb4lv13LbF6/BucRlcxHyd/kKQ37vr89yUfT3XljPLUvepZ
         JqpD4Que1lxYr9HaCaTC2v+6L6hjvjEq5Akqkngr0xbAW/9eXiITi7s41h6huTEy9xuY
         sGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444160; x=1775048960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WAc4mOPKFfNTckqGfMJzU1oKEn8ryqKVY5PrIYqGkRA=;
        b=np3tB6V9499S8Nnd7vMYhHPmwNLf1vxxE2W9GnnikWFDMh1JCLsIy9Ju0+4D7sdDea
         jBqQnwORypcLrantJ4ALC1tdffhhEnPcOlRZoXOI/L1RerhkbF0u8vB9AeBGf90Ro8hL
         10EkoaRxh95jdwuQvea2NEs1VCKQzkDtkx7Kaw9nt+m85aaEA5chUv10gsGqJepE4Xr0
         rfiixHX5FX2Wwryi35FLUJPSFzV1YNHJBF6ysS5VF1HvnSgagThPKxAbq3TQXzGP5taT
         ai0hcTXAGs5niix0STzhSAvNr32HtGg+bJUc71s2gX3PIaiDpkHiDXaWcmgK90TCLxc+
         0kKg==
X-Gm-Message-State: AOJu0YxTDuNhHHB95PSugdsCJXY641MnqSnTSX4LAHlBZenazXGhuN7p
	w97MI5czq1EIf9l/zbVK10rAFmxH+xhHv4pVmw1lHg+zaSE0DrToH54u0Rao8w==
X-Gm-Gg: ATEYQzwCUFaw4AZwxbHXh+jjK6wYNMXYyhz6ysCniHyLEMknFU9i6r1aOEy6XvMr3gx
	xn7K52Tt1GIy6+yTxh/xeqgnL2wdnI1e9HbOtaM05hfFoT9A8B+9aRXbd6V7y8wxiCipipcWR4O
	uG4xsWDbTa1fkPn07DhPZqq4O08fP2RWg8Lz3sV8G00rnjHpdsotX6c2tMFkjOasetq0/MNjxIi
	ciA0sd2m4IjsHGhizUCulv48byktU1aqqwQQnXsyqx1rsYwad2D4Bv/A8oSMIKtKCLZqajwn5TO
	kufwjIsC7b8yfjs3a/pI7VF/GfgsBDIgflmHSQPHMBBFnelpmx4yNpBjeVGEtxcaB4TOUcIuM+2
	Oe8hTveLF4aRe4ztiGBkkGHlaVZxvYQUJgfHzntS52WhoO+bFN0WSYGpl6/e6rZoRHEbbZckgFP
	z7RLI69GVuBTu8u+g2CuN4u3PRBENBnu3/cHwbjun6eZFr1Np91Pkh0yJRynJmenc77loz5aixT
	wX7YJhujg==
X-Received: by 2002:a5d:5f47:0:b0:43b:4a2a:2cd4 with SMTP id ffacd0b85a97d-43b887f3e18mr5165518f8f.0.1774444159848;
        Wed, 25 Mar 2026 06:09:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd923sm54062611f8f.12.2026.03.25.06.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:09:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v2 2/5] io_uring/zcrx: don't use mark0 for allocating xarray
Date: Wed, 25 Mar 2026 13:09:19 +0000
Message-ID: <b5be2425e187942277ecebec034a2294794bffcb.1774444007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774444007.git.asml.silence@gmail.com>
References: <cover.1774444007.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12856-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E684325DC2
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
index 1ce867c68446..dede892bdda9 100644
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


