Return-Path: <io-uring+bounces-1262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A476F88EF17
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F9B429C04E
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BFA14E2E3;
	Wed, 27 Mar 2024 19:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="044Xn4DQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E08152167
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567193; cv=none; b=aJTAkymndi4/TEVj9J+j+74EvgAxiZnNvvoUsYEpqctz6lDdprz6IH6NyAN2Ro9X3+gdDCqIqzGNmGIXlHNKgVJZOxXOwTotvYUOfAG9d2w/uu0WLBjFoBjL/2P5VxvtUXqmCV/mZTgEh2fFfnXT1byu/F2P93HEfB2JPn1BJEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567193; c=relaxed/simple;
	bh=5YqocHr5mxuGOr5Z0D+Jj5Z+RZ0wDYj67RIhWvHLoys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqNgpAdiT8Ky+R8Gak/fY6RXZfZZqzuP6c9eUgqaKhn27AxSfoieSj5HwTY9YYQuOZBeoooM5HVQIhj9Vi8ncMDxaNlm/MrK8WJz7wMWEt7UK9u4n3AbdIp67GDkoi2JZZsMiy9nUX8DDIucjJw7rq5PNxg+dbzueUXP3R2uMeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=044Xn4DQ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e694337fffso59632b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567190; x=1712171990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRbXBnmBssLCefthvGjqIke1i8J8DEDsrgn5OvhdPnw=;
        b=044Xn4DQoUHScYlFpXeIw3ZeM3g6qOZGq7lwhRIi0QhAE26PmahorWuWjpbrU20JEO
         Oyw0IsE3yyotht8U1czYqg1QtuJUSkGjHGTbVU5ZiHLfuZ8OSqNfg2HRR2CO8zYEcAWC
         HifKvDmAPlbnOxNpkVf+j6F+DpdOuDOzTnTM1GBDyceTFpT90+gLud7qAiz7CSf9PXKq
         Nlr9BSHoyeme4P4uTW7mMNt0c3A4469qv+q+XWCXEBwPIcpJ6HCeXwVEaD9pEC8SbsI6
         73hIN5ks596yuPJWS00G+X9GdNBWuYhzXg7xBLYcmD9WC+JSZxaAAW63/eCYdQl+FJqq
         /yKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567190; x=1712171990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRbXBnmBssLCefthvGjqIke1i8J8DEDsrgn5OvhdPnw=;
        b=F76oihS0jh2mfQ7ob+67H3MOIqgvlJ7DF5VtljwIVTjCpXEDzzH6SLfRZvxyuEZmZW
         KGCEnJVLeF5WTTEYWttdJPTvQ0Gu0XnW4husM4sKeumdAtp9mA/mH0IBA33zogNFZSTU
         JXIXHo0F8WmwybEN1A4O7cb/bz6okvBEyZYTUmgftcx5u9MxvOKVUMG9KkTq4EqN1hh+
         3h5s9VJXry4UWmeTptDzcrew0SkrNLYtXx2CA9Wmf4hEKTtl2wZqgIo7QodmMzPKClO0
         0Jj2eLMDvsvxLU4yMwrap9majRvIxuLruqNZjdrkwP39jSsAm7YAgJsCvgWw/bSVhZQE
         nBVA==
X-Gm-Message-State: AOJu0YwxHIaYeF/4fGv3IMysmMMRXPbByhvmGYLv13NdUabsgFbt801d
	Z/cKgPXoZL/6vRtr9LmDzSUmw791QiB0ysO+bhH3K0naTRcP10cfgPQtSGhGj+4Utg5WcfklxEe
	r
X-Google-Smtp-Source: AGHT+IEMifsDN6osR6tIPxBi9aDAJ8gAjN6bActUpN5W6XLr7k0j8vne4Hd40xna4ZZkyF2PEXOq6Q==
X-Received: by 2002:a05:6a20:7f9b:b0:1a3:bd72:b8de with SMTP id d27-20020a056a207f9b00b001a3bd72b8demr965327pzj.3.1711567190293;
        Wed, 27 Mar 2024 12:19:50 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/10] io_uring/kbuf: protect io_buffer_list teardown with a reference
Date: Wed, 27 Mar 2024 13:13:43 -0600
Message-ID: <20240327191933.607220-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for being able
to keep the buffer list alive outside of the ctx->uring_lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 15 +++++++++++----
 io_uring/kbuf.h |  2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 72c15dde34d3..206f4d352e15 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -62,6 +62,7 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
+	atomic_set(&bl->refs, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -259,6 +260,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	if (atomic_dec_and_test(&bl->refs)) {
+		__io_remove_buffers(ctx, bl, -1U);
+		kfree_rcu(bl, rcu);
+	}
+}
+
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
@@ -268,8 +277,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		io_put_bl(ctx, bl);
 	}
 
 	/*
@@ -671,9 +679,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!bl->is_buf_ring)
 		return -EINVAL;
 
-	__io_remove_buffers(ctx, bl, -1U);
 	xa_erase(&ctx->io_bl_xa, bl->bgid);
-	kfree_rcu(bl, rcu);
+	io_put_bl(ctx, bl);
 	return 0;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index fdbb10449513..8b868a1744e2 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -25,6 +25,8 @@ struct io_buffer_list {
 	__u16 head;
 	__u16 mask;
 
+	atomic_t refs;
+
 	/* ring mapped provided buffers */
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
-- 
2.43.0


