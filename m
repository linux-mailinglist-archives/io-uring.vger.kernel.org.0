Return-Path: <io-uring+bounces-920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5151987AAE4
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 17:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 814A41C2216A
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 16:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA5F482C9;
	Wed, 13 Mar 2024 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnyCRqjn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5BC481C6
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710345980; cv=none; b=m8DGq+c7lqwlNNrI970L3POQgiyPKLzAtjVgWqhFzwGG8aXNVeoTARMhY/l7nOXRkPg4/NnAkfaCRt2rFjC8+VONRbYQf4Jf58tltXM72brfTx7lN7HB12dpjeW+I6hiK1heIpHEkGMUk7nQ//EHxC58NVtVrmgoo+JAHo9OfEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710345980; c=relaxed/simple;
	bh=VJu1YF1nRd3qpaGPm8Ug/d5wDS6A3acDwLqfKX6uaDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxXP7WNAZ639AHaTHtPPm8eARCQdlWG77Q+/3Mfh5C0zbjLlyIhEyeOXHra+FDw0jiHi8dOF3xa4besiaFqAat+YtRDNVjBL1vxxeOqsKY9gY3K/Fsga/9zh09Bg/l28levfS9EhI2rxfnaUs9XYxh/aMgF3MFhiKZVMGmjmPnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gnyCRqjn; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a45bb2a9c20so1374066b.0
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 09:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710345976; x=1710950776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPKYe40craARbO1i5F7IziwUbywNogLHwQ/WiTOUiBg=;
        b=gnyCRqjnRvYwOVNX5WyPA0kcIrZdZn3/aJoaNwoDJBhnwQ60YBx9ttaScNexuSe0VZ
         y97yvTj5iIzyp7vAhuDcXxhCqJDrydsVnqY/KhVKOiDkoMoEOuFZuhpkUpJ2dkg6aNM0
         yNEHE3+3aJh3tqUI7xV4b/Cehnx27DChG8LtRJG9UuI41gbmxk02hNgzGncGNu9G6JK0
         2/5EMsB29y1csz8VkDyLv537D97tbk4gErdLmLxMzAbAXaOSaiCS79cdp4dLoAPETErc
         nEBa5D3f2lvkH4Nk/TMD86wfa4lrdHX9SMFxho99FVo/El+OUN2z3ilRGQdhlpWYn1YR
         Hb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710345976; x=1710950776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPKYe40craARbO1i5F7IziwUbywNogLHwQ/WiTOUiBg=;
        b=V+p9S50uus38prZkNpwiBpC/XoSaQTKVzhqEowyl7500pxzj8qpeQfc1mDYEakr+WA
         Y0CayOQfkdeBaEE0Bbw+o5J03F1ZDYTbvdcSc5RXaDtJZ4OgaBaYRXkJhO/+4jqfyYK4
         fA4VZQpkQc3eTJqMEBN17HLETr8ca30r0etvGtdnIFe5Z9ZsZzb8GPww2KOCTQOmaAtm
         HYKk0o2/zPaYLlV3fY1eZVoKrPiKkbCnkZojoUaVACev+z4sOgKVit9xNouyDLBQHGsJ
         W+xKcMJn7idhXiG0NpDSlLtP/2VGGl6lCyW9O4K6tZjU2H0uLAlJp6OkGFpoP80ytWhh
         trRw==
X-Gm-Message-State: AOJu0YzaPifMRLOgCYrvCmBoQkzDgIQ9QUGHBCq6wxqFLwAweXOjB2El
	hTRWCOkN/QplRfTFGo0CYiiWSFibp7qYW09UFXSGo8BI0zaVyHclFQpsevRi
X-Google-Smtp-Source: AGHT+IEHyog9BUqNA+o+pdSHmMtRiz1V0WGoRUr57EoL7gu/TS0cfJmTzX7Wf74tNVCf8YwsYq6ihw==
X-Received: by 2002:a17:907:d047:b0:a46:3aa2:d452 with SMTP id vb7-20020a170907d04700b00a463aa2d452mr6049181ejc.64.1710345976529;
        Wed, 13 Mar 2024 09:06:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7461])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709067ad000b00a4655976025sm798328ejo.82.2024.03.13.09.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 09:06:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: simplify io_pages_free
Date: Wed, 13 Mar 2024 15:52:40 +0000
Message-ID: <0e1a46f9a5cd38e6876905e8030bdff9b0845e96.1710343154.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710343154.git.asml.silence@gmail.com>
References: <cover.1710343154.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We never pass a null (top-level) pointer, remove the check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1d0eac0cc8aa..cfe1413511ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2696,13 +2696,9 @@ void io_mem_free(void *ptr)
 
 static void io_pages_free(struct page ***pages, int npages)
 {
-	struct page **page_array;
+	struct page **page_array = *pages;
 	int i;
 
-	if (!pages)
-		return;
-
-	page_array = *pages;
 	if (!page_array)
 		return;
 
-- 
2.43.0


