Return-Path: <io-uring+bounces-173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA75A7FFBBB
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3CF4B21054
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4F553E05;
	Thu, 30 Nov 2023 19:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b4oQpmwm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D48D67
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7b393fd9419so6309339f.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373601; x=1701978401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzni/7YGjthyX/EKfOM3P3qwS1b3E+PYRXzgk/3HwtU=;
        b=b4oQpmwmKPW7DgXXS5pRaL4H0dc7S8TdNy3Wj7W/IqquqQo6ko7dpbSOhq+eNJX8em
         9l8K8GA2Rs6GEoOPsq7kHYr/lMlQohjOkoUlKzZLRx9o1G+7DSsKXgrsuexKpJVLyCiH
         Al7/b6CV+XCaWbGQjmwOjwOqq4vDGn/ZnWUxq3LPu6eZywcguavY0G0mjyI2QNUId109
         aXvbFx/waNVHWK5OXs8rP8V1KFE67bVhkBuCGQ+LQkUpghQqbHX9ipWN0K0nWxLLTSiQ
         LWESbHkbHoP2LedCez82geWbKQC7kFEbblVa9iSzFtcSJKGkpNr5NTp5vphQ/4YVMpb3
         aosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373601; x=1701978401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rzni/7YGjthyX/EKfOM3P3qwS1b3E+PYRXzgk/3HwtU=;
        b=kIPkf5tKiRV4UMo6rIa6Inm069Z3gmnnaAd8PvYYviorJ3Y6UftxA0SiGR0zuv7kPP
         vFrvLnjM5QlIzLpTs+h2S3cU98BAKewTEk6HPEEgl3/neBdjMmf1TsbeYhtk6TifFLbk
         KopkDS0xJ8M0/qrqcRL2tZK+gFXKpHo448VlHS9SuzttIK8xRN/Txs3ORW81Wm0nTAuL
         qVI+JJgblf5ZjKA7I5a9uax2u15XwAdmvlXAW4Y099PvccnzcYBiggaizu9MD1fu3VF/
         FZFtqIoDZB4byI66+Z3LHNS+uFJjVVk4QVcF+Ut3UveefVpy4vpcM3xUjHYcK/eyqkdx
         HzVg==
X-Gm-Message-State: AOJu0YwCNsQbrUU2YPwyE0PSlgm+ARx/ch52H/qVzpyPcruApO1mC4W0
	DamM1VZ8B8V9Zzf2jIdjhV44hES8lxl0cdjlL5zucg==
X-Google-Smtp-Source: AGHT+IGC3u4ZpnZCT+lO/hHmrcofG05ga5uT1s4J/28aCYMZ/Hx7i65Y9YHMKbcs/IFc15WQg0qk6g==
X-Received: by 2002:a05:6602:489a:b0:7b3:95a4:de9c with SMTP id ee26-20020a056602489a00b007b395a4de9cmr19103111iob.1.1701373600877;
        Thu, 30 Nov 2023 11:46:40 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:39 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Jann Horn <jannh@google.com>
Subject: [PATCH 1/8] io_uring: don't allow discontig pages for IORING_SETUP_NO_MMAP
Date: Thu, 30 Nov 2023 12:45:47 -0700
Message-ID: <20231130194633.649319-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_sqes_map() is used rather than io_mem_alloc(), if the application
passes in memory for mapping rather than have the kernel allocate it and
then mmap(2) the ranges. This then calls __io_uaddr_map() to perform the
page mapping and pinning, which checks if we end up with the same pages,
if more than one page is mapped. But this check is incorrect and only
checks if the first and last pages are the same, where it really should
be checking if the mapped pages are contigous. This allows mapping a
single normal page, or a huge page range.

Down the line we can add support for remapping pages to be virtually
contigous, which is really all that io_uring cares about.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ed254076c723..b45abfd75415 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2697,6 +2697,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 {
 	struct page **page_array;
 	unsigned int nr_pages;
+	void *page_addr;
 	int ret, i;
 
 	*npages = 0;
@@ -2718,27 +2719,29 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 		io_pages_free(&page_array, ret > 0 ? ret : 0);
 		return ret < 0 ? ERR_PTR(ret) : ERR_PTR(-EFAULT);
 	}
-	/*
-	 * Should be a single page. If the ring is small enough that we can
-	 * use a normal page, that is fine. If we need multiple pages, then
-	 * userspace should use a huge page. That's the only way to guarantee
-	 * that we get contigious memory, outside of just being lucky or
-	 * (currently) having low memory fragmentation.
-	 */
-	if (page_array[0] != page_array[ret - 1])
-		goto err;
 
-	/*
-	 * Can't support mapping user allocated ring memory on 32-bit archs
-	 * where it could potentially reside in highmem. Just fail those with
-	 * -EINVAL, just like we did on kernels that didn't support this
-	 * feature.
-	 */
+	page_addr = page_address(page_array[0]);
 	for (i = 0; i < nr_pages; i++) {
-		if (PageHighMem(page_array[i])) {
-			ret = -EINVAL;
+		ret = -EINVAL;
+
+		/*
+		 * Can't support mapping user allocated ring memory on 32-bit
+		 * archs where it could potentially reside in highmem. Just
+		 * fail those with -EINVAL, just like we did on kernels that
+		 * didn't support this feature.
+		 */
+		if (PageHighMem(page_array[i]))
 			goto err;
-		}
+
+		/*
+		 * No support for discontig pages for now, should either be a
+		 * single normal page, or a huge page. Later on we can add
+		 * support for remapping discontig pages, for now we will
+		 * just fail them with EINVAL.
+		 */
+		if (page_address(page_array[i]) != page_addr)
+			goto err;
+		page_addr += PAGE_SIZE;
 	}
 
 	*pages = page_array;
-- 
2.42.0


