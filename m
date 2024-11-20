Return-Path: <io-uring+bounces-4895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F1F9D448A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D430F283462
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A711C1BBBE8;
	Wed, 20 Nov 2024 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RaU87vA3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16411C1F12
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145596; cv=none; b=YfBXL2o4RLOEsApt/hgSiDpFH+fgtJU9gD9SDgRahkPZ0JWzYQjAx7nabD2kLdxcg2bcH3Pzd9CyG4+2k3wB3L/hLaWp6oUakHI7cRk1jrukM1X5mfgMP7qS6tnO9pUA6U2bmU1h8g0ctJnhHrNjZ0ZUBTudMWc/SEu+isLUIYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145596; c=relaxed/simple;
	bh=AOfi6x19gzyu/5rrZe/6KOA7e2hddpGJfDp/n7HaVeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efkuSCXNJY/JeRhNb0s91dWwJA/KRFqcrQrE+mC9iAq626wWMEC20DUm+FMyxOMosstDuw2f/oDo6RTUzXoECZBCSIQOOPZxBO8MAs8p7tJflfQxtXah4lbZdXPMwq61TlWfdZkStGZ7shDDLZnFfngfzawqokdMkb3UA6v/0e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RaU87vA3; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso49774266b.1
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145593; x=1732750393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKExDGox31CnOmhkyqcAp7yYwe/A8AEg0kEs/PZerJw=;
        b=RaU87vA3uBKXknmCyscOy2UQx3t6vTZyJMcxwKuhD2/jC4GGAx4Pn0aAEN1rPm1ZZw
         CQcp20bxXns3FCoDLyBZMNJ3b3HHcKlP+FkAZZb3ABCK2MT5XaqoEv6zKHimFs2GpfvW
         NMYhOdlIUY9JJvL3xDk6En/07BAEhvonKJt1QI91fPAk8tni/6//GaLNOXsSPyRIg5Lc
         L/jntH1w022J0/KfYMrD4gO3e1zi/1kmiuP8mEH61F5TTagW8r29xS+aTeXRLkxZnasl
         fiEADRhK9LzJmfLT6GbCbR1sDq80Kc88Ch8mm4ZGvF3MtKbqC4aNZVFhNKx0pC4j2z0J
         2rCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145593; x=1732750393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKExDGox31CnOmhkyqcAp7yYwe/A8AEg0kEs/PZerJw=;
        b=vFX2G3NmqXjTpFI//ieX0i9cyflMBOdUhI9dtl3si0kwLDUnz3SguMvPCELEznY/xA
         5ef8tvNezrDTFANtOfV3X3t2YzJPv/fzWahg9ZT06WHrrBPr0F+txBRaIfMZAOHOGHL6
         tNE1Wk5SAmMn+FmA5lVQvdbhx/JTgSHkxqU2cCiIj34GXXLCF4g0CTREFcE9Gn0md3JJ
         TLwemwDBoFXo36+o61xfjgSdQiQRY1G4P9a9rKFcsP3We3r7BVtbdLY8lKtBGJLHmVg0
         bEdYrSuNO4oCCm1+pJ7CEu1dBJj6GlSaRpKtqgrGPXx4T2vc9yRYqR2kRIlT/+/FqCNg
         kOQA==
X-Gm-Message-State: AOJu0YyAjlZ1h3lkW/IGK+qWffd+BY1YabmvqxWTmyuEHSj7VucLET6g
	NvEet8ynYMVFlBA+jmJvwyzLgGZ4abO5FVcDvMHNtJoKVL6UrAttM7Xf0Q==
X-Gm-Gg: ASbGncvxK5WWZVZs9awXfsgnh05KX/UBID1B6zVn5VQwT+zzyBDTeaTm3ZnbSwCDy6h
	GQZmmb0L/qoxB8B4sMP703RLC0ZoABPfp/Oprkv6RMJScG9ZxFbvYFeOzz1ThNh5PkvxuXnEZJw
	ZODtJEJ6HBc7CB0i/UAAwUFpUqlljh0+llQgVEQmSbxWu9q5Qcehr8229AUrTd0bkoXQEW2WB54
	wSGAJq24MgN4tqM+zkvNWMLZyzOpRvYjy5o748FjSj/A+ZJeFOaQDjybJG8o2P+
X-Google-Smtp-Source: AGHT+IFMVUw3mUobW2DnWAfq4vB9p+OhvmK4OsYjRpVjZ8yiIIQfTqBz+vCuM17Io5d7BqlXO/66dQ==
X-Received: by 2002:a17:907:2d08:b0:a9e:d49e:c475 with SMTP id a640c23a62f3a-aa4dd57baa4mr383783866b.26.1732145593041;
        Wed, 20 Nov 2024 15:33:13 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 08/11] io_uring/memmap: helper for pinning region pages
Date: Wed, 20 Nov 2024 23:33:31 +0000
Message-ID: <e24d99bc46d23b24766b10e9042eddb805520752.1732144783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732144783.git.asml.silence@gmail.com>
References: <cover.1732144783.git.asml.silence@gmail.com>
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


