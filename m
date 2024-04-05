Return-Path: <io-uring+bounces-1408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CF6E899DC7
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 14:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEA3F1C22FE0
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0394C16C879;
	Fri,  5 Apr 2024 12:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="J1+Z5oNS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D4416ABFA;
	Fri,  5 Apr 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712321896; cv=none; b=bVXeLS5mPbhhHUEc74H0rUUor3doI7XqMLb9Ji9GuHs0BDMVyHPDUfjwaR1WMyTXTGhnICSRm3tQSD9y8gYY6M0m0eozlMYmaD/tKwhmzT1K4kaFuXShCE7pGp7LbsVArmLuNf73l+we1PZScRWMQZK26MT/mrYJ4C9GtcIxvGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712321896; c=relaxed/simple;
	bh=WDANi8dlbdkYdbVKXyPz1hMyv4QfRuDNdXM822iahBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IuuumAfiOwDDDGk1USYysEme3ZMOn5pPgjWB1jkkTOcERk6MQlm2xpMIl/3PwEGK/bYboB+hFcfLCgZocOfd9VS+ljwhzR38uOIUwS2zPtPDijrk9fFlY3Ptt2Fj8df8AAjeWJm00ODu7gUgK+eo1jnlBnRv979Ml9ooS4VCwDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=J1+Z5oNS; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from vihara.intra.ispras.ru (unknown [10.10.3.38])
	by mail.ispras.ru (Postfix) with ESMTP id D62C74073CFC;
	Fri,  5 Apr 2024 12:58:04 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru D62C74073CFC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1712321884;
	bh=QhB6ezstggRh91x0/nIIArK1laheKeir/i42B5f2MKo=;
	h=From:To:Cc:Subject:Date:From;
	b=J1+Z5oNSBb19eO33zb3mOZLxqDBQexDVDjIs9SVL3K9ZYsZR0rjBqqRb3GlKMVYq6
	 WsAQEauVIiX1GJqcVtzhO01fSuGtaWCDHvm0pGWBjdQYbeyJh6I/RS+/hOWVVfKeFH
	 hMdADdxHQwWEkY9hqDXTevQm4zf4tEtLXdREhi8I=
From: Alexey Izbyshev <izbyshev@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Olivier Langlois <olivier@trillion01.com>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Fix io_cqring_wait() not restoring sigmask on get_timespec64() failure
Date: Fri,  5 Apr 2024 15:55:51 +0300
Message-ID: <20240405125551.237142-1-izbyshev@ispras.ru>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bug was introduced in commit 950e79dd7313 ("io_uring: minor
io_cqring_wait() optimization"), which was made in preparation for
adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
got reverted in cb3182167325 ("Revert "io_uring: Add support for
napi_busy_poll""), so simply undo the former as well.

Fixes: 950e79dd7313 ("io_uring: minor io_cqring_wait() optimization")
Signed-off-by: Alexey Izbyshev <izbyshev@ispras.ru>
---
 io_uring/io_uring.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..b764a18f3a49 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2595,19 +2595,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	if (__io_cqring_events_user(ctx) >= min_events)
 		return 0;
 
-	if (sig) {
-#ifdef CONFIG_COMPAT
-		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      sigsz);
-		else
-#endif
-			ret = set_user_sigmask(sig, sigsz);
-
-		if (ret)
-			return ret;
-	}
-
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
@@ -2624,6 +2611,19 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
 
+	if (sig) {
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
+						      sigsz);
+		else
+#endif
+			ret = set_user_sigmask(sig, sigsz);
+
+		if (ret)
+			return ret;
+	}
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		unsigned long check_cq;
-- 
2.44.0


