Return-Path: <io-uring+bounces-8229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 463B0ACF47C
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 18:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 020EC189C8EC
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 16:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00041E0B66;
	Thu,  5 Jun 2025 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rn0zxGWX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF267DA9C
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141395; cv=none; b=bqnhuE+GPheN9WSPQcohYexD4Vo5NHt21wl96pmpGCskQ61wQNsZwmQ1czT5EN2NLwgQMjiS99hS9TEzqCWmOjx1VqwzJNVzEyW0gz5UA0AV7xSc4XI0Lxsl7nwwDrD5B5HiLlm4FuCQ211O9hoOUppeZNaltXgCDpUFbgFi+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141395; c=relaxed/simple;
	bh=nij8009+aH92YVWZ4VEdZHbO2xiEnWHsL18ntdrqaV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGa0C2tRonlFbSQa9TOoHzqn8x3y48Xoh+s97sVA/G/r4UOFioEZFJuQAuWxihFoFFlta8tn0BCV4aIfzPYOH4lDlfCn5Fm485/6hmYAQqnDXnOFrAUfLbFGpVeHqCv7hg7W6YFjU96W0TxvWhCTrlklwgPc81IbIQw0a4LHvv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rn0zxGWX; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d817bc6eb0so5682345ab.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 09:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749141391; x=1749746191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=so+ZsnOqqQRoGCtlXDVO6FDwAe8kk6OopdWs6cTWQig=;
        b=rn0zxGWXGctyvYZueJv3QXr0L+Suh5au0TkFP7zRGAUVqwl4LCgIp0n+eWUUWN5KcU
         CpyNQ/Pn1+/qWmdAXW/l2pk3Ygd3nPrvT/i0uGFa23QebCx6qcMfKGMDrGLHDbeCyqK7
         nwxJ/v8DGBJy97RsQIihlYTHWOggTRcfKc7DW7Pv7olGUFXL7j4Nycmn36DPzHzxIPVQ
         0KMR1xL1oRRHKhh4fyUSHd9TwdCZHdFUMQiuNNUO5yzK3vKnj008WDJhCKxuDTZ87SCf
         auPsygWwyr3PQhGchI6pdCrho5dGRsG1401MFRc5LnMGkwl2M1n9kp8uv09QwHh5gAL/
         USdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749141391; x=1749746191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=so+ZsnOqqQRoGCtlXDVO6FDwAe8kk6OopdWs6cTWQig=;
        b=O4l67q6e7aIERMf8RRLrMAmoGi7tG1UlvQoCI4jqFTf6TpoHC9qH6Nq31XqICpsbDL
         nQ642Gr/YJJCrbTzRzNgKS+2tpK2dUItuh87w3b691A/aow4zptE25uxHaC1rgrX6N5/
         xXiyJjT0qTIpp0Nz441b9yB1Mq0zWhMrgWbmAEut6UeTHi3KsZ3qIihBz+wlAsqSQlh3
         CDR/4Kw8NNl8SZEGi6f3OSMf/0FEzU3tn9jcit/9p8BjXgZbHrgqT0mtw/YVxKFqo4SJ
         L5SMSzu9BJd25hu4Ut9rfCF5gxM1JSxe8M4Z+Yx5cb9RkohIWsxfVu3DUN36z91DuURC
         6iaQ==
X-Gm-Message-State: AOJu0YwfcHufPdJ9X3dsgOotzbZkkoTqQhsqXJZliCMLG8/Kv41i2g7Y
	bj46Yf5dPSj8qTGLqtOtXndCQ/UoHXFMRmsoW7zBRgVqVWvSgk/6RVsZwP09EqDatITF93NPcTI
	FWIUr
X-Gm-Gg: ASbGncvAobii/Ufrfq9vjGGXoxuWTmSl9gWhUmRvzL/DUXK+9Q/627Z3Spv0OlB7pXB
	z113MQB1ZtNsn5TBbD9JnWXq/EI+pftnaI5TEzM8sR249bS/2WmSAAZ55tN1PycJ/3xKdLZRFCE
	XKTeBKanLNn2yC8reXIrltPwCCKruqyaZwfxKCWvkPNgpdfZOP7/qBrGcIWuhrsXR+pfKgQhuqn
	d+Cq13tqcF2r8DbFkCSdPRfPxLykc/OmHK2pWPG1ot/v7S25Uj4o/Dl9Nx9P3UKpCY2S5/iLSQ0
	0FDO7TfJq5fLcVPRx2jMEOyG2aIK6x9UOIBnj8mYMHUHVFGddH8BbhBd3cMH9ZW2Ew==
X-Google-Smtp-Source: AGHT+IFw+joiD3AVTHSWE7EWcPAawpRbk38xsOgqgoynUlXuPtez4yufKrXVPYCdvHxd0m9NQLPXtw==
X-Received: by 2002:a05:6e02:2582:b0:3dd:b669:2c8a with SMTP id e9e14a558f8ab-3ddce40c836mr291725ab.11.1749141390824;
        Thu, 05 Jun 2025 09:36:30 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddbee31f15sm10849085ab.62.2025.06.05.09.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 09:36:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
Date: Thu,  5 Jun 2025 10:30:10 -0600
Message-ID: <20250605163626.97871-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605163626.97871-1-axboe@kernel.dk>
References: <20250605163626.97871-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a pretty pointless helper, just allocates and copies data. Fold it
into io_uring_cmd_prep().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 929cad6ee326..e204f4941d72 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -181,8 +181,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-static int io_uring_cmd_prep_setup(struct io_kiocb *req,
-				   const struct io_uring_sqe *sqe)
+int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_async_cmd *ac;
@@ -190,6 +189,18 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	/* see io_uring_cmd_get_async_data() */
 	BUILD_BUG_ON(offsetof(struct io_async_cmd, data) != 0);
 
+	if (sqe->__pad1)
+		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
+		return -EINVAL;
+
+	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+		req->buf_index = READ_ONCE(sqe->buf_index);
+
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+
 	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
 	if (!ac)
 		return -ENOMEM;
@@ -207,25 +218,6 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	return 0;
 }
 
-int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-
-	if (sqe->__pad1)
-		return -EINVAL;
-
-	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
-		return -EINVAL;
-
-	if (ioucmd->flags & IORING_URING_CMD_FIXED)
-		req->buf_index = READ_ONCE(sqe->buf_index);
-
-	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
-
-	return io_uring_cmd_prep_setup(req, sqe);
-}
-
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.49.0


