Return-Path: <io-uring+bounces-611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F578856F11
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 22:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5A0628384F
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 21:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8028613B287;
	Thu, 15 Feb 2024 21:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JFyLLBHs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C5913A88D
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708031250; cv=none; b=X/AnJpveB78PKr90TmXkWAwY9/XoSZa5sfNHr8T+RY3a9lKOx/fO2jwIwyR7tf+GNCG75phm5KbL9QcGrHJ0KvDO9q2v9nFTVzdA5+9VJEoqDRXJ++r0Tby1pR7N68Z2f2PPJJczlAPHYlYGRt2AOSTpWxXbwIm4U6CnC+lyufA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708031250; c=relaxed/simple;
	bh=k7CPm3SnV5/DfCFWW/wP/kaGFmfFHF5lJ6LqvmTJT5g=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lEw8/yfNufBTEi8ovIXNg4MW5WDOdAiaPPNqkVmjJ1zh2e6w1aFiVfl0VHuYN0MvRaZVPHsQdv8yLrqBI3cqXFv+gHEn8KuEI5xVWKjCb91plMm1DYIfOo+Gw11wTNiFTZ6xMFcqVZ8OtmiYA4RNOg/fQ8yi5RjaAogHeWLY2N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JFyLLBHs; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-363acc3bbd8so877025ab.1
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 13:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708031246; x=1708636046; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0io2jrXortabpR0vlTAle8eBCy9p9bMrUeIi6IiXUY=;
        b=JFyLLBHsSRPaVyieZaVcIpSy2NtVfn2z3bIdWoe+UJHE+5rdtuyfZILh++/vfDksI8
         kUfb0kuU/jfwHB83RZy60b3z7KujhxXKJt5UX6NjHOhKe15+g6ObC9EshK/or2ua/ERd
         0pFe8okdZqV7kuHMeJzAfmzq+Ylh6RNfD09pLWdJrvIhm5yAQk0/qBVZf5ewHC0j8Dyc
         PzVs1+ysTPaw1nMAfvEQQOOI+YXmG09xeb1R5xb1BGFE8kW7r2P8C2P2+j0cyqzodH9P
         MVYBy05aZrZS8x3gvRxPA+Q/nasZm0iMpl6xVCJV2E+MFQx5z2+y3xTqg1JAWQjZtAPY
         mjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708031246; x=1708636046;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q0io2jrXortabpR0vlTAle8eBCy9p9bMrUeIi6IiXUY=;
        b=l49OqqxUHYNgrGPbsmNTuUOt1a2sWaSw6qv3rpRTcpZSuH4it/Nfg0JuF+bRzJ3KPk
         50fvXRkb2vcVCFYuTiWkduKc9gahBtEm4I5eC7+GnYEgTlUx0JnLaoWt78Rlkh5wC119
         HJC13Gf/h3kr5edqLIXwjv9M3uEovOPXE39Lp5XxoGw+TvzeKfU3v2NLKemCgbD+3qA1
         LYvU91WW7P0ey8wJE3H+4gFkrjfA5Sg8KVSBX/3kK6KG08B+2/16EOtXr+eAaCIMnh3Y
         lEj1PklBjPl8f32YPMAltzx97VQrAPSO5x9I8iQttpV0lBARfcEHvgBbwMJ7mln4xJdC
         ypRA==
X-Gm-Message-State: AOJu0YzR733Q0EQJIiMbC9PG88nrje5MLSPpmI0rDzloPpZvCht6l5K5
	7qnqKQBwJGmKDECALf7r7lXpmWQ/mgChxLB8CrYGq1kO9evMkp8/uOrT8QKix3aueoy6WNsdWk6
	L
X-Google-Smtp-Source: AGHT+IEXDS9T0qbCKpX20ba4ujGG0jGht2hJhiA+LP9LZAb9pmnesj8FEsHH6kIEAEDPZ40+FUZc9w==
X-Received: by 2002:a05:6e02:170e:b0:363:c82e:57d9 with SMTP id u14-20020a056e02170e00b00363c82e57d9mr252341ill.3.1708031245753;
        Thu, 15 Feb 2024 13:07:25 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c4-20020a92d3c4000000b00361a84b89cfsm57346ilh.51.2024.02.15.13.07.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 13:07:25 -0800 (PST)
Message-ID: <e7c6d3ca-ccc3-47a0-be0d-0697567ed47d@kernel.dk>
Date: Thu, 15 Feb 2024 14:07:24 -0700
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
Subject: [PATCH] io_uring: kill stale comment for io_cqring_overflow_kill()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This function now deals only with discarding overflow entries on ring
free and exit, and it no longer returns whether we successfully flushed
all entries as there's no CQE posting involved anymore. Kill the
outdated comment.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 45a2f8f3a77c..cf2f514b7cc0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -666,7 +666,6 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_commit_cqring_flush(ctx);
 }
 
-/* Returns true if there are no backlogged entries after the flush */
 static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 {
 	struct io_overflow_cqe *ocqe;

-- 
Jens Axboe


