Return-Path: <io-uring+bounces-7461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D8DA89EFD
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 15:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CB261735D4
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 13:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3DE2973D8;
	Tue, 15 Apr 2025 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eh23Qy4A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00622749D5
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744722546; cv=none; b=S7EjWtXLorJWZRikyhkal1FQx8/ioMqtZjjdYpbApvJw/zIWYt6qhTlFHtZFqf3c7WYPH3kEqMjVfTCaSqEsSV+wG1kjRq882ZX9Hyj63xhBa8vSnS/AGNPw8cQvh5WUQl5CxITQmIg17ueOJQw6PGgT7Qfm/6JY+CvD00mZVig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744722546; c=relaxed/simple;
	bh=7icFJMrmAK2BWZ7EmHsnaVr27B+cQG2M+Ez4iA3MbQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PNnvw9rqe4i49lVGoRpBpH5+1AuNT3ryR7FRruJ9dhe4eykJrSwqmCqySlnaAWI+JkV9xqfQtrlkx4q8hbJCNtjOc7nCI52/AzS8ZPuAMR+3Az8L6HxXkd+ClZyDKH16SI1jFDXFZdh35kX7qylfeca2m8od4K4J8sWQCMNIeZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eh23Qy4A; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac345bd8e13so956128066b.0
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 06:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744722543; x=1745327343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6P4zQ/qgjT2nWx1iJEVwi6jFrmy6O2QOk4eAG1qFHwY=;
        b=eh23Qy4AyLyTwKbs4k+NStu4EjOvSyt6rQzvLQYC+q3jMibKY/4HnNL73By/Q+9UKx
         E7/LXV/6p/ontkaAHPKUqqRXNi6lwuYazzrC//kJw0AtQWJB/vppWlqDcSXc9VOMW4R7
         ANDwQ6dbxCyfwKh9oA5wJgmR/xx6JB/ut3goZ4psHzSnQLta2AfC5b7Xx9l41/04plNe
         IfVspFcDDtYMP+gf8EArlCgkocIbl0SBDH0FPd3QQM8Ik6wKiH5ZsiXczFbysBp8Lgrz
         hZ8bE/H5F89g64Tye+4lBykzyFtyCNZVbk5nPoq2oyWqnow64lUaGC7AXcE3Eg7/O3vw
         5pew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744722543; x=1745327343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6P4zQ/qgjT2nWx1iJEVwi6jFrmy6O2QOk4eAG1qFHwY=;
        b=koTDUEZPuVGdpv5ioGF46KjZXfORm9OmWF6exiIfXzywD954NOD8/VmiSxpYxvVIJa
         0y1/e7SPMEE/I8czM7FQ0W0egTNT9Akg0QZJuCDhRhMhZOhw/pCrPCtRs4N0+CiXwDZd
         jtD+cJIxQRyIqrTTnTC/zILhdfFJrGkDeJOLxQaHjxRiPeA6TcdcX8IWpYbJxweJMVXn
         RZsvi/jSsPjkJg8bbDxuKSBq9gV48/THndF7CUYDscF7/VYDbb4afVco39sTBawB7sgA
         VDDDNnaSKBPWW+CyQ3qYgFFjc/MGUcsmGCk42a4TtDeaMX5P8auMHrtJJgocjjYtCc1p
         L4sg==
X-Gm-Message-State: AOJu0YybCR2fh9MGW4bvMDbGYmxj4wlUCN/DxvWJl6BJ9wJWJ7E4zfZd
	PTTDmDUkw6mok8KxeJ2gj0ojC3lKF1fvJ9QF3e8Y99XMSLrdAKt04ox8jg==
X-Gm-Gg: ASbGncs/5WwF7weyj73UHlwhWsglGqCZL0Ut4JNW/jh06OhtAGitSw96Z1BoqoTkVY4
	JmHolCQePZOiCG9jUFbhRXJ6goKlw+uAnoTuh8YAqgU2oxdSYRCMryMBnONrnlhjak2uPndEU5/
	PSpqr5vBkdQJwTkXXCNnZy1YiJgBOYrXdwh3miK+exVpr477bcdYlpocT19H00Kpx5Rira7EEdy
	tY50Aoy3+i18sN6tY5NEEs+L4SLtAZviRuG1U2xJXDX0uil2Yw/FfpBKpIAVk3HKIU6sMuNV41S
	3FE8GWMa93/MPLFR3/wiUn1LAnMSL3V3Gms=
X-Google-Smtp-Source: AGHT+IHeUZpwx+uUxDt5uhLZL7wUHJPtdS9DT2w7Wwz4RoS+GPJdMC82LthJ0170D3StHYoGXVjpEQ==
X-Received: by 2002:a17:907:2d06:b0:ac8:196d:2262 with SMTP id a640c23a62f3a-acad34d98c9mr1261837066b.35.1744722542296;
        Tue, 15 Apr 2025 06:09:02 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9066])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acaa1cb4204sm1085094866b.116.2025.04.15.06.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 06:09:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/zcrx: add pp to ifq conversion helper
Date: Tue, 15 Apr 2025 14:10:16 +0100
Message-ID: <3522eb8fa9b4e21bcf32e7e9ae656c616b282210.1744722526.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It'll likely to change how page pools store memory providers, so in
preparation to that keep accesses in one place in io_uring by
introducing a helper.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d0eccf277a20..5defbe8f95f9 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -26,6 +26,11 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
+{
+	return pp->mp_priv;
+}
+
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
 static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
@@ -586,7 +591,7 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 
 static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 {
-	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
 
 	/* pp should already be ensuring that */
 	if (unlikely(pp->alloc.count))
@@ -618,7 +623,7 @@ static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
 
 static int io_pp_zc_init(struct page_pool *pp)
 {
-	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EINVAL;
@@ -637,7 +642,7 @@ static int io_pp_zc_init(struct page_pool *pp)
 
 static void io_pp_zc_destroy(struct page_pool *pp)
 {
-	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
 	struct io_zcrx_area *area = ifq->area;
 
 	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
@@ -792,7 +797,7 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 	niov = netmem_to_net_iov(frag->netmem);
 	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
-	    niov->pp->mp_priv != ifq)
+	    io_pp_to_ifq(niov->pp) != ifq)
 		return -EFAULT;
 
 	if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
-- 
2.48.1


