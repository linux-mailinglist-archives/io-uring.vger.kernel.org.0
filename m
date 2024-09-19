Return-Path: <io-uring+bounces-3236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D3997CD72
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 20:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A086285639
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 18:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5002014A96;
	Thu, 19 Sep 2024 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e4m6h1h4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA271802E
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726769186; cv=none; b=UgycWtcHASLM3TuFxbiypGxgor4YuYqyFVE5nn6MmbkYbKlbl2MSjGb20hM4yWK1zIz6XRqax5IG+2f7m9zfyBzOCIxyy9YeffLySJ1leEwRJGqMG70d7lTh/jnQzshdeK19NnfMVWThaFD5y0KL2TefkNElyBafHXX+3EGW7P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726769186; c=relaxed/simple;
	bh=DD6cY3SKXXak9CLSwq6p41W027p732fkbMv1JBf9VRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d9x5Nna/fjSuQL6CsxpZaihx5EJZo75bcjuJfznyFqFcay5Rki42aKeS+hkdsTTLoAnvcJyb2lQr+uvEwW6QOo5brgakuf/ZkZf3mKxH8FUAv3gBIs2hguwGUYByHOYvKb3l1ZIXq86HuurGLgOqde5z1DwbnaKTaQHIiAmefeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e4m6h1h4; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5365aa568ceso1511950e87.0
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 11:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726769182; x=1727373982; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/yRalcoLOoTxxeKlYKZ2EH2F2XmpzAubeuTtTNpXkI=;
        b=e4m6h1h4TWkJCWK8LgPJgCsip0UhzYR0pjW0OXuXKuO4wcbyrOZ9XlmIt22N7/I+1a
         jyVqb4Gpi1eSncKtKSz4JZdIRtBEhKcKnMPJdPUswvvAPxY94vXRJhdPKjRGH/nLeK23
         CFM6D+N/z2/ySF3LCGJBFSG+rhyo8CcGbKob2vtV55R4+tgtruLrtBurdIdO1LHpHhqP
         PY5xKDmvQKOobjc5fE/snZRE1UYDsPjxz9VDBMPrfTi3Q6WeGQswLpDHWELUxTeoY3tT
         /KFTCTacovPr3Jpmwera0eHacKmQjjlGwazMSoUP/EQKSgiMlvRmnN4Rdgd1HnPAr/Vh
         LH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726769182; x=1727373982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/yRalcoLOoTxxeKlYKZ2EH2F2XmpzAubeuTtTNpXkI=;
        b=vN8g7mwPaWqx4ZFyuymrUghcp6+0O8c0wwL7dkvYJIEqc2xbOYKdd2J/uK0Q4DO6MF
         nelpQdha9ZcLa3Qk8bkFeoUJIzB+LQzuEZuWYZ4cUgvDyRFqV4/y916VJH+TUGMqP3sy
         lfvlOn/3jAnGhRgdgiDZh9iNFjRYOYqsdLNfyrpaTQYaQHBwSUqt9ZMHDrGSTytF8jto
         98x94W1l64KDCuXyYGEPwVDhJCq13FbmBt4I/f4u7jb/mYYK6WDDJdlnsKZ+yFV/9YEp
         hTlGGfNxD3hVnhnemyym51gSgalGr5zExvFBdVxnaTn8bHPKC3ZpCYA/hIc0uG6ohnvg
         b9xA==
X-Forwarded-Encrypted: i=1; AJvYcCWPuvPoH8i7nmlaAAXEF6ZLXgySdsvG0KPAR1xLY4BPs1DgBzo5OHzaj3dQWg4MHk2+jIcung4NHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLaCR5eUnNT5OPcF/oXqfYnjopxfkKBIU5pATyIFQ5lvZFeSXI
	wu/BhNaSOQVh0RoBtSNmdDrUEFR4XWN8wuyUNlzZ1fojDhQz3Sm7MD/azqA5t/s=
X-Google-Smtp-Source: AGHT+IEsUCasGMviloXcHIBr/na6S52s1/sxm4gwwaT6cxiLKAzl/fY9hjoOxzwh0sjewi0q6AQYzQ==
X-Received: by 2002:a05:6512:108a:b0:535:ea75:e915 with SMTP id 2adb3069b0e04-536ac3405f8mr127822e87.56.1726769181703;
        Thu, 19 Sep 2024 11:06:21 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9061330c1fsm741057466b.206.2024.09.19.11.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 11:06:21 -0700 (PDT)
Message-ID: <ed1cc6ec-eb5d-495c-bd99-3a0eb634f9ff@kernel.dk>
Date: Thu, 19 Sep 2024 12:06:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: run normal task_work AFTER local work
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
 <6e445fe1-9a75-4e50-aa70-514937064e64@gmail.com>
 <5ac3973b-fbbd-4a49-babb-6d2e3e8333f7@kernel.dk> <ZuxVpEjXoJrkTp-F@archlinux>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZuxVpEjXoJrkTp-F@archlinux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/24 10:47 AM, Jan Hendrik Farr wrote:
>> [...]
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 75f0087183e5..56097627eafc 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2472,7 +2472,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>  		return 1;
>>  	if (unlikely(!llist_empty(&ctx->work_llist)))
>>  		return 1;
>> -	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
>> +	if (unlikely(task_work_pending(current)))
>>  		return 1;
>>  	if (unlikely(task_sigpending(current)))
>>  		return -EINTR;
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index 9d70b2cf7b1e..2fbf0ea9c171 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -308,15 +308,17 @@ static inline int io_run_task_work(void)
>>  	 */
>>  	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>>  		clear_notify_signal();
>> +
>> +	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
>> +		__set_current_state(TASK_RUNNING);
>> +		resume_user_mode_work(NULL);
>> +	}
>> +
>>  	/*
>>  	 * PF_IO_WORKER never returns to userspace, so check here if we have
>>  	 * notify work that needs processing.
>>  	 */
>>  	if (current->flags & PF_IO_WORKER) {
>> -		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
>> -			__set_current_state(TASK_RUNNING);
>> -			resume_user_mode_work(NULL);
>> -		}
>>  		if (current->io_uring) {
>>  			unsigned int count = 0;
>>  
>>
> 
> Can confirm that also this patch fixes the issue on my end (both with the
> reordering of the task_work and without it).

Great, thanks for testing! Sent out a v2. No need to test it unless you
absolutely want to ;-)

> Also found a different way to trigger the issue that does not misuse
> IOSQE_IO_LINK. Do three sends with IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK
> followed by a close with IOSQE_CQE_SKIP_SUCCESS on a ring with
> IORING_SETUP_DEFER_TASKRUN.
> 
> I confirmed that that test case also first brakes on
> 846072f16eed3b3fb4e59b677f3ed8afb8509b89 and is fixed by either of the
> two patches you sent.
> 
> Not sure if that's a preferable test case compared to the weirder ealier one.
> You can find it below as a patch to the existing test case in the liburing
> repo:

I think that's an improvement, just because it doesn't rely on a weird
usage of IOSQE_IO_LINK. And it looks good to me - do you want me to
commit this directly, or do you want to send a "proper" patch (or github
PR) to retain the proper attribution to you?

-- 
Jens Axboe

