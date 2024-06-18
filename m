Return-Path: <io-uring+bounces-2254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8F690DBDA
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 507901C227B1
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5F838DD3;
	Tue, 18 Jun 2024 18:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BZrd5ol1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AE51171C
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736496; cv=none; b=JfQNgjhKoDBCD2I0Lf99Tg6ZjLR+gCNFYXW7DxqdsLZ6xKH945y40Ty0w4G10rH0SlFaxEMDecsDu1wenOtucYZ+rZId2FIUgGeNJVsJkw3xChLoWTuq2K7h4bVz+mcZi4xPpcKjJHlRqeo/adEQGvi6KkT6ocvfOOzAPRNeaxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736496; c=relaxed/simple;
	bh=OBDP+HBvhO4wcCCMuSh7QG5+mYmZSXSrsC960b22TZU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=kq+9NsT1OAcPIlVxibR6C/TiuSL/6EJy+lsxKyOia3CmqSn/fk82T8HSazsVZkACwo6WeTWKl1miK5d84uxILeE8c/eK8hZZcDmYsEzXoLiTkYzo7GWMmyQaiHtK70o3JoZBnMz8UxgaOIJuF8GnPbXLLBGB3S3xULJx3FVlXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BZrd5ol1; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-254976d3327so461543fac.1
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736494; x=1719341294; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJLculYgYkTCtGkKCz0AG2WsArDHEComCy9o92d5+qY=;
        b=BZrd5ol1rIG/axwnROtyY/yqxhlbhaNTwMqENxTH82Y825r/Haq3cZq83U9+sMVLwk
         MBjO77I0VXQD8SwF9uxOfrN+1MlkDF4nqRun/5ecIu757HY5NOI0oCncvOkRdZjKI/EZ
         ZAiuc5pyKwPZvxjFqmqdUsn2a1WdMnJX6BRRXHgBjBFPS5HyM6apcoN4BKATDTftlatP
         q/PxfYi+N7bioMbw7HqonI8w+E8OMDkUcaC2dwHnEYOJOFXgGfEsYIfHOoeAoRWLMyqU
         /rBwzkM0OsqNIxpZ86ijSwJyEFpm7bFxqpEo4V95ca7TPaaD6xV358shdIo8xghWQ4Ud
         k35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736494; x=1719341294;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pJLculYgYkTCtGkKCz0AG2WsArDHEComCy9o92d5+qY=;
        b=du5tiAPP+0lMEHEJI++qOLwdy63EcKIlDWg1Dp/vD3eg+UtzZ4EhL/cEagnOeqLfTc
         xVSDZqALduDnBFXJv/+D4e+fp5LglXF/uS+7Pfp6uCnPuvtU5pE9SgdnOiXsfbIPESYN
         WKjQVP8i8MP51JO9GEqEFsFu746f8FIoD+rrd4NoiHQoPhp1yWJdMaWXG+zRbgFJT3nB
         Jnv6G5eQrJkp16W8uxpuNyr+vTbpW7bsgqgbf4AWVzLXHvSYfuBw2Vhh9ivbjobNr9gx
         fGbd8NcucFqUnaH5hK28jlrfTulQo1+tdt4qwtIXvQDS2zwJJUt6Q+zWtZP+iMtvUbPd
         3E2g==
X-Gm-Message-State: AOJu0YydK3T8GljhyVN15Xx3X/ZWCdOdqUeZmAdFVF4iSKAodagw6/yP
	GsFClnF2fwoeGxAf4f5Jh33IJjwEEXrrQFJijHjB5LnAl+mXFBgCCZoFPNRuIxwDs4ExwUmmim8
	2
X-Google-Smtp-Source: AGHT+IEEvfsqRE3iO112tp2vJxM4wSPBPXEDyXaHyKTVsb51hXNEtaC4F9U+2RyS2bU7I4d3PxAyGg==
X-Received: by 2002:a05:6808:180d:b0:3d3:a23:8815 with SMTP id 5614622812f47-3d51b97dcfbmr596904b6e.2.1718736493757;
        Tue, 18 Jun 2024 11:48:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d247626e33sm1863440b6e.23.2024.06.18.11.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 11:48:13 -0700 (PDT)
Message-ID: <deaba6b5-743e-477d-88cc-3d1a2c82ebb4@kernel.dk>
Date: Tue, 18 Jun 2024 12:48:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: source@s.muenzel.net
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/advise: support 64-bit lengths
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The existing fadvise/madvise support only supports 32-bit lengths. Add
support for 64-bit lengths, enabled by the application setting sqe->off
rather than sqe->len for the length. If sqe->len is set, then that is
used as the 32-bit length. If sqe->len is zero, then sqe->off is read
for full 64-bit support.

Older kernels will return -EINVAL if 64-bit support isn't available.

Fixes: 4840e418c2fc ("io_uring: add IORING_OP_FADVISE")
Fixes: c1ca757bd6f4 ("io_uring: add IORING_OP_MADVISE")
Reported-by: Stefan <source@s.muenzel.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/advise.c b/io_uring/advise.c
index 7085804c513c..cb7b881665e5 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -17,14 +17,14 @@
 struct io_fadvise {
 	struct file			*file;
 	u64				offset;
-	u32				len;
+	u64				len;
 	u32				advice;
 };
 
 struct io_madvise {
 	struct file			*file;
 	u64				addr;
-	u32				len;
+	u64				len;
 	u32				advice;
 };
 
@@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
 
-	if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	ma->addr = READ_ONCE(sqe->addr);
-	ma->len = READ_ONCE(sqe->len);
+	ma->len = READ_ONCE(sqe->off);
+	if (!ma->len)
+		ma->len = READ_ONCE(sqe->len);
 	ma->advice = READ_ONCE(sqe->fadvise_advice);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
@@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
 
-	if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	fa->offset = READ_ONCE(sqe->off);
-	fa->len = READ_ONCE(sqe->len);
+	fa->len = READ_ONCE(sqe->addr);
+	if (!fa->len)
+		fa->len = READ_ONCE(sqe->len);
 	fa->advice = READ_ONCE(sqe->fadvise_advice);
 	if (io_fadvise_force_async(fa))
 		req->flags |= REQ_F_FORCE_ASYNC;

-- 
Jens Axboe


