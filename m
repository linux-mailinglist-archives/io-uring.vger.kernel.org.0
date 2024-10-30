Return-Path: <io-uring+bounces-4227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1115A9B6B6A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CABFD281AA9
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E84C1C7B8F;
	Wed, 30 Oct 2024 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lVE1AEsz"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E0E1BD9DD
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730310859; cv=none; b=ZakguoAP0BQC2MAwfOxXYsB+yUhD2Xm/SSaHOjgxZJ974cyB06F7E8Bg/1+awO9Z8JVE8MgWPJwV3wJxJ/nvn4H2nK9ILN+UjSASWPfMWh3qOx/+CshMMcBKeANgRCwteNkD4v8h76B8MXdLB9OSQ9m0HDfzppMK814bK5uRqhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730310859; c=relaxed/simple;
	bh=A420Fvi6OxbPCfTmPK6uOfFgt3bwRtmeQINHK/+3Kao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QDm6pVmK0HnKYgWNmIlcACpgoHGpaZRK2m8aawr5yNXyPeQnUdT533tHKWgKyeaCP0z0X098YQZ927kjoO99q6TJrbZEO2UIDDsQ/MfiSJHdfxnnVABfKW+8jFsfmWMd6BkBFEmRTVMvn4/5QPJU1udlgQaquFsjECvGtVi6bdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lVE1AEsz; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=cgV4E
	uBAqmvpq61K/8Q0AikUcJZ6v9TAZL7P/qz9Qm8=; b=lVE1AEszSrNxEgXuQWzEm
	vxla0+93MXoXA185qVR/wPsCwpZx7H+rmGAzDKJXgAiK9H2BGEw0+SMFYkoHjv9w
	Wdy8/hswfbM9VfJ9h5xo1iLgRdlP/m70Ek7J5m5S+lDBCLUk9nYH4sQinh9vPX0O
	H2e/KXLCiE2NkmqCd+jUtQ=
Received: from localhost.localdomain (unknown [101.88.182.14])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3PzzDciJnjf6SEQ--.15737S2;
	Thu, 31 Oct 2024 01:54:12 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1] Remove the redundant include "liburing/compat.h"
Date: Thu, 31 Oct 2024 01:53:45 +0800
Message-ID: <20241030175348.569-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3PzzDciJnjf6SEQ--.15737S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw47Cw4kZFWfCrW7Zw4kCrg_yoWkZFgEyw
	srArWUtF9xWrWku3W7JFWkAFyYyw1fGr15XFWFyw43CF1vya1DGa1DZr97Cr15W3ZxuFy8
	XFn8W343Jr13GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREBHqJUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiRRGIa2cicl0DqwAAs1

Since these C source files have included the "liburing/liburing.h",
which has included "liburing/compat.h".

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 src/queue.c    | 1 -
 src/register.c | 1 -
 src/setup.c    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 6967dad..1692866 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -6,7 +6,6 @@
 #include "liburing.h"
 #include "int_flags.h"
 #include "liburing/sanitize.h"
-#include "liburing/compat.h"
 #include "liburing/io_uring.h"
 
 /*
diff --git a/src/register.c b/src/register.c
index 6e9bc88..d20ff9b 100644
--- a/src/register.c
+++ b/src/register.c
@@ -6,7 +6,6 @@
 #include "liburing.h"
 #include "setup.h"
 #include "int_flags.h"
-#include "liburing/compat.h"
 #include "liburing/io_uring.h"
 #include "liburing/sanitize.h"
 
diff --git a/src/setup.c b/src/setup.c
index 96fdcab..e4c39f0 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -6,7 +6,6 @@
 #include "liburing.h"
 #include "int_flags.h"
 #include "setup.h"
-#include "liburing/compat.h"
 #include "liburing/io_uring.h"
 
 #define KERN_MAX_ENTRIES	32768
-- 
2.47.0


