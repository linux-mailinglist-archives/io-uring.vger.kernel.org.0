Return-Path: <io-uring+bounces-2519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0AF932FA8
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 20:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FE5B1C21DD2
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 18:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B697D1A01A0;
	Tue, 16 Jul 2024 18:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6fZS2IR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A051A01B7
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721153131; cv=none; b=QxmoFlm4CJUOoanC74+WsrcSWWk7B87pPI668Jt7QJyEHLdkfwPtJI2zIXzHcbG/7mW1taL7YOg2PNYV4eWN6j/vFPtkmRpTWC0cpML/O/RL507zZ6+WPTdeJxr8i9ggTjfdB0Be20zJmwZEp6EwxLXAdy636zzHfs9m+3aKhSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721153131; c=relaxed/simple;
	bh=sMmskaeiD/LK3PzOk4kdLKNAGIHIkh3e/dvrYnKl0cI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dQFqf7hG/AHRaVZ4zqBlIBBpXC4W3dkv81L16kWo6s/Pn2jI9eeb7X5Xs4KnayTd1b+Fj+7eWbJMEbem8guymUCwq6dpX83eM7SH9qD9Cvcm40VljYA+EnTQDKDdG19l0HtCtQviSzofh57yKX5W5WtKh9c4jskxEus5oBl3Kgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g6fZS2IR; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4266182a9d7so37692265e9.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 11:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721153128; x=1721757928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xAV+vfiqGI7yXcxC0oMBDM51qylCIOWuLizSxGCFKyE=;
        b=g6fZS2IRcHd3WopbdDgfbklX/8ierEM2WPMpbiOcQOUjJZqviXs+t4BXSeIEYwV4Xr
         VaCdaT9c9jH2J3CiX/xsymPRnIceDHcTvjyUcC+W5zzi6qhqrm3INMHMOK6PmFV3ZP+I
         KHL48s8yLepsReNjtUq6+taIb6uaK1cgZdoBmLSQ9N48207q1TqlH6Ttn82xXVp1VV+d
         bCnLtZeQtkISYazGGmintdLtVxcjC76onjWbdiRt7PyArwRvpFSRf0IZIq+OybG1ws7X
         Nf4F6uKOu+09W5sbg08ap2eymyCWradmWb3Fww3SWjjWpgbtsfSnmi8aSOxkdeKCetxL
         EWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721153128; x=1721757928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xAV+vfiqGI7yXcxC0oMBDM51qylCIOWuLizSxGCFKyE=;
        b=uz67g4s8wfsQqRUUadLxS+U1NqKa7sYCYEj0IXJMMHFEqBgWdxyJw7iKTkalJvFUxM
         iQ5pY0ZRgjV2ofIhPmOCp0ZV1xmN+H4wtVJMrHeGAEdHb0OerpzF6WKT4S0y59VAZVbR
         g9SaLZlu0BdZ1utG5rE14/Ck226rQ0Bxip5FjNfsBsqYvHHE8Yo/nIp9j/cetmY19Xuh
         j0ga4ftXJirI4CZb2C09owCLe8BrsIskOxthoo5KPljhKmkIaw2+mCf0/DDp36YVJkA9
         aU6TZRTYkpTdSDHlYT1FKLQQZYlLfgOZofSTPhn9iqwTxaHA+/Ut+tgeiUWQ7qaeAxhs
         0XVQ==
X-Gm-Message-State: AOJu0YxR32OZ6KoE0trixJT+owVboJ7bhtupPOc+pzDf+PvyW9MJAab3
	L8rYPYt3mmfnZyDg9l9dEnQzAJ4UImsQs61rRukza1OnrruoWL7aRka5FR1i
X-Google-Smtp-Source: AGHT+IGqDCIhl7HWtfee+X0/TA9yMchgH4bqcAl6+NL4uA2edElP8CyZWU0VtEcFyWz4pMH2YlLltA==
X-Received: by 2002:a05:600c:1e11:b0:426:67f0:b4eb with SMTP id 5b1f17b1804b1-427ba655311mr19169015e9.2.1721153127784;
        Tue, 16 Jul 2024 11:05:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.233.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5e983e7sm136369295e9.23.2024.07.16.11.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 11:05:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH 1/1] io_uring: fix lost getsockopt completions
Date: Tue, 16 Jul 2024 19:05:46 +0100
Message-ID: <ff349cf0654018189b6077e85feed935f0f8839e.1721149870.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a report that iowq executed getsockopt never completes. The
reason being that io_uring_cmd_sock() can return a positive result, and
io_uring_cmd() propagates it back to core io_uring, instead of IOU_OK.
In case of io_wq_submit_work(), the request will be dropped without
completing it.

The offending code was introduced by a hack in
a9c3eda7eada9 ("io_uring: fix submission-failure handling for uring-cmd"),
however it was fine until getsockopt was introduced and started
returning positive results.

The right solution is to always return IOU_OK, since
e0b23d9953b0c ("io_uring: optimise ltimeout for inline execution"),
we should be able to do it without problems, however for the sake of
backporting and minimising side effects, let's keep returning negative
return codes and otherwise do IOU_OK.

Link: https://github.com/axboe/liburing/issues/1181
Cc: stable@vger.kernel.org
Fixes: 8e9fad0e70b7b ("io_uring: Add io_uring command support for sockets")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 21ac5fb2d5f0..a54163a83968 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -265,7 +265,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
-	return ret;
+	return ret < 0 ? ret : IOU_OK;
 }
 
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-- 
2.44.0


