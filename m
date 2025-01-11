Return-Path: <io-uring+bounces-5820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E55A0A09F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 04:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0091188B3B3
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 03:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A39819CD1D;
	Sat, 11 Jan 2025 03:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r/fYonRJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDF91990DB
	for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 03:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736566421; cv=none; b=d0AP+gQov9dcG1OvyGFBfNg0pnMOjcfKniZtnPlpJvSpwVwQaUXQLR7qfW7lHdSsnHOp4b/y1hWNN9Yj/z5R6um2BvHHCk+fjVz+j4+9Ki/PXYu3I5hROdvPJmfhu/RuLr1O1dm67oRZFGib0GkXkxtQ9T5edpIXdQikXxkfN3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736566421; c=relaxed/simple;
	bh=BFi5xFbwB2b0+fpMjFjnBcucoqX7Z5MCJy5sCqe+UQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Rq8JaCWii/vhzhj8/Hft3veYzPzRRkZhznV9LOHDgaWbvJo6SDhls79aUT/ramOzMSKM9Q2Au3X3aaF5QKZLaOadGpVNWVhgFF1VaoU+82+Gdo4vq9d8fx2NqiKzwqfLjeAQ7McE5gRZbVkJ6MLFpBxuDwKYwKgatkan2/9nkgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r/fYonRJ; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3cdce23f3e7so18646335ab.0
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 19:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736566416; x=1737171216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LrL3tBboriimTgVbAlmP6jkLPelsvtJH+bwBnQx1YIo=;
        b=r/fYonRJ5OreefYxqPyh36bse5X15DDrSG0ODnjybi+unnpz3m9cciqqU1IFkQq0uE
         PhfOzxvz79FED46UWY+UyI4bDlEhWRCQPBb+O+FwYZQktRxa/Fyh2VjCsJYExrJEmXLN
         zP/p30voS73/BFizirZeFRetsaHEFRTsJYITk6C73ozuh9Z8RJWl9Sh5/VHgnTCLYZDg
         nTPr6WvM9zMEs2tD1ORvMC3ODSeku1BLE66D+nQNTTNdWO1hV+wNH6QLDV5ylgvBoBvJ
         kBu9gK9vrZwyZwE5JUd42NlCOn4GZ8ug+P465Nnl7wfSHFBC8cDB6ylFKn1BbrnmcDTF
         orxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736566416; x=1737171216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LrL3tBboriimTgVbAlmP6jkLPelsvtJH+bwBnQx1YIo=;
        b=KRUI7W/kCNcr22uvRplvIze+2pQMSJAsPHOcbnzB7K+RaDH/OYehQRUNoXzjlKm+W/
         La+UibmUApMLfSDLHF63dKuPQz6n8bQlv4Ff+Dar4hG7Eli/jQNyPgbC74VCj5sQkU/1
         mX47yPWuSsv/vH9On50xcOZSWS39/1nydzxuQx6EMynKeW3oLQSZKqf26XrDsrtHvb0y
         but9TWgj4d2ZcHmZs4jlg9DtevZBdtTzVJB2/VAJggU37nhrySuQtgKE9PGkudy6LkXm
         o/LoUjI4GR1mdIMJd62v3cP/L8sEFG8yIsfxChkvLhcmuJMmuMFkBd0jKV3gPI/PoeWS
         LlvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLhdMiWdK8pzjdomvgH9BXTU+EvtRk+rcD2b9KQZjCyILuzupvEgiF9oJVCT+2hUs3/c7BanEQ+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZqPc2S3Dab42me1WsMf7gT4pyMxuXUgGwNpgwuT6siuiY3fjz
	rs6IhtBmtgDhIZ7weCJZhSPEWLvdZWUfPJGFmZVR20Sd3mDgvTAptTckANVJeaw=
X-Gm-Gg: ASbGnct8c9A3CA+ffipnP+rv0PrmeUxoMplFDIBK+Asw3XrnTDVCsr+t9/h0j3CPuDt
	xVW4ar6ibtvWu2bkuvgVwDs16ftHPV/LPkbyyDZ+Yx1pDt1DUji+orcx5eLZLn6rLrJ7z4aKwOq
	x4+1pEWsn4YDQ21NsXCcM0DJtMKul1biMmsJLnCjG9RcJPL91w0BAxjQ11NGIhjKtTyJbWyErmA
	pj0ycuI2gxJyjR1IM4NqVqkYWm2J1YEnDsGZWPzxO1qwzL+wnzb9w==
X-Google-Smtp-Source: AGHT+IGlrzYaPnVt6J+CpShPV3tQvbWK0kEiljd1tejoQM1KCkNHYEDfsBrYFKmrpyr6gf+UQ2+Szw==
X-Received: by 2002:a05:6e02:512:b0:3ce:3d5a:4520 with SMTP id e9e14a558f8ab-3ce3d5a4825mr72260755ab.17.1736566416329;
        Fri, 10 Jan 2025 19:33:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b745799sm1237535173.114.2025.01.10.19.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 19:33:35 -0800 (PST)
Message-ID: <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
Date: Fri, 10 Jan 2025 20:33:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
To: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/25 3:26 PM, Jann Horn wrote:
> Hi!
> 
> I think there is some brittle interaction between futex and io_uring;
> but to be clear, I don't think that there is actually a bug here.
> 
> In io_uring, when a IORING_OP_FUTEX_WAIT SQE is submitted with
> IOSQE_ASYNC, an io_uring worker thread can queue up futex waiters via
> the following path:
> 
> ret_from_fork -> io_wq_worker -> io_worker_handle_work ->
> io_wq_submit_work[called as ->do_work] -> io_issue_sqe ->
> io_futex_wait[called as .issue] -> futex_queue -> __futex_queue
> 
> futex_q instances normally describe synchronously waiting tasks, and
> __futex_queue() records the identity of the calling task (which is
> normally the waiter) in futex_q::task. But io_uring waits on futexes
> asynchronously instead; from io_uring's perspective, a pending futex
> wait is not tied to the task that called into futex_queue(), it is
> just tied to the userspace task on behalf of which the io_uring worker
> is acting (I think). So when a futex wait operation is started by an
> io_uring worker task, I think that worker task could go away while the
> futex_q is still queued up on the futex, and so I think we can end up
> with a futex_q whose "task" member points to a freed task_struct.
> 
> The good part is that (from what I understand) that "task" member is
> only used for two purposes:
> 
> 1. futexes that are either created through the normal futex syscalls
> use futex_wake_mark as their .wake callback, which needs the task
> pointer to know which task should be woken.
> 2. PI futexes use it for priority inheritance magic (and AFAICS there
> is no way for io_uring to interface with PI futexes)
> 
> I'm not sure what is the best thing to do is here - maybe the current
> situation is fine, and I should just send a patch that adds a comment
> describing this to the definition of the "task" member? Or maybe it
> would be better for robustness to ensure that the "task" member is
> NULLed out in those cases, though that would probably make the
> generated machine code a little bit more ugly? (Or maybe I totally
> misunderstand what's going on and there isn't actually a dangling
> pointer...)

Good find. And yes the io-wq task could go away, if there's more of
them.

While it isn't an issue, dangling pointers make me nervous. We could do
something like the (totally untested) below patch, where io_uring just
uses __futex_queue() and make __futex_queue() take a task_struct as
well. Other callers pass in 'current'.

It's quite possible that it'd be safe to just use __futex_queue() and
clear ->task after the queue, but if we pass in NULL from the get-go,
then there's definitely not a risk of anything being dangling.


diff --git a/io_uring/futex.c b/io_uring/futex.c
index 30139cc150f2..985ad10cc6d5 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -338,7 +338,12 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
 		io_ring_submit_unlock(ctx, issue_flags);
 
-		futex_queue(&ifd->q, hb);
+		/*
+		 * Don't pass in current as the task associated with the
+		 * futex queue, that only makes sense for sync syscalls.
+		 */
+		__futex_queue(&ifd->q, hb, NULL);
+		spin_unlock(&hb->lock);
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
index 99b32e728c4a..2d3f1d53c854 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -285,7 +285,8 @@ static inline int futex_get_value_locked(u32 *dest, u32 __user *from)
 }
 
 extern void __futex_unqueue(struct futex_q *q);
-extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb);
+extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+				struct task_struct *task);
 extern int futex_unqueue(struct futex_q *q);
 
 /**
@@ -303,7 +304,7 @@ extern int futex_unqueue(struct futex_q *q);
 static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
-	__futex_queue(q, hb);
+	__futex_queue(q, hb, current);
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

-- 
Jens Axboe

