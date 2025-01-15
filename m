Return-Path: <io-uring+bounces-5877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D156CA12795
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 029C21889775
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106B216A930;
	Wed, 15 Jan 2025 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AhlpPw3s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B51160799
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736955131; cv=none; b=mu6nS2rVZjihd4+JZNy0ZlDvrlbywcWJULzzaWVkRHcXCBxsl13yQicxCHZP9gVQGTtRnQG7otny0TCbQVYN0lcCje2zWxMHDJo4nR8P6eM5YVNIOFneRhIwXBLltZvvyTbzxYLGea0nDZ5IUFX8oh29cEY5Oe9eekdmnMWLV9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736955131; c=relaxed/simple;
	bh=ifcDq9UXcXAAmINYm2Dr5CR9Y2DxkgA3apIguz5Qcb0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ueLc1CqE2vz8W2dJg+aRCiqmdTcG55V2lntIHDRt2KkKZX4bcbnXmP47mE5PRHnZmFUCmgfmq7q5Ks4MkL35jvTI3ZptDJmXW0NENxAf5/Ewr47IFxVdQl9VxfQYoYtSuSUE3bRcYCPMQLoUC0Dv4cdqOOry8oZQzj43bRUaZ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AhlpPw3s; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-84cdacbc3dbso529395039f.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 07:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736955127; x=1737559927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YpIzzMm2kQy/gWFJKpiaDNjKMkP75xwtIkj0p7Z1/cE=;
        b=AhlpPw3ssgNsN7QDjs23a3eg7mQUcx4PdVGObtG4KWVCMUYWQIMv096+RGvtsB1RSL
         zFLakMqCsf6/JX+ndF9GQyuSX0RsQeCP5ZlJ7xmMgcgJPxOfcnGBA+UmcMDZHgOmSl3n
         DTYc6BvHgSAJ9GxUdJYJ15ocKW00CY3NwnYjRIxWr7YO9rrbBWfp4CdMZ2G9NQbNn7Fi
         xQ/13kFPdS56sJQMESBxASii2CI6OEJ+3t/5S/hPhvQSU6rZ2XKhTiH5sn/1NQedVqtw
         YMEe5SxzT+UEIoKg17r4v97+eGSAQ1YzhCepVjlF1+YGZoUEJChQh1QAJnfYpzsg0Ndp
         mtWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736955127; x=1737559927;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpIzzMm2kQy/gWFJKpiaDNjKMkP75xwtIkj0p7Z1/cE=;
        b=GVS3NNQOkwTMAKOSEUBapNNdrLnkrm9yciSY/UxDhkH5J7CIhLJ7fRGZ76PzLFDJi9
         2dnvghk/k87dvrlgyNnDTNAQiLwX9U1M5rU03AiE97vscbXdrhdBd1aKKrZILhpPbg0q
         uyNi4yATvA587LDvVmGs/Hl+N3SFAvmNBLrhsB3yNKxG4OaXFde2/8VxODKyOw200HIA
         KORlyfjF+DVAZbIiua5dbuLsUv/qgaAFW6xtGoP2TEoQ93ZoiTYWlDYnw91E0N3IRe07
         WLoSAz12Dfdl4MVjoclKiu8Ksx9kyfmZh75sUqDA3YiZ0NMgH6//KDicGIibjNVasVgn
         ZLFA==
X-Forwarded-Encrypted: i=1; AJvYcCUiNJAFDgrW2KcPx4fqpu44AREygmwOe7ms7wRCJ/og/XqmAqRfSdt9+tiPm5Ju7iYdg8skSIQRjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCRzvaZgDXTxelTR+Dm442w6SsGHjm4pZwtTaaX8Bl1sIL/4KE
	AZIiI5uW0lS3FsnqA0rBpRKGMq6V3KpWIx/UBZKuKXa0umZQqg3oLB2yDu2nLHY=
X-Gm-Gg: ASbGnctDEquyjCnf2pI6wXJGayw9E1tZkL7Kt/OxK5VrotaN8SYOzxFGQQ/XZ5xDJY7
	n9Qaj5bueNFPgL3y+AgturiejIrbwZaw1ESFw3L6eLadhfkGjlc1EYto7IV3JyYCk1SNu/Qu2Qu
	DzQ/lqYOLDkqTBDXzeEqoos0rMsF616pWpmA9fPV6GKz8IHEEbgXmnEPwSe9KwT6yJLpbHD9Nvz
	8zxj5ymCpZ+ao83hjTzywM61NAg6D919vskEsEjbqhzpNp1rXoq
X-Google-Smtp-Source: AGHT+IHT5EC03/WmOEboRexkPNC8EKnX1wwVVP1jalQzyaxn7UKD1Z4a/+BI50rU0+FtSraKsEnNGg==
X-Received: by 2002:a05:6602:6cc6:b0:844:debf:2c8f with SMTP id ca18e2360f4ac-84ce01a47ebmr2981297239f.14.1736955127433;
        Wed, 15 Jan 2025 07:32:07 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b6151f2sm4089556173.64.2025.01.15.07.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 07:32:06 -0800 (PST)
Message-ID: <5603e468-9891-46a3-9ef7-13830cc975e5@kernel.dk>
Date: Wed, 15 Jan 2025 08:32:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
From: Jens Axboe <axboe@kernel.dk>
To: Thomas Gleixner <tglx@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>,
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
 <20250113143832.GH5388@noisy.programming.kicks-ass.net> <877c6wcra6.ffs@tglx>
 <30a6d768-b1b8-4adf-8ff0-9f54edde9605@kernel.dk>
Content-Language: en-US
In-Reply-To: <30a6d768-b1b8-4adf-8ff0-9f54edde9605@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 8:23 AM, Jens Axboe wrote:
> On 1/15/25 3:20 AM, Thomas Gleixner wrote:
>> On Mon, Jan 13 2025 at 15:38, Peter Zijlstra wrote:
>>> On Fri, Jan 10, 2025 at 08:33:34PM -0700, Jens Axboe wrote:
>>>
>>>> @@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
>>>>  
>>>>  	plist_node_init(&q->list, prio);
>>>>  	plist_add(&q->list, &hb->chain);
>>>> -	q->task = current;
>>>> +	q->task = task;
>>>>  }
>>>>  
>>>>  /**
>>>
>>> The alternative is, I suppose, to move the q->task assignment out to
>>> these two callsites instead. Thomas, any opinions?
>>
>> That's fine as long as hb->lock is held, but the explicit argument makes
>> all of this simpler to understand.
>>
>> Though I'm not really a fan of this part:
>>
>>> +		__futex_queue(&ifd->q, hb, NULL);
>>> +		spin_unlock(&hb->lock);
>>
>> Can we please add that @task argument to futex_queue() and keep the
>> internals in the futex code instead of pulling more stuff into io_uring?
> 
> Sure, was trying to keep the change more minimal, but we can certainly
> add it to futex_queue() instead rather than needing to work around it on
> the io_uring side.
> 
> I'll be happy to send out a patch for that.

Here's the raw patch. Should've done this initially rather than just
tackle __futex_queue(), for some reason I thought/assumed that
futex_queue() was more widely used.

What do you think?


diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..f108da4ff863 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -349,7 +349,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
 		io_ring_submit_unlock(ctx, issue_flags);
 
-		futex_queue(&ifd->q, hb);
+		futex_queue(&ifd->q, hb, NULL);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index ebdd76b4ecbb..3db8567f5a44 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -532,7 +532,8 @@ void futex_q_unlock(struct futex_hash_bucket *hb)
 	futex_hb_waiters_dec(hb);
 }
 
-void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
+void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+		   struct task_struct *task)
 {
 	int prio;
 
@@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
-	q->task = current;
+	q->task = task;
 }
 
 /**
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 618ce1fe870e..11de6405c4e3 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -285,13 +285,15 @@ static inline int futex_get_value_locked(u32 *dest, u32 __user *from)
 }
 
 extern void __futex_unqueue(struct futex_q *q);
-extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb);
+extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+				struct task_struct *task);
 extern int futex_unqueue(struct futex_q *q);
 
 /**
  * futex_queue() - Enqueue the futex_q on the futex_hash_bucket
  * @q:	The futex_q to enqueue
  * @hb:	The destination hash bucket
+ * @task: Task queueing this futex
  *
  * The hb->lock must be held by the caller, and is released here. A call to
  * futex_queue() is typically paired with exactly one call to futex_unqueue().  The
@@ -299,11 +301,14 @@ extern int futex_unqueue(struct futex_q *q);
  * or nothing if the unqueue is done as part of the wake process and the unqueue
  * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
  * an example).
+ *
+ * Note that @task may be NULL, for async usage of futexes.
  */
-static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
+static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+			       struct task_struct *task)
 	__releases(&hb->lock)
 {
-	__futex_queue(q, hb);
+	__futex_queue(q, hb, task);
 	spin_unlock(&hb->lock);
 }
 
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index d62cca5ed8f4..635c7d5d4222 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -982,7 +982,7 @@ int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int tryl
 	/*
 	 * Only actually queue now that the atomic ops are done:
 	 */
-	__futex_queue(&q, hb);
+	__futex_queue(&q, hb, current);
 
 	if (trylock) {
 		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 3a10375d9521..a9056acb75ee 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -350,7 +350,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 	 * access to the hash list and forcing another memory barrier.
 	 */
 	set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
-	futex_queue(q, hb);
+	futex_queue(q, hb, current);
 
 	/* Arm the timer */
 	if (timeout)
@@ -461,7 +461,7 @@ int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 			 * next futex. Queue each futex at this moment so hb can
 			 * be unlocked.
 			 */
-			futex_queue(q, hb);
+			futex_queue(q, hb, current);
 			continue;
 		}
 

-- 
Jens Axboe

