Return-Path: <io-uring+bounces-9814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A72B59A47
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3B7D1C06390
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90414324B01;
	Tue, 16 Sep 2025 14:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSQFTYUD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2857343D90
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032829; cv=none; b=qSS/06qxSdg/sl+Kd9E8tDLu4naCqTG87bCdSlp7suHbF+rVcLerdbp4ZpViwPJN/FxtFkgT6RJfQZVWlCAAH5aFHP3ssZCMNDQzla6zGoS8liq3qWgwOxr8j0Y/GJWcbahcFZjPi96MK153Xjgppx8S7Mx1l3iBREbOvGDM3I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032829; c=relaxed/simple;
	bh=cUSid0EW5cfwbBH9uLjPkg8AI3vwqBJjfSHdVa4+EX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOA5YyvF5uM7dWcyoku9dd9oGAiODUFEnk9NLDYv56ovu1WlFLxfLi0NxIKMHEdmCa8FS9qkTdl6cypMP1G+O3A73V0sQgFn7ByF3ZS7/XcpuerDTV4kk6sOFLQ8izak37xlkk8/Hz2M3AJxdAIuK7nrfQ9cjv7E8eJGNmxoJVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSQFTYUD; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45f29dd8490so26295825e9.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032825; x=1758637625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1L06yh/OTNiHz3+mKqDzw5e1CP8XgM5RXxq56yk0SE4=;
        b=FSQFTYUD6yBUq/tixOeI2XORjh87Th+AO/qov7ayKO3R+rLwPiRaSmV3zzRep9ix2J
         UWfWg/9uqTcw4QH87dfQKLyBrp07JPBkBOETLPfPLbEWy2Y2vMGYhYGgf1ayFK2pihPl
         8E2nvJsNTz1Q3jGy/h4mQip5ElPplIkNlIw5TFeWuDEWDYe3ysDoIxe1FzdSD2Zw4SAG
         BG0G+MAejFpdpw613lsCAhRatHYxiz7NyfIiSn3kDKmcq71vkVNZwxZI02QH5ZkjzR0W
         UezSjdSUfWFFRgVQj5unuBT2ejae1/EPCbdqWQvuDoxV0npMVRZ4FtdCkyI0Kf0hRqMg
         LgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032825; x=1758637625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1L06yh/OTNiHz3+mKqDzw5e1CP8XgM5RXxq56yk0SE4=;
        b=sQOwgkge5i5/W6QfX3n7IJmHts2T6kLtSCiMw8kAER30ejABcRqwWpQzLHLNZ5NMLs
         Mji/9js0FLkYz/w/NsNLmhek2rv9ZnPni7+qqh31bu1SwG+jsA9DPpCaWoQ+s3zy1FHe
         BzrGaY2z1pNs2Q9+psRTDyq2RqK7QMSPvGts0WzyjlC2fqhjsZTJ252c2w2uwusQJ5Eh
         AnuFgYvS3m+bCZIkmLOGJ0cD45LKsdca83f+TVNomZ1yKSezhcEm/+yzbP23YWiRmcmk
         DCMrS7UGKBFWpW3DTJlriPmNC57xsV+cPmY54WEZQjotj2YCEk+PTQpsmexpPVEfy1zA
         kE0Q==
X-Gm-Message-State: AOJu0YxBwcNnKNWSYIXBP3yxVUH50JsUq/OIyFdTAN6HJHTT1HFVAi6l
	7G4HCL6IeDKzHiWobpuWir2JM1KYoRzvYCmflBlgB65cFGGOEb4XP2buijJEcQ==
X-Gm-Gg: ASbGncuUJ5ZtKdw8XO7f2kZ2sx+dOH9KX1439AYGdz3+WBYcyaeCvpjX39isK/HByPc
	wWa9uMCbrxK7l2x9zkF4no8r8EH9ToFypFlBNAehNuEOwl2hzEuBh+LK9GfVHgyPSxKFInxg6SR
	9Cg2pw24D01BecP6FMprMk0mUPfcjqpNmpCnheocXmhgp8NhJjGFLVJy1JqruBPURlfPmVmEmlP
	T/RCzPpAM+B0Swzt5IHctnou7wq2w4Gbt6Oc86wxXj4kXmJsEJNfWlr0L6Ttn9pzKtb+QXgFSEi
	kNeO9KtvkpGGKZxtBauyztJsXZ+juVq+PKpHnBhrKxQKl9Q5KsOAs53SCSRhekGOFe7BzLdne8j
	jnrqN6w==
X-Google-Smtp-Source: AGHT+IFrov1iTD7XqwPqeAsMPpLI3rjri0/ecbeNkrusYT/gBZooV3OkL6Lk4TwOg3bjDrWKXuEt5w==
X-Received: by 2002:a05:600c:1d20:b0:45f:2b47:b06e with SMTP id 5b1f17b1804b1-45f2db8764cmr68373755e9.18.1758032825201;
        Tue, 16 Sep 2025 07:27:05 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 14/20] io_uring/zcrx: protect netdev with pp_lock
Date: Tue, 16 Sep 2025 15:27:57 +0100
Message-ID: <a1c84a5c5e357274566b63f0d7bfcbd6b839488e.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
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
index 0deb41b74b7c..6a5b6f32edc3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -476,7 +476,6 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
-	spin_lock_init(&ifq->lock);
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
 	return ifq;
@@ -484,12 +483,12 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
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
@@ -504,11 +503,11 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
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
index 3f89a34e5282..a48871b5adad 100644
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


