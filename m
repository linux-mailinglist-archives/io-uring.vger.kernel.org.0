Return-Path: <io-uring+bounces-9005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9022B29591
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E77D64E2E2F
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E7721B9C0;
	Sun, 17 Aug 2025 22:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cYNO3/cz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12331D8A10
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470602; cv=none; b=UShcxsOytEubdKh6r6txabi4oW8cpllDTpctLvNjFOFQLetztDJkV+vAELFfRTEWM5amhMY8DlZoEh/L8Gv/CkebCyCYL2wehSMZK1Vxy+wigHlOvZkTae4mYbjpOZCVtlA5AJUNzqURi63Aid3Z2bv4/7OtCKoPx/4CtlSZmZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470602; c=relaxed/simple;
	bh=gudytOECfgObdhqUoRGcZfyXw4AqYKENnOexAwfwGvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0dH8Sz8ATJDnDPGsHviczHQPzyZy7D8sUY2i6ft1uQBWguiY0ge47fUv45kZBaqV6qZNJgstvXzLYdnpCJZDAHNlNE/g0fsaoKpHNp21kzkfBFWPKeGNJt01oyb5TeEQ2vLuTfDI8P2CzFLy2CqHO6q6srDt91sVz9cemeL1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cYNO3/cz; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9e411c820so1894043f8f.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470599; x=1756075399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7F5OI2M0NPKctJpgfNAF8/oYqWJD4ol0IWbrEWgc1BE=;
        b=cYNO3/cziLKpcbWSee3jN+lkE8O732jAz2j8aefdq3dNcVM6Hs+oDAVSHYPoOnTIQn
         KfjLhTOWLwJm2YgLxuLI2j8j+UzkxARdxR0APVL1FIf6vZU8ppaQLxm6JEvMkL6vamea
         athCAWWATVQtPqiFckmov7osqkh/BuNWVgtTJvUFdQhx99ELyx7A24JhHp/rmnAcwGn8
         GsMJMEisSkRWgeZbRAwl4vlP/GuSANWR+EwxlaYYgqno135hhd8HMzO52tnYWC5Y7aDx
         W6jpZZ1U1SG/WqSNbZJ8X9kRZwURs4JDYj2qiSSPJAbTgqLvQGfDBrjdPJrF1MIjdGfp
         Kzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470599; x=1756075399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7F5OI2M0NPKctJpgfNAF8/oYqWJD4ol0IWbrEWgc1BE=;
        b=VOzNgJIinsmQ+1wNEqoE2iY1fwH6x0I5RMvS9oQxF76V3y4mDjeJVoISS16J6tZe+9
         xvBmV6T6KKZi3AkZCJYxrAGTq9a2OsB9GXHi4e+yDthnejFW7UEG3wJDQwRISoRtB9mH
         chyxdJ6FVSEhAt63+JePLaLnkmYirOJ6oes1rr9KQUBaacDko8BLsTHS9MQxeg9F/Mz8
         F4un45GGbVFSdY8HIN1DfvJOTlcdbB3IDxsAEfJCkeLSzeWUHjOqtspYDjEtc0g2FDuy
         QAWIQMi7JvSu1HYqYckrvZOwmcGw3fSx2fKn4pAtfkbT3+E5oczC1lTDOuUzh8GnZCks
         hbQQ==
X-Gm-Message-State: AOJu0Yzc4sGWclym7sjsL2FKufzDhOvaEmUdgRcvTRU8L+xOX4NZGIyq
	ngRiUkDOnTsYQVXDQHwtfqM00IPEuC2J+BgX5El42PZJuJ7+vy+hpBG7HBUwXQ==
X-Gm-Gg: ASbGncsVUy1yuOQVxHtqtzIx9Sqem6tVxUdE2QxZUsiINCO6WHKhvUT6xCIAbfp6WXm
	l/X4Axdua/t/1qc0l+nk1JLXSU2fO8Kz8Nf7NDTl2sGExnLUhkAmVzgN58T0vQWdlKzzHdYocgJ
	bCdUJ7dU2T3280kwacrrMGOWRvEsoe8MF6ib+b3qKI12t6/jmahnWxwb5ry8CltDfBzbf9K3y7P
	IPxbWfPQnlY7okfAiyAJOE3R3TFK9SOWfbegNQi8trvO6LoHzVPzb9tCKVvHWUftRKq+V81tCtq
	huwYdwf3aazM+h0+NFx5lGPtg9nAfH9YetMeS+qBalfKkDVqTpEBlIfqDEDxEAy3D8cOU29Y6WX
	zTPyMjlbqJ1FV4Whs+He4WYWHrkL5iRKFQw==
X-Google-Smtp-Source: AGHT+IFugyxAOTVVaHvRgUfrRtcGulrGpDIVa165Ab690V78h4cQDf5a/QPkOJ2rd0w6fQqy3lj7jA==
X-Received: by 2002:a05:6000:381:b0:3b7:9214:6d73 with SMTP id ffacd0b85a97d-3bb671f7aa3mr7217614f8f.20.1755470598867;
        Sun, 17 Aug 2025 15:43:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 4/8] io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
Date: Sun, 17 Aug 2025 23:44:15 +0100
Message-ID: <b231eb01fc7610d35c1e89783cc343f08b0a401e.1755467608.git.asml.silence@gmail.com>
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

io_zcrx_copy_chunk() doesn't and shouldn't care from which area the
buffer is allocated, don't try to resolve the area in it but pass the
ifq to io_zcrx_alloc_fallback() and let it handle it. Also rename it for
more clarity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index be6d59401dc7..cb8113e83311 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -945,10 +945,14 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
-static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
+static struct net_iov *io_alloc_fallback_niov(struct io_zcrx_ifq *ifq)
 {
+	struct io_zcrx_area *area = ifq->area;
 	struct net_iov *niov = NULL;
 
+	if (area->mem.is_dmabuf)
+		return NULL;
+
 	spin_lock_bh(&area->freelist_lock);
 	if (area->free_count)
 		niov = __io_zcrx_get_free_niov(area);
@@ -1008,19 +1012,15 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				  struct page *src_page, unsigned int src_offset,
 				  size_t len)
 {
-	struct io_zcrx_area *area = ifq->area;
 	size_t copied = 0;
 	int ret = 0;
 
-	if (area->mem.is_dmabuf)
-		return -EFAULT;
-
 	while (len) {
 		struct io_copy_cache cc;
 		struct net_iov *niov;
 		size_t n;
 
-		niov = io_zcrx_alloc_fallback(area);
+		niov = io_alloc_fallback_niov(ifq);
 		if (!niov) {
 			ret = -ENOMEM;
 			break;
-- 
2.49.0


