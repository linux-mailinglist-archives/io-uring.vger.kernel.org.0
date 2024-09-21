Return-Path: <io-uring+bounces-3248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB6297DC0D
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AF6A1F21AF2
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BDC153837;
	Sat, 21 Sep 2024 08:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hvD1wfLv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A67E5FEE4
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905807; cv=none; b=k2V9rWWFJRMS96VhI2kStoptkpjRijrseZkzdjD9oP+hia/48TU+2gfWcrpiq+9k05EI+TIfkRgqHmKm4qzF9WVGkctPJb8THpv5tvJ1LnL48FhwTUBGXfpxCGQqrf+msHOREuj/8Ya4JLz24nPo+p8IzEd+kXHvQ+Q4KZ+We2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905807; c=relaxed/simple;
	bh=mkYEMFNjtOptKYoRJNvnM32o18ZZzOs47rd0niUTsd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elPlOxo/ctJM7o5zxmwCXs/geUWXM2TF3fVlcUAnzs92njWKiJtfKM9RQjL0tWoFTkuiOu6k2u8VRT6DeyWEx3Y3sYxN/RQ2E1LLIVwA8lqHQ5fVdr91cfK6nr7R6ZypDKNXyM5q1DVMppGFknrS4h2PxG0qE6mBafMD/mKgNoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hvD1wfLv; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c4226a5af8so3545759a12.1
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905798; x=1727510598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIHhoqouWr+1bAg94n+0B587yCzWhD+Td/cRRJvC/8w=;
        b=hvD1wfLvaF5J/Z/Z9AB4rI+gniS7hxN/fHliHhnhMCBlixvajSwaTWqALatdNzPf0g
         wuMcbHFvcBNrKmQphMXjkMdHbE/+85xGjPDMPPgOjLrj/1z3tKOEUr1E0kBpJ+u5IEnO
         MInuySr/p2vfvY9VRnqiekATCxH2MTiX6pq44/negaypRaMBIFjsLzSSy16hqPoEaPX2
         6A88iLYbTIGp8Ir2EzGjlWnhX4i5eJdkIQqk3WFspFAcJ+gpA9yVqjca7rHoaNdWyP3e
         hwXe/H7uvoui9MiNDe++Ck+BO10mpuloDKbcS7caIxhOZ3o18GNmCMD/U60XWtH2PIzO
         9JDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905798; x=1727510598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIHhoqouWr+1bAg94n+0B587yCzWhD+Td/cRRJvC/8w=;
        b=t5UVnJaz7yxggT7H1rypCJm6V2uvecQeEIpY/4EJI0qUIlSo9yBSvGgFFqEPr38boN
         Xil5bonHp6JWLksEBuGLR93bOTmYH7FD+DRgBrCj9xJ0PROpy0p98lWY57+6cBtt17tS
         EMPjiSfgF4TL83SzbnP4mlcZcmuOzgThmre/YQs4A0HUL52AW3KUS0OeyoNoLHJ6dZ31
         9woHCKViwMsmJAxZODToc2vYakk1x/SlSmSI+bCWLNLTeFFy7oAR0wf2p4+w3CTOaP2d
         7DgcMy9yfBjUYVHU86/TOqFrPWSL/69qcXyLu0FttUENPGiMAlV8h9btE7H/2ohMO8of
         OxwQ==
X-Gm-Message-State: AOJu0YxeXnHN4F9v322m9QeYLVthFylq3yvRIKu7DDEH8HIZCpXUw0/l
	G10F+mXjxYwjijb/PqEOTNl2e9EiU6K9bH9tLYYZdJKULQ/Eg8DpBzBi85qT5jzmw/yk2R99+7j
	sQBaSs87j
X-Google-Smtp-Source: AGHT+IFjq8fOMIwbl38YMkQFNV44p+Rt1w1qaz3mR8NEO8lZ/wNsI1kUqn6YSz5W85yBLulYvEErcg==
X-Received: by 2002:a17:907:6ea2:b0:a7a:ab8a:38f with SMTP id a640c23a62f3a-a90d510bed7mr595430666b.41.1726905798509;
        Sat, 21 Sep 2024 01:03:18 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring/eventfd: abstract out ev_fd put helper
Date: Sat, 21 Sep 2024 01:59:47 -0600
Message-ID: <20240921080307.185186-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We call this in two spot, have a helper for it. In preparation for
extending this part.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index e37fddd5d9ce..8b628ab6bbff 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -41,6 +41,12 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 		io_eventfd_free(rcu);
 }
 
+static void io_eventfd_put(struct io_ev_fd *ev_fd)
+{
+	if (refcount_dec_and_test(&ev_fd->refs))
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
+}
+
 void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd = NULL;
@@ -77,8 +83,7 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 		}
 	}
 out:
-	if (refcount_dec_and_test(&ev_fd->refs))
-		call_rcu(&ev_fd->rcu, io_eventfd_free);
+	io_eventfd_put(ev_fd);
 }
 
 void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
@@ -152,8 +157,7 @@ int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	if (ev_fd) {
 		ctx->has_evfd = false;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
-		if (refcount_dec_and_test(&ev_fd->refs))
-			call_rcu(&ev_fd->rcu, io_eventfd_free);
+		io_eventfd_put(ev_fd);
 		return 0;
 	}
 
-- 
2.45.2


