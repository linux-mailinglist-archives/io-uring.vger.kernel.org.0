Return-Path: <io-uring+bounces-8392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBE8ADD06A
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D943017C540
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906D02264A2;
	Tue, 17 Jun 2025 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PMHveq03"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12B72CCDE
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171645; cv=none; b=oI3R4/HI4+A9CyCZsZsbvV8QjlSP9wwwlkIGILG0bsr3SfkPqSAk6sreszarVIKSm4sMPQYbju/TEbOloi22QHmCFJteDSBi+Xij1LQop3hw2nrN50sdIoZhP0gpcRsraJcpKDUn9YbFl3pqmn3pFv+1pEUKxIiQGB2+3BJSUh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171645; c=relaxed/simple;
	bh=3ZvApFDHOGFQsQSIH5iFDilTGnoRdqEhAunoLN3Luxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuG8EM1KfqtBjm1+SfveM5hTJ8g9EidXiVqIs71GhpjBy5OT7WK+vTayqRxtGUqTtWbcN4cLNOR/l1twsThz9EHaaxaza6V8NLr621jBu9qu0/WT7n2eL+rXdgRQTeIWLCSetuVUFmjAy9srit0msAQPAiFxU0koPPakWjtPQ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PMHveq03; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-607ea238c37so12295935a12.2
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171642; x=1750776442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otvMlGMV2xw3oG3/w7X3BAa26EyeHvBWmVtd+d0AQBU=;
        b=PMHveq03jU2iHs+a9l/o7HP7SubtdWHT7Hljaiiy2aeYKsnSWx6hrVFB/nTarYF9Ms
         t5k7BiHGqq4AnSeuLeiekigJHpGDAsYlnasZ6uwqjPHNWxOREKh7/UmCLZfO3AlfbqQ/
         5Wu4fxlEKOj8BPV00eVCdnszXsalOMwQXRTStZRzYtmXLuDFyYVMjLUyYvAEFFXTcX42
         KzpTZcxm9zVxlkH2VWwy4mOzyFscKmcQNPIGS4dAJmUM5DiK9N7fm04PfluUp2d1wqlB
         cqC3mkDrHtFeMJhJs+PM6Oe+f2PncOl+SdIMU9cGU6j4W4Ixbx2qYogolUOdGChVPpC3
         aVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171642; x=1750776442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otvMlGMV2xw3oG3/w7X3BAa26EyeHvBWmVtd+d0AQBU=;
        b=PUDFL7CUCkKnOpZxh+IY49YplK8riKmgBLNUacq//3cgQD02intWfq1SwgdSUyvgce
         g6N3rzy8kkBO3Xl8PTPcOcVfHQfZ9XFZRk+MXKLX3k9YCAtbnVZkX5JUO4TI6YNEWpDt
         /kYU51kMlB9tlt4FNy1FRCTFsAIqAcYK5v2dmJLEXdndY+uebC+M40LMsrMotHHOw1aW
         Irn5O6bM5WpFYlAcJ283iEt4mCUywtPaNZvBnfYfSSg5v3TqL66MmYIG6JTP0fNle5LQ
         Zq7OUHnP+2sB1vUCAUe9/NoN39IM+brbRX1dV96Kb4P96kSjVp5rHSMv+bCJiINV1g4M
         gfCw==
X-Gm-Message-State: AOJu0YzoVoBV7zzev5m0MYwPWL39lrb3EzaTsqLmB+yAcnk5R7sn64Ym
	Xs4O1n7IpMh3EgjnWicA3twRK4SZhPzkrcXGzkjWbGK0NpbRvzVz0Pf2SWOeMA==
X-Gm-Gg: ASbGncv9hNxSKcbxkY0jkM6gKm56OEybs+Dcv9stF/ogco1a1IugrdTdzgoSXVSzR7C
	dp30qMW3phnW6LvMH41FLW3wUn6LUK0gdKwIysUnVv7CvLTIoBO1TwyoXTdqe7enOWWwcyQuy3Q
	LdoQykvmjKnh4mKpv68mV9wRqCRe6GunkmitrdbqZzzIk1s82obnv2WbP0lqKm8FCWSx6T1CBmB
	9K4snsNNuHdt96OGFVN0wUjRM9y+GTkRenDs28/Soj+8iRdqIi+8y5nGRw8gNJ/xsCf2LgEU5Gg
	TlKCMqCPOR0ob/KwgrW2n9WkOnQWfSKbDfwxowiDY3S1Sw==
X-Google-Smtp-Source: AGHT+IFDR+RDp9VIIWzK+RdPzeA0HjXH1dlVOGF83LbMZHevniP3c02jS/XPlxZVseD1VfUWS9mLyg==
X-Received: by 2002:a05:6402:d0b:b0:607:e77:f840 with SMTP id 4fb4d7f45d1cf-608d097a5bdmr12711207a12.26.1750171641284;
        Tue, 17 Jun 2025 07:47:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 1/8] io_uring/zcrx: return error from io_zcrx_map_area_*
Date: Tue, 17 Jun 2025 15:48:19 +0100
Message-ID: <e8e3888082376011803b8d2078c8fd672a942656.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
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
index 797247a34cb7..7d361b661ccb 100644
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


