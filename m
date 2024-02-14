Return-Path: <io-uring+bounces-604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DE1855474
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 21:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93A091C209C6
	for <lists+io-uring@lfdr.de>; Wed, 14 Feb 2024 20:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495D213DB88;
	Wed, 14 Feb 2024 20:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vmbbVdly"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E70154649
	for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 20:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707944347; cv=none; b=YS54FjjE6peky2Apa3/tHma50U1IxdjSWy/8st2LRt7xPR+vZFsKYtZLnfRb7TDFqnQ6Cjivczv8P7danhjC3vlHHrkuZgYL5kPNyGKVAKOvlXv+jfZvcWknKtsQVF4crFG+T7/yf0Le85hwSmdpDcycajInMJ3/4Xvv6mh9zBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707944347; c=relaxed/simple;
	bh=6iA76gY7VYbs0cubNKcAd9Ogm5lWMTXBTQu+j2AMTyc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=N5oQZwdjq0THHsx8jtGDAJ4hRk7c3fY5Emqneb0qXC39+Txgd8dGhyzxLBHC5EKB2Cm+HxyQWI/qajZ5E0meBdpd7+bKMa5xynvLvbk5UTcumNwFRhzlfjeil4YRgLgAbVVvkoiUks70/ccT8C2c7WpBSZ3Rj1lIvbYLsi45AZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vmbbVdly; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35d374bebe3so333025ab.1
        for <io-uring@vger.kernel.org>; Wed, 14 Feb 2024 12:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707944341; x=1708549141; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgj52bdTF6bCz9q9Jd8cHJa8Jnejj95APVYteKPtUF8=;
        b=vmbbVdlyN622fudfhmnNyahmwokHLSvzXijMtgrCz9b1NP6XZp1HAAwcAFUza6ScTl
         ktagfEgw3AaGwp5aoNLTJTXe0I+gqqYlcOnqqxAeUM29Jy7yyl/ZeeSXz4W1/abRN6KS
         glCdZJ0V32K5ijr06DsTvctRJkee7fPdY204HQP1Y4cl4qAhWEMYuR+whVoSvybDDJn1
         j1lSEVxMgiQyB9LL0LpCliUsIbQpEtyzHlkkYAyWV376EieylBJQSVTYAj4p6C1dxabk
         CH1h5FfuLzGompi6ikiwVfRcnd3Uj5qfp2AcyTDkWRrkGnzirNXY3W1hnWKP4C5hZOS2
         riWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707944341; x=1708549141;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cgj52bdTF6bCz9q9Jd8cHJa8Jnejj95APVYteKPtUF8=;
        b=fuH46mX6r54JcL3reFNj+lLscn0QNTyX67cFOJfDqQr41nasC6uDRBCxaQqBYOa5Bt
         L34Vp6W4v+4rWuQQDWvmJJY25F+fJot46QpnZSTbD1ynjn0p3EUWQTZjUA6YMzampjXk
         b/BE23X+7LHrIWQktuZQLtLTAVsY6A1BScEfUo/vuB16KgXpVwmB/GMoKNbDzaBGpJ/N
         dNAUuvp7cqzBG9TmAjbzVJfLsRDicJEUf9LX+n0/lE3ARcZtTKSBlP6gCkL+KKr22Vxq
         xXwbngueT8Lq56Ekg6/hk8imwTTejlBHehf9gj7E3tuRZcuW2Bn7g5Ccs43jOswBGf70
         NkMQ==
X-Gm-Message-State: AOJu0YwQQ2YiqKJT5Ij5HT4CNUYSwia/MKyLNeGWt0+PR8tF8CD6r7bz
	ETxtlQfNk8LuFKUjE9y5WcnkRRfsGhpSGeWahiUvxN5Ubz394ktg6VncYpwhdXGki8Yt9XHnDAb
	w
X-Google-Smtp-Source: AGHT+IGlzIaJaMsxefMbdsJblupiwkWezea3KfL1NbTumye/AiyQGC4PoxYYlY5gmbq1N9nhVGYPzQ==
X-Received: by 2002:a92:c26b:0:b0:363:c919:eee3 with SMTP id h11-20020a92c26b000000b00363c919eee3mr4680496ild.0.1707944341580;
        Wed, 14 Feb 2024 12:59:01 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b17-20020a92db11000000b00364b66eb5e3sm358224iln.24.2024.02.14.12.59.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:59:01 -0800 (PST)
Message-ID: <24ce564f-8203-40dc-8399-fcd36c69a676@kernel.dk>
Date: Wed, 14 Feb 2024 13:59:00 -0700
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
Subject: [PATCH] io_uring: wake SQPOLL task when task_work is added to an
 empty queue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If there's no current work on the list, we still need to potentially
wake the SQPOLL task if it is sleeping. This is ordered with the
wait queue addition in sqpoll, which adds to the wait queue before
checking for pending work items.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 844a7524ed91..45a2f8f3a77c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1370,8 +1370,13 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
 	/* SQPOLL doesn't need the task_work added, it'll run it itself */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct io_sq_data *sqd = ctx->sq_data;
+
+		if (wq_has_sleeper(&sqd->wait))
+			wake_up(&sqd->wait);
 		return;
+	}
 
 	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
 		return;

-- 
Jens Axboe


