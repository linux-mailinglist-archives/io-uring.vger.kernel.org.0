Return-Path: <io-uring+bounces-10028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 44141BE31BB
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA1D04FEFA2
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 11:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B23C3164B0;
	Thu, 16 Oct 2025 11:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCfQ0M2J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB283009F5
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 11:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760614606; cv=none; b=nCoQ7YfB6fxYi5Alj1sMkWBp14Jr+DV1eBgJvAL1i0Lby7nd+xjJqzCroUlVPCPmGI2Wsq3L1NZE+3KQll+K4iQYwe/NS3/SWtjhg2pUICa0J/K+bCSscGqdw8UTXQgGNdKATa9s+0ibUz6fcHe7UTE57grRjxAKASS+fOsXKLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760614606; c=relaxed/simple;
	bh=l6t2XhjvyRBv3SOHqWxkS6X2WXs5JXpclMhkdlVu8e0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3Kk4hlKwg/XTvArkq9IRdOExgpVFBJ8qPCPiGfcrzkmnzfZVsVkFT+srf9LnMs6bYET84QGCmWrv0jPuEDhAj1efqQ4eXAN4IhVaFSJNz62Blhv9xNq+8hLpTTJaXtGfuGnZC7TJZxaUOvRTXKN1Qrx1w1o5N2lfLnKUGBXhdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCfQ0M2J; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-421851bcb25so352462f8f.2
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 04:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760614603; x=1761219403; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lYRkRnXDkkYqdruP/GrkMZEpfl3vrmW68SVwFQLiLL0=;
        b=kCfQ0M2JRmOh/gc2LyFUdhTRhx3+ThLOIwGV8I+n/RGr2BIcqeveBeq6u02YTTh2ki
         qgjmXPoBgTCeOo/sM3vgx7k1b10PIByz3nn24Qdutpg2Salzj7+ufLbSa+FSYYacTR79
         Ol22Rh8WkD7Zxc340HyxQOx7yu6+gIUcT+JRnfEhCG6+dEFEkdlsGbgp7QvJIq7bTq48
         DLnCWQoNcs/JAhMUO99RMtlg62Qg8+5UmMEAXgI06YbIKrY0slDoXWzDA7G+wvCULAPc
         GvgeYkjjEMCspYn2uyZyBs3kLD5zB51aavvDvm8gvrQElLgfu6XIObMz3hK7PjXK1Nrk
         2Q4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760614603; x=1761219403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYRkRnXDkkYqdruP/GrkMZEpfl3vrmW68SVwFQLiLL0=;
        b=WPae1mE4BDawo0mN0HViAsf3NRRHsXX3xi8FHl5bK+pb4/9L5BBlRmZtoXSiqAdnAE
         SiFS/vLQG0J49siBnMAHpgg0V8/xN9pK0dr5INZhqKwUgLXgRUxqfIbnnaqdOufI44uH
         8a1FgKXfoAyT/Tqtxw6PDDsxEgkfD0SDP9NkP94oSjmAuzQ0+Bw4rPybAVymRR8mhaN2
         N+Vk63PpUW1uLLA5+mBeq2Lsi3fy94qPT5BrJFlbNL3UYZ4JeHrVRfCU5ngutF9KMYnF
         0C25yJIKrGNPKLbpirH+aS7rCb4+PcIvdDg4jernEKyi0WR4Yye+fPqJbplvWG40F4op
         GwGg==
X-Gm-Message-State: AOJu0Yxv9KBcqizMWHpyLAoNTnVblJNaop3m78zOxt3izPa5FePjdwrD
	HR1ZeSWSnlHpYLjlLw6WSshu1+YB9zSXutadU03Q7DX1rmLHYgAjpqs5
X-Gm-Gg: ASbGncuAYqf4d8NcqH9SAyl3hdVeRixyWcpJE+2VBWFMbhKhnVcFiE4HB7qcNzPXfXD
	LrnaFvL+2hFodw9oVM9EgjCjFv25RvIcuRoof8Xv39aR7V1S3rorl51LHskIJX2cEf2d/rOU3xz
	wy7bJLOjBSMlZ6w0yR+d0ZgVeraWldFrUbaoQxdVZg8DnwRIT2z0b5tbmsp/e7awEqdhLIuCK5M
	Ug7QBFgvqA+XG70VHQZEiuETaYkjjtM3yLY1DSEvgbVqzeeWkak4UFX5smNo9qYajKcuOTKIJjS
	FYXMPocFkKahrmi4al2PVZBf78muNc9R/OucoL50q4cHC0ZwdJNrh7vfBLbzGbNFuuQw0NGsUdF
	2Dq1URrp+3fyrd+JUPnI4Y8NcruHR9D9dFAxukZtGWaMs3vqDgM2qRYwc8uDXmxpJN6CG7sW26f
	f/B5JRQsbf0nllAtACKx9vy2sdaqD8WTj+
X-Google-Smtp-Source: AGHT+IGN5Uc/nEadhLFmRtZ+KJ0VJa6FGEgeJ7hU79c6oWsc4kI7EZ+Cl8Tlhrzw4EH4n/VO/MjwZg==
X-Received: by 2002:a05:6000:2c06:b0:426:f10e:77ca with SMTP id ffacd0b85a97d-426f10e7886mr6314973f8f.24.1760614602843;
        Thu, 16 Oct 2025 04:36:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57cd11sm34628304f8f.5.2025.10.16.04.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 04:36:42 -0700 (PDT)
Message-ID: <dd5ee82e-fb18-4126-a4a8-4fe19d2e1d65@gmail.com>
Date: Thu, 16 Oct 2025 12:38:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: introduce non-circular SQ
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
 <CADUfDZqXmmG+_9ENc6tJ4RRQ5L4_UKhWxZd3O5YGQP7tNo2iHg@mail.gmail.com>
 <fdff4e0c-0d26-4e19-8671-1f98e1c526a6@gmail.com>
 <CADUfDZqVG6sd-VChW3CxM+dgY7t7MRg3mqth038P0aYjjCsycA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZqVG6sd-VChW3CxM+dgY7t7MRg3mqth038P0aYjjCsycA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/14/25 20:46, Caleb Sander Mateos wrote:
> On Tue, Oct 14, 2025 at 12:25 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/14/25 19:37, Caleb Sander Mateos wrote:
>>> On Tue, Oct 14, 2025 at 3:57 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> ...>> + * SQEs always start at index 0 in the submission ring instead of using a
>>>> + * wrap around indexing.
>>>> + */
>>>> +#define IORING_SETUP_SQ_REWIND         (1U << 19)
>>>
>>> Keith's mixed-SQE-size patch series is already planning to use this
>>> flag: https://lore.kernel.org/io-uring/20251013180011.134131-3-kbusch@meta.com/
>>
>> I'll rebase it as ususual if that gets merged before.
>>>> -       /*
>>>> -        * Ensure any loads from the SQEs are done at this point,
>>>> -        * since once we write the new head, the application could
>>>> -        * write new data to them.
>>>> -        */
>>>> -       smp_store_release(&rings->sq.head, ctx->cached_sq_head);
>>>> +       if (ctx->flags & IORING_SETUP_SQ_REWIND) {
>>>> +               ctx->cached_sq_head = 0;
>>>
>>> The only awkward thing about this interface seems to be if
>>> io_submit_sqes() aborts early without submitting all the requested
>>> SQEs. Does userspace then need to memmove() the remaining SQEs to the
>>> start of the ring? It's certainly an unlikely case but something
>>> userspace has to handle because io_alloc_req() can fail for reasons
>>> outside its control. Seems like it might simplify the userspace side
>>> if cached_sq_head wasn't rewound if not all SQEs were consumed.
>> This kind of special rules is what usually makes interfaces a pain to
>> work with. What if you want to abort all un-submitted requests
>> instead? You can empty the queue, but then the next syscall will
>> still start from the middle. Or what if the application wants to
>> queue more requests before resubmitting previous ones? There are
>> reasons b/c the kernel will need to handle it in a less elegant way
>> than it potentially can otherwise. memmove sounds appropriate.
> 
> Maybe most convenient would be a way for userspace to pass both a head
> and a nr/tail value to the syscall instead of assuming the head is
> always 0. But it's probably difficult to modify the existing syscall

It feels fine from the API perspective, but you still need head/tail
fetching and care, additional index sanitisation (Spectre), and either
handling wrap around or extra border checks. All minor points, but
the index handling will likely be more annoying than just doing a
memmove.

> interface without an indirection to the head value, which seems to be
> a main point of this series. So always resetting to 0 and requiring
> userspace to memmove() the remaining SQEs in the rare case that
> io_uring_enter() doesn't consume all of them seems like a reasonable
> approach.

If that's what the user wants to do as there are other ways
it could be handled.

-- 
Pavel Begunkov


