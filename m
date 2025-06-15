Return-Path: <io-uring+bounces-8347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A637EADA297
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 18:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E2916B2AD
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 16:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD5D25F979;
	Sun, 15 Jun 2025 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFSiZbA/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A8713B5B3;
	Sun, 15 Jun 2025 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750005555; cv=none; b=c3RfsV/aSjdWNvVyf3txEiU0V5vgu0vEutFFygss27P+Qi68DFgmKnuXvafu2442TqytwtVWurFUN6O1q6D3vmMTlEW/Bz4E4zhDK7O0Xf68xiuyDHLLEUr35mS8KmXxRIfJLoiiS+yOtoDbZ0wqDdRdifgIvdSqlEnD3J4+lT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750005555; c=relaxed/simple;
	bh=GK0jzvLSit00bW/3EYnb7wXg+pv6N9OjVA7Bns8y3fQ=;
	h=From:To:Cc:Subject:Date:Message-Id; b=bUg+4WXapDEfU2brI7+Pdk9j/yGhKBMNUUxVEqML16vKIFKIC+37U+Wh5aX9cefQ6qAuR/sVJVF3CZtQ8upDj//6gc+yLsIz7hLghq7o93AoUKQSmMft7ynXKDRmSfcuheI051EOKMYx5ksB9I8bWPk02/MA51udkwLxv6lQpFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFSiZbA/; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3134c67a173so4222956a91.1;
        Sun, 15 Jun 2025 09:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750005553; x=1750610353; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZBAMogNz4ko4MNKtThLToU4GYVVb482Gm5l6Ugs708=;
        b=lFSiZbA/5UzhagzITENbUS2zIwnVb6VFBTP9jozu7FsSsU+KwE4fziap5rqkPCkZwB
         sYdlHKMA53StaduvfJyrvWoqyI48qC1pi1mbZ/AoHVeD8ztvWJRu7M3K81lXrDYP0n8C
         a3+FdIVuVuh1x/ch7noVhb6SUFb+exldr8U7fX5fwQmfGk1EIJIkcOqKNZ+gn4glzo9s
         kA26rAJtD/cn5M7bq3EfZQkwyyjF0jv6F/cGP4X5ybIzR2RDzOP443mqQD9vUSefToQW
         iI6WnVA9Z+eVU5B8yH2r+ku+6FKMx6EAy2PGRmJwldRu8q4ZRTS0WX7/25pRc9Nds38E
         H1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750005553; x=1750610353;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZBAMogNz4ko4MNKtThLToU4GYVVb482Gm5l6Ugs708=;
        b=M0YPYX8LaBTLDg6Zc4lI915Uj7iwahcANg9fMwtrG8ZwIpYopoP7j8RHjVpLc2Gt+z
         q9xAiFBBwxMGLhRl99ZFm3F3turL0g4HW5pp5AEiOK7B05SnJX4QJyVxd7kQWQVM9sst
         SyP4JrQ3Y3FrMWTPSGd9P3deNpaFP3F8wTB7XUNs1tXI0xxR+O2sfJ1n5Ca+bcdO9fPp
         sRMEX+g+nWF9xCycn0ouU3USLHaQaI2U6gqdKv1QVZ5yLXcESRdBPLlTGzsASZ7vCzFi
         MR4iEUCz4EHWWkYL0i+eMkyVnSpisFjf4/jrZOr6ZCODBF/SKk/L9CLRwPbWqgsW80VO
         6Ksw==
X-Forwarded-Encrypted: i=1; AJvYcCXB1xbQfGjoVgnkRtmAQ3Xq+ncaImN4AjVDYCQkpLJN4uxLg7BFA6iNIHVO1XMUR7Hh38+PAi6u9EE/0wk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmY/VDfjtpAbhIL2aZD6rrrc5kCbXk7yPPirRic27Cf4EGOewQ
	C0OU1ibGCARGDweRPwB2sYSKI18VRpi3ABKc4rouxN6wpi78icUrOu7U
X-Gm-Gg: ASbGncu5GVaOrjZi7o9g7Ae09zbEEQTnP3Ar1AfgmrzduRU3wCNPdoJt/6Z7Qzn1Ux8
	WvnMihISBKmdzub62JE8hJZcYXZ9xHql9N2D8ZEnPs5SWwm8yO5X0Myb9STspn61oPJckAvDafo
	Vixd+u6ESweTbUaSVDb12xN9Xnlbk3a/ExVQrlL3/tTzyQ1oYQpL5v0WUMbl+/QYABXjyrqkYrx
	xyt85i7PgIywiQVC1oRHWTqObHkMI6lxiclee6CFfy3IL8tyVu28noW1KSll6toTCYDesBVM00x
	vscRGIO/Qt6Sfw5ytdFwZ5+E0MpUmqe3EpLhPCeckCWsQmBwqWZ8xWjoO95GqA8iAzuWeW+iaUy
	0uPs82WU=
X-Google-Smtp-Source: AGHT+IG33NHllH9NHfk5VE6wMn8kpLXKQbrwTfekdbkuaTq2eHIydpa7Z3b1UgsRYvS4qDCEwKtsSQ==
X-Received: by 2002:a17:90b:48cc:b0:311:a4d6:30f8 with SMTP id 98e67ed59e1d1-313f1c098b9mr9406216a91.13.1750005553528;
        Sun, 15 Jun 2025 09:39:13 -0700 (PDT)
Received: from ubuntu.localdomain ([39.86.156.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d8a1fafsm46242775ad.70.2025.06.15.09.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jun 2025 09:39:12 -0700 (PDT)
From: Penglei Jiang <superman.xpt@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Penglei Jiang <superman.xpt@gmail.com>
Subject: [PATCH] io_uring: fix task leak issue in io_wq_create()
Date: Sun, 15 Jun 2025 09:39:06 -0700
Message-Id: <20250615163906.2367-1-superman.xpt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Add missing put_task_struct() in the error path

Fixes: 0f8baa3c9802 ("io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
---
 io_uring/io-wq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index cd1fcb115739..be91edf34f01 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1259,8 +1259,10 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
 	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	if (ret)
+	if (ret) {
+		put_task_struct(wq->task);
 		goto err;
+	}
 
 	return wq;
 err:
-- 
2.17.1


