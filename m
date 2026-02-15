Return-Path: <io-uring+bounces-12220-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MWLG4lDkmlZsgEAu9opvQ
	(envelope-from <io-uring+bounces-12220-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:07:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 157B113FDBB
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 77D803003D11
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D55823C4FA;
	Sun, 15 Feb 2026 22:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahdrZmM7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B6021FF2A
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771193223; cv=none; b=JNEx/uXYUDza9W8kQgXC/0Aw3J9UdMQqVPeCIFllhRZp2yhfKaJfx7pcRgeFrsMtAJMLjm17S9jfNygYpS+YlOmZBVO5EmRmuDXWZPr+ZOwB4cCsh6CMn1Pti57vC9yQAhQRGCVKLaV7CJqTYLPVstzJ1+Up4bPyS0lJx3UtAMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771193223; c=relaxed/simple;
	bh=xyBdzEbhaHRxRh8zqLJJszYsm41G3HC+5rupiMT90Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q+yB7lYJmih9H7hrhYccUckS3ixK5tGlRSl7VWYsjuL1ErPoutMK6yPVtAqIVI1MZZZcHAPm8be5wyE8l8CeavSX4A56Y0LDroVvxj3PGNVzP6VV7N30vZPx0dIfBlnlXP2oAGgEnW/3CZJKHyzrKzkPKhEGdxDEXA+pz8uyA68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahdrZmM7; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48372efa020so17066055e9.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 14:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771193220; x=1771798020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SdQp/r5hurC4TGAPZSeFhZHoVoN9o3wmtKpFivGSCww=;
        b=ahdrZmM78bVyzn5moXf3BxPufpWA6EomMWLPmJKffGGOHFnxuR2rzNGp3XyZoXUDQI
         eM5qoaTOtjnezNu6YZFiN/6+TLSQaY+3CUWjHNB+5sZVh9hk3APJCh5jG4W/yWd/g2L0
         GGq4KDl2Xi5s8VSJgujMPk3wcupslaUQfD+l2XsQfidCnXwZaeIoGRyUp4g7HETH6N75
         ZsBJ2EYEIJF2p1tGpi+ruZMMZ1RKIl4PbL6DY67ZHpGWs21kGT/Zdtct/UW3HvBcgHCs
         W+sR2fdEC1/9NQMaUUW7zLVdsBG9ZsbO+7WMuxUY7AAqqYeIuxAs7dN/xrMCiszP2NDr
         IP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771193220; x=1771798020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SdQp/r5hurC4TGAPZSeFhZHoVoN9o3wmtKpFivGSCww=;
        b=iotJZFo19BrWCeOFaOCt2ez4C1qAqei9HMH/YE/BIcFKbnzoUqu+10/zIIHCslQRSf
         QVgO8oDK3EcSKHb6BHjc0vYVnM5KJXB7loA5qdiVSoB3awrY8vF0VoWUgtiHbbT53E5e
         dCkTvgn8DScuwWgIU/nrmw7xZTYQKxKTe53h3NYHspEMe5gcqmdYbAtg+0NcaI2179iX
         +aPR1aOcbCp2owmyAFsQRm1NpFZRo1Dd2rrncaK7xXrmXn4Wd0QlVW+Z3qHEfGAxou8U
         5SQVTPRUfshaPoc+NxuviCzi0pqq08TZ2GrWaXCrG2wvpwJCIVYtaWVFI5Cod5U+0XJR
         lEFw==
X-Gm-Message-State: AOJu0YwlLIquasvF1E/XF3KD0CeLD+vQin7fKQlALi9oTW3fG73VlTx2
	kRze0L5ylqndLppWYbbogS1GsDUq6jIjpvwRZlH9PYVxFLf9PDwTOK0tm4tDRQ==
X-Gm-Gg: AZuq6aKBOM8xRa+uov34oezkJLNQUgqTEuNfaTPfVH0FHS8wr95WdZ2e5edDlT7dCtj
	pPs4L/5YJw7KFQ5jG6VBH3KCrtUdCIaWdJAShc0vaBBN1gRjFq5TLbGFUk3+0qNrNAyxJtYZwKU
	cniSDgp8Y3zzIYnpjb0+mk41Fp+mzYHF+rGysI3vfxCR6kjEC/RLHKgRzOi3iA9Zo5pHdccrpYf
	SFkGwkhaCjXmqcu5P5vsZnJ4rTjG8MR1AldR42mKusfsgRfm7ijauchQbC5l5Gyb+Mmo+djeAJX
	mcX7wU5D1uoZS6R70QVyq0na7a6EE9Y5aZotK62V37JIGpy4v9ahnDq3QSmHx/F4RdqjKIOoDG/
	/utQm04qTiXM70uqaxhKZY1lisEcx4LVmBJkx7nTSeDZBT+4rhgCp9gBjGFoINgR+e04vIGF15+
	fL2Jmrt4DMFgA3dkJmdvjGmlP2sEn0EYVBxLqy7bUawnz8CO8+I/bSkdC3/4dD1YzL4tBa4h+O5
	I2oXiPavU4fRxxmswsIZWuFL1RmVw==
X-Received: by 2002:a05:600d:108:20b0:483:80b0:b245 with SMTP id 5b1f17b1804b1-48380b0b344mr51497525e9.9.1771193219695;
        Sun, 15 Feb 2026 14:06:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a4c4sm653457295e9.10.2026.02.15.14.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 14:06:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v2 1/1] io_uring: delay sqarray static branch disablement
Date: Sun, 15 Feb 2026 22:06:52 +0000
Message-ID: <0837f85d2d0beb1ab012812bd373cbdbc3d71551.1771193194.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12220-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 157B113FDBB
X-Rspamd-Action: no action

io_key_has_sqarray static branch can be easily switched on/off by the
user every time patching the kernel. That can be very disruptive as it
might require heavy synchronisation across all CPUs. Use deferred static
keys, which can rate-limit it by deferring, batching and potentially
effectively eliminating dec+inc pairs.

Fixes: 9b296c625ac1d ("io_uring: static_key for !IORING_SETUP_NO_SQARRAY")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3a2753f6b444..1e627b7a2f3a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -119,7 +119,7 @@
 static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
-static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
+static __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(io_key_has_sqarray, HZ);
 
 struct kmem_cache *req_cachep;
 static struct workqueue_struct *iou_wq __ro_after_init;
@@ -1978,7 +1978,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	unsigned mask = ctx->sq_entries - 1;
 	unsigned head = ctx->cached_sq_head++ & mask;
 
-	if (static_branch_unlikely(&io_key_has_sqarray) &&
+	if (static_branch_unlikely(&io_key_has_sqarray.key) &&
 	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
@@ -2173,7 +2173,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_rings_free(ctx);
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_dec(&io_key_has_sqarray);
+		static_branch_slow_dec_deferred(&io_key_has_sqarray);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -2951,7 +2951,7 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	ctx->clock_offset = 0;
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_inc(&io_key_has_sqarray);
+		static_branch_deferred_inc(&io_key_has_sqarray);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL))
-- 
2.52.0


