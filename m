Return-Path: <io-uring+bounces-3250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3F397DC0F
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5C3F1C20FF3
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EED14D6F7;
	Sat, 21 Sep 2024 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W8n+IZ4s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D79149C50
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905808; cv=none; b=jeDWtV9d71B6Uj2NwikPprlTahdv6aptg4h9wU+zM0k//V6n16Itfg6JKPuc9xoPrZjLRG9lc9gWSCyNsQq2cTtbMJeSikqBmO2jP04AG7sb38HlTVtlMmSCjMEmN4tRJuiT5F28FfIQmW+t0fzrmuH2jCyNYvi0Sqqjl/oHuQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905808; c=relaxed/simple;
	bh=WrVTkfnAvzDJx/0lbUHu9OmwXYRQFHd/6xDsnzvPS1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlzuLmtRutexB4WvRY4ql+MbkNHFHURZOl4URGRIsM7gTUfkgwWeZjS2CD/qNKEiLaPITyOahgu6SdSffOvgidO5R22FuScdYF2jrkVtlXzDh+d0TaNNXbXRr4EwCPZLTbHYqgzKy1I7ExrBfTfPo7hEfoE+95oltOxavg0upDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W8n+IZ4s; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8d13b83511so316126766b.2
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905805; x=1727510605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bO/KRR7ks2vctLl92J7KuMLnkhNzTt8xT10+GbHUAv8=;
        b=W8n+IZ4sWGdLt0gYjuNwsP9eQiykEOtVpuaQH1mVr5ArAnsPsVCq1cJi04I3yss2/J
         6iryVPVqwdzDzMPx0kT3itKhEzEP/XDapGE4VHEvh+IEcfieR4szCC4ip3oClZiiWusP
         Z9NOrI2+dMGItcmsywYBBE/7qFE4AyHZXj+qm44OCAySyculx8Lg7bcTyDaiBcQjD0xT
         IM7/lxdKkAxO7ngbzgBE/wBJ5u9g/ZdKKMhJa2lzye6u9WnzWYGR2Hwpkk4Vr4IQlvvW
         +MKHZsCqWw+l45idMC84/B0wP/iJBeTJS/SKb/T2HaJdjhV2eBxg9qenzd5hp30+d5WO
         +LQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905805; x=1727510605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bO/KRR7ks2vctLl92J7KuMLnkhNzTt8xT10+GbHUAv8=;
        b=rWlhAIuQbe0S0kGDPbrsKMHG6VauP6ErNTHxELGMA+8AoXclXIPo37GLZx0unNclfy
         YHXDb1shVfbu5/YGkNv+IqMDbFRQsC41/fM3KXNtMslpAdINC2JhQrnCYPphWLcefPna
         LyHW2qqjidy9mlXDR2/Aopdv3xITI3txpm2kkAKjo7onsjCZw3dGpUKHeT4XJNFlypwD
         6ZMtACuQLL8Hd2WhDGtXzISIg9BI447/w1R82APE32Zl/R5cpi24/IcYfQqPQO2ns9XL
         BNcFPYLZWUWEijZxI3ZzGx3CeEbbKdTeQdOIz5IuayRCJMn3LPS+dEHsdjyUdKOsF9k7
         pDgQ==
X-Gm-Message-State: AOJu0Yz03FpkaTSy0qdjH7QKZ0yhC4fzOlxqJ2LG/Z0h3x92cj7FdOfZ
	/LfdEhjxuz5rvTnz2LRnfsxQ5RU+1kt4WiOuTyjMwhnmVF9nspQCgUWjiIjuZAUyneAxwiZh1QG
	Ea3i/ltOH
X-Google-Smtp-Source: AGHT+IGq1AxHnRUAoIqD2MH72JAbc0JqbhH4k2x6dKO/aVa2WyVRklLhF/uq5bq3pRVdfisWZqeB1w==
X-Received: by 2002:a17:907:60d4:b0:a8d:4db5:529 with SMTP id a640c23a62f3a-a90d59299famr457905766b.48.1726905803782;
        Sat, 21 Sep 2024 01:03:23 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring/eventfd: move trigger check into a helper
Date: Sat, 21 Sep 2024 01:59:50 -0600
Message-ID: <20240921080307.185186-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a bit hard to read what guards the triggering, move it into a
helper and add a comment explaining it too. This additionally moves
the ev_fd == NULL check in there as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 58e76f4d1e00..0946d3da88d3 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -63,6 +63,17 @@ static bool __io_eventfd_signal(struct io_ev_fd *ev_fd)
 	return true;
 }
 
+/*
+ * Trigger if eventfd_async isn't set, or if it's set and the caller is
+ * an async worker. If ev_fd isn't valid, obviously return false.
+ */
+static bool io_eventfd_trigger(struct io_ev_fd *ev_fd)
+{
+	if (ev_fd)
+		return !ev_fd->eventfd_async || io_wq_current_is_worker();
+	return false;
+}
+
 void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd = NULL;
@@ -83,9 +94,7 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 	 * completed between the NULL check of ctx->io_ev_fd at the start of
 	 * the function and rcu_read_lock.
 	 */
-	if (unlikely(!ev_fd))
-		return;
-	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
+	if (!io_eventfd_trigger(ev_fd))
 		return;
 	if (!refcount_inc_not_zero(&ev_fd->refs))
 		return;
-- 
2.45.2


