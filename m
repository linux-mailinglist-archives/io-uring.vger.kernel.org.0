Return-Path: <io-uring+bounces-7701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7ECA9ABCE
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 152153B88D7
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 11:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA41C223DF9;
	Thu, 24 Apr 2025 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LTUPiuc9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DFB1EB182
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745494215; cv=none; b=cyMmgHp8PoGJ9n32jb47MNb2h64q1C8fHA7PHRNoHRkGilOvlXC0+rQQXu80NkB5ONua9OBOgzrhhiWQj4vT/AN4/kx1aOXaHt0l2fRgyEtGJBWB9+pGCs5od4MOXroIAVUYJXHD0lVl0G111iExHcdMGllsh2i4sLbsoyjjmLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745494215; c=relaxed/simple;
	bh=KA55gXnEJVbIlXmStfIc8I9mN0+qGPpHwzgZ66U0XB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8QqA5eWKtG5Gs3eOjKRHMHitulKq4eiIbeh5RNm/4Ejw/MM31QQHnxZ9S/Eh/cucqTM1W9RJB7QkXSOHG/151qInEUY761VoG/bsPuBn3nzB8W7nG3r+uRaFXT9g0AysPWG4ZojlFuzjszFHRP4d1ITJB0e2tb5PIjpD4tzEFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LTUPiuc9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-acb615228a4so345416266b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745494211; x=1746099011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSJLXYVd+z0FKy6+yhcx5/iGMA0+25u/amVJZHBtMmM=;
        b=LTUPiuc9fbdWev0bYc/6Zbg9LYb/84NfnLIYuI3X6XLXhS+1fOr4TP3yFaT/HU5pQa
         +Phdn6bxB4M9IZBz41s4lTYjUVbiEU/qr4WX9zcL7haN8VepZ1cbUXBTQYdlheOafI2w
         +pzuaOkHe+vtArGYNHRbHfpf5mSwic+MjbeL6L1883DDTqjHz+YtE9BkluNGjxMJjk2h
         1W1VgAJ8Ulybovbn4DrFTV/N2JOHmJIl6QhpO3Fy61p1cqjixsgMcC964FtUOboKlU0s
         H3lM+cgHPFy4+ulRHUaWjFK10yu6Xn+hmmfiInsZSr9WZcIAeHX0SHwf9jvUED+J05Zc
         njZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745494211; x=1746099011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSJLXYVd+z0FKy6+yhcx5/iGMA0+25u/amVJZHBtMmM=;
        b=o2fLFqrtHNKrPj/QU73vmYpimRmVWmNoiluu5p8O/XRzz2TUbIZvOAe7eMOGoAePeD
         rcHKMuRBm9L2a5oHy3Uhps8JeAdp4PZPlz3GxX2HqFh4F6tqH5ZaOQOKc45GnuyDmdgl
         4ARW0Gje66nZFPTh6mhfE/W202nFlWNZ4Uv8nlO5FFPBRvuO7so4ywaGV19mrWR23+0t
         fmaemRyqBRIg+xouxaPeAPwAfea1t64c66Zi4aU1ZxJsHbL4qTCAT4ptaLdnTDwjAGIr
         sVBelHV4TDnC9FmA4dpFh5qHZnHePW2UPzyBQr1jEh47tPu9vCkEBxMKAh/77hgy6lWW
         NRUQ==
X-Gm-Message-State: AOJu0Yzw3LXgoufcNZYIZGY/K7IJdpl2/rNa1AEcUvxNVhkElaMSQYU1
	HygBY0KnECQzULJlgZnOiLw9mFAAnYdVVMnBwGW0NPX2qo3cRP/7d6v1dA==
X-Gm-Gg: ASbGnctO6mH7O71GO+WKuvE2qMLeN0Q8PJSG/PqIt29AyRa88tibSMa46YDydjUW5cV
	4m41AIpzxn51RACQhBFxQrAw9xn/AQXcVNyNx/4qSCm8SQ1Vp1WnMN4/xSsQw5EVsFgZvr2gigM
	6nwzMKKmGPNn229WQSGBdNKVmjmv8ntT1YXyuOhX48LnZAzdA4UM5q59Ds/b0uNFc0KAExlZuwT
	YnDJRTGZD8b4dBlzsvA0DZ9UWWUZsf69g0f/O8oZo2XjpRxJy2O+GdBFOsYlewRDNxZfq7VwE2P
	ge5lwdbdSPsAQ3acCgpxJwMV
X-Google-Smtp-Source: AGHT+IE1B+pjvjq7uuDkVUNU1CYKV/DBHflObaHCSBmG1cgadSGDnR/ghEVt6H2VnzAnSOO9PhvQ/A==
X-Received: by 2002:a17:906:9f87:b0:ac7:b213:b7e5 with SMTP id a640c23a62f3a-ace5a2a92ebmr191871066b.18.1745494211322;
        Thu, 24 Apr 2025 04:30:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c716])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59c26316sm93675266b.151.2025.04.24.04.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:30:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring/eventfd: clean up rcu locking
Date: Thu, 24 Apr 2025 12:31:17 +0100
Message-ID: <91a925e708ca8a5aa7fee61f96d29b24ea9adeaf.1745493845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745493845.git.asml.silence@gmail.com>
References: <cover.1745493845.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conditional locking is never welcome if there are better options. Move
rcu locking into io_eventfd_signal(), make it unconditional and use
guards. It also helps with sparse warnings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/eventfd.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index a9da2d0d7510..8c2835ac17a0 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -47,13 +47,6 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 	io_eventfd_put(ev_fd);
 }
 
-static void io_eventfd_release(struct io_ev_fd *ev_fd, bool put_ref)
-{
-	if (put_ref)
-		io_eventfd_put(ev_fd);
-	rcu_read_unlock();
-}
-
 /*
  * Returns true if the caller should put the ev_fd reference, false if not.
  */
@@ -89,11 +82,6 @@ static struct io_ev_fd *io_eventfd_grab(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
 
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return NULL;
-
-	rcu_read_lock();
-
 	/*
 	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
 	 * and eventfd_signal
@@ -108,15 +96,18 @@ static struct io_ev_fd *io_eventfd_grab(struct io_ring_ctx *ctx)
 	if (io_eventfd_trigger(ev_fd) && refcount_inc_not_zero(&ev_fd->refs))
 		return ev_fd;
 
-	rcu_read_unlock();
 	return NULL;
 }
 
 void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
 {
-	bool skip = false, put_ref = true;
+	bool skip = false;
 	struct io_ev_fd *ev_fd;
 
+	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return;
+
+	guard(rcu)();
 	ev_fd = io_eventfd_grab(ctx);
 	if (!ev_fd)
 		return;
@@ -137,9 +128,8 @@ void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
 		spin_unlock(&ctx->completion_lock);
 	}
 
-	if (!skip)
-		put_ref = __io_eventfd_signal(ev_fd);
-	io_eventfd_release(ev_fd, put_ref);
+	if (skip || __io_eventfd_signal(ev_fd))
+		io_eventfd_put(ev_fd);
 }
 
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.48.1


