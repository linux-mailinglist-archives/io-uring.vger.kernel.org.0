Return-Path: <io-uring+bounces-2689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 069CC94DF77
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 03:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B311A281A14
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 01:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4053A79F3;
	Sun, 11 Aug 2024 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p4lAqIih"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BC5234
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 01:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723340048; cv=none; b=nZMsvrfoLKx05jMT8+KkDg1XeC3vrFLz3toZr1mqVTE+Xww3K8ezj3amzDvJRDjAvJjqdr/h2a2jm0S2v8vZYR1PK1lsMVxknxoeE4G4a6EaOOpVLQmbt3eri1zinJLXsWucaKWpdXWrmloJFYDly6HsBhck5t9aPBsHFPhHg1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723340048; c=relaxed/simple;
	bh=BN5E0VGWfhOWrrqKFTqAfeHDXiSHJ6aKYoU0MkIntdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8E5wANCLf/YrM8J7qrmdChcfd+lFEuiQhkINdbg/V9WsiRoIXyYp/1UhaUErqpRH3rW1UFHIW2FOPoFfcooGDKyTvvhofINfXCue4m3kpJKKhWtmthDDgOt5JAjZFJejw6S2tOU7JUIL0CX8i8H4jd9zGnPJBwjukbuQYj1uvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p4lAqIih; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2d21a652107so60852a91.1
        for <io-uring@vger.kernel.org>; Sat, 10 Aug 2024 18:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723340043; x=1723944843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4/WOdJEAthGUHs9CVmua1xhvwSbejian67Yt3Lg4hY=;
        b=p4lAqIih1jIGSiRjMwgq3NHZs6RphianZIZ26QAOmuTqip6N9XRV00keILrSPbqDws
         NnnQmmCzaRdko8zlHacTFVG0BjYvtqc1xXaf51uR4x0qme8vz5wDYyUTCH1UuihsSIq4
         FeRay8mL0WICyTlu0j/JcSdY08Gm3OPfghaC8ZSYFz9+FudRZGvq65nWGA1z0TVHgBJA
         +3Y/o8R/vEwGBvBORePLHve7JN8oYqo2jclRyYk5Z1d4JSBVB0BWOPyhvZQ+n8BtpgoW
         7b/4UdQnlbyo10+hK31Crl5P33WGK/ixM1iqqznSZNmHebnvmDzjT4oWmfeE3x80QvZw
         wGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723340043; x=1723944843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4/WOdJEAthGUHs9CVmua1xhvwSbejian67Yt3Lg4hY=;
        b=pWqpuJVeRKQmLWauZoASItIJdLEAy9xkw4Wpt0VBJFm0Gyk9eazCRoKo4F0CGs9Na+
         zGFPQCem0tKZFVSTOQFuMHrQp/HWWhEAErQTBB0C6EvQnoZD2EvJfSePF/UDvXYwtBCT
         BuQAx7GfhKbbXcPYqJPhZEv2QM8fpJ4HECGt4uEW8AuYtXvEZVq01/lEhmc6ysQ669wE
         bOCQFhboLyBNFbLLkfVExjV0VIA0uWPrUCIS/oUUH76tXlfzqc5qb9wZm6g/VSMpYi32
         ZrRyDbiMNCimUvxCu2EgLgk3YZv3colrPLp166qxFnzNNk49ZiJpMb+lECU/8zSSH1ec
         hM0g==
X-Gm-Message-State: AOJu0YwMRU9P5sQu5Hu53gkk8x+2SXXRBBsDwbejP8KDiki1djIWz24U
	XpJ6B94NrHQLO83fPugetauooEJgzksx/FcAhbcpMVqYH7P5D7F6FqTV3CUeFNhTWlVfI6eKf9p
	T
X-Google-Smtp-Source: AGHT+IFUkcHmP62l875SE2FsCcOZEtFDRURCRT39v403vtX56vWLwCpwN10H+HLhaLXPxXAPzTDH2g==
X-Received: by 2002:a05:6a20:394b:b0:1c4:d11d:4916 with SMTP id adf61e73a8af0-1c89ff29d63mr5424040637.7.1723340043404;
        Sat, 10 Aug 2024 18:34:03 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c3dbea4389sm1852477a12.84.2024.08.10.18.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 18:34:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/kbuf: use 'bl' directly rather than req->buf_list
Date: Sat, 10 Aug 2024 19:32:58 -0600
Message-ID: <20240811013359.7112-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240811013359.7112-1-axboe@kernel.dk>
References: <20240811013359.7112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

req->buf_list is assigned higher up and is safe to use as we remain
within a locked region, as is the 'bl' variable itself from which it
was assigned. To improve readability, use 'bl' directly rather than
get it from the io_kiocb, if we need to increment the head directly
in the buffer selection path. This makes it readily apparent that
it's the same io_buffer_list being used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c95dc1736dd9..c75b22d246ec 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -295,7 +295,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 */
 		if (ret > 0) {
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			req->buf_list->head += ret;
+			bl->head += ret;
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
-- 
2.43.0


