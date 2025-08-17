Return-Path: <io-uring+bounces-8994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC21B29585
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD214202661
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A58721D3E4;
	Sun, 17 Aug 2025 22:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iONOzHPn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D6A2253F2
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470564; cv=none; b=BwkAbezuUk0GALiyQXQCvqPMK6Nh2NsTdHm/2yTy+pg9ikDSxnuPRN5+f1qNBSAT+EAXTccUQQipTL0CRbNsy6HZ25mNYci1/hxB3z3RVsp09RTrYftFnsRzjGB3LfXergs/sbvK9/EF7C76H53yTy3wezZwG9MuNMr4Cb2b7FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470564; c=relaxed/simple;
	bh=zgbjvqWRh7UJTgzhMrPYl0ZZXPJcnjb1N1/8LLqAoDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJGm9lrnvO26sKP4ykPG6lFeKQYI6T9pd7WCOZ2GtMa5uvL6e/Xhjvfx9ZdZAZFMQZPXyfw7GgKRMD71zHFZ3uDqkIN/9AsklSE8x1M1Nbqhe+RORYGBf5sIdXl3Q4INPAmcCKMo5R8J0hyIbLysfQfuB8yBVfXuY9Mdq3nMm3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iONOzHPn; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3bb2fb3a436so1860262f8f.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470561; x=1756075361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQZ19/urDWJp7/+PR7iChkdCw65sUJQ2G7yUsyYRQf4=;
        b=iONOzHPnsWX85G9AXIeqqUxU41Ike4hz+FxyU2Lekl8QxdxRS0zXdwKJ8fqZ3nGOOW
         p9crjfJ4QlDwqmaVmWCxS0hkP/XYS+YPajMWl7H/xLaXEDTpzlweP3KslHKVG3FhKkXa
         67pEQ+ClbqSlUzwVEKy26PkAKiqpFVfPGm30KSWYAE/uCyQjlyx96Uk4Cit2VFhzxDyQ
         AQ0cb5wly0sJ1y7ndqJAOaqCNLlLM8XRiquEJUkzq7ecNnFUgPlcbWGMw+Te8yFieMUF
         yUz/xu+J6/Vs6oJEL8jMd/v8xQN+kVdI/+WqSyAoCGW7wjG/U+UNMQwmpuDlKT44/RYU
         5hLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470561; x=1756075361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQZ19/urDWJp7/+PR7iChkdCw65sUJQ2G7yUsyYRQf4=;
        b=dta0VgV/jzi0+SrMFS7TDnv75jpdSUyoxFywrHM79rQuQnCkxnTDpq3nKymJlumZiI
         8w1mM2RfQbrWwX9JHx4EsoOCKDBInj8eehv71SkFF5AzzsQFxJJ+S5uPmIzaW6AvfNEv
         jqNMErmzofEaaHHoK6j5srEaYVN9C3D8qBGfU8U0RfNvhjZh5NQEqsv22GGi6p2wkd66
         P8uUJxwh3etlXg1XtqWA4C/BucjOv2XEpmaPzK8QJeVCvNRB6wSzqrtQkZNDxPoOwZiF
         wpx7084HdT1IBn2p/4nRFcH4a2N7pHDQOfSpvplvMYfaTyBmlMr8fzQ14bq7F1nT0gB8
         iw9w==
X-Gm-Message-State: AOJu0YzufToSW06r3bf3WDBC3MjOlZY8AOtJ5oiuAIdQIdAOUn+zPHej
	YkacgxhzIkQsMJlWxyAXXNameZANxmoELHOE71Uujq+uxcYwJM9+LkjorlYr1A==
X-Gm-Gg: ASbGnctspfLE59P5QdPCwqtdYLRmub6ITACuQXEBgRSP4Ct6QpcUvywpWZAyeBXc+On
	GjZ0Ok+0k1Uz9yzms6Sr3UQaHLtB8mnUyl+cVDwGI52zW6RIOo4H9qMAlkspGdpnBgO5WQfbHIG
	eCo8KUIe5akdmo5D8lz/uGVVswnNVZzagc9RzlyhYZLLAISOdpxnfpwAm1TxZmWwe0g7LflUu8G
	vm+BhlHgfLsaWWzrjcMeIcfrQRJ+ZaxyUn7KgkvMBfJEEODtBLPM07giYIswYiMm6Tywm2MtVYg
	1ps68poc+KUCO7rPyeKap/QBhOgR6dgf5j4YoidyrwEcVRhV5e16sm1ofGgZwd127ZAG8oOXw5t
	GgSVPG346OvdhDXoJCpMcTTtpANy9xRqU1MtnUO+mKR/q
X-Google-Smtp-Source: AGHT+IEIuIH+SgJn7b5ZupQ4Jt79QpgoFMbKlVjNiOChpIvx1CWpZlDs3rzsPnmfGOrgVwoK/iW+QA==
X-Received: by 2002:a05:6000:310f:b0:3b7:94c3:277d with SMTP id ffacd0b85a97d-3bc684d7ba4mr5027688f8f.20.1755470560638;
        Sun, 17 Aug 2025 15:42:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 04/10] io_uring/zcrx: rename dma lock
Date: Sun, 17 Aug 2025 23:43:30 +0100
Message-ID: <9c42c9bb492b6512b7ee5abcd4413e0b6107529a.1755467432.git.asml.silence@gmail.com>
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

In preparation for reusing the lock for other purposes, rename it to
"pp_lock". As before, it can be taken deeper inside the networking stack
by page pool, and so the syscall io_uring must avoid holding it while
doing queue reconfiguration or anything that can result in immediate pp
init/destruction.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 8 ++++----
 io_uring/zcrx.h | 7 ++++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ba0c51feb126..e664107221de 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -247,7 +247,7 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 {
 	int i;
 
-	guard(mutex)(&ifq->dma_lock);
+	guard(mutex)(&ifq->pp_lock);
 	if (!area->is_mapped)
 		return;
 	area->is_mapped = false;
@@ -278,7 +278,7 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
 	int ret;
 
-	guard(mutex)(&ifq->dma_lock);
+	guard(mutex)(&ifq->pp_lock);
 	if (area->is_mapped)
 		return 0;
 
@@ -471,7 +471,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 	ifq->ctx = ctx;
 	spin_lock_init(&ifq->lock);
 	spin_lock_init(&ifq->rq_lock);
-	mutex_init(&ifq->dma_lock);
+	mutex_init(&ifq->pp_lock);
 	return ifq;
 }
 
@@ -520,7 +520,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 		put_device(ifq->dev);
 
 	io_free_rbuf_ring(ifq);
-	mutex_destroy(&ifq->dma_lock);
+	mutex_destroy(&ifq->pp_lock);
 	kfree(ifq);
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 109c4ca36434..479dd4b5c1d2 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -54,7 +54,12 @@ struct io_zcrx_ifq {
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
 	spinlock_t			lock;
-	struct mutex			dma_lock;
+
+	/*
+	 * Page pool and net configuration lock, can be taken deeper in the
+	 * net stack.
+	 */
+	struct mutex			pp_lock;
 	struct io_mapped_region		region;
 };
 
-- 
2.49.0


