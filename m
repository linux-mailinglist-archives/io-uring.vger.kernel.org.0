Return-Path: <io-uring+bounces-9550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0680FB412E0
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 05:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C233D54372D
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1084F2C325C;
	Wed,  3 Sep 2025 03:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SfJ3DUc4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f98.google.com (mail-vs1-f98.google.com [209.85.217.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BDE2C21DC
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870022; cv=none; b=FdX1wHSA+bYmiwHKNBEUOQ3gBgdQpK9n2gUJCnrSFMYDznO/vQ7MWVvBuL5+Awik8nj8zKljZs6qOS/6i+BCtSyfh7p5ciN19DcW/B63OJHejJ13z43XeguCQp/dvhj18oqeZW83ZgJAbX5VuGpuCpzG2eobD23V2OAxJVzqnoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870022; c=relaxed/simple;
	bh=hFmR3pVdhT7xfVLKpbhJFsgBB3+5r+/8jlK7QV+iOBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNgbwQWD3fxTm3qLLoz1Se9DYskXleHDSWt1hvx1Wf+XcDmf0FFWXuQfYXQ/aLV167+Ozui2+nhXx8etY+OELzKQv6aGMdjgAS+XWbLa0QXotimKNkOjX+9Tx+wE81UVv7w8MfN6ua2zzBi/Jh5ktQI3B0y74nuZpWouPmdow+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SfJ3DUc4; arc=none smtp.client-ip=209.85.217.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vs1-f98.google.com with SMTP id ada2fe7eead31-528af49b718so162399137.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 20:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756870019; x=1757474819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSqF8u89jLv/Gbai9ll4AlOnIZ8yRMDq0tMj1xwV5eA=;
        b=SfJ3DUc4R1HrK6TWTCyLUp4c1a0p5ZuQ278IqlaKPnWsvH4kBgPGyOGYRcJpXgzYZc
         DcGwjuJLsmQ0GE7KO1TwkCxcWIHB8NxlZ4Z5A+3Y4jigS9fzz8UqtWYlYUQw08n0xtT1
         DN+UbIBtZHOA/2DmKFWMVzKzeVI0O0RBXiIIphtO8kphteGOB96hhRGYxChQeQSj9L9U
         10o/b+BUetE/9AD0TJzoFsLTmBtaQcYxFa8+skdkrA1Ki/kMswnJFRceAVj4eoxyrGV9
         b81QTO86gAcAjHybeaODw4PcyWPtE/+OKYC9RHdYeIpVc40l+EbuMI0U0gTZditNSP7b
         UY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756870019; x=1757474819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSqF8u89jLv/Gbai9ll4AlOnIZ8yRMDq0tMj1xwV5eA=;
        b=YjbjfkLivx2pVX97epKMQOBEZdVT9MkoXvxBLw7h7NVA3PxG7DflrpS1+ZyZGTAl25
         aRt81DiWwuiSOP9kvTP5PoKBmxfbaFDPxuVTOlPoUbCZkxxXBWD4uGuFEA4EDEklmy5G
         sj4zaX5lT/O7cFZIEmc1bgMfPdXBNEX2iGZDiwpwroaNVX3o1vaZHgJ83/qwQ+hdP68V
         5KrlwLFcIM6ckPObs7mwdfRgFjWKhdfADCPs5f108mBfL6du9+YgZ0tiHS+WgZT5IJYK
         CfpfAon8BflTPM4PfVNTCi/acWhN3qHbtaAf+npvnXYUDFQ3NwYLBc3briKuWdGG+CgI
         7IAA==
X-Gm-Message-State: AOJu0YxSrFXgGkAT5K2Z4uNfdU47bdoIrOiqus5yHgCaara+EMtgYAuL
	piq5gkddKFmhNZ5ZLXqtVJn8PJIvsRdemH9IA/khi9ndEHGqjyB3Czn3hMBOW0UOygE0nEhYJjD
	xOi+PeLo8a5bP/U3Yy1RldHNuJxvwFx9NQ0ignmJfwJ4OhxWpLh8d
X-Gm-Gg: ASbGncuSUZ5hn63AThcOPsBnWNhgkmpPi0awUJByeRslHr2nWGfniNVsImPKzeCzwl+
	xv7PSgUtzNDijdaFkYBrPMEey7L65xjLXOsIcOibS2LxkM7d11+po7zpRP9pD7no5oPXoVcfxqi
	F49XBC9OizA0GPfISNYHwjcBWdav1y7BdRyydWbtGjlnGVN+31rzz6yvWQKWGWela408axLSYa5
	Vkoqlw6+oUqh7DnWRWLk9AyO24meiAw0b3ZxSVkXZhBYFw8UqorjUm2apvMqc8UKHPTQWLp0uVM
	WyDc9XTDc7RKjm3/XVq4m4IZ7UAqcCvsPve0bIHNqrawVLy4G7jtRSlHMg==
X-Google-Smtp-Source: AGHT+IFehSnrrzLkenHFKrvF2fQBZ/Hq0de+LCBKeNQJKzQhedbF9DLqRHrw6Abi/Dp8WwHLWwZOnSYtgIX2
X-Received: by 2002:a05:6102:149d:b0:525:df9e:936e with SMTP id ada2fe7eead31-52a343e4a6cmr1745805137.7.1756870019067;
        Tue, 02 Sep 2025 20:26:59 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-52af1212c63sm1232773137.3.2025.09.02.20.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 20:26:59 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D1CD2340344;
	Tue,  2 Sep 2025 21:26:57 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id CF728E41964; Tue,  2 Sep 2025 21:26:57 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
Date: Tue,  2 Sep 2025 21:26:53 -0600
Message-ID: <20250903032656.2012337-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903032656.2012337-1-csander@purestorage.com>
References: <20250903032656.2012337-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring/io_uring.h doesn't use anything declared in
io_uring/filetable.h, so drop the unnecessary #include. Add filetable.h
includes in .c files previously relying on the transitive include from
io_uring.h.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/cancel.c    | 1 +
 io_uring/fdinfo.c    | 2 +-
 io_uring/io_uring.c  | 1 +
 io_uring/io_uring.h  | 1 -
 io_uring/net.c       | 1 +
 io_uring/openclose.c | 1 +
 io_uring/register.c  | 1 +
 io_uring/rsrc.c      | 1 +
 io_uring/rw.c        | 1 +
 io_uring/splice.c    | 1 +
 10 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 6d57602304df..64b51e82baa2 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -9,10 +9,11 @@
 #include <linux/nospec.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "tctx.h"
 #include "poll.h"
 #include "timeout.h"
 #include "waitid.h"
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 5c7339838769..ff3364531c77 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -7,11 +7,11 @@
 #include <linux/seq_file.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
 
-#include "io_uring.h"
+#include "filetable.h"
 #include "sqpoll.h"
 #include "fdinfo.h"
 #include "cancel.h"
 #include "rsrc.h"
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 545a7d5eefec..9c1190b19adf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -77,10 +77,11 @@
 
 #include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "refs.h"
 #include "tctx.h"
 #include "register.h"
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index fa8a66b34d4e..d62b7d9fafed 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -9,11 +9,10 @@
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "alloc_cache.h"
 #include "io-wq.h"
 #include "slist.h"
-#include "filetable.h"
 #include "opdef.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index d2ca49ceb79d..cf4bf4a2264b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -8,10 +8,11 @@
 #include <net/compat.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "kbuf.h"
 #include "alloc_cache.h"
 #include "net.h"
 #include "notif.h"
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index d70700e5cef8..bfeb91b31bba 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -12,10 +12,11 @@
 
 #include <uapi/linux/io_uring.h>
 
 #include "../fs/internal.h"
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "rsrc.h"
 #include "openclose.h"
 
 struct io_open {
diff --git a/io_uring/register.c b/io_uring/register.c
index aa5f56ad8358..5e493917a1a8 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -16,10 +16,11 @@
 #include <linux/nospec.h>
 #include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring_types.h>
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "tctx.h"
 #include "rsrc.h"
 #include "sqpoll.h"
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f75f5e43fa4a..2d15b8785a95 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -11,10 +11,11 @@
 #include <linux/io_uring.h>
 #include <linux/io_uring/cmd.h>
 
 #include <uapi/linux/io_uring.h>
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
 #include "memmap.h"
 #include "register.h"
diff --git a/io_uring/rw.c b/io_uring/rw.c
index dcde5bb7421a..ab6b4afccec3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -13,10 +13,11 @@
 #include <linux/io_uring/cmd.h>
 #include <linux/indirect_call_wrapper.h>
 
 #include <uapi/linux/io_uring.h>
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "opdef.h"
 #include "kbuf.h"
 #include "alloc_cache.h"
 #include "rsrc.h"
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 35ce4e60b495..e81ebbb91925 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -9,10 +9,11 @@
 #include <linux/io_uring.h>
 #include <linux/splice.h>
 
 #include <uapi/linux/io_uring.h>
 
+#include "filetable.h"
 #include "io_uring.h"
 #include "splice.h"
 
 struct io_splice {
 	struct file			*file_out;
-- 
2.45.2


