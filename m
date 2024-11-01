Return-Path: <io-uring+bounces-4314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5B39B961E
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53D9A1F23271
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034791CBE8B;
	Fri,  1 Nov 2024 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yYREtZ0T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F61CBE98
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730480325; cv=none; b=htixwdRxWvj76bkiHWY7vJfMMctpju2UQ5kMcZHhH4Zb9bSIYx9k10tkLYSamQTWDq33Q006cW845BfyTbHFB/J3bPttkcLl8dZmExuKtxH5Rj8vf8M9+IECpywyuN9zczqU05vWIEEvAvrA8kzjjsR76MbEJpNjzAHBDHk6M/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730480325; c=relaxed/simple;
	bh=6DUe+nk1Kh+ft0WTdMLlOsj3w7T5VwTrn8ByUfTbiwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rq57eU8M8IDPtdhlpfloQqxLNVR1EB7Dk1fnqG5TxloE43uhrhZ1n29ST0vCimpei/NMKLbLGYnwuFmkJGaMqiswgylOenAlve9iDIpt2a9cDlfEAHHJekam5Ut55waG9t3nlxeQY4tuW7RMA0ieV8nlbwgymv8xujgbvSqxRWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yYREtZ0T; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20c714cd9c8so23732315ad.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 09:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730480322; x=1731085122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/VA+dHt5J8xk/6aqnoL91OL24tr4rsLEIUETDPMNOsQ=;
        b=yYREtZ0TkqII493y4LtVChT9Dpritg+Vo7ecNn1nZ7vaKYv1I1iSXcEdnMt1tKLBox
         nefWSRBf0KiJUHPZftnISK5xsErylI1hxA1P4tMipLAG3dPTgQ/6tqxMffLUnPsMbmYj
         Lpunj4tg4QSj/gXgJsavDpPniITIxZ46JzROu67gqJpMIPT8rBbZEywmyljPIolghjyg
         Z15ANR++je7ARYC2PS6tAm82g6K6/aZMz0qdw+bRQnfdsjkklHPHMUAu9oRWqGqj8JIW
         wguNpVYkgu5JlK41mP1iyyBboLXrw0PRtkHgp/541HkzYgiJmqeH/aKniAipW65W9k7O
         fnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730480322; x=1731085122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/VA+dHt5J8xk/6aqnoL91OL24tr4rsLEIUETDPMNOsQ=;
        b=MJ/4zlJ44/zigBll/Oi2aWxqHJXfaEXPi0H47yu4jwQ3Ia4fUNYsTmlZqxO6WFske+
         JojusWTEUknvoWT9zQNzQ2tII9oKGNKSMlIi+xWHjoqWgUV4ngMOCZAXvlwiuzZa0ccB
         AfMragxrdC2P0Y0pow+kkpqe4dmoSAA/WvZlb0Bk32AhBbMsV5PgtKuZcVVH5zFq+bP3
         7Vors3lE7EZprgOXsIajVDP84rmi7yzIw8PEGSuQVpdDf1w9FXs+KYJhMPmVYTH0s76/
         w4HT8Ej0T00aEWv7f5AvxYi64RJlU4DtL5sYU784h0KOvkVgh2wMSCOtan828FBpqA0f
         eEyg==
X-Gm-Message-State: AOJu0YwoGaFshf/HoBZxuIAsQe570eSWORp+AaA35m0vY/BZSAMe2Hau
	k8jak8hU78equb1JYmHj+vVHj+sDFFG51OV3XL0m77BVjC3q/xfNEIH5QnMwKwc=
X-Google-Smtp-Source: AGHT+IHvxkVkGOyja+qB55kurc1RJybZXkk7IOZmaE95tbbf/qP4wBeaUppb0UAC4Zmtq2ClQOeSKQ==
X-Received: by 2002:a17:903:2287:b0:202:13ca:d73e with SMTP id d9443c01a7336-2111af695f1mr50681205ad.28.1730480321708;
        Fri, 01 Nov 2024 09:58:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057a72a2sm23619605ad.170.2024.11.01.09.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 09:58:41 -0700 (PDT)
Message-ID: <200c1a3b-68a8-4b6c-8da4-fa0ef805dec9@kernel.dk>
Date: Fri, 1 Nov 2024 10:58:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora> <ZyRAKm0IQV7wWjhC@fedora>
 <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk> <ZyTm9rBQpy7WFdwK@fedora>
 <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk>
 <73389bbf-5fc6-4256-a76d-2a027154a0d9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <73389bbf-5fc6-4256-a76d-2a027154a0d9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 10:55 AM, Pavel Begunkov wrote:
> On 11/1/24 14:42, Jens Axboe wrote:
>> On 11/1/24 8:34 AM, Ming Lei wrote:
>>> On Fri, Nov 01, 2024 at 07:59:38AM -0600, Jens Axboe wrote:
>>>> On 10/31/24 8:42 PM, Ming Lei wrote:
>>>>> On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
>>>>>> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
>>>>>>> In hindsight everything is clearer, but it probably should've been known
>>>>>>> that 8 bits of ->flags would run out sooner than later. Rather than
>>>>>>> gobble up the last bit for a random use case, add a bit that controls
>>>>>>> whether or not ->personality is used as a flags2 argument. If that is
>>>>>>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>>>>>>> which personality field to read.
>>>>>>>
>>>>>>> While this isn't the prettiest, it does allow extending with 15 extra
>>>>>>> flags, and retains being able to use personality with any kind of
>>>>>>> command. The exception is uring cmd, where personality2 will overlap
>>>>>>> with the space set aside for SQE128. If they really need that, then that
>>>>>>
>>>>>> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
>>>>>>
>>>>>> Also it is overlapped with ->optval and ->addr3, so just wondering why not
>>>>>> use ->__pad2?
>>>>>>
>>>>>> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
>>>>>> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
>>>>>> just a bit ugly to use.
>>>>>
>>>>> Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
>>>>> feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
>>>>> fine to take the 7th bit as SQE_GROUP now.
>>>>
>>>> Not sure I follow your thinking there, can you expand?
>>>
>>> It could be one io_uring setup flag, such as
>>> IORING_SETUP_IOSQE2_PERSONALITY.
>>>
>>> If this flag is set, take __pad2 as sqe2_flags, otherwise use current
>>> way, so it doesn't have to take bit7 of sqe_flags for this purpose.
>>
>> Would probably have to be a IORING_SETUP_IOSQE2_FLAGS or something in
>> general. And while that could work, not a huge fan of that. I think we
>> should retain that for when a v2 of the sqe is done, to coordinate which
>> version to use.
> 
> A setup flag over an sqe flag for marking IMHO would be a _much_
> better approach. It doesn't take an SQE bit for nothing, you can
> parse and process it in the slow setup path, enable static keys
> for the hot path and so on.

Alright, if both of you like that, then let me rework the flags patch to
do that instead. If we go that route, then we can just defer doing the
actual setup flag until we need a new bit beyond filling the last
sqe->flags bit with GROUP.

-- 
Jens Axboe

