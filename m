Return-Path: <io-uring+bounces-6048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BCFA1994A
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 20:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6656D1888677
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 19:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A5A2153F3;
	Wed, 22 Jan 2025 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V1KX8OdS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B156215F78
	for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 19:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737574899; cv=none; b=rD6DliqWaB5tzhzOPZlf1gc+CaqLO78pUHuNsQ1BxPOKNnd9U8r27ZgufYI6NrnlY+MmnhXZIa8BOp0eYmn/nP1jc7qNWLY026va5lkPVOBgt8FJx3T2DNI076xHN7ELF2NyrBaMOiijXvjn6XCXRYEadHkWsyCxnMdFeekA7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737574899; c=relaxed/simple;
	bh=i1kKFvJeJAKlEvVQnFdWBz1teztkuAggDNXfEWSFvr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bx7irEbUPsthNciwfos0VDHVZ+cpOk5+oM3FFZsm9jNzhZT65S+k3N0tr0G/UYzaHyrvt0mXgPQbCrrZG2pIgmKqXlqIPf7YZ+c4XdY7bloDcmNEA/sqTLBFn5bIw7TmEvQMH9H+czeD+06YlCeLz1QN3UeRbbUv4bWaFEAOKcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V1KX8OdS; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3cf880d90bdso330855ab.3
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 11:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737574897; x=1738179697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=offrgp5lHPGm/UdkQPt2XHu3+3USXFbPLDQQXgWaF/8=;
        b=V1KX8OdSGPvXulTCUsGlB252JjmRo5ogw1Ig/MFn5ehYoysQ9eKxpmUq8XT42qAjSE
         A/x+meSuX7T7PaSI72dOP6UyDjsAKQDEz73Rg1Ns0SUpyzcjo3/28PRpNVP54G8VcR97
         e2FZfKJtLF/JLoosXAEJkrmq+fece+n16ICXdE/fBJqw13n6YWPxE7bq6eKTzjBbQVID
         uP2i4x9BqJeHZTvd7TlAgQSCB7nJgoiEvBk347QoRm9VLyvkAzWPS5hAA4hgHjszxgbg
         NsAu6l5kce4zYmsopfrpex729KYINvbxo5dt5kHP4QnGnT5UTo8jQbmDi6pnubmVX3lj
         MWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737574897; x=1738179697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=offrgp5lHPGm/UdkQPt2XHu3+3USXFbPLDQQXgWaF/8=;
        b=Jzq7Zn/BUEUOMqh12bxmdEyDEXGKVaH+DtpMPNy/Ab6ZiZbEhZ1Pk3WdLq4TNdO9pS
         usTzkoLri9/X5Fa3wC5n1fuuz/r5RXFkkP8OC+1TEJ77lp0PjA1DOfhFlcAXBJkPFBAQ
         QX12BfBYiPY3z1g8M8TCpTkgYiktWOehcuUMNGbavZ2WffTY7+iMPvt7I9xBD+joWk6m
         56M0oveVkgGNELyNzekMTRgeJ74rZkSDFU9MRtS8fB+eqaJxUyb0Ycwp7boR+tHfORdK
         NNM7/9NCiahq5KqHqlha+7j94mQHIsSc6ajI3LmEvoux1S7EYqED1iRCmEDioSamWOnO
         d5tQ==
X-Gm-Message-State: AOJu0YzwAZ+o+KHVIjxWxSPY0BTYtyFmfcF4K4TTqK/WBLfQTAFbSBes
	9SnoAArbext4+iuwPrxzkxL6IKsNdum/8b1IaOL5dYtVTpTtziSbeUtPfmEyp2ScDuEoXEJi4io
	x
X-Gm-Gg: ASbGncuLHtNkVrTpiZmH+vM2DQ/Ck9UaE10IUK1kwfEgqBCAwi1DBU6jp8dRdXzaQAP
	MdLZb39HfFAoXtioyl5zXVFG3FW4ap6RMozFZbJpjhnnvIbn8lwyvRhmnUG2WzvkMuPUU/HS9EV
	omODvtACbathpPpH0Kye94CsXU5rHfIW+KC1ZrIQ59KKWnjoHXeE7GSrgRaOXg3LQAqAMDUpRWM
	ghqMTHc6uNYZUCiXa/QTr0PrvhFktgBC9a0UQKy0cycMByc4tSVNN3S7KRnmhy/Yg==
X-Google-Smtp-Source: AGHT+IHwLrw5kowiAvzn7F1wKQqZ50cOSoepHHAYFVp7iRjolFz0AMcqd6cfGMQuEpA7t5m6z+i5WA==
X-Received: by 2002:a05:6e02:20c8:b0:3ce:9149:a8b1 with SMTP id e9e14a558f8ab-3cf743e94f7mr173517705ab.9.1737574897175;
        Wed, 22 Jan 2025 11:41:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71b44a9esm38102685ab.49.2025.01.22.11.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 11:41:36 -0800 (PST)
Message-ID: <98664621-489c-473a-9ef8-802985affb01@kernel.dk>
Date: Wed, 22 Jan 2025 12:41:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
 <CAHk-=wjuucatTzRy6b8Jh6pvHrZ9_LXbz6G-gjBYLAurzanPjQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjuucatTzRy6b8Jh6pvHrZ9_LXbz6G-gjBYLAurzanPjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/20/25 9:38 PM, Linus Torvalds wrote:
> On Sun, 19 Jan 2025 at 07:05, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Note that this will throw a merge conflict, as there's a conflict
>> between a fix that went into mainline after 6.13-rc4. The
>> io_uring/register.c one is trivial, the io_uring/uring_cmd.c requires a
>> small addition. Here's my resolution [..]
> 
> Ok, so while doing this merge, I absolutely *hate* your resolution in
> both files.

Hah, noted!

> 
> The READ_ONCE/WRITE_ONCE changes during resize operations may not
> actually matter, but the way you wrote things, it does multiple
> "READ_ONCE()" operations. Which is kind of against the whole *point*.
> 
> So in io_uring/register.c, after the loop that copies the old ring contents with
> 
>         for (i = old_head; i < tail; i++) {
> 
> I changed the
> 
>         WRITE_ONCE(n.rings->sq.head, READ_ONCE(o.rings->sq.head));
>         WRITE_ONCE(n.rings->sq.tail, READ_ONCE(o.rings->sq.tail));
> 
> to instead just *use* the original READ_ONCE() values, and thus do
> 
>         WRITE_ONCE(n.rings->sq.head, old_head);
>         WRITE_ONCE(n.rings->sq.tail, tail);
> 
> instead (and same for the 'cq' head/tail logic)
> 
> Otherwise, what's the point of reading "once", when you then read again?
> 
> Now, presumably (and hopefully) this doesn't actually matter, and
> nobody should even have access to the old ring when it gets resized,
> but it really bothered me.
> 
> And it's also entirely possible that I have now screwed up royally,
> and I actually messed up. Maybe I just misunderstood the code. But the
> old code really looked nonsensical, and I felt I couldn't leave it
> alone.

I do agree with you in that it's nonsensical to use READ_ONCE when it's
ready multiple times, even if it is for documentation purposes. Even
things like the old_head doesn't matter - yes userspace can screw itself
if it updates it after the initial read, but it won't cause any harm. At
the same time, if we've read the old_head, then we should just use that
going forward. So I think it all looks fine, thanks for cleaning that up
while merging.

> Now, the other conflict didn't look nonsensical, and I *did* leave it
> alone, but I still do hate it even if I did it as you did. Because I
> hate that pattern.
> 
> There are now three cases of 'use the init_once callback" for
> io_uring_alloc_async_data(), and all of them just clear out a couple
> of fields.
> 
> Is it really worth it?
> 
> Could we not get rid of that 'init_once' pattern completely, and
> replace it with just always using 'kzalloc()' to clear the *whole*
> allocation initially?
> 
> From what I can tell, all those things are fairly small structures.
> Doing a simple 'memset()' is *cheaper* than calling an indirect
> function pointer that then messes up the cache by setting just one or
> two fields (and has to do a read-for-ownership in order to do so).
> 
> Are there cases where the allocations are so big that doing a
> kmalloc() and then clearing one field (using an indirect function
> pointer) really is worth it?
> 
> Anyway, I left that logic alone, because my hatred for it may run hot
> and deep, but the pattern goes beyond just the conflict.

I'll take a look at this and see if we can't clean that up. The fast
path should be cached anyway.

> So please tell me why I'm wrong, and please take a look at the
> WRITE_ONCE() changes I *did* do, to see if I might be confused there
> too.

Looks good to me.

-- 
Jens Axboe

