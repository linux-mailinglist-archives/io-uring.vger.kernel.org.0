Return-Path: <io-uring+bounces-10907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E588C9D6AF
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2B74B4E4C09
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543FC21D3F6;
	Wed,  3 Dec 2025 00:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbnNp1lZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBBC21CC60
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722211; cv=none; b=roMXwLQhftcNevUxPmNmw+jy5sWAwBu6iD+HfV16jDSRWOTDc7KkqwkaRzYTpm2on0j1Nj8LIVz3y6NxRqHChbMWSuTZChBk5SdJ925jEzfr535fZaeT2BHYH/jxQEFuo+E8pegeAEeqwBUFb8vMN5IYDEd3CAtMW2e8i7Rn1dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722211; c=relaxed/simple;
	bh=afoyDzoiPk8LpuqO1S+0owVvKfZJf7DjSxtapBSXLJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVVaU5wZmj2U73GsjNrMSA7+f+19kg3vKsXs1hWFDcYuByd8eaH5SgQD3GN9EU/N+AGltQG3KWPMbtNkBh7OmP24sz6xelB9DQHDkPtwzDt9X/kzZa1WgDo+yBdsM3f2Phr4m1GDhqvAxhY0ydvqBlsrR/u14aemSzzf/JgIIzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbnNp1lZ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aab7623f42so6645327b3a.2
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722209; x=1765327009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIn+I9DWZGks0gL0wMu6vEBklTa1TvdGkH3R5xpUwHU=;
        b=nbnNp1lZL9tZy4CmZ/iWHEi9eTqt3B91uDVF5MUWo5pWrk4A/RMqyT8GGgMyEEqmfI
         RIayu1FCYWKLtRCf+A93cQxmTUP1w5SgZtrPh1reDPzRrXgMXB86dSq3yHGDc6W0kpNy
         9FUD10Qn/0CGz8y4DYG2FGZooxHCbce1vJTvh/UICafarvHZlrll4tcAGIilPqkNNn9C
         7FnVZ+7IdI7JgWodYMl33hrRxtoXN4QuiVC3itQOWR7YBixyVregl/2HXa0yWWrcSUKG
         mb+MPWuTea+ZawN6HTZlDbDYRmUILUTIqdxmIPZLDzRAeUySgUop6lR/ChVh6Gg/7C/L
         7Dhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722209; x=1765327009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QIn+I9DWZGks0gL0wMu6vEBklTa1TvdGkH3R5xpUwHU=;
        b=e1osnJMHj/6XCsmM/lY1ucDpfKuAIRa/TqM9xjEJG0wOVwqYS4UrboFFibdNwKaoZL
         f4yRqkF2c4o1Inr/CyMK3j4SbH9rnhVDT4ogOxFadp2uSKd+c5iAESrGC4Y/nQraPMEt
         1kJBJ3bjo0tY0112QY+q1Vb3zc4qOoqONn1gfTi3WDAcn1JEoNUKC18VS2JW9moWdi+8
         p4LjJbU65q84Zcf3kxuFFRTc5GOBMccNCrHnsLlzdXy3PrckDCphYnGmHn3VxUSSCmFS
         lSooueboc/3lEtG7izjsenzMEAZA7Fmlz38J37+BtosUeGQ+hu7ta56azcO0eeTT1MI0
         mXsg==
X-Forwarded-Encrypted: i=1; AJvYcCX6viCFtgE4PKdmzpuD3g5jgZuWb4zmeFSQppOyR2JZTM5aqPqJ8ce+1heEvlfieSu524HLJRaozQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeljyXtTUmvFLUDrRwhR8ORfFj9CnzNYT0afNYlpWIh33h8R6q
	n0/bUZUBwnwAN20ACQzuNc/KlULrz35yJO8arC1UlGmroVM/8iPwmEVQ
X-Gm-Gg: ASbGncvpFkK154JeBLnAframi3i4+7rV2CTJlDsuS3ni45rNjWgOFujTIGuFV3+Np3w
	mkUdHwuGskR2VEgyGSlvkzskDFZXiGD9eR7sdbz9rAegfJL9/JRwS/0vU5e76y2eYejUG5nyy8+
	e8Ra8OYojVF418SVweG1gbwktwKZkbmZ4MVIsQx2ExvX992snpE1NWOTmoaDgrS478WjiAOLa0d
	fRWoMVfEDGd6PQ9EMNyLtkISDx2vl/JaR/82Mtubv0sRGHYL9ZytJbrqvLOhwF4HQM0jAFjkVVM
	RC2gyXIx5WzkH04H6p2OVZvIQt6Zs+hvIv74rAppa1HXNP2B3OZ93TZjAHjxRMHhOsa/aRLUb9w
	qyG+YCTNYsvb/fLGUCDJQBHaIr8+zffVYK35utkRA67rLau/CiMD+Av8j+SehzVzmJZ8qX+nOdL
	hx3JS4saNxZZ2uql+A
X-Google-Smtp-Source: AGHT+IERKuXG4e7N06PKcTxod714QF67phubaFnfJTjNtHhlJZnatgwWOnZQ6YIUfoV+7JgMlRp2hA==
X-Received: by 2002:a05:6a00:2e20:b0:7ad:e4c5:2d5f with SMTP id d2e1a72fcca58-7e009830ba8mr505675b3a.3.1764722209114;
        Tue, 02 Dec 2025 16:36:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15fcfe28csm18106859b3a.67.2025.12.02.16.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:48 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 12/30] io_uring/kbuf: export io_ring_buffer_select()
Date: Tue,  2 Dec 2025 16:35:07 -0800
Message-ID: <20251203003526.2889477-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export io_ring_buffer_select() so that it may be used by callers who
pass in a pinned bufring without needing to grab the io_uring mutex.

This is a preparatory patch that will be needed by fuse io-uring, which
will need to select a buffer from a kernel-managed bufring while the
uring mutex may already be held by in-progress commits, and may need to
select a buffer in atomic contexts.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 15 +++++++++++++++
 io_uring/kbuf.c              |  7 ++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
index 90ab5cde7d11..2b49c01fe2f5 100644
--- a/include/linux/io_uring/buf.h
+++ b/include/linux/io_uring/buf.h
@@ -19,6 +19,10 @@ int io_uring_kmbuf_recycle_pinned(struct io_kiocb *req,
 
 bool io_uring_is_kmbuf_ring(struct io_ring_ctx *ctx, unsigned int buf_group,
 			    unsigned int issue_flags);
+
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags);
 #else
 static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
 					unsigned buf_group,
@@ -55,6 +59,17 @@ static inline bool io_uring_is_kmbuf_ring(struct io_ring_ctx *ctx,
 {
 	return false;
 }
+static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *req,
+						     size_t *len,
+						     struct io_buffer_list *bl,
+						     unsigned int issue_flags)
+{
+	struct io_br_sel sel = {
+		.val = -EOPNOTSUPP,
+	};
+
+	return sel;
+}
 #endif /* CONFIG_IO_URING */
 
 #endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3ecb6494adea..74804bf631e9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -215,9 +215,9 @@ static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
 	return false;
 }
 
-static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					      struct io_buffer_list *bl,
-					      unsigned int issue_flags)
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
@@ -251,6 +251,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 	return sel;
 }
+EXPORT_SYMBOL_GPL(io_ring_buffer_select);
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
-- 
2.47.3


