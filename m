Return-Path: <io-uring+bounces-2712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6794094F57F
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 19:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2336F2852CA
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 17:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5973E18455A;
	Mon, 12 Aug 2024 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dbdIElAb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD8017C21B
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482058; cv=none; b=psD18EjJjqPQKLcYTduOn6c9NUtjlsDTJ5N3VKcCFWtGtU4lpcKlBGHjsQO9IhOEA7SMAFM+y4iCSktHg6wNHQefVEwHw9iCmIizGkbrkN8w6iujT1Znvle0LJ4qHoqP5q3/oTFu2pCROW4bDiwQugh8EvMLXhRG06UYaBgYBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482058; c=relaxed/simple;
	bh=LbQqkw7YZP8zPiB3vP6jCdtVMBrcnWjSI4UjUVwzchQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAIjBispK48ITm+aF/JQS1zCmws4dcRpdDfRgZdOWWntrXLBpgRYad6SRfz5y9QU7sJoXXKgd5PcxD3XssxxjFyFuCVvj9AnN8htPrv1K8P2RyySnyk/RPMgtTDAx/hpnsg4YuSGo1Lpuiv+V4mekq3oZ0/DUTW+jPLj5mmsy/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dbdIElAb; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2cb80633dcfso856614a91.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 10:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723482055; x=1724086855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+k0CzKlomibFd620tzLnsekibzHi84Tk+Peag9/NfCM=;
        b=dbdIElAbic66FrQjRpHo9stjHgdiz38HkzyWy5/WH0j0gzenXJjCw9FRlJ6g5OnSpq
         KmAQglT7aqe0GwTdcXok5pWOsCU5MWZLnw8zvAvRLqPn0kK1/q9wWE6pP8gVwv94Rxna
         HRoGuwk5kgeL5hAB4i0txl0YOIQorMOLF7WILPxCb1at0n5dzqir6OJP8pK5809MPuzY
         bJ7dtRYGcmS6R0OlFHPIdV+fzZ5DatygsSOYR8p/J0aOuSJNMRSAZFdecbQyKpsUB+lp
         B8EzA+WgAeJJlNOIZq4wPCVMnk4dQ2pABiicP0aQI4lmtYNJd2tttLzqPKCkRy+cpcWS
         O3gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482055; x=1724086855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+k0CzKlomibFd620tzLnsekibzHi84Tk+Peag9/NfCM=;
        b=tWrBHGAM1jCTv2FXMzhnnhXQnKSKmHry97bSWkuCcvJ/utzqRqlwMBIgvfJkasJ7HX
         fKRkbGQ3KP3Pq22s59KfFQMNJCyTNSALARMk2Razcl9ddE9FvOjSfRIENgAYKGaRCgv5
         aFmPd0CtE8Crhg+uZ0Hbn+o/EsXqxGLAj2RUX7vHVmKl/pRxhYgD4i+backa9qTSKkzr
         RLGhL37r8LOILU9pkq6C4dVDndHBs9SsERaeP1D6pHOObsmzVncOvLrf2m0MqJp1QPbF
         1pPxm6Rw1ZTrCtvtkEpCJwFLE9Lkt1iPOhNioE0nmnFYZasGhcQ1AXW73w2RTz4mEN+M
         F4og==
X-Gm-Message-State: AOJu0YxmWVprkJR0aWAJBh3NHOdLDEI+fxu1Wv6PUZNVD+05LmTNBJOq
	L8MpR09FGVqq3mBthPKbjU87rcTSjsy2DIoePb/oW/n1b9COSZKxTa37A+bxM6X1wFWmP88VOKC
	l
X-Google-Smtp-Source: AGHT+IGZ3MnUtHMXCuEWLVAE2vRG7Kow9Jdh4LkXDlRDJOa8q6+8gnVPt5XhMVLK4eftXigy5itMuA==
X-Received: by 2002:a17:902:d4cc:b0:1fd:a7b8:edaf with SMTP id d9443c01a7336-201ca1da02cmr6110495ad.8.1723482055094;
        Mon, 12 Aug 2024 10:00:55 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9feaa4sm40212725ad.213.2024.08.12.10.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 10:00:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/net: pass in io_kiocb to io_bundle_nbufs()
Date: Mon, 12 Aug 2024 10:55:25 -0600
Message-ID: <20240812170044.93133-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812170044.93133-1-axboe@kernel.dk>
References: <20240812170044.93133-1-axboe@kernel.dk>
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
index e312fc1ed7de..a6268e62b348 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -459,8 +459,9 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
  * data in the iter, then loop the segments to figure out how much we
  * transferred.
  */
-static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
+static int io_bundle_nbufs(struct io_kiocb *req, int ret)
 {
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct iovec *iov;
 	int nbufs;
 
@@ -503,7 +504,7 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(req, *ret), issue_flags);
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -844,7 +845,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
+		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(req, *ret),
 				      issue_flags);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
-- 
2.43.0


