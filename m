Return-Path: <io-uring+bounces-3238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE2D97CD9A
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 20:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FC181C20BDF
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 18:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E941BC49;
	Thu, 19 Sep 2024 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jWLAbX7a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42306FB6
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726770757; cv=none; b=M3kAJXEQrdQeezm1qIx0mhNl4amQj7x6r7DX130Tbe7bsdX2I/9XMYSHjnglXQ6oQalNlbKgC8mjNI2f7YfiOtK3uSnE3YVuEjpzKXTGZGwX6hZHgB0J4Zc6aG8+AmoE6C88Q6qAT2JryfhCPUDJfTkineccLCA7Cu5Y5M1cVS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726770757; c=relaxed/simple;
	bh=bAdUFdFrMSziTX6W6oKvb+2GqcmZ1JMnHX6oIYvO50k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4aczZ9v1KVfd4IWLdZo0Rgp3Iyk5BmibvW3jG3gFIIJ8MpeFjY1wJl1oBoqa+jk578kN5FGnGBXC9bRQ++hcRlHq5O4crI7oMJeUrX5GWzosFCOraeaKVWXJcNSqpcWUVQ9ZFuovNEl83i1iGMCbTs47TyspRQyIAwDEBNm9BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jWLAbX7a; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8d0d0aea3cso144911566b.3
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 11:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726770751; x=1727375551; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MxqX4gLR0khCHP2frOBv+tStWhQixK2k+pSW+qQ7Qcw=;
        b=jWLAbX7aLrpw+K5JTKvqibG5m0FSO5sgAgKhDmMMreNhZVTpNhHi2+XNa5/8fOEmDE
         k047RmfzGIm5dlIJPz/4m9EV3OQWnQ4e2luDqbu34fgtBU3LdIYIC/0lrxGBa6onVybm
         XiwMQ36Q2MO5URxZdCkJ6CsbmE3x3Si7nm/UcmZfrSMA4XBLMKJrwkyWrBvd3y93UMjp
         Ufm1ziVwhBQghv3eGxvrd6CRDrB5cJP8AdhV5BuWh7Gwko+KVy75IHNSGF5KShGmNeJ8
         sfpEE4QPiy8fu+J+NK3cZpL2vOCWcSo6zq6LtMaS/gnYKHtqxi8PliYsGPgr0YnOVgU6
         nhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726770751; x=1727375551;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MxqX4gLR0khCHP2frOBv+tStWhQixK2k+pSW+qQ7Qcw=;
        b=UF5adslAagSzeS9LzbjAq4wcwnjcHZFPi/EXL79WBFgRn72nGj3Jzu8eUJDwh2LHHy
         qfChd9V/VFhUR7RaFXjK9afWXhq63zKvVkJlDVvAFHwXuS3rVqX7q+RUSM40IuGCxTEo
         6nYp4mWwp/8T+3pwZSehJV4i9ddWNO6lfEcPrU6GAf5LH9mw1wBFnZYS0nDXO/Q0/GVU
         fuRhl6uYiukZM0uw13fOSUpkWWceDAoHL8X/j61KzyrTO3rJ2X2TgEM9w662bUVAgw3g
         fx2ZWr4iZBBrjn69MudsqMzOleCY44uR9SLSQn+LVJPII0PKuBUvYvZLvIyn1mDSbQhw
         eN1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/jMO40e2eWsZdGrgwCkIxD2yeapqaFWH8IM2xW4U2/5b96XxWCBXRMup4NFy5UY7jKHMHuiolHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTNRUpmMtGSFoTk+2ETQhf6BcokicCxQ5FcvlLpPDd2L/DDW+U
	F6DtxrRvJ+bYfMmVxTrwWUNXlOQN7vlBReHCEYMAgLyPaVYckxDmf2xOmucPIgI=
X-Google-Smtp-Source: AGHT+IHPfX2zMxVdkbW2wQ2iI+TVE7g80n4MGcpQnJu4qObzZbsrg/SQ/s1c7daNSysSyVatC1qVIA==
X-Received: by 2002:a17:906:99c5:b0:a8a:8de6:a610 with SMTP id a640c23a62f3a-a90d512792cmr11558966b.40.1726770750833;
        Thu, 19 Sep 2024 11:32:30 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a906132fa05sm744229266b.190.2024.09.19.11.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 11:32:30 -0700 (PDT)
Message-ID: <d352ace2-424b-457c-9922-8604724b7514@kernel.dk>
Date: Thu, 19 Sep 2024 12:32:28 -0600
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
 <ed1cc6ec-eb5d-495c-bd99-3a0eb634f9ff@kernel.dk> <ZuxuGwU172K2-Pik@archlinux>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZuxuGwU172K2-Pik@archlinux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/24 12:31 PM, Jan Hendrik Farr wrote:
> On 19 12:06:20, Jens Axboe wrote:
>> On 9/19/24 10:47 AM, Jan Hendrik Farr wrote:
>>>> [...]
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 75f0087183e5..56097627eafc 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -2472,7 +2472,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>>>  		return 1;
>>>>  	if (unlikely(!llist_empty(&ctx->work_llist)))
>>>>  		return 1;
>>>> -	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
>>>> +	if (unlikely(task_work_pending(current)))
>>>>  		return 1;
>>>>  	if (unlikely(task_sigpending(current)))
>>>>  		return -EINTR;
>>>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>>>> index 9d70b2cf7b1e..2fbf0ea9c171 100644
>>>> --- a/io_uring/io_uring.h
>>>> +++ b/io_uring/io_uring.h
>>>> @@ -308,15 +308,17 @@ static inline int io_run_task_work(void)
>>>>  	 */
>>>>  	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>>>>  		clear_notify_signal();
>>>> +
>>>> +	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
>>>> +		__set_current_state(TASK_RUNNING);
>>>> +		resume_user_mode_work(NULL);
>>>> +	}
>>>> +
>>>>  	/*
>>>>  	 * PF_IO_WORKER never returns to userspace, so check here if we have
>>>>  	 * notify work that needs processing.
>>>>  	 */
>>>>  	if (current->flags & PF_IO_WORKER) {
>>>> -		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
>>>> -			__set_current_state(TASK_RUNNING);
>>>> -			resume_user_mode_work(NULL);
>>>> -		}
>>>>  		if (current->io_uring) {
>>>>  			unsigned int count = 0;
>>>>  
>>>>
>>>
>>> Can confirm that also this patch fixes the issue on my end (both with the
>>> reordering of the task_work and without it).
>>
>> Great, thanks for testing! Sent out a v2. No need to test it unless you
>> absolutely want to ;-)
>>
>>> Also found a different way to trigger the issue that does not misuse
>>> IOSQE_IO_LINK. Do three sends with IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_LINK
>>> followed by a close with IOSQE_CQE_SKIP_SUCCESS on a ring with
>>> IORING_SETUP_DEFER_TASKRUN.
>>>
>>> I confirmed that that test case also first brakes on
>>> 846072f16eed3b3fb4e59b677f3ed8afb8509b89 and is fixed by either of the
>>> two patches you sent.
>>>
>>> Not sure if that's a preferable test case compared to the weirder ealier one.
>>> You can find it below as a patch to the existing test case in the liburing
>>> repo:
>>
>> I think that's an improvement, just because it doesn't rely on a weird
>> usage of IOSQE_IO_LINK. And it looks good to me - do you want me to
>> commit this directly, or do you want to send a "proper" patch (or github
>> PR) to retain the proper attribution to you?
>>
> 
> Sent the PR with one minor change (adjusted the user data for the third
> send).

And pulled, thanks.

-- 
Jens Axboe

