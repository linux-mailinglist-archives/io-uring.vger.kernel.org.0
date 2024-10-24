Return-Path: <io-uring+bounces-3975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E229AEA60
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94B5A1C22333
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E451D5176;
	Thu, 24 Oct 2024 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EyX6qa0R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B044D1EC01D
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783682; cv=none; b=aEMxvH1xrxZpe4s5ZILWMpEPxbl0gQFALLyf90XpF7ffQ/zcmYWavlkgufUfV6LUy3ZZD7wugsgrywH+ICY+xhbVIBrd/wz8yrGuyJFnkMlfJbO3C6nLMfn7GQIzAg+k7gVzIX5xLNtlO5Vf+oYpYcEpq1856CnbZIF18H038Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783682; c=relaxed/simple;
	bh=fanvJcr2LZkrQ6Ji8ZXrJMewku/yyw63DcJ9pngxagg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XnNlC7CttxvH6+I/1gAf0VvTYjDJrs+VjZ5be9U1T0W0bIIoCFNSDrjmM1f8hZlAOg58OCZyxl8iCsWLYaTUEnX1pSsZCOaqT33A5bcWenS3Ncuy3jKwLW6i3AvX9pw/L4osbh2yv0A9Rn24WQJxHPSAJKMvjdFytJC5McRLzUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EyX6qa0R; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a39f73a2c7so4674665ab.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729783677; x=1730388477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TOgdllDNF8qU34Ihu7V7Iw+enEm3VreNmeGmUN1buqg=;
        b=EyX6qa0RE/DsX16huVerN6pLif0rATTX5bUYczCtmPTAJwsT8ty0UsguoFb36DeKJ9
         WWv7/prsvMeneH/BPFb2QUfvkreJZ5IjyHYd9dQzZXxS8hMQ3XDDucc/5iu9kUwvwqmM
         qQ2P2l/s8X/SA3Bbi19Ge5orhBm9lGqUKMs8FR/Ar5oro0xLH1i4o1+o9ErGJnY/56g1
         XD1HgxC5pOuwZrEf8/vU/p63nyu1aXhskFqcCYTEtCTX9vuB8TlzRHJQgxiJhjUQJLLi
         wsJHMuitoITPzC3dwqYnE/deBvDSMPPouwRKqPLBss8xeTxFKss1/P9VzKpc0qTYauCi
         giwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729783677; x=1730388477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOgdllDNF8qU34Ihu7V7Iw+enEm3VreNmeGmUN1buqg=;
        b=dqT13mJYYwjesRwRCwio2OZe2dS0d9A30WtweerhJPolHzL55E4JTJMs13mmw7vXaA
         9ITdoOEN90x35jmV/SNGTo+tTpyPjH2wthQ77rwAlCQ6WUnpKdAmHPbyeCZWNR1OHRKy
         5uZ/4kHvLa4lf5ht4XNcRW8r13lwdwV/l2+EJzeIEgRkbiYukhTJyi6LTpXoGZphX3ur
         R0VHdVnufPeBszAkc1BYHjWHIOHxNgQ+gZmizCUmJh/7Nw5Rl4lGqrXxNb/0FT5f1d1k
         w6iyyc8DTrl7alCQhQ7cKrkwh46UE9DGAszP/lPiCpXKDwqZoqsS+gEiRvtJ9et3ID8D
         zOEw==
X-Forwarded-Encrypted: i=1; AJvYcCW1O/C+UZjZ3ecp1lR9TP8UV7wVgwDVA9RkoD9JjPKGrlFsusyA08Or83oUTAMd1Xh2RdqtAjWVyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUQdjMX6uwbnwUT2zdM2apghgSVr/lWAmE61pimt0bJByCY7gK
	QmFytO29CIAOIjqU6eBNuf/TtWWUrCBezsDRI5hoycLPtS1VJ4Lxil9hyuI5E8KSiieNdj1qHGK
	j
X-Google-Smtp-Source: AGHT+IGzgiUg4RYGDFYmVXlEUKmF75c/WMz/ixGoG7o6xWyMmshJre2P/gyuRG+VSEMHIFLaaME5vw==
X-Received: by 2002:a05:6e02:12e2:b0:3a3:6b20:5e33 with SMTP id e9e14a558f8ab-3a4d59628b1mr75611445ab.12.1729783676662;
        Thu, 24 Oct 2024 08:27:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a52fda4sm2697890173.36.2024.10.24.08.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:27:56 -0700 (PDT)
Message-ID: <673f2f66-cf18-44f1-878d-db2a6ffe335b@kernel.dk>
Date: Thu, 24 Oct 2024 09:27:55 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <84c8f280-09eb-425d-a47f-69117438ae55@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 9:22 AM, Pavel Begunkov wrote:
> On 10/23/24 17:07, Jens Axboe wrote:
>> The provided buffer helpers always map to iovecs. Add a new mode,
>> KBUF_MODE_BVEC, which instead maps it to a bio_vec array instead. For
>> use with zero-copy scenarios, where the caller would want to turn it
>> into a bio_vec anyway, and this avoids first iterating and filling out
>> and iovec array, only for the caller to then iterate it again and turn
>> it into a bio_vec array.
>>
>> Since it's now managing both iovecs and bvecs, change the naming of
>> buf_sel_arg->nr_iovs member to nr_vecs instead.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/kbuf.c | 170 +++++++++++++++++++++++++++++++++++++++++++-----
>>   io_uring/kbuf.h |   9 ++-
>>   io_uring/net.c  |  10 +--
>>   3 files changed, 165 insertions(+), 24 deletions(-)
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 42579525c4bd..10a3a7a27e9a 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
> ...
>> +static struct io_mapped_ubuf *io_ubuf_from_buf(struct io_ring_ctx *ctx,
>> +                           u64 addr, unsigned int *offset)
>> +{
>> +    struct io_mapped_ubuf *imu;
>> +    u16 idx;
>> +
>> +    /*
>> +     * Get registered buffer index and offset, encoded into the
>> +     * addr base value.
>> +     */
>> +    idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
>> +    addr >>= IOU_BUF_REGBUF_BITS;
>> +    *offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);
> 
> There are two ABI questions with that. First why not use just
> user addresses instead of offsets? It's more consistent with
> how everything else works. Surely it could've been offsets for
> all registered buffers ops from the beggining, but it's not.

How would that work? You need to pass in addr + buffer index for that.
The usual approach is doing that, and then 'addr' tells you the offset
within the buffer, eg you can just do a subtraction to get your offset.
But you can't pass in both addr + index in a provided buffer, which is
why it's using buf->addr to encode index + offset for that, rather than
rely on the addr for the offset too.

The alternative obviously is to just do the 'addr' and have that be both
index and offset, in which case you'd need to lookup the buffer. And
that's certainly a no-go.

> And the second, we need to start getting rid of the global node
> queue, if we do, this will need to allocate an array of nodes,
> store an imu list or something similar, which will be just
> as terrible as it sounds, and then it'll need another cache,
> sprinking more checks and handling into the hot path and so
> on. That's the reason the vectored registered buffer patch
> supports juts one registered buffer to index per request, and
> I believe this one should do that as well.

Yeah agree, the global node queue is getting in the way of more
important things too, like applications using registered files and not
seeing reclaim in due time. I think that's the main issue here with the
ring wide queue, and certainly something that needs sorting sooner
rather than later.

Limiting this patch to just dealing with a single imu would be perfectly
fine I think, the intended use case here is really large registered
buffers, not little ones. And having a bundle be limited to a single
buffer would be perfectly fine. I can make that change for sure.

-- 
Jens Axboe

