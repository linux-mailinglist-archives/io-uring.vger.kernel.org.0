Return-Path: <io-uring+bounces-546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CE084BAE9
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32EB0B232D4
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9F1132C0B;
	Tue,  6 Feb 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NNKtRr9B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715A312E1ED
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236861; cv=none; b=Abh1SyjdjuUr7d7cr8yHGlUYQ9irRLucrIC4ddlbLsEcem55SiB/xy+N/Mfo5pBtbvtioM4vCffUIiXsUVjBGZ4U05SjmKvnz3kLs/DdabmlFowrjf4l11ncw97JMEliIyHXC0vzkvlQdDKMrA00GKIoM1ehBkovxiZcNOJf3gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236861; c=relaxed/simple;
	bh=sHxZJS7kSIuUULAieqdB85lzc84QEvd6GJS4n2E5Rs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpRlNbOxlkFPUghE/ZsGHrKK/gLL1EzVDcTbEZ390SSnkLNmlmRorF+z+KVDNkUnfqXybvfBdoopYjR7J7hlOe9Dvv9hGvWmmTo4WVl3riAvFDCbG0lgbAFASBMrPgikjdvT52ECu8zkF04uweIfrTzAu8CmysmWz5dTwZgNv1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NNKtRr9B; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso98723339f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236858; x=1707841658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkbEO3p68qIQIUai79CU/8MPZ1efFTqJP2GlbGjeI6s=;
        b=NNKtRr9BvnuMtBP2hTzwXPsD6L9sGoTviP1iKXUEJozbSI8Bf1MSHy8IqO0c+WdeDK
         I+6Wmkex6NsBy3VW+xGYgcveXupg98mP9tPnKjt3ifiumyXXZjx6kuLQenAU9DVCleKw
         iioli4mV08J3qWBFk6muyojKvcN1OlyeDzXKS5eILdPTqmKt9eno2jH9oG0wWxg+b3NB
         0sukfEpwpwaEhxwOsjtoDIUksK9WoH3d55UKHL9p1Upkd8rm0SiEIu5LLsetXKLh87xh
         fDlalRn0IxKWpYmBi68wCbTVyu++sAAB3D9wds56Da7XuByYmIkfN9LsfymHobhFfwNT
         vW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236858; x=1707841658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XkbEO3p68qIQIUai79CU/8MPZ1efFTqJP2GlbGjeI6s=;
        b=pKD1pTWqhCjhUagBBPWjfd2t9yeMd06i/RyHaapNrn+gvR99GXZnN7Qgr5UcPegUAL
         6QspKVuF6qHFTJAJKTDC8qDGfnHnc0ksS56EvuCPFRLUaseNfyEDPUsHa47AP3UzuYWU
         gdSqFdvcIsG4KnRlVmBS7/Qdel/Q79NoAjbtmx6BolbILl9X3bdG3iWQpSHnLBUwznNI
         E9ujqKs3UNoCGrEVHHvrq5Soj7GKrcDPMOo+ngUDaQ4mfSDmakJyEFT3M4pDVz+SwWMQ
         M9dHSBHnzPynWX8tcYoimJSA8C/W3q+AcRmo0BHmhYzwWylE2TCUw3Cj3VAdsR2HTywE
         ONfw==
X-Gm-Message-State: AOJu0YzYMlCK6GF3rk1FQ6NCgKeC4hVXROT/PRGRcD7EhGvxKmRq2suk
	YENJKukjsYeZ/zC3dMiH16oML2M5wuxF59+f23lJzxjfV4b02HMtYrFR0FdJ14TBzop8VXXWnTA
	hvcg=
X-Google-Smtp-Source: AGHT+IHEOxMfjlKYM3yv40ZALc2gOo2aSf8sAIZFxvGZC5pGJ7x219iEr5ez4m4PzFR0iKwetGNzGA==
X-Received: by 2002:a05:6602:123a:b0:7c0:2ea0:b046 with SMTP id z26-20020a056602123a00b007c02ea0b046mr3677419iot.1.1707236858112;
        Tue, 06 Feb 2024 08:27:38 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/10] io_uring: remove next io_kiocb fetch in task_work running
Date: Tue,  6 Feb 2024 09:24:39 -0700
Message-ID: <20240206162726.644202-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We just reversed the task_work list and that will have touched requests
as well, just get rid of this optimization as it should not make a
difference anymore.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 47d06bc55c95..a587b240fa48 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1184,8 +1184,6 @@ static unsigned int handle_tw_list(struct llist_node *node,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
-		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
-
 		if (req->ctx != *ctx) {
 			ctx_flush_and_put(*ctx, ts);
 			*ctx = req->ctx;
@@ -1408,7 +1406,6 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
-		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				req, ts);
-- 
2.43.0


