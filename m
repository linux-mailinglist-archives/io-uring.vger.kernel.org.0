Return-Path: <io-uring+bounces-859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D2D875869
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 21:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2F7DB23638
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 20:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5526651BD;
	Thu,  7 Mar 2024 20:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ES9Lkqpe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9E96312F
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 20:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843484; cv=none; b=AgROkmHA0BdO5A/hq1ZVJZEC2Z+jiOocAJK9d6idGIMPOEnpZd56eb3pJ4J30M3zNSWw1xm8FjL4S5hf4YXfBNEBdytJq/1qarmBWX2FH2vBMrE+gfknybDppWA55UWQI/Nu+vqyKEvjBy43IbxNCGRim5FTY7EqJEaeq5BjbfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843484; c=relaxed/simple;
	bh=x62x4eLeT00le194Rzh+3OzyARrf7VSLrMQH0L+XvxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuwoP6oljOCgo50ZPXkqW5PnqH9Dji0AcfqGa1ePra1S7ZXW/Tzi4QeIs9ll9vTBtrRfdlJyFBgltaEViBo59ZlhMXotW7f968KGwbtKVigtgdOqctWrIKaNnNK9pM7FEZJxwlWiJMa6EN5k6m+kvzOUajfSDWuKzNoAgyi0Fn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ES9Lkqpe; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c495be1924so20176839f.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 12:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709843481; x=1710448281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y73OfLbNdbzIkG7Jv1Ebw5Y0V7KrlnEGSBYyOhB57Qk=;
        b=ES9LkqpeNhVM05PONoBMZUs7kEAaMWc8qZyioDLxWIUSUpSiORu2FtwOGMJaL6g1cx
         +qkbBK/pWSUtmwQxwIXsib92MOcK75tPLRqSpQ5XQ/+H9/l+beyuyUyy6I/EX8DKTjge
         Ca7ijxog+epoNZlxFSf+548mdZzk/51Qu6HnI8WeUvHCoPraRgSUOwhK1r0eEcXUDD4H
         Pg8XaYmrP+wwvbInnwpZvUR5sAOlTBSd6IcFt+6SWwNxwEZoRIo/DISkrQngCstSQPjg
         Kp5HZL/+q1L5mp8QvgaQaLFRTXuYi8jJm9tDzAz89OMpeqU7NCmahxDTo4x3SWqrb5qG
         iJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709843481; x=1710448281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y73OfLbNdbzIkG7Jv1Ebw5Y0V7KrlnEGSBYyOhB57Qk=;
        b=us7+7DNCyXdC7PUIPvbtjivk9vy3UrhyF718yMzQQ4JwBkQAvHeNPEyfeOFxfpVaMz
         K8JNWyF8Xnwh1EETkmJ1TerjPibv3kI5QMpRMDiz085zOMQLi2rnx7sGGJAXT3FFxNq9
         oJMjBbpY2OP7LXXrQKnwH6ZHwYAdtapTdzfJV3c0MTgHZHRuCEVHgOJaGqVwiyRHZxXt
         Qm/IbCKOCdPN0wCV/BRO+h/7GZ/kyUj1lha4LeEm3zArNCKMTA/v2AfcwapdciXMiWSV
         ++HEpnW5CAq1Y5kHLaTeKEhEtA8C4IZsGxNJZtW5rJyMPXyCb8w90IaiJZhw/evAgB2R
         505A==
X-Gm-Message-State: AOJu0YymMfRGzOWHZUzyXEOwKMb8wHBHDQJFF8Hdig5xI7FkYbHR4GpL
	E9jDC0u1x5+mVF0yct8/pVbKNDd23RDQCTdLv0IYTOlVnKh8kdP0hOicJ0axYikcY3K4wubjHGw
	/
X-Google-Smtp-Source: AGHT+IHDev+cvBNNO7tS1/RXggpurV8R27G07Fc9HCN4EPQwop1dym7u8kxnIXFMzV3VKQFveBP/Lg==
X-Received: by 2002:a5d:974e:0:b0:7c8:6f1f:d44 with SMTP id c14-20020a5d974e000000b007c86f1f0d44mr3352981ioo.1.1709843481107;
        Thu, 07 Mar 2024 12:31:21 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a028481000000b0047469b04c35sm4198921jai.65.2024.03.07.12.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 12:31:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/net: simplify msghd->msg_inq checking
Date: Thu,  7 Mar 2024 13:30:26 -0700
Message-ID: <20240307203113.575893-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307203113.575893-1-axboe@kernel.dk>
References: <20240307203113.575893-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just check for larger than zero rather than check for non-zero and
not -1. This is easier to read, and also protects against any errants
< 0 values that aren't -1.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f8495f6a0bda..e24baf765c0e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -697,7 +697,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg->msg_inq && msg->msg_inq != -1)
+	if (msg->msg_inq > 0)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
@@ -720,7 +720,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		io_recv_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
 				return false;
 			/* mshot retries exceeded, force a requeue */
-- 
2.43.0


