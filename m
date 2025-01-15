Return-Path: <io-uring+bounces-5885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7941BA1283B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B58DD3A8FE6
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E66A16A930;
	Wed, 15 Jan 2025 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B0iuSAFf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B0D160799
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957293; cv=none; b=dyCG3M4AR9VtzCwqKGxV26JSDNffs0XThhiNHFeoZ8ewT96aaOaUs/2ce1/UoTh3f25GyFl8iD/HEU1X56OlFpjOO0yDO7+h/PrSlpmPkp3tNtIMpyqNue+Ukq/05NP4aMBlaYhYeXBMhnqMeB+hVrqCzxAcOJN8smF/tOCmNts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957293; c=relaxed/simple;
	bh=ly1C5Yct8ZTsbUmnRgqnj60JWaqQWfnmxnyapuMOoqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwpW9n3z4LzfH6Uqs/XcBqIc70a/5n95CRLV51ClHrIyD8NxKBBRjElgBEjYwa/i7i93qMUA9GOz2vuoJaPFB8eSHSxNrIu4l7G1/qmap1RoBbLn30WIV+X7zZ+M56BifAOn+qwX0fjMZ6IUM82JUXx5tiECiFo58NjyaJDFLz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B0iuSAFf; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844eac51429so502115039f.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 08:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736957291; x=1737562091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCcurH+21y1CdLJIDj2Lvdkg2UanN9gco9kS7CdXWWs=;
        b=B0iuSAFfIwYgWv20dn+MboPNIUiqtAdNnMtdLwj9aDvrmRT7xIi/PB++ICd8zmakmZ
         ABIQncvj9SwiyebbngpxamJ+UFbsLcdXFBt20FgVXKYLNdPDsdkvpmplmAEu5xI5JgGF
         1C6xYXvdSaeFvxmRxrDVRJZeG874Y0pfGhEcz3PkfRRybXo8y68YZpdhV/7QJKnHciTr
         gx601wTGhKFXlWv2FvOtvj7wuob6s0BF539V1coYuKyemE/ntB4QoOhtoNKk2UI0yX5w
         F2KcExzvsR2hYpnjQcP/ro747ICSgSIlLCMgwWMzZ870UWWy3/nbn0lCxWfPUQ+PJ2A0
         mG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736957291; x=1737562091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCcurH+21y1CdLJIDj2Lvdkg2UanN9gco9kS7CdXWWs=;
        b=Yqvnum7HKEyg+dIDey1ltf4QZ5elPdPdulZtM8QiMMz6vdBFwhhEZSEdA/atARPhku
         uTQifBeKzgSHP9yc+f1Q6qyPuF7Pwu3tJPx4XbI8hsvzHk5B2zVAE+WGbJpeSHNNt44l
         B1LHNuGUa7YNmZLRThNLXuZ62hhkD7qyaEBJ89ObNHWv8y3t0sml5QUkyc6u3E90ayHk
         6CoKbqeFw5rnUbP6Dtt6CfA+PU80rR/W0RrRgJHQsGHnJY+GYTQizIzmAehQqxVZTwET
         rm+89SbTrHGOGzNSNTeB+CS6eR9Pa0hwcp0tYaFEaBX6O09zmDeQK5r3F2BZmGfrGBzj
         iT3w==
X-Gm-Message-State: AOJu0Yz6JHTnjWDeWkCJbjrla5laoO8akoGHnXJvFRguv0dw/qwTq49w
	d54cqGzSXI8FLW5FqMR9OryFiB9fCA27w8zw/63G/BHok9FI+9gDJOFpzQLe+7wGq62tYmrl3bn
	G
X-Gm-Gg: ASbGnctOiF8mxGrl/FJ+svIhqakXc7IcPciszwS4og9ZjmatqGf13XLWJjV6LUpY01g
	4oAaQRHtwBC9nT6FvAutS6WefQbXZy1SOvL4Pe2LYew4UEyLBfKMWAhAaBb51NI2R7EGLBdLz/c
	+xQzhApt9uJ2zskkbk2oFbuF9R4ZfSshll10pMoZ7T+E8ZsygsxqN+vY6Vi5aaP87cB01A66CFS
	o7s8q2L1XF3bEP71cMLJafpiYaqukcS/8M+4dc66DteQKob5niS4WrDepbR
X-Google-Smtp-Source: AGHT+IEqejPnCg4CObu/B6ZEfZXv9yta1ipbsUFwLeJ2kxG/PATiOYaS+6+6aZDwQcfWOaE8yKNl/g==
X-Received: by 2002:a05:6e02:148b:b0:3ce:88b1:7f21 with SMTP id e9e14a558f8ab-3ce88b17fcdmr20129105ab.15.1736957290718;
        Wed, 15 Jan 2025 08:08:10 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce860d324asm4548715ab.34.2025.01.15.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 08:08:09 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/register: cache old SQ/CQ head reading for copies
Date: Wed, 15 Jan 2025 09:06:03 -0700
Message-ID: <20250115160801.43369-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115160801.43369-1-axboe@kernel.dk>
References: <20250115160801.43369-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SQ and CQ ring heads are read twice - once for verifying that it's
within bounds, and once inside the loops copying SQE and CQE entries.
This is technically incorrect, in case the values could get modified
in between verifying them and using them in the copy loop. While this
won't lead to anything truly nefarious, it may cause longer loop times
for the copies than expected.

Read the ring head values once, and use the verified value in the copy
loops.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index ffcbc840032e..371aec87e078 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -405,8 +405,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	size_t size, sq_array_offset;
+	unsigned i, tail, old_head;
 	struct io_uring_params p;
-	unsigned i, tail;
 	void *ptr;
 	int ret;
 
@@ -518,9 +518,10 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 */
 	n.sq_sqes = ptr;
 	tail = READ_ONCE(o.rings->sq.tail);
-	if (tail - READ_ONCE(o.rings->sq.head) > p.sq_entries)
+	old_head = READ_ONCE(o.rings->sq.head);
+	if (tail - old_head > p.sq_entries)
 		goto overflow;
-	for (i = READ_ONCE(o.rings->sq.head); i < tail; i++) {
+	for (i = old_head; i < tail; i++) {
 		unsigned src_head = i & (ctx->sq_entries - 1);
 		unsigned dst_head = i & (p.sq_entries - 1);
 
@@ -530,7 +531,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	WRITE_ONCE(n.rings->sq.tail, READ_ONCE(o.rings->sq.tail));
 
 	tail = READ_ONCE(o.rings->cq.tail);
-	if (tail - READ_ONCE(o.rings->cq.head) > p.cq_entries) {
+	old_head = READ_ONCE(o.rings->cq.head);
+	if (tail - old_head > p.cq_entries) {
 overflow:
 		/* restore old rings, and return -EOVERFLOW via cleanup path */
 		ctx->rings = o.rings;
@@ -539,7 +541,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		ret = -EOVERFLOW;
 		goto out;
 	}
-	for (i = READ_ONCE(o.rings->cq.head); i < tail; i++) {
+	for (i = old_head; i < tail; i++) {
 		unsigned src_head = i & (ctx->cq_entries - 1);
 		unsigned dst_head = i & (p.cq_entries - 1);
 
-- 
2.47.1


