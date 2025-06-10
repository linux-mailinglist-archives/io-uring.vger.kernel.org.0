Return-Path: <io-uring+bounces-8305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1690AD441F
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 22:52:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B391D18996A1
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 20:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC25A266565;
	Tue, 10 Jun 2025 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Lx0d45ob"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C1423506D
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 20:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588752; cv=none; b=m45MFjYRpuWY1MIAEKxSZVwx14BLDbJyJWk0d/+wzqoJuyoeBgqsiUrV3mDESu81iOLL5YJ8lX3Q4isWjMn38/d5oyeun+CGZ7Kqv5SPxNruZYr34TGZeojypeKNiel0rBgfswDpuU8UZkGVfA+zAVLQjr125dqMYY3Mc863hCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588752; c=relaxed/simple;
	bh=7qjKopyBMG4Q9fJsYFUNb0RVe+gICeSRzOtr5TU5Q4g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uSe/7ii6NCE1SL4vdjMcujaluV0d9LVYr3boFHboJ7T+PKaEiqRjGsbaT1m6VuxIq/tdJpCUf1KioGQFX7mtvxVgsa3LK5L3CGRSZMCSQfDnA4vjt6COS+K17CMmBn4Eyj/1jddM07kyVQXYFS2aQ6tDSh/VOMfc1/zUSgd6b3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Lx0d45ob; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso26693495ab.2
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 13:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749588749; x=1750193549; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=11eQzAdyWbEcyD+QmPa9dsHpaNwKoDskj65fJyqyOrg=;
        b=Lx0d45obFq52zWjyVsTQaKD44Xhz5yIgYLkTCMpQSsyaPUJXMoW15gKLY8JHhbzcON
         JnA7gTunODYuf7/jFAFRi9rf1Jy2CR7YotLHMnDXAGVtq7+SxzvX5QZRcm1ofOOSVwD3
         a0Tm3gjP00QP09Sz6OWtXtbpXj74d5GUNQ7ytjrMY07jpj6ZTzB3qTFVj9JH3KM/v5y1
         lByeiSM6BHgUiYBw1X/iyK/F4zxMRfTHSiLKRpfXyByTJFVFeK3ARLcUfbNr/0/MTF7u
         VUQsV4DPB5eUFjWXRxsEKPW1jBXexIw39RbRMsww7AnNUiA0rcTfPttTTbxLWJ9FA9x4
         VUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749588749; x=1750193549;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11eQzAdyWbEcyD+QmPa9dsHpaNwKoDskj65fJyqyOrg=;
        b=ZO5lrn2p50l4U8rZ8ldVx3KWj623yD/0T3yUjYlLKhgMOKNPwAHFm6riV/kYiyAEK/
         cQHVSMu98p2QaH2BZBw5Q11Zj0VtzM5Z2ysyCzcxnnP9FaFRkdCbV1fxxvUwoTpWEFYp
         imv4vkvX28O0uNOL0i8sk93X5xHndsCEHYTz6/2mHvr381R2eM0k9I1x5u2DtS8MVNhh
         GjALBR9H1hpUz09zF2pTKv8IqY96BQRq1s9m8ds4z/CV6cZ3Tgynl9HGkd9/lnw8fTAt
         Gi3izJHdkYmYZHEFd1/tAH1PPNm+MPs6+9Dhty9JJvzrlpm+SZ1qMLfc5n2PudfgQvqI
         w/zw==
X-Forwarded-Encrypted: i=1; AJvYcCUsVqZPrs2/NZGKuqHHOXsZmOmykf80z4Iy9mbqx2Jv8BKHaf+aUmnjaq3gVUQK1fU2ohJjbb/oPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtAds0jpSOv/JWKcY7rHHURcmDWLmhwihwe6fKl+wdDH7fQv3c
	fhOMoUhayCTLrbqXAyGkiPUMY6Zfr+AFzysLW+U9Rgg85R+m0rSZ8gFkOFyg/g+dtio=
X-Gm-Gg: ASbGncswlujYYscbhpYaqlHOdGx1AVmNbEIJqVlHQmB+9l17cstBUgjZhFNZUzcKPIg
	febyq2f5gWueGmRly+bzOjw1HozgjUjjEy7LeLrAlZ4VDKzFP0j5cJFDIKejItV6QksBfLMmVfG
	/uVhPuieamMyrKZt4TKSTTyHgFgSSQShVEWMpOOfDn4ETnMJAgw43IoY4BLXdiCRjrArpuYsu09
	p8V6t4+xoEeFZbYEmP+ZiAwbna78VE0LrA8zRAx9dS6a6nalUilmbszMOje0qaSNFf0DyABVuDa
	V3u1ZQ5FY+7p4nVzJEDlR3JPtVGxNuNs/eHqiR60/v2ImykqnQaXVqTYQhs=
X-Google-Smtp-Source: AGHT+IE0gKQ93A87c/xsyIhvmkN6rSQ265rF/huEJqYZaOyEOUc2dvACS3Ge02UKEKDoAbYtEwDb9Q==
X-Received: by 2002:a05:6e02:2142:b0:3dd:c946:a273 with SMTP id e9e14a558f8ab-3ddf4258ab9mr8628985ab.9.1749588749572;
        Tue, 10 Jun 2025 13:52:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddf475fb55sm606225ab.50.2025.06.10.13.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 13:52:29 -0700 (PDT)
Message-ID: <b482578b-3418-4f97-b676-41986630a5ee@kernel.dk>
Date: Tue, 10 Jun 2025 14:52:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: consistently use rcu semantics with sqpoll
 thread
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 superman.xpt@gmail.com
References: <20250610193028.2032495-1-kbusch@meta.com>
 <c2f09260-46c8-4108-b190-232c025947df@kernel.dk>
 <aEiToYXiUneeNFq_@kbusch-mbp>
 <f0e4a1f5-0571-4a69-afef-e8c845f19f47@kernel.dk>
Content-Language: en-US
In-Reply-To: <f0e4a1f5-0571-4a69-afef-e8c845f19f47@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 2:45 PM, Jens Axboe wrote:
> On 6/10/25 2:20 PM, Keith Busch wrote:
>> On Tue, Jun 10, 2025 at 02:04:41PM -0600, Jens Axboe wrote:
>>> On 6/10/25 1:30 PM, Keith Busch wrote:
>>>> From: Keith Busch <kbusch@kernel.org>
>>>>
>>>> It is already dereferenced with rcu read protection, so it needs to be
>>>> annotated as such, and consistently use rcu helpers for access and
>>>> assignment.
>>>
>>> There are some bits in io_uring.c that access it, which probably need
>>> some attention too I think. One of them a bit trickier.
>>
>> Oh, sure is. I just ran 'make C=1' on the originally affected files, but
>> should have ran it on all of io_uring/.
>>
>> I think the below should clear up the new warnings. I think it's safe to
>> hold the rcu read lock for the tricky one as io_wq_cancel_cb() doesn't
>> appear to make any blocking calls.
> 
> It _probably_ is, but that's entirely untested. Right now it looks fine,
> for a variety of reasons like submitting work that's marked cancel
> should not be doing anything with it really. But it doesn't feel me with
> joy, particularly as only the somewhat uncommon SQPOLL is the one that
> will do it.
> 
> The io_sq_thread_park() parts in the patch also look broken, as an
> rcu_access_pointer() is being passed into wake_up_process(). It should
> all be fine, but it's now a case of instrumentation actively making the
> code more confusing to read.
> 
> I think we might be better off leaving the sparse warnings and doing a
> proper io_sq_data accessor thing for this, rather than try and paper
> over the sparse warnings.

Ah we can probably get by with just a bit more work, something like
this per section should do it.

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 0625a421626f..8852e104ed68 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -46,13 +46,18 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->lock)
 {
-	WARN_ON_ONCE(data_race(sqd->thread) == current);
+	struct task_struct *tsk;
 
 	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
+	rcu_read_lock();
+	tsk = rcu_dereference(sqd->thread);
+	if (tsk) {
+		WARN_ON_ONCE(tsk == current);
+		wake_up_process(tsk);
+	}
+	rcu_read_unlock();
 }
 
 void io_sq_thread_stop(struct io_sq_data *sqd)

-- 
Jens Axboe

