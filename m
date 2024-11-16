Return-Path: <io-uring+bounces-4757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6889D00F4
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF36C1F23541
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50B3194A63;
	Sat, 16 Nov 2024 21:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZC1InzS7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55AF196C9B
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792433; cv=none; b=S1LJnUcQbu7hPutuNGj3W6LEnI4DOAPHIFKHfL47HW9jRVIfft+1X/j2jU+pMiihuNDwvOVMCU0Vg20v++2nReiu4DLwm/itDNLkktCrpu974GEk5A4+OQxDVnJKd7aLx8jZOq6Bu6LEZEi/Bw082QwzLoW7WauYx+ffsFQnodo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792433; c=relaxed/simple;
	bh=ZpzgsozMuAk/ochldTowI7h7bTEw7JWBZOOahdDVlW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8PkxBnU+sEJ5japghUlnJ2ArEBWTPDs6NMNau7ovR1hiGq2bXIRHFC25lbSz6SGOElTUlMVOYlOcmlpSvBtfiF1ZpNqyaipRBPk9nPlI5qhkEtJOMN0RzT909aSHaGXsCJWLF230Lt5jAU2vv694ru89pD/IY/MQPpuQloEN/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZC1InzS7; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-431548bd1b4so6660445e9.3
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792429; x=1732397229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wg+v/WEafR0hhxU0jQVQiPnsF9EILrTwW/uQsLAHZ2k=;
        b=ZC1InzS7PCGlcK5UW9jo2V54SQ8OV10R2Kr3S+/g67n5YniFJytj0pH8nx0rPH7CTA
         vy7euZnQfc+8ks90QGwwvCjmC3Me3d8LtFmbMmfUq6VGYlOk12cbUQuj9jPPAhMBT8pj
         ne9iSpGJywfBjXHsBdFEz3e9+EUDArFDwok7yjePEDUdZqRWtKavogkzjGzWD12xHeZB
         yWccyr6vmedWbeO4TzZOLol1di4CiL07IpnKmPoS4RJjjkw3FMBtW61RcmxZvxnbCNvv
         p/k2WjEnXDA5syGy3+yDdY1c3V1+DCGJWG4U8+j4uzvuFbRjMDfrDNNK+CbmJJEAStga
         CCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792429; x=1732397229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wg+v/WEafR0hhxU0jQVQiPnsF9EILrTwW/uQsLAHZ2k=;
        b=qooEAvYWbWZlZdN9WIJvCFt0QbC8QZxQgqzRBzdL1Q/PD+UoP7zkNRjNngBFfo4TYY
         G9AtXOGizjA+uUJgPFNOoEYZ0iS6RAxrNtFLF63kKGqJCmQ4FZciliKyFRRTvvgTKwuU
         1G09WxYjb0dDxpGjmpy4N0qGU+XMcBQ1YMat0oiI+n9PY/utSaDVJPhiTIF5gnU6CHXl
         GHGGtTsqRdmimFTKLeiTMgUIA7lQDHdakOR+G+y9+LKGTV8qBCE6wYSB6sKCeneuJp0p
         r6X98yV86iqs7RRIKckaHQAYOF+zsZsk0j4UDsr3S9nmy4IdJCI1pIgRQUQYsvXmJvAG
         4ywA==
X-Gm-Message-State: AOJu0YxqFuA3d0+CMFR8zwhsJeDuhK+glaynjOGfjlILgRHiCrY8WT1+
	eBt9zKnVqjxu0bHLJQUgGnUjjdcSEXm4vkVc7Dp0boKpoeUXMrMgJMRsFQ==
X-Google-Smtp-Source: AGHT+IHtvy1HqyUf3Kg1RThApoE+yK2cE2VoE9L5hkGfYTCe+se5M49Y+gMpVjoWSapsHUd48xp1aA==
X-Received: by 2002:a05:600c:3b03:b0:431:6083:cd2a with SMTP id 5b1f17b1804b1-432df74ba87mr67477105e9.15.1731792429334;
        Sat, 16 Nov 2024 13:27:09 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/8] test/reg-wait: fix test_regions
Date: Sat, 16 Nov 2024 21:27:41 +0000
Message-ID: <13bd6e7b30bdaed0d11bdfda409e5369ab8005ec.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regions for CQ wait arguments are registered to disabled rings, and
test_try_register_region() doesn't do it right. While at it kill the
extra argument as it doesn't do anything useful.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index aef4546..eef10e0 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -222,7 +222,7 @@ err:
 }
 
 static int test_try_register_region(struct io_uring_mem_region_reg *pr,
-				    bool disabled, bool reenable)
+				    bool disabled)
 {
 	struct io_uring ring;
 	int flags = 0;
@@ -237,15 +237,16 @@ static int test_try_register_region(struct io_uring_mem_region_reg *pr,
 		return 1;
 	}
 
-	if (reenable) {
+	ret = io_uring_register_region(&ring, pr);
+	if (ret)
+		goto err;
+
+	if (disabled) {
 		ret = io_uring_enable_rings(&ring);
-		if (ret) {
+		if (ret)
 			fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
-			return 1;
-		}
 	}
-
-	ret = io_uring_register_region(&ring, pr);
+err:
 	io_uring_queue_exit(&ring);
 	return ret;
 }
@@ -270,28 +271,22 @@ static int test_regions(void)
 	mr.region_uptr = (__u64)(unsigned long)&rd;
 	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
 
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (ret == -EINVAL)
 		return T_EXIT_SKIP;
 	if (ret) {
-		fprintf(stderr, "test_try_register_region(true, false) fail %i\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	ret = test_try_register_region(&mr, false, false);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "test_try_register_region(false, false) fail %i\n", ret);
+		fprintf(stderr, "region: register normal fail %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
-	ret = test_try_register_region(&mr, true, true);
+	ret = test_try_register_region(&mr, false);
 	if (ret != -EINVAL) {
-		fprintf(stderr, "test_try_register_region(true, true) fail %i\n", ret);
+		fprintf(stderr, "region: register with !R_DISABLED fail %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
 	rd.size = 4096 * 4;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (ret) {
 		fprintf(stderr, "test_try_register_region() 16KB fail %i\n", ret);
 		return T_EXIT_FAIL;
@@ -299,7 +294,7 @@ static int test_regions(void)
 	rd.size = 4096;
 
 	rd.user_addr = 0;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "test_try_register_region() null uptr fail %i\n", ret);
 		return T_EXIT_FAIL;
@@ -307,7 +302,7 @@ static int test_regions(void)
 	rd.user_addr = (__u64)(unsigned long)buffer;
 
 	rd.flags = 0;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (!ret) {
 		fprintf(stderr, "test_try_register_region() kernel alloc with uptr fail %i\n", ret);
 		return T_EXIT_FAIL;
@@ -315,7 +310,7 @@ static int test_regions(void)
 	rd.flags = IORING_MEM_REGION_TYPE_USER;
 
 	rd.size = 0;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (!ret) {
 		fprintf(stderr, "test_try_register_region() 0-size fail %i\n", ret);
 		return T_EXIT_FAIL;
@@ -323,7 +318,7 @@ static int test_regions(void)
 	rd.size = 4096;
 
 	mr.region_uptr = 0;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (!ret) {
 		fprintf(stderr, "test_try_register_region() NULL region %i\n", ret);
 		return T_EXIT_FAIL;
@@ -331,14 +326,14 @@ static int test_regions(void)
 	mr.region_uptr = (__u64)(unsigned long)&rd;
 
 	rd.user_addr += 16;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (!ret) {
 		fprintf(stderr, "test_try_register_region() misaligned region %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
 	rd.user_addr = 0x1000;
-	ret = test_try_register_region(&mr, true, false);
+	ret = test_try_register_region(&mr, true);
 	if (!ret) {
 		fprintf(stderr, "test_try_register_region() bogus uptr %i\n", ret);
 		return T_EXIT_FAIL;
-- 
2.46.0


