Return-Path: <io-uring+bounces-9811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8DAB59A39
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A33B63BA061
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B3A341AD4;
	Tue, 16 Sep 2025 14:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GDfU+bLc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A90335BBC
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032824; cv=none; b=M4i47WTuOTA5Wc8PxTHy44YoKbzGkBjLtdSVG3y9VeSYF9/NKRPa5tYoxdPzPkTFwm17yyzvGEKGuSbjn5i6VZrzCLl3ga30BWXxJnM/H2Tob6s3obZdp2eh0GH8O9EZ/61julo3L2uhkzH+we8xgY9EXefss5Q1dI4plZVMfb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032824; c=relaxed/simple;
	bh=md/u41YuGYWtEQ7kexiZRvpClbjwM6XPeJYgxDSf0Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OplI2eQ1M6cKuViO+jMMYrb96wcf17LqTFag/NydIWJPuS6NHs/vt2i+rYa0m3lSh0SJKDQKwiQIljLBLUNeLZPjKDBOuLV4gX2RED/aHa6H5V2IlI/VY9ZsdNdzKVD/PhAMpzALRu/HtSP5IhL5Qo4S95Dn4O2Yz4rWp1cQ7KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GDfU+bLc; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ebe8dc13a3so1117941f8f.3
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032821; x=1758637621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73c8L+i7W+SsbayytJARAwM9cZlDtn5qBWzXTgfB4mo=;
        b=GDfU+bLc4FMtJ/4UHF7w9MuRRcD3tl5MeXiN7k0kavnuJkCWI4iZZaXap2R0s5XVl1
         iSf/IQRAMRjGBpj71/iZQn4kexdWIwIZhxBKiVIMPe4c8L89P9Dg4QnTrPAZhWjUz1BR
         +jdccktJX29TBGwyBomt/a8DNRYSjFDpbhuamTv1jVvOQXecX3+7s4+p6or9lWGB053Y
         HDe1hOvLz5wB/d80ij01G4fSx4sbuzizsy4UawNktBqK9tbQcDO9bIdeM6xQuMAEsDqQ
         d6S3oST3wLDNfOdr2Mvrx/VkYozi9w631cWnZXJgHEzi69hAQnnxeGVBL/tF6gtLQtpq
         Xw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032821; x=1758637621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73c8L+i7W+SsbayytJARAwM9cZlDtn5qBWzXTgfB4mo=;
        b=NvyycWzSKO+Ef+LBQt+7o0r5UjSL/vY192S1CpsmImqnOKpSrMjfcz9oTU+2Fbo0O4
         gD7UraSAsIV5c3zmh7DBe60I7QV5wXrxYISOoqdaa07zMkwQjF0RspoOXKo6zGg/16aF
         1slYSXvYz/C61AmlHR1Vrpee4JYHonQ9HfTAxcCvtXdhtaAJvwcySsyF7Jo9aia47kJF
         SwioW+krfesAxSrBcwDjc39T13rYx2WqTZ1WfWJ1wsNZ1nawKU5K/pW+qyFE111IXHnz
         OA1UU1H/V2LpuXNB1no8CSSxQn5SJ0M90wFOHfWKM3BuH4OgjSDKsDKcc7Pr9ARP1n1d
         94zw==
X-Gm-Message-State: AOJu0YySLwVBh9Sxsn6ZJPCjDf7tjZHmZR4K01f4+lHDjTdb0nnbCb+X
	QJDKFbc0oEEOr8d88tzMmJDNgSz7JG/49kN9hUIDFojGUU5ByO+IF/QrQf+2Ng==
X-Gm-Gg: ASbGncvSE4uXhd0DWfoGDzE1Q4tEWXeEuqYt3XkAFcJemFYy0STe4esVk3I57wTarMe
	MsfzFJM3lRQUyxVxhH5WoJx4MLSabku+NkJzEoQHRdT5qdQeoRIqphZI6vLutVnqnLLiTW/BtYe
	vduoHmKLYsjthao84hamk49k2wursXIYSMWfJrLvqPXIqPU2kqyNNnO756rcwixrK6GbnrcbXrY
	GW0AhhHTgeX0nLQJsyHwvOmpXxWhYW096DlOTReu2dwlcSRrb6Qxjj3/focceJr881KrB8JAZSV
	xzgMNjc0T2Xyy7fOkjWlEhm5flbqbbFso8rGphqy1DHJ+Jb3yYhMu6pSMcC+qlG3asAyts6Nz+V
	lTRuw7Q==
X-Google-Smtp-Source: AGHT+IG1K3og0Ohym2q623urrf03JcipKiKB6LpW55CV2jR7zYCdd486onYwJAJM8jKdGvg+Eropng==
X-Received: by 2002:a05:6000:607:b0:3e4:b44d:c586 with SMTP id ffacd0b85a97d-3e7659e97a5mr15099110f8f.34.1758032820950;
        Tue, 16 Sep 2025 07:27:00 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 11/20] io_uring/zcrx: set sgt for umem area
Date: Tue, 16 Sep 2025 15:27:54 +0100
Message-ID: <f07b13cee1fcf13eb3e0c739f8efb223de370432.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set struct io_zcrx_mem::sgt for umem areas as well to simplify looking
up the current sg table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 14 ++++++--------
 io_uring/zcrx.h |  2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index bcefb302aadf..764723bf04d6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -52,9 +52,9 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 }
 
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
-				struct io_zcrx_area *area,
-				struct sg_table *sgt)
+				struct io_zcrx_area *area)
 {
+	struct sg_table *sgt = area->mem.sgt;
 	struct scatterlist *sg;
 	unsigned i, niov_idx = 0;
 
@@ -197,6 +197,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret < 0)
 		mem->account_pages = 0;
 
+	mem->sgt = &mem->page_sg_table;
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
@@ -211,7 +212,8 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 	}
 	if (mem->pages) {
 		unpin_user_pages(mem->pages, mem->nr_folios);
-		sg_free_table(&mem->page_sg_table);
+		sg_free_table(mem->sgt);
+		mem->sgt = NULL;
 		kvfree(mem->pages);
 	}
 }
@@ -263,7 +265,6 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	struct sg_table *sgt;
 	int ret;
 
 	guard(mutex)(&ifq->dma_lock);
@@ -275,12 +276,9 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 				      DMA_FROM_DEVICE, IO_DMA_ATTR);
 		if (ret < 0)
 			return ret;
-		sgt = &area->mem.page_sg_table;
-	} else {
-		sgt = area->mem.sgt;
 	}
 
-	ret = io_populate_area_dma(ifq, area, sgt);
+	ret = io_populate_area_dma(ifq, area);
 	if (ret == 0)
 		area->is_mapped = true;
 	return ret;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 24ed473632c6..27d7cf28a04e 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -16,10 +16,10 @@ struct io_zcrx_mem {
 	unsigned long			nr_folios;
 	struct sg_table			page_sg_table;
 	unsigned long			account_pages;
+	struct sg_table			*sgt;
 
 	struct dma_buf_attachment	*attach;
 	struct dma_buf			*dmabuf;
-	struct sg_table			*sgt;
 };
 
 struct io_zcrx_area {
-- 
2.49.0


