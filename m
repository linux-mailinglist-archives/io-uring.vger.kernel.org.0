Return-Path: <io-uring+bounces-976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 629F087D172
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CDDD281F4F
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA8D2BD19;
	Fri, 15 Mar 2024 16:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yNEPcTou"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7C946544
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710521399; cv=none; b=Ltuyc5raPjlUN+V1feyZozYh4+ZCcgLn9PfTsEcqgyTDXf8bivfY2B5Lu3HBvxKKnXXnLJcAltuCDEGCfGAFRxxZARSkZ3Pzg114kdsSJtgsXziPx2d+hazZ3liQFme/FpRpULxoFt5wPR7DUq8Z7wzmqppccKUEfETVelCee7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710521399; c=relaxed/simple;
	bh=SuR67F8XoDSI4HHwpfxzucTrAIlw/5RRUv+t4ymfrDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sPiHV3O4JemojwDO3QPySUdXvugjdFRL1DNRT2aXI/L5ki/asTgn4dqZi5YULVhftNeaKHe6HlBgmwG1Ta6zh01b8DEgTrV1IvBiuEyWc1Ye5yjqY4Uu+zUqQwRHsvMx0lmv1H2CUvJqgoB73rDRWydEz7AKIdkTftqVkH5iLYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yNEPcTou; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-366970716fcso1031315ab.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 09:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710521396; x=1711126196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TcNIOJEkoN1ZEY9DOqUfvfDlesxq21ySpxg2PgXUUsI=;
        b=yNEPcTou/23ccuShf9wBEGqKJfNn8AdwZfGWR93gD61gYSzUupx5MLJoaruYdP0Pm2
         bOoHgckw+rJwv91RUnDKc1d0uQbCWQKMEOpF9kE6FJ1yHmaymr2vb3M2ZE5Deeiqv8GE
         ZAlecgg+mDFM+CeAJlazS7J0TJq5UDsTtzh3j4jkEXITt3v+tIUoFbt13YAoYbRGBHvM
         EG+r7vsbYAWIKRETbdK14z98XnJeeTHSXnbxJV/MPYUJuANLkaFCM5nj2Phm/D2mdlT0
         CPm2+gpk9PJ/aNmVp1dBCIyGc4fPqQ7ZQ/v39Cnk23+4DX+HdcHeVGwYAYZ8O/t6eemH
         toEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710521396; x=1711126196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TcNIOJEkoN1ZEY9DOqUfvfDlesxq21ySpxg2PgXUUsI=;
        b=OzMBkHzB6Mpalr7qLNBRfVEGEp3vZIA7EIjGsXTFtGAxLL3/OM+qazdjOmL03ej3lq
         hJG8ji0K4QWuTGiZo/JKIQArX2sA0JtUMh0EPjz9FtjkeMZOut7qYBlTirV6tOo3iXR+
         Aj/oWO4Zyog7nUQBoFWBkLG4oPIulqgQdj4wfOSYIBRv8pYm4UBCeI3+yD2qea5W/N8z
         2RfU0gkjQaRnNI8HrMyYLbs4xq+YfAt1F277sc62p+7VnnAo3RdNwgDAKAlznW7sj7mw
         BnTELjQ7buUn/YsKxCSXFBs6OMaZ0NQ3XxOUbQJyfG77fA/vr9RLBpTC5/FotRU2s4Zf
         RqAA==
X-Forwarded-Encrypted: i=1; AJvYcCVUC9d3qwMs7rRzPo0KJIzkdL74sIcsjUmsJaLjMbku0oy+/esy8Ub6EJlacL9acRQw0Tc8eGeyGMHm9PksYDntFZ0cMIyP7nI=
X-Gm-Message-State: AOJu0YxB0u4pgavGi10FiGheQv76DGCgqMoqXcpHcZm9XU9XDjcWRUR3
	IphiirtI/886uc/4Ek2zxjacE57UkdByiyPTcr7vpFj20BjqxqO1qJ25B/GtHX8=
X-Google-Smtp-Source: AGHT+IENMSWc1EzmBcnNNtWnMB1MzK+qyFtFEFbexEPcQTwQf6Vzki/DkpyKy9Hur5/Y5M441eiO8Q==
X-Received: by 2002:a6b:6a10:0:b0:7c8:bb03:a7a with SMTP id x16-20020a6b6a10000000b007c8bb030a7amr2842909iog.2.1710521395844;
        Fri, 15 Mar 2024 09:49:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k23-20020a02a717000000b00476db13646fsm857327jam.86.2024.03.15.09.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:49:55 -0700 (PDT)
Message-ID: <0f164d26-e4da-4e96-b413-ec66cf16e3d7@kernel.dk>
Date: Fri, 15 Mar 2024 10:49:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
 <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
 <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
 <dfdfcafe-199f-4652-9e79-7fb0e7b2ab4f@kernel.dk>
 <e40448f1-11b4-41a8-81ab-11b4ffc1b717@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e40448f1-11b4-41a8-81ab-11b4ffc1b717@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 10:44 AM, Pavel Begunkov wrote:
> On 3/15/24 16:27, Jens Axboe wrote:
>> On 3/15/24 10:25 AM, Jens Axboe wrote:
>>> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>>>> On 3/15/24 16:20, Jens Axboe wrote:
>>>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>>>> completions by putting CQEs into a temporary array for the purpose
>>>>>> completion lock/flush batching.
>>>>>>
>>>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>>>> directly into the CQ and defer post completion handling with a flag.
>>>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>>>> multishot requests, so have conditional locking with deferred flush
>>>>>> for them.
>>>>>
>>>>> This breaks the read-mshot test case, looking into what is going on
>>>>> there.
>>>>
>>>> I forgot to mention, yes it does, the test makes odd assumptions about
>>>> overflows, IIRC it expects that the kernel allows one and only one aux
>>>> CQE to be overflown. Let me double check
>>>
>>> Yeah this is very possible, the overflow checking could be broken in
>>> there. I'll poke at it and report back.
>>
>> It does, this should fix it:
>>
>>
>> diff --git a/test/read-mshot.c b/test/read-mshot.c
>> index 8fcb79857bf0..501ca69a98dc 100644
>> --- a/test/read-mshot.c
>> +++ b/test/read-mshot.c
>> @@ -236,7 +236,7 @@ static int test(int first_good, int async, int overflow)
>>           }
>>           if (!(cqe->flags & IORING_CQE_F_MORE)) {
>>               /* we expect this on overflow */
>> -            if (overflow && (i - 1 == NR_OVERFLOW))
>> +            if (overflow && i >= NR_OVERFLOW)
> 
> Which is not ideal either, e.g. I wouldn't mind if the kernel stops
> one entry before CQ is full, so that the request can complete w/o
> overflowing. Not supposing the change because it's a marginal
> case, but we shouldn't limit ourselves.

But if the event keeps triggering we have to keep posting CQEs,
otherwise we could get stuck. As far as I'm concerned, the behavior with
the patch looks correct. The last CQE is overflown, and that terminates
it, and it doesn't have MORE set. The one before that has MORE set, but
it has to, unless you aborted it early. But that seems impossible,
because what if that was indeed the last current CQE, and we reap CQEs
before the next one is posted.

So unless I'm missing something, I don't think we can be doing any
better.
-- 
Jens Axboe


