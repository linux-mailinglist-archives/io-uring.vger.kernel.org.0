Return-Path: <io-uring+bounces-4081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8EC9B345A
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC3BB1C21E21
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58E41DE2B5;
	Mon, 28 Oct 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j+wn2+Q8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93AE154433
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127901; cv=none; b=WKQ3bJ1E4zKXslJQEhExEKrXbPpyloOxJ9GWUIGAop0O1aIZCyDUuT2EmLMGb0nzQKVteAShPyvXPiSCQhw62JsumvW1ofJZYCUtAmirqaXEieqwHXFxOhV7Z9N+twnx2Au/hLWFVLAyEr53T9X/wjvnlsOqOJ11ScpPsN9jcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127901; c=relaxed/simple;
	bh=VfbDmtv5aW5PNQ30l++4tRQtbgzBFwi3W06NW3vdzIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tr4TAg/LFJ2xYNOe+gExgjWme5UUXpiosZE/BxksRHxlWVtmjCul51GYtP+hZPu5TYm/NfDo2gKnqu3EntcmCh9xqcCHjN2x7SKq4Ngq7YepEXghlFIbRp2L6YhFh+E8rNndbtx4/nPHgd7XUr/teaSp9VzOnfBJPsYQ6/3Xt2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=j+wn2+Q8; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a3aeb19ea2so16001245ab.0
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127898; x=1730732698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/2dKOrmPK4w2j6buyCUdzsOQjVIHjTxGl9nrPXboIs=;
        b=j+wn2+Q8cUYz3RoVcsyWtNNRgpBXkfdN84NLcynPgun20VWV1BvTbVaN3d2yMdFZlK
         Bom57CvsuElMj8nwWAAwqgxxv56CWm5TxprPm9/cOWB0B9g7sL3bYvK8VIhjYyGTLk7i
         i/5HxkwWezt9Pj9Tevhqy56k31UzJkEifDq9mEDuyTX26+5fk4VotZsYf4bq9oiUY8At
         NF5NbLdg/AHjsf6FDPJOZr2fyi2OOCD+zRjaqaKuBV+GC3UHGAdtgdm4PvWcOGzV1kf9
         X153RkL8GIVfCfoi/5mOHR7mbWF9V8hfCO/JMOTZYf8MKH0k4Wh9z46GUGVwwWLnM7+X
         j1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127898; x=1730732698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/2dKOrmPK4w2j6buyCUdzsOQjVIHjTxGl9nrPXboIs=;
        b=TwiA+u4lL8PtlVWwPNj5c9cV/Fko+FmK/M7E8Z0o+JrjRYQUFOjOWFtQs8FgGO8FRo
         r5Zg/+TW0fVp3vU0sWrSvT7i92HjikWruJ4ZyBZ2vEFk+eRNS2KyKeLEZdTy0XtfwbOR
         tigv2gFRkdQ0UDfnBZLgwCCkx30gsmBHitsv57+gFypPPh4PTNYA2kzcwDap9E1MjSu0
         PaiFQZpauwOSwDBq4j3vw+1FdEj5GO3VSSqa12TH+1d8UKoi6MbQanl8825tpbHjQ2cN
         6L/FY5wbVtUw1fXM3NXwB7EkJNXH/DsjSueRDkDXOj83cXrBuuAr4ZxK6nLgcNlzhht7
         Hifw==
X-Gm-Message-State: AOJu0Yykb66vogWlE0YFTEZ6lwioQypzV806ZULqDup9+eFiE0ZsTsS/
	BG1sR7/mKI4o95vsfp8fv7zIj2JpasVxEtdB9iiu15qvnFnE4imsfx+OCwB+7PYLhnh281/nuoa
	+
X-Google-Smtp-Source: AGHT+IHbkpyQleAXSnTQthfZWkj0Tejcsba4wqO5vJXrous1OtUEisMD2MhHlsCzn5xHT6j0fmz7hQ==
X-Received: by 2002:a05:6e02:1568:b0:3a1:a163:ba64 with SMTP id e9e14a558f8ab-3a4ed264feemr75401085ab.3.1730127898327;
        Mon, 28 Oct 2024 08:04:58 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/13] io_uring/filetable: kill io_reset_alloc_hint() helper
Date: Mon, 28 Oct 2024 08:52:43 -0600
Message-ID: <20241028150437.387667-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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
index 782d28d66245..2a30e0db94c0 100644
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


