Return-Path: <io-uring+bounces-5013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 278159D783C
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DA33B2211B
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C34514F136;
	Sun, 24 Nov 2024 21:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gaILUWc9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85159163
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482731; cv=none; b=eiztTIqIxQS67wHxz3kqFs/pR7DIFdJz9/hbGl2VnCvwziyjShjhcM4nTG/2J+OpNYzEfYKpCwlw6T0WwcjR8GwV6yi0HKntckCr3WTSr2loi82Z0ZY7C1rAC/V78pIPP/yhQuGTguf+2AAKC0mvmkcfYAxGBlvbC0wFVQmTlKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482731; c=relaxed/simple;
	bh=dujS0aFvz1kY8S8u3h9P118Wqvzr24FydnRRbGhqzO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5xExTBVLvKxRZmV10EuLZ1rbEs0bLl5Mjju4phzLRLGLmWysxAnrXacvoAX/Qgs349ijBjkxCJ6f4DK3mb+pcF+J1onHnYDmHvKsIZ8R7EdKxfdL5bAC2sYdF/KarYcZ7CT0H8csn4ebbYvquCaHD7Os1JrmNwG9ZDBvp/pCCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gaILUWc9; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4349fb56260so1841045e9.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482728; x=1733087528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPuIWteBXaKyE6IW5ybcaZa+VOFWSvl/ffKsXytsJvI=;
        b=gaILUWc9TNCTJiplsHAdyAnKbSt4sV4eF2VuCk/ysvACpuP7NLz0j0e5IGDnS3CuY2
         h7XxcGdeQVSGG0DZF/ZBujesFDvTh0w/38ItosgGQSWWDW04gSDBTejnqhmm+f8GBA4j
         mCT0Xgrm9PwHfEXzyP3/peuUuJFgCcODkH+sjjnA+7UfLRQDhToIeK2T9ryVzwy2ijiG
         jcGyM6drIqTy4yBrcbwrFNJuUiYywbW7DPb17n/cJU7UKZQ2RgohJa2djE5LxUfyfaiV
         BEYJIS+etsNNhvXOvucnUEnJzv+d03NX5AMu22MTSto+h8ygXI1pgFg5R1QjvEsKSVfb
         vayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482728; x=1733087528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sPuIWteBXaKyE6IW5ybcaZa+VOFWSvl/ffKsXytsJvI=;
        b=CsskT//MgRnbYCOXMEO7H7y7EcHFcZj97AL+r0ZGA/r24CXhGqOihrxLaVdj/H4qkT
         dk0fXZrZsuwuo0JkhMo8UUvDZrAmUe+bz81/LrIZX8SL3Bmiq9ojJXRBFrp5JT4mpHlH
         Kd/undUnvmCLyytFZo6xXJTCLZbFfmWcwE2MUZf9DesrC2MrMMXOK/8xreJvOvYvwPNS
         wI1IDCGC/xvT+Gus3v/8r1ldb0vAPO7TGQDO1pBu1sz6VLqcfygywi8j3fOk7EEgqZ0t
         kobS/+ruedFBQJ9mshq3iqMC0yxmfdc8S+h+QW0p8j9f5feCQjYQV+Lx8HsdjZ0qMM4+
         Z8nQ==
X-Gm-Message-State: AOJu0YyN4oWhNIfFv5uHLkenjhUf9yYHgFIi6lCN79qunDlCt5v1LOE0
	/ZS3OF5FaiRSgDtEgF2+82KVwPlsZ/0uRYWcTGayQZ9DU+FKpBGzI+51uA==
X-Gm-Gg: ASbGncvZUuffkrLNZOuBGadSXtvGNDSohfat+8cTMZYjRpA6wqMI4lWpsJ3FXwD4F4l
	f5Hnl33XCvtyEN5M7l7HPzQh11haSIxr3drkCsGvcqOoxX5+dVAQWgc2SK9VmoWF2rxDkAcM3mH
	RTd/KUhPSP1QxEcdG6pvM+EmWDnLLUm75ZUQVk0Y+qS/2cErLri/9IX0Q3gSz3aSuNJPCv97NqR
	3TmX1tvTfcKlKojLZsE07MDhg9WUJoDi7781ASnqK8jMgcifPbcALRJDDjnAlg=
X-Google-Smtp-Source: AGHT+IHd0iE3BCSRGeO8VjoEfrfhIYbJu4koAcnNoEc5/3Nw0nrDDDydq9jEILXWJooOs+yALvNBfQ==
X-Received: by 2002:a05:600d:4:b0:431:5847:f63f with SMTP id 5b1f17b1804b1-433ce426802mr96062305e9.13.1732482727531;
        Sun, 24 Nov 2024 13:12:07 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 06/18] io_uring/memmap: reuse io_free_region for failure path
Date: Sun, 24 Nov 2024 21:12:23 +0000
Message-ID: <79927f47b1506508b877607e82af0d6a2c53c293.1732481694.git.asml.silence@gmail.com>
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

Regions are going to become more complex with allocation options and
optimisations, I want to split initialisation into steps and for that it
needs a sane fail path. Reuse io_free_region(), it's smart enough to
undo only what's needed and leaves the structure in a consistent state.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index cc5f6f69ee6c..2b3cb3fd3fdf 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -220,7 +220,6 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
-	int pages_accounted = 0;
 	struct page **pages;
 	int nr_pages, ret;
 	void *vptr;
@@ -248,32 +247,27 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
 			return ret;
-		pages_accounted = nr_pages;
 	}
+	mr->nr_pages = nr_pages;
 
 	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
-		pages = NULL;
 		goto out_free;
 	}
+	mr->pages = pages;
+	mr->flags |= IO_REGION_F_USER_PINNED;
 
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!vptr) {
 		ret = -ENOMEM;
 		goto out_free;
 	}
-
-	mr->pages = pages;
 	mr->ptr = vptr;
-	mr->nr_pages = nr_pages;
-	mr->flags |= IO_REGION_F_VMAP | IO_REGION_F_USER_PINNED;
+	mr->flags |= IO_REGION_F_VMAP;
 	return 0;
 out_free:
-	if (pages_accounted)
-		__io_unaccount_mem(ctx->user, pages_accounted);
-	if (pages)
-		io_pages_free(&pages, nr_pages);
+	io_free_region(ctx, mr);
 	return ret;
 }
 
-- 
2.46.0


