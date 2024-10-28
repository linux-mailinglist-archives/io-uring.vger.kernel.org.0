Return-Path: <io-uring+bounces-4087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 217919B3A59
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 20:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BF411F22633
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 19:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04AC318F2DF;
	Mon, 28 Oct 2024 19:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xU+ykKvz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871E155A52
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 19:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730143312; cv=none; b=K7cUnh3VwcrBA1ylnL9lVhAaxxH5LrKopy33GggInYZILur4VO/tDukRGTcBgNOxQULNFf8JprLTf/idrltzHtI/O6lY+STtfUAq0KbOTeyz6PgQc1mvoZo/nmo8VCwpzswt9Z55IK9FUlpR797cqjucmi6TyrIWzF2uHuJt8oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730143312; c=relaxed/simple;
	bh=af/GSDsZi2hfuVnS3F8p6SCr+ovAtOwzxaUwsIoyim0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=opFe/yo2ejcpyYsRrDt+K3zaQp/J68r+3uNTNO64KNvv2CZmTDwx/wA5zT6Q86wkrU6vdXg6Uh8wkmDcNiH8VNJN6ybpr2slSVfNk9aIbzjoZOoNXK78apvQXq7nOIfav4i/GRK9JSBYn/+gQDw9l3qDvEqUXQjrbI9BCjtiKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xU+ykKvz; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83aad4a05eeso178463939f.1
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730143308; x=1730748108; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=how9u9cAzll1b+FHsoGX9LPU+CQGIEqzQyHytgCTFXo=;
        b=xU+ykKvzLqWny7QOZdh3Q3BdCfKiHJjABaggTBPgFYctNQFURpIagh+prrFM721Sic
         OIwQJS9cBE8XxeK3vXnUCQ0O9Z8LAYibCRhA1eZNkEJstruxFpQM+qnr5QiElQ8mph/d
         nKWuZXs0bFrEW7WRV1Bn3xppgv+ZhIz0JGR2MPBOyZsaKEAJwFQdgWqWX5U2V/VNLNqq
         Pzb3xl4IgxXjJ8D1KOmTgacvy3cuZ345LZm+mDoVNCUA8WQHrmKue2hcrCYZjbrckann
         m1zzXwCFTT35Zr35tUmDvMA0lwT19s3RVfKF8E32+vhsaqqXhxsmwYQ3abttCxKcMlNV
         MFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730143308; x=1730748108;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=how9u9cAzll1b+FHsoGX9LPU+CQGIEqzQyHytgCTFXo=;
        b=RS8tP8U8l7eqP+UJZCzx9DVETtXZ5raEjiDescolbYe9SkMZB06tq2y1mmJMkZqzJI
         epmfScTbi76I635jmzM2PB3OMqDlLdhg3dcNnZfsGtaUqPJQEpq2hr9F6tnNUO0nJkhX
         AkskadAhFWY/Lt/RoqyrZcPyGcJJ5Lj9FdIG33Jw2agPchxnb9V8239mkh/r6OpWvUtc
         sCZRl/RqB4IeZV2jbR5nKlYb8t/F8NuDsEjulWqn3aavImGy1WPIhnpOiPjt7PjhBsz1
         azqySxlxC/p8WfLyYMQQvU/BiQEtmGFHkj7hYFiiJ9IX1Y3ATysKgFffjJQ+5n+p/Juu
         2vsg==
X-Gm-Message-State: AOJu0YwtSBIY8R7yzArcSd9pdZdKzZibJQPAzElc+T6MbCHXqB8P90Ed
	uUEL+lvqGeFvY2zLuVjlQY9NghVgnFRaZxTTl5S/Z2knsnCFm8ty55oeBqN6g+GuJljfIiFBmrT
	I
X-Google-Smtp-Source: AGHT+IGks/jDKn7stgyg2IlqtZXoOvvjSz/9C9+5OE38OIdOQkO9rEdgon2SBAa/53MfVYP9un1nTg==
X-Received: by 2002:a05:6602:1483:b0:83a:c384:ea2a with SMTP id ca18e2360f4ac-83b1c3dd89emr751702539f.6.1730143307910;
        Mon, 28 Oct 2024 12:21:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc72781364sm1837997173.140.2024.10.28.12.21.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 12:21:47 -0700 (PDT)
Message-ID: <37c69370-013f-457c-a66a-502881e35119@kernel.dk>
Date: Mon, 28 Oct 2024 13:21:46 -0600
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
Subject: [PATCH] io_uring/sqpoll: wait on sqd->wait for thread parking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_sqd_handle_event() just does a mutex unlock/lock dance when it's
supposed to park, somewhat relying on full ordering with the thread
trying to park it which does a similar unlock/lock dance on sqd->lock.
However, with adaptive spinning on mutexes, this can waste an awful
lot of time. Normally this isn't very noticeable, as parking and
unparking the thread isn't a common (or fast path) occurence. However,
in testing ring resizing, it's testing exactly that, as each resize
will require the SQPOLL to safely park and unpark.

Have io_sq_thread_park() explicitly wait on sqd->park_pending being
zero before attempting to grab the sqd->lock again.

In a resize test, this brings the runtime of SQPOLL down from about
60 seconds to a few seconds, just like the !SQPOLL tests. And saves
a ton of spinning time on the mutex, on both sides.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a26593979887..1f18b642fbd4 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -40,6 +40,7 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 	if (atomic_dec_return(&sqd->park_pending))
 		set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_unlock(&sqd->lock);
+	wake_up(&sqd->wait);
 }
 
 void io_sq_thread_park(struct io_sq_data *sqd)
@@ -215,7 +216,7 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 		mutex_unlock(&sqd->lock);
 		if (signal_pending(current))
 			did_sig = get_signal(&ksig);
-		cond_resched();
+		wait_event(sqd->wait, !atomic_read(&sqd->park_pending));
 		mutex_lock(&sqd->lock);
 		sqd->sq_cpu = raw_smp_processor_id();
 	}

-- 
Jens Axboe


