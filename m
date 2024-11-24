Return-Path: <io-uring+bounces-5012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4209D7838
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 708FD281EF7
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B03113FD72;
	Sun, 24 Nov 2024 21:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FgkExJsN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98754156960
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482730; cv=none; b=BS7mO2gGkYjYUWh+7AuvmgCCsShllQ4Q7iN5qJ8rSMkl2gw3c1AriKjYrSwMhSmoIeOG15s6drXHXj1StKn8p6dCttRK+CmKOOxkdYTOXcKrx2CjAAuCnA8fFNYkNVR+WfylVBY5YTeyEN7Aunp7YITmi7g6+KiWeZLg/L3fGaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482730; c=relaxed/simple;
	bh=A/BG30k4dPSYeGyQ9WWlDhGgvjjruOFJ2EsBN5g0230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHv6Fy2Cn5WJLBwFQQ7HZagiHRCjxa71M+zB6/ElxeQvd++5OKar7++6TiFdLUH8mXCn6xRR31Eyie8vEt+SDWWKzb0PyLpt/4hSIXSnMxrWwW87skiSaHNazU8FRaYtI1oFKrz8fGD8D84Mx7iYOMbjJiUzDkeP6RnTCK5FwZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FgkExJsN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43152b79d25so34026435e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482726; x=1733087526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cQnp+lrUnHITWCsKfUZMU+VFdBNN5rUz4oDhu1P1PU=;
        b=FgkExJsNOiPu6+InZ1AyoMXm4nBYqwFVGiN5/tcppV388zig4UypsP6z9Yl8FnAZAF
         MZiJcRUXVWHrtwHzasblZgPNuRGSN7w2pOV+xKe2w6W0k/72e0DmX+GwC7TK2XgV+HtH
         BD6SDRWmce7KE7DEYCee0C+JIdLUci+izY4XVsjc0qDRRclRKnMfSQM20i8jSAsNPfDf
         0xDrrg48C+yAVr9VZhGZ7HFkFrppwyq6aJ0M5eZSkUnrtTN9eKAS9a8m2mgZdVxvhPn+
         OyOoIRSqHb1XLAhXbZSHg37lH6w/dQEFfzPZSbYtq6nUwDmpk1/xnJzuXMLogw8RR9jo
         xUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482726; x=1733087526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cQnp+lrUnHITWCsKfUZMU+VFdBNN5rUz4oDhu1P1PU=;
        b=j9m0UBuxmQvdFDDjGVU4rkJcgc4gFFyIsAdo3GoiT1lVNvSyNoDdvDBTYqcyadcDNW
         DO6njE/BVXz3BgtG6q6LHnYgWDQmNv8Unkn62xn/7UKTyCm0fZeGSGxLWldOiJrBsVtQ
         RiEYvr5Nx7sbaxJIrrOS1fEE7FFMx6JKwUAoEFeOVbn4QtYsh35nX4O2QtqTGZ/5HMQv
         j8vj+25WarGfHkcatFDi2di6SDJnpLomCGuHpSXyYPbToUAEn0cVJQDy97uFJ2fW/Q2F
         Iq+aE0WgxTgsdD8QG9QoVqmVAfbnRMD1RSH9WQctE8AaIL8D2DoUvyXku/8drOqRuNF+
         0IwA==
X-Gm-Message-State: AOJu0Yxe+niQgfp+dyLB3kPeE3I8cwGetwiLW7uWKvKBy4pUf3aIqNjE
	iqr+09svBrbX5zWV54Rvo0QUSrv5IOdaY3HJJJXTEJlHyoIMLU/Uyl9Afw==
X-Gm-Gg: ASbGncvXq0T7N1OzsfRqQ0m9Sk+NCx0yyLOA7Fvo+vtkGRqCAmJwhcVcMwxzl7COQ4d
	MAqnTK4PDPWHcc4FIznHoUUclflmd9H04GVS6ScgHjKks/bB2revAtZhPno7fmJyU3Uvrrw+cBf
	75je9caXwcobVXQxooGi2fLpdwi2E24VhW0WSjxkpe5o57JEEq/eq4DIFoNo3n4pzAfWU/AwZow
	LJdKsNdJYTCmWEHHBI8s7Cn7dAYw7wajLC6VcQnT0y0klxSNADkXH1VUHq+KFw=
X-Google-Smtp-Source: AGHT+IHiFkzJjuDs4LcWCvAlzsfaVRFGPRDADzkmwlHomkgvLWXqzHuA7E1fgdkW7vZy49e35L+VgQ==
X-Received: by 2002:a05:600c:3b19:b0:42c:bae0:f05b with SMTP id 5b1f17b1804b1-433ce413c8emr78182685e9.1.1732482726372;
        Sun, 24 Nov 2024 13:12:06 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 05/18] io_uring/memmap: account memory before pinning
Date: Sun, 24 Nov 2024 21:12:22 +0000
Message-ID: <686422cc34b24ffd682abd6443904d18c0d0e06b.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move memory accounting before page pinning. It shouldn't even try to pin
pages if it's not allowed, and accounting is also relatively
inexpensive. It also give a better code structure as we do generic
accounting and then can branch for different mapping types.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index f76bee5a861a..cc5f6f69ee6c 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -243,17 +243,21 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	if (check_add_overflow(reg->user_addr, reg->size, &end))
 		return -EOVERFLOW;
 
-	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
-	if (IS_ERR(pages))
-		return PTR_ERR(pages);
-
+	nr_pages = reg->size >> PAGE_SHIFT;
 	if (ctx->user) {
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
-			goto out_free;
+			return ret;
 		pages_accounted = nr_pages;
 	}
 
+	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
+	if (IS_ERR(pages)) {
+		ret = PTR_ERR(pages);
+		pages = NULL;
+		goto out_free;
+	}
+
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!vptr) {
 		ret = -ENOMEM;
@@ -268,7 +272,8 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 out_free:
 	if (pages_accounted)
 		__io_unaccount_mem(ctx->user, pages_accounted);
-	io_pages_free(&pages, nr_pages);
+	if (pages)
+		io_pages_free(&pages, nr_pages);
 	return ret;
 }
 
-- 
2.46.0


