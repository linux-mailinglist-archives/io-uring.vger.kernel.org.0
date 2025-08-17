Return-Path: <io-uring+bounces-8992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC04BB29583
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D88F189A24D
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB5C22ACEF;
	Sun, 17 Aug 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjJkq742"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677322ACE3
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470561; cv=none; b=ksy5VhUgcZmTk6nUEOAqX/Lcnk/kwduYcQqA/z6ElOdHo5ayGmR2HsPxr78ehYRuxlaQPbDzuBY9ZGvukdCfZO0YXmeKKSP2Cui1cccZmTE4e6lYL6Y3GlTN3pO+FNUGT4W9kM3/S0DGdX2M24aBbILB9FqHI/JUxzcO50AeuPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470561; c=relaxed/simple;
	bh=XvNZxWZyXZiapIq5X0hRqYvuq6Cho/2Jg60cT0jbTOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khY2f4ChrwojNsiOtR2urzI3eLDVc3+MFUTFsMCjXrc8sFANZFgzQoXlEwe/LhK9Ucqkq1eriibzFTysyo0a7hPD0+k0LWVKvUxmmzCtKVqlZNyZS6Q+FajNFzV7k10x5KGuJcpCV6VjwHJrstnxcSIkNRrqm1skfH1KtycsdA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjJkq742; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b0d224dso17028645e9.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470558; x=1756075358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXrAKho8kFCq782RpfSntgSza435kpL8+HPawAWzujo=;
        b=AjJkq742TERvaMx6+QMQEs2uN5oPvAffjo6TTHqrZ058cBC72lBtb0RxdGTujp1c/b
         GYqRtkfdKxnRmigtuQCmLU/PJWcESm7KlLXSnlQ7p9nG3YHrIYOrxsWSerW+Vim1gTsb
         Xrp5/2e2i9ixyKZOy5q5AgcnBB7knlZuh+ez0NlN/Dmrb9RCYOgDKDHFOce/Q2jkyaHY
         cOVfv5p694n7dOQFiblbyS0PwAklAc9jiw9iN/577IN8jhd0X5E6vUqFa+i55shJbTC0
         R2CnjlHdRSwKRpotMAtF0Ck8xgnCZEh5R9YStR1F43d/Bvll2A7TYJybBpYH1mSGvcaO
         PYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470558; x=1756075358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aXrAKho8kFCq782RpfSntgSza435kpL8+HPawAWzujo=;
        b=XHlv4XtfcMAI6csJBMxX5ya1uVVgqhwqD93XPmh4/aNJG1J584Z9wwZ+w9qbWENLH2
         c2RbeOoCDfmrh4jdaFxFsP5KcgL795uJIXiEMlYy8N0ZgvHSegVzxoNm3seiiX+RtWMS
         ewtq5GyDA4IyE6c7nUjS/xipx9M6c0tuWQFsMKIT97Zh81J+xS4MaxGKM4YMCoCO/C/C
         aKtHGLrsPPHd7mVdLoAuSS0U0BbfjsecE2a2GTgRbw+hf2/C2K16EUBQ4MMDDbVpAm0A
         L+K40zrGoYASCMakdYYJZjcQ2Jxt4aNbzd2dwnmww/H9pO72lhhYR9HwIs/COCcDwoAQ
         Dy0Q==
X-Gm-Message-State: AOJu0Yxt1jGloJzuXT8QTXxCwU/8ZZ3I6CrMZJ4Yi+SGlBAstpxqFphB
	sTmKrKS1ed8jpRQKnGjVYDQ+dg4ruVXIZL12KAoHV6pgZJWkmzF+OTnKXFf6uw==
X-Gm-Gg: ASbGncstKfyvm8JG9FH1+i8oUn2nEZSh6DoGjXAjFp5ED7SPGMmftcirm++UMB2H2MB
	I88bY5zLxabMy0KzQczTO3oSp8V9yHoa/7FW7CYeoeN+aLVMPlei1SsSvztQ35sLafV4pCRcq8o
	iqswQSXddqGkapfz8WDhsY5mOSFDFNr0eIzbZwruyWyDulQQRlmnNvanXAeOns1u04owyJTv6iL
	TYjWCIZYSKjbGpiae7YlldWMbEhpR2cRdk3qLvRVwB9L2DBJan2PsvBeSZhLF93mWcw1pTNi7RF
	IsW5+qxZvAm/vriFkigeh2jkg/xCi2GHrAFuVeD0UHf7G0mxbCU/8iqlA6F84OMWQ1QFOeXDqLy
	gOQUqDttdLw0zX5+BydkqyqyDNJzaRaNkrg==
X-Google-Smtp-Source: AGHT+IGuwLZdHPGAtrDGILqtPd9nRi+IFoRw65fFBSNuaFhyVqAur3aiNOO0Mq9jE2PpHTyCV5FLDA==
X-Received: by 2002:a05:600c:3147:b0:459:443e:b177 with SMTP id 5b1f17b1804b1-45a21857a4bmr73748465e9.25.1755470558107;
        Sun, 17 Aug 2025 15:42:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 02/10] io_uring/zcrx: use page_pool_unref_and_test()
Date: Sun, 17 Aug 2025 23:43:28 +0100
Message-ID: <2f2335e7939e59518e1032ce502943cb97c2640b.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

page_pool_unref_and_test() tries to better follow usuall refcount
semantics, use it instead of page_pool_unref_netmem().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 66bede4f8f44..bd8b3ce7d589 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -785,7 +785,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 
 		netmem = net_iov_to_netmem(niov);
-		if (page_pool_unref_netmem(netmem, 1) != 0)
+		if (!page_pool_unref_and_test(netmem))
 			continue;
 
 		if (unlikely(niov->pp != pp)) {
-- 
2.49.0


