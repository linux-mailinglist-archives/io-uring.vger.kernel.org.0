Return-Path: <io-uring+bounces-8556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B0FAEFA93
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D3521C07FA4
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6858F276056;
	Tue,  1 Jul 2025 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CYzddqGA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643A2275B1E
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376382; cv=none; b=L2lLNe0tIk9I6TeMdkZemyyCKZzUK0N4FDH8N23iJ9B5DD319QE8qSqi9sgsMPgwk9ysLOQzouC2ttlLhohHeL1OQV4HHoc/PWdWt80BOAM5UlKCxI+nJV6ySYUz2vHQPdcKr7nq6ClbvgUiSf1KYpdOopNos4VBLz8OVmTdCm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376382; c=relaxed/simple;
	bh=Nv1J/YwJd/1WInHQulecxJCT+Owuj7WTyA5M9tdgtHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xzmc+Onrs9gfK7J7LMk+oHttdN9/eV3J1QLHfeuTIhmR8EOe9tauLC7WrGCZj+j7MspX7nJOZWMWrPSt0R9pHIUmk2vlZsKph05GkVmPMHB9dYivTyqFm6+cX2VoaNja2IfP1+kt72u+FeLGsD8Wuw8wDcDH4IaLTFN9CtsfjDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CYzddqGA; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so6191605b3a.0
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376377; x=1751981177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD3cUMqYJg997d1pue4/G4HDRqC/d97A0JSEAjfGGDE=;
        b=CYzddqGAhy471xwmRGU7vWb8fnezanXiLyCPn9YShY0aMY+X+Y/csD+ThhXome2Uuw
         2ArOAx539JQkF6AvDECRYEDYFMtsI8XI0QnfpWmakof7/9GUFIN6/a2enJ7nyJUnu9Tz
         eKGq8g3A+R5emxhg8op9kNlIQYVl2BKDro7C1O/tYm0cZH4T6d84RHSAos/Km8Wxbm2B
         XHfxEHFsF7n5RnozSaz9aIHK4jUkZKU1N8SqlQhGm3HczxQS7ZHGSIYqxldhuinObyfs
         kx/OC+ZNWwjZMNJvlLNjy3cNofuF+UGoOdCv9P8/S9p5trJWZd0UWbehzFdlbMPiHqMA
         vNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376377; x=1751981177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BD3cUMqYJg997d1pue4/G4HDRqC/d97A0JSEAjfGGDE=;
        b=VSl/nEu9d7mBT/xQ8ZttI1DIGNwyD3EDUqsFTnRX522dYawpnOQwS8Auqj8TAwj1C5
         OPgFwmRsJVCvmLhXri2Qo0pC+788++FCbWmpW0le7e/W+4SiklMdQaWOKPKKSoOyY0I/
         Ip6UpEGt3l9GizjEV9AyqBtqGvLV5B4RtLhkV6NTCLWSJQED0EqQ5Z7zfS0MVjbtCBRp
         NEDmH+25iRdtBjfwdsFw8aoPyJ6tJ3po6hHefgGq7q3KQVGWsqaBIjKJbnjq5sjgIoP2
         r/56+yu/uaWMoIVWygihmDTz/g5btKC6MFcRdQanrfX4qqcBwgPco9THI0TP8dUrjnzM
         FHfQ==
X-Gm-Message-State: AOJu0Yy689xfkPEzLyR2Oi/opcSDa9tGCH5tSQVdWwQ7XSp77/wxGLql
	p9ecxkQr+mHZ2rwalvx+toAn+mUig1qddqwyQIM98UT826ddoHaoSSpqCiLmadJG
X-Gm-Gg: ASbGncs/k59mds8GPH/NcRtjXAFjD82CzRrQEaagTWkEgRWTL+RnVQ98DReJ5WUo1Gb
	S6DMjDj6D2vrIhf3Q8m2ArSbRZKBfrT8Knn4lLDdz660H76royti+fFqmsByK9A47xtth/kXUeb
	TzHIe0e518nQI34teBde5tlzhShfrgTiKcTeQLoiZ2FUabxw1m+GASJbdYks3rc+RZqrMuLQwPT
	ki6XiBfK5+o9r46h75njCbKgbb3Q3SN449w6kWfHk2cqKRarlNRKg260UeB8Ba9Ze+xtOI10t/P
	y3wdZMUm9TJRno94UlTmfq8lM5OtCbBHKNRJKiBHvDUe4o1vlxGp/rbB8nVbZRbSqIn6Zg==
X-Google-Smtp-Source: AGHT+IGbTR4nYJTFZlKuWfTYLg9U+egzChqnwNTTRM4I2P0fADwDwwuF1TmYKs3Z63kUi2M76w6a8A==
X-Received: by 2002:a05:6a21:9204:b0:1f5:619a:7f4c with SMTP id adf61e73a8af0-220a16c987amr29954327637.29.1751376377381;
        Tue, 01 Jul 2025 06:26:17 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 2/6] io_uring/zcrx: return error from io_zcrx_map_area_*
Date: Tue,  1 Jul 2025 14:27:28 +0100
Message-ID: <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751376214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751376214.git.asml.silence@gmail.com>
References: <cover.1751376214.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_zcrx_map_area_*() helpers return the number of processed niovs, which
we use to unroll some of the mappings for user memory areas. It's
unhandy, and dmabuf doesn't care about it. Return an error code instead
and move failure partial unmapping into io_zcrx_map_area_umem().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 99a253c1c6c5..2cde88988260 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -139,13 +139,13 @@ static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area
 			struct net_iov *niov = &area->nia.niovs[niov_idx];
 
 			if (net_mp_niov_set_dma_addr(niov, dma))
-				return 0;
+				return -EFAULT;
 			sg_len -= PAGE_SIZE;
 			dma += PAGE_SIZE;
 			niov_idx++;
 		}
 	}
-	return niov_idx;
+	return 0;
 }
 
 static int io_import_umem(struct io_zcrx_ifq *ifq,
@@ -254,29 +254,30 @@ static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *a
 			break;
 		}
 	}
-	return i;
+
+	if (i != area->nia.num_niovs) {
+		__io_zcrx_unmap_area(ifq, area, i);
+		return -EINVAL;
+	}
+	return 0;
 }
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	unsigned nr;
+	int ret;
 
 	guard(mutex)(&ifq->dma_lock);
 	if (area->is_mapped)
 		return 0;
 
 	if (area->mem.is_dmabuf)
-		nr = io_zcrx_map_area_dmabuf(ifq, area);
+		ret = io_zcrx_map_area_dmabuf(ifq, area);
 	else
-		nr = io_zcrx_map_area_umem(ifq, area);
+		ret = io_zcrx_map_area_umem(ifq, area);
 
-	if (nr != area->nia.num_niovs) {
-		__io_zcrx_unmap_area(ifq, area, nr);
-		return -EINVAL;
-	}
-
-	area->is_mapped = true;
-	return 0;
+	if (ret == 0)
+		area->is_mapped = true;
+	return ret;
 }
 
 static void io_zcrx_sync_for_device(const struct page_pool *pool,
-- 
2.49.0


