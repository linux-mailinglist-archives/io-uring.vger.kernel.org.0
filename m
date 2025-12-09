Return-Path: <io-uring+bounces-10992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE96CB106C
	for <lists+io-uring@lfdr.de>; Tue, 09 Dec 2025 21:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCA57309D947
	for <lists+io-uring@lfdr.de>; Tue,  9 Dec 2025 20:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C08230270;
	Tue,  9 Dec 2025 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d9MmPURg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA74DB640
	for <io-uring@vger.kernel.org>; Tue,  9 Dec 2025 20:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765312393; cv=none; b=sxOYQVhqYItJ7kJOvRZNINsXx8hpZpXMMfkVg8J+P28N+w0ENhtZ51BhGVEaU4xVYqGkEsSKaDP7HympNy6uCz6rqDMnkCnvbYM2O/fxsi3usOwV+ZfTmwA/VyhivLFYnoO7g3THN6Y6UIwU7bln+pJdiQBdj8P+FJkdTM8/2zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765312393; c=relaxed/simple;
	bh=9BPu7zGB3sx/ZaRHgDKaR/vSTqOXz5BH7+KOUHJ0u6Y=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=KJK+rm1oul9O2PqbRM39Bglc+IImB7Hoig8io83gR6JroE5lwbHHvolj9hNxawFwvo/LrhqqBk7vZLAHlvNyRPqpJwu9fYMVe2gLPUcl0NvzQHtXLONJfk/1l12s28g3m/iwyP00T/FY3Nel+ov17JMKKTlLtGHCaQDpqMUYhxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=d9MmPURg; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so4029306b3a.2
        for <io-uring@vger.kernel.org>; Tue, 09 Dec 2025 12:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765312388; x=1765917188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGlwimed1HqkjsjjBj/RsduuK4zxzywWQIjyfxIl1XY=;
        b=d9MmPURgJz7+oyT99xGqeIey5Yx1thqHDUwXP3fjEqhblhhD5nfvmo+83Z96D5majO
         HRMD+EQjrsNqMv//h/Tyky8/Uic6QQnsJvVEe/2681FYCTJAiCHGvmQiGOa2P0biZg9o
         lTEslK6ibRUXjjdNCh4zJFMaNGUFlObNvls5E9/KpaMes5oCD1/PSoMh4MTGh8cMxRGX
         fQ3F9/hu/f7eVsg/WAK+zRuia9KaB87s94kbVriVG4WQM7E5ILHW1xqotFsg+fX9Mn46
         fkL1jEMSL9aCbe4aDbqg9l3+wVFSk9wNS8VNnM12J81rEYejzb1JMe088NErzuvDXzDZ
         8lSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765312388; x=1765917188;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CGlwimed1HqkjsjjBj/RsduuK4zxzywWQIjyfxIl1XY=;
        b=qFVR2/M15vX9LWGhAsDysvRzR8j+Cgw3lNq+EAKCUgVi4uWz3nQcM25UZqH6VoJNhT
         QSTSD1x07pq+bfZ/WYnl2HJCgIu1b79WJ2zPucgB0jVXTlBmlYCS6MgVaWEFHpxqbeA0
         /r4eQuBuJVghbf1DNbfr6+cQawQvi/4toRY4mrKG9N9zzE2FgxtyubqLab+s5jNMClQN
         GiNfvrJx/ByJbhtweVqWE53tdFj4Ed2ukM3ovq/uO7V3rh9ifm6+K+uPjf9sQqjp03bB
         ANBHNKquqDs48wW25/ELPgWzgvYOhRExHwGCzHGMW3176nXzpVZCBobyfYbuNQKSHwgL
         m9Qg==
X-Gm-Message-State: AOJu0YxSR2dnIulhPLmLU7Fjs2C3E5NO7PMuTEaHyjlirURLgMIALdW1
	LiBIHxUR5aKfy9c2zWrBqJ55xhqqmC2pfMcFRujtiE7v1jJLkQ3I9JZt53xrTY1zUIpb+e9Dr17
	KFiVMxtKmDA==
X-Gm-Gg: ASbGncsvLeNpslUna6TWKHR6OBUb5foV9qjI/V5I2YUyYri+p8BNNcH991rbUtRrcWq
	S1wlTLRRqQpOaolI4+OWZCSoinj6zGZN7TfuO1+HxHg3iKMC9DtRhrlKPBWCrD5QI5tjazNdtHy
	Msv+9CB2CsEJxdrchC+3m4GSiQ2ahkYbQIhvz4or00gvHrk1abX3uGxZff/JDBKb+ulepSgE23B
	zRxWyVXFms6HCsJIAky/1zussknWQNc8rkZ86AD2xx0VCFI+vKXdD9HPxm/9Im6eC4M6Zdgncue
	CPP4FKJ4HGcvkpV2WfPVwvoh9LEUreaLrXdwU5pV7eXqzFS6ZgolzI8elHcQD8KXKIayGpP3hFX
	/LMyrCbTQqtWd7dJ9HS7nl4GxYzB50dtbliUsHuNvKnnl24aelkprUTuVCHQY89eyrADEa4iRp8
	C8T380oY40RbGoEgjQyovd+AI/sIoD2CbGNhgZUivERHoO86Ypqw==
X-Google-Smtp-Source: AGHT+IF0xJVuIJrwxg5nG3hf7TmED1khXdi2w5orldImcz6ab4esqFHPgb2zfXU7J0vwRpBqfcC5ww==
X-Received: by 2002:a05:6a00:3c8c:b0:7ad:11c9:d643 with SMTP id d2e1a72fcca58-7f22ce239b7mr34908b3a.21.1765312387979;
        Tue, 09 Dec 2025 12:33:07 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29ff6b55fsm16951337b3a.17.2025.12.09.12.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 12:33:07 -0800 (PST)
Message-ID: <183b0452-c538-40de-a33a-51db4a5dfa63@kernel.dk>
Date: Tue, 9 Dec 2025 13:33:05 -0700
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
Subject: [PATCH] io_uring: fix min_wait wakeups for SQPOLL
Cc: Tip ten Brink <tip@tenbrinkmeijs.com>
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
needed to wake the task to the current number plus 1. This should ensure
that any future events will wake the task, regardless of how many events
it originally wanted to wait for.

Reported-by: Tip ten Brink <tip@tenbrinkmeijs.com>
Cc: stable@vger.kernel.org
Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Link: https://github.com/axboe/liburing/issues/1477
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d130c578435..1a1fe05367d8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2538,6 +2538,8 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
 	hrtimer_set_expires(timer, iowq->timeout);
+	/* any generated CQE post now should wake us up */
+	iowq->cq_tail = READ_ONCE(ctx->rings->cq.head) + 1;
 	return HRTIMER_RESTART;
 out_wake:
 	return io_cqring_timer_wakeup(timer);

-- 
Jens Axboe


