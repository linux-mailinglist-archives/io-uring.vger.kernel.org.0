Return-Path: <io-uring+bounces-1263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F84E88EF18
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62ACF1C2EA49
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEF412E1F6;
	Wed, 27 Mar 2024 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="brCBvRU+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4279B1514EA
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567195; cv=none; b=QOR6T2iYOfNuyZiY8AJEJTlWnmna+1NSTZHlV9s+rFaganoOGnm0nzzoMMVQTNv0/9Yfs47uBAxPuK2aeFjTgOy5c1Lw5GeZ2a7NDwaYlWkSXYMtDlNznLbjntrcdHZHJdNBbSS08KGpc8wCIr6AoGHgJ4MkBa2AH6eh/xLidgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567195; c=relaxed/simple;
	bh=YSpQj8fqX+tbLB6tYf9HPldNaAuc27V0fHVqVAkaBSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tztLx34AcCFOJ0qa8NchImawZLBkWqWK/6tTS0CipVBINhFXqjFJji0Dpgm4it8Fg4LujUJBivUUA7en15YJv444zKTlvad9DzJ8RxXpcVkfKc7TVhRbWthkL1LWr6u/7QPYmcjGKaO28Q9RcE+NYASN1IIQt9ZUzXDBV4qwoPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=brCBvRU+; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6c38be762so41841b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567193; x=1712171993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRPtHKt58oVWeh2+NDBEfZ2xFmX8Q/Yl8QC5Ndz+dR8=;
        b=brCBvRU+tTRwtV9Go1Id/1mBbIjKpAn6ejjlZ2NcWPeeMpoBXs9rXKjRyatWr6Mt6r
         LpbQ6iOjUjt0/eoc7aAn4cw2daClWUnpiiBdz8AYb9Owi8OGlD342BYLGuUwPKdxMFOH
         O7Br1jScgaQdupI9Y5ZaVEGly1tESuTDpszKH1DLB78Vybwe+z5e3LNqiwKhuwbBF/hJ
         eNZVxLNDQzaNBnEnXwboLuM+hplYt/BBOIG8NOdlOqniLQcWYfrXPQV5GYRl8BaqcQ0v
         M4MT/2OT+437M4OgvxIVHtC93bzIsmfwZLZvs4mjMP6/Qk+34Hqs7Moi/HSeLSEr+Ec/
         wOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567193; x=1712171993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bRPtHKt58oVWeh2+NDBEfZ2xFmX8Q/Yl8QC5Ndz+dR8=;
        b=JL+4G4sDHDm1JzFgBDynypFMOCvJW+t/BjizrcKqfQ9FY3Y950CD1jKO/1ym0OfZ4Z
         l9LbRnCjKA+4fB/SGjW93ijrTstNGVGM6+AR1rjGpXJ9wbVeLiy88PtiApPvjLXUyLxj
         +VSObliETCCYPf2kmCnDdrLvhXz/Zm6TDawJzJlQD8NWFvw1FgxcrUSQc3951rl91CsV
         mLTzhGhXnEeTAW+fIKiv7TAFQHLd1LBija5qN4jS0AUyVvwtIYVf6P4xgAeBkp6fIcXu
         AhNfBmpoer1KZJTAI/uoMAFAelBw7F4zX6JDg0Rh4Ze9LjZj4AfFD+f2BhMbMmh+cCMa
         vLJA==
X-Gm-Message-State: AOJu0YxV16w1/sb2tHPBYdseuOo/Qsl4c94eRhfPnwj9jVnhwxynUzSX
	CIGKj/MarV7ZUjOj3nzIUnE0SQq936RZAlhx1FfSNhDbbeizepDdb1i3m+vHsM8dQHvsfy5Nm4V
	7
X-Google-Smtp-Source: AGHT+IFPA7J3ZmjEoLJpSmrKQxynFA62CCUwF1XAQ+S08zx+FFmTCCYBDcsACOYcPak7ortvwkQlBg==
X-Received: by 2002:a05:6a00:2d2a:b0:6ea:7f2e:633 with SMTP id fa42-20020a056a002d2a00b006ea7f2e0633mr836611pfb.2.1711567193024;
        Wed, 27 Mar 2024 12:19:53 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/10] io_uring: use unpin_user_pages() where appropriate
Date: Wed, 27 Mar 2024 13:13:45 -0600
Message-ID: <20240327191933.607220-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a few cases of open-rolled loops around unpin_user_page(), use
the generic helper instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 4 +---
 io_uring/kbuf.c     | 5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff7276699a2c..fe9233958b4a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2622,13 +2622,11 @@ void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
 static void io_pages_free(struct page ***pages, int npages)
 {
 	struct page **page_array = *pages;
-	int i;
 
 	if (!page_array)
 		return;
 
-	for (i = 0; i < npages; i++)
-		unpin_user_page(page_array[i]);
+	unpin_user_pages(page_array, npages);
 	kvfree(page_array);
 	*pages = NULL;
 }
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 99b349930a1a..3ba576ccb1d9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -457,8 +457,8 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 			    struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br = NULL;
-	int nr_pages, ret, i;
 	struct page **pages;
+	int nr_pages, ret;
 
 	pages = io_pin_pages(reg->ring_addr,
 			     flex_array_size(br, bufs, reg->ring_entries),
@@ -494,8 +494,7 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->is_mmap = 0;
 	return 0;
 error_unpin:
-	for (i = 0; i < nr_pages; i++)
-		unpin_user_page(pages[i]);
+	unpin_user_pages(pages, nr_pages);
 	kvfree(pages);
 	vunmap(br);
 	return ret;
-- 
2.43.0


