Return-Path: <io-uring+bounces-8526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF15AEE502
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 065983B8A7E
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E24328FFCD;
	Mon, 30 Jun 2025 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lc87ou/x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23828DF33
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751302421; cv=none; b=nsZV243Y0X/8DURI7772+RD6hLChjKvuvXyteDvOm0mnmcEi0yfbJWVj1KYr8MHQpTLNzcQ7QUHMhgcE5I8hWje/3PH1iJNPb00MvLiPV4xh8EEc/yoGMqRQvonvbY0eSh94c9LQjNFFn089n1xykve6ASxhJA3xKYtBuTe00qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751302421; c=relaxed/simple;
	bh=9yV1tt0m+hL6Roc9KM9gs5hShPI8+4l3zLZ0IUk5t0A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=p8N1217OIqhSnWjs97mYePbzDA9b01JZvNsiDjH7pgosn2z+Wb9gx1mhOOWaRP16dD4C+Cum3kVl1PLgIskCq3yVOXrn2HrjVL5BNmClnUPOfnehh3CHyNwzq8s0o7GooY96SKuDT3+Oe4DQ2RpQWozAhYB9F1hnBTVwThxeGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lc87ou/x; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-af51596da56so2431200a12.0
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751302418; x=1751907218; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvYhR/kAsD3H6CkNeBsd9sdxiK60d92O18ySvnet2nA=;
        b=Lc87ou/xoFOJxnJmNoelhuO1NDDzJl5tn/FzgAhr1f8zWeblittkIFFcS5zqFbd+3l
         gTtnA6xzK6D365/n2UFhyPf0T9UH0reSa7hIQlU5uRa6psSWzuQZcgCEXxfKbkD68t3Y
         dQbom6kkiqmTMEsmhsftXF6a+XTnuCEIJYvXbVoGa92y+U2bUrWChVHGC8DcSHg8k6Js
         IFcGKvvD2koLa/ByiazpH7EvlK+o91dr03/MKPKhaBwf6RawpckM5YRRUXF3/eXp6u05
         PXztMsfOA0rtsoFM9BMNYkASdW71rZohMyOUTEvRhRhgrEoEORMxadCSoiJV+VyZ69lI
         EwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751302418; x=1751907218;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvYhR/kAsD3H6CkNeBsd9sdxiK60d92O18ySvnet2nA=;
        b=d/GJmFQctbHpALBnRXXNJvdcJAzfko/ylWdpWf1FvRUmdx8OFbjrW0RdE+b+KgeWnX
         F1bsVGgGlMC3FBKs/9ek72wxIfz1TNbGJBbzIixCXrjvTkdlYR8VPpEeD2/1Lt8q+fu/
         lxMniSysmwgI9TEMgHZofAa0CARD2ZJfVMihSFatH3YfF5smeYpWw6fhzr842OGfRAsk
         yEVfNPV7MpMJf4jVpJ5seO2C4D2mtMXBUJxts7PMLAYM5TGM9scWoD/8PFatXm315oPV
         zaMO29qWyCkEyTXOi2OUD399vnc9rk4PRZlh9ITaFIL8WtFwQuIx4h8G1tWOsAFrfrsb
         D+Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWRraGU76yocPz5+V8aBZ72ftnaXFG1MGB4bzy/2LkB8tzsDfybQBc05VstfNyB3k00rsnsxoOhyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlD1WjpHHDkK/l4WJaNoShfyHYr//6UrKo1goyDAv/PD68kouY
	b8c3e5TctYtvp3r5TBdH1Vi8WT8tWx7w6O17kj8V/lsIlnrutYFZG0Kk
X-Gm-Gg: ASbGncvm0c5Lh9II7x6cjqiF52Rh5n7BPgjIiil/GrBji9bcXCMXUesjRp8lbjrxH1O
	+z6sJJHtF76J/fpOSwgVpFM3CbsSalO7ewgKSPK2fNypVRVRdqu4babtQca2AYgodEDITn+T6j5
	s1rMvD5eWVN4/j6v64DIeqFWf0sxFwbY225YzQzd+KVH3PZLe6kyTt2rdJ53c0ALt6H4PzXjt+A
	9ruWmBbPvMeqyKipMLyosERu+FcDqZg+tzHOTyZXGix9TcBdVkcQfuUcyLtwVCMK5Jy+mQlTDOg
	RGjuvlfQ2kwNDoGRzlWHJ+tHuMojNW43UiAG55R4rw0PaM9QO015nXJVmiajHIHJON0c5YSDk/I
	nCjTR9pUKAw==
X-Google-Smtp-Source: AGHT+IFscc+xR3mIz7OY26R5SnWil0cuo23DkXrt7/196V8csaXWOQg/IZJJsrgZHKjiNunvUA0vvg==
X-Received: by 2002:a05:6a20:394b:b0:203:bb3b:5f03 with SMTP id adf61e73a8af0-220a1251b79mr23542078637.6.1751302417743;
        Mon, 30 Jun 2025 09:53:37 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:106::41a? ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af580638bsm9625819b3a.173.2025.06.30.09.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 09:53:37 -0700 (PDT)
Message-ID: <83b51c3b-83b7-4604-bd4c-94b5ab803cb8@gmail.com>
Date: Mon, 30 Jun 2025 17:55:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] tests: timestamp example
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1751299730.git.asml.silence@gmail.com>
 <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
 <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
 <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
 <1c1a2761-9e4d-4abd-ab43-e6d302092b6b@gmail.com>
Content-Language: en-US
In-Reply-To: <1c1a2761-9e4d-4abd-ab43-e6d302092b6b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/25 17:50, Pavel Begunkov wrote:
> On 6/30/25 17:45, Pavel Begunkov wrote:
>> On 6/30/25 17:20, Jens Axboe wrote:
>>> On 6/30/25 10:09 AM, Pavel Begunkov wrote:
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> A bit of commit message might be nice? Ditto the other patch.
>>> I know they are pretty straight forward, but doesn't hurt to
>>> spell out a bit why the change is being made.
>>
>> It's not like there is much to describe. The only bit
>> I can add is the reference to the selftest as per the CV
>>
>>>> +#ifndef SCM_TS_OPT_ID
>>>> +#define SCM_TS_OPT_ID 0
>>>> +#endif
>>
>> Otherwise it needs to be
>>
>> #ifdef SCM_TS_OPT_ID
>>
>> All tests using SCM_TS_OPT_ID
>>
>> #else
>> int main() {
>>      return skip;
>> }
>> #endif
>>
>> which is even uglier
>>
>>> This one had me a bit puzzled, particularly with:
>>>
>>>> +    if (SCM_TS_OPT_ID == 0) {
>>>> +        fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
>>>> +        return T_EXIT_SKIP;
>>>> +    }
>>>
>>> as that'll just make the test skip on even my debian unstable/testing
>>> base as it's still not defined there. But I guess it's because it's arch
>>> specific? FWIW, looks like anything but sparc/parisc define it as 81,
>>> hence in terms of coverage might be better to simply define it for
>>> anything but those and actually have the test run?
>>
>> That only works until someone runs it on those arches and complain,
>> i.e. delaying the problem. And I honesty don't want to parse the
>> current architecture and figuring the value just for a test.
> 
> #include <asm/socket.h>
> 
> Is that even legit?

Except that it doesn't work, nevermind

-- 
Pavel Begunkov


