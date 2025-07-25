Return-Path: <io-uring+bounces-8788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B75B12380
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 20:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C02D189A0FA
	for <lists+io-uring@lfdr.de>; Fri, 25 Jul 2025 18:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12A724A06D;
	Fri, 25 Jul 2025 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="ebCmomRz"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256D623F40C;
	Fri, 25 Jul 2025 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466748; cv=none; b=F11kfbT353ZSrcchYTIC1n/vqWDU/Yj4kNCljl19zsxDDLMyJdEmf60HtFzNtq34tAmNJoYv2e682LTooKfuuZGrl9WonOpdYrsH5w+6lAMRJlP3OwPzP4V0/HxFxlr0h1LYkkBZNIWppCdvEe75iJZsNkgxrzOLSjropZ3Fk7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466748; c=relaxed/simple;
	bh=+uIxxdRnw9PvYH9tTEhH/8oOyQSTIu9eVN23Ki+b3JI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uP48qiZQaZAx1P7sLuDwZnOqd4cL3gGQakm75jrF1oTqk7tjmYNY4hcc7k/QZJQ1QQPAk91Dv1KWmmbTCa1rk4W6t7sz2+jLA3FE68YV3/r/WN7wEvsCFVDy2KXS9bS/PGje2M3KdMxlwD4laTksXSlkZ1OUNPQUgEj/bDbU5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=ebCmomRz; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753466366;
	bh=+uIxxdRnw9PvYH9tTEhH/8oOyQSTIu9eVN23Ki+b3JI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=ebCmomRzORYPJAp+vQf75WSXjZFSHSRtj95jv5JqgIau6ISHNjGzCxkyWEkCBlyXt
	 t2TbgWxy43gMsa14TQ+6W1+kq3tSAzKytMXnF9ACtjnL5EvNmM1rXZGh0K2EfbhFgv
	 0Orul5ZF9y6iPyos69+3a7d1mJj5So+c7pFYcEYz0tyKghQ1oLUcTwEiMqKq45cKC1
	 wp0fycJCfHTLqTOiOQWmScfX38AywYOVpXvKDNiZ0ZOIcGnU+r0YG+886mOj5TISaQ
	 SNumONGNLGeEdV9/l7qJfKOuRHtvnM5EXeCF+dsdWO8+MeCQhBiviifRLbYNzCmbeb
	 rXcJpb5IWJuaQ==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id EABB02109AB6;
	Fri, 25 Jul 2025 17:59:24 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Michael de Lang <michael@volt-software.nl>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 2/2] liburing: Don't use `IOURINGINLINE` on `__io_uring_prep_poll_mask`
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 26 Jul 2025 00:59:13 +0700
Message-Id: <20250725175913.2598891-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
References: <20250725175913.2598891-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not exported for FFI.

Cc: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index dda0d5c4facd..83434f6eca65 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -704,7 +704,7 @@ IOURINGINLINE void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int fd,
 	sqe->msg_flags = flags;
 }
 
-IOURINGINLINE unsigned __io_uring_prep_poll_mask(unsigned poll_mask)
+static inline unsigned __io_uring_prep_poll_mask(unsigned poll_mask)
 	LIBURING_NOEXCEPT
 {
 #if __BYTE_ORDER == __BIG_ENDIAN
-- 
Ammar Faizi


