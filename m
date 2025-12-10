Return-Path: <io-uring+bounces-10993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2872FCB176B
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 01:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBFF330AECA1
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 00:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22EC6FC5;
	Wed, 10 Dec 2025 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fmEnhnvk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D90F322A
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 00:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765324995; cv=none; b=uR4xpvB11r+mMcYJbWgnPkpUqFesQHsjJwHt8YSoxPpLgLdNhyhFV97/qPhn7cc19WQanLanzfAt6/pNE+K3av8lFYUW7sGmr8S/vpaHRqDvc0g4ofBk8j/K1BdYwa3GNbsxp6j7URHLRsTQ7LM7ZxYWBP5O9WaKW4TYwIo8e0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765324995; c=relaxed/simple;
	bh=VlYKNVHqRBjSjrqQt1/AIYveklYctx3R8FdrokmUp14=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=TxBYzmbkhexwRVFKYx/KzvbA5Iomi9VrFASyjvD9/LbetEat8YpjAP7j8hP1P4UOr6yeV7AvYXOlMCR09aYGju1LjfHtsMItzgRzLUlbOIJSjuxtym6McxgZg3EyUTiZe/cTEShwHmApxvcs+u8hlC79dDRkRJGXbuacdkByKJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fmEnhnvk; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3434700be69so8775004a91.1
        for <io-uring@vger.kernel.org>; Tue, 09 Dec 2025 16:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765324991; x=1765929791; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qs0z44A914VzCgi1P6krFfw96Q+CNA//kDkt8Fpdu80=;
        b=fmEnhnvka9MvooBG6uRLOV7G1l+RQuFJnhW1xr1pZjPBAY+MuJcDxEGHzuiS6Kw9u9
         CBx1VYpYuPCOM/tad8MuEgFXukEjVQq/yDNvhuRpC96qMgM+CsJFOxtvE9vnOw3wNa28
         i/4DmZfxxGB+xWF1qWK7DWJZRLz/it8CCL+TYfbv6HJVTqS8FyGjsasvM8ZwQcup+2Kf
         +A1Xw7O99kYs4ekZduQjZwVMgfIWp+kF9Z1nL1zhuHp2KZzFoTIL42RPMdb4tb0rUsIc
         ogV2ayLOgaDFGxjaQCOSxvfgLOvbeR6ekLF2oD3iGOUnWLEzyvZ6Ghjo8e8Gkjcg/bqi
         cnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765324991; x=1765929791;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qs0z44A914VzCgi1P6krFfw96Q+CNA//kDkt8Fpdu80=;
        b=f2Zf+Uw5FyXlxntBUXlr7vvB5DlOr58gM/i04QGcvC7zPYt8lQ46m3O/aW///ZdTa1
         t4r7OaRAtAzd6/4ovjSaAfpDkeQu07jTmoVRXCfJ63y97OTc/K/vMdqTGxmcJThYt8N8
         iO2jN/4PK/oCQJc6CCCSWO49YbxeGiyoVtG/dXigqBtLH42fr25aYxIV/8uOdJRUERJa
         S0g940hgwsmfBisxWU3WYsIinfk/406sv5H25YwAqDqZd9VTn9ZJ/YRwXvkhxVX6kkxh
         NljOZimSdnm23ph1xHw9vRKXlmzBXMg8Y6IcKGtSILqdcBfX5g+u8fZHeXBcUf0HVor4
         kbFA==
X-Gm-Message-State: AOJu0Yw8b60idKvqqeU7dnZSUgFKKtG68mr3Ci1DFViwRzLD6eiisuUz
	BTrLnnkOYycT4pTGaypsFXdhTptDV+Y8T7otyD7FuGc18rcnxq8JdtazBWJWGzhfYDrIObxTkJR
	iNJpbUMrHNA==
X-Gm-Gg: AY/fxX6I7tlZgCq8V+FKmzcuznjSBhhxu/6EdYjpRitM/QI4fBuuAeg07Rvf0ggeLWh
	TYIc+rP7T147WXVWi3oZ/ZOEoHtXyh/KYjLKSm866psl0TSo6uW/kskY29Nlj/Z/2YS86+TRcBO
	OLyuyt9UR5v9nVXigw7YqIKkWwB9GYElu5JDSs4VwHaWKryO9rIDGbtU2AK9hPqWcFx7N2PziG/
	jTyzw+Vk30PpVlIQLeery09H132p6MbFjt8dSAxYboXGtW5wc1VVGomjx3FXupG8DEq1mCaGvfS
	ldusCKNIMuhq7+64dfEvb03Oy1lU53NZeDHO+477kcp5b7PpTP+LKPvLX2Mddr26Yp9tSbzEQZa
	2yCYShVHvHr3wl2MW3YL/Dfc054s/N57rv3t1N3AzdUVk21xMCVhARqEguVmiIiUEKcVkt0ChbC
	SOQQ0Jc0rpr01q/pFrN3SKKH8+kxOToFexXmmZXlbdmNbUjluGHwk=
X-Google-Smtp-Source: AGHT+IFzlVtG/2MCZ6tyQklrDdsUsP1Fdy/QxXNFM6NiOPieZKVc0T+SGnthHF2IDeF7j0twgOn6cQ==
X-Received: by 2002:a17:90b:3891:b0:341:315:f4ec with SMTP id 98e67ed59e1d1-34a727eea71mr506907a91.7.1765324991009;
        Tue, 09 Dec 2025 16:03:11 -0800 (PST)
Received: from [172.21.1.37] (fs76eed293.tkyc007.ap.nuro.jp. [118.238.210.147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a70929f41sm534858a91.13.2025.12.09.16.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 16:03:10 -0800 (PST)
Message-ID: <86bd8844-fe7b-48b4-bf3a-35bad6294a3e@kernel.dk>
Date: Tue, 9 Dec 2025 17:03:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Tip ten Brink <tip@tenbrinkmeijs.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: fix min_wait wakeups for SQPOLL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Using min_wait, two timeouts are given:

1) The min_wait timeout, within which up to 'wait_nr' events are
   waited for.
2) The overall long timeout, which is entered if no events are generated
   in the min_wait window.

If the min_wait has expired, any event being posted must wake the task.
For SQPOLL, that isn't the case, as it won't trigger the io_has_work()
condition, as it will have already processed the task_work that happened
when an event was posted. This causes any event to trigger post the
min_wait to not always cause the waiting application to wakeup, and
instead it will wait until the overall timeout has expired. This can be
shown in a test case that has a 1 second min_wait, with a 5 second
overall wait, even if an event triggers after 1.5 seconds:

axboe@m2max-kvm /d/iouring-mre (master)> zig-out/bin/iouring
info: MIN_TIMEOUT supported: true, features: 0x3ffff
info: Testing: min_wait=1000ms, timeout=5s, wait_nr=4
info: 1 cqes in 5000.2ms

where the expected result should be:

axboe@m2max-kvm /d/iouring-mre (master)> zig-out/bin/iouring
info: MIN_TIMEOUT supported: true, features: 0x3ffff
info: Testing: min_wait=1000ms, timeout=5s, wait_nr=4
info: 1 cqes in 1500.3ms

When the min_wait timeout triggers, reset the number of completions
needed to wake the task. This should ensure that any future events will
wake the task, regardless of how many events it originally wanted to
wait for.

Reported-by: Tip ten Brink <tip@tenbrinkmeijs.com>
Cc: stable@vger.kernel.org
Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Link: https://github.com/axboe/liburing/issues/1477
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2: just set ot to cq_min_tail. Should work just as well, and avoids
needing to do unturn/once reads.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d130c578435..6cb24cdf8e68 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2536,6 +2536,9 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 			goto out_wake;
 	}
 
+	/* any generated CQE posted past this time should wake us up */
+	iowq->cq_tail = iowq->cq_min_tail;
+
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
 	hrtimer_set_expires(timer, iowq->timeout);
 	return HRTIMER_RESTART;

-- 
Jens Axboe


