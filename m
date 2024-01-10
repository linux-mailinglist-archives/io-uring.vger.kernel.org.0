Return-Path: <io-uring+bounces-384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8636882A056
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 19:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95E2B26054
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 18:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4926B4B5A5;
	Wed, 10 Jan 2024 18:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="va7Joy/i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD24D112
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 18:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-360630beb7bso3502495ab.0
        for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 10:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704911883; x=1705516683; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvS+yY8nDNORPw8RkEmLy6ho2ne1xiAq0CFpgKCyKh4=;
        b=va7Joy/inVz6/559QCmlopOS07R7hjcat3lFVsWcVIKYISzOEicsP+Rlq4eQxZs7tG
         v5UnCf6Qie25McyHjSujRu/hX/8nXxfSdBbzJZNpvP5rYSdD+Q4GsYgtdhVjE/uFUwpy
         N1hpkaZWk5FDI/KZeCYajHpTZvQVAMpCQJq5ilT3Jt1QYBxfc7IBjqlKm/QmR7ppR0qY
         e+VUGVGkiw6TH6oA32yRo2HrOH+HK3P8uHLNGzwj+Gyncrn1ccnhzIP41m2uRZHgqqEf
         SFGMua9ILuNtOMmRzR9EGwtTnrlWLVcpm2BdczjUrdzJI63HdSAfnnf5wo880tlKt1HJ
         jCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704911883; x=1705516683;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qvS+yY8nDNORPw8RkEmLy6ho2ne1xiAq0CFpgKCyKh4=;
        b=W2AgWyYsqZdypnAmbJpQkDjpCkGaU7YXi0Pmumintx0g25RgSXcOmNSa9nQFdiMFJU
         UGD8PBoSdcHaB4vnbjETi8q7nfoSQfY6tOqlPwuboddHdyVkzmSiNEuyKdhvqJ+eBW38
         SDpo3PvdBs7BgF9Ot09btyztVnfZoZ+Z6+SVeLSottDkXyugwU20XFs6AO12Q+5eg9Qa
         Aa6ughZy8nayPgSIYe6zdeZFPKcYNaa5tPDsi8Y90EYDKSzxObv353fQM18EnqM5XGVR
         VnvlLjXZcwC5D7zOMECiKNm1lXIo6/RwyJegmbVGbli14qwHrxeJbz+89XHufQhszhxc
         MKmw==
X-Gm-Message-State: AOJu0Yy9t0335EMlm7P9lLWbdDMVRd3Td2kYOOc4U31NJfCU0hWpPJsv
	WwaClk2DgmU5F3sDCUATCxOx9ncQseMEuiVldU+afOehKtLN2w==
X-Google-Smtp-Source: AGHT+IGiL+/+v46zhfSKA/s13Im6DGhwLs+of5lgYX5oynI0ndTPcrCGOgvUtQdpIMwZEwxSv9j3cQ==
X-Received: by 2002:a05:6e02:b2d:b0:35f:bc09:c56b with SMTP id e13-20020a056e020b2d00b0035fbc09c56bmr3366682ilu.2.1704911883547;
        Wed, 10 Jan 2024 10:38:03 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w2-20020a92d2c2000000b0035d6f8d02d7sm1394927ilg.7.2024.01.10.10.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 10:38:02 -0800 (PST)
Message-ID: <cbc9efdd-9b38-4f6a-8cdf-b603d26db6a3@kernel.dk>
Date: Wed, 10 Jan 2024 11:38:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/rw: cleanup io_rw_done()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This originally came from the aio side, and it's laid out rather oddly.
The common case here is that we either get -EIOCBQUEUED from submitting
an async request, or that we complete the request correctly with the
given number of bytes. Handling the odd internal restart error codes
is not a common operation.

Lay it out a bit more optimally that better explains the normal flow,
and switch to avoiding the indirect call completely as this is our
kiocb and we know the completion handler can only be one of two
possible variants. While at it, move it to where it belongs in the
file, with fellow end IO helpers.

Outside of being easier to read, this also reduces the text size of the
function by 24 bytes for me on arm64.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2:	- Further cleanup readability (Keith)
	- Add a few comments

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c856726b15d..118cc9f1cf16 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -168,27 +168,6 @@ void io_readv_writev_cleanup(struct io_kiocb *req)
 	kfree(io->free_iovec);
 }
 
-static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
-{
-	switch (ret) {
-	case -EIOCBQUEUED:
-		break;
-	case -ERESTARTSYS:
-	case -ERESTARTNOINTR:
-	case -ERESTARTNOHAND:
-	case -ERESTART_RESTARTBLOCK:
-		/*
-		 * We can't just restart the syscall, since previously
-		 * submitted sqes may already be in progress. Just fail this
-		 * IO with EINTR.
-		 */
-		ret = -EINTR;
-		fallthrough;
-	default:
-		kiocb->ki_complete(kiocb, ret);
-	}
-}
-
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -371,6 +350,33 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	smp_store_release(&req->iopoll_completed, 1);
 }
 
+static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+{
+	/* IO was queued async, completion will happen later */
+	if (ret == -EIOCBQUEUED)
+		return;
+
+	/* transform internal restart error codes */
+	if (unlikely(ret < 0)) {
+		switch (ret) {
+		case -ERESTARTSYS:
+		case -ERESTARTNOINTR:
+		case -ERESTARTNOHAND:
+		case -ERESTART_RESTARTBLOCK:
+			/*
+			 * We can't just restart the syscall, since previously
+			 * submitted sqes may already be in progress. Just fail
+			 * this IO with EINTR.
+			 */
+			ret = -EINTR;
+			break;
+		}
+	}
+
+	INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
+			io_complete_rw, kiocb, ret);
+}
+
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {

-- 
Jens Axboe


