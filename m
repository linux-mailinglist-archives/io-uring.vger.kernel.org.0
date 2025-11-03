Return-Path: <io-uring+bounces-10335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 98391C2DBDF
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E82524F0052
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D483132143F;
	Mon,  3 Nov 2025 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FjluXrCo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385E8313E0F
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195790; cv=none; b=q41aWWTwmvMPVEGvlrHltibBM4kVAuoWE1lQC08I+7gac6O7+S2c1ebouDYnwmVhFwRpAksF96xSqX+JGlZoR878LRdT1pbztDEPa/N3d0iiqdtantpDfAF+mhVztyV3+S+zSBDIGBFVbEVkfWL+rTeIlhp1TxbqkVb22EofI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195790; c=relaxed/simple;
	bh=7yryRVCNqA0boqFiBC3bfNE6l1YGZzG0xtYCHtZWHmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhZRUjnUQCM6gv3XgTtUayLdufOTY/IDcSm8CIk0oxuyjKmVTocDc1FG+mgU8lFOsVxumG8u0nLzZOdMhXmxvYUWOuWYNbBDpcUR4TDFs/tXlMlk8+7RfZFTUU3yEEun1w9UPnqvnCjg1+T/jVxPDeCsX7cePD45tzDC0+K7CBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FjluXrCo; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-943b8b69734so471464739f.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195788; x=1762800588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V70QoS7q3d+HFMAoREu3S7SpBnrjqstdUcUXxZVlzeI=;
        b=FjluXrCo/B5vqnR6CF7RxOzMMQQun17wzIMgaIblPmdrCc8FZxokWOxmMZgXjJHgaV
         11YFTZAPZgPmmlqMW7POLT6bppmjF7517LOdMp5P6Cu5ncvPdfOC0uo/IBDUqPLTPAnF
         TSnUMdnLJKCQ+Gm0yT5PpAxBjkaViAqgn7WYRjEcQIpDHgHZ6cnny69UO2ELqsrGWf4Y
         YWtWnWeS6tg522t0Ayq1wTLCTbBN1ZT1yeyI1XKgq6cglTWdzh/KDXJn2IryFKlu4LJ7
         w8G2V1yMaEunGkus7OaO/MH3yn3OvATRZ2lVUlPDa3/W7bgnheN3UMoGbHTeH891G+zX
         uV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195788; x=1762800588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V70QoS7q3d+HFMAoREu3S7SpBnrjqstdUcUXxZVlzeI=;
        b=rq2tpFdLCi9baYMvsCUcQxoSDOGm4baQHxfEehxxpnlZYuftdkg6XnDBfZxG4bIjwI
         HdLozXigPCvoWffLA/40l3d94hUhflO1BXTmGCq3uD0LZn12cVPAIPWIj7ZEOT732z4U
         9eKgs4aqUqTfiO+FWCupSQctHk0Jgz+IdSBGYCE3F0Vftgsu7iDYsH5fd2j9ZKFx8/YK
         D2rHuV7+LC6smUpjzfCdT2sGaEimBne/PlgAf7bEgsioOj683NNdUEnrmRM2CuDNhz2i
         4X1XTS0PLmKDFHs4fXem38Ovxgtv5gFOkNmj1fMxyDBUwumNICWM5ud1tEpFv3Nr1An/
         r1UQ==
X-Gm-Message-State: AOJu0YwoRur2aoT6KIlKGb02sMRQX8LWlAevK3hQUoNGQ/Xeo8Ntfb1m
	5AflPZBH4wcBFcQqHzXaX69uFBZtp9QvVmZDSY37E3KOBLND6Ku5V1PhX1FTzB1WpXLj6yMHElX
	aaOwy
X-Gm-Gg: ASbGncvUeZREipRSOWhqkkP/KO4yXttpdvrzGvFgRwVCMaltm7MzhKyLDgpGkeiiyJu
	zMtyeWFR6NdGhF0STpbwMUzkILr0tEm7+R3U0H/XQ2MkDbFZoovehGqE0Ld+mTLPMsIaecSC3nG
	ceOMYJp8h2KmPzssc2mQRyr2jgFoPCRvuUnTs2Z9KjgbARoYz4ptEskmbl4fhgn15X7i7Q1h8af
	B/ojIB0P02leJo0OFEdAxNllqUuAwZlEkvPJNvX8OqfHSBdmPJmWhZV4P8pcYRM3GNig5pxhxHg
	KQo2BwKkJvTAR5SBrdBrZ0/Dn88epnVIZ1OL3jRUk8vNxnEd5By1lvk07s2M80Z3NIs2oYdNwLr
	G0688gnlKijqDmrkxhro6r+osfRZEymNF91eY/O2EwbngWiMVDU/vJS8z68I=
X-Google-Smtp-Source: AGHT+IEcoekhibj3itRU6Hvv4ugM5cPvY2ESjWpj7iUth4bLRZQEueTuccJJXtHj7w0hiefZ3Wme2Q==
X-Received: by 2002:a05:6e02:1a0f:b0:433:2b18:e9d with SMTP id e9e14a558f8ab-4332b180fdbmr62092785ab.20.1762195787944;
        Mon, 03 Nov 2025 10:49:47 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/cancel: move __io_uring_cancel() into cancel.c
Date: Mon,  3 Nov 2025 11:48:03 -0700
Message-ID: <20251103184937.61634-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103184937.61634-1-axboe@kernel.dk>
References: <20251103184937.61634-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yet another function that should be in cancel.c, move it over.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c   | 6 ++++++
 io_uring/io_uring.c | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 2754ea80e288..3ba82a1bfe80 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -422,3 +422,9 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 	}
 	return matched;
 }
+
+void __io_uring_cancel(bool cancel_all)
+{
+	io_uring_unreg_ringfd();
+	io_uring_cancel_generic(cancel_all, NULL);
+}
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 75bd049a1efd..b3be305b99be 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3336,12 +3336,6 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	}
 }
 
-void __io_uring_cancel(bool cancel_all)
-{
-	io_uring_unreg_ringfd();
-	io_uring_cancel_generic(cancel_all, NULL);
-}
-
 static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 			const struct io_uring_getevents_arg __user *uarg)
 {
-- 
2.51.0


