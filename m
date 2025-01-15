Return-Path: <io-uring+bounces-5884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B33A12838
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 883A8188C029
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC441632FB;
	Wed, 15 Jan 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WP/cWctv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC9165F18
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957292; cv=none; b=ab1/kd5ie10jzsMJfZWitxAJ5w/ooQeWpng9TBSXKYDH16iSY6HkrZecHrqgCzOGeuvPNua7+OE5cjRkAYpmk3kVd/nThRrPznzJ9xSrABLe3gK+JHVaMaqGs5fV+YkRqsIbbLL6Wyck02BLQS0veSspS/UXLa1jEyy7FHp9iGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957292; c=relaxed/simple;
	bh=7EP+TVMW0xZYxFdWwtwJDdad0sBQT6VdO5TGfwm37+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riVdu/fPH9Nx3/UU27t//Vqz8+WrQAiII8ViyZbUeQaT5N8SplkKN/PuSPnn2n5U+2Kx8JfoAULzXVybpLqhxwEIYQKWI/sm6bDQaZ49Q9tFD1R3jbIgBIvxjG/wqHcnUQqcfFCPJyT6r0Yc/0hNZjqeYQTf3NruUE2IKik3St4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WP/cWctv; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a9cdcec53fso49975495ab.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 08:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736957289; x=1737562089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYP+OkQfxulFcCqgxeNmCgJ0LM/nPoW7bJ0Qh+duWeQ=;
        b=WP/cWctv3te/UhXUtTVLs/VW63QGkF29PeaRLijjcXpPE521VwmlFZ2JAzK9sQsiXJ
         s+3U4xr0DRFVqKOtpBDX7x0aj7lfpxZN6edOydLPrH7sEmA+sFRJIWSQGCgIOVeBcOoW
         hXsKOXlDfz866k0RJKlKOQ0KoNQhmGropVaFZ9mA27J1VcUt7mOujWLxg2QQoI+MSD3g
         n5Ewz809r8OBbEOQPN5+3iKtExhvqpGB0ZBVL8/PLUghk+lXV1nR3RjYl+OqgHOwEdIc
         wj0sT1niaQvtEl272fpbgxceWsqggBhru/nJ0j0Mog9S8EsB1nlmtU4AlN2hFVn22v7I
         1Bsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736957289; x=1737562089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VYP+OkQfxulFcCqgxeNmCgJ0LM/nPoW7bJ0Qh+duWeQ=;
        b=Qk6CAbOHuYn8hF0CkUt/0I7UZKiI2bgT9EL4QZ/Ps5cLQnTwI6cDSnzYD0X9VpLhL0
         ACgWhaWiRu97LLzp0bPpksPLnIXD1iDGpV/iKwvzQY+D9Qd/LLoVFjKTxT4o41eb1d7B
         Hvmxn6bGPkFiaKMvNgHtA2u72DUVAedLoTJVKA4rOjfEaGZpPfuwKNuuvIVicsyFJnF7
         iYYO9jlGUkd9YyKoGu1naLx6eRFfQxE1kbMQTZcj7o+synfk0l5X9xlqOlZCKlyFBZKb
         k8uaKHzhcUU8KGKHuQocT+sKBx1dLXM3aU1KOYzsz2zCZjOnqDptpHom8uc47coXSmri
         caig==
X-Gm-Message-State: AOJu0YxVA32yzD9G1hDg0EPpsuy5YFriaeum8NgtRLkyaRUxzJDY2x9n
	2TFyjGIAtYludKI+f+k1wUl3lsW6FklYvM/vLroRTu1Wc63x/zIb9twL1mlXZwzZnn0WkUNV5zq
	x
X-Gm-Gg: ASbGncvxK5XRJLHadkvHXuvdbh313pouKA0p20KDAR2EIaUaBPQPFINGbAAMRklfyfB
	IMSO4Kll6frqyaLAJ6IQWewhJ6bgXmkJQ4+qUsPC3SkcYv/KDGOwHnamavkGxQqX8pqzkBYaeE0
	pcr/u2HwO8vEtb8Q5Jm/OLZmU2/6PrrUzqDJAKC/iDDfEFGSxG1B0E3bjvqe1wHZUWqP7p/eDSq
	HOIowpPcGKOOT71hRoO93tzgg1hgVorYND4OQp8uelf1x6uOgtTrFtBBihP
X-Google-Smtp-Source: AGHT+IH4Milg/o0SKNvA2WQSCjyI4vxcFPQOLZtJbSfvZ/Q3B9uiKrPLStmo6rmRzWrCdhZEemlGtg==
X-Received: by 2002:a05:6e02:1687:b0:3a6:ad61:7ff8 with SMTP id e9e14a558f8ab-3ce3a8883e1mr265482475ab.12.1736957289314;
        Wed, 15 Jan 2025 08:08:09 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce860d324asm4548715ab.34.2025.01.15.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 08:08:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/register: document io_register_resize_rings() shared mem usage
Date: Wed, 15 Jan 2025 09:06:02 -0700
Message-ID: <20250115160801.43369-3-axboe@kernel.dk>
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

It can be a bit hard to tell which parts of io_register_resize_rings()
are operating on shared memory, and which ones are not. And anything
reading or writing to those regions should really use the read/write
once primitives.

Hence add those, ensuring sanity in how this memory is accessed, and
helping document the shared nature of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 5880eb75ae44..ffcbc840032e 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -449,10 +449,18 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (IS_ERR(n.rings))
 		return PTR_ERR(n.rings);
 
-	n.rings->sq_ring_mask = p.sq_entries - 1;
-	n.rings->cq_ring_mask = p.cq_entries - 1;
-	n.rings->sq_ring_entries = p.sq_entries;
-	n.rings->cq_ring_entries = p.cq_entries;
+	/*
+	 * At this point n.rings is shared with userspace, just like o.rings
+	 * is as well. While we don't expect userspace to modify it while
+	 * a resize is in progress, and it's most likely that userspace will
+	 * shoot itself in the foot if it does, we can't always assume good
+	 * intent... Use read/write once helpers from here on to indicate the
+	 * shared nature of it.
+	 */
+	WRITE_ONCE(n.rings->sq_ring_mask, p.sq_entries - 1);
+	WRITE_ONCE(n.rings->cq_ring_mask, p.cq_entries - 1);
+	WRITE_ONCE(n.rings->sq_ring_entries, p.sq_entries);
+	WRITE_ONCE(n.rings->cq_ring_entries, p.cq_entries);
 
 	if (copy_to_user(arg, &p, sizeof(p))) {
 		io_register_free_rings(&p, &n);
@@ -509,20 +517,20 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 * rings can't hold what is already there, then fail the operation.
 	 */
 	n.sq_sqes = ptr;
-	tail = o.rings->sq.tail;
-	if (tail - o.rings->sq.head > p.sq_entries)
+	tail = READ_ONCE(o.rings->sq.tail);
+	if (tail - READ_ONCE(o.rings->sq.head) > p.sq_entries)
 		goto overflow;
-	for (i = o.rings->sq.head; i < tail; i++) {
+	for (i = READ_ONCE(o.rings->sq.head); i < tail; i++) {
 		unsigned src_head = i & (ctx->sq_entries - 1);
 		unsigned dst_head = i & (p.sq_entries - 1);
 
 		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
 	}
-	n.rings->sq.head = o.rings->sq.head;
-	n.rings->sq.tail = o.rings->sq.tail;
+	WRITE_ONCE(n.rings->sq.head, READ_ONCE(o.rings->sq.head));
+	WRITE_ONCE(n.rings->sq.tail, READ_ONCE(o.rings->sq.tail));
 
-	tail = o.rings->cq.tail;
-	if (tail - o.rings->cq.head > p.cq_entries) {
+	tail = READ_ONCE(o.rings->cq.tail);
+	if (tail - READ_ONCE(o.rings->cq.head) > p.cq_entries) {
 overflow:
 		/* restore old rings, and return -EOVERFLOW via cleanup path */
 		ctx->rings = o.rings;
@@ -531,21 +539,21 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		ret = -EOVERFLOW;
 		goto out;
 	}
-	for (i = o.rings->cq.head; i < tail; i++) {
+	for (i = READ_ONCE(o.rings->cq.head); i < tail; i++) {
 		unsigned src_head = i & (ctx->cq_entries - 1);
 		unsigned dst_head = i & (p.cq_entries - 1);
 
 		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
 	}
-	n.rings->cq.head = o.rings->cq.head;
-	n.rings->cq.tail = o.rings->cq.tail;
+	WRITE_ONCE(n.rings->cq.head, READ_ONCE(o.rings->cq.head));
+	WRITE_ONCE(n.rings->cq.tail, READ_ONCE(o.rings->cq.tail));
 	/* invalidate cached cqe refill */
 	ctx->cqe_cached = ctx->cqe_sentinel = NULL;
 
-	n.rings->sq_dropped = o.rings->sq_dropped;
-	n.rings->sq_flags = o.rings->sq_flags;
-	n.rings->cq_flags = o.rings->cq_flags;
-	n.rings->cq_overflow = o.rings->cq_overflow;
+	WRITE_ONCE(n.rings->sq_dropped, READ_ONCE(o.rings->sq_dropped));
+	WRITE_ONCE(n.rings->sq_flags, READ_ONCE(o.rings->sq_flags));
+	WRITE_ONCE(n.rings->cq_flags, READ_ONCE(o.rings->cq_flags));
+	WRITE_ONCE(n.rings->cq_overflow, READ_ONCE(o.rings->cq_overflow));
 
 	/* all done, store old pointers and assign new ones */
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-- 
2.47.1


