Return-Path: <io-uring+bounces-5135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1213E9DE7A7
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CB1CB20A80
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA51219E83E;
	Fri, 29 Nov 2024 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4vwA0ox"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E586619E980
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887243; cv=none; b=M+g7ZZ0hpfHWraVdxqTX3HNJvveaovIiNwFaLdWeMn0v/Eb6hZjgig92d0PrJN8LXjcUI8rAO3ub7WFIdR+Y95cOrqbuLL6TyVivzgR7LWo1SSeT2Zqm4/d36SZ3dALQ09GDXzZsuSRbOXcqjOT+Ub6Q6Hjg3i2Z4hmGUCeDmD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887243; c=relaxed/simple;
	bh=eBy///SVgAPRtDm8yj1s8ccjZKDipQkxK2Ssw37Th8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/leaCW11zJuZY5xVg4VHfCMK3UwehT/x2HL1MSGbns477fAxbePqcHe6vUqd42GLmkQJiwU9fB9JNXg2Dvl21HZwt/0BmrI9VYkR6aj8kKbf9RUgNB4uHJ81rKegOjM2rE2C+8T/hPaTbWj7QQM7UlGlWJwi81kwBA6M9Ohrpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4vwA0ox; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa52edbcb63so516030466b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887239; x=1733492039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er6DLT3c1GoQv/pFnVFv5XuEMbnbGTIcjU+5j6eVv0Q=;
        b=e4vwA0oxnJ6APw/2o3jMcaFodxCxBD//voXHa7wzErQo8LEKs8U9T7JmbD83aJJ0b6
         DUJ3G9yhNZUi9MFLiZ9A2gLgsJyGyBK36Gh4gMt9q2qehJM+PdF9NEV0/tyHK11p+Msb
         kDQmfg3rrOXITKmi/rQ4XNTLANaE3DEDfe0IPcTtGldUB+ZTcomkiaBev8/f/lpwOWg6
         tHY40q1GHBl7YQY4oTvCyGPnLXiQ2jScH0RVitCJPnbBBv6eHyFjwGzWKSigQ6xp4WvK
         nzIpC8f6sTcyloCHVtlzxN1c/swjjrO31K0ISDkW2eE4DfQePCG+6fdq7Ta6KVDVun5K
         n22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887239; x=1733492039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Er6DLT3c1GoQv/pFnVFv5XuEMbnbGTIcjU+5j6eVv0Q=;
        b=ECdxRtQvNEW1rsCeMfm0Q4Wm1hUI/L5z6avozKXpjaInK13Z3S7yHZolNRGZsqYPh4
         J8P5SiyHtkyO8t8Yr41fvd+U8s6eXG804AXtRctvwMfUC29PU7m7DORme+RoeU1DsbCb
         xji2YbU+w6I/+nZLSldWcz505lCQF4lB5cs1vKknelZdmxx6bnpoMcf2zUe3EZfOJrV7
         hkRy0NlPPbJ0TYWXE5uQXc2orunys9BX1HgQKKHoTnrL3csmDB4WwGETXmwc7CcxFLmt
         gIni6IEPHj5GXyN2J322QO2Tt3Iu9FfKeVCZMJnlDXADHCIwQB2HeTaRPfQqRSE5GSEg
         Htbg==
X-Gm-Message-State: AOJu0YwoGMohmSmgQq3qM9rQozSF28JO0s/QdzGhiPJqRjm4c7k5LFk6
	/ufJCWq9ggUki91iP0BLsODNtlCVCWZTxTHV9nzLSmOkOdZsGXTsoOlRPg==
X-Gm-Gg: ASbGncvhxEv8xu4UeVtJ3M4bKqiOf9774o6opz/v36yoy84x5gpqq2tTdiG21gRAuqT
	Lsb9gHuJPGZorQP5Y2pkx4shbqKnMPBKC/uom8rHA4A/3hgjozMOua/BvBy3VHyzxkty0HMuuPB
	67/WcZ9BpaD/LDs9M6F95loTXk75Q7rxrmT3fhTBXLmMRea12ej7cWbOD7TkR6oYpEvbdBh30dH
	uv+Ty307xnL9stHV69AoW5vfu0dYhS4kPsl4MxtBkN7ZgDmt7CmBYcWWSd86vSh
X-Google-Smtp-Source: AGHT+IGwUDwbPgqADq38T5hAP+2gEGz+ZdMZHeJS9vSYXfcluwL37gZLDMazlg1Z4cYiHfD59VskfQ==
X-Received: by 2002:a17:906:1da9:b0:aa5:3853:553b with SMTP id a640c23a62f3a-aa5945fb07bmr701521366b.20.1732887239301;
        Fri, 29 Nov 2024 05:33:59 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:33:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 04/18] io_uring/memmap: flag regions with user pages
Date: Fri, 29 Nov 2024 13:34:25 +0000
Message-ID: <0dc91564642654405bab080b7ec911cb4a43ec6e.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to kernel allocated regions add a flag telling if
the region contains user pinned pages or not.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 31fb8c8ffe4e..a0416733e921 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -205,12 +205,17 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 enum {
 	/* memory was vmap'ed for the kernel, freeing the region vunmap's it */
 	IO_REGION_F_VMAP			= 1,
+	/* memory is provided by user and pinned by the kernel */
+	IO_REGION_F_USER_PROVIDED		= 2,
 };
 
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
-		unpin_user_pages(mr->pages, mr->nr_pages);
+		if (mr->flags & IO_REGION_F_USER_PROVIDED)
+			unpin_user_pages(mr->pages, mr->nr_pages);
+		else
+			release_pages(mr->pages, mr->nr_pages);
 		kvfree(mr->pages);
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
@@ -267,7 +272,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	mr->pages = pages;
 	mr->ptr = vptr;
 	mr->nr_pages = nr_pages;
-	mr->flags |= IO_REGION_F_VMAP;
+	mr->flags |= IO_REGION_F_VMAP | IO_REGION_F_USER_PROVIDED;
 	return 0;
 out_free:
 	if (pages_accounted)
-- 
2.47.1


