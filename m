Return-Path: <io-uring+bounces-5099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B14CB9DAF1B
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B20D1666A5
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DADA2036E9;
	Wed, 27 Nov 2024 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tRiK3LIX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA31BC3F
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744357; cv=none; b=foA9Dlt6YRGVFaRuU14DzRqrzI2WcPYUqWabIeoobpiVGPgDSpwgj2lOR7NpWaxbzPADBCFeSxpVoQXkAS36GOpUYnD+LHekgN3Kl4a0MmtzrDhA32akmbN9hFOvL37E8iayO1EhAvuCLvIfSvvhs0anoUyFHoBb8/6aF2tJuro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744357; c=relaxed/simple;
	bh=EM/4mHDM8IGSubI+o454Y3goHzwpuRKt6oB8kvXn198=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=o/D2ZfluP6bviI96wf8oEZsZ63D6Dmd3cRkIdb79pFKdxRSELUSmd0R1k5rZRCdOTMx549lnD9KN86UZg+kIpIGRBPmApAyUWVqLRgcqmPGfSmjK7sNxZRSvj+b/N6ZQhZRDunrcNyAtQimBu1BE2DlSk0t8+1hFw3E7nwM+3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tRiK3LIX; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3ea53011deaso153233b6e.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 13:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732744354; x=1733349154; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zXBXv71yrwh/W96nQYPOr57MuN6FAQnmq0hsvo2YPvo=;
        b=tRiK3LIXTo0fmYGB3vWLZuvv7HKNorc1ebP37vtXvhVNvgaE2ob4crk4+4Q0rmC7lV
         gbVg+LRPbozSEjKIojsSGsjOXbIi4oaGvKkt0I6mvVX/WrkpwHrSYX3w/Bs7EE5aOjbX
         gFN/ltu+UuMCkCohLjyOvgQzXygvpuq8n0yKa0HkfDY4+uhQmiG5PQn5kARzJiJJrWBu
         oLDnphOobBxuhcunhiiWp95EdoOmfl+/mulL+1onWPeywb1FOKhJK8wQCO7mGEhHbbkL
         sMudeblimG027931KWr+TN32eWPB6m/T6Hsdd4/hDaDi/LZhpzLloaXaioDnJ4LQldgQ
         diyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744354; x=1733349154;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zXBXv71yrwh/W96nQYPOr57MuN6FAQnmq0hsvo2YPvo=;
        b=nsRHPcoimJHGWEkQwc6vCvHf4KwYFJibbFtslldhRtcvai7rlA1+wvgYtucwzu3QKO
         /FsZ4YoDNnXw6/cMTn5vN5LycJANHQ5BKeGeODRFNHAcyHMSqhxgeOfzStYKEJpp/nmB
         47J0oUj/7fMtX3qyKtw6UjfolJvFd+/fa8MXAy84DflaayIRmoUL+u+OZVdPhqgIBcrO
         7zEC2gd3duFfXJwKIfu9AlPWhHe08TdX01pTseuz610QEe8ZTB7exvx88jY2/v0u2k1H
         /GMiuqogGa974ng/jfLjvuTBZ0W+EckwILM0z9Hy+sLbcVaN+KorcU1/fiK8gzlJQtKG
         RG5w==
X-Forwarded-Encrypted: i=1; AJvYcCXXCEw4YWU5a+vScXVUMIU9VzvA8rCYuIR2WNGBIiH0yIkCGNu+G09bYXL/laZlCL96QC4VYSfFoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmGiDAb2n9cXMe7uzpzRHvYagx9Yngb4bduMqEpfhEVEnU1Siv
	NQBwcv0gppRRMA83d6ul3H02lKymuLLITjgko8GPhoH4nTH+HVzFXYpju4+jjCQ9UcJWU5j2Arc
	ErUs=
X-Gm-Gg: ASbGncv2TtsA++okVeBE1WuoSmGOFdrYwuaLvSkx339xAJJCiu7Bll/blSQx6BLKHEI
	1nxhV38i5oEiferqfQM/vwyStHyvD5k3mTE/8xSJqseO2O5UihraAGV8ilR4eM3IyopYRWzkCsZ
	Gif6s9vK2jHHTLNmU6nDyCyfpaVnrqYGcMn1MwSdbYKUx+0ZXLPFsOwuuUG92AtMq89mBkiG2m+
	5pRLpUGasDM4DjfN/Dfkw0kgs3NQoV2TJadY50VkqtO5Q==
X-Google-Smtp-Source: AGHT+IGeeLFCPusmOIhw+35AOSNyBrWyt/GW4UJ4w87XtENHZrksBW3r4sJQ0Nqdv4tVolmCtBkvAw==
X-Received: by 2002:a05:6830:6996:b0:718:9c7c:2b33 with SMTP id 46e09a7af769-71d65cf3b0dmr4424477a34.23.1732744353716;
        Wed, 27 Nov 2024 13:52:33 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f21a366532sm19894eaf.12.2024.11.27.13.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 13:52:33 -0800 (PST)
Message-ID: <4715a920-ae4b-41d4-97ae-0fb92b4fa024@kernel.dk>
Date: Wed, 27 Nov 2024 14:52:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jann Horn <jannh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
 <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
 <CAG48ez3BS3rRCBnEHvdLbR29u9ZEB7VeCByfMBDa57JiLUM8zQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAG48ez3BS3rRCBnEHvdLbR29u9ZEB7VeCByfMBDa57JiLUM8zQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> On Wed, Nov 27, 2024 at 10:16?PM Jens Axboe <axboe@kernel.dk> wrote:
> > On 11/27/24 2:08 PM, Kent Overstreet wrote:
> > > On Wed, Nov 27, 2024 at 09:44:21PM +0100, Jann Horn wrote:
> > >> On Wed, Nov 27, 2024 at 9:25?PM Kent Overstreet
> > >> <kent.overstreet@linux.dev> wrote:
> > >>> On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
> > >>>> On 11/27/24 9:57 AM, Jann Horn wrote:
> > >>>>> Hi!
> > >>>>>
> > >>>>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> > >>>>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> > >>>>> (without any kind of refcount increment), and used in
> > >>>>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> > >>>>> which are used to enable userspace memory access from kthread context.
> > >>>>> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> > >>>>> guarantees that the MM hasn't gone through exit_mmap() yet (normally
> > >>>>> by holding an mmget() reference).
> > >>>>>
> > >>>>> If we reach this codepath via io_uring, do we have a guarantee that
> > >>>>> the mm_struct that called bch2_direct_write() is still alive and
> > >>>>> hasn't yet gone through exit_mmap() when it is accessed from
> > >>>>> bch2_dio_write_continue()?
> > >>>>>
> > >>>>> I don't know the async direct I/O codepath particularly well, so I
> > >>>>> cc'ed the uring maintainers, who probably know this better than me.
> > >>>>
> > >>>> I _think_ this is fine as-is, even if it does look dubious and bcachefs
> > >>>> arguably should grab an mm ref for this just for safety to avoid future
> > >>>> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
> > >>>> means that on the io_uring side it cannot do non-blocking issue of
> > >>>> requests. This is slower as it always punts to an io-wq thread, which
> > >>>> shares the same mm. Hence if the request is alive, there's always a
> > >>>> thread with the same mm alive as well.
> > >>>>
> > >>>> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
> > >>>> to dig a bit deeper to verify that would always be safe and there's not
> > >>>> a of time today with a few days off in the US looming, so I'll defer
> > >>>> that to next week. It certainly would be fine with an mm ref grabbed.
> > >>>
> > >>> Wouldn't delivery of completions be tied to an address space (not a
> > >>> process) like it is for aio?
> > >>
> > >> An io_uring instance is primarily exposed to userspace as a file
> > >> descriptor, so AFAIK it is possible for the io_uring instance to live
> > >> beyond when the last mmput() happens. io_uring initially only holds an
> > >> mmgrab() reference on the MM (a comment above that explains: "This is
> > >> just grabbed for accounting purposes"), which I think is not enough to
> > >> make it stable enough for kthread_use_mm(); I think in io_uring, only
> > >> the worker threads actually keep the MM fully alive (and AFAIK the
> > >> uring worker threads can exit before the uring instance itself is torn
> > >> down).
> > >>
> > >> To receive io_uring completions, there are multiple ways, but they
> > >> don't use a pointer from the io_uring instance to the MM to access
> > >> userspace memory. Instead, you can have a VMA that points to the
> > >> io_uring instance, created by calling mmap() on the io_uring fd; or
> > >> alternatively, with IORING_SETUP_NO_MMAP, you can have io_uring grab
> > >> references to userspace-provided pages.
> > >>
> > >> On top of that, I think it might currently be possible to use the
> > >> io_uring file descriptor from another task to submit work. (That would
> > >> probably be fairly nonsensical, but I think the kernel does not
> > >> currently prevent it.)
> > >
> > > Ok, that's a wrinkle.
> >
> > I'd argue the fact that you are using an mm from a different process
> > without grabbing a reference is the wrinkle. I just don't think it's a
> > problem right now, but it could be... aio is tied to the mm because of
> > how it does completions, potentially, and hence needs this exit_aio()
> > hack because of that. aio also doesn't care, because it doesn't care
> > about blocking - it'll happily block during issue.
> >
> > > Jens, is it really FMODE_NOWAIT that controls whether we can hit this? A
> > > very cursory glance leads me to suspect "no", it seems like this is a
> > > bug if io_uring is allowed on bcachefs at all.
> >
> > I just looked at bcachefs dio writes, which look to be the only case of
> > this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
> > always involved for the IO.
>
> I guess it could be an issue if the iocb can outlive the io-wq thread?
> Like, a userspace task creates a uring instance and starts a write;
> the write will be punted to a uring worker because of missing
> FMODE_NOWAIT; then the uring worker enters io_write() and starts a
> write on a kiocb. Can this write initiated from the worker be async?
> And could the uring worker exit (for example, because the userspace
> task exited) while the kiocb is still in flight?

No, any write (or read, whatever) from an io-wq worker is always
blocking / sync. That's the main reason for them existing, to be able to
do blocking issue. And that's what they always do.

-- 
Jens Axboe


