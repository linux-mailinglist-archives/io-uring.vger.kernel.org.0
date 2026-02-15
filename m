Return-Path: <io-uring+bounces-12228-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELL8IvhWkmmjtAEAu9opvQ
	(envelope-from <io-uring+bounces-12228-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:30:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31737140144
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E33263004904
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636972D7DE1;
	Sun, 15 Feb 2026 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFudlKws"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2BA2D5926
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 23:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771198191; cv=none; b=BrPRgl1ejt3ECv/6Os+5vK9mRa3QpZQh2mbV6nPkurBfV5tg1bxKdh9Wo13u6Pewb335sFYU3pU8i/zLgYYo69HtqJlRaQmTE3a3LTSAAKD5VPST1w8q1AE7BMlVkxLWIT7vdFGjDETlOW6JF4Y3FaWbZMUH2WRpGGUjtKA5plo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771198191; c=relaxed/simple;
	bh=i3UDGp7KLBf04ttQhlWkE6uwpc1xbbanHk4UuNzhxHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHFVoh1iYX7hU4kZRN7ii9YpGaWXokoYBCmB79spgkJJXFHF2WXxmF54DvoTfZJHGLlp9QWLFU+Fh4horPjnZd5B8nwcxkUuJ6FqSMvGP1l4/fRMjVN84HvtE/cOQE893LUOHfQo2JVkMwvOFPariy5IiqukPkVQNUg6bZtHeF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NFudlKws; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43770c94dfaso3208161f8f.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 15:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771198188; x=1771802988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1g7mVgGvWTK8/EIC7VR9y/94JjU5VubItvDLMki6i5A=;
        b=NFudlKwsOfaCd552NIQjvhRB98fIuYhnJkmThdvq21VzVpE2Eh66rpHtW+wicnoPwz
         2o8gHdpAqVTlenmWnZ7afHdflpcMC3HFNI1UpqxEU1OW1fyDR44P58gwcHi6RS8JKGTr
         UiS49sSaR11atc9nD00CFmwqhUFfuvKGLXZ6SLPx0DDaiUPNV2PL/A9A9XDVNKb/1I+g
         ESn4+A1UyFKpTIgv5BaBQ/sw8PMmvNoK425q9VMDlYwrQVGYdaSbB/0brY4mJSmXCut3
         j69qcmJlU5TdGAokmXe6Bz6jKzLwLzlZFqroUYFolg0ipkNzOa3pKOzrqTISM+GYMDrX
         7lxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771198188; x=1771802988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1g7mVgGvWTK8/EIC7VR9y/94JjU5VubItvDLMki6i5A=;
        b=BC7Z6oajEGGQgOZ3KpmDxDlAsqjVnJFTBUrxNsef6mh17I5psoPdVLaFOM1d4t3kl3
         r4tH9xr3GQ5cD1l2+VUNNj5ykPi69XaPGFdHzo2uT65nRvAltbByBFKz962ApCJlYiBG
         rYernLfKrPNGiRUofU364OHKugeBPknJv0Zu64/yH2n+QNV5YI5Lf/pjL+ZONWviYYDP
         3v6MiwIY06VrEjIBVBwpZ6vOeejntAwXahw9UlgqEV21MWhSALLVEtusXZYpLCLUHt0w
         nsqTyJtfK+WYqJLr3rI5A63dwYpuMrtnVUSkP5T50bCEWM6dB+ryCr1OrB77R2ispzUK
         IpTQ==
X-Gm-Message-State: AOJu0Yzm9hd3o90qzxH0+sv6swmoCSFZ9IirLi1Zjwf1THLk3hQKqpG/
	ON3aeU+oW7Rbux/3ljBUoHyjUlvB+IIzXIe7i9WjoIM9p2cPQb2bGkDa4SVGlQ==
X-Gm-Gg: AZuq6aL9sdYfak58ioz3lLKCnuwoGquxcA3uL8LWGt+f0ykeIMYeanKPRGaVAJ9pZxu
	zAoQQsXnCzaNxMt4e1yWky/5NRONwmP5qRuQHXXaD0toBQelTDIkuHICONaHitkKIe5GzzXtKnK
	nrESiBZR7soYtVZJA4X9VFMlGDMthHaeYp0nN1zkYPJH7ZMilmlErtQIiEelYF1zyLw+y8lxd/c
	samKrsVgQi6r2+vIovX7G5ZcBlCrG1ZLKgGvhN4ykLCZDaqHjZY7pRdwn9+36drBX5B8OK13jk2
	3khPwTUka3/tJwnQRaPNQ1kMjYiuHb8S0F3xHmuOQltHU3h+pjsLFa61kkJfHY7w2kE+99feB9t
	pzR5ClRLYVbpmT0A6cOaEXsXVtmdbWkR3Rhc2W96HNmV63qydCgGlmmveCR+3JCp3Bt3kIrxWsI
	P8H2NX9c8QwOpyiWOmAy6M0fcAFRRcD7cn4SFUpeWRyEOCteh+ljQ21AKgXT6IVhp9mPRqg4n+I
	xjMVeZmBFxZ/+ggxygyxMInkUQgJ3OUo1uzr6X6
X-Received: by 2002:a05:600c:83c6:b0:477:9eb8:97d2 with SMTP id 5b1f17b1804b1-48373a15fa3mr143130425e9.8.1771198187814;
        Sun, 15 Feb 2026 15:29:47 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a44d2asm70403195e9.30.2026.02.15.15.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 15:29:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: declare some constants for query
Date: Sun, 15 Feb 2026 23:29:39 +0000
Message-ID: <b68ff77af39422191154413f262717a08dfc9e04.1771197486.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12228-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 31737140144
X-Rspamd-Action: no action

Add constants for zcrx features and supported registration flags that
can be reused by the query code. I was going to add another registration
flag, and this patch helps to avoid duplication and keeps changes
specific to zcrx files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Depends on the patch that added zcrx features

 io_uring/query.c | 4 ++--
 io_uring/zcrx.c  | 4 +++-
 io_uring/zcrx.h  | 3 +++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/query.c b/io_uring/query.c
index 63cc30c9803d..c1704d088374 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -34,12 +34,12 @@ static ssize_t io_query_zcrx(union io_query_data *data)
 {
 	struct io_uring_query_zcrx *e = &data->zcrx;
 
-	e->register_flags = ZCRX_REG_IMPORT;
+	e->register_flags = ZCRX_SUPPORTED_REG_FLAGS;
 	e->area_flags = IORING_ZCRX_AREA_DMABUF;
 	e->nr_ctrl_opcodes = __ZCRX_CTRL_LAST;
 	e->rq_hdr_size = sizeof(struct io_uring);
 	e->rq_hdr_alignment = L1_CACHE_BYTES;
-	e->features = ZCRX_FEATURE_RX_PAGE_SIZE;
+	e->features = ZCRX_FEATURES;
 	e->__resv2 = 0;
 	return sizeof(*e);
 }
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 28150c6578e3..60e12eb5d4f3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -774,11 +774,13 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) || reg.zcrx_id)
 		return -EINVAL;
+	if (reg.flags & ~ZCRX_SUPPORTED_REG_FLAGS)
+		return -EINVAL;
 	if (reg.flags & ZCRX_REG_IMPORT)
 		return import_zcrx(ctx, arg, &reg);
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
-	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
+	if (reg.if_rxq == -1 || !reg.rq_entries)
 		return -EINVAL;
 	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
 		if (!(ctx->flags & IORING_SETUP_CLAMP))
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 32ab95b2cb81..0ddcf0ee8861 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -8,6 +8,9 @@
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
+#define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT)
+#define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE)
+
 struct io_zcrx_mem {
 	unsigned long			size;
 	bool				is_dmabuf;
-- 
2.52.0


