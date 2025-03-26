Return-Path: <io-uring+bounces-7256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1FA5A72580
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 23:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BF721683A1
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 22:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85AD1F55FB;
	Wed, 26 Mar 2025 22:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NH+DuR3B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29FC82899;
	Wed, 26 Mar 2025 22:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743028847; cv=none; b=OwSYe5wrJ6SwI6jYT7OISCUguZHBcGwTUWxkCQK1vxbL/moAcmLYrjKeltDp68vtahPmmSXSClUN1HQbTZFF9eDyUNMldAS/y+3gO64i+kdNq9XD44gd79WP1JHu/qDIaIMXqVCQPW5TA5Lj6ltUhsWuxSmZWM2lvGeIzQARNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743028847; c=relaxed/simple;
	bh=L9A15sjzLr1fEWncr19j20ydfM7A+gAYG8NML9w9nKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N39AOSb7aczcv4AGyHXFZ1SF76xfN6n7s5Xjknxi7pYn8Yk+IlJpYknhRNuPxkm1bSteJB0cF0XfqU49NLUGzsgSLn9kqK3nMKpKUTe2IFGAf8UPcwUs24oC2sqejv6JcbRgZKK5Ng8e6yMm1MIHqlXcekpaUDjcHXfruFMBuCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NH+DuR3B; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac289147833so65407466b.2;
        Wed, 26 Mar 2025 15:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743028844; x=1743633644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XV50vEzrK1pDVZvoneCyBVVV/DstYz+cH9XtIlryO4Y=;
        b=NH+DuR3B77N95lDmvkKyCTdyYKoUYwxfOWOwicKKsuMEnZmDNJdlHFpokrFGn/Vcrj
         mIQdvA1zul5a06JlkuGLIwfDQOdNUNCZgPWWwettTh9C3PLsMqBFqd78IGLv4KnBRoDh
         tbVAVcRsN11XCta0OsI8T1RSaYUrLhoE05x7s3wbJraG4qF5WhstNYr3R9CSysgFGb/6
         oZhLsohhsKoq7TtrpsCY6tUEvrc7RZS6cOkx8XcPVGvZ8zNVzMO/krIPzYjGYu6bTcgH
         dGFGiW8jmPbQ+HHmLU+D4X5U/268rW1wUUNQt3+ten2XJLgkR0lwACvC/gQUJqyek6wt
         uWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743028844; x=1743633644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XV50vEzrK1pDVZvoneCyBVVV/DstYz+cH9XtIlryO4Y=;
        b=Os7Rh1wMF/vHnvlYEpKXz25WhwzDMCFXmiPg3wmgmby3x/pVfMXXpXFb2XNghDHgp8
         bBqJWbo29QdOizlktfvUN5nEkCrNRRL75rT3UwR+PTXa/OHZlwtMG27jViFlzno/0Ovl
         42d4O4ocnbRS3GnDTyQpE59aBdIJL3Q6Uq6r+hiFx1pMvk14YOlmCso7n29MwkQ4ddZ4
         qGcoqkCPcyY0PAELyLMep/G/rBFC1RXIAJcYuQrKUV+wvRU+BYBuw3Ni16MU9roluBKZ
         sHN9FeFqu6El1KDrkLKt0RVMGyQKWInx+KvE0YCLrTH9Lh5xK7b1JHcjMrhxcXE4MncT
         8ZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSAtq2caXIGWB3lDg9GmnSuJcSSdHL8nq+y9ccWvdHkYiVVppDiKRCe9yn5HrrT/Tqo9BYDsekfe/+e08=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc0pNBnbVPFhbY84SPiasrrTGomDITAurzuP74ULM955PTdvTC
	31G0QcuePR4UUTP2DALpqBW4LLzvF87/Y04QuiLYQi2wXDXBAFDPDFu78Q==
X-Gm-Gg: ASbGnct+riHarBXGKqxtlJSAkbfQZP1y1rUkiWPuxYS+5VkA3xoT7ljEwmmLxJmSwJX
	AwLhmaDKSrwMZn300L9sd1cNCYH9msnm0oWmLznGkbpc67jLsPfeHeHNAygmKnTZ35aBpj7calf
	nL/7PyVeM3SfSjfTTdh5nB6zDB2iYDazoswCVB1IPYq8rrDgh6pkfpUwy7+pLuPLVVVEiT5CpoU
	rTaODhL/S00Nb93mzHCVCKEHYMaiQXWVEWGSa5n7BSSvDKP3BMcvAoToypCO/AUb3jlnLFyNbHv
	lWU5UX5RZDIMuzKV4C18UG7Z+2PxelRol+l3bq/cw1SBTPmPMEaWpg==
X-Google-Smtp-Source: AGHT+IG61eFdSVp6Z+C4dXoYNCupfDKO+csq0BW5TxID1dFzHv41/oAlZoAKK+Xkv1PEo0FJyclu3g==
X-Received: by 2002:a17:907:6e90:b0:ac2:b1e2:4b85 with SMTP id a640c23a62f3a-ac6fae493e7mr86588866b.3.1743028843907;
        Wed, 26 Mar 2025 15:40:43 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.207])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef869f72sm1095396766b.32.2025.03.26.15.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 15:40:43 -0700 (PDT)
Message-ID: <e5fb965e-25a4-4f72-bc68-17ccd1fba794@gmail.com>
Date: Wed, 26 Mar 2025 22:41:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250325143943.1226467-1-csander@purestorage.com>
 <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
 <CADUfDZoo11vZ3Yq-6y4zZNNoyE+YnSSa267hOxQCvH66vM1njQ@mail.gmail.com>
 <9770387a-9726-4905-9166-253ec02507ff@kernel.dk>
 <CADUfDZr0FgW4O3bCtq=Yez2cHz799=Tfud6uA6SHEGT4hdwxiA@mail.gmail.com>
 <570272b0-4d96-4e98-bf73-e313cc49918c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <570272b0-4d96-4e98-bf73-e313cc49918c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/25 17:31, Jens Axboe wrote:
> On 3/26/25 11:23 AM, Caleb Sander Mateos wrote:
>> On Wed, Mar 26, 2025 at 10:05?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 3/26/25 11:01 AM, Caleb Sander Mateos wrote:
>>>> On Wed, Mar 26, 2025 at 2:59?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>
>>>>> On 3/25/25 14:39, Caleb Sander Mateos wrote:
>>>>>> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
>>>>>> track whether io_send_zc() has already imported the buffer. This flag
>>>>>> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
>>>>>
>>>>> It didn't apply cleanly to for-6.15/io_uring-reg-vec, but otherwise
>>>>> looks good.
>>>>
>>>> It looks like Jens dropped my earlier patch "io_uring/net: import
>>>> send_zc fixed buffer before going async":
>>>> https://lore.kernel.org/io-uring/20250321184819.3847386-3-csander@purestorage.com/T/#u
>>>> .
>>>> Not sure why it was dropped. But this change is independent, I can
>>>> rebase it onto the current for-6.15/io_uring-reg-vec if desired.
>>>
>>> Mostly just around the discussion on what we want to guarantee here. I
>>> do think that patch makes sense, fwiw!
>>
>> I hope the approach I took for the revised NVMe passthru patch [1] is
>> an acceptable compromise: the order in which io_uring issues
>> operations isn't guaranteed, but userspace may opportunistically
>> submit operations in parallel with a fallback path in case of failure.
>> Viewed this way, I think it makes sense for the kernel to allow the
>> operation using the fixed buffer to succeed even if it goes async,
>> provided that it doesn't impose any burden on the io_uring
>> implementation. I dropped the "Fixes" tag and added a paragraph to the
>> commit message clarifying that io_uring doesn't guarantee this
>> behavior, it's just an optimization.
>>
>> [1]: https://lore.kernel.org/io-uring/20250324200540.910962-4-csander@purestorage.com/T/#u
> 
> It is, I already signed off on that one, I think it's just waiting for
> Keith to get queued up. Always a bit tricky during the merge window,
> particularly when it ends up depending on multiple branches. But should
> go in for 6.15.
> 
> When you have time, resending the net one would be useful. I do think
> that one makes sense too.

If that's about "io_uring/net: import send_zc fixed buffer before going
async" please don't, because the next second you'll be arguing that
it's a regression to change it and so it's essentially uapi, and we
end up with 2 step prep with semantics nobody ever will be able to
sanely describe, not without listing all the cases where it can fail.

-- 
Pavel Begunkov


