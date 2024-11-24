Return-Path: <io-uring+bounces-5015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE65E9D783B
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 130B6162CB0
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097C214F136;
	Sun, 24 Nov 2024 21:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSKAMIOi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0F115B97D
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482733; cv=none; b=U3yrD0aIj/NcDKXcL+seMX0Db60mwLbCT1RijMRTRvrMghojpE/wceG1ZvMYhwUrvm4ElvqjjXEhxfrWtYQIdseUAk6FwtVhYkw2o2mKhO8ivgF1gajLFSHVpK9SMNBTMmWS2M68JVcUrV6UZ9DNB9g41K8SQxrg6tr/0kaGON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482733; c=relaxed/simple;
	bh=AOfi6x19gzyu/5rrZe/6KOA7e2hddpGJfDp/n7HaVeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8KxXKqqYZIBjk1HINF5QwE3D/ITCBULVcA3wp+TNdyO0/MpIntHITNKaiAIlBoLCDowkdPmp3VlGqfP7wZ12aVX2f+3QyaDmyfB64QrKIFuqoN1xNnfyq6j/DaS9DZqziUFTJfx889B3V9YVRYZlDk+le5kLSar1qCi3ly9d7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSKAMIOi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso48596845e9.0
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482730; x=1733087530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKExDGox31CnOmhkyqcAp7yYwe/A8AEg0kEs/PZerJw=;
        b=GSKAMIOiExYOQUqVwt5muf1F7Me3oR6Jxm5kMo6c2rWZr5kcVNTaSthCFzG9OFgHP+
         9dcTUzxCtSyKE39NGODG1L38fnZi8rjFV5CmDpUzjrlQHpn8F2IgGq1ksWvx5cJAksPz
         D8YS/ozbgD6eVz3mXxnCyew7mN9s0dPNOrptwhpICCvoS7aNu0Asmx5dwAoC+kbt3WdQ
         XL+PvGnv+DimvW8E/XtmGkRAdkrCaZBK048XZpuH5SwQNLxiR0clZkE+jhSJXQ9b4GbL
         sISGh+4nFRbcC6yy8avk+mb4M8e24hUV+6pgqQhdAj0V7YoTRc76lLDlSg1WGYN0xIJy
         QBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482730; x=1733087530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKExDGox31CnOmhkyqcAp7yYwe/A8AEg0kEs/PZerJw=;
        b=kPzCXtAkWKvQVakB1BNsaLLWnqQqnkxISKJagn7NXShqxizXgLZ+yFytH1yBoHr4EV
         6h/+E7Tw8uM3XOXMr+M74/IW3J+Mmy366k+7jAUmh9aNCkW2MqG7U7qwpFryigqEYCdy
         wVa7T7espWgmNJfLdzupX5qv43zLCt/KDZiyhqtvzEUZtk/D5H+sLv2v6umltBLTmwgz
         PK17LYYpZpck92uaf7FNTXhEJqeJG6E6RVZVvNZpYE42ymQ47vJp03ffPlfmpAXb12im
         Ua3nkX9nZM30UiF61D8TcbJ5EtC0aR7yS/ixpx+lWt2Zi5Nas5YYgIzPHRsE1gv3Y6mj
         tbAA==
X-Gm-Message-State: AOJu0Yxc3N0+4Fl57icvhZBVtADBqPViLpayQ0lDgO3dIWtapl00RgW9
	JzJejS6lHCms5v/V6fS7i7WUON+7rzcjfB46jM++F3slrIHUV9AO5sFZPA==
X-Gm-Gg: ASbGncvtLEgxjOiH5A94rOO2X4y87HTbww4r2Njkn+iwZWTT5dl9yoFlYwKWxvIHcZD
	QY13OFZ7V+jMFvs2iBA0HiZqCthjR2n+mXB/d2pmDSwkOF1cxZRMULyRM09GslcSEwiikObLlfx
	Y3MXtBJLTqv1+DXY8jXnY4nVx3lrZbTvJMa3tnBgnun117NHXsn6uvUBOj4cflFwPSGbbG+U5HG
	N8cbA1nrailEVJImUHs+IPPPnl+wM6iM24Q/OOyY59U4jPZjqtKrdJXGH6yesI=
X-Google-Smtp-Source: AGHT+IGtPe5Wu0SEuXNZJQ3EQyZ6browCpeZ5VDV+UdyUpZJD/TTNW0HegwjKG/dWYajR847Oexn2g==
X-Received: by 2002:a05:600c:3ac3:b0:431:4b88:d407 with SMTP id 5b1f17b1804b1-433ce410255mr105545035e9.5.1732482730126;
        Sun, 24 Nov 2024 13:12:10 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 08/18] io_uring/memmap: helper for pinning region pages
Date: Sun, 24 Nov 2024 21:12:25 +0000
Message-ID: <694614a8654a16d846439cebe666f1e04d4dd15e.1732481694.git.asml.silence@gmail.com>
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

In preparation to adding kernel allocated regions extract a new helper
that pins user pages.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 32d2a39aff02..15fefbed77ec 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -237,10 +237,28 @@ static int io_region_init_ptr(struct io_mapped_region *mr)
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
+	mr->flags |= IO_REGION_F_USER_PINNED;
+	return 0;
+}
+
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
-	struct page **pages;
 	int nr_pages, ret;
 	u64 end;
 
@@ -269,14 +287,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
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
-	mr->flags |= IO_REGION_F_USER_PINNED;
-
 	ret = io_region_init_ptr(mr);
 	if (ret)
 		goto out_free;
-- 
2.46.0


