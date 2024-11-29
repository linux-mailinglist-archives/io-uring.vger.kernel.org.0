Return-Path: <io-uring+bounces-5138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32ABA9DE7AB
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5211161D76
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895B819CC3F;
	Fri, 29 Nov 2024 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6lIYDjl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E624219E97F
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887246; cv=none; b=cStZfhYpPoTELI9HSMZZ+cLSFRNJmX2l/BufchedsA6ZG0wyrxhsglJV5FlxDxt6TgaZgr5bRMSR3dHJBZQAGjZzuYj+CT2zujMfo3IUgKuckRqUiN469xesSim3bsmA2hoU4SYD75RYP6tp6WPCa0/Pix7go9UwE5jUugT8whc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887246; c=relaxed/simple;
	bh=pLdERTeJUP2FsZyKU28rGQ/VhRsj4YjeaNLB8EP/JYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8+JHwTUKwHf0vdEO8CrSCK59WXKtBSw5oY9mulWXkqZx7xf/eJPt1b5Y87bnNJeqfFBGKebL0YD43rUrwBaL12Nx3zv5CZcv4VMA0BYaH9ec/UHh0uYxh84+LP2IlZT+yqGIRZpa9DkrRAmo4z9UsI7FkO6EfeBMPHECLU6usc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g6lIYDjl; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa51bf95ce1so365711566b.3
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887243; x=1733492043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wog/MXIJc5UwLwczDRE7MZ3BX2Dhl+EKIi5M1sjuJ7Q=;
        b=g6lIYDjlFF4eQvpG8n/tRDKy7nyWgM2c2RHeu6nr4k+Tkfxg48Q673yEqpTl11CUiB
         BoTEeNsV+AW1RUWWEqhBqatYw1ZtCBKc7e2Say460P7yKA/YJZsc3A7zfXsdi1kEAClQ
         rBZK48TxmL7nje649JlMS9Z09mMGbUmL0IFbdVubPxO4pKnVccmFXRNFu6XtvJEXxSYS
         XeETh2K80U9lWOAZ1an/qx9nDAus4ZODE3080sdC1QbQDm/Ba7bJ78cYP2xL5fwrAZqr
         j/7rg4Sts17YhJeXKX4+Q+rQPLFszzJuasvC8l+67hOWFMAVfnhzsHqKLSkBHHP74hO+
         F9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887243; x=1733492043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wog/MXIJc5UwLwczDRE7MZ3BX2Dhl+EKIi5M1sjuJ7Q=;
        b=irA296u7EJs4jlYSRfum764wdGRVggEn/0cDz84buFLWkFV5+h+lezfh0oAXB7N9LV
         ntDetO9hPRNlZBkYPaTZsQBsxv6wSxuxoumEnGKqhQ/0yS45x5DVk1Mop52XPngT2T33
         vNuAJuuEQqrlS8a6muAH1eTfrdA1dQ9HHBL4WIWdyRWtyH0CUXpV9r4xXVJovxFfssT9
         U9w93o+qE+0vye9uNmwwJjzJ0TsloFSMjKputz8Xo9/YiE2wvAsccIqJfMmQVzuLcmxn
         SRjjYin0pVnAuFLzWxkCctuZ6JvOmpW1J4tZBPMsN50m/K5E3jrF3aE9bO8c9owTlim9
         f7nw==
X-Gm-Message-State: AOJu0YyxSkaSgQ7r5pq0kNVNQAh8a1hHU7n+tZIaO2rUyogHlP5hy64p
	HXu8Eqj75gU6sez+mENoO+FKu6rzoMhOhZ1bKSzZJ2IpZqXsmHzdmUxyYQ==
X-Gm-Gg: ASbGncsn0hf9sVGchwanvehE9R4eLf6B9k5LU87gSKpaMiS/VA7ukfE0eddox3b66y3
	zvlPu7NcPTlSdrLDckzsb9Uj38BJRG4lVkNkbkhKAVTx4kfu2eNViJpWL+FXd3phybOdOfGSmGW
	2/+X4tGPQ4qiZbZaFyjzfyna3uKQ/Ol97JZMXNUXl7qhSJAMBQQ/5id5442IU2YIiSyRNDOTn4x
	QOg7gKgkvdd/CCHLXwj3tmVqTcMQ71MhFGx0QBP5PUCNIgACLRMSCSnKQGkpKJF
X-Google-Smtp-Source: AGHT+IFCipBuzDfYP4y0z6LqzCmNaUMiihBaKRzq1o95NYizjq1xgmPUNGgnb+PLdSjMKxq3dpIOpw==
X-Received: by 2002:a17:906:3d29:b0:aa5:63a1:17cf with SMTP id a640c23a62f3a-aa580f23e33mr1138961066b.20.1732887243012;
        Fri, 29 Nov 2024 05:34:03 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 08/18] io_uring/memmap: helper for pinning region pages
Date: Fri, 29 Nov 2024 13:34:29 +0000
Message-ID: <a17d7c39c3de4266b66b75b2dcf768150e1fc618.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to adding kernel allocated regions extract a new helper
that pins user pages.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index fd348c98f64f..5d261e07c2e3 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -246,10 +246,28 @@ static int io_region_init_ptr(struct io_mapped_region *mr)
 	return 0;
 }
 
+static int io_region_pin_pages(struct io_ring_ctx *ctx,
+				struct io_mapped_region *mr,
+				struct io_uring_region_desc *reg)
+{
+	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	struct page **pages;
+	int nr_pages;
+
+	pages = io_pin_pages(reg->user_addr, size, &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+	if (WARN_ON_ONCE(nr_pages != mr->nr_pages))
+		return -EFAULT;
+
+	mr->pages = pages;
+	mr->flags |= IO_REGION_F_USER_PROVIDED;
+	return 0;
+}
+
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
-	struct page **pages;
 	int nr_pages, ret;
 	u64 end;
 
@@ -278,13 +296,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	}
 	mr->nr_pages = nr_pages;
 
-	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
-	if (IS_ERR(pages)) {
-		ret = PTR_ERR(pages);
+	ret = io_region_pin_pages(ctx, mr, reg);
+	if (ret)
 		goto out_free;
-	}
-	mr->pages = pages;
-	mr->flags |= IO_REGION_F_USER_PROVIDED;
 
 	ret = io_region_init_ptr(mr);
 	if (ret)
-- 
2.47.1


