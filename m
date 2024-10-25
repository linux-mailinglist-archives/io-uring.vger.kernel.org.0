Return-Path: <io-uring+bounces-4032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4CA9B0504
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 435262841EB
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADA721219F;
	Fri, 25 Oct 2024 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zA3rAh99"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A694913B787
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865123; cv=none; b=O8ENN1HrIPImKcZYzNMm8JfB+spsid3TLcRKFwj0XTAreCGilCf8ecHN3u8YfjyGBnSBu6Rsxez1cJmR2/Z2d1Ho+fvijakA9YOBCDgPKmj9xV5XOjBb3ajuKhNxGZScWBkkMmTCmNEjz+XYiDuS2Nj08JTZUx6CKviSDcCJPmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865123; c=relaxed/simple;
	bh=Hc8LWFF+BnTAwlQsvqEqcz1icMxeGM4aq1XGEcW9+IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug62XbS3vrmKoJ9B+srKlVgZ3cuaZdlhEz8Txq9djSnuWIWFemxh3LU/bsNSdKSC74y2oFmAtUPyWawrPLP9MbgSotK7uVlic58GLb0btm7QsjHIbCcbl26wgat/MVeGB/ERft3BvLGV2JZyKaL9gOXGpMymM/2KSY5vuWBWKt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zA3rAh99; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83abcfb9f37so83165939f.1
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865120; x=1730469920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olc4hQqg9C/G+s6Y4gqlaKc2EU5xK/tf7mC8ufS+JaY=;
        b=zA3rAh99zW35dxOQsmYc5lHBhIg9Ko+9lAJuphhDKZfNk5NhWXTw8x7ObzEdLOX2sK
         FmIWyhj4nQWdZUmwlDElWUJ+W9z0bsV2hN7yOu2pesfsN7cdLAf8N69tNbcIKwGNgkIv
         61XiUdcZWKZos1x9S3comtsBmUmpLfpbECc9Ix9N+DSZ5EQ7Ft8eSAFr2ybnSPS8+dmv
         +05l/EEnbjIZOdiu1N2Qk9x2NCQ8dbrqgDInYa0RO4pgmOZSZULdIbdG/26rnV7XpNu2
         MIsssc1QOWzyS3W687avPSHF3ykwpFsbPEByi0p1tNY10qO1MhBxsXZDlH4zOBv5YcHA
         ij0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865120; x=1730469920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olc4hQqg9C/G+s6Y4gqlaKc2EU5xK/tf7mC8ufS+JaY=;
        b=qqfGQRlonsbQD7+okU3dobh3Um6YRD/42VjdeELiZ5TOQVJPJfKjL+L3VW0vPeL7ib
         P0XIwhQeRjDmjXBTLqGu42KQzZ7IwovArMQfk7B3DuLjkhxVeQdwfwzKk86zUSEIvBQr
         q9rNNj/XUiYGbLTZlTRboarRGDXcT+wzG1mddAEy5m5dQgN06aHcDmU8sTgcuhjYcBzq
         TxjPxWzp6BiYtRtwiwJHCKpveZteB71myFSRynGy6MsmY5i2G1kHuc+FWOqWfsglh6Q6
         acx1abqlmuq8hTrJ3BFp81f99AS2MrGZyZHvMdmn2Iioll+I8Ldz1MauAAw46RgtoIue
         1llQ==
X-Gm-Message-State: AOJu0YyW8iRnKj0SGLrpVMYbcRp1fJwgYPHJ9fGREhs0w/NK4kcsyb6o
	Z7l+7ujFrbt2qMw1K5dZi57QPlargjxgjivLszIh/VNmNGkzsw+EWCpAbr9G05j87ZCJu45rrvJ
	H
X-Google-Smtp-Source: AGHT+IGtfhoXPPmdjyahESwm10Aoeuc6+0QDfGGwWQfTZYiGr0QktQSjDEqyElMr5Oryk26OqXSXjw==
X-Received: by 2002:a05:6e02:58c:b0:3a4:e80c:ca3c with SMTP id e9e14a558f8ab-3a4e80ccd77mr13172045ab.5.1729865120208;
        Fri, 25 Oct 2024 07:05:20 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56641sm2924635ab.65.2024.10.25.07.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:05:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/memmap: explicitly return -EFAULT for mmap on NULL rings
Date: Fri, 25 Oct 2024 08:02:30 -0600
Message-ID: <20241025140502.167623-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025140502.167623-2-axboe@kernel.dk>
References: <20241025140502.167623-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The later mapping will actually check this too, but in terms of code
clarify, explicitly check for whether or not the rings and sqes are
valid during validation. That makes it explicit that if they are
non-NULL, they are valid and can get mapped.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/memmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index a0f32a255fd1..d614824e17bd 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -204,11 +204,15 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
+		if (!ctx->rings)
+			return ERR_PTR(-EFAULT);
 		return ctx->rings;
 	case IORING_OFF_SQES:
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
+		if (!ctx->sq_sqes)
+			return ERR_PTR(-EFAULT);
 		return ctx->sq_sqes;
 	case IORING_OFF_PBUF_RING: {
 		struct io_buffer_list *bl;
-- 
2.45.2


