Return-Path: <io-uring+bounces-4759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 616C49D00F6
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0606B234AA
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726A81A0BD8;
	Sat, 16 Nov 2024 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPB56OOc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5485199951
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792436; cv=none; b=d0AYd37OCXvpK1BuKKP+hx3xnfrgYBrfi+l5GewSa3z5uVEOMcsvJYrTFo4Pl/8abG6WvRCZI7upRkouUs4IHqUBNWEWMoFMFNYfxCd/jn7UePk+fgyOcWld1e8MuLceqzmJT066+iFCMlkXHY8x8u186pDgVxcU7cQIIP7TIEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792436; c=relaxed/simple;
	bh=yjB4gJwDQul0jz8AIPThX3h4EGCwd+BWB09OydCbPOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vxh+YUBHWMSDxFNg14hheeIt2qhrZylH1e5gpS3z7FMd+GUDvDcdmDZeQrzquQtpwQiWvS2ojwyltLULRedNaoBCAMTbpCpG4uc7r7S+jnaubv2XT7Y3f5FI+BgGjlg/AJDsQsEinJlLhXkGo7CjvKQNjV2xWOWzCdGKuNaMooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FPB56OOc; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-432d86a3085so7515135e9.2
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792431; x=1732397231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mh8I21kvfztjBG+u8dEs8RjQmxtH6iAHnm7ZZZMg+q4=;
        b=FPB56OOcWWIMoS06eUMZZTupKQpVwCp7n301JueJjH5TxbUfFa1tJM0zodLiJs+AD4
         7C/Ojg6IasF66+S4VzIJ9S3Nr27Qa5vJaSWNFsSc03WCwlVDP4/kn9oX/cleFgpWCQvv
         km3TANIb/119qLdsmkb4rAQ0+Z+r+96vo+5KS36fRRLXQtUOnwpd3VRpCVaKXzYVMBMH
         oRNXtRsATGtn+1KxWbfaKbgFKErCIVCpBZwU15oPYpSq98OGlayr93jLt3qbusaMpLU2
         89K+INA6RS24QjthQ4KMM303UoCOrU31TUBA63mUzvQ2NpOs4TAdjbwSIbd5B2t7ZAKF
         onfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792431; x=1732397231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mh8I21kvfztjBG+u8dEs8RjQmxtH6iAHnm7ZZZMg+q4=;
        b=qFgZVG5Wl6yrGo1h/WKeDGcIxN0psG29i1WlSIdk3sFKo9VZMWgnl0+C3aIaSu/hcp
         DZuXX19koamq8skHq4fHuyeSNshFsofLk7rKd3U+H9aAmCYvz+Og3fA14SBmKs46vU/I
         NNIFSH3O84ZU2GbjrI14i6G/SBnYdM34niwau31HGnW7HMFyvEasNvBtmj0ouMn7OxIU
         kXhHvMj7egHYUkCKT4jvAd4/azDdgB1czhGP13tamsjCPSLKXG+90V6jlXw42Vh63/IA
         c5fvlj0fv+9FAySvmLQv0j8OFSuc6z2tTgjJj0XcLFi12JnD/+hRN1xz1+LAvGjg/qUR
         WuaQ==
X-Gm-Message-State: AOJu0YzoA4O4busnnhUTg4MSXHqTCsTL5Zo+cSqW1GbjTSuOjOjl+UJa
	+MSLrninlKTy4RU73r/18KR+v8YNNrHN+E4IV22cwKkt1uUTNktOe3hBiw==
X-Google-Smtp-Source: AGHT+IFIxT2h3vien8C2Reg8jIdgAZps3rYx8+8QfTVGhaurmoVyHn0BkM16ZNGhD7Hptn9BGU2iOA==
X-Received: by 2002:a05:600c:3c9a:b0:431:5465:807b with SMTP id 5b1f17b1804b1-432df793de8mr54377595e9.32.1731792431309;
        Sat, 16 Nov 2024 13:27:11 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 3/8] test/reg-wait: use queried page_size
Date: Sat, 16 Nov 2024 21:27:43 +0000
Message-ID: <aec96dc7c43d7479820f686e615f7e949cf7f358.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index ec90019..6cf47bf 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -101,7 +101,7 @@ static int test_offsets(struct io_uring *ring)
 		return T_EXIT_FAIL;
 	}
 
-	offset = 4096 - sizeof(long);
+	offset = page_size - sizeof(long);
 	rw = (void *)reg + offset;
 	memset(rw, 0, sizeof(*rw));
 	rw->flags = IORING_REG_WAIT_TS;
@@ -259,14 +259,14 @@ static int test_regions(void)
 	void *buffer;
 	int ret;
 
-	buffer = aligned_alloc(4096, 4096 * 4);
+	buffer = aligned_alloc(page_size, page_size * 4);
 	if (!buffer) {
 		fprintf(stderr, "allocation failed\n");
 		return T_EXIT_FAIL;
 	}
 
 	rd.user_addr = (__u64)(unsigned long)buffer;
-	rd.size = 4096;
+	rd.size = page_size;
 	rd.flags = IORING_MEM_REGION_TYPE_USER;
 
 	mr.region_uptr = (__u64)(unsigned long)&rd;
@@ -286,13 +286,13 @@ static int test_regions(void)
 		return T_EXIT_FAIL;
 	}
 
-	rd.size = 4096 * 4;
+	rd.size = page_size * 4;
 	ret = test_try_register_region(&mr, true);
 	if (ret) {
 		fprintf(stderr, "test_try_register_region() 16KB fail %i\n", ret);
 		return T_EXIT_FAIL;
 	}
-	rd.size = 4096;
+	rd.size = page_size;
 
 	rd.user_addr = 0;
 	ret = test_try_register_region(&mr, true);
@@ -316,7 +316,7 @@ static int test_regions(void)
 		fprintf(stderr, "test_try_register_region() 0-size fail %i\n", ret);
 		return T_EXIT_FAIL;
 	}
-	rd.size = 4096;
+	rd.size = page_size;
 
 	mr.region_uptr = 0;
 	ret = test_try_register_region(&mr, true);
-- 
2.46.0


