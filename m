Return-Path: <io-uring+bounces-3878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5B39A95EF
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58C5D281237
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8690C1E51D;
	Tue, 22 Oct 2024 02:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kh1i2NA6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEA25B216
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562676; cv=none; b=k+Ro3Gu+lGImToOrku9Gzvu7OKS0CAmRBYs575DpDHgNL+IWmsTAah/Q2l7XdDXdqZWOMqqVNSiMHdM/jevORDNcFSoL2i8JRvwbkY+ZJ/vzFxpc0oqKBcisWTBIswMZdQ9FiwH7+h4qpR3bvNYXftAo7YAI/q+JSQnyqo0rF8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562676; c=relaxed/simple;
	bh=4cN3rSInxG031End0lb1dpyjNWiWykCGbxZ8WyXkePY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIPbRO1hSgN+VJ7zqqFi4nRbQhNsJZiFmM5Y9B+VljLFGKuvzYNJCfsKSO4aZixrmnqkjG3ZmOuwQTI7FRpV+lqfx6HaQiop6HrRH3wkX/zYxUt9yTXe/2pbFYKlIq445+Xmaqn+0CsqrkcpbgkUjTmfFLLcwIOQO3b4AKpNhYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kh1i2NA6; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-277e6002b7dso1842024fac.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729562672; x=1730167472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paxlLTuk+IUBQ5sAmbInMRBMpA5dgQe7Mulbt/p9r7s=;
        b=kh1i2NA6DgUtNss5dlsEyQjRzUevk5ZjFoUq62EnEtBZ14gb9UgfzjbCx6NH907qaq
         I5RPhyyqPzxO3FA7EagV3ymeJv8TCqwp9EcQq7R+O03m/PKmRBL74+E7Wks+bocWJmLv
         a0FfKAvI/FWv/5l64h2bUbWffzzK9Lsbgu4zs7nsdcdk6ZyoFnfY3GUnE5daEmtdBAQ/
         Gc8n4tGtIFaBvmy7mAn+l+JNRnkNltrvb8czwXqcdaOXLoofZ1xZsR+QbB5xkDb/C5DI
         V7rM9knpZ+3NeyBJMJpVbZZrI3EHsKpQVW57SLOlKmg4YzzPyLueki5PYvU/n0rZDizU
         WMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729562672; x=1730167472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=paxlLTuk+IUBQ5sAmbInMRBMpA5dgQe7Mulbt/p9r7s=;
        b=IlDeeEwpVhK4NwRQ9wAsSMYjXo/rk/66XXCU5WJYWJOrmINYvl6hqr73CbeOZrLRD8
         0SbED3sn0PjS8iz8A0QxCMYkDejbZ19enxLXgbJLFNVS9z475HDBbe3MwTiVBb6FjUDY
         NdPX+hU69Yr8x4A711XnhPoVSIrQK4GtTxdJAVO+xYyJNy5hKR4rWpi04qR65+9ELg33
         5iWBzfDspl56O01xG3yIvfXspkAUis3lcr2SM+0gJ17rwjPqF2iZL5MLHW1QwImvKFGJ
         XAnryT2tC2cnOgTS5UzyXhngL5lgqN4LX28Mx1baOLoEjBuCKzzRfmNFV74A853rXwe4
         z9+Q==
X-Gm-Message-State: AOJu0Yyq8p61XbXgkwGj3g6t4rx6OL6pRRIjQrWX6EFtfpAKQhsJ1GZw
	5UtQfwnRWD8BrEOaT1nEdQfyQzoWdlFh5CNn3BvwS4ItuuRe5lc7vmY8noeO57jvUdztc3A3jV3
	i
X-Google-Smtp-Source: AGHT+IFrfVOf1mgXjFmYLeULKBZNwks1gn2Rx5SpykJXksQnWZLFSkGZOQ+tyx+id5PnazOF1y4F/g==
X-Received: by 2002:a05:6870:80c8:b0:270:1352:6c10 with SMTP id 586e51a60fabf-2892c5435d9mr11547675fac.37.1729562671796;
        Mon, 21 Oct 2024 19:04:31 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab58820sm3845534a12.52.2024.10.21.19.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:04:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
Date: Mon, 21 Oct 2024 20:03:20 -0600
Message-ID: <20241022020426.819298-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022020426.819298-1-axboe@kernel.dk>
References: <20241022020426.819298-1-axboe@kernel.dk>
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
 io_uring/uring_cmd.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 39c3c816ec78..313e2a389174 100644
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
@@ -272,8 +276,16 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
+	int ret;
 
-	return io_import_fixed(rw, iter, req->imu, ubuf, len);
+	mutex_lock(&ctx->uring_lock);
+	imu = ctx->user_bufs[req->buf_index];
+	ret = io_import_fixed(rw, iter, imu, ubuf, len);
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
-- 
2.45.2


