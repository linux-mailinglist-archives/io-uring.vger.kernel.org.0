Return-Path: <io-uring+bounces-3902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F85C9AA33C
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B66A1F22206
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4687E19CC08;
	Tue, 22 Oct 2024 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D4O/o1fq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D669E1E481
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604092; cv=none; b=b2GR6oSyt6kynKzo8YqMBk6Uz9Dd6hJ+JWge4ha3Fzi3CtcGIkPh2UlwVZcb6b8TDRgzgYdPSOjlCrHEeXcVVVkfsfSLINhwhNvOvVZ3n7vRz6T4jRZGMolyKxYj6uVa71r7XNGqjDCvPnRaxQQU+w2ggEQb0HIFbyxUmPEyz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604092; c=relaxed/simple;
	bh=Kz4vGkhsU14SInO/EThGe6nS05YsS+HhirZwa3uwYGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuIeIBH11N/fmhQ3jevr3ds5Jaz6hKphGUJ2q3fvEBPPvU4nkRIJw/rHUgTKIUb7LN2SKz+ZthOxUdm1KkHml+pC9b8JIimcshwvdMub8cBq7T6U3xWO3rd2jiVKNWVU0QuDRfN8lBapX63T3X67196TpdsQ3/a365hI5EiRQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=D4O/o1fq; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a3f82b2018so12826665ab.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729604087; x=1730208887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVEVwHtUh+ycaU7GqFc+/vwJ88P9ex7Or1DogMBql6s=;
        b=D4O/o1fqHOeXCV+1w9WDiCDaOd7KQKNSbWnF+1ul9tM4XNeLpDqzXAsdObRQ23mLea
         aoNw8lIiyQnriNW60hvYPs/pQqmh3gJZ7om6+IVEZwY+e3UZDQVtBKGOKsT3em/M+iin
         +PaEAGOkbwHJ8CoaPLyrCHiXzU+aG7kfdfj32UvCr92SUoYOJHVGJimh3qbPF1FYY8eJ
         62pV0rHnbm93twwRkpWbAs4iPblNKSsrY4xU+/WA++mHc08G970kUlfwoqb9i9jYkxkz
         rHZ1/5FF6Hilw++R/KxvbQ2U32X8L216fz6rL5TE05v9JROmIYhmcHZKjDm5NjOZXsnz
         SGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729604087; x=1730208887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVEVwHtUh+ycaU7GqFc+/vwJ88P9ex7Or1DogMBql6s=;
        b=SHCSZEoYaXX0WPZkRU3cj250iMA0pONSOQBWTXWFdfLvUcjPyZxiOXvb8DM9YXy8/D
         phzoBw6POeq+QRyhj8cmoemnZxJ8gMZrLu8bzO7xMp+2r10zw5m7JiUmQ9SDbF3kIp5c
         svuWm/r4pIoEFtf/AsorabwrBYBBgzQKlT8SegX1Mi5MmaaH+GxPTXSeL7V0NEgugX1x
         Q3ZzRrvvhWDiuMIE7jgtHiYsTQIs2Zn8O3YGFxsJ6jWkg8R/0j8NZwrWtHW3z0Itlmjk
         cdfaZDbciBdLnJvdcy/vgrNNf1bQZZ7cWFrQpAwghzbPn5ynKrhFo2paVFo5PqVH0aG5
         RpOw==
X-Gm-Message-State: AOJu0YzZibVIOakGlJ8Vm0ubdg4gJyTjiwv48U90s40mSVKaCjMPtK7h
	1DXbOyfJXOPXRebTipStO51cpMOLZ0shUqwViXSvJceGQwAIz3/Mr0I4OiIb3bhj0G2et+Q1ZCW
	E
X-Google-Smtp-Source: AGHT+IGDUxO24JoxuiT14jNyoUG9xxnOwGk/D/aTDEy8c9WcIPT+0UT4W7yPzAtCFv3kkfKrCjbKhA==
X-Received: by 2002:a05:6e02:16cf:b0:3a3:af94:461f with SMTP id e9e14a558f8ab-3a3f4050131mr145081265ab.1.1729604087464;
        Tue, 22 Oct 2024 06:34:47 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b7c76bsm18032385ab.72.2024.10.22.06.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 06:34:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
Date: Tue, 22 Oct 2024 07:32:55 -0600
Message-ID: <20241022133441.855081-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022133441.855081-1-axboe@kernel.dk>
References: <20241022133441.855081-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's pretty pointless to use io_kiocb as intermediate storage for this,
so split the validity check and the actual usage. The resource node is
assigned upfront at prep time, to prevent it from going away. The actual
import is never called with the ctx->uring_lock held, so grab it for
the import.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 39c3c816ec78..58d0b817d6ea 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -211,11 +211,15 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		struct io_ring_ctx *ctx = req->ctx;
 		u16 index;
 
-		req->buf_index = READ_ONCE(sqe->buf_index);
-		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+		index = READ_ONCE(sqe->buf_index);
+		if (unlikely(index >= ctx->nr_user_bufs))
 			return -EFAULT;
-		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-		req->imu = ctx->user_bufs[index];
+		req->buf_index = array_index_nospec(index, ctx->nr_user_bufs);
+		/*
+		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
+		 * being called. This prevents destruction of the mapped buffer
+		 * we'll need at actual import time.
+		 */
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
@@ -272,8 +276,17 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	/* Must have had rsrc_node assigned at prep time */
+	if (req->rsrc_node) {
+		struct io_mapped_ubuf *imu;
+
+		imu = READ_ONCE(ctx->user_bufs[req->buf_index]);
+		return io_import_fixed(rw, iter, imu, ubuf, len);
+	}
 
-	return io_import_fixed(rw, iter, req->imu, ubuf, len);
+	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
-- 
2.45.2


