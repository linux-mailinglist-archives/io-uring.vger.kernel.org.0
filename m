Return-Path: <io-uring+bounces-4115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EAF9B4DBF
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC80282375
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B176192B77;
	Tue, 29 Oct 2024 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dkrplgux"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2677C193416
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215402; cv=none; b=Dn/Ug6vJRpB6vIFy7xkNiSIvrSo8sFP3mMLHH7BM55EElLFPN2J2CC4OTuNBUxTvw8o4dgYC7yAJVGJ92VqziUQwdJA9lLTxd1GnvxeA1gy9iRab70zHs5Gvia9+5lx4q7xIx7uyLqZr+hWEw0DAuWEio9DqKfLmTC7zDUnXO6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215402; c=relaxed/simple;
	bh=ZtTuIg71Y7d8GwNOGFMCoLgePIhoo4ujtF6+yd5PsPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3pjqkeWyr/s6vsts1M/vLLbF/If8l7ZovPwTmuQoi7w4IAJKqAF0nYhm6oX48EvB+mRe3MzXWblN/ktuNb88/XlGLED0Wk4wrFEm6jSdNyX+j5ETHRVA9Yo5sDIl4dDyjwvbtPPN1wu99MsTKQxj5aoVet9YotYC+eZMGIZeo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dkrplgux; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83b2a41b81cso101780539f.0
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215399; x=1730820199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WTbLEVTHcZTbfKmFj6UiMSsh5E/ApXC9ukCVRFjC63Q=;
        b=DkrplguxRVYaUig1hoxKmJzNHwzguw9NomcwnIFUe8MM7JFgpQC9kSE7BKeqiPE1eJ
         7sep4G/Kq9YdEfwSqLOqqPts7nWeiwWm/9OA4axouDMfyA+SISCHpBRSkVeFGdiW1O25
         0i7s29fIpdefyRMN/3gD6tAe/xZTbL2alwFPNmx5oYGmibst+C166dsou/nwu1+3siJe
         e59T3Z0MY00XKgI3yViWW3SiniuyHJpXB2I615+5dBiBqlWhO63hZVkt0jS8xl0a0+ao
         PDDtozVqoAojqQZg3M+dXSGlCSqmGPBw5M/hjwt6j007eFb9s+tjMfIb5hGoH1Q4N7nW
         ZOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215399; x=1730820199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTbLEVTHcZTbfKmFj6UiMSsh5E/ApXC9ukCVRFjC63Q=;
        b=TVnzK2tmeMSfneefJSEP+evVLcEjQHgJCVYd2pBa8iblgGHxaGmBS8Gl5Tqs4j4dGQ
         4fejAfeVkfRb7VYEOq9OvxRCoJ+lM/c2y8qdkGDgnTC9XrTYQoUHwtbD7k9GDZwrm9DD
         qWqv87H7vRsSscZ/gngbrRSX5Bvc3H7o08Q+nn4mS0GUVMmaTg+Gr50m2ZK4myWkMx6j
         mF6WHr3z4azsm463Fhx3AoOMtycL5Vqlj0gg3zsHdWnlnkHZ0CSQ7/1BVIjUsAvCtFV3
         J8C1cccC4JPhQWcImCRQgHHnXDmZNvT0S9i2yPq28tg9d6uWciBOTHretqwdy40+Doge
         KtXA==
X-Gm-Message-State: AOJu0Yz5MYmr1qvRqgaDVMJJ+/PkgK2GgzP97uoX+AW5wuWpMW2fNaLt
	nN3OMpNICwrJx1cfVN4hNMXMFK2ePlBxPmDhW+B6QGGJ8YYkfDHnqMH18GFfyE/B98CV5Ipa0Q3
	9
X-Google-Smtp-Source: AGHT+IEe5u7WfULkU+qVLJEGXkTsMp5YSCG5GpvZXW7QtCtANmWlhFW7Nc8YGhFBnndRhyRnAX5QnA==
X-Received: by 2002:a05:6602:1493:b0:83a:b8aa:ec0 with SMTP id ca18e2360f4ac-83b1c627e42mr1070584039f.13.1730215398836;
        Tue, 29 Oct 2024 08:23:18 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/14] io_uring/filetable: kill io_reset_alloc_hint() helper
Date: Tue, 29 Oct 2024 09:16:42 -0600
Message-ID: <20241029152249.667290-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's only used internally, and in one spot, just open-code ti.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/filetable.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 6c0c9642f6e9..bfacadb8d089 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -56,17 +56,12 @@ static inline void io_fixed_file_set(struct io_rsrc_node *node,
 		(io_file_get_flags(file) >> REQ_F_SUPPORT_NOWAIT_BIT);
 }
 
-static inline void io_reset_alloc_hint(struct io_ring_ctx *ctx)
-{
-	ctx->file_table.alloc_hint = ctx->file_alloc_start;
-}
-
 static inline void io_file_table_set_alloc_range(struct io_ring_ctx *ctx,
 						 unsigned off, unsigned len)
 {
 	ctx->file_alloc_start = off;
 	ctx->file_alloc_end = off + len;
-	io_reset_alloc_hint(ctx);
+	ctx->file_table.alloc_hint = ctx->file_alloc_start;
 }
 
 #endif
-- 
2.45.2


