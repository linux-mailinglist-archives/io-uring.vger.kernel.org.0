Return-Path: <io-uring+bounces-6569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F072A3C62D
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 18:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A93C73B891C
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67C6214A82;
	Wed, 19 Feb 2025 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uv3omP9v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C93E214A72
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985971; cv=none; b=XgSTjZOimHBJ0FspVsICWV3wpm4usYbUnFGsnOSHOKaBCzex/RtRSOWaNaAWlsDO/Cwm1fYFyXFIIMHyUvKjeBlwWzgcxJ7HkhlOsHju7MJEf22b6Cs5MQoIJ5M1z2cqUcSD8WYD1MmdhCExScZN1Y2Urnn72ucVrbXvFi8BbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985971; c=relaxed/simple;
	bh=NKhQ3CZ0sAQuduklLkJ8jHQS9JJUaLrLvLnUNJYM5Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqKsnEz78VVyrC6dIFDsdCCNiMriIbSSfNajOnqukKFgaA4Vdx7bIjuSx+vfE9ZXUAe/JkVNJJ2hajlHeKAOqOQ+/s3h49T4kwVpW8nBuKe1bbPsgGwgFp8rhV+glueEbYEw3si0+XPaMWBkPYvXtCMdvFX3wLfhaq2yt3qoaUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uv3omP9v; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-852050432a8so1959639f.1
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 09:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739985969; x=1740590769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqeZNiF4C8ajF9Httgn8ehWaoVM+wUVbzJe1YYgdf+w=;
        b=uv3omP9vMBs1OH6zr+j8x1E00QLeFQ1bVFZ/3Sr5KU6i2BpRk3+NXpoiTGMEV4e47L
         TGLPRJqejz24lFFSiqJSNRk8hDz6qSiC8idLdZCwB7bDgKq5Re3jpQCEK8Hc072aUZy6
         PgxybNO9fcyOmMJ19KKCJgnmbUWHbuVENCJk2uiQU96ormD9FUpuxIBykblBO3XQT8MM
         9/rpTR9GfNKw2+YWYdL9I7M5ss4Knv4hqDblinj7hYPA+LLq5bF3jLvs5zrMdTQLzMkA
         /5/Si+4dSsFxlyYLIqUWv6OfKL2+w9/VkCmNQTD2p/LnSeNF+0PR+O8buTjSrILX/0FD
         /ZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985969; x=1740590769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PqeZNiF4C8ajF9Httgn8ehWaoVM+wUVbzJe1YYgdf+w=;
        b=VkeQOXJWev6DFdphqYVKf2A1ttxpiTAPtPjLMN5R0krK+AoJa1WkMG5lbSDI/9Odi6
         aCsOGMUVBsCwx3vpCabMWYopIW2uq+4df9u1fWdL5E0r2V0CfXvNWsDMFa2+3KBZkzrE
         i3ECtLtKCGd0nXN48DrT88rNqeIJBBgTll4v5A3TmAPgz7BPcdGUGuFCcPTF/Or/Kytq
         lSn/CeclbZaAaPm5T7G/Uy9PAgIocYTUOLaPPozQp5DdYlz+Is19bJS4262YFdA7bbKO
         3Wfwi9t+r9T2pFbD68QE83lewKN0MZDrZ58sSk/4LaBpYllFtjr5A2xAu4lZ4jbW8ME8
         w9mQ==
X-Gm-Message-State: AOJu0Yw4AE0cwTFNgjXgd3845V4kTUCubvz9qUp9aLtEf0QvIMmSKeXQ
	Z01VWZGcB/4tFr4isCwDVyAw7gqe3uwWViEb1QYmZp+oRjtNv6UHFH00SoYObga6/SJcBUb9vva
	i
X-Gm-Gg: ASbGnctIJUUfO9gtzMLocIaTn0pE8umVfpeisKVN9sKkkmpCJxdhViPrdZxuA7UxynF
	Ne22GIjBfYRSkIw04phDIxaPjCIt/PNfg2Nq+d6p3XXHKMJzcWQrT4oIsyauG3FeUSGS3dskhEN
	dnkQt2sdCUXUVLFvemao5E2bZL/entkrYcxM0I6E6nPHO0eLdLub9m/b5d/PfG4X5Lu19misgYm
	D5ZmxaPeF2IHtV8F3CLFYrD9jSBCs3oUTO53etu99k1rcmafhK/PJUM+4+bJDY5HW4hcJ4XTxxQ
	m5HMOTfwlKJzVzT32u4=
X-Google-Smtp-Source: AGHT+IHRVFWWS5YvlkaNF1Q/MDG4uwtiTei/nIZPfpHN+WkrFtLSjd0dVoryMXxuADhDSJM8pIGxUA==
X-Received: by 2002:a05:6602:6d87:b0:855:b0eb:3fe6 with SMTP id ca18e2360f4ac-855c32ce3c0mr10130239f.8.1739985968846;
        Wed, 19 Feb 2025 09:26:08 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8558f3ccdcesm142192839f.16.2025.02.19.09.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 09:26:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/epoll: remove CONFIG_EPOLL guards
Date: Wed, 19 Feb 2025 10:22:27 -0700
Message-ID: <20250219172552.1565603-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250219172552.1565603-1-axboe@kernel.dk>
References: <20250219172552.1565603-1-axboe@kernel.dk>
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
index 98e48339d84d..3e28a741ca15 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -11,10 +11,11 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					eventfd.o uring_cmd.o openclose.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
-					epoll.o statx.o timeout.o fdinfo.o \
-					cancel.o waitid.o register.o \
-					truncate.o memmap.o alloc_cache.o
+					statx.o timeout.o fdinfo.o cancel.o \
+					waitid.o register.o truncate.o \
+					memmap.o alloc_cache.o
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
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


