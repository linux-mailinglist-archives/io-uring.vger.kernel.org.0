Return-Path: <io-uring+bounces-6567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DB5A3C628
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 18:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6BC13B870D
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CC9214A6C;
	Wed, 19 Feb 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="enej1hDr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098F20E6F9
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985969; cv=none; b=X2qZQTxrlzib7x4x3VeMKyyDusT4Pr9kuNQQgehfEP9cEc8r70v1N8tkPvKLC9F+NytyMv/kjmnbOcWkcRSQhhMTcv5UK5nabDbpvIjLPn9mFTj5Z5SdlGhTwGXfxgyJoGGF+67L+cIJoapOI6smKfQAEiuNyGfEISY/UXn3XGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985969; c=relaxed/simple;
	bh=t9VFdL/JGSkI1kK+B8jwU1v2EPjZm47f8WEHapLZ7wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMbDk7deq9biu1UBC+3ZP9P5xwSPzYIxPYlMDvJNLwaq+lnOQeKlX8su89GYELxEbT4BgMY50MVag/DGZ0v4K5EBZoWpL8KqrgjncRxXW0vZn1vucsidd3KcRwzz2QTp1w7CBJOsS9ZUsny7ztaeiWUSbqJMwRejIKl/7/JcgRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=enej1hDr; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-855a7e3be0eso1084639f.1
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 09:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739985966; x=1740590766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1wj/NWWDbHBPUQsB02XJgoAK7FnxuSmVDgGIKejleZ4=;
        b=enej1hDrhmuIYdeMJy9bUwnuXUsVtUYDEenZZEF+QcABBK6YPAeQdNg+j7Liv4VfJX
         UwCTNtGWykuq1SpvuONFSwiddML7oRkhNELvDT3KM0WQ7DcYvejm7SHGjzw06OCs/pOF
         uXpNxrWzEd2lEVf+hM1HaRqnvtGe+F97FIWaU2G073LBJJSHgwgoI6FB6xHQhMddLb77
         WevOOj51aY2dT3S9GSVWQGJX7LT3d9DrkPgRVMRsviqWEixl3RcIF2jQ5dgxa6J3HWK9
         eLLK+MredZWWLudxj+bf7HVrS9tlBQmwbBmsfr++rLlCIVLW3AXfKP7u1JIUwsB3RUO2
         3g+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985966; x=1740590766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wj/NWWDbHBPUQsB02XJgoAK7FnxuSmVDgGIKejleZ4=;
        b=WfA6z+OSMENvTZW+Lpy4vXiZQO21r2ugXq2Py661ASbJGJ74cPzTNWbkjPYuH3ogA0
         ybnZsE9NSfvwKXNt8upD65krZKBB3GG23HgOSgO7XIp+xg/iYm2RqJ2dDAVLtJudvW1C
         g3P1n+0ZASkwPU77F9IsSBkDvEu+31F/BB95Ux9gauLNXy888J96XtkhD+DxKvOMGhVi
         c5/Gn7SIAKWhOc8OftJYqGffRyXJB38D3OGKB1s49HX++7TIa7OZM9YbXIRUNc4/TnVM
         zXA9xtZq0VVupnhH+E5I6sdGqswgQt7X6X4BxUE17P4ffnxmrdt/VGkIeupTx63HwMIM
         tmrg==
X-Gm-Message-State: AOJu0YysCyZy0sQb7zrmC30IWIEB5D5vFLjUwamA8cdT7p8NST0A3Dp4
	0802kCi2jkc6+3//5RwalTvvSll/MCj4NzV/Cv14lh8xv1X04xcE4VE+DHvj99zvITBQdz+jh2I
	L
X-Gm-Gg: ASbGncvecQUFzO/e/D5DSvFbL7A0uurQm/5Mx6CdApRPGUVDW2Z8jkHHcWSh+dXWwKl
	izXLGV9GzoIA0zRKqa3zoVmd/79LX1FB932AgdYDqYgH6OjRwlip5UazlqjD2YNmxNgW80050GI
	0Jr9j7kFLYNIgvBbG+ONv+w+/ojdVkbuTuC9TSVkkw4z+HF6lxMM0IuAnbBR7oQ67kX3j3QqHmq
	GZJisuqzTSO9DkLB/VWRk+EngzJBJAkhHEOu5KiOMne8rnv0iLkrFdUT3jg3g/OtbL1t8dA5gG0
	AvxAda+OiKzpbBSqAqw=
X-Google-Smtp-Source: AGHT+IFtaL9/XuB8qrh/MkYo4ESV+gFWdA1YcEjvsmOMak+8t8dipfJF4xY48fkZWILi3KWxQmI7cA==
X-Received: by 2002:a05:6602:6d8d:b0:855:b5fe:3fb7 with SMTP id ca18e2360f4ac-855b5fe4041mr283067439f.7.1739985966274;
        Wed, 19 Feb 2025 09:26:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8558f3ccdcesm142192839f.16.2025.02.19.09.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 09:26:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] eventpoll: abstract out ep_try_send_events() helper
Date: Wed, 19 Feb 2025 10:22:25 -0700
Message-ID: <20250219172552.1565603-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250219172552.1565603-1-axboe@kernel.dk>
References: <20250219172552.1565603-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for reusing this helper in another epoll setup helper,
abstract it out.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 565bf451df82..14466765b85d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1980,6 +1980,22 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 	return ret;
 }
 
+static int ep_try_send_events(struct eventpoll *ep,
+			      struct epoll_event __user *events, int maxevents)
+{
+	int res;
+
+	/*
+	 * Try to transfer events to user space. In case we get 0 events and
+	 * there's still timeout left over, we go trying again in search of
+	 * more luck.
+	 */
+	res = ep_send_events(ep, events, maxevents);
+	if (res > 0)
+		ep_suspend_napi_irqs(ep);
+	return res;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -2031,17 +2047,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 	while (1) {
 		if (eavail) {
-			/*
-			 * Try to transfer events to user space. In case we get
-			 * 0 events and there's still timeout left over, we go
-			 * trying again in search of more luck.
-			 */
-			res = ep_send_events(ep, events, maxevents);
-			if (res) {
-				if (res > 0)
-					ep_suspend_napi_irqs(ep);
+			res = ep_try_send_events(ep, events, maxevents);
+			if (res)
 				return res;
-			}
 		}
 
 		if (timed_out)
-- 
2.47.2


