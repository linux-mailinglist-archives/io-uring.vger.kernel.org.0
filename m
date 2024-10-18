Return-Path: <io-uring+bounces-3828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 568BD9A4608
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2985B22CDC
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F229A204093;
	Fri, 18 Oct 2024 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aymWDjLB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EDA20010F
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276797; cv=none; b=maf0BnHdhEuXidEPhLf6Mj69iAvA7zmCf1lCMc6K5W8q0CLzMLnMUSJB3jE8x6/qyXTiYMEtXO8uIagtpn/hKncBxIFFwD3gcOfNjN/efPuN5Uj5VvqqBKC6xLOwiHkT7OmeliPItq7zosTtLy2qomcmTIdgCx3HhmPdhHN7Hcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276797; c=relaxed/simple;
	bh=oDiF+iJtDAqOQFD3zFbOwHq1eNByLNSUH9pNke+Mbqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptsesDQqWc9UZjroMXqnKJATXTKXR5VittMk63RyAdchYot8w+WqnUyhKmUT0vhVdQ9Tc1G11iVnLIvZOes2fbLNgo9QhDerxqebwNDCcSi9ym5HnHe0LK/ot50Beo2vX6ICtuW27C+2JgJfWpQGHxAtNUnmcrXHco0UHNktsaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aymWDjLB; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83abcfb9f39so29311639f.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276795; x=1729881595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7q/V2BhkWsb+BFpGXBB0cov0CmL9fUYlsdRBSuHeDA=;
        b=aymWDjLBY9xbynZRL44UFHOivgzw/WcbA9KKxiVzt1qwf40lL5HMR1W2bXjNx4M75g
         cMyyCCJ5QfaPi+4eng9ksN0vzAY72jsrUbtrNqV6v1eX5dTjrnTL2GMROsmg7uORk04v
         UFjlYNqVDFOf8JFS/ZNfyfVktCEa0lbBzJT77jDtQXZpS7kBdvRfwSzGqrV6IYsL+2jc
         aV5OwD79wp9mdvpg4BnnI/A3EbKNBsgwUABLgWCfd0W99zTvR0dfcNia/ocY8EVsUej3
         epRPz5DZ0TcCkPCCn9o7zVxcqne8+jrswmYc4f+gHSl1/gGUtxmkTZRMaKD5nGw7LqPA
         1HTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276795; x=1729881595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7q/V2BhkWsb+BFpGXBB0cov0CmL9fUYlsdRBSuHeDA=;
        b=AQZQgFw4/7SVadV0fb/KCeqLWLpESintReiSP/Hx0EbkYNl7toV0IjhYMab7BcLc6Z
         T8nuEzGKcrt8oZakG9kmxpNp/N3SfbX3kk4on4lwliJaQiOO+5v3UGd0zhmR/Na3ZaPi
         fG86Gd6TAsEIgAAt1W7n1LXqMpUdjlr9RQSKXm+LAgXUm6OS9xtWsN+j9GWTU9cB893/
         L2Eg/qBLfPaf5ZZm1+lF9D8BHf0ZtLa4tSU1Heq8gkpqvJWa/FKoMw01YIwSyblFOE7C
         gsNiffFVNy0inWGY3RN4LfBzKi1HO02QMzaLNdKdN55h5lSO9AQwVa4JBMFmWNGv2LAo
         /J/Q==
X-Gm-Message-State: AOJu0Yyswul4NDo2pszW9MJlojy9G4p8ATDUs4QDGjdIzZjzimZOYb8s
	cnR7nEBpcEAFkav854oIQmAlhKPUyxxnVSjNsmIBo8rTc3/Lr63aK+Azu91f54XMl87A0kmq4mz
	t
X-Google-Smtp-Source: AGHT+IG1qDIBH5L8exVsDybEl+2Z2uvKYa/R1rK8kP9CHuO2B2iM7dZP2AffdUaieMvE8GZ+ClzMHA==
X-Received: by 2002:a05:6602:164c:b0:83a:b83a:bfa8 with SMTP id ca18e2360f4ac-83aba992f83mr211872739f.6.1729276794765;
        Fri, 18 Oct 2024 11:39:54 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10c2b424sm534387173.98.2024.10.18.11.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:39:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/rw: get rid of using req->imu
Date: Fri, 18 Oct 2024 12:38:24 -0600
Message-ID: <20241018183948.464779-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241018183948.464779-1-axboe@kernel.dk>
References: <20241018183948.464779-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's assigned in the same function that it's being used, get rid of
it. A local variable will do just fine.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 80ae3c2ebb70..c633365aa37d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -330,6 +330,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
 	struct io_async_rw *io;
 	u16 index;
 	int ret;
@@ -341,11 +342,11 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (unlikely(req->buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-	req->imu = ctx->user_bufs[index];
+	imu = ctx->user_bufs[index];
 	io_req_set_rsrc_node(req, ctx, 0);
 
 	io = req->async_data;
-	ret = io_import_fixed(ddir, &io->iter, req->imu, rw->addr, rw->len);
+	ret = io_import_fixed(ddir, &io->iter, imu, rw->addr, rw->len);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
-- 
2.45.2


