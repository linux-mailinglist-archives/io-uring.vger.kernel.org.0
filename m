Return-Path: <io-uring+bounces-3978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B83D9AEABF
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AEF5B21A6D
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA31E1F4708;
	Thu, 24 Oct 2024 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKTEzxhs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9194C1F12EA
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784414; cv=none; b=Hl0a9ux17rnWQifxVysG75CQSTjfGBkH1LYKxTuvdjzfNvP+IFhYgaIy3AnujV/U/Ua+iDuVahwTUlbHiCY9s/0ZsdKu77Nns+72Y27W7MUiXaAEIFz4YWOcwuH5cdrzk+4L+iBSuXjN4DtV4hUrbkMzSDbBHBRrgC++h0Kq5Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784414; c=relaxed/simple;
	bh=kfVoKnI3hXf11d9rVRhxGg8Wd/7KCSFJabyVlCRYsOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NRJdciIgDTdiIGC+2N9uOVx3M4PNv/wticQ2IHqmUCfRD97m2DSCamgSxGfDOOyeIv2kbM4UxmZwDL75Sjn0zqxbELIONaD6ugKhCsANyI9PbIYCNgesbxIfywd4DKUWAfZP61+lU3ZBL4CTWUVJ9CoYAbNx840TlRyUMpMa+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKTEzxhs; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c9850ae22eso1375160a12.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729784410; x=1730389210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jl/iDmFcjX6zX7svEcNw733rs3fDb3rr/i6vru2XO14=;
        b=RKTEzxhsPUCRhJf4yoAIcuKcFZ9o7LYbprUd+LeWg5CJzGGorHngb2AKUZYqdYeJF4
         +zVhTBuYTOzcwDqwn0kxZqnU5PRRIZi0CAdN2W6VLVD6TOX/VK+TuuAT+uX4OGyKMvaJ
         mb6Oigyw41Yg32RBPuxJ5dctIEhMDrwZPJ3q5Ke4a5LWYncsisXsAR0xFmuHkfrLjT89
         Nd4z3wv5Ri/D/VcwxXKfSXRrHLBmv3rYtXg5bIMfrAXZo1IDXalxiZmSeL3KpXViVf/M
         IJNAmajhHdDeLHQzeJ1W0kGiL7dDtcw/2PK8XVjKXarpoxRZs2tnAKxGuW4VE15nsZG2
         1+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729784410; x=1730389210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jl/iDmFcjX6zX7svEcNw733rs3fDb3rr/i6vru2XO14=;
        b=m/IHlXZU3uAWgWbq4uasgOf/VPWkufdsYySI7TXEX3HlVrjkTI1b+/t49TdNVsrEOF
         9OLQx3dz1F/DVf7reTW/5yl02rOPQkYvVbEm1ZlgLkDR5UTmSZWEND09bnNZPyXasAz7
         9DmMPQ8umaWuR3h9o8brUlNpPPEEtwAsAm+zGEwdtlDwJjDm3rDWyUyCcB/RgUS7Js1r
         vZBgtlPy5LJ+jjjLLheaudgPY50g0AMJ4irzkrwyfJxDXr7es41W7eQr/fVIqwQ/vkBm
         ie4Hsxo0ZnlQeKn+xgKAtofnjtmlMADQfo5FK2COusTPrpQjeScTmTDPiQsDypIab9SZ
         wNgw==
X-Forwarded-Encrypted: i=1; AJvYcCWXJKducx3+lIfAG6XPOPEaaY2iYhCeCVA9IA5lv1duuB/tXNK32FRd57lTTGbJfi9msClw1BHc6A==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwd6BiFQJtyamWn8baN8gwMJtDK62636DnvuDkb/wVkuJ9e1tt
	JOdsMo3k1ytndPAEV6K9WD5ioqqtS3BGToBIsrJnBatr7o13L1OW8kpoWg==
X-Google-Smtp-Source: AGHT+IFasnoMKFuczj+lzXrxkX+pomlExHuPdQ75qu3jE8c7JAz6EeMZ/opvyk+0gJcPNORX7mUPEQ==
X-Received: by 2002:a05:6402:40ca:b0:5cb:acfa:621d with SMTP id 4fb4d7f45d1cf-5cbacfa695dmr151812a12.3.1729784410435;
        Thu, 24 Oct 2024 08:40:10 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c6b120sm5846762a12.59.2024.10.24.08.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:40:10 -0700 (PDT)
Message-ID: <db742ec9-8077-48ac-ac19-fe82732f3be7@gmail.com>
Date: Thu, 24 Oct 2024 16:40:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] io_uring/kbuf: add support for mapping type
 KBUF_MODE_BVEC
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-7-axboe@kernel.dk>
 <84c8f280-09eb-425d-a47f-69117438ae55@gmail.com>
 <673f2f66-cf18-44f1-878d-db2a6ffe335b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <673f2f66-cf18-44f1-878d-db2a6ffe335b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 16:27, Jens Axboe wrote:
> On 10/24/24 9:22 AM, Pavel Begunkov wrote:
>> On 10/23/24 17:07, Jens Axboe wrote:
>>> The provided buffer helpers always map to iovecs. Add a new mode,
>>> KBUF_MODE_BVEC, which instead maps it to a bio_vec array instead. For
>>> use with zero-copy scenarios, where the caller would want to turn it
>>> into a bio_vec anyway, and this avoids first iterating and filling out
>>> and iovec array, only for the caller to then iterate it again and turn
>>> it into a bio_vec array.
>>>
>>> Since it's now managing both iovecs and bvecs, change the naming of
>>> buf_sel_arg->nr_iovs member to nr_vecs instead.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    io_uring/kbuf.c | 170 +++++++++++++++++++++++++++++++++++++++++++-----
>>>    io_uring/kbuf.h |   9 ++-
>>>    io_uring/net.c  |  10 +--
>>>    3 files changed, 165 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>>> index 42579525c4bd..10a3a7a27e9a 100644
>>> --- a/io_uring/kbuf.c
>>> +++ b/io_uring/kbuf.c
>> ...
>>> +static struct io_mapped_ubuf *io_ubuf_from_buf(struct io_ring_ctx *ctx,
>>> +                           u64 addr, unsigned int *offset)
>>> +{
>>> +    struct io_mapped_ubuf *imu;
>>> +    u16 idx;
>>> +
>>> +    /*
>>> +     * Get registered buffer index and offset, encoded into the
>>> +     * addr base value.
>>> +     */
>>> +    idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
>>> +    addr >>= IOU_BUF_REGBUF_BITS;
>>> +    *offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);
>>
>> There are two ABI questions with that. First why not use just
>> user addresses instead of offsets? It's more consistent with
>> how everything else works. Surely it could've been offsets for
>> all registered buffers ops from the beggining, but it's not.
> 
> How would that work? You need to pass in addr + buffer index for that.

I guess it depends on the second part then, that is if you
want to preserve the layout, in which case you can just use
sqe->buf_index

> The usual approach is doing that, and then 'addr' tells you the offset
> within the buffer, eg you can just do a subtraction to get your offset.
> But you can't pass in both addr + index in a provided buffer, which is
> why it's using buf->addr to encode index + offset for that, rather than
> rely on the addr for the offset too.
> 
> The alternative obviously is to just do the 'addr' and have that be both
> index and offset, in which case you'd need to lookup the buffer. And
> that's certainly a no-go.

-- 
Pavel Begunkov

