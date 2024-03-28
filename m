Return-Path: <io-uring+bounces-1313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2877E890E8C
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2AD91F22E34
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195AB45946;
	Thu, 28 Mar 2024 23:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DbE0gLpP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC4A225A8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668901; cv=none; b=EDYmM03SHiRzRkIfDHKee6WB3un8i95beM6xO3AgAwLryG9VZnKiftkHCmrkDT6JWpuGLw8+1GVmieoZF2zEcrdfpFHHuOJisMLMXkDKgjDjCjY2mlmBAu+2gq04lMn8MTNFIytNr+AUWPTYDnwq7rPD9W6oiUvj6PlwO3NBOxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668901; c=relaxed/simple;
	bh=8G3QN6wuHYeuEtMo+UdWrxs8c//P5kJMH+4+MKrhbiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bapj7voK0wdKgyKWwbAXUskXgQ05BMLjlUwfDrE17e6F8JO8A5Pf5Sig7JCk21vSDNGc65KnjGFU/b6xzC5GkEWAksTqitoCGIrZnI4UvQXfeRxqSl/G5DEo8VzTKbSDW3NvOj6NUyE0VmKWKs/3VG31d2IpLhSuVfRqouMZHJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DbE0gLpP; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5d862e8b163so317575a12.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668899; x=1712273699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtvzBKul3lnX4UwRp+DUDb1X15hTCGMb7+BkwEEbcgU=;
        b=DbE0gLpPprOUtmyGI5T/wYx8JdktjL7my2/vucvF6zrqvIbPJ2yYpapiPw4fyfavPD
         4HT8q9OUBao5P+2BYk3UFtd9ddCeUnyaiQqnX2lov/oChrB5a/rco4pzyrNhFce15d34
         yIUCMf3owhYxqRUMKMnF77dH13ykZG38X4vQQmchKliMTvwS5cLxwAEEA83duOkIVh1B
         aPl+jU8lONLsICNG4cbFtc9F2GsL4r41jXeX3/EvX0T2RXFKOYREfCyGb+dVxutIPHbV
         vJvLQJZ4b0WbaWyx7NIaqdi03D7qd20HBTL5h0yrJTS+siUsJEkr0AzyHb772oeb16Wj
         lXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668899; x=1712273699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtvzBKul3lnX4UwRp+DUDb1X15hTCGMb7+BkwEEbcgU=;
        b=JUNtaS0HpjB0g+YGpgOWKiNwE1Wb8NUVhnrEcpRVaqMS2bv+TtZ8GaheeFIvgxbQfw
         m27sAQ+vSSQ0Nv5rCWHRnUlOWJq7TWy5B6DGCFB7+FdAUM0XrADKiDU+drUKZ8jnwmP2
         uz/iCwteYAAcegj4NIGzIysdqmI+/QS8DNA2mKjYi2O0hqmDzUkTtUt52eMnjLRJaDF0
         eAhCkLGB8UpumiujoKuIMkQIt5wapgxZApJxprCsGSQmVQZHpRUWa43HJ7ZtnzEnXGFb
         R4PIniZvHPG1zcXlUV1kfEqePSFl6V2eh+yEGNXcLvan+d8KzenQjK26hy5Dq3thHyFs
         GljA==
X-Gm-Message-State: AOJu0YzN1pGKhfeHJSFXF23zJx/FcGW9LqDHk4CwXTMIRXmbcsTLQ1o5
	xbtebO/jA+QURTRvR6s2THnWX4153yPmohei93S//NZSqRflVBINZHrropFT5T0QrjHA1/66s2b
	/
X-Google-Smtp-Source: AGHT+IHMrKoSuOgUJAZ1BjSxfV5Yyb01o9L8DQuab2vKfL2DOj2AT5BGY+ufChJnR8NHTkxdMBpRlg==
X-Received: by 2002:a17:902:e88b:b0:1dd:b54c:df51 with SMTP id w11-20020a170902e88b00b001ddb54cdf51mr956244plg.4.1711668898649;
        Thu, 28 Mar 2024 16:34:58 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] io_uring/kbuf: get rid of bl->is_ready
Date: Thu, 28 Mar 2024 17:31:33 -0600
Message-ID: <20240328233443.797828-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that xarray is being exclusively used for the buffer_list lookup,
this check is no longer needed. Get rid of it and the is_ready member.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 8 --------
 io_uring/kbuf.h | 2 --
 2 files changed, 10 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8bf0121f00af..011280d873e7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -61,7 +61,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
-	smp_store_release(&bl->is_ready, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -721,13 +720,6 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
 	if (!bl || !bl->is_mmap)
 		return NULL;
-	/*
-	 * Ensure the list is fully setup. Only strictly needed for RCU lookup
-	 * via mmap, and in that case only for the array indexed groups. For
-	 * the xarray lookups, it's either visible and ready, or not at all.
-	 */
-	if (!smp_load_acquire(&bl->is_ready))
-		return NULL;
 
 	return bl->buf_ring;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1c7b654ee726..fdbb10449513 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -29,8 +29,6 @@ struct io_buffer_list {
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
 	__u8 is_mmap;
-	/* bl is visible from an RCU point of view for lookup */
-	__u8 is_ready;
 };
 
 struct io_buffer {
-- 
2.43.0


