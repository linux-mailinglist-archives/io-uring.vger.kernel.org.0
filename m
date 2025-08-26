Return-Path: <io-uring+bounces-9299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AE1B3726A
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 20:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC3011B68674
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 18:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA06371EA5;
	Tue, 26 Aug 2025 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1+v7Q4AM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705FE1E51EB
	for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756233664; cv=none; b=dfMmU/Z6YNDp+b6+F7XwIiHUnONxQuKhPLTO5vEkMjFFHMyo9HRiGKARUVRQEXVCIl4r5TLGYPZ9Ted9D552f1s+dwyXQycSR5x44XQFq3SsfbkgtKoUOMCnLJ2elkMFVWBQ3cznuorKV7bHhqIGaAlEUMBUFXaWQ3S2NACL9nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756233664; c=relaxed/simple;
	bh=BlbpSk4yokjtrqnBA+4iqkMRKf/UnzKcfoT473DA3Po=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIAUG7T6GFqgidAHGTCaPwYY/Xek9zPxE0Tm8WbkZpxnN7Eqff4hLHQCEyEPnG4Fe7xl9rIMVmxKiyF8sKasgmuWA8YQwWOf7zfQdFLVRDhS4TMXkDDdnwFQ5xzjOG1sqrLLeMs74CPO4GRzyAajpb2uqZ+XJZXCldBwzijyqZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1+v7Q4AM; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-88470af142bso497256539f.0
        for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 11:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756233659; x=1756838459; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HMwIDevTAyBC6uoCpV6fH9S1XRGgzQHXbtpE8y4L2M4=;
        b=1+v7Q4AMk4M6+QjktHpyEPP8T89GB3ecBMSmEX5SKFZQuqPomeCoOojVBiRE/yC8ju
         Y+tmvfjm/QuAT2IJ1j7HSdyWLrdtX9atEMKq50ikPdCCYobFDyeZw7m6hAUBj/IXC8Vh
         jy2WZDuWgqRdyv57LzEbUXwkdrdHYgH8lnfRn43yqk+MQNxm8MNx8ymoy1pVrVsJVI2/
         2tRHErtrK3Id3eZqmiRf5JMTmALFoPXS4ZyEBCD4BgBDpkxuc486BZUkQjUYJiNug4ax
         LRBBDxpraZoMnDQwyxUh76717pobhkZHFKxgyIBf4SdDBdAXi9HMGesHTM/QTS7AOY6V
         K8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756233659; x=1756838459;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMwIDevTAyBC6uoCpV6fH9S1XRGgzQHXbtpE8y4L2M4=;
        b=rBQZ+URkFfmhBIVNoDR6VoYB5E9PzdNFkFS2jGIISbUTZGy2w/i3ns5C08cZwpkkoz
         Aoom0/sQpcfLRtTcLrPB3rcntGAYJiBT+FakNjd9jDZD9iUijGNlBCtjFj498RfCcsAe
         bqwcfX59hNuPCaRFSdzuun1qMayJPmmFJ41JNHzFzmrIu691HRjATQxVv0CauCmaKI/u
         Yfn9GoqS9Skrbz5E2JFAZP4jjaFrF7vw2SrS2mgzt7JUe/aYbWqoCrfw5xzduaJ0A2b3
         l/fft6aWts5Kc2nY+86x9jy44aSq8NC+ShjowmQwQhqv5Xt8Y41IAcEQadW+ubo3ddbz
         rDUQ==
X-Gm-Message-State: AOJu0YwPDaL7QUXGqfw1Lchat6ZIEPzbITSPAMSKA4/BuRgIndua1JvS
	EYZDFfOfjJJCKSdLkfqFherOMPE2LgcW00JrPPCLr5x+cywJbxrDEhR5sU9hd/kgcHxE/ot5aOR
	aCgSy
X-Gm-Gg: ASbGncvVOhjXrtVo4LD7ifYywbUYK7sj1oUXTUtWhmPwv6r6HPnrbRkIJTZcWh2BFOm
	bFi5RnjrPRenMqUHclhhiXaggGl58D0YCzsYUw8xVYZvoi8J0uflCUjdr9HebEnxX/hkCRzKTx5
	3AFU7bZaDzXfJ0dRq9HUV3nfLf1CSNSsjwaQ4AgEOnIoptJ38O1OjhbSqzZjV6SNDJDOi32z5bW
	AZ/HqSGiyI4UWmGpJekeDXU7bpRI9kMiYtNIld2gPGKRi71FtnQ8fNsCHBxz2R3w2gjKtEKXyw1
	3PJ0/iFXGqz52bKyP4fBe70wIffHqwAGvnqlzzqPY1/y4WeyluyOWJ7GVd250gfVJk5cLNxAvLt
	wFEUKvZ+yE3tLpb09kevsud1BQWqXxUs9ETHowf5G
X-Google-Smtp-Source: AGHT+IHXzqAXuy+XpIKDHVMvwUUS/UUvP7fOLNQKJbvlAimo1w55DEd0q1kkr8HuEcDrwLv1A9vAqg==
X-Received: by 2002:a05:6602:154b:b0:883:eb1a:c732 with SMTP id ca18e2360f4ac-886bd11f63bmr2329147439f.3.1756233659258;
        Tue, 26 Aug 2025 11:40:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8ff7058sm710759639f.28.2025.08.26.11.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 11:40:58 -0700 (PDT)
Message-ID: <5991889c-0028-4e60-988d-1b6cbef10f25@kernel.dk>
Date: Tue, 26 Aug 2025 12:40:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring: add async data clear/free helpers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <c93fcc03-ff41-4fe5-bea1-5fe3837eef73@kernel.dk>
 <CADUfDZqcgkpbdY5jH8UwQNc5RBi-QKR=sw2fsgALPFzKBNcbUw@mail.gmail.com>
 <810863fb-4479-46ff-9a2b-1b0e3293ee71@kernel.dk>
 <CADUfDZonRMM5kKm-PvOzLwjsEUeRKWv08FN8tOwExS9UQCndsw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZonRMM5kKm-PvOzLwjsEUeRKWv08FN8tOwExS9UQCndsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/26/25 10:10 AM, Caleb Sander Mateos wrote:
> On Tue, Aug 26, 2025 at 9:04 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/26/25 9:27 AM, Caleb Sander Mateos wrote:
>>>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>>>> index 2e4f7223a767..86613b8224bd 100644
>>>> --- a/io_uring/io_uring.h
>>>> +++ b/io_uring/io_uring.h
>>>> @@ -281,6 +281,19 @@ static inline bool req_has_async_data(struct io_kiocb *req)
>>>>         return req->flags & REQ_F_ASYNC_DATA;
>>>>  }
>>>>
>>>> +static inline void io_req_async_data_clear(struct io_kiocb *req,
>>>> +                                          io_req_flags_t extra_flags)
>>>> +{
>>>> +       req->flags &= ~(REQ_F_ASYNC_DATA|extra_flags);
>>>> +       req->async_data = NULL;
>>>> +}
>>>> +
>>>> +static inline void io_req_async_data_free(struct io_kiocb *req)
>>>> +{
>>>> +       kfree(req->async_data);
>>>> +       io_req_async_data_clear(req, 0);
>>>> +}
>>>
>>> Would it make sense to also add a helper for assigning async_data that
>>> would also make sure to set REQ_F_ASYNC_DATA?
>>
>> I did consider that, but it's only futex that'd use it and just in those
>> two spots. So decided against it. At least for now.
> 
> Makes sense. I think it could also be used in
> io_uring_alloc_async_data(), but it's true there are fewer sites
> assigning to async_data than clearing it.

Indeed, most of the setting happens through the alloc async data
helper already. And yes it could get unified with that, but then
we'd probably want to extend that a bit more to return -ENOMEM
too for the cached case, and futex has one of each. IOW, I just
stopped at that point :-)

-- 
Jens Axboe


