Return-Path: <io-uring+bounces-497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8EC84145A
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 21:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B8AB2833D7
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 20:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA361E4B7;
	Mon, 29 Jan 2024 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g79Wba8k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6460241E9
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 20:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706560235; cv=none; b=J+OV3uG/Y8gITtx700Gnlwtd/ijuG+s0Cqu5dysdopZ1PZw8n6VHlUll7Tim7pe+gcAs20Mz1FpXaklv2jwvA/v02cS8Vnx5S05B1NCshaEfbLLqqf0pm+uLt1tzO1rEdJgsfCe3IfkiUSBfRiEMfib+LHby0xM7/ZgZruNUAqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706560235; c=relaxed/simple;
	bh=0+Rd3c+2VrjAHvhG2SXGTxJvV0LNchhXjiL1XoN1hYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwQJuveLzh0b8x0dPFom9NL6VrfBSdwsh/xvsHfTkJkGMC3aaNj0O8NGsdVK2gnD4cfreLGgoFTqDDbjrweHEcx/h6ZdhzSL5TevaBpR9Z0PAHOnSBbV1ZVPHybvEG6Rg6YEVJmIewZBh5ifK2eNCBvJLCLvfyQ5Js69wsgZRLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g79Wba8k; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7beeeb1ba87so49128939f.0
        for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 12:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706560232; x=1707165032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Uq6s8O+pYHZy+YqyeW9aGwqRrlELW919jI2ZvhUwBE=;
        b=g79Wba8krWHgWUkmqXySe4oo9o+vRUuaYWY/csaO3wprde+CEZL2+5Bl1evgNwFK9p
         P52vyeY5M2+ZlZTHM9Cm5AtOPL975xWNMSkzte3D1r39cfYJ/tVZTyOv+/3fI5B23ddQ
         4Hay+JenYL6EDG7DPJ3rMEoARuVbNKXgjzASoIsf0cJ+67O7Gqy4J7aB00SBxJJ29ZgY
         Z7CN/RV8qw72VySOm83DwkWLGnB0GjTOKANzV6+QRrd5Yy714pp5t9Oo9YW/t5xP5ExU
         6HQrR52r1qvkVAk/ib9qabiApI4NcgFGLnAUvz7RUL3M4ah8sSVwqE+bKoQacNLp4KtG
         eXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706560232; x=1707165032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Uq6s8O+pYHZy+YqyeW9aGwqRrlELW919jI2ZvhUwBE=;
        b=MWQLrZvMVgm/jmVwJUIlDGqAyHramERUQ3j5NZG73jBBZetTWeP8kyWwvW9L+52mz0
         QFu544mNjKzs5vb8XFzeP0YfczzMrK3VOQ17ZMm7K23fMTbfWav+0pyT8WkFjQ1aCVhG
         cxcoRKWbqEoJkHLhEIpOv5QRCsVZjy2HuizWhjPNRcUhgQF7J6pR6v1+F9FERjmvv8Dx
         hTr8Bca6ajrnQ3bYfoGE0nx+6CGx7XOEEOuXi3gaSan+IYuaiFiZgZUW0N2dibMpT/I5
         8dYKN4HiTcc0RkiuUiYu5WMdep7KUb8zddoa+QWqoclGWu+cvIs3MbdqOftjUe4+t+0l
         4Fgg==
X-Gm-Message-State: AOJu0Yxa1Jkp+Nl4etxOqWOup+4tZZEgev4nhau3GaC+jeEuIvh6SBbp
	0yFfoyW/Sm4LmR/6aWrJgD7ZmLYOJ4Jm6eqUUTJieiAk0c/rYebaowXhL18k/xMj6LomFseuGvj
	ah3I=
X-Google-Smtp-Source: AGHT+IFI9DGTXsdE+TE2omu5IVWlSJ8jTtoDnY7xieNFXkdniHwWsNW+nz2DK80hHJLKG3RGXcU2UQ==
X-Received: by 2002:a05:6602:1508:b0:7bf:f336:8032 with SMTP id g8-20020a056602150800b007bff3368032mr5204169iow.2.1706560232543;
        Mon, 29 Jan 2024 12:30:32 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i8-20020a05663815c800b0046e6a6482d2sm1952510jat.97.2024.01.29.12.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 12:30:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/poll: add requeue return code from poll multishot handling
Date: Mon, 29 Jan 2024 13:23:46 -0700
Message-ID: <20240129203025.3214152-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129203025.3214152-1-axboe@kernel.dk>
References: <20240129203025.3214152-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since our poll handling is edge triggered, multishot handlers retry
internally until they know that no more data is available. In
preparation for limiting these retries, add an internal return code,
IOU_REQUEUE, which can be used to inform the poll backend about the
handler wanting to retry, but that this should happen through a normal
task_work requeue rather than keep hammering on the issue side for this
one request.

No functional changes in this patch, nobody is using this return code
just yet.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 8 +++++++-
 io_uring/poll.c     | 9 ++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 04e33f25919c..d5495710c178 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -15,11 +15,17 @@
 #include <trace/events/io_uring.h>
 #endif
 
-
 enum {
 	IOU_OK			= 0,
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
+	/*
+	 * Requeue the task_work to restart operations on this request. The
+	 * actual value isn't important, should just be not an otherwise
+	 * valid error code, yet less than -MAX_ERRNO and valid internally.
+	 */
+	IOU_REQUEUE		= -3072,
+
 	/*
 	 * Intended only when both IO_URING_F_MULTISHOT is passed
 	 * to indicate to the poll runner that multishot should be
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 785a5b191003..7513afc7b702 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -226,6 +226,7 @@ enum {
 	IOU_POLL_NO_ACTION = 1,
 	IOU_POLL_REMOVE_POLL_USE_RES = 2,
 	IOU_POLL_REISSUE = 3,
+	IOU_POLL_REQUEUE = 4,
 };
 
 static void __io_poll_execute(struct io_kiocb *req, int mask)
@@ -329,6 +330,8 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 			int ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
+			else if (ret == IOU_REQUEUE)
+				return IOU_POLL_REQUEUE;
 			if (ret < 0)
 				return ret;
 		}
@@ -351,8 +354,12 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 	int ret;
 
 	ret = io_poll_check_events(req, ts);
-	if (ret == IOU_POLL_NO_ACTION)
+	if (ret == IOU_POLL_NO_ACTION) {
 		return;
+	} else if (ret == IOU_POLL_REQUEUE) {
+		__io_poll_execute(req, 0);
+		return;
+	}
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, ts);
 
-- 
2.43.0


