Return-Path: <io-uring+bounces-8998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D757B2958B
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 249DA4E2680
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF3C21767C;
	Sun, 17 Aug 2025 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWPVzjcB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B382225779
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470571; cv=none; b=Jd97ZfCDrq0nxi2IGvcjuyvHSVqqjbgF9kmZBUVYg106ucTWXU7PCElGsxuWsE8/GApIwD+eqmDo0VKjhC7EB4EJbNDD0YfVe8079H4x5gDp/rMX99ii38kjkX7SNkTIwaEQTOEdFJ8J72uXsEg9tDT07ZUjyLNAsJipPTo0jHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470571; c=relaxed/simple;
	bh=k6QVkOgWFSlG8WqnGhp9DvxUyizMniZMPfGJztkts3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XL5isFSini19h5DovSH6PCYggC0+G3DZpQcLZ91J979cu2HPZ8eutiCN3qQzwol4+F+JdLxfngIhkwRmEx4lSrWcDazuGUWZlJhrSoGirmb3dEnbfqKBUIv3i4ngcRLYzv+yuS2atGDnPAlN5J7w94le69Zv8L9NxS95iigSuXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WWPVzjcB; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b04f8b5so16515275e9.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470567; x=1756075367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=del27qRgkryQ89WiWSA3KPupFB3otwVkY4WP7pXVyGU=;
        b=WWPVzjcBLJDHFY54GHsADJFLPyJoaWgj61CBk47uOZtcNZ8v46OlKTVzPH0F7uUHDK
         EEAxmk8ygZQ9yr0AtIwCB6pu7BuYivBsDQuBnovz5C/IClEFMUWO2nZRmBsAKFo6+GOR
         Ic+1l8KiRjImL6uJD/d75taSF1X07gcYfZXoReknjadsVu7Xosu1wQnupcekFphgV2vr
         0E9M2d/Rdvz7FhtpLol6+hy2UxWaPk1jwXj+rnvSvq8mcvNMNSluzwIMwUpc6jNArL0K
         BYzEDKi+k86zvKtjN/yF17ksTm3+x/1oln0MsZXwrflTrcz7eER6DIIjPgYCHK475Pdq
         kJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470567; x=1756075367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=del27qRgkryQ89WiWSA3KPupFB3otwVkY4WP7pXVyGU=;
        b=riMhQkjbVJCfO6apPVaYlTcBMtajA3oi4aFTTCKw8emmLWmMu6R7MHNf6pMhHfJ3da
         CPhEyEJluw594HJFP9VRKgpXPUBlXDEGidciL/NfPdG7n6EosAnGoH1Es2DKIod+ai6T
         g/zNok4YOhBEb83sLtOjzFWPEhFh7DKMG1u4Qo7HbGpUkFuho+9UmVwBTLtXlfDLq7oQ
         kxANv0d47bLDA825owNV0b8RlPYOv1UX1UBJ1YwlcO6G7qtWkLV7VIzsaFhJtAlDIH9E
         3DpVGaPXyYsO+nbC2exsJ9FWSx7zDCPIKPOrfKHy1G46pKO5XiRIrKvGUU2JNrrt+Qag
         X0ag==
X-Gm-Message-State: AOJu0YzBRYRq3j07N1apJ4He3tzITrS61zBYvDjcuHw5szaRfHLtCUfE
	PtZ0K80ncn3BgnG/FWABpiGW9rQX9nQ+8Gr6K40o8bk7/wFHQmHsbWwPO71e0Q==
X-Gm-Gg: ASbGncsvqtIQGAouZiDFO/zrwwFg4Jx5G1brUedUaUN+bF+leDiHwVJJaE3Y+7Pr4rq
	M7Hijja8rEN80Xt6OhstlkQJigLxeQjxl/AI+3sVz9FEJ7AoKM128ivNH7wm2dQp2W2WxzseZwJ
	/u1ajWijxm2o1jM+Zg6UeLWEpCu3G1avx8UmD7mWJeDJvIwtofkbgidam8QElqd8Ptzw+Cl3pcu
	JaakQzSE1CsuBxl2VXyOnE3NyEUnTYu84RM2ib+YChpv1Tbx09IZ6GYras+610DbvyKJZ7+XLYf
	qbrWlETHENotqofYB8tlt//6R5XS5YQUhJdK5Ak8gUVvOtopMaxy5049Pn0kEJqPDJlX7/KiWra
	fdMv3xHQjgPYQxMJzvbKCgrGeaolW7FpFzg==
X-Google-Smtp-Source: AGHT+IHpGVEVMzsooyGvaHktkCLRI2B7/wzIiqCACwgYdOjZgIgwNlF8ZwY6kWavDUqMcDJ9BJe1Iw==
X-Received: by 2002:a05:600c:4688:b0:458:a850:f857 with SMTP id 5b1f17b1804b1-45a2679e4b2mr48127495e9.31.1755470567198;
        Sun, 17 Aug 2025 15:42:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 08/10] io_uring/zcrx: use guards for the refill lock
Date: Sun, 17 Aug 2025 23:43:34 +0100
Message-ID: <031c6e99ffe8e636a4f4931867fc2513dd749dbf.1755467432.git.asml.silence@gmail.com>
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

Use guards for rq_lock in io_zcrx_ring_refill(), makes it a tad simpler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 44e6a0cb7916..a235ef2f852a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -736,14 +736,12 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 	unsigned int mask = ifq->rq_entries - 1;
 	unsigned int entries;
 
-	spin_lock_bh(&ifq->rq_lock);
+	guard(spinlock_bh)(&ifq->rq_lock);
 
 	entries = io_zcrx_rqring_entries(ifq);
 	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
-	if (unlikely(!entries)) {
-		spin_unlock_bh(&ifq->rq_lock);
+	if (unlikely(!entries))
 		return;
-	}
 
 	do {
 		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
@@ -780,7 +778,6 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 	} while (--entries);
 
 	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
-	spin_unlock_bh(&ifq->rq_lock);
 }
 
 static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
-- 
2.49.0


