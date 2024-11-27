Return-Path: <io-uring+bounces-5095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB659DAECE
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43011164DE5
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264272010F4;
	Wed, 27 Nov 2024 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GYBl5RVy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964EE15575C
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732742190; cv=none; b=JiZfnXnpIGAOdijtBwxxGK7OELgaQFx/rEATDCw/3Fh5eERnsJF03aEft23xZuF/+12p0No2/oaN9BUYNkf3XI7vsNpFJD3bl87QZk3JQLb3aoZFV6zkV890wpDqYC79pwQhemZp1TtwIkg/IKyUGa2QtI0nvC24KvPZTk7LlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732742190; c=relaxed/simple;
	bh=Fxn1X+ehwaYhCHZcC8uTjSxCtiQcEenGfPonIBYz6Io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4DPKostoFM7eJrAXxVFehcy5hrT0DeJc4U3Gff9qokgwA/C5CMGLUc73crDXsmKfn57TtdlJAw5B42JTPP0aIARQXcjrqypBk7O8/kyYWi8rLbeiucQdrdo2956Qs/IuJ7Ov2I8Gff6YLjsgaAkJC2rnUNECVOnjBf0G9dORs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GYBl5RVy; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5f1dbf0d060so98640eaf.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 13:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732742185; x=1733346985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MbEQnkUxOaFhMn75+V9SHyVteV8uSDV/a8R/NVBNEOA=;
        b=GYBl5RVyNT8U5VdhEesQfi9osi82U4VEgWa7hwX6AoH3JQP0MEB+3k8gLrofVbUKZR
         iitzYOnwQgmQVcyiA4Zfm/PUUfsFoC6QoGCAUr3y9YxzOHVdxBwnHr/QVIk9lI8EFWNT
         lkJ7zGDLphK0mNHgYSN1z56xdyvlEWwtgpWc+KANXSkP/L4Vqrxb0AitTmVLEjhzczOW
         NvkiGlH1GhdBQjGdco8BifKBqwUkQgjtRnua3rMabnjyXBf2xRnqJZfBKRHbSKly11hm
         0ZialJqpYCv9SNR6FqWAEW8cOANDETAs4suErc10aZjirxtLUPhWilZOkY1WmZLM8Og9
         0jnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732742185; x=1733346985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MbEQnkUxOaFhMn75+V9SHyVteV8uSDV/a8R/NVBNEOA=;
        b=pW66QHEXVAzgvHoVNZSYXp/5Uvlb7RclunBJf4pNtbCZsYypMjiJxa5JdESCXSKuGc
         vBn2STmAHTGlXyPcW1vSIlEw6jwkySs8Z5r3D2w4wvU8F6ppZJgmri7pm0UKr5ay+Blc
         cZwgWLsW8WGyQXfVhQrMJRkjWXs1GCYpu+TXen6PTQGaxgQND1bw7oMn0sLTMcBv1rWh
         cZe27VZvqlsArexPA7NfObiFxTVf1KF6TkbXuJNAIuPtIJR/L7HNkMDJTCBhcHsyJZy5
         V7ctjjU/iqOEnGvIwoK1LizWj2jIm/zduwghAEC0H9H5MjjoVJmzWOWYHcm+I8rQ13WJ
         brsA==
X-Forwarded-Encrypted: i=1; AJvYcCUj/UjISpG3viNFb2ifaytSZXJprSruH+7XVvJFVh8xo2bv69QX2T/7wI3oKgi2H6oKmMyNvCnXFA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr46gSFTXxNL/I7hALx4K6dkCVHXo6UrNenFuPj1Ezki9C0DGq
	rCASgNLdOcIk/7XigXws/o2MEaOWLwFRewoFDw08rSxL2zx3eqdYX9R6uvX1dKSKMYD/6kotung
	uzaM=
X-Gm-Gg: ASbGncvW/vzcBHRlcLx7EhPcqOSyHgdqOF3mw0FSzhJEA88NZC9V3n4Tz7bhtgoTvUo
	ISYRLOwEDyR46SztM5Yy3Y/S3SMNTnMrPt5rvukx4FYFa0JhWhbZ0D3gqdIN5S8wG0kFb9hbvng
	6/UoYHxwWvvRVnsl03TfE13SvMJ8Fm7p5dyxag8rqL056ieu68F6LJuhIcL5bwSmpe19bGswI7R
	ccx8cm2N8tkepg+pDYYH9m7b56MlFT2d7mrlKrzcVHNRA==
X-Google-Smtp-Source: AGHT+IFts3eKwhVYVSrJDt3Jr4qUN9DnRFk2sgCqpxJYdxS758kSUN5q61EgEhIS5rtU7WG7aVXKOg==
X-Received: by 2002:a05:6830:4907:b0:71a:6c7a:e23b with SMTP id 46e09a7af769-71d65cb2c74mr4690905a34.16.1732742185581;
        Wed, 27 Nov 2024 13:16:25 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71d725638a7sm17780a34.43.2024.11.27.13.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 13:16:24 -0800 (PST)
Message-ID: <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
Date: Wed, 27 Nov 2024 14:16:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Kent Overstreet <kent.overstreet@linux.dev>, Jann Horn <jannh@google.com>
Cc: linux-bcachefs@vger.kernel.org, kernel list
 <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 2:08 PM, Kent Overstreet wrote:
> On Wed, Nov 27, 2024 at 09:44:21PM +0100, Jann Horn wrote:
>> On Wed, Nov 27, 2024 at 9:25?PM Kent Overstreet
>> <kent.overstreet@linux.dev> wrote:
>>> On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
>>>> On 11/27/24 9:57 AM, Jann Horn wrote:
>>>>> Hi!
>>>>>
>>>>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
>>>>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
>>>>> (without any kind of refcount increment), and used in
>>>>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
>>>>> which are used to enable userspace memory access from kthread context.
>>>>> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
>>>>> guarantees that the MM hasn't gone through exit_mmap() yet (normally
>>>>> by holding an mmget() reference).
>>>>>
>>>>> If we reach this codepath via io_uring, do we have a guarantee that
>>>>> the mm_struct that called bch2_direct_write() is still alive and
>>>>> hasn't yet gone through exit_mmap() when it is accessed from
>>>>> bch2_dio_write_continue()?
>>>>>
>>>>> I don't know the async direct I/O codepath particularly well, so I
>>>>> cc'ed the uring maintainers, who probably know this better than me.
>>>>
>>>> I _think_ this is fine as-is, even if it does look dubious and bcachefs
>>>> arguably should grab an mm ref for this just for safety to avoid future
>>>> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
>>>> means that on the io_uring side it cannot do non-blocking issue of
>>>> requests. This is slower as it always punts to an io-wq thread, which
>>>> shares the same mm. Hence if the request is alive, there's always a
>>>> thread with the same mm alive as well.
>>>>
>>>> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
>>>> to dig a bit deeper to verify that would always be safe and there's not
>>>> a of time today with a few days off in the US looming, so I'll defer
>>>> that to next week. It certainly would be fine with an mm ref grabbed.
>>>
>>> Wouldn't delivery of completions be tied to an address space (not a
>>> process) like it is for aio?
>>
>> An io_uring instance is primarily exposed to userspace as a file
>> descriptor, so AFAIK it is possible for the io_uring instance to live
>> beyond when the last mmput() happens. io_uring initially only holds an
>> mmgrab() reference on the MM (a comment above that explains: "This is
>> just grabbed for accounting purposes"), which I think is not enough to
>> make it stable enough for kthread_use_mm(); I think in io_uring, only
>> the worker threads actually keep the MM fully alive (and AFAIK the
>> uring worker threads can exit before the uring instance itself is torn
>> down).
>>
>> To receive io_uring completions, there are multiple ways, but they
>> don't use a pointer from the io_uring instance to the MM to access
>> userspace memory. Instead, you can have a VMA that points to the
>> io_uring instance, created by calling mmap() on the io_uring fd; or
>> alternatively, with IORING_SETUP_NO_MMAP, you can have io_uring grab
>> references to userspace-provided pages.
>>
>> On top of that, I think it might currently be possible to use the
>> io_uring file descriptor from another task to submit work. (That would
>> probably be fairly nonsensical, but I think the kernel does not
>> currently prevent it.)
> 
> Ok, that's a wrinkle.

I'd argue the fact that you are using an mm from a different process
without grabbing a reference is the wrinkle. I just don't think it's a
problem right now, but it could be... aio is tied to the mm because of
how it does completions, potentially, and hence needs this exit_aio()
hack because of that. aio also doesn't care, because it doesn't care
about blocking - it'll happily block during issue.

> Jens, is it really FMODE_NOWAIT that controls whether we can hit this? A
> very cursory glance leads me to suspect "no", it seems like this is a
> bug if io_uring is allowed on bcachefs at all.

I just looked at bcachefs dio writes, which look to be the only case of
this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
always involved for the IO.

-- 
Jens Axboe

