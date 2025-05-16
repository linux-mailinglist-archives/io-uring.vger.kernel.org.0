Return-Path: <io-uring+bounces-8006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BFCABA328
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB94C16951D
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0731C27AC42;
	Fri, 16 May 2025 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RJSIizaD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB198274FF9
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421419; cv=none; b=F5JxAQsJHEA0uxOEpXHYEa5KjU4mJLM2AVdBb1tIAbbsaidoiHox025bE9RHVt4TUeQhgg67vg8vdQkYzdJ98MNSDpbDf/JDUzUMFxb+lWPqQsAdYi+BB0yLyllCn4w01j/HN8nPl2imNBKcabfsvEvheO1IHOl+5TleHEC9JUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421419; c=relaxed/simple;
	bh=eV+ZDvxsRGKdghYpfMk3rY0Sc72kFvnm+CCA/lgtFMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpPD3o/jROl4B8SIfuGnigy3ESqd7ptxYT5z7Hj1zritcW+tygD78uPRug1TtSivHAiNdv+d2EDS0Uj3Be1wrH/96iqyV5wQQEpqEESeOqy7NLqkHxjkd3Je3F2GbYz0D0n9L5JgO9g3frvZ1B0k+lncMcaiuxaxdl04RBnkAiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RJSIizaD; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3da785e3f90so12318915ab.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 11:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747421415; x=1748026215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxer+HPLQFWo4HOVClNFo40C9ULWGTJH+H5OO8uVAHA=;
        b=RJSIizaD/BG0SCuQ6I1349vCxD47AS+sQTk1fYDV6kEZDX9Yqqbb/AoJlC7tktmtg6
         iTjSwdP/fXPF/yiwnazRlkM1gX7ymBveNJ8Idc6EOYX8vAnzpaEtl3EeLEvOW+FAGFY3
         AEom0bTlX/029g6cArS7agQIlvT4HrcssooXZ3ouPZ7J9OVQhMCb0LCHJ6/laNRdjvoY
         DuZIRTCHFc9M5/kWSxXmSeMYgxRccXUvIcUWDRc7W8EuZw7VlhL4tF0kGEGvcFQnoyE6
         m/X5EHp5sc0r48S3TQBzkpO/vTi9m5wsNENdbjtN7NbfGlYGbthQ66WSFTSeChdUkkFp
         /bxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747421415; x=1748026215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qxer+HPLQFWo4HOVClNFo40C9ULWGTJH+H5OO8uVAHA=;
        b=SNLG9pWy9e696ugKvDeJX0hgyuhZLq0flY3eaWD78a5Iee+MzB4JeAlF7+mR8enTnd
         oixYBFApeWBYePD3AwE9voy7jaggJmptusXIUY5keTUo/1jzWj715PCkNNBUSNUG4cf4
         Pow1coszyd+rOZC1pFCp56g7CjMrXAlOHZUvPM+6qWoiGLOoVobkfPeRKPJClC5mcCbH
         hOZDVJAEOef4iyXs8YShUOdxwxWO2C87rjC3xsg02xqFICAI9Vq4do5L8+USW6SL4BZC
         V7vZt0JTAl39q9+Sl+601o9afe1kcvJrxLZF8TWvZjvcj+HznajQUVnqwNR0uSDzAdOc
         /Xrw==
X-Gm-Message-State: AOJu0YwsAjp+FKSDjUPWwNOsj/oloIioJJemSYy7/Ec46HCfJbq23/aF
	24XZjyeD38PON63f0t43/q0dFyJdchTw1ipxX62Xf3ABUt2khNq66rCbbCB3DL7cXnNFwgvlX4X
	zyw7H
X-Gm-Gg: ASbGnctpwL0UBD3zSumPPgWAwtLNsJoPKRIeIjB5+o8L+QVP5hgrO5pIA+Tsgd862vt
	N3d31afpxH/3tFo9gqJXxoOtG/Gdi2enDXkb2SCnRdW0W4ZmHT2Br7y1p2sZ0QBgUVSkaQTfMK2
	wBXZkDEp+wHGpdf1IxuaMrHrAfz/nQrxAFTiEOfEM9hsoqHKjoQ9gBzN6SmzRZuHHHlU0Wc4JcX
	iHSQYGzXkHSo7R7UUDkMVq5qLKsUDyIYBNYu01KI+jW5PXzjWjJ7stXWrP6DjWLIFvySWpOLM2C
	GaLa2jqAwKqFysCYhHhqfS93dotrWdF/bDP5zSA6Mm0FgJ9BM/MfsAzm
X-Google-Smtp-Source: AGHT+IE1KeF59gml3eR7MZDdhbHiLnYNxaBdd0ao7B22Pc4X3/KQ0ZqEnC+OVfrZ/32FA5eReuaNMw==
X-Received: by 2002:a05:6e02:3f11:b0:3d9:3e8e:60da with SMTP id e9e14a558f8ab-3db857a6ec4mr36664245ab.17.1747421415593;
        Fri, 16 May 2025 11:50:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db8443ae8dsm6162115ab.49.2025.05.16.11.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 11:50:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/fdinfo: only compile if CONFIG_PROC_FS is set
Date: Fri, 16 May 2025 12:48:46 -0600
Message-ID: <20250516185010.443874-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516185010.443874-1-axboe@kernel.dk>
References: <20250516185010.443874-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than wrap fdinfo.c in one big if, handle it on the Makefile
side instead. io_uring.c already conditionally sets fops->fdinfo()
anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/Makefile | 3 ++-
 io_uring/fdinfo.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/Makefile b/io_uring/Makefile
index 11a739927a62..d97c6b51d584 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					eventfd.o uring_cmd.o openclose.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
-					statx.o timeout.o fdinfo.o cancel.o \
+					statx.o timeout.o cancel.o \
 					waitid.o register.o truncate.o \
 					memmap.o alloc_cache.o
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
@@ -20,3 +20,4 @@ obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_EPOLL)		+= epoll.o
 obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
+obj-$(CONFIG_PROC_FS) += fdinfo.o
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index e0d6a59a89fa..b83296eee5f8 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -15,7 +15,6 @@
 #include "cancel.h"
 #include "rsrc.h"
 
-#ifdef CONFIG_PROC_FS
 static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
 		const struct cred *cred)
 {
@@ -264,4 +263,3 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		mutex_unlock(&ctx->uring_lock);
 	}
 }
-#endif
-- 
2.49.0


