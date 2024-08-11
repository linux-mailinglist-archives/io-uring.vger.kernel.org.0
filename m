Return-Path: <io-uring+bounces-2693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B7F94E3A9
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 00:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79EB81F21F5D
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 22:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727E7160796;
	Sun, 11 Aug 2024 22:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="pXNV2Erl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8913BC8E9
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 22:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723415249; cv=none; b=HIeu+AoEvanIvD+SydHafXXOQywdxBacofetG3lDIJrEtLWVkonOZXd1WuVAMvh565NZzzH7BE8SSDhdRJ24/7NJYr8sePEF32f31yhzIN6qfZnA643awm6UK6hKpQ5U1Vb4ynbAujBSQq2pBm1XutcjEtFOwteeDySeQHq3jP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723415249; c=relaxed/simple;
	bh=SzyJrnQp8Uz830lPa3hcN4gxoi7JSiSAYiOGEnSLnIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TSdJiWbp2Ko4FzbGXbKczcw6tlkC5jDBZcdEHkbGIkYJocqp2EIqktPLuvoKsBPDt3csZgUZ4UXhQWgCYGGObKG26xkH5RPLWliNtLS7m3/RrNlY/olkwF8mQq58kCP1xkPWdVpcoxsW2jrPBanCv1sD+30W01Xun0lc6ZPQsxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=pXNV2Erl; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a7a8caef11fso419430266b.0
        for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 15:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1723415245; x=1724020045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e4Zac+A5KLRIfYXaRReKZx0UGyVecnM7nQMC/JMtMM8=;
        b=pXNV2Erlq6D6aOXOF89sa94GVEfnnzb7eC/BsvlR7N3HYLINXPVZ0JvY3+K9p0vRcR
         72VTOgjvo2pGDOA34MZ8vFWJlJETQXtD9AZhNeci6e0M7tK0hzSjFTjledfvORL7KuZC
         pevm0IUE9wXHAA6scPwJiGCCwdwwEDHHBKxm8OhzyIUHzlwEpYwSGBHnsYUBQq8xSw5y
         9giEFUzSjKFrOfCNYIE2vZKoQkp3cklYnilgi9Te3VH4w3cRbf+k3NlcIlVe2nw5/z0D
         wwob16L6g5DuhupjpxPfS/+TQMcEPG2615U0jb0e/8gn1uhZq2g1Cu3uc61Zq9UTcNO0
         EkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723415245; x=1724020045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4Zac+A5KLRIfYXaRReKZx0UGyVecnM7nQMC/JMtMM8=;
        b=FzpJXU1QbIKvPYeDQqipafxItAK9Cu1irUUTDOQVKXdLpa0so4887MM+/GIwpxhcXv
         FKOhqBJ/zWH68GnbFZpfToo9OixG+v0scd5BiOapx6xPR8zNmm8XfETVr8ShARu0+bul
         kj3dKKa9A88BkdPpP62KfsqwFBqbFampvzf7TJvG265z5X2JenDpxNcPH6gtlHrlUc/R
         XhzGnqtvqekOLR9RHaJ6vGeXPBxq4JKeK3KxDxp43N81Iz0DRUAUuTAkQjZb4kVf2Wm5
         /l/s9BRE3mZhYbeMPsMuSEgCZ9CYAX2ks/2NnMfTP1HwYfr7sjJOXnUczIU2W8CarruU
         F6Dg==
X-Gm-Message-State: AOJu0YxrlRHIbjkFrNt4t6yeJiDrCR82whSuhgCZuWHFt2NBJlVWaxAs
	zwFm0FFm+yqAtP+v/Z+Wa5o3kHv8XCaDfuScCwdGsGt0NnIAQyrPSx3Dlc0V8xE=
X-Google-Smtp-Source: AGHT+IFuRotOvb7NG9VaBxjLgw3eDaFGdEzAK/4EBQJP5b+w6dEHIXP2tg92tewHv2u6HT5+eJvTWw==
X-Received: by 2002:a17:906:d247:b0:a7a:b43e:86cf with SMTP id a640c23a62f3a-a80aa5a6dadmr522707266b.27.1723415244273;
        Sun, 11 Aug 2024 15:27:24 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-163.dynamic.mnet-online.de. [62.216.208.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80bb212e49sm174447566b.160.2024.08.11.15.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 15:27:23 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] io_uring/net: Remove unneeded if check in io_net_vec_assign()
Date: Mon, 12 Aug 2024 00:26:39 +0200
Message-ID: <20240811222638.24464-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kfree() already checks if its argument is NULL. Remove the unneeded if
check and fix the following Coccinelle/coccicheck warning reported by
ifnullfree.cocci:

  WARNING: NULL check before some freeing functions is not needed

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 io_uring/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d08abcca89cc..9f35f1eb54cb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -189,8 +189,7 @@ static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 	if (iov) {
 		req->flags |= REQ_F_NEED_CLEANUP;
 		kmsg->free_iov_nr = kmsg->msg.msg_iter.nr_segs;
-		if (kmsg->free_iov)
-			kfree(kmsg->free_iov);
+		kfree(kmsg->free_iov);
 		kmsg->free_iov = iov;
 	}
 	return 0;
-- 
2.46.0


