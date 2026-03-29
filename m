Return-Path: <io-uring+bounces-12885-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CZBAadIyWl9xAUAu9opvQ
	(envelope-from <io-uring+bounces-12885-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 17:43:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 808D7352ACA
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 17:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80AB93026595
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 15:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E915A31CA4E;
	Sun, 29 Mar 2026 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bU0K9Wyh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8D137C90C
	for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774798907; cv=none; b=dCuxBXT9rOfR0t4FNwY4SwCVLLenxkYYSjHL/yluo5cf4KsKmkmcHynbkarYQE9kP6vSJLoZJjvFYitwN035roTyvKcHHgKKMmz0UKKt0Y63jH/LiyKeFCI2vlHCBNv5ay9VDjOLs8nPnnVRY7dva/IaCfyeUrnYTiO00MyDAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774798907; c=relaxed/simple;
	bh=OtCWhzUvfXIqQ7wYdgMIv64ae+ELFznyxx4NLyzlzyw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dykGbx7y063N3YJhPpEV/lUD9sOD9h1QAjsBi7rj8qhl9g+0jOzPMZztd2oWZHmpSR5lYn89yi7jPC5UoOEwUyv8iDc5SXe4W4K3RX0fdGd/BPrUkb1kcwD1wq3lCSm92/l8NGHjBYqfNK6QUPrQqvMSh88WygnhBA/pqOar8fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bU0K9Wyh; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8299f1ca894so1756324b3a.2
        for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 08:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774798906; x=1775403706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T6PuK7lGvveq13IklGwlrhaqu07K88SU2jZy7VZsoXo=;
        b=bU0K9Wyh1HRzVqkvQhEbM1pc01OuX3EDbXUyF9fAgffsQU6u2joXGOO6AyPtWZy8hJ
         nzioLJUqgzWN27rpdEVWyxEu3Z2u3JUfVm86GcGW3QVPy741P//PgjyB0+OSm2+I0eYQ
         pR+9voEPUrIjuohceFmvg889Ez9zKRTCJJZb5j80c7ZXBuY0Cf8tTXTy2vCJjMTulOFW
         3tOMAZ8D9hN/WzD2HaX1AS9DzNhxu8YxKZCtWP8NEhDG8bZSeJF6ezho/KaTRrkuFzvN
         Cis725tbVPSgqdNL3Cp5teaApUaHfNwsMjCH1+noAA2dpcbKh9jde866fE+hRnUTz0gr
         BDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774798906; x=1775403706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6PuK7lGvveq13IklGwlrhaqu07K88SU2jZy7VZsoXo=;
        b=Ow0B69noRNR9OjKLK8pdaVL7TtNCsjF3laflJsJfKg4EpgPVvcjITZJTCKWk1YcCYI
         UM7NM9wp6/TvSGBJXYBNS6X9Dv7X+WU/GdqazHU/VwfZXawwgWiYIbW/38El6AKT3wKU
         JfgET994LKKBLXwKHm0bKGFkTwsmf0xG4WvfYo5ed91XvIEVROUpuNWt/O+CktjhAqVG
         gzCPtYxI6eJoSQi9330rkv7p6kabbEJZimtQSYqpcJSWmFbzSlTqsipjljXenHYl7xAR
         ZVLsgZS0/qw5T7dmFzDcIQaFGGDAxhlthV9Tn/y88hXnNnnq15L4hTQFFemNp9TBsxJz
         7rQA==
X-Gm-Message-State: AOJu0Yzgub8iGpaGo6BeAEqgCl1UpLFj86D3t5JhnpaBvnQjZnCtOQCo
	8q3IR0n3YOxzh2Qx027ktAuf1GNv9aeE334+SO99+KCA/S6Y6K/B6gGTVEns9kSt
X-Gm-Gg: ATEYQzwG8gLJyfchLsFFZTPHm63t5vMSTZr1F2qeMTr1OhHrGEAaAvfWSUHHwegmpRR
	lY40+w0p9FHPlCDgM2X9gje7d2gyRcFvEtj7bSNDOBsfXXmBc3FX4JzZkN5G2bXE/uvmyqDTBSv
	9e1UxtHfl8K+yT/7HW7VffdT3aHrqsgixf9aBxP0+P8S6kMLwj8GeFQbTqM1ORgCk5mjzlt8vUq
	fmuuJmnWql2cgjg5htk5/eQERmX+nVYRM7Jg+lGrnWpMpKw3KtEQFHx+3xgfNCJYECOAVdx8imq
	mHy0kBh96jlf5Dffb4x+oeTQqx2vJm87j0lvYy6UMeUBwbyuV6r2Jmp4ChDt7EPRUsRLszH7Qol
	l0qnY8xyknM4ArOMFPEGksDpBM9L1LLBO4FgJPxp0LmlcIwFRxVnq59WbRxFjQ7QxHAVYZtN3bS
	Rr8hDPqHcgbCRDcCuW/l0bKMGXRkejqtRWl6s5F28=
X-Received: by 2002:a05:6a00:99b:b0:819:5db9:6ac0 with SMTP id d2e1a72fcca58-82c96057c43mr9040444b3a.37.1774798905719;
        Sun, 29 Mar 2026 08:41:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:250:3007:3:4b07:f431:12e1:3797])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca843bf3csm4800004b3a.11.2026.03.29.08.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 08:41:45 -0700 (PDT)
From: Junxi Qian <qjx1298677004@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] io_uring/net: fix slab-out-of-bounds read in io_bundle_nbufs()
Date: Sun, 29 Mar 2026 23:39:09 +0800
Message-Id: <20260329153909.279046-1-qjx1298677004@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12885-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[qjx1298677004@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 808D7352ACA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

sqe->len is __u32 but gets stored into sr->len which is int. When
userspace passes sqe->len values exceeding INT_MAX (e.g. 0xFFFFFFFF),
sr->len overflows to a negative value. This negative value propagates
through the bundle recv/send path:

  1. io_recv(): sel.val = sr->len (ssize_t gets -1)
  2. io_recv_buf_select(): arg.max_len = sel->val (size_t gets
     0xFFFFFFFFFFFFFFFF)
  3. io_ring_buffers_peek(): buf->len is not clamped because max_len
     is astronomically large
  4. iov[].iov_len = 0xFFFFFFFF flows into io_bundle_nbufs()
  5. io_bundle_nbufs(): min_t(int, 0xFFFFFFFF, ret) yields -1,
     causing ret to increase instead of decrease, creating an
     infinite loop that reads past the allocated iov[] array

This results in a slab-out-of-bounds read in io_bundle_nbufs() from
the kmalloc-64 slab, as nbufs increments past the allocated iovec
entries.

  BUG: KASAN: slab-out-of-bounds in io_bundle_nbufs+0x128/0x160
  Read of size 8 at addr ffff888100ae05c8 by task exp/145
  Call Trace:
   io_bundle_nbufs+0x128/0x160
   io_recv_finish+0x117/0xe20
   io_recv+0x2db/0x1160

Fix this by rejecting negative sr->len values early in both
io_sendmsg_prep() and io_recvmsg_prep(). Since sqe->len is __u32,
any value > INT_MAX indicates overflow and is not a valid length.

Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Cc: stable@vger.kernel.org
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
---
 io_uring/net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index d27adbe3f..8885d9441 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -421,6 +421,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->done_io = 0;
 	sr->len = READ_ONCE(sqe->len);
+	if (unlikely(sr->len < 0))
+		return -EINVAL;
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
@@ -791,6 +793,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	if (unlikely(sr->len < 0))
+		return -EINVAL;
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~RECVMSG_FLAGS)
 		return -EINVAL;
-- 
2.34.1


