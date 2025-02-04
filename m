Return-Path: <io-uring+bounces-6259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F069A27BE5
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:48:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F223A15B9
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F5721A428;
	Tue,  4 Feb 2025 19:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JfN2gut8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AA1219A6E
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698507; cv=none; b=Fuyc7DOysZNq3nMK4K4yUAC9C0jZJaKWa44lmpRgkEe7yj3uYBp3rStLU/WcsaXeFAVu5YdZ/2Wz10HX+OMnQZDiALpSOMXPioZIgraimagb6Fn6xtrFn02QseK+60Dgjt7PqTE4kjhrYfoTrhSIBLrXpIZsXjw+xwyekXsXd/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698507; c=relaxed/simple;
	bh=AJ4EpG+a/HnjEaQKeFR8lZf7Ex4++mtSxvprrt1iy8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+1mNWfmXby45iY/srkdBrYtvAsS5zDvt9uk6ykRbZTfQ8Yi4gdrVqFaWK92Qy+gznKbr/lqWD4PGToKcyR3TtPcSPryTtGODUzFpv4s2I1Aas2M2Cb40CthpPvosj5OK5d9Jfl1PUHP3ZZ1M5S+wcHun9P2JXFJdBN+96C2ch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JfN2gut8; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3ce873818a3so53136645ab.1
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698505; x=1739303305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yl4I89AW9N+9ZjPLUSwNXzZLneK6YdFoM+i0fKJ0Giw=;
        b=JfN2gut8Mxyx+Qm9lTtApKyUPE9Vk+jkt8VT758RePaXAhRuka29qcPnwrIGQbmros
         krHD88HtdrvAy7cvfMXtiSm8wweQQHxGYn3gUzI9ybt5QgY/7Y96xJzhHpsuc01X082K
         q1vSCkQdUCY9fKWJ2jEiTZ7BZKbWWat33liqs0jSJvaJ95+I6syqal1eZ3Iw1eeCxBXB
         vD9Fei9So0vXWrLR5M0XAULuPFoiKMjCqtQ1E8K9X2WajZzi70eST6m+POhNxZ7kn5J5
         NbtEB2/L/MwVMVx8n+pgMz+gOCbR52DnnnrbOneufoeJFEPLwgz7uCOdKPLdRVpD6FVU
         W3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698505; x=1739303305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yl4I89AW9N+9ZjPLUSwNXzZLneK6YdFoM+i0fKJ0Giw=;
        b=penMQ0ghy+5WSiWsrtOzyhK560bycXYslgG/WTZXQwxkw1X4X4tLCdJZ1ijNuxOJXB
         c2GPwAwGMtBubekbUCjqEpr/FlE45X6aGI/4gr/MPTuKgLQEvIhA2CjxnAWut+G2CsrZ
         S0AHE+3aK32ozPE0/f2FmXBL94BRRhdwAiP0QoI8J5ahAZ5W+M0cDYlQxI4jGyk85c7c
         faI5VaOVKzBIB00tnDfO9OsFY1/JqF4Rx7E1JqUYOpFeK4wsrcklRukO7PSLR00s5koz
         J1V6Yv39dt1X4iwxMV/HRuf6JZQzVpXza9f52tjZgftu/wC50dG3AbbAC7oJtNUxczL5
         2QDg==
X-Gm-Message-State: AOJu0YwrNlBq1Ibe6JNfsfpcDL/MtbaTZyp7LEFvQvuSUDQDpv431OQP
	5m43m/bTOMWf7n7IpcWoDKKM3HFyf1HMbQQO+3SdG3kniXwtT0KM918pw+51VDb3r9XldSCoAuJ
	J
X-Gm-Gg: ASbGncs55dW77UydkFHJWCwepfoj2Qc7nYOujrGLUCFHqgs1EK7naretxL9WRZxlRvv
	bC8BgYrM2kSdzH4PQXYqX9MUFjkPFAONux4j77fVOB14zLl0cQsujktflqp5EWPekFOkM6CiY0l
	vs2ugdHXNK82D0BzmKdQirooF3owHpWYP0lAkbCLvz1wzX2eVZS4v1nVLYw5t5WU7J8AUdVWLh6
	onkAPcB+MKO2h5ls9awgbqQLGl3InP7YImnVQqxd8T4vFyMEaU2nuuzpfd7XJcuBUuKTPVKYfo0
	LcAR00rteZOb7FdHjVQ=
X-Google-Smtp-Source: AGHT+IELVjxsL1tqCfebEN1r34RIVmp0hKbUIDlK1Ylpdn3ib9har3+McLtmJPMliq4v7hQ7wmzlMg==
X-Received: by 2002:a05:6e02:f:b0:3cf:b2b0:5d35 with SMTP id e9e14a558f8ab-3d04f41ad8amr2550205ab.7.1738698504932;
        Tue, 04 Feb 2025 11:48:24 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:24 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] io_uring/epoll: remove CONFIG_EPOLL guards
Date: Tue,  4 Feb 2025 12:46:40 -0700
Message-ID: <20250204194814.393112-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just have the Makefile add the object if epoll is enabled, then it's
not necessary to guard the entire epoll.c file inside an CONFIG_EPOLL
ifdef.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/Makefile | 9 +++++----
 io_uring/epoll.c  | 2 --
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/Makefile b/io_uring/Makefile
index d695b60dba4f..7114a6dbd439 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -11,9 +11,10 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					eventfd.o uring_cmd.o openclose.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
-					epoll.o statx.o timeout.o fdinfo.o \
-					cancel.o waitid.o register.o \
-					truncate.o memmap.o alloc_cache.o
+					statx.o timeout.o fdinfo.o cancel.o \
+					waitid.o register.o truncate.o \
+					memmap.o alloc_cache.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
-obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
+obj-$(CONFIG_EPOLL)		+= epoll.o
+obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 89bff2068a19..7848d9cc073d 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -12,7 +12,6 @@
 #include "io_uring.h"
 #include "epoll.h"
 
-#if defined(CONFIG_EPOLL)
 struct io_epoll {
 	struct file			*file;
 	int				epfd;
@@ -58,4 +57,3 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
-#endif
-- 
2.47.2


