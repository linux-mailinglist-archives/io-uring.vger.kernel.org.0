Return-Path: <io-uring+bounces-11051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9E3CBFB4E
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 21:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E338305A828
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 20:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4423126C7;
	Mon, 15 Dec 2025 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D3FlZClr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D703093B6
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829431; cv=none; b=lGpSeflXObE7egK5UGykORimo84FDJ7CRP3imYKaV5C/oO7dsQJyt7r5ugPxUU/WUxv4gEVa0CCZHe+Xk8i1zvsg+Bx4K4MJzm7jv2dvZmySU4wEzs7V9Wn9iR1B8SKSUd3I7Pj6YAMsy9EjAgwsA659Nqr2QrV4aMHfB+E7Sls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829431; c=relaxed/simple;
	bh=rpg9xRwqXJdoa9o/0hJC0BVwNsBbVZZp4L9qh0QLmM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hROi4nnMdPYmN0bm4PKust8+ZYPWCKx5gnvCC+ofDFDNoMhswLNuer9YJp3GSwmv6/ZmxIu2EAuNJI8vAuUnuyDzyHNGHOxazmDQXNjkPO3i23xd082fA/h8LhmAf1NryplWd9jeYXENOb3ZC6VmLlJ7WqOoWDiwsStfoLL0VhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D3FlZClr; arc=none smtp.client-ip=209.85.217.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-5e53d9dab3bso237516137.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 12:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765829428; x=1766434228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMOc2yXwMWNwizXE4LJ3r+8jQkSXD2ri2LLDuLQglmM=;
        b=D3FlZClrS3Yp/90KJDnW+DlP9Q41LWOmgRePjXdGBoE++tgDCYchPFysyEH0zySfq1
         R1vlbE4GNcu3Vv8rvL3VnoCVUYuc1NgN0hxrYQri8DhNUO+5oMV+ASnQt10a2VRtQziz
         wZfRxdcAvFERgCCLbiYqTIG76oUnezAK/qyp+9eJwafJ+xp/PRdhrlYzi8yfIbdVsoeK
         cCplRwdJUmYMc+BPpUFv4mqXr9elbelaxA3/ZE5XNBzO0ZnSXBBKyl+RVQrxGinx4OvL
         tKSVTEvLrb1msRUzZg6Eky4dbg9i8v99bYt8vt5APzWxzLUKa+TR8H6C42uMoIEwVsNt
         grxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765829428; x=1766434228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BMOc2yXwMWNwizXE4LJ3r+8jQkSXD2ri2LLDuLQglmM=;
        b=jAWWcV1k34ptzLczPr12zOLaAYhkbqKq8rA06I+bPr2dBrt1HUNWKpR1+0TENG9obs
         yLfM8/IQQ3TCXA3vZIT5HHX/fp+cIyT4UPKTH855cazK07ev6vFTfLMOXqVRBkMhdRAh
         wQ0FpWOuxDwllWBmhrwAu+5yRCccvAXNfoOddSepfV4c7qmQ25d8PmAKvUa62j59qPeC
         uTx33CO4FkcAJgxsm4O4P3JvATLpTgPXFL5AZOmxgKxl0MfCKHwqYKJVkUdeBZkgOUaj
         m8JDzufJjGSP0zeMQRli/W00Plkdb1+eqmU/yvzChqY/1BTx2fbizNZTFwfAUFYl/0Y6
         uE9g==
X-Forwarded-Encrypted: i=1; AJvYcCUfVnH8UZOX+ICkHW96D5JdGoiT3uEquGSC7RhEM6ZtSE/pbIpwbKyjoXZrLmHSNKoW6rZBk29mYw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw4UYbQ7PV7lIU07igFjERR9RoXz1NKms4+Cn/ICm+3s8QLD90
	PK2UnfgBUYPLGbMtbV+brRim5wRkyopBYs1F2/PE6L433RKxxhL0qoW1U6qt+7xlSywf45hs8jP
	7hrvZlt+pNe6pn6dxsx/0k6c1TaAVPy1Q/+s0PSM13MXpvBWgCGrZ
X-Gm-Gg: AY/fxX7tpqO+RhHby/n3tqhPNu494ljuLlhvIzWrWZ/gZ26RSjmhH8iLclRHNU4VGsG
	XLZAuomerQTurleITWJIyGFtAtM7EHaulrgW/P4dCCAThO04LVfCypu/4WZ8K8ahYNPULvreF5k
	a1DydFqfS4K1NSitXqfWXzvpm0c2mU5CYi3gGGCxurGoD/iQJEu2r9hn6TgFSIBPBUaiL/pHD8w
	JNMn3uQViWKry2BTfDpxUadiLdN9XGqflynqFEQDeI0zEd3uV/F9E9DcubLJJUJKdTidFM3Zg+L
	vVeNvx/oUBIi4n6xhjBQ73HyzakApCQJ+/XoczQvop6GTQ6fV4Mt6sL4e4oQk74sYLHtqU0T9d/
	l4JqvMDaBLxo++APy82DgDbM1zE4=
X-Google-Smtp-Source: AGHT+IFJA1XGOBY4ZrexkEdFA58KYk98JHMbYC0iRw6qzib7NP4qfcqgFFh8UrRyUIpfsJWwOs5lf8+Waaix
X-Received: by 2002:a05:6102:1951:b0:5e1:8746:85ed with SMTP id ada2fe7eead31-5e8277aa8b6mr1917739137.4.1765829427472;
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-5e7db1f2cf2sm2156930137.3.2025.12.15.12.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 4F11F340644;
	Mon, 15 Dec 2025 13:10:26 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 4BCB4E41D23; Mon, 15 Dec 2025 13:10:26 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v5 1/6] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Mon, 15 Dec 2025 13:09:04 -0700
Message-ID: <20251215200909.3505001-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251215200909.3505001-1-csander@purestorage.com>
References: <20251215200909.3505001-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_enter() and io_msg_ring() read ctx->flags and
ctx->submitter_task without holding the ctx's uring_lock. This means
they may race with the assignment to ctx->submitter_task and the
clearing of IORING_SETUP_R_DISABLED from ctx->flags in
io_register_enable_rings(). Ensure the correct ordering of the
ctx->flags and ctx->submitter_task memory accesses by storing to
ctx->flags using release ordering and loading it using acquire ordering.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 4add705e4eeb ("io_uring: remove io_register_submitter")
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/msg_ring.c | 4 ++--
 io_uring/register.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cb24cdf8e68..761b9612c5b6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3249,11 +3249,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 	}
 
 	ctx = file->private_data;
 	ret = -EBADFD;
-	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
+	if (unlikely(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED))
 		goto out;
 
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7063ea7964e7..c48588e06bfb 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -123,11 +123,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 
 	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
 	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
 		return io_msg_data_remote(target_ctx, msg);
 
@@ -243,11 +243,11 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (msg->len)
 		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
-	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 	if (!msg->src_file) {
 		int ret = io_msg_grab_file(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..9e473c244041 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -191,11 +191,11 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	}
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	smp_store_release(&ctx->flags, ctx->flags & ~IORING_SETUP_R_DISABLED);
 	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	return 0;
 }
 
-- 
2.45.2


