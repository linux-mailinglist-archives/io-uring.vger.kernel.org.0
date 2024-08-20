Return-Path: <io-uring+bounces-2843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4AF958D11
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 19:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C36801F2473A
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 17:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF531B8E8A;
	Tue, 20 Aug 2024 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dB90G1hY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE961101C4;
	Tue, 20 Aug 2024 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724174315; cv=none; b=sNyZYGiXGdakos6z/VTC+PaeIA5Yn29WYbyJ7fotr0j33wXXimAFVfsYRL7EvRM21sA1/xW7BL7FDO58D33mGBAdjo1RuTnUaPuQ9wOpN6p+vBh12hUBT1k5tEv7LdBVMkje/AD3F6w3UGy/mADmGvVLpRNh+BcTPUicgUcBkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724174315; c=relaxed/simple;
	bh=K7lKBEb5d2DKiZ0ThXJk7j7HC0pMqiZD9ZOgRxPZK/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=quNeZ2HqbHK2aaQLHGAJQrxaODTHB6E9nF2gZmVs0I4vldKfUJSOBPQMCkX6BuY0WgvBYkaQBHUlvspAawpf8i1OqCx3BqHoXU+k/cOYIwA3UbD67mIyIFbZfD4wZnhzieRpHbKNMCKsXG4TdDIF+ZaqrCHTGNbusOD4EAXa6DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dB90G1hY; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7aa4ca9d72so745998266b.0;
        Tue, 20 Aug 2024 10:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724174312; x=1724779112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+RXbpZ+OXyPsRrZFRrCFaRajdIpPUXoh7rfHKzntLs=;
        b=dB90G1hYwKxByRmo5uMBUCMnUMOtshnIupyxb3Oqzt2WtMr/jUvjscZygLyb1NTvdt
         0Qwswlzksre+DwpX8FewdOEYyDEsmvtNjol2CG1EGj0yJS4O7AaM5+3ryeEEKCZDKVpP
         IdgSY+3CZf+a3Zf+dRqhR4B97t7Xj/FJxEDkIn9I2JFAgzAvspZtDKTymyGTDzAFzs6o
         X68XCNyFDgzh+KWAMnzkTfLBL2cdFV/MWCbDJ8WntfiaMOpw9PavhdnkWDL0csIOzIDV
         DqhsVfr9vYvtF5mP2L775uklR+sxa5WZWzjSbOJCJaFbC6mdr/z+T1jXo4B/bm4s+KMV
         06jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724174312; x=1724779112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+RXbpZ+OXyPsRrZFRrCFaRajdIpPUXoh7rfHKzntLs=;
        b=lWmqt3Z81XIZu6Og1btiPg5OLcJH1eVuFjaVVY+IQyVTJimnsPujoQjsIHprrDtCk8
         xGEra1yOimu+XEfK95yW4HdHQWsrla3rVEVtlSO4VCcxAbh6On90x4WNQyaD+s0XQMXi
         2z+noJ+A8ZILM1vxzP8hjo47eyLWcU8MjvCuk3v97rk4IRstaP4CGLiZ4/OiL7fr1o03
         9EpZwT+AyzDVhqcQ0LJYrz6da06+BmEoPs/TBlIKOM7MOluYmucMiGUgyam2yrtvCSxN
         W+bWkU0V1qb4/lt7osjT2RrRaoi4lvfkCDBHSMr5JwY6WidH7CNVSTwUEwKBEtyqzauW
         M4Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXw5mJk3dktf5NMt/b4GHCRbhEfBdEA6ve8BGeuH6vUWdeXfNS94hbXhQ7vrApOfoYdQKbkL9laK1UNTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwO2Z09FnGlG8XUpqoh1MXh+4/ZdfrHmCfwDvc6saDbO2IKXqtH
	9jBqZatpKgCYXj6qx3YTOOqjFyzFGW4IL5gRRnOUtG4cL+DzORmC
X-Google-Smtp-Source: AGHT+IH3k+sZO9tU+W74giEEa69Bw48c6Vz0E0qFyPViLeM3L11zqSo6gMiaGiLsiwO4iLdVM/Jr1w==
X-Received: by 2002:a17:907:1c08:b0:a86:672d:8436 with SMTP id a640c23a62f3a-a86672d874dmr37469166b.59.1724174311455;
        Tue, 20 Aug 2024 10:18:31 -0700 (PDT)
Received: from [192.168.42.136] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838eeeefsm787314866b.97.2024.08.20.10.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 10:18:31 -0700 (PDT)
Message-ID: <c69d1769-ae86-4659-bbda-6f7760a8e83f@gmail.com>
Date: Tue, 20 Aug 2024 18:19:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Conrad Meyer <conradmeyer@meta.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <cover.1723601133.git.asml.silence@gmail.com>
 <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
 <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
 <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
 <e06fd325-f20f-44d8-8f72-89b97cf4186f@gmail.com> <Zr6S4sHWtdlbl/dd@fedora>
 <4d016a30-d258-4d0e-b3bc-18bf0bd48e32@kernel.dk> <Zr6vIt1uSe9/xguH@fedora>
 <e9562cf8-9cf1-409e-8fbd-546d11fcba93@kernel.dk> <ZsQBMjaBrtcFLpIj@fedora>
 <d8ef3e63-1a94-45a4-974a-01324d6ce310@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d8ef3e63-1a94-45a4-974a-01324d6ce310@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 17:30, Jens Axboe wrote:
> On 8/19/24 8:36 PM, Ming Lei wrote:
>> On Mon, Aug 19, 2024 at 02:01:21PM -0600, Jens Axboe wrote:
>>> On 8/15/24 7:45 PM, Ming Lei wrote:
...
>>>> Meantime the handling has to move to io-wq for avoiding to block current
>>>> context, the interface becomes same with IORING_OP_FALLOCATE?
>>>
>>> I think the current truncate is overkill, we should be able to get by
>>> without. And no, I will not entertain an option that's "oh just punt it
>>> to io-wq".
>>
>> BTW, the truncate is added by 351499a172c0 ("block: Invalidate cache on discard v2"),
>> and block/009 serves as regression test for covering page cache
>> coherency and discard.
>>
>> Here the issue is actually related with the exclusive lock of
>> filemap_invalidate_lock(). IMO, it is reasonable to prevent page read during
>> discard for not polluting page cache. block/009 may fail too without the lock.
>>
>> It is just that concurrent discards can't be allowed any more by
>> down_write() of rw_semaphore, and block device is really capable of doing
>> that. It can be thought as one regression of 7607c44c157d ("block: Hold invalidate_lock in
>> BLKDISCARD ioctl").
>>
>> Cc Jan Kara and Shin'ichiro Kawasaki.
> 
> Honestly I just think that's nonsense. It's like mixing direct and
> buffered writes. Can you get corruption? Yes you most certainly can.
> There should be no reason why we can't run discards without providing
> page cache coherency. The sync interface attempts to do that, but that
> doesn't mean that an async (or a different sync one, if that made sense)
> should.

I don't see it as a problem either, it's a new interface, just need
to be upfront on what guarantees it provides (one more reason why
not fallocate), I'll elaborate on it in the commit message and so.

I think a reasonable thing to do is to have one rule for all write-like
operations starting from plain writes, which is currently allowing races
to happen and shift it to the user. Purely in theory we can get inventive
with likes of range lock trees, but that's unwarranted for all sorts of
reasons.

> If you do discards to the same range as you're doing buffered IO, you
> get to keep both potentially pieces. Fact is that most folks are doing
> dio for performant IO exactly because buffered writes tend to be
> horrible, and you could certainly use that with async discards and have
> the application manage it just fine.
> 
> So I really think any attempts to provide page cache synchronization for
> this is futile. And the existing sync one looks pretty abysmal, but it
> doesn't really matter as it's a sync interfce. If one were to do

It should be a pain for sync as well, you can't even spin another process
and parallelise this way.

-- 
Pavel Begunkov

