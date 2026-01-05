Return-Path: <io-uring+bounces-11370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9ACCF542E
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D65830AC761
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7751B4223;
	Mon,  5 Jan 2026 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u2/LsQFC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8BE13FEE
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767638755; cv=none; b=rNpea/TMeXeuxObKDA4SKao7D78eHdlX/jsOKggIQP78zgYTsXZ7xDc0SDFbKp83R2RCuTr28nrUZqXRxoGmPED/NTAYrj+Xx7bU+RSUn9aLlIJxanWhiUdn/AN5Am26/Z/AbFCzn7XK6YWiMQ4BhQZ+1RqK7h5c0n9nlF58Luk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767638755; c=relaxed/simple;
	bh=Qot2MoHl6pUeeThNFIM55c16lm8atXupdzTfNiM8u2k=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=tIUSB1xO+qFZkWXWD1HRQ9tXmhb9c0txKaxi6/pjk6AlMLxfdERwn7SoompWecz/sAUCSc4NAH1MWsZllyEQdAb2HeEPqR09Lusep48mMCdfoyyJ/Ko14itMJL9TTzVmf4ZkDYCYKzuHVfl4fuvVGbRBsfdsHMxN6dqwbN76yNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=u2/LsQFC; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-3e0f19a38d0so177931fac.0
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 10:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767638752; x=1768243552; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cs96TSTNXaDrcHqhE/HdChh6u+fGIFjI3uW5jKXN7+M=;
        b=u2/LsQFCh06w+xgilKZdWwGX/kC/VI6gN3hZ+POvyYR/DbRHjygUgLMdYRbGN4dveO
         9FxnblYgbP/EuvdabjAhPtfWeTC18+Sw6tcIjrZizG0ym/kviVp+V5O/zLQBuCGSDYjg
         ubBwvImKQ7kLc0zQZYOepsR/F+GpRzU6OWcdhxx6lTa2p3cewy58QGQBVDkK+jwYnHFY
         F1b0fSw+heX9mtF0G8BssKTylEjbke0fXKc0r5A64OxZO1SbZvnEprqre+TMcZjjFGJk
         hOtyftX4QczgfVa+gQmLj0W2dy/4Kb4vGwW4lhAlXGcWwL+UN48EVxCREl8SrC1FATC3
         3Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767638752; x=1768243552;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cs96TSTNXaDrcHqhE/HdChh6u+fGIFjI3uW5jKXN7+M=;
        b=EWq9uY1FCTjnRBl1CqcXj/nS/EQi0CfWtN/SmnZ0Px1S6/FUoe1Rz+sxuD74jZGOab
         2MzcSClLZvXJy5aifJQeOKuLrDsPYlxAFPebIoCJDAbpspCgCv8XiaSQzQd3fr4bYEvr
         nsvn2FIkCt41SKtoSp/lPAbp3npLzkLTqcV7sJjCgdmuK/dFVBQu9fYdmTKQbC/Wf7wh
         wzJFwBd8RzyDpl0vC2X9/jbLCzn2Cw3ZI26pCwp1U+B0XQnnaL/vkCUJeSDXJS8cEiK2
         piGLoe8jW5q1spTpvlNKTLIZPDToA7YzQwdk1/W0/xnaelLKZyTNv1GyaMWyuk6GHING
         ed0g==
X-Gm-Message-State: AOJu0Yz5RWOZtqeohuOLrla252gJHdLZJOMkTx/JV+zDhFNOyxYqqhXO
	JbZ/xyksw1G9Bsy2tIVqHem5vqfX4yoW6j8vZphrP2lvgVgmIJAPeKlEoRHkhcnTttP51lKaGOU
	/Xg45
X-Gm-Gg: AY/fxX4KaWIAt/KR2dMYQUb1k2Ol1fHYJW79J6EZxrtgyAZKCoBfqVo2rlg4qrPd+kH
	NBVvqcB+eo1U+ONEkss2ySvc/HqUcpls21X9gMGoyqafv6D8xmqjT3YrjZZvG77fOrQy3ns2++d
	SJmXvzFARi9UeDjkNtcWxGkHB5TB7fnlGUgc/tX6LoU3x9M8vJivqv6TPhf8F/wCYoQvsL2D1/q
	PaAKD+zPb08KLzP87jYMOSYRSMVV7wsfMD7mH0mDonffn+IFPUBGF9j+9vg4wCbf7WGWtyOsgOA
	LDX6pChf+UxCIBFQ9NSgnT2tHSFofKyyc4nV/gd1FCb0tH1gZFbYO+arwFuD9Iz3XUPtPFfZsSe
	fogrz8O1oMzrFyO+IdAHSBvbv3QoFfUwczCm5axTSKrjgRMPhmvpntWENRFCFF3accC8ZLfjG4Q
	VWQ9Zd85oY
X-Google-Smtp-Source: AGHT+IFyEUb8lZkTf8JYX66CoELfBxkgY0QTGjuWfyj/VrOaXlZYDZA7LnQ1e4nn8X8tWGsTwIuPxw==
X-Received: by 2002:a05:6820:2202:b0:65c:f821:9dd0 with SMTP id 006d021491bc7-65f47a9772emr192374eaf.59.1767638751660;
        Mon, 05 Jan 2026 10:45:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f4782ac2asm188185eaf.5.2026.01.05.10.45.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 10:45:50 -0800 (PST)
Message-ID: <708b2a6d-7c87-4f94-8d15-c450228c6b6b@kernel.dk>
Date: Mon, 5 Jan 2026 11:45:50 -0700
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
Subject: [PATCH] io_uring/io-wq: remove io_wq_for_each_worker() return value
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The only use of this helper is to iterate all of the workers, and
hence all callers will pass in a func that always returns false to do
that. As none of the callers use the return value, get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Followup to previous patch fixing an issue with the iteration, while
at it let's clean up the io_wq_for_each_worker() helper to always
just return void as no callers use the return value.

This could potentially go one step further and ignore the
io_acct_for_each_worker() return value as well, but let's keep it as-is
in that regard, for the case where a new caller is added that does
provide a func that may return true to terminate the iteration.

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6c5ef629e59a..9fd9f6ab722c 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -947,16 +947,13 @@ static bool io_acct_for_each_worker(struct io_wq_acct *acct,
 	return ret;
 }
 
-static bool io_wq_for_each_worker(struct io_wq *wq,
+static void io_wq_for_each_worker(struct io_wq *wq,
 				  bool (*func)(struct io_worker *, void *),
 				  void *data)
 {
-	for (int i = 0; i < IO_WQ_ACCT_NR; i++) {
+	for (int i = 0; i < IO_WQ_ACCT_NR; i++)
 		if (io_acct_for_each_worker(&wq->acct[i], func, data))
-			return true;
-	}
-
-	return false;
+			break;
 }
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
-- 
Jens Axboe


