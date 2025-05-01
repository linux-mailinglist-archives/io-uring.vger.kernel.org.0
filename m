Return-Path: <io-uring+bounces-7800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5678CAA5E35
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 14:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DBA59A150E
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 12:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB374235078;
	Thu,  1 May 2025 12:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtPp/z0o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BFC22A813;
	Thu,  1 May 2025 12:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101801; cv=none; b=UvK3l65RfsTGvvEx5az5FATlcoQJa06vegEnreKFJXCegjIUxkLwlZmQCQhvkuBYsmSdBqMrI2qhP3TY1f2W5MBfS52HaenVqDWbC5HSPlPvinkZBrk21cru1OkqJDpXRgw6lqKVA0v83Eq/TC9bm1N3Bm4iGG0aYez3MsnxjyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101801; c=relaxed/simple;
	bh=99Lzy9SRLURn7c7ASQCW5N7d41d7JpvKM3dq6OU+kRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nne/O49D9bnEqFtO0bkXnjxWl8/QTgSxpQ25QOU3ZAf8mbKY0w5tO7plCIMcRHIsFpgcg2zsdpq//rQ0lq79cBy9tXwzmi8/+H20/Gy7tF3Ho6gb9bmJerZCITOWaJZ8JG5To+zXU6bZDxgjt1hO+GJM7gT2XZ5BgfHZeXZgvXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtPp/z0o; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac29fd22163so136560266b.3;
        Thu, 01 May 2025 05:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746101798; x=1746706598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ljO6O6G/GYbAZOA8bgwL88NiKJk62ypN6MvRRgvroQ=;
        b=VtPp/z0oYob/70yvoSfXhdtbMj+SJMU6RK+rsx2SO6ROFwFLzd7cUqd/RO0YACjlij
         Qo/dh6QCPOC0HFyxDHjUY34tbQYCK1AJX8EgQCHrq0VfeMvK+N6GDiL9sq5S6vwKAvhT
         JK6ME5rJ8rmolL26HCD8wcG8eqheFXP3LQMvDyNfCP/V6GnnMDo5zDYthvrOlAoCC2iM
         ms/rRJwn4HQOYxZF9KB+Zy6ZBkOuDHaNW+a28xgxfme6JbIdmKP1N0ELb626EeOqEnUi
         o/79Pgxq02uta45avmX0aBBH2hrdfXe3BiJ/0K9cpjMR8F/YCJC+qM9bfhzHmUc+cQ83
         ziaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746101798; x=1746706598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ljO6O6G/GYbAZOA8bgwL88NiKJk62ypN6MvRRgvroQ=;
        b=puyUOG0T6k4m19QzLxB+3VCJ6gRrkHu/uXQ6VuCp7mbUOpewnFUY89GMBz+3d0PVFL
         /DRcaED95lsc8XMFiMSTCo63m7bLe75HxZ6rmaqvS5GPpzVzbXpOE0FkR13MzIJ/vKhz
         4Mxw02TpSAzoDEKNfaZzRqhQB4d+6IMJNSqQ2s0fw+M64IHphYMKkoU1WO3jzjOrQC5e
         HNaktGSGX3huyhCAt4xME0VEGarO3tWPhuJODvQdCG51fRJfr9DJ0MDFaiQwDbP6/a3/
         t1eUd2T+ZnlYK0/DkBFlPBT7uZ/WMr5t38If0kZnPqeEiSL5JT+s5j3/EeirqzNIqxuZ
         RUsw==
X-Forwarded-Encrypted: i=1; AJvYcCXm4YwXAJgHYUkduwwHbImoiHwDkEdmCiaZfJhhzrp4CyMxjPRBUzh+ljkE6oXdzeetSFm5qPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzogp3KF89mLkD+vwjYFGfPnrLP2frK5qK8wrNOBX/+nikleSS3
	nJLh7xNBEC7vYbqzX84GQi+sLAxaEIPHCyvkSNEXMQStAvsYLf6HgthlfA==
X-Gm-Gg: ASbGncuCrchHv2JpeF4IsfMcSDskWkFBMd7zXCn9UnVFiVE/Ueg/yJPxzYk9bzDQ7Hv
	WkFfQVyNijGCYGObgqFaFoS7FF1X9bFeqAe7MTBusJhXDRnETuK0PPpbZWX65tisqVbvCsKnSat
	yxCoFwk8rLYkBwKOku+FSa9SOG4Jq+fHA79feWw8U2EjjUbNUUlK/05su2WQMojNG7MDnZvrT6R
	feUn+RhLSSAuA+g3xaxllFUeNQB31m/Q3HtIBCpCKJUmv2WvOsRiwmJv4UustD67g7kRO+47Rso
	3ExqEAX6PWNu+d3P/M54/e9k
X-Google-Smtp-Source: AGHT+IF+zwJkE2ref0S5VsiHzU32lGDNrARgWzK7aW72KrO+1EJrGr0af9gYMbKq53z+ojOyE1WmhQ==
X-Received: by 2002:a17:907:d02:b0:ac3:bf36:80e2 with SMTP id a640c23a62f3a-acefbb181abmr258961066b.20.1746101797568;
        Thu, 01 May 2025 05:16:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9c32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f930010655sm346146a12.73.2025.05.01.05.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 05:16:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	netdev@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH io_uring 2/5] io_uring/zcrx: resolve netdev before area creation
Date: Thu,  1 May 2025 13:17:15 +0100
Message-ID: <ac8c1482be22acfe9ca788d2c3ce31b7451ce488.1746097431.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746097431.git.asml.silence@gmail.com>
References: <cover.1746097431.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some area types will require a valid struct device to be created, so
resolve netdev and struct device before creating an area.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5e918587fdc5..b5335dd4f5b1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -395,6 +395,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+	ifq->rq_entries = reg.rq_entries;
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
 		/* preallocate id */
@@ -407,24 +408,24 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
-	ret = io_zcrx_create_area(ifq, &ifq->area, &area);
-	if (ret)
-		goto err;
-
-	ifq->rq_entries = reg.rq_entries;
-
-	ret = -ENODEV;
 	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
 					  &ifq->netdev_tracker, GFP_KERNEL);
-	if (!ifq->netdev)
+	if (!ifq->netdev) {
+		ret = -ENODEV;
 		goto err;
+	}
 
 	ifq->dev = ifq->netdev->dev.parent;
-	ret = -EOPNOTSUPP;
-	if (!ifq->dev)
+	if (!ifq->dev) {
+		ret = -EOPNOTSUPP;
 		goto err;
+	}
 	get_device(ifq->dev);
 
+	ret = io_zcrx_create_area(ifq, &ifq->area, &area);
+	if (ret)
+		goto err;
+
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
 	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
-- 
2.48.1


