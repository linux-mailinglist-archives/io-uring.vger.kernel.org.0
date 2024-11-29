Return-Path: <io-uring+bounces-5136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D36169DE7A9
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07DFA1644E1
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3642B19E980;
	Fri, 29 Nov 2024 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0Aw5rFS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ABB19D8A9
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887245; cv=none; b=Lf6qlAbaiedDTj9mk7+v3ed/2h3y83Nunm59Csx8BfuQw8ZcoudsV+Rue6Uu0+zJ5zWT5UI3YwM20ff7+q4lNQ6pt/a92ELlSYxWGGUS8Wgyimwjbokt+Wo3Ze8TX85CYSeX4o9D1nfI1/kUDR78yhPabKzTZ53/Gilh8XHyctU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887245; c=relaxed/simple;
	bh=HiPHB2byif2JmwtD9synNZcUgz3oMf9JozNgG/Za3iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+Ke2UGz2VUoUrGoddHVI8OD6VphzKbzZNshoXO2S+jWMe2XID+kuDSIh/gzBEN0Oh5pPtzuesQETlmyxnmIwVU3EiZMeSxwxfgifRtHQ6vQVEVF751jf2uxbhwVWOiixrxh/XG8SnxC0BgNi+N9PlerJU78NWPW7t4zIzcVjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0Aw5rFS; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ffc3f2b3a9so28132241fa.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887241; x=1733492041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DubJ6ZhJK+V7sUnHZiHP3s7lIIuPRHa1v63uLBvTUGE=;
        b=m0Aw5rFS8yQJhCbdkRP1gil0uOP8fcybaabjN/VPqVWy4C/ztnnymvyIiI2b5l2DBU
         rLIuDdHV3j3x+Fchj/4HGOcAG0Lie5ieN1hm6QOuJCjONqvpOcwwQcE6BxSIqb+WWbgQ
         EEb6X+td0Sv+ExEJennTzONHwp6rpamj8P9WmlrdXazWxj76J2ASJZEnT6mkQdEkxRuy
         8IcIkExmxQDBZXn0NRiPax0sJNGDjtbxyl5792lfA6PGz58Low1iqC8+vwM1p9u2Hdwn
         ETXbWJif7tIPO5drJ7937o4vzSGvB1C3YaIny3v1sgZHpsZAYOrMJZBhiJ4FTVQqFQfL
         WzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887241; x=1733492041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DubJ6ZhJK+V7sUnHZiHP3s7lIIuPRHa1v63uLBvTUGE=;
        b=PAAYaK0ghqCFiktoIEwY7LKVZLaKXd+3Z8szwbKrf8ONJOoEK3eMk2/gCXz09IWtgA
         xBbz0bsXzWW4s5fNPsoyqusJFjz7XRHqnjDfJldNRWgOCgpwbI4n0styjxFDpMeOXVKi
         M6z6A5NtAE2dYUzsh8BETpbqPHNkZUVm3uBK6RMgce/SsG35kNqoZmEV8yuKMBhA67s4
         bAJpWbWLDVCb22Etq3UvDwbgP/Kkw1zn1mS5ca0XiXElRlPSa+Xc+jW+AT0qJnINiHmm
         pbxwXWCXb6hqVYY5LO9Vxk2P5XLOpd8D9tJlXACimiArsIAKtLkGt/315i0BvMahYT9U
         cfWg==
X-Gm-Message-State: AOJu0YzOm7wJxY0syRQLsIb4Wc4NIRLkcvwB1cYp9cM5HynpTuTHLwBv
	+ZW1mc8bFN2xHjhJrgKtGiefYuqHrWKeZWVWhgCIXMWyLOZbyk0jZ/s+iQ==
X-Gm-Gg: ASbGncuPfxbGXRvCLrM8hzzDVY+BBuYQI7s8idZxhXWTVZAwkrhM+IfqxKpSewgl3SL
	lXML9HYEAWbzT/9sxoSPeXk5UZV9xCyyTRat7rpUMvFbCZ+Alnbwf1vLiKriuIM3zGT/RIcWWUf
	2mUPHesl3c8ELcUvkUp7YDvAnoR8RT/7vEhhmRISpxjl+htU/FSbDdZ94s6hNh1YFhgWuAMNnNS
	m6k2vQKZamKNRo2Qlu8/n3IaL0AWKporyxgQMbmP0N03krQYsHp5qPicsC/sswN
X-Google-Smtp-Source: AGHT+IFnmtOVGzLVQvqJG24P0xpyIMv5HZK06w7LGm4N+GVsh+rkvXUpYygi/za1wUsvoqVb1khHAA==
X-Received: by 2002:a2e:bcc2:0:b0:2ff:95d7:9ed2 with SMTP id 38308e7fff4ca-2ffd60c6f1emr113906611fa.32.1732887240858;
        Fri, 29 Nov 2024 05:34:00 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:33:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 05/18] io_uring/memmap: account memory before pinning
Date: Fri, 29 Nov 2024 13:34:26 +0000
Message-ID: <1e242b8038411a222e8b269d35e021fa5015289f.1732886067.git.asml.silence@gmail.com>
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

Move memory accounting before page pinning. It shouldn't even try to pin
pages if it's not allowed, and accounting is also relatively
inexpensive. It also give a better code structure as we do generic
accounting and then can branch for different mapping types.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index a0416733e921..fca93bc4c6f1 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -252,17 +252,21 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	if (check_add_overflow(reg->user_addr, reg->size, &end))
 		return -EOVERFLOW;
 
-	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
-	if (IS_ERR(pages))
-		return PTR_ERR(pages);
-
+	nr_pages = reg->size >> PAGE_SHIFT;
 	if (ctx->user) {
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
-			goto out_free;
+			return ret;
 		pages_accounted = nr_pages;
 	}
 
+	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
+	if (IS_ERR(pages)) {
+		ret = PTR_ERR(pages);
+		pages = NULL;
+		goto out_free;
+	}
+
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!vptr) {
 		ret = -ENOMEM;
@@ -277,7 +281,8 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 out_free:
 	if (pages_accounted)
 		__io_unaccount_mem(ctx->user, pages_accounted);
-	io_pages_free(&pages, nr_pages);
+	if (pages)
+		io_pages_free(&pages, nr_pages);
 	return ret;
 }
 
-- 
2.47.1


