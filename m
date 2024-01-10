Return-Path: <io-uring+bounces-380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BA5829EE3
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 18:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AD6B1F25AB4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 17:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DC44CDF6;
	Wed, 10 Jan 2024 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HRdzXyIO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA4E44397
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso39895239f.1
        for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 09:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704906561; x=1705511361; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZhBU+92JRMQa1mCqM7xx/6bvFUzMoPTns69acPlNXVs=;
        b=HRdzXyIO9OoXiuvli7UoV9J+xcv23dT5exYUOgU0A8bBIKs4oox2eZ2pj2FZcIGgYx
         UNLDMAT5+X7f6RN3+LkDfIjpWMsflk81cR+Yo8NwdYZVn8oq+Uo4BEO5LU26CMPd+ErL
         oT2PvY8DscH2ztREyUxS/jpb/elyN01Y17hlyjV2++r7eOGLc3mvDHs5/kxDRDePh3yp
         TeH0OdLwmSHQePLdWCZcPeRcyCocbHMwFVYKDakX2JNGjFQSSIR8sBZnH+E5TIcztlxs
         wNZVIKH9ubYCvsWyUc/OZZSdonHwnuuAHViXZrWurPLrL+dtHIq+tZtSkvTvTCqRIrum
         GgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704906561; x=1705511361;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZhBU+92JRMQa1mCqM7xx/6bvFUzMoPTns69acPlNXVs=;
        b=wTjXCItYeGDiEUPVwcVyvnAJmv8IvcIg7FZ41lJ+thKoZyImfZNqmH+MIgsIu/7Rag
         Emm9DJU3r5f16tx8gS725NsBMLkkO15cdUpBKZzgbVMdQGCO7npaO40/AwEBM3GzqU/O
         or0ti9o0gwx5K7AxUBGP36isj6Pq3eESMvGrCIg6I8ZweKJg+fCgw/x2k6N8sloljfaR
         bX/UzVWM+YSWxasLuyhKJ8zjzX+HboPTZqVk3IXA3uLhXEqGekQ3mDAyIJ1HtR+JQDgJ
         1j/A5YHtmbHsReNQc4/qZ4Gy07dedbZ6mHWvtdbzRK0CzHZy7ctqiIvZI0Y225vHgsP/
         ZVkA==
X-Gm-Message-State: AOJu0Yy8dcvICr20TZ53sHcauFZGkEfEg+1L/6qaISn6sVtBHGp2Kh+t
	+xb52Yl2TtJtT4FdK0u994tVygHP/VlMZoaw2cqmYJj9g+gKuQ==
X-Google-Smtp-Source: AGHT+IEV833whswEQOG4gLdp+XwOw59yjzj5kUW40aBkCLzGEyguNWj/edc5VdXIFFP6ci4+j12IMA==
X-Received: by 2002:a5e:8e49:0:b0:7bc:2603:575f with SMTP id r9-20020a5e8e49000000b007bc2603575fmr2801083ioo.0.1704906560647;
        Wed, 10 Jan 2024 09:09:20 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cn15-20020a0566383a0f00b0046e4195769csm769592jab.79.2024.01.10.09.09.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 09:09:20 -0800 (PST)
Message-ID: <8182cb84-0fca-43b8-b36f-0287e20184cd@kernel.dk>
Date: Wed, 10 Jan 2024 10:09:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: cleanup io_rw_done()
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

Outside of being easier to read, this also reduces the size of the
function by 10 bytes for me on arm64.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c856726b15d..885d4f16d11d 100644
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
+	if (ret == -EIOCBQUEUED) {
+		return;
+	} else if (ret >= 0) {
+end_io:
+		INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
+				io_complete_rw, kiocb, ret);
+	} else {
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
+			WARN_ON_ONCE(1);
+			break;
+		}
+		goto end_io;
+	}
+}
+
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {

-- 
Jens Axboe


