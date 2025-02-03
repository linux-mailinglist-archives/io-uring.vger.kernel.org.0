Return-Path: <io-uring+bounces-6229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB1EA26015
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 17:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 099C5166BCF
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821AA20B7FD;
	Mon,  3 Feb 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZJoRKj/w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C656E20B1E6
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600291; cv=none; b=XeV0aFXAWBXWeWUHIAKPE2UFzP0P+5EfLXwBb6lik0rHKvfgCgluJYEZUJnERXa2wti7qiD5bEU1IYpKkVtupBn8xtWpgEJhSPFnBA2uMlEn702Mq0tVCTfpOULE+ydxqbeKnyO3saxyteC7S8sDw80+cfPNnZBuhnSpp+2nyrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600291; c=relaxed/simple;
	bh=AJ4EpG+a/HnjEaQKeFR8lZf7Ex4++mtSxvprrt1iy8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+/MdBkSOi8jd9B4jJGHwayPo+GEMjLFlp7Qm9XEJJg9Ve1zBSIrBpbvcB/QNP6K3hte+toGPNFj2fVFTXcF7oGLwyaT8XNrJDoKQldwqJi3yDggc+OuGvThaYFzPuNAv4JmF+SYAYa+cSYURrIJsqUuF6z8wr6UgW9fO/1kIAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZJoRKj/w; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-84ceaf2667aso298716139f.3
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 08:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600288; x=1739205088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yl4I89AW9N+9ZjPLUSwNXzZLneK6YdFoM+i0fKJ0Giw=;
        b=ZJoRKj/wU9yHgIyliRh6uYcJDLsHUg87VbXXz9WrMywx571IQHJSZvPWT+pehE6zwt
         XPJVDW+HJuvBUCcEY3dulA5y+us00W5xVqfja+guAPugN+752p/tYE64d3ZYUFaoNzqo
         bB/O+lZGQ/7RHcdgwEE/LA9ngEG1mXOl+SEJ7UhavRIv+I4huyEKASbtQ7wzEZ9DtQGA
         kIVZ/Q9FtD3miB/DDvoOctkkWrErtnhHBAOgDZPauz+AEJpcmxEqAKxZOV8XDQzVLGPl
         6wCxQv8IGNEUmY+/173HHd8Gac4cbefpo4iWkLJhIEPwk2m+AEO2WJ88Jtr7KOxlbBky
         /Rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600288; x=1739205088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yl4I89AW9N+9ZjPLUSwNXzZLneK6YdFoM+i0fKJ0Giw=;
        b=VKrDvGM3mW5M76VrnU8Nv+2AYybFzZxYkwVKbgakcbiMcMUHzdrWAWk2P4hc3bzT2g
         bBA6jPFMNNKVSIe7euWidlHSHh9r9Y6rlLyAAjE4Rcv1Op5r3JbF72NngdTjPoEhTz15
         XF10kaKmX5ISPMflnRC/uocsAWyHo0LEoEdIALmSOVnpja5IAbpbigQRirDfCsV+ypsP
         hCAhQTOx0hbHg5bfnIpi1D7D7VMBFBh5XXGtVgMmt9uotG4sDgEC1E7OLVgWWGaZNpfn
         52Iu3OB3vlsBj5liX8g9Cozvut1AzHrYFQT8QsAkiIePTWEne5Gv1w4cEY4rI46dVTvC
         4XSw==
X-Gm-Message-State: AOJu0YwBy8Ov6K9Btf517qZtHSNkEPObj6ApmR7S8y9lPnulUWm0Jy+Z
	c7uFHuxb/zIYOMqiOrlmcd2BVzCto6gbawpI2sUMOEt2MDZkblzLWXS3BWX7x4yZP9aIlaKLY4D
	iAKI=
X-Gm-Gg: ASbGnctK8nNYLI5ARYysV/o5GW8nLAiJ8qKHv6GyPYbmPa/0+dpreF1w/jnflBImJgJ
	Tdq9B0QSsMzfTy/CmyPB4OF1/OP9ubAgRho9gt9XQzYQGVKCedYcUKtl1yPcaQaosk5oMXqPySh
	+y+jh3Ca/2U/6tm/kTSfZ6czsEysmxV+8yNU0MLbdI16e/lB0uarWZy6u7T1bZ9BPI+ZIK2kfyk
	il9j/RpPQG+76r1Z+yYneYyntUOCM+533wzB92r/9qAg+RuP6QLWsDojBo5uKfed7aCFRP/LOdq
	EsEntcDMulWLFWTZrCw=
X-Google-Smtp-Source: AGHT+IE2WgIanOs+ot0lC6WutrqrC2QvvTTTNdZSFULo/ROZk+MFEGYpcigt6bnj4gvbuMhY+oEQZA==
X-Received: by 2002:a05:6602:3818:b0:84f:41d9:9932 with SMTP id ca18e2360f4ac-85427df1edbmr2081256039f.9.1738600288562;
        Mon, 03 Feb 2025 08:31:28 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a16123c6sm243748139f.24.2025.02.03.08.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:31:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring/epoll: remove CONFIG_EPOLL guards
Date: Mon,  3 Feb 2025 09:23:44 -0700
Message-ID: <20250203163114.124077-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250203163114.124077-1-axboe@kernel.dk>
References: <20250203163114.124077-1-axboe@kernel.dk>
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


