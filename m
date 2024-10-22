Return-Path: <io-uring+bounces-3903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE129AA33D
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 627841F230D6
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400CB1E481;
	Tue, 22 Oct 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Or+ZHDR8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351298063C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604093; cv=none; b=OtaxM2JznHzPXorAiPj7t0BSXedC6EPPHB8JTDUVrKbZkGQiasJ664UfpF8vniqje4utO+HVMHB2hIR/iKSM9lkrHG6O/xLhlomTzhdVS+WAtev9D0tDWRHMLwg9yRS4+gINSj6nrMylJo90d5Ws+FQvM4zLuyGfZtuzheqNvDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604093; c=relaxed/simple;
	bh=oDiF+iJtDAqOQFD3zFbOwHq1eNByLNSUH9pNke+Mbqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzl5GRtX2bkcyi+QLZbxaNTsrF2dHMdc+YqW21073iUY046mYagXfsig9gfKtZa0lumZo0UbDbvkvjUf0S1tNe5jX3va3/6GQqjMVjtODHZP5mUF4haLBs1HkFczBYIIGUZ/rEfcvx+OkGPxWMSvaFvLK8IO6snCfozoQL3M73A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Or+ZHDR8; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a3aeb19ea2so20496275ab.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729604089; x=1730208889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7q/V2BhkWsb+BFpGXBB0cov0CmL9fUYlsdRBSuHeDA=;
        b=Or+ZHDR8QKtT5XwcAb6/unOnTn/pXh74PmAaVBGUrDiLawSBJUuN/F6nccUr0auhEX
         g+hPq//EA8qgMYRj96wpx1/RdY0YWZtkWgrRSZrkUBE2+FCvgRvQ7spome8idgvOTr0N
         LeT/jHenf+LB2i8sLmp1mh3Fo2VK5K3yakmnNqwDuVEmzfp2KvWkCLAK6DcLD6wrctaj
         CGUzbk1wiod45HcmwA+JVpReVH2HF0k3mSGsegB020jIT+u+jVvMo1L/0ufW9G1aIgZx
         V35qaoAkw3DS05I7T9ErOWh2ama8hRIAfPQk0YzI2m95PHT593Ua8Neewu1/7kOTHT47
         d6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729604089; x=1730208889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7q/V2BhkWsb+BFpGXBB0cov0CmL9fUYlsdRBSuHeDA=;
        b=gTl4VhQAFAzfTjwgpWHtU4dH0MKPf0IXXnUqKSRzmeSLYQBxHd5sIwEdCbyHHhfbPJ
         tJdARBVSXuAE2z1ryfp/SSX98X61RRJ/TrZft4rpu7uBn21JwLr7n5p44fjFtLoIMxv8
         NSXBFfNRkeJ/7gjp9wHWUTOXdnDVd8g+1pbTQtgK5dsQe1peVTioQogU+33Xdu6uXtgf
         2+EH0qD75tz9y6RhB3heZ8oUzoLZNrLba7q+FaLnsHljcZDutAdDpiDy9PpWsfSDiefX
         JK4Cm5CzJfp5bR1WkLRq02s9tnazVAn1ex4uO1J6lZUjoqdPSSandqe8OkjG3W6O2q8e
         nazA==
X-Gm-Message-State: AOJu0YzyL9Ys2uKJn92jxtyPZIeTJNcVOuONBj4pGh8i2tKg9lXdAhet
	Q56piIWk1sByiR02nEb1ZmW8I4q65keG6w/zneLzMGBVWUTAwySHD5P2dx4LGk6hDsuA1xgpANh
	z
X-Google-Smtp-Source: AGHT+IFVXuej426JlMC2c7o9inbu+wH3hO+G59DaWZjOyU5Dp2D6pDT8083BLqOaEfAyHWOW/i9jVw==
X-Received: by 2002:a05:6e02:1fc7:b0:3a0:9244:191d with SMTP id e9e14a558f8ab-3a3f40ab47cmr136132985ab.16.1729604089558;
        Tue, 22 Oct 2024 06:34:49 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b7c76bsm18032385ab.72.2024.10.22.06.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 06:34:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/rw: get rid of using req->imu
Date: Tue, 22 Oct 2024 07:32:56 -0600
Message-ID: <20241022133441.855081-3-axboe@kernel.dk>
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


