Return-Path: <io-uring+bounces-854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3A98755CB
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 19:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7610B23064
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 18:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9429E13172E;
	Thu,  7 Mar 2024 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SV84UlW2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15551DA27
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709834901; cv=none; b=DJUlFxilSp3OWqzGlTnI5aIesW9EN+IH+k0MI2fVAQARnn2co5h2CXJ65U0Abj3pkpK8wjq1qHhZH4haKRbIIJAMbT3XI3726m2NFLFZqRM1TZMet2WXKBLFnbEA1KoacdlMb1KHTpMBVDoJXxzw5QVuPcRdBH+Js5KyjfaUzOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709834901; c=relaxed/simple;
	bh=IDZ/fd2A1Pt0aPzG5zaZF9+9hJFfGJhlbiY7nqJiVwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SyxKFaL4MF8fv2U179gHsI/bgq/IDl5G3E0qD3hGBjRqynKIFp8/aq4suIExglAv4ImjcPpJqSyF3SQrbUOe2pUPF7B+wEH+jzEBDPsjjslq8vgTlcZ4kDxE06nggkIjnpdTA7wcWqDzjBsyen667O/hutMiUz84s81Jfj5WSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SV84UlW2; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a28a6cef709so3292266b.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 10:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709834897; x=1710439697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lbDobA7L7azHftgWxPYcNwhjCwO1ulHCc9jB7vXDXyQ=;
        b=SV84UlW2Op67qDoxRrcwi1Oh6byIkX+2qd3dy/upX5d85867X+TGXzAWvHPPHFkXNJ
         7JsgZlz43H1MJlmyWbOst/tZcMWfryPnA6nIoWJrSyK/dB9wo+VeUih3czciSB0lCORE
         gmhl0IJUhwnmV65yVsdR6VJcd5T90POGa/UpCvtPDNVRLYNwdOGqAxgpD38cNBblEet7
         9W7mQ0NFXCuICWk3mBo8qYIzAb830gWV2laiMMUzzIksculMIrf34XOTzEmRBGS5Hr15
         jZTNLl3z1wgVsltggr/ftHz4Mh3xCKdCJIub0eDtQttjJVNdNb+mdqr06pfgznv2Xt/H
         jEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709834897; x=1710439697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lbDobA7L7azHftgWxPYcNwhjCwO1ulHCc9jB7vXDXyQ=;
        b=YbHp/NL+zT+NFcVfbnkDuO9hPRs596heeGQCOWhCmjTFntrGLmTY2z0cXBj48DARRP
         1ZR2fkDGirXY2K5kuSOaOVLuRpmCbNbd57iMgPtN7qYjz4hJ6TxeZ1KxiJD+tJ6GwHb4
         91Vnntl3eA179cnUPdCeoWMW+WkCbfbltecl7jd4GbTUo+3iPFX93LBqEFj3nLmRc1O/
         Ui02mQb6eMsujVwx0tQYrLP86shcPIrg7CW3LcDnvYH5E77fjms8MKdB1hVUtmw6a8Zu
         zyPyLY2iMhInKJ7TqrdcGETBcfxSBujTk1w4iNiwoKti/83EOcJbItGgeIQgazOvXXjV
         10Pw==
X-Gm-Message-State: AOJu0YyczelazYjTo/ZTr7IFKG23IaY8teBG69EKHqdgvmOGIdd/HgBg
	MMMix7S3wsh0sXun0kfOr9ZPbjpY7OAlGuauY3yVjdsyXktZq75deZdXOdMp0hA=
X-Google-Smtp-Source: AGHT+IH7Gyq1JyTd9Rr0hy0fkXB4b2sQqf+VJIJgbvvhXTR0TYuvbDqeVpjHOuICPg7htgOvOj0/9Q==
X-Received: by 2002:a17:906:fac9:b0:a3f:9d69:3643 with SMTP id lu9-20020a170906fac900b00a3f9d693643mr11083461ejb.32.1709834897229;
        Thu, 07 Mar 2024 10:08:17 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:86e8])
        by smtp.gmail.com with ESMTPSA id lh15-20020a170906f8cf00b00a44f14c8d64sm6023714ejb.135.2024.03.07.10.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 10:08:17 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix io_queue_proc modifying req->flags
Date: Thu,  7 Mar 2024 18:06:32 +0000
Message-ID: <455cc49e38cf32026fa1b49670be8c162c2cb583.1709834755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With multiple poll entries __io_queue_proc() might be running in
parallel with poll handlers and possibly task_work, we should not be
carelessly modifying req->flags there. io_poll_double_prepare() handles
a similar case with locking but it's much easier to move it into
__io_arm_poll_handler().

Cc: stable@vger.kernel.org
Fixes: 595e52284d24a ("io_uring/poll: don't enable lazy wake for POLLEXCLUSIVE")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 053d738c330c..5f779139cae1 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -540,14 +540,6 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 	poll->wait.private = (void *) wqe_private;
 
 	if (poll->events & EPOLLEXCLUSIVE) {
-		/*
-		 * Exclusive waits may only wake a limited amount of entries
-		 * rather than all of them, this may interfere with lazy
-		 * wake if someone does wait(events > 1). Ensure we don't do
-		 * lazy wake for those, as we need to process each one as they
-		 * come in.
-		 */
-		req->flags |= REQ_F_POLL_NO_LAZY;
 		add_wait_queue_exclusive(head, &poll->wait);
 	} else {
 		add_wait_queue(head, &poll->wait);
@@ -616,6 +608,17 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		req->flags &= ~REQ_F_HASH_LOCKED;
 
+
+	/*
+	 * Exclusive waits may only wake a limited amount of entries
+	 * rather than all of them, this may interfere with lazy
+	 * wake if someone does wait(events > 1). Ensure we don't do
+	 * lazy wake for those, as we need to process each one as they
+	 * come in.
+	 */
+	if (poll->events & EPOLLEXCLUSIVE)
+		req->flags |= REQ_F_POLL_NO_LAZY;
+
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	if (unlikely(ipt->error || !ipt->nr_entries)) {
-- 
2.43.0


