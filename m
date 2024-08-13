Return-Path: <io-uring+bounces-2744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C50D9504BF
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 14:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8024B1C22106
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 12:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FC719925B;
	Tue, 13 Aug 2024 12:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="siTxml+K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A98184554
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551373; cv=none; b=RlIIcoImm+HRxfq9zLdTsnWVKNsT+ofp1960gulrJiE9b1xeZRbk2sTEnFEQw7c5JI0yhYqqpRwqm6I0O31aWeOc+NQtbT588OhtmqDzzM19WLId9sPhtWVZeA1omyW40BAd6EzkGX6JgFha44j2FcFIRMfQ9hv4VFNHYU564zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551373; c=relaxed/simple;
	bh=rQQwliLXM5GT7X0qG1GuFjC0EdcRiQg+/0P6jsmXNnY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=keYpYeMJMutstZECE1a395W2Rr6ylJsBIwJuUrMdWjnF3KrRYy+g3W0BJ37//6Ry29iY7bvX6WDWDz4Cem4Sa4TZgL+clxxYv+GzyLXG8UezJlmUfmPwmZPcXR4qMkz2i8aVl1SETUbLqLPb+nlBVYEXYxjJGz8wHDteaVGAyA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=siTxml+K; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2cb4e1dca7aso1067178a91.0
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 05:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723551370; x=1724156170; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/G+gvjdBaddRWEdPLkSuoWXDkOOeyKF0h1cSHfCmVAc=;
        b=siTxml+KdpIsInFPWHalgRbCjmVUjDCakENcsgYTDd8lmycMSMEgo+MpUXl6Xlozk0
         kmSJzEXgwO5n/VCpPtVgzEK+AZc45FpPBlzdI6ZnFnIl+ZySY2BpzGfoe4+FKz/rcSsa
         aG2e8NTWlJPQWcPkRyx4zTG0J0kveIToGUmfYFmVPJWr3JhXPgVi8SA61vhdIzZtrmi9
         32g2dCu54TUqx2GZjywVseicNF1x9zXWDNp7GfE53IFuZcBQT1/Sh5C4iUoilF+loDhO
         fiq6LtOHI1tXgfYGTD07ulHXQaQAZQnaoXPOkOIgaI2E/9lrchg2KfxFvx5pP5WM3E1K
         VcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723551370; x=1724156170;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/G+gvjdBaddRWEdPLkSuoWXDkOOeyKF0h1cSHfCmVAc=;
        b=jp6f4MaNM9fFES/0Sxt/Vz2z4LWQAaYqjry+/Zl2Bd2NEAwqApB8PDBI12zMeuCb5O
         90qNyP+aV6rbrXKPyuHh2GXo9ivdx/SXzUgaCUMmsPoGHIgjoS9CV+zCLEjSvhoYsDQt
         xfipy9WS+Fs+9x2GjWZOjEFFPD+yOhBWS3fRQ4qZ2i1uQYolvp+wce+1I6/LoTd9oXxZ
         Atq2AOfHr1/xyQV4dsnTyzXkYioxlnxYbiiLf1lSxvT3vHwPtPg33UQcFmS879bCXQiS
         K3Ewsd/dBsgLK1XUIiECAYlk0c6bMh16eGHh0DUBRDIHSuabDVYpNzKYyfwu4kPoSBOa
         AgdA==
X-Gm-Message-State: AOJu0Yz5JgS+2T47RorolV3Vop3YXdbYZKNhR7x2vdICakBEDwqYg4hi
	7p1ZxqkL7kBdfv4KAuiHwHm4sz8gMpiLVT/qKjYfp1XDWqOi0fhKhSeKgm96BhZ+b2F6YEIb1Vy
	Q
X-Google-Smtp-Source: AGHT+IGF68f6PqUuAPCdKS0UiOl5VlwQZGGwhYIg6fsU0acGqeVyBQlvlWvHJ5WXOVQxk/vKW2NJJQ==
X-Received: by 2002:a17:90a:db94:b0:2ca:63a7:6b9d with SMTP id 98e67ed59e1d1-2d3968f3b3bmr1463034a91.3.1723551370030;
        Tue, 13 Aug 2024 05:16:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d396a8aafcsm1507448a91.0.2024.08.13.05.16.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 05:16:09 -0700 (PDT)
Message-ID: <7bb28cb4-b58d-4ca8-9d11-cd90c465d677@kernel.dk>
Date: Tue, 13 Aug 2024 06:16:08 -0600
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
Subject: [PATCH] io_uring/sqpoll: annotate debug task == current with
 data_race()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There's a debug check in io_sq_thread_park() checking if it's the SQPOLL
thread itself calling park. KCSAN warns about this, as we should not be
reading sqd->thread outside of sqd->lock.

Just silence this with data_race(). The pointer isn't used for anything
but this debug check.

Reported-by: syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index b3722e5275e7..3b50dc9586d1 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -44,7 +44,7 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->lock)
 {
-	WARN_ON_ONCE(sqd->thread == current);
+	WARN_ON_ONCE(data_race(sqd->thread) == current);
 
 	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);

-- 
Jens Axboe


