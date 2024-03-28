Return-Path: <io-uring+bounces-1273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D6588F553
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 03:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 367051F2702C
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 02:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674321CAA4;
	Thu, 28 Mar 2024 02:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vJHub0yp"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA372561F;
	Thu, 28 Mar 2024 02:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711592622; cv=none; b=BHTHCndWmF29YrsAooNSe8Va5Wv4PElym9nCa8nnnXFHo981rzzIv7u17EYy6GnG3HYWZbVMvMldbbKfKlKoX4Pk5AAU3KhxNPsSvKA0+y5vn7btZRpAArF+HhqsRg6F9rtTI8nrZEanDxBS74MuAWiZCtDCTEviLCQntkWLspA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711592622; c=relaxed/simple;
	bh=fE7UPGjpW4ybjCuZPI6M+/ZGKQlUOPJ/ZkNBj3Ns0rk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C3F4F4+vDI47/1jLdPod83CrIDn62Hsfc+2MeHP9lnjF8S2ojj0vRJ7FW1A8hI4wTJQb0KWbrz1GQv1lFAb5x+BxleAD3Z2G37+8Lq+WXfhNunXZWUH416AR6mwT7xoZPcUQWEgqkpkYGTblx93QJY3W0Al1Ot7wpEjDs/XxrJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vJHub0yp; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711592616; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=BPeX+Hl7QxuesHJ3WXDWWRziotoRu2s0MYI3HBPg72Q=;
	b=vJHub0ypFcgKeyHwF9fU0hmfJuEcxHtXJ/HvURIxjiD5wyvhAS6LBlFmja4sZwqbWVrISGb00G2//Y7dstNUEDe8EjOs8rDmo9SqOrvd0NNayQT1VvmvQnjh45FXnfCYAl0SVaDRMbOUYdPGdzDB6lIYbsE1qmb4xP4o456/oF4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W3QPvpR_1711592606;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W3QPvpR_1711592606)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 10:23:36 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] io_uring: Remove unused function
Date: Thu, 28 Mar 2024 10:23:24 +0800
Message-Id: <20240328022324.78029-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function are defined in the io_uring.c file, but not called
elsewhere, so delete the unused function.

io_uring/io_uring.c:646:20: warning: unused function '__io_cq_unlock'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8660
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 io_uring/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 585fbc363eaf..8a9584c5c8ce 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -643,12 +643,6 @@ static inline void __io_cq_lock(struct io_ring_ctx *ctx)
 		spin_lock(&ctx->completion_lock);
 }
 
-static inline void __io_cq_unlock(struct io_ring_ctx *ctx)
-{
-	if (!ctx->lockless_cq)
-		spin_unlock(&ctx->completion_lock);
-}
-
 static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	__acquires(ctx->completion_lock)
 {
-- 
2.20.1.7.g153144c


