Return-Path: <io-uring+bounces-8076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4082FAC0E19
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 16:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85F917A73D2
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 14:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7271428D8C0;
	Thu, 22 May 2025 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AcmcionP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E837528CF70
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747924152; cv=none; b=gv3a4qgkI9urCJsmg8oGEMspuVrzhedTethgzRd/Bo5L/Bo+XytUebil6PnDRugw0+m5GOfz+Ci4SKecaPGMhUfOwZRMKVnW5O0Xy+DsMfi0EmY+DvMrRXZ/BiZaBIOPEebtv7YpqISdO8dXZdxxZlUnOtiy2+fX/0VuBugmGEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747924152; c=relaxed/simple;
	bh=r2LZxWRstnfqOfz6zqOYkJsezvBQqEC0wh7WpiANxcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4k+3qplP3zuM+AyketnfKBILJKi9vHzmQ77GB7tEdxb8+4HmqtuVxHxXFrpWo15eDoqw+Tffj6zOUh1ujP+nnHulGUaxFvQJ7qE7ZKfcby0E020hGCETOmJq63olqRE/ELU1LfhTvwe4OT9rNZUnln0a9ZmPkVrnaLgf/pTxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AcmcionP; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85db3475637so286792939f.1
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 07:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747924148; x=1748528948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jox6fHChgx2DKpsUcWB+z7QcdOVB6yy+gzDP4Sg34eo=;
        b=AcmcionPidefJSydbBseZuxZ8s3OSZUn1re1leC0TLXzCP9jne/RdF7dolCGSe3HZc
         Znr9O8QNZtsrStGkMS1TgRGD+E++coojdqADkMB1yivL3OrUdOgtkyPOBBgkujP5TeS/
         J05pdPLJoH6gRxSHJfRwmHwKhQFF+bvVA5FXXA5cVUuojEUYSBQyGUIgji0joYwB9SKQ
         C9fVT8YTanSfN5p+6JWpMSoMJVcxc9/U9D/wsW98vaR1Kc4YKHytmldAy+J1m2PN3C1u
         7DrZ5f4gu+s6nvPc7ePPePuLiQSHTlMaHxH5AJuQXSr61HuO/pXdmyZEYR6BjWxS91/w
         c4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747924148; x=1748528948;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jox6fHChgx2DKpsUcWB+z7QcdOVB6yy+gzDP4Sg34eo=;
        b=rzQn5jsh+pPCVgjW0pdIh/F5vyKl8XieeDdM2xXu5fFyGpnEHjZpPieg5wvrQu3s+l
         TocZMK8nepGBzA0wX7XbvDbyieEnBG67MbqQByuA4roWMaA41MBmRORCNpsnmpj0mcgq
         S1hUZWaatFubJIy9DH4em2+DwaQhGLkV94iD7XoIm+YglDE28MC57JTtXwJKyS3IkM1I
         OKijPDaZlCUEOll3cZGtf2rBQUFO/I8MHVEp1kxL7Mr9iH01oDhk27KPNdcgIL4lmMcT
         gAkwKgsh2ZXvklvgKvbrKy9OHamcU8JMt3MCSSsGZtkS5hQZQ8Th2aoN6iCIt1Qf1vPn
         IXrw==
X-Forwarded-Encrypted: i=1; AJvYcCX0RD1XXFfLUwbH0KOuRpQ4VRZizSKD6KXK5EcLhEUGzHL3uVH4vZYnrtUDOhC7iyGDBANYRQBqpw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFg6LJe+LJF3zNwTpGbCHEhYqkmEfSAeiiE5ioAKZjz4PhoASR
	vyQPlRg2qSrhzTukL2/2epdORWY3GzEVEudZvZ4tXihFrYchdbbtW7s6xcTT5bsj8NU=
X-Gm-Gg: ASbGncv/0GocyqP8bOmRgSziWZC0mIuaIDpmk2HWW3kV0+/DKU8vZtNOyvKtOZ+Psnb
	30H453UH8toLnf9CiTEMetusYOIE7b37TUHkzO3DW2d8iAk67au5KzzyRlV1zKrV2ez4MKeXSiq
	fNDiAzAquRyAOdBJSREy8Ya56vvtDygW9oPyYavH3V2jUlq2Z2fSAQCuK33hGSNmW+B7Nw66NaL
	qg0X/y7YtLZQ5tkE+egvaBtlFxUDo6+0hGQZfBljOOYNh/Lhczfqd5dJmPVHlx8EsaKFdlYGWtc
	dSY/X7kSq6gGebtbIQhPdtiuan5XXhsmQzQXeCEpqjSsTCM=
X-Google-Smtp-Source: AGHT+IGN/wNIN2Gg430VbEDEGkh7ybOrIq6+S1g/X0QuvcVn2z4T3bBqJhNcyE4CdmPhkoa7Km65qA==
X-Received: by 2002:a92:cdae:0:b0:3dc:8e8b:42af with SMTP id e9e14a558f8ab-3dc8e8b43a9mr19548725ab.7.1747924147550;
        Thu, 22 May 2025 07:29:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc88f188c9sm6877135ab.3.2025.05.22.07.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 07:29:06 -0700 (PDT)
Message-ID: <356c5068-bd97-419a-884c-bcdb04ad6820@kernel.dk>
Date: Thu, 22 May 2025 08:29:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [RFC PATCH] io_uring: fix io worker thread that
 keeps creating and destroying
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 Diangang Li <lidiangang@bytedance.com>
References: <20250522090909.73212-1-changfengnan@bytedance.com>
 <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk>
 <CAPFOzZtxRYsCg1BVdpDUH=_bsLEQRvsp5+x-7Kpwow66poUVtA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CAPFOzZtxRYsCg1BVdpDUH=_bsLEQRvsp5+x-7Kpwow66poUVtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/25 6:01 AM, Fengnan Chang wrote:
> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 19:35???
>>
>> On 5/22/25 3:09 AM, Fengnan Chang wrote:
>>> When running fio with buffer io and stable iops, I observed that
>>> part of io_worker threads keeps creating and destroying.
>>> Using this command can reproduce:
>>> fio --ioengine=io_uring --rw=randrw --bs=4k --direct=0 --size=100G
>>> --iodepth=256 --filename=/data03/fio-rand-read --name=test
>>> ps -L -p pid, you can see about 256 io_worker threads, and thread
>>> id keeps changing.
>>> And I do some debugging, most workers create happen in
>>> create_worker_cb. In create_worker_cb, if all workers have gone to
>>> sleep, and we have more work, we try to create new worker (let's
>>> call it worker B) to handle it.  And when new work comes,
>>> io_wq_enqueue will activate free worker (let's call it worker A) or
>>> create new one. It may cause worker A and B compete for one work.
>>> Since buffered write is hashed work, buffered write to a given file
>>> is serialized, only one worker gets the work in the end, the other
>>> worker goes to sleep. After repeating it many times, a lot of
>>> io_worker threads created, handles a few works or even no work to
>>> handle,and exit.
>>> There are several solutions:
>>> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
>>> create worker too, remove create worker action in create_worker_cb
>>> is fine, maybe affect performance?
>>> 2. When wq->hash->map bit is set, insert hashed work item, new work
>>> only put in wq->hash_tail, not link to work_list,
>>> io_worker_handle_work need to check hash_tail after a whole dependent
>>> link, io_acct_run_queue will return false when new work insert, no
>>> new thread will be created either in io_wqe_dec_running.
>>> 3. Check is there only one hash bucket in io_wqe_dec_running. If only
>>> one hash bucket, don't create worker, io_wq_enqueue will handle it.
>>
>> Nice catch on this! Does indeed look like a problem. Not a huge fan of
>> approach 3. Without having really looked into this yet, my initial idea
>> would've been to do some variant of solution 1 above. io_wq_enqueue()
>> checks if we need to create a worker, which basically boils down to "do
>> we have a free worker right now". If we do not, we create one. But the
>> question is really "do we need a new worker for this?", and if we're
>> inserting hashed worked and we have existing hashed work for the SAME
>> hash and it's busy, then the answer should be "no" as it'd be pointless
>> to create that worker.
> 
> Agree
> 
>>
>> Would it be feasible to augment the check in there such that
>> io_wq_enqueue() doesn't create a new worker for that case? And I guess a
>> followup question is, would that even be enough, do we always need to
>> cover the io_wq_dec_running() running case as well as
>> io_acct_run_queue() will return true as well since it doesn't know about
>> this either?
> Yes?It is feasible to avoid creating a worker by adding some checks in
> io_wq_enqueue. But what I have observed so far is most workers are
> created in io_wq_dec_running (why no worker create in io_wq_enqueue?
> I didn't figure it out now), it seems no need to check this
> in io_wq_enqueue.  And cover io_wq_dec_running is necessary.

The general concept for io-wq is that it's always assumed that a worker
won't block, and if it does AND more work is available, at that point a
new worker is created. io_wq_dec_running() is called by the scheduler
when a worker is scheduled out, eg blocking, and then an extra worker is
created at that point, if necessary.

I wonder if we can get away with something like the below? Basically two
things in there:

1) If a worker goes to sleep AND it doesn't have a current work
   assigned, just ignore it. Really a separate change, but seems to
   conceptually make sense - a new worker should only be created off
   that path, if it's currenly handling a work item and goes to sleep.

2) If there is current work, defer if it's hashed and the next work item
   in that list is also hashed and of the same value.


diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d52069b1177b..cd1fcb115739 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -150,6 +150,16 @@ static bool io_acct_cancel_pending_work(struct io_wq *wq,
 static void create_worker_cb(struct callback_head *cb);
 static void io_wq_cancel_tw_create(struct io_wq *wq);
 
+static inline unsigned int __io_get_work_hash(unsigned int work_flags)
+{
+	return work_flags >> IO_WQ_HASH_SHIFT;
+}
+
+static inline unsigned int io_get_work_hash(struct io_wq_work *work)
+{
+	return __io_get_work_hash(atomic_read(&work->flags));
+}
+
 static bool io_worker_get(struct io_worker *worker)
 {
 	return refcount_inc_not_zero(&worker->ref);
@@ -409,6 +419,30 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	return false;
 }
 
+/* Defer if current and next work are both hashed to the same chain */
+static bool io_wq_hash_defer(struct io_wq_work *work, struct io_wq_acct *acct)
+{
+	unsigned int hash, work_flags;
+	struct io_wq_work *next;
+
+	lockdep_assert_held(&acct->lock);
+
+	work_flags = atomic_read(&work->flags);
+	if (!__io_wq_is_hashed(work_flags))
+		return false;
+
+	/* should not happen, io_acct_run_queue() said we had work */
+	if (wq_list_empty(&acct->work_list))
+		return true;
+
+	hash = __io_get_work_hash(work_flags);
+	next = container_of(acct->work_list.first, struct io_wq_work, list);
+	work_flags = atomic_read(&next->flags);
+	if (!__io_wq_is_hashed(work_flags))
+		return false;
+	return hash == __io_get_work_hash(work_flags);
+}
+
 static void io_wq_dec_running(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
@@ -419,8 +453,14 @@ static void io_wq_dec_running(struct io_worker *worker)
 
 	if (!atomic_dec_and_test(&acct->nr_running))
 		return;
+	if (!worker->cur_work)
+		return;
 	if (!io_acct_run_queue(acct))
 		return;
+	if (io_wq_hash_defer(worker->cur_work, acct)) {
+		raw_spin_unlock(&acct->lock);
+		return;
+	}
 
 	raw_spin_unlock(&acct->lock);
 	atomic_inc(&acct->nr_running);
@@ -454,16 +494,6 @@ static void __io_worker_idle(struct io_wq_acct *acct, struct io_worker *worker)
 	}
 }
 
-static inline unsigned int __io_get_work_hash(unsigned int work_flags)
-{
-	return work_flags >> IO_WQ_HASH_SHIFT;
-}
-
-static inline unsigned int io_get_work_hash(struct io_wq_work *work)
-{
-	return __io_get_work_hash(atomic_read(&work->flags));
-}
-
 static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
 {
 	bool ret = false;

-- 
Jens Axboe

