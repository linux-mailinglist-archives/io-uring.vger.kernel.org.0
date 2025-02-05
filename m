Return-Path: <io-uring+bounces-6282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3016A29B29
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E85F37A1EF7
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B721FFC61;
	Wed,  5 Feb 2025 20:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n+r1szEk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303C01519AD
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787214; cv=none; b=trl0S6YUHhb9/DwHv65SShDjwXsLtr+ZsuldiJa47dQT+bwymJNqO5HeIPQwp4VxsO7WiQUoYL0z0nRHZ/Myh5z5hnEnG2OW81hymEYK3wdEUjFPwhgUIdO56hQtcH8TYrzC2V3ZhjGCnxTNHO8p6fu2j0V6/fKsmpkohHSpIzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787214; c=relaxed/simple;
	bh=JvgOl6fhWtHjM/9fdnV3rMW77gb/+BxjpwZhpMiIXNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifAy3RmZjugKrNmn83vIaBaXoJzwWCfCh9niZEWvJvJWzMm9fP81SpymQ+SNHbsLgrDdpiCM3JN9SAoTrSfiqMPXxn+F5o+ejjlvP8gYvvMHISEtuRAxCIDCbNTApU6WRlPi0Y3iQphQ9aTFUanhAQ80MdqW3zGV4mI9Iv809W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n+r1szEk; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d04e7f284aso575755ab.0
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787211; x=1739392011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1wpsdoKO+e203lnxZDiW2FYjIL66DuwOXiWNJha8FI=;
        b=n+r1szEkE6IO4sjUiL8l9TF9BqzllNobHTmS3Q9jUXHvIW9OONS0a/E4s/WUt5apHp
         JwqG1XjhHue4MaInYjRETvYfbJkXntRl8pBDHNIQcZrzTu6P4qN0VD0MjPzWUSP8qrA+
         TKaAbpRcMM9kla4oIvQZLDI3VufX1sejkl6I5sjyTi+cEQvYlJu8d2BHOcgvqB3pwzWP
         V7335VKwU6FO5zg0CIwTYmjcYorjYb/bBKLFyU0vlFYIswr2QadbbwzAD9DKcsc8WFr2
         1p6Rxpg2p17sj6tQvxgC8CW2aOXJaRLpd3EabUhqY8/cicsskTAMbmw59pH5mfLSgVtm
         jn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787211; x=1739392011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/1wpsdoKO+e203lnxZDiW2FYjIL66DuwOXiWNJha8FI=;
        b=KAgjgl6FYhCdYbe/8UwvarGwk8kRpfERSdB0RA8cpOByvBpVrAcxaRUhgsHvfcrv6g
         OhNB1ulcv/NoOIhpcp4KPguNEPjWfr7BlMYBD+sBQKUlt01vQIQ2q8EmW9hdeYcpXKJ7
         f5VE6N5gjCszIsR0HvNF7cDFT4YbQ6s0sC2fZjsHZPNCYZnvIYeBLQuR8V+kXNKtv18v
         OUC42HmQLWEpaucdqk7Jb0k9aXny/lAuSXvMeAUq0LXty8chmqlc94SLft/gA7XzRDk4
         BDWJC9N/SjXRDg8qA8TO3tFFyMsF+PUFVNbAH7dcP+UFEDO805b8aGPf6UZZvYDfIOPp
         XiVg==
X-Gm-Message-State: AOJu0YyzJT5k64vqx2SIqjZp9z1mzVlAGiTHcUzSi9PanhBxLi9u971v
	qRdyoLdPihRhVX+YywtPFCrrriFAA5XE/iFaslA0+VhfjRhCdbN39ePwNsBP19vC9oXnF/rxBfm
	5
X-Gm-Gg: ASbGncsgM+ycLh/8dXdTxZFGkKGElVLoydIUwCPEfsi7S9a0OEy6JxqCC1GJ0Ea4qVC
	TPpa++bFtzxrdX6xbfoaxlvBd+Y8PTgeoHlahSJlpiEHYtQimoRt3qowDGD0BpftO+xHlIkGRXP
	HIKxoq8H70Sx991AKUvHwgVRyYwBpkUrLWGm8icBUKIJ+2YqZ4pPDY38MV9FcAl9p32ZX20IwsA
	5kyK4dhDfoG5GEnWoz805mrjvj1Ft3JQQCQjr7wAuZjLCNa/98fsHFthSZnDKZ0pAV7QzLEhXYk
	Hz6maLIej645U9v75Jw=
X-Google-Smtp-Source: AGHT+IGSEfvT/OcL29G5bcrhzNEf/bzbVzKhqQMNEVccCa+byXLsFAwqexrHc5geqn3d/EVnivEaOg==
X-Received: by 2002:a05:6e02:2183:b0:3d0:1abc:fe03 with SMTP id e9e14a558f8ab-3d04f91b165mr37882505ab.15.1738787210693;
        Wed, 05 Feb 2025 12:26:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring/futex: use generic io_cancel_remove() helper
Date: Wed,  5 Feb 2025 13:26:12 -0700
Message-ID: <20250205202641.646812-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250205202641.646812-1-axboe@kernel.dk>
References: <20250205202641.646812-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't implement our own loop rolling and checking, just use the generic
helper to find and cancel requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 808eb57f1210..54b9760f2aa6 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -116,29 +116,7 @@ static bool __io_futex_cancel(struct io_kiocb *req)
 int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		    unsigned int issue_flags)
 {
-	struct hlist_node *tmp;
-	struct io_kiocb *req;
-	int nr = 0;
-
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
-		return -ENOENT;
-
-	io_ring_submit_lock(ctx, issue_flags);
-	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
-		if (req->cqe.user_data != cd->data &&
-		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
-			continue;
-		if (__io_futex_cancel(req))
-			nr++;
-		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
-			break;
-	}
-	io_ring_submit_unlock(ctx, issue_flags);
-
-	if (nr)
-		return nr;
-
-	return -ENOENT;
+	return io_cancel_remove(ctx, cd, issue_flags, &ctx->futex_list, __io_futex_cancel);
 }
 
 bool io_futex_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
-- 
2.47.2


