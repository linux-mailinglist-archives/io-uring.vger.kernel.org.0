Return-Path: <io-uring+bounces-8272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F5FAD09CA
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E457172B0C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD032236A79;
	Fri,  6 Jun 2025 21:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ENwfstpi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838C6238C34
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247003; cv=none; b=kePEmPw+spYu4Cw4bpiw+og/UygIRORPqrtDI1P6cy2zLaPVCpOYgUAS8eeh18HEBCr4bZ1MeSeLvV9yd1YExO3nrj4Eo3Oy86xNqIEpZxU8A8T0V8fl5Sm4HzvPdKdYdGuVyZomAmfXoWMZJzNJWrbQoM9z3ngi5ZEQPw86lMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247003; c=relaxed/simple;
	bh=eykJOwCmf629BIQ/wTR7Z98oQxPAg3d72K7L7afXSzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkbSlK4LhxrAFrRvhBff6WeJ0WBbXkinPiwPX23fViVlnFYREAPmvVoZgTZ1HNC9Lc25HfzpUcZGNVfAsYzQo1iGrRZDyBKbW2aOM4LfcV9c/QJ/Wz98w/oUcDC6SqBTGEY9rgB47fwQbgkSG517gtljWM1KUOGBgB02zev82is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ENwfstpi; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3da8e1259dfso20792945ab.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749247000; x=1749851800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cr5hq1BO1G/eHwQ8zSw4cGz1hwajioFjfnQ435r26Yk=;
        b=ENwfstpiVCzyy7Zs/CQ4gLozz6FWKWF9qX8T9BoBDHrePNXDC3qKg2puwfZeNtsLGD
         sz2+ibr4jWADDqwYedXKIpGTlbQBP79r6JqCEv9a7nGyI7pURp19Cvsf1vsnCPUwx9a9
         xnY4DFaoX9IAj95A4bA6qI9BId/BMUJLlnIZhiK4ZO2TL7HVuCMdYGnzaaRVD1mkdUK+
         CfLlWk1EMM6t5lBphLnHJsJneGqVCDY/G+wxAA38b+6/JuHrRu42STEE5+npS5IYmAxL
         nO3iOc6TFaxaxBxUWChBjv7bXQ98Rp7YIOpMA/ORNRAXoYS83FHkKPcpMrOAB38em0Tv
         Bxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749247000; x=1749851800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cr5hq1BO1G/eHwQ8zSw4cGz1hwajioFjfnQ435r26Yk=;
        b=bxzWYeeeSG7uU/+KBinlTSrXW2xWeBXuSPNfvDG/DEGZsdNUAPAuM1NMu3V7wlttg3
         QjSbN5PmXRsvsD0Q3/Zp3A575cJ5alnyPNdGx1PeUqPq1MJ5aqpRT+Q9KzUNm8EZHezE
         /GV9LmLDJQX1w09EEk+nL9Tnnk2uRN+tq8sRfQB521VygM4i69KXO2I9UiET/eLKmVA/
         6HjVEg+NMXc753PQJqQtZgUbtKYkVqt3vOCUB4Eqd0HLmmD20JXQNRB/xlwHer7L542Y
         WIgS5dcdcz/ovl3TlfJp6fskHllGkmPKugTMY6yZfB9tbmkcQ8D3I2+2N5FDVlfMmqsr
         K1tQ==
X-Gm-Message-State: AOJu0YyatoD6QhnyLy7RiHTrJnWrtjjHueZP+fyGb7JOYJIUpGnqIrwT
	CrBrze0/uxH33iGHZxcws1naRnFmqeRiq3WQ/PTKdpSepUObCgPuZ2Vf78bCBMppjUgQTVwDEkc
	nrtzm
X-Gm-Gg: ASbGncugTNuRr/yNlBtvyBFrnuA+hxlgLmPufuXJUdvNV+MiMPQg3Ztvh07LR0arPbQ
	dHkkD4E66J0JUgAofWjmyEg/ND1IZx4l0FtIP6Vml/rzVqcQrr2JJCLTtRQnfaceKdjGAz6SXGb
	gWfjyLVIaihg/JkJ9HNOOZK2fSQwG6JrCa27hob3zr3GhYOfzDMLnA6kwdnbysEBp5tWL5TCNlB
	1ovjCzsU5N8yPf1B8JuBu5J7hTJXAL+SaXbdHkKIKL5Yw3d8dqtSz7FSYXd6bl58+bVTjhcAdMq
	8NdoVMscivZZS345uePNvbKypxPdQSMwh5aEjRcvwUa5C/KU+0srBuD4
X-Google-Smtp-Source: AGHT+IFjlcWjUZjW1mKp0jEiBIebvXVBZdaALjCCS33HgLKqLnxq38fE5mgwhu2WSUOnPCb4eFZpEw==
X-Received: by 2002:a05:6e02:1fcd:b0:3dd:cbe9:8c06 with SMTP id e9e14a558f8ab-3ddce490f44mr65648375ab.22.1749247000278;
        Fri, 06 Jun 2025 14:56:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf1585bfsm5735105ab.30.2025.06.06.14.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 14:56:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
Date: Fri,  6 Jun 2025 15:54:28 -0600
Message-ID: <20250606215633.322075-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250606215633.322075-1-axboe@kernel.dk>
References: <20250606215633.322075-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a pretty pointless helper, just allocates and copies data. Fold it
into io_uring_cmd_prep().

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
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


