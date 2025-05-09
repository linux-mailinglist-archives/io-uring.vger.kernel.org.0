Return-Path: <io-uring+bounces-7930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8995AAB11EF
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9279A4E6D03
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F1028FA91;
	Fri,  9 May 2025 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzR2s4Id"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC8228C99
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789116; cv=none; b=Lzaxd1TbKxnzJKPJOypg6tAPQrIY2FoiMS9lD5zuerqOGbqo35zCoK4Z0Ck1ZuTZgeAQbhrkjNYV1x53GkdDDRyaxVhBbhVaDQC3hhEJZoLe2rbbrLzTDtRYj1cTzay+PrqWVd6hAahI/DpL/HmwtJjEZWxpICpWJ1iFxCl0iY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789116; c=relaxed/simple;
	bh=+IaCjDFGgR7Xdt9MTIIu0HopFdZBD3DC3bsovgWHJes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOwlIHsrEo+RDHe9Rktkxdz+u5hgUTpvOZPpg2n+NiMTkEmwu55BvlxNGyZIUy1yYU8aJeiHB+LnhCUoHKCHKdI2uud0vFS033VxlmcDCQCrJiV/ZJw9MiO1bk8nbmBeGXp6KFcA1P8kKFKyCGRYrmaS18BsB2g5br89Y4IlpQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SzR2s4Id; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5fbeadf2275so3539321a12.2
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789113; x=1747393913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHyixqyY6sy5/oXlVIiW8dE9MHYsBdfZjSNGjdf5goY=;
        b=SzR2s4IdE9MACy3BD03WD4MjpPnJAhPEyX4vCdeIoMnIf9xbUOjRrNdr4uJiOkTPde
         U+h+OnmGuMeX08DIcvo2Ej5ozJuWkvC4zZ7ZRmcQN9GvbYGw42Iq3sCvudKSLIIGtQKY
         JbJJxAFwnMPgzgwq1kBJ9LQNEHVc5OjBkSVrXdz4s0sYwf8J2IZwqnDiuTDzlVG5rPbu
         2o57dwG4tSVkuhxYa4I2FYQ3H0baS7NDKuDpFnYbN5uNZ3ll+hRmkb+g68hAf/c/yVe4
         Uw+ZwuXTDQSAWxncgt9qfyqU3kU0+LK6Nrjt41hAkOIHUPUOLCyNmr5MiFz97yz9m0LY
         2Vmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789113; x=1747393913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHyixqyY6sy5/oXlVIiW8dE9MHYsBdfZjSNGjdf5goY=;
        b=kYVIZr3IxVini10amovMS7CsQT3s4zPu73XkarrD1SU5n9wtNMdkzK5zinLtcxsSOw
         OQx/o7dnngEtXgQDds7juX4iif5HzjsUK6J3mmIcvQ1F++YY3Q0YxZD2Cuu9jF88aJ18
         0IUD1DTQrZqSR+UFcPIvjd1KX7EwAPQTnbJtPwJPMRkXfhji8IqUiXxqJPBE8hChJV/7
         +gR1wNeLFktdWees4eCaRFtxSNPdihn4EEUo+bHZT3cg6ylXBeRaIW6472mT/dRAQ9DN
         5JLpKVlLNwHGbj58AMIsBxeF6c18k+M9CvLmrVzxsFPOV1Yin1BI1qFvdTDwys0Ntgsk
         gk2Q==
X-Gm-Message-State: AOJu0Yzual85oD1CVrH0GKv2tag2nzkLQ7xsjSJB5I8ZahMp5xm+rMyl
	iCP+Y/ojZtJeN+vcFR/eTAgaMBuMelQSNSvQCznuJv57ymdkDVDZVXqEjA==
X-Gm-Gg: ASbGncuZAr5jbvbZz7MiStcgIkrHsD7ttNd/IFiOcTfoUI8eRN1zevnMssqirVUNVR5
	42Yz1KVk/ktWmM4lpkqWy1Ms4DflYr+NRUf4yFYAiS5XEtWw0sglELkJ4xPo9tW48Aj8c4b//qZ
	aWB17j/Fl1SBcXvTSOvUB2LpCXrvl5j7kOBujNyVoWdbzYDHU5yNzpN1ehR7iJ228ZT3RpjFwia
	MvsOH7rmNmuTsP6NH3aJ8WBLJfJ+GFAtq3MDGljomVTyHtwKvZinYqxIRJR9clF8QHxo/GUbDP+
	UfjbgCFCRCzgpBMIjB0jRhWP
X-Google-Smtp-Source: AGHT+IF+WgyfbaOAGTKmchIDqudTBrFW5OTg3RGxmsLi7NxXLdaYKLtCzZ46LCllGBR1x80U+WhEcg==
X-Received: by 2002:a17:906:7955:b0:acb:5c83:251 with SMTP id a640c23a62f3a-ad2191789acmr282203666b.53.1746789112729;
        Fri, 09 May 2025 04:11:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 7/8] io_uring: count allocated requests
Date: Fri,  9 May 2025 12:12:53 +0100
Message-ID: <c8f8308294dc2a1cb8925d984d937d4fc14ab5d4.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep track of the number requests a ring currently has allocated (and
not freed), it'll be needed in the next patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/io_uring.c            | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7e23e993280e..73b289b48280 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -435,6 +435,7 @@ struct io_ring_ctx {
 
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
+	unsigned			nr_req_allocated;
 
 	/*
 	 * Protection for resize vs mmap races - both the mmap and resize
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9619c46bd25e..14188f49a4ce 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -954,6 +954,8 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	}
 
 	percpu_ref_get_many(&ctx->refs, ret);
+	ctx->nr_req_allocated += ret;
+
 	while (ret--) {
 		struct io_kiocb *req = reqs[ret];
 
@@ -2691,8 +2693,10 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		kmem_cache_free(req_cachep, req);
 		nr++;
 	}
-	if (nr)
+	if (nr) {
+		ctx->nr_req_allocated -= nr;
 		percpu_ref_put_many(&ctx->refs, nr);
+	}
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -2729,6 +2733,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
+
+	WARN_ON_ONCE(ctx->nr_req_allocated);
+
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	io_napi_free(ctx);
-- 
2.49.0


