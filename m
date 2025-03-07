Return-Path: <io-uring+bounces-7014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D28A56DF8
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D37877AA6CB
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DA923E242;
	Fri,  7 Mar 2025 16:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XR34Bs0h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C851623CF06
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365510; cv=none; b=bfLEvBX7+yM1VsS/KW0urVDseWh7uGwrA+Oj5rZa0dQ/4C1TcRcI6+LHZEgF9reVKTPCv/1p8abLMOQOM1vX5HacXsbsGce7vVa2QtN8VbSSRU8u3q1zsSw7vdytSIK/l8wM/qAaJw+g6KutP/+ntPviuum2T+XWVSmDNKZQnWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365510; c=relaxed/simple;
	bh=pPXL/isy15to+99HM9MMDlj0lOJ6uynPfv29x606Wag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fw/q3VWLx+XiouCIoWmvJ/LabNkK4RtSZGqxxU36NaO0Hq08GjTRZO2+PTIkj3SQF2Kwb9265BBwNo8UcxIRgEtpL9JDWhqdqL2fl7pcCqshkuRD5uzUQbjwWjMeLNnMq+gInqXtyoHXI8P2nC5HRuUREjXe6PGgje8xsJigMi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XR34Bs0h; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85add719f7aso61401339f.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741365508; x=1741970308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ybA+5EEmFKNdJ63NMrvySBU5slBwFK6pu41iL70gnsg=;
        b=XR34Bs0h1PKgl1OahOyZZ9+5H1kBG+znbnAWm91pwVH3hOp2VM2XzUn2IK2fLqDDLu
         YIHqusyI/TjUSTuZNc7P9eIjynvFIlCViqlq6ZDO9QVxlIEkzZTLYXTvrJ8we9EdUrgj
         jfxPNYgfnHmub0MjrnzQjznxQYXaZFgM4j/G/tbi4rhN1lAM//X3NGk9osZlPn0d6UyM
         jWQNFEYMtZ0zdDSVRhIL/GTUMeaimEOxbhgy1lbQNgmfIps3ejyXImRSd4hqPAo3D4Mw
         ZeJrb1Y8RdfsBkrzFjt2Ss6FBOjhhF25iuLDKLgwfd9aAmgtf6UDS2okN71qb/f5WQ4K
         CFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365508; x=1741970308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ybA+5EEmFKNdJ63NMrvySBU5slBwFK6pu41iL70gnsg=;
        b=KneXVYsYvZRLq6K3Q7LOkqjpu+G9rIJXJK4qmU5iHurLcnfzM7vyoRZCP37Vm5vwsJ
         qrY8bNFRWTJrpAadnaCYZaHM4gPkBnN365J3jzJBL58yqFCZcvq6WX9mN+UEZVkMnONJ
         tFrvEfkqs0cgtvOKD9bGKErNQKwfc8hfBvIViWySiT4zzoc5KzTvd7ThNmMfrtP5JLnj
         bpyRKF4DDryWRaE5a+hCW+mbTahAUg72EhogWKPu0fUvGYyJD8Dp7KkmROWcb9oFffLO
         1yMHD7qWjeI7ByXJNf1NtI1nAmpK7yH9nCNmi80fnpNW6YBIt6tTNJ6NAs+vPyAWIDui
         NaYA==
X-Forwarded-Encrypted: i=1; AJvYcCW4oLHDiviZnFo1konxwI7aZg+CFyRpuZigD4mCvsShg6P46WQZ2HWDX7KK+Ge/hKZkSHtJWczl0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxK+Sl+mSMh0NqS/P6zz8UJZSs2/mPDm7sT1rVYdtUiVs0+U7O
	arYlBWhBUlJQbliBq9we2E3i+x8gIGXFg88znmsKHnQSYYKvrs0f+L+zUle9W6P+bVyxWzzMgIF
	c
X-Gm-Gg: ASbGncv0EYwRrPUeUgRSnY5NaslX2IHugtImW0b9znxwBD9IU0c3oqXFHon/Lwg2lRH
	xoejjb0tAnEPPJqBIpy5fvlNbG0/8SxTKPHJwqUUJ+H/RNS5d8UOFMyifeTfCnhwDEOayyp0wUt
	OsPgesqPS9S4CrPCmZH5OxqlYBjdOmluUniBeVs8d2rl+QFOKPclrONwRUylFoOn9PMfet+UFoY
	uh3LsDdziDzt1VFvZDAce3LMv0G5MxGF+fQBMMnizENCzHaU6EGhYf4cewNIIhFjdIZJ0bWisT3
	Mc5FpB8mekoYEtEtBNbxLdgKSPlYVJtK68mYQd6+
X-Google-Smtp-Source: AGHT+IFXnu+ZVuExRLXAMFL77qJU20P86s6MIkDCRS8MHKyVaXM1QMQX4366yYXTzscbD6IJMPtNRA==
X-Received: by 2002:a05:6602:4c8e:b0:85a:f8e6:d6c3 with SMTP id ca18e2360f4ac-85b1d125756mr460052839f.9.1741365507842;
        Fri, 07 Mar 2025 08:38:27 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209e15545sm1022343173.41.2025.03.07.08.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 08:38:27 -0800 (PST)
Message-ID: <ccfd73e6-7681-4c76-bdc6-7dd7e053e078@kernel.dk>
Date: Fri, 7 Mar 2025 09:38:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org
References: <20250307161155.760949-1-mjguzik@gmail.com>
 <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
 <CAGudoHGina_OHsbP_oz5UAtXKoKQqhv-tB6Ok63rRQHThPuy+Q@mail.gmail.com>
 <5a0ddd31-8df1-40d7-8104-30aa89a35286@kernel.dk>
 <CAGudoHFE8D4itzs=DC14cJpRo-SNqJTz7J4g5B0VsjrNuE0_pA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAGudoHFE8D4itzs=DC14cJpRo-SNqJTz7J4g5B0VsjrNuE0_pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/7/25 9:35 AM, Mateusz Guzik wrote:
> On Fri, Mar 7, 2025 at 5:32?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/7/25 9:25 AM, Mateusz Guzik wrote:
>>> On Fri, Mar 7, 2025 at 5:18?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>> +static inline void makeatomicname(struct filename *name)
>>>>> +{
>>>>> +     VFS_BUG_ON(IS_ERR_OR_NULL(name));
>>>>> +     /*
>>>>> +      * The name can legitimately already be atomic if it was cached by audit.
>>>>> +      * If switching the refcount to atomic, we need not to know we are the
>>>>> +      * only non-atomic user.
>>>>> +      */
>>>>> +     VFS_BUG_ON(name->owner != current && !name->is_atomic);
>>>>> +     /*
>>>>> +      * Don't bother branching, this is a store to an already dirtied cacheline.
>>>>> +      */
>>>>> +     name->is_atomic = true;
>>>>> +}
>>>>
>>>> Should this not depend on audit being enabled? io_uring without audit is
>>>> fine.
>>>>
>>>
>>> I thought about it, but then I got worried about transitions from
>>> disabled to enabled -- will they suddenly start looking here? Should
>>> this test for audit_enabled, audit_dummy_context() or something else?
>>> I did not want to bother analyzing this.
>>
>> Let me take a look at it, the markings for when to switch atomic are not
>> accurate - it only really needs to happen for offload situations only,
>> and if audit is enabled and tracking. So I think we can great improve
>> upon this patch.
>>
> 
> I aimed for this to be a NOP for io_uring, so to speak, specifically
> because I could not be arsed to deal with audit.

Hah I hear ya... But right now it seems to mark it atomic for any of the
fs based ops, which is not really necessary.

>>> I'll note though this would be an optimization on top of the current
>>> code, so I don't think it *blocks* the patch.
>>
>> Let's not go with something half-done if we can get it right the first
>> time.
>>
> 
> Since you volunteered to sort this out, I'll be happy to wait.

I'll take a look start next week, don't think it should be too bad. You
already did 90% of the work.

-- 
Jens Axboe

