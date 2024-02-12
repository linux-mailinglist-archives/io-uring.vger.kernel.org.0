Return-Path: <io-uring+bounces-595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3676C8522B5
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 00:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7E2B285D6F
	for <lists+io-uring@lfdr.de>; Mon, 12 Feb 2024 23:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029194F8A3;
	Mon, 12 Feb 2024 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QzCgoxVF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6F64F897
	for <io-uring@vger.kernel.org>; Mon, 12 Feb 2024 23:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707781381; cv=none; b=Y+6MHBdp9PYMdVnhh0JT7LoGLNnrkt5P8f4ep/EskbQjJtUTyfThub6kNSEfcRtFxnnp2E/P/XHpdqamto/zlZcvlxbVDFq+13irt9BzIJYWlMDWzshuRflIxlbMQ3pQS0iqeDnhBemDs22eerYelfHAmw30q0tYLKBRGsjxoUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707781381; c=relaxed/simple;
	bh=mQ/JWmAxoIhLLT90JiDNMOc016wQIJuddmhxof/KBfw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jJcj8LP1FkTucIfimf9fqG2DCJeRMUK0T4dDq3V/2M9NoHElMzcqfb33oAsXxKklcQMHwZoIHHgXPImf8lEo/t/8aTb0pdpoPHhFsR8M6OpMXKBfV0XsA6PpwnckL5dNH4Ydk68KLuKcnIroCqd7qQwtTzJdFBfsb6Y2Ay5Ti50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=QzCgoxVF; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1707781380; x=1739317380;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9NrPx9UbkKLKvh2yXTUp0ZuOcVmbvjj07zY+cwnSaJc=;
  b=QzCgoxVF3vXBOTWtBhFBg7l7/pFsXkHw15dDCuhizXqjc581YI6cuCyE
   Q29nVdemWYedi0Zo6aIoeiuQDlDq2vixsIk0ukrlcYEgcSO8iAAAUra4u
   sVNt0QE1mmE9ncnoBbPLfMJVVih03I2rh6Ik+kfp6Os/sL4UVD4ncMzAp
   k=;
X-IronPort-AV: E=Sophos;i="6.06,155,1705363200"; 
   d="scan'208";a="396614982"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 23:42:54 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:10361]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.42.140:2525] with esmtp (Farcaster)
 id eec59f75-5fe7-480f-9f56-b6cd924a7f4f; Mon, 12 Feb 2024 23:42:53 +0000 (UTC)
X-Farcaster-Flow-ID: eec59f75-5fe7-480f-9f56-b6cd924a7f4f
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 12 Feb 2024 23:42:52 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.23) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.40;
 Mon, 12 Feb 2024 23:42:50 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <io-uring@vger.kernel.org>
Subject: [PATCH v1] io_uring: Don't include af_unix.h.
Date: Mon, 12 Feb 2024 15:42:36 -0800
Message-ID: <20240212234236.63714-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

Changes to AF_UNIX trigger rebuild of io_uring, but io_uring does
not use AF_UNIX anymore.

Let's not include af_unix.h and instead include necessary headers.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 io_uring/io_uring.c  | 1 -
 io_uring/rsrc.h      | 2 --
 io_uring/rw.c        | 1 +
 io_uring/uring_cmd.c | 1 +
 4 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..c5bfc6d42fe2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -59,7 +59,6 @@
 #include <linux/bvec.h>
 #include <linux/net.h>
 #include <net/sock.h>
-#include <net/af_unix.h>
 #include <linux/anon_inodes.h>
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c6f199bbee28..e21000238954 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -2,8 +2,6 @@
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
-#include <net/af_unix.h>
-
 #include "alloc_cache.h"
 
 #define IO_NODE_ALLOC_CACHE_MAX 32
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..332bd59f19b1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -11,6 +11,7 @@
 #include <linux/nospec.h>
 #include <linux/compat.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <uapi/linux/io_uring.h>
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index c33fca585dde..42f63adfa54a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -5,6 +5,7 @@
 #include <linux/io_uring/cmd.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
+#include <net/sock.h>
 
 #include <uapi/linux/io_uring.h>
 #include <asm/ioctls.h>
-- 
2.30.2


