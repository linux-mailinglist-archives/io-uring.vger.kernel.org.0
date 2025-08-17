Return-Path: <io-uring+bounces-8995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCD8B29588
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D0B0202604
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FD722A7F2;
	Sun, 17 Aug 2025 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jz0QRlKj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F52253F2
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470567; cv=none; b=c1DrFyCsyXOPj5pyGRbwB/cs7SuOtZRDyGVql7hA42aVOMkdP1PsYDMnc9QHw8caIhqLsZx1N1d15klTfU0L3e+22NLVECV0gDtwd3A+UvcxYT0wzn1OdLP00QqyeR2WxnYP+WelJfM/cALlznKjjQEbtDfA0SbKiyBTaEDlTVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470567; c=relaxed/simple;
	bh=PgLfwAE8vqIlypS7HUgoNHj1vmFPyxOi8xK48gj/wqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAvOa2Zu+d+MG5pIuOFZItUjvikn3tCoDxSk6W954nSwWEZz0w489h2AimMmOviWrWfrLm6ekAr1wdXgys+sbrIcN7Y3G79tW+/nJqdfQBCW3lIVEkR3BzGGlbAPTcDhejt35LqGcQQ/h1HtGK8/QOTgnefwNCRMGHiJvtVLeMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jz0QRlKj; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0c8867so27656245e9.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470563; x=1756075363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Te+WLJsYgARQtzKoIXO12rlfWQ57LPGgUVwfMbPLNA=;
        b=Jz0QRlKjXBikvxsvdSns1QZyfMP/ljIDJsdrX2781cXAuETLDsGWXWcypYh8CF0T/G
         69AjzuoqJ23ADiSugc7dn7dzPQec18O2uSSZ+9g0G1pZeA5+YItR7/6PdZyE6pM9bVlQ
         o/roCNLnia2bPGzY/cEk2l5YMd9PdY/8fDvSDtDGODVjc3pOHt8EVKQ0eY7OFFvWu8GU
         5e7RmxuSXIua9/LpW+CCvUfw+NTHhWFnQyhF8rPzuCrrLIrRxde+mcdXY/+OGylP+/y2
         fGHVDm9+T10TbIVG4NRTY3isTigZUjROByssZfnVTNeDjDIX+vxB7qG5TJz82O3QM9F/
         2pHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470563; x=1756075363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Te+WLJsYgARQtzKoIXO12rlfWQ57LPGgUVwfMbPLNA=;
        b=n25beQ8hjn75lI832+8GozLexR40pqYX/0ZHuVaXOOkNeO5gArQCLxIXvAjX+rRF9J
         qSYHGzA43BGH0CN+0W8WE3zfahgbHlx6DtdGaIho6Xiz6KzkHx2f/kBQ+asCINENR1fB
         UYjHGxKjvWuljyaTNePO1T4Ycs9Jnef23zYV8z7sbWckYsT45/zeQIKifa2bEKYYejjX
         hiaIqzr2/fsrGHBv5TjYsekivJGY7RExvRMzM2iU4Fl8AABelcyOjSPApvK5+8ZvLVNS
         N+8sogjYRgQcroQFDY+vZErhZR+ITwIRklLNbl4XrSIxj8vGu1IxSa4jjl3lVhXsvOh0
         8+oA==
X-Gm-Message-State: AOJu0YyerP0QIzZGuNgAm6I7CKuBhL6fyE75JgM6EC3FT/OYdd6bg6yT
	HisQaLgOWvz87J0UHh6DStD1yGZMVpv59qT39uMVW3oXBY8crER8PLMi1nSqlQ==
X-Gm-Gg: ASbGnctuoV+cJsVpJdps768pVAj0sbEut6g8tig5pFE8EM7JXS4QKeBnlR/9kc+p4a8
	PVaH2/tllcfLZwLdjS1oLayWGIPaIEiPXf7CzId3vFOwmuvyNRms4TEVpwKPGOibIJtujREgEbZ
	PJCsSYH2WJxdOoqjfqNmSJxE+mit3JVa9X84cVltB1Ge4fGnP3pifhlTqg/LVGo/4rKEEkuyY1E
	YfFVREb6T+eOYAuuATYb/DU1Hv3Xt5CVn5E0zegdn/I0QH9padOWQONCCWdJDjeq1SpGe28yWDA
	geiz3OfEiPZp6oo1sq9mNtG2pTHi23i+IL+LnEpvk000Y+pPnr7fLENOH6JI9jpmW0YpBbScKRD
	1OamBI9zXz6btd4BjVsrarKfxpxyyhISgFg==
X-Google-Smtp-Source: AGHT+IEwE4XqcPifL7WbYWS3YGL6W1ZOTJN6LQ3MM4C7+s0JPZ4k81IiVwlEZ0Nad79eiG+prK/+4A==
X-Received: by 2002:a05:600c:1906:b0:459:d8c2:80b2 with SMTP id 5b1f17b1804b1-45a217f71b3mr59725095e9.7.1755470563138;
        Sun, 17 Aug 2025 15:42:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 05/10] io_uring/zcrx: protect netdev with pp_lock
Date: Sun, 17 Aug 2025 23:43:31 +0100
Message-ID: <0d01b34961c30cca51be8c0f35d7d69ef771ab4d.1755467432.git.asml.silence@gmail.com>
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

Remove ifq->lock and reuse pp_lock to protect the netdev pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 23 +++++++++++------------
 io_uring/zcrx.h |  1 -
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e664107221de..d8dd4624f8f8 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -469,7 +469,6 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
-	spin_lock_init(&ifq->lock);
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
 	return ifq;
@@ -477,12 +476,12 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_drop_netdev(struct io_zcrx_ifq *ifq)
 {
-	spin_lock(&ifq->lock);
-	if (ifq->netdev) {
-		netdev_put(ifq->netdev, &ifq->netdev_tracker);
-		ifq->netdev = NULL;
-	}
-	spin_unlock(&ifq->lock);
+	guard(mutex)(&ifq->pp_lock);
+
+	if (!ifq->netdev)
+		return;
+	netdev_put(ifq->netdev, &ifq->netdev_tracker);
+	ifq->netdev = NULL;
 }
 
 static void io_close_queue(struct io_zcrx_ifq *ifq)
@@ -497,11 +496,11 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 	if (ifq->if_rxq == -1)
 		return;
 
-	spin_lock(&ifq->lock);
-	netdev = ifq->netdev;
-	netdev_tracker = ifq->netdev_tracker;
-	ifq->netdev = NULL;
-	spin_unlock(&ifq->lock);
+	scoped_guard(mutex, &ifq->pp_lock) {
+		netdev = ifq->netdev;
+		netdev_tracker = ifq->netdev_tracker;
+		ifq->netdev = NULL;
+	}
 
 	if (netdev) {
 		net_mp_close_rxq(netdev, ifq->if_rxq, &p);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 479dd4b5c1d2..f6a9ecf3e08a 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -53,7 +53,6 @@ struct io_zcrx_ifq {
 	struct device			*dev;
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
-	spinlock_t			lock;
 
 	/*
 	 * Page pool and net configuration lock, can be taken deeper in the
-- 
2.49.0


