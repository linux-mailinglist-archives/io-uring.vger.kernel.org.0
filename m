Return-Path: <io-uring+bounces-3982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C57C09AEB09
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 565761F23E2C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364A91F6692;
	Thu, 24 Oct 2024 15:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2/eYXZSl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77FF13CA97
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784953; cv=none; b=reL3sVf1BX+WhVfFI+qi1NcDX1gxlfM6mHvjJGoPa+HNHZPOjTPgE6trSLRLsD4anuUGEXC8kMkvy8mbhKZjDCwr0Su8CPomC7evuNDYPBxXe/v94uWBj5s/QRZnhjLsO924QkZ4xGN3uhTLCaxH3GfIHeZ6fDJuuXv8PzGcVhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784953; c=relaxed/simple;
	bh=MI8on6Dh37OfAybjgoxOggj/+4R/UPpHGYIoNS9d5tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PaBH/bI8qIIOPb3NSZpfjV+MsP/rW1fw/oHwBuVxRyMf5RWI9KMfQA7lbvdBlygX9GjqM6bPragRuUheCdJaPiGwXFWHcXYRSWZP50NOF47PTazC2EDHwj7qKNxxodoTfbKEfeSq37OGUIHRbUlbf3vI8wlh2nkqhluouLor7+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2/eYXZSl; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83ab694ebe5so42492139f.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729784949; x=1730389749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Wz1fWfkD3uJ6WAIabZCqf3tV+mDvJF5rRub3KKBlLY=;
        b=2/eYXZSlzRnXaUZAYsqe8k7gzetT++MNteZ32/Ep8ZM2TUAK/BfmZZ8dPDMWniVkGZ
         HzNxh0eMTlUO3lx87ghAKf0N9HAJSCp/QtehacIbOyEX9oXFacCX7uoHJkju+QgMTqjY
         FZHXggp19RAKqGg3GMs5o241pBwUL+tmTi4Y0XmECP3m+Ly+KoTA0yMjRtP4sJ7+xM5U
         QTiWmiKo4wKMi4ZuCAGTdk93D4Jb+h4OLBplo5OsO4emWBuBDvSQ1/Z8SpkALB5EL+Du
         NlsNypx+xL+VV9of8V1/Oefx9u1Y9g+krw33ifmdbQf2fg4Sm0wEBFeIUke7sBFnEpMl
         iypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729784949; x=1730389749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Wz1fWfkD3uJ6WAIabZCqf3tV+mDvJF5rRub3KKBlLY=;
        b=fZGRJRnftVTz3WWovq8UB3B0A/x7Kjix8wVSQw899nxbsEAQPthjnSzVvaQcPLqgL8
         +4b9qavVOeEN4uPaFp/a1DSZKpWda4zg/f3hNrNi1N7rEOG3SHpdfCjYt/NB8O67xdEc
         HVCx02RrRNE9NOpx7qFB+8/Wu+cESXb7CP8VrEgWFWELVH8qEMRG8kdhWjpBaGgYOFWw
         W6obrLv2j88/zybgSTtQ/Tc9HZvmU5vj1dsDSBXtPlOFfESkNRr+jpFmb9RXjsFRlcja
         elBHgNCT4v1vHy0Eo+vG5Z+2mLg0IKdI5SQMEeYuoLTMAy4eZdk/OMa/xKUSO0HO47O/
         Yfag==
X-Forwarded-Encrypted: i=1; AJvYcCUuwDo3GmbDuCwdIk1Ulpq5sYLJbxGADGiU+hfeDbuySGoRC9wlyDIX5yWqDl5GJY/sfNwq8UghRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzaUsCB4xPX955Wx16fEhueGffdRp0doG4+nohkrsC30P4P6b3v
	3SuSce7OzlOHekHwIbE8z8VXjUrRtphnVVI0iv3ygjFEZqIw8QxGHNtN9drhkEk=
X-Google-Smtp-Source: AGHT+IHB6ullied2HNgc/txa742Hq+nM88uha2iAez+tqJGGlTSznGFAjntlm4faTXy3Qr4o4NjkdA==
X-Received: by 2002:a05:6602:6d04:b0:82a:7181:200f with SMTP id ca18e2360f4ac-83b0403f1b7mr253491839f.9.1729784948560;
        Thu, 24 Oct 2024 08:49:08 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a52fc4fsm2745509173.22.2024.10.24.08.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:49:07 -0700 (PDT)
Message-ID: <b712943d-bb85-44c8-8907-58541d11eb6f@kernel.dk>
Date: Thu, 24 Oct 2024 09:49:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] io_uring/kbuf: add support for mapping type
 KBUF_MODE_BVEC
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-7-axboe@kernel.dk>
 <84c8f280-09eb-425d-a47f-69117438ae55@gmail.com>
 <673f2f66-cf18-44f1-878d-db2a6ffe335b@kernel.dk>
 <db742ec9-8077-48ac-ac19-fe82732f3be7@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <db742ec9-8077-48ac-ac19-fe82732f3be7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 9:40 AM, Pavel Begunkov wrote:
> On 10/24/24 16:27, Jens Axboe wrote:
>> On 10/24/24 9:22 AM, Pavel Begunkov wrote:
>>> On 10/23/24 17:07, Jens Axboe wrote:
>>>> The provided buffer helpers always map to iovecs. Add a new mode,
>>>> KBUF_MODE_BVEC, which instead maps it to a bio_vec array instead. For
>>>> use with zero-copy scenarios, where the caller would want to turn it
>>>> into a bio_vec anyway, and this avoids first iterating and filling out
>>>> and iovec array, only for the caller to then iterate it again and turn
>>>> it into a bio_vec array.
>>>>
>>>> Since it's now managing both iovecs and bvecs, change the naming of
>>>> buf_sel_arg->nr_iovs member to nr_vecs instead.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    io_uring/kbuf.c | 170 +++++++++++++++++++++++++++++++++++++++++++-----
>>>>    io_uring/kbuf.h |   9 ++-
>>>>    io_uring/net.c  |  10 +--
>>>>    3 files changed, 165 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>>>> index 42579525c4bd..10a3a7a27e9a 100644
>>>> --- a/io_uring/kbuf.c
>>>> +++ b/io_uring/kbuf.c
>>> ...
>>>> +static struct io_mapped_ubuf *io_ubuf_from_buf(struct io_ring_ctx *ctx,
>>>> +                           u64 addr, unsigned int *offset)
>>>> +{
>>>> +    struct io_mapped_ubuf *imu;
>>>> +    u16 idx;
>>>> +
>>>> +    /*
>>>> +     * Get registered buffer index and offset, encoded into the
>>>> +     * addr base value.
>>>> +     */
>>>> +    idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
>>>> +    addr >>= IOU_BUF_REGBUF_BITS;
>>>> +    *offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);
>>>
>>> There are two ABI questions with that. First why not use just
>>> user addresses instead of offsets? It's more consistent with
>>> how everything else works. Surely it could've been offsets for
>>> all registered buffers ops from the beggining, but it's not.
>>
>> How would that work? You need to pass in addr + buffer index for that.
> 
> I guess it depends on the second part then, that is if you
> want to preserve the layout, in which case you can just use
> sqe->buf_index

The whole point is to make provided AND registered buffers work
together. And you can't pass in a buffer group ID _and_ a registered
buffer index in the SQE.

And for provided buffers, furthermore the point is that the buffer
itself holds information about where to transfer to/from. Once you've
added your buffer, you don't need to further track it, when it gets
picked it has all the information on where the transfer occurs.

-- 
Jens Axboe

