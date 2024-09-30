Return-Path: <io-uring+bounces-3339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4FA498AE97
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C363B210F8
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9011A0BD0;
	Mon, 30 Sep 2024 20:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I9mh+We2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6021373
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 20:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728829; cv=none; b=kPle+5cjANP5gch+eRDBZifUZBuNZXrKkVFFmzoh3XZDHusa11sMp2dpH2IleLhLSof8t4imVn2CR296PXmFLPq/+r9OkJzxUcvfhaAJVO90XR9YCTA/cZPIKEW6QWWYN4b983SUMPbOyBhueVBjzKcIs4xEang9Wdr7Xn0eQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728829; c=relaxed/simple;
	bh=t7dgvkj5xpodNXZOK/IWcfBh4eHIdO52KtvIie4ZSNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB2s5z/wrpPgy6DlVmwedYlE4gBa5wXmYne1s98n0MjtzfPoDiaXPyIGAAcHqqnR1jvsVV4DalAwYngpUDRe+kfIA6qKOTwSLD6LpBW9nxGuWZ184EZOrrX5jTnwJnTZAmtiN+BnLmOE79B+sZ7pOYTMM/36gx+vG7qL1kYmROE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I9mh+We2; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a274ef3bdeso18282935ab.2
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 13:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727728827; x=1728333627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NcT3xb4WXjYKAJLK56A3Ii5F4kRF9uFA+kKq+uCfFvE=;
        b=I9mh+We2Ygzh5xthAqdyEt/JRUDWWsKfext5PowHOm6hRMv4euTY7hAemhCPQsvs5t
         sMCJn+hnyLZNoEKrDsnjdNbzKwiLADvuCgoQFfuOX/focrydbuhrMLl/rnwHcyyUDPaE
         XZKTHycqxu8/F/sEnM8J5T4aNmxvl5wSyWuMRSDooX1skFsvdBn6Gaur1sbkUNRoQYZp
         SaZZr1dmgLIrgJUqLGk1+aMv5Zab6SVx5wAZgrp29M0c1qj+WFZLsXFpwv/0rTEGyLMy
         RZxp0CGtxhX+ManSZRRbMzzrBYPSskmh8Tjp/EgVPUsrOV5b7TKF1o1i87ltKQDjg8tk
         PLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727728827; x=1728333627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NcT3xb4WXjYKAJLK56A3Ii5F4kRF9uFA+kKq+uCfFvE=;
        b=xGnjfXrH0Y4zpHr7cZXelM3Nbjj6nc3LSqFAKIgy3q+YMDNcSaExxxf1RBm6hDZMhs
         PrB1TLdda7gJdzRQ10kFjm8mxWDPwo4UdMFOCDfa3RPrLpSC5LNXhUkFNzC3L0eTb1pQ
         xxL5O/TntqzzhROH6U38L984cUTyaORXBhP66ftLTXbdXNM5YpZAZOhod9103JLcrcPQ
         qnGo73nTQWyXIBElW44TICbu1WPX8mKrtctDcaxkPDI8nsYDV+d3DGrIS429Dg3FLdXV
         p2yY6e/m68ulxNsph2feKfazWYULz8c57OlSnAAD359fRBFCDSlR6+NNP2AMV2O9xbmT
         iyFw==
X-Gm-Message-State: AOJu0Yw/2GbBG5KO/3kx6pyPHiIO6DVu8WFmL1x/rROdgiu1W1cwp9Jo
	DPnFILahaz1t+gN3IjdA/HulnEdx515xebV9RqNuG2COpxfiVFKKf8zuQXZtvqS3bHCLAOgmU9i
	Npms=
X-Google-Smtp-Source: AGHT+IEDsWdTHs0dNRFVIsCUZWw3Q0C0rvMx42yAFswqcVebrlTTDIofheMHv/unA0f+CtEjsL6/Lw==
X-Received: by 2002:a05:6e02:2187:b0:3a1:a69f:9391 with SMTP id e9e14a558f8ab-3a345179f16mr97819855ab.13.1727728826696;
        Mon, 30 Sep 2024 13:40:26 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm26430175ab.2.2024.09.30.13.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:40:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/poll: get rid of io_poll_tw_hash_eject()
Date: Mon, 30 Sep 2024 14:37:47 -0600
Message-ID: <20240930204018.109617-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930204018.109617-1-axboe@kernel.dk>
References: <20240930204018.109617-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It serves no purposes anymore, all it does is delete the hash list
entry. task_work always has the ring locked.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 69382da48c00..a7d7fa844729 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -128,20 +128,6 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
-static void io_poll_tw_hash_eject(struct io_kiocb *req, struct io_tw_state *ts)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	/*
-	 * ->cancel_table_locked is protected by ->uring_lock in
-	 * contrast to per bucket spinlocks. Likely, tctx_task_work()
-	 * already grabbed the mutex for us, but there is a chance it
-	 * failed.
-	 */
-	io_tw_lock(ctx, ts);
-	hash_del(&req->hash_node);
-}
-
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
 {
 	poll->head = NULL;
@@ -336,7 +322,8 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 		return;
 	}
 	io_poll_remove_entries(req);
-	io_poll_tw_hash_eject(req, ts);
+	/* task_work always has ->uring_lock held */
+	hash_del(&req->hash_node);
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		if (ret == IOU_POLL_DONE) {
-- 
2.45.2


