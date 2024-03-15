Return-Path: <io-uring+bounces-989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B66887D66A
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6E73B216ED
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 21:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2EE146544;
	Fri, 15 Mar 2024 21:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="opcb2FTx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371675490F
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539750; cv=none; b=Fojjfcqhaza4BlalEY+yG4nSHWhoNfHaSgYv0GTAVcOrcd9kqUqTtDnaqvTwhz0//8SJUI+Sw5WWkkZ7jCUuJFbZr6yejZj7MIMeeE82xE8JpveOx/ixtqjfCJjnrvnlh2/lRR7v9lGfuPmp6r7ZIqs9QQdVVxKS/iidvceX9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539750; c=relaxed/simple;
	bh=N0WVbMMT5cfQciXvHfuD+N+GyLR9doGS2p1NMuZn6Sg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SlGpEbSMVcsSmWIHPvRaWN1xenqTMveMwFRBHfiYYqpFs5RR+59oHJTsWHLj8SIQ+hhnWwxlYKKdxMm43oG9s/gKCsxaWtjWkkEtHbTqOOTu7pDQMUaA5K6BWPmqbpSPnqNIAS9IrV/02C+zHtm0UdysAOQ25ER7NhvCyJeiaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=opcb2FTx; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-29df844539bso255513a91.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 14:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710539745; x=1711144545; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uYk5Tk+boafSfLbvMadNCk2h+0BOEs/YtRnSkg5cAs=;
        b=opcb2FTxs95atfxtzy9y4cmYYZuV+gfYW8MdA9KIuOzCpGN1QYOs9l7pnWUZW7J43w
         9cK3nQVsp4W9xTUyw06sCkgnePL+8Mkco47Stlo5z0w/PhPXXePKYl8f9x9wv6Axpd/m
         blCjbATc7231wPcGH6MapHGydmMBH4wj2U1kT+I3redJ/snizOkUNK0OpJucMoG0hDqZ
         4vyPESnMAnw6zTKz81HI/jmh3Typx0bE1mWsAQaUaa976lcSldzc+Gc6QT/xdy+zFAQp
         ZhY5Qbrcztm9w/vL4xyqM0eKZOQ+gFARIi0cBCl7UhvyRVoTgWEAEwpu5fG3DGUQPDol
         Plpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539745; x=1711144545;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5uYk5Tk+boafSfLbvMadNCk2h+0BOEs/YtRnSkg5cAs=;
        b=GxdeL5ot2UuaYub3QOeDhcU3gCH0C/9C+ffQtpWiiKgNEHefhUIFJ7SvMLz0zOvdsi
         MflqDAUh91qT5bPzOPgCueC+vJBVq+yxaU1AwABqs5TCPiZLshTgemCLxeVDBTHbYqIn
         LMcEQT3Snzno0KWDm1WSMjn1rUGbo2rkqiG3BJvQZYyY+EFl39reDEF8b0aErtld44XK
         iEdODNsY4itx5XKnMJaFRoh9cFKDO1H8iCRnC5OPBfpnTX5tYKxsB+WdY7EQwUKwCYMz
         I+EfwFuA9x4e9qpUZqqnV2Ivq/bwZ1KKvh2r0Cx2uqeFsElM6LCkf2vMTCJGI3XgXicg
         XicQ==
X-Gm-Message-State: AOJu0Yxwr1NVXwROPzsKZG+2t3Z/rgj0pBIfStCh/iifnqAuijZwKWwF
	usVZiMvPeBMyEeBzVnfVMNrPpANfEucA3xg4yPA1KMeNl18Z9JOcdrUPNgAWJDKHEpCuNOySHL2
	c
X-Google-Smtp-Source: AGHT+IEkAFS6fYk9ujNgFf5h2yj7ZNLn5yVUY7rYwDNWxgz12Ffyubs9tiUu9iJvWT2Yx02q15orcg==
X-Received: by 2002:a17:902:da89:b0:1dd:da28:e5ca with SMTP id j9-20020a170902da8900b001ddda28e5camr4871641plx.0.1710539745510;
        Fri, 15 Mar 2024 14:55:45 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c8::17d7? ([2620:10d:c090:400::5:ad40])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903120900b001db5bdd5e33sm4375372plh.48.2024.03.15.14.55.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 14:55:44 -0700 (PDT)
Message-ID: <d460ee09-e65e-4c07-9d97-8ab4392bad08@kernel.dk>
Date: Fri, 15 Mar 2024 15:55:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/waitid: always remove waitid entry for cancel all
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We know the request is either being removed, or already in the process of
being removed through task_work, so we can delete it from our waitid list
upfront. This is important for remove all conditions, as we otherwise
will find it multiple times and prevent cancelation progress.

Remove the dead check in cancelation as well for the hash_node being
empty or not. We already have a waitid reference check for ownership,
so we don't need to check the list too.

Cc: stable@vger.kernel.org
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6f851978606d..77d340666cb9 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -125,12 +125,6 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	/*
-	 * Did cancel find it meanwhile?
-	 */
-	if (hlist_unhashed(&req->hash_node))
-		return;
-
 	hlist_del_init(&req->hash_node);
 
 	ret = io_waitid_finish(req, ret);
@@ -202,6 +196,7 @@ bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
 		if (!io_match_task_safe(req, task, cancel_all))
 			continue;
+		hlist_del_init(&req->hash_node);
 		__io_waitid_cancel(ctx, req);
 		found = true;
 	}

-- 
Jens Axboe


