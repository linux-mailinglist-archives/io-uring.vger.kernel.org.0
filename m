Return-Path: <io-uring+bounces-6309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5F3A2CA55
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F4E416B041
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D7019A2A3;
	Fri,  7 Feb 2025 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HZ0PTeKW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8C619F12D
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949812; cv=none; b=B50rv9MLcra0PWSdy9U0yw3ILKzcac/LK2nlxA8ZnJRItHZyu0LiUbnywpaekxy0o0GDfiQZEBU/hHWYQ2Lrt/Eh8OuB4yPLDs/TbhWqNMW2k/VNW0sR0r04KWr9+e7BA6QTde0NDXUSsTQIl4WJ6xwB28jFNrKYW6VRqjf268s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949812; c=relaxed/simple;
	bh=AJ4EpG+a/HnjEaQKeFR8lZf7Ex4++mtSxvprrt1iy8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF39cUKBU9il8OaPVYc5KJKECKL4A09r2humftQEuDhxXB6F5FWcUc0SVgKUEkJAN7dYbzG6yf7Z6VUU2rcz66nDb/c1afX44opaklYitvs9QNMmHKVu0WeR8x7/piyReILX5ZOVoLC7SHJADrhVRQlnoqk08rB6qBvikaagH+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HZ0PTeKW; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d03d2bd7d2so20587075ab.0
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 09:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738949809; x=1739554609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yl4I89AW9N+9ZjPLUSwNXzZLneK6YdFoM+i0fKJ0Giw=;
        b=HZ0PTeKWdgPzlRTKYZUtkF3n4dgc6kmTN0yRvmnKb+WWyaRLPx1ZT0Exx30cqPEJpQ
         NFvPNl8bXhCdkXGWvFORVCq7z0kjQ02nLwqY35ebken9jBUjLqZOR2/VjSDGvePo9yNH
         G1w6gdu7aF6uJIU1XEYJJ5yp4Dj4get3WNBfR0eqnNis1Hbj96NyXLxhYnosNDn+GSIe
         ePXzoVkYbp5N5XU/i716UqhwQq9HGQ2vTfBa11kyvL1tt+gll1bcol+4PY3t7w9DrGYz
         10XtITW9mtN9FoiodpD1/VwiN+r3w53hfhznX79wk3qg84Rq1lSNzuZXjxvGzJTQi5zG
         HbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949809; x=1739554609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yl4I89AW9N+9ZjPLUSwNXzZLneK6YdFoM+i0fKJ0Giw=;
        b=N2Br6LtjPe6mpDyCOTY+uonWQMjS0qxDg/1AQZESJ+xA5+Ssq1jmRC/aS81lUbNvUm
         4+FVLiXUBe9U4HRLS21T6yyCmmP8YFWdM0dtSUZj2S8mbVt12kV18nB8J99YvSs7m8JG
         BtGHu3hhk/NHrpLGOpfWGGEwsB/lM7dgfQ8yS4sdhbmC11AoaqotPB+uYO5ZL/dwjd5Y
         9vk7+t0Nvy5F1qKvCFD7j67skpcO/J7YSB0pErWe4L3OEeDQ7LKvD+lsPMkk+WGDQh23
         CEtoT4peuw9YECXOh8jdyHTQbtN4fk0D4OdFWxsm4A8kPW3UrvtyW36AonYzsNJ8MlDr
         brQA==
X-Gm-Message-State: AOJu0YxkhEvPdPZzqzOm1AlzWNX3Bz/JIdRntdsJZ+eWPLxj3NYTWOEU
	lF8kbfbEp96eLJgJ+lFSGtYkuWFRDr8A+C4PCg+y4gvfv3OksE8538qlD7XAeUulUcG2DVI2CKr
	Z
X-Gm-Gg: ASbGncv/ee6NCLJIvLY/jLPZxSX1UOfeO8AshK3KVl9L+Y64B+OjrbASfail/q4F9pR
	VCMa0Nb7LPnNRmHkT8p9EMCXxXjKyWx4p+JKWrBZfmv30NoSHbvvcs/EAXfDeiJ93vxu0TbZhf/
	M6ZjQhehNCdHfch5DJfFBzctbkSS29tgp3KxxXlYC/GRTRQQ7+4MAXzlqwB55DrIjls9R2ffFZh
	Dlldo1bve1uP4Hl1iE51jiDKN4dzTAfewHG/L4ndYOc7CH4/Hn3Eplur/wO1EFzoUzkc3a8Mk2h
	1ZIrwHiCUhA9P2AGKBE=
X-Google-Smtp-Source: AGHT+IFf5yFHbi0FpkwI0St9Frw/m6TmD/MzSZjJpnF8PSyMprcyK2hlYpYREkjfvbItwT4qYeHWRA==
X-Received: by 2002:a05:6e02:338f:b0:3cf:c9ad:46a1 with SMTP id e9e14a558f8ab-3d13de7ae05mr31235335ab.13.1738949809397;
        Fri, 07 Feb 2025 09:36:49 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ece0186151sm206241173.111.2025.02.07.09.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:36:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring/epoll: remove CONFIG_EPOLL guards
Date: Fri,  7 Feb 2025 10:32:28 -0700
Message-ID: <20250207173639.884745-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250207173639.884745-1-axboe@kernel.dk>
References: <20250207173639.884745-1-axboe@kernel.dk>
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


