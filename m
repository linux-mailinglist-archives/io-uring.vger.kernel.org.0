Return-Path: <io-uring+bounces-172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 677917FFBB9
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C239528283E
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7217652F93;
	Thu, 30 Nov 2023 19:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XnXwgLPZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBA8D7F
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:43 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7b05e65e784so6243839f.1
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373602; x=1701978402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9hDKK//PcdFxhtS7/Qn7jAt09MAas7oaU4k4FD1Rqw=;
        b=XnXwgLPZvmIeKv2Y9jZtds8oYOniL/y4dXZrOBat7gqzpaT/wA3b9mK1k06+L/IsVW
         xmftrj7K1Xr7lkTuDA44QTNiBuSYA+L25pGFYt7KP7iwr6Nu0zz2Ey4gRl2THyW6k7ur
         LuUEaOEL3hrSPVsw/9raK9Jtv2r5NqkbrLgJDN+uKAOdy9G6hCdh+d0RnbpqbwR4FVeA
         xUBGfzZo/klUzWUylM+8LDesp1dhdYqGnKBgQXWRUMWtpHGJtGpQRLTSKS0XLStgYYVi
         T40L+ddaH9UDgzdKfqZb+gneehZui2HyeVcDkOARPjmkc1yFLecHXjGSayzBWubfEs7k
         B7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373602; x=1701978402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9hDKK//PcdFxhtS7/Qn7jAt09MAas7oaU4k4FD1Rqw=;
        b=SyPgs44+j12PbkqrJamEPSmO7hRGETODzf6Pc3F+rZxQIBXBpZ1Ibkd0/PM89zT8Ie
         QHmZmpOp9ER7XHAQjxVL4xKcWrgjJhi9QsZzbIzQYK+3edFeqhSlj5EScqPH12yiDlW9
         gOrFtEHWVMPPofro37cKPwY/FBcIDzLHviSRbP11yHom3O4i1WZM7eMpqx994NQifA4/
         Bo5ByYo12CjswSBOeC86Kl1+HGd4j3cRL56q9Lod6n8a+Q8VOCYRA5j1po4Ga0pv+Mzn
         uooZ2/73x+g6jff/qjhVMBFNj6fpG0VtkJ6k+xt7KCG2oKVbiABp6+nVSYud9dn7Rjsb
         FABQ==
X-Gm-Message-State: AOJu0Yyk7wypOTBSPlIiffN7kBu/3jJ2M5k9T2qhbp9Dq7KVKObFs1DW
	SGYC8UMDgWMx/BowdHVeNjZTMsZmYKZsNapvTZnwRQ==
X-Google-Smtp-Source: AGHT+IFJ6mHvElhGT5jPQ8JYEJZcf+L1A7r0mDrYJ68VOR4tM1Lj8OUi3k06cw9dAGnoUNZ86ahGUg==
X-Received: by 2002:a5e:9512:0:b0:7b0:75a7:6606 with SMTP id r18-20020a5e9512000000b007b075a76606mr22604509ioj.0.1701373602272;
        Thu, 30 Nov 2023 11:46:42 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 2/8] io_uring: don't guard IORING_OFF_PBUF_RING with SETUP_NO_MMAP
Date: Thu, 30 Nov 2023 12:45:48 -0700
Message-ID: <20231130194633.649319-3-axboe@kernel.dk>
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

This flag only applies to the SQ and CQ rings, it's perfectly valid
to use a mmap approach for the provided ring buffers. Move the
check into where it belongs.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b45abfd75415..52e4b14ad8aa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3478,16 +3478,18 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	struct page *page;
 	void *ptr;
 
-	/* Don't allow mmap if the ring was setup without it */
-	if (ctx->flags & IORING_SETUP_NO_MMAP)
-		return ERR_PTR(-EINVAL);
-
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
+		/* Don't allow mmap if the ring was setup without it */
+		if (ctx->flags & IORING_SETUP_NO_MMAP)
+			return ERR_PTR(-EINVAL);
 		ptr = ctx->rings;
 		break;
 	case IORING_OFF_SQES:
+		/* Don't allow mmap if the ring was setup without it */
+		if (ctx->flags & IORING_SETUP_NO_MMAP)
+			return ERR_PTR(-EINVAL);
 		ptr = ctx->sq_sqes;
 		break;
 	case IORING_OFF_PBUF_RING: {
-- 
2.42.0


