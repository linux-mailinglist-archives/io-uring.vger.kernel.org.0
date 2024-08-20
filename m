Return-Path: <io-uring+bounces-2860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 164A29590A4
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C32A0285260
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC660191F92;
	Tue, 20 Aug 2024 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMl4/fEy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D5014AD38
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724194015; cv=none; b=Nw+WKgkqcd4JgxPYeYhk17uDVp+tK+/kUrHHQgvRMQ1Q+9B92/dpc29awC6JcPcg6vbGbn8Q4orAe79GDTLJX5t+312W94cpt+FSC5dB/3eO/fvm5LpELWpXnxcS62n0AtX82vgMBwyPyIXK8TNw3XgGmvc0tWUPFEKe7APhr2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724194015; c=relaxed/simple;
	bh=lynTl0Cfj/2JRJxA1Q0Oh+JpH6oEGVX8nwAZn0C9nZ4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=L9smVrhKSS+feAx5O5M9wqLBRICXUR2kGpbNYX+wwFE/th+1AX8ljKt1wIyefxHYW+UB7cC7FPMSsRTn0n3tLY4VwpYaRjj8NHVX0S4R+TbLgqZ9umoUCTdCq7ck9NZAfvzJUhLCzfbFp62fc4zxV7SqPkW8GlWZ1rxeAx3erYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMl4/fEy; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8643235f99so208212166b.3
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724194012; x=1724798812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dC/uRp44+1WY+wK79nIkIKLNz6DGGW4sAwW1Tutpv1s=;
        b=BMl4/fEyt9JpIfY2XjP1Y5zW4J+YqEc9Xhnem7VTog64+WW844/KUKJPwePvHl847T
         SV4riUYR8lCxJWWg2pTFBH79YZ0Rn4qr2WlXFRc4VD/h2jwuRGxyT9T8EG+rpocThIWr
         raiCdtoNz6zMs+54pUStLCN51cF4Ih3UdH35MsOITBZHPxlhteIDExLug0g+KigXesqN
         QzqgV2SyR7m/sUj9yWDdBnpOEZBO57Pi0JiaObt/ISgXNHeAjm6cEMOaM4hwKimI3Gw4
         NctIhdBpckcyVWbxlmQZ+psKiN//BQ9D3saKiKLkiGGRNA6nLD9gQfI6y6AYKnvgw9Ry
         4hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724194012; x=1724798812;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dC/uRp44+1WY+wK79nIkIKLNz6DGGW4sAwW1Tutpv1s=;
        b=PxJmwuQ7FAsMPp0bXYqDGTd1oqY2RcO87qcHJuFmNljxIeku+HaW8eX/3BJIvu/upo
         SThfLWuYw19ncO6+MpyPGH4UVbyBBQgYERVDdACR322zXzPJhO7uNC7Y3QHwlpyjVdPv
         Jdxr2kxvKNxz6JJG+/xp2j7deI+zEDIss1FGNVYm2jloHWUDqElY0poNuIlrcc0IkIvn
         XD2lLOdHZq1azlo+kPm4MCVeLTjh0VofqY6HQPLQlOP4SpYPLJY905crLdwHZSUWpGd+
         DE6c4TpKgScfiOUjA4hldRsc/fmEC+GgdFKu3DUx0RsbBdnNws718TDTWYVn96D6z7/1
         5/UA==
X-Forwarded-Encrypted: i=1; AJvYcCVl/Vps38c4zlpgfHQAYJTqrsQSdLIY3xQPwbru1ohKF+FnJ4PWcjrJ9SHFqOxLv+ewSHMwELgL6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfrL5y+wt83+NPI7qILh1m6eUspUm4wjgboj2vnU+CnhLme37Z
	+hTMX946gPJtw8X+UEqhY7kCI8KRudZaI5J186atcy3NJMvG9Jxw5MdjTg==
X-Google-Smtp-Source: AGHT+IFjIAEXFbum0+6clX2czK/+Cyn9H8H96hEEVoqsyG98ZoOkU3xkafo0kIC44abFygYYei81iA==
X-Received: by 2002:a17:907:d3c7:b0:a7a:ab1a:2d64 with SMTP id a640c23a62f3a-a866f9d2811mr25056666b.58.1724194011915;
        Tue, 20 Aug 2024 15:46:51 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838396ce0asm815378466b.206.2024.08.20.15.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:46:51 -0700 (PDT)
Message-ID: <aa17480b-ce0a-4569-9f28-f44bdf057aa9@gmail.com>
Date: Tue, 20 Aug 2024 23:47:20 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <abbab9cf-1249-4463-88cc-85a51399a950@gmail.com>
Content-Language: en-US
In-Reply-To: <abbab9cf-1249-4463-88cc-85a51399a950@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/20/24 23:46, Pavel Begunkov wrote:
> On 8/20/24 00:28, Jens Axboe wrote:
>> Waiting for events with io_uring has two knobs that can be set:
>>
>> 1) The number of events to wake for
>> 2) The timeout associated with the event
>>
>> Waiting will abort when either of those conditions are met, as expected.
>>
>> This adds support for a third event, which is associated with the number
>> of events to wait for. Applications generally like to handle batches of
>> completions, and right now they'd set a number of events to wait for and
>> the timeout for that. If no events have been received but the timeout
>> triggers, control is returned to the application and it can wait again.
>> However, if the application doesn't have anything to do until events are
>> reaped, then it's possible to make this waiting more efficient.
>>
>> For example, the application may have a latency time of 50 usecs and
>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>> as the timeout, then it'll be doing 20K context switches per second even
>> if nothing is happening.
>>
>> This introduces the notion of min batch wait time. If the min batch wait
>> time expires, then we'll return to userspace if we have any events at all.
>> If none are available, the general wait time is applied. Any request
>> arriving after the min batch wait time will cause waiting to stop and
>> return control to the application.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
>>   io_uring/io_uring.h |  2 ++
>>   2 files changed, 67 insertions(+), 10 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index ddfbe04c61ed..d09a7c2e1096 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>       return HRTIMER_NORESTART;
>>   }
>> +/*
>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>> + * sleeping.
>> + */
>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>> +{
>> +    struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>> +    struct io_ring_ctx *ctx = iowq->ctx;
>> +
>> +    /* no general timeout, or shorter, we are done */
>> +    if (iowq->timeout == KTIME_MAX ||
>> +        ktime_after(iowq->min_timeout, iowq->timeout))
>> +        goto out_wake;
>> +    /* work we may need to run, wake function will see if we need to wake */
>> +    if (io_has_work(ctx))
>> +        goto out_wake;
>> +    /* got events since we started waiting, min timeout is done */
>> +    if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>> +        goto out_wake;
>> +    /* if we have any events and min timeout expired, we're done */
>> +    if (io_cqring_events(ctx))
>> +        goto out_wake;
>> +
>> +    /*
>> +     * If using deferred task_work running and application is waiting on
>> +     * more than one request, ensure we reset it now where we are switching
>> +     * to normal sleeps. Any request completion post min_wait should wake
>> +     * the task and return.
>> +     */
>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> +        atomic_set(&ctx->cq_wait_nr, 1);
> 
> racy
> 
> atomic_set(&ctx->cq_wait_nr, 1);
> smp_mb();
> if (llist_empty(&ctx->work_llist))
>      // wake;

rather if _not_ empty


  
>> +
>> +    iowq->t.function = io_cqring_timer_wakeup;
>> +    hrtimer_set_expires(timer, iowq->timeout);
>> +    return HRTIMER_RESTART;
>> +out_wake:
>> +    return io_cqring_timer_wakeup(timer);
>> +}
>> +

-- 
Pavel Begunkov

