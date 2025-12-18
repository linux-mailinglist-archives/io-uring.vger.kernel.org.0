Return-Path: <io-uring+bounces-11167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABC9CCA18B
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B7D25301255B
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB1A2FE056;
	Thu, 18 Dec 2025 02:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NladGGCv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59F32D29B7
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025906; cv=none; b=gqPddABVGhzmPNhQe0I7Vr3n2m0ZrjDQ7MohcP8krUe+9pwUNRySNg+ejJKn7XmqA5YkDYBua5ei2wwR9W6f5PSHazMgSX1VA/3Ian04EUneLBn5nCDvfs9yRli7Up10O8jEGli04sk/aBmu/9bSieSGWj7iPUu1cIhdEe6nWLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025906; c=relaxed/simple;
	bh=rpg9xRwqXJdoa9o/0hJC0BVwNsBbVZZp4L9qh0QLmM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2rYe9U47H+MdwPtPKOUEVoxTaeFU0dfMvlblrnA5569J6iIJrsdJ+1gLVYHzk6gJcQBJIOla+uojbaPTnlhufDO9yvRHg9P4r4r0ISUS+nYFiNPpSJtqOmp7sXaCatcIU/7KazPGzzJtCAn8iiC9jMy6hVBSmxNyC6vXbbAoX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NladGGCv; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-29f08b909aeso303795ad.2
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766025903; x=1766630703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMOc2yXwMWNwizXE4LJ3r+8jQkSXD2ri2LLDuLQglmM=;
        b=NladGGCvz9hx3HUKT+udV9PoXHncEEwwjBmd/DWBBV9fYZY+O+pcyYoGqTAuh84ROt
         LNy1i5az+fCWRHewJhgSYFZhf08hjq39a40ZFcdjkpcoX994S+O1qjrHufUVbCJDR5S/
         EWVt1Dseu5QY/q2fohWSrovOoT8jmw+vtB+h1o3RTFPiQT8nl2aZuN6K5jodTaXBSWV5
         hV4M37nooP+kEvC5OcifI+/L/h0xb4XRaR5HRfD9E6Y8FWPDv77CQmV3MUTccl2UO2c3
         lzm4un4uf31DvgWcbp5TTUzA+3nIfW0v7UKkOHDWa+IF2Lji545HPf8GnUC4K4CvH+ct
         zQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766025903; x=1766630703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BMOc2yXwMWNwizXE4LJ3r+8jQkSXD2ri2LLDuLQglmM=;
        b=HJcHy9+2aZp4qvAuYmEAodA3cEGVhbdr2rA3l2oSSC8Dpo6KcAXJznXwXYl9t8UigW
         Iz6bf/PmggILzYbQRQMyUWSkivLIIa1E+j01Cr1wLfquOIOp/VLtQgzmZ6ozJb/upFoy
         Dp9tAgv9lIaLEympn5RcwhDnXUwIvs7i+9REc9smAngxaBITZlX9XnzvJ/99bNgwbziu
         4tiLmZvTknD4EE4uECWWR7Kqwjwg3zQMkEpHZpmY33oFARuwIj5Dl1Obl1XfQuFanIsO
         RiPatMQWaev9jsacW59lG3MtM56Mkhe6qIFIHEvwfSTW1ab9CsU8RkAwu3qvJdxfKgrv
         eB/A==
X-Forwarded-Encrypted: i=1; AJvYcCW3GaLxc9EVOTuXskAQ0SREwOEe73iMlWXxcI2eIdTHtbfKCJYV2XhW4byCV7VurZnkPBMOYcSfTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwS74Mn3nW1gWxgwvM6H3RUJrxJ/lNOLWxVb6LBIx/h+slWhKsR
	sEGMna4pB3w3JVpa6AMA0ZruX07EHw9TXW/9N/N/ri8i+buusy8wldmJbknX7a0lOJbd6Tcpns7
	W9E5osDSYrd0e2vukmh5zbHri15RfBmjS6CQioMEAEPbyAINfXM0m
X-Gm-Gg: AY/fxX75gN3IIEl1Bj3s/lByWGUtzYyQDN1QLfsMA8fvMGPNqmfRqHUP2PuNLcyr2jm
	fVhHENwGEkt3TF2DDB4XTqFpFUjTt5lJLuMs/TjQSrkp+O+UVbjgOszVSJeaVQum7guHr477zdV
	cqURQ8YuOeaFDGyr2wKElnWkQ9OQfweGDZIPOBUKqZjIx2iMV2BDRxBsdiwdZOUpdgyh77AN45h
	HkGLq23/oRuNCQp2O3RQ3god8vhC8WuOkgxXIJ5wsKYPwQcVmOvcE7ef38LwN4AFYM0vlCD+lnT
	RBoXjNARpuR5dt9fDNc/pri7ezvGNtql4zEo/vnH0f1aHHf4ZO3Dbl/wawDsBk0fSkGZ/YsRi2C
	8p41Hx3KYmuQpxo//2MH1Nuas4TU=
X-Google-Smtp-Source: AGHT+IFH+pl8jKSdmMofH8xpbY+iOFdJxlVTeWYz56gwdoc2mTCaFO5HLwh1g+k03mnsyYLRY4FHfibrTnS6
X-Received: by 2002:a17:902:f647:b0:29f:2df2:cf49 with SMTP id d9443c01a7336-2a2d4516c82mr6470925ad.5.1766025902885;
        Wed, 17 Dec 2025 18:45:02 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a2d13e9e91sm1610865ad.46.2025.12.17.18.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 18:45:02 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 3203334023F;
	Wed, 17 Dec 2025 19:45:02 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 2DBE7E41A13; Wed, 17 Dec 2025 19:45:02 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v6 1/6] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Wed, 17 Dec 2025 19:44:54 -0700
Message-ID: <20251218024459.1083572-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251218024459.1083572-1-csander@purestorage.com>
References: <20251218024459.1083572-1-csander@purestorage.com>
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


