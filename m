Return-Path: <io-uring+bounces-2948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED49895DEC2
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A4CA2827C3
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E99C153820;
	Sat, 24 Aug 2024 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YO/gMRE0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF6929CEB
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514578; cv=none; b=CbcPMhffdi1/U5Gw5tkO9lC4/zhzg67TrWXVbnNGS1aA9aWnT1idXn8aWrcKIkofYESQ4pK6MQm2KrTycf21mzbpRHbCeXQxmc01TRBBUdklnP/XnVzGVLGyUM+7GYs43PIKDRpmAsrl5VTX0sHV+PiOS5G869S9qu70wN9Crk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514578; c=relaxed/simple;
	bh=/9Yw9iGvyFY9bRDTyC55FojQXRM7DiFusStXOdf7Cc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvYurqsjWdKsZElkgve6Ej21dHNHJQAGlPQi+m3yq4T6mBtS2aDKZRtb06n7yERSRnH9OF2sK3u+jDih3Nuv7lzZc6dj0ecyrxdwbFi/dNleADp64AX4+wKZz7lv+/3NryKMrvVW2WbNQB1Gdf1MepfzG2BZiS4oAlAe0EmmfZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YO/gMRE0; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2702ed1054fso2241312fac.3
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514576; x=1725119376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWdUi5OOnBRIhs/jpEU9FWBcXjypJv8PV47JtyWLSQQ=;
        b=YO/gMRE0PEkpCcmTYMeI/b2btln5PZMsWVy1xj0RNj/TY4UAvVDDmqx5COZNhqMd28
         hnD5X5kJ6kYRSgh9ogEu7gJ9o0Qgwe9wowFeo1kT+0txTYco3P5GVX5EF/Vm/RYnn5yj
         mNmSielLxY7QaJCYWAxjVCvg2w+ebZ2yryGzjWl9ZgDAwD3Ntxyl9bnFxo2ek5xhaqyL
         VvYEc94r9/1LhJ4gsJ75CQxFDas94BXHxvZFpNcFmjAu0vz2iv9VF6URdCSe2fPTKwFe
         zSQRrKBvxB3yEthduiwCZ1PozhG0GE3tmnXQoCGlS7fgGfpfWZ7SgTpIePEEtC/Vi+u9
         VWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514576; x=1725119376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zWdUi5OOnBRIhs/jpEU9FWBcXjypJv8PV47JtyWLSQQ=;
        b=iFdii4fmxntLE8meaqmniFhdYb7vODX+WKL1BwZzf3iih7LLZbt6njmqzKUqNcPvZZ
         jTfbhOkjvOGb459Lo/6N8mrwTBPirPGfCfLdhc7P3m1lriMC3hjORsrlaVuJ4xAgSgnT
         f8bL3N3GU5h9FheZSJzPJ2lrVePwywKEWxafPfloiS57Ve0DITYMAkfSZM367rVlRaXM
         2u3bxTWjyxdRoSNE32CMtZ3N/7th51H/GT6twuGiy4RTnS5bB+gRVoXSH3nf17gu3mbM
         WvgTyHSjMD1Q6z0fUYfN8LdbDIMb5B44b7DzW9lWHSSLfHyR1EdmcA1jBSpjS20qqN0m
         uESQ==
X-Gm-Message-State: AOJu0YysyYu59HeHeiNioFumQoSVfkMbH2XzZfGMkr4pPW7ODzibFhO/
	b5JMfRDqBp0XBDGqvMzN07nYpQ90b0CkRMOPsPDfXZOrP+tHxMidEiycI7V7x10RgYkQOkwFRyk
	a
X-Google-Smtp-Source: AGHT+IGakDqD/DSRaqToHMr2O2NvTVGIiNHxaFlutp6+G2ECPxP5/B4DB8JWyHUL9yi+jKb4ma683A==
X-Received: by 2002:a05:6870:8a22:b0:261:679:d7f4 with SMTP id 586e51a60fabf-273e64d9712mr6579688fac.25.1724514576067;
        Sat, 24 Aug 2024 08:49:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e09c3sm4633925b3a.122.2024.08.24.08.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:49:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: pass in io_kiocb to io_bundle_nbufs()
Date: Sat, 24 Aug 2024 09:46:59 -0600
Message-ID: <20240824154924.110619-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824154924.110619-1-axboe@kernel.dk>
References: <20240824154924.110619-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for needing the io_kiocb in there, and kmsg can always
be gotten off that in the first place.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f10f5a22d66a..14dd60bed676 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -457,8 +457,9 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
  * data in the iter, then loop the segments to figure out how much we
  * transferred.
  */
-static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
+static int io_bundle_nbufs(struct io_kiocb *req, int ret)
 {
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct iovec *iov;
 	int nbufs;
 
@@ -501,7 +502,7 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(req, *ret), issue_flags);
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -842,7 +843,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
+		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(req, *ret),
 				      issue_flags);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
-- 
2.43.0


