Return-Path: <io-uring+bounces-5087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EF79DAE3D
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19DCF162558
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 20:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49012010E0;
	Wed, 27 Nov 2024 20:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NOolMrL7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E6E13D518
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 20:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732737696; cv=none; b=pkQj8SFJUILtcsxUZuMATiK1NaC6BZy6fqY67AF0W8xbJYg7AsLpPKIEXGzvE5dGXRx1htSr0gdFXnTzJgR5B0EkyDYwJW9Yw/LrbWRGxCFmD4YqIteHQG2pOmpXAHJu3/VECKfwucghSEpesWzd+XSxjgguna+sZ0Gug1mTuc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732737696; c=relaxed/simple;
	bh=iGLSaQYvOpZLIRVOKm7zAxg5mxG+KrquynDIeaa/XyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fE2S5SNXnnzYEs5c6dTTBby3Ge0v3SyVj+SQtfYIZ8LV2atk/2vNSgLK8yBrV4XbH7UTkkx2XxhJCHj3juq0NlOmECASFnO+C3hwK6vGgjPLsxHvMjlMknHQGODCM0qRbgrzCBghAyv2aW7NHosWI8vp/0Me1fuNbmy2PdDFShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NOolMrL7; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-27d0e994ae3so113946fac.3
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 12:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732737693; x=1733342493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGAs9+TLtxCXXP5blBGV1RPMNvOSXa/kEVbzs2tZuvQ=;
        b=NOolMrL7FzEuUVnGdtu2bp7yFYuj30HpHrEr+g1gEUn4jXglpmL+Ga+ysxooboP7qJ
         qwo2KXZM9nBvbyOGqRL9C+WyEqPDh1h7Uw0hq42LMtFSwbOMOGaS5rc/QqmSdYN9mVYG
         Ia4/VVqnihciMVIK4qQHZAV/lmtyJ4ukL0NAgfTDCoeLzxf3mAYK9m0L9XJ9C+3fwllU
         jp/LWbg/KYCA+Bq1Wn6xxyDyT67Xahr3TWxSxCg3I/2iIaevDG8wHwc7zsfag8+CMClS
         n4BLcHLzhWKRov6+OV71baVN+ttFCXiODDxvGdZ8FXgwwZ9/I3olDwNCFv3H/1dVxg7m
         KKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732737693; x=1733342493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGAs9+TLtxCXXP5blBGV1RPMNvOSXa/kEVbzs2tZuvQ=;
        b=EI3T3yCOy/VMWG0451ZsQhpITzb+6Bep/HVrJuRlH3kf59z1RzpiNpY+O73k/yaF7G
         +ZRevI3C4tz+GVreXmf+a/GcAuLIdAUDiYbHAUxvxsVloCpt6dwv4T0MRX/t2fn+pGIm
         iEkCCb62YUI+uAw9x8HRRjb0B5opzYypETTUwIR7ZwGCZujsXLdUhW4Pdz2xx7HGzGSy
         ofNsn037Mf/cQ0AlnaI5iwKBnsN0KmwE1NQi5ebOKpJO1yVKhUjfWALdm2+GpCRc2k6H
         14+EIcqUJ2aDwKt9ACWsQJvSC0AKmANm3aEwIXIUO/aBez60Myw7ZeD2bvOmLZ1+IVZm
         T9yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI5BgdN6U7HOpJ+M2rqV7+9jXWOGmqBIFQh7EwUJL4LW31tVIAulWwZX0iew2uMo7F0udchadcgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXTjFxj983bLKNovFlkM03kBLvHwJGVB4jRBL2GbBKhl5Ob3xl
	7R+XjQDHB2OQqrE2zitTUnZCAJ3i1dyxRKMTukLrHABxNdyUSPe2LMvr+UTstKU=
X-Gm-Gg: ASbGncs66d1lPmxVpkbdD4eF754mAssy0LCHt3ygvv0y7xIaqeyeLQm3Z5eG85eiPHW
	0LSLhayl7NNfvgMaKcJQPLX4o2iG7Tr11mBin2zIV78txGr3uJy1iweBwUNKl6onVRnw8k39tCV
	Gq+fgoVpi3p3M+WNqk/tGftW+pNzOn9QZe6inVYPv5DkGkayfbh9u5rRak+SaT8Tq06K2XblsZ6
	v+QzByjBJhKLduhYhUKu8rZKlaZCrLrD7hzXi/jVuuxuA==
X-Google-Smtp-Source: AGHT+IFF4P2YXnscplxiGukxPYkf09OAWc7B/D6urrQUWsAbwpbsXxn6dv3H+qNYpcsHs46pVmyu6Q==
X-Received: by 2002:a05:6870:828a:b0:296:e58a:fbbe with SMTP id 586e51a60fabf-29dc4189835mr4165584fac.19.1732737692603;
        Wed, 27 Nov 2024 12:01:32 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71d65a48895sm755944a34.63.2024.11.27.12.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 12:01:32 -0800 (PST)
Message-ID: <cd72e289-f671-4b8d-adb9-aebdf8a43afd@kernel.dk>
Date: Wed, 27 Nov 2024 13:01:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jann Horn <jannh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <CAG48ez1ZCBPriyFo-cjhoNMi56WdV7O+HPifFSgbR+U35gmMzA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez1ZCBPriyFo-cjhoNMi56WdV7O+HPifFSgbR+U35gmMzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 12:43 PM, Jann Horn wrote:
> On Wed, Nov 27, 2024 at 7:09?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 11/27/24 9:57 AM, Jann Horn wrote:
>>> Hi!
>>>
>>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
>>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
>>> (without any kind of refcount increment), and used in
>>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
>>> which are used to enable userspace memory access from kthread context.
>>> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
>>> guarantees that the MM hasn't gone through exit_mmap() yet (normally
>>> by holding an mmget() reference).
>>>
>>> If we reach this codepath via io_uring, do we have a guarantee that
>>> the mm_struct that called bch2_direct_write() is still alive and
>>> hasn't yet gone through exit_mmap() when it is accessed from
>>> bch2_dio_write_continue()?
>>>
>>> I don't know the async direct I/O codepath particularly well, so I
>>> cc'ed the uring maintainers, who probably know this better than me.
>>
>> I _think_ this is fine as-is, even if it does look dubious and bcachefs
>> arguably should grab an mm ref for this just for safety to avoid future
>> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
>> means that on the io_uring side it cannot do non-blocking issue of
>> requests. This is slower as it always punts to an io-wq thread, which
>> shares the same mm. Hence if the request is alive, there's always a
>> thread with the same mm alive as well.
>>
>> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
>> to dig a bit deeper to verify that would always be safe and there's not
>> a of time today with a few days off in the US looming, so I'll defer
>> that to next week. It certainly would be fine with an mm ref grabbed.
> 
> Ah, thanks for looking into it! I missed this implication of not
> setting FMODE_NOWAIT.
> 
> Anyway, what you said sounds like it would be cleaner for bcachefs to
> grab its own extra reference, maybe by initially grabbing an mm
> reference with mmgrab() in bch2_direct_write(), and then use
> mmget_not_zero() in bch2_dio_write_continue() to ensure the MM is
> stable.

Yep I think that would definitely make it more sturdy, and also less
headscratchy in terms of being able to verify it's actually safe.

> What do other file systems do for this? I think they normally grab
> page references so that they don't need the MM anymore when
> asynchronously fulfilling the request, right? Like in
> iomap_dio_bio_iter(), which uses bio_iov_iter_get_pages() to grab
> references to the pages corresponding to the userspace regions in
> dio->submit.iter?

Not aware of anything else doing it like this, where it's punted to a
kthread and then the mm used from there. The upfront page
getting/mapping is the common approach, like you described. Which does
seem like a much better choice, rather than needing to rely on the mm in
a kworker.

-- 
Jens Axboe

