Return-Path: <io-uring+bounces-9009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F00B29594
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0083F4E7AEA
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4392253E0;
	Sun, 17 Aug 2025 22:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5ZuD3oX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1A421B9C0
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470611; cv=none; b=ArOtYk9zIx9+lDntncomLFFn0rL02AsiUMW9gaCXQqz6UveDMeWfcYfNW70tqwv24COb58QPtZo6ppSwXQkXD6Yf1driTHGt1oiK+8vGDb+8o2MucvFIlON2P1lhpciv7mK1gxDjMvWOCtKybfkMY7qOowwEjcMJ77dCe3mj/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470611; c=relaxed/simple;
	bh=ZO6Nxemid/jiAETCbF2VkmyZBkvSUyqql5euDO1T+s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrgSAAKhg0orDIXFJOkRPt1udu+csi3ZU4CWs818XlbiGKCTTUmBuDC8TF8HCpWTA074kJXeR7zAXIeV8nPqzCYJWZVAAEy7TMXjdsoIkxZZm7vvovNOY6Mio/QYFBhkG6bXPhi9A703vW/mEMm3VPRMOVtINm9uib3ZtshTisQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D5ZuD3oX; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45a1b066b5eso16026905e9.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470607; x=1756075407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/CeqRwDWRFqqH3ZsOKoYwOT5h+CGjdoHIT/T/gjuSOA=;
        b=D5ZuD3oXMp7Y+jMhamvyFjTu53OEH6XBFqLPiY5FQRmF5UMq3QwDl+EMlbgSP2j8Gy
         bU+d3zsPq9Gztqy2dpJsSYiywPp/79N1ivP3wjYG4ei3wmvtKWb8np7nDmi+HH2/MhIv
         gupkFupTuR8d0XYwBwBKGDG8Z/f/JQRf9z5TlqP7MvLOPMU340Ztb90pFPEnwo3Bh+1u
         C4gquKeK6m3/5lXpdERohiidMSDlWnHodgoZCFaYGdIH/XjNpqKWbOJ1pz7QRk1NziZN
         y3JUo/k68bGSQVABPyw3OZ4GY8xAxk+Tah2wdR1IRK7li5lEKJU5QY9gEAkhmrtmCXHq
         Lb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470607; x=1756075407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/CeqRwDWRFqqH3ZsOKoYwOT5h+CGjdoHIT/T/gjuSOA=;
        b=iFJMD62Cb2ZEZdSXcAzKNaYprDmYHjqoDwXJEXiOGB0unoMQShyImD/9N17vvzD+2k
         WLpGCcW7cICaI5/7ibKZFswIVrI+XIawEffI6UoAC3SzZux1TqqElCLlglp4eG1Zj5fQ
         2BU4S1qgecaXi3CF6AOHz38D26X9KDuAoU1Et0GPDunRMKoPuPVwlfV50dR6Oc2rtvft
         UrV1hBYZfXtlaU+3ceqhAdbikYjfnr2i9SDWyi25ZvAE4ZswcFhPyIRBnyotISj8fCOC
         VyIff1laRcoTqz/ItmCx7N6XmG57lSuXaNG0TOSHa7hZpKEKt+jVpkkZ/ikBVzNFdm6j
         xphg==
X-Gm-Message-State: AOJu0YwY8ZCPbjKF38uhfeaDGWRUMfwYPgzRH2i4srtJkoAPa7fvqg42
	cYjWUJxSCLnh665INb1+HBn5yxCn/KE9QeEESEJSssCU6wxLLh0joZSN8tPPCw==
X-Gm-Gg: ASbGnct9UHgQhy25Oj68Oj2ixPA61c6nvuIqhHFi7zvmEfHfn4Gcu1Rpuq+ahcNJ3bk
	/u5ducgIZyOjtFV2VDIZaLgX30axnOVBdREQhhs+9a8INGRBwSXB5M1HmLiuuBHOinnCHxT15yS
	ADmqZ/1vTAHIwH+iOkatNh0T690Fnj2+Xeoh+4bwVTbBBgoTBSIwx38iTyxKrQE5RyOFaQiQIBT
	w3KX+l6YzuX7YFqVy7iSH9ZR951sq4w6shCVHz7svWxKRzl54RToeCA01oafh8H8va6MmILT6XH
	IBF+GTOKheSafoq126qJoIj2G3+c/5Pk0uGQF5OMu4yuvSbKZ3Hw8kueq6zwcVOHR29+agy5HMu
	H7ShVNqM004ii+gxxZbtnIqQi4efRdjnZCg==
X-Google-Smtp-Source: AGHT+IF4rx+RflzrvrO442QvHouE5eiv4llSOWTcmc4gungAH5PBLLkIhEfFfEZNVidArkaJX++CYQ==
X-Received: by 2002:a05:600c:3510:b0:456:12ad:ec30 with SMTP id 5b1f17b1804b1-45a217f5367mr77403075e9.13.1755470607481;
        Sun, 17 Aug 2025 15:43:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 8/8] io_uring/zcrx: set sgt for umem area
Date: Sun, 17 Aug 2025 23:44:19 +0100
Message-ID: <e6b7d2c133cf159b704c319922e05f3791f920b0.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
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
index 952cd7669589..b3cfe0c04920 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -54,10 +54,10 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 }
 
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
-				struct io_zcrx_area *area,
-				struct sg_table *sgt)
+				struct io_zcrx_area *area)
 {
 	unsigned niov_size = 1U << ifq->niov_shift;
+	struct sg_table *sgt = area->mem.sgt;
 	struct scatterlist *sg;
 	unsigned i, niov_idx = 0;
 
@@ -203,6 +203,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret < 0)
 		mem->account_pages = 0;
 
+	mem->sgt = &mem->page_sg_table;
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
@@ -217,7 +218,8 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 	}
 	if (mem->pages) {
 		unpin_user_pages(mem->pages, mem->nr_folios);
-		sg_free_table(&mem->page_sg_table);
+		sg_free_table(mem->sgt);
+		mem->sgt = NULL;
 		kvfree(mem->pages);
 	}
 }
@@ -269,7 +271,6 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	struct sg_table *sgt;
 	int ret;
 
 	guard(mutex)(&ifq->pp_lock);
@@ -281,12 +282,9 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
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
index 41e4ceab8dd6..a48871b5adad 100644
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


