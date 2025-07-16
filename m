Return-Path: <io-uring+bounces-8692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5856B06AB2
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 02:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46C61189ECEC
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 00:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876F619D092;
	Wed, 16 Jul 2025 00:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="pgGZWFUA"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5C8199924;
	Wed, 16 Jul 2025 00:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752626657; cv=none; b=YIwDPJGNQyIKNPy9h+PkhJlU0MLSN4OmAgTUWnKhufZnS5gTfYkZrZKNk3k3hnevb8JbR3kgCmUORqCrrOcTnB/1TtkJeEoLS6X5QggL7prxwqTnxAP5I0ey425SXB29w56di97G0zOlTROnuV+sMliuzivjU9nPi3yg/d3zAlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752626657; c=relaxed/simple;
	bh=Mx61kFRNQHY9qQ6RBZGwoOG4WieLMzliOmAtmIesLuo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hwK9GQ01s/VuFzwG42riEqv8Ayiv3s+g3cN/nd3yXl4qtCSeK9Oe3HAfF8ldKKRUqCYT7uSMYl2Giqot3EXj7sG0QX1sZis3UIQDo9ETXUGl6E2sPuWor0UdSeJmEXQT9mT1nlGOUourV2Bi10XJ/Hf0pFRyVogO5LS6ONJlkyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=pgGZWFUA; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752626654;
	bh=Mx61kFRNQHY9qQ6RBZGwoOG4WieLMzliOmAtmIesLuo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=pgGZWFUAselh4tfIJmgjTwnCZDdQxb2U3KybXWkAQZK0qJ8brqZ3cFElnjGdtDweL
	 vhRAUY6aqXOQIj1lUXMbpikqdHKooAw1d115cRA/yg7pWQIzb8px8V9532Asam1TGS
	 B0+Q/KXprdxYbjU6pfMT9H+GTjeBzSB/ktQj1lTGT1+0yLNyuoEnQyP5gwgnOQDmu8
	 9ra3VWV+x/kwrFnfJiklJ/1bxNjry+ygCFE6aBw7s0fdPv7QWM/E2QaAa4ZSTO4Ayi
	 yQCSndhCUyPpGoRY+j8xOYAp4MupV2TvxRn/lqJ28mie202dd5hOxcwg5gNXYaljih
	 vipBlz20MLcnQ==
Received: from localhost.localdomain (unknown [68.183.184.174])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 5AF792109A7B;
	Wed, 16 Jul 2025 00:44:12 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2 3/3] examples: Add `memfd_create()` helper
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 07:44:02 +0700
Message-Id: <20250716004402.3902648-4-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
References: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add `memfd_create()` helper to handle missing defintion on an environment
where `CONFIG_HAVE_MEMFD_CREATE` is not defined.

Fixes: 93d3a7a70b4a ("examples/zcrx: udmabuf backed areas")
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 examples/helpers.c | 8 ++++++++
 examples/helpers.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/examples/helpers.c b/examples/helpers.c
index 483ddee..8c112f1 100644
--- a/examples/helpers.c
+++ b/examples/helpers.c
@@ -13,6 +13,14 @@
 
 #include "helpers.h"
 
+#ifndef CONFIG_HAVE_MEMFD_CREATE
+#include <sys/syscall.h>
+int memfd_create(const char *name, unsigned int flags)
+{
+	return (int)syscall(SYS_memfd_create, name, flags);
+}
+#endif
+
 int setup_listening_socket(int port, int ipv6)
 {
 	struct sockaddr_in srv_addr = { };
diff --git a/examples/helpers.h b/examples/helpers.h
index 44543e1..0b6f15f 100644
--- a/examples/helpers.h
+++ b/examples/helpers.h
@@ -17,4 +17,9 @@ void *t_aligned_alloc(size_t alignment, size_t size);
 
 void t_error(int status, int errnum, const char *format, ...);
 
+#ifndef CONFIG_HAVE_MEMFD_CREATE
+#include <linux/memfd.h>
+#endif
+int memfd_create(const char *name, unsigned int flags);
+
 #endif
-- 
Alviro Iskandar Setiawan


